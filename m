From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH v4] Bluetooth: convert smp and selftest to crypto kpp API
Date: Wed,  1 Jun 2016 11:00:18 +0100
Message-ID: <1464775218-96138-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org,
	marcel@holtmann.org, johan.hedberg@gmail.com
To: herbert@gondor.apana.org.au, gustavo@padovan.org,
	linux-bluetooth@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbcFAKAX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 06:00:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 * Convert both smp and selftest to crypto kpp API
 * Remove module ecc as not more required
 * Add ecdh_helper functions for wrapping kpp async calls

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---

Patch based on https://patchwork.kernel.org/patch/9145037/

Changes from v3:
 * Patch adjusted to minor API change. crypto_kpp_set_params no longer
   takes len as input parameter

Changes from v2:
 * Remove header guard in internal header
 * Shorter name for ecdh wrappers and fix 80chars issue
 * Add CRYPTO_ECDH dependency in bluetooth Kconfig

Changes from v1:
 * Convert ecc_make_key to kpp API


 net/bluetooth/Kconfig       |   1 +
 net/bluetooth/Makefile      |   2 +-
 net/bluetooth/ecc.c         | 816 --------------------------------------------
 net/bluetooth/ecc.h         |  54 ---
 net/bluetooth/ecdh_helper.c | 204 +++++++++++
 net/bluetooth/ecdh_helper.h |  27 ++
 net/bluetooth/selftest.c    |   6 +-
 net/bluetooth/smp.c         |   8 +-
 8 files changed, 240 insertions(+), 878 deletions(-)
 delete mode 100644 net/bluetooth/ecc.c
 delete mode 100644 net/bluetooth/ecc.h
 create mode 100644 net/bluetooth/ecdh_helper.c
 create mode 100644 net/bluetooth/ecdh_helper.h

diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 06c31b9..68f951b 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -13,6 +13,7 @@ menuconfig BT
 	select CRYPTO_CMAC
 	select CRYPTO_ECB
 	select CRYPTO_SHA256
+	select CRYPTO_ECDH
 	help
 	  Bluetooth is low-cost, low-power, short-range wireless technology.
 	  It was designed as a replacement for cables and other short-range
diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
index b3ff12e..c54d790 100644
--- a/net/bluetooth/Makefile
+++ b/net/bluetooth/Makefile
@@ -13,7 +13,7 @@ bluetooth_6lowpan-y := 6lowpan.o
 
 bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
 	hci_sock.o hci_sysfs.o l2cap_core.o l2cap_sock.o smp.o lib.o \
-	ecc.o hci_request.o mgmt_util.o
+	ecdh_helper.o hci_request.o mgmt_util.o
 
 bluetooth-$(CONFIG_BT_BREDR) += sco.o
 bluetooth-$(CONFIG_BT_HS) += a2mp.o amp.o
