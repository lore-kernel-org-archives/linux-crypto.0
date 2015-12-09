From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/2] crypto: KEYS: convert public key to the akcipher api
Date: Wed, 09 Dec 2015 15:52:32 -0800
Message-ID: <20151209235232.11783.30705.stgit@tstruk-mobl1>
References: <20151209235226.11783.57073.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151209235226.11783.57073.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch converts the module verification code to the new akcipher API.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/asymmetric_keys/Kconfig            |    2 
 crypto/asymmetric_keys/Makefile           |    7 -
 crypto/asymmetric_keys/pkcs7_parser.c     |   12 +-
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 
 crypto/asymmetric_keys/pkcs7_verify.c     |    2 
 crypto/asymmetric_keys/public_key.c       |   64 +++------
 crypto/asymmetric_keys/public_key.h       |   36 -----
 crypto/asymmetric_keys/rsa.c              |  211 +++++++++++------------------
 crypto/asymmetric_keys/x509_cert_parser.c |   37 +----
 crypto/asymmetric_keys/x509_public_key.c  |   17 +-
 crypto/asymmetric_keys/x509_rsakey.asn1   |    4 -
 include/crypto/public_key.h               |   49 ++-----
 12 files changed, 135 insertions(+), 308 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 delete mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 4870f28..905d745 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -22,7 +22,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
-	select MPILIB
+	select CRYPTO_RSA
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index cd1406f..b78a194 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -16,21 +16,18 @@ obj-$(CONFIG_X509_CERTIFICATE_PARSER) += x509_key_parser.o
 x509_key_parser-y := \
 	x509-asn1.o \
 	x509_akid-asn1.o \
-	x509_rsakey-asn1.o \
 	x509_cert_parser.o \
 	x509_public_key.o
 
 $(obj)/x509_cert_parser.o: \
 	$(obj)/x509-asn1.h \
-	$(obj)/x509_akid-asn1.h \
-	$(obj)/x509_rsakey-asn1.h
+	$(obj)/x509_akid-asn1.h
+
 $(obj)/x509-asn1.o: $(obj)/x509-asn1.c $(obj)/x509-asn1.h
 $(obj)/x509_akid-asn1.o: $(obj)/x509_akid-asn1.c $(obj)/x509_akid-asn1.h
-$(obj)/x509_rsakey-asn1.o: $(obj)/x509_rsakey-asn1.c $(obj)/x509_rsakey-asn1.h
 
 clean-files	+= x509-asn1.c x509-asn1.h
 clean-files	+= x509_akid-asn1.c x509_akid-asn1.h
-clean-files	+= x509_rsakey-asn1.c x509_rsakey-asn1.h
 
 #
 # PKCS#7 message handling
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 758acab..12912c1 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 #include "pkcs7-asn1.h"
 
