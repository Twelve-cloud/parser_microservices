# parser_microservices

# Security Status

---

Due to **PostgreSQL** and **Redpanda** not supporting **EdDSA (ED448)**, the system uses **RSA-based** certificates with the following configuration:

| Parameter           | Value                          |
|---------------------|--------------------------------|
| **Key Algorithm**   | RSA                            |
| **Key Size**        | 2048 bits                      |
| **Signature Scheme**| SHA-256 with RSA Encryption    |

---

### 🌐 UI HTTPS Protocol
| Service        | Status | Notes          |
|----------------|--------|----------------|
| Redis Insight  | ✅ OK  | Enabled        |
| Mongo Express  | ✅ OK  | Enabled        |
| pgAdmin        | ✅ OK  | Enabled        |
| Redpanda       | ✅ OK  | Enabled        |

All **UI** components utilize certificates signed by intermediate CA.

---

### 🔐 TLS 1.3 Support
| Service    | Status | Notes          |
|------------|--------|----------------|
| Redis      | ✅ OK  | Enabled        |
| MongoDB    | ✅ OK  | Enabled        |
| PostgreSQL | ✅ OK  | Enabled        |
| Kafka      | ✅ OK  | Enabled        |

All **system** components enforce TLS 1.3.

---

### 🛡️ TLS 1.3 Ciphersuites
| Service    | Status           | Notes            |
|------------|------------------|------------------|
| Redis      | ✅ OK            | Enabled          |
| MongoDB    | ✅ OK            | Enabled          |
| PostgreSQL | ❌ Not Supported | TLS 1.2 ciphers  |
| Kafka      | ✅ OK            | Enabled          |

All **system** components except for **PostgreSQL** enforce TLS 1.3 ciphersuites.
**PostgreSQL** utilizes TLS 1.2 ciphersuites due to compatibility requirements with TLS 1.3 implementation.

---

### 🔒 Mutual TLS (mTLS) Support
| Service    | Status | Notes          |
|------------|--------|----------------|
| Redis      | ✅ OK  | Enabled        |
| MongoDB    | ✅ OK  | Enabled        |
| PostgreSQL | ✅ OK  | Enabled        |
| Kafka      | ✅ OK  | Enabled        |

**All** components implement strict mTLS with comprehensive certificate validation.
**Servers** validate client certificates against CA chain and verify client CN matches authorized users.
**Clients** validate server certificates and ensure hostname matches CN or SAN entries.

---

### 🔑 SCRAM-SHA-256 Authentication
| Service    | Status             | Notes              |
|------------|--------------------|--------------------|
| Redis      | ❌ Not Supported   | Only plaintext     |
| MongoDB    | ✅ OK              | Enabled            |
| PostgreSQL | ✅ OK              | Enabled            |
| Kafka      | ✅ OK              | Enabled            |

All **system** components except for **Redis** have additional **SCRAM-SHA-256** password based authentication.
**Redis** employs plaintext authentication as it does not support **SCRAM-SHA-256** authentication mechanism.

---

### 📜 OCSP-Stapling/CRL Support
| Service    | Status             | Notes                    |
|------------|--------------------|--------------------------|
| Redis      | ❌ Not Supported   | Only in Redis Enterprise |
| MongoDB    | ✅ OK              | OCSP enabled             |
| PostgreSQL | ✅ OK              | CRL enabled              |
| Kafka      | ✅ OK              | OCSP enabled             |


All **system** components except for **Redis** support real-time certificate revocation.
**Mongo** and **Kafka** supports OCSP. **PostgreSQL** supports CRL with automatic updating.
**Redis** does not support any of those. Only in **Redis E**.

---
