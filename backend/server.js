const express = require('express');
const cors = require('cors');
const axios = require('axios');
const https = require('https');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

const insecureAgent = new https.Agent({ rejectUnauthorized: false });

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://supabase.co';
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY || 'sb_publishable_b855lS0q_K3Xry_3w7b1-w_4yJ_yS0a';

const ACCOUNTS = {
  cbe: '1000273060937',
  ownerName: 'MOHAMMEDSABIT',
  usdtTrc20: 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE',
  usdtContract: 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t'
};

const FOUNDER_EMAIL = 'admin@ethiovoice.com';
const FOUNDER_PASS = '142730';
const otpStore = new Map();

function sbHeaders() {
  return {
    apikey: SUPABASE_KEY,
    Authorization: `Bearer ${SUPABASE_KEY}`,
    'Content-Type': 'application/json',
    Prefer: 'return=representation'
  };
}

async function sbSelect(table, query = '') {
  const url = `${SUPABASE_URL}/rest/v1/${table}${query}`;
  const res = await axios.get(url, { headers: sbHeaders(), timeout: 12000 });
  return Array.isArray(res.data) ? res.data : [];
}

async function sbInsert(table, row) {
  const url = `${SUPABASE_URL}/rest/v1/${table}`;
  const res = await axios.post(url, row, { headers: sbHeaders(), timeout: 12000 });
  return Array.isArray(res.data) ? res.data : [res.data];
}

async function sbUpdate(table, query, patch) {
  const url = `${SUPABASE_URL}/rest/v1/${table}${query}`;
  const res = await axios.patch(url, patch, { headers: sbHeaders(), timeout: 12000 });
  return Array.isArray(res.data) ? res.data : [res.data];
}

function mapUserOut(u) {
  return {
    uid: u.uid,
    name: u.name,
    contact: u.contact,
    coins: Number(u.coins || 0),
    points: Number(u.points || 0),
    vipLevel: Number(u.vip_level || 0)
  };
}

async function ensureFounderAccount() {
  try {
    const existing = await sbSelect('users', `?contact=eq.${encodeURIComponent(FOUNDER_EMAIL)}`);
    if (existing.length === 0) {
      await sbInsert('users', {
        uid: '100001',
        name: 'Mohammedsabit (Founder)',
        contact: FOUNDER_EMAIL,
        pass: FOUNDER_PASS,
        coins: 500000,
        points: 1000,
        vip_level: 19
      });
    }
  } catch (e) {
    console.error('Founder init warning:', e.message);
  }
}

