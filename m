From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm/ghash-ce - implement support for 4-way aggregation
Date: Wed, 22 Aug 2018 16:28:55 +0100
Message-ID: <20180822152855.7699-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Speed up the GHASH algorithm based on 64-bit polynomial multiplication
by adding support for 4-way aggregation. This improves throughput by
~60% on Cortex-A53, from 1.70 cycles per byte to 1.05 cycles per byte.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig         |   1 +
 arch/arm/crypto/ghash-ce-core.S | 101 ++++++++++++++++++++++++++++++--
 arch/arm/crypto/ghash-ce-glue.c |  38 ++++++++----
 3 files changed, 124 insertions(+), 16 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 925d1364727a..07dd12efeea4 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -99,6 +99,7 @@ config CRYPTO_GHASH_ARM_CE
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
+	select CRYPTO_GF128MUL
 	help
 	  Use an implementation of GHASH (used by the GCM AEAD chaining mode)
 	  that uses the 64x64 to 128 bit polynomial multiplication (vmull.p64)
diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index 2f78c10b1881..c982c63877a6 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -63,6 +63,27 @@
 	k48		.req	d31
 	SHASH2_p64	.req	d31
 
+	HH		.req	q10
+	HH3		.req	q11
+	HH4		.req	q12
+	HH34		.req	q13
+
+	HH_L		.req	d20
+	HH_H		.req	d21
+	HH3_L		.req	d22
+	HH3_H		.req	d23
+	HH4_L		.req	d24
+	HH4_H		.req	d25
+	HH34_L		.req	d26
+	HH34_H		.req	d27
+	SHASH2_H	.req	d29
+
+	XL2		.req	q5
+	XM2		.req	q6
+	XH2		.req	q7
+	XL3		.req	q8
+	XM3		.req	q9
+
 	.text
 	.fpu		crypto-neon-fp-armv8
 
@@ -175,12 +196,76 @@
 	beq		0f
 	vld1.64		{T1}, [ip]
 	teq		r0, #0
-	b		1f
+	b		3f
+
+0:	.ifc		\pn, p64
+	tst		r0, #3			// skip until #blocks is a
+	bne		2f			// round multiple of 4
+
+1:	vld1.8		{XL2-XM2}, [r2]!
+	vld1.8		{XL3}, [r2]!
+	vrev64.8	T1, XL2
+
+	subs		r0, r0, #4
+
+	vext.8		T2, T1, T1, #8
+	veor		T1_H, T1_H, XL_L
+	veor		XL, XL, T2
+
+	vmull.p64	XH, HH4_H, XL_H			// a1 * b1
+	veor		T1_H, T1_H, XL_H
+	vmull.p64	XL, HH4_L, XL_L			// a0 * b0
+	vmull.p64	XM, HH34_H, T1_H		// (a1 + a0)(b1 + b0)
+
+	vrev64.8	T1, XM2
+
+	vmull.p64	XH2, HH3_H, T1_L		// a1 * b1
+	veor		T1_L, T1_L, T1_H
+	vmull.p64	XL2, HH3_L, T1_H		// a0 * b0
+	vmull.p64	XM2, HH34_L, T1_L		// (a1 + a0)(b1 + b0)
+
+	vrev64.8	T1, XL3
+
+	vmull.p64	XL3, HH_H, T1_L			// a1 * b1
+	veor		T1_L, T1_L, T1_H
+	veor		XH2, XH2, XL3
+	vmull.p64	XL3, HH_L, T1_H			// a0 * b0
+	vmull.p64	XM3, SHASH2_H, T1_L		// (a1 + a0)(b1 + b0)
+
+	vld1.8		{T1}, [r2]!
+	veor		XL2, XL2, XL3
+	vrev64.8	T1, T1
+	veor		XM2, XM2, XM3
+
+	vmull.p64	XL3, SHASH_H, T1_L		// a1 * b1
+	veor		T1_L, T1_L, T1_H
+	veor		XH2, XH2, XL3
+	vmull.p64	XL3, SHASH_L, T1_H		// a0 * b0
+	vmull.p64	XM3, SHASH2_p64, T1_L		// (a1 + a0)(b1 + b0)
 
