Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792955552;
	b=yjnhty1bwVImsizAzBBZwcmusYcEZ4WnKelRliPZ112La/B8+L1oPbUuAGUHa0aPcd4E
	 GfraFbbWdnMk4mCgp6qAK4ZjJB+TmljM2TUM0c1YaFfm2fLwQY+qO9Zm3+EFfZ5B+dErW
	 uso+0kIsDjA1+JXspdHcWFbSG42bw4Mri/XzhZibcZVMTaGxuxhtVDmH2uJnS/5vRlwTB
	 pZK5Mfnc0mC4v85suT2eNbOxOpAN7bkjd1HJpl41mwl+K6+HUs39lb2hTVyah0Rp1/r1b
	 F025iAeWHQsUgMwnUzvij0GKjn4iAHuuekk5YJEWfKYOEEg9P5W0+B/LjdtkrkdckVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792955552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=v0LYqB6Jt6uRD00774esn5EXeYWxhHT8u99cd+Yt3vs=;
	b=NFnaaCjuV+qWAvDD0TefcbveyksKpUAgQOn3dKD9R1/HH8f6P3FXIOiH1YQeJamsXJwk
	 ALeOVxx+ScgIlTWYCwBklRNG+fSUCuAqojyl5wN196EOkX9JUEBtGWJhn4nBs/th7wV+q
	 qok12OvR+kcDLg0ZMHKd6NnedlLqdcmGfA0bhaDTCy4VbhfOAlDhb3KxPqvEBVnK2iLGm
	 ubB72R6foUrVcePU5elRnWECfVE0QI+akcoNvCY8VC1pmlEvvyAlKih6qLXPgrsoioOzz
	 Y29CylrR05PFyyODhCcfneP+hdXjTtyMG4kG6bcNbII+/NNitL0sSK504MI0d16TRqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cglSjbBd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF91A606A32D;
	Sun, 25 Oct 2026 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cglSjbBd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA3A1F01825;
	Sun, 25 Oct 2026 19:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792955551;
	bh=v0LYqB6Jt6uRD00774esn5EXeYWxhHT8u99cd+Yt3vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cglSjbBd0jqDdPwp9/osaeJaI2HVx+dw02TH9oEmCotqnlqvB2QABZA5yASnY/vkR
	 4Qiuq3erAV84cESSlOBqRbiPV5QfLS3ZqPm4crU1iq+sTqXDLDIx3IkvbprzCbI1nN
	 lLSLQBn7LQ3GIpqeZpDHBW2n+JOoStzfAbq6e+11y3V5fWtRAZCnuEl/JspfP6eXeU
	 DsKFDc6wK47rSzzdRiS8Vric37KfL6sLQYolZjg8DRs+f7SOU24vImaYjMPn5Wc9h8
	 /POaOEWVuPsVVUxy14hYyUHNWjhW3DJkcZ5yQX1UbvihcP+obGVOkbkFnrvGm8aQAm
	 1ZYfPGF5IpoMQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-raid@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] raid6: simplify CPU feature checks
Date: Sun, 25 Oct 2026 12:12:07 -0700
Message-ID: <20261025191207.86590-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261025191207.86590-1-ebiggers@kernel.org>
References: <20261025191207.86590-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove unnecessary checks for features that are prerequisites for other
features, such as AVX which is a prerequisite for AVX2.

(Note: in most cases arch/x86/kernel/cpu/cpuid-deps.c warns about
missing prerequisites rather than enforcing them.  This is intentional,
and it does not mean the prerequisites should be checked elsewhere.)

Then, move the raid6_recov_algo_add() lines into the appropriate places
just above so that the same CPU features aren't checked multiple times.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/raid6/x86/pq_arch.h | 51 ++++++++----------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/lib/raid/raid6/x86/pq_arch.h b/lib/raid/raid6/x86/pq_arch.h
index 4a863b253b909..418e4d4a2930f 100644
--- a/lib/raid/raid6/x86/pq_arch.h
+++ b/lib/raid/raid6/x86/pq_arch.h
@@ -16,63 +16,34 @@ extern const struct raid6_recov_calls raid6_recov_ssse3;
 extern const struct raid6_recov_calls raid6_recov_avx2;
 extern const struct raid6_recov_calls raid6_recov_avx512;
 
-static inline int raid6_has_avx512(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) &&
-		boot_cpu_has(X86_FEATURE_AVX) &&
-		boot_cpu_has(X86_FEATURE_AVX512F) &&
-		boot_cpu_has(X86_FEATURE_AVX512BW) &&
-		boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		boot_cpu_has(X86_FEATURE_AVX512DQ);
-}
-
-static inline bool raid6_has_avx2(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX);
-}
-
-static inline bool raid6_has_ssse3(void)
-{
-	return boot_cpu_has(X86_FEATURE_XMM) &&
-		boot_cpu_has(X86_FEATURE_XMM2) &&
-		boot_cpu_has(X86_FEATURE_SSSE3);
-}
-
-static inline bool raid6_has_sse2(void)
-{
-	return boot_cpu_has(X86_FEATURE_MMX) &&
-		    boot_cpu_has(X86_FEATURE_FXSR) &&
-		    boot_cpu_has(X86_FEATURE_XMM) &&
-		    boot_cpu_has(X86_FEATURE_XMM2);
-}
-
 static __always_inline void __init arch_raid6_init(void)
 {
-	if (raid6_has_avx2()) {
+	if (boot_cpu_has(X86_FEATURE_AVX2)) {
 		raid6_algo_add(&raid6_avx2x1);
 		raid6_algo_add(&raid6_avx2x2);
 		if (IS_ENABLED(CONFIG_X86_64))
 			raid6_algo_add(&raid6_avx2x4);
-		if (raid6_has_avx512()) {
+		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&
+		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
+		    boot_cpu_has(X86_FEATURE_AVX512DQ)) {
 			raid6_algo_add(&raid6_avx512x1);
 			raid6_algo_add(&raid6_avx512x2);
 			if (IS_ENABLED(CONFIG_X86_64))
 				raid6_algo_add(&raid6_avx512x4);
+			raid6_recov_algo_add(&raid6_recov_avx512);
+		} else {
+			raid6_recov_algo_add(&raid6_recov_avx2);
 		}
-	} else if (IS_ENABLED(CONFIG_X86_64) || raid6_has_sse2()) {
+	} else if (IS_ENABLED(CONFIG_X86_64) ||
+		   boot_cpu_has(X86_FEATURE_XMM2)) {
 		/* x86_64 can assume SSE2 as baseline */
 		raid6_algo_add(&raid6_sse2x1);
 		raid6_algo_add(&raid6_sse2x2);
 		if (IS_ENABLED(CONFIG_X86_64))
 			raid6_algo_add(&raid6_sse2x4);
+		if (boot_cpu_has(X86_FEATURE_SSSE3))
+			raid6_recov_algo_add(&raid6_recov_ssse3);
 	} else {
 		raid6_algo_add_default();
 	}
-
-	if (raid6_has_avx512())
-		raid6_recov_algo_add(&raid6_recov_avx512);
-	else if (raid6_has_avx2())
-		raid6_recov_algo_add(&raid6_recov_avx2);
-	else if (raid6_has_ssse3())
-		raid6_recov_algo_add(&raid6_recov_ssse3);
 }
-- 
2.56.0

