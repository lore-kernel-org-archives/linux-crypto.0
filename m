Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314068;
	b=DqIJPUaWDbg8gNPWBZ74WKq/RL5Uw68x2MD+zV9+EgaSTfTFP/ydmGYOUcRfDebZnyp+
	 az/i4aDDxV2/N+DlMXGm1sGkwzeHQmTPemuItDAf+xm7BWMMwoVpDYeW4CvQ8SPYvbPcB
	 xD7IXvX5z36QObwiI3FVNiPAdStlXhGFqeBErbXDO5zHqUEFEBbQnm1Mgz3lxHTFUK/7B
	 Zkcg/8P11hMZZG8zec+8wtkzJ68LCTtwzeh7m/xgWoUii24OchKOuXQ3NQA/qxGIKhJ2j
	 +Ns4r0ijvsbfYXERVGoegXZIrrY2LC7G7+EnW7ohk612U4LS1s3VNnU+x4rduLSTJQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4gfIV9JL87j56QwW+OS8FPrFhM6UHhaHPQZjPJPFpRM=;
	b=bFwwxjWJL1ZIVaOWCanMuFoFoeRPIozW28xYqSILPGrOxx2UCTW184eqh+W4A3teifRu
	 AarJ8TW2OU1EP+EUaeBvZimjZVSQiA2NxkFUO7ODlTnM0ZgzTo2BCdkMyE8tGeod0rSu+
	 AJPasmjSXO9gf816ejoHfWbBc9tWM65TjBMIuBSkbAYYPrtFsaRojzs3hStSioJcI1eBD
	 sCXkR1kNXOUU9v8/DOl9U0INYnDQEktVW+6so5oaAdPWwRdgCC/jSYh3x8+r9m35aYDn6
	 PR/Pj+KzR+73FKhmLzJHa948PScMBGN3baC9S7pTSEeukwanjVxdXWt/gi8X2s8lwmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NKvAoKm+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AB3606A339
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NKvAoKm+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E161F000D2;
	Sun, 22 Nov 2026 02:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314067;
	bh=4gfIV9JL87j56QwW+OS8FPrFhM6UHhaHPQZjPJPFpRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKvAoKm+zUlCqeh/I/B00fZe7C27LVxJlllNd6ewy7apHjmHmyPvpKZu0FixJZcfy
	 kbwvgEjuGCkxnqBSIsjrzVDirgKs8tYPwx+fNMT3vskKe5dF8iz/sY2qd0RLRmJJMo
	 CX5zNxetOem/3207X2vorrb3kLYIXZNuBK1Qvp4KZGM+JqmTnEjM4Y5B3x+mYtq8A3
	 Abw8Xhkaku7qTZgdg/LhDyDz4de5k8ChLNCs01IswrFb4YrlEg4/ZV2XYoQAzo4GJs
	 mw8rhOIC4W41BhsSpDyg+flT44MQJnySfu4RQhvDzeB+9+tWAfsWvMUZMbyJcUco2U
	 TdyKeioTMHCEg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/8] lib/crypto: x86/sha512: Keep XMM_QWORD_BSWAP in %xmm14 across blocks
Date: Sat, 21 Nov 2026 18:20:26 -0800
Message-ID: <20261122022030.296468-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261122022030.296468-1-ebiggers@kernel.org>
References: <20261122022030.296468-1-ebiggers@kernel.org>
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

Load the byte-swap shuffle mask into a free XMM register once before the
block loop instead of reloading it from memory on every block.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index f2a43c4ac8bec..d40a3361aefeb 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -85,6 +85,7 @@ XW4 =		%xmm10
 XW5 =		%xmm11
 XW6 =		%xmm12
 XW7 =		%xmm13
+XBSWAP =	%xmm14	# XMM_QWORD_BSWAP
 
 # Useful QWORD "arrays" for simpler memory references
 # MSG, DIGEST, K_t are arrays
@@ -301,6 +302,8 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	push	msglen
 	push	digest
 
+	movdqa	XMM_QWORD_BSWAP(%rip), XBSWAP
+
 .Lupdateblock:
 
 	# Load state variables
@@ -314,15 +317,14 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	mov	DIGEST(7), h_64
 
 	# Rounds 0 - 13: BSWAP W[0..15] into XW0..XW7 and compute rounds 0..13.
-	movdqa	XMM_QWORD_BSWAP(%rip), %xmm1
 	movdqu	MSG(0), XW0
-	pshufb	%xmm1, XW0	# BSWAP
+	pshufb	XBSWAP, XW0	# BSWAP
 	movdqa	XW0, XWK
 	paddq	K_t(0), XWK	# Compute W[0..1]+K[0..1]
 	t = 2
 	.irp reg, XW1,XW2,XW3,XW4,XW5,XW6,XW7
 		movdqu	MSG(t), \reg
-		pshufb	%xmm1, \reg	# BSWAP
+		pshufb	XBSWAP, \reg	# BSWAP
 		SHA512_Round (t-2)	# Round t-2
 		movdqa	\reg, %xmm0
 		paddq	K_t(t), %xmm0	# Compute W[t]+K[t]
-- 
2.56.1

