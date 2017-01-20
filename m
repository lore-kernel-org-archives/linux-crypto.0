From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: [PATCH 2/6] crypto: ecc: add vli and ecc ops
Date: Fri, 20 Jan 2017 17:05:57 +0530
Message-ID: <1484912161-5932-3-git-send-email-nkumbhar@nvidia.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, Nitin Kumbhar <nkumbhar@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5448 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdATLg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 06:36:57 -0500
In-Reply-To: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add functions to copy vli from buffers, to print vli in
big endian format, for vli mod and mod multiplication ops
and ecc point addition.

Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
---
 crypto/ecc.c |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 168 insertions(+), 0 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index a8c10e725138..6ad785c4c12a 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -208,6 +208,42 @@ static void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
 		dest[i] = src[i];
 }
 
+/* Copy from vli to buf.
+ * For buffers smaller than vli: copy only LSB nbytes from vli.
+ * For buffers larger than vli : fill up remaining buf with zeroes.
+ */
+void vli_copy_to_buf(u8 *dst_buf, unsigned int buf_len,
+		     const u64 *src_vli, unsigned int ndigits)
+{
+	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	u8 *vli = (u8 *)src_vli;
+	int i;
+
+	for (i = 0; i < buf_len && i < nbytes; i++)
+		dst_buf[i] = vli[i];
+
+	for (; i < buf_len; i++)
+		dst_buf[i] = 0;
+}
+
+/* Copy from buffer to vli.
+ * For buffers smaller than vli: fill up remaining vli with zeroes.
+ * For buffers larger than vli : copy only LSB nbytes to vli.
+ */
+void vli_copy_from_buf(u64 *dst_vli, unsigned int ndigits,
+		       const u8 *src_buf, unsigned int buf_len)
+{
+	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	u8 *vli = (u8 *)dst_vli;
+	int i;
+
+	for (i = 0; i < buf_len && i < nbytes; i++)
+		vli[i] = src_buf[i];
+
+	for (; i < nbytes; i++)
+		vli[i] = 0;
+}
+
 /* Returns sign of left - right. */
 static int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 {
@@ -440,6 +476,83 @@ static void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
 		vli_add(result, result, mod, ndigits);
 }
 
