Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:53284 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfAFNhO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 08:37:14 -0500
From: Vitaly Chikunov <vt@altlinux.org>
To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/4] crypto: Add EC-RDSA algorithm
Date: Sun,  6 Jan 2019 16:36:08 +0300
Message-Id: <20190106133608.820-5-vt@altlinux.org>
In-Reply-To: <20190106133608.820-1-vt@altlinux.org>
References: <20190106133608.820-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Elliptic Curve Russian Digital Signature Algorithm (GOST R
34.10-2012, RFC 7091, ISO/IEC 14888-3) is one of the Russian (and since
2018 the CIS countries) cryptographic standard algorithms (called GOST
algorithms). Only signature verification is supported, with intent to be
used in the IMA.

Summary of the changes:

crypto/Kconfig:
- Public-key methods are moved to the new "Public-key cryptography"
  section;
- Where EC-RDSA is added.

crypto/Makefile:
- ecc.o is split into a separate module to use both by ecdh and ecrdsa.

crypto/asymmetric_keys/x509_cert_parser.c:
- Recognize EC-RDSA and Streebog OIDs.

include/linux/oid_registry.h:
- EC-RDSA OIDs are added to the enum. Also, a few currently not used
  curve OIDs are added for possible extension later (to not change
  numbering and grouping).

crypto/ecc.c:
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
  vli_mmod_fast - integrated non-strict heuristic to call optimal
    module reduction function depending on the prime value;
  vli_mod_mult_slow - modular multiplication;
  ecc_point_add - add two points;
  ecc_point_mult_shamir - add two points multiplied by scalars in one
    combined multiplication (this gives speed up by another factor 2 in
    compare to two separate multiplications).

crypto/ecc.h:
- struct ecc_point and struct ecc_curve definitions are moved from
  ecc.c and slightly extended.
- All exported functions are documented.

crypto/ecrdsa.c:
- All five curves are defined locally since they are limited to use by
  EC-RDSA. (Possible by ECDH too, though.)
- Only signature verification is implemented.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/Kconfig                            |  63 ++--
 crypto/Makefile                           |   5 +-
 crypto/asymmetric_keys/x509_cert_parser.c |  13 +
 crypto/ecc.c                              | 421 +++++++++++++++++++++++--
 crypto/ecc.h                              | 162 +++++++++-
 crypto/ecc_curve_defs.h                   |  15 -
 crypto/ecrdsa.c                           | 494 ++++++++++++++++++++++++++++++
 include/linux/oid_registry.h              |  12 +
 8 files changed, 1126 insertions(+), 59 deletions(-)
 create mode 100644 crypto/ecrdsa.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b6376d5d973e..75783af857ce 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -113,29 +113,6 @@ config CRYPTO_ACOMP
 	select CRYPTO_ALGAPI
 	select CRYPTO_ACOMP2
 
-config CRYPTO_RSA
-	tristate "RSA algorithm"
-	select CRYPTO_AKCIPHER
-	select CRYPTO_MANAGER
-	select MPILIB
-	select ASN1
-	help
-	  Generic implementation of the RSA public key algorithm.
-
-config CRYPTO_DH
-	tristate "Diffie-Hellman algorithm"
-	select CRYPTO_KPP
-	select MPILIB
-	help
-	  Generic implementation of the Diffie-Hellman algorithm.
-
-config CRYPTO_ECDH
-	tristate "ECDH algorithm"
-	select CRYPTO_KPP
-	select CRYPTO_RNG_DEFAULT
-	help
-	  Generic implementation of the ECDH algorithm
-
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
@@ -243,6 +220,46 @@ config CRYPTO_GLUE_HELPER_X86
 config CRYPTO_ENGINE
 	tristate
 
