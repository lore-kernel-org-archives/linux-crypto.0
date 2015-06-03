From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v3 2/3] crypto: RSA: KEYS: convert rsa and public key to
 new PKE API
Date: Wed, 03 Jun 2015 15:44:14 -0700
Message-ID: <20150603224414.22310.17260.stgit@tstruk-mobl1>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, tadeusz.struk@intel.com,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbbFCWoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 18:44:12 -0400
In-Reply-To: <20150603224403.22310.79731.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change the existing rsa and public key code to integrate it
with the new Public Key Encryption API.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/asymmetric_keys/Kconfig            |    1 
 crypto/asymmetric_keys/Makefile           |    1 
 crypto/asymmetric_keys/pkcs7_parser.c     |    2 
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 
 crypto/asymmetric_keys/pkcs7_verify.c     |    2 
 crypto/asymmetric_keys/public_key.c       |   53 +--
 crypto/asymmetric_keys/public_key.h       |   36 --
 crypto/asymmetric_keys/rsa.c              |  467 ++++++++++++++++-------------
 crypto/asymmetric_keys/rsa_pkcs1_v1_5.c   |  259 ++++++++++++++++
 crypto/asymmetric_keys/x509_cert_parser.c |    2 
 crypto/asymmetric_keys/x509_public_key.c  |    4 
 include/crypto/public_key.h               |   11 -
 12 files changed, 540 insertions(+), 300 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 create mode 100644 crypto/asymmetric_keys/rsa_pkcs1_v1_5.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 4870f28..4d27116 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -23,6 +23,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
 	select MPILIB
+	select CRYPTO_AKCIPHER
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index e47fcd9..a9cb1b8 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -8,6 +8,7 @@ asymmetric_keys-y := asymmetric_type.o signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
 obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
+obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa_pkcs1_v1_5.o
 
 #
 # X.509 Certificate handling
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3bd5a1e..054f110 100644
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
index 2f6e4fb..4685aed 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -18,30 +18,26 @@
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
 };
 EXPORT_SYMBOL_GPL(pkey_id_type_name);
 
+int rsa_pkcs1_v1_5_verify_signature(const struct public_key *pkey,
+				    const struct public_key_signature *sig);
+
 /*
  * Provide a part of a description of the key for /proc/keys.
  */
@@ -52,7 +48,8 @@ static void public_key_describe(const struct key *asymmetric_key,
 
 	if (key)
 		seq_printf(m, "%s.%s",
-			   pkey_id_type_name[key->id_type], key->algo->name);
+			   pkey_id_type_name[key->id_type],
+			   pkey_algo_name[key->pkey_algo]);
 }
 
 /*
@@ -74,37 +71,20 @@ EXPORT_SYMBOL_GPL(public_key_destroy);
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
+	BUG_ON(!pkey->mpi[0]);
+	BUG_ON(!pkey->mpi[1]);
 	BUG_ON(!sig);
 	BUG_ON(!sig->digest);
 	BUG_ON(!sig->mpi[0]);
 
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
 
@@ -112,6 +92,7 @@ static int public_key_verify_signature_2(const struct key *key,
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
index 459cf97..9e805ae 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -3,276 +3,317 @@
  * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
+ * Split to RSA cryptographic primitives and RSA encryption schemes
+ * added support for encrypt, decrypt and sign
+ * Tadeusz Struk <tadeusz.struk@intel.com>
+ * Copyright (c) 2015, Intel Corporation
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public Licence
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
  */
 
-#define pr_fmt(fmt) "RSA: "fmt
 #include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <crypto/algapi.h>
-#include "public_key.h"
+#include <linux/scatterlist.h>
+#include <crypto/public_key.h>
+#include <crypto/akcipher.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RSA Public Key Algorithm");
 
-#define kenter(FMT, ...) \
-	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
-#define kleave(FMT, ...) \
-	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
-
 /*
- * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
+ * RSAEP function [RFC3447 sec 5.1.1]
+ * c = m^e mod n;
  */
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
+static int _rsa_enc(const struct public_key *key, MPI c, MPI m)
+{
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->rsa.n) >= 0)
+		return -EBADMSG;
 
