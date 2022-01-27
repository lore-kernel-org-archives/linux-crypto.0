Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063A9C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 11:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240181AbiA0LgA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 06:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbiA0Lf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 06:35:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9804EC061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 03:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358C0618C8
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DC2C340EB;
        Thu, 27 Jan 2022 11:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643283358;
        bh=JMH5lmqbXtV6ViO8f1B1HQAo1tQR70C8q6O4V9BSw8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5tHUPTY6GkH3h2KZTdd5TXPXl3cjd2flwJ2eq9BCpwUNg/reHk51d4KGCW7jyHhN
         UkSIw9v/OgAZPHt/BY0bEHqnGGbgvMt8UcuV+TtFTq6FHR4EFPCrXMOvc26gy9t0R5
         HBO4586SSvV3PVk0vhd4+bzto1M65tm49r2td53Xf3pSYVq+2AaijemereVnlVNJeo
         rgB73dzWomAor6GdvSpuEh/wMYqLjVHGkltS+ziV9vYzNWq7Egy4tqzCsIfz3mEpGi
         1k4WBYx5kbydCUoMAYoGcKth6tvAByVOJBO7H8xpWmmOgNdfc4Vlhhx8cXDh0GsxDm
         bpAu8ZctHAz9Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/3] crypto: arm/aes-neonbs-ctr - deal with non-multiples of AES block size
Date:   Thu, 27 Jan 2022 12:35:43 +0100
Message-Id: <20220127113545.7821-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127113545.7821-1-ardb@kernel.org>
References: <20220127113545.7821-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7803; h=from:subject; bh=JMH5lmqbXtV6ViO8f1B1HQAo1tQR70C8q6O4V9BSw8M=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8oOPzu8TurO73nePLh6LC+T5JAhKvMZPFLHSUF6v sE39tkaJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfKDjwAKCRDDTyI5ktmPJLn2C/ 9WRbAep232a3/Q2A6QzXR6ZSVN0zEfOxzqjanbbEd4EvV4kqb5EAnRo11B/bUFxkd4desxOgxRXpPF S0rijptcb30LqFSFnZ3YGF08L3ftYNxKX5gIFlkPObdlj7cgqczSTFglYuRs/EMb5xyVi9I5PEPyby FRn4OiZTfIno00C7rENe1epzNNaxzLDounx3NIKJLI5HMsGCFCAnO3X2ICydhnt/zyljpte4vAhfby 2gWpbIdHHJK3MXj4h6TvpjEZSWVqJB4eJqCyqYO++ixXOFvhk81tMLafCks/Wd5NJI4vR13Mqdipva y5DXK9U3NxU4hHOwZ1RD1ohc+ENRhyt1v3x4lBxFK7PR+8J3Z0lf0YanmzwQkmrARAfBmVJ9Di09s7 tprPWSW2aPWi0BYLVmBSVZL6HmbPHnkJfuQAiAMtYb7OkM9/VUOyxg76BjCWPQ1aDcOIlhBAHleV7V 4zbU+sCrVEbUe1n0lBkNonpkS2sJ7XXRbMliz4HjK8rzc=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of falling back to C code to deal with the final bit of input
that is not a round multiple of the block size, handle this in the asm
code, permitting us to use overlapping loads and stores for performance,
and implement the 16-byte wide XOR using a single NEON instruction.

Since NEON loads and stores have a natural width of 16 bytes, we need to
handle inputs of less than 16 bytes in a special way, but this rarely
occurs in practice so it does not impact performance. All other input
sizes can be consumed directly by the NEON asm code, although it should
be noted that the core AES transform can still only process 128 bytes (8
AES blocks) at a time.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/aes-neonbs-core.S | 105 ++++++++++++--------
 arch/arm/crypto/aes-neonbs-glue.c |  35 +++----
 2 files changed, 77 insertions(+), 63 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-core.S b/arch/arm/crypto/aes-neonbs-core.S
index 7d0cc7f226a5..7b61032f29fa 100644
--- a/arch/arm/crypto/aes-neonbs-core.S
+++ b/arch/arm/crypto/aes-neonbs-core.S
@@ -758,29 +758,24 @@ ENTRY(aesbs_cbc_decrypt)
 ENDPROC(aesbs_cbc_decrypt)
 
 	.macro		next_ctr, q
