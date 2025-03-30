# parser_microservices

# Security Status

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
