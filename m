Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1FA287255;
	Tue,  9 Sep 2025 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757459787; cv=none; b=lWcYk2QJBW/Kn3CUXxP08MSNPt9f4qyeX+qK9XTgtMH5k2Yj5OLEAmFWk9mwbVr7GTF9/Ls/QIIb2tkTwKSSKT4a8f33oiPK1mTghcos7GbAcAcW8Lq7dUjM5yuYJH5DUABRVu6kGOlyfNQt/gfRrgZ9PAb+fgOcht7k/jwLiAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757459787; c=relaxed/simple;
	bh=S6D1yNE1Syyh365j61OFnP89O+T3sxGXw/t1oEMSH+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjBk+d8SrvSbsxNWHqDTjQ59p1f+7fGcTll8yahn9gNusqeAfrCjPqmh3ngIVAlE0NaMQ6PEEOMBgV9vWO/JRrs15KNCcNO2e94k2/YavAGrFBAhpgsaA4ard7YBIaRmwo5F3cVYr2j6iUMFfLq3yFqEr7YKZXZTdPZ7zdkwtwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlKnfh9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlKnfh9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16069C4CEFA;
	Tue,  9 Sep 2025 23:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757459787;
	bh=S6D1yNE1Syyh365j61OFnP89O+T3sxGXw/t1oEMSH+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlKnfh9F1ri+fH5JlMG64WG6iqYd9iiXy1jRm25czW9mthAY39+49oIyeZIu+bDNN
	 wYmD+vmIvyDrXQwTQcBX1t1HRAvmHK+I9HLp/xLt7CeMqis2ZkHLf5Hw8CSmnvOvEi
	 fDsc7HjJ87pXtHhx6ZOVdxa0RY48X4Y4bL2J+ppxfNHgHgQ0kpOF7+ZX6z2x4igQAB
	 vUAIsJJZGsoruIetffDm9ERFA/WrcuUDf5dYy/8KRwLwrXTuJ9UjuCjWbFy/vpPGTj
	 ROAOdBZyamLgS1wZ/xHVEdZzpXPIgAZ16uqK9P4CvafDhf/X5AanlSC+Fec7nF6DoW
	 D4zUNhoxc10CA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/6] lib/crypto: x86/sha256: Add support for 2-way interleaved hashing
Date: Tue,  9 Sep 2025 16:13:23 -0700
Message-ID: <20250909231326.1074672-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250909231326.1074672-1-ebiggers@kernel.org>
References: <20250909231326.1074672-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an implementation of sha256_finup_2x_arch() for x86_64.  It
interleaves the computation of two SHA-256 hashes using the x86 SHA-256
instructions.  dm-verity and fs-verity will take advantage of this for
greatly improved performance on capable CPUs.

This increases the throughput of SHA-256 hashing 4096-byte messages by
the following amounts on the following CPUs:

    Intel Ice Lake (server):        4%
    Intel Sapphire Rapids:          38%
    Intel Emerald Rapids:           38%
    AMD Zen 1 (Threadripper 1950X): 84%
    AMD Zen 4 (EPYC 9B14):          98%
    AMD Zen 5 (Ryzen 9 9950X):      64%

For now, this seems to benefit AMD more than Intel.  This seems to be
because current AMD CPUs support concurrent execution of the SHA-NI
instructions, but unfortunately current Intel CPUs don't, except for the
sha256msg2 instruction.  Hopefully future Intel CPUs will support SHA-NI
on more execution ports.  Zen 1 supports 2 concurrent sha256rnds2, and
Zen 4 supports 4 concurrent sha256rnds2, which suggests that even better
performance may be achievable on Zen 4 by interleaving more than two
hashes.  However, doing so poses a number of trade-offs, and furthermore
Zen 5 goes back to supporting "only" 2 concurrent sha256rnds2.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha256-ni-asm.S | 368 +++++++++++++++++++++++++++++++++
 lib/crypto/x86/sha256.h        |  39 ++++
 2 files changed, 407 insertions(+)

diff --git a/lib/crypto/x86/sha256-ni-asm.S b/lib/crypto/x86/sha256-ni-asm.S
index 4bd9490ffc662..de5f707e7ef71 100644
--- a/lib/crypto/x86/sha256-ni-asm.S
+++ b/lib/crypto/x86/sha256-ni-asm.S
@@ -163,10 +163,378 @@ SYM_FUNC_START(sha256_ni_transform)
 	movdqu		STATE0, 1*16(STATE_PTR)
 
 	RET
 SYM_FUNC_END(sha256_ni_transform)
 
