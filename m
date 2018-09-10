From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/4] crypto: arm64/aes-blk - revert NEON yield for skciphers
Date: Mon, 10 Sep 2018 16:41:13 +0200
Message-ID: <20180910144115.25727-3-ard.biesheuvel@linaro.org>
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

The reasoning of commit f10dc56c64bb ("crypto: arm64 - revert NEON yield
for fast AEAD implementations") applies equally to skciphers: the walk
API already guarantees that the input size of each call into the NEON
code is bounded to the size of a page, and so there is no need for an
additional TIF_NEED_RESCHED flag check inside the inner loop. So revert
the skcipher changes to aes-modes.S (but retain the mac ones)

This partially reverts commit 0c8f838a52fe9fd82761861a934f16ef9896b4e5.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-modes.S | 281 ++++++++------------
 1 file changed, 108 insertions(+), 173 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 496c243de4ac..35632d11200f 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -14,12 +14,12 @@
 	.align		4
 
 aes_encrypt_block4x:
-	encrypt_block4x	v0, v1, v2, v3, w22, x21, x8, w7
+	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	ret
 ENDPROC(aes_encrypt_block4x)
 
 aes_decrypt_block4x:
-	decrypt_block4x	v0, v1, v2, v3, w22, x21, x8, w7
+	decrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	ret
 ENDPROC(aes_decrypt_block4x)
 
@@ -31,71 +31,57 @@ ENDPROC(aes_decrypt_block4x)
 	 */
 
 AES_ENTRY(aes_ecb_encrypt)
-	frame_push	5
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-
-.Lecbencrestart:
-	enc_prepare	w22, x21, x5
+	enc_prepare	w3, x2, x5
 
 .LecbencloopNx:
-	subs		w23, w23, #4
+	subs		w4, w4, #4
 	bmi		.Lecbenc1x
-	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 pt blocks */
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
 	bl		aes_encrypt_block4x
-	st1		{v0.16b-v3.16b}, [x19], #64
-	cond_yield_neon	.Lecbencrestart
+	st1		{v0.16b-v3.16b}, [x0], #64
 	b		.LecbencloopNx
 .Lecbenc1x:
-	adds		w23, w23, #4
+	adds		w4, w4, #4
 	beq		.Lecbencout
 .Lecbencloop:
-	ld1		{v0.16b}, [x20], #16		/* get next pt block */
-	encrypt_block	v0, w22, x21, x5, w6
-	st1		{v0.16b}, [x19], #16
-	subs		w23, w23, #1
+	ld1		{v0.16b}, [x1], #16		/* get next pt block */
+	encrypt_block	v0, w3, x2, x5, w6
+	st1		{v0.16b}, [x0], #16
+	subs		w4, w4, #1
 	bne		.Lecbencloop
 .Lecbencout:
-	frame_pop
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_ecb_encrypt)
 
 
 AES_ENTRY(aes_ecb_decrypt)
-	frame_push	5
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-
-.Lecbdecrestart:
-	dec_prepare	w22, x21, x5
+	dec_prepare	w3, x2, x5
 
 .LecbdecloopNx:
-	subs		w23, w23, #4
+	subs		w4, w4, #4
 	bmi		.Lecbdec1x
-	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 ct blocks */
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
 	bl		aes_decrypt_block4x
-	st1		{v0.16b-v3.16b}, [x19], #64
-	cond_yield_neon	.Lecbdecrestart
+	st1		{v0.16b-v3.16b}, [x0], #64
 	b		.LecbdecloopNx
 .Lecbdec1x:
-	adds		w23, w23, #4
+	adds		w4, w4, #4
 	beq		.Lecbdecout
 .Lecbdecloop:
-	ld1		{v0.16b}, [x20], #16		/* get next ct block */
-	decrypt_block	v0, w22, x21, x5, w6
-	st1		{v0.16b}, [x19], #16
-	subs		w23, w23, #1
+	ld1		{v0.16b}, [x1], #16		/* get next ct block */
+	decrypt_block	v0, w3, x2, x5, w6
+	st1		{v0.16b}, [x0], #16
+	subs		w4, w4, #1
 	bne		.Lecbdecloop
 .Lecbdecout:
-	frame_pop
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_ecb_decrypt)
 
@@ -108,100 +94,78 @@ AES_ENDPROC(aes_ecb_decrypt)
 	 */
 
 AES_ENTRY(aes_cbc_encrypt)
-	frame_push	6
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x5
-
-.Lcbcencrestart:
-	ld1		{v4.16b}, [x24]			/* get iv */
-	enc_prepare	w22, x21, x6
+	ld1		{v4.16b}, [x5]			/* get iv */
+	enc_prepare	w3, x2, x6
 
 .Lcbcencloop4x:
