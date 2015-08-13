From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/2] crypto: KEYS: convert public key to the akcipher API
Date: Wed, 12 Aug 2015 20:54:39 -0700
Message-ID: <20150813035439.25108.62457.stgit@tstruk-mobl1>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, tadeusz.struk@intel.com, steved@redhat.com,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150813035433.25108.3065.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch converts the module verification code to the new akcipher API.
RSA implementation from crypto/asymmetric_keys has been removed and the
new API is used for cryptographic primitives. The signature verification
has been moved into a new crypto/asymmetric_keys/rsa_pkcs1_v1_5.c file.
There is no need for MPI above the API anymore.
Modules can be verified with software as well as HW rsa implementations.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/asymmetric_keys/Kconfig            |    2 
 crypto/asymmetric_keys/Makefile           |    7 -
 crypto/asymmetric_keys/pkcs7_parser.c     |   12 +
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 
 crypto/asymmetric_keys/pkcs7_verify.c     |    2 
 crypto/asymmetric_keys/public_key.c       |   59 ++----
 crypto/asymmetric_keys/public_key.h       |   36 ----
 crypto/asymmetric_keys/rsa.c              |  278 -----------------------------
 crypto/asymmetric_keys/rsa_pkcs1_v1_5.c   |  229 ++++++++++++++++++++++++
 crypto/asymmetric_keys/x509_cert_parser.c |   37 +---
 crypto/asymmetric_keys/x509_public_key.c  |   17 +-
 crypto/asymmetric_keys/x509_rsakey.asn1   |    4 
 include/crypto/public_key.h               |   48 +----
 kernel/module_signing.c                   |   56 ++----
 security/integrity/digsig_asymmetric.c    |   11 -
 15 files changed, 301 insertions(+), 499 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 delete mode 100644 crypto/asymmetric_keys/rsa.c
 create mode 100644 crypto/asymmetric_keys/rsa_pkcs1_v1_5.c
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
index e47fcd9..895d8ca 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
 asymmetric_keys-y := asymmetric_type.o signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
-obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
+obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa_pkcs1_v1_5.o
 
 #
 # X.509 Certificate handling
@@ -15,16 +15,13 @@ obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
 obj-$(CONFIG_X509_CERTIFICATE_PARSER) += x509_key_parser.o
 x509_key_parser-y := \
 	x509-asn1.o \
-	x509_rsakey-asn1.o \
 	x509_cert_parser.o \
 	x509_public_key.o
 
-$(obj)/x509_cert_parser.o: $(obj)/x509-asn1.h $(obj)/x509_rsakey-asn1.h
+$(obj)/x509_cert_parser.o: $(obj)/x509-asn1.h
 $(obj)/x509-asn1.o: $(obj)/x509-asn1.c $(obj)/x509-asn1.h
-$(obj)/x509_rsakey-asn1.o: $(obj)/x509_rsakey-asn1.c $(obj)/x509_rsakey-asn1.h
 
 clean-files	+= x509-asn1.c x509-asn1.h
-clean-files	+= x509_rsakey-asn1.c x509_rsakey-asn1.h
 
 #
 # PKCS#7 message handling
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3bd5a1e..8e3597a 100644
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
 
