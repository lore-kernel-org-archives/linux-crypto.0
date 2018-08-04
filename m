From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm64/ghash-ce - implement 4-way aggregation
Date: Sat,  4 Aug 2018 20:46:25 +0200
Message-ID: <20180804184625.28523-3-ard.biesheuvel@linaro.org>
References: <20180804184625.28523-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, jerome.forissier@linaro.org,
 herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 jens.wiklander@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180804184625.28523-1-ard.biesheuvel@linaro.org>
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

Enhance the GHASH implementation that uses 64-bit polynomial
multiplication by adding support for 4-way aggregation. This
more than doubles the performance, from 2.4 cycles per byte
to 1.1 cpb on Cortex-A53.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 122 +++++++++++++++++---
 arch/arm64/crypto/ghash-ce-glue.c |  71 ++++++------
 2 files changed, 142 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 344811c6a0ca..1b319b716d5e 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -46,6 +46,19 @@
 	ss3		.req	v26
 	ss4		.req	v27
 
+	XL2		.req	v8
+	XM2		.req	v9
+	XH2		.req	v10
+	XL3		.req	v11
+	XM3		.req	v12
+	XH3		.req	v13
+	TT3		.req	v14
+	TT4		.req	v15
+	HH		.req	v16
+	HH3		.req	v17
+	HH4		.req	v18
+	HH34		.req	v19
+
 	.text
 	.arch		armv8-a+crypto
 
@@ -134,11 +147,25 @@
 	.endm
 
 	.macro		__pmull_pre_p64
+	add		x8, x3, #16
+	ld1		{HH.2d-HH4.2d}, [x8]
+
+	trn1		SHASH2.2d, SHASH.2d, HH.2d
+	trn2		T1.2d, SHASH.2d, HH.2d
+	eor		SHASH2.16b, SHASH2.16b, T1.16b
+
+	trn1		HH34.2d, HH3.2d, HH4.2d
+	trn2		T1.2d, HH3.2d, HH4.2d
+	eor		HH34.16b, HH34.16b, T1.16b
+
 	movi		MASK.16b, #0xe1
 	shl		MASK.2d, MASK.2d, #57
 	.endm
 
 	.macro		__pmull_pre_p8
+	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
+	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
+
 	// k00_16 := 0x0000000000000000_000000000000ffff
 	// k32_48 := 0x00000000ffffffff_0000ffffffffffff
 	movi		k32_48.2d, #0xffffffff
@@ -215,8 +242,6 @@
 	.macro		__pmull_ghash, pn
 	ld1		{SHASH.2d}, [x3]
 	ld1		{XL.2d}, [x1]
-	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
-	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	__pmull_pre_\pn
 
@@ -224,12 +249,79 @@
 	cbz		x4, 0f
 	ld1		{T1.2d}, [x4]
 	mov		x4, xzr
-	b		1f
+	b		3f
+
+0:	.ifc		\pn, p64
+	tbnz		w0, #0, 2f		// skip until #blocks is a
+	tbnz		w0, #1, 2f		// round multiple of 4
+
+1:	ld1		{XM3.16b-TT4.16b}, [x2], #64
+
+	sub		w0, w0, #4
+
+	rev64		T1.16b, XM3.16b
+	rev64		T2.16b, XH3.16b
+	rev64		TT4.16b, TT4.16b
+	rev64		TT3.16b, TT3.16b
+
+	ext		IN1.16b, TT4.16b, TT4.16b, #8
+	ext		XL3.16b, TT3.16b, TT3.16b, #8
+
+	eor		TT4.16b, TT4.16b, IN1.16b
+	pmull2		XH2.1q, SHASH.2d, IN1.2d	// a1 * b1
+	pmull		XL2.1q, SHASH.1d, IN1.1d	// a0 * b0
+	pmull		XM2.1q, SHASH2.1d, TT4.1d	// (a1 + a0)(b1 + b0)
+
+	eor		TT3.16b, TT3.16b, XL3.16b
+	pmull2		XH3.1q, HH.2d, XL3.2d		// a1 * b1
+	pmull		XL3.1q, HH.1d, XL3.1d		// a0 * b0
+	pmull2		XM3.1q, SHASH2.2d, TT3.2d	// (a1 + a0)(b1 + b0)
+
+	ext		IN1.16b, T2.16b, T2.16b, #8
+	eor		XL2.16b, XL2.16b, XL3.16b
+	eor		XH2.16b, XH2.16b, XH3.16b
+	eor		XM2.16b, XM2.16b, XM3.16b
+
+	eor		T2.16b, T2.16b, IN1.16b
+	pmull2		XH3.1q, HH3.2d, IN1.2d		// a1 * b1
+	pmull		XL3.1q, HH3.1d, IN1.1d		// a0 * b0
+	pmull		XM3.1q, HH34.1d, T2.1d		// (a1 + a0)(b1 + b0)
 
