Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2274520F098;
	Fri, 18 Jul 2025 19:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752866403; cv=none; b=gDWyQPRyhr6xtQxE75c6NoKUSTCJmQ5AxgLwTPgPtJpnou+ezHWT6iiHyQhe2Mk8fJULH3+3PxMDtJ/zYNHklDU8fwNftA1KAi9OsWH+TxzBXbnbJWK5xgaWOlx03gRStIifAQ87QZkHseZBmv1zig/8UMU4ogJZv7306sPKO+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752866403; c=relaxed/simple;
	bh=tqbHNuzT5yP389d31CenPRZuzKHAZqST8zpA2sincno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjQNuYLQTPXLy15Ryo/rzM1ys/CpZfEG5/BDCHQE4W0ZoAGg+lh0G13d42tC7L9LLEW3zugsAql3KL9LVD2VXbrtt+cdGvHstbsr61y4GDlIUHYQFIxzKQaHgXfjVxw+QSyay7XkeHVqkMTAmdEq4/Vq2TLj5MT0qpTfQEz1l7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLctTnl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLctTnl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB33C4CEF6;
	Fri, 18 Jul 2025 19:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752866402;
	bh=tqbHNuzT5yP389d31CenPRZuzKHAZqST8zpA2sincno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLctTnl/VJIxu7ShtQqpiAm0MNC0yItzgToWhzuoF966otVQc0YNRa/BNKEsiP+gq
	 8MoEnfvs/oF8bC9QbmyqjAjg31WKoqeRlHt7e2yNQoXixDWGKGFeVRq5m8ij5hLzOG
	 mxNXCQ2NEuDys38xZtnmavu0LcgnFf2kkgWw2Uqsz9kgFofXVWsxcfsXtwN1QY5MtU
	 iv+jro7pejYmaaBJHVmByZ0mpe1EILeZ7EaYeYWiGaOFqx0HRKYAa6DvpNYiyulEBN
	 ZUEXBIywOLbJYZdA+bnj7XKHnjtj+mUjIjXFaY51RDQkilpC4mD9Ys7gb8KC39oLaj
	 eMaeWXm89/Adg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] lib/crypto: x86/sha1-ni: Convert to use rounds macros
Date: Fri, 18 Jul 2025 12:19:00 -0700
Message-ID: <20250718191900.42877-3-ebiggers@kernel.org>
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

The assembly code that does all 80 rounds of SHA-1 is highly repetitive.
Replace it with 20 expansions of a macro that does 4 rounds, using the
macro arguments and .if directives to handle the slight variations
between rounds.  This reduces the length of sha1-ni-asm.S by 129 lines
while still producing the exact same object file.  This mirrors
sha256-ni-asm.S which uses this same strategy.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha1-ni-asm.S | 187 ++++++-----------------------------
 1 file changed, 29 insertions(+), 158 deletions(-)

diff --git a/lib/crypto/x86/sha1-ni-asm.S b/lib/crypto/x86/sha1-ni-asm.S
index 1d08b2f364ce7..428f9b9605943 100644
--- a/lib/crypto/x86/sha1-ni-asm.S
+++ b/lib/crypto/x86/sha1-ni-asm.S
@@ -68,23 +68,43 @@
 #define MSG3		%xmm6
 #define SHUF_MASK	%xmm7
 #define ABCD_SAVED	%xmm8
 #define E0_SAVED	%xmm9
 
+.macro do_4rounds	i, m0, m1, m2, m3, e0, e1
+.if \i < 16
+	movdqu		\i*4(DATA_PTR), \m0
+	pshufb		SHUF_MASK, \m0
+.endif
+.if \i == 0
+	paddd		\m0, \e0
+.else
+	sha1nexte	\m0, \e0
+.endif
+	movdqa		ABCD, \e1
+.if \i >= 12 && \i < 76
+	sha1msg2	\m0, \m1
+.endif
+	sha1rnds4	$\i / 20, \e0, ABCD
+.if \i >= 4 && \i < 68
+	sha1msg1	\m0, \m3
+.endif
+.if \i >= 8 && \i < 72
+	pxor		\m0, \m2
+.endif
+.endm
+
 /*
  * Intel SHA Extensions optimized implementation of a SHA-1 block function
  *
  * This function takes a pointer to the current SHA-1 state, a pointer to the
  * input data, and the number of 64-byte blocks to process.  The number of
  * blocks to process is assumed to be nonzero.  Once all blocks have been
  * processed, the state is updated with the new state.  This function only
  * processes complete blocks.  State initialization, buffering of partial
  * blocks, and digest finalization are expected to be handled elsewhere.
  *
- * The indented lines in the loop are instructions related to rounds processing.
- * The non-indented lines are instructions related to the message schedule.
- *
  * void sha1_ni_transform(struct sha1_block_state *state,
  *			  const u8 *data, size_t nblocks)
  */
 .text
 SYM_FUNC_START(sha1_ni_transform)
@@ -100,165 +120,16 @@ SYM_FUNC_START(sha1_ni_transform)
 .Lnext_block:
 	/* Save the state for addition after the rounds. */
 	movdqa		E0, E0_SAVED
 	movdqa		ABCD, ABCD_SAVED
 
