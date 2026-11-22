const express = require('express');
const cors = require('cors');
const axios = require('axios');
const https = require('https');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

const SUPABASE_URL = 'https://supabase.co';
const SUPABASE_KEY = 'sb_publishable_M1d5TY-ak6_pSUDiJo38RQ_A46yTGct';

const sbHeaders = {
  apikey: SUPABASE_KEY,
  Authorization: `Bearer ${SUPABASE_KEY}`,
  'Content-Type': 'application/json',
  Prefer: 'return=representation'
};

async function sbSelect(table, query = '') {
  const res = await axios.get(`${SUPABASE_URL}/rest/v1/${table}${query}`, { headers: sbHeaders, timeout: 12000 });
  return res.data || [];
}

async function sbInsert(table, payload) {
  const res = await axios.post(`${SUPABASE_URL}/rest/v1/${table}`, payload, { headers: sbHeaders, timeout: 12000 });
  return res.data || [];
}

async function sbUpdate(table, query, payload) {
  const res = await axios.patch(`${SUPABASE_URL}/rest/v1/${table}${query}`, payload, { headers: sbHeaders, timeout: 12000 });
  return res.data || [];
}

function mapUserOut(u) {
  return {
    uid: u.uid,
    name: u.name,
    contact: u.contact,
    coins: Number(u.coins || 0),
    points: Number(u.points || 0),
    vipLevel: Number(u.vip_level || 0),
    hostLv: Number(u.host_lv || 1),
    wealthLv: Number(u.wealth_lv || 1),
    isAgency: Boolean(u.is_agency),
    isCoinSeller: Boolean(u.is_coin_seller),
    totalGifted: Number(u.total_gifted || 0),
    totalReceived: Number(u.total_received || 0)
  };
}

async function ensureFounder() {
  try {
    const existing = await sbSelect('users', '?contact=eq.admin%40ethiovoice.com');
    if (existing.length === 0) {
      await sbInsert('users', {
        contact: 'admin@ethiovoice.com',
        uid: '1000001',
        name: 'Mohammedsabit (Founder)',
        pass: '142730',
        coins: 500000,
        points: 250000.0,
        vip_level: 19,
        host_lv: 15,
        wealth_lv: 20,
        is_agency: true,
        is_coin_seller: true,
        total_gifted: 120000,
        total_received: 95000
      });
    }
  } catch (e) {}
}

// ==================== AUTH & SYNC ROUTES (SUPABASE) ====================

