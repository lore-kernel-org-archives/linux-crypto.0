From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto/arm64: aes-ce-gcm - implement 2-way aggregation
Date: Sat, 28 Jul 2018 20:54:00 +0200
Message-ID: <20180728185400.8237-3-ard.biesheuvel@linaro.org>
References: <20180728185400.8237-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jerome.forissier@linaro.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, catalin.marinas@arm.com,
 will.deacon@arm.com, vakul.garg@nxp.com, jens.wiklander@linaro.org,
 linux-arm-kernel@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180728185400.8237-1-ard.biesheuvel@linaro.org>
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

Implement a faster version of the GHASH transform which amortizes the
reduction modulo the characteristic polynomial across two input blocks at
a time. This is based on the Intel white paper "Carry-Less Multiplication
Instruction and its Usage for Computing the GCM Mode"

On a Cortex-A53, the gcm(aes) performance increases 24%, from 3.0 cycles per
byte to 2.4 cpb for large input sizes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
Raw numbers after the patch

 arch/arm64/crypto/ghash-ce-core.S | 87 +++++++-------------
 arch/arm64/crypto/ghash-ce-glue.c | 33 ++++++--
 2 files changed, 54 insertions(+), 66 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 437a2fb0f7f9..c144b526abe6 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -290,6 +290,11 @@ ENDPROC(pmull_ghash_update_p8)
 	KS1		.req	v9
 	INP0		.req	v10
 	INP1		.req	v11
+	HH		.req	v12
+	Hhl		.req	v13
+	XLn		.req	v14
+	XMn		.req	v15
+	XHn		.req	v16
 
 	.macro		load_round_keys, rounds, rk
 	cmp		\rounds, #12
@@ -342,13 +347,13 @@ CPU_LE(	rev		x28, x28	)
 
 0:	mov		x0, x25
 	load_round_keys	w26, x0
-	ld1		{SHASH.2d}, [x23]
+	add		x1, x23, #32
+	ld1		{HH.2d-Hhl.2d}, [x23]
+	ld1		{SHASH.2d}, [x1]
 	ld1		{XL.2d}, [x20]
 
 	movi		MASK.16b, #0xe1
-	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
 	shl		MASK.2d, MASK.2d, #57
-	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	.if		\enc == 1
 	ld1		{KS0.16b-KS1.16b}, [x27]
@@ -372,116 +377,82 @@ CPU_LE(	rev		x28, x28	)
 	ins		KS0.d[1], x9			// set lower counter
 	ins		KS1.d[1], x10
 
-	rev64		T1.16b, INP0.16b
+	rev64		T1.16b, INP1.16b
 
 	cmp		w26, #12
 	b.ge		4f				// AES-192/256?
 
 2:	enc_round	KS0, v21
-
-	ext		T2.16b, XL.16b, XL.16b, #8
 	ext		IN1.16b, T1.16b, T1.16b, #8
 
 	enc_round	KS1, v21
-
-	eor		T1.16b, T1.16b, T2.16b
-	eor		XL.16b, XL.16b, IN1.16b
+	pmull2		XHn.1q, SHASH.2d, IN1.2d	// a1 * b1
 
 	enc_round	KS0, v22
-
-	pmull2		XH.1q, SHASH.2d, XL.2d		// a1 * b1
-	eor		T1.16b, T1.16b, XL.16b
+	eor		T1.16b, T1.16b, IN1.16b
 
 	enc_round	KS1, v22
-
-	pmull		XL.1q, SHASH.1d, XL.1d		// a0 * b0
-	pmull		XM.1q, SHASH2.1d, T1.1d		// (a1 + a0)(b1 + b0)
+	pmull		XLn.1q, SHASH.1d, IN1.1d	// a0 * b0
 
 	enc_round	KS0, v23
-
-	ext		T1.16b, XL.16b, XH.16b, #8
-	eor		T2.16b, XL.16b, XH.16b
-	eor		XM.16b, XM.16b, T1.16b
+	pmull		XMn.1q, Hhl.1d, T1.1d		// (a1 + a0)(b1 + b0)
 
 	enc_round	KS1, v23
