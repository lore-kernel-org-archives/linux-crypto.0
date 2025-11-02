Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A041F78F54;
	Sun,  2 Nov 2025 01:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762048184; cv=none; b=WTB+deQNFtPGJfZXQfOV90nKxFHnNrGarotFoKZ9IH2PTfR9eKjt8mMw40DpmthrJjLgFJ75zN6JZdLZ5TTPI2hCp1v9tQn++sGVJLzBc2JlJJGIVziB9gEdF6PgmEJn2W24ZM3CsccZJAtaMuQIf/QicwMSjyqDUOkw57Ra+oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762048184; c=relaxed/simple;
	bh=LxQeUgunFc21LIZae/NTxauplw0Lbky943VHdgB/Pv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JUPr7P14HuHpuybYzC+1m60pTsUKpdftv5k2Zxk15CTv8ocKXBtAFquB7wvsfpr2EB1J0H7glAPUIjFrY0jHuCbqTzS8KJfqSkpEo8aTQOhcVfTHDUfHZBLt/PKe0eNvNeU3pzQLsKU2L5JcxQfy5R+k7cm4AQSJEcO+sunAErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgdZuZgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgdZuZgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA4AC4CEF1;
	Sun,  2 Nov 2025 01:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762048184;
	bh=LxQeUgunFc21LIZae/NTxauplw0Lbky943VHdgB/Pv8=;
	h=From:To:Cc:Subject:Date:From;
	b=RgdZuZgpda8jftRQEl3ytHKLcEzEPuYC5EYYJM4E/rxaqjYmfBUAaAxPsBKw9ICkD
	 By3/AS7/3r63YCQGkfQ15K60SXhFHHIcRrbFEKK/uxCEPUChoCUf8KYPyw40xt2WDB
	 0Y9Sc8/FB3q12QfzEVpMxvWWsY5jhe7JMAAgnHJNaj+xwCXbdcVbb3TXjYkXHdc1ta
	 5xaQwJuR/6OJe7OjqulomgSwgL6kY+aqpyZyyye/IKlL2uwe/kCdZ/Cex7Hj94+t79
	 YWekdWymPCVFqFV1Q3G9bpZT/MeN3ez3yOc7RMTjbx6te9hnAOJWQj3WYcSeSwq7wb
	 YleWKS4M/zTBA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/blake2s: Drop check for nblocks == 0
Date: Sat,  1 Nov 2025 18:49:37 -0700
Message-ID: <20251102014937.171096-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since blake2s_compress() is always passed nblocks != 0, remove the
unnecessary check for nblocks == 0 from blake2s_compress_ssse3().

Note that this makes it consistent with blake2s_compress_avx512() in the
same file as well as the arm32 blake2s_compress().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 lib/crypto/x86/blake2s-core.S | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index ef8e9f427aab..7b820d3eda2c 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -43,12 +43,10 @@ SIGMA2:
 .byte 15,  5,  4, 13, 10,  7,  3, 11, 12,  2,  0,  6,  9,  8,  1, 14
 .byte  8,  7, 14, 11, 13, 15,  0, 12, 10,  4,  5,  6,  3,  2,  1,  9
 
 .text
 SYM_FUNC_START(blake2s_compress_ssse3)
-	testq		%rdx,%rdx
-	je		.Lendofloop
 	movdqu		(%rdi),%xmm0
 	movdqu		0x10(%rdi),%xmm1
 	movdqa		ROT16(%rip),%xmm12
 	movdqa		ROR328(%rip),%xmm13
 	movdqu		0x20(%rdi),%xmm14
@@ -166,11 +164,10 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	decq		%rdx
 	jnz		.Lbeginofloop
 	movdqu		%xmm0,(%rdi)
 	movdqu		%xmm1,0x10(%rdi)
 	movdqu		%xmm14,0x20(%rdi)
-.Lendofloop:
 	RET
 SYM_FUNC_END(blake2s_compress_ssse3)
 
 SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(%rdi),%xmm0

base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9
-- 
2.51.2

