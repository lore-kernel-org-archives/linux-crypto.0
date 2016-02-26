From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] akcipher: Move the RSA DER encoding check to the crypto
 layer
Date: Fri, 26 Feb 2016 15:23:47 +0000
Message-ID: <20160226152347.29934.41008.stgit@warthog.procyon.org.uk>
References: <20160226152333.29934.21098.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, balrogg@googlemail.com,
	keyrings@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbcBZPXu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 10:23:50 -0500
In-Reply-To: <20160226152333.29934.21098.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the RSA EMSA-PKCS1-v1_5 encoding from the asymmetric-key public_key
subtype to the rsa crypto module's pkcs1pad template.  This means that the
public_key subtype no longer has any dependencies on public key type.

To make this work, the following changes have been made:

 (1) The rsa pkcs1pad template is now used for RSA keys.  This strips off the
     padding and returns just the message hash.

 (2) In a previous patch, the pkcs1pad template gained an optional second
     parameter that, if given, specifies the hash used.  We now give this,
     and pkcs1pad checks the encoded message E(M) for the EMSA-PKCS1-v1_5
     encoding and verifies that the correct digest OID is present.

 (3) The crypto driver in crypto/asymmetric_keys/rsa.c is now reduced to
     something that doesn't care about what the encryption actually does
     and and has been merged into public_key.c.

 (4) CONFIG_PUBLIC_KEY_ALGO_RSA is gone.  Module signing must set
     CONFIG_CRYPTO_RSA=y instead.

Thoughts:

 (*) Should the encoding style (eg. raw, EMSA-PKCS1-v1_5) also be passed to
     the padding template?  Should there be multiple padding templates
     registered that share most of the code?

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 crypto/asymmetric_keys/Kconfig         |    7 -
 crypto/asymmetric_keys/Makefile        |    1 
 crypto/asymmetric_keys/public_key.c    |  104 +++++++++++++--
 crypto/asymmetric_keys/rsa.c           |  224 --------------------------------
 include/crypto/public_key.h            |    2 
 init/Kconfig                           |    2 
 security/integrity/digsig_asymmetric.c |    1 
 7 files changed, 95 insertions(+), 246 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/rsa.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 905d745c2f85..91a7e047a765 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -12,7 +12,6 @@ if ASYMMETRIC_KEY_TYPE
 config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	tristate "Asymmetric public-key crypto algorithm subtype"
 	select MPILIB
-	select PUBLIC_KEY_ALGO_RSA
 	select CRYPTO_HASH_INFO
 	help
 	  This option provides support for asymmetric public key type handling.
@@ -20,12 +19,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	  appropriate hash algorithms (such as SHA-1) must be available.
 	  ENOPKG will be reported if the requisite algorithm is unavailable.
 
-config PUBLIC_KEY_ALGO_RSA
-	tristate "RSA public-key algorithm"
-	select CRYPTO_RSA
-	help
-	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
-
 config X509_CERTIFICATE_PARSER
 	tristate "X.509 certificate parser"
 	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index b78a194ea014..f90486256f01 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
 asymmetric_keys-y := asymmetric_type.o signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
-obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
 
 #
 # X.509 Certificate handling
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index b383629b9e62..27ebc2f44394 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -17,8 +17,10 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/scatterlist.h>
 #include <keys/asymmetric-subtype.h>
 #include <crypto/public_key.h>
+#include <crypto/akcipher.h>
 
 MODULE_LICENSE("GPL");
 
@@ -35,12 +37,6 @@ const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST] = {
 };
 EXPORT_SYMBOL_GPL(pkey_id_type_name);
 
-static int (*alg_verify[PKEY_ALGO__LAST])(const struct public_key *pkey,
-	const struct public_key_signature *sig) = {
-	NULL,
-	rsa_verify_signature
-};
-
 /*
  * Provide a part of a description of the key for /proc/keys.
  */
@@ -68,24 +64,110 @@ void public_key_destroy(void *payload)
 }
 EXPORT_SYMBOL_GPL(public_key_destroy);
 