-	subs		w23, w23, #4
+	subs		w4, w4, #4
 	bmi		.Lcbcenc1x
-	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 pt blocks */
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
 	eor		v0.16b, v0.16b, v4.16b		/* ..and xor with iv */
-	encrypt_block	v0, w22, x21, x6, w7
+	encrypt_block	v0, w3, x2, x6, w7
 	eor		v1.16b, v1.16b, v0.16b
-	encrypt_block	v1, w22, x21, x6, w7
+	encrypt_block	v1, w3, x2, x6, w7
 	eor		v2.16b, v2.16b, v1.16b
-	encrypt_block	v2, w22, x21, x6, w7
+	encrypt_block	v2, w3, x2, x6, w7
 	eor		v3.16b, v3.16b, v2.16b
-	encrypt_block	v3, w22, x21, x6, w7
-	st1		{v0.16b-v3.16b}, [x19], #64
+	encrypt_block	v3, w3, x2, x6, w7
+	st1		{v0.16b-v3.16b}, [x0], #64
 	mov		v4.16b, v3.16b
-	st1		{v4.16b}, [x24]			/* return iv */
-	cond_yield_neon	.Lcbcencrestart
 	b		.Lcbcencloop4x
 .Lcbcenc1x:
-	adds		w23, w23, #4
+	adds		w4, w4, #4
 	beq		.Lcbcencout
 .Lcbcencloop:
-	ld1		{v0.16b}, [x20], #16		/* get next pt block */
+	ld1		{v0.16b}, [x1], #16		/* get next pt block */
 	eor		v4.16b, v4.16b, v0.16b		/* ..and xor with iv */
-	encrypt_block	v4, w22, x21, x6, w7
-	st1		{v4.16b}, [x19], #16
-	subs		w23, w23, #1
+	encrypt_block	v4, w3, x2, x6, w7
+	st1		{v4.16b}, [x0], #16
+	subs		w4, w4, #1
 	bne		.Lcbcencloop
 .Lcbcencout:
-	st1		{v4.16b}, [x24]			/* return iv */
-	frame_pop
+	st1		{v4.16b}, [x5]			/* return iv */
 	ret
 AES_ENDPROC(aes_cbc_encrypt)
 
 
 AES_ENTRY(aes_cbc_decrypt)
-	frame_push	6
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x5
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
-.Lcbcdecrestart:
-	ld1		{v7.16b}, [x24]			/* get iv */
-	dec_prepare	w22, x21, x6
+	ld1		{v7.16b}, [x5]			/* get iv */
+	dec_prepare	w3, x2, x6
 
 .LcbcdecloopNx:
-	subs		w23, w23, #4
+	subs		w4, w4, #4
 	bmi		.Lcbcdec1x
-	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 ct blocks */
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
 	mov		v4.16b, v0.16b
 	mov		v5.16b, v1.16b
 	mov		v6.16b, v2.16b
 	bl		aes_decrypt_block4x
-	sub		x20, x20, #16
+	sub		x1, x1, #16
 	eor		v0.16b, v0.16b, v7.16b
 	eor		v1.16b, v1.16b, v4.16b
-	ld1		{v7.16b}, [x20], #16		/* reload 1 ct block */
+	ld1		{v7.16b}, [x1], #16		/* reload 1 ct block */
 	eor		v2.16b, v2.16b, v5.16b
 	eor		v3.16b, v3.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x19], #64
-	st1		{v7.16b}, [x24]			/* return iv */
-	cond_yield_neon	.Lcbcdecrestart
+	st1		{v0.16b-v3.16b}, [x0], #64
 	b		.LcbcdecloopNx
 .Lcbcdec1x:
-	adds		w23, w23, #4
+	adds		w4, w4, #4
 	beq		.Lcbcdecout
 .Lcbcdecloop:
-	ld1		{v1.16b}, [x20], #16		/* get next ct block */
+	ld1		{v1.16b}, [x1], #16		/* get next ct block */
 	mov		v0.16b, v1.16b			/* ...and copy to v0 */
-	decrypt_block	v0, w22, x21, x6, w7
+	decrypt_block	v0, w3, x2, x6, w7
 	eor		v0.16b, v0.16b, v7.16b		/* xor with iv => pt */
 	mov		v7.16b, v1.16b			/* ct is next iv */
-	st1		{v0.16b}, [x19], #16
-	subs		w23, w23, #1
+	st1		{v0.16b}, [x0], #16
+	subs		w4, w4, #1
 	bne		.Lcbcdecloop
 .Lcbcdecout:
