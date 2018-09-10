From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/4] crypto: arm64/aes-blk - improve XTS mask handling
Date: Mon, 10 Sep 2018 16:41:15 +0200
Message-ID: <20180910144115.25727-5-ard.biesheuvel@linaro.org>
References: <20180910144115.25727-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Theodore Ts'o <tytso@mit.edu>,
 herbert@gondor.apana.org.au, Steve Capper <steve.capper@arm.com>,
 Eric Biggers <ebiggers@google.com>, linux-arm-kernel@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180910144115.25727-1-ard.biesheuvel@linaro.org>
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

The Crypto Extension instantiation of the aes-modes.S collection of
skciphers uses only 15 NEON registers for the round key array, whereas
the pure NEON flavor uses 16 NEON registers for the AES S-box.

This means we have a spare register available that we can use to hold
the XTS mask vector, removing the need to reload it at every iteration
of the inner loop.

Since the pure NEON version does not permit this optimization, tweak
the macros so we can factor out this functionality. Also, replace the
literal load with a short sequence to compose the mask vector.

On Cortex-A53, this results in a ~4% speedup.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
Raw performance numbers after the patch.

 arch/arm64/crypto/aes-ce.S    |  5 +++
 arch/arm64/crypto/aes-modes.S | 40 ++++++++++----------
 arch/arm64/crypto/aes-neon.S  |  6 +++
 3 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 623e74ed1c67..143070510809 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -17,6 +17,11 @@
 
 	.arch		armv8-a+crypto
 
+	xtsmask		.req	v16
+
+	.macro		xts_reload_mask, tmp
+	.endm
+
 	/* preload all round keys */
 	.macro		load_round_keys, rounds, rk
 	cmp		\rounds, #12
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 82931fba53d2..5c0fa7905d24 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -340,17 +340,19 @@ AES_ENDPROC(aes_ctr_encrypt)
 	 *		   int blocks, u8 const rk2[], u8 iv[], int first)
 	 */
 
-	.macro		next_tweak, out, in, const, tmp
+	.macro		next_tweak, out, in, tmp
 	sshr		\tmp\().2d,  \in\().2d,   #63
-	and		\tmp\().16b, \tmp\().16b, \const\().16b
+	and		\tmp\().16b, \tmp\().16b, xtsmask.16b
 	add		\out\().2d,  \in\().2d,   \in\().2d
 	ext		\tmp\().16b, \tmp\().16b, \tmp\().16b, #8
 	eor		\out\().16b, \out\().16b, \tmp\().16b
 	.endm
 