diff --git a/net/bluetooth/ecc.c b/net/bluetooth/ecc.c
deleted file mode 100644
index e1709f8..0000000
--- a/net/bluetooth/ecc.c
+++ /dev/null
@@ -1,816 +0,0 @@
-/*
- * Copyright (c) 2013, Kenneth MacKay
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *  * Redistributions of source code must retain the above copyright
- *   notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <linux/random.h>
-
-#include "ecc.h"
-
-/* 256-bit curve */
-#define ECC_BYTES 32
-
-#define MAX_TRIES 16
-
-/* Number of u64's needed */
-#define NUM_ECC_DIGITS (ECC_BYTES / 8)
-
-struct ecc_point {
-	u64 x[NUM_ECC_DIGITS];
-	u64 y[NUM_ECC_DIGITS];
-};
-
-typedef struct {
-	u64 m_low;
-	u64 m_high;
-} uint128_t;
-
-#define CURVE_P_32 {	0xFFFFFFFFFFFFFFFFull, 0x00000000FFFFFFFFull, \
-			0x0000000000000000ull, 0xFFFFFFFF00000001ull }
-
-#define CURVE_G_32 { \
-		{	0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,	\
-			0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull }, \
-		{	0xCBB6406837BF51F5ull, 0x2BCE33576B315ECEull,	\
-			0x8EE7EB4A7C0F9E16ull, 0x4FE342E2FE1A7F9Bull }	\
-}
-
-#define CURVE_N_32 {	0xF3B9CAC2FC632551ull, 0xBCE6FAADA7179E84ull,	\
-			0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFF00000000ull }
-
-static u64 curve_p[NUM_ECC_DIGITS] = CURVE_P_32;
-static struct ecc_point curve_g = CURVE_G_32;
-static u64 curve_n[NUM_ECC_DIGITS] = CURVE_N_32;
-
-static void vli_clear(u64 *vli)
-{
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++)
-		vli[i] = 0;
-}
-
-/* Returns true if vli == 0, false otherwise. */
-static bool vli_is_zero(const u64 *vli)
-{
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++) {
-		if (vli[i])
-			return false;
-	}
-
-	return true;
-}
-
-/* Returns nonzero if bit bit of vli is set. */
-static u64 vli_test_bit(const u64 *vli, unsigned int bit)
-{
-	return (vli[bit / 64] & ((u64) 1 << (bit % 64)));
-}
-
-/* Counts the number of 64-bit "digits" in vli. */
-static unsigned int vli_num_digits(const u64 *vli)
-{
-	int i;
-
-	/* Search from the end until we find a non-zero digit.
-	 * We do it in reverse because we expect that most digits will
-	 * be nonzero.
-	 */
-	for (i = NUM_ECC_DIGITS - 1; i >= 0 && vli[i] == 0; i--);
-
-	return (i + 1);
-}
-
-/* Counts the number of bits required for vli. */
-static unsigned int vli_num_bits(const u64 *vli)
-{
-	unsigned int i, num_digits;
-	u64 digit;
-
-	num_digits = vli_num_digits(vli);
-	if (num_digits == 0)
-		return 0;
-
-	digit = vli[num_digits - 1];
-	for (i = 0; digit; i++)
-		digit >>= 1;
-
-	return ((num_digits - 1) * 64 + i);
-}
-
-/* Sets dest = src. */
-static void vli_set(u64 *dest, const u64 *src)
-{
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++)
-		dest[i] = src[i];
-}
-
-/* Returns sign of left - right. */
-static int vli_cmp(const u64 *left, const u64 *right)
-{
-    int i;
-
-    for (i = NUM_ECC_DIGITS - 1; i >= 0; i--) {
-	    if (left[i] > right[i])
-		    return 1;
-	    else if (left[i] < right[i])
-		    return -1;
-    }
-
-    return 0;
-}
-
-/* Computes result = in << c, returning carry. Can modify in place
- * (if result == in). 0 < shift < 64.
- */
-static u64 vli_lshift(u64 *result, const u64 *in,
-			   unsigned int shift)
-{
-	u64 carry = 0;
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++) {
-		u64 temp = in[i];
-
-		result[i] = (temp << shift) | carry;
-		carry = temp >> (64 - shift);
-	}
-
-	return carry;
-}
-
-/* Computes vli = vli >> 1. */
-static void vli_rshift1(u64 *vli)
-{
-	u64 *end = vli;
-	u64 carry = 0;
-
-	vli += NUM_ECC_DIGITS;
-
-	while (vli-- > end) {
-		u64 temp = *vli;
-		*vli = (temp >> 1) | carry;
-		carry = temp << 63;
-	}
-}
-
-/* Computes result = left + right, returning carry. Can modify in place. */
-static u64 vli_add(u64 *result, const u64 *left,
-			const u64 *right)
-{
-	u64 carry = 0;
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++) {
-		u64 sum;
-
-		sum = left[i] + right[i] + carry;
-		if (sum != left[i])
-			carry = (sum < left[i]);
-
-		result[i] = sum;
-	}
-
-	return carry;
-}
-
-/* Computes result = left - right, returning borrow. Can modify in place. */
-static u64 vli_sub(u64 *result, const u64 *left, const u64 *right)
-{
-	u64 borrow = 0;
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++) {
-		u64 diff;
-
-		diff = left[i] - right[i] - borrow;
-		if (diff != left[i])
-			borrow = (diff > left[i]);
-
-		result[i] = diff;
-	}
-
-	return borrow;
-}
-
-static uint128_t mul_64_64(u64 left, u64 right)
-{
-	u64 a0 = left & 0xffffffffull;
-	u64 a1 = left >> 32;
-	u64 b0 = right & 0xffffffffull;
-	u64 b1 = right >> 32;
-	u64 m0 = a0 * b0;
-	u64 m1 = a0 * b1;
-	u64 m2 = a1 * b0;
-	u64 m3 = a1 * b1;
-	uint128_t result;
-
-	m2 += (m0 >> 32);
-	m2 += m1;
-
-	/* Overflow */
-	if (m2 < m1)
-		m3 += 0x100000000ull;
-
-	result.m_low = (m0 & 0xffffffffull) | (m2 << 32);
-	result.m_high = m3 + (m2 >> 32);
-
-	return result;
-}
-
-static uint128_t add_128_128(uint128_t a, uint128_t b)
-{
-	uint128_t result;
-
-	result.m_low = a.m_low + b.m_low;
-	result.m_high = a.m_high + b.m_high + (result.m_low < a.m_low);
-
-	return result;
-}
-
-static void vli_mult(u64 *result, const u64 *left, const u64 *right)
-{
-	uint128_t r01 = { 0, 0 };
-	u64 r2 = 0;
-	unsigned int i, k;
-
-	/* Compute each digit of result in sequence, maintaining the
-	 * carries.
-	 */
-	for (k = 0; k < NUM_ECC_DIGITS * 2 - 1; k++) {
-		unsigned int min;
-
-		if (k < NUM_ECC_DIGITS)
-			min = 0;
-		else
-			min = (k + 1) - NUM_ECC_DIGITS;
-
-		for (i = min; i <= k && i < NUM_ECC_DIGITS; i++) {
-			uint128_t product;
-
-			product = mul_64_64(left[i], right[k - i]);
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
-		}
-
-		result[k] = r01.m_low;
-		r01.m_low = r01.m_high;
-		r01.m_high = r2;
-		r2 = 0;
-	}
-
-	result[NUM_ECC_DIGITS * 2 - 1] = r01.m_low;
-}
-
-static void vli_square(u64 *result, const u64 *left)
-{
-	uint128_t r01 = { 0, 0 };
-	u64 r2 = 0;
-	int i, k;
-
-	for (k = 0; k < NUM_ECC_DIGITS * 2 - 1; k++) {
-		unsigned int min;
-
-		if (k < NUM_ECC_DIGITS)
-			min = 0;
-		else
-			min = (k + 1) - NUM_ECC_DIGITS;
-
-		for (i = min; i <= k && i <= k - i; i++) {
-			uint128_t product;
-
-			product = mul_64_64(left[i], left[k - i]);
-
-			if (i < k - i) {
-				r2 += product.m_high >> 63;
-				product.m_high = (product.m_high << 1) |
-						 (product.m_low >> 63);
-				product.m_low <<= 1;
-			}
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
-		}
-
-		result[k] = r01.m_low;
-		r01.m_low = r01.m_high;
-		r01.m_high = r2;
-		r2 = 0;
-	}
-
-	result[NUM_ECC_DIGITS * 2 - 1] = r01.m_low;
-}
-
-/* Computes result = (left + right) % mod.
- * Assumes that left < mod and right < mod, result != mod.
- */
-static void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
-			const u64 *mod)
-{
-	u64 carry;
-
-	carry = vli_add(result, left, right);
-
-	/* result > mod (result = mod + remainder), so subtract mod to
-	 * get remainder.
-	 */
-	if (carry || vli_cmp(result, mod) >= 0)
-		vli_sub(result, result, mod);
-}
-
-/* Computes result = (left - right) % mod.
- * Assumes that left < mod and right < mod, result != mod.
- */
-static void vli_mod_sub(u64 *result, const u64 *left, const u64 *right,
-			const u64 *mod)
-{
-	u64 borrow = vli_sub(result, left, right);
-
-	/* In this case, p_result == -diff == (max int) - diff.
-	 * Since -x % d == d - x, we can get the correct result from
-	 * result + mod (with overflow).
-	 */
-	if (borrow)
-		vli_add(result, result, mod);
-}
-
-/* Computes result = product % curve_p
-   from http://www.nsa.gov/ia/_files/nist-routines.pdf */
-static void vli_mmod_fast(u64 *result, const u64 *product)
-{
-	u64 tmp[NUM_ECC_DIGITS];
-	int carry;
-
-	/* t */
-	vli_set(result, product);
-
-	/* s1 */
-	tmp[0] = 0;
-	tmp[1] = product[5] & 0xffffffff00000000ull;
-	tmp[2] = product[6];
-	tmp[3] = product[7];
-	carry = vli_lshift(tmp, tmp, 1);
-	carry += vli_add(result, result, tmp);
-
-	/* s2 */
-	tmp[1] = product[6] << 32;
-	tmp[2] = (product[6] >> 32) | (product[7] << 32);
-	tmp[3] = product[7] >> 32;
-	carry += vli_lshift(tmp, tmp, 1);
-	carry += vli_add(result, result, tmp);
-
-	/* s3 */
-	tmp[0] = product[4];
-	tmp[1] = product[5] & 0xffffffff;
-	tmp[2] = 0;
-	tmp[3] = product[7];
-	carry += vli_add(result, result, tmp);
-
-	/* s4 */
-	tmp[0] = (product[4] >> 32) | (product[5] << 32);
-	tmp[1] = (product[5] >> 32) | (product[6] & 0xffffffff00000000ull);
-	tmp[2] = product[7];
-	tmp[3] = (product[6] >> 32) | (product[4] << 32);
-	carry += vli_add(result, result, tmp);
-
-	/* d1 */
-	tmp[0] = (product[5] >> 32) | (product[6] << 32);
-	tmp[1] = (product[6] >> 32);
-	tmp[2] = 0;
-	tmp[3] = (product[4] & 0xffffffff) | (product[5] << 32);
-	carry -= vli_sub(result, result, tmp);
-
-	/* d2 */
-	tmp[0] = product[6];
-	tmp[1] = product[7];
-	tmp[2] = 0;
-	tmp[3] = (product[4] >> 32) | (product[5] & 0xffffffff00000000ull);
-	carry -= vli_sub(result, result, tmp);
-
-	/* d3 */
-	tmp[0] = (product[6] >> 32) | (product[7] << 32);
-	tmp[1] = (product[7] >> 32) | (product[4] << 32);
-	tmp[2] = (product[4] >> 32) | (product[5] << 32);
-	tmp[3] = (product[6] << 32);
-	carry -= vli_sub(result, result, tmp);
-
-	/* d4 */
-	tmp[0] = product[7];
-	tmp[1] = product[4] & 0xffffffff00000000ull;
-	tmp[2] = product[5];
-	tmp[3] = product[6] & 0xffffffff00000000ull;
-	carry -= vli_sub(result, result, tmp);
-
-	if (carry < 0) {
-		do {
-			carry += vli_add(result, result, curve_p);
-		} while (carry < 0);
-	} else {
-		while (carry || vli_cmp(curve_p, result) != 1)
-			carry -= vli_sub(result, result, curve_p);
-	}
-}
-
-/* Computes result = (left * right) % curve_p. */
-static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right)
-{
-	u64 product[2 * NUM_ECC_DIGITS];
-
-	vli_mult(product, left, right);
-	vli_mmod_fast(result, product);
-}
-
-/* Computes result = left^2 % curve_p. */
-static void vli_mod_square_fast(u64 *result, const u64 *left)
-{
-	u64 product[2 * NUM_ECC_DIGITS];
-
-	vli_square(product, left);
-	vli_mmod_fast(result, product);
-}
-
-#define EVEN(vli) (!(vli[0] & 1))
-/* Computes result = (1 / p_input) % mod. All VLIs are the same size.
- * See "From Euclid's GCD to Montgomery Multiplication to the Great Divide"
- * https://labs.oracle.com/techrep/2001/smli_tr-2001-95.pdf
- */
-static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod)
-{
-	u64 a[NUM_ECC_DIGITS], b[NUM_ECC_DIGITS];
-	u64 u[NUM_ECC_DIGITS], v[NUM_ECC_DIGITS];
-	u64 carry;
-	int cmp_result;
-
-	if (vli_is_zero(input)) {
-		vli_clear(result);
-		return;
-	}
-
-	vli_set(a, input);
-	vli_set(b, mod);
-	vli_clear(u);
-	u[0] = 1;
-	vli_clear(v);
-
-	while ((cmp_result = vli_cmp(a, b)) != 0) {
-		carry = 0;
-
-		if (EVEN(a)) {
-			vli_rshift1(a);
-
-			if (!EVEN(u))
-				carry = vli_add(u, u, mod);
-
-			vli_rshift1(u);
-			if (carry)
-				u[NUM_ECC_DIGITS - 1] |= 0x8000000000000000ull;
-		} else if (EVEN(b)) {
-			vli_rshift1(b);
-
-			if (!EVEN(v))
-				carry = vli_add(v, v, mod);
-
-			vli_rshift1(v);
-			if (carry)
-				v[NUM_ECC_DIGITS - 1] |= 0x8000000000000000ull;
-		} else if (cmp_result > 0) {
-			vli_sub(a, a, b);
-			vli_rshift1(a);
-
-			if (vli_cmp(u, v) < 0)
-				vli_add(u, u, mod);
-
-			vli_sub(u, u, v);
-			if (!EVEN(u))
-				carry = vli_add(u, u, mod);
-
-			vli_rshift1(u);
-			if (carry)
-				u[NUM_ECC_DIGITS - 1] |= 0x8000000000000000ull;
-		} else {
-			vli_sub(b, b, a);
-			vli_rshift1(b);
-
-			if (vli_cmp(v, u) < 0)
-				vli_add(v, v, mod);
-
-			vli_sub(v, v, u);
-			if (!EVEN(v))
-				carry = vli_add(v, v, mod);
-
-			vli_rshift1(v);
-			if (carry)
-				v[NUM_ECC_DIGITS - 1] |= 0x8000000000000000ull;
-		}
-	}
-
-	vli_set(result, u);
-}
-
-/* ------ Point operations ------ */
-
-/* Returns true if p_point is the point at infinity, false otherwise. */
-static bool ecc_point_is_zero(const struct ecc_point *point)
-{
-	return (vli_is_zero(point->x) && vli_is_zero(point->y));
-}
-
-/* Point multiplication algorithm using Montgomery's ladder with co-Z
- * coordinates. From http://eprint.iacr.org/2011/338.pdf
- */
-
-/* Double in place */
-static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1)
-{
-	/* t1 = x, t2 = y, t3 = z */
-	u64 t4[NUM_ECC_DIGITS];
-	u64 t5[NUM_ECC_DIGITS];
-
-	if (vli_is_zero(z1))
-		return;
-
-	vli_mod_square_fast(t4, y1);   /* t4 = y1^2 */
-	vli_mod_mult_fast(t5, x1, t4); /* t5 = x1*y1^2 = A */
-	vli_mod_square_fast(t4, t4);   /* t4 = y1^4 */
-	vli_mod_mult_fast(y1, y1, z1); /* t2 = y1*z1 = z3 */
-	vli_mod_square_fast(z1, z1);   /* t3 = z1^2 */
-
-	vli_mod_add(x1, x1, z1, curve_p); /* t1 = x1 + z1^2 */
-	vli_mod_add(z1, z1, z1, curve_p); /* t3 = 2*z1^2 */
-	vli_mod_sub(z1, x1, z1, curve_p); /* t3 = x1 - z1^2 */
-	vli_mod_mult_fast(x1, x1, z1);    /* t1 = x1^2 - z1^4 */
-
-	vli_mod_add(z1, x1, x1, curve_p); /* t3 = 2*(x1^2 - z1^4) */
-	vli_mod_add(x1, x1, z1, curve_p); /* t1 = 3*(x1^2 - z1^4) */
-	if (vli_test_bit(x1, 0)) {
-		u64 carry = vli_add(x1, x1, curve_p);
-		vli_rshift1(x1);
-		x1[NUM_ECC_DIGITS - 1] |= carry << 63;
-	} else {
-		vli_rshift1(x1);
-	}
-	/* t1 = 3/2*(x1^2 - z1^4) = B */
-
-	vli_mod_square_fast(z1, x1);      /* t3 = B^2 */
-	vli_mod_sub(z1, z1, t5, curve_p); /* t3 = B^2 - A */
-	vli_mod_sub(z1, z1, t5, curve_p); /* t3 = B^2 - 2A = x3 */
-	vli_mod_sub(t5, t5, z1, curve_p); /* t5 = A - x3 */
-	vli_mod_mult_fast(x1, x1, t5);    /* t1 = B * (A - x3) */
-	vli_mod_sub(t4, x1, t4, curve_p); /* t4 = B * (A - x3) - y1^4 = y3 */
-
-	vli_set(x1, z1);
-	vli_set(z1, y1);
-	vli_set(y1, t4);
-}
-
-/* Modify (x1, y1) => (x1 * z^2, y1 * z^3) */
-static void apply_z(u64 *x1, u64 *y1, u64 *z)
-{
-	u64 t1[NUM_ECC_DIGITS];
-
-	vli_mod_square_fast(t1, z);    /* z^2 */
-	vli_mod_mult_fast(x1, x1, t1); /* x1 * z^2 */
-	vli_mod_mult_fast(t1, t1, z);  /* z^3 */
-	vli_mod_mult_fast(y1, y1, t1); /* y1 * z^3 */
-}
-
-/* P = (x1, y1) => 2P, (x2, y2) => P' */
-static void xycz_initial_double(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
-				u64 *p_initial_z)
-{
-	u64 z[NUM_ECC_DIGITS];
-
-	vli_set(x2, x1);
-	vli_set(y2, y1);
-
-	vli_clear(z);
-	z[0] = 1;
-
-	if (p_initial_z)
-		vli_set(z, p_initial_z);
-
-	apply_z(x1, y1, z);
-
-	ecc_point_double_jacobian(x1, y1, z);
-
-	apply_z(x2, y2, z);
-}
-
-/* Input P = (x1, y1, Z), Q = (x2, y2, Z)
- * Output P' = (x1', y1', Z3), P + Q = (x3, y3, Z3)
- * or P => P', Q => P + Q
- */
-static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2)
-{
-	/* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
-	u64 t5[NUM_ECC_DIGITS];
-
-	vli_mod_sub(t5, x2, x1, curve_p); /* t5 = x2 - x1 */
-	vli_mod_square_fast(t5, t5);      /* t5 = (x2 - x1)^2 = A */
-	vli_mod_mult_fast(x1, x1, t5);    /* t1 = x1*A = B */
-	vli_mod_mult_fast(x2, x2, t5);    /* t3 = x2*A = C */
-	vli_mod_sub(y2, y2, y1, curve_p); /* t4 = y2 - y1 */
-	vli_mod_square_fast(t5, y2);      /* t5 = (y2 - y1)^2 = D */
-
-	vli_mod_sub(t5, t5, x1, curve_p); /* t5 = D - B */
-	vli_mod_sub(t5, t5, x2, curve_p); /* t5 = D - B - C = x3 */
-	vli_mod_sub(x2, x2, x1, curve_p); /* t3 = C - B */
-	vli_mod_mult_fast(y1, y1, x2);    /* t2 = y1*(C - B) */
-	vli_mod_sub(x2, x1, t5, curve_p); /* t3 = B - x3 */
-	vli_mod_mult_fast(y2, y2, x2);    /* t4 = (y2 - y1)*(B - x3) */
-	vli_mod_sub(y2, y2, y1, curve_p); /* t4 = y3 */
-
-	vli_set(x2, t5);
-}
-
-/* Input P = (x1, y1, Z), Q = (x2, y2, Z)
- * Output P + Q = (x3, y3, Z3), P - Q = (x3', y3', Z3)
- * or P => P - Q, Q => P + Q
- */
-static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2)
-{
-	/* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
-	u64 t5[NUM_ECC_DIGITS];
-	u64 t6[NUM_ECC_DIGITS];
-	u64 t7[NUM_ECC_DIGITS];
-
-	vli_mod_sub(t5, x2, x1, curve_p); /* t5 = x2 - x1 */
-	vli_mod_square_fast(t5, t5);      /* t5 = (x2 - x1)^2 = A */
-	vli_mod_mult_fast(x1, x1, t5);    /* t1 = x1*A = B */
-	vli_mod_mult_fast(x2, x2, t5);    /* t3 = x2*A = C */
-	vli_mod_add(t5, y2, y1, curve_p); /* t4 = y2 + y1 */
-	vli_mod_sub(y2, y2, y1, curve_p); /* t4 = y2 - y1 */
-
-	vli_mod_sub(t6, x2, x1, curve_p); /* t6 = C - B */
-	vli_mod_mult_fast(y1, y1, t6);    /* t2 = y1 * (C - B) */
-	vli_mod_add(t6, x1, x2, curve_p); /* t6 = B + C */
-	vli_mod_square_fast(x2, y2);      /* t3 = (y2 - y1)^2 */
-	vli_mod_sub(x2, x2, t6, curve_p); /* t3 = x3 */
-
-	vli_mod_sub(t7, x1, x2, curve_p); /* t7 = B - x3 */
-	vli_mod_mult_fast(y2, y2, t7);    /* t4 = (y2 - y1)*(B - x3) */
-	vli_mod_sub(y2, y2, y1, curve_p); /* t4 = y3 */
-
-	vli_mod_square_fast(t7, t5);      /* t7 = (y2 + y1)^2 = F */
-	vli_mod_sub(t7, t7, t6, curve_p); /* t7 = x3' */
-	vli_mod_sub(t6, t7, x1, curve_p); /* t6 = x3' - B */
-	vli_mod_mult_fast(t6, t6, t5);    /* t6 = (y2 + y1)*(x3' - B) */
-	vli_mod_sub(y1, t6, y1, curve_p); /* t2 = y3' */
-
-	vli_set(x1, t7);
-}
-
-static void ecc_point_mult(struct ecc_point *result,
-			   const struct ecc_point *point, u64 *scalar,
-			   u64 *initial_z, int num_bits)
-{
-	/* R0 and R1 */
-	u64 rx[2][NUM_ECC_DIGITS];
-	u64 ry[2][NUM_ECC_DIGITS];
-	u64 z[NUM_ECC_DIGITS];
-	int i, nb;
-
-	vli_set(rx[1], point->x);
-	vli_set(ry[1], point->y);
-
-	xycz_initial_double(rx[1], ry[1], rx[0], ry[0], initial_z);
-
-	for (i = num_bits - 2; i > 0; i--) {
-		nb = !vli_test_bit(scalar, i);
-		xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb]);
-		xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb]);
-	}
-
-	nb = !vli_test_bit(scalar, 0);
-	xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb]);
-
-	/* Find final 1/Z value. */
-	vli_mod_sub(z, rx[1], rx[0], curve_p); /* X1 - X0 */
-	vli_mod_mult_fast(z, z, ry[1 - nb]); /* Yb * (X1 - X0) */
-	vli_mod_mult_fast(z, z, point->x);   /* xP * Yb * (X1 - X0) */
-	vli_mod_inv(z, z, curve_p);          /* 1 / (xP * Yb * (X1 - X0)) */
-	vli_mod_mult_fast(z, z, point->y);   /* yP / (xP * Yb * (X1 - X0)) */
-	vli_mod_mult_fast(z, z, rx[1 - nb]); /* Xb * yP / (xP * Yb * (X1 - X0)) */
-	/* End 1/Z calculation */
-
-	xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb]);
-
-	apply_z(rx[0], ry[0], z);
-
-	vli_set(result->x, rx[0]);
-	vli_set(result->y, ry[0]);
-}
-
-static void ecc_bytes2native(const u8 bytes[ECC_BYTES],
-			     u64 native[NUM_ECC_DIGITS])
-{
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++) {
-		const u8 *digit = bytes + 8 * (NUM_ECC_DIGITS - 1 - i);
-
-		native[NUM_ECC_DIGITS - 1 - i] =
-				((u64) digit[0] << 0) |
-				((u64) digit[1] << 8) |
-				((u64) digit[2] << 16) |
-				((u64) digit[3] << 24) |
-				((u64) digit[4] << 32) |
-				((u64) digit[5] << 40) |
-				((u64) digit[6] << 48) |
-				((u64) digit[7] << 56);
-	}
-}
-
-static void ecc_native2bytes(const u64 native[NUM_ECC_DIGITS],
-			     u8 bytes[ECC_BYTES])
-{
-	int i;
-
-	for (i = 0; i < NUM_ECC_DIGITS; i++) {
-		u8 *digit = bytes + 8 * (NUM_ECC_DIGITS - 1 - i);
-
-		digit[0] = native[NUM_ECC_DIGITS - 1 - i] >> 0;
-		digit[1] = native[NUM_ECC_DIGITS - 1 - i] >> 8;
-		digit[2] = native[NUM_ECC_DIGITS - 1 - i] >> 16;
-		digit[3] = native[NUM_ECC_DIGITS - 1 - i] >> 24;
-		digit[4] = native[NUM_ECC_DIGITS - 1 - i] >> 32;
-		digit[5] = native[NUM_ECC_DIGITS - 1 - i] >> 40;
-		digit[6] = native[NUM_ECC_DIGITS - 1 - i] >> 48;
-		digit[7] = native[NUM_ECC_DIGITS - 1 - i] >> 56;
-	}
-}
-
-bool ecc_make_key(u8 public_key[64], u8 private_key[32])
-{
-	struct ecc_point pk;
-	u64 priv[NUM_ECC_DIGITS];
-	unsigned int tries = 0;
-
-	do {
-		if (tries++ >= MAX_TRIES)
-			return false;
-
-		get_random_bytes(priv, ECC_BYTES);
-
-		if (vli_is_zero(priv))
-			continue;
-
-		/* Make sure the private key is in the range [1, n-1]. */
-		if (vli_cmp(curve_n, priv) != 1)
-			continue;
-
-		ecc_point_mult(&pk, &curve_g, priv, NULL, vli_num_bits(priv));
-	} while (ecc_point_is_zero(&pk));
-
-	ecc_native2bytes(priv, private_key);
-	ecc_native2bytes(pk.x, public_key);
-	ecc_native2bytes(pk.y, &public_key[32]);
-
-	return true;
-}
-
-bool ecdh_shared_secret(const u8 public_key[64], const u8 private_key[32],
-		        u8 secret[32])
-{
-	u64 priv[NUM_ECC_DIGITS];
-	u64 rand[NUM_ECC_DIGITS];
-	struct ecc_point product, pk;
-
-	get_random_bytes(rand, ECC_BYTES);
-
-	ecc_bytes2native(public_key, pk.x);
-	ecc_bytes2native(&public_key[32], pk.y);
-	ecc_bytes2native(private_key, priv);
-
-	ecc_point_mult(&product, &pk, priv, rand, vli_num_bits(priv));
-
-	ecc_native2bytes(product.x, secret);
-
-	return !ecc_point_is_zero(&product);
-}
diff --git a/net/bluetooth/ecc.h b/net/bluetooth/ecc.h
deleted file mode 100644
index 8d6a2f4..0000000
--- a/net/bluetooth/ecc.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * Copyright (c) 2013, Kenneth MacKay
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *  * Redistributions of source code must retain the above copyright
- *   notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-/* Create a public/private key pair.
- * Outputs:
- *	public_key  - Will be filled in with the public key.
- *	private_key - Will be filled in with the private key.
- *
- * Returns true if the key pair was generated successfully, false
- * if an error occurred. The keys are with the LSB first.
- */
-bool ecc_make_key(u8 public_key[64], u8 private_key[32]);
-
-/* Compute a shared secret given your secret key and someone else's
- * public key.
- * Note: It is recommended that you hash the result of ecdh_shared_secret
- * before using it for symmetric encryption or HMAC.
- *
- * Inputs:
- *	public_key  - The public key of the remote party
- *	private_key - Your private key.
- *
- * Outputs:
- *	secret - Will be filled in with the shared secret value.
- *
- * Returns true if the shared secret was generated successfully, false
- * if an error occurred. Both input and output parameters are with the
- * LSB first.
- */
-bool ecdh_shared_secret(const u8 public_key[64], const u8 private_key[32],
-		        u8 secret[32]);
diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
new file mode 100644
index 0000000..a09df45
--- /dev/null
+++ b/net/bluetooth/ecdh_helper.c
@@ -0,0 +1,204 @@
+/*
+ * ECDH helper functions - KPP wrappings
+ *
+ * Copyright (C) 2016 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation;
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
+ * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
+ * IN NO EVENT SHALL THE COPYRIGHT HOLDER(S) AND AUTHOR(S) BE LIABLE FOR ANY
+ * CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS,
+ * COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
+ * SOFTWARE IS DISCLAIMED.
+ */
+#include "ecdh_helper.h"
+
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <crypto/kpp.h>
+#include <crypto/ecdh.h>
+
+struct ecdh_completion {
+	struct completion completion;
+	int err;
+};
+
+static void ecdh_complete(struct crypto_async_request *req, int err)
+{
+	struct ecdh_completion *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
+{
+	int i;
+
+	for (i = 0; i < ndigits; i++)
+		out[i] = __swab64(in[ndigits - 1 - i]);
+}
+
+bool compute_ecdh_secret(const u8 public_key[64], const u8 private_key[32],
+			 u8 secret[32])
+{
+	struct crypto_kpp *tfm;
+	struct kpp_request *req;
+	struct ecdh_params p;
+	struct ecdh_completion result;
+	struct scatterlist src, dst;
+	u8 tmp[64];
+	int err = -ENOMEM;
+
+	tfm = crypto_alloc_kpp("ecdh", CRYPTO_ALG_INTERNAL, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: kpp: Failed to load tfm for kpp: %ld\n",
+		       PTR_ERR(tfm));
+		return false;
+	}
+
+	req = kpp_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		goto free_kpp;
+
+	init_completion(&result.completion);
+
+	/* Set curve_id */
+	p.curve_id = ECC_CURVE_NIST_P256;
+	err = crypto_kpp_set_params(tfm, (void *)&p);
+	if (err)
+		goto free_req;
+
+	/* Security Manager Protocol holds digits in litte-endian order
+	 * while ECC API expect big-endian data
+	 */
+	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
+
+	/* Set A private Key */
+	err = crypto_kpp_set_secret(tfm, (void *)tmp, 32);
+	if (err)
+		goto free_all;
+
+	swap_digits((u64 *)public_key, (u64 *)tmp, 4); /* x */
+	swap_digits((u64 *)&public_key[32], (u64 *)&tmp[32], 4); /* y */
+
+	sg_init_one(&src, tmp, 64);
+	sg_init_one(&dst, secret, 32);
+	kpp_request_set_input(req, &src, 64);
+	kpp_request_set_output(req, &dst, 32);
+	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				 ecdh_complete, &result);
+	err = crypto_kpp_compute_shared_secret(req);
+	if (err == -EINPROGRESS) {
+		wait_for_completion(&result.completion);
+		err = result.err;
+	}
+	if (err < 0) {
+		pr_err("alg: ecdh: compute shard secret test failed. err %d\n",
+		       err);
+		goto free_all;
+	}
+
+	swap_digits((u64 *)secret, (u64 *)tmp, 4);
+	memcpy(secret, tmp, 32);
+
+free_all:
+free_req:
+	kpp_request_free(req);
+free_kpp:
+	crypto_free_kpp(tfm);
+	return (err == 0);
+}
+
+bool generate_ecdh_keys(u8 public_key[64], u8 private_key[32])
+{
+	struct crypto_kpp *tfm;
+	struct kpp_request *req;
+	struct ecdh_params p;
+	struct ecdh_completion result;
+	struct scatterlist dst;
+	u8 tmp[64];
+	int err = -ENOMEM;
+	const unsigned short max_tries = 16;
+	unsigned short tries = 0;
+
+	tfm = crypto_alloc_kpp("ecdh", CRYPTO_ALG_INTERNAL, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: kpp: Failed to load tfm for kpp: %ld\n",
+		       PTR_ERR(tfm));
+		return false;
+	}
+
+	req = kpp_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		goto free_kpp;
+
+	init_completion(&result.completion);
+
+	/* Set curve_id */
+	p.curve_id = ECC_CURVE_NIST_P256;
+	err = crypto_kpp_set_params(tfm, (void *)&p);
+	if (err)
+		goto free_req;
+
+	do {
+		if (tries++ >= max_tries)
+			goto free_all;
+
+		get_random_bytes(private_key, 32);
+
+		/* Set private Key */
+		err = crypto_kpp_set_secret(tfm, (void *)private_key, 32);
+		if (err)
+			goto free_all;
+
+		sg_init_one(&dst, tmp, 64);
+		kpp_request_set_output(req, &dst, 64);
+		kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					 ecdh_complete, &result);
+
+		err = crypto_kpp_generate_public_key(req);
+
+		if (err == -EINPROGRESS) {
+			wait_for_completion(&result.completion);
+			err = result.err;
+		}
+
+		/* Private key is not valid. Regenerate */
+		if (err == -EINVAL)
+			continue;
+
+		if (err < 0)
+			goto free_all;
+		else
+			break;
+
+	} while (true);
+
+	/* Keys are handed back in little endian as expected by Security
+	 * Manager Protocol
+	 */
+	swap_digits((u64 *)tmp, (u64 *)public_key, 4); /* x */
+	swap_digits((u64 *)&tmp[32], (u64 *)&public_key[32], 4); /* y */
+	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
+	memcpy(private_key, tmp, 32);
+
+free_all:
+free_req:
+	kpp_request_free(req);
+free_kpp:
+	crypto_free_kpp(tfm);
+	return (err == 0);
+}
diff --git a/net/bluetooth/ecdh_helper.h b/net/bluetooth/ecdh_helper.h
new file mode 100644
index 0000000..726a500
--- /dev/null
+++ b/net/bluetooth/ecdh_helper.h
@@ -0,0 +1,27 @@
+/*
+ * ECDH helper functions - KPP wrappings
+ *
+ * Copyright (C) 2016 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation;
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
+ * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
+ * IN NO EVENT SHALL THE COPYRIGHT HOLDER(S) AND AUTHOR(S) BE LIABLE FOR ANY
+ * CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS,
+ * COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
+ * SOFTWARE IS DISCLAIMED.
+ */
+#include <linux/types.h>
+
+bool compute_ecdh_secret(const u8 pub_a[64], const u8 priv_b[32],
+			 u8 secret[32]);
+bool generate_ecdh_keys(u8 public_key[64], u8 private_key[32]);
diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index dc688f1..efef281 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -26,7 +26,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 
-#include "ecc.h"
+#include "ecdh_helper.h"
 #include "smp.h"
 #include "selftest.h"
 
