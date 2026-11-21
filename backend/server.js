const express = require('express');
const cors = require('cors');
const axios = require('axios');
const https = require('https');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

const DB_FILE = path.join(__dirname, 'used_transactions.json');

function loadUsedTx() {
  try {
    if (fs.existsSync(DB_FILE)) {
      return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
    }
  } catch (e) {}
  return {};
}

function saveUsedTx(data) {
  try {
    fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
  } catch (e) {}
}

const ACCOUNTS = {
  telebirr: '0919108311',
  cbe: '1000273060937',
  awash: '014251157710000',
  dashen: '2952945930711',
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
  const age = Date.now() - parsedDateMs;
  if (age > MAX_RECEIPT_AGE_MS) {
    throw new Error('This receipt is older than 24 hours. Please enter a recent Transaction ID.');
  }
}

function calculateCoinsFromEtb(paidEtb) {
  const matched = PACKAGES.find(p => Math.abs(paidEtb - p.etb) <= 5);
  if (matched) return matched.coins;
  return Math.floor((paidEtb / 150) * 1000);
}

function calculateCoinsFromUsdt(paidUsdt) {
  const matched = PACKAGES.find(p => Math.abs(paidUsdt - p.usdt) <= 0.15);
  if (matched) return matched.coins;
  return Math.floor(paidUsdt * 1000);
}

const insecureAgent = new https.Agent({ rejectUnauthorized: false });

async function verifyTelebirrReceipt(txId, expectedEtb) {
  const cleanId = txId.trim().toUpperCase();
  const url = `https://ethiotelecom.et{cleanId}`;
  const res = await axios.get(url, { timeout: 15000, httpsAgent: insecureAgent });
  const html = String(res.data || '');

  if (!html.includes('919108311') && !html.toUpperCase().includes(ACCOUNTS.ownerName)) {
    throw new Error('This receipt was not sent to Telebirr +251919108311.');
  }

  const dateMatch =
    html.match(/(\d{2}-\d{2}-\d{4}\s+\d{2}:\d{2}:\d{2})/) ||
    html.match(/(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})/);
  if (dateMatch) {
    const rawDate = dateMatch[1];
    let ts = Date.parse(rawDate);
    if (Number.isNaN(ts) && /^\d{2}-\d{2}-\d{4}/.test(rawDate)) {
      const [dPart, tPart] = rawDate.split(/\s+/);
      const [dd, mm, yyyy] = dPart.split('-');
      ts = Date.parse(`${yyyy}-${mm}-${dd}T${tPart}+03:00`);
    }
    ensureWithin24Hours(ts);
  }

  const amountMatch =
    html.match(/([0-9,]+\.[0-9]{2})\s*Birr/i) ||
    html.match(/Settled Amount[\s\S]{0,120}?([0-9,]+\.[0-9]{2})/i);
  const paidAmount = amountMatch ? parseFloat(amountMatch[1].replace(/,/g, '')) : expectedEtb;

  if (paidAmount < expectedEtb - 2) {
    throw new Error(`Paid amount (${paidAmount} ETB) is less than the package price (${expectedEtb} ETB).`);
  }
  return paidAmount;
}