-.Lxts_mul_x:
-CPU_LE(	.quad		1, 0x87		)
-CPU_BE(	.quad		0x87, 1		)
+	.macro		xts_load_mask, tmp
+	movi		xtsmask.2s, #0x1
+	movi		\tmp\().2s, #0x87
+	uzp1		xtsmask.4s, xtsmask.4s, \tmp\().4s
+	.endm
 
 AES_ENTRY(aes_xts_encrypt)
 	stp		x29, x30, [sp, #-16]!
@@ -362,24 +364,24 @@ AES_ENTRY(aes_xts_encrypt)
 	enc_prepare	w3, x5, x8
 	encrypt_block	v4, w3, x5, x8, w7		/* first tweak */
 	enc_switch_key	w3, x2, x8
-	ldr		q7, .Lxts_mul_x
+	xts_load_mask	v8
 	b		.LxtsencNx
 
 .Lxtsencnotfirst:
 	enc_prepare	w3, x2, x8
 .LxtsencloopNx:
-	ldr		q7, .Lxts_mul_x
-	next_tweak	v4, v4, v7, v8
+	xts_reload_mask	v8
+	next_tweak	v4, v4, v8
 .LxtsencNx:
 	subs		w4, w4, #4
 	bmi		.Lxtsenc1x
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
-	next_tweak	v5, v4, v7, v8
+	next_tweak	v5, v4, v8
 	eor		v0.16b, v0.16b, v4.16b
-	next_tweak	v6, v5, v7, v8
+	next_tweak	v6, v5, v8
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	next_tweak	v7, v6, v7, v8
+	next_tweak	v7, v6, v8
 	eor		v3.16b, v3.16b, v7.16b
 	bl		aes_encrypt_block4x
 	eor		v3.16b, v3.16b, v7.16b
@@ -401,7 +403,7 @@ AES_ENTRY(aes_xts_encrypt)
 	st1		{v0.16b}, [x0], #16
 	subs		w4, w4, #1
 	beq		.Lxtsencout
-	next_tweak	v4, v4, v7, v8
+	next_tweak	v4, v4, v8
 	b		.Lxtsencloop
 .Lxtsencout:
 	st1		{v4.16b}, [x6]
@@ -420,24 +422,24 @@ AES_ENTRY(aes_xts_decrypt)
 	enc_prepare	w3, x5, x8
 	encrypt_block	v4, w3, x5, x8, w7		/* first tweak */
 	dec_prepare	w3, x2, x8
-	ldr		q7, .Lxts_mul_x
+	xts_load_mask	v8
 	b		.LxtsdecNx
 
 .Lxtsdecnotfirst:
 	dec_prepare	w3, x2, x8
 .LxtsdecloopNx:
-	ldr		q7, .Lxts_mul_x
-	next_tweak	v4, v4, v7, v8
+	xts_reload_mask	v8
+	next_tweak	v4, v4, v8
 .LxtsdecNx:
 	subs		w4, w4, #4
 	bmi		.Lxtsdec1x
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
-	next_tweak	v5, v4, v7, v8
+	next_tweak	v5, v4, v8
 	eor		v0.16b, v0.16b, v4.16b
-	next_tweak	v6, v5, v7, v8
+	next_tweak	v6, v5, v8
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	next_tweak	v7, v6, v7, v8
+	next_tweak	v7, v6, v8
 	eor		v3.16b, v3.16b, v7.16b
 	bl		aes_decrypt_block4x
 	eor		v3.16b, v3.16b, v7.16b
@@ -459,7 +461,7 @@ AES_ENTRY(aes_xts_decrypt)
 	st1		{v0.16b}, [x0], #16
 	subs		w4, w4, #1
 	beq		.Lxtsdecout
-	next_tweak	v4, v4, v7, v8
+	next_tweak	v4, v4, v8
 	b		.Lxtsdecloop
 .Lxtsdecout:
 	st1		{v4.16b}, [x6]
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index 1c7b45b7268e..29100f692e8a 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -14,6 +14,12 @@
 #define AES_ENTRY(func)		ENTRY(neon_ ## func)
 #define AES_ENDPROC(func)	ENDPROC(neon_ ## func)
 
+	xtsmask		.req	v7
+
+	.macro		xts_reload_mask, tmp
+	xts_load_mask	\tmp
+	.endm
+
 	/* multiply by polynomial 'x' in GF(2^8) */
 	.macro		mul_by_x, out, in, temp, const
 	sshr		\temp, \in, #7
-- 
2.18.0

Cortex-A53 @ 1 GHz

BEFORE:

testing speed of async xts(aes) (xts-aes-ce) encryption
0 (256 bit key,   16 byte blocks): 1338059 ops in 1 secs ( 21408944 bytes)
1 (256 bit key,   64 byte blocks): 1249191 ops in 1 secs ( 79948224 bytes)
2 (256 bit key,  256 byte blocks):  918979 ops in 1 secs (235258624 bytes)
3 (256 bit key, 1024 byte blocks):  456993 ops in 1 secs (467960832 bytes)
4 (256 bit key, 8192 byte blocks):   74937 ops in 1 secs (613883904 bytes)
5 (512 bit key,   16 byte blocks): 1269281 ops in 1 secs ( 20308496 bytes)
6 (512 bit key,   64 byte blocks): 1176362 ops in 1 secs ( 75287168 bytes)
7 (512 bit key,  256 byte blocks):  840553 ops in 1 secs (215181568 bytes)
8 (512 bit key, 1024 byte blocks):  400329 ops in 1 secs (409936896 bytes)
9 (512 bit key, 8192 byte blocks):   64268 ops in 1 secs (526483456 bytes)

testing speed of async xts(aes) (xts-aes-ce) decryption
0 (256 bit key,   16 byte blocks): 1333819 ops in 1 secs ( 21341104 bytes)
1 (256 bit key,   64 byte blocks): 1239393 ops in 1 secs ( 79321152 bytes)
2 (256 bit key,  256 byte blocks):  913715 ops in 1 secs (233911040 bytes)
3 (256 bit key, 1024 byte blocks):  455176 ops in 1 secs (466100224 bytes)
4 (256 bit key, 8192 byte blocks):   74343 ops in 1 secs (609017856 bytes)
5 (512 bit key,   16 byte blocks): 1274941 ops in 1 secs ( 20399056 bytes)
6 (512 bit key,   64 byte blocks): 1182107 ops in 1 secs ( 75654848 bytes)
7 (512 bit key,  256 byte blocks):  844930 ops in 1 secs (216302080 bytes)
8 (512 bit key, 1024 byte blocks):  401614 ops in 1 secs (411252736 bytes)
9 (512 bit key, 8192 byte blocks):   63913 ops in 1 secs (523575296 bytes)

AFTER:

testing speed of async xts(aes) (xts-aes-ce) encryption
0 (256 bit key,   16 byte blocks): 1398063 ops in 1 secs ( 22369008 bytes)
1 (256 bit key,   64 byte blocks): 1302694 ops in 1 secs ( 83372416 bytes)
2 (256 bit key,  256 byte blocks):  951692 ops in 1 secs (243633152 bytes)
3 (256 bit key, 1024 byte blocks):  473198 ops in 1 secs (484554752 bytes)
4 (256 bit key, 8192 byte blocks):   77204 ops in 1 secs (632455168 bytes)
5 (512 bit key,   16 byte blocks): 1323582 ops in 1 secs ( 21177312 bytes)
6 (512 bit key,   64 byte blocks): 1222306 ops in 1 secs ( 78227584 bytes)
7 (512 bit key,  256 byte blocks):  871791 ops in 1 secs (223178496 bytes)
8 (512 bit key, 1024 byte blocks):  413557 ops in 1 secs (423482368 bytes)
9 (512 bit key, 8192 byte blocks):   66014 ops in 1 secs (540786688 bytes)

testing speed of async xts(aes) (xts-aes-ce) decryption
0 (256 bit key,   16 byte blocks): 1399388 ops in 1 secs ( 22390208 bytes)
1 (256 bit key,   64 byte blocks): 1300861 ops in 1 secs ( 83255104 bytes)
2 (256 bit key,  256 byte blocks):  951950 ops in 1 secs (243699200 bytes)
3 (256 bit key, 1024 byte blocks):  473399 ops in 1 secs (484760576 bytes)
4 (256 bit key, 8192 byte blocks):   77168 ops in 1 secs (632160256 bytes)
5 (512 bit key,   16 byte blocks): 1317833 ops in 1 secs ( 21085328 bytes)
6 (512 bit key,   64 byte blocks): 1217145 ops in 1 secs ( 77897280 bytes)
7 (512 bit key,  256 byte blocks):  868323 ops in 1 secs (222290688 bytes)
8 (512 bit key, 1024 byte blocks):  412821 ops in 1 secs (422728704 bytes)
9 (512 bit key, 8192 byte blocks):   65919 ops in 1 secs (540008448 bytes)
