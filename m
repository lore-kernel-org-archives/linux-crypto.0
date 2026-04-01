Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A3A1B7F4;
	Wed,  1 Apr 2026 00:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002069; cv=none; b=XJrv4SIxlWmDlonht4lnWYJmmj1izNOAA88yoWJI4+BlnorilsWJVjqRxOHjyZOT745J5by7XErEvoFDYZNEv8lGgozbXbL7YJC7cYFF5+J5WgiGyNgzB+jfDCSHe63+f9ke6JOgJzli1Zqc/eiSohXeMgq3VAdMm6dqMZBS8aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002069; c=relaxed/simple;
	bh=j3vg8XQEajSovL+s9UwD7AoOOlA0CLrK0i32Wlp9kDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZiTBGawfrNjHPlwnGJ1VkCMobb/MxqhlWGnvel6U4SqFW+yPR44jG5kHHFDoxpSpyHS5WlYKhrtntgn764onx+xxdjfHpRRBr/R2MTJGo/H0VIvZx7raQO9sCdeJohJK7/fLfDECH3rirDSpi6B3WcybAYxwv4NjMWHPb7bURo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlL9LCLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlL9LCLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1F0C2BCB1;
	Wed,  1 Apr 2026 00:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002069;
	bh=j3vg8XQEajSovL+s9UwD7AoOOlA0CLrK0i32Wlp9kDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlL9LCLqxyWcvhbtkZ+pUsJlNFKEdgIXGBUuGkbM8x5PWdMr//mGBvVTrMU7+PWJU
	 TG0/NYWkDnFcBJ0gn3kXWVNPvL94J9VpzT1QxSD3/axKGDwL+BSSkwsplfQU5rPOv7
	 xK2F97nl7PBY3wT5A45aJl7PQNLsCxkWUoSC+wO8QrWFW6uILXrhKnRJ9Nn//9GE2G
	 5IAA3JxG2A1qhIKUyrczQIrIZSYSFfSWQn+Hwq+RmeMEBCK6M0pupF7zk33iQFLxjG
	 U9zTcQnZXBmD/cAGJrfoR1VVZrVMn9hNGwGQ1v7YlHuUkieKEauI41PsUQUlFrKaWR
	 0BuA/tIEDGIkg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/9] lib/crypto: arm64/chacha: Remove obsolete chunking logic
Date: Tue, 31 Mar 2026 17:05:41 -0700
Message-ID: <20260401000548.133151-3-ebiggers@kernel.org>
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

Simplify the ChaCha code accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm64/chacha.h | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/lib/crypto/arm64/chacha.h b/lib/crypto/arm64/chacha.h
index ca8c6a8b0578..c6f8ddf98e2d 100644
--- a/lib/crypto/arm64/chacha.h
+++ b/lib/crypto/arm64/chacha.h
@@ -34,13 +34,13 @@ asmlinkage void hchacha_block_neon(const struct chacha_state *state,
 				   u32 out[HCHACHA_OUT_WORDS], int nrounds);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 static void chacha_doneon(struct chacha_state *state, u8 *dst, const u8 *src,
-			  int bytes, int nrounds)
+			  unsigned int bytes, int nrounds)
 {
-	while (bytes > 0) {
+	while (bytes) {
 		int l = min(bytes, CHACHA_BLOCK_SIZE * 5);
 
 		if (l <= CHACHA_BLOCK_SIZE) {
 			u8 buf[CHACHA_BLOCK_SIZE];
 
@@ -74,20 +74,12 @@ static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
 {
 	if (!static_branch_likely(&have_neon) || bytes <= CHACHA_BLOCK_SIZE ||
 	    !crypto_simd_usable())
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
-	do {
-		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
-
-		scoped_ksimd()
-			chacha_doneon(state, dst, src, todo, nrounds);
-
-		bytes -= todo;
-		src += todo;
-		dst += todo;
-	} while (bytes);
+	scoped_ksimd()
+		chacha_doneon(state, dst, src, bytes, nrounds);
 }
 
 #define chacha_mod_init_arch chacha_mod_init_arch
 static void chacha_mod_init_arch(void)
 {
-- 
2.53.0