-	st1		{v7.16b}, [x24]			/* return iv */
-	frame_pop
+	st1		{v7.16b}, [x5]			/* return iv */
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
 
@@ -212,26 +176,19 @@ AES_ENDPROC(aes_cbc_decrypt)
 	 */
 
 AES_ENTRY(aes_ctr_encrypt)
-	frame_push	6
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x5
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
-.Lctrrestart:
-	enc_prepare	w22, x21, x6
-	ld1		{v4.16b}, [x24]
+	enc_prepare	w3, x2, x6
+	ld1		{v4.16b}, [x5]
 
 	umov		x6, v4.d[1]		/* keep swabbed ctr in reg */
 	rev		x6, x6
+	cmn		w6, w4			/* 32 bit overflow? */
+	bcs		.Lctrloop
 .LctrloopNx:
-	subs		w23, w23, #4
+	subs		w4, w4, #4
 	bmi		.Lctr1x
-	cmn		w6, #4			/* 32 bit overflow? */
-	bcs		.Lctr1x
 	add		w7, w6, #1
 	mov		v0.16b, v4.16b
 	add		w8, w6, #2
@@ -245,27 +202,25 @@ AES_ENTRY(aes_ctr_encrypt)
 	rev		w9, w9
 	mov		v2.s[3], w8
 	mov		v3.s[3], w9
-	ld1		{v5.16b-v7.16b}, [x20], #48	/* get 3 input blocks */
+	ld1		{v5.16b-v7.16b}, [x1], #48	/* get 3 input blocks */
 	bl		aes_encrypt_block4x
 	eor		v0.16b, v5.16b, v0.16b
-	ld1		{v5.16b}, [x20], #16		/* get 1 input block  */
+	ld1		{v5.16b}, [x1], #16		/* get 1 input block  */
 	eor		v1.16b, v6.16b, v1.16b
 	eor		v2.16b, v7.16b, v2.16b
 	eor		v3.16b, v5.16b, v3.16b
-	st1		{v0.16b-v3.16b}, [x19], #64
+	st1		{v0.16b-v3.16b}, [x0], #64
 	add		x6, x6, #4
 	rev		x7, x6
 	ins		v4.d[1], x7
-	cbz		w23, .Lctrout
-	st1		{v4.16b}, [x24]		/* return next CTR value */
-	cond_yield_neon	.Lctrrestart
+	cbz		w4, .Lctrout
 	b		.LctrloopNx
 .Lctr1x:
-	adds		w23, w23, #4
+	adds		w4, w4, #4
 	beq		.Lctrout
 .Lctrloop:
 	mov		v0.16b, v4.16b
-	encrypt_block	v0, w22, x21, x8, w7
+	encrypt_block	v0, w3, x2, x8, w7
 
 	adds		x6, x6, #1		/* increment BE ctr */
 	rev		x7, x6
@@ -273,22 +228,22 @@ AES_ENTRY(aes_ctr_encrypt)
 	bcs		.Lctrcarry		/* overflow? */
 
 .Lctrcarrydone:
-	subs		w23, w23, #1
+	subs		w4, w4, #1
 	bmi		.Lctrtailblock		/* blocks <0 means tail block */
-	ld1		{v3.16b}, [x20], #16
+	ld1		{v3.16b}, [x1], #16
 	eor		v3.16b, v0.16b, v3.16b
-	st1		{v3.16b}, [x19], #16
+	st1		{v3.16b}, [x0], #16
 	bne		.Lctrloop
 
 .Lctrout:
-	st1		{v4.16b}, [x24]		/* return next CTR value */
-.Lctrret:
-	frame_pop
+	st1		{v4.16b}, [x5]		/* return next CTR value */
+	ldp		x29, x30, [sp], #16
 	ret
 
 .Lctrtailblock:
-	st1		{v0.16b}, [x19]
-	b		.Lctrret
+	st1		{v0.16b}, [x0]
+	ldp		x29, x30, [sp], #16
+	ret
 
 .Lctrcarry:
 	umov		x7, v4.d[0]		/* load upper word of ctr  */
@@ -321,16 +276,10 @@ CPU_LE(	.quad		1, 0x87		)
 CPU_BE(	.quad		0x87, 1		)
 
 AES_ENTRY(aes_xts_encrypt)
-	frame_push	6
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x6
-
-	ld1		{v4.16b}, [x24]
+	ld1		{v4.16b}, [x6]
 	cbz		w7, .Lxtsencnotfirst
 
 	enc_prepare	w3, x5, x8
