From: Carlo Caione <carlo@caione.org>
Subject: [PATCH] X.509: Recognize the legacy OID 1.3.14.3.2.29 (sha1WithRSASignature)
Date: Tue,  1 Aug 2017 14:28:59 +0200
Message-ID: <20170801122859.24806-1-carlo@caione.org>
Cc: Carlo Caione <carlo@endlessm.com>
To: dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@endlessm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Carlo Caione <carlo@endlessm.com>

sha1WithRSASignature is a deprecated equivalent of
sha1WithRSAEncryption. It originates from the NIST Open Systems
Environment (OSE) Implementor's Workshop (OIW).

It is supported for compatibility with Microsoft's certificate APIs
and tools, particularly makecert.exe, which default(ed/s) to this
OID for SHA-1.

Signed-off-by: Carlo Caione <carlo@endlessm.com>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 1 +
 include/linux/oid_registry.h              | 1 +
 2 files changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index dd03fead1ca3..cdbc8c2def79 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -203,6 +203,7 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 		break;
 
 	case OID_sha1WithRSAEncryption:
+	case OID_sha1WithRSASignature:
 		ctx->cert->sig->hash_algo = "sha1";
 		ctx->cert->sig->pkey_algo = "rsa";
 		break;
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index d2fa9ca42e9a..26faee80357f 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -62,6 +62,7 @@ enum OID {
 
 	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
+	OID_sha1WithRSASignature,	/* 1.3.14.3.2.29 */
 	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
 	OID_sha384,			/* 2.16.840.1.101.3.4.2.2 */
 	OID_sha512,			/* 2.16.840.1.101.3.4.2.3 */
-- 
2.13.3
