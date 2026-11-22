Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314069;
	b=BJ2Fqs27eGQnyyr7XK6PMZ3miEn2OjBI5T3kpPYg4uF75U961dKuxN1xdHJonxd0YYET
	 pRa9UXEZrGzz0gQuLOC1XE8OPxa7XLWzxoI1623PKXiDIRFRNJ9SAiytezw1pUQETUjcL
	 0dCEuU6fAsFxiXJtTKupkcEYLqDxmwQPzt1MzlQDBu+4UY7FOxT1IISIAAIG+uTigOJsM
	 jko5VVrsB7VPeaK28T0w5XT2ds0fliX6+U2U+AVUkt4IggGw0QmJwGkdRyvOYIfl5q1if
	 i0IwWy5ZwLZFxgKw1nXkZauzW98HHFsHTCVeISmzHZFNs0sZINIJxxYNqKOaEEn+4hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eLcmHeQl0dioOhG2X6AlmYgWvDydB/Pnk2Ke1ICnDIM=;
	b=fWAkja6IQwJJJFwIODg6l1DNjjSiKwfeZAAlBBevF0TT+uvkCw8mb8nSAWSktJ9IGuKO
	 9almdnOyWZWW50wPtkMHPvFdo7ARQFPf76ADbwSpOkBYS1wVU0hiKB8AQJnjTVrcba7dq
	 AX78PEqyZKlHEUWgPF1gJWuXlHkrBSEMF1g3B241SDyg/15xwBOzKqZ0Miik92UOZrEKO
	 V0StbCaHNKGqNgLhPfseqegVwFoGqwD1TKdmvpb81QGYyUm2Z0MFX2mVx6xApOnIX6u1x
	 9jNXsb+UkFCziQ8YzmjejHGSoIdjehB3UNar6/Y3P9RtGihBFuW5iaYFlBz5wxxkDeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl5tb1lU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957AF606A32C
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl5tb1lU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289EE1F000CF;
	Sun, 22 Nov 2026 02:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314069;
	bh=eLcmHeQl0dioOhG2X6AlmYgWvDydB/Pnk2Ke1ICnDIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hl5tb1lUaQ+fmcdaKVw2FrA+h0B4kF6rYY33n4cMRtBcz7s6gw8UhsNgMlTPLEDq7
	 N8FydIjFXHtYWO/NN8l2u9WFnXzKd7rGv+esTDul/Rv2TjY4WQek6q62ABzM7dT6a+
	 nIdoFR0lKYGO1NuOI1zdmx7oCjDQ2xTqcDvJVEPIi3OI4ZVFLBsT5WYyBw6+GgcRyk
	 dObADX6NnJYdq1otWrhvZqPs83Vn4uWOMVuAoy6jgNjq71wj1XUx1/lt36Mp3Jf5Ti
	 RznIHz6YGzk8nzVpE/PR820CwNebXQVzVoo+WfaprIb7M285mMUQ6rvdlOJqc7q4bN
	 lPagBT7kAdI+Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 8/8] lib/crypto: x86/sha512: Use local labels for data
Date: Sat, 21 Nov 2026 18:20:30 -0800
Message-ID: <20261122022030.296468-9-ebiggers@kernel.org>
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

Prefix XMM_QWORD_BSWAP, XMM_QWORD_ROR8, and K512 with ".L_" to make them
local labels and avoid emitting extra symbol table entries.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index 62f1f5109f629..42375adde01ef 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -71,7 +71,7 @@ g_64 =		%r15
 h_64 =		%rbx
 tmp0 =		%rax
 # Used in the rounds 14-77 loop, while digest and msglen are spilled
-kptr =		%rdi	# Pointer to K512[72]
+kptr =		%rdi	# Pointer to .L_K512[72]
 toff =		%rdx	# 8*(t - 80), where W[t] is the first QWORD scheduled in the iteration.
 
 XWK =		%xmm5	# {W[t]+K[t], W[t+1]+K[t+1]} for the next two rounds
@@ -85,8 +85,8 @@ XW4 =		%xmm10
 XW5 =		%xmm11
 XW6 =		%xmm12
 XW7 =		%xmm13
-XBSWAP =	%xmm14	# XMM_QWORD_BSWAP
-XROR8 =		%xmm15	# XMM_QWORD_ROR8
+XBSWAP =	%xmm14	# .L_XMM_QWORD_BSWAP
+XROR8 =		%xmm15	# .L_XMM_QWORD_ROR8
 
 # Useful QWORD "arrays" for simpler memory references
 # MSG, DIGEST, K_t are arrays
@@ -98,7 +98,7 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 #define DIGEST(i) 8*i(digest)
 
 # SHA Constants (static mem)
-#define K_t(i)    8*i+K512(%rip)
+#define K_t(i)    8*i+.L_K512(%rip)
 
 # Add \mem to \reg, then copy the result back to \mem.
 .macro addm mem reg
@@ -307,8 +307,8 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	push	msglen
 	push	digest
 
-	movdqa	XMM_QWORD_BSWAP(%rip), XBSWAP
-	movdqa	XMM_QWORD_ROR8(%rip), XROR8
+	movdqa	.L_XMM_QWORD_BSWAP(%rip), XBSWAP
+	movdqa	.L_XMM_QWORD_ROR8(%rip), XROR8
 
 	# Load state variables
 	mov	DIGEST(0), a_64
@@ -344,7 +344,7 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	# iteration would avoid the register swap below, but 8 rounds per
 	# iteration saves ~1.1 KB of code size, which is worthwhile for this
 	# fallback implementation and improves I-cache residency.
-	lea	K512+72*8(%rip), kptr
+	lea	.L_K512+72*8(%rip), kptr
 	mov	$-(80-16)*8, toff
 
 .align 16
@@ -414,13 +414,13 @@ SYM_FUNC_END(sha512_transform_ssse3)
 .section	.rodata.cst16.XMM_QWORD_BSWAP, "aM", @progbits, 16
 .align 16
 # Mask for byte-swapping a couple of qwords in an XMM register using pshufb.
-XMM_QWORD_BSWAP:
+.L_XMM_QWORD_BSWAP:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
 
 .section	.rodata.cst16.XMM_QWORD_ROR8, "aM", @progbits, 16
 .align 16
 # Mask for rotating each qword in an XMM register right by 8 bits using pshufb.
-XMM_QWORD_ROR8:
+.L_XMM_QWORD_ROR8:
 	.octa 0x080f0e0d0c0b0a090007060504030201
 
 # Mergeable 640-byte rodata section. This allows linker to merge the table
@@ -429,7 +429,7 @@ XMM_QWORD_ROR8:
 .section	.rodata.cst640.K512, "aM", @progbits, 640
 .align 64
 # K[t] used in SHA512 hashing
-K512:
+.L_K512:
 	.quad 0x428a2f98d728ae22,0x7137449123ef65cd
 	.quad 0xb5c0fbcfec4d3b2f,0xe9b5dba58189dbbc
 	.quad 0x3956c25bf348b538,0x59f111f1b605d019
-- 
2.56.1

