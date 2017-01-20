From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: [PATCH 3/6] crypto: ecc: export vli and ecc ops
Date: Fri, 20 Jan 2017 17:05:58 +0530
Message-ID: <1484912161-5932-4-git-send-email-nkumbhar@nvidia.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, Nitin Kumbhar <nkumbhar@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2450 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbdATLg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 06:36:57 -0500
In-Reply-To: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Export vli and ECC related functions so that these can
be used by all ECC algorithm modules like ECDH, ECDSA and ECIES.

Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
---
 crypto/ecc.c |  114 +++++++++++++++++++++++++++++++++++++---------------------
 crypto/ecc.h |   53 +++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 41 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 6ad785c4c12a..c6fe1b7b998d 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -77,7 +77,7 @@
 	.n = nist_p256_n
 };
 
-static inline const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
+const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 {
 	switch (curve_id) {
 	/* In FIPS mode only allow P256 and higher */
@@ -89,6 +89,7 @@
 		return NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(ecc_get_curve);
 
 static u64 *ecc_alloc_digits_space(unsigned int ndigits)
 {
@@ -105,7 +106,7 @@ static void ecc_free_digits_space(u64 *space)
 	kzfree(space);
 }
 
-static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
+struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 {
 	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
 
@@ -130,8 +131,9 @@ static void ecc_free_digits_space(u64 *space)
 	kfree(p);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(ecc_alloc_point);
 
-static void ecc_free_point(struct ecc_point *p)
+void ecc_free_point(struct ecc_point *p)
 {
 	if (!p)
 		return;
@@ -140,17 +142,19 @@ static void ecc_free_point(struct ecc_point *p)
 	kzfree(p->y);
 	kzfree(p);
 }
+EXPORT_SYMBOL_GPL(ecc_free_point);
 
-static void vli_clear(u64 *vli, unsigned int ndigits)
+void vli_clear(u64 *vli, unsigned int ndigits)
 {
 	int i;
 
 	for (i = 0; i < ndigits; i++)
 		vli[i] = 0;
 }
+EXPORT_SYMBOL_GPL(vli_clear);
 
 /* Returns true if vli == 0, false otherwise. */
-static bool vli_is_zero(const u64 *vli, unsigned int ndigits)
+bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 {
 	int i;
 
@@ -161,15 +165,17 @@ static bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(vli_is_zero);
 
 /* Returns nonzero if bit bit of vli is set. */
-static u64 vli_test_bit(const u64 *vli, unsigned int bit)
+u64 vli_test_bit(const u64 *vli, unsigned int bit)
 {
 	return (vli[bit / 64] & ((u64)1 << (bit % 64)));
 }
+EXPORT_SYMBOL_GPL(vli_test_bit);
 
 /* Counts the number of 64-bit "digits" in vli. */
-static unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits)
+unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits)
 {
 	int i;
 
@@ -181,9 +187,10 @@ static unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits)
 
 	return (i + 1);
 }
+EXPORT_SYMBOL_GPL(vli_num_digits);
 
 /* Counts the number of bits required for vli. */
-static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
+unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 {
 	unsigned int i, num_digits;
 	u64 digit;
@@ -198,15 +205,17 @@ static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 
 	return ((num_digits - 1) * 64 + i);
 }
+EXPORT_SYMBOL_GPL(vli_num_bits);
 
 /* Sets dest = src. */
-static void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
+void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
 {
 	int i;
 
 	for (i = 0; i < ndigits; i++)
 		dest[i] = src[i];
 }
+EXPORT_SYMBOL_GPL(vli_set);
 
 /* Copy from vli to buf.
  * For buffers smaller than vli: copy only LSB nbytes from vli.
@@ -225,6 +234,7 @@ void vli_copy_to_buf(u8 *dst_buf, unsigned int buf_len,
 	for (; i < buf_len; i++)
 		dst_buf[i] = 0;
 }
+EXPORT_SYMBOL_GPL(vli_copy_to_buf);
 
 /* Copy from buffer to vli.
  * For buffers smaller than vli: fill up remaining vli with zeroes.
@@ -243,9 +253,10 @@ void vli_copy_from_buf(u64 *dst_vli, unsigned int ndigits,
 	for (; i < nbytes; i++)
 		vli[i] = 0;
 }
+EXPORT_SYMBOL_GPL(vli_copy_from_buf);
 
 /* Returns sign of left - right. */
-static int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
+int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 {
 	int i;
 
@@ -258,12 +269,13 @@ static int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vli_cmp);
 
 /* Computes result = in << c, returning carry. Can modify in place
  * (if result == in). 0 < shift < 64.
  */
-static u64 vli_lshift(u64 *result, const u64 *in, unsigned int shift,
-		      unsigned int ndigits)
+u64 vli_lshift(u64 *result, const u64 *in, unsigned int shift,
+	       unsigned int ndigits)
 {
 	u64 carry = 0;
 	int i;
@@ -277,9 +289,10 @@ static u64 vli_lshift(u64 *result, const u64 *in, unsigned int shift,
 
 	return carry;
 }
+EXPORT_SYMBOL_GPL(vli_lshift);
 
 /* Computes vli = vli >> 1. */
-static void vli_rshift1(u64 *vli, unsigned int ndigits)
+void vli_rshift1(u64 *vli, unsigned int ndigits)
 {
 	u64 *end = vli;
 	u64 carry = 0;
@@ -292,10 +305,11 @@ static void vli_rshift1(u64 *vli, unsigned int ndigits)
 		carry = temp << 63;
 	}
 }
+EXPORT_SYMBOL_GPL(vli_rshift1);
 
 /* Computes result = left + right, returning carry. Can modify in place. */
-static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
-		   unsigned int ndigits)
+u64 vli_add(u64 *result, const u64 *left, const u64 *right,
+	    unsigned int ndigits)
 {
 	u64 carry = 0;
 	int i;
@@ -312,10 +326,11 @@ static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
 
 	return carry;
 }
