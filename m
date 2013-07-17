From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 02/20] keys: change asymmetric keys to use common hash definitions
Date: Wed, 17 Jul 2013 19:51:22 -0400
Message-ID: <1374105100-25880-3-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>

This patch makes use of the newly defined common hash algorithm info,
replacing, for example, PKEY_HASH with HASH_ALGO.

Changelog:
- Lindent fixes - Mimi

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 crypto/asymmetric_keys/Kconfig            |  1 +
 crypto/asymmetric_keys/public_key.c       | 12 ------------
 crypto/asymmetric_keys/rsa.c              | 14 +++++++-------
 crypto/asymmetric_keys/x509_cert_parser.c | 12 ++++++------
 crypto/asymmetric_keys/x509_parser.h      |  2 +-
 crypto/asymmetric_keys/x509_public_key.c  |  4 ++--
 include/crypto/public_key.h               | 18 ++++--------------
 kernel/module_signing.c                   |  8 ++++----
 8 files changed, 25 insertions(+), 46 deletions(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 6d2c2ea..52a7f2c 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -12,6 +12,7 @@ if ASYMMETRIC_KEY_TYPE
 config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	tristate "Asymmetric public-key crypto algorithm subtype"
 	select MPILIB
+	select CRYPTO_HASH_INFO
 	help
 	  This option provides support for asymmetric public key type handling.
 	  If signature generation and/or verification are to be used,
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index cb2e291..007396f 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -28,18 +28,6 @@ const char *const pkey_algo[PKEY_ALGO__LAST] = {
 };
 EXPORT_SYMBOL_GPL(pkey_algo);
 
-const char *const pkey_hash_algo[PKEY_HASH__LAST] = {
-	[PKEY_HASH_MD4]		= "md4",
-	[PKEY_HASH_MD5]		= "md5",
-	[PKEY_HASH_SHA1]	= "sha1",
-	[PKEY_HASH_RIPE_MD_160]	= "rmd160",
-	[PKEY_HASH_SHA256]	= "sha256",
-	[PKEY_HASH_SHA384]	= "sha384",
-	[PKEY_HASH_SHA512]	= "sha512",
-	[PKEY_HASH_SHA224]	= "sha224",
-};
-EXPORT_SYMBOL_GPL(pkey_hash_algo);
-
 const char *const pkey_id_type[PKEY_ID_TYPE__LAST] = {
 	[PKEY_ID_PGP]		= "PGP",
 	[PKEY_ID_X509]		= "X509",
diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 4a6a069..90a17f5 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -73,13 +73,13 @@ static const struct {
 	size_t size;
 } RSA_ASN1_templates[PKEY_HASH__LAST] = {
 #define _(X) { RSA_digest_info_##X, sizeof(RSA_digest_info_##X) }
-	[PKEY_HASH_MD5]		= _(MD5),
-	[PKEY_HASH_SHA1]	= _(SHA1),
-	[PKEY_HASH_RIPE_MD_160]	= _(RIPE_MD_160),
-	[PKEY_HASH_SHA256]	= _(SHA256),
-	[PKEY_HASH_SHA384]	= _(SHA384),
-	[PKEY_HASH_SHA512]	= _(SHA512),
-	[PKEY_HASH_SHA224]	= _(SHA224),
+	[HASH_ALGO_MD5]		= _(MD5),
+	[HASH_ALGO_SHA1]	= _(SHA1),
+	[HASH_ALGO_RIPE_MD_160]	= _(RIPE_MD_160),
+	[HASH_ALGO_SHA256]	= _(SHA256),
+	[HASH_ALGO_SHA384]	= _(SHA384),
+	[HASH_ALGO_SHA512]	= _(SHA512),
+	[HASH_ALGO_SHA224]	= _(SHA224),
 #undef _
 };
 
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index facbf26..0cefbe2 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -152,32 +152,32 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 		return -ENOPKG; /* Unsupported combination */
 
 	case OID_md4WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_MD5;
+		ctx->cert->sig_hash_algo = HASH_ALGO_MD5;
 		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha1WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA1;
+		ctx->cert->sig_hash_algo = HASH_ALGO_SHA1;
 		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha256WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA256;
+		ctx->cert->sig_hash_algo = HASH_ALGO_SHA256;
 		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha384WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA384;
+		ctx->cert->sig_hash_algo = HASH_ALGO_SHA384;
 		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha512WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA512;
+		ctx->cert->sig_hash_algo = HASH_ALGO_SHA512;
 		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha224WithRSAEncryption:
-		ctx->cert->sig_hash_algo = PKEY_HASH_SHA224;
+		ctx->cert->sig_hash_algo = HASH_ALGO_SHA224;
 		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
 		break;
 	}
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index f86dc5f..2a8bb66 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -22,7 +22,7 @@ struct x509_certificate {
 	struct tm	valid_to;
 	enum pkey_algo	pkey_algo : 8;		/* Public key algorithm */
 	enum pkey_algo	sig_pkey_algo : 8;	/* Signature public key algorithm */
-	enum pkey_hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
+	enum hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
 	const void	*tbs;			/* Signed data */
 	size_t		tbs_size;		/* Size of signed data */
 	const void	*sig;			/* Signature data */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 06007f0..312b408 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -49,7 +49,7 @@ static int x509_check_signature(const struct public_key *pub,
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(pkey_hash_algo[cert->sig_hash_algo], 0, 0);
+	tfm = crypto_alloc_shash(hash_algo_name[cert->sig_hash_algo], 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
@@ -128,7 +128,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 cert->valid_to.tm_min,  cert->valid_to.tm_sec);
 	pr_devel("Cert Signature: %s + %s\n",
 		 pkey_algo[cert->sig_pkey_algo],
-		 pkey_hash_algo[cert->sig_hash_algo]);
+		 hash_algo_name[cert->sig_hash_algo]);
 
 	if (!cert->fingerprint || !cert->authority) {
 		pr_warn("Cert for '%s' must have SubjKeyId and AuthKeyId extensions\n",
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index f5b0224..b4e5f27 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -15,6 +15,7 @@
 #define _LINUX_PUBLIC_KEY_H
 
 #include <linux/mpi.h>
+#include <crypto/hash_info.h>
 
 enum pkey_algo {
 	PKEY_ALGO_DSA,
@@ -24,19 +25,8 @@ enum pkey_algo {
 
 extern const char *const pkey_algo[PKEY_ALGO__LAST];
 
-enum pkey_hash_algo {
-	PKEY_HASH_MD4,
-	PKEY_HASH_MD5,
-	PKEY_HASH_SHA1,
-	PKEY_HASH_RIPE_MD_160,
-	PKEY_HASH_SHA256,
-	PKEY_HASH_SHA384,
-	PKEY_HASH_SHA512,
-	PKEY_HASH_SHA224,
-	PKEY_HASH__LAST
-};
-
-extern const char *const pkey_hash_algo[PKEY_HASH__LAST];
+/* asymmetric key implementation supports only up to SHA224 */
+#define PKEY_HASH__LAST		(HASH_ALGO_SHA224 + 1)
 
 enum pkey_id_type {
 	PKEY_ID_PGP,		/* OpenPGP generated key ID */
@@ -88,7 +78,7 @@ struct public_key_signature {
 	u8 *digest;
 	u8 digest_size;			/* Number of bytes in digest */
 	u8 nr_mpi;			/* Occupancy of mpi[] */
-	enum pkey_hash_algo pkey_hash_algo : 8;
+	enum hash_algo pkey_hash_algo : 8;
 	union {
 		MPI mpi[2];
 		struct {
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index f2970bd..ce1dfe8 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -28,7 +28,7 @@
  */
 struct module_signature {
 	u8	algo;		/* Public-key crypto algorithm [enum pkey_algo] */
-	u8	hash;		/* Digest algorithm [enum pkey_hash_algo] */
+	u8	hash;		/* Digest algorithm [enum hash_algo] */
 	u8	id_type;	/* Key identifier type [enum pkey_id_type] */
 	u8	signer_len;	/* Length of signer's name */
 	u8	key_id_len;	/* Length of key identifier */
@@ -39,7 +39,7 @@ struct module_signature {
 /*
  * Digest the module contents.
  */
-static struct public_key_signature *mod_make_digest(enum pkey_hash_algo hash,
+static struct public_key_signature *mod_make_digest(enum hash_algo hash,
 						    const void *mod,
 						    unsigned long modlen)
 {
@@ -54,7 +54,7 @@ static struct public_key_signature *mod_make_digest(enum pkey_hash_algo hash,
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(pkey_hash_algo[hash], 0, 0);
+	tfm = crypto_alloc_shash(hash_algo_name[hash], 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? ERR_PTR(-ENOPKG) : ERR_CAST(tfm);
 
@@ -217,7 +217,7 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		return -ENOPKG;
 
 	if (ms.hash >= PKEY_HASH__LAST ||
-	    !pkey_hash_algo[ms.hash])
+	    !hash_algo_name[ms.hash])
 		return -ENOPKG;
 
 	key = request_asymmetric_key(sig, ms.signer_len,
-- 
1.8.1.4

