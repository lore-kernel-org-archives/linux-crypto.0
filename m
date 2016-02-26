From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] X.509: Make algo identifiers text instead of enum
Date: Fri, 26 Feb 2016 15:23:54 +0000
Message-ID: <20160226152354.29934.16054.stgit@warthog.procyon.org.uk>
References: <20160226152333.29934.21098.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, balrogg@googlemail.com,
	keyrings@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbcBZPX5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 10:23:57 -0500
In-Reply-To: <20160226152333.29934.21098.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the identifier public key and digest algorithm fields text instead of
enum.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/mscode_parser.c    |   14 +++++++-------
 crypto/asymmetric_keys/pkcs7_parser.c     |   18 ++++++++---------
 crypto/asymmetric_keys/pkcs7_verify.c     |    8 +++-----
 crypto/asymmetric_keys/public_key.c       |   24 ++++-------------------
 crypto/asymmetric_keys/verify_pefile.c    |    4 ++--
 crypto/asymmetric_keys/verify_pefile.h    |    2 +-
 crypto/asymmetric_keys/x509_cert_parser.c |   26 +++++++++++++------------
 crypto/asymmetric_keys/x509_public_key.c  |   17 ++++++++--------
 include/crypto/public_key.h               |   30 ++++-------------------------
 kernel/module_signing.c                   |    6 ++++++
 security/integrity/digsig_asymmetric.c    |    8 +++-----
 11 files changed, 59 insertions(+), 98 deletions(-)

diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
index adcef59eec0b..3242cbfaeaa2 100644
--- a/crypto/asymmetric_keys/mscode_parser.c
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -86,25 +86,25 @@ int mscode_note_digest_algo(void *context, size_t hdrlen,
 	oid = look_up_OID(value, vlen);
 	switch (oid) {
 	case OID_md4:
-		ctx->digest_algo = HASH_ALGO_MD4;
+		ctx->digest_algo = "md4";
 		break;
 	case OID_md5:
-		ctx->digest_algo = HASH_ALGO_MD5;
+		ctx->digest_algo = "md5";
 		break;
 	case OID_sha1:
-		ctx->digest_algo = HASH_ALGO_SHA1;
+		ctx->digest_algo = "sha1";
 		break;
 	case OID_sha256:
-		ctx->digest_algo = HASH_ALGO_SHA256;
+		ctx->digest_algo = "sha256";
 		break;
 	case OID_sha384:
-		ctx->digest_algo = HASH_ALGO_SHA384;
+		ctx->digest_algo = "sha384";
 		break;
 	case OID_sha512:
-		ctx->digest_algo = HASH_ALGO_SHA512;
+		ctx->digest_algo = "sha512";
 		break;
 	case OID_sha224:
-		ctx->digest_algo = HASH_ALGO_SHA224;
+		ctx->digest_algo = "sha224";
 		break;
 
 	case OID__NR:
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3ef62dac9771..1c4f715efdde 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -218,25 +218,25 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
 
 	switch (ctx->last_oid) {
 	case OID_md4:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_MD4;
+		ctx->sinfo->sig.hash_algo = "md4";
 		break;
 	case OID_md5:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_MD5;
+		ctx->sinfo->sig.hash_algo = "md5";
 		break;
 	case OID_sha1:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA1;
+		ctx->sinfo->sig.hash_algo = "sha1";
 		break;
 	case OID_sha256:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA256;
+		ctx->sinfo->sig.hash_algo = "sha256";
 		break;
 	case OID_sha384:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA384;
+		ctx->sinfo->sig.hash_algo = "sha384";
 		break;
 	case OID_sha512:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA512;
+		ctx->sinfo->sig.hash_algo = "sha512";
 		break;
 	case OID_sha224:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA224;
+		ctx->sinfo->sig.hash_algo = "sha224";
 	default:
 		printk("Unsupported digest algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
@@ -255,7 +255,7 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 
 	switch (ctx->last_oid) {
 	case OID_rsaEncryption:
-		ctx->sinfo->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->sinfo->sig.pkey_algo = "rsa";
 		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
@@ -615,8 +615,6 @@ int pkcs7_sig_note_signature(void *context, size_t hdrlen,
 {
 	struct pkcs7_parse_context *ctx = context;
 
-	BUG_ON(ctx->sinfo->sig.pkey_algo != PKEY_ALGO_RSA);
-
 	ctx->sinfo->sig.s = kmemdup(value, vlen, GFP_KERNEL);
 	if (!ctx->sinfo->sig.s)
 		return -ENOMEM;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index f5db1378c096..50be2a15e531 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -31,17 +31,15 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	void *digest;
 	int ret;
 
-	kenter(",%u,%u", sinfo->index, sinfo->sig.pkey_hash_algo);
+	kenter(",%u,%s", sinfo->index, sinfo->sig.hash_algo);
 
-	if (sinfo->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !hash_algo_name[sinfo->sig.pkey_hash_algo])
+	if (!sinfo->sig.hash_algo)
 		return -ENOPKG;
 
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(hash_algo_name[sinfo->sig.pkey_hash_algo],
-				 0, 0);
+	tfm = crypto_alloc_shash(sinfo->sig.hash_algo, 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 27ebc2f44394..0f8b264b3961 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -24,19 +24,6 @@
 
 MODULE_LICENSE("GPL");
 
-const char *const pkey_algo_name[PKEY_ALGO__LAST] = {
-	[PKEY_ALGO_DSA]		= "dsa",
-	[PKEY_ALGO_RSA]		= "rsa",
-};
-EXPORT_SYMBOL_GPL(pkey_algo_name);
-
-const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST] = {
-	[PKEY_ID_PGP]		= "PGP",
-	[PKEY_ID_X509]		= "X509",
-	[PKEY_ID_PKCS7]		= "PKCS#7",
-};
-EXPORT_SYMBOL_GPL(pkey_id_type_name);
-
 /*
  * Provide a part of a description of the key for /proc/keys.
  */
@@ -46,9 +33,7 @@ static void public_key_describe(const struct key *asymmetric_key,
 	struct public_key *key = asymmetric_key->payload.data[asym_crypto];
 
 	if (key)
-		seq_printf(m, "%s.%s",
-			   pkey_id_type_name[key->id_type],
-			   pkey_algo_name[key->pkey_algo]);
+		seq_printf(m, "%s.%s", key->id_type, key->pkey_algo);
 }
 
 /*
@@ -103,15 +88,14 @@ int public_key_verify_signature(const struct public_key *pkey,
 	BUG_ON(!sig->digest);
 	BUG_ON(!sig->s);
 
-	alg_name = pkey_algo_name[sig->pkey_algo];
-	if (sig->pkey_algo == PKEY_ALGO_RSA) {
+	alg_name = sig->pkey_algo;
+	if (strcmp(sig->pkey_algo, "rsa") == 0) {
 		/* The data wangled by the RSA algorithm is typically padded
 		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
 		 * sec 8.2].
 		 */
 		if (snprintf(alg_name_buf, CRYPTO_MAX_ALG_NAME,
-			     "pkcs1pad(rsa,%s)",
-			     hash_algo_name[sig->pkey_hash_algo]
+			     "pkcs1pad(rsa,%s)", sig->hash_algo
 			     ) >= CRYPTO_MAX_ALG_NAME)
 			return -EINVAL;
 		alg_name = alg_name_buf;
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 897b734dabf9..7e8c2338ae25 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -328,12 +328,12 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	void *digest;
 	int ret;
 
-	kenter(",%u", ctx->digest_algo);
+	kenter(",%s", ctx->digest_algo);
 
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(hash_algo_name[ctx->digest_algo], 0, 0);
+	tfm = crypto_alloc_shash(ctx->digest_algo, 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
diff --git a/crypto/asymmetric_keys/verify_pefile.h b/crypto/asymmetric_keys/verify_pefile.h
index 55d5f7ebc45a..a133eb81a492 100644
--- a/crypto/asymmetric_keys/verify_pefile.h
+++ b/crypto/asymmetric_keys/verify_pefile.h
@@ -28,7 +28,7 @@ struct pefile_context {
 	/* PKCS#7 MS Individual Code Signing content */
 	const void	*digest;		/* Digest */
 	unsigned	digest_len;		/* Digest length */
-	enum hash_algo	digest_algo;		/* Digest algorithm */
+	const char	*digest_algo;		/* Digest algorithm */
 };
 
 #define kenter(FMT, ...)					\
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index c02c200a7136..4a29bac70060 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -188,33 +188,33 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 		return -ENOPKG; /* Unsupported combination */
 
 	case OID_md4WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_MD5;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.hash_algo = "md4";
+		ctx->cert->sig.pkey_algo = "rsa";
 		break;
 
 	case OID_sha1WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA1;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.hash_algo = "sha1";
+		ctx->cert->sig.pkey_algo = "rsa";
 		break;
 
 	case OID_sha256WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA256;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.hash_algo = "sha256";
+		ctx->cert->sig.pkey_algo = "rsa";
 		break;
 
 	case OID_sha384WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA384;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.hash_algo = "sha384";
+		ctx->cert->sig.pkey_algo = "rsa";
 		break;
 
 	case OID_sha512WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA512;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.hash_algo = "sha512";
+		ctx->cert->sig.pkey_algo = "rsa";
 		break;
 
 	case OID_sha224WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA224;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig.hash_algo = "sha224";
+		ctx->cert->sig.pkey_algo = "rsa";
 		break;
 	}
 
@@ -396,7 +396,7 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 	if (ctx->last_oid != OID_rsaEncryption)
 		return -ENOPKG;
 
-	ctx->cert->pub->pkey_algo = PKEY_ALGO_RSA;
+	ctx->cert->pub->pkey_algo = "rsa";
 
 	/* Discard the BIT STRING metadata */
 	ctx->key = value + 1;
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index d4782d3fdebc..5b6a45404954 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -176,7 +176,7 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(hash_algo_name[cert->sig.pkey_hash_algo], 0, 0);
+	tfm = crypto_alloc_shash(cert->sig.hash_algo, 0, 0);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
 			cert->unsupported_crypto = true;
@@ -294,21 +294,20 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	pr_devel("Cert Issuer: %s\n", cert->issuer);
 	pr_devel("Cert Subject: %s\n", cert->subject);
 
-	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig.pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !hash_algo_name[cert->sig.pkey_hash_algo]) {
+	if (!cert->pub->pkey_algo ||
+	    !cert->sig.pkey_algo ||
+	    !cert->sig.hash_algo) {
 		ret = -ENOPKG;
 		goto error_free_cert;
 	}
 
-	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pub->pkey_algo]);
+	pr_devel("Cert Key Algo: %s\n", cert->pub->pkey_algo);
 	pr_devel("Cert Valid period: %lld-%lld\n", cert->valid_from, cert->valid_to);
 	pr_devel("Cert Signature: %s + %s\n",
-		 pkey_algo_name[cert->sig.pkey_algo],
-		 hash_algo_name[cert->sig.pkey_hash_algo]);
+		 cert->sig.pkey_algo,
+		 cert->sig.hash_algo);
 
-	cert->pub->id_type = PKEY_ID_X509;
+	cert->pub->id_type = "X509";
 
 	/* See if we can derive the trustability of this certificate.
 	 *
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 80ab099a3edf..aa730ea7faf8 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -14,28 +14,6 @@
 #ifndef _LINUX_PUBLIC_KEY_H
 #define _LINUX_PUBLIC_KEY_H
 
-#include <crypto/hash_info.h>
-
-enum pkey_algo {
-	PKEY_ALGO_DSA,
-	PKEY_ALGO_RSA,
-	PKEY_ALGO__LAST
-};
-
-extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
-
-/* asymmetric key implementation supports only up to SHA224 */
-#define PKEY_HASH__LAST		(HASH_ALGO_SHA224 + 1)
-
-enum pkey_id_type {
-	PKEY_ID_PGP,		/* OpenPGP generated key ID */
-	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
-	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
-	PKEY_ID_TYPE__LAST
-};
-
-extern const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST];
-
 /*
  * The use to which an asymmetric key is being put.
  */
@@ -59,8 +37,8 @@ extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
 struct public_key {
 	void *key;
 	u32 keylen;
-	enum pkey_algo pkey_algo : 8;
-	enum pkey_id_type id_type : 8;
+	const char *id_type;
+	const char *pkey_algo;
 };
 
 extern void public_key_destroy(void *payload);
@@ -73,8 +51,8 @@ struct public_key_signature {
 	u32 s_size;		/* Number of bytes in signature */
 	u8 *digest;
 	u8 digest_size;		/* Number of bytes in digest */
-	enum pkey_algo pkey_algo : 8;
-	enum hash_algo pkey_hash_algo : 8;
+	const char *pkey_algo;
+	const char *hash_algo;
 };
 
 extern struct asymmetric_key_subtype public_key_subtype;
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 6528a79d998d..518efd683b4f 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -15,6 +15,12 @@
 #include <crypto/public_key.h>
 #include "module-internal.h"
 
+enum pkey_id_type {
+	PKEY_ID_PGP,		/* OpenPGP generated key ID */
+	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
+	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
+};
+
 /*
  * Module signature information block.
  *
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 69a92e6db23d..3a9828403383 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -16,6 +16,7 @@
 #include <linux/ratelimit.h>
 #include <linux/key-type.h>
 #include <crypto/public_key.h>
+#include <crypto/hash_info.h>
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
 
@@ -94,17 +95,14 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	if (siglen != __be16_to_cpu(hdr->sig_size))
 		return -EBADMSG;
 
-	if (hdr->hash_algo >= PKEY_HASH__LAST)
-		return -ENOPKG;
-
 	key = request_asymmetric_key(keyring, __be32_to_cpu(hdr->keyid));
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
 	memset(&pks, 0, sizeof(pks));
 
-	pks.pkey_algo = PKEY_ALGO_RSA;
-	pks.pkey_hash_algo = hdr->hash_algo;
+	pks.pkey_algo = "rsa";
+	pks.hash_algo = hash_algo_name[hdr->hash_algo];
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
