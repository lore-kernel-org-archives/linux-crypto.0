From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 05/10] crypto: arm64/aes-bs - yield NEON after every
 block of input
Date: Mon, 30 Apr 2018 18:18:25 +0200
Message-ID: <20180430161830.14892-6-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/aes-neonbs-core.S | 305 +++++++++++---------
 1 file changed, 170 insertions(+), 135 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index ca0472500433..e613a87f8b53 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -565,54 +565,61 @@ ENDPROC(aesbs_decrypt8)
 	 *		     int blocks)
 	 */
 	.macro		__ecb_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	5
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
 
 99:	mov		x5, #1
-	lsl		x5, x5, x4
-	subs		w4, w4, #8
-	csel		x4, x4, xzr, pl
+	lsl		x5, x5, x23
+	subs		w23, w23, #8
+	csel		x23, x23, xzr, pl
 	csel		x5, x5, xzr, mi
 
-	ld1		{v0.16b}, [x1], #16
+	ld1		{v0.16b}, [x20], #16
 	tbnz		x5, #1, 0f
-	ld1		{v1.16b}, [x1], #16
+	ld1		{v1.16b}, [x20], #16
 	tbnz		x5, #2, 0f
-	ld1		{v2.16b}, [x1], #16
+	ld1		{v2.16b}, [x20], #16
 	tbnz		x5, #3, 0f
-	ld1		{v3.16b}, [x1], #16
+	ld1		{v3.16b}, [x20], #16
 	tbnz		x5, #4, 0f
-	ld1		{v4.16b}, [x1], #16
+	ld1		{v4.16b}, [x20], #16
 	tbnz		x5, #5, 0f
-	ld1		{v5.16b}, [x1], #16
+	ld1		{v5.16b}, [x20], #16
 	tbnz		x5, #6, 0f
-	ld1		{v6.16b}, [x1], #16
+	ld1		{v6.16b}, [x20], #16
 	tbnz		x5, #7, 0f
-	ld1		{v7.16b}, [x1], #16
+	ld1		{v7.16b}, [x20], #16
 
-0:	mov		bskey, x2
-	mov		rounds, x3
+0:	mov		bskey, x21
+	mov		rounds, x22
 	bl		\do8
 
-	st1		{\o0\().16b}, [x0], #16
+	st1		{\o0\().16b}, [x19], #16
 	tbnz		x5, #1, 1f
-	st1		{\o1\().16b}, [x0], #16
+	st1		{\o1\().16b}, [x19], #16
 	tbnz		x5, #2, 1f
-	st1		{\o2\().16b}, [x0], #16
+	st1		{\o2\().16b}, [x19], #16
 	tbnz		x5, #3, 1f
-	st1		{\o3\().16b}, [x0], #16
+	st1		{\o3\().16b}, [x19], #16
 	tbnz		x5, #4, 1f
-	st1		{\o4\().16b}, [x0], #16
+	st1		{\o4\().16b}, [x19], #16
 	tbnz		x5, #5, 1f
-	st1		{\o5\().16b}, [x0], #16
+	st1		{\o5\().16b}, [x19], #16
 	tbnz		x5, #6, 1f
-	st1		{\o6\().16b}, [x0], #16
+	st1		{\o6\().16b}, [x19], #16
 	tbnz		x5, #7, 1f
-	st1		{\o7\().16b}, [x0], #16
+	st1		{\o7\().16b}, [x19], #16
 
-	cbnz		x4, 99b
+	cbz		x23, 1f
+	cond_yield_neon
+	b		99b
 
-1:	ldp		x29, x30, [sp], #16
+1:	frame_pop
 	ret
 	.endm
 