async function verifyCbeReceipt(txId, expectedEtb) {
  const cleanId = txId.trim().toUpperCase();
  const fullId = cleanId.endsWith('60937') ? cleanId : `${cleanId}60937`;
  const url = `https://cbe.com.et{fullId}`;
  const res = await axios.get(url, {
    responseType: 'arraybuffer',
    timeout: 15000,
    httpsAgent: insecureAgent
  });

  const text = Buffer.from(res.data).toString('latin1').toUpperCase();
  if (!text.includes('60937') && !text.includes(ACCOUNTS.ownerName)) {
    throw new Error('This CBE receipt was not sent to account 1000273060937.');
  }

  const cbeDate = text.match(/(\d{1,2}\/\d{1,2}\/\d{4},?\s+\d{1,2}:\d{2}:\d{2}\s*(?:AM|PM)?)/);
  if (cbeDate) {
    ensureWithin24Hours(Date.parse(cbeDate[1]));
  }

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

  if (data.timestamp) {
    ensureWithin24Hours(Number(data.timestamp));
  }

  const transfers = data.trc20TransferInfo || [];
  const validTransfer = transfers.find(
    t =>
      t.to_address === ACCOUNTS.usdtTrc20 &&
      t.contract_address === ACCOUNTS.usdtContract
  );

  if (!validTransfer) {
    throw new Error(`USDT was not sent to ${ACCOUNTS.usdtTrc20} (TRC20).`);
  }

  const decimals = Number(validTransfer.decimals || 6);
  const paidUsdt = Number(validTransfer.amount_str || 0) / Math.pow(10, decimals);

  if (expectedUsdt && paidUsdt < expectedUsdt - 0.1) {
    throw new Error(`Sent amount (${paidUsdt} USDT) is less than the package price (${expectedUsdt} USDT).`);
  }

  return paidUsdt;
}

app.get('/', (req, res) => {
  res.json({
    status: 'Voice Chat ET Secure Automatic Verifier Active',
    autoMethods: ['Telebirr', 'CBE', 'USDT (TRC20)'],
    manualApprovalMethods: ['Awash Bank', 'Dashen Bank']
  });
});

app.post('/api/verify-payment', async (req, res) => {
  const { userId, method, transactionId, expectedEtb, expectedUsdt, requestedCoins } = req.body || {};

  if (!userId || !method || !transactionId) {
    return res.status(400).json({
      success: false,
      message: 'Please enter User ID, Payment Method, and Transaction ID (TxID).'
    });
  }

  const txKey = `${method.toLowerCase()}_${transactionId.trim()}`;
  const usedTx = loadUsedTx();

  if (usedTx[txKey]) {
    return res.status(409).json({
      success: false,
      message: 'This Transaction ID / TxID has already been used. Please enter a new receipt.'
    });
  }

  try {
    const m = method.toLowerCase();
    let coinsToCredit = Number(requestedCoins) || 0;
    let summaryText = '';

    if (m.includes('usdt') || m.includes('trc20') || m.includes('binance')) {
      const paidUsdt = await verifyUsdtTrc20Tx(transactionId, Number(expectedUsdt) || 0);
      if (!coinsToCredit) coinsToCredit = calculateCoinsFromUsdt(paidUsdt);
      summaryText = `${paidUsdt.toFixed(2)} USDT (TRC20)`;
    } else if (m.includes('telebirr')) {
      const paidEtb = await verifyTelebirrReceipt(transactionId, Number(expectedEtb) || 150);
      if (!coinsToCredit) coinsToCredit = calculateCoinsFromEtb(paidEtb);
      summaryText = `${paidEtb} ETB (Telebirr)`;
    } else if (m.includes('cbe')) {
      const paidEtb = await verifyCbeReceipt(transactionId, Number(expectedEtb) || 150);
      if (!coinsToCredit) coinsToCredit = calculateCoinsFromEtb(paidEtb);
      summaryText = `${paidEtb} ETB (CBE)`;
    } else if (m.includes('awash') || m.includes('dashen')) {
      return res.status(403).json({
        success: false,
        requiresManualApproval: true,
        message: 'Awash and Dashen Bank payments require Admin approval. Please send your receipt on Telegram (+251919108311).'
      });
    } else {
      return res.status(400).json({ success: false, message: 'Please select a valid payment method.' });
    }

    usedTx[txKey] = {
      userId,
      method,
      transactionId: transactionId.trim(),
      summaryText,
      coinsCredited: coinsToCredit,
      timestamp: new Date().toISOString()
    };
    saveUsedTx(usedTx);

    return res.json({
      success: true,
      coinsAdded: coinsToCredit,
      message: `Payment (${summaryText}) verified! ${coinsToCredit} coins have been added to your account.`
    });
  } catch (err) {
    return res.status(400).json({
      success: false,
      message: err.message || 'Verification failed. Please check your Transaction ID / TxID and try again.'
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Voice Chat ET Secure Verifier running on port ${PORT}`));
