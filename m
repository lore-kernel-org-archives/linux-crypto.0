Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3FA1C6B8;
	Mon, 22 Apr 2024 20:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818163; cv=none; b=ld45mNRhJXJdQnEg3Z5tlbumOrgzkNzfkO+831UySVj5mj2ynFLjL7HdmsyUUvepaq+CqDTg8+PZnArJC7MDyFgIwYrBqdQ6Y1a8pRbycpNnwmUjpK2AWTse/DQHkxSq9eE2DyaTzcXqiVd/IvYYHrY/bgBJzFfJEvjMmEl4XCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818163; c=relaxed/simple;
	bh=A/SJeX1WaVwRrD9NYUGVQTFowCVhuP/v2Jq1Nj4cm6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOxn0Y7VLu4QAQ1a21VpxN8S1dW5nxh4+j7U9Kp2MzBKuri6GkP9+iEio1SJ8WVIHHCtqte8lGWw4MybXvSbasvGSVEeyMbPbWNIv6jKqgKJDYUturmP1liJSLEJ3Rx6cvpvTGQHLREibtGT9liGeCAIiyJRJpCSNwcbP0/HsRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PES3nZ8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PES3nZ8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25083C113CC;
	Mon, 22 Apr 2024 20:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713818163;
	bh=A/SJeX1WaVwRrD9NYUGVQTFowCVhuP/v2Jq1Nj4cm6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PES3nZ8IprQPT0U4B67QdbeI3y2ki5cSRSbRvBvdQxIJ+HuFXgBbQcpCk0cYmriOA
	 Y98grFZzTyL3Z+Lvs+jLWVIiTGu3YNR0plVxK+XrthIXQ5TOtWPegDbiiOovXL5R4m
	 ziWrk6B8lP4MH6Ud//bxI6mx74EG3vgcAEE29PLxwdV6agvadfuqZ4IcrKSmLAGWT5
	 DCHpYm2EJxZ+NnLnqamNBGcJTYppyTEiEWog2vy3OVyiiSP4LhEwYdoZt3CKC2V7HX
	 jXlHw51ob9y2LPRF5WKw169nDqchSSa5Oj/eNxKwHkvA1H1bD5ft2gvApvlM88Mj9D
	 Ga9m1tpU3p63Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 5/8] crypto: arm64/sha256-ce - add support for finup2x
Date: Mon, 22 Apr 2024 13:35:41 -0700
Message-ID: <20240422203544.195390-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422203544.195390-1-ebiggers@kernel.org>
References: <20240422203544.195390-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add an implementation of finup2x to sha256-ce.  finup2x interleaves a
finup operation for two equal-length messages that share a common
prefix.  dm-verity and fs-verity will take advantage of this for
significantly improved performance on capable CPUs.

On an ARM Cortex-X1, this increases the throughput of SHA-256 hashing
4096-byte messages by 70%.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sha2-ce-core.S | 281 ++++++++++++++++++++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c |  41 +++++
 2 files changed, 316 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index fce84d88ddb2..fb5d5227e585 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -68,22 +68,26 @@
 	.word		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5
 	.word		0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3
 	.word		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208
 	.word		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
 
+	.macro load_round_constants	tmp
+	adr_l		\tmp, .Lsha2_rcon
+	ld1		{ v0.4s- v3.4s}, [\tmp], #64
+	ld1		{ v4.4s- v7.4s}, [\tmp], #64
+	ld1		{ v8.4s-v11.4s}, [\tmp], #64
+	ld1		{v12.4s-v15.4s}, [\tmp]
+	.endm
+
 	/*
 	 * int __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
 	 *			     int blocks)
 	 */
 	.text
 SYM_FUNC_START(__sha256_ce_transform)
