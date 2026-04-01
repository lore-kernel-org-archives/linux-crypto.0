Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEECC29408;
	Wed,  1 Apr 2026 00:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002069; cv=none; b=Kue69HaqIMZV9HenJO/ewkaorba9FBEhncLi8jtnfAasBqG5mlihves+yggtTjThkakdIAW8yZYHfGwHx2MPaM5XX5ZtrdNj7fzwAVr/NboSyYA8HrY4FYDUlcT3C56tO4VYWpP1vk31txzx1qulAImMgQZV9fZHXocZ8ReSRzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002069; c=relaxed/simple;
	bh=Xl+MsNWe1/r1+hTDGoE1qKiqas9gp7xrKlVQjVUdCyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYrMnwmBeGCqKNU8YzpqH1UAVs7v1RDmtipfrrOm5WETHu3ERODKntWslK+mC6EhHNXDu14mQs+kLetjaB6id3awy22jZ0ye71bN85vACZ+emt7NX+nqq9m6Ol2J0huS4B0AWfpTe4yI3zTl1XTZgWTAuwcDYJWpotKauYZCEZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHCmaKJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHCmaKJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D76C19423;
	Wed,  1 Apr 2026 00:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002069;
	bh=Xl+MsNWe1/r1+hTDGoE1qKiqas9gp7xrKlVQjVUdCyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHCmaKJnLmp8V/FAp6FPJYNBZjtGPcpCLhe/EPJAX/ErJ9mrsrR4bH+PtTECPSDQ7
	 VtVox40YNbtQ4mSLUgeDVtJzRU9/o5p/B2Ni9x0yb+l8aFFVJxKCV4OBF5FweuKeSU
	 A8JkWfVi+pFwRvLsBohwrVDy6MpSNBPL6kbmw5l/tZ+azQAGqCd+H2PYW1rG+hUEWY
	 VRWnz+dY56ME2qUUwYCFtOnsshwg86V5LCvEL+xQ5PeI5d6zVbbpEUZ4s3kWfhJnnU
	 k3Sh0vpSqpxN8F4rtoqlEUeBzbSnG72unkrZwYpF84hqfMMvnxfjbsmBhE/Xzjnw+8
	 UUHFjmaB5I3wQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/9] lib/crypto: arm64/gf128hash: Remove obsolete chunking logic
Date: Tue, 31 Mar 2026 17:05:42 -0700
Message-ID: <20260401000548.133151-4-ebiggers@kernel.org>
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

Simplify the GHASH and POLYVAL code accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm64/gf128hash.h | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/lib/crypto/arm64/gf128hash.h b/lib/crypto/arm64/gf128hash.h
index b2c85585b758..1d1179f87f8d 100644
--- a/lib/crypto/arm64/gf128hash.h
+++ b/lib/crypto/arm64/gf128hash.h
@@ -87,20 +87,12 @@ static void polyval_mul_arch(struct polyval_elem *acc,
 static void ghash_blocks_arch(struct polyval_elem *acc,
 			      const struct ghash_key *key,
 			      const u8 *data, size_t nblocks)
 {
 	if (static_branch_likely(&have_asimd) && may_use_simd()) {
-		do {
-			/* Allow rescheduling every 4 KiB. */
-			size_t n = min_t(size_t, nblocks,
-					 4096 / GHASH_BLOCK_SIZE);
-
-			scoped_ksimd()
-				pmull_ghash_update_p8(n, acc, data, &key->h);
-			data += n * GHASH_BLOCK_SIZE;
-			nblocks -= n;
-		} while (nblocks);
+		scoped_ksimd()
+			pmull_ghash_update_p8(nblocks, acc, data, &key->h);
 	} else {
 		ghash_blocks_generic(acc, &key->h, data, nblocks);
 	}
 }
 
@@ -108,20 +100,12 @@ static void ghash_blocks_arch(struct polyval_elem *acc,
 static void polyval_blocks_arch(struct polyval_elem *acc,
 				const struct polyval_key *key,
 				const u8 *data, size_t nblocks)
 {
 	if (static_branch_likely(&have_pmull) && may_use_simd()) {
-		do {
-			/* Allow rescheduling every 4 KiB. */
-			size_t n = min_t(size_t, nblocks,
-					 4096 / POLYVAL_BLOCK_SIZE);
-
-			scoped_ksimd()
-				polyval_blocks_pmull(acc, key, data, n);
-			data += n * POLYVAL_BLOCK_SIZE;
-			nblocks -= n;
-		} while (nblocks);
+		scoped_ksimd()
+			polyval_blocks_pmull(acc, key, data, nblocks);
 	} else {
 		polyval_blocks_generic(acc, &key->h_powers[NUM_H_POWERS - 1],
 				       data, nblocks);
 	}
 }
-- 
2.53.0