app.post('/api/auth/signup', async (req, res) => {
  try {
    const { name, contact, pass, ref } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    const cleanName = String(name || '').trim();
    const cleanPass = String(pass || '').trim();

    if (cleanContact.length < 5 || cleanPass.length < 6 || cleanName.length < 2) {
      return res.status(400).json({ ok: false, msg: 'Enter valid name, phone/email, and 6+ char password.' });
    }

    const existing = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (existing.length > 0) {
      return res.status(409).json({ ok: false, msg: 'Account already registered. Please tap Login.' });
    }

    const uid = String(100000 + Math.floor(Math.random() * 8999999));
    const inserted = await sbInsert('users', {
      contact: cleanContact,
      uid,
      name: cleanName,
      pass: cleanPass,
      coins: String(ref || '').trim().length >= 5 ? 1500 : 1000,
      points: 0.0,
      vip_level: 0,
      host_lv: 1,
      wealth_lv: 1,
      is_agency: false,
      is_coin_seller: false,
      total_gifted: 0,
      total_received: 0
    });

    return res.json({ ok: true, user: mapUserOut(inserted[0]) });
  } catch (e) {
    return res.status(500).json({ ok: false, msg: 'Database busy. Please tap Sign Up again.' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    await ensureFounder();
    const { contact, pass } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    const cleanPass = String(pass || '').trim();

    const rows = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (rows.length === 0) {
      return res.status(404).json({ ok: false, msg: 'Account not found. Please Sign Up first.' });
    }
    const user = rows[0];
    if (user.pass !== cleanPass) {
      return res.status(401).json({ ok: false, msg: 'Incorrect password. Please try again.' });
    }

    return res.json({ ok: true, user: mapUserOut(user) });
  } catch (e) {
    return res.status(500).json({ ok: false, msg: 'Server connecting. Please tap Login again.' });
  }
});

app.post('/api/auth/send-otp', async (req, res) => {
  try {
    const { contact } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    const rows = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (rows.length === 0) {
      return res.status(404).json({ ok: false, msg: 'Account not registered.' });
    }
    const code = String(100000 + Math.floor(Math.random() * 899999));
    await sbUpdate('users', `?contact=eq.${encodeURIComponent(cleanContact)}`, { otp: code });
    return res.json({ ok: true, code });
  } catch (e) {
    return res.status(500).json({ ok: false, msg: 'Could not generate code. Try again.' });
  }
});

app.post('/api/auth/verify-otp', async (req, res) => {
  try {
    const { contact, code, newPass } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    const rows = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (rows.length === 0) return res.status(404).json({ ok: false, msg: 'Account not found.' });
    const user = rows[0];
    if (String(newPass || '').trim().length < 6) {
      return res.status(400).json({ ok: false, msg: 'New password must be at least 6 characters.' });
    }
    if (user.otp && user.otp !== String(code || '').trim()) {
      return res.status(400).json({ ok: false, msg: 'Invalid verification code.' });
    }
    const updated = await sbUpdate(
      'users',
      `?contact=eq.${encodeURIComponent(cleanContact)}`,
      { pass: String(newPass).trim(), otp: null }
    );
    return res.json({ ok: true, user: mapUserOut(updated[0]) });
  } catch (e) {
    return res.status(500).json({ ok: false, msg: 'Reset failed. Try again.' });
  }
});

app.post('/api/user/sync', async (req, res) => {
  try {
    const { contact, name, coins, points, vipLevel, hostLv, wealthLv, totalGifted, totalReceived } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    if (!cleanContact) return res.json({ ok: false });

    const rows = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (rows.length > 0) {
      const cur = rows[0];
      const patch = {};
      if (name) patch.name = name;
      if (typeof coins === 'number') patch.coins = coins;
      if (typeof points === 'number') patch.points = points;
      if (typeof vipLevel === 'number') patch.vip_level = vipLevel;
      if (typeof hostLv === 'number') patch.host_lv = hostLv;
      if (typeof wealthLv === 'number') patch.wealth_lv = wealthLv;
      if (typeof totalGifted === 'number') patch.total_gifted = Number(cur.total_gifted || 0) + totalGifted;
      if (typeof totalReceived === 'number') patch.total_received = Number(cur.total_received || 0) + totalReceived;
      await sbUpdate('users', `?contact=eq.${encodeURIComponent(cleanContact)}`, patch);
    }
    return res.json({ ok: true });
  } catch (e) {
    return res.json({ ok: false });
  }
});

app.get('/api/leaderboard', async (req, res) => {
  try {
    const gifters = await sbSelect('users', '?select=uid,name,vip_level,total_gifted&order=total_gifted.desc&limit=10');
    const hosts = await sbSelect('users', '?select=uid,name,vip_level,total_received&order=total_received.desc&limit=10');
    return res.json({
      ok: true,
      topGifters: gifters.map(u => ({ uid: u.uid, name: u.name, vipLevel: u.vip_level || 0, gifted: u.total_gifted || 0 })),
      topHosts: hosts.map(u => ({ uid: u.uid, name: u.name, vipLevel: u.vip_level || 0, received: u.total_received || 0 }))
    });
  } catch (e) {
    return res.json({ ok: true, topGifters: [], topHosts: [] });
  }
});

// ==================== CASHOUT & REPORT ROUTES ====================

app.post('/api/cashout', async (req, res) => {
  try {
    const { userId, userName, method, account, points, etbAmount } = req.body || {};
    if (!userId || !method || !account || Number(points) < 100) {
      return res.status(400).json({ ok: false, msg: 'Minimum 100 points and valid account required.' });
    }
    await sbInsert('cashout_requests', {
      user_id: String(userId),
      user_name: String(userName || 'User'),
      method: String(method),
      account: String(account),
      points: Number(points),
      etb_amount: Number(etbAmount || 0),
      status: 'pending'
    });
    return res.json({ ok: true, msg: 'Cash-out request saved to server!' });
  } catch (e) {
    return res.status(500).json({ ok: false, msg: 'Could not submit cash-out.' });
  }
});

app.get('/api/admin/cashouts', async (req, res) => {
  try {
    const list = await sbSelect('cashout_requests', '?order=created_at.desc&limit=50');
    return res.json({ ok: true, requests: list });
  } catch (e) {
    return res.json({ ok: true, requests: [] });
  }
});

// ==================== AUTOMATIC PAYMENT VERIFIER ====================

const ACCOUNTS = {
  cbe: '1000273060937',
  usdtTrc20: 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE',
  usdtContract: 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t',
  ownerName: 'MOHAMMEDSABIT'
};

const MAX_RECEIPT_AGE_MS = 24 * 60 * 60 * 1000;

function ensureWithin24Hours(parsedDateMs) {
  if (!parsedDateMs || Number.isNaN(parsedDateMs)) return;
  if (Date.now() - parsedDateMs > MAX_RECEIPT_AGE_MS) {
    throw new Error('This receipt is older than 24 hours. Please enter a recent Transaction ID.');
  }
}

const insecureAgent = new https.Agent({ rejectUnauthorized: false });

async function verifyCbeReceipt(txId, expectedEtb) {
  const cleanId = txId.trim().toUpperCase();
  const fullId = cleanId.endsWith('60937') ? cleanId : `${cleanId}60937`;
  const url = `https://cbe.com.et{fullId}`;
  const res = await axios.get(url, { responseType: 'arraybuffer', timeout: 15000, httpsAgent: insecureAgent });
  const text = Buffer.from(res.data).toString('latin1').toUpperCase();
  if (!text.includes('60937') && !text.includes(ACCOUNTS.ownerName)) {
    throw new Error('This CBE receipt was not sent to account 1000273060937.');
  }
  const cbeDate = text.match(/(\d{1,2}\/\d{1,2}\/\d{4},?\s+\d{1,2}:\d{2}:\d{2}\s*(?:AM|PM)?)/);
  if (cbeDate) ensureWithin24Hours(Date.parse(cbeDate));
  return expectedEtb;
}

async function verifyUsdtTrc20Tx(txHash, expectedUsdt) {
  const cleanHash = txHash.trim();
  const url = `https://tronscanapi.com{cleanHash}`;
  const res = await axios.get(url, { timeout: 15000 });
  const data = res.data || {};
  if (!data.confirmed && data.contractRet !== 'SUCCESS') {
    throw new Error('This USDT transaction is not yet confirmed on the TRON network.');
  }
  if (data.timestamp) ensureWithin24Hours(Number(data.timestamp));
  const transfers = data.trc20TransferInfo || [];
  const validTransfer = transfers.find(
    t => t.to_address === ACCOUNTS.usdtTrc20 && t.contract_address === ACCOUNTS.usdtContract
  );
  if (!validTransfer) throw new Error(`USDT was not sent to ${ACCOUNTS.usdtTrc20} (TRC20).`);
  const decimals = Number(validTransfer.decimals || 6);
  const paidUsdt = Number(validTransfer.amount_str || 0) / Math.pow(10, decimals);
  if (expectedUsdt && paidUsdt < expectedUsdt - 0.1) {
    throw new Error(`Sent amount (${paidUsdt} USDT) is less than the package price (${expectedUsdt} USDT).`);
  }
  return paidUsdt;
}

app.get('/', (req, res) => {
  res.json({
    status: 'Voice Chat ET Supabase Cloud & Auto-Payment Server Active',
    database: 'Supabase Connected',
    autoPayments: ['CBE', 'USDT (TRC20)']
  });
});

app.post('/api/verify-payment', async (req, res) => {
  const { userId, method, transactionId, expectedEtb, expectedUsdt, requestedCoins } = req.body || {};
  if (!userId || !method || !transactionId) {
    return res.status(400).json({ success: false, message: 'Please enter User ID, Method, and Transaction ID.' });
  }

  const txKey = `${method.toLowerCase()}_${transactionId.trim()}`;
  try {
    const existingTx = await sbSelect('used_transactions', `?tx_key=eq.${encodeURIComponent(txKey)}`);
    if (existingTx.length > 0) {
      return res.status(409).json({ success: false, message: 'This Transaction ID / TxID has already been used.' });
    }

    const m = method.toLowerCase();
    let coinsToCredit = Number(requestedCoins) || 0;
    let summaryText = '';

    if (m.includes('usdt') || m.includes('trc20') || m.includes('binance')) {
      const paidUsdt = await verifyUsdtTrc20Tx(transactionId, Number(expectedUsdt) || 0);
      if (!coinsToCredit) coinsToCredit = Math.floor(paidUsdt * 10000);
      summaryText = `${paidUsdt.toFixed(2)} USDT (TRC20)`;
    } else if (m.includes('cbe')) {
      const paidEtb = await verifyCbeReceipt(transactionId, Number(expectedEtb) || 180);
      if (!coinsToCredit) coinsToCredit = Math.floor((paidEtb / 180) * 10000);
      summaryText = `${paidEtb} ETB (CBE)`;
    } else {
      return res.status(403).json({
        success: false,
        message: 'Only CBE and USDT (TRC20) are supported for automatic verification.'
      });
    }

    await sbInsert('used_transactions', {
      tx_key: txKey,
      user_id: String(userId),
      method: String(method),
      transaction_id: transactionId.trim(),
      summary_text: summaryText,
      coins_credited: coinsToCredit
    });

    return res.json({
      success: true,
      coinsAdded: coinsToCredit,
      message: `Payment (${summaryText}) verified! ${coinsToCredit} coins added.`
    });
  } catch (err) {
    return res.status(400).json({
      success: false,
      message: err.message || 'Verification failed. Check your Transaction ID.'
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Voice Chat ET Supabase Server running on port ${PORT}`));
