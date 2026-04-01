Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F9319AD5C;
	Wed,  1 Apr 2026 00:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002072; cv=none; b=QSHY7faLhHJmqS7+TcLVlFLGXKpjs6t62ABK3hRfhED/Ky0HkmWfNzKwJLznuXu7Yw5fgy7Q/FsOxtiRmNkS941BN58aDtHMnC7EMKisFpEQidOT66bK5O77nJUmZgRlBlXI1WAc7A3MpJ3B8H0JUpuTsIlW7p5L3iDDX8Uqc/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002072; c=relaxed/simple;
	bh=07ofvOpbjy7Rvwy7/y+ptg/LOHhp6n7ORQdHYjZws/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCVpgaKO/QRGRrnA/R3rh9YhUBtvUMs161a4zYohPOye9zSSDP1apbZPXc0tKZhWAC3W6FDyVFqwOn847eIMhOCmZ0Av6xUoKdgszyXXEnSWEJ7pr5Ml0UzCpJ3YlLvlKsIYyFzmcZeee4xWQMBgMvMNoxbHpJQaNBM230Xf1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCTICZVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCTICZVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE63C19423;
	Wed,  1 Apr 2026 00:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002071;
	bh=07ofvOpbjy7Rvwy7/y+ptg/LOHhp6n7ORQdHYjZws/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCTICZVm5Xek9G7SrzaQRLeTtYiCK2S8jTgni2L9zEre5E/hNHHe0G0r5BKyKKsBQ
	 8su2oWId/cDBZrb8PihZ4wlC4Ac+nRiCWw+1LxhfViVGIWYY1icoXdLeqVK3g+FkBk
	 P0yrqKIyWvZVB8mGQ8DuE8EOCmCScQnIMzOziVA5frx4YczjVAvnFFBFKpWfLTG023
	 q8TcH0TbNobEHDIDB7Z+twjZCqMhogkSVZVDaYZqQogaimEHgJSgQlca67UfaVop4t
	 8fDcs/RlYsUuhCvb4Az988H0Ee8WzbBZ1vMFIVv6Me66kbvftzVGlnqUEvK2SQGZys
	 raP8llq4AjL+Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 8/9] lib/crypto: arm64/sha3: Remove obsolete chunking logic
Date: Tue, 31 Mar 2026 17:05:47 -0700
Message-ID: <20260401000548.133151-9-ebiggers@kernel.org>
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

Simplify the SHA-3 code accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm64/sha3-ce-core.S |  8 +++-----
 lib/crypto/arm64/sha3.h         | 15 ++++-----------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/lib/crypto/arm64/sha3-ce-core.S b/lib/crypto/arm64/sha3-ce-core.S
index ace90b506490..b8ab01987ae0 100644
--- a/lib/crypto/arm64/sha3-ce-core.S
+++ b/lib/crypto/arm64/sha3-ce-core.S
@@ -35,12 +35,12 @@
 	.macro	xar, rd, rn, rm, imm6
 	.inst	0xce800000 | .L\rd | (.L\rn << 5) | ((\imm6) << 10) | (.L\rm << 16)
 	.endm
 
 	/*
-	 * size_t sha3_ce_transform(struct sha3_state *state, const u8 *data,
-	 *			    size_t nblocks, size_t block_size)
+	 * void sha3_ce_transform(struct sha3_state *state, const u8 *data,
+	 *			  size_t nblocks, size_t block_size)
 	 *
 	 * block_size is assumed to be one of 72 (SHA3-512), 104 (SHA3-384), 136
 	 * (SHA3-256 and SHAKE256), 144 (SHA3-224), or 168 (SHAKE128).
 	 */
 	.text
@@ -183,22 +183,20 @@ SYM_FUNC_START(sha3_ce_transform)
 	bcax	 v2.16b,  v2.16b, v28.16b, v27.16b
 
 	eor	 v0.16b,  v0.16b, v31.16b
 
 	cbnz	w8, 3b
-	cond_yield 4f, x8, x9
 	cbnz	x2, 0b
 
 	/* save state */
-4:	st1	{ v0.1d- v3.1d}, [x0], #32
+	st1	{ v0.1d- v3.1d}, [x0], #32
 	st1	{ v4.1d- v7.1d}, [x0], #32
 	st1	{ v8.1d-v11.1d}, [x0], #32
 	st1	{v12.1d-v15.1d}, [x0], #32
 	st1	{v16.1d-v19.1d}, [x0], #32
 	st1	{v20.1d-v23.1d}, [x0], #32
 	st1	{v24.1d}, [x0]
-	mov	x0, x2
 	ret
 SYM_FUNC_END(sha3_ce_transform)
 
 	.section	".rodata", "a"
 	.align		8
diff --git a/lib/crypto/arm64/sha3.h b/lib/crypto/arm64/sha3.h
index b602f1b3b282..eaaba3224acc 100644
--- a/lib/crypto/arm64/sha3.h
+++ b/lib/crypto/arm64/sha3.h
@@ -10,26 +10,19 @@
 #include <asm/simd.h>
 #include <linux/cpufeature.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha3);
 
-asmlinkage size_t sha3_ce_transform(struct sha3_state *state, const u8 *data,
-				    size_t nblocks, size_t block_size);
+asmlinkage void sha3_ce_transform(struct sha3_state *state, const u8 *data,
+				  size_t nblocks, size_t block_size);
 
 static void sha3_absorb_blocks(struct sha3_state *state, const u8 *data,
 			       size_t nblocks, size_t block_size)
 {
 	if (static_branch_likely(&have_sha3) && likely(may_use_simd())) {
-		do {
-			size_t rem;
-
-			scoped_ksimd()
-				rem = sha3_ce_transform(state, data, nblocks,
-							block_size);
-			data += (nblocks - rem) * block_size;
-			nblocks = rem;
-		} while (nblocks);
+		scoped_ksimd()
+			sha3_ce_transform(state, data, nblocks, block_size);
 	} else {
 		sha3_absorb_blocks_generic(state, data, nblocks, block_size);
 	}
 }
 
-- 
2.53.0