-static const u8 RSA_digest_info_SHA224[] = {
-	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
-	0x05, 0x00, 0x04, 0x1C
-};
+	/* (2) c = m^e mod n */
+	return mpi_powm(c, m, key->rsa.e, key->rsa.n);
+}
 
-static const u8 RSA_digest_info_SHA256[] = {
-	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
-	0x05, 0x00, 0x04, 0x20
-};
+/*
+ * RSADP function [RFC3447 sec 5.1.2]
+ * m = c^d mod n;
+ */
+static int _rsa_dec(const struct public_key *key, MPI m, MPI c)
+{
+	/* (1) Validate 0 <= c < n */
+	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->rsa.n) >= 0)
+		return -EBADMSG;
 
-static const u8 RSA_digest_info_SHA384[] = {
-	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
-	0x05, 0x00, 0x04, 0x30
-};
+	/* (2) m = c^d mod n */
+	return mpi_powm(m, c, key->rsa.d, key->rsa.n);
+}
 
-static const u8 RSA_digest_info_SHA512[] = {
-	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
-	0x05, 0x00, 0x04, 0x40
-};
+/*
+ * RSASP1 function [RFC3447 sec 5.2.1]
+ * s = m^d mod n
+ */
+static int _rsa_sign(const struct public_key *key, MPI s, MPI m)
+{
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->rsa.n) >= 0)
+		return -EBADMSG;
 
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
+	/* (2) s = m^d mod n */
+	return mpi_powm(s, m, key->rsa.d, key->rsa.n);
+}
 
 /*
- * RSAVP1() function [RFC3447 sec 5.2.2]
+ * RSAVP1 function [RFC3447 sec 5.2.2]
+ * m = s^e mod n;
  */
-static int RSAVP1(const struct public_key *key, MPI s, MPI *_m)
+static int _rsa_verify(const struct public_key *key, MPI m, MPI s)
 {
-	MPI m;
-	int ret;
-
 	/* (1) Validate 0 <= s < n */
-	if (mpi_cmp_ui(s, 0) < 0) {
-		kleave(" = -EBADMSG [s < 0]");
-		return -EBADMSG;
-	}
-	if (mpi_cmp(s, key->rsa.n) >= 0) {
-		kleave(" = -EBADMSG [s >= n]");
+	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->rsa.n) >= 0)
 		return -EBADMSG;
-	}
-
-	m = mpi_alloc(0);
-	if (!m)
-		return -ENOMEM;
 
 	/* (2) m = s^e mod n */
-	ret = mpi_powm(m, s, key->rsa.e, key->rsa.n);
-	if (ret < 0) {
-		mpi_free(m);
-		return ret;
-	}
-
-	*_m = m;
-	return 0;
+	return mpi_powm(m, s, key->rsa.e, key->rsa.n);
 }
 
