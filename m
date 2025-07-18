Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EE520766E;
	Fri, 18 Jul 2025 19:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752866402; cv=none; b=hU6q/4WAPPxaZ3/6Yc4bQ4wtv7ieDlSNPgGFSIpVZoUksxXL6azjZB3OtwT6aHjwaxZRHjyuwMcFSL+smegGb2tYUJzGaB6LAGCFZ+l7k6fGm6L1A7y7rKSV4BDqEihUbv5XZKl8h2ZKd570q2cDFzosNGKc0+wnGvWIjHNHBoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752866402; c=relaxed/simple;
	bh=dS9Fky7xKxNSurHar2x8+SnKQ+ldHvnIXl92Nxn4y4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLDNLswowdd6qGGN1iaKdkNLeiW0TCJB8bOnZnhGXVS+H2q4lbHnN7H50P9BD+iaPfs3xuj7IH8kkbwoU3oS0v3+M0wuHf7e5xPMP1LJOGvNz+Swh95Gyc6CwBn09h1QIGmQ6gflE0P8Vok1GxixTRg2vIzlFIWHDS3VNBObSeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFTpLzz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFTpLzz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E466EC4CEF5;
	Fri, 18 Jul 2025 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752866402;
	bh=dS9Fky7xKxNSurHar2x8+SnKQ+ldHvnIXl92Nxn4y4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFTpLzz1/jvaqInCdtnCjIDSF8PDXyQP48rKDBMnal+HMZy/rHR1670icf1SF30gj
	 /d//UrQKxPIrpODbm1HW2E7bCcxIFMuv0x0WpU3pdA4c2IAa1LIf9zViBh3gvT9L+z
	 eC9OMxLLDxaSq2uocqd8OoA4k+HIy6VSScqvxzgN5m3g+sXheG7gBLI/jOi6PSbwK0
	 qRdackw6v8bfF7VmCNk1ggVBlc7VoNJvy8s1/QCCy2LPDQIVuKvKBqY9AckHCmtTv0
	 FJXp3ownEh869C4vr1Lxw6w6SEh+obZcriLHbDM9IFwTSeamHdECkMu5XULdo+9trB
	 aUCqJSEq1GnEg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] lib/crypto: x86/sha1-ni: Minor optimizations and cleanup