+/* Computes result = input % mod.
+ * Assumes that input < mod, result != mod.
+ */
+void vli_mod(u64 *result, const u64 *input, const u64 *mod,
+	     unsigned int ndigits)
+{
+	if (vli_cmp(input, mod, ndigits) >= 0)
+		vli_sub(result, input, mod, ndigits);
+	else
+		vli_set(result, input, ndigits);
+}
+
+/* Print vli in big-endian format.
+ * The bytes are printed in hex.
+ */
+void vli_print(char *vli_name, const u64 *vli, unsigned int ndigits)
+{
+	int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	int buf_size = 2 * ECC_MAX_DIGIT_BYTES + 1;
+	unsigned char *c, buf[buf_size];
+	int i, j;
+
+	c = (unsigned char *)vli;
+
+	for (i = nbytes - 1, j = 0; i >= 0 && j < buf_size; i--, j += 2)
+		snprintf(&buf[j], 3, "%02x", *(c + i));
+
+	buf[j] = '\0';
+
+	pr_info("%20s(BigEnd)=%s\n", vli_name, buf);
+}
+
+/* Computes result = (left * right) % mod.
+ * Assumes that left < mod and right < mod, result != mod.
+ * Uses:
+ *	(a * b) % m = ((a % m) * (b % m)) % m
+ *	(a * b) % m = (a + a + ... + a) % m = b modular additions of (a % m)
+ */
+void vli_mod_mult(u64 *result, const u64 *left, const u64 *right,
+		  const u64 *mod, unsigned int ndigits)
+{
+	u64 t1[ndigits], mm[ndigits];
+	u64 aa[ndigits], bb[ndigits];
+
+	vli_clear(result, ndigits);
+	vli_set(aa, left, ndigits);
+	vli_set(bb, right, ndigits);
+	vli_set(mm, mod, ndigits);
+
+	/* aa = aa % mm */
+	vli_mod(aa, aa, mm, ndigits);
+
+	/* bb = bb % mm */
+	vli_mod(bb, bb, mm, ndigits);
+
+	while (!vli_is_zero(bb, ndigits)) {
+
+		/* if bb is odd i.e. 0th bit set then add
+		 * aa i.e. result = (result + aa) % mm
+		 */
+		if (vli_test_bit(bb, 0))
+			vli_mod_add(result, result, aa, mm, ndigits);
+
+		/* bb = bb / 2 = bb >> 1 */
+		vli_rshift1(bb, ndigits);
+
+		/* aa = (aa * 2) % mm */
+		vli_sub(t1, mm, aa, ndigits);
+		if (vli_cmp(aa, t1, ndigits) == -1)
+			/* if aa < t1 then aa = aa * 2 = aa << 1*/
+			vli_lshift(aa, aa, 1, ndigits);
+		else
+			/* if aa >= t1 then aa = aa - t1 */
+			vli_sub(aa, aa, t1, ndigits);
+	}
+}
+
 /* Computes p_result = p_product % curve_p.
  * See algorithm 5 and 6 from
  * http://www.isys.uni-klu.ac.at/PDF/2001-0126-MT.pdf
@@ -878,6 +991,61 @@ static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
 	vli_set(x1, t7, ndigits);
 }
 
+/* Point addition.
+ * Add 2 distinct points on elliptic curve to get a new point.
+ *
+ * P = (x1,y1)and Q = (x2, y2) then P + Q = (x3,y3) where
+ * x3 = ((y2-y1)/(x2-x1))^2 - x1 - x2
+ * y3 = ((y2-y1)/(x2-x1))(x1-x3) - y1
+ *
+ * Q => P + Q
+ */
+void ecc_point_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
+		   unsigned int ndigits)
+{
+	/* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
+	u64 t5[ndigits];
+	u64 t6[ndigits];
+	u64 t7[ndigits];
+
+	/* t6 = x2 - x1 */
+	vli_mod_sub(t6, x2, x1, curve_prime, ndigits);
+	/* t6 = (x2 - x1)^2 = A */
+	vli_mod_square_fast(t6, t6, curve_prime, ndigits);
+	vli_mod_inv(t7, t6, curve_prime, ndigits);
+	/* t5 = x2 - x1 */
+	vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
+	/* t5 = (x2 - x1)^2 = A */
+	vli_mod_square_fast(t5, t5, curve_prime, ndigits);
+	/* t1 = x1*A = B = x1*(x2-x1)^2*/
+	vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits);
+	/* t3 = x2*A = C = x2*(x2-x1)^2*/
+	vli_mod_mult_fast(x2, x2, t5, curve_prime, ndigits);
+	/* t4 = y2 - y1 */
+	vli_mod_sub(y2, y2, y1, curve_prime, ndigits);
+	/* t5 = (y2 - y1)^2 = D */
+	vli_mod_square_fast(t5, y2, curve_prime, ndigits);
+
+	/* t5 = D - B = (y2 - y1)^2 - x1*(x2-x1)^2 */
+	vli_mod_sub(t5, t5, x1, curve_prime, ndigits);
+	/* t5 = D - B - C = x3 = (y2 - y1)^2 - x1*(x2-x1)^2 - x2*(x2-x1)^2*/
+	vli_mod_sub(t5, t5, x2, curve_prime, ndigits);
+
+	/* t3 = C - B = x2*(x2-x1)^2 - x1*(x2-x1)^2 */
+	vli_mod_sub(x2, x2, x1, curve_prime, ndigits);
+	/* t2 = y1*(C - B) = y1*(x2*(x2-x1)^2 - x1*(x2-x1)^2)*/
+	vli_mod_mult_fast(y1, y1, x2, curve_prime, ndigits);
+	/* t3 = B - x3 = x1*(x2-x1)^2 - x3*/
+	vli_mod_sub(x2, x1, t5, curve_prime, ndigits);
+	/* t4 = (y2 - y1)*(B - x3)  = (y2 - y1)*(x1*(x2-x1)^2 - x3)*/
+	vli_mod_mult_fast(y2, y2, x2, curve_prime, ndigits);
+	/* t4 = y3 = ((y2 - y1)*(x1*(x2-x1)^2 - x3)) - y1*/
+	vli_mod_sub(y2, y2, y1, curve_prime, ndigits);
+
+	vli_mod_mult_fast(t5, t5, t7,  curve_prime, ndigits);
+	vli_set(x2, t5, ndigits);
+}
+
 static void ecc_point_mult(struct ecc_point *result,
 			   const struct ecc_point *point, const u64 *scalar,
 			   u64 *initial_z, u64 *curve_prime,
-- 
1.7.6.3