+comment "Public-key cryptography"
+
+config CRYPTO_RSA
+	tristate "RSA algorithm"
+	select CRYPTO_AKCIPHER
+	select CRYPTO_MANAGER
+	select MPILIB
+	select ASN1
+	help
+	  Generic implementation of the RSA public key algorithm.
+
+config CRYPTO_DH
+	tristate "Diffie-Hellman algorithm"
+	select CRYPTO_KPP
+	select MPILIB
+	help
+	  Generic implementation of the Diffie-Hellman algorithm.
+
+config CRYPTO_ECC
+	tristate
+
+config CRYPTO_ECDH
+	tristate "ECDH algorithm"
+	select CRYPTO_ECC
+	select CRYPTO_KPP
+	select CRYPTO_RNG_DEFAULT
+	help
+	  Generic implementation of the ECDH algorithm
+
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
index 5e789dc2d4fd..5f0e24f75b02 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -146,12 +146,15 @@ obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_OFB) += ofb.o
+obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 
-ecdh_generic-y := ecc.o
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
+ecrdsa_generic-y += ecrdsa.o
+obj-$(CONFIG_CRYPTO_ECRDSA) += ecrdsa_generic.o
+
 #
 # generic algorithms and the async_tx api
 #
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 202a9dc66c93..a76ea216cd46 100644
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
diff --git a/crypto/ecc.c b/crypto/ecc.c
index ed1237115066..9a789926cc2a 100644
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
@@ -24,12 +24,15 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <linux/module.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/swab.h>
 #include <linux/fips.h>
 #include <crypto/ecdh.h>
 #include <crypto/rng.h>
+#include <asm/unaligned.h>
+#include <linux/ratelimit.h>
 
 #include "ecc.h"
 #include "ecc_curve_defs.h"
@@ -67,7 +70,7 @@ static void ecc_free_digits_space(u64 *space)
 	kzfree(space);
 }
 
-static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
+struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 {
 	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
 
@@ -93,7 +96,7 @@ static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 	return NULL;
 }
 
-static void ecc_free_point(struct ecc_point *p)
+void ecc_free_point(struct ecc_point *p)
 {
 	if (!p)
 		return;
@@ -112,7 +115,7 @@ static void vli_clear(u64 *vli, unsigned int ndigits)
 }
 
 /* Returns true if vli == 0, false otherwise. */
-static bool vli_is_zero(const u64 *vli, unsigned int ndigits)
+bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 {
 	int i;
 
@@ -123,6 +126,7 @@ static bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 
 	return true;
 }
+EXPORT_SYMBOL(vli_is_zero);
 
 /* Returns nonzero if bit bit of vli is set. */
 static u64 vli_test_bit(const u64 *vli, unsigned int bit)
@@ -130,6 +134,11 @@ static u64 vli_test_bit(const u64 *vli, unsigned int bit)
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
@@ -161,17 +170,39 @@ static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
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
-static void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
+void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
 {
 	int i;
 
 	for (i = 0; i < ndigits; i++)
 		dest[i] = src[i];
 }
+EXPORT_SYMBOL(vli_set);
 
 /* Returns sign of left - right. */
-static int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
+int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 {
 	int i;
 
@@ -184,6 +215,7 @@ static int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 
 	return 0;
 }
+EXPORT_SYMBOL(vli_cmp);
 
 /* Computes result = in << c, returning carry. Can modify in place
  * (if result == in). 0 < shift < 64.
@@ -239,8 +271,30 @@ static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
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
-static u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
+u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 		   unsigned int ndigits)
 {
 	u64 borrow = 0;
@@ -258,9 +312,37 @@ static u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 
 	return borrow;
 }
+EXPORT_SYMBOL(vli_sub);
+
+/* Computes result = left - right, returning borrow. Can modify in place. */
+u64 vli_usub(u64 *result, const u64 *left, u64 right,
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
@@ -269,7 +351,6 @@ static uint128_t mul_64_64(u64 left, u64 right)
 	u64 m1 = a0 * b1;
 	u64 m2 = a1 * b0;
 	u64 m3 = a1 * b1;
-	uint128_t result;
 
 	m2 += (m0 >> 32);
 	m2 += m1;
@@ -280,7 +361,7 @@ static uint128_t mul_64_64(u64 left, u64 right)
 
 	result.m_low = (m0 & 0xffffffffull) | (m2 << 32);
 	result.m_high = m3 + (m2 >> 32);
-
+#endif
 	return result;
 }
 
@@ -290,7 +371,6 @@ static uint128_t add_128_128(uint128_t a, uint128_t b)
 
 	result.m_low = a.m_low + b.m_low;
 	result.m_high = a.m_high + b.m_high + (result.m_low < a.m_low);
-
 	return result;
 }
 