-0:	ld1		{T1.2d}, [x2], #16
+	eor		XL2.16b, XL2.16b, XL3.16b
+	eor		XH2.16b, XH2.16b, XH3.16b
+	eor		XM2.16b, XM2.16b, XM3.16b
+
+	ext		IN1.16b, T1.16b, T1.16b, #8
+	ext		TT3.16b, XL.16b, XL.16b, #8
+	eor		XL.16b, XL.16b, IN1.16b
+	eor		T1.16b, T1.16b, TT3.16b
+
+	pmull2		XH.1q, HH4.2d, XL.2d		// a1 * b1
+	eor		T1.16b, T1.16b, XL.16b
+	pmull		XL.1q, HH4.1d, XL.1d		// a0 * b0
+	pmull2		XM.1q, HH34.2d, T1.2d		// (a1 + a0)(b1 + b0)
+
+	eor		XL.16b, XL.16b, XL2.16b
+	eor		XH.16b, XH.16b, XH2.16b
+	eor		XM.16b, XM.16b, XM2.16b
+
+	eor		T2.16b, XL.16b, XH.16b
+	ext		T1.16b, XL.16b, XH.16b, #8
+	eor		XM.16b, XM.16b, T2.16b
+
+	__pmull_reduce_p64
+
+	eor		T2.16b, T2.16b, XH.16b
+	eor		XL.16b, XL.16b, T2.16b
+
+	cbz		w0, 5f
+	b		1b
+	.endif
+
+2:	ld1		{T1.2d}, [x2], #16
 	sub		w0, w0, #1
 
-1:	/* multiply XL by SHASH in GF(2^128) */
+3:	/* multiply XL by SHASH in GF(2^128) */
 CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	ext		T2.16b, XL.16b, XL.16b, #8
@@ -242,7 +334,7 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	__pmull_\pn 	XL, XL, SHASH			// a0 * b0
 	__pmull_\pn	XM, T1, SHASH2			// (a1 + a0)(b1 + b0)
 
-	eor		T2.16b, XL.16b, XH.16b
+4:	eor		T2.16b, XL.16b, XH.16b
 	ext		T1.16b, XL.16b, XH.16b, #8
 	eor		XM.16b, XM.16b, T2.16b
 
@@ -253,7 +345,7 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	cbnz		w0, 0b
 
-	st1		{XL.2d}, [x1]
+5:	st1		{XL.2d}, [x1]
 	ret
 	.endm
 
@@ -269,14 +361,10 @@ ENTRY(pmull_ghash_update_p8)
 	__pmull_ghash	p8
 ENDPROC(pmull_ghash_update_p8)
 
-	KS0		.req	v8
-	KS1		.req	v9
-	INP0		.req	v10
-	INP1		.req	v11
-	HH		.req	v12
-	XL2		.req	v13
-	XM2		.req	v14
-	XH2		.req	v15
+	KS0		.req	v12
+	KS1		.req	v13
+	INP0		.req	v14
+	INP1		.req	v15
 
 	.macro		load_round_keys, rounds, rk
 	cmp		\rounds, #12
@@ -310,8 +398,8 @@ ENDPROC(pmull_ghash_update_p8)
 	.endm
 
 	.macro		pmull_gcm_do_crypt, enc