-/*
- * Integer to Octet String conversion [RFC3447 sec 4.1]
- */
-static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+static int rsa_enc(struct akcipher_request *req)
 {
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
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct public_key *pkey = tfm->pkey;
+	MPI m, c = mpi_alloc(0);
+	char *buf;
+	unsigned int len;
+	int ret = 0;
+	int sign;
+
+	if (!c)
 		return -ENOMEM;
-	if (X_sign < 0) {
-		kfree(X);
-		return -EBADMSG;
+
+	m = mpi_read_raw_data(req->src, req->src_len);
+	if (!m) {
+		ret = -ENOMEM;
+		goto err_free_c;
 	}
-	if (X_size != xLen - 1) {
-		kfree(X);
-		return -EBADMSG;
+
+	ret = _rsa_enc(pkey, c, m);
+	if (ret)
+		goto err_free_m;
+
+	buf = mpi_get_buffer(c, &len, &sign);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_free_m;
+	}
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_buf;
 	}
 
-	*_X = X;
-	return 0;
+	if (req->dst_len < len) {
+		ret = -EINVAL;
+		goto err_free_buf;
+	}
+
+	if (req->result_len)
+		*req->result_len = len;
+
+	memcpy(req->dst, buf, len);
+
+err_free_buf:
+	kfree(buf);
+err_free_m:
+	mpi_free(m);
+err_free_c:
+	mpi_free(c);
+	return ret;
 }
 
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
+static int rsa_dec(struct akcipher_request *req)
 {
-	unsigned PS_end, T_offset, i;
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct public_key *pkey = tfm->pkey;
+	MPI c, m = mpi_alloc(0);
+	char *buf;
+	unsigned int len;
+	int ret = 0;
+	int sign;
 
-	kenter(",,%zu,%zu,%zu", k, hash_size, asn1_size);
+	if (!m)
+		return -ENOMEM;
 
-	if (k < 2 + 1 + asn1_size + hash_size)
-		return -EBADMSG;
+	c = mpi_read_raw_data(req->src, req->src_len);
+	if (!c) {
+		ret = -ENOMEM;
+		goto err_free_m;
+	}
 
-	/* Decode the EMSA-PKCS1-v1_5 */
-	if (EM[1] != 0x01) {
-		kleave(" = -EBADMSG [EM[1] == %02u]", EM[1]);
-		return -EBADMSG;
+	ret = _rsa_dec(pkey, m, c);
+	if (ret)
+		goto err_free_c;
+
+	buf = mpi_get_buffer(m, &len, &sign);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_free_c;
 	}
 
-	T_offset = k - (asn1_size + hash_size);
-	PS_end = T_offset - 1;
-	if (EM[PS_end] != 0x00) {
-		kleave(" = -EBADMSG [EM[T-1] == %02u]", EM[PS_end]);
-		return -EBADMSG;
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_buf;
 	}
 
-	for (i = 2; i < PS_end; i++) {
-		if (EM[i] != 0xff) {
-			kleave(" = -EBADMSG [EM[PS%x] == %02u]", i - 2, EM[i]);
-			return -EBADMSG;
-		}
+	if (req->dst_len < len) {
+		ret = -EINVAL;
+		goto err_free_buf;
 	}
 
-	if (crypto_memneq(asn1_template, EM + T_offset, asn1_size) != 0) {
-		kleave(" = -EBADMSG [EM[T] ASN.1 mismatch]");
-		return -EBADMSG;
+	if (req->result_len)
+		*req->result_len = len;
+
+	memcpy(req->dst, buf, len);
+
+err_free_buf:
+	kfree(buf);
+err_free_c:
+	mpi_free(c);
+err_free_m:
+	mpi_free(m);
+	return ret;
+}
+
+static int rsa_sign(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct public_key *pkey = tfm->pkey;
+	MPI m, s = mpi_alloc(0);
+	char *buf;
+	unsigned int len;
+	int ret = 0;
+	int sign;
+
+	if (!s)
+		return -ENOMEM;
+
+	m = mpi_read_raw_data(req->src, req->src_len);
+	if (!m) {
+		ret = -ENOMEM;
+		goto err_free_s;
+	}
+	ret = _rsa_sign(pkey, s, m);
+	if (ret)
+		goto err_free_m;
+
+	buf = mpi_get_buffer(s, &len, &sign);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_free_m;
+	}
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_buf;
 	}
 
-	if (crypto_memneq(H, EM + T_offset + asn1_size, hash_size) != 0) {
-		kleave(" = -EKEYREJECTED [EM[T] hash mismatch]");
-		return -EKEYREJECTED;
+	if (req->dst_len < len) {
+		ret = -EINVAL;
+		goto err_free_buf;
 	}
 
-	kleave(" = 0");
-	return 0;
+	if (req->result_len)
+		*req->result_len = len;
+
+	memcpy(req->dst, buf, len);
+
+err_free_buf:
+	kfree(buf);
+err_free_m:
+	mpi_free(m);
+err_free_s:
+	mpi_free(s);
+	return ret;
 }
 
-/*
- * Perform the verification step [RFC3447 sec 8.2.2].
- */
-static int RSA_verify_signature(const struct public_key *key,
-				const struct public_key_signature *sig)
+static int rsa_verify(struct akcipher_request *req)
 {
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
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct public_key *pkey = tfm->pkey;
+	MPI s, m = mpi_alloc(0);
+	char *buf;
+	unsigned int len;
+	int ret = 0;
+	int sign;
+
+	if (!m)
+		return -ENOMEM;
+
+	s = mpi_read_raw_data(req->src, req->src_len);
+	if (!s) {
+		ret = -ENOMEM;
+		goto err_free_m;
+	}
+
+	ret = _rsa_verify(pkey, m, s);
+	if (ret)
+		goto err_free_s;
+
+	buf = mpi_get_buffer(m, &len, &sign);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_free_s;
+	}
+
+	if (sign < 0) {
 		ret = -EBADMSG;
-		goto error;
+		goto err_free_buf;
+	}
+
+	if (req->dst_len < len) {
+		ret = -EINVAL;
+		goto err_free_buf;
 	}
 
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
+	if (req->result_len)
+		*req->result_len = len;
+
+	memcpy(req->dst, buf, len);
+
+err_free_buf:
+	kfree(buf);
+err_free_s:
+	mpi_free(s);
+err_free_m:
 	mpi_free(m);
-	kleave(" = %d", ret);
 	return ret;
 }
 
