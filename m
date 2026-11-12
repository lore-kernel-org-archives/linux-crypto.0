Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457631;
	b=S/LnUejvPBEAFBEKheK89YZ0zTK/GY82WeRH8KZTrnKvI6GKiwD4AbPKL98shGRboP8w
	 fKBbqHS3GB2Zi3AGjsAOuEsalpOfZmC2Jxgyxb0uNjqetWECsmDz8iwQvAllujpMecMv/
	 tvv7SmxZCzzwniJHQoJBIXk+Xdx28uxKbwyuFkaTgPcN7EuqV4Vl9pA1Kid+1/hPPSy1L
	 PTsrW/nzt+kkEsA26/VTqqx7zcZYs9AoVj2pTvrUSlGgn2Ibpo+3aA5eHUbvwRefr5wUp
	 CVGmscLv9UdkhiXAH8TEaAU45AiZu2MZa0vCwPEkVeyr1kNVp6IzWawfIv4DGx2uH+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U2h1lZEY2PbYdQeNMuKrFcrQ2dPE2NBW0uXaXen51pw=;
	b=zSc98kJd1pI79t1T6HUIY57NKyTqRBkbFb4qYzgCifodG7W7cWSsIrR6vkVCKXpeWJPG
	 xrqXiXMsMIGDBrELc761EOZGI2qzOewkxnTkbgna34aynUZH0PC9ZySPbvGaXxak6hZ8V
	 YuEp55i0V+R8oJzjmlEZXWSnF8pbdDp6P9KJ2frmgp6S0U9vACWYROyx/Hjz51OF4Trt5
	 29dCpx+l4MzXyow5yT5Vn/vwLbn4j8mJj37rAiXDszbSI44NPMM+kxdYAesDzQ4HLWwuH
	 bD+li7VsHjw1jy6qgAJ1x8wa2ERmYvPR8p7tc7N4Y8J2wJz61MxeCJOXXe4Cye7vS6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k8ciVudu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848BE606A321
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k8ciVudu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35331F00A05;
	Thu, 12 Nov 2026 04:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457631;
	bh=U2h1lZEY2PbYdQeNMuKrFcrQ2dPE2NBW0uXaXen51pw=;
	h=From:To:Cc:Subject:Date;
	b=k8ciVudufzl9QirAqR8t+wLUmUv5qRflD5NI3rfLLoEkqW/7fzgyTjHDYtfC/hL9Z
	 qJ+QvT7JnvFRXZswSQ2P3+cOOYs5DORJe/57ECg47QKJNWJ63qHmSW8HiAjxeQzx08
	 Yno48IofFM4FnCUt+rdfW6h6NHol6pgO119auuCsYA9gEhH7//xKppHs/nWI4f2gAC
	 DBGQ7eeybqhN36bOtzF8kPXr50GUzff36vItwnVv4+MHt/PfUW+OxmTaJ9HcKQVMEi
	 tMk2fhmqkqxSt3j+OVGNkDLzVnzEKsG2ev/QfLu2eoRkAWmP7RGILG5xfbnU/1cNGd
	 JysFWjE3sR/5Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/blake2s: Permute original message words in AVX-512 code
Date: Wed, 11 Nov 2026 20:25:13 -0800
Message-ID: <20261112042513.59919-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
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

Each round of BLAKE2s takes a different fixed permutation of the message
words as an input.  For each round, blake2s_compress_avx512() applies
that permutation on the message words in %ymm6-%ymm7, writing the
permuted words to %ymm8-%ymm9 where they are used for the round.

Oddly, though, it also copies the permuted words back into %ymm6-%ymm7.
That means the next round has to apply the previous round's inverse
permutation, then the next round's permutation.  Which it does, by using
the 'sigma2' table which has the permutations precomposed in this way.

However, this is not necessary at all, as we can simply do each round's
permutation on the original message words, using the 'sigma' table which
is already present in the file for blake2s_compress_ssse3().

Do that instead.  This eliminates 160 unnecessary bytes of rodata, two
unnecessary instructions per round, and a loop-carried dependency.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index 7b1d98ca7482c..f9105764686b7 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -36,20 +36,6 @@
 .byte  6, 14, 11,  0, 15,  9,  3,  8, 10, 12, 13,  1,  5,  2,  7,  4
 .byte 10,  8,  7,  1,  2,  4,  6,  5, 13, 15,  9,  3,  0, 11, 14, 12
 
-.section .rodata.cst64.sigma2, "aM", @progbits, 160
-.align 64
-.Lsigma2:
-.byte  0,  2,  4,  6,  1,  3,  5,  7, 14,  8, 10, 12, 15,  9, 11, 13
-.byte  8,  2, 13, 15, 10,  9, 12,  3,  6,  4,  0, 14,  5, 11,  1,  7
-.byte 11, 13,  8,  6,  5, 10, 14,  3,  2,  4, 12, 15,  1,  0,  7,  9
-.byte 11, 10,  7,  0,  8, 15,  1, 13,  3,  6,  2, 12,  4, 14,  9,  5
-.byte  4, 10,  9, 14, 15,  0, 11,  8,  1,  7,  3, 13,  2,  5,  6, 12
-.byte  2, 11,  4, 15, 14,  3, 10,  8, 13,  6,  5,  7,  0, 12,  1,  9
-.byte  4,  8, 15,  9, 14, 11, 13,  5,  3,  2,  1, 12,  6, 10,  7,  0
-.byte  6, 13,  0, 14, 12,  2,  1, 11, 15,  4,  5,  8,  7,  9,  3, 10
-.byte 15,  5,  4, 13, 10,  7,  3, 11, 12,  2,  0,  6,  9,  8,  1, 14
-.byte  8,  7, 14, 11, 13, 15,  0, 12, 10,  4,  5,  6,  3,  2,  1,  9
-
 #define CTX		%rdi
 #define DATA		%rsi
 #define NBLOCKS		%rdx
@@ -226,7 +212,7 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(DATA),%ymm6		// Load first 8 data words
 	vmovdqu		32(DATA),%ymm7		// Load second 8 data words
 	addq		$64,DATA
-	leaq		.Lsigma2(%rip),%rax
+	leaq		.Lsigma(%rip),%rax
 	movb		$10,%cl			// Set num rounds remaining
 
 .Lavx512_roundloop:
@@ -236,8 +222,6 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	addq		$16,%rax
 	vpermi2d	%ymm7,%ymm6,%ymm8
 	vpermi2d	%ymm7,%ymm6,%ymm9
-	vmovdqa		%ymm8,%ymm6
-	vmovdqa		%ymm9,%ymm7
 	vpaddd		%xmm8,%xmm0,%xmm0
 	vpaddd		%xmm1,%xmm0,%xmm0
 	vpxor		%xmm0,%xmm3,%xmm3

base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.1

