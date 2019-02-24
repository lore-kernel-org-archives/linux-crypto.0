Return-Path: <SRS0=FcWR=Q7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C966DC00319
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 791FA204EC
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbfBXGJ0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Feb 2019 01:09:26 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:43868 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbfBXGJY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Feb 2019 01:09:24 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id B35EA72CCAE;
        Sun, 24 Feb 2019 09:09:11 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 83B4F4A4AEB;
        Sun, 24 Feb 2019 09:09:11 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/10] crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm
Date:   Sun, 24 Feb 2019 09:08:26 +0300
Message-Id: <20190224060828.2527-9-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190224060828.2527-1-vt@altlinux.org>
References: <20190224060828.2527-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add Elliptic Curve Russian Digital Signature Algorithm (GOST R
34.10-2012, RFC 7091, ISO/IEC 14888-3) is one of the Russian (and since
2018 the CIS countries) cryptographic standard algorithms (called GOST
algorithms). Only signature verification is supported, with intent to be
used in the IMA.

Summary of the changes:

* crypto/Kconfig:
  - EC-RDSA is added into Public-key cryptography section.

* crypto/Makefile:
  - ecrdsa objects are added.

* crypto/asymmetric_keys/x509_cert_parser.c:
  - Recognize EC-RDSA and Streebog OIDs.

* include/linux/oid_registry.h:
  - EC-RDSA OIDs are added to the enum. Also, a two currently not
    implemented curve OIDs are added for possible extension later (to
    not change numbering and grouping).

* crypto/ecc.c:
  - Kenneth MacKay copyright date is updated to 2014, because
    vli_mmod_slow, ecc_point_add, ecc_point_mult_shamir are based on his
    code from micro-ecc.
  - Functions needed for ecrdsa are EXPORT_SYMBOL'ed.
  - New functions:
    vli_is_negative - helper to determine sign of vli;
    vli_from_be64 - unpack big-endian array into vli (used for
      a signature);
    vli_from_le64 - unpack little-endian array into vli (used for
      a public key);
    vli_uadd, vli_usub - add/sub u64 value to/from vli (used for
      increment/decrement);
    mul_64_64 - optimized to use __int128 where appropriate, this speeds
      up point multiplication (and as a consequence signature
      verification) by the factor of 1.5-2;
    vli_umult - multiply vli by a small value (speeds up point
      multiplication by another factor of 1.5-2, depending on vli sizes);
    vli_mmod_special - module reduction for some form of Pseudo-Mersenne
      primes (used for the curves A);
    vli_mmod_special2 - module reduction for another form of
      Pseudo-Mersenne primes (used for the curves B);
    vli_mmod_barrett - module reduction using pre-computed value (used
      for the curve C);
    vli_mmod_slow - more general module reduction which is much slower
     (used when the modulus is subgroup order);
    vli_mod_mult_slow - modular multiplication;
    ecc_point_add - add two points;
    ecc_point_mult_shamir - add two points multiplied by scalars in one
      combined multiplication (this gives speed up by another factor 2 in
      compare to two separate multiplications).
    ecc_is_pubkey_valid_partial - additional samity check is added.
  - Updated vli_mmod_fast with non-strict heuristic to call optimal
      module reduction function depending on the prime value;
  - All computations for the previously defined (two NIST) curves should
    not unaffected.

* crypto/ecc.h:
  - Newly exported functions are documented.

* crypto/ecrdsa_defs.h
  - Five curves are defined.

* crypto/ecrdsa.c:
  - Signature verification is implemented.

* crypto/ecrdsa_params.asn1, crypto/ecrdsa_pub_key.asn1:
  - Templates for BER decoder for EC-RDSA parameters and public key.

Cc: linux-integrity@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/Kconfig                            |  11 +
 crypto/Makefile                           |   8 +
 crypto/asymmetric_keys/x509_cert_parser.c |  26 +-
 crypto/ecc.c                              | 392 +++++++++++++++++++++++++++++-
 crypto/ecc.h                              |  54 +++-
 crypto/ecrdsa.c                           | 297 ++++++++++++++++++++++
 crypto/ecrdsa_defs.h                      | 225 +++++++++++++++++
 include/linux/oid_registry.h              |  18 ++
 8 files changed, 1018 insertions(+), 13 deletions(-)
 create mode 100644 crypto/ecrdsa.c
 create mode 100644 crypto/ecrdsa_defs.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index cf0bceee0ea5..c7e7e3ac38ed 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -259,6 +259,17 @@ config CRYPTO_ECDH
 	help
 	  Generic implementation of the ECDH algorithm
 
+config CRYPTO_ECRDSA
+	tristate "EC-RDSA (GOST 34.10) algorithm"
+	select CRYPTO_ECC
+	select CRYPTO_AKCIPHER
+	select CRYPTO_STREEBOG
+	help
+	  Elliptic Curve Russian Digital Signature Algorithm (GOST R 34.10-2012,
+	  RFC 7091, ISO/IEC 14888-3:2018) is one of the Russian cryptographic
+	  standard algorithms (called GOST algorithms). Only signature verification
+	  is supported.
+
 comment "Authenticated Encryption with Associated Data"
 
 config CRYPTO_CCM
diff --git a/crypto/Makefile b/crypto/Makefile
index b660f078651a..89e5e55bf391 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -153,6 +153,14 @@ ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
+$(obj)/ecrdsa_params.asn1.o: $(obj)/ecrdsa_params.asn1.c $(obj)/ecrdsa_params.asn1.h
+$(obj)/ecrdsa_pub_key.asn1.o: $(obj)/ecrdsa_pub_key.asn1.c $(obj)/ecrdsa_pub_key.asn1.h
+$(obj)/ecrdsa.o: $(obj)/ecrdsa_params.asn1.h $(obj)/ecrdsa_pub_key.asn1.h
+ecrdsa_generic-y += ecrdsa.o
+ecrdsa_generic-y += ecrdsa_params.asn1.o
+ecrdsa_generic-y += ecrdsa_pub_key.asn1.o
+obj-$(CONFIG_CRYPTO_ECRDSA) += ecrdsa_generic.o
+
 #
 # generic algorithms and the async_tx api
 #
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index b2cdf2db1987..5b7bfd95c334 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -230,6 +230,14 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 	case OID_sha224WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha224";
 		goto rsa_pkcs1;
+
+	case OID_gost2012Signature256:
+		ctx->cert->sig->hash_algo = "streebog256";
+		goto ecrdsa;
+
+	case OID_gost2012Signature512:
+		ctx->cert->sig->hash_algo = "streebog512";
+		goto ecrdsa;
 	}
 
 rsa_pkcs1:
@@ -237,6 +245,11 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 	ctx->cert->sig->encoding = "pkcs1";
 	ctx->algo_oid = ctx->last_oid;
 	return 0;
+ecrdsa:
+	ctx->cert->sig->pkey_algo = "ecrdsa";
+	ctx->cert->sig->encoding = "raw";
+	ctx->algo_oid = ctx->last_oid;
+	return 0;
 }
 
 /*
@@ -256,7 +269,8 @@ int x509_note_signature(void *context, size_t hdrlen,
 		return -EINVAL;
 	}
 
-	if (strcmp(ctx->cert->sig->pkey_algo, "rsa") == 0) {
+	if (strcmp(ctx->cert->sig->pkey_algo, "rsa") == 0 ||
+	    strcmp(ctx->cert->sig->pkey_algo, "ecrdsa") == 0) {
 		/* Discard the BIT STRING metadata */
 		if (vlen < 1 || *(const u8 *)value != 0)
 			return -EBADMSG;
@@ -440,11 +454,15 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 {
 	struct x509_parse_context *ctx = context;
 
-	if (ctx->last_oid != OID_rsaEncryption)
+	ctx->key_algo = ctx->last_oid;
+	if (ctx->last_oid == OID_rsaEncryption)
+		ctx->cert->pub->pkey_algo = "rsa";
+	else if (ctx->last_oid == OID_gost2012PKey256 ||
+		 ctx->last_oid == OID_gost2012PKey512)
+		ctx->cert->pub->pkey_algo = "ecrdsa";
+	else
 		return -ENOPKG;
 
-	ctx->cert->pub->pkey_algo = "rsa";
-
 	/* Discard the BIT STRING metadata */
 	if (vlen < 1 || *(const u8 *)value != 0)
 		return -EBADMSG;
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 5f36792d143d..dfe114bc0c4a 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1,6 +1,6 @@
 /*
- * Copyright (c) 2013, Kenneth MacKay
- * All rights reserved.
+ * Copyright (c) 2013, 2014 Kenneth MacKay. All rights reserved.
+ * Copyright (c) 2019 Vitaly Chikunov <vt@altlinux.org>
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are
@@ -31,6 +31,8 @@
 #include <linux/fips.h>
 #include <crypto/ecdh.h>
 #include <crypto/rng.h>
+#include <asm/unaligned.h>
+#include <linux/ratelimit.h>
 
 #include "ecc.h"
 #include "ecc_curve_defs.h"
@@ -132,6 +134,11 @@ static u64 vli_test_bit(const u64 *vli, unsigned int bit)
 	return (vli[bit / 64] & ((u64)1 << (bit % 64)));
 }
 
+static bool vli_is_negative(const u64 *vli, unsigned int ndigits)
+{
+	return vli_test_bit(vli, ndigits * 64 - 1);
+}
+
 /* Counts the number of 64-bit "digits" in vli. */
 static unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits)
 {
@@ -163,6 +170,27 @@ static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 	return ((num_digits - 1) * 64 + i);
 }
 
+/* Set dest from unaligned bit string src. */
+void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits)
+{
+	int i;
+	const u64 *from = src;
+
+	for (i = 0; i < ndigits; i++)
+		dest[i] = get_unaligned_be64(&from[ndigits - 1 - i]);
+}
+EXPORT_SYMBOL(vli_from_be64);
+
+void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits)
+{
+	int i;
+	const u64 *from = src;
+
+	for (i = 0; i < ndigits; i++)
+		dest[i] = get_unaligned_le64(&from[i]);
+}
+EXPORT_SYMBOL(vli_from_le64);
+
 /* Sets dest = src. */
 static void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
 {
@@ -242,6 +270,28 @@ static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
 	return carry;
 }
 
+/* Computes result = left + right, returning carry. Can modify in place. */
+static u64 vli_uadd(u64 *result, const u64 *left, u64 right,
+		    unsigned int ndigits)
+{
+	u64 carry = right;
+	int i;
+
+	for (i = 0; i < ndigits; i++) {
+		u64 sum;
+
+		sum = left[i] + carry;
+		if (sum != left[i])
+			carry = (sum < left[i]);
+		else
+			carry = !!carry;
+
+		result[i] = sum;
+	}
+
+	return carry;
+}
+
 /* Computes result = left - right, returning borrow. Can modify in place. */
 u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 		   unsigned int ndigits)
@@ -263,8 +313,35 @@ u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 }
 EXPORT_SYMBOL(vli_sub);
 
+/* Computes result = left - right, returning borrow. Can modify in place. */
+static u64 vli_usub(u64 *result, const u64 *left, u64 right,
+	     unsigned int ndigits)
+{
+	u64 borrow = right;
+	int i;
+
+	for (i = 0; i < ndigits; i++) {
+		u64 diff;
+
+		diff = left[i] - borrow;
+		if (diff != left[i])
+			borrow = (diff > left[i]);
+
+		result[i] = diff;
+	}
+
+	return borrow;
+}
+
 static uint128_t mul_64_64(u64 left, u64 right)
 {
+	uint128_t result;
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+	unsigned __int128 m = (unsigned __int128)left * right;
+
+	result.m_low  = m;
+	result.m_high = m >> 64;
+#else
 	u64 a0 = left & 0xffffffffull;
 	u64 a1 = left >> 32;
 	u64 b0 = right & 0xffffffffull;
@@ -273,7 +350,6 @@ static uint128_t mul_64_64(u64 left, u64 right)
 	u64 m1 = a0 * b1;
 	u64 m2 = a1 * b0;
 	u64 m3 = a1 * b1;
-	uint128_t result;
 
 	m2 += (m0 >> 32);
 	m2 += m1;
@@ -284,7 +360,7 @@ static uint128_t mul_64_64(u64 left, u64 right)
 
 	result.m_low = (m0 & 0xffffffffull) | (m2 << 32);
 	result.m_high = m3 + (m2 >> 32);
-
+#endif
 	return result;
 }
 
@@ -334,6 +410,28 @@ static void vli_mult(u64 *result, const u64 *left, const u64 *right,
 	result[ndigits * 2 - 1] = r01.m_low;
 }
 
+/* Compute product = left * right, for a small right value. */
+static void vli_umult(u64 *result, const u64 *left, u32 right,
+		      unsigned int ndigits)
+{
+	uint128_t r01 = { 0 };
+	unsigned int k;
+
+	for (k = 0; k < ndigits; k++) {
+		uint128_t product;
+
+		product = mul_64_64(left[k], right);
+		r01 = add_128_128(r01, product);
+		/* no carry */
+		result[k] = r01.m_low;
+		r01.m_low = r01.m_high;
+		r01.m_high = 0;
+	}
+	result[k] = r01.m_low;
+	for (++k; k < ndigits * 2; k++)
+		result[k] = 0;
+}
+
 static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
 {
 	uint128_t r01 = { 0, 0 };
@@ -406,6 +504,170 @@ static void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
 		vli_add(result, result, mod, ndigits);
 }
 