+#undef DIGEST_PTR
+#undef DATA_PTR
+#undef NUM_BLKS
+#undef SHA256CONSTANTS
+#undef MSG
+#undef STATE0
+#undef STATE1
+#undef MSG0
+#undef MSG1
+#undef MSG2
+#undef MSG3
+#undef TMP
+#undef SHUF_MASK
+#undef ABEF_SAVE
+#undef CDGH_SAVE
+
+// parameters for sha256_ni_finup2x()
+#define CTX		%rdi
+#define DATA1		%rsi
+#define DATA2		%rdx
+#define LEN		%ecx
+#define LEN8		%cl
+#define LEN64		%rcx
+#define OUT1		%r8
+#define OUT2		%r9
+
+// other scalar variables
+#define SHA256CONSTANTS	%rax
+#define COUNT		%r10
+#define COUNT32		%r10d
+#define FINAL_STEP	%r11d
+
+// rbx is used as a temporary.
+
+#define MSG		%xmm0	// sha256rnds2 implicit operand
+#define STATE0_A	%xmm1
+#define STATE1_A	%xmm2
+#define STATE0_B	%xmm3
+#define STATE1_B	%xmm4
+#define TMP_A		%xmm5
+#define TMP_B		%xmm6
+#define MSG0_A		%xmm7
+#define MSG1_A		%xmm8
+#define MSG2_A		%xmm9
+#define MSG3_A		%xmm10
+#define MSG0_B		%xmm11
+#define MSG1_B		%xmm12
+#define MSG2_B		%xmm13
+#define MSG3_B		%xmm14
+#define SHUF_MASK	%xmm15
+
+#define OFFSETOF_STATE		0  // offsetof(struct __sha256_ctx, state)
+#define OFFSETOF_BYTECOUNT	32 // offsetof(struct __sha256_ctx, bytecount)
+#define OFFSETOF_BUF		40 // offsetof(struct __sha256_ctx, buf)
+
+// Do 4 rounds of SHA-256 for each of two messages (interleaved).  m0_a and m0_b
+// contain the current 4 message schedule words for the first and second message
+// respectively.
+//
+// If not all the message schedule words have been computed yet, then this also
+// computes 4 more message schedule words for each message.  m1_a-m3_a contain
+// the next 3 groups of 4 message schedule words for the first message, and
+// likewise m1_b-m3_b for the second.  After consuming the current value of
+// m0_a, this macro computes the group after m3_a and writes it to m0_a, and
+// likewise for *_b.  This means that the next (m0_a, m1_a, m2_a, m3_a) is the
+// current (m1_a, m2_a, m3_a, m0_a), and likewise for *_b, so the caller must
+// cycle through the registers accordingly.
+.macro	do_4rounds_2x	i, m0_a, m1_a, m2_a, m3_a,  m0_b, m1_b, m2_b, m3_b
+	movdqa		(\i-32)*4(SHA256CONSTANTS), TMP_A
+	movdqa		TMP_A, TMP_B
+	paddd		\m0_a, TMP_A
+	paddd		\m0_b, TMP_B
+.if \i < 48
+	sha256msg1	\m1_a, \m0_a
+	sha256msg1	\m1_b, \m0_b
+.endif
+	movdqa		TMP_A, MSG
+	sha256rnds2	STATE0_A, STATE1_A
+	movdqa		TMP_B, MSG
+	sha256rnds2	STATE0_B, STATE1_B
+	pshufd 		$0x0E, TMP_A, MSG
+	sha256rnds2	STATE1_A, STATE0_A
+	pshufd 		$0x0E, TMP_B, MSG
+	sha256rnds2	STATE1_B, STATE0_B
+.if \i < 48
+	movdqa		\m3_a, TMP_A
+	movdqa		\m3_b, TMP_B
+	palignr		$4, \m2_a, TMP_A
+	palignr		$4, \m2_b, TMP_B
+	paddd		TMP_A, \m0_a
+	paddd		TMP_B, \m0_b
+	sha256msg2	\m3_a, \m0_a
+	sha256msg2	\m3_b, \m0_b
+.endif
+.endm
+
+//
+// void sha256_ni_finup2x(const struct __sha256_ctx *ctx,
+//			  const u8 *data1, const u8 *data2, int len,
+//			  u8 out1[SHA256_DIGEST_SIZE],
+//			  u8 out2[SHA256_DIGEST_SIZE]);
+//
+// This function computes the SHA-256 digests of two messages |data1| and
+// |data2| that are both |len| bytes long, starting from the initial context
+// |ctx|.  |len| must be at least SHA256_BLOCK_SIZE.
+//
+// The instructions for the two SHA-256 operations are interleaved.  On many
+// CPUs, this is almost twice as fast as hashing each message individually due
+// to taking better advantage of the CPU's SHA-256 and SIMD throughput.
+//
+SYM_FUNC_START(sha256_ni_finup2x)
+	// Allocate 128 bytes of stack space, 16-byte aligned.
+	push		%rbx
+	push		%rbp
+	mov		%rsp, %rbp
+	sub		$128, %rsp
+	and		$~15, %rsp
+
+	// Load the shuffle mask for swapping the endianness of 32-bit words.
+	movdqa		PSHUFFLE_BYTE_FLIP_MASK(%rip), SHUF_MASK
+
+	// Set up pointer to the round constants.
+	lea		K256+32*4(%rip), SHA256CONSTANTS
+
+	// Initially we're not processing the final blocks.
+	xor		FINAL_STEP, FINAL_STEP
+
+	// Load the initial state from ctx->state.
+	movdqu		OFFSETOF_STATE+0*16(CTX), STATE0_A	// DCBA
+	movdqu		OFFSETOF_STATE+1*16(CTX), STATE1_A	// HGFE
+	movdqa		STATE0_A, TMP_A
+	punpcklqdq	STATE1_A, STATE0_A			// FEBA
+	punpckhqdq	TMP_A, STATE1_A				// DCHG
+	pshufd		$0x1B, STATE0_A, STATE0_A		// ABEF
+	pshufd		$0xB1, STATE1_A, STATE1_A		// CDGH
+
+	// Load ctx->bytecount.  Take the mod 64 of it to get the number of
+	// bytes that are buffered in ctx->buf.  Also save it in a register with
+	// LEN added to it.
+	mov		LEN, LEN
+	mov		OFFSETOF_BYTECOUNT(CTX), %rbx
+	lea		(%rbx, LEN64, 1), COUNT
+	and		$63, %ebx
+	jz		.Lfinup2x_enter_loop	// No bytes buffered?
+
+	// %ebx bytes (1 to 63) are currently buffered in ctx->buf.  Load them
+	// followed by the first 64 - %ebx bytes of data.  Since LEN >= 64, we
+	// just load 64 bytes from each of ctx->buf, DATA1, and DATA2
+	// unconditionally and rearrange the data as needed.
+
+	movdqu		OFFSETOF_BUF+0*16(CTX), MSG0_A
+	movdqu		OFFSETOF_BUF+1*16(CTX), MSG1_A
+	movdqu		OFFSETOF_BUF+2*16(CTX), MSG2_A
+	movdqu		OFFSETOF_BUF+3*16(CTX), MSG3_A
+	movdqa		MSG0_A, 0*16(%rsp)
+	movdqa		MSG1_A, 1*16(%rsp)
+	movdqa		MSG2_A, 2*16(%rsp)
+	movdqa		MSG3_A, 3*16(%rsp)
+
+	movdqu		0*16(DATA1), MSG0_A
+	movdqu		1*16(DATA1), MSG1_A
+	movdqu		2*16(DATA1), MSG2_A
+	movdqu		3*16(DATA1), MSG3_A
+	movdqu		MSG0_A, 0*16(%rsp,%rbx)
+	movdqu		MSG1_A, 1*16(%rsp,%rbx)
+	movdqu		MSG2_A, 2*16(%rsp,%rbx)
+	movdqu		MSG3_A, 3*16(%rsp,%rbx)
+	movdqa		0*16(%rsp), MSG0_A
+	movdqa		1*16(%rsp), MSG1_A
+	movdqa		2*16(%rsp), MSG2_A
+	movdqa		3*16(%rsp), MSG3_A
+
+	movdqu		0*16(DATA2), MSG0_B
+	movdqu		1*16(DATA2), MSG1_B
+	movdqu		2*16(DATA2), MSG2_B
+	movdqu		3*16(DATA2), MSG3_B
+	movdqu		MSG0_B, 0*16(%rsp,%rbx)
+	movdqu		MSG1_B, 1*16(%rsp,%rbx)
+	movdqu		MSG2_B, 2*16(%rsp,%rbx)
+	movdqu		MSG3_B, 3*16(%rsp,%rbx)
+	movdqa		0*16(%rsp), MSG0_B
+	movdqa		1*16(%rsp), MSG1_B
+	movdqa		2*16(%rsp), MSG2_B
+	movdqa		3*16(%rsp), MSG3_B
+
+	sub		$64, %rbx 	// rbx = buffered - 64
+	sub		%rbx, DATA1	// DATA1 += 64 - buffered
+	sub		%rbx, DATA2	// DATA2 += 64 - buffered
+	add		%ebx, LEN	// LEN += buffered - 64
+	movdqa		STATE0_A, STATE0_B
+	movdqa		STATE1_A, STATE1_B
+	jmp		.Lfinup2x_loop_have_data
+
+.Lfinup2x_enter_loop:
+	sub		$64, LEN
+	movdqa		STATE0_A, STATE0_B
+	movdqa		STATE1_A, STATE1_B
+.Lfinup2x_loop:
+	// Load the next two data blocks.
+	movdqu		0*16(DATA1), MSG0_A
+	movdqu		0*16(DATA2), MSG0_B
+	movdqu		1*16(DATA1), MSG1_A
+	movdqu		1*16(DATA2), MSG1_B
+	movdqu		2*16(DATA1), MSG2_A
+	movdqu		2*16(DATA2), MSG2_B
+	movdqu		3*16(DATA1), MSG3_A
+	movdqu		3*16(DATA2), MSG3_B
+	add		$64, DATA1
+	add		$64, DATA2
+.Lfinup2x_loop_have_data:
+	// Convert the words of the data blocks from big endian.
+	pshufb		SHUF_MASK, MSG0_A
+	pshufb		SHUF_MASK, MSG0_B
+	pshufb		SHUF_MASK, MSG1_A
+	pshufb		SHUF_MASK, MSG1_B
+	pshufb		SHUF_MASK, MSG2_A
+	pshufb		SHUF_MASK, MSG2_B
+	pshufb		SHUF_MASK, MSG3_A
+	pshufb		SHUF_MASK, MSG3_B
+.Lfinup2x_loop_have_bswapped_data:
+
+	// Save the original state for each block.
+	movdqa		STATE0_A, 0*16(%rsp)
+	movdqa		STATE0_B, 1*16(%rsp)
+	movdqa		STATE1_A, 2*16(%rsp)
+	movdqa		STATE1_B, 3*16(%rsp)
+
+	// Do the SHA-256 rounds on each block.
+.irp i, 0, 16, 32, 48
+	do_4rounds_2x	(\i + 0),  MSG0_A, MSG1_A, MSG2_A, MSG3_A, \
+				   MSG0_B, MSG1_B, MSG2_B, MSG3_B
+	do_4rounds_2x	(\i + 4),  MSG1_A, MSG2_A, MSG3_A, MSG0_A, \
+				   MSG1_B, MSG2_B, MSG3_B, MSG0_B
+	do_4rounds_2x	(\i + 8),  MSG2_A, MSG3_A, MSG0_A, MSG1_A, \
+				   MSG2_B, MSG3_B, MSG0_B, MSG1_B
+	do_4rounds_2x	(\i + 12), MSG3_A, MSG0_A, MSG1_A, MSG2_A, \
+				   MSG3_B, MSG0_B, MSG1_B, MSG2_B
+.endr
+
+	// Add the original state for each block.
+	paddd		0*16(%rsp), STATE0_A
+	paddd		1*16(%rsp), STATE0_B
+	paddd		2*16(%rsp), STATE1_A
+	paddd		3*16(%rsp), STATE1_B
+
+	// Update LEN and loop back if more blocks remain.
+	sub		$64, LEN
+	jge		.Lfinup2x_loop
+
+	// Check if any final blocks need to be handled.
+	// FINAL_STEP = 2: all done
+	// FINAL_STEP = 1: need to do count-only padding block
+	// FINAL_STEP = 0: need to do the block with 0x80 padding byte
+	cmp		$1, FINAL_STEP
+	jg		.Lfinup2x_done
+	je		.Lfinup2x_finalize_countonly
+	add		$64, LEN
+	jz		.Lfinup2x_finalize_blockaligned
+
+	// Not block-aligned; 1 <= LEN <= 63 data bytes remain.  Pad the block.
+	// To do this, write the padding starting with the 0x80 byte to
+	// &sp[64].  Then for each message, copy the last 64 data bytes to sp
+	// and load from &sp[64 - LEN] to get the needed padding block.  This
+	// code relies on the data buffers being >= 64 bytes in length.
+	mov		$64, %ebx
+	sub		LEN, %ebx		// ebx = 64 - LEN
+	sub		%rbx, DATA1		// DATA1 -= 64 - LEN
+	sub		%rbx, DATA2		// DATA2 -= 64 - LEN
+	mov		$0x80, FINAL_STEP   // using FINAL_STEP as a temporary
+	movd		FINAL_STEP, MSG0_A
+	pxor		MSG1_A, MSG1_A
+	movdqa		MSG0_A, 4*16(%rsp)
+	movdqa		MSG1_A, 5*16(%rsp)
+	movdqa		MSG1_A, 6*16(%rsp)
+	movdqa		MSG1_A, 7*16(%rsp)
+	cmp		$56, LEN
+	jge		1f	// will COUNT spill into its own block?
+	shl		$3, COUNT
+	bswap		COUNT
+	mov		COUNT, 56(%rsp,%rbx)
+	mov		$2, FINAL_STEP	// won't need count-only block
+	jmp		2f
+1:
+	mov		$1, FINAL_STEP	// will need count-only block
+2:
+	movdqu		0*16(DATA1), MSG0_A
+	movdqu		1*16(DATA1), MSG1_A
+	movdqu		2*16(DATA1), MSG2_A
+	movdqu		3*16(DATA1), MSG3_A
+	movdqa		MSG0_A, 0*16(%rsp)
+	movdqa		MSG1_A, 1*16(%rsp)
+	movdqa		MSG2_A, 2*16(%rsp)
+	movdqa		MSG3_A, 3*16(%rsp)
+	movdqu		0*16(%rsp,%rbx), MSG0_A
+	movdqu		1*16(%rsp,%rbx), MSG1_A
+	movdqu		2*16(%rsp,%rbx), MSG2_A
+	movdqu		3*16(%rsp,%rbx), MSG3_A
+
+	movdqu		0*16(DATA2), MSG0_B
+	movdqu		1*16(DATA2), MSG1_B
+	movdqu		2*16(DATA2), MSG2_B
+	movdqu		3*16(DATA2), MSG3_B
+	movdqa		MSG0_B, 0*16(%rsp)
+	movdqa		MSG1_B, 1*16(%rsp)
+	movdqa		MSG2_B, 2*16(%rsp)
+	movdqa		MSG3_B, 3*16(%rsp)
+	movdqu		0*16(%rsp,%rbx), MSG0_B
+	movdqu		1*16(%rsp,%rbx), MSG1_B
+	movdqu		2*16(%rsp,%rbx), MSG2_B
+	movdqu		3*16(%rsp,%rbx), MSG3_B
+	jmp		.Lfinup2x_loop_have_data
+
+	// Prepare a padding block, either:
+	//
+	//	{0x80, 0, 0, 0, ..., count (as __be64)}
+	//	This is for a block aligned message.
+	//
+	//	{   0, 0, 0, 0, ..., count (as __be64)}
+	//	This is for a message whose length mod 64 is >= 56.
+	//
+	// Pre-swap the endianness of the words.
+.Lfinup2x_finalize_countonly:
+	pxor		MSG0_A, MSG0_A
+	jmp		1f
+
+.Lfinup2x_finalize_blockaligned:
+	mov		$0x80000000, %ebx
+	movd		%ebx, MSG0_A
+1:
+	pxor		MSG1_A, MSG1_A
+	pxor		MSG2_A, MSG2_A
+	ror		$29, COUNT
+	movq		COUNT, MSG3_A
+	pslldq		$8, MSG3_A
+	movdqa		MSG0_A, MSG0_B
+	pxor		MSG1_B, MSG1_B
+	pxor		MSG2_B, MSG2_B
+	movdqa		MSG3_A, MSG3_B
+	mov		$2, FINAL_STEP
+	jmp		.Lfinup2x_loop_have_bswapped_data
+
+.Lfinup2x_done:
+	// Write the two digests with all bytes in the correct order.
+	movdqa		STATE0_A, TMP_A
+	movdqa		STATE0_B, TMP_B
+	punpcklqdq	STATE1_A, STATE0_A		// GHEF
+	punpcklqdq	STATE1_B, STATE0_B
+	punpckhqdq	TMP_A, STATE1_A			// ABCD
+	punpckhqdq	TMP_B, STATE1_B
+	pshufd		$0xB1, STATE0_A, STATE0_A	// HGFE
+	pshufd		$0xB1, STATE0_B, STATE0_B
+	pshufd		$0x1B, STATE1_A, STATE1_A	// DCBA
+	pshufd		$0x1B, STATE1_B, STATE1_B
+	pshufb		SHUF_MASK, STATE0_A
+	pshufb		SHUF_MASK, STATE0_B
+	pshufb		SHUF_MASK, STATE1_A
+	pshufb		SHUF_MASK, STATE1_B
+	movdqu		STATE0_A, 1*16(OUT1)
+	movdqu		STATE0_B, 1*16(OUT2)
+	movdqu		STATE1_A, 0*16(OUT1)
+	movdqu		STATE1_B, 0*16(OUT2)
+
+	mov		%rbp, %rsp
+	pop		%rbp
+	pop		%rbx
+	RET
+SYM_FUNC_END(sha256_ni_finup2x)
+
 .section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
 K256:
 	.long	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
 	.long	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 41fa95fbc3bf8..38e33b22a0927 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -5,10 +5,12 @@
  * Copyright 2025 Google LLC
  */
 #include <asm/fpu/api.h>
 #include <linux/static_call.h>
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha_ni);
+
 DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_blocks_generic);
 
 #define DEFINE_X86_SHA256_FN(c_fn, asm_fn)                                 \
 	asmlinkage void asm_fn(struct sha256_block_state *state,           \
 			       const u8 *data, size_t nblocks);            \