-	vmov.32		\q\()h[1], r10
+	vmov		\q\()h, r9, r10
 	adds		r10, r10, #1
-	vmov.32		\q\()h[0], r9
 	adcs		r9, r9, #0
-	vmov.32		\q\()l[1], r8
+	vmov		\q\()l, r7, r8
 	adcs		r8, r8, #0
-	vmov.32		\q\()l[0], r7
 	adc		r7, r7, #0
 	vrev32.8	\q, \q
 	.endm
 
 	/*
 	 * aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
-	 *		     int rounds, int blocks, u8 ctr[], u8 final[])
+	 *		     int rounds, int bytes, u8 ctr[])
 	 */
 ENTRY(aesbs_ctr_encrypt)
 	mov		ip, sp
 	push		{r4-r10, lr}
 
-	ldm		ip, {r5-r7}		// load args 4-6
-	teq		r7, #0
-	addne		r5, r5, #1		// one extra block if final != 0
-
+	ldm		ip, {r5, r6}		// load args 4-5
 	vld1.8		{q0}, [r6]		// load counter
 	vrev32.8	q1, q0
 	vmov		r9, r10, d3
@@ -792,20 +787,19 @@ ENTRY(aesbs_ctr_encrypt)
 	adc		r7, r7, #0
 
 99:	vmov		q1, q0
+	sub		lr, r5, #1
 	vmov		q2, q0
+	adr		ip, 0f
 	vmov		q3, q0
+	and		lr, lr, #112
 	vmov		q4, q0
+	cmp		r5, #112
 	vmov		q5, q0
+	sub		ip, ip, lr, lsl #1
 	vmov		q6, q0
+	add		ip, ip, lr, lsr #2
 	vmov		q7, q0
-
-	adr		ip, 0f
-	sub		lr, r5, #1
-	and		lr, lr, #7
-	cmp		r5, #8
-	sub		ip, ip, lr, lsl #5
-	sub		ip, ip, lr, lsl #2
-	movlt		pc, ip			// computed goto if blocks < 8
+	movle		pc, ip			// computed goto if bytes < 112
 
 	next_ctr	q1
 	next_ctr	q2
@@ -820,12 +814,14 @@ ENTRY(aesbs_ctr_encrypt)
 	bl		aesbs_encrypt8
 
 	adr		ip, 1f