app.post('/api/auth/signup', async (req, res) => {
  try {
    await ensureFounderAccount();
    const { name, contact, password } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    const cleanPass = String(password || '').trim();
    const cleanName = String(name || '').trim() || `User_${Math.floor(1000 + Math.random() * 9000)}`;

    if (!cleanContact || cleanPass.length < 6) {
      return res.status(400).json({ ok: false, msg: 'Enter valid phone/email and at least 6-character password.' });
    }
    const existing = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (existing.length > 0) {
      return res.status(409).json({ ok: false, msg: 'Account already exists. Please use Login.' });
    }

    const uid = String(Math.floor(100000 + Math.random() * 899999));
    const inserted = await sbInsert('users', {
      uid,
      name: cleanName,
      contact: cleanContact,
      pass: cleanPass,
      coins: 5000,
      points: 0,
      vip_level: 0
    });
    return res.json({ ok: true, user: mapUserOut(inserted[0]) });
  } catch (err) {
    return res.status(500).json({ ok: false, msg: 'Database error during Sign Up. Try again.' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    await ensureFounderAccount();
    const { contact, password } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    const cleanPass = String(password || '').trim();

    if (cleanContact === FOUNDER_EMAIL && cleanPass === FOUNDER_PASS) {
      const fRows = await sbSelect('users', `?contact=eq.${encodeURIComponent(FOUNDER_EMAIL)}`);
      if (fRows.length > 0) {
        return res.json({ ok: true, user: mapUserOut(fRows[0]) });
      }
      return res.json({
        ok: true,
        user: { uid: '100001', name: 'Mohammedsabit (Founder)', contact: FOUNDER_EMAIL, coins: 500000, points: 1000, vipLevel: 19 }
      });
    }

    const rows = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (rows.length === 0) {
      return res.status(404).json({ ok: false, msg: 'Account not found. Please Sign Up first.' });
    }
    const user = rows[0];
    if (user.pass !== cleanPass) {
      return res.status(401).json({ ok: false, msg: 'Incorrect password. Use Forgot Password if needed.' });
    }
    return res.json({ ok: true, user: mapUserOut(user) });
  } catch (err) {
    return res.status(500).json({ ok: false, msg: 'Server connection error. Please try again.' });
  }
});

app.post('/api/auth/request-otp', async (req, res) => {
  const { contact } = req.body || {};
  const cleanContact = String(contact || '').trim().toLowerCase();
  if (!cleanContact) return res.status(400).json({ ok: false, msg: 'Enter your registered phone or email.' });

  const code = String(Math.floor(100000 + Math.random() * 900000));
  otpStore.set(cleanContact, { code, expires: Date.now() + 10 * 60 * 1000 });
  return res.json({
    ok: true,
    demoOtp: code,
    msg: `Verification OTP code generated: ${code}`
  });
});

app.post('/api/auth/verify-otp', async (req, res) => {
  try {
    const { contact, otp, newPassword } = req.body || {};
    const cleanContact = String(contact || '').trim().toLowerCase();
    const record = otpStore.get(cleanContact);
    if (!record || record.code !== String(otp || '').trim() || Date.now() > record.expires) {
      return res.status(400).json({ ok: false, msg: 'Invalid or expired OTP code.' });
    }
    otpStore.delete(cleanContact);

    const rows = await sbSelect('users', `?contact=eq.${encodeURIComponent(cleanContact)}`);
    if (rows.length === 0) {
      return res.status(404).json({ ok: false, msg: 'No account found with this phone/email.' });
    }
    const user = rows[0];
    const nextPass = (newPassword && String(newPassword).trim().length >= 6) ? String(newPassword).trim() : user.pass;
    const updated = await sbUpdate('users', `?uid=eq.${encodeURIComponent(user.uid)}`, { pass: nextPass });
    return res.json({ ok: true, user: mapUserOut(updated[0]) });
  } catch (err) {
    return res.status(500).json({ ok: false, msg: 'Could not verify OTP. Try again.' });
  }
});
app.post('/api/user/sync', async (req, res) => {
  try {
    const { uid, coins, points, vipLevel } = req.body || {};
    if (!uid) return res.status(400).json({ ok: false, msg: 'Missing UID' });
    const rows = await sbSelect('users', `?uid=eq.${encodeURIComponent(String(uid))}`);
    if (rows.length === 0) return res.status(404).json({ ok: false, msg: 'User not found' });

    const patch = {};
    if (typeof coins === 'number') patch.coins = Math.max(0, Math.floor(coins));
    if (typeof points === 'number') patch.points = Math.max(0, Number(points));
    if (typeof vipLevel === 'number') patch.vip_level = Math.max(0, Math.floor(vipLevel));
    patch.updated_at = new Date().toISOString();

    const updated = await sbUpdate('users', `?uid=eq.${encodeURIComponent(String(uid))}`, patch);
    return res.json({ ok: true, user: mapUserOut(updated) });
  } catch (err) {
    return res.status(500).json({ ok: false, msg: 'Sync error' });
  }
});

app.get('/api/user/:uid', async (req, res) => {
  try {
    const rows = await sbSelect('users', `?uid=eq.${encodeURIComponent(String(req.params.uid))}`);
    if (rows.length === 0) return res.status(404).json({ ok: false, msg: 'User not found' });
    return res.json({ ok: true, user: mapUserOut(rows) });
  } catch (err) {
    return res.status(500).json({ ok: false, msg: 'Fetch error' });
  }
});

async function verifyCbeTransaction(txRef, expectedEtb) {
  const cleanRef = String(txRef || '').trim().toUpperCase();
  if (!cleanRef.startsWith('FT') || cleanRef.length < 10) {
    return { valid: false, reason: 'Invalid CBE Reference format. Must start with FT (e.g., FT26085XXXXX).' };
  }
  const suffix = ACCOUNTS.cbe.slice(-8);
  const urls = [
    `https://cbe.com.et{cleanRef}${suffix}`,
    `https://cbe.com.et{cleanRef}${suffix}`
  ];
  for (const url of urls) {
    try {
      const response = await axios.get(url, { httpsAgent: insecureAgent, timeout: 14000 });
      const html = String(response.data || '');
      const hasOwner = html.toUpperCase().includes(ACCOUNTS.ownerName) || html.includes(ACCOUNTS.cbe);
      const amountMatch = html.match(/([0-9,]+(?:\.[0-9]{1,2})?)\s*ETB/i);
      const paidEtb = amountMatch ? parseFloat(amountMatch.replace(/,/g, '')) : expectedEtb;
      if (hasOwner && paidEtb + 1 >= expectedEtb) {
        return { valid: true, paidAmount: paidEtb, currency: 'ETB' };
      }
      if (hasOwner && paidEtb + 1 < expectedEtb) {
        return { valid: false, reason: `Paid ${paidEtb} ETB is less than required ${expectedEtb} ETB.` };
      }
    } catch (_) {}
  }
  return { valid: false, reason: 'CBE receipt not confirmed yet. Wait 1 minute and check your FT reference.' };
}

async function verifyUsdtTrc20Transaction(txHash, expectedUsdt) {
  const cleanHash = String(txHash || '').trim();
  if (cleanHash.length < 30) {
    return { valid: false, reason: 'Invalid TRON Transaction Hash (TxID).' };
  }
  try {
    const url = `https://tronscanapi.com{cleanHash}`;
    const response = await axios.get(url, { timeout: 14000 });
    const data = response.data || {};
    if (!data.confirmed) {
      return { valid: false, reason: 'Transaction is still confirming on TRON blockchain. Wait 30 seconds.' };
    }
    const transfers = data.trc20TransferInfo || [];
    const match = transfers.find(
      (t) => t.to_address === ACCOUNTS.usdtTrc20 && t.contract_address === ACCOUNTS.usdtContract
    );
    if (!match) {
      return { valid: false, reason: 'Receiver address does not match official USDT TRC20 wallet.' };
    }
    const paidUsdt = Number(match.amount_str || 0) / 1e6;
    if (paidUsdt + 0.05 < expectedUsdt) {
      return { valid: false, reason: `Paid ${paidUsdt} USDT is less than required ${expectedUsdt} USDT.` };
    }
    return { valid: true, paidAmount: paidUsdt, currency: 'USDT' };
  } catch (err) {
    return { valid: false, reason: 'Could not reach TRON network. Please retry in 15 seconds.' };
  }
}

app.post('/api/verify-payment', async (req, res) => {
  try {
    const { method, reference, expectedAmount, coins, userId, userName } = req.body || {};
    const cleanRef = String(reference || '').trim().toUpperCase();
    if (!cleanRef) {
      return res.status(400).json({ ok: false, msg: 'Transaction Reference / Hash is required.' });
    }

    const used = await sbSelect('used_transactions', `?tx_ref=eq.${encodeURIComponent(cleanRef)}`);
    if (used.length > 0) {
      return res.status(409).json({ ok: false, msg: 'This Transaction ID has already been used!' });
    }

    const result = method === 'CBE'
      ? await verifyCbeTransaction(cleanRef, Number(expectedAmount || 0))
      : await verifyUsdtTrc20Transaction(cleanRef, Number(expectedAmount || 0));

    if (!result.valid) {
      return res.status(400).json({ ok: false, msg: result.reason });
    }

    const coinReward = Number(coins || 0);
    await sbInsert('used_transactions', {
      tx_ref: cleanRef,
      method,
      user_id: String(userId || 'Guest'),
      user_name: String(userName || 'User'),
      paid_amount: result.paidAmount,
      currency: result.currency,
      coins_credited: coinReward
    });

    let updatedUser = null;
    if (userId) {
      const uRows = await sbSelect('users', `?uid=eq.${encodeURIComponent(String(userId))}`);
      if (uRows.length > 0) {
        const nextCoins = Number(uRows.coins || 0) + coinReward;
        const uPatch = await sbUpdate('users', `?uid=eq.${encodeURIComponent(String(userId))}`, { coins: nextCoins });
        updatedUser = mapUserOut(uPatch);
      }
    }

    return res.json({
      ok: true,
      msg: `Verified ${result.paidAmount} ${result.currency}! ${coinReward} Coins credited.`,
      coinsCredited: coinReward,
      user: updatedUser
    });
  } catch (err) {
    return res.status(500).json({ ok: false, msg: 'Payment verification error. Please retry.' });
  }
});

app.post('/api/cashout', async (req, res) => {
  try {
    const { userId, userName, method, account, points, etbAmount } = req.body || {};
    const pts = Number(points || 0);
    if (!userId || pts < 100 || !account) {
      return res.status(400).json({ ok: false, msg: 'Minimum 100 points and valid account required.' });
    }
    const uRows = await sbSelect('users', `?uid=eq.${encodeURIComponent(String(userId))}`);
    if (uRows.length > 0) {
      const currentPts = Number(uRows.points || 0);
      if (currentPts < pts) {
        return res.status(400).json({ ok: false, msg: 'Insufficient points balance.' });
      }
      await sbUpdate('users', `?uid=eq.${encodeURIComponent(String(userId))}`, { points: currentPts - pts });
    }
    await sbInsert('cashout_requests', {
      user_id: String(userId),
      user_name: String(userName || 'User'),
      method: String(method || 'CBE'),
      account: String(account),
      points: pts,
      etb_amount: Number(etbAmount || pts * 10),
      status: 'pending'
    });
    return res.json({ ok: true, msg: 'Withdrawal request saved to cloud! Admin will process within 24h.' });
  } catch (err) {
    return res.status(500).json({ ok: false, msg: 'Could not submit withdrawal request.' });
  }
});

app.post('/api/support', async (req, res) => {
  try {
    const { userId, userName, category, message, screenshotBase64 } = req.body || {};
    if (!message && !screenshotBase64) {
      return res.status(400).json({ ok: false, msg: 'Please write a message or attach a screenshot.' });
    }
    await sbInsert('support_tickets', {
      user_id: String(userId || 'Guest'),
      user_name: String(userName || 'User'),
      category: String(category || 'Payment / Coins'),
      message: String(message || 'Payment screenshot attached'),
      screenshot_base64: screenshotBase64 ? String(screenshotBase64) : null,
      status: 'open'
    });
    return res.json({ ok: true, msg: 'Ticket & screenshot sent to Admin support!' });
  } catch (e) {
    return res.status(500).json({ ok: false, msg: 'Could not send support message. Try again.' });
  }
});

app.get('/api/support/:userId', async (req, res) => {
  try {
    const uid = encodeURIComponent(req.params.userId);
    const tickets = await sbSelect('support_tickets', `?user_id=eq.${uid}&order=created_at.asc&limit=50`);
    return res.json({ ok: true, tickets });
  } catch (e) {
    return res.json({ ok: true, tickets: [] });
  }
});

app.get('/api/admin/support', async (req, res) => {
  try {
    const tickets = await sbSelect('support_tickets', '?order=created_at.desc&limit=50');
    return res.json({ ok: true, tickets });
  } catch (e) {
    return res.json({ ok: true, tickets: [] });
  }
});

app.post('/api/admin/support/reply', async (req, res) => {
  try {
    const { id, reply } = req.body || {};
    if (!id || !reply) return res.status(400).json({ ok: false });
    await sbUpdate('support_tickets', `?id=eq.${Number(id)}`, { admin_reply: String(reply), status: 'answered' });
    return res.json({ ok: true });
  } catch (e) {
    return res.status(500).json({ ok: false });
  }
});

app.get('/', (req, res) => {
  res.json({
    status: 'Voice Chat ET Supabase Cloud & Auto-Payment Server Active',
    database: 'Supabase Connected',
    accounts: { cbe: ACCOUNTS.cbe, owner: ACCOUNTS.ownerName, usdtTrc20: ACCOUNTS.usdtTrc20 }
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Voice Chat ET Cloud Backend running on port ${PORT}`));