@@ -144,8 +144,8 @@ static int __init test_ecdh_sample(const u8 priv_a[32], const u8 priv_b[32],
 {
 	u8 dhkey_a[32], dhkey_b[32];
 
-	ecdh_shared_secret(pub_b, priv_a, dhkey_a);
-	ecdh_shared_secret(pub_a, priv_b, dhkey_b);
+	compute_ecdh_secret(pub_b, priv_a, dhkey_a);
+	compute_ecdh_secret(pub_a, priv_b, dhkey_b);
 
 	if (memcmp(dhkey_a, dhkey, 32))
 		return -EINVAL;
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 50976a6..083e176 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -31,7 +31,7 @@
 #include <net/bluetooth/l2cap.h>
 #include <net/bluetooth/mgmt.h>
 
-#include "ecc.h"
+#include "ecdh_helper.h"
 #include "smp.h"
 
 #define SMP_DEV(hdev) \
@@ -564,7 +564,7 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 	} else {
 		while (true) {
 			/* Generate local key pair for Secure Connections */
-			if (!ecc_make_key(smp->local_pk, smp->local_sk))
+			if (!generate_ecdh_keys(smp->local_pk, smp->local_sk))
 				return -EIO;
 
 			/* This is unlikely, but we need to check that
@@ -1862,7 +1862,7 @@ static u8 sc_send_public_key(struct smp_chan *smp)
 	} else {
 		while (true) {
 			/* Generate local key pair for Secure Connections */
-			if (!ecc_make_key(smp->local_pk, smp->local_sk))
+			if (!generate_ecdh_keys(smp->local_pk, smp->local_sk))
 				return SMP_UNSPECIFIED;
 
 			/* This is unlikely, but we need to check that
@@ -2630,7 +2630,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	SMP_DBG("Remote Public Key X: %32phN", smp->remote_pk);
 	SMP_DBG("Remote Public Key Y: %32phN", smp->remote_pk + 32);
 
-	if (!ecdh_shared_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
+	if (!compute_ecdh_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
 		return SMP_UNSPECIFIED;
 
 	SMP_DBG("DHKey %32phN", smp->dhkey);
-- 
2.7.4