-0:	vld1.64		{T1}, [r2]!
+	veor		XL2, XL2, XL3
+	veor		XM2, XM2, XM3
+
+	veor		XL, XL, XL2
+	veor		XH, XH, XH2
+	veor		XM, XM, XM2
+
+	veor		T1, XL, XH
+	veor		XM, XM, T1
+
+	__pmull_reduce_p64
+
+	veor		T1, T1, XH
+	veor		XL, XL, T1
+
+	beq		4f
+	b		1b
+	.endif
+
+2:	vld1.64		{T1}, [r2]!
 	subs		r0, r0, #1
 
-1:	/* multiply XL by SHASH in GF(2^128) */
+3:	/* multiply XL by SHASH in GF(2^128) */
 #ifndef CONFIG_CPU_BIG_ENDIAN
 	vrev64.8	T1, T1
 #endif
@@ -203,7 +288,7 @@
 
 	bne		0b
 
-	vst1.64		{XL}, [r1]
+4:	vst1.64		{XL}, [r1]
 	bx		lr
 	.endm
 
@@ -212,8 +297,14 @@
 	 *			   struct ghash_key const *k, const char *head)
 	 */
 ENTRY(pmull_ghash_update_p64)
-	vld1.64		{SHASH}, [r3]
+	vld1.64		{SHASH}, [r3]!
+	vld1.64		{HH}, [r3]!
+	vld1.64		{HH3-HH4}, [r3]
+
 	veor		SHASH2_p64, SHASH_L, SHASH_H
+	veor		SHASH2_H, HH_L, HH_H
+	veor		HH34_L, HH3_L, HH3_H
+	veor		HH34_H, HH4_L, HH4_H
 
 	vmov.i8		MASK, #0xe1
 	vshl.u64	MASK, MASK, #57
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 8930fc4e7c22..b7d30b6cf49c 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -1,7 +1,7 @@
 /*
  * Accelerated GHASH implementation with ARMv8 vmull.p64 instructions.
  *
- * Copyright (C) 2015 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2015 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -28,8 +28,10 @@ MODULE_ALIAS_CRYPTO("ghash");
 #define GHASH_DIGEST_SIZE	16
 
 struct ghash_key {
-	u64	a;
-	u64	b;
+	u64	h[2];
+	u64	h2[2];
+	u64	h3[2];
+	u64	h4[2];
 };
 
 struct ghash_desc_ctx {
@@ -117,26 +119,40 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 	return 0;
 }
 
+static void ghash_reflect(u64 h[], const be128 *k)
+{
+	u64 carry = be64_to_cpu(k->a) >> 63;
+
+	h[0] = (be64_to_cpu(k->b) << 1) | carry;
+	h[1] = (be64_to_cpu(k->a) << 1) | (be64_to_cpu(k->b) >> 63);
+
+	if (carry)
+		h[1] ^= 0xc200000000000000UL;
+}
+
 static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *inkey, unsigned int keylen)
 {
 	struct ghash_key *key = crypto_shash_ctx(tfm);
-	u64 a, b;
+	be128 h, k;
 
 	if (keylen != GHASH_BLOCK_SIZE) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	/* perform multiplication by 'x' in GF(2^128) */
-	b = get_unaligned_be64(inkey);
-	a = get_unaligned_be64(inkey + 8);
+	memcpy(&k, inkey, GHASH_BLOCK_SIZE);
+	ghash_reflect(key->h, &k);
+
+	h = k;
+	gf128mul_lle(&h, &k);
+	ghash_reflect(key->h2, &h);
 
-	key->a = (a << 1) | (b >> 63);
-	key->b = (b << 1) | (a >> 63);
+	gf128mul_lle(&h, &k);
+	ghash_reflect(key->h3, &h);
 
-	if (b >> 63)
-		key->b ^= 0xc200000000000000UL;
+	gf128mul_lle(&h, &k);
+	ghash_reflect(key->h4, &h);
 
 	return 0;
 }
-- 
2.18.0
