From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3] crypto: ecc: Remove stack VLA usage
Date: Mon, 26 Mar 2018 16:03:30 -0700
Message-ID: <20180326230330.GA27127@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On the quest to remove all VLAs from the kernel[1], this avoids VLAs
by just using the maximum allocation size (4 bytes) for stack arrays.
All the VLAs in ecc were either 3 or 4 bytes (or a multiple), so just
make it 4 bytes all the time. Initialization routines are adjusted to
check that ndigits does not end up larger than the arrays.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This expects 14de52112ee70ca289fa77bf2d9cbc79fd2c811f to be reverted.
---
 crypto/ecc.c  | 47 ++++++++++++++++++++++++-----------------------
 crypto/ecc.h  |  4 +++-
 crypto/ecdh.c |  4 ++--
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 18f32f2a5e1c..815541309a95 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -515,7 +515,7 @@ static void vli_mmod_fast_256(u64 *result, const u64 *product,
 static bool vli_mmod_fast(u64 *result, u64 *product,
 			  const u64 *curve_prime, unsigned int ndigits)
 {
-	u64 tmp[2 * ndigits];
+	u64 tmp[2 * ECC_MAX_DIGITS];
 
 	switch (ndigits) {
 	case 3:
@@ -536,7 +536,7 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
 static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
 			      const u64 *curve_prime, unsigned int ndigits)
 {
-	u64 product[2 * ndigits];
+	u64 product[2 * ECC_MAX_DIGITS];
 
 	vli_mult(product, left, right, ndigits);
 	vli_mmod_fast(result, product, curve_prime, ndigits);
@@ -546,7 +546,7 @@ static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
 static void vli_mod_square_fast(u64 *result, const u64 *left,
 				const u64 *curve_prime, unsigned int ndigits)
 {
-	u64 product[2 * ndigits];
+	u64 product[2 * ECC_MAX_DIGITS];
 
 	vli_square(product, left, ndigits);
 	vli_mmod_fast(result, product, curve_prime, ndigits);
@@ -560,8 +560,8 @@ static void vli_mod_square_fast(u64 *result, const u64 *left,
 static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 			unsigned int ndigits)
 {
-	u64 a[ndigits], b[ndigits];
-	u64 u[ndigits], v[ndigits];
+	u64 a[ECC_MAX_DIGITS], b[ECC_MAX_DIGITS];
+	u64 u[ECC_MAX_DIGITS], v[ECC_MAX_DIGITS];
 	u64 carry;
 	int cmp_result;
 
@@ -649,8 +649,8 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
 				      u64 *curve_prime, unsigned int ndigits)
 {
 	/* t1 = x, t2 = y, t3 = z */
-	u64 t4[ndigits];
-	u64 t5[ndigits];
+	u64 t4[ECC_MAX_DIGITS];
+	u64 t5[ECC_MAX_DIGITS];
 
 	if (vli_is_zero(z1, ndigits))
 		return;
@@ -711,7 +711,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
 static void apply_z(u64 *x1, u64 *y1, u64 *z, u64 *curve_prime,
 		    unsigned int ndigits)
 {
-	u64 t1[ndigits];
+	u64 t1[ECC_MAX_DIGITS];
 
 	vli_mod_square_fast(t1, z, curve_prime, ndigits);    /* z^2 */
 	vli_mod_mult_fast(x1, x1, t1, curve_prime, ndigits); /* x1 * z^2 */
@@ -724,7 +724,7 @@ static void xycz_initial_double(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
 				u64 *p_initial_z, u64 *curve_prime,
 				unsigned int ndigits)
 {
-	u64 z[ndigits];
+	u64 z[ECC_MAX_DIGITS];
 
 	vli_set(x2, x1, ndigits);
 	vli_set(y2, y1, ndigits);
@@ -750,7 +750,7 @@ static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
 		     unsigned int ndigits)
 {
 	/* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
-	u64 t5[ndigits];
+	u64 t5[ECC_MAX_DIGITS];
 
 	/* t5 = x2 - x1 */
 	vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
@@ -791,9 +791,9 @@ static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
 		       unsigned int ndigits)
 {
 	/* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
-	u64 t5[ndigits];
-	u64 t6[ndigits];
-	u64 t7[ndigits];
+	u64 t5[ECC_MAX_DIGITS];
+	u64 t6[ECC_MAX_DIGITS];
+	u64 t7[ECC_MAX_DIGITS];
 
 	/* t5 = x2 - x1 */
 	vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
@@ -846,9 +846,9 @@ static void ecc_point_mult(struct ecc_point *result,
 			   unsigned int ndigits)
 {
 	/* R0 and R1 */
-	u64 rx[2][ndigits];
-	u64 ry[2][ndigits];
-	u64 z[ndigits];
+	u64 rx[2][ECC_MAX_DIGITS];
+	u64 ry[2][ECC_MAX_DIGITS];
+	u64 z[ECC_MAX_DIGITS];
 	int i, nb;
 	int num_bits = vli_num_bits(scalar, ndigits);
 
@@ -943,13 +943,13 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 {
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
-	u64 priv[ndigits];
+	u64 priv[ECC_MAX_DIGITS];
 	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
 	unsigned int nbits = vli_num_bits(curve->n, ndigits);
 	int err;
 
 	/* Check that N is included in Table 1 of FIPS 186-4, section 6.1.1 */
-	if (nbits < 160)
+	if (nbits < 160 || ndigits > ARRAY_SIZE(priv))
 		return -EINVAL;
 
 	/*
@@ -988,10 +988,10 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 {
 	int ret = 0;
 	struct ecc_point *pk;
-	u64 priv[ndigits];
+	u64 priv[ECC_MAX_DIGITS];
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 
-	if (!private_key || !curve) {
+	if (!private_key || !curve || ndigits > ARRAY_SIZE(priv)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1025,12 +1025,13 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 {
 	int ret = 0;
 	struct ecc_point *product, *pk;
-	u64 priv[ndigits];
-	u64 rand_z[ndigits];
+	u64 priv[ECC_MAX_DIGITS];
+	u64 rand_z[ECC_MAX_DIGITS];
 	unsigned int nbytes;
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 
-	if (!private_key || !public_key || !curve) {
+	if (!private_key || !public_key || !curve ||
+	    ndigits > ARRAY_SIZE(priv) || ndigits > ARRAY_SIZE(rand_z)) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/crypto/ecc.h b/crypto/ecc.h
index e4fd4492c765..f75a86baa3bd 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -26,7 +26,9 @@
 #ifndef _CRYPTO_ECC_H
 #define _CRYPTO_ECC_H
 
-#define ECC_MAX_DIGITS	4 /* 256 */
+#define ECC_CURVE_NIST_P192_DIGITS  3
+#define ECC_CURVE_NIST_P256_DIGITS  4
+#define ECC_MAX_DIGITS              ECC_CURVE_NIST_P256_DIGITS
 
 #define ECC_DIGITS_TO_BYTES_SHIFT 3
 
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 3aca0933ec44..3f91ef13c8c6 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -30,8 +30,8 @@ static inline struct ecdh_ctx *ecdh_get_ctx(struct crypto_kpp *tfm)
 static unsigned int ecdh_supported_curve(unsigned int curve_id)
 {
 	switch (curve_id) {
-	case ECC_CURVE_NIST_P192: return 3;
-	case ECC_CURVE_NIST_P256: return 4;
+	case ECC_CURVE_NIST_P192: return ECC_CURVE_NIST_P192_DIGITS;
+	case ECC_CURVE_NIST_P256: return ECC_CURVE_NIST_P256_DIGITS;
 	default: return 0;
 	}
 }
-- 
2.7.4


-- 
Kees Cook
Pixel Security