-	and		lr, r5, #7
-	cmp		r5, #8
-	movgt		r4, #0
-	ldrle		r4, [sp, #40]		// load final in the last round
-	sub		ip, ip, lr, lsl #2
-	movlt		pc, ip			// computed goto if blocks < 8
+	sub		lr, r5, #1
+	cmp		r5, #128
+	bic		lr, lr, #15
+	ands		r4, r5, #15		// preserves C flag
+	teqcs		r5, r5			// set Z flag if not last iteration
+	sub		ip, ip, lr, lsr #2
+	rsb		r4, r4, #16
+	movcc		pc, ip			// computed goto if bytes < 128
 
 	vld1.8		{q8}, [r1]!
 	vld1.8		{q9}, [r1]!
@@ -834,46 +830,70 @@ ENTRY(aesbs_ctr_encrypt)
 	vld1.8		{q12}, [r1]!
 	vld1.8		{q13}, [r1]!
 	vld1.8		{q14}, [r1]!
-	teq		r4, #0			// skip last block if 'final'
-1:	bne		2f
+1:	subne		r1, r1, r4
 	vld1.8		{q15}, [r1]!
 
-2:	adr		ip, 3f
-	cmp		r5, #8
-	sub		ip, ip, lr, lsl #3
-	movlt		pc, ip			// computed goto if blocks < 8
+	add		ip, ip, #2f - 1b
 
 	veor		q0, q0, q8
-	vst1.8		{q0}, [r0]!
 	veor		q1, q1, q9
-	vst1.8		{q1}, [r0]!
 	veor		q4, q4, q10
-	vst1.8		{q4}, [r0]!
 	veor		q6, q6, q11
-	vst1.8		{q6}, [r0]!
 	veor		q3, q3, q12
-	vst1.8		{q3}, [r0]!
 	veor		q7, q7, q13
-	vst1.8		{q7}, [r0]!
 	veor		q2, q2, q14
+	bne		3f
+	veor		q5, q5, q15
+
+	movcc		pc, ip			// computed goto if bytes < 128
+
+	vst1.8		{q0}, [r0]!
+	vst1.8		{q1}, [r0]!
+	vst1.8		{q4}, [r0]!
+	vst1.8		{q6}, [r0]!
+	vst1.8		{q3}, [r0]!
+	vst1.8		{q7}, [r0]!
 	vst1.8		{q2}, [r0]!
-	teq		r4, #0			// skip last block if 'final'
-	W(bne)		5f
-3:	veor		q5, q5, q15
+2:	subne		r0, r0, r4
 	vst1.8		{q5}, [r0]!
 
-4:	next_ctr	q0
+	next_ctr	q0
 
-	subs		r5, r5, #8
+	subs		r5, r5, #128
 	bgt		99b
 
 	vst1.8		{q0}, [r6]
 	pop		{r4-r10, pc}
 
-5:	vst1.8		{q5}, [r4]
-	b		4b
+3:	adr		lr, .Lpermute_table + 16
+	cmp		r5, #16			// Z flag remains cleared
+	sub		lr, lr, r4
+	vld1.8		{q8-q9}, [lr]
+	vtbl.8		d16, {q5}, d16
+	vtbl.8		d17, {q5}, d17
+	veor		q5, q8, q15
+	bcc		4f			// have to reload prev if R5 < 16
+	vtbx.8		d10, {q2}, d18
+	vtbx.8		d11, {q2}, d19
+	mov		pc, ip			// branch back to VST sequence
+
+4:	sub		r0, r0, r4
+	vshr.s8		q9, q9, #7		// create mask for VBIF
+	vld1.8		{q8}, [r0]		// reload
+	vbif		q5, q8, q9
+	vst1.8		{q5}, [r0]
+	pop		{r4-r10, pc}
 ENDPROC(aesbs_ctr_encrypt)
 
+	.align		6
+.Lpermute_table:
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
+	.byte		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+
 	.macro		next_tweak, out, in, const, tmp
 	vshr.s64	\tmp, \in, #63
 	vand		\tmp, \tmp, \const
@@ -888,6 +908,7 @@ ENDPROC(aesbs_ctr_encrypt)
 	 * aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		     int blocks, u8 iv[], int reorder_last_tweak)
 	 */
+	.align		6
 __xts_prepare8:
 	vld1.8		{q14}, [r7]		// load iv
 	vmov.i32	d30, #0x87		// compose tweak mask vector
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 5c6cd3c63cbc..f00f042ef357 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -37,7 +37,7 @@ asmlinkage void aesbs_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]);
 
 asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
-				  int rounds, int blocks, u8 ctr[], u8 final[]);
+				  int rounds, int blocks, u8 ctr[]);
 
 asmlinkage void aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[], int);
@@ -243,32 +243,25 @@ static int ctr_encrypt(struct skcipher_request *req)
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes > 0) {
-		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
-		u8 *final = (walk.total % AES_BLOCK_SIZE) ? buf : NULL;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		int bytes = walk.nbytes;
 
-		if (walk.nbytes < walk.total) {
-			blocks = round_down(blocks,
-					    walk.stride / AES_BLOCK_SIZE);
-			final = NULL;
-		}
+		if (unlikely(bytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(buf + sizeof(buf) - bytes,
+					   src, bytes);
+		else if (walk.nbytes < walk.total)
+			bytes &= ~(8 * AES_BLOCK_SIZE - 1);
 
 		kernel_neon_begin();
-		aesbs_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				  ctx->rk, ctx->rounds, blocks, walk.iv, final);
+		aesbs_ctr_encrypt(dst, src, ctx->rk, ctx->rounds, bytes, walk.iv);
 		kernel_neon_end();
 
-		if (final) {
-			u8 *dst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
-			u8 *src = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
+		if (unlikely(bytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr,
+			       buf + sizeof(buf) - bytes, bytes);
 
-			crypto_xor_cpy(dst, src, final,
-				       walk.total % AES_BLOCK_SIZE);
-
-			err = skcipher_walk_done(&walk, 0);
-			break;
-		}
-		err = skcipher_walk_done(&walk,
-					 walk.nbytes - blocks * AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - bytes);
 	}
 
 	return err;
-- 
2.30.2

