Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA23C3789;
	Tue,  1 Sep 2026 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274696; cv=none; b=UvFgwx+y2Ro19Ub6yEZWr2EYOzO0uf4cZMlmSygzbMUtdm5RYMFwgGxIhlAus8itoBo2Cbc3oDl0cURo5VqXAcLpGuVP3mDG8JpLJhhMG5Ol+5fdlJ6D1GY6AxUc7eZck9zr2Wev61fvM/RmAAbCILgXYDhiKjua04s1Tkz4m0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274696; c=relaxed/simple;
	bh=e0/5EyKvRR38AkedRTxpFtVqo23cOjcvx5sQexInGDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEzK71QLnUWhIbQhahgMlBrSv67jAiQfkr9InofBVoKEBaSTEW5X6Xx140qIA2JENj8na/MNh6inviYrKw35L7gypDFOVS4m5arGOfiIiS0qpvdaaydjwGrwkbagq0p2eeDUFW99ozFZwgr+gmYlndvTsAenjH7QUxJjwJTwCFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdUkd4qI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdUkd4qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3671F00ACA;
	Tue,  1 Sep 2026 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274694;
	bh=DdqWq0+mPRqIC9aeO4PAgts2wuJAHghXz/rr2+6DDJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdUkd4qI1dN9Ut6fdtoqtGveQA4rWJtp8L5fQwXWpRW9MrbcxDxKHc/kCGp9Vqk8i
	 vQREACmTP3DT6zLtbDBbj/BUliDgZ+KywMEiu15ZpOoxWaFPZJabsjy2Ur7s8qNDyr
	 Jbb0CDn0lZ5wM8mneU30hhyJHk8TakKyBbTpB2zLUZQJYPxmes/NTWHk+FwYui9oOq
	 sg7AauP0fGBQsx9+1eUv4Cjw4c+L9uMYzuxbjnEA7s1boKMdusih7K0VH2JpqIgnbl
	 /bqoqOYoNXk2lespVepAPgOe/du7hngHIP4aEebxU4QFBIyqCw1LVEOChZ+6jrHSiK
	 l6RWQSp/Rn4zg==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 4/8] lib/crypto: x86: Stop using cpu_has_xfeatures()
Date: Tue,  1 Sep 2026 07:57:36 -0700
Message-ID: <20260901145740.42337-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901145740.42337-1-ebiggers@kernel.org>
References: <20260901145740.42337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Checking both boot_cpu_has() and cpu_has_xfeatures() has never really
been needed in practice, and it's never been universally done (e.g.,
lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both x86 and UML
now explicitly clear the AVX and AVX-512 flags if their xfeatures are
missing, which should remove any remaining doubts.

Thus, remove all the calls to cpu_has_xfeatures().

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s.h  | 4 +---
 lib/crypto/x86/chacha.h   | 3 +--
 lib/crypto/x86/nh.h       | 4 +---
 lib/crypto/x86/poly1305.h | 7 ++-----
 lib/crypto/x86/sha1.h     | 4 +---
 lib/crypto/x86/sha256.h   | 4 +---
 lib/crypto/x86/sha512.h   | 3 +--
 lib/crypto/x86/sm3.h      | 3 +--
 8 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/lib/crypto/x86/blake2s.h b/lib/crypto/x86/blake2s.h
index f8eed6cb042e..0f7c51f055c8 100644
--- a/lib/crypto/x86/blake2s.h
+++ b/lib/crypto/x86/blake2s.h
@@ -55,8 +55,6 @@ static void blake2s_mod_init_arch(void)
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
 	    boot_cpu_has(X86_FEATURE_AVX2) &&
 	    boot_cpu_has(X86_FEATURE_AVX512F) &&
-	    boot_cpu_has(X86_FEATURE_AVX512VL) &&
-	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
-			      XFEATURE_MASK_AVX512, NULL))
+	    boot_cpu_has(X86_FEATURE_AVX512VL))
 		static_branch_enable(&blake2s_use_avx512);
 }
diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index 10cf8f1c569d..c79562aac56b 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -165,8 +165,7 @@ static void chacha_mod_init_arch(void)
 	static_branch_enable(&chacha_use_simd);
 
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_AVX2) &&
-	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
+	    boot_cpu_has(X86_FEATURE_AVX2)) {
 		static_branch_enable(&chacha_use_avx2);
 
 		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
diff --git a/lib/crypto/x86/nh.h b/lib/crypto/x86/nh.h
index 83361c2e9783..342636dcb750 100644
--- a/lib/crypto/x86/nh.h
+++ b/lib/crypto/x86/nh.h
@@ -37,9 +37,7 @@ static void nh_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_XMM2)) {
 		static_branch_enable(&have_sse2);
-		if (boot_cpu_has(X86_FEATURE_AVX2) &&
-		    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				      NULL))
+		if (boot_cpu_has(X86_FEATURE_AVX2))
 			static_branch_enable(&have_avx2);
 	}
 }
diff --git a/lib/crypto/x86/poly1305.h b/lib/crypto/x86/poly1305.h
index ee92e3740a78..b061b9926fa5 100644
--- a/lib/crypto/x86/poly1305.h
+++ b/lib/crypto/x86/poly1305.h
@@ -143,15 +143,12 @@ static void poly1305_emit(const struct poly1305_state *ctx,
 #define poly1305_mod_init_arch poly1305_mod_init_arch
 static void poly1305_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+	if (boot_cpu_has(X86_FEATURE_AVX))
 		static_branch_enable(&poly1305_use_avx);
-	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2) &&
-	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2))
 		static_branch_enable(&poly1305_use_avx2);
 	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2) &&
 	    boot_cpu_has(X86_FEATURE_AVX512F) &&
-	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, NULL) &&
 	    /* Skylake downclocks unacceptably much when using zmm, but later generations are fast. */
 	    boot_cpu_data.x86_vfm != INTEL_SKYLAKE_X)
 		static_branch_enable(&poly1305_use_avx512);
diff --git a/lib/crypto/x86/sha1.h b/lib/crypto/x86/sha1.h
index c48a0131fd12..6aff433466e7 100644
--- a/lib/crypto/x86/sha1.h
+++ b/lib/crypto/x86/sha1.h
@@ -59,9 +59,7 @@ static void sha1_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
 		static_call_update(sha1_blocks_x86, sha1_blocks_ni);
-	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				     NULL) &&
-		   boot_cpu_has(X86_FEATURE_AVX)) {
+	} else if (boot_cpu_has(X86_FEATURE_AVX)) {
 		if (boot_cpu_has(X86_FEATURE_AVX2) &&
 		    boot_cpu_has(X86_FEATURE_BMI1) &&
 		    boot_cpu_has(X86_FEATURE_BMI2))
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 0ee69d8e39fe..e98ffdaf4b14 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -104,9 +104,7 @@ static void sha256_mod_init_arch(void)
 		   boot_cpu_has(X86_FEATURE_PHE_EN) &&
 		   boot_cpu_data.x86 >= 0x07) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_phe);
-	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				     NULL) &&
-		   boot_cpu_has(X86_FEATURE_AVX)) {
+	} else if (boot_cpu_has(X86_FEATURE_AVX)) {
 		if (boot_cpu_has(X86_FEATURE_AVX2) &&
 		    boot_cpu_has(X86_FEATURE_BMI2))
 			static_call_update(sha256_blocks_x86,
diff --git a/lib/crypto/x86/sha512.h b/lib/crypto/x86/sha512.h
index 0213c70cedd0..4e177b4606bd 100644
--- a/lib/crypto/x86/sha512.h
+++ b/lib/crypto/x86/sha512.h
@@ -37,8 +37,7 @@ static void sha512_blocks(struct sha512_block_state *state,
 #define sha512_mod_init_arch sha512_mod_init_arch
 static void sha512_mod_init_arch(void)
 {
-	if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL) &&
-	    boot_cpu_has(X86_FEATURE_AVX)) {
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		if (boot_cpu_has(X86_FEATURE_AVX2) &&
 		    boot_cpu_has(X86_FEATURE_BMI2))
 			static_call_update(sha512_blocks_x86,
diff --git a/lib/crypto/x86/sm3.h b/lib/crypto/x86/sm3.h
index 3834780f2f6a..e06d4a22e4fa 100644
--- a/lib/crypto/x86/sm3.h
+++ b/lib/crypto/x86/sm3.h
@@ -33,7 +33,6 @@ static void sm3_blocks(struct sm3_block_state *state,
 #define sm3_mod_init_arch sm3_mod_init_arch
 static void sm3_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_BMI2) &&
-	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_BMI2))
 		static_call_update(sm3_blocks_x86, sm3_blocks_avx);
 }
-- 
2.55.0