+/*
+ * Computes result = product % mod
+ * for special form moduli: p = 2^k-c, for small c (note the minus sign)
+ *
+ * References:
+ * R. Crandall, C. Pomerance. Prime Numbers: A Computational Perspective.
+ * 9 Fast Algorithms for Large-Integer Arithmetic. 9.2.3 Moduli of special form
+ * Algorithm 9.2.13 (Fast mod operation for special-form moduli).
+ */
+static void vli_mmod_special(u64 *result, const u64 *product,
+			      const u64 *mod, unsigned int ndigits)
+{
+	u64 c = -mod[0];
+	u64 t[ECC_MAX_DIGITS * 2];
+	u64 r[ECC_MAX_DIGITS * 2];
+
+	vli_set(r, product, ndigits * 2);
+	while (!vli_is_zero(r + ndigits, ndigits)) {
+		vli_umult(t, r + ndigits, c, ndigits);
+		vli_clear(r + ndigits, ndigits);
+		vli_add(r, r, t, ndigits * 2);
+	}
+	vli_set(t, mod, ndigits);
+	vli_clear(t + ndigits, ndigits);
+	while (vli_cmp(r, t, ndigits * 2) >= 0)
+		vli_sub(r, r, t, ndigits * 2);
+	vli_set(result, r, ndigits);
+}
+
+/*
+ * Computes result = product % mod
+ * for special form moduli: p = 2^{k-1}+c, for small c (note the plus sign)
+ * where k-1 does not fit into qword boundary by -1 bit (such as 255).
+
+ * References (loosely based on):
+ * A. Menezes, P. van Oorschot, S. Vanstone. Handbook of Applied Cryptography.
+ * 14.3.4 Reduction methods for moduli of special form. Algorithm 14.47.
+ * URL: http://cacr.uwaterloo.ca/hac/about/chap14.pdf
+ *
+ * H. Cohen, G. Frey, R. Avanzi, C. Doche, T. Lange, K. Nguyen, F. Vercauteren.
+ * Handbook of Elliptic and Hyperelliptic Curve Cryptography.
+ * Algorithm 10.25 Fast reduction for special form moduli
+ */
+static void vli_mmod_special2(u64 *result, const u64 *product,
+			       const u64 *mod, unsigned int ndigits)
+{
+	u64 c2 = mod[0] * 2;
+	u64 q[ECC_MAX_DIGITS];
+	u64 r[ECC_MAX_DIGITS * 2];
+	u64 m[ECC_MAX_DIGITS * 2]; /* expanded mod */
+	int carry; /* last bit that doesn't fit into q */
+	int i;
+
+	vli_set(m, mod, ndigits);
+	vli_clear(m + ndigits, ndigits);
+
+	vli_set(r, product, ndigits);
+	/* q and carry are top bits */
+	vli_set(q, product + ndigits, ndigits);
+	vli_clear(r + ndigits, ndigits);
+	carry = vli_is_negative(r, ndigits);
+	if (carry)
+		r[ndigits - 1] &= (1ull << 63) - 1;
+	for (i = 1; carry || !vli_is_zero(q, ndigits); i++) {
+		u64 qc[ECC_MAX_DIGITS * 2];
+
+		vli_umult(qc, q, c2, ndigits);
+		if (carry)
+			vli_uadd(qc, qc, mod[0], ndigits * 2);
+		vli_set(q, qc + ndigits, ndigits);
+		vli_clear(qc + ndigits, ndigits);
+		carry = vli_is_negative(qc, ndigits);
+		if (carry)
+			qc[ndigits - 1] &= (1ull << 63) - 1;
+		if (i & 1)
+			vli_sub(r, r, qc, ndigits * 2);
+		else
+			vli_add(r, r, qc, ndigits * 2);
+	}
+	while (vli_is_negative(r, ndigits * 2))
+		vli_add(r, r, m, ndigits * 2);
+	while (vli_cmp(r, m, ndigits * 2) >= 0)
+		vli_sub(r, r, m, ndigits * 2);
+
+	vli_set(result, r, ndigits);
+}
+
+/*
+ * Computes result = product % mod, where product is 2N words long.
+ * Reference: Ken MacKay's micro-ecc.
+ * Currently only designed to work for curve_p or curve_n.
+ */
+static void vli_mmod_slow(u64 *result, u64 *product, const u64 *mod,
+			  unsigned int ndigits)
+{
+	u64 mod_m[2 * ECC_MAX_DIGITS];
+	u64 tmp[2 * ECC_MAX_DIGITS];
+	u64 *v[2] = { tmp, product };
+	u64 carry = 0;
+	unsigned int i;
+	/* Shift mod so its highest set bit is at the maximum position. */
+	int shift = (ndigits * 2 * 64) - vli_num_bits(mod, ndigits);
+	int word_shift = shift / 64;
+	int bit_shift = shift % 64;
+
+	vli_clear(mod_m, word_shift);
+	if (bit_shift > 0) {
+		for (i = 0; i < ndigits; ++i) {
+			mod_m[word_shift + i] = (mod[i] << bit_shift) | carry;
+			carry = mod[i] >> (64 - bit_shift);
+		}
+	} else
+		vli_set(mod_m + word_shift, mod, ndigits);
+
+	for (i = 1; shift >= 0; --shift) {
+		u64 borrow = 0;
+		unsigned int j;
+
+		for (j = 0; j < ndigits * 2; ++j) {
+			u64 diff = v[i][j] - mod_m[j] - borrow;
+
+			if (diff != v[i][j])
+				borrow = (diff > v[i][j]);
+			v[1 - i][j] = diff;
+		}
+		i = !(i ^ borrow); /* Swap the index if there was no borrow */
+		vli_rshift1(mod_m, ndigits);
+		mod_m[ndigits - 1] |= mod_m[ndigits] << (64 - 1);
+		vli_rshift1(mod_m + ndigits, ndigits);
+	}
+	vli_set(result, v[i], ndigits);
+}
+
+/* Computes result = product % mod using Barrett's reduction with precomputed
+ * value mu appended to the mod after ndigits, mu = (2^{2w} / mod) and have
+ * length ndigits + 1, where mu * (2^w - 1) should not overflow ndigits
+ * boundary.
+ *
+ * Reference:
+ * R. Brent, P. Zimmermann. Modern Computer Arithmetic. 2010.
+ * 2.4.1 Barrett's algorithm. Algorithm 2.5.
+ */
+static void vli_mmod_barrett(u64 *result, u64 *product, const u64 *mod,
+			     unsigned int ndigits)
+{
+	u64 q[ECC_MAX_DIGITS * 2];
+	u64 r[ECC_MAX_DIGITS * 2];
+	const u64 *mu = mod + ndigits;
+
+	vli_mult(q, product + ndigits, mu, ndigits);
+	if (mu[ndigits])
+		vli_add(q + ndigits, q + ndigits, product + ndigits, ndigits);
+	vli_mult(r, mod, q + ndigits, ndigits);
+	vli_sub(r, product, r, ndigits * 2);
+	while (!vli_is_zero(r + ndigits, ndigits) ||
+	       vli_cmp(r, mod, ndigits) != -1) {
+		u64 carry;
+
+		carry = vli_sub(r, r, mod, ndigits);
+		vli_usub(r + ndigits, r + ndigits, carry, ndigits);
+	}
+	vli_set(result, r, ndigits);
+}
+
 /* Computes p_result = p_product % curve_p.
  * See algorithm 5 and 6 from
  * http://www.isys.uni-klu.ac.at/PDF/2001-0126-MT.pdf
@@ -513,14 +775,33 @@ static void vli_mmod_fast_256(u64 *result, const u64 *product,
 	}
 }
 
-/* Computes result = product % curve_prime
- *  from http://www.nsa.gov/ia/_files/nist-routines.pdf
-*/
+/* Computes result = product % curve_prime for different curve_primes.
+ *
+ * Note that curve_primes are distinguished just by heuristic check and
+ * not by complete conformance check.
+ */
 static bool vli_mmod_fast(u64 *result, u64 *product,
 			  const u64 *curve_prime, unsigned int ndigits)
 {
 	u64 tmp[2 * ECC_MAX_DIGITS];
 
+	/* Currently, both NIST primes have -1 in lowest qword. */
+	if (curve_prime[0] != -1ull) {
+		/* Try to handle Pseudo-Marsenne primes. */
+		if (curve_prime[ndigits - 1] == -1ull) {
+			vli_mmod_special(result, product, curve_prime,
+					 ndigits);
+			return true;
+		} else if (curve_prime[ndigits - 1] == 1ull << 63 &&
+			   curve_prime[ndigits - 2] == 0) {
+			vli_mmod_special2(result, product, curve_prime,
+					  ndigits);
+			return true;
+		}
+		vli_mmod_barrett(result, product, curve_prime, ndigits);
+		return true;
+	}
+
 	switch (ndigits) {
 	case 3:
 		vli_mmod_fast_192(result, product, curve_prime, tmp);
@@ -529,13 +810,26 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
 		vli_mmod_fast_256(result, product, curve_prime, tmp);
 		break;
 	default:
-		pr_err("unsupports digits size!\n");
+		pr_err_ratelimited("ecc: unsupported digits size!\n");
 		return false;
 	}
 
 	return true;
 }
 
