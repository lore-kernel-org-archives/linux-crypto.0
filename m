Return-Path: <SRS0=Q/Sy=EH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00619C4741F
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Nov 2020 16:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9F4A22253
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Nov 2020 16:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604248441;
	bh=6O8meGMlCaIXh+hg/xnu2ALO/nxguNxcUS3HY4x/w0g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=yh400Tukba9tVyEwShmu7rQB5zIoFE4PZT8Rz83mUGg6sFko7V6h+4nklONDX9k3c
	 KVCjLpRL4RG+nPAvLDgeoNGXegdge282PvegSFSBC1uX4rSUWhej0TJxgDfCZ25gHr
	 jzH+wbySCBWZun9wvfmi8N8GYFa6PzDEHd/LMcgo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgKAQeA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Nov 2020 11:34:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgKAQd7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Nov 2020 11:33:59 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D4312084C;
        Sun,  1 Nov 2020 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604248438;
        bh=6O8meGMlCaIXh+hg/xnu2ALO/nxguNxcUS3HY4x/w0g=;
        h=From:To:Cc:Subject:Date:From;
        b=NF6EYwbjh0RC4CEYhAhYlfjw7rQlNC6MUm9X8yix7cya/f38LOmaZa3T5dxpvwLdy
         blIiOcWvgsXdEqrbxYkKW374dpEdFFif39D5DMyHbq2PTSHFWPaZxrDRja30KTWhUY
         7mNqx+qZqAXStPheGef9yxp7ZpOXxChfdo2vzdq8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] crypto: arm/chacha-neon - optimize for non-block size multiples
Date:   Sun,  1 Nov 2020 17:33:52 +0100
Message-Id: <20201101163352.6395-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current NEON based ChaCha implementation for ARM is optimized for
multiples of 4x the ChaCha block size (64 bytes). This makes sense for
block encryption, but given that ChaCha is also often used in the
context of networking, it makes sense to consider arbitrary length
inputs as well.

For example, WireGuard typically uses 1420 byte packets, and performing
ChaCha encryption involves 5 invocations of chacha_4block_xor_neon()
and 3 invocations of chacha_block_xor_neon(), where the last one also
involves a memcpy() using a buffer on the stack to process the final
chunk of 1420 % 64 == 12 bytes.

Let's optimize for this case as well, by letting chacha_4block_xor_neon()
deal with any input size between 64 and 256 bytes, using NEON permutation
instructions and overlapping loads and stores. This way, the 140 byte
tail of a 1420 byte input buffer can simply be processed in one go.

On out-of-order microarchitectures such as Cortex-A57, this results in
a speedup for 1420 byte blocks of about 21%, without any signficant
performance impact of the power-of-2 block sizes. On lower end cores
such as Cortex-A53, the speedup for 1420 byte blocks is only about 2%,
but also without impacting other input sizes.

Cc: Eric Biggers <ebiggers@google.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/chacha-glue.c      |  23 ++--
 arch/arm/crypto/chacha-neon-core.S | 124 +++++++++++++++++---
 2 files changed, 116 insertions(+), 31 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 59da6c0b63b6..9924143f63d7 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -23,7 +23,7 @@
 asmlinkage void chacha_block_xor_neon(const u32 *state, u8 *dst, const u8 *src,
 				      int nrounds);
 asmlinkage void chacha_4block_xor_neon(const u32 *state, u8 *dst, const u8 *src,
-				       int nrounds);
+				       int nrounds, unsigned int nbytes);
 asmlinkage void hchacha_block_arm(const u32 *state, u32 *out, int nrounds);
 asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 