-const struct public_key_algorithm RSA_public_key_algorithm = {
-	.name		= "RSA",
-	.n_pub_mpi	= 2,
-	.n_sec_mpi	= 3,
-	.n_sig_mpi	= 1,
-	.verify_signature = RSA_verify_signature,
+static struct akcipher_alg rsa = {
+	.encrypt = rsa_enc,
+	.decrypt = rsa_dec,
+	.sign = rsa_sign,
+	.verify = rsa_verify,
+	.base = {
+		.cra_name = "rsa",
+		.cra_driver_name = "rsa-generic",
+		.cra_priority = 100,
+		.cra_ctxsize = 0,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
 };
-EXPORT_SYMBOL_GPL(RSA_public_key_algorithm);
+
+static int rsa_init(void)
+{
+	return crypto_register_akcipher(&rsa);
+}
+
+static void rsa_exit(void)
+{
+	crypto_unregister_akcipher(&rsa);
+}
+
+module_init(rsa_init);
+module_exit(rsa_exit);
+MODULE_ALIAS_CRYPTO("rsa");
diff --git a/crypto/asymmetric_keys/rsa_pkcs1_v1_5.c b/crypto/asymmetric_keys/rsa_pkcs1_v1_5.c
new file mode 100644
index 0000000..8feb28e
--- /dev/null
+++ b/crypto/asymmetric_keys/rsa_pkcs1_v1_5.c
@@ -0,0 +1,259 @@
+/* RSA asymmetric public-key algorithm [RFC3447]
+ * RSA encryption schemes part
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Split to RSA cryptographic primitives and RSA encryption schemes
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
+	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
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
+
+	/* Decode the EMSA-PKCS1-v1_5 */
+	if (EM[1] != 0x01) {
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
+
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
+	void *inbuf = NULL;
+	size_t tsize;
+	unsigned int len, len_out;
+	int ret;
+	/* Variables as per RFC3447 sec 8.2.2 */
+	const u8 *H = sig->digest;
+	size_t k;
+
+	kenter("");
+	tfm = crypto_alloc_akcipher("rsa", 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = -ENOMEM;
+		goto error_out;
+	}
+
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto error_free_tfm;
+	}
+	/* (1) Check the signature size against the public key modulus size */
+	k = mpi_get_nbits(pkey->rsa.n);
+	tsize = mpi_get_nbits(sig->rsa.s);
+
+	/* According to RFC 4880 sec 3.2, length of MPI is computed starting
+	 * from most significant bit.  So the RFC 3447 sec 8.2.2 size check
+	 * must be relaxed to conform with shorter signatures - so we fail here
+	 * only if signature length is longer than modulus size.
+	 */
+	if (k < tsize) {
+		ret = -EBADMSG;
+		goto error_free_req;
+	}
+
+	/* initialize input with signature */
+	inbuf = mpi_get_buffer(sig->rsa.s, &len, NULL);
+	if (!inbuf) {
+		ret = -ENOMEM;
+		goto error_free_req;
+	}
+
+	/* Expect the same result size as the size of the signature */
+	len_out = len;
+
+	/* initlialzie out buf */
+	outbuf = kmalloc(len_out, GFP_KERNEL);
+	if (!outbuf) {
+		ret = -ENOMEM;
+		goto error_free_req;
+	}
+
+	/* Perform RSA verification primitive */
+	crypto_akcipher_setkey(tfm, pkey);
+	akcipher_request_set_crypt(req, inbuf, outbuf, len, len_out, &len_out);
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
+	/* Round up and convert to octets */
+	k = (k + 7) / 8;
+
+	/*
+	 * Output from the operation is an encoded message (EM) of
+	 * length k octets.
+	 *
+	 * NOTE!  The leading zero byte is suppressed by MPI, so we pass a
+	 * pointer to the _preceding_ byte to rsa_verify()!
+	 */
+	ret = rsa_signture_verify(H, outbuf - 1, k, sig->digest_size,
+				  RSA_ASN1_templates[sig->pkey_hash_algo].data,
+				  RSA_ASN1_templates[sig->pkey_hash_algo].size);
+error_free_req:
+	akcipher_request_free(req);
+error_free_tfm:
+	crypto_free_akcipher(tfm);
+error_out:
+	kfree(inbuf);
+	kfree(outbuf);
+	kleave(" = %d", ret);
+	return ret;
+}
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index a668d90..bab3fdd 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
-#include "public_key.h"
+#include <crypto/public_key.h>
 #include "x509_parser.h"
 #include "x509-asn1.h"
 #include "x509_rsakey-asn1.h"
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index a6c4203..8f35975 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -21,7 +21,6 @@
 #include <keys/system_keyring.h>
 #include <crypto/hash.h>
 #include "asymmetric_keys.h"
-#include "public_key.h"
 #include "x509_parser.h"
 
 static bool use_builtin_keys;
@@ -250,8 +249,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_algo >= PKEY_ALGO__LAST ||
 	    cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !pkey_algo[cert->pub->pkey_algo] ||
-	    !pkey_algo[cert->sig.pkey_algo] ||
 	    !hash_algo_name[cert->sig.pkey_hash_algo]) {
 		ret = -ENOPKG;
 		goto error_free_cert;
@@ -270,7 +267,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 pkey_algo_name[cert->sig.pkey_algo],
 		 hash_algo_name[cert->sig.pkey_hash_algo]);
 
