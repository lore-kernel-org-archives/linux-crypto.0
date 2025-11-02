Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41B6253F2B;
	Sun,  2 Nov 2025 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762127044; cv=none; b=OTz05cBMFtih86/TB4rSMEcNykDfuEO+LcbAfiLDe40hj1EKyhkNCBFD0XT0u/gyQXNaMpCZVzOehQKc4sm8fnfZKleDyx6d1r55aZMNrD9IsKs1SiyBvDvVQJkoH9GlLat3bhGgCK1fNbEEe7mt2UegTqWV3YDfRZTzjby0zGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762127044; c=relaxed/simple;
	bh=j+LSbTUig2K+EmVWaRZVVpXdTDuVAi/PAB71FfKJnIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3UxjFKPxqdNe1QKkNUVnJucVxGEFiYUQ049pye3p2LOfYZE1CzFkwHktGI6NSwhxPbfWbXaGALJ8phynMgww2WfJf0qGO4SVM8g1EdgiTrJ1DFJhUj+qglefFh0BzMvaDkbjNWGLKTgdQHJfmklM68qbHJxHClSBCB2gwct9lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GtVTM6xJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GtVTM6xJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC21C19423;
	Sun,  2 Nov 2025 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762127044;
	bh=j+LSbTUig2K+EmVWaRZVVpXdTDuVAi/PAB71FfKJnIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtVTM6xJL/gvPY+zJsdv8/aaTPE5/cHj/iGZYsJ0X3+DOisrk8LuSao0kmvFtknQ8
	 Wu8fQnerrUXuSTurB7CmlXX8TfKbc0IfNJDBBNWIuCo5zAaHDmDQUvqJ1F+BYIZ5q3
	 ZyYUg0MdounUp9QUFldvD6ITKq3E+z31/5Qk2mK9hO/EBPbBFKupJBV7b9LMUSNYH4
	 /OIjUeQ2jhaPc+eqwrhKximaFVSi30aDC8ocVnXGCYWA6tXMUEmVeFOhnKR5gHyykv
	 ZNOdTvGJv6KngG7E8829H437XRN8qV3lwA4dRdNP9tH+wa90yGAEcg2eRlLxVIaTFC
	 dP+ZhJXQcHeDA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/6] lib/crypto: x86/blake2s: Use vpternlogd for 3-input XORs
Date: Sun,  2 Nov 2025 15:42:09 -0800
Message-ID: <20251102234209.62133-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251102234209.62133-1-ebiggers@kernel.org>
References: <20251102234209.62133-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AVX-512 supports 3-input XORs via the vpternlogd (or vpternlogq)
instruction with immediate 0x96.  This approach, vs. the alternative of
two vpxor instructions, is already used in the CRC, AES-GCM, and AES-XTS
code, since it reduces the instruction count and is faster on some CPUs.
Make blake2s_compress_avx512() take advantage of it too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index 869064f6ac16..7b1d98ca7482 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -276,14 +276,12 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vpshufd		$0x93,%xmm2,%xmm2
 	decb		%cl
 	jne		.Lavx512_roundloop
 
 	// Compute the new h: h[0..7] ^= v[0..7] ^ v[8..15]
-	vpxor		%xmm10,%xmm0,%xmm0
-	vpxor		%xmm11,%xmm1,%xmm1
-	vpxor		%xmm2,%xmm0,%xmm0
-	vpxor		%xmm3,%xmm1,%xmm1
+	vpternlogd	$0x96,%xmm10,%xmm2,%xmm0
+	vpternlogd	$0x96,%xmm11,%xmm3,%xmm1
 	decq		NBLOCKS
 	jne		.Lavx512_mainloop
 
 	vmovdqu		%xmm0,(CTX)		// Store new h[0..3]
 	vmovdqu		%xmm1,16(CTX)		// Store new h[4..7]
-- 
2.51.2