@@ -42,19 +42,14 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 {
 	u8 buf[CHACHA_BLOCK_SIZE];
 
-	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
-		chacha_4block_xor_neon(state, dst, src, nrounds);
-		bytes -= CHACHA_BLOCK_SIZE * 4;
-		src += CHACHA_BLOCK_SIZE * 4;
-		dst += CHACHA_BLOCK_SIZE * 4;
-		state[12] += 4;
-	}
-	while (bytes >= CHACHA_BLOCK_SIZE) {
-		chacha_block_xor_neon(state, dst, src, nrounds);
-		bytes -= CHACHA_BLOCK_SIZE;
-		src += CHACHA_BLOCK_SIZE;
-		dst += CHACHA_BLOCK_SIZE;
-		state[12]++;
+	while (bytes > CHACHA_BLOCK_SIZE) {
+		unsigned int l = min(bytes, CHACHA_BLOCK_SIZE * 4U);
+
+		chacha_4block_xor_neon(state, dst, src, nrounds, l);
+		bytes -= l;
+		src += l;
+		dst += l;
+		state[12] += DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE);
 	}
 	if (bytes) {
 		memcpy(buf, src, bytes);
diff --git a/arch/arm/crypto/chacha-neon-core.S b/arch/arm/crypto/chacha-neon-core.S
index eb22926d4912..38bcb49b3b39 100644
--- a/arch/arm/crypto/chacha-neon-core.S
+++ b/arch/arm/crypto/chacha-neon-core.S
@@ -47,6 +47,7 @@
   */
 
 #include <linux/linkage.h>
+#include <asm/cache.h>
 
 	.text
 	.fpu		neon
@@ -205,8 +206,9 @@ ENDPROC(hchacha_block_neon)
 
 	.align		5
 ENTRY(chacha_4block_xor_neon)
-	push		{r4-r5}
-	mov		r4, sp			// preserve the stack pointer
+	push		{r4-r6, lr}
+	ldr		r4, [sp, #16]
+	mov		r6, sp			// preserve the stack pointer
 	sub		ip, sp, #0x20		// allocate a 32 byte buffer
 	bic		ip, ip, #0x1f		// aligned to 32 bytes
 	mov		sp, ip
@@ -215,6 +217,7 @@ ENTRY(chacha_4block_xor_neon)
 	// r1: 4 data blocks output, o
 	// r2: 4 data blocks input, i
 	// r3: nrounds
+	// r4: number of bytes
 
 	//
 	// This function encrypts four consecutive ChaCha blocks by loading
@@ -503,6 +506,13 @@ ENTRY(chacha_4block_xor_neon)
 	vswp		d17, d20
 	vswp		d19, d22
 
+	mov		sp, r6		// restore original stack pointer
+
+	subs		r4, r4, #96	// set up lr and ip for overlapping
+	mov		lr, #32		// loads and stores
+	addcc		ip, r4, #32
+	movcs		ip, #32
+
 	// Last two rows of each block are (q8 q12) (q10 q14) (q9 q13) (q11 q15)
 
 	// x8..11[0-3] += s8..11[0-3]	(add orig state to 3rd row of each block)
@@ -519,42 +529,122 @@ ENTRY(chacha_4block_xor_neon)
 
 	// XOR the rest of the data with the keystream
 
-	vld1.8		{q0-q1}, [r2]!
+	vld1.8		{q0-q1}, [r2], ip
 	veor		q0, q0, q8
 	veor		q1, q1, q12
-	vst1.8		{q0-q1}, [r1]!
+	ble		.Lle96
+	subs		r4, r4, #32
+	addcc		lr, r4, #32
+	vst1.8		{q0-q1}, [r1], ip
 
-	vld1.8		{q0-q1}, [r2]!
+	vld1.8		{q0-q1}, [r2], lr
 	veor		q0, q0, q2
 	veor		q1, q1, q6
-	vst1.8		{q0-q1}, [r1]!
+	ble		.Lle128
+	subs		r4, r4, #32
+	addcc		ip, r4, #32
+	vst1.8		{q0-q1}, [r1], lr
 
-	vld1.8		{q0-q1}, [r2]!
+	vld1.8		{q0-q1}, [r2], ip
 	veor		q0, q0, q10
 	veor		q1, q1, q14
-	vst1.8		{q0-q1}, [r1]!
+	ble		.Lle160
+	subs		r4, r4, #32
+	addcc		lr, r4, #32
+	vst1.8		{q0-q1}, [r1], ip
 
-	vld1.8		{q0-q1}, [r2]!
+	vld1.8		{q0-q1}, [r2], lr
 	veor		q0, q0, q4
 	veor		q1, q1, q5
-	vst1.8		{q0-q1}, [r1]!
+	ble		.Lle192
+	subs		r4, r4, #32
+	addcc		ip, r4, #32
+	vst1.8		{q0-q1}, [r1], lr
 
-	vld1.8		{q0-q1}, [r2]!
+	vld1.8		{q0-q1}, [r2], ip
 	veor		q0, q0, q9
 	veor		q1, q1, q13
-	vst1.8		{q0-q1}, [r1]!
+	ble		.Lle224
+	subs		r4, r4, #32
+	addcc		lr, r4, #32
+	vst1.8		{q0-q1}, [r1], ip
 
-	vld1.8		{q0-q1}, [r2]!
+	vld1.8		{q0-q1}, [r2], lr
 	veor		q0, q0, q3
 	veor		q1, q1, q7
-	vst1.8		{q0-q1}, [r1]!
+	blt		.Llt256
+	vst1.8		{q0-q1}, [r1], lr
 
+.Llastblock:
 	vld1.8		{q0-q1}, [r2]
-	  mov		sp, r4		// restore original stack pointer
 	veor		q0, q0, q11
 	veor		q1, q1, q15
 	vst1.8		{q0-q1}, [r1]
 
-	pop		{r4-r5}
-	bx		lr
+	pop		{r4-r6, pc}
+
+.Lle192:
+	mov		ip, lr
+	vmov		q4, q9
+	vmov		q5, q13
+
+.Lle160:
+	// Process the final block if processing less than 4 full blocks.
+	// Entered with 32 bytes of ChaCha cipher stream in q4-q5, and the
+	// previous 32 byte output block that still needs to be written at [r1]
+	beq		.Lfullblock
+	adr		lr, .Lpermute
+	add		lr, lr, ip
+	add		ip, ip, r1
+
+	vld1.8		{q2-q3}, [lr]
+	vld1.8		{q6-q7}, [r2]
+
+	vtbl.8		d4, {q4-q5}, d4
+	vtbl.8		d5, {q4-q5}, d5
+	vtbl.8		d6, {q4-q5}, d6
+	vtbl.8		d7, {q4-q5}, d7
+
+	veor		q6, q6, q2
+	veor		q7, q7, q3
+
+	vst1.8		{q6-q7}, [ip]	// overlapping stores
+	vst1.8		{q0-q1}, [r1]
+	pop		{r4-r6, pc}
+
+.Lfullblock:
+	vst1.8		{q0-q1}, [r1]!
+	vmov		q11, q4
+	vmov		q15, q5
+	b		.Llastblock
+
+.Lle96:
+	vmov		q4, q2
+	vmov		q5, q6
+	b		.Lle160
+.Lle128:
+	mov		ip, lr
+	vmov		q4, q10
+	vmov		q5, q14
+	b		.Lle160
+.Lle224:
+	vmov		q4, q3
+	vmov		q5, q7
+	b		.Lle160
+.Llt256:
+	mov		ip, lr
+	vmov		q4, q11
+	vmov		q5, q15
+	b		.Lle160
 ENDPROC(chacha_4block_xor_neon)
+
+	.align		L1_CACHE_SHIFT
+.Lpermute:
+	.byte		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
+	.byte		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	.byte		0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
+	.byte		0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
+	.byte		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
+	.byte		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	.byte		0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
+	.byte		0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
-- 
2.17.1