+EXPORT_SYMBOL_GPL(vli_add);
 
 /* Computes result = left - right, returning borrow. Can modify in place. */
-static u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
-		   unsigned int ndigits)
+u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
+	    unsigned int ndigits)
 {
 	u64 borrow = 0;
 	int i;
@@ -332,6 +347,7 @@ static u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 
 	return borrow;
 }
+EXPORT_SYMBOL_GPL(vli_sub);
 
 static uint128_t mul_64_64(u64 left, u64 right)
 {
@@ -368,8 +384,8 @@ static uint128_t add_128_128(uint128_t a, uint128_t b)
 	return result;
 }
 
-static void vli_mult(u64 *result, const u64 *left, const u64 *right,
-		     unsigned int ndigits)
+void vli_mult(u64 *result, const u64 *left, const u64 *right,
+	      unsigned int ndigits)
 {
 	uint128_t r01 = { 0, 0 };
 	u64 r2 = 0;
@@ -403,8 +419,9 @@ static void vli_mult(u64 *result, const u64 *left, const u64 *right,
 
 	result[ndigits * 2 - 1] = r01.m_low;
 }
+EXPORT_SYMBOL_GPL(vli_mult);
 
-static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
+void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
 {
 	uint128_t r01 = { 0, 0 };
 	u64 r2 = 0;
@@ -442,12 +459,13 @@ static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
 
 	result[ndigits * 2 - 1] = r01.m_low;
 }
+EXPORT_SYMBOL_GPL(vli_square);
 
 /* Computes result = (left + right) % mod.
  * Assumes that left < mod and right < mod, result != mod.
  */
-static void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
-			const u64 *mod, unsigned int ndigits)
+void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
+		 const u64 *mod, unsigned int ndigits)
 {
 	u64 carry;
 
@@ -459,12 +477,13 @@ static void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
 	if (carry || vli_cmp(result, mod, ndigits) >= 0)
 		vli_sub(result, result, mod, ndigits);
 }
+EXPORT_SYMBOL_GPL(vli_mod_add);
 
 /* Computes result = (left - right) % mod.
  * Assumes that left < mod and right < mod, result != mod.
  */
-static void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
-			const u64 *mod, unsigned int ndigits)
+void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
+		 const u64 *mod, unsigned int ndigits)
 {
 	u64 borrow = vli_sub(result, left, right, ndigits);
 
@@ -475,6 +494,7 @@ static void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
 	if (borrow)
 		vli_add(result, result, mod, ndigits);
 }