Date: Fri, 18 Jul 2025 12:18:59 -0700
Message-ID: <20250718191900.42877-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250718191900.42877-1-ebiggers@kernel.org>
References: <20250718191900.42877-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Store the previous state in %xmm8-%xmm9 instead of spilling it to the
  stack.  There are plenty of unused XMM registers here, so there is no
  reason to spill to the stack.  (While 32-bit code is limited to
  %xmm0-%xmm7, this is 64-bit code, so it's free to use %xmm8-%xmm15.)

- Remove the unnecessary check for nblocks == 0.  sha1_ni_transform() is
  always passed a positive nblocks.

- To get an XMM register with 'e' in the high dword and the rest zeroes,
  just zeroize the register using pxor, then load 'e'.  Previously the
  code loaded 'e', then zeroized the lower dwords by AND-ing with a
  constant, which was slightly less efficient.

- Instead of computing &DATA_PTR[NBLOCKS << 6] and stopping when
  DATA_PTR reaches that value, instead just decrement NBLOCKS on each
  iteration and stop when it reaches 0.  This is fewer instructions.

- Rename DIGEST_PTR to STATE_PTR.  It points to the SHA-1 internal
  state, not a SHA-1 digest value.

This commit shrinks the code size of sha1_ni_transform() from 624 bytes
to 589 bytes and also shrinks rodata by 16 bytes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha1-ni-asm.S | 68 +++++++++++++-----------------------
 1 file changed, 25 insertions(+), 43 deletions(-)

diff --git a/lib/crypto/x86/sha1-ni-asm.S b/lib/crypto/x86/sha1-ni-asm.S
index 3989b0642ff5f..1d08b2f364ce7 100644
--- a/lib/crypto/x86/sha1-ni-asm.S
+++ b/lib/crypto/x86/sha1-ni-asm.S
@@ -53,65 +53,56 @@
  *
  */
 
 #include <linux/linkage.h>
 
-#define DIGEST_PTR	%rdi	/* 1st arg */
+#define STATE_PTR	%rdi	/* 1st arg */
 #define DATA_PTR	%rsi	/* 2nd arg */
 #define NUM_BLKS	%rdx	/* 3rd arg */
 
-/* gcc conversion */
-#define FRAME_SIZE	32	/* space for 2x16 bytes */
-
 #define ABCD		%xmm0
 #define E0		%xmm1	/* Need two E's b/c they ping pong */
 #define E1		%xmm2
 #define MSG0		%xmm3
 #define MSG1		%xmm4
 #define MSG2		%xmm5
 #define MSG3		%xmm6
 #define SHUF_MASK	%xmm7
-
+#define ABCD_SAVED	%xmm8
+#define E0_SAVED	%xmm9
 
 /*
  * Intel SHA Extensions optimized implementation of a SHA-1 block function
  *
  * This function takes a pointer to the current SHA-1 state, a pointer to the
- * input data, and the number of 64-byte blocks to process.  Once all blocks
- * have been processed, the state is updated with the new state.  This function
- * only processes complete blocks.  State initialization, buffering of partial
+ * input data, and the number of 64-byte blocks to process.  The number of
+ * blocks to process is assumed to be nonzero.  Once all blocks have been
+ * processed, the state is updated with the new state.  This function only
+ * processes complete blocks.  State initialization, buffering of partial
  * blocks, and digest finalization are expected to be handled elsewhere.
  *
  * The indented lines in the loop are instructions related to rounds processing.
  * The non-indented lines are instructions related to the message schedule.
  *
  * void sha1_ni_transform(struct sha1_block_state *state,
  *			  const u8 *data, size_t nblocks)
  */
 .text
 SYM_FUNC_START(sha1_ni_transform)
-	push		%rbp
-	mov		%rsp, %rbp
-	sub		$FRAME_SIZE, %rsp
-	and		$~0xF, %rsp
-
-	shl		$6, NUM_BLKS		/* convert to bytes */
-	jz		.Ldone_hash
-	add		DATA_PTR, NUM_BLKS	/* pointer to end of data */
-
-	/* load initial hash values */
-	pinsrd		$3, 1*16(DIGEST_PTR), E0
-	movdqu		0*16(DIGEST_PTR), ABCD
-	pand		UPPER_WORD_MASK(%rip), E0
+
+	/* Load the initial state from STATE_PTR. */
+	pxor		E0, E0
+	pinsrd		$3, 16(STATE_PTR), E0
+	movdqu		(STATE_PTR), ABCD
 	pshufd		$0x1B, ABCD, ABCD
 
 	movdqa		PSHUFFLE_BYTE_FLIP_MASK(%rip), SHUF_MASK
 
-.Lloop0:
-	/* Save hash values for addition after rounds */
-	movdqa		E0, (0*16)(%rsp)
-	movdqa		ABCD, (1*16)(%rsp)
+.Lnext_block:
+	/* Save the state for addition after the rounds. */
+	movdqa		E0, E0_SAVED
+	movdqa		ABCD, ABCD_SAVED
 
 	/* Rounds 0-3 */
 	movdqu		0*16(DATA_PTR), MSG0
 	pshufb		SHUF_MASK, MSG0
 		paddd		MSG0, E0
@@ -265,35 +256,26 @@ SYM_FUNC_START(sha1_ni_transform)
 	/* Rounds 76-79 */
 		sha1nexte	MSG3, E1
 		movdqa		ABCD, E0
 		sha1rnds4	$3, E1, ABCD
 
-	/* Add current hash values with previously saved */
-	sha1nexte	(0*16)(%rsp), E0
-	paddd		(1*16)(%rsp), ABCD
+	/* Add the previous state (before the rounds) to the current state. */
+	sha1nexte	E0_SAVED, E0
+	paddd		ABCD_SAVED, ABCD
 
-	/* Increment data pointer and loop if more to process */
+	/* Advance to the next block, or break if there are no more blocks. */
 	add		$64, DATA_PTR
-	cmp		NUM_BLKS, DATA_PTR
-	jne		.Lloop0
+	dec		NUM_BLKS
+	jnz		.Lnext_block
 
-	/* Write hash values back in the correct order */
+	/* Store the new state to STATE_PTR. */
+	pextrd		$3, E0, 16(STATE_PTR)
 	pshufd		$0x1B, ABCD, ABCD
-	movdqu		ABCD, 0*16(DIGEST_PTR)
-	pextrd		$3, E0, 1*16(DIGEST_PTR)
-
-.Ldone_hash:
-	mov		%rbp, %rsp
-	pop		%rbp
+	movdqu		ABCD, (STATE_PTR)
 
 	RET
 SYM_FUNC_END(sha1_ni_transform)
 
 .section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
 .align 16
 PSHUFFLE_BYTE_FLIP_MASK:
 	.octa 0x000102030405060708090a0b0c0d0e0f
-
-.section	.rodata.cst16.UPPER_WORD_MASK, "aM", @progbits, 16
-.align 16
-UPPER_WORD_MASK:
-	.octa 0xFFFFFFFF000000000000000000000000
-- 
2.50.1