@@ -44,7 +44,7 @@ struct pkcs7_parse_context {
 static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
 {
 	if (sinfo) {
-		mpi_free(sinfo->sig.mpi[0]);
+		kfree(sinfo->sig.s);
 		kfree(sinfo->sig.digest);
 		kfree(sinfo->signing_cert_id);
 		kfree(sinfo);
@@ -616,16 +616,14 @@ int pkcs7_sig_note_signature(void *context, size_t hdrlen,
 			     const void *value, size_t vlen)
 {
 	struct pkcs7_parse_context *ctx = context;
-	MPI mpi;
 
 	BUG_ON(ctx->sinfo->sig.pkey_algo != PKEY_ALGO_RSA);
 
-	mpi = mpi_read_raw_data(value, vlen);
-	if (!mpi)
+	ctx->sinfo->sig.s = kmemdup(value, vlen, GFP_KERNEL);
+	if (!ctx->sinfo->sig.s)
 		return -ENOMEM;
 
-	ctx->sinfo->sig.mpi[0] = mpi;
-	ctx->sinfo->sig.nr_mpi = 1;
+	ctx->sinfo->sig.s_size = vlen;
 	return 0;
 }
 
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 90d6d47..3bbdcc7 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -17,7 +17,7 @@
 #include <linux/asn1.h>
 #include <linux/key.h>
 #include <keys/asymmetric-type.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 
 /**
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 325575c..f5db137 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -16,7 +16,7 @@
 #include <linux/err.h>
 #include <linux/asn1.h>
 #include <crypto/hash.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 
 /*
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 6db4c01..b383629 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -18,24 +18,16 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <keys/asymmetric-subtype.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 
 MODULE_LICENSE("GPL");
 
 const char *const pkey_algo_name[PKEY_ALGO__LAST] = {
-	[PKEY_ALGO_DSA]		= "DSA",
-	[PKEY_ALGO_RSA]		= "RSA",
+	[PKEY_ALGO_DSA]		= "dsa",
+	[PKEY_ALGO_RSA]		= "rsa",
 };
 EXPORT_SYMBOL_GPL(pkey_algo_name);
 
-const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST] = {
-#if defined(CONFIG_PUBLIC_KEY_ALGO_RSA) || \
-	defined(CONFIG_PUBLIC_KEY_ALGO_RSA_MODULE)
-	[PKEY_ALGO_RSA]		= &RSA_public_key_algorithm,
-#endif
-};
-EXPORT_SYMBOL_GPL(pkey_algo);
-
 const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST] = {
 	[PKEY_ID_PGP]		= "PGP",
 	[PKEY_ID_X509]		= "X509",
@@ -43,6 +35,12 @@ const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST] = {
 };
 EXPORT_SYMBOL_GPL(pkey_id_type_name);
 
+static int (*alg_verify[PKEY_ALGO__LAST])(const struct public_key *pkey,
+	const struct public_key_signature *sig) = {
+	NULL,
+	rsa_verify_signature
+};
+
 /*
  * Provide a part of a description of the key for /proc/keys.
  */
@@ -53,7 +51,8 @@ static void public_key_describe(const struct key *asymmetric_key,
 
 	if (key)
 		seq_printf(m, "%s.%s",
-			   pkey_id_type_name[key->id_type], key->algo->name);
+			   pkey_id_type_name[key->id_type],
+			   pkey_algo_name[key->pkey_algo]);
 }
 
 /*
@@ -62,50 +61,31 @@ static void public_key_describe(const struct key *asymmetric_key,
 void public_key_destroy(void *payload)
 {
 	struct public_key *key = payload;
-	int i;
 
-	if (key) {
-		for (i = 0; i < ARRAY_SIZE(key->mpi); i++)
-			mpi_free(key->mpi[i]);
-		kfree(key);
-	}
+	if (key)
+		kfree(key->key);
+	kfree(key);
 }
 EXPORT_SYMBOL_GPL(public_key_destroy);
 
 /*
  * Verify a signature using a public key.
  */
-int public_key_verify_signature(const struct public_key *pk,
+int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig)
 {
-	const struct public_key_algorithm *algo;
-
-	BUG_ON(!pk);
-	BUG_ON(!pk->mpi[0]);
-	BUG_ON(!pk->mpi[1]);
+	BUG_ON(!pkey);
 	BUG_ON(!sig);
 	BUG_ON(!sig->digest);
-	BUG_ON(!sig->mpi[0]);
-
-	algo = pk->algo;
-	if (!algo) {
-		if (pk->pkey_algo >= PKEY_ALGO__LAST)
-			return -ENOPKG;
-		algo = pkey_algo[pk->pkey_algo];
-		if (!algo)
-			return -ENOPKG;
-	}
+	BUG_ON(!sig->s);
 
-	if (!algo->verify_signature)
-		return -ENOTSUPP;
+	if (pkey->pkey_algo >= PKEY_ALGO__LAST)
+		return -ENOPKG;
 
-	if (sig->nr_mpi != algo->n_sig_mpi) {
-		pr_debug("Signature has %u MPI not %u\n",
-			 sig->nr_mpi, algo->n_sig_mpi);
-		return -EINVAL;
-	}
+	if (!alg_verify[pkey->pkey_algo])
+		return -ENOPKG;
 
-	return algo->verify_signature(pk, sig);
+	return alg_verify[pkey->pkey_algo](pkey, sig);
 }
 EXPORT_SYMBOL_GPL(public_key_verify_signature);
 
diff --git a/crypto/asymmetric_keys/public_key.h b/crypto/asymmetric_keys/public_key.h
deleted file mode 100644
index 5c37a22..0000000
--- a/crypto/asymmetric_keys/public_key.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/* Public key algorithm internals
- *
- * See Documentation/crypto/asymmetric-keys.txt
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
-#include <crypto/public_key.h>
-
-extern struct asymmetric_key_subtype public_key_subtype;
-
-/*
- * Public key algorithm definition.
- */
-struct public_key_algorithm {
-	const char	*name;
-	u8		n_pub_mpi;	/* Number of MPIs in public key */
-	u8		n_sec_mpi;	/* Number of MPIs in secret key */
-	u8		n_sig_mpi;	/* Number of MPIs in a signature */
-	int (*verify_signature)(const struct public_key *key,
-				const struct public_key_signature *sig);
-};
-
-extern const struct public_key_algorithm RSA_public_key_algorithm;
-
-/*
- * public_key.c
- */
-extern int public_key_verify_signature(const struct public_key *pk,
-				       const struct public_key_signature *sig);
diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 508b57b..e97013db 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -11,10 +11,10 @@
 
 #define pr_fmt(fmt) "RSA: "fmt
 #include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/slab.h>
+#include <crypto/akcipher.h>
+#include <crypto/public_key.h>
 #include <crypto/algapi.h>
-#include "public_key.h"
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RSA Public Key Algorithm");
@@ -84,72 +84,10 @@ static const struct {
 #undef _
 };
 
-/*
- * RSAVP1() function [RFC3447 sec 5.2.2]
- */
-static int RSAVP1(const struct public_key *key, MPI s, MPI *_m)
-{
-	MPI m;
-	int ret;
-
-	/* (1) Validate 0 <= s < n */
-	if (mpi_cmp_ui(s, 0) < 0) {
-		kleave(" = -EBADMSG [s < 0]");
-		return -EBADMSG;
-	}
-	if (mpi_cmp(s, key->rsa.n) >= 0) {
-		kleave(" = -EBADMSG [s >= n]");
-		return -EBADMSG;
-	}
-
-	m = mpi_alloc(0);
-	if (!m)
-		return -ENOMEM;
-
-	/* (2) m = s^e mod n */
-	ret = mpi_powm(m, s, key->rsa.e, key->rsa.n);
-	if (ret < 0) {
-		mpi_free(m);
-		return ret;
-	}
-
-	*_m = m;
-	return 0;
-}
-
-/*
- * Integer to Octet String conversion [RFC3447 sec 4.1]
- */
-static int RSA_I2OSP(MPI x, size_t xLen, u8 **pX)
-{
-	unsigned X_size, x_size;
-	int X_sign;
-	u8 *X;
-
-	/* Make sure the string is the right length.  The number should begin
-	 * with { 0x00, 0x01, ... } so we have to account for 15 leading zero
-	 * bits not being reported by MPI.
-	 */
-	x_size = mpi_get_nbits(x);
-	pr_devel("size(x)=%u xLen*8=%zu\n", x_size, xLen * 8);
-	if (x_size != xLen * 8 - 15)
-		return -ERANGE;
-
-	X = mpi_get_buffer(x, &X_size, &X_sign);
-	if (!X)
-		return -ENOMEM;
-	if (X_sign < 0) {
-		kfree(X);
-		return -EBADMSG;
-	}
-	if (X_size != xLen - 1) {
-		kfree(X);
-		return -EBADMSG;
-	}
-
-	*pX = X;
-	return 0;
-}
+struct rsa_completion {
+	struct completion completion;
+	int err;
+};
 
 /*
  * Perform the RSA signature verification.
@@ -160,7 +98,7 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **pX)
  * @asn1_template: The DigestInfo ASN.1 template
  * @asn1_size: Size of asm1_template[]
  */
-static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
+static int rsa_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
 		      const u8 *asn1_template, size_t asn1_size)
 {
 	unsigned PS_end, T_offset, i;
@@ -169,9 +107,9 @@ static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
 
 	if (k < 2 + 1 + asn1_size + hash_size)
 		return -EBADMSG;
-
-	/* Decode the EMSA-PKCS1-v1_5 */
-	if (EM[1] != 0x01) {
+	/* Decode the EMSA-PKCS1-v1_5
+	 * note: leading zeros are stirpped by the RSA implementation */
+	if (EM[0] != 0x01) {
 		kleave(" = -EBADMSG [EM[1] == %02u]", EM[1]);
 		return -EBADMSG;
 	}
@@ -183,7 +121,7 @@ static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
 		return -EBADMSG;
 	}
 
-	for (i = 2; i < PS_end; i++) {
+	for (i = 1; i < PS_end; i++) {
 		if (EM[i] != 0xff) {
 			kleave(" = -EBADMSG [EM[PS%x] == %02u]", i - 2, EM[i]);
 			return -EBADMSG;
@@ -204,75 +142,82 @@ static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
 	return 0;
 }
 
-/*
- * Perform the verification step [RFC3447 sec 8.2.2].
- */
-static int RSA_verify_signature(const struct public_key *key,
-				const struct public_key_signature *sig)
+static void public_key_verify_done(struct crypto_async_request *req, int err)
 {
-	size_t tsize;
-	int ret;
+	struct rsa_completion *compl = req->data;
 
-	/* Variables as per RFC3447 sec 8.2.2 */
-	const u8 *H = sig->digest;
-	u8 *EM = NULL;
-	MPI m = NULL;
-	size_t k;
+	if (err == -EINPROGRESS)
+		return;
 
-	kenter("");
-
-	if (!RSA_ASN1_templates[sig->pkey_hash_algo].data)
-		return -ENOTSUPP;
-
-	/* (1) Check the signature size against the public key modulus size */
-	k = mpi_get_nbits(key->rsa.n);
-	tsize = mpi_get_nbits(sig->rsa.s);
+	compl->err = err;
+	complete(&compl->completion);
+}
 
-	/* According to RFC 4880 sec 3.2, length of MPI is computed starting
-	 * from most significant bit.  So the RFC 3447 sec 8.2.2 size check
-	 * must be relaxed to conform with shorter signatures - so we fail here
-	 * only if signature length is longer than modulus size.
-	 */
-	pr_devel("step 1: k=%zu size(S)=%zu\n", k, tsize);
-	if (k < tsize) {
-		ret = -EBADMSG;
-		goto error;
+int rsa_verify_signature(const struct public_key *pkey,
+			 const struct public_key_signature *sig)
+{
+	struct crypto_akcipher *tfm;
+	struct akcipher_request *req;
+	struct rsa_completion compl;
+	struct scatterlist sig_sg, sg_out;
+	void *outbuf = NULL;
+	unsigned int outlen = 0;
+	int ret = -ENOMEM;
+
+	tfm = crypto_alloc_akcipher("rsa", 0, 0);
+	if (IS_ERR(tfm))
+		goto error_out;
+
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		goto error_free_tfm;
+
+	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
+	if (ret)
+		goto error_free_req;
+
+	ret = -EINVAL;
+	outlen = crypto_akcipher_maxsize(tfm);
+	if (!outlen)
+		goto error_free_req;
+
+	/* initlialzie out buf */
+	ret = -ENOMEM;
+	outbuf = kmalloc(outlen, GFP_KERNEL);
+	if (!outbuf)
+		goto error_free_req;
+
+	sg_init_one(&sig_sg, sig->s, sig->s_size);
+	sg_init_one(&sg_out, outbuf, outlen);
+	akcipher_request_set_crypt(req, &sig_sg, &sg_out, sig->s_size, outlen);
+	init_completion(&compl.completion);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      public_key_verify_done, &compl);
+
+	ret = crypto_akcipher_verify(req);
+	if (ret == -EINPROGRESS) {
+		wait_for_completion(&compl.completion);
+		ret = compl.err;
 	}
 
-	/* Round up and convert to octets */
-	k = (k + 7) / 8;
+	if (ret)
+		goto error_free_req;
 
-	/* (2b) Apply the RSAVP1 verification primitive to the public key */
-	ret = RSAVP1(key, sig->rsa.s, &m);
-	if (ret < 0)
-		goto error;
-
-	/* (2c) Convert the message representative (m) to an encoded message
-	 *      (EM) of length k octets.
-	 *
-	 *      NOTE!  The leading zero byte is suppressed by MPI, so we pass a
-	 *      pointer to the _preceding_ byte to RSA_verify()!
+	/*
+	 * Output from the operation is an encoded message (EM) of
+	 * length k octets.
 	 */
-	ret = RSA_I2OSP(m, k, &EM);
-	if (ret < 0)
-		goto error;
-
-	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
+	outlen = req->dst_len;
+	ret = rsa_verify(sig->digest, outbuf, outlen, sig->digest_size,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
-
-error:
-	kfree(EM);
-	mpi_free(m);
-	kleave(" = %d", ret);
+error_free_req:
+	akcipher_request_free(req);
+error_free_tfm:
+	crypto_free_akcipher(tfm);
+error_out:
+	kfree(outbuf);
 	return ret;
 }
-
-const struct public_key_algorithm RSA_public_key_algorithm = {
-	.name		= "RSA",
-	.n_pub_mpi	= 2,
-	.n_sec_mpi	= 3,
-	.n_sig_mpi	= 1,
-	.verify_signature = RSA_verify_signature,
-};
-EXPORT_SYMBOL_GPL(RSA_public_key_algorithm);
+EXPORT_SYMBOL_GPL(rsa_verify_signature);
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 021d39c..7502029 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -15,11 +15,10 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "x509_parser.h"
 #include "x509-asn1.h"
 #include "x509_akid-asn1.h"
-#include "x509_rsakey-asn1.h"
 
 struct x509_parse_context {
 	struct x509_certificate	*cert;		/* Certificate being constructed */
@@ -56,7 +55,7 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert->akid_id);
 		kfree(cert->akid_skid);
 		kfree(cert->sig.digest);
-		mpi_free(cert->sig.rsa.s);
+		kfree(cert->sig.s);
 		kfree(cert);
 	}
 }
@@ -103,12 +102,12 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 		}
 	}
 
-	/* Decode the public key */
-	ret = asn1_ber_decoder(&x509_rsakey_decoder, ctx,
-			       ctx->key, ctx->key_size);
-	if (ret < 0)
+	cert->pub->key = kmemdup(ctx->key, ctx->key_size, GFP_KERNEL);
+	if (!cert->pub->key)
 		goto error_decode;
 
+	cert->pub->keylen = ctx->key_size;
+
 	/* Generate cert issuer + serial number key ID */
 	kid = asymmetric_key_generate_id(cert->raw_serial,
 					 cert->raw_serial_size,
@@ -124,6 +123,7 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	return cert;
 
 error_decode:
+	kfree(cert->pub->key);
 	kfree(ctx);
 error_no_ctx:
 	x509_free_certificate(cert);
@@ -404,29 +404,6 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 	return 0;
 }
 
-/*
- * Extract a RSA public key value
- */
-int rsa_extract_mpi(void *context, size_t hdrlen,
-		    unsigned char tag,
-		    const void *value, size_t vlen)
-{
-	struct x509_parse_context *ctx = context;
-	MPI mpi;
-
-	if (ctx->nr_mpi >= ARRAY_SIZE(ctx->cert->pub->mpi)) {
-		pr_err("Too many public key MPIs in certificate\n");
-		return -EBADMSG;
-	}
-
-	mpi = mpi_read_raw_data(value, vlen);
-	if (!mpi)
-		return -ENOMEM;
-
-	ctx->cert->pub->mpi[ctx->nr_mpi++] = mpi;
-	return 0;
-}
-
 /* The keyIdentifier in AuthorityKeyIdentifier SEQUENCE is tag(CONT,PRIM,0) */
 #define SEQ_TAG_KEYID (ASN1_CONT << 6)
 
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 2a44b37..2e18dfc 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -13,15 +13,11 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/err.h>
-#include <linux/mpi.h>
-#include <linux/asn1_decoder.h>
 #include <keys/asymmetric-subtype.h>
 #include <keys/asymmetric-parser.h>
 #include <keys/system_keyring.h>
 #include <crypto/hash.h>
 #include "asymmetric_keys.h"
-#include "public_key.h"
 #include "x509_parser.h"
 
 static bool use_builtin_keys;
@@ -167,13 +163,15 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	if (cert->unsupported_crypto)
 		return -ENOPKG;
-	if (cert->sig.rsa.s)
+	if (cert->sig.s)
 		return 0;
 
-	cert->sig.rsa.s = mpi_read_raw_data(cert->raw_sig, cert->raw_sig_size);
-	if (!cert->sig.rsa.s)
+	cert->sig.s = kmemdup(cert->raw_sig, cert->raw_sig_size,
+			      GFP_KERNEL);
+	if (!cert->sig.s)
 		return -ENOMEM;
-	cert->sig.nr_mpi = 1;
+
+	cert->sig.s_size = cert->raw_sig_size;
 
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
@@ -296,8 +294,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !pkey_algo[cert->pub->pkey_algo] ||
-	    !pkey_algo[cert->sig.pkey_algo] ||
 	    !hash_algo_name[cert->sig.pkey_hash_algo]) {
 		ret = -ENOPKG;
 		goto error_free_cert;
@@ -309,7 +305,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 pkey_algo_name[cert->sig.pkey_algo],
 		 hash_algo_name[cert->sig.pkey_hash_algo]);
 