+EXPORT_SYMBOL_GPL(vli_mod_sub);
 
 /* Computes result = input % mod.
  * Assumes that input < mod, result != mod.
@@ -487,6 +507,7 @@ void vli_mod(u64 *result, const u64 *input, const u64 *mod,
 	else
 		vli_set(result, input, ndigits);
 }
+EXPORT_SYMBOL_GPL(vli_mod);
 
 /* Print vli in big-endian format.
  * The bytes are printed in hex.
@@ -507,6 +528,7 @@ void vli_print(char *vli_name, const u64 *vli, unsigned int ndigits)
 
 	pr_info("%20s(BigEnd)=%s\n", vli_name, buf);
 }
+EXPORT_SYMBOL_GPL(vli_print);
 
 /* Computes result = (left * right) % mod.
  * Assumes that left < mod and right < mod, result != mod.
@@ -552,6 +574,7 @@ void vli_mod_mult(u64 *result, const u64 *left, const u64 *right,
 			vli_sub(aa, aa, t1, ndigits);
 	}
 }
+EXPORT_SYMBOL_GPL(vli_mod_mult);
 
 /* Computes p_result = p_product % curve_p.
  * See algorithm 5 and 6 from
@@ -663,8 +686,8 @@ static void vli_mmod_fast_256(u64 *result, const u64 *product,
 /* Computes result = product % curve_prime
  *  from http://www.nsa.gov/ia/_files/nist-routines.pdf
 */
-static bool vli_mmod_fast(u64 *result, u64 *product,
-			  const u64 *curve_prime, unsigned int ndigits)
+bool vli_mmod_fast(u64 *result, u64 *product,
+		   const u64 *curve_prime, unsigned int ndigits)
 {
 	u64 tmp[2 * ndigits];
 
@@ -682,34 +705,37 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(vli_mmod_fast);
 
 /* Computes result = (left * right) % curve_prime. */
-static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
-			      const u64 *curve_prime, unsigned int ndigits)
+void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
+		       const u64 *curve_prime, unsigned int ndigits)
 {
 	u64 product[2 * ndigits];
 
 	vli_mult(product, left, right, ndigits);
 	vli_mmod_fast(result, product, curve_prime, ndigits);
 }
+EXPORT_SYMBOL_GPL(vli_mod_mult_fast);
 
 /* Computes result = left^2 % curve_prime. */
-static void vli_mod_square_fast(u64 *result, const u64 *left,
-				const u64 *curve_prime, unsigned int ndigits)
+void vli_mod_square_fast(u64 *result, const u64 *left,
+			 const u64 *curve_prime, unsigned int ndigits)
 {
 	u64 product[2 * ndigits];
 
 	vli_square(product, left, ndigits);
 	vli_mmod_fast(result, product, curve_prime, ndigits);
 }
+EXPORT_SYMBOL_GPL(vli_mod_square_fast);
 
 #define EVEN(vli) (!(vli[0] & 1))
 /* Computes result = (1 / p_input) % mod. All VLIs are the same size.
  * See "From Euclid's GCD to Montgomery Multiplication to the Great Divide"
  * https://labs.oracle.com/techrep/2001/smli_tr-2001-95.pdf
  */
-static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
-			unsigned int ndigits)
+void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
+		 unsigned int ndigits)
 {
 	u64 a[ndigits], b[ndigits];
 	u64 u[ndigits], v[ndigits];
@@ -781,23 +807,25 @@ static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 
 	vli_set(result, u, ndigits);
 }
+EXPORT_SYMBOL_GPL(vli_mod_inv);
 
 /* ------ Point operations ------ */
 
 /* Returns true if p_point is the point at infinity, false otherwise. */
-static bool ecc_point_is_zero(const struct ecc_point *point)
+bool ecc_point_is_zero(const struct ecc_point *point)
 {
 	return (vli_is_zero(point->x, point->ndigits) &&
 		vli_is_zero(point->y, point->ndigits));
 }
+EXPORT_SYMBOL_GPL(ecc_point_is_zero);
 
 /* Point multiplication algorithm using Montgomery's ladder with co-Z
  * coordinates. From http://eprint.iacr.org/2011/338.pdf
  */
 
 /* Double in place */
-static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
-				      u64 *curve_prime, unsigned int ndigits)
+void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
+			       u64 *curve_prime, unsigned int ndigits)
 {
 	/* t1 = x, t2 = y, t3 = z */
 	u64 t4[ndigits];
@@ -857,6 +885,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
 	vli_set(z1, y1, ndigits);
 	vli_set(y1, t4, ndigits);
 }
+EXPORT_SYMBOL_GPL(ecc_point_double_jacobian);
 
 /* Modify (x1, y1) => (x1 * z^2, y1 * z^3) */
 static void apply_z(u64 *x1, u64 *y1, u64 *z, u64 *curve_prime,
@@ -1045,11 +1074,12 @@ void ecc_point_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
 	vli_mod_mult_fast(t5, t5, t7,  curve_prime, ndigits);
 	vli_set(x2, t5, ndigits);
 }
