From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 03/10] crypto: arm64/aes-ccm - yield NEON after every
 block of input
Date: Mon, 30 Apr 2018 18:18:23 +0200
Message-ID: <20180430161830.14892-4-ard.biesheuvel@linaro.org>
References: <20180430161830.14892-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: will.deacon@arm.com, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180430161830.14892-1-ard.biesheuvel@linaro.org>
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

Avoid excessive scheduling delays under a preemptible kernel by
yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 150 +++++++++++++-------
 1 file changed, 95 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index e3a375c4cb83..88f5aef7934c 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -19,24 +19,33 @@
 	 *			     u32 *macp, u8 const rk[], u32 rounds);
 	 */
 ENTRY(ce_aes_ccm_auth_data)
-	ldr	w8, [x3]			/* leftover from prev round? */
+	frame_push	7
+
+	mov	x19, x0
+	mov	x20, x1
+	mov	x21, x2
+	mov	x22, x3
+	mov	x23, x4
+	mov	x24, x5
+
+	ldr	w25, [x22]			/* leftover from prev round? */
 	ld1	{v0.16b}, [x0]			/* load mac */
-	cbz	w8, 1f
-	sub	w8, w8, #16
+	cbz	w25, 1f
+	sub	w25, w25, #16
 	eor	v1.16b, v1.16b, v1.16b
-0:	ldrb	w7, [x1], #1			/* get 1 byte of input */
-	subs	w2, w2, #1
-	add	w8, w8, #1
+0:	ldrb	w7, [x20], #1			/* get 1 byte of input */
+	subs	w21, w21, #1
+	add	w25, w25, #1
 	ins	v1.b[0], w7
 	ext	v1.16b, v1.16b, v1.16b, #1	/* rotate in the input bytes */
 	beq	8f				/* out of input? */
-	cbnz	w8, 0b
+	cbnz	w25, 0b
 	eor	v0.16b, v0.16b, v1.16b
-1:	ld1	{v3.4s}, [x4]			/* load first round key */
-	prfm	pldl1strm, [x1]
-	cmp	w5, #12				/* which key size? */
-	add	x6, x4, #16
-	sub	w7, w5, #2			/* modified # of rounds */
+1:	ld1	{v3.4s}, [x23]			/* load first round key */
+	prfm	pldl1strm, [x20]
+	cmp	w24, #12			/* which key size? */
+	add	x6, x23, #16
+	sub	w7, w24, #2			/* modified # of rounds */
 	bmi	2f
 	bne	5f
 	mov	v5.16b, v3.16b
@@ -55,33 +64,43 @@ ENTRY(ce_aes_ccm_auth_data)
 	ld1	{v5.4s}, [x6], #16		/* load next round key */
 	bpl	3b
 	aese	v0.16b, v4.16b
-	subs	w2, w2, #16			/* last data? */
+	subs	w21, w21, #16			/* last data? */
 	eor	v0.16b, v0.16b, v5.16b		/* final round */
 	bmi	6f
-	ld1	{v1.16b}, [x1], #16		/* load next input block */
+	ld1	{v1.16b}, [x20], #16		/* load next input block */
 	eor	v0.16b, v0.16b, v1.16b		/* xor with mac */
-	bne	1b
-6:	st1	{v0.16b}, [x0]			/* store mac */
+	beq	6f
+
+	if_will_cond_yield_neon
+	st1	{v0.16b}, [x19]			/* store mac */
+	do_cond_yield_neon
+	ld1	{v0.16b}, [x19]			/* reload mac */
+	endif_yield_neon
+
+	b	1b
+6:	st1	{v0.16b}, [x19]			/* store mac */
 	beq	10f
-	adds	w2, w2, #16
+	adds	w21, w21, #16
 	beq	10f
-	mov	w8, w2
-7:	ldrb	w7, [x1], #1
+	mov	w25, w21
+7:	ldrb	w7, [x20], #1
 	umov	w6, v0.b[0]
 	eor	w6, w6, w7
-	strb	w6, [x0], #1
-	subs	w2, w2, #1
+	strb	w6, [x19], #1
+	subs	w21, w21, #1
 	beq	10f
 	ext	v0.16b, v0.16b, v0.16b, #1	/* rotate out the mac bytes */
 	b	7b
-8:	mov	w7, w8
-	add	w8, w8, #16
+8:	mov	w7, w25
+	add	w25, w25, #16
 9:	ext	v1.16b, v1.16b, v1.16b, #1
 	adds	w7, w7, #1
 	bne	9b
 	eor	v0.16b, v0.16b, v1.16b
-	st1	{v0.16b}, [x0]
-10:	str	w8, [x3]
+	st1	{v0.16b}, [x19]
+10:	str	w25, [x22]
+
+	frame_pop
 	ret
 ENDPROC(ce_aes_ccm_auth_data)
 