-	ld1		{HH.2d}, [x4], #16
-	ld1		{SHASH.2d}, [x4]
+	ld1		{SHASH.2d}, [x4], #16
+	ld1		{HH.2d}, [x4]
 	ld1		{XL.2d}, [x1]
 	ldr		x8, [x5, #8]			// load lower counter
 
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 03ce71ea81a2..08b49fd621cb 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -33,9 +33,12 @@ MODULE_ALIAS_CRYPTO("ghash");
 #define GCM_IV_SIZE		12
 
 struct ghash_key {
-	u64 a;
-	u64 b;
-	be128 k;
+	u64			h[2];
+	u64			h2[2];
+	u64			h3[2];
+	u64			h4[2];
+
+	be128			k;
 };
 
 struct ghash_desc_ctx {
@@ -46,7 +49,6 @@ struct ghash_desc_ctx {
 
 struct gcm_aes_ctx {
 	struct crypto_aes_ctx	aes_key;
-	u64			h2[2];
 	struct ghash_key	ghash_key;
 };
 
@@ -63,11 +65,12 @@ static void (*pmull_ghash_update)(int blocks, u64 dg[], const char *src,
 				  const char *head);
 
 asmlinkage void pmull_gcm_encrypt(int blocks, u64 dg[], u8 dst[],
-				  const u8 src[], u64 const *k, u8 ctr[],
-				  u32 const rk[], int rounds, u8 ks[]);
+				  const u8 src[], struct ghash_key const *k,
+				  u8 ctr[], u32 const rk[], int rounds,
+				  u8 ks[]);
 
 asmlinkage void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[],
-				  const u8 src[], u64 const *k,
+				  const u8 src[], struct ghash_key const *k,
 				  u8 ctr[], u32 const rk[], int rounds);
 
 asmlinkage void pmull_gcm_encrypt_block(u8 dst[], u8 const src[],
@@ -174,23 +177,36 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 	return 0;
 }
 
+static void ghash_reflect(u64 h[], const be128 *k)
+{
+	u64 carry = be64_to_cpu(k->a) & BIT(63) ? 1 : 0;
+
+	h[0] = (be64_to_cpu(k->b) << 1) | carry;
+	h[1] = (be64_to_cpu(k->a) << 1) | (be64_to_cpu(k->b) >> 63);
+
+	if (carry)
+		h[1] ^= 0xc200000000000000UL;
+}
+
 static int __ghash_setkey(struct ghash_key *key,
 			  const u8 *inkey, unsigned int keylen)
 {
-	u64 a, b;
+	be128 h;
 
 	/* needed for the fallback */
 	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
 
-	/* perform multiplication by 'x' in GF(2^128) */
-	b = get_unaligned_be64(inkey);
-	a = get_unaligned_be64(inkey + 8);
+	ghash_reflect(key->h, &key->k);
+
+	h = key->k;
+	gf128mul_lle(&h, &key->k);
+	ghash_reflect(key->h2, &h);
 
-	key->a = (a << 1) | (b >> 63);
-	key->b = (b << 1) | (a >> 63);
+	gf128mul_lle(&h, &key->k);
+	ghash_reflect(key->h3, &h);
 
-	if (b >> 63)
-		key->b ^= 0xc200000000000000UL;
+	gf128mul_lle(&h, &key->k);
+	ghash_reflect(key->h4, &h);
 
 	return 0;
 }
@@ -241,8 +257,7 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 		      unsigned int keylen)
 {
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
-	be128 h1, h2;
-	u8 *key = (u8 *)&h1;
+	u8 key[GHASH_BLOCK_SIZE];
 	int ret;
 
 	ret = crypto_aes_expand_key(&ctx->aes_key, inkey, keylen);
@@ -254,19 +269,7 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	__aes_arm64_encrypt(ctx->aes_key.key_enc, key, (u8[AES_BLOCK_SIZE]){},
 			    num_rounds(&ctx->aes_key));
 
-	__ghash_setkey(&ctx->ghash_key, key, sizeof(be128));
-
-	/* calculate H^2 (used for 2-way aggregation) */
-	h2 = h1;
-	gf128mul_lle(&h2, &h1);
-
-	ctx->h2[0] = (be64_to_cpu(h2.b) << 1) | (be64_to_cpu(h2.a) >> 63);
-	ctx->h2[1] = (be64_to_cpu(h2.a) << 1) | (be64_to_cpu(h2.b) >> 63);
-
-	if (be64_to_cpu(h2.a) >> 63)
-		ctx->h2[1] ^= 0xc200000000000000UL;
-
-	return 0;
+	return __ghash_setkey(&ctx->ghash_key, key, sizeof(be128));
 }
 
 static int gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
@@ -402,8 +405,8 @@ static int gcm_encrypt(struct aead_request *req)
 				kernel_neon_begin();
 
 			pmull_gcm_encrypt(blocks, dg, walk.dst.virt.addr,
-					  walk.src.virt.addr, ctx->h2, iv,
-					  rk, nrounds, ks);
+					  walk.src.virt.addr, &ctx->ghash_key,
+					  iv, rk, nrounds, ks);
 			kernel_neon_end();
 
 			err = skcipher_walk_done(&walk,
@@ -513,8 +516,8 @@ static int gcm_decrypt(struct aead_request *req)
 				kernel_neon_begin();
 
 			pmull_gcm_decrypt(blocks, dg, walk.dst.virt.addr,
-					  walk.src.virt.addr, ctx->h2, iv,
-					  rk, nrounds);
+					  walk.src.virt.addr, &ctx->ghash_key,
+					  iv, rk, nrounds);
 
 			/* check if this is the final iteration of the loop */
 			if (rem < (2 * AES_BLOCK_SIZE)) {
-- 
2.18.0