@@ -330,6 +410,28 @@ static void vli_mult(u64 *result, const u64 *left, const u64 *right,
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
@@ -402,6 +504,167 @@ static void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
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
+	while (vli_cmp(r, t, ndigits * 2) >= 0) {
+		vli_sub(r, r, t, ndigits * 2);
+	}
+	vli_set(result, r, ndigits);
+}
+
+/*
+ * Computes result = product % mod
+ * for special form moduli: p = 2^{k-1}+c, for small c (note the plus sign)
+ * where k-1 does not fit into qword boundary by -1 bit (such as 255).
+
+ * References:
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
+/* Computes result = product % mod, where product is 2N words long. */
+/* Currently only designed to work for curve_p or curve_n. */
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
+ * length ndigits + 1, where mu * (2^w - 1) should not overflow ndigits boundary.
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
@@ -509,14 +772,32 @@ static void vli_mmod_fast_256(u64 *result, const u64 *product,
 	}
 }
 
-/* Computes result = product % curve_prime
- *  from http://www.nsa.gov/ia/_files/nist-routines.pdf
-*/
+/* Computes result = product % curve_prime for different curve_primes.
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
@@ -525,13 +806,26 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
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
@@ -557,7 +851,7 @@ static void vli_mod_square_fast(u64 *result, const u64 *left,
  * See "From Euclid's GCD to Montgomery Multiplication to the Great Divide"
  * https://labs.oracle.com/techrep/2001/smli_tr-2001-95.pdf
  */
-static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
+void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 			unsigned int ndigits)
 {
 	u64 a[ECC_MAX_DIGITS], b[ECC_MAX_DIGITS];
@@ -630,6 +924,7 @@ static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 
 	vli_set(result, u, ndigits);
 }
+EXPORT_SYMBOL(vli_mod_inv);
 
 /* ------ Point operations ------ */
 
@@ -903,6 +1198,85 @@ static void ecc_point_mult(struct ecc_point *result,
 	vli_set(result->y, ry[0], ndigits);
 }
 
+/* Computes R = P + Q mod p */
+void ecc_point_add(const struct ecc_point *result,
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
@@ -948,6 +1322,7 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 
 	return __ecc_is_key_valid(curve, private_key, ndigits);
 }
+EXPORT_SYMBOL(ecc_is_key_valid);
 
 /*
  * ECC private keys are generated using the method of extra random bits,
@@ -1000,6 +1375,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 
 	return 0;
 }
+EXPORT_SYMBOL(ecc_gen_privkey);
 
 int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, u64 *public_key)
@@ -1036,13 +1412,17 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(ecc_make_pub_key);
 
 /* SP800-56A section 5.6.2.3.4 partial verification: ephemeral keys only */
-static int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
-				       struct ecc_point *pk)
+int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
+				struct ecc_point *pk)
 {
 	u64 yy[ECC_MAX_DIGITS], xxx[ECC_MAX_DIGITS], w[ECC_MAX_DIGITS];
 
+	if (WARN_ON(pk->ndigits != curve->g.ndigits))
+		return -EINVAL;
+
 	/* Check 1: Verify key is not the zero point. */
 	if (ecc_point_is_zero(pk))
 		return -EINVAL;
@@ -1064,8 +1444,8 @@ static int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 		return -EINVAL;
 
 	return 0;
-
 }
+EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
 
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
@@ -1121,3 +1501,6 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(crypto_ecdh_shared_secret);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/ecc.h b/crypto/ecc.h
index f75a86baa3bd..6063dde083d8 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -28,11 +28,48 @@
 
 #define ECC_CURVE_NIST_P192_DIGITS  3
 #define ECC_CURVE_NIST_P256_DIGITS  4