-
-	eor		XM.16b, XM.16b, T2.16b
-	pmull		T2.1q, XL.1d, MASK.1d
+	rev64		T1.16b, INP0.16b
+	ext		T2.16b, XL.16b, XL.16b, #8
 
 	enc_round	KS0, v24
-
-	mov		XH.d[0], XM.d[1]
-	mov		XM.d[1], XL.d[0]
+	ext		IN1.16b, T1.16b, T1.16b, #8
+	eor		T1.16b, T1.16b, T2.16b
 
 	enc_round	KS1, v24
-
-	eor		XL.16b, XM.16b, T2.16b
+	eor		XL.16b, XL.16b, IN1.16b
 
 	enc_round	KS0, v25
-
-	ext		T2.16b, XL.16b, XL.16b, #8
+	pmull2		XH.1q, HH.2d, XL.2d		// a1 * b1
 
 	enc_round	KS1, v25
-
-	pmull		XL.1q, XL.1d, MASK.1d
-	eor		T2.16b, T2.16b, XH.16b
+	eor		T1.16b, T1.16b, XL.16b
 
 	enc_round	KS0, v26
-
-	eor		XL.16b, XL.16b, T2.16b
-	rev64		T1.16b, INP1.16b
+	pmull		XL.1q, HH.1d, XL.1d		// a0 * b0
 
 	enc_round	KS1, v26
-
-	ext		T2.16b, XL.16b, XL.16b, #8
-	ext		IN1.16b, T1.16b, T1.16b, #8
+	pmull2		XM.1q, Hhl.2d, T1.2d		// (a1 + a0)(b1 + b0)
 
 	enc_round	KS0, v27
-
-	eor		T1.16b, T1.16b, T2.16b
-	eor		XL.16b, XL.16b, IN1.16b
+	eor		XH.16b, XH.16b, XHn.16b
+	eor		XM.16b, XM.16b, XMn.16b
 
 	enc_round	KS1, v27
-
-	pmull2		XH.1q, SHASH.2d, XL.2d		// a1 * b1
-	eor		T1.16b, T1.16b, XL.16b
+	eor		XL.16b, XL.16b, XLn.16b
+	ext		T1.16b, XL.16b, XH.16b, #8
 
 	enc_round	KS0, v28
-
-	pmull		XL.1q, SHASH.1d, XL.1d		// a0 * b0
-	pmull		XM.1q, SHASH2.1d, T1.1d		// (a1 + a0)(b1 + b0)
-
-	enc_round	KS1, v28
-
-	ext		T1.16b, XL.16b, XH.16b, #8
 	eor		T2.16b, XL.16b, XH.16b
 	eor		XM.16b, XM.16b, T1.16b
 
-	enc_round	KS0, v29
-
+	enc_round	KS1, v28
 	eor		XM.16b, XM.16b, T2.16b
+
+	enc_round	KS0, v29
 	pmull		T2.1q, XL.1d, MASK.1d
 
 	enc_round	KS1, v29
-
 	mov		XH.d[0], XM.d[1]
 	mov		XM.d[1], XL.d[0]
 
 	aese		KS0.16b, v30.16b
-
 	eor		XL.16b, XM.16b, T2.16b
 
 	aese		KS1.16b, v30.16b
-
 	ext		T2.16b, XL.16b, XL.16b, #8
 
 	eor		KS0.16b, KS0.16b, v31.16b
-
 	pmull		XL.1q, XL.1d, MASK.1d
 	eor		T2.16b, T2.16b, XH.16b
 
 	eor		KS1.16b, KS1.16b, v31.16b
-
 	eor		XL.16b, XL.16b, T2.16b
 
 	.if		\enc == 0
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 371f8368c196..65a0b8239620 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -46,6 +46,8 @@ struct ghash_desc_ctx {
 
 struct gcm_aes_ctx {
 	struct crypto_aes_ctx	aes_key;
+	u64			h2[2];
+	u64			hhl[2];
 	struct ghash_key	ghash_key;
 };
 
@@ -62,12 +64,11 @@ static void (*pmull_ghash_update)(int blocks, u64 dg[], const char *src,
 				  const char *head);
 
 asmlinkage void pmull_gcm_encrypt(int blocks, u64 dg[], u8 dst[],
-				  const u8 src[], struct ghash_key const *k,
-				  u8 ctr[], u32 const rk[], int rounds,
-				  u8 ks[]);
+				  const u8 src[], u64 const *k, u8 ctr[],
+				  u32 const rk[], int rounds, u8 ks[]);
 
 asmlinkage void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[],