-	/* load round constants */
-	adr_l		x8, .Lsha2_rcon
-	ld1		{ v0.4s- v3.4s}, [x8], #64
-	ld1		{ v4.4s- v7.4s}, [x8], #64
-	ld1		{ v8.4s-v11.4s}, [x8], #64
-	ld1		{v12.4s-v15.4s}, [x8]
+
+	load_round_constants	x8
 
 	/* load state */
 	ld1		{dgav.4s, dgbv.4s}, [x0]
 
 	/* load sha256_ce_state::finalize */
@@ -153,5 +157,270 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	/* store new state */
 3:	st1		{dgav.4s, dgbv.4s}, [x0]
 	mov		w0, w2
 	ret
 SYM_FUNC_END(__sha256_ce_transform)
+
+	.unreq dga
+	.unreq dgav
+	.unreq dgb
+	.unreq dgbv
+	.unreq t0
+	.unreq t1
+	.unreq dg0q
+	.unreq dg0v
+	.unreq dg1q
+	.unreq dg1v
+	.unreq dg2q
+	.unreq dg2v
+
+	// parameters for __sha256_ce_finup2x()
+	sctx		.req	x0
+	data1		.req	x1
+	data2		.req	x2
+	len		.req	w3
+	out1		.req	x4
+	out2		.req	x5
+
+	// other scalar variables
+	count		.req	x6
+	final_step	.req	w7
+
+	// x8-x9 are used as temporaries.
+
+	// v0-v15 are used to cache the SHA-256 round constants.
+	// v16-v19 are used for the message schedule for the first message.
+	// v20-v23 are used for the message schedule for the second message.
+	// v24-v31 are used for the state and temporaries as given below.
+	// *_a are for the first message and *_b for the second.
+	state0_a_q	.req	q24
+	state0_a	.req	v24
+	state1_a_q	.req	q25
+	state1_a	.req	v25
+	state0_b_q	.req	q26
+	state0_b	.req	v26
+	state1_b_q	.req	q27
+	state1_b	.req	v27
+	t0_a		.req	v28
+	t0_b		.req	v29
+	t1_a_q		.req	q30
+	t1_a		.req	v30
+	t1_b_q		.req	q31
+	t1_b		.req	v31
+
+#define OFFSETOF_COUNT	32	// offsetof(struct sha256_state, count)
+#define OFFSETOF_BUF	40	// offsetof(struct sha256_state, buf)
+// offsetof(struct sha256_state, state) is assumed to be 0.
+
+	// Do 4 rounds of SHA-256 for each of two messages (interleaved).  m0_a
+	// and m0_b contain the current 4 message schedule words for the first
+	// and second message respectively.
+	//
+	// If not all the message schedule words have been computed yet, then
+	// this also computes 4 more message schedule words for each message.
+	// m1_a-m3_a contain the next 3 groups of 4 message schedule words for
+	// the first message, and likewise m1_b-m3_b for the second.  After
+	// consuming the current value of m0_a, this macro computes the group
+	// after m3_a and writes it to m0_a, and likewise for *_b.  This means
+	// that the next (m0_a, m1_a, m2_a, m3_a) is the current (m1_a, m2_a,
+	// m3_a, m0_a), and likewise for *_b, so the caller must cycle through
+	// the registers accordingly.
+	.macro	do_4rounds_2x	i, k,  m0_a, m1_a, m2_a, m3_a,  \
+				       m0_b, m1_b, m2_b, m3_b
+	add		t0_a\().4s, \m0_a\().4s, \k\().4s
+	add		t0_b\().4s, \m0_b\().4s, \k\().4s
+	.if \i < 48
+	sha256su0	\m0_a\().4s, \m1_a\().4s
+	sha256su0	\m0_b\().4s, \m1_b\().4s
+	sha256su1	\m0_a\().4s, \m2_a\().4s, \m3_a\().4s
+	sha256su1	\m0_b\().4s, \m2_b\().4s, \m3_b\().4s
+	.endif
+	mov		t1_a.16b, state0_a.16b
+	mov		t1_b.16b, state0_b.16b
+	sha256h		state0_a_q, state1_a_q, t0_a\().4s
+	sha256h		state0_b_q, state1_b_q, t0_b\().4s
+	sha256h2	state1_a_q, t1_a_q, t0_a\().4s
+	sha256h2	state1_b_q, t1_b_q, t0_b\().4s
+	.endm
+
+	.macro	do_16rounds_2x	i, k0, k1, k2, k3
+	do_4rounds_2x	\i + 0,  \k0,  v16, v17, v18, v19,  v20, v21, v22, v23
+	do_4rounds_2x	\i + 4,  \k1,  v17, v18, v19, v16,  v21, v22, v23, v20
+	do_4rounds_2x	\i + 8,  \k2,  v18, v19, v16, v17,  v22, v23, v20, v21
+	do_4rounds_2x	\i + 12, \k3,  v19, v16, v17, v18,  v23, v20, v21, v22
+	.endm
+
+//
+// void __sha256_ce_finup2x(const struct sha256_state *sctx,
+//			    const u8 *data1, const u8 *data2, int len,
+//			    u8 out1[SHA256_DIGEST_SIZE],
+//			    u8 out2[SHA256_DIGEST_SIZE]);
+//
+// This function computes the SHA-256 digests of two messages |data1| and
+// |data2| that are both |len| bytes long, starting from the initial state
+// |sctx|.  |len| must be at least SHA256_BLOCK_SIZE.
+//
+// The instructions for the two SHA-256 operations are interleaved.  On many
+// CPUs, this is almost twice as fast as hashing each message individually due
+// to taking better advantage of the CPU's SHA-256 and SIMD throughput.
+//
+SYM_FUNC_START(__sha256_ce_finup2x)
+	sub		sp, sp, #128
+	mov		final_step, #0
+	load_round_constants	x8
+
+	// Load the initial state from sctx->state.
+	ld1		{state0_a.4s-state1_a.4s}, [sctx]
+
+	// Load sctx->count.  Take the mod 64 of it to get the number of bytes
+	// that are buffered in sctx->buf.  Also save it in a register with len
+	// added to it.
+	ldr		x8, [sctx, #OFFSETOF_COUNT]
+	add		count, x8, len, sxtw
+	and		x8, x8, #63
+	cbz		x8, .Lfinup2x_enter_loop	// No bytes buffered?
+
+	// x8 bytes (1 to 63) are currently buffered in sctx->buf.  Load them
+	// followed by the first 64 - x8 bytes of data.  Since len >= 64, we
+	// just load 64 bytes from each of sctx->buf, data1, and data2
+	// unconditionally and rearrange the data as needed.
+	add		x9, sctx, #OFFSETOF_BUF
+	ld1		{v16.16b-v19.16b}, [x9]
+	st1		{v16.16b-v19.16b}, [sp]
+
+	ld1		{v16.16b-v19.16b}, [data1], #64
+	add		x9, sp, x8
+	st1		{v16.16b-v19.16b}, [x9]
+	ld1		{v16.4s-v19.4s}, [sp]
+
+	ld1		{v20.16b-v23.16b}, [data2], #64
+	st1		{v20.16b-v23.16b}, [x9]
+	ld1		{v20.4s-v23.4s}, [sp]
+
+	sub		len, len, #64
+	sub		data1, data1, x8
+	sub		data2, data2, x8
+	add		len, len, w8
+	mov		state0_b.16b, state0_a.16b
+	mov		state1_b.16b, state1_a.16b
+	b		.Lfinup2x_loop_have_data
+
+.Lfinup2x_enter_loop:
+	sub		len, len, #64
+	mov		state0_b.16b, state0_a.16b
+	mov		state1_b.16b, state1_a.16b
+.Lfinup2x_loop:
+	// Load the next two data blocks.
+	ld1		{v16.4s-v19.4s}, [data1], #64
+	ld1		{v20.4s-v23.4s}, [data2], #64
+.Lfinup2x_loop_have_data:
+	// Convert the words of the data blocks from big endian.
+CPU_LE(	rev32		v16.16b, v16.16b	)
+CPU_LE(	rev32		v17.16b, v17.16b	)
+CPU_LE(	rev32		v18.16b, v18.16b	)
+CPU_LE(	rev32		v19.16b, v19.16b	)
+CPU_LE(	rev32		v20.16b, v20.16b	)
+CPU_LE(	rev32		v21.16b, v21.16b	)
+CPU_LE(	rev32		v22.16b, v22.16b	)
+CPU_LE(	rev32		v23.16b, v23.16b	)
+.Lfinup2x_loop_have_bswapped_data:
+
+	// Save the original state for each block.
+	st1		{state0_a.4s-state1_b.4s}, [sp]
+
+	// Do the SHA-256 rounds on each block.
+	do_16rounds_2x	0,  v0, v1, v2, v3
+	do_16rounds_2x	16, v4, v5, v6, v7
+	do_16rounds_2x	32, v8, v9, v10, v11
+	do_16rounds_2x	48, v12, v13, v14, v15
+
+	// Add the original state for each block.
+	ld1		{v16.4s-v19.4s}, [sp]
+	add		state0_a.4s, state0_a.4s, v16.4s
+	add		state1_a.4s, state1_a.4s, v17.4s
+	add		state0_b.4s, state0_b.4s, v18.4s
+	add		state1_b.4s, state1_b.4s, v19.4s
+
+	// Update len and loop back if more blocks remain.
+	sub		len, len, #64
+	tbz		len, #31, .Lfinup2x_loop	// len >= 0?
+
+	// Check if any final blocks need to be handled.
+	// final_step = 2: all done
+	// final_step = 1: need to do count-only padding block
+	// final_step = 0: need to do the block with 0x80 padding byte
+	tbnz		final_step, #1, .Lfinup2x_done
+	tbnz		final_step, #0, .Lfinup2x_finalize_countonly
+	add		len, len, #64
+	cbz		len, .Lfinup2x_finalize_blockaligned
+
+	// Not block-aligned; 1 <= len <= 63 data bytes remain.  Pad the block.
+	// To do this, write the padding starting with the 0x80 byte to
+	// &sp[64].  Then for each message, copy the last 64 data bytes to sp
+	// and load from &sp[64 - len] to get the needed padding block.  This
+	// code relies on the data buffers being >= 64 bytes in length.
+	sub		w8, len, #64		// w8 = len - 64
+	add		data1, data1, w8, sxtw	// data1 += len - 64
+	add		data2, data2, w8, sxtw	// data2 += len - 64
+	mov		x9, 0x80
+	fmov		d16, x9
+	movi		v17.16b, #0
+	stp		q16, q17, [sp, #64]
+	stp		q17, q17, [sp, #96]
+	sub		x9, sp, w8, sxtw	// x9 = &sp[64 - len]
+	cmp		len, #56
+	b.ge		1f		// will count spill into its own block?
+	lsl		count, count, #3
+	rev		count, count
+	str		count, [x9, #56]
+	mov		final_step, #2	// won't need count-only block
+	b		2f
+1:
+	mov		final_step, #1	// will need count-only block
+2:
+	ld1		{v16.16b-v19.16b}, [data1]
+	st1		{v16.16b-v19.16b}, [sp]
+	ld1		{v16.4s-v19.4s}, [x9]
+	ld1		{v20.16b-v23.16b}, [data2]
+	st1		{v20.16b-v23.16b}, [sp]
+	ld1		{v20.4s-v23.4s}, [x9]
+	b		.Lfinup2x_loop_have_data
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
+	movi		v16.2d, #0
+	b		1f
+.Lfinup2x_finalize_blockaligned:
+	mov		x8, #0x80000000
+	fmov		d16, x8
+1:
+	movi		v17.2d, #0
+	movi		v18.2d, #0
+	ror		count, count, #29	// ror(lsl(count, 3), 32)
+	mov		v19.d[0], xzr
+	mov		v19.d[1], count
+	mov		v20.16b, v16.16b
+	movi		v21.2d, #0
+	movi		v22.2d, #0
+	mov		v23.16b, v19.16b
+	mov		final_step, #2
+	b		.Lfinup2x_loop_have_bswapped_data
+
+.Lfinup2x_done:
+	// Write the two digests with all bytes in the correct order.
+CPU_LE(	rev32		state0_a.16b, state0_a.16b	)
+CPU_LE(	rev32		state1_a.16b, state1_a.16b	)
+CPU_LE(	rev32		state0_b.16b, state0_b.16b	)
+CPU_LE(	rev32		state1_b.16b, state1_b.16b	)
+	st1		{state0_a.4s-state1_a.4s}, [out1]
+	st1		{state0_b.4s-state1_b.4s}, [out2]
+	add		sp, sp, #128
+	ret
+SYM_FUNC_END(__sha256_ce_finup2x)
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 0a44d2e7ee1f..c77d75395cc4 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -31,10 +31,15 @@ extern const u32 sha256_ce_offsetof_count;
 extern const u32 sha256_ce_offsetof_finalize;
 
 asmlinkage int __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
 				     int blocks);
 
+asmlinkage void __sha256_ce_finup2x(const struct sha256_state *sctx,
+				    const u8 *data1, const u8 *data2, int len,
+				    u8 out1[SHA256_DIGEST_SIZE],
+				    u8 out2[SHA256_DIGEST_SIZE]);
+
 static void sha256_ce_transform(struct sha256_state *sst, u8 const *src,
 				int blocks)
 {
 	while (blocks) {
 		int rem;
@@ -122,10 +127,45 @@ static int sha256_ce_digest(struct shash_desc *desc, const u8 *data,
 {
 	sha256_base_init(desc);
 	return sha256_ce_finup(desc, data, len, out);
 }
 
+static noinline_for_stack int
+sha256_finup2x_fallback(struct sha256_state *sctx, const u8 *data1,
+			const u8 *data2, unsigned int len, u8 *out1, u8 *out2)
+{
+	struct sha256_state sctx2 = *sctx;
+
+	sha256_update(sctx, data1, len);
+	sha256_final(sctx, out1);
+	sha256_update(&sctx2, data2, len);
+	sha256_final(&sctx2, out2);
+	return 0;
+}
+
+static int sha256_ce_finup2x(struct shash_desc *desc,
+			     const u8 *data1, const u8 *data2,
+			     unsigned int len, u8 *out1, u8 *out2)
+{
+	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
+
+	if (unlikely(!crypto_simd_usable() || len < SHA256_BLOCK_SIZE ||
+		     len > INT_MAX))
+		return sha256_finup2x_fallback(&sctx->sst, data1, data2, len,
+					       out1, out2);
+
+	/* __sha256_ce_finup2x() assumes the following offsets. */
+	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
+	BUILD_BUG_ON(offsetof(struct sha256_state, count) != 32);
+	BUILD_BUG_ON(offsetof(struct sha256_state, buf) != 40);
+
+	kernel_neon_begin();
+	__sha256_ce_finup2x(&sctx->sst, data1, data2, len, out1, out2);
+	kernel_neon_end();
+	return 0;
+}
+
 static int sha256_ce_export(struct shash_desc *desc, void *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
 	memcpy(out, &sctx->sst, sizeof(struct sha256_state));
@@ -162,10 +202,11 @@ static struct shash_alg algs[] = { {
 	.init			= sha256_base_init,
 	.update			= sha256_ce_update,
 	.final			= sha256_ce_final,
 	.finup			= sha256_ce_finup,
 	.digest			= sha256_ce_digest,
+	.finup2x		= sha256_ce_finup2x,
 	.export			= sha256_ce_export,
 	.import			= sha256_ce_import,
 	.descsize		= sizeof(struct sha256_ce_state),
 	.statesize		= sizeof(struct sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
-- 
2.44.0

