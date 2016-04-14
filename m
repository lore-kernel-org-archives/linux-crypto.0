From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH] KEYS: Provide keyctls to do public key operations
Date: Thu, 14 Apr 2016 23:00:31 +0100
Message-ID: <18908.1460671231@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: keyrings@vger.kernel.org, dhowells@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
To: pjones@redhat.com, tadeusz.struk@intel.com, marcel@holtmann.org,
	dwmw2@infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbcDNWAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Apr 2016 18:00:37 -0400
Content-ID: <18907.1460671231.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Here's a patch that does a first attempt at implementing keyctls for public
key operations using asymmetric-type keys.  This includes provision of a
query function.

[!] Note that whilst this patch compiles, it has not yet been tested.

I make the assumption that the asymmetric key type is the only one that
supports such things and call the asymmetric type accessor functions
directly rather than adding more key_type operations.  It would, however,
be cleaner to go through key_type ops - but would add an extra call into
the stack.

Encrypt, decrypt and sign ops could be combined with an argument to select
which op is desired.

The interface for the active ops is a bit clunky as the syscall interface
doesn't provide sufficient argument space to pass everything I need to
specify.  Some basic integer arguments are specified in a struct and more
complex options through a string of key=val pairs - just so I don't have to
deal with the compat code for dealing with a struct containing pointers
(but I can change to that if it's preferable).

I've specified data and enc buffer pointer for the keyctls, the order of
which are reversed for decrypt.  I'm tempted to change that to in and out
and just accept that for verify, out is actually an input.  I do not want
to pass data out for verify and then leave it to the caller to make the
comparison as I can't assume that hardware crypto will give me the computed
result of the verify crypto operation.

This patch really needs splitting into three: (1) internal op functions to
invoke the subtype (verify_signature() already exists in this set), (2) the
keyctl interface and (3) the software public key subtype methods.

I also have not yet implemented the hoop jumping in public_key.c to get the
software public key implementation to invoke the crypto layer to do the
missing three operations.

David
---
KEYS: Provide keyctls to do public key operations

Provide keyctl functions to do public key operations (sign, verify, encrypt
and decrypt) if the target key supports them, plus a query function to find
out about the key.

Not-yet-signed-off-by: David Howells <dhowells@redhat.com>
---
 Documentation/security/keys.txt           |  105 +++++++++
 crypto/asymmetric_keys/pkcs7_parser.c     |    1 
 crypto/asymmetric_keys/public_key.c       |   38 +++
 crypto/asymmetric_keys/signature.c        |  150 +++++++++++++
 crypto/asymmetric_keys/x509_cert_parser.c |   21 +-
 include/crypto/public_key.h               |   13 +
 include/keys/asymmetric-subtype.h         |   13 +
 include/linux/keyctl.h                    |   36 +++
 include/uapi/linux/keyctl.h               |   27 ++
 security/keys/Makefile                    |    1 
 security/keys/compat.c                    |   11 +
 security/keys/internal.h                  |   35 +++
 security/keys/keyctl.c                    |   21 ++
 security/keys/keyctl_pkey.c               |  324 +++++++++++++++++++++++++++++
 14 files changed, 781 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/keyctl.h
 create mode 100644 security/keys/keyctl_pkey.c

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 20d05719bceb..8a0dbf289631 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -854,6 +854,111 @@ The keyctl syscall functions are:
      supported, error ENOKEY if the key could not be found, or error
      EACCES if the key is not readable by the caller.
 
+
+ (*) Query an asymmetric key.
+
+	long keyctl(KEYCTL_PKEY_QUERY, key_serial_t key,
+		    struct keyctl_pkey_query *info);
+
+     Get information about an asymmetric key.  The information is returned in
+     the keyctl_pkey_query struct:
+
+	__u32	supported_ops;
+
+     A bit mask of flags indicating which ops are supported.  This is
+     constructed from a bitwise-OR of:
+
+	KEYCTL_SUPPORTS_{ENCRYPT,DECRYPT,SIGN,VERIFY}
+
+	__u32	key_size;
+
+     The size in bits of the key.
+
+	__u16	max_data_size;
+	__u16	max_sig_size;
+	__u16	max_enc_size;
+	__u16	max_dec_size;
+
+     The maximum sizes in bytes of a blob of data to be signed, a signature
+     blob, a blob to be encrypted and a blob to be decypted.
+
+     If successful, 0 is returned.  If the key is not an asymmetric key,
+     EOPNOTSUPP is returned.
+
+
+ (*) Encrypt, decrypt, sign or verify a blob using an asymmetric key.
+
+	long keyctl(KEYCTL_PKEY_ENCRYPT,
+		    const struct keyctl_pkey_params *params,
+		    const char *info,
+		    const void *data,
+		    void *enc);
+
+	long keyctl(KEYCTL_PKEY_DECRYPT,
+		    const struct keyctl_pkey_params *params,
+		    const char *info,
+		    const void *enc,
+		    void *data);
+
+	long keyctl(KEYCTL_PKEY_SIGN,
+		    const struct keyctl_pkey_params *params,
+		    const char *info,
+		    const void *data,
+		    void *enc);
+
+	long keyctl(KEYCTL_PKEY_VERIFY,
+		    const struct keyctl_pkey_params *params,
+		    const char *info,
+		    const void *data,
+		    const void *enc);
+
+     Use an asymmetric key to perform a public-key cryptographic operation a
+     blob of data.  For encryption and verification, the asymmetric key may
+     only need the public parts to be available, but for decryption and signing
+     the private parts are required also.
+
+     The parameter block pointed to by params contains a number of integer
+     values:
+
+	__s32		key_id;
+	__s32		password_id;
+	__u32		data_len;
+	__u32		enc_len;
+
+     key_id is the ID of the asymmetric key to be used.  data_len indicates the
+     length of the data or buffer pointed to by data whilst enc_len indicates
+     the length of the data or buffer pointed to by enc.
+
+     If the key must be unlocked with a password before it can be used,
+     password_id should point to a logon-type key that holds this.
+
+     info is a string of key=value pairs that supply supplementary
+     information.  These include:
+
+	enc=<encoding>	The encoding of the encrypted/signature blob.  This can
+			be "pkcs1" for RSASSA-PKCS1-v1.5 or RSAES-PKCS1-v1.5;
+			"pss" for "RSASSA-PSS"; "oaep" for "RSAES-OAEP".  If
+			omitted or is "raw", the raw output of the encryption
+			function is specified.
+
+        hash=<algo>	If the data buffer contains the output of a hash
+			function and the encoding includes some indication of
+			which hash function was used, the hash function can be
+			specified with this, eg. "hash=sha256".
+
+     For encryption, data points to the data blob to be encrypted whilst enc
+     points to a buffer to hold the encrypted output.  Decryption is the mirror
+     image of this - and note that the arguments are reversed.
+
+     For signing and verifying, data holds the blob to be signed in both cases
+     (this is typically the output of a digest function).  When signing, enc
+     points to a buffer into which the signature will be written, whereas with
+     verification, enc points to the signature to be verified.
+
+     If successful, encrypt, decrypt and sign all return the amount of data
+     written into the output buffer.  Verification returns 0 on success.
+
+
 ===============
 KERNEL SERVICES
 ===============
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index af4cd8649117..5f0c6755a55b 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -261,6 +261,7 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 	switch (ctx->last_oid) {
 	case OID_rsaEncryption:
 		ctx->sinfo->sig->pkey_algo = "rsa";
+		ctx->sinfo->sig->encoding = "pkcs1";
 		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index fd76b5fc3b3a..3a38b177df89 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -57,6 +57,40 @@ static void public_key_destroy(void *payload0, void *payload3)
 	public_key_signature_free(payload3);
 }
 
+/*
+ * Query information about a key.
+ */
+static int software_key_query(const struct key *key,
+			      struct kernel_pkey_query *info)
+{
+	struct crypto_akcipher *tfm;
+	struct public_key *pkey = key->payload.data[asym_crypto];
+	int ret, len;
+
+	tfm = crypto_alloc_akcipher(pkey->pkey_algo, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
+	if (ret < 0)
+		goto error_free_tfm;
+
+	len = crypto_akcipher_maxsize(tfm) * 8;
+	info->key_size = len * 8;
+	info->max_data_size = len;
+	info->max_sig_size = len;
+	info->max_enc_size = len;
+	info->max_dec_size = len;
+	info->supported_ops = KEYCTL_SUPPORTS_VERIFY;
+	ret = 0;
+
+error_free_tfm:
+	crypto_free_akcipher(tfm);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+
+
 struct public_key_completion {
 	struct completion completion;
 	int err;
@@ -97,7 +131,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 	BUG_ON(!sig->s);
 
 	alg_name = sig->pkey_algo;
-	if (strcmp(sig->pkey_algo, "rsa") == 0) {
+	if (strcmp(sig->pkey_algo, "rsa") == 0 &&
+	    strcmp(sig->encoding, "pkcs1") == 0) {
 		/* The data wangled by the RSA algorithm is typically padded
 		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
 		 * sec 8.2].
@@ -179,6 +214,7 @@ struct asymmetric_key_subtype public_key_subtype = {
 	.name_len		= sizeof("public_key") - 1,
 	.describe		= public_key_describe,
 	.destroy		= public_key_destroy,
+	.query			= software_key_query,
 	.verify_signature	= public_key_verify_signature_2,
 };
 EXPORT_SYMBOL_GPL(public_key_subtype);
diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 11b7ba170904..8ecbeda16b53 100644
--- a/crypto/asymmetric_keys/signature.c
+++ b/crypto/asymmetric_keys/signature.c
@@ -37,6 +37,156 @@ void public_key_signature_free(struct public_key_signature *sig)
 EXPORT_SYMBOL_GPL(public_key_signature_free);
 
 /**
+ * query_asymmetric_key - Get information about an aymmetric key.
+ * @key: The key to query
+ * @info: Where to put the information.
+ */
+int query_asymmetric_key(const struct key *key,
+			 struct kernel_pkey_query *info)
+{
+	const struct asymmetric_key_subtype *subtype;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return -EINVAL;
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype ||
+	    !key->payload.data[0])
+		return -EINVAL;
+
+	ret = subtype->query(key, info);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(query_asymmetric_key);
+
+/**
+ * encrypt_blob - Encrypt data using an asymmetric key
+ * @params: Various parameters
+ * @data: Data blob to be encrypted, length params->data_len
+ * @enc: Encrypted data buffer, length params->enc_len
+ *
+ * Encrypt the specified data blob using the private key specified by
+ * params->key.  The encrypted data is wrapped in an encoding if
+ * params->encoding is specified (eg. "pkcs1").
+ *
+ * If the key needs to be unlocked, a password can be supplied in a logon key
+ * specified by params->password.
+ *
+ * Returns the length of the data placed in the encrypted data buffer or an
+ * error.
+ */
+int encrypt_blob(struct kernel_pkey_params *params,
+		 const void *data, void *enc)
+{
+	const struct asymmetric_key_subtype *subtype;
+	struct key *key = params->key;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return -EINVAL;
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype ||
+	    !key->payload.data[0])
+		return -EINVAL;
+	if (!subtype->encrypt_blob)
+		return -ENOTSUPP;
+
+	ret = subtype->encrypt_blob(params, data, enc);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(encrypt_blob);
+
+/**
+ * decrypt_blob - Decrypt data using an asymmetric key
+ * @params: Various parameters
+ * @enc: Encrypted data to be decrypted, length params->enc_len
+ * @data: Decrypted data buffer, length params->data_len
+ *
+ * Decrypt the specified data blob using the private key specified by
+ * params->key.  The decrypted data is wrapped in an encoding if
+ * params->encoding is specified (eg. "pkcs1").
+ *
+ * If the private key needs to be unlocked, a password can be supplied in a
+ * logon key specified by params->password.
+ *
+ * Returns the length of the data placed in the decrypted data buffer or an
+ * error.
+ */
+int decrypt_blob(struct kernel_pkey_params *params,
+		 const void *enc, void *data)
+{
+	const struct asymmetric_key_subtype *subtype;
+	struct key *key = params->key;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return -EINVAL;
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype ||
+	    !key->payload.data[0])
+		return -EINVAL;
+	if (!subtype->decrypt_blob)
+		return -ENOTSUPP;
+
+	ret = subtype->decrypt_blob(params, enc, data);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(decrypt_blob);
+
+/**
+ * create_signature - Sign some data using an asymmetric key
+ * @params: Various parameters
+ * @data: Data blob to be signed, length params->data_len
+ * @enc: Signature buffer, length params->enc_len
+ *
+ * Sign the specified data blob using the private key specified by params->key.
+ * The signature is wrapped in an encoding if params->encoding is specified
+ * (eg. "pkcs1").  If the encoding needs to know the digest type, this can be
+ * passed through params->hash_algo (eg. "sha1").
+ *
+ * If the private key needs to be unlocked, a password can be supplied in a
+ * logon key specified by params->password.
+ *
+ * Returns the length of the data placed in the signature buffer or an error.
+ */
+int create_signature(struct kernel_pkey_params *params,
+		     const void *data, void *enc)
+{
+	const struct asymmetric_key_subtype *subtype;
+	struct key *key = params->key;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return -EINVAL;
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype ||
+	    !key->payload.data[0])
+		return -EINVAL;
+	if (!subtype->create_signature)
+		return -ENOTSUPP;
+
+	ret = subtype->create_signature(params, data, enc);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(create_signature);
+
+/**
  * verify_signature - Initiate the use of an asymmetric key to verify a signature
  * @key: The asymmetric key to verify against
  * @sig: The signature to check
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 865f46ea724f..1f1899d5ab43 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -199,35 +199,32 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 
 	case OID_md4WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "md4";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha1WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha1";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha256WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha256";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha384WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha384";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha512WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha512";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha224WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha224";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 	}
 
+rsa_pkcs1:
+	ctx->cert->sig->pkey_algo = "rsa";
+	ctx->cert->sig->encoding = "pkcs1";
 	ctx->algo_oid = ctx->last_oid;
 	return 0;
 }
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 882ca0e1e7a5..a5bdfef2d243 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -14,6 +14,8 @@
 #ifndef _LINUX_PUBLIC_KEY_H
 #define _LINUX_PUBLIC_KEY_H
 
+#include <linux/keyctl.h>
+
 /*
  * Cryptographic data for the public-key subtype of the asymmetric key type.
  *
@@ -40,6 +42,7 @@ struct public_key_signature {
 	u8 digest_size;		/* Number of bytes in digest */
 	const char *pkey_algo;
 	const char *hash_algo;
+	const char *encoding;
 };
 
 extern void public_key_signature_free(struct public_key_signature *sig);
@@ -54,8 +57,14 @@ extern int restrict_link_by_signature(struct key *trust_keyring,
 				      const struct key_type *type,
 				      const union key_payload *payload);
 
-extern int verify_signature(const struct key *key,
-			    const struct public_key_signature *sig);
+extern int query_asymmetric_key(const struct key *,
+				struct kernel_pkey_query *);
+
+extern int encrypt_blob(struct kernel_pkey_params *, const void *, void *);
+extern int decrypt_blob(struct kernel_pkey_params *, const void *, void *);
+extern int create_signature(struct kernel_pkey_params *, const void *, void *);
+extern int verify_signature(const struct key *,
+			    const struct public_key_signature *);
 
 int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig);
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index 2480469ce8fb..b3a6e1a090c2 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -17,6 +17,8 @@
 #include <linux/seq_file.h>
 #include <keys/asymmetric-type.h>
 
+struct kernel_pkey_query;
+struct kernel_pkey_params;
 struct public_key_signature;
 
 /*
@@ -34,6 +36,17 @@ struct asymmetric_key_subtype {
 	/* Destroy a key of this subtype */
 	void (*destroy)(void *payload_crypto, void *payload_auth);
 
+	int (*query)(const struct key *key, struct kernel_pkey_query *info);
+
+	int (*encrypt_blob)(struct kernel_pkey_params *params,
+			    const void *data, void *enc);
+
+	int (*decrypt_blob)(struct kernel_pkey_params *params,
+			    const void *enc, void *data);
+
+	int (*create_signature)(struct kernel_pkey_params *params,
+				const void *data, void *enc);
+
 	/* Verify the signature on a key of this subtype (optional) */
 	int (*verify_signature)(const struct key *key,
 				const struct public_key_signature *sig);
diff --git a/include/linux/keyctl.h b/include/linux/keyctl.h
new file mode 100644
index 000000000000..54afe345b75a
--- /dev/null
+++ b/include/linux/keyctl.h
@@ -0,0 +1,36 @@
+/* keyctl kernel bits
+ *
+ * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef __LINUX_KEYCTL_H
+#define __LINUX_KEYCTL_H
+
+#include <uapi/linux/keyctl.h>
+
+struct kernel_pkey_query {
+	__u32		supported_ops;	/* Which ops are supported */
+	__u32		key_size;	/* Size of the key in bits */
+	__u16		max_data_size;	/* Maximum size of raw data to sign in bytes */
+	__u16		max_sig_size;	/* Maximum size of signature in bytes */
+	__u16		max_enc_size;	/* Maximum size of encrypted blob in bytes */
+	__u16		max_dec_size;	/* Maximum size of decrypted blob in bytes */
+};
+
+struct kernel_pkey_params {
+	struct key	*key;
+	struct key	*password;
+	const char	*encoding;	/* Encoding (eg. "oaep" or NULL for raw) */
+	const char	*hash_algo;	/* Digest algorithm used (eg. "sha1") or NULL if N/A */
+	char		*info;		/* Modified info string to be released later */
+	__u32		data_len;	/* Unencrypted/unsigned data (buffer) size */
+	__u32		enc_len;	/* Encrypted data/signature (buffer) size */
+};
+
+#endif /* __LINUX_KEYCTL_H */
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 86eddd6241f3..d9e865ddee8a 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -60,6 +60,11 @@
 #define KEYCTL_INVALIDATE		21	/* invalidate a key */
 #define KEYCTL_GET_PERSISTENT		22	/* get a user's persistent keyring */
 #define KEYCTL_DH_COMPUTE		23	/* Compute Diffie-Hellman values */
+#define KEYCTL_PKEY_QUERY		24	/* Query public key parameters */
+#define KEYCTL_PKEY_ENCRYPT		25	/* Encrypt a blob using a public key */
+#define KEYCTL_PKEY_DECRYPT		26	/* Decrypt a blob using a public key */
+#define KEYCTL_PKEY_SIGN		27	/* Create a public key signature */
+#define KEYCTL_PKEY_VERIFY		28	/* Verify a public key signature */
 
 /* keyctl structures */
 struct keyctl_dh_params {
@@ -68,4 +73,26 @@ struct keyctl_dh_params {
 	__s32 base;
 };
 
+struct keyctl_pkey_query {
+	__u32		supported_ops;	/* Which ops are supported */
+#define KEYCTL_SUPPORTS_ENCRYPT		0x01
+#define KEYCTL_SUPPORTS_DECRYPT		0x02
+#define KEYCTL_SUPPORTS_SIGN		0x04
+#define KEYCTL_SUPPORTS_VERIFY		0x05
+	__u32		key_size;	/* Size of the key in bits */
+	__u16		max_data_size;	/* Maximum size of raw data to sign in bytes */
+	__u16		max_sig_size;	/* Maximum size of signature in bytes */
+	__u16		max_enc_size;	/* Maximum size of encrypted blob in bytes */
+	__u16		max_dec_size;	/* Maximum size of decrypted blob in bytes */
+	__u32		__spare[10];
+};
+
+struct keyctl_pkey_params {
+	__s32		key_id;		/* Serial no. of public key to use */
+	__s32		password_id;	/* Serial no. of password-containing key to use (or 0) */
+	__u32		data_len;	/* Unencrypted/unsigned data (buffer) size */
+	__u32		enc_len;	/* Encrypted data/signature (buffer) size */
+	__u32		__spare[4];
+};
+
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 1fd4a16e6daf..981be73e938f 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 obj-$(CONFIG_PERSISTENT_KEYRINGS) += persistent.o
 obj-$(CONFIG_KEY_DH_OPERATIONS) += dh.o
+obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += keyctl_pkey.o
 
 #
 # Key types
diff --git a/security/keys/compat.c b/security/keys/compat.c
index c8783b3b628c..e3e365ebf12d 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -136,6 +136,17 @@ COMPAT_SYSCALL_DEFINE5(keyctl, u32, option,
 		return keyctl_dh_compute(compat_ptr(arg2), compat_ptr(arg3),
 					 arg4);
 
+	case KEYCTL_PKEY_ENCRYPT:
+	case KEYCTL_PKEY_DECRYPT:
+	case KEYCTL_PKEY_SIGN:
+		return keyctl_pkey_e_d_s(option,
+					 compat_ptr(arg2), compat_ptr(arg3),
+					 compat_ptr(arg4), compat_ptr(arg5));
+
+	case KEYCTL_PKEY_VERIFY:
+		return keyctl_pkey_verify(compat_ptr(arg2), compat_ptr(arg3),
+					  compat_ptr(arg4), compat_ptr(arg5));
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 8ec7a528365d..b6657bd47606 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -269,6 +269,41 @@ static inline long keyctl_dh_compute(struct keyctl_dh_params __user *params,
 }
 #endif
 
+#ifdef CONFIG_ASYMMETRIC_KEY_TYPE
+extern long keyctl_pkey_query(key_serial_t,  struct keyctl_pkey_query __user *);
+
+extern long keyctl_pkey_verify(const struct keyctl_pkey_params __user *,
+			       const char __user *,
+			       const void __user *, const void __user *);
+
+extern long keyctl_pkey_e_d_s(int,
+			      const struct keyctl_pkey_params __user *,
+			      const char __user *,
+			      const void __user *, void __user *);
+#else
+static inline long keyctl_pkey_query(key_serial_t id,  struct keyctl_pkey_query __user *_res)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline long keyctl_pkey_verify(const struct keyctl_pkey_params __user *params,
+				      const char __user *_info,
+				      const void __user *_sig,
+				      const void __user *_data)
+{
+	return -EOPNOTSUPP;
+}
+
+extern long keyctl_pkey_e_d_s(int op,
+			      const struct keyctl_pkey_params __user *params,
+			      const char __user *_info,
+			      const void __user *_in,
+			      void __user _out*)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 /*
  * Debugging key validation
  */
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 3b135a0af344..bd4580e55eaf 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1691,6 +1691,27 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 					 (char __user *) arg3,
 					 (size_t) arg4);
 
+	case KEYCTL_PKEY_QUERY:
+		return keyctl_pkey_query((key_serial_t)arg2,
+					 (struct keyctl_pkey_query *)arg3);
+
+	case KEYCTL_PKEY_ENCRYPT:
+	case KEYCTL_PKEY_DECRYPT:
+	case KEYCTL_PKEY_SIGN:
+		return keyctl_pkey_e_d_s(
+			option,
+			(const struct keyctl_pkey_params __user *)arg2,
+			(const char __user *)arg3,
+			(const void __user *)arg4,
+			(void __user *)arg5);
+
+	case KEYCTL_PKEY_VERIFY:
+		return keyctl_pkey_verify(
+			(const struct keyctl_pkey_params __user *)arg2,
+			(const char __user *)arg3,
+			(const void __user *)arg4,
+			(const void __user *)arg5);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
new file mode 100644
index 000000000000..c903e7469beb
--- /dev/null
+++ b/security/keys/keyctl_pkey.c
@@ -0,0 +1,324 @@
+/* Public-key operation keyctls
+ *
+ * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/slab.h>
+#include <linux/key.h>
+#include <linux/keyctl.h>
+#include <linux/parser.h>
+#include <crypto/public_key.h>
+#include <keys/asymmetric-type.h>
+#include <keys/user-type.h>
+#include <asm/uaccess.h>
+#include "internal.h"
+
+/*
+ * Query information about an asymmetric key.
+ */
+long keyctl_pkey_query(key_serial_t id,  struct keyctl_pkey_query __user *_res)
+{
+	struct kernel_pkey_query res;
+	struct key *key;
+	key_ref_t key_ref;
+	long ret;
+
+	key_ref = lookup_user_key(id, 0, KEY_NEED_READ);
+	if (IS_ERR(key_ref))
+		return PTR_ERR(key_ref);
+
+	key = key_ref_to_ptr(key_ref);
+
+	ret = query_asymmetric_key(key, &res);
+	if (ret < 0)
+		goto error_key;
+
+	ret = -EFAULT;
+	if (copy_to_user(_res, &res, sizeof(res)) == 0 &&
+	    clear_user(_res->__spare, sizeof(_res->__spare)) == 0)
+		ret = 0;
+
+error_key:
+	key_put(key);
+	return ret;
+}
+
+static void keyctl_pkey_params_free(struct kernel_pkey_params *params)
+{
+	kfree(params->info);
+	key_put(params->key);
+	key_put(params->password);
+}
+
+enum {
+	Opt_err = -1,
+	Opt_enc,		/* "enc=<endoding>" eg. "enc=oaep" */
+	Opt_hash,		/* "hash=<digest-name>" eg. "hash=sha1" */
+};
+
+static const match_table_t param_keys = {
+	{ Opt_enc,	"enc=%s" },
+	{ Opt_hash,	"hash=%s" },
+	{ Opt_err,	NULL }
+};
+
+/*
+ * Parse the information string which consists of key=val pairs.
+ */
+static int keyctl_pkey_params_parse(struct kernel_pkey_params *params)
+{
+	unsigned long token_mask = 0;
+	substring_t args[MAX_OPT_ARGS];
+	char *c = params->info, *p, *q;
+	int token;
+
+	while ((p = strsep(&c, " \t"))) {
+		if (*p == '\0' || *p == ' ' || *p == '\t')
+			continue;
+		token = match_token(p, param_keys, args);
+		if (test_and_set_bit(token, &token_mask))
+			return -EINVAL;
+		q = args[0].from;
+		if (q[0])
+			return -EINVAL;
+
+		switch (token) {
+		case Opt_enc:
+			params->encoding = q;
+			break;
+
+		case Opt_hash:
+			params->hash_algo = q;
+			break;
+
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Get parameters from userspace.
+ */
+static int keyctl_pkey_params_get(const struct keyctl_pkey_params __user *_params,
+				  const char __user *_info,
+				  int op,
+				  struct kernel_pkey_params *params)
+{
+	struct keyctl_pkey_params uparams;
+	struct kernel_pkey_query info;
+	key_ref_t key_ref;
+	void *p;
+	int ret;
+
+	memset(params, 0, sizeof(*params));
+	params->encoding = "raw";
+
+	if (copy_from_user(&uparams, _params, sizeof(uparams)) != 0)
+		return -EFAULT;
+
+	p = strndup_user(_info, PAGE_SIZE);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+	params->info = p;
+
+	ret = keyctl_pkey_params_parse(params);
+
+	key_ref = lookup_user_key(uparams.key_id, 0, KEY_NEED_READ);
+	if (IS_ERR(key_ref))
+		return PTR_ERR(key_ref);
+	params->key = key_ref_to_ptr(key_ref);
+
+	ret = query_asymmetric_key(params->key, &info);
+	if (ret < 0)
+		goto error;
+
+	if (uparams.password_id) {
+		key_ref = lookup_user_key(uparams.password_id, 0,
+					  KEY_NEED_READ);
+		if (IS_ERR(key_ref)) {
+			ret = PTR_ERR(key_ref);
+			goto error;
+		}
+		params->password = key_ref_to_ptr(key_ref);
+		ret = -EINVAL;
+		if (params->password->type != &key_type_logon)
+			goto error;
+	}
+
+	ret = -EINVAL;
+	switch (op) {
+	case KEYCTL_PKEY_ENCRYPT:
+	case KEYCTL_PKEY_DECRYPT:
+		if (uparams.enc_len  > info.max_enc_size ||
+		    uparams.data_len > info.max_dec_size)
+			goto error;
+		break;
+	case KEYCTL_PKEY_SIGN:
+	case KEYCTL_PKEY_VERIFY:
+		if (uparams.enc_len  > info.max_sig_size ||
+		    uparams.data_len > info.max_data_size)
+			goto error;
+		break;
+	default:
+		BUG();
+	}
+
+	params->enc_len  = uparams.enc_len;
+	params->data_len = uparams.data_len;
+	return 0;
+
+error:
+	keyctl_pkey_params_free(params);
+	return ret;
+}
+
+/*
+ * Encrypt/decrypt/sign
+ *
+ * Encrypt data, decrypt data or sign data using a public key.
+ *
+ * _info is a string of supplementary information in key=val format.  For
+ * instance, it might contain:
+ *
+ *	"enc=pkcs1 hash=sha256"
+ *
+ * where enc= specifies the encoding and hash= selects the OID to go in that
+ * particular encoding if required.  If enc= isn't supplied, it's assumed that
+ * the caller is supplying raw values.
+ *
+ * If needed, a password may be provided to unlock the private key in a logon
+ * key whose serial number is in _params->password_id.
+ *
+ * If successful, 0 is returned.
+ */
+long keyctl_pkey_e_d_s(int op,
+		       const struct keyctl_pkey_params __user *_params,
+		       const char __user *_info,
+		       const void __user *_in,
+		       void __user *_out)
+{
+	int (*func)(struct kernel_pkey_params *, const void *, void *);
+	struct kernel_pkey_params params;
+	u16 in_len, out_len;
+	void *in, *out;
+	long ret;
+
+	ret = keyctl_pkey_params_get(_params, _info, op, &params);
+	if (ret < 0)
+		return ret;
+
+	switch (op) {
+	case KEYCTL_PKEY_ENCRYPT:
+		func = encrypt_blob;
+		in_len = params.data_len;
+		out_len = params.enc_len;
+		break;
+	case KEYCTL_PKEY_DECRYPT:
+		func = decrypt_blob;
+		in_len = params.enc_len;
+		out_len = params.data_len;
+		break;
+	case KEYCTL_PKEY_SIGN:
+		func = create_signature;
+		in_len = params.data_len;
+		out_len = params.enc_len;
+		break;
+	}
+
+	in = memdup_user(_in, in_len);
+	if (IS_ERR(in)) {
+		ret = PTR_ERR(in);
+		goto error_params;
+	}
+
+	out = kzalloc(out_len, GFP_KERNEL);
+	if (IS_ERR(out)) {
+		ret = PTR_ERR(out);
+		goto error_in;
+	}
+
+	ret = func(&params, in, out);
+	if (ret < 0)
+		goto error_out;
+
+	if (copy_to_user(_out, out, out_len) != 0)
+		ret = -EFAULT;
+
+error_out:
+	kfree(out);
+error_in:
+	kfree(in);
+error_params:
+	keyctl_pkey_params_free(&params);
+	return ret;
+}
+
+/*
+ * Verify a signature.
+ *
+ * Verify a public key signature using the given key, or if not given, search
+ * for a matching key.
+ *
+ * _info is a string of supplementary information in key=val format.  For
+ * instance, it might contain:
+ *
+ *	"enc=pkcs1 hash=sha256"
+ *
+ * where enc= specifies the signature blob encoding and hash= selects the OID
+ * to go in that particular encoding.  If enc= isn't supplied, it's assumed
+ * that the caller is supplying raw values.
+ *
+ * If successful, 0 is returned.
+ */
+long keyctl_pkey_verify(const struct keyctl_pkey_params __user *_params,
+			const char __user *_info,
+			const void __user *_sig,
+			const void __user *_data)
+{
+	struct kernel_pkey_params params;
+	struct public_key_signature sig;
+	void *p;
+	long ret;
+
+	ret = keyctl_pkey_params_get(_params, _info, KEYCTL_PKEY_VERIFY,
+				     &params);
+	if (ret < 0)
+		return ret;
+
+	memset(&sig, 0, sizeof(sig));
+	sig.s_size	= params.enc_len;
+	sig.digest_size	= params.data_len;
+	sig.encoding	= params.encoding;
+	sig.hash_algo	= params.hash_algo;
+
+	p = memdup_user(_sig, params.enc_len);
+	if (IS_ERR(p)) {
+		ret = PTR_ERR(p);
+		goto error_params;
+	}
+	sig.s = p;
+
+	p = memdup_user(_data, params.data_len);
+	if (IS_ERR(p)) {
+		ret = PTR_ERR(p);
+		goto error_sig;
+	}
+	sig.digest = p;
+
+	ret = verify_signature(params.key, &sig);
+
+error_sig:
+	public_key_signature_free(&sig);
+error_params:
+	keyctl_pkey_params_free(&params);
+	return ret;
+}