-	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
diff --git a/crypto/asymmetric_keys/x509_rsakey.asn1 b/crypto/asymmetric_keys/x509_rsakey.asn1
deleted file mode 100644
index 4ec7cc6..0000000
--- a/crypto/asymmetric_keys/x509_rsakey.asn1
+++ /dev/null
@@ -1,4 +0,0 @@
-RSAPublicKey ::= SEQUENCE {
-	modulus			INTEGER ({ rsa_extract_mpi }),	-- n
-	publicExponent		INTEGER ({ rsa_extract_mpi })	-- e
-	}
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index cc2516d..33bafba 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_PUBLIC_KEY_H
 #define _LINUX_PUBLIC_KEY_H
 
-#include <linux/mpi.h>
+#include <keys/asymmetric-type.h>
 #include <crypto/hash_info.h>
 
 enum pkey_algo {
@@ -24,7 +24,6 @@ enum pkey_algo {
 };
 
 extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
-extern const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST];
 
 /* asymmetric key implementation supports only up to SHA224 */
 #define PKEY_HASH__LAST		(HASH_ALGO_SHA224 + 1)
@@ -59,31 +58,10 @@ extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
  * part.
  */
 struct public_key {
-	const struct public_key_algorithm *algo;
-	u8	capabilities;
-#define PKEY_CAN_ENCRYPT	0x01
-#define PKEY_CAN_DECRYPT	0x02
-#define PKEY_CAN_SIGN		0x04
-#define PKEY_CAN_VERIFY		0x08
+	void *key;
+	u32 keylen;
 	enum pkey_algo pkey_algo : 8;
 	enum pkey_id_type id_type : 8;
-	union {
-		MPI	mpi[5];
-		struct {
-			MPI	p;	/* DSA prime */
-			MPI	q;	/* DSA group order */
-			MPI	g;	/* DSA group generator */
-			MPI	y;	/* DSA public-key value = g^x mod p */
-			MPI	x;	/* DSA secret exponent (if present) */
-		} dsa;
-		struct {
-			MPI	n;	/* RSA public modulus */
-			MPI	e;	/* RSA public encryption exponent */
-			MPI	d;	/* RSA secret encryption exponent (if present) */
-			MPI	p;	/* RSA secret prime (if present) */
-			MPI	q;	/* RSA secret prime (if present) */
-		} rsa;
-	};
 };
 
 extern void public_key_destroy(void *payload);
