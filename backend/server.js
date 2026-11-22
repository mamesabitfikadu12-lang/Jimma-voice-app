const express = require('express');
const cors = require('cors');
const axios = require('axios');
const https = require('https');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

const TX_DB_FILE = path.join(__dirname, 'used_transactions.json');
const USERS_DB_FILE = path.join(__dirname, 'users_db.json');

function readJson(file, fallback) {
  try {
    if (fs.existsSync(file)) return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch (e) {}
  return fallback;
}

function writeJson(file, data) {
  try {
    fs.writeFileSync(file, JSON.stringify(data, null, 2));
  } catch (e) {}
}

function getDefaultUsers() {
  return {
    'admin@ethiovoice.com': {
      uid: '1000001',
      name: 'Mohammedsabit (Founder)',
      contact: 'admin@ethiovoice.com',
      pass: '142730',
      coins: 500000,
      points: 250000.0,
      vipLevel: 19,
      hostLv: 15,
      wealthLv: 20,
      isAgency: true,
      isCoinSeller: true,
      totalGifted: 120000,
      totalReceived: 95000
    }
  };
}

function loadUsers() {
  const users = readJson(USERS_DB_FILE, null);
  if (!users || Object.keys(users).length === 0) {
    const initial = getDefaultUsers();
    writeJson(USERS_DB_FILE, initial);
    return initial;
  }
  return users;
}

// ==================== AUTH & SYNC ROUTES ====================

app.post('/api/auth/signup', (req, res) => {
  const { name, contact, pass, ref } = req.body || {};
  const cleanContact = String(contact || '').trim().toLowerCase();
  const cleanName = String(name || '').trim();
  const cleanPass = String(pass || '').trim();

  if (cleanContact.length < 5 || cleanPass.length < 6 || cleanName.length < 2) {
    return res.status(400).json({ ok: false, msg: 'Enter valid name, phone/email, and 6+ char password.' });
  }

  const users = loadUsers();
  if (users[cleanContact]) {
    return res.status(409).json({ ok: false, msg: 'Account already registered. Please tap Login.' });
  }

  const uid = String(1000002 + Object.keys(users).length + Math.floor(Math.random() * 900));
  const newUser = {
    uid,
    name: cleanName,
    contact: cleanContact,
    pass: cleanPass,
    coins: String(ref || '').trim().length >= 5 ? 1500 : 1000,
    points: 0.0,
    vipLevel: 0,
    hostLv: 1,
    wealthLv: 1,
    isAgency: false,
    isCoinSeller: false,
    totalGifted: 0,
    totalReceived: 0
  };

  users[cleanContact] = newUser;
  writeJson(USERS_DB_FILE, users);

  const { pass: _, ...safeUser } = newUser;
  return res.json({ ok: true, user: safeUser });
});

app.post('/api/auth/login', (req, res) => {
  const { contact, pass } = req.body || {};
  const cleanContact = String(contact || '').trim().toLowerCase();
  const cleanPass = String(pass || '').trim();

  const users = loadUsers();
  const user = users[cleanContact];

  if (!user) {
    return res.status(404).json({ ok: false, msg: 'Account not found. Please Sign Up first.' });
  }
  if (user.pass !== cleanPass) {
    return res.status(401).json({ ok: false, msg: 'Incorrect password. Please try again.' });
  }

  const { pass: _, ...safeUser } = user;
  return res.json({ ok: true, user: safeUser });
});

app.post('/api/auth/send-otp', (req, res) => {
  const { contact } = req.body || {};
  const cleanContact = String(contact || '').trim().toLowerCase();
  const users = loadUsers();
  if (!users[cleanContact]) {
    return res.status(404).json({ ok: false, msg: 'Account not registered.' });
  }
  const code = String(100000 + Math.floor(Math.random() * 899999));
  users[cleanContact].otp = code;
  writeJson(USERS_DB_FILE, users);
  return res.json({ ok: true, code });
});

app.post('/api/auth/verify-otp', (req, res) => {
  const { contact, code, newPass } = req.body || {};
  const cleanContact = String(contact || '').trim().toLowerCase();
  const users = loadUsers();
  const user = users[cleanContact];
  if (!user) return res.status(404).json({ ok: false, msg: 'Account not found.' });
  if (String(newPass || '').trim().length < 6) {
    return res.status(400).json({ ok: false, msg: 'New password must be at least 6 characters.' });
  }
  if (user.otp && user.otp !== String(code || '').trim()) {
    return res.status(400).json({ ok: false, msg: 'Invalid verification code.' });
  }
  user.pass = String(newPass).trim();
  delete user.otp;
  writeJson(USERS_DB_FILE, users);

  const { pass: _, ...safeUser } = user;
  return res.json({ ok: true, user: safeUser });
});

app.post('/api/user/sync', (req, res) => {
  const { contact, name, coins, points, vipLevel, hostLv, wealthLv, totalGifted, totalReceived } = req.body || {};
  const cleanContact = String(contact || '').trim().toLowerCase();
  if (!cleanContact) return res.json({ ok: false });

  const users = loadUsers();
  if (users[cleanContact]) {
    if (name) users[cleanContact].name = name;
    if (typeof coins === 'number') users[cleanContact].coins = coins;
    if (typeof points === 'number') users[cleanContact].points = points;
    if (typeof vipLevel === 'number') users[cleanContact].vipLevel = vipLevel;
    if (typeof hostLv === 'number') users[cleanContact].hostLv = hostLv;
    if (typeof wealthLv === 'number') users[cleanContact].wealthLv = wealthLv;
    if (typeof totalGifted === 'number') users[cleanContact].totalGifted = (users[cleanContact].totalGifted || 0) + totalGifted;
    if (typeof totalReceived === 'number') users[cleanContact].totalReceived = (users[cleanContact].totalReceived || 0) + totalReceived;
    writeJson(USERS_DB_FILE, users);
  }
  return res.json({ ok: true });
});

app.get('/api/leaderboard', (req, res) => {
  const users = Object.values(loadUsers());
  const topGifters = [...users]
    .sort((a, b) => (b.totalGifted || 0) - (a.totalGifted || 0))
    .slice(0, 10)
    .map(u => ({ uid: u.uid, name: u.name, vipLevel: u.vipLevel || 0, gifted: u.totalGifted || 0 }));

  const topHosts = [...users]
    .sort((a, b) => (b.totalReceived || 0) - (a.totalReceived || 0))
    .slice(0, 10)
    .map(u => ({ uid: u.uid, name: u.name, vipLevel: u.vipLevel || 0, received: u.totalReceived || 0 }));

  return res.json({ ok: true, topGifters, topHosts });
});

// ==================== AUTOMATIC PAYMENT VERIFIER ====================

const ACCOUNTS = {
  cbe: '1000273060937',
  usdtTrc20: 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE',
  usdtContract: 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t',
  ownerName: 'MOHAMMEDSABIT'
};

const PACKAGES = [
  { coins: 1000, etb: 150, usdt: 1.0 },
  { coins: 5000, etb: 700, usdt: 5.0 },
  { coins: 10000, etb: 1350, usdt: 10.0 },
  { coins: 50000, etb: 6500, usdt: 45.0 },
  { coins: 100000, etb: 12500, usdt: 85.0 },
  { coins: 500000, etb: 60000, usdt: 400.0 }
];

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
    status: 'Voice Chat ET Auth & Automatic Payment Server Active',
    auth: ['signup', 'login', 'otp', 'sync', 'leaderboard'],
    autoPayments: ['CBE', 'USDT (TRC20)']
  });
});

app.post('/api/verify-payment', async (req, res) => {
  const { userId, method, transactionId, expectedEtb, expectedUsdt, requestedCoins } = req.body || {};
  if (!userId || !method || !transactionId) {
    return res.status(400).json({ success: false, message: 'Please enter User ID, Method, and Transaction ID.' });
  }

  const txKey = `${method.toLowerCase()}_${transactionId.trim()}`;
  const usedTx = readJson(TX_DB_FILE, {});
  if (usedTx[txKey]) {
    return res.status(409).json({ success: false, message: 'This Transaction ID / TxID has already been used.' });
  }

  try {
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

    usedTx[txKey] = {
      userId,
      method,
      transactionId: transactionId.trim(),
      summaryText,
      coinsCredited: coinsToCredit,
      timestamp: new Date().toISOString()
    };
    writeJson(TX_DB_FILE, usedTx);

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
app.listen(PORT, () => console.log(`Voice Chat ET Full Server running on port ${PORT}`));