@@ -632,43 +639,49 @@ ENDPROC(aesbs_ecb_decrypt)
 	 */
 	.align		4
 ENTRY(aesbs_cbc_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	6
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
 
 99:	mov		x6, #1
-	lsl		x6, x6, x4
-	subs		w4, w4, #8
-	csel		x4, x4, xzr, pl
+	lsl		x6, x6, x23
+	subs		w23, w23, #8
+	csel		x23, x23, xzr, pl
 	csel		x6, x6, xzr, mi
 
-	ld1		{v0.16b}, [x1], #16
+	ld1		{v0.16b}, [x20], #16
 	mov		v25.16b, v0.16b
 	tbnz		x6, #1, 0f
-	ld1		{v1.16b}, [x1], #16
+	ld1		{v1.16b}, [x20], #16
 	mov		v26.16b, v1.16b
 	tbnz		x6, #2, 0f
-	ld1		{v2.16b}, [x1], #16
+	ld1		{v2.16b}, [x20], #16
 	mov		v27.16b, v2.16b
 	tbnz		x6, #3, 0f
-	ld1		{v3.16b}, [x1], #16
+	ld1		{v3.16b}, [x20], #16
 	mov		v28.16b, v3.16b
 	tbnz		x6, #4, 0f
-	ld1		{v4.16b}, [x1], #16
+	ld1		{v4.16b}, [x20], #16
 	mov		v29.16b, v4.16b
 	tbnz		x6, #5, 0f
-	ld1		{v5.16b}, [x1], #16
+	ld1		{v5.16b}, [x20], #16
 	mov		v30.16b, v5.16b
 	tbnz		x6, #6, 0f
-	ld1		{v6.16b}, [x1], #16
+	ld1		{v6.16b}, [x20], #16
 	mov		v31.16b, v6.16b
 	tbnz		x6, #7, 0f
-	ld1		{v7.16b}, [x1]
+	ld1		{v7.16b}, [x20]
 
-0:	mov		bskey, x2
-	mov		rounds, x3
+0:	mov		bskey, x21
+	mov		rounds, x22
 	bl		aesbs_decrypt8
 
-	ld1		{v24.16b}, [x5]			// load IV
+	ld1		{v24.16b}, [x24]		// load IV
 
 	eor		v1.16b, v1.16b, v25.16b
 	eor		v6.16b, v6.16b, v26.16b
@@ -679,34 +692,36 @@ ENTRY(aesbs_cbc_decrypt)
 	eor		v3.16b, v3.16b, v30.16b
 	eor		v5.16b, v5.16b, v31.16b
 
-	st1		{v0.16b}, [x0], #16
+	st1		{v0.16b}, [x19], #16
 	mov		v24.16b, v25.16b
 	tbnz		x6, #1, 1f
-	st1		{v1.16b}, [x0], #16
+	st1		{v1.16b}, [x19], #16
 	mov		v24.16b, v26.16b
 	tbnz		x6, #2, 1f
-	st1		{v6.16b}, [x0], #16
+	st1		{v6.16b}, [x19], #16
 	mov		v24.16b, v27.16b
 	tbnz		x6, #3, 1f
-	st1		{v4.16b}, [x0], #16
+	st1		{v4.16b}, [x19], #16
 	mov		v24.16b, v28.16b
 	tbnz		x6, #4, 1f
-	st1		{v2.16b}, [x0], #16
+	st1		{v2.16b}, [x19], #16
 	mov		v24.16b, v29.16b
 	tbnz		x6, #5, 1f
-	st1		{v7.16b}, [x0], #16
+	st1		{v7.16b}, [x19], #16
 	mov		v24.16b, v30.16b
 	tbnz		x6, #6, 1f
-	st1		{v3.16b}, [x0], #16
+	st1		{v3.16b}, [x19], #16
 	mov		v24.16b, v31.16b
 	tbnz		x6, #7, 1f
-	ld1		{v24.16b}, [x1], #16
-	st1		{v5.16b}, [x0], #16
-1:	st1		{v24.16b}, [x5]			// store IV
+	ld1		{v24.16b}, [x20], #16
+	st1		{v5.16b}, [x19], #16
+1:	st1		{v24.16b}, [x24]		// store IV
 
-	cbnz		x4, 99b
+	cbz		x23, 2f
+	cond_yield_neon
+	b		99b
 
-	ldp		x29, x30, [sp], #16
+2:	frame_pop
 	ret
 ENDPROC(aesbs_cbc_decrypt)
 
@@ -731,87 +746,93 @@ CPU_BE(	.quad		0x87, 1		)
 	 */
 __xts_crypt8:
 	mov		x6, #1
-	lsl		x6, x6, x4
-	subs		w4, w4, #8
-	csel		x4, x4, xzr, pl
+	lsl		x6, x6, x23
+	subs		w23, w23, #8
+	csel		x23, x23, xzr, pl
 	csel		x6, x6, xzr, mi
 
-	ld1		{v0.16b}, [x1], #16
+	ld1		{v0.16b}, [x20], #16
 	next_tweak	v26, v25, v30, v31
 	eor		v0.16b, v0.16b, v25.16b
 	tbnz		x6, #1, 0f
 
-	ld1		{v1.16b}, [x1], #16
+	ld1		{v1.16b}, [x20], #16
 	next_tweak	v27, v26, v30, v31
 	eor		v1.16b, v1.16b, v26.16b
 	tbnz		x6, #2, 0f
 
-	ld1		{v2.16b}, [x1], #16
+	ld1		{v2.16b}, [x20], #16
 	next_tweak	v28, v27, v30, v31
 	eor		v2.16b, v2.16b, v27.16b
 	tbnz		x6, #3, 0f
 
-	ld1		{v3.16b}, [x1], #16
+	ld1		{v3.16b}, [x20], #16
 	next_tweak	v29, v28, v30, v31
 	eor		v3.16b, v3.16b, v28.16b
 	tbnz		x6, #4, 0f
 
-	ld1		{v4.16b}, [x1], #16
-	str		q29, [sp, #16]
+	ld1		{v4.16b}, [x20], #16
+	str		q29, [sp, #.Lframe_local_offset]
 	eor		v4.16b, v4.16b, v29.16b
 	next_tweak	v29, v29, v30, v31
 	tbnz		x6, #5, 0f
 
-	ld1		{v5.16b}, [x1], #16
-	str		q29, [sp, #32]
+	ld1		{v5.16b}, [x20], #16
+	str		q29, [sp, #.Lframe_local_offset + 16]
 	eor		v5.16b, v5.16b, v29.16b
 	next_tweak	v29, v29, v30, v31
 	tbnz		x6, #6, 0f
 
-	ld1		{v6.16b}, [x1], #16
-	str		q29, [sp, #48]
+	ld1		{v6.16b}, [x20], #16
+	str		q29, [sp, #.Lframe_local_offset + 32]
 	eor		v6.16b, v6.16b, v29.16b
 	next_tweak	v29, v29, v30, v31
 	tbnz		x6, #7, 0f
 
-	ld1		{v7.16b}, [x1], #16
-	str		q29, [sp, #64]
+	ld1		{v7.16b}, [x20], #16
+	str		q29, [sp, #.Lframe_local_offset + 48]
 	eor		v7.16b, v7.16b, v29.16b
 	next_tweak	v29, v29, v30, v31
 
-0:	mov		bskey, x2
-	mov		rounds, x3
+0:	mov		bskey, x21
+	mov		rounds, x22
 	br		x7
 ENDPROC(__xts_crypt8)
 
 	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
-	stp		x29, x30, [sp, #-80]!
-	mov		x29, sp
+	frame_push	6, 64
 
-	ldr		q30, .Lxts_mul_x
-	ld1		{v25.16b}, [x5]
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+
+0:	ldr		q30, .Lxts_mul_x
+	ld1		{v25.16b}, [x24]
 
 99:	adr		x7, \do8
 	bl		__xts_crypt8
 
-	ldp		q16, q17, [sp, #16]
-	ldp		q18, q19, [sp, #48]
+	ldp		q16, q17, [sp, #.Lframe_local_offset]
+	ldp		q18, q19, [sp, #.Lframe_local_offset + 32]
 
 	eor		\o0\().16b, \o0\().16b, v25.16b
 	eor		\o1\().16b, \o1\().16b, v26.16b
 	eor		\o2\().16b, \o2\().16b, v27.16b
 	eor		\o3\().16b, \o3\().16b, v28.16b
 
-	st1		{\o0\().16b}, [x0], #16
+	st1		{\o0\().16b}, [x19], #16
 	mov		v25.16b, v26.16b
 	tbnz		x6, #1, 1f
-	st1		{\o1\().16b}, [x0], #16
+	st1		{\o1\().16b}, [x19], #16
 	mov		v25.16b, v27.16b
 	tbnz		x6, #2, 1f
-	st1		{\o2\().16b}, [x0], #16
+	st1		{\o2\().16b}, [x19], #16
 	mov		v25.16b, v28.16b
 	tbnz		x6, #3, 1f
-	st1		{\o3\().16b}, [x0], #16
+	st1		{\o3\().16b}, [x19], #16
 	mov		v25.16b, v29.16b
 	tbnz		x6, #4, 1f
 
@@ -820,18 +841,22 @@ ENDPROC(__xts_crypt8)
 	eor		\o6\().16b, \o6\().16b, v18.16b
 	eor		\o7\().16b, \o7\().16b, v19.16b
 
-	st1		{\o4\().16b}, [x0], #16
+	st1		{\o4\().16b}, [x19], #16
 	tbnz		x6, #5, 1f
-	st1		{\o5\().16b}, [x0], #16
+	st1		{\o5\().16b}, [x19], #16
 	tbnz		x6, #6, 1f
-	st1		{\o6\().16b}, [x0], #16
+	st1		{\o6\().16b}, [x19], #16
 	tbnz		x6, #7, 1f
-	st1		{\o7\().16b}, [x0], #16
+	st1		{\o7\().16b}, [x19], #16
+
+	cbz		x23, 1f
+	st1		{v25.16b}, [x24]
 
-	cbnz		x4, 99b
+	cond_yield_neon	0b
+	b		99b
 
-1:	st1		{v25.16b}, [x5]
-	ldp		x29, x30, [sp], #80
+1:	st1		{v25.16b}, [x24]
+	frame_pop
 	ret
 	.endm
 
@@ -856,24 +881,31 @@ ENDPROC(aesbs_xts_decrypt)
 	 *		     int rounds, int blocks, u8 iv[], u8 final[])
 	 */
 ENTRY(aesbs_ctr_encrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
-
-	cmp		x6, #0
-	cset		x10, ne
-	add		x4, x4, x10		// do one extra block if final
-
-	ldp		x7, x8, [x5]
-	ld1		{v0.16b}, [x5]
+	frame_push	8
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+	mov		x25, x6
+
+	cmp		x25, #0
+	cset		x26, ne
+	add		x23, x23, x26		// do one extra block if final
+
+98:	ldp		x7, x8, [x24]
+	ld1		{v0.16b}, [x24]
 CPU_LE(	rev		x7, x7		)
 CPU_LE(	rev		x8, x8		)
 	adds		x8, x8, #1
 	adc		x7, x7, xzr
 
 99:	mov		x9, #1
-	lsl		x9, x9, x4
-	subs		w4, w4, #8
-	csel		x4, x4, xzr, pl
+	lsl		x9, x9, x23
+	subs		w23, w23, #8
+	csel		x23, x23, xzr, pl
 	csel		x9, x9, xzr, le
 
 	tbnz		x9, #1, 0f
@@ -891,82 +923,85 @@ CPU_LE(	rev		x8, x8		)
 	tbnz		x9, #7, 0f
 	next_ctr	v7
 
-0:	mov		bskey, x2
-	mov		rounds, x3
+0:	mov		bskey, x21
+	mov		rounds, x22
 	bl		aesbs_encrypt8
 
-	lsr		x9, x9, x10		// disregard the extra block
+	lsr		x9, x9, x26		// disregard the extra block
 	tbnz		x9, #0, 0f
 
-	ld1		{v8.16b}, [x1], #16
+	ld1		{v8.16b}, [x20], #16
 	eor		v0.16b, v0.16b, v8.16b
-	st1		{v0.16b}, [x0], #16
+	st1		{v0.16b}, [x19], #16
 	tbnz		x9, #1, 1f
 
-	ld1		{v9.16b}, [x1], #16
+	ld1		{v9.16b}, [x20], #16
 	eor		v1.16b, v1.16b, v9.16b
-	st1		{v1.16b}, [x0], #16
+	st1		{v1.16b}, [x19], #16
 	tbnz		x9, #2, 2f
 
-	ld1		{v10.16b}, [x1], #16
+	ld1		{v10.16b}, [x20], #16
 	eor		v4.16b, v4.16b, v10.16b
-	st1		{v4.16b}, [x0], #16
+	st1		{v4.16b}, [x19], #16
 	tbnz		x9, #3, 3f
 
-	ld1		{v11.16b}, [x1], #16
+	ld1		{v11.16b}, [x20], #16
 	eor		v6.16b, v6.16b, v11.16b
-	st1		{v6.16b}, [x0], #16
+	st1		{v6.16b}, [x19], #16
 	tbnz		x9, #4, 4f
 
-	ld1		{v12.16b}, [x1], #16
+	ld1		{v12.16b}, [x20], #16
 	eor		v3.16b, v3.16b, v12.16b
-	st1		{v3.16b}, [x0], #16
+	st1		{v3.16b}, [x19], #16
 	tbnz		x9, #5, 5f
 
-	ld1		{v13.16b}, [x1], #16
+	ld1		{v13.16b}, [x20], #16
 	eor		v7.16b, v7.16b, v13.16b
-	st1		{v7.16b}, [x0], #16
+	st1		{v7.16b}, [x19], #16
 	tbnz		x9, #6, 6f
 
-	ld1		{v14.16b}, [x1], #16
+	ld1		{v14.16b}, [x20], #16
 	eor		v2.16b, v2.16b, v14.16b
-	st1		{v2.16b}, [x0], #16
+	st1		{v2.16b}, [x19], #16
 	tbnz		x9, #7, 7f
 
-	ld1		{v15.16b}, [x1], #16
+	ld1		{v15.16b}, [x20], #16
 	eor		v5.16b, v5.16b, v15.16b
-	st1		{v5.16b}, [x0], #16
+	st1		{v5.16b}, [x19], #16
 
 8:	next_ctr	v0
-	cbnz		x4, 99b
+	st1		{v0.16b}, [x24]
+	cbz		x23, 0f
+
+	cond_yield_neon	98b
+	b		99b
 
-0:	st1		{v0.16b}, [x5]
-	ldp		x29, x30, [sp], #16
+0:	frame_pop
 	ret
 
 	/*
 	 * If we are handling the tail of the input (x6 != NULL), return the
 	 * final keystream block back to the caller.
 	 */
-1:	cbz		x6, 8b
-	st1		{v1.16b}, [x6]
+1:	cbz		x25, 8b
+	st1		{v1.16b}, [x25]
 	b		8b
-2:	cbz		x6, 8b
-	st1		{v4.16b}, [x6]
+2:	cbz		x25, 8b
+	st1		{v4.16b}, [x25]
 	b		8b
-3:	cbz		x6, 8b
-	st1		{v6.16b}, [x6]
+3:	cbz		x25, 8b
+	st1		{v6.16b}, [x25]
 	b		8b
-4:	cbz		x6, 8b
-	st1		{v3.16b}, [x6]
+4:	cbz		x25, 8b
+	st1		{v3.16b}, [x25]
 	b		8b
-5:	cbz		x6, 8b
-	st1		{v7.16b}, [x6]
+5:	cbz		x25, 8b
+	st1		{v7.16b}, [x25]
 	b		8b
-6:	cbz		x6, 8b
-	st1		{v2.16b}, [x6]
+6:	cbz		x25, 8b
+	st1		{v2.16b}, [x25]
 	b		8b
-7:	cbz		x6, 8b
-	st1		{v5.16b}, [x6]
+7:	cbz		x25, 8b
+	st1		{v5.16b}, [x25]
 	b		8b
 ENDPROC(aesbs_ctr_encrypt)
-- 
2.17.0
