Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE882BDC17;
	Sun,  6 Jul 2025 23:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751843506; cv=none; b=b1ErLvYUokt/t4jA8wQww5G5aVrCqtVU01yrI3SIx9l9RK2/0NmRPLuZ2Z3EIdSxC5ZqqnjjGG/dzNUpcsUMFEi1UuyyeqmFsJZMK2X4hi8SYgQ2mCH9s2Csdzna/c4PafIG/yq7loIUbpeB56W1SZXM/pt2wWDMaSMrW33Ohcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751843506; c=relaxed/simple;
	bh=bKAMxj63gaupN/jPkfJEbmvoMQTv+UmI9WM2d0qO3mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od2n2KYu8wCxhyvO5buU8olJ/S3vy/3a87DqIZW5EQ81v3E1Eq0YyuQox2OH/ScqTCgE5y6MfE82GzQQ1a13mty0jMacqhT7gmvy0zULBjRCNd7g8paMqnnyHbJlBNxu6FcXYOf56OMtXwJvO948GyF4DK0bLOdLdnGNr0y9Lwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzVCEDK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzVCEDK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684A0C4CEF3;
	Sun,  6 Jul 2025 23:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751843506;
	bh=bKAMxj63gaupN/jPkfJEbmvoMQTv+UmI9WM2d0qO3mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzVCEDK5NF34GmUsnPaUCZvX2iUQTpQOn313UltFqgaO2/uvwdrNURrbDQOejBenw
	 NQ32GzxatZ9iOSvjGKBCRDp1TLey1lsIfGY5lKzKqJgT3S7kVlkXVZQPMQmOHvjJl3
	 I6AoDiKgHxSVwb1UOXqNFi0JvVUjbvM9SdC+l3h84glZKhKD+f7F4CE8QX0JaJUMBY
	 K8XHCTU/9F/lzXZ7zrzaawXsmFWrt9mn9UQ5EiESrSOwY8erVhCQKkD+wXmYxOgxNZ
	 FXZDepSXX+MOy1aaEtASkDz/hjoqWd8x6aRVT8RzlH9UP99hCuNei9cp5+53WrXyxL
	 D+NwPULFu5UAg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 4/5] lib/crypto: x86/poly1305: Fix register corruption in no-SIMD contexts
Date: Sun,  6 Jul 2025 16:10:59 -0700
Message-ID: <20250706231100.176113-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250706231100.176113-1-ebiggers@kernel.org>
References: <20250706231100.176113-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore the SIMD usability check and base conversion that were removed
by commit 318c53ae02f2 ("crypto: x86/poly1305 - Add block-only
interface").

This safety check is cheap and is well worth eliminating a footgun.
While the Poly1305 functions *should* be called only where SIMD
registers are usable, if they are anyway, they should just do the right
thing instead of corrupting random tasks' registers and/or computing
incorrect MACs.  Fixing this is also needed for poly1305_kunit to pass.

Just use irq_fpu_usable() instead of the original crypto_simd_usable(),
since poly1305_kunit won't rely on crypto_simd_disabled_for_test.

Fixes: 318c53ae02f2 ("crypto: x86/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/poly1305_glue.c | 40 +++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/x86/poly1305_glue.c b/lib/crypto/x86/poly1305_glue.c
index b7e78a583e07..968d84677631 100644
--- a/lib/crypto/x86/poly1305_glue.c
+++ b/lib/crypto/x86/poly1305_glue.c
@@ -23,10 +23,46 @@ struct poly1305_arch_internal {
 	u64 r[2];
 	u64 pad;
 	struct { u32 r2, r1, r4, r3; } rn[9];
 };
 
+/*
+ * The AVX code uses base 2^26, while the scalar code uses base 2^64. If we hit
+ * the unfortunate situation of using AVX and then having to go back to scalar
+ * -- because the user is silly and has called the update function from two
+ * separate contexts -- then we need to convert back to the original base before
+ * proceeding. It is possible to reason that the initial reduction below is
+ * sufficient given the implementation invariants. However, for an avoidance of
+ * doubt and because this is not performance critical, we do the full reduction
+ * anyway. Z3 proof of below function: https://xn--4db.cc/ltPtHCKN/py
+ */
+static void convert_to_base2_64(void *ctx)
+{
+	struct poly1305_arch_internal *state = ctx;
+	u32 cy;
+
+	if (!state->is_base2_26)
+		return;
+
+	cy = state->h[0] >> 26; state->h[0] &= 0x3ffffff; state->h[1] += cy;
+	cy = state->h[1] >> 26; state->h[1] &= 0x3ffffff; state->h[2] += cy;
+	cy = state->h[2] >> 26; state->h[2] &= 0x3ffffff; state->h[3] += cy;
+	cy = state->h[3] >> 26; state->h[3] &= 0x3ffffff; state->h[4] += cy;
+	state->hs[0] = ((u64)state->h[2] << 52) | ((u64)state->h[1] << 26) | state->h[0];
+	state->hs[1] = ((u64)state->h[4] << 40) | ((u64)state->h[3] << 14) | (state->h[2] >> 12);
+	state->hs[2] = state->h[4] >> 24;
+	/* Unsigned Less Than: branchlessly produces 1 if a < b, else 0. */
+#define ULT(a, b) ((a ^ ((a ^ b) | ((a - b) ^ b))) >> (sizeof(a) * 8 - 1))
+	cy = (state->hs[2] >> 2) + (state->hs[2] & ~3ULL);
+	state->hs[2] &= 3;
+	state->hs[0] += cy;
+	state->hs[1] += (cy = ULT(state->hs[0], cy));
+	state->hs[2] += ULT(state->hs[1], cy);
+#undef ULT
+	state->is_base2_26 = 0;
+}
+
 asmlinkage void poly1305_block_init_arch(
 	struct poly1305_block_state *state,
 	const u8 raw_key[POLY1305_BLOCK_SIZE]);
 EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
 asmlinkage void poly1305_blocks_x86_64(struct poly1305_arch_internal *ctx,
@@ -60,11 +96,13 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *inp,
 
 	/* SIMD disables preemption, so relax after processing each page. */
 	BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
 		     SZ_4K % POLY1305_BLOCK_SIZE);
 
-	if (!static_branch_likely(&poly1305_use_avx)) {
+	if (!static_branch_likely(&poly1305_use_avx) ||
+	    unlikely(!irq_fpu_usable())) {
+		convert_to_base2_64(ctx);
 		poly1305_blocks_x86_64(ctx, inp, len, padbit);
 		return;
 	}
 
 	do {
-- 
2.50.0