@@ -92,23 +70,15 @@ extern void public_key_destroy(void *payload);
  * Public key cryptography signature data
  */
 struct public_key_signature {
+	u8 *s;			/* Signature */
+	u32 s_size;		/* Number of bytes in signature */
 	u8 *digest;
-	u8 digest_size;			/* Number of bytes in digest */
-	u8 nr_mpi;			/* Occupancy of mpi[] */
+	u8 digest_size;		/* Number of bytes in digest */
 	enum pkey_algo pkey_algo : 8;
 	enum hash_algo pkey_hash_algo : 8;
-	union {
-		MPI mpi[2];
-		struct {
-			MPI s;		/* m^d mod n */
-		} rsa;
-		struct {
-			MPI r;
-			MPI s;
-		} dsa;
-	};
 };
 
+extern struct asymmetric_key_subtype public_key_subtype;
 struct key;
 extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
@@ -119,4 +89,9 @@ extern struct key *x509_request_asymmetric_key(struct key *keyring,
 					       const struct asymmetric_key_id *skid,
 					       bool partial);
 
+int public_key_verify_signature(const struct public_key *pkey,
+				const struct public_key_signature *sig);
+
+int rsa_verify_signature(const struct public_key *pkey,
+			 const struct public_key_signature *sig);
 #endif /* _LINUX_PUBLIC_KEY_H */