+struct public_key_completion {
+	struct completion completion;
+	int err;
+};
+
+static void public_key_verify_done(struct crypto_async_request *req, int err)
+{
+	struct public_key_completion *compl = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	compl->err = err;
+	complete(&compl->completion);
+}
+
 /*
  * Verify a signature using a public key.
  */
 int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig)
 {
+	struct public_key_completion compl;
+	struct crypto_akcipher *tfm;
+	struct akcipher_request *req;
+	struct scatterlist sig_sg, digest_sg;
+	const char *alg_name;
+	char alg_name_buf[CRYPTO_MAX_ALG_NAME];
+	void *output;
+	unsigned int outlen;
+	int ret = -ENOMEM;
+
+	pr_devel("==>%s()\n", __func__);
+
 	BUG_ON(!pkey);
 	BUG_ON(!sig);
 	BUG_ON(!sig->digest);
 	BUG_ON(!sig->s);
 
-	if (pkey->pkey_algo >= PKEY_ALGO__LAST)
-		return -ENOPKG;
+	alg_name = pkey_algo_name[sig->pkey_algo];
+	if (sig->pkey_algo == PKEY_ALGO_RSA) {
+		/* The data wangled by the RSA algorithm is typically padded
+		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
+		 * sec 8.2].
+		 */
+		if (snprintf(alg_name_buf, CRYPTO_MAX_ALG_NAME,
+			     "pkcs1pad(rsa,%s)",
+			     hash_algo_name[sig->pkey_hash_algo]
+			     ) >= CRYPTO_MAX_ALG_NAME)
+			return -EINVAL;
+		alg_name = alg_name_buf;
+	}
+
+	tfm = crypto_alloc_akcipher(alg_name, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		goto error_free_tfm;
+
+	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
+	if (ret)
+		goto error_free_req;
+
+	outlen = crypto_akcipher_maxsize(tfm);
+	output = kmalloc(outlen, GFP_KERNEL);
+	if (!output)
+		goto error_free_req;
+
+	sg_init_one(&sig_sg, sig->s, sig->s_size);
+	sg_init_one(&digest_sg, output, outlen);
+	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
+				   outlen);
+	init_completion(&compl.completion);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      public_key_verify_done, &compl);
+
+	/* Perform the verification calculation.  This doesn't actually do the
+	 * verification, but rather calculates the hash expected by the
+	 * signature and returns that to us.
+	 */
+	ret = crypto_akcipher_verify(req);
+	if (ret == -EINPROGRESS) {
+		wait_for_completion(&compl.completion);
+		ret = compl.err;
+	}
+	if (ret < 0)
+		goto out_free_output;
 
-	if (!alg_verify[pkey->pkey_algo])
-		return -ENOPKG;
+	/* Do the actual verification step. */
+	if (req->dst_len != sig->digest_size ||
+	    memcmp(sig->digest, output, sig->digest_size) != 0)
+		ret = -EKEYREJECTED;
 
-	return alg_verify[pkey->pkey_algo](pkey, sig);
+out_free_output:
+	kfree(output);
+error_free_req:
+	akcipher_request_free(req);
+error_free_tfm:
+	crypto_free_akcipher(tfm);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(public_key_verify_signature);
 
diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
deleted file mode 100644
index 51502bca65e7..000000000000
--- a/crypto/asymmetric_keys/rsa.c
+++ /dev/null
@@ -1,224 +0,0 @@
-/* RSA asymmetric public-key algorithm [RFC3447]
- *
- * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#define pr_fmt(fmt) "RSA: "fmt
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <crypto/akcipher.h>
-#include <crypto/public_key.h>
-#include <crypto/algapi.h>
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("RSA Public Key Algorithm");
-
-#define kenter(FMT, ...) \
-	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
-#define kleave(FMT, ...) \
-	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
-
-/*
- * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
- */
-static const u8 RSA_digest_info_MD5[] = {
-	0x30, 0x20, 0x30, 0x0C, 0x06, 0x08,
-	0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x02, 0x05, /* OID */
-	0x05, 0x00, 0x04, 0x10
-};
-
-static const u8 RSA_digest_info_SHA1[] = {
-	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
-	0x2B, 0x0E, 0x03, 0x02, 0x1A,
-	0x05, 0x00, 0x04, 0x14
-};
-
-static const u8 RSA_digest_info_RIPE_MD_160[] = {
-	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
-	0x2B, 0x24, 0x03, 0x02, 0x01,
-	0x05, 0x00, 0x04, 0x14
-};
-
-static const u8 RSA_digest_info_SHA224[] = {
-	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
-	0x05, 0x00, 0x04, 0x1C
-};
-
-static const u8 RSA_digest_info_SHA256[] = {
-	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
-	0x05, 0x00, 0x04, 0x20
-};
-
-static const u8 RSA_digest_info_SHA384[] = {
-	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
-	0x05, 0x00, 0x04, 0x30
-};
-
-static const u8 RSA_digest_info_SHA512[] = {
-	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
-	0x05, 0x00, 0x04, 0x40
-};
-
-static const struct {
-	const u8 *data;
-	size_t size;
-} RSA_ASN1_templates[PKEY_HASH__LAST] = {
-#define _(X) { RSA_digest_info_##X, sizeof(RSA_digest_info_##X) }
-	[HASH_ALGO_MD5]		= _(MD5),
-	[HASH_ALGO_SHA1]	= _(SHA1),
-	[HASH_ALGO_RIPE_MD_160]	= _(RIPE_MD_160),
-	[HASH_ALGO_SHA256]	= _(SHA256),
-	[HASH_ALGO_SHA384]	= _(SHA384),
-	[HASH_ALGO_SHA512]	= _(SHA512),
-	[HASH_ALGO_SHA224]	= _(SHA224),
-#undef _
-};
-
-struct rsa_completion {
-	struct completion completion;
-	int err;
-};
-
-/*
- * Perform the RSA signature verification.
- * @H: Value of hash of data and metadata
- * @EM: The computed signature value
- * @k: The size of EM (EM[0] is an invalid location but should hold 0x00)
- * @hash_size: The size of H
- * @asn1_template: The DigestInfo ASN.1 template
- * @asn1_size: Size of asm1_template[]
- */
-static int rsa_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
-		      const u8 *asn1_template, size_t asn1_size)
-{
-	unsigned PS_end, T_offset, i;
-
-	kenter(",,%zu,%zu,%zu", k, hash_size, asn1_size);
-
-	if (k < 2 + 1 + asn1_size + hash_size)
-		return -EBADMSG;
-
-	/* Decode the EMSA-PKCS1-v1_5
-	 * note: leading zeros are stripped by the RSA implementation
-	 */
-	if (EM[0] != 0x01) {
-		kleave(" = -EBADMSG [EM[0] == %02u]", EM[0]);
-		return -EBADMSG;
-	}
-
-	T_offset = k - (asn1_size + hash_size);
-	PS_end = T_offset - 1;
-	if (EM[PS_end] != 0x00) {
-		kleave(" = -EBADMSG [EM[T-1] == %02u]", EM[PS_end]);
-		return -EBADMSG;
-	}
-
-	for (i = 1; i < PS_end; i++) {
-		if (EM[i] != 0xff) {
-			kleave(" = -EBADMSG [EM[PS%x] == %02u]", i - 2, EM[i]);
-			return -EBADMSG;
-		}
-	}
-
-	if (crypto_memneq(asn1_template, EM + T_offset, asn1_size) != 0) {
-		kleave(" = -EBADMSG [EM[T] ASN.1 mismatch]");
-		return -EBADMSG;
-	}
-
-	if (crypto_memneq(H, EM + T_offset + asn1_size, hash_size) != 0) {
-		kleave(" = -EKEYREJECTED [EM[T] hash mismatch]");
-		return -EKEYREJECTED;
-	}
-
-	kleave(" = 0");
-	return 0;
-}
-
-static void public_key_verify_done(struct crypto_async_request *req, int err)
-{
-	struct rsa_completion *compl = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	compl->err = err;
-	complete(&compl->completion);
-}
-
-int rsa_verify_signature(const struct public_key *pkey,
-			 const struct public_key_signature *sig)
-{
-	struct crypto_akcipher *tfm;
-	struct akcipher_request *req;
-	struct rsa_completion compl;
-	struct scatterlist sig_sg, sg_out;
-	void *outbuf = NULL;
-	unsigned int outlen = 0;
-	int ret = -ENOMEM;
-
-	tfm = crypto_alloc_akcipher("rsa", 0, 0);
-	if (IS_ERR(tfm))
-		goto error_out;
-
-	req = akcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req)
-		goto error_free_tfm;
-
-	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
-	if (ret)
-		goto error_free_req;
-
-	ret = -EINVAL;
-	outlen = crypto_akcipher_maxsize(tfm);
-	if (!outlen)
-		goto error_free_req;
-
-	/* Initialize the output buffer */
-	ret = -ENOMEM;
-	outbuf = kmalloc(outlen, GFP_KERNEL);
-	if (!outbuf)
-		goto error_free_req;
-
-	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&sg_out, outbuf, outlen);
-	akcipher_request_set_crypt(req, &sig_sg, &sg_out, sig->s_size, outlen);
-	init_completion(&compl.completion);
-	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-				      CRYPTO_TFM_REQ_MAY_SLEEP,
-				      public_key_verify_done, &compl);
-
-	ret = crypto_akcipher_verify(req);
-	if (ret == -EINPROGRESS) {
-		wait_for_completion(&compl.completion);
-		ret = compl.err;
-	}
-
-	if (ret)
-		goto error_free_req;
-
-	/* Output from the operation is an encoded message (EM) of
-	 * length k octets.
-	 */
-	outlen = req->dst_len;
-	ret = rsa_verify(sig->digest, outbuf, outlen, sig->digest_size,
-			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
-			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
-error_free_req:
-	akcipher_request_free(req);
-error_free_tfm:
-	crypto_free_akcipher(tfm);
-error_out:
-	kfree(outbuf);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(rsa_verify_signature);
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index a1693ed77be6..80ab099a3edf 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -91,6 +91,4 @@ extern struct key *x509_request_asymmetric_key(struct key *keyring,
 int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig);
 
-int rsa_verify_signature(const struct public_key *pkey,
-			 const struct public_key_signature *sig);
 #endif /* _LINUX_PUBLIC_KEY_H */
diff --git a/init/Kconfig b/init/Kconfig
index 22320804fbaf..af4de4f1b02c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1757,9 +1757,9 @@ config SYSTEM_DATA_VERIFICATION
 	select SYSTEM_TRUSTED_KEYRING
 	select KEYS
 	select CRYPTO
+	select CRYPTO_RSA
 	select ASYMMETRIC_KEY_TYPE
 	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
-	select PUBLIC_KEY_ALGO_RSA
 	select ASN1
 	select OID_REGISTRY
 	select X509_CERTIFICATE_PARSER
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 2fa3bc681a1b..69a92e6db23d 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -103,6 +103,7 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 
 	memset(&pks, 0, sizeof(pks));
 
+	pks.pkey_algo = PKEY_ALGO_RSA;
 	pks.pkey_hash_algo = hdr->hash_algo;
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