@@ -41,7 +41,7 @@ struct pkcs7_parse_context {
 static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
 {
 	if (sinfo) {
-		mpi_free(sinfo->sig.mpi[0]);
+		kfree(sinfo->sig.s);
 		kfree(sinfo->sig.digest);
 		kfree(sinfo->signing_cert_id);
 		kfree(sinfo);
@@ -374,16 +374,14 @@ int pkcs7_sig_note_signature(void *context, size_t hdrlen,
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
index 1d29376..68ebae2 100644
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
index cd45545..c32a337 100644
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
index 2f6e4fb..fb6bdec 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -18,24 +18,17 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <keys/asymmetric-subtype.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
+#include <crypto/akcipher.h>
 
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
@@ -52,7 +45,8 @@ static void public_key_describe(const struct key *asymmetric_key,
 
 	if (key)
 		seq_printf(m, "%s.%s",
-			   pkey_id_type_name[key->id_type], key->algo->name);
+			   pkey_id_type_name[key->id_type],
+			   pkey_algo_name[key->pkey_algo]);
 }
 
 /*
@@ -61,50 +55,28 @@ static void public_key_describe(const struct key *asymmetric_key,
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
+	BUG_ON(!sig->s);
 
-	algo = pk->algo;
-	if (!algo) {
-		if (pk->pkey_algo >= PKEY_ALGO__LAST)
-			return -ENOPKG;
-		algo = pkey_algo[pk->pkey_algo];
-		if (!algo)
-			return -ENOPKG;
-	}
+	if (pkey->pkey_algo != PKEY_ALGO_RSA)
+		return -ENOPKG;
 
-	if (!algo->verify_signature)
-		return -ENOTSUPP;
-
-	if (sig->nr_mpi != algo->n_sig_mpi) {
-		pr_debug("Signature has %u MPI not %u\n",
-			 sig->nr_mpi, algo->n_sig_mpi);
-		return -EINVAL;
-	}
-
-	return algo->verify_signature(pk, sig);
+	return rsa_pkcs1_v1_5_verify_signature(pkey, sig);
 }
 EXPORT_SYMBOL_GPL(public_key_verify_signature);
 
@@ -112,6 +84,7 @@ static int public_key_verify_signature_2(const struct key *key,
 					 const struct public_key_signature *sig)
 {
 	const struct public_key *pk = key->payload.data;
+
 	return public_key_verify_signature(pk, sig);
 }
 
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
deleted file mode 100644
index 508b57b..0000000
--- a/crypto/asymmetric_keys/rsa.c
+++ /dev/null
@@ -1,278 +0,0 @@
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
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <crypto/algapi.h>
-#include "public_key.h"
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
-static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
-		      const u8 *asn1_template, size_t asn1_size)
-{
-	unsigned PS_end, T_offset, i;
-
-	kenter(",,%zu,%zu,%zu", k, hash_size, asn1_size);
-
-	if (k < 2 + 1 + asn1_size + hash_size)
-		return -EBADMSG;
-
-	/* Decode the EMSA-PKCS1-v1_5 */
-	if (EM[1] != 0x01) {
-		kleave(" = -EBADMSG [EM[1] == %02u]", EM[1]);
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
-	for (i = 2; i < PS_end; i++) {
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
-/*
- * Perform the verification step [RFC3447 sec 8.2.2].
- */
-static int RSA_verify_signature(const struct public_key *key,
-				const struct public_key_signature *sig)
-{
-	size_t tsize;
-	int ret;
-
-	/* Variables as per RFC3447 sec 8.2.2 */
-	const u8 *H = sig->digest;
-	u8 *EM = NULL;
-	MPI m = NULL;
-	size_t k;
-
-	kenter("");
-
-	if (!RSA_ASN1_templates[sig->pkey_hash_algo].data)
-		return -ENOTSUPP;
-
-	/* (1) Check the signature size against the public key modulus size */
-	k = mpi_get_nbits(key->rsa.n);
-	tsize = mpi_get_nbits(sig->rsa.s);
-
-	/* According to RFC 4880 sec 3.2, length of MPI is computed starting
-	 * from most significant bit.  So the RFC 3447 sec 8.2.2 size check
-	 * must be relaxed to conform with shorter signatures - so we fail here
-	 * only if signature length is longer than modulus size.
-	 */
-	pr_devel("step 1: k=%zu size(S)=%zu\n", k, tsize);
-	if (k < tsize) {
-		ret = -EBADMSG;
-		goto error;
-	}
-
-	/* Round up and convert to octets */
-	k = (k + 7) / 8;
-
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
-	 */
-	ret = RSA_I2OSP(m, k, &EM);
-	if (ret < 0)
-		goto error;
-
-	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
-			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
-			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
-
-error:
-	kfree(EM);
-	mpi_free(m);
-	kleave(" = %d", ret);
-	return ret;
-}
-
-const struct public_key_algorithm RSA_public_key_algorithm = {
-	.name		= "RSA",
-	.n_pub_mpi	= 2,
-	.n_sec_mpi	= 3,
-	.n_sig_mpi	= 1,
-	.verify_signature = RSA_verify_signature,
-};
-EXPORT_SYMBOL_GPL(RSA_public_key_algorithm);
diff --git a/crypto/asymmetric_keys/rsa_pkcs1_v1_5.c b/crypto/asymmetric_keys/rsa_pkcs1_v1_5.c
new file mode 100644
index 0000000..6c138bf
--- /dev/null
+++ b/crypto/asymmetric_keys/rsa_pkcs1_v1_5.c
@@ -0,0 +1,229 @@
+/* RSA asymmetric public-key algorithm [RFC3447]
+ * RSA encryption schemes part
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Converted to akcipher crypto API
+ * Tadeusz Struk <tadeusz.struk@intel.com>
+ * Copyright (c) 2015, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "PKEY: "fmt
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <crypto/public_key.h>
+#include <crypto/akcipher.h>
+#include <crypto/algapi.h>
+
+#define kenter(FMT, ...) \
+	pr_devel("==> %s(" FMT ")\n", __func__, ## __VA_ARGS__)
+#define kleave(FMT, ...) \
+	pr_devel("<== %s()" FMT "\n", __func__, ## __VA_ARGS__)
+
+/*
+ * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
+ */
+static const u8 RSA_digest_info_MD5[] = {
+	0x30, 0x20, 0x30, 0x0C, 0x06, 0x08,
+	0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x02, 0x05, /* OID */
+	0x05, 0x00, 0x04, 0x10
+};
+
+static const u8 RSA_digest_info_SHA1[] = {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2B, 0x0E, 0x03, 0x02, 0x1A,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 RSA_digest_info_RIPE_MD_160[] = {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2B, 0x24, 0x03, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 RSA_digest_info_SHA224[] = {
+	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
+	0x05, 0x00, 0x04, 0x1C
+};
+
+static const u8 RSA_digest_info_SHA256[] = {
+	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x20
+};
+
+static const u8 RSA_digest_info_SHA384[] = {
+	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
+	0x05, 0x00, 0x04, 0x30
+};
+
+static const u8 RSA_digest_info_SHA512[] = {
+	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
+	0x05, 0x00, 0x04, 0x40
+};
+
+static const struct {
+	const u8 *data;
+	size_t size;
+} RSA_ASN1_templates[PKEY_HASH__LAST] = {
+#define _(X) { RSA_digest_info_##X, sizeof(RSA_digest_info_##X) }
+	[HASH_ALGO_MD5]		= _(MD5),
+	[HASH_ALGO_SHA1]	= _(SHA1),
+	[HASH_ALGO_RIPE_MD_160]	= _(RIPE_MD_160),
+	[HASH_ALGO_SHA256]	= _(SHA256),
+	[HASH_ALGO_SHA384]	= _(SHA384),
+	[HASH_ALGO_SHA512]	= _(SHA512),
+	[HASH_ALGO_SHA224]	= _(SHA224),
+#undef _
+};
+
+struct rsa_completion {
+	struct completion completion;
+	int err;
+};
+
+/*
+ * Perform the RSA signature verification.
+ * @H: Value of hash of data and metadata
+ * @EM: The computed signature value
+ * @k: The size of EM (EM[0] is an invalid location but should hold 0x00)
+ * @hash_size: The size of H
+ * @asn1_template: The DigestInfo ASN.1 template
+ * @asn1_size: Size of asm1_template[]
+ */
+static int rsa_signture_verify(const u8 *H, const u8 *EM, size_t k,
+			       size_t hash_size, const u8 *asn1_template,
+			       size_t asn1_size)
+{
+	unsigned PS_end, T_offset, i;
+
+	kenter(",,%zu,%zu,%zu", k, hash_size, asn1_size);
+
+	if (k < 2 + 1 + asn1_size + hash_size)
+		return -EBADMSG;
+	/* Decode the EMSA-PKCS1-v1_5 */
+	if (EM[0] != 0x00 || EM[1] != 0x01) {
+		kleave(" = -EBADMSG [EM[1] == %02u]", EM[1]);
+		return -EBADMSG;
+	}
+
+	T_offset = k - (asn1_size + hash_size);
+	PS_end = T_offset - 1;
+	if (EM[PS_end] != 0x00) {
+		kleave(" = -EBADMSG [EM[T-1] == %02u]", EM[PS_end]);
+		return -EBADMSG;
+	}
+
+	for (i = 2; i < PS_end; i++) {
+		if (EM[i] != 0xff) {
+			kleave(" = -EBADMSG [EM[PS%x] == %02u]", i - 2, EM[i]);
+			return -EBADMSG;
+		}
+	}
+
+	if (crypto_memneq(asn1_template, EM + T_offset, asn1_size) != 0) {
+		kleave(" = -EBADMSG [EM[T] ASN.1 mismatch]");
+		return -EBADMSG;
+	}
+
+	if (crypto_memneq(H, EM + T_offset + asn1_size, hash_size) != 0) {
+		kleave(" = -EKEYREJECTED [EM[T] hash mismatch]");
+		return -EKEYREJECTED;
+	}
+	kleave(" = 0");
+	return 0;
+}
+
+static void public_key_verify_done(struct crypto_async_request *req, int err)
+{
+	struct rsa_completion *compl = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	compl->err = err;
+	complete(&compl->completion);
+}
+
+/*
+ * Perform the verification step [RFC3447 sec 8.2.2].
+ */
+int rsa_pkcs1_v1_5_verify_signature(const struct public_key *pkey,
+				    const struct public_key_signature *sig)
+{
+	struct crypto_akcipher *tfm;
+	struct akcipher_request *req;
+	struct rsa_completion compl;
+	void *outbuf = NULL;
+	unsigned int outlen = 0;
+	int ret = -ENOMEM;
+
+	kenter("");
+	tfm = crypto_alloc_akcipher("rsa", 0, 0);
+	if (IS_ERR(tfm))
+		goto error_out;
+
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		goto error_free_tfm;
+
+	ret = crypto_akcipher_setkey(tfm, pkey->key, pkey->keylen);
+	if (ret)
+		goto error_free_req;
+
+	akcipher_request_set_crypt(req, sig->s, outbuf, sig->s_size, outlen);
+
+	/* expect this to fail, and update the required buf len */
+	ret = -EINVAL;
+	crypto_akcipher_verify(req);
+	outlen = req->dst_len;
+	if (!outlen)
+		goto error_free_req;
+
+	/* initlialzie out buf */
+	ret = -ENOMEM;
+	outbuf = kmalloc(outlen, GFP_KERNEL);
+	if (!outbuf)
+		goto error_free_req;
+
+	akcipher_request_set_crypt(req, sig->s, outbuf, sig->s_size, outlen);
+	init_completion(&compl.completion);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      public_key_verify_done, &compl);
+
+	ret = crypto_akcipher_verify(req);
+	if (ret == -EINPROGRESS) {
+		wait_for_completion(&compl.completion);
+		ret = compl.err;
+	}
+
+	if (ret)
+		goto error_free_req;
+
+	/*
+	 * Output from the operation is an encoded message (EM) of
+	 * length k octets.
+	 */
+	ret = rsa_signture_verify(sig->digest, outbuf, outlen, sig->digest_size,
+				  RSA_ASN1_templates[sig->pkey_hash_algo].data,
+				  RSA_ASN1_templates[sig->pkey_hash_algo].size);
+
+error_free_req:
+	akcipher_request_free(req);
+error_free_tfm:
+	crypto_free_akcipher(tfm);
+error_out:
+	kfree(outbuf);
+	kleave(" = %d", ret);
+	return ret;
+}
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index a668d90..c8ac014 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -15,10 +15,9 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "x509_parser.h"
 #include "x509-asn1.h"
-#include "x509_rsakey-asn1.h"
 
 struct x509_parse_context {
 	struct x509_certificate	*cert;		/* Certificate being constructed */
@@ -50,7 +49,7 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert->skid);
 		kfree(cert->authority);
 		kfree(cert->sig.digest);
-		mpi_free(cert->sig.rsa.s);
+		kfree(cert->sig.s);
 		kfree(cert);
 	}
 }
@@ -85,12 +84,12 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	if (ret < 0)
 		goto error_decode;
 
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
@@ -106,6 +105,7 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	return cert;
 
 error_decode:
+	kfree(cert->pub->key);
 	kfree(ctx);
 error_no_ctx:
 	x509_free_certificate(cert);
@@ -386,29 +386,6 @@ int x509_extract_key_data(void *context, size_t hdrlen,
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
index 24f17e6..12df4e4 100644
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
@@ -137,13 +133,15 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
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
@@ -263,8 +261,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !pkey_algo[cert->pub->pkey_algo] ||
-	    !pkey_algo[cert->sig.pkey_algo] ||
 	    !hash_algo_name[cert->sig.pkey_hash_algo]) {
 		ret = -ENOPKG;
 		goto error_free_cert;
@@ -283,7 +279,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
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
index 54add20..f9ed8e0 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -14,7 +14,6 @@
 #ifndef _LINUX_PUBLIC_KEY_H
 #define _LINUX_PUBLIC_KEY_H
 
-#include <linux/mpi.h>
 #include <keys/asymmetric-type.h>
 #include <crypto/hash_info.h>
 
@@ -25,7 +24,6 @@ enum pkey_algo {
 };
 
 extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
-extern const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST];
 
 /* asymmetric key implementation supports only up to SHA224 */
 #define PKEY_HASH__LAST		(HASH_ALGO_SHA224 + 1)
@@ -45,31 +43,10 @@ extern const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST];
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
@@ -78,23 +55,15 @@ extern void public_key_destroy(void *payload);
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
@@ -104,4 +73,9 @@ extern struct key *x509_request_asymmetric_key(struct key *keyring,
 					       const struct asymmetric_key_id *kid,
 					       bool partial);
 
+int public_key_verify_signature(const struct public_key *pkey,
+				const struct public_key_signature *sig);
+
+int rsa_pkcs1_v1_5_verify_signature(const struct public_key *pkey,
+				    const struct public_key_signature *sig);
 #endif /* _LINUX_PUBLIC_KEY_H */
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index be5b8fa..8df0971 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -99,35 +99,6 @@ error_no_pks:
 }
 
 /*
- * Extract an MPI array from the signature data.  This represents the actual
- * signature.  Each raw MPI is prefaced by a BE 2-byte value indicating the
- * size of the MPI in bytes.
- *
- * RSA signatures only have one MPI, so currently we only read one.
- */
-static int mod_extract_mpi_array(struct public_key_signature *pks,
-				 const void *data, size_t len)
-{
-	size_t nbytes;
-	MPI mpi;
-
-	if (len < 3)
-		return -EBADMSG;
-	nbytes = ((const u8 *)data)[0] << 8 | ((const u8 *)data)[1];
-	data += 2;
-	len -= 2;
-	if (len != nbytes)
-		return -EBADMSG;
-
-	mpi = mpi_read_raw_data(data, nbytes);
-	if (!mpi)
-		return -ENOMEM;
-	pks->mpi[0] = mpi;
-	pks->nr_mpi = 1;
-	return 0;
-}
-
-/*
  * Request an asymmetric key.
  */
 static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
@@ -190,7 +161,7 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 	struct module_signature ms;
 	struct key *key;
 	const void *sig;
-	size_t modlen = *_modlen, sig_len;
+	size_t modlen = *_modlen, sig_len, len_bytes;
 	int ret;
 
 	pr_devel("==>%s(,%zu)\n", __func__, modlen);
@@ -202,8 +173,10 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 	modlen -= sizeof(ms);
 
 	sig_len = be32_to_cpu(ms.sig_len);
-	if (sig_len >= modlen)
+
+	if (sig_len >= modlen || sig_len < 3)
 		return -EBADMSG;
+
 	modlen -= sig_len;
 	if ((size_t)ms.signer_len + ms.key_id_len >= modlen)
 		return -EBADMSG;
@@ -232,19 +205,28 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		goto error_put_key;
 	}
 
-	ret = mod_extract_mpi_array(pks, sig + ms.signer_len + ms.key_id_len,
-				    sig_len);
-	if (ret < 0)
+	sig = sig + ms.signer_len + ms.key_id_len;
+	len_bytes = ((const u8 *)sig)[0] << 8 | ((const u8 *)sig)[1];
+
+	if (sig_len - 2 != len_bytes) {
+		ret = -EBADMSG;
 		goto error_free_pks;
+	}
+	sig += 2;
+	pks->s = kmemdup(sig, len_bytes, GFP_KERNEL);
+	if (!pks->s) {
+		ret = -ENOMEM;
+		goto error_free_pks;
+	}
+	pks->s_size = len_bytes;
 
 	ret = verify_signature(key, pks);
 	pr_devel("verify_signature() = %d\n", ret);
-
+	kfree(pks->s);
 error_free_pks:
-	mpi_free(pks->rsa.s);
 	kfree(pks);
 error_put_key:
 	key_put(key);
 	pr_devel("<==%s() = %d\n", __func__, ret);
-	return ret;	
+	return ret;
 }
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 4fec181..030a7da 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -88,17 +88,12 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 		return PTR_ERR(key);
 
 	memset(&pks, 0, sizeof(pks));
-
 	pks.pkey_hash_algo = hdr->hash_algo;
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
-	pks.nr_mpi = 1;
-	pks.rsa.s = mpi_read_raw_data(hdr->sig, siglen);
-
-	if (pks.rsa.s)
-		ret = verify_signature(key, &pks);
-
-	mpi_free(pks.rsa.s);
+	pks.s = sig;
+	pks.s_size = siglen;
+	ret = verify_signature(key, &pks);
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
 	return ret;