@@ -339,17 +288,15 @@ AES_ENTRY(aes_xts_encrypt)
 	ldr		q7, .Lxts_mul_x
 	b		.LxtsencNx
 
-.Lxtsencrestart:
-	ld1		{v4.16b}, [x24]
 .Lxtsencnotfirst:
-	enc_prepare	w22, x21, x8
+	enc_prepare	w3, x2, x8
 .LxtsencloopNx:
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
 .LxtsencNx:
-	subs		w23, w23, #4
+	subs		w4, w4, #4
 	bmi		.Lxtsenc1x
-	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 pt blocks */
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
 	next_tweak	v5, v4, v7, v8
 	eor		v0.16b, v0.16b, v4.16b
 	next_tweak	v6, v5, v7, v8
@@ -362,43 +309,35 @@ AES_ENTRY(aes_xts_encrypt)
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x19], #64
+	st1		{v0.16b-v3.16b}, [x0], #64
 	mov		v4.16b, v7.16b
-	cbz		w23, .Lxtsencout
-	st1		{v4.16b}, [x24]
-	cond_yield_neon	.Lxtsencrestart
+	cbz		w4, .Lxtsencout
 	b		.LxtsencloopNx
 .Lxtsenc1x:
-	adds		w23, w23, #4
+	adds		w4, w4, #4
 	beq		.Lxtsencout
 .Lxtsencloop:
-	ld1		{v1.16b}, [x20], #16
+	ld1		{v1.16b}, [x1], #16
 	eor		v0.16b, v1.16b, v4.16b
-	encrypt_block	v0, w22, x21, x8, w7
+	encrypt_block	v0, w3, x2, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
-	st1		{v0.16b}, [x19], #16
-	subs		w23, w23, #1
+	st1		{v0.16b}, [x0], #16
+	subs		w4, w4, #1
 	beq		.Lxtsencout
 	next_tweak	v4, v4, v7, v8
 	b		.Lxtsencloop
 .Lxtsencout:
-	st1		{v4.16b}, [x24]
-	frame_pop
+	st1		{v4.16b}, [x6]
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_xts_encrypt)
 
 
 AES_ENTRY(aes_xts_decrypt)
-	frame_push	6
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x6
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
-	ld1		{v4.16b}, [x24]
+	ld1		{v4.16b}, [x6]
 	cbz		w7, .Lxtsdecnotfirst
 
 	enc_prepare	w3, x5, x8
@@ -407,17 +346,15 @@ AES_ENTRY(aes_xts_decrypt)
 	ldr		q7, .Lxts_mul_x
 	b		.LxtsdecNx
 
-.Lxtsdecrestart:
-	ld1		{v4.16b}, [x24]
 .Lxtsdecnotfirst:
-	dec_prepare	w22, x21, x8
+	dec_prepare	w3, x2, x8
 .LxtsdecloopNx:
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
 .LxtsdecNx:
-	subs		w23, w23, #4
+	subs		w4, w4, #4
 	bmi		.Lxtsdec1x
-	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 ct blocks */
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
 	next_tweak	v5, v4, v7, v8
 	eor		v0.16b, v0.16b, v4.16b
 	next_tweak	v6, v5, v7, v8
@@ -430,28 +367,26 @@ AES_ENTRY(aes_xts_decrypt)
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x19], #64
+	st1		{v0.16b-v3.16b}, [x0], #64
 	mov		v4.16b, v7.16b
-	cbz		w23, .Lxtsdecout
-	st1		{v4.16b}, [x24]
-	cond_yield_neon	.Lxtsdecrestart
+	cbz		w4, .Lxtsdecout
 	b		.LxtsdecloopNx
 .Lxtsdec1x:
-	adds		w23, w23, #4
+	adds		w4, w4, #4
 	beq		.Lxtsdecout
 .Lxtsdecloop:
-	ld1		{v1.16b}, [x20], #16
+	ld1		{v1.16b}, [x1], #16
 	eor		v0.16b, v1.16b, v4.16b
-	decrypt_block	v0, w22, x21, x8, w7
+	decrypt_block	v0, w3, x2, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
-	st1		{v0.16b}, [x19], #16
-	subs		w23, w23, #1
+	st1		{v0.16b}, [x0], #16
+	subs		w4, w4, #1
 	beq		.Lxtsdecout
 	next_tweak	v4, v4, v7, v8
 	b		.Lxtsdecloop
 .Lxtsdecout:
-	st1		{v4.16b}, [x24]
-	frame_pop
+	st1		{v4.16b}, [x6]
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_xts_decrypt)
 
-- 
2.18.0