@@ -33,15 +35,52 @@ static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	static_call(sha256_blocks_x86)(state, data, nblocks);
 }
 
+static_assert(offsetof(struct __sha256_ctx, state) == 0);
+static_assert(offsetof(struct __sha256_ctx, bytecount) == 32);
+static_assert(offsetof(struct __sha256_ctx, buf) == 40);
+asmlinkage void sha256_ni_finup2x(const struct __sha256_ctx *ctx,
+				  const u8 *data1, const u8 *data2, int len,
+				  u8 out1[SHA256_DIGEST_SIZE],
+				  u8 out2[SHA256_DIGEST_SIZE]);
+
+#define sha256_finup_2x_arch sha256_finup_2x_arch
+static bool sha256_finup_2x_arch(const struct __sha256_ctx *ctx,
+				 const u8 *data1, const u8 *data2, size_t len,
+				 u8 out1[SHA256_DIGEST_SIZE],
+				 u8 out2[SHA256_DIGEST_SIZE])
+{
+	/*
+	 * The assembly requires len >= SHA256_BLOCK_SIZE && len <= INT_MAX.
+	 * Further limit len to 65536 to avoid spending too long with preemption
+	 * disabled.  (Of course, in practice len is nearly always 4096 anyway.)
+	 */
+	if (static_branch_likely(&have_sha_ni) && len >= SHA256_BLOCK_SIZE &&
+	    len <= 65536 && likely(irq_fpu_usable())) {
+		kernel_fpu_begin();
+		sha256_ni_finup2x(ctx, data1, data2, len, out1, out2);
+		kernel_fpu_end();
+		kmsan_unpoison_memory(out1, SHA256_DIGEST_SIZE);
+		kmsan_unpoison_memory(out2, SHA256_DIGEST_SIZE);
+		return true;
+	}
+	return false;
+}
+
+static bool sha256_finup_2x_is_optimized_arch(void)
+{
+	return static_key_enabled(&have_sha_ni);
+}
+
 #define sha256_mod_init_arch sha256_mod_init_arch
 static void sha256_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_ni);
+		static_branch_enable(&have_sha_ni);
 	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				     NULL) &&
 		   boot_cpu_has(X86_FEATURE_AVX)) {
 		if (boot_cpu_has(X86_FEATURE_AVX2) &&
 		    boot_cpu_has(X86_FEATURE_BMI2))
-- 
2.50.1