-				  const u8 src[], struct ghash_key const *k,
+				  const u8 src[], u64 const *k,
 				  u8 ctr[], u32 const rk[], int rounds);
 
 asmlinkage void pmull_gcm_encrypt_block(u8 dst[], u8 const src[],
@@ -233,7 +234,8 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 		      unsigned int keylen)
 {
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
-	u8 key[GHASH_BLOCK_SIZE];
+	be128 h1, h2;
+	u8 *key = (u8 *)&h1;
 	int ret;
 
 	ret = crypto_aes_expand_key(&ctx->aes_key, inkey, keylen);
@@ -245,7 +247,22 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	__aes_arm64_encrypt(ctx->aes_key.key_enc, key, (u8[AES_BLOCK_SIZE]){},
 			    num_rounds(&ctx->aes_key));
 
-	return __ghash_setkey(&ctx->ghash_key, key, sizeof(key));
+	__ghash_setkey(&ctx->ghash_key, key, sizeof(be128));
+
+	/* calculate H^2 and Hhl (used for 2-way aggregation) */
+	h2 = h1;
+	gf128mul_lle(&h2, &h1);
+
+	ctx->h2[0] = (be64_to_cpu(h2.b) << 1) | (be64_to_cpu(h2.a) >> 63);
+	ctx->h2[1] = (be64_to_cpu(h2.a) << 1) | (be64_to_cpu(h2.b) >> 63);
+
+	if (be64_to_cpu(h2.a) >> 63)
+		ctx->h2[1] ^= 0xc200000000000000UL;
+
+	ctx->hhl[0] = ctx->ghash_key.a ^ ctx->ghash_key.b;
+	ctx->hhl[1] = ctx->h2[0] ^ ctx->h2[1];
+
+	return 0;
 }
 
 static int gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
@@ -381,7 +398,7 @@ static int gcm_encrypt(struct aead_request *req)
 
 			kernel_neon_begin();
 			pmull_gcm_encrypt(blocks, dg, walk.dst.virt.addr,
-					  walk.src.virt.addr, &ctx->ghash_key,
+					  walk.src.virt.addr, ctx->h2,
 					  iv, ctx->aes_key.key_enc,
 					  num_rounds(&ctx->aes_key), ks);
 			kernel_neon_end();
@@ -490,7 +507,7 @@ static int gcm_decrypt(struct aead_request *req)
 
 			kernel_neon_begin();
 			pmull_gcm_decrypt(blocks, dg, walk.dst.virt.addr,
-					  walk.src.virt.addr, &ctx->ghash_key,
+					  walk.src.virt.addr, ctx->h2,
 					  iv, ctx->aes_key.key_enc, nrounds);
 			kernel_neon_end();
 
-- 
2.18.0

tcrypt performance numbers for a Cortex-A53 @ 1 GHz (CONFIG_PREEMPT disabled)