-#define ECC_MAX_DIGITS              ECC_CURVE_NIST_P256_DIGITS
+#define ECC_MAX_DIGITS             (512 / 64)
 
 #define ECC_DIGITS_TO_BYTES_SHIFT 3
 
 /**
+ * struct ecc_point - elliptic curve point in affine coordinates
+ *
+ * @x:		X coordinate in vli form.
+ * @y:		Y coordinate in vli form.
+ * @ndigits:	Length of vlis.
+ */
+struct ecc_point {
+	u64 *x;
+	u64 *y;
+	u8 ndigits;
+};
+
+#define ECC_POINT_INIT(x, y, ndigits)	(struct ecc_point) { x, y, ndigits }
+
+/**
+ * struct ecc_curve - definition of elliptic curve
+ *
+ * @name:	Short name of the curve.
+ * @g:		Generator point of the curve.
+ * @p:		Prime number, if Barrett's reduction is used for this curve
+ *		pre-calculated value 'mu' is appended to the @p after ndigits.
+ *		Use of Barrett's reduction is heuristically determined in
+ *		vli_mmod_fast().
+ * @n:		Order of the curve group.
+ * @a:		Curve parameter a.
+ * @b:		Curve parameter b.
+ */
+struct ecc_curve {
+	char *name;
+	struct ecc_point g;
+	u64 *p;
+	u64 *n;
+	u64 *a;
+	u64 *b;
+};
+
+/**
  * ecc_is_key_valid() - Validate a given ECDH private key
  *
  * @curve_id:		id representing the curve to use
@@ -91,4 +128,127 @@ int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
 			      u64 *secret);
+
+/**
+ * ecc_is_pubkey_valid_partial() - Partial public key validation
+ *
+ * @curve:		elliptic curve domain parameters
+ * @pk:			public key as a point
+ *
+ * Valdiate public key according to SP800-56A section 5.6.2.3.4 ECC Partial
+ * Public-Key Validation Routine.
+ *
+ * Note: There is no check that the public key is in the correct elliptic curve
+ * subgroup.
+ *
+ * Return: 0 if validation is successful, -EINVAL if validation is failed.
+ */
+int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
+				struct ecc_point *pk);
+
+/**
+ * vli_set() - Copy vli fro src to dest
+ *
+ * @dest:		target vli
+ * @src:		source vli
+ * @ndigits:		vli lengths
+ *
+ */
+void vli_set(u64 *dest, const u64 *src, unsigned int ndigits);
+
+/**
+ * vli_is_zero() - Determine is vli is zero
+ *
+ * @vli:		vli to check.
+ * @ndigits:		length of the @vli
+ */
+bool vli_is_zero(const u64 *vli, unsigned int ndigits);
+
+/**
+ * vli_cmp() - compare left and right vlis
+ *
+ * @left:		vli
+ * @right:		vli
+ * @ndigits:		length of both vlis
+ *
+ * Returns sign of @left - @right, i.e. -1 if @left < @right,
+ * 0 if @left == @right, 1 if @left > @right.
+ */
+int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits);
+
+/**
+ * vli_sub() - Subtracts right from left
+ *
+ * @result:		where to write result
+ * @left:		vli
+ * @right		vli
+ * @ndigits:		length of all vlis
+ *
+ * Note: can modify in-place.
+ *
+ * Return: carry bit.
+ */
+u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
+	    unsigned int ndigits);
+
+/**
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
+ * vli_mod_inv() - Modular inversion
+ *
+ * @result:		where to write vli number
+ * @input:		vli value to operate on
+ * @mod:		modulus
+ * @ndigits:		length of all vlis
+ */
+void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
+		 unsigned int ndigits);
+
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
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 336ab1805639..69be6c7d228f 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -2,21 +2,6 @@
 #ifndef _CRYTO_ECC_CURVE_DEFS_H
 #define _CRYTO_ECC_CURVE_DEFS_H
 
-struct ecc_point {
-	u64 *x;
-	u64 *y;
-	u8 ndigits;
-};
-
-struct ecc_curve {
-	char *name;
-	struct ecc_point g;
-	u64 *p;
-	u64 *n;
-	u64 *a;
-	u64 *b;
-};
-
 /* NIST P-192: a = p - 3 */
 static u64 nist_p192_g_x[] = { 0xF4FF0AFD82FF1012ull, 0x7CBF20EB43A18800ull,
 				0x188DA80EB03090F6ull };
diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
new file mode 100644
index 000000000000..bf5ddd6e22ca
--- /dev/null
+++ b/crypto/ecrdsa.c
@@ -0,0 +1,494 @@
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
+
+#include "ecc.h"
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
+	unsigned int key_len; /* key length (bytes) */
+	struct ecc_point pub_key;
+	u64 _pubp[2][ECRDSA_MAX_DIGITS];
+};
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
+	default:
+		return NULL;
+	}
+}
+
+static int ecrdsa_sign(struct akcipher_request *req)
+{
+	return -ENOSYS;
+}
+
+static int ecrdsa_verify2(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	unsigned char sig[ECRDSA_MAX_SIG_SIZE + 1];
+	unsigned int ndigits = req->digest_len / sizeof(u64);
+	u64 e[ECRDSA_MAX_DIGITS]; /* h \mod q */
+	u64 r[ECRDSA_MAX_DIGITS]; /* witness (r) */
+	u64 s[ECRDSA_MAX_DIGITS]; /* second part of sig (s) */
+	u64 v[ECRDSA_MAX_DIGITS]; /* e^{-1} \mod q */
+	u64 z1[ECRDSA_MAX_DIGITS];
+	u64 z2[ECRDSA_MAX_DIGITS];
+	u64 cpt[2][ECRDSA_MAX_DIGITS];
+	struct ecc_point cc = ECC_POINT_INIT(cpt[0], cpt[1], ndigits);
+
+	/*
+	 * Digest value, digest algorithm, and curve (modulus) should have the same
+	 * length (256 or 512 bits), public key and signature should be twice bigger
+	 * (plus 1 byte for BIT STRING of signature metadata).
+	 */
+	if (!ctx->curve ||
+	    !ctx->digest ||
+	    !req->digest ||
+	    !ctx->pub_key.x ||
+	    req->digest_len != ctx->digest_len ||
+	    req->digest_len != ctx->curve->g.ndigits * sizeof(u64) ||
+	    ctx->pub_key.ndigits != ctx->curve->g.ndigits ||
+	    req->digest_len * 2 != req->src_len - 1 ||
+	    WARN_ON(req->src_len > sizeof(sig)))
+		return -EBADMSG;
+
+	sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, req->src_len),
+			  sig, req->src_len);
+
+	if (sig[0]) /* invalid BIT STRING */
+		return -EBADMSG;
+
+	vli_from_be64(s, sig + 1, ndigits);
+	vli_from_be64(r, sig + 1 + ndigits * sizeof(u64), ndigits);
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
+	vli_from_le64(e, req->digest, ndigits);
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
+/* Parse DER encoded subjectPublicKey. */
+static int ecrdsa_set_pub_key(struct crypto_akcipher *tfm, const void *ber,
+			      unsigned int len)
+{
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	unsigned int ndigits;
+	const u8 *k = ber;
+	unsigned int offset;
+
+	/* First chance to zero ctx */
+	memset(ctx, 0, sizeof(*ctx));
+
+	if (len < 3 ||
+	    k[0] != 0x04 || /* OCTET STRING */
+	    (k[1] < 0x80 && len != k[1] + 2) ||
+	    (k[1] == 0x81 && len != k[2] + 3) ||
+	    k[1] > 0x81)
+		return -EBADMSG;
+	offset = (k[1] < 0x80)? 2 : 3;
+	k += offset;
+	len -= offset;
+	/* Key is two 256- or 512-bit coordinates. */
+	if (len != (2 * 256 / 8) &&
+	    len != (2 * 512 / 8))
+		return -ENOPKG;
+	ndigits = len / sizeof(u64) / 2;
+	ctx->pub_key = ECC_POINT_INIT(ctx->_pubp[0], ctx->_pubp[1], ndigits);
+	vli_from_le64(ctx->pub_key.x, k, ndigits);
+	vli_from_le64(ctx->pub_key.y, k + ndigits * sizeof(u64), ndigits);
+
+	return 0;
+}
+
+/* Parse DER encoded SubjectPublicKeyInfo.AlgorithmIdentifier.parameters. */
+static int ecrdsa_set_params(struct crypto_akcipher *tfm, enum OID algo,
+			     const void *params, unsigned int paramlen)
+{
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	const u8 *p = params;
+	int i;
+
+	if (algo == OID_gost2012PublicKey256) {
+		ctx->digest	= "streebog256";
+		ctx->digest_oid	= OID_gost2012Digest256;
+		ctx->digest_len	= 256 / 8;
+	} else if (algo == OID_gost2012PublicKey512) {
+		ctx->digest	= "streebog512";
+		ctx->digest_oid	= OID_gost2012Digest512;
+		ctx->digest_len	= 512 / 8;
+	} else
+		return -ENOPKG;
+	ctx->curve = NULL;
+	ctx->curve_oid = 0;
+	ctx->algo_oid = algo;
+
+	for (i = 0; i < paramlen; i += p[i + 1] + 2) {
+		const struct ecc_curve *curve;
+		enum OID oid;
+
+		if (paramlen - i < 2 ||
+		    p[i] != 0x06 || /* OBJECT IDENTIFIER */
+		    p[i + 1] > paramlen - i - 2)
+			return -EBADMSG;
+		oid = look_up_OID(p + i + 2, p[i + 1]);
+		if (oid == OID__NR)
+			return -ENOPKG;
+
+		if (oid == OID_gost2012Digest256 ||
+		    oid == OID_gost2012Digest512) {
+			if (oid != ctx->digest_oid)
+				return -ENOPKG;
+		} else {
+			curve = get_curve_by_oid(oid);
+			if (!curve || ctx->curve)
+				return -ENOPKG;
+			ctx->curve = curve;
+			ctx->curve_oid = oid;
+		}
+	}
+	/* Sizes of algo, curve, pub_key, and digest should match each other. */
+	if (!ctx->curve ||
+	    ctx->curve->g.ndigits * sizeof(u64) != ctx->digest_len ||
+	    ctx->curve->g.ndigits != ctx->pub_key.ndigits)
+		return -ENOPKG;
+
+	/* First chance to validate the public key. */
+	if (ecc_is_pubkey_valid_partial(ctx->curve, &ctx->pub_key))
+		return -EKEYREJECTED;
+
+	return 0;
+}
+
+static int ecrdsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+			       unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
+static unsigned int ecrdsa_max_size(struct crypto_akcipher *tfm)
+{
+	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	/* verify2 doesn't need any output, so it's just informational
+	 * for keyctl for a key size.
+	 */
+	return ctx->pub_key.ndigits * sizeof(u64);
+}
+
+static void ecrdsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+}
+
+static struct akcipher_alg ecrdsa_alg = {
+	.sign		= ecrdsa_sign,
+	.verify2	= ecrdsa_verify2,
+	.set_priv_key	= ecrdsa_set_priv_key,
+	.set_pub_key	= ecrdsa_set_pub_key,
+	.set_params	= ecrdsa_set_params,
+	.max_size	= ecrdsa_max_size,
+	.exit		= ecrdsa_exit_tfm,
+	.reqsize	= sizeof(struct ecrdsa_ctx),
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
+MODULE_ALIAS_CRYPTO("ecrdsa");
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index e2e323fd4826..1cc4d58d3bff 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -94,10 +94,22 @@ enum OID {
 	OID_extKeyUsage,		/* 2.5.29.37 */
 
 	/* EC-RDSA */
+	OID_gostCPSignA,		/* 1.2.643.2.2.35.1 */
+	OID_gostCPSignB,		/* 1.2.643.2.2.35.2 */
+	OID_gostCPSignC,		/* 1.2.643.2.2.35.3 */
 	OID_gost2012PublicKey256,	/* 1.2.643.7.1.1.1.1 */
 	OID_gost2012PublicKey512,	/* 1.2.643.7.1.1.1.2 */
+	OID_gost2012Digest256,		/* 1.2.643.7.1.1.2.2 */
+	OID_gost2012Digest512,		/* 1.2.643.7.1.1.2.3 */
 	OID_gost2012Signature256,	/* 1.2.643.7.1.1.3.2 */
 	OID_gost2012Signature512,	/* 1.2.643.7.1.1.3.3 */
+	OID_gostTC26Sign256A,		/* 1.2.643.7.1.2.1.1.1 */
+	OID_gostTC26Sign256B,		/* 1.2.643.7.1.2.1.1.2 */
+	OID_gostTC26Sign256C,		/* 1.2.643.7.1.2.1.1.3 */
+	OID_gostTC26Sign256D,		/* 1.2.643.7.1.2.1.1.4 */
+	OID_gostTC26Sign512A,		/* 1.2.643.7.1.2.1.2.1 */
+	OID_gostTC26Sign512B,		/* 1.2.643.7.1.2.1.2.2 */
+	OID_gostTC26Sign512C,		/* 1.2.643.7.1.2.1.2.3 */
 
 	OID__NR
 };
-- 
2.11.0
