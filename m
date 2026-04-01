Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F6617A586;
	Wed,  1 Apr 2026 00:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002071; cv=none; b=ARtq3mBk6X8QSSS1NIiWNWagK08zbOHQfQfx6IgmfjRHHAjLXg5FU8AiPP2iIo/8YNvkMM/XKEPs7i9geIsMk4XETulJBntWQpe7Hv6AJZon+FZvfjWWpAObncR1jzCLRApv/P+ACoq+1nEojQdI5ICEhu2M3zZCmgvPY18PxqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002071; c=relaxed/simple;
	bh=CAC+qe7Z/7a3GD63JAT9HC8eCyiKaVWZzQ/HUGxe4cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyeRdH2dBLF/iGWVO83Qt0W+gLYtGXwc1ALem1tkXfwnmZUyRQUBUNrLKaE1fGNUaIEO6oUQfgNUn5Nz56xWE2VSfwIKbNVBgPTeW1NERbSEp35O2u9wnasEYV2WEX9xKS7yMQ8KO+6XKaxUe6j5L6RLxQs0P7FUYUwRna1bELI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZ9K754L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZ9K754L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FBBC2BCB0;
	Wed,  1 Apr 2026 00:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002071;
	bh=CAC+qe7Z/7a3GD63JAT9HC8eCyiKaVWZzQ/HUGxe4cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZ9K754Lb9Mn8acJgg8xXygVIgFVgCsEu0WSKlrDoqPc+oJmZADyrnyGot+A4tQYL
	 e6FIk6AaPSQLKatwj5hdQuC/e7vptVT2X94JvAi95l8BZOMa4ab82cvrhlhC3DHEZl
	 waBKkLqjrt94Snwpxm3GMEKnAIb1+RzO9GJztMwQGaSXK23XMgqPsXeFd6VWst/DC4
	 Txi+ECzcEPZg33nWyU7fl3ybs6mzWdrFdLvSmhcL+++lWYtXaksOKTv/WYMe7T+yj4
	 CYykjpmjrcSOZL2v0B2jJsjrVkWG3dSGOTyGeNiCTOakRuf5qnURmOOkqc4GmQU1nY
	 1hcjJRa8UULoA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7/9] lib/crypto: arm64/sha512: Remove obsolete chunking logic
Date: Tue, 31 Mar 2026 17:05:46 -0700
Message-ID: <20260401000548.133151-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401000548.133151-1-ebiggers@kernel.org>
References: <20260401000548.133151-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit aefbab8e77eb ("arm64: fpsimd: Preserve/restore kernel mode
NEON at context switch"), kernel-mode NEON sections have been
preemptible on arm64.  And since commit 7dadeaa6e851 ("sched: Further
restrict the preemption modes"), voluntary preemption is no longer
supported on arm64 either.  Therefore, there's no longer any need to
limit the length of kernel-mode NEON sections on arm64.

Simplify the SHA-512 code accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm64/sha512-ce-core.S | 12 +++++-------
 lib/crypto/arm64/sha512.h         | 15 ++++-----------
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-ce-core.S
index ffd51acfd1ee..26834921e8d6 100644
--- a/lib/crypto/arm64/sha512-ce-core.S
+++ b/lib/crypto/arm64/sha512-ce-core.S
@@ -91,15 +91,15 @@
 	add		v\i4\().2d, v\i1\().2d, v\i3\().2d
 	sha512h2	q\i3, q\i1, v\i0\().2d
 	.endm
 
 	/*
-	 * size_t __sha512_ce_transform(struct sha512_block_state *state,
-	 *				const u8 *data, size_t nblocks);
+	 * void sha512_ce_transform(struct sha512_block_state *state,
+	 *			    const u8 *data, size_t nblocks);
 	 */
 	.text
-SYM_FUNC_START(__sha512_ce_transform)
+SYM_FUNC_START(sha512_ce_transform)
 	/* load state */
 	ld1		{v8.2d-v11.2d}, [x0]
 
 	/* load first 4 round constants */
 	adr_l		x3, .Lsha512_rcon
@@ -184,14 +184,12 @@ CPU_LE(	rev64		v19.16b, v19.16b	)
 	add		v8.2d, v8.2d, v0.2d
 	add		v9.2d, v9.2d, v1.2d
 	add		v10.2d, v10.2d, v2.2d
 	add		v11.2d, v11.2d, v3.2d
 
-	cond_yield	3f, x4, x5
 	/* handled all input blocks? */
 	cbnz		x2, 0b
 
 	/* store new state */
-3:	st1		{v8.2d-v11.2d}, [x0]
-	mov		x0, x2
+	st1		{v8.2d-v11.2d}, [x0]
 	ret
-SYM_FUNC_END(__sha512_ce_transform)
+SYM_FUNC_END(sha512_ce_transform)
diff --git a/lib/crypto/arm64/sha512.h b/lib/crypto/arm64/sha512.h
index d978c4d07e90..5da27e6e23ea 100644
--- a/lib/crypto/arm64/sha512.h
+++ b/lib/crypto/arm64/sha512.h
@@ -10,27 +10,20 @@
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha512_insns);
 
 asmlinkage void sha512_block_data_order(struct sha512_block_state *state,
 					const u8 *data, size_t nblocks);
-asmlinkage size_t __sha512_ce_transform(struct sha512_block_state *state,
-					const u8 *data, size_t nblocks);
+asmlinkage void sha512_ce_transform(struct sha512_block_state *state,
+				    const u8 *data, size_t nblocks);
 
 static void sha512_blocks(struct sha512_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	if (static_branch_likely(&have_sha512_insns) &&
 	    likely(may_use_simd())) {
-		do {
-			size_t rem;
-
-			scoped_ksimd()
-				rem = __sha512_ce_transform(state, data, nblocks);
-
-			data += (nblocks - rem) * SHA512_BLOCK_SIZE;
-			nblocks = rem;
-		} while (nblocks);
+		scoped_ksimd()
+			sha512_ce_transform(state, data, nblocks);
 	} else {
 		sha512_block_data_order(state, data, nblocks);
 	}
 }
 
-- 
2.53.0

