Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD00E207A20;
	Sun,  2 Nov 2025 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762127048; cv=none; b=aBNUgzJQAWEfJLClHpFSCNll1XrqRmEn6E30kndUO1y67cgDsJ/Lrf7zMJZ0CpVUKqiuFWBZsLQPOrvYQVcg1sjtu3kK4RhtVa8TB+bKztoivQ2jH2blgW/x+SVLwtu287Gl4ZTF+awY8K2YDf1vmjm60kt/58Q/nGpuifqZxcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762127048; c=relaxed/simple;
	bh=k2ihRsAJpVZynwObEpw3RH70PsUdDzp23XLPstmxK9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnfF786jCbq0qmMx4wC62hMTqYuHxHCcVGzARHthhoBUDXiduQfNJkrzfu0qT+V4CSOAbae7B5K9z/ZYbgdTbSeilR/KuOdvk6/jQ1hJne1f3iWBsOHDcPYWr9/4aQ1X056dg1gyKmkq1jDff1mYE5n9pm3Pqwe0jFSkO0HwaHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b++mgGmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b++mgGmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E599C4CEF7;
	Sun,  2 Nov 2025 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762127044;
	bh=k2ihRsAJpVZynwObEpw3RH70PsUdDzp23XLPstmxK9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b++mgGmd3lKCuPyeu8y+8WpSyacY1Vqu/yhuBtI4l2G7sishtVO+RvDhnsOb/kv3e
	 2aPbyu7xYnV5tXFKlhlHNocVInPs8NXGwMBe8BqjU+8m6cA0+TMdL9F6bxgsuL6iUn
	 EWIUQ3CywYaNNITcLo8bVLXW/cgABlReidQ0QfIOl5BwGl1ApF+MA1JxitMwVy9A17
	 4ATRJPRM4Cxkhhy+x7tvfmkhXJCuTw/YTBjknHykt3Jwru0inlq5/myt77KBX1DKZA
	 qZiddK6sA6u6XLiNlWC0o54NgdzVmLgfEmbjlTjoC0vNvsCBSy5zlANTpUwQQldqFM
	 LIYUdfH1Yf2Vg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/6] lib/crypto: x86/blake2s: Avoid writing back unchanged 'f' value
Date: Sun,  2 Nov 2025 15:42:08 -0800
Message-ID: <20251102234209.62133-6-ebiggers@kernel.org>
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

Just before returning, blake2s_compress_ssse3() and
blake2s_compress_avx512() store updated values to the 'h', 't', and 'f'
fields of struct blake2s_ctx.  But 'f' is always unchanged (which is
correct; only the C code changes it).  So, there's no need to write to
'f'.  Use 64-bit stores (movq and vmovq) instead of 128-bit stores
(movdqu and vmovdqu) so that only 't' is written.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index f805a49c590d..869064f6ac16 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -191,11 +191,11 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	decq		NBLOCKS
 	jnz		.Lssse3_mainloop
 
 	movdqu		%xmm0,(CTX)		// Store new h[0..3]
 	movdqu		%xmm1,16(CTX)		// Store new h[4..7]
-	movdqu		%xmm14,32(CTX)		// Store new t and f
+	movq		%xmm14,32(CTX)		// Store new t (f is unchanged)
 	RET
 SYM_FUNC_END(blake2s_compress_ssse3)
 
 //
 // void blake2s_compress_avx512(struct blake2s_ctx *ctx,
@@ -285,9 +285,9 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	decq		NBLOCKS
 	jne		.Lavx512_mainloop
 
 	vmovdqu		%xmm0,(CTX)		// Store new h[0..3]
 	vmovdqu		%xmm1,16(CTX)		// Store new h[4..7]
-	vmovdqu		%xmm4,32(CTX)		// Store new t and f
+	vmovq		%xmm4,32(CTX)		// Store new t (f is unchanged)
 	vzeroupper
 	RET
 SYM_FUNC_END(blake2s_compress_avx512)
-- 
2.51.2

