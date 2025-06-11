require('dotenv').config();

const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET;

// Load client configurations from clients.json
const clientsPath = path.join(__dirname, 'clients.json');
const clients = JSON.parse(fs.readFileSync(clientsPath, 'utf8'));

// Utility function to base64url encode a string (for the JWKS endpoint)
function base64UrlEncode(str) {
  return Buffer.from(str)
    .toString('base64')
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_');
}

// Use urlencoded parser for application/x-www-form-urlencoded bodies
app.use(bodyParser.urlencoded({ extended: true }));

// Well-Known OpenID Connect Configuration Endpoint
app.get('/.well-known/openid-configuration', (req, res) => {
  const issuer = `http://localhost:${port}`;
  const config = {
    issuer: issuer,
    token_endpoint: `${issuer}/token`,
    jwks_uri: `${issuer}/.well-known/jwks.json`
    // You can add more settings as needed.
  };
  res.json(config);
});

// JWKS Endpoint returns our symmetric key in JWK format.
app.get('/.well-known/jwks.json', (req, res) => {
  const jwk = {
    kty: "oct",
    alg: "HS256",
    use: "sig",
    kid: "1",  // Static key ID; in production consider a more robust approach.
    k: base64UrlEncode(JWT_SECRET)
  };
  res.json({ keys: [jwk] });
});

// Token Endpoint supporting client_credentials flow.
app.post('/token', (req, res) => {
  const { grant_type, client_id, client_secret, scope } = req.body;

  // Only support client_credentials grant type.
  if (grant_type !== 'client_credentials') {
    return res.status(400).json({ error: 'unsupported_grant_type' });
  }

  // Find client configuration based on the provided client_id.
  const clientConfig = clients.find(c => c.client_id === client_id);

  // If no matching client or secret mismatch, return error.
  if (!clientConfig || clientConfig.client_secret !== client_secret) {
    return res.status(401).json({ error: 'invalid_client' });
  }

  // Build a JWT payload with any preset claims from the client's configuration.
  // You can also add additional global claims here if needed.
  const payload = {
    sub: client_id,
    ...clientConfig.claims
  };

  // Create a JWT token.
  const token = jwt.sign(payload, JWT_SECRET, {
    expiresIn: '1h',
    issuer: `http://localhost:${port}`
  });

  res.json({
    access_token: token,
    token_type: 'Bearer',
    expires_in: 3600
  });
});

// Launch the server.
app.listen(port, () => {
  console.log(`OAuth Identity Provider running at http://localhost:${port}`);
});