+/* Computes result = (left * right) % mod.
+ * Assumes that mod is big enough curve order.
+ */
+void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
+		       const u64 *mod, unsigned int ndigits)
+{
+	u64 product[ECC_MAX_DIGITS * 2];
+
+	vli_mult(product, left, right, ndigits);
+	vli_mmod_slow(result, product, mod, ndigits);
+}
+EXPORT_SYMBOL(vli_mod_mult_slow);
+
 /* Computes result = (left * right) % curve_prime. */
 static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
 			      const u64 *curve_prime, unsigned int ndigits)
@@ -908,6 +1202,85 @@ static void ecc_point_mult(struct ecc_point *result,
 	vli_set(result->y, ry[0], ndigits);
 }
 
+/* Computes R = P + Q mod p */
+static void ecc_point_add(const struct ecc_point *result,
+		   const struct ecc_point *p, const struct ecc_point *q,
+		   const struct ecc_curve *curve)
+{
+	u64 z[ECC_MAX_DIGITS];
+	u64 px[ECC_MAX_DIGITS];
+	u64 py[ECC_MAX_DIGITS];
+	unsigned int ndigits = curve->g.ndigits;
+
+	vli_set(result->x, q->x, ndigits);
+	vli_set(result->y, q->y, ndigits);
+	vli_mod_sub(z, result->x, p->x, curve->p, ndigits);
+	vli_set(px, p->x, ndigits);
+	vli_set(py, p->y, ndigits);
+	xycz_add(px, py, result->x, result->y, curve->p, ndigits);
+	vli_mod_inv(z, z, curve->p, ndigits);
+	apply_z(result->x, result->y, z, curve->p, ndigits);
+}
+
+/* Computes R = u1P + u2Q mod p using Shamir's trick.
+ * Based on: Kenneth MacKay's micro-ecc (2014).
+ */
+void ecc_point_mult_shamir(const struct ecc_point *result,
+			   const u64 *u1, const struct ecc_point *p,
+			   const u64 *u2, const struct ecc_point *q,
+			   const struct ecc_curve *curve)
+{
+	u64 z[ECC_MAX_DIGITS];
+	u64 sump[2][ECC_MAX_DIGITS];
+	u64 *rx = result->x;
+	u64 *ry = result->y;
+	unsigned int ndigits = curve->g.ndigits;
+	unsigned int num_bits;
+	struct ecc_point sum = ECC_POINT_INIT(sump[0], sump[1], ndigits);
+	const struct ecc_point *points[4];
+	const struct ecc_point *point;
+	unsigned int idx;
+	int i;
+
+	ecc_point_add(&sum, p, q, curve);
+	points[0] = NULL;
+	points[1] = p;
+	points[2] = q;
+	points[3] = &sum;
+
+	num_bits = max(vli_num_bits(u1, ndigits),
+		       vli_num_bits(u2, ndigits));
+	i = num_bits - 1;
+	idx = (!!vli_test_bit(u1, i)) | ((!!vli_test_bit(u2, i)) << 1);
+	point = points[idx];
+
+	vli_set(rx, point->x, ndigits);
+	vli_set(ry, point->y, ndigits);
+	vli_clear(z + 1, ndigits - 1);
+	z[0] = 1;
+
+	for (--i; i >= 0; i--) {
+		ecc_point_double_jacobian(rx, ry, z, curve->p, ndigits);
+		idx = (!!vli_test_bit(u1, i)) | ((!!vli_test_bit(u2, i)) << 1);
+		point = points[idx];
+		if (point) {
+			u64 tx[ECC_MAX_DIGITS];
+			u64 ty[ECC_MAX_DIGITS];
+			u64 tz[ECC_MAX_DIGITS];
+
+			vli_set(tx, point->x, ndigits);
+			vli_set(ty, point->y, ndigits);
+			apply_z(tx, ty, z, curve->p, ndigits);
+			vli_mod_sub(tz, rx, tx, curve->p, ndigits);
+			xycz_add(tx, ty, rx, ry, curve->p, ndigits);
+			vli_mod_mult_fast(z, z, tz, curve->p, ndigits);
+		}
+	}
+	vli_mod_inv(z, z, curve->p, ndigits);
+	apply_z(rx, ry, z, curve->p, ndigits);
+}
+EXPORT_SYMBOL(ecc_point_mult_shamir);
+
 static inline void ecc_swap_digits(const u64 *in, u64 *out,
 				   unsigned int ndigits)
 {
@@ -1051,6 +1424,9 @@ int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 {
 	u64 yy[ECC_MAX_DIGITS], xxx[ECC_MAX_DIGITS], w[ECC_MAX_DIGITS];
 
+	if (WARN_ON(pk->ndigits != curve->g.ndigits))
+		return -EINVAL;
+
 	/* Check 1: Verify key is not the zero point. */
 	if (ecc_point_is_zero(pk))
 		return -EINVAL;
diff --git a/crypto/ecc.h b/crypto/ecc.h
index 3809dbeb699a..ab0eb70b9c09 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -26,9 +26,10 @@
 #ifndef _CRYPTO_ECC_H
 #define _CRYPTO_ECC_H
 
+/* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
 #define ECC_CURVE_NIST_P256_DIGITS  4
-#define ECC_MAX_DIGITS              ECC_CURVE_NIST_P256_DIGITS
+#define ECC_MAX_DIGITS             (512 / 64)
 
 #define ECC_DIGITS_TO_BYTES_SHIFT 3
 
@@ -45,6 +46,8 @@ struct ecc_point {
 	u8 ndigits;
 };
 
+#define ECC_POINT_INIT(x, y, ndigits)	(struct ecc_point) { x, y, ndigits }
+
 /**
  * struct ecc_curve - definition of elliptic curve
  *
@@ -180,6 +183,24 @@ u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 	    unsigned int ndigits);
 
 /**
+ * vli_from_be64() - Load vli from big-endian u64 array
+ *
+ * @dest:		destination vli
+ * @src:		source array of u64 BE values
+ * @ndigits:		length of both vli and array
+ */
+void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits);
+
+/**
+ * vli_from_le64() - Load vli from little-endian u64 array
+ *
+ * @dest:		destination vli
+ * @src:		source array of u64 LE values
+ * @ndigits:		length of both vli and array
+ */
+void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits);
+
+/**
  * vli_mod_inv() - Modular inversion
  *
  * @result:		where to write vli number
@@ -190,4 +211,35 @@ u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 		 unsigned int ndigits);
 
+/**
+ * vli_mod_mult_slow() - Modular multiplication
+ *
+ * @result:		where to write result value
+ * @left:		vli number to multiply with @right
+ * @right:		vli number to multiply with @left
+ * @mod:		modulus
+ * @ndigits:		length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
+		       const u64 *mod, unsigned int ndigits);
+
+/**
+ * ecc_point_mult_shamir() - Add two points multiplied by scalars
+ *
+ * @result:		resulting point
+ * @x:			scalar to multiply with @p
+ * @p:			point to multiply with @x
+ * @y:			scalar to multiply with @q
+ * @q:			point to multiply with @y
+ * @curve:		curve
+ *
+ * Returns result = x * p + x * q over the curve.
+ * This works faster than two multiplications and addition.
+ */
+void ecc_point_mult_shamir(const struct ecc_point *result,
+			   const u64 *x, const struct ecc_point *p,
+			   const u64 *y, const struct ecc_point *q,
+			   const struct ecc_curve *curve);
 #endif
diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
new file mode 100644
index 000000000000..9e6568a4c309
--- /dev/null
+++ b/crypto/ecrdsa.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Elliptic Curve (Russian) Digital Signature Algorithm for Cryptographic API
+ *
+ * Copyright (c) 2019 Vitaly Chikunov <vt@altlinux.org>
+ *
+ * References:
+ * GOST 34.10-2018, GOST R 34.10-2012, RFC 7091, ISO/IEC 14888-3:2018.
+ *
+ * Historical references:
+ * GOST R 34.10-2001, RFC 4357, ISO/IEC 14888-3:2006/Amd 1:2010.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <crypto/streebog.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+#include <linux/oid_registry.h>
+#include "ecrdsa_params.asn1.h"
+#include "ecrdsa_pub_key.asn1.h"
+#include "ecc.h"
+#include "ecrdsa_defs.h"
+
+#define ECRDSA_MAX_SIG_SIZE (2 * 512 / 8)
+#define ECRDSA_MAX_DIGITS (512 / 64)
+
+struct ecrdsa_ctx {
+	enum OID algo_oid; /* overall public key oid */
+	enum OID curve_oid; /* parameter */
+	enum OID digest_oid; /* parameter */
+	const struct ecc_curve *curve; /* curve from oid */
+	unsigned int digest_len; /* parameter (bytes) */
+	const char *digest; /* digest name from oid */
+	unsigned int key_len; /* @key length (bytes) */
+	const char *key; /* raw public key */
+	struct ecc_point pub_key;
+	u64 _pubp[2][ECRDSA_MAX_DIGITS]; /* point storage for @pub_key */
+};
+
+static const struct ecc_curve *get_curve_by_oid(enum OID oid)
+{
+	switch (oid) {
+	case OID_gostCPSignA:
+	case OID_gostTC26Sign256B:
+		return &gost_cp256a;
+	case OID_gostCPSignB:
+	case OID_gostTC26Sign256C:
+		return &gost_cp256b;
+	case OID_gostCPSignC:
+	case OID_gostTC26Sign256D:
+		return &gost_cp256c;
+	case OID_gostTC26Sign512A:
+		return &gost_tc512a;
+	case OID_gostTC26Sign512B:
+		return &gost_tc512b;
+	/* The following two aren't implemented: */
+	case OID_gostTC26Sign256A:
+	case OID_gostTC26Sign512C:
+	default:
+		return NULL;
+	}
+}
+
+static int ecrdsa_verify(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	unsigned char sig[ECRDSA_MAX_SIG_SIZE];
+	unsigned char digest[STREEBOG512_DIGEST_SIZE];
+	unsigned int ndigits = req->dst_len / sizeof(u64);
+	u64 r[ECRDSA_MAX_DIGITS]; /* witness (r) */
+	u64 s[ECRDSA_MAX_DIGITS]; /* second part of sig (s) */
+	u64 e[ECRDSA_MAX_DIGITS]; /* h \mod q */
+	u64 *v = e;		  /* e^{-1} \mod q */
+	u64 z1[ECRDSA_MAX_DIGITS];
+	u64 z2[ECRDSA_MAX_DIGITS];
+	struct ecc_point cc = ECC_POINT_INIT(s, e, ndigits); /* reuse s, e */
+
+	/*
+	 * Digest value, digest algorithm, and curve (modulus) should have the
+	 * same length (256 or 512 bits), public key and signature should be
+	 * twice bigger.
+	 */
+	if (!ctx->curve ||
+	    !ctx->digest ||
+	    !req->src ||
+	    !ctx->pub_key.x ||
+	    req->dst_len != ctx->digest_len ||
+	    req->dst_len != ctx->curve->g.ndigits * sizeof(u64) ||
+	    ctx->pub_key.ndigits != ctx->curve->g.ndigits ||
+	    req->dst_len * 2 != req->src_len ||
+	    WARN_ON(req->src_len > sizeof(sig)) ||
+	    WARN_ON(req->dst_len > sizeof(digest)))
+		return -EBADMSG;
+
+	sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, req->src_len),
+			  sig, req->src_len);
+	sg_pcopy_to_buffer(req->src,
+			   sg_nents_for_len(req->src,
+					    req->src_len + req->dst_len),
+			   digest, req->dst_len, req->src_len);
+
+	vli_from_be64(s, sig, ndigits);
+	vli_from_be64(r, sig + ndigits * sizeof(u64), ndigits);
+
+	/* Step 1: verify that 0 < r < q, 0 < s < q */
+	if (vli_is_zero(r, ndigits) ||
+	    vli_cmp(r, ctx->curve->n, ndigits) == 1 ||
+	    vli_is_zero(s, ndigits) ||
+	    vli_cmp(s, ctx->curve->n, ndigits) == 1)
+		return -EKEYREJECTED;
+
+	/* Step 2: calculate hash (h) of the message (passed as input) */
+	/* Step 3: calculate e = h \mod q */
+	vli_from_le64(e, digest, ndigits);
+	if (vli_cmp(e, ctx->curve->n, ndigits) == 1)
+		vli_sub(e, e, ctx->curve->n, ndigits);
+	if (vli_is_zero(e, ndigits))
+		e[0] = 1;
+
+	/* Step 4: calculate v = e^{-1} \mod q */
+	vli_mod_inv(v, e, ctx->curve->n, ndigits);
+
+	/* Step 5: calculate z_1 = sv \mod q, z_2 = -rv \mod q */
+	vli_mod_mult_slow(z1, s, v, ctx->curve->n, ndigits);
+	{
+		u64 _r[ECRDSA_MAX_DIGITS];
+
+		vli_sub(_r, ctx->curve->n, r, ndigits);
+		vli_mod_mult_slow(z2, _r, v, ctx->curve->n, ndigits);
+	}
+
+	/* Step 6: calculate point C = z_1P + z_2Q, and R = x_c \mod q */
+	ecc_point_mult_shamir(&cc, z1, &ctx->curve->g, z2, &ctx->pub_key,
+			      ctx->curve);
+	if (vli_cmp(cc.x, ctx->curve->n, ndigits) == 1)
+		vli_sub(cc.x, cc.x, ctx->curve->n, ndigits);
+
+	/* Step 7: if R == r signature is valid */
+	if (!vli_cmp(cc.x, r, ndigits))
+		return 0;
+	else
+		return -EKEYREJECTED;
+}
+
+int ecrdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	struct ecrdsa_ctx *ctx = context;
+
+	ctx->curve_oid = look_up_OID(value, vlen);
+	if (!ctx->curve_oid)
+		return -EINVAL;
+	ctx->curve = get_curve_by_oid(ctx->curve_oid);
+	return 0;
+}
+
+/* Optional. If present should match expected digest algo OID. */
+int ecrdsa_param_digest(void *context, size_t hdrlen, unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct ecrdsa_ctx *ctx = context;
+	int digest_oid = look_up_OID(value, vlen);
+
+	if (digest_oid != ctx->digest_oid)
+		return -EINVAL;
+	return 0;
+}
+
+/* Parse BER encoded SubjectPublicKeyInfo.AlgorithmIdentifier.parameters. */
+static int ecrdsa_set_params(struct crypto_akcipher *tfm, enum OID algo,
+			     const void *ber, unsigned int berlen)
+{
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	int err;
+
+	if (algo == OID_gost2012PKey256) {
+		ctx->digest	= "streebog256";
+		ctx->digest_oid	= OID_gost2012Digest256;
+		ctx->digest_len	= 256 / 8;
+	} else if (algo == OID_gost2012PKey512) {
+		ctx->digest	= "streebog512";
+		ctx->digest_oid	= OID_gost2012Digest512;
+		ctx->digest_len	= 512 / 8;
+	} else
+		return -ENOPKG;
+	ctx->algo_oid = algo;
+
+	err = asn1_ber_decoder(&ecrdsa_params_decoder, ctx, ber, berlen);
+	if (err < 0)
+		return err;
+	/*
+	 * Sizes of algo (set in digest_len) and curve should match
+	 * each other.
+	 */
+	if (!ctx->curve ||
+	    ctx->curve->g.ndigits * sizeof(u64) != ctx->digest_len)
+		return -ENOPKG;
+
+	return 0;
+}
+
+int ecrdsa_parse_pub_key(void *context, size_t hdrlen, unsigned char tag,
+			 const void *value, size_t vlen)
+{
+	struct ecrdsa_ctx *ctx = context;
+
+	ctx->key = value;
+	ctx->key_len = vlen;
+	return 0;
+}
+
+/* Parse BER encoded subjectPublicKey. */
+static int ecrdsa_set_pub_key(struct crypto_akcipher *tfm, const void *ber,
+			      unsigned int berlen)
+{
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	unsigned int ndigits;
+	int err;
+
+	err = asn1_ber_decoder(&ecrdsa_pub_key_decoder, ctx, ber, berlen);
+	if (err < 0)
+		return err;
+	/*
+	 * Key is two 256- or 512-bit coordinates which should match
+	 * curve size.
+	 */
+	if ((ctx->key_len != (2 * 256 / 8) &&
+	     ctx->key_len != (2 * 512 / 8)) ||
+	    !ctx->curve ||
+	    ctx->key_len != ctx->curve->g.ndigits * sizeof(u64) * 2)
+		return -ENOPKG;
+	ndigits = ctx->key_len / sizeof(u64) / 2;
+	ctx->pub_key = ECC_POINT_INIT(ctx->_pubp[0], ctx->_pubp[1], ndigits);
+	vli_from_le64(ctx->pub_key.x, ctx->key, ndigits);
+	vli_from_le64(ctx->pub_key.y, ctx->key + ndigits * sizeof(u64),
+		      ndigits);
+
+	if (ecc_is_pubkey_valid_partial(ctx->curve, &ctx->pub_key))
+		return -EKEYREJECTED;
+
+	return 0;
+}
+
+static unsigned int ecrdsa_max_size(struct crypto_akcipher *tfm)
+{
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	/*
+	 * Verify doesn't need any output, so it's just informational
+	 * for keyctl to determine the key bit size.
+	 */
+	return ctx->pub_key.ndigits * sizeof(u64);
+}
+
+static void ecrdsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+}
+
+static struct akcipher_alg ecrdsa_alg = {
+	.verify		= ecrdsa_verify,
+	.set_pub_key	= ecrdsa_set_pub_key,
+	.set_params	= ecrdsa_set_params,
+	.max_size	= ecrdsa_max_size,
+	.exit		= ecrdsa_exit_tfm,
+	.base = {
+		.cra_name	 = "ecrdsa",
+		.cra_driver_name = "ecrdsa-generic",
+		.cra_priority	 = 100,
+		.cra_module	 = THIS_MODULE,
+		.cra_ctxsize	 = sizeof(struct ecrdsa_ctx),
+	},
+};
+
+static int __init ecrdsa_mod_init(void)
+{
+	return crypto_register_akcipher(&ecrdsa_alg);
+}
+
+static void __exit ecrdsa_mod_fini(void)
+{
+	crypto_unregister_akcipher(&ecrdsa_alg);
+}
+
+module_init(ecrdsa_mod_init);
+module_exit(ecrdsa_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vitaly Chikunov <vt@altlinux.org>");
+MODULE_DESCRIPTION("EC-RDSA generic algorithm");
+MODULE_ALIAS_CRYPTO("ecrdsa-generic");
diff --git a/crypto/ecrdsa_defs.h b/crypto/ecrdsa_defs.h
new file mode 100644
index 000000000000..170baf039007
--- /dev/null
+++ b/crypto/ecrdsa_defs.h
@@ -0,0 +1,225 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Definitions of EC-RDSA Curve Parameters
+ *
+ * Copyright (c) 2019 Vitaly Chikunov <vt@altlinux.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#ifndef _CRYTO_ECRDSA_DEFS_H
+#define _CRYTO_ECRDSA_DEFS_H
+
+#include "ecc.h"
+
+#define ECRDSA_MAX_SIG_SIZE (2 * 512 / 8)
+#define ECRDSA_MAX_DIGITS (512 / 64)
+
+/*
+ * EC-RDSA uses its own set of curves.
+ *
+ * cp256{a,b,c} curves first defined for GOST R 34.10-2001 in RFC 4357 (as
+ * 256-bit {A,B,C}-ParamSet), but inherited for GOST R 34.10-2012 and
+ * proposed for use in R 50.1.114-2016 and RFC 7836 as the 256-bit curves.
+ */
+/* OID_gostCPSignA 1.2.643.2.2.35.1 */
+static u64 cp256a_g_x[] = {
+	0x0000000000000001ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull, };
+static u64 cp256a_g_y[] = {
+	0x22ACC99C9E9F1E14ull, 0x35294F2DDF23E3B1ull,
+	0x27DF505A453F2B76ull, 0x8D91E471E0989CDAull, };
+static u64 cp256a_p[] = { /* p = 2^256 - 617 */
+	0xFFFFFFFFFFFFFD97ull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 cp256a_n[] = {
+	0x45841B09B761B893ull, 0x6C611070995AD100ull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 cp256a_a[] = { /* a = p - 3 */
+	0xFFFFFFFFFFFFFD94ull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 cp256a_b[] = {
+	0x00000000000000a6ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull };
+
+static struct ecc_curve gost_cp256a = {
+	.name = "cp256a",
+	.g = {
+		.x = cp256a_g_x,
+		.y = cp256a_g_y,
+		.ndigits = 256 / 64,
+	},
+	.p = cp256a_p,
+	.n = cp256a_n,
+	.a = cp256a_a,
+	.b = cp256a_b
+};
+
+/* OID_gostCPSignB 1.2.643.2.2.35.2 */
+static u64 cp256b_g_x[] = {
+	0x0000000000000001ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull, };
+static u64 cp256b_g_y[] = {
+	0x744BF8D717717EFCull, 0xC545C9858D03ECFBull,
+	0xB83D1C3EB2C070E5ull, 0x3FA8124359F96680ull, };
+static u64 cp256b_p[] = { /* p = 2^255 + 3225 */
+	0x0000000000000C99ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x8000000000000000ull, };
+static u64 cp256b_n[] = {
+	0xE497161BCC8A198Full, 0x5F700CFFF1A624E5ull,
+	0x0000000000000001ull, 0x8000000000000000ull, };
+static u64 cp256b_a[] = { /* a = p - 3 */
+	0x0000000000000C96ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x8000000000000000ull, };
+static u64 cp256b_b[] = {
+	0x2F49D4CE7E1BBC8Bull, 0xE979259373FF2B18ull,
+	0x66A7D3C25C3DF80Aull, 0x3E1AF419A269A5F8ull, };
+
+static struct ecc_curve gost_cp256b = {
+	.name = "cp256b",
+	.g = {
+		.x = cp256b_g_x,
+		.y = cp256b_g_y,
+		.ndigits = 256 / 64,
+	},
+	.p = cp256b_p,
+	.n = cp256b_n,
+	.a = cp256b_a,
+	.b = cp256b_b
+};
+
+/* OID_gostCPSignC 1.2.643.2.2.35.3 */
+static u64 cp256c_g_x[] = {
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull, };
+static u64 cp256c_g_y[] = {
+	0x366E550DFDB3BB67ull, 0x4D4DC440D4641A8Full,
+	0x3CBF3783CD08C0EEull, 0x41ECE55743711A8Cull, };
+static u64 cp256c_p[] = {
+	0x7998F7B9022D759Bull, 0xCF846E86789051D3ull,
+	0xAB1EC85E6B41C8AAull, 0x9B9F605F5A858107ull,
+	/* pre-computed value for Barrett's reduction */
+	0xedc283cdd217b5a2ull, 0xbac48fc06398ae59ull,
+	0x405384d55f9f3b73ull, 0xa51f176161f1d734ull,
+	0x0000000000000001ull, };
+static u64 cp256c_n[] = {
+	0xF02F3A6598980BB9ull, 0x582CA3511EDDFB74ull,
+	0xAB1EC85E6B41C8AAull, 0x9B9F605F5A858107ull, };
+static u64 cp256c_a[] = { /* a = p - 3 */
+	0x7998F7B9022D7598ull, 0xCF846E86789051D3ull,
+	0xAB1EC85E6B41C8AAull, 0x9B9F605F5A858107ull, };
+static u64 cp256c_b[] = {
+	0x000000000000805aull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull, };
+
+static struct ecc_curve gost_cp256c = {
+	.name = "cp256c",
+	.g = {
+		.x = cp256c_g_x,
+		.y = cp256c_g_y,
+		.ndigits = 256 / 64,
+	},
+	.p = cp256c_p,
+	.n = cp256c_n,
+	.a = cp256c_a,
+	.b = cp256c_b
+};
+
+/* tc512{a,b} curves first recommended in 2013 and then standardized in
+ * R 50.1.114-2016 and RFC 7836 for use with GOST R 34.10-2012 (as TC26
+ * 512-bit ParamSet{A,B}).
+ */
+/* OID_gostTC26Sign512A 1.2.643.7.1.2.1.2.1 */
+static u64 tc512a_g_x[] = {
+	0x0000000000000003ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull, };
+static u64 tc512a_g_y[] = {
+	0x89A589CB5215F2A4ull, 0x8028FE5FC235F5B8ull,
+	0x3D75E6A50E3A41E9ull, 0xDF1626BE4FD036E9ull,
+	0x778064FDCBEFA921ull, 0xCE5E1C93ACF1ABC1ull,
+	0xA61B8816E25450E6ull, 0x7503CFE87A836AE3ull, };
+static u64 tc512a_p[] = { /* p = 2^512 - 569 */
+	0xFFFFFFFFFFFFFDC7ull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull, };
+static u64 tc512a_n[] = {
+	0xCACDB1411F10B275ull, 0x9B4B38ABFAD2B85Dull,
+	0x6FF22B8D4E056060ull, 0x27E69532F48D8911ull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull, };
+static u64 tc512a_a[] = { /* a = p - 3 */
+	0xFFFFFFFFFFFFFDC4ull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+	0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull, };
+static u64 tc512a_b[] = {
+	0x503190785A71C760ull, 0x862EF9D4EBEE4761ull,
+	0x4CB4574010DA90DDull, 0xEE3CB090F30D2761ull,
+	0x79BD081CFD0B6265ull, 0x34B82574761CB0E8ull,
+	0xC1BD0B2B6667F1DAull, 0xE8C2505DEDFC86DDull, };
+
+static struct ecc_curve gost_tc512a = {
+	.name = "tc512a",
+	.g = {
+		.x = tc512a_g_x,
+		.y = tc512a_g_y,
+		.ndigits = 512 / 64,
+	},
+	.p = tc512a_p,
+	.n = tc512a_n,
+	.a = tc512a_a,
+	.b = tc512a_b
+};
+
+/* OID_gostTC26Sign512B 1.2.643.7.1.2.1.2.2 */
+static u64 tc512b_g_x[] = {
+	0x0000000000000002ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull, };
+static u64 tc512b_g_y[] = {
+	0x7E21340780FE41BDull, 0x28041055F94CEEECull,
+	0x152CBCAAF8C03988ull, 0xDCB228FD1EDF4A39ull,
+	0xBE6DD9E6C8EC7335ull, 0x3C123B697578C213ull,
+	0x2C071E3647A8940Full, 0x1A8F7EDA389B094Cull, };
+static u64 tc512b_p[] = { /* p = 2^511 + 111 */
+	0x000000000000006Full, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x8000000000000000ull, };
+static u64 tc512b_n[] = {
+	0xC6346C54374F25BDull, 0x8B996712101BEA0Eull,
+	0xACFDB77BD9D40CFAull, 0x49A1EC142565A545ull,
+	0x0000000000000001ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x8000000000000000ull, };
+static u64 tc512b_a[] = { /* a = p - 3 */
+	0x000000000000006Cull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x0000000000000000ull,
+	0x0000000000000000ull, 0x8000000000000000ull, };
+static u64 tc512b_b[] = {
+	0xFB8CCBC7C5140116ull, 0x50F78BEE1FA3106Eull,
+	0x7F8B276FAD1AB69Cull, 0x3E965D2DB1416D21ull,
+	0xBF85DC806C4B289Full, 0xB97C7D614AF138BCull,
+	0x7E3E06CF6F5E2517ull, 0x687D1B459DC84145ull, };
+
+static struct ecc_curve gost_tc512b = {
+	.name = "tc512b",
+	.g = {
+		.x = tc512b_g_x,
+		.y = tc512b_g_y,
+		.ndigits = 512 / 64,
+	},
+	.p = tc512b_p,
+	.n = tc512b_n,
+	.a = tc512b_a,
+	.b = tc512b_b
+};
+
+#endif
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index d2fa9ca42e9a..7f30446348c4 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -93,6 +93,24 @@ enum OID {
 	OID_authorityKeyIdentifier,	/* 2.5.29.35 */
 	OID_extKeyUsage,		/* 2.5.29.37 */
 
+	/* EC-RDSA */
+	OID_gostCPSignA,		/* 1.2.643.2.2.35.1 */
+	OID_gostCPSignB,		/* 1.2.643.2.2.35.2 */
+	OID_gostCPSignC,		/* 1.2.643.2.2.35.3 */
+	OID_gost2012PKey256,		/* 1.2.643.7.1.1.1.1 */
+	OID_gost2012PKey512,		/* 1.2.643.7.1.1.1.2 */
+	OID_gost2012Digest256,		/* 1.2.643.7.1.1.2.2 */
+	OID_gost2012Digest512,		/* 1.2.643.7.1.1.2.3 */
+	OID_gost2012Signature256,	/* 1.2.643.7.1.1.3.2 */
+	OID_gost2012Signature512,	/* 1.2.643.7.1.1.3.3 */
+	OID_gostTC26Sign256A,		/* 1.2.643.7.1.2.1.1.1 */
+	OID_gostTC26Sign256B,		/* 1.2.643.7.1.2.1.1.2 */
+	OID_gostTC26Sign256C,		/* 1.2.643.7.1.2.1.1.3 */
+	OID_gostTC26Sign256D,		/* 1.2.643.7.1.2.1.1.4 */
+	OID_gostTC26Sign512A,		/* 1.2.643.7.1.2.1.2.1 */
+	OID_gostTC26Sign512B,		/* 1.2.643.7.1.2.1.2.2 */
+	OID_gostTC26Sign512C,		/* 1.2.643.7.1.2.1.2.3 */
+
 	OID__NR
 };
 
-- 
2.11.0