+EXPORT_SYMBOL_GPL(ecc_point_add);
 
-static void ecc_point_mult(struct ecc_point *result,
-			   const struct ecc_point *point, const u64 *scalar,
-			   u64 *initial_z, u64 *curve_prime,
-			   unsigned int ndigits)
+void ecc_point_mult(struct ecc_point *result,
+		    const struct ecc_point *point, const u64 *scalar,
+		    u64 *initial_z, u64 *curve_prime,
+		    unsigned int ndigits)
 {
 	/* R0 and R1 */
 	u64 rx[2][ndigits];
@@ -1100,15 +1130,16 @@ static void ecc_point_mult(struct ecc_point *result,
 	vli_set(result->x, rx[0], ndigits);
 	vli_set(result->y, ry[0], ndigits);
 }
+EXPORT_SYMBOL_GPL(ecc_point_mult);
 
-static inline void ecc_swap_digits(const u64 *in, u64 *out,
-				   unsigned int ndigits)
+void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits)
 {
 	int i;
 
 	for (i = 0; i < ndigits; i++)
 		out[i] = __swab64(in[ndigits - 1 - i]);
 }
+EXPORT_SYMBOL_GPL(ecc_swap_digits);
 
 int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 		     const u8 *private_key, unsigned int private_key_len)
@@ -1133,3 +1164,4 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ecc_is_key_valid);
diff --git a/crypto/ecc.h b/crypto/ecc.h
index 5db82223d485..0f907a860d0b 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -31,6 +31,59 @@
 
 #include "ecc_curve_defs.h"
 
+const struct ecc_curve *ecc_get_curve(unsigned int curve_id);
+struct ecc_point *ecc_alloc_point(unsigned int ndigits);
+void ecc_free_point(struct ecc_point *p);
+
+void vli_clear(u64 *vli, unsigned int ndigits);
+bool vli_is_zero(const u64 *vli, unsigned int ndigits);
+unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits);
+unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits);
+void vli_set(u64 *dest, const u64 *src, unsigned int ndigits);
+void vli_copy_to_buf(u8 *dst_buf, unsigned int buf_len,
+		     const u64 *src_vli, unsigned int ndigits);
+void vli_copy_from_buf(u64 *dst_vli, unsigned int ndigits,
+		       const u8 *src_buf, unsigned int buf_len);
+int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits);
+u64 vli_lshift(u64 *result, const u64 *in, unsigned int shift,
+	       unsigned int ndigits);
+void vli_rshift1(u64 *vli, unsigned int ndigits);
+u64 vli_add(u64 *result, const u64 *left, const u64 *right,
+	    unsigned int ndigits);
+u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
+	    unsigned int ndigits);
+void vli_mult(u64 *result, const u64 *left, const u64 *right,
+	      unsigned int ndigits);
+void vli_square(u64 *result, const u64 *left, unsigned int ndigits);
+void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
+		 const u64 *mod, unsigned int ndigits);
+void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
+		 const u64 *mod, unsigned int ndigits);
+void vli_mod(u64 *result, const u64 *input, const u64 *mod,
+	     unsigned int ndigits);
+void vli_print(char *vli_name, const u64 *vli, unsigned int ndigits);
+void vli_mod_mult(u64 *result, const u64 *left, const u64 *right,
+		  const u64 *mod, unsigned int ndigits);
+bool vli_mmod_fast(u64 *result, u64 *product,
+		   const u64 *curve_prime, unsigned int ndigits);
+void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
+		       const u64 *curve_prime, unsigned int ndigits);
+void vli_mod_square_fast(u64 *result, const u64 *left,
+			 const u64 *curve_prime, unsigned int ndigits);
+void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
+		 unsigned int ndigits);
+
+bool ecc_point_is_zero(const struct ecc_point *point);
+void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
+			       u64 *curve_prime, unsigned int ndigits);
+void ecc_point_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
+		   unsigned int ndigits);
+void ecc_point_mult(struct ecc_point *result,
+		    const struct ecc_point *point, const u64 *scalar,
+		    u64 *initial_z, u64 *curve_prime,
+		    unsigned int ndigits);
+void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits);
+
 /**
  * ecc_is_key_valid() - Validate a given ECDH private key
  *
-- 
1.7.6.3
