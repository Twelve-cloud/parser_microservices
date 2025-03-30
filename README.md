# parser_microservices

# Security Status

Since **PostgreSQL** and **Redpanda** do not support EdDSA (ED448), I use RSA-based certificates with the following settings:

| Parameter           | Value                          |
|---------------------|--------------------------------|
| **Key Algorithm**   | RSA                            |
| **Key Size**        | 2048 bits                      |
| **Signature Scheme**| SHA-256 with RSA Encryption    |

### 🌐 UI HTTPS Protocol
| Service        | Status | Notes          |
|----------------|--------|----------------|
| Redis Insight  | ✅ OK  | Enabled        |
| Mongo Express  | ✅ OK  | Enabled        |
| pgAdmin        | ✅ OK  | Enabled        |
| Redpanda       | ✅ OK  | Enabled        |

### 🔒 Mutual TLS (mTLS) Support
| Service    | Status | Notes          |
|------------|--------|----------------|
| Redis      | ✅ OK  | Enabled        |
| MongoDB    | ✅ OK  | Enabled        |
| PostgreSQL | ✅ OK  | Enabled        |
| Kafka      | ✅ OK  | Enabled        |

### 🔐 TLS 1.3 Support
| Service    | Status | Notes          |
|------------|--------|----------------|
| Redis      | ✅ OK  | Enabled        |
| MongoDB    | ✅ OK  | Enabled        |
| PostgreSQL | ✅ OK  | Enabled        |
| Kafka      | ✅ OK  | Enabled        |

### 🛡️ TLS 1.3 Ciphersuites
| Service    | Status           | Notes            |
|------------|------------------|------------------|
| Redis      | ✅ OK            | Enabled          |
| MongoDB    | ✅ OK            | Enabled          |
| PostgreSQL | ❌ Not Supported | TLS 1.2 ciphers  |
| Kafka      | ✅ OK            | Enabled          |

### 🔑 SCRAM-SHA-256 Authentication
| Service    | Status             | Notes              |
|------------|--------------------|--------------------|
| Redis      | ❌ Not Supported   | Only plaintext     |
| MongoDB    | ✅ OK              | Enabled            |
| PostgreSQL | ✅ OK              | Enabled            |
| Kafka      | ✅ OK              | Enabled            |

### 📜 OCSP-Stapling/CRL Support
| Service    | Status             | Notes                    |
|------------|--------------------|--------------------------|
| Redis      | ❌ Not Supported   | Only in Redis Enterprise |
| MongoDB    | ✅ OK              | OCSP enabled             |
| PostgreSQL | ✅ OK              | CRL enabled              |
| Kafka      | ✅ OK              | OCSP enabled             |