@@ -126,19 +145,29 @@ ENTRY(ce_aes_ccm_final)
 ENDPROC(ce_aes_ccm_final)
 
 	.macro	aes_ccm_do_crypt,enc
-	ldr	x8, [x6, #8]			/* load lower ctr */
-	ld1	{v0.16b}, [x5]			/* load mac */
-CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
+	frame_push	8
+
+	mov	x19, x0
+	mov	x20, x1
+	mov	x21, x2
+	mov	x22, x3
+	mov	x23, x4
+	mov	x24, x5
+	mov	x25, x6
+
+	ldr	x26, [x25, #8]			/* load lower ctr */
+	ld1	{v0.16b}, [x24]			/* load mac */
+CPU_LE(	rev	x26, x26		)	/* keep swabbed ctr in reg */
 0:	/* outer loop */
-	ld1	{v1.8b}, [x6]			/* load upper ctr */
-	prfm	pldl1strm, [x1]
-	add	x8, x8, #1
-	rev	x9, x8
-	cmp	w4, #12				/* which key size? */
-	sub	w7, w4, #2			/* get modified # of rounds */
+	ld1	{v1.8b}, [x25]			/* load upper ctr */
+	prfm	pldl1strm, [x20]
+	add	x26, x26, #1
+	rev	x9, x26
+	cmp	w23, #12			/* which key size? */
+	sub	w7, w23, #2			/* get modified # of rounds */
 	ins	v1.d[1], x9			/* no carry in lower ctr */
-	ld1	{v3.4s}, [x3]			/* load first round key */
-	add	x10, x3, #16
+	ld1	{v3.4s}, [x22]			/* load first round key */
+	add	x10, x22, #16
 	bmi	1f
 	bne	4f
 	mov	v5.16b, v3.16b
@@ -165,9 +194,9 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 	bpl	2b
 	aese	v0.16b, v4.16b
 	aese	v1.16b, v4.16b
-	subs	w2, w2, #16
-	bmi	6f				/* partial block? */
-	ld1	{v2.16b}, [x1], #16		/* load next input block */
+	subs	w21, w21, #16
+	bmi	7f				/* partial block? */
+	ld1	{v2.16b}, [x20], #16		/* load next input block */
 	.if	\enc == 1
 	eor	v2.16b, v2.16b, v5.16b		/* final round enc+mac */
 	eor	v1.16b, v1.16b, v2.16b		/* xor with crypted ctr */
@@ -176,18 +205,29 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 	eor	v1.16b, v2.16b, v5.16b		/* final round enc */
 	.endif
 	eor	v0.16b, v0.16b, v2.16b		/* xor mac with pt ^ rk[last] */
-	st1	{v1.16b}, [x0], #16		/* write output block */
-	bne	0b
-CPU_LE(	rev	x8, x8			)
-	st1	{v0.16b}, [x5]			/* store mac */
-	str	x8, [x6, #8]			/* store lsb end of ctr (BE) */
-5:	ret
-
-6:	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
+	st1	{v1.16b}, [x19], #16		/* write output block */
+	beq	5f
+
+	if_will_cond_yield_neon
+	st1	{v0.16b}, [x24]			/* store mac */
+	do_cond_yield_neon
+	ld1	{v0.16b}, [x24]			/* reload mac */
+	endif_yield_neon
+
+	b	0b
+5:
+CPU_LE(	rev	x26, x26			)
+	st1	{v0.16b}, [x24]			/* store mac */
+	str	x26, [x25, #8]			/* store lsb end of ctr (BE) */
+
+6:	frame_pop
+	ret
+
+7:	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
 	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
-	st1	{v0.16b}, [x5]			/* store mac */
-	add	w2, w2, #16			/* process partial tail block */
-7:	ldrb	w9, [x1], #1			/* get 1 byte of input */
+	st1	{v0.16b}, [x24]			/* store mac */
+	add	w21, w21, #16			/* process partial tail block */
+8:	ldrb	w9, [x20], #1			/* get 1 byte of input */
 	umov	w6, v1.b[0]			/* get top crypted ctr byte */
 	umov	w7, v0.b[0]			/* get top mac byte */
 	.if	\enc == 1
@@ -197,13 +237,13 @@ CPU_LE(	rev	x8, x8			)
 	eor	w9, w9, w6
 	eor	w7, w7, w9
 	.endif
-	strb	w9, [x0], #1			/* store out byte */
-	strb	w7, [x5], #1			/* store mac byte */
-	subs	w2, w2, #1
-	beq	5b
+	strb	w9, [x19], #1			/* store out byte */
+	strb	w7, [x24], #1			/* store mac byte */
+	subs	w21, w21, #1
+	beq	6b
 	ext	v0.16b, v0.16b, v0.16b, #1	/* shift out mac byte */
 	ext	v1.16b, v1.16b, v1.16b, #1	/* shift out ctr byte */
-	b	7b
+	b	8b
 	.endm
 
 	/*
-- 
2.17.0