BASELINE:
=========
test  0 (128 bit key,   16 byte blocks): 445165 operations in 1 seconds (  7122640 bytes)
test  1 (128 bit key,   64 byte blocks): 437076 operations in 1 seconds ( 27972864 bytes)
test  2 (128 bit key,  256 byte blocks): 354203 operations in 1 seconds ( 90675968 bytes)
test  3 (128 bit key,  512 byte blocks): 284031 operations in 1 seconds (145423872 bytes)
test  4 (128 bit key, 1024 byte blocks): 203473 operations in 1 seconds (208356352 bytes)
test  5 (128 bit key, 2048 byte blocks): 129855 operations in 1 seconds (265943040 bytes)
test  6 (128 bit key, 4096 byte blocks):  75686 operations in 1 seconds (310009856 bytes)
test  7 (128 bit key, 8192 byte blocks):  40167 operations in 1 seconds (329048064 bytes)
test  8 (192 bit key,   16 byte blocks): 441610 operations in 1 seconds (  7065760 bytes)
test  9 (192 bit key,   64 byte blocks): 429364 operations in 1 seconds ( 27479296 bytes)
test 10 (192 bit key,  256 byte blocks): 343303 operations in 1 seconds ( 87885568 bytes)
test 11 (192 bit key,  512 byte blocks): 272029 operations in 1 seconds (139278848 bytes)
test 12 (192 bit key, 1024 byte blocks): 192399 operations in 1 seconds (197016576 bytes)
test 13 (192 bit key, 2048 byte blocks): 121298 operations in 1 seconds (248418304 bytes)
test 14 (192 bit key, 4096 byte blocks):  69994 operations in 1 seconds (286695424 bytes)
test 15 (192 bit key, 8192 byte blocks):  37045 operations in 1 seconds (303472640 bytes)
test 16 (256 bit key,   16 byte blocks): 438244 operations in 1 seconds (  7011904 bytes)
test 17 (256 bit key,   64 byte blocks): 423345 operations in 1 seconds ( 27094080 bytes)
test 18 (256 bit key,  256 byte blocks): 336844 operations in 1 seconds ( 86232064 bytes)
test 19 (256 bit key,  512 byte blocks): 265711 operations in 1 seconds (136044032 bytes)
test 20 (256 bit key, 1024 byte blocks): 186853 operations in 1 seconds (191337472 bytes)
test 21 (256 bit key, 2048 byte blocks): 117301 operations in 1 seconds (240232448 bytes)
test 22 (256 bit key, 4096 byte blocks):  67513 operations in 1 seconds (276533248 bytes)
test 23 (256 bit key, 8192 byte blocks):  35629 operations in 1 seconds (291872768 bytes)


THIS PATCH:
===========
test  0 (128 bit key,   16 byte blocks): 441257 operations in 1 seconds (  7060112 bytes)
test  1 (128 bit key,   64 byte blocks): 436595 operations in 1 seconds ( 27942080 bytes)
test  2 (128 bit key,  256 byte blocks): 369839 operations in 1 seconds ( 94678784 bytes)
test  3 (128 bit key,  512 byte blocks): 308239 operations in 1 seconds (157818368 bytes)
test  4 (128 bit key, 1024 byte blocks): 231004 operations in 1 seconds (236548096 bytes)
test  5 (128 bit key, 2048 byte blocks): 153930 operations in 1 seconds (315248640 bytes)
test  6 (128 bit key, 4096 byte blocks):  92739 operations in 1 seconds (379858944 bytes)
test  7 (128 bit key, 8192 byte blocks):  49934 operations in 1 seconds (409059328 bytes)
test  8 (192 bit key,   16 byte blocks): 437427 operations in 1 seconds (  6998832 bytes)
test  9 (192 bit key,   64 byte blocks): 429462 operations in 1 seconds ( 27485568 bytes)
test 10 (192 bit key,  256 byte blocks): 358183 operations in 1 seconds ( 91694848 bytes)
test 11 (192 bit key,  512 byte blocks): 294539 operations in 1 seconds (150803968 bytes)
test 12 (192 bit key, 1024 byte blocks): 217082 operations in 1 seconds (222291968 bytes)
test 13 (192 bit key, 2048 byte blocks): 140672 operations in 1 seconds (288096256 bytes)
test 14 (192 bit key, 4096 byte blocks):  84369 operations in 1 seconds (345575424 bytes)
test 15 (192 bit key, 8192 byte blocks):  45280 operations in 1 seconds (370933760 bytes)
test 16 (256 bit key,   16 byte blocks): 434127 operations in 1 seconds (  6946032 bytes)
test 17 (256 bit key,   64 byte blocks): 423837 operations in 1 seconds ( 27125568 bytes)
test 18 (256 bit key,  256 byte blocks): 351244 operations in 1 seconds ( 89918464 bytes)
test 19 (256 bit key,  512 byte blocks): 286884 operations in 1 seconds (146884608 bytes)
test 20 (256 bit key, 1024 byte blocks): 209954 operations in 1 seconds (214992896 bytes)
test 21 (256 bit key, 2048 byte blocks): 136553 operations in 1 seconds (279660544 bytes)
test 22 (256 bit key, 4096 byte blocks):  80749 operations in 1 seconds (330747904 bytes)
test 23 (256 bit key, 8192 byte blocks):  43118 operations in 1 seconds (353222656 bytes)