-	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 54add20..34b6fb8 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -25,7 +25,6 @@ enum pkey_algo {
 };
 
 extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
-extern const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST];
 
 /* asymmetric key implementation supports only up to SHA224 */
 #define PKEY_HASH__LAST		(HASH_ALGO_SHA224 + 1)
@@ -45,12 +44,6 @@ extern const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST];
  * part.
  */
 struct public_key {
-	const struct public_key_algorithm *algo;
-	u8	capabilities;
-#define PKEY_CAN_ENCRYPT	0x01
-#define PKEY_CAN_DECRYPT	0x02
-#define PKEY_CAN_SIGN		0x04
-#define PKEY_CAN_VERIFY		0x08
 	enum pkey_algo pkey_algo : 8;
 	enum pkey_id_type id_type : 8;
 	union {
@@ -95,6 +88,7 @@ struct public_key_signature {
 	};
 };
 
+extern struct asymmetric_key_subtype public_key_subtype;
 struct key;
 extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
@@ -104,4 +98,7 @@ extern struct key *x509_request_asymmetric_key(struct key *keyring,
 					       const struct asymmetric_key_id *kid,
 					       bool partial);
 
+int public_key_verify_signature(const struct public_key *pkey,
+				const struct public_key_signature *sig);
+
 #endif /* _LINUX_PUBLIC_KEY_H */