-	/* Rounds 0-3 */
-	movdqu		0*16(DATA_PTR), MSG0
-	pshufb		SHUF_MASK, MSG0
-		paddd		MSG0, E0
-		movdqa		ABCD, E1
-		sha1rnds4	$0, E0, ABCD
-
-	/* Rounds 4-7 */
-	movdqu		1*16(DATA_PTR), MSG1
-	pshufb		SHUF_MASK, MSG1
-		sha1nexte	MSG1, E1
-		movdqa		ABCD, E0
-		sha1rnds4	$0, E1, ABCD
-	sha1msg1	MSG1, MSG0
-
-	/* Rounds 8-11 */
-	movdqu		2*16(DATA_PTR), MSG2
-	pshufb		SHUF_MASK, MSG2
-		sha1nexte	MSG2, E0
-		movdqa		ABCD, E1
-		sha1rnds4	$0, E0, ABCD
-	sha1msg1	MSG2, MSG1
-	pxor		MSG2, MSG0
-
-	/* Rounds 12-15 */
-	movdqu		3*16(DATA_PTR), MSG3
-	pshufb		SHUF_MASK, MSG3
-		sha1nexte	MSG3, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG3, MSG0
-		sha1rnds4	$0, E1, ABCD
-	sha1msg1	MSG3, MSG2
-	pxor		MSG3, MSG1
-
-	/* Rounds 16-19 */
-		sha1nexte	MSG0, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG0, MSG1
-		sha1rnds4	$0, E0, ABCD
-	sha1msg1	MSG0, MSG3
-	pxor		MSG0, MSG2
-
-	/* Rounds 20-23 */
-		sha1nexte	MSG1, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG1, MSG2
-		sha1rnds4	$1, E1, ABCD
-	sha1msg1	MSG1, MSG0
-	pxor		MSG1, MSG3
-
-	/* Rounds 24-27 */
-		sha1nexte	MSG2, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG2, MSG3
-		sha1rnds4	$1, E0, ABCD
-	sha1msg1	MSG2, MSG1
-	pxor		MSG2, MSG0
-
-	/* Rounds 28-31 */
-		sha1nexte	MSG3, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG3, MSG0
-		sha1rnds4	$1, E1, ABCD
-	sha1msg1	MSG3, MSG2
-	pxor		MSG3, MSG1
-
-	/* Rounds 32-35 */
-		sha1nexte	MSG0, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG0, MSG1
-		sha1rnds4	$1, E0, ABCD
-	sha1msg1	MSG0, MSG3
-	pxor		MSG0, MSG2
-
-	/* Rounds 36-39 */
-		sha1nexte	MSG1, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG1, MSG2
-		sha1rnds4	$1, E1, ABCD
-	sha1msg1	MSG1, MSG0
-	pxor		MSG1, MSG3
-
-	/* Rounds 40-43 */
-		sha1nexte	MSG2, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG2, MSG3
-		sha1rnds4	$2, E0, ABCD
-	sha1msg1	MSG2, MSG1
-	pxor		MSG2, MSG0
-
-	/* Rounds 44-47 */
-		sha1nexte	MSG3, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG3, MSG0
-		sha1rnds4	$2, E1, ABCD
-	sha1msg1	MSG3, MSG2
-	pxor		MSG3, MSG1
-
-	/* Rounds 48-51 */
-		sha1nexte	MSG0, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG0, MSG1
-		sha1rnds4	$2, E0, ABCD
-	sha1msg1	MSG0, MSG3
-	pxor		MSG0, MSG2
-
-	/* Rounds 52-55 */
-		sha1nexte	MSG1, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG1, MSG2
-		sha1rnds4	$2, E1, ABCD
-	sha1msg1	MSG1, MSG0
-	pxor		MSG1, MSG3
-
-	/* Rounds 56-59 */
-		sha1nexte	MSG2, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG2, MSG3
-		sha1rnds4	$2, E0, ABCD
-	sha1msg1	MSG2, MSG1
-	pxor		MSG2, MSG0
-
-	/* Rounds 60-63 */
-		sha1nexte	MSG3, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG3, MSG0
-		sha1rnds4	$3, E1, ABCD
-	sha1msg1	MSG3, MSG2
-	pxor		MSG3, MSG1
-
-	/* Rounds 64-67 */
-		sha1nexte	MSG0, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG0, MSG1
-		sha1rnds4	$3, E0, ABCD
-	sha1msg1	MSG0, MSG3
-	pxor		MSG0, MSG2
-
-	/* Rounds 68-71 */
-		sha1nexte	MSG1, E1
-		movdqa		ABCD, E0
-	sha1msg2	MSG1, MSG2
-		sha1rnds4	$3, E1, ABCD
-	pxor		MSG1, MSG3
-
-	/* Rounds 72-75 */
-		sha1nexte	MSG2, E0
-		movdqa		ABCD, E1
-	sha1msg2	MSG2, MSG3
-		sha1rnds4	$3, E0, ABCD
-
-	/* Rounds 76-79 */
-		sha1nexte	MSG3, E1
-		movdqa		ABCD, E0
-		sha1rnds4	$3, E1, ABCD
+.irp i, 0, 16, 32, 48, 64
+	do_4rounds	(\i + 0),  MSG0, MSG1, MSG2, MSG3, E0, E1
+	do_4rounds	(\i + 4),  MSG1, MSG2, MSG3, MSG0, E1, E0
+	do_4rounds	(\i + 8),  MSG2, MSG3, MSG0, MSG1, E0, E1
+	do_4rounds	(\i + 12), MSG3, MSG0, MSG1, MSG2, E1, E0
+.endr
 
 	/* Add the previous state (before the rounds) to the current state. */
 	sha1nexte	E0_SAVED, E0
 	paddd		ABCD_SAVED, ABCD
 
-- 
2.50.1

