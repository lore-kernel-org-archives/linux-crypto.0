Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539670;
	b=kg7exm4XbP9OgDE0wGLeF+Zb+ZNo+ovfkP2R0IvZIXW6nbH0+0Hc9qZFQsPQrmzEfP6u
	 Yc5GI1m4oKp4VhjAL2ZiQBJFU/PjimyQkhbgidRAH+s+2hdJxhrwR3MrlWm+C1SiUQxwg
	 jb1O8nWWit8XfE25xkiblgJV0gHJCNRbTX4Fs07Jn6FmV6iCtbh1xJtxrLPIDR662yNrd
	 7aO2pkRYLtC31GfjlcVtPJ0tJlPt1r18dMzfBjJsqpltNqu6VZYQIGwJ/Iw3FGGBSwfo3
	 9WgiQ24Pp6Cwu1rfQoO51qIIl5pWWagYUYju3oifvmiOxeMXH1lPi5XWwF6fflayNEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0Brgt57itndYNenlEEAykva8LxQ3Zbfs2+/1+ETows=;
	b=Gc2QHVp33uG3lEOkqB27fh7qZhajrQJ69OhpHr1c4ifdD43KB+D/q36bzGsVBdv3ptyP
	 D9LPlzv05TEQ7l3XiCGvYiDQCcN+xXB4IYq9W3lLZmA7yK0meQYWyagGAfJ+qNurWL0rL
	 bbaOdB9tU0W+mbZNsB03Rm9JGjntiw5IEJ1riUtUaJRG0zQEF4sB2jUfoleYHx107+jL6
	 oSgtZRmYueiT5SJ+k7GT1oFv3mFnd2DYrG/sp22AbY1XchTTLiasibIa+DaRYFSlrzgff
	 vuEZM7ybkbceLpo1wHt06nw2IvBXumblVIGl6yI9y2+kTWC29wStXqy+yh2ybkyWQ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LGoG7KZr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88F0606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LGoG7KZr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303B01F000C4;
	Fri, 13 Nov 2026 03:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794539669;
	bh=r0Brgt57itndYNenlEEAykva8LxQ3Zbfs2+/1+ETows=;
	h=From:To:Cc:Subject:Date;
	b=LGoG7KZrASjWuhKCd96SgMXLwlEmmL36Vm+AYDL/eczvV1LeHRJwQeldD043AkPLn
	 z/PhrWl3wjY3CoM1TiWC2+NsOEQudhD3k04FgFQUrxeL8tlO2BqDQZKvaiPoSZpB5v
	 xG9d/zJW8JD3t2I09CFBYR3aUbZY29HSzcbzjDswEVqdHooR3xcvAwjAkn0irq2Fpw
	 FXX3YnUvJ5oZ2/8CNjb2mWbCqkY3iMfY24tq280mnJFAH7Q/66+5EboYMzoBprKS/I
	 7ZKtKLW8G9dKYofSMdhDM8yQsVpRMklcUrbnw0+3YXFt2VkOF8sFZ+wWrJHbQYu506
	 A5nkoycLoNXAw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Martin Willi <martin@strongswan.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] lib/crypto: x86/chacha: Fix mistakes and inconsistencies in comments
Date: Thu, 12 Nov 2026 19:13:40 -0800
Message-ID: <20261113031340.63688-1-ebiggers@kernel.org>
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

Fix various mistakes in comments, many probably originating from
copy+pasting: incorrect block ranges, duplicate words, and stray text.

Also make chacha_1to4blocks_ssse3() refer to the state matrix using flat
indexing, like the equivalent AVX2 and AVX512 functions.  It was the
only place using 2D row-column indexing of the state matrix.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: Fixed another inconsistency pointed out by Antonio

 lib/crypto/x86/chacha-avx2-x86_64.S   | 12 ++++-----
 lib/crypto/x86/chacha-avx512-x86_64.S | 10 ++++----
 lib/crypto/x86/chacha-ssse3-x86_64.S  | 36 +++++++++++++--------------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx2-x86_64.S b/lib/crypto/x86/chacha-avx2-x86_64.S
index 18ae03e05074f..5cf009616f7cb 100644
--- a/lib/crypto/x86/chacha-avx2-x86_64.S
+++ b/lib/crypto/x86/chacha-avx2-x86_64.S
@@ -46,7 +46,7 @@ SYM_FUNC_START(chacha_1to2blocks_avx2)
 	# on four words in each matrix in parallel, but requires shuffling to
 	# rearrange the words after each round.
 
-	# x0..3[0-2] = s0..3
+	# x0..3[0-1] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
 	vbroadcasti128	0x20(%rdi),%ymm2
@@ -212,7 +212,7 @@ SYM_FUNC_START(chacha_2to4blocks_avx2)
 	# required word shuffling has a rather high latency, we can do the
 	# arithmetic on two matrix-pairs without much slowdown.
 
-	# x0..3[0-4] = s0..3
+	# x0..3[0-3] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
 	vbroadcasti128	0x20(%rdi),%ymm2
@@ -495,7 +495,7 @@ SYM_FUNC_START(chacha_4to8blocks_avx2)
 	vmovdqa		ROT8(%rip),%ymm2
 	vmovdqa		ROT16(%rip),%ymm3
 
-	# x12 += counter values 0-3
+	# x12 += counter values 0-7
 	vpaddd		%ymm1,%ymm12,%ymm12
 
 .Ldoubleround8:
@@ -596,7 +596,7 @@ SYM_FUNC_START(chacha_4to8blocks_avx2)
 	vmovdqa		%ymm0,0x00(%rsp)
 	vpxor		%ymm0,%ymm15,%ymm15
 	vpshufb		%ymm3,%ymm15,%ymm15
-	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)%ymm0
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)
 	vpaddd		0x20(%rsp),%ymm6,%ymm0
 	vmovdqa		%ymm0,0x20(%rsp)
 	vpxor		%ymm0,%ymm12,%ymm12
@@ -686,7 +686,7 @@ SYM_FUNC_START(chacha_4to8blocks_avx2)
 	sub		$2,%r8d
 	jnz		.Ldoubleround8
 
-	# x0..15[0-3] += s[0..15]
+	# x0..15[0-7] += s[0..15]
 	vpbroadcastd	0x00(%rdi),%ymm0
 	vpaddd		0x00(%rsp),%ymm0,%ymm0
 	vmovdqa		%ymm0,0x00(%rsp)
@@ -724,7 +724,7 @@ SYM_FUNC_START(chacha_4to8blocks_avx2)
 	vpbroadcastd	0x3c(%rdi),%ymm0
 	vpaddd		%ymm0,%ymm15,%ymm15
 
-	# x12 += counter values 0-3
+	# x12 += counter values 0-7
 	vpaddd		%ymm1,%ymm12,%ymm12
 
 	# interleave 32-bit words in state n, n+1
diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index 127a94f1843bb..a96a3d0f11b9a 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -55,7 +55,7 @@ SYM_FUNC_START(chacha_0to2blocks_avx512vl)
 	# on four words in each matrix in parallel, but requires shuffling to
 	# rearrange the words after each round.
 
-	# x0..3[0-2] = s0..3
+	# x0..3[0-1] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
 	vbroadcasti128	0x20(%rdi),%ymm2
@@ -195,7 +195,7 @@ SYM_FUNC_START(chacha_2to4blocks_avx512vl)
 	# required word shuffling has a rather high latency, we can do the
 	# arithmetic on two matrix-pairs without much slowdown.
 
-	# x0..3[0-4] = s0..3
+	# x0..3[0-3] = s0..3
 	vbroadcasti128	0x00(%rdi),%ymm0
 	vbroadcasti128	0x10(%rdi),%ymm1
 	vbroadcasti128	0x20(%rdi),%ymm2
@@ -400,14 +400,14 @@ SYM_FUNC_END(chacha_2to4blocks_avx512vl)
 	# %r8d: nrounds
 
 	# This encrypts VL/4 consecutive ChaCha blocks by loading the state
-	# matrix in as many vector registers. Compared to AVX2, this mostly
+	# matrix in vector registers VL/4 times. Compared to AVX2, this mostly
 	# benefits from the new rotate instructions and the additional
 	# registers.
 	#
 	# VL=32 encrypts eight blocks in 256-bit ymm registers.
 	# VL=64 encrypts sixteen blocks in 512-bit zmm registers.
 
-	# x0..15[0-VL/4] = s[0..15]
+	# x0..15[0-(VL/4 - 1)] = s[0..15]
 	vpbroadcastd	0x00(%rdi),V0
 	vpbroadcastd	0x04(%rdi),V1
 	vpbroadcastd	0x08(%rdi),V2
@@ -585,7 +585,7 @@ SYM_FUNC_END(chacha_2to4blocks_avx512vl)
 	sub		$2,%r8d
 	jnz		.Ldoubleround\@
 
-	# x0..15 += s[0..15]
+	# x0..15[0-(VL/4 - 1)] += s[0..15]
 	vpaddd		V16,V0,V0
 	vpaddd		V17,V1,V1
 	vpaddd		V18,V2,V2
diff --git a/lib/crypto/x86/chacha-ssse3-x86_64.S b/lib/crypto/x86/chacha-ssse3-x86_64.S
index b9884ec979fae..ea25d2cc796e3 100644
--- a/lib/crypto/x86/chacha-ssse3-x86_64.S
+++ b/lib/crypto/x86/chacha-ssse3-x86_64.S
@@ -227,7 +227,7 @@ SYM_FUNC_START(chacha_1to4blocks_ssse3)
 	# %rcx: input/output data length in bytes: 1 to 4 blocks inclusive
 	# %r8d: nrounds
 
-	# This function encrypts four consecutive ChaCha blocks by loading the
+	# This function encrypts four consecutive ChaCha blocks by loading
 	# the state matrix in SSE registers four times. As we need some scratch
 	# registers, we save the first four registers on the stack. The
 	# algorithm performs each operation on the corresponding word of each
@@ -242,7 +242,7 @@ SYM_FUNC_START(chacha_1to4blocks_ssse3)
 	and		$~63,%rsp
 	mov		%rcx,%rax
 
-	# x0..15[0-3] = s0..3[0..3]
+	# x0..15[0-3] = s[0..15]
 	movq		0x00(%rdi),%xmm1
 	pshufd		$0x00,%xmm1,%xmm0
 	pshufd		$0x55,%xmm1,%xmm1
@@ -500,8 +500,8 @@ SYM_FUNC_START(chacha_1to4blocks_ssse3)
 	sub		$2,%r8d
 	jnz		.Ldoubleround4
 
-	# x0[0-3] += s0[0]
-	# x1[0-3] += s0[1]
+	# x0[0-3] += s[0]
+	# x1[0-3] += s[1]
 	movq		0x00(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3
@@ -509,8 +509,8 @@ SYM_FUNC_START(chacha_1to4blocks_ssse3)
 	movdqa		%xmm2,0x00(%rsp)
 	paddd		0x10(%rsp),%xmm3
 	movdqa		%xmm3,0x10(%rsp)
-	# x2[0-3] += s0[2]
-	# x3[0-3] += s0[3]
+	# x2[0-3] += s[2]
+	# x3[0-3] += s[3]
 	movq		0x08(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3
@@ -519,45 +519,45 @@ SYM_FUNC_START(chacha_1to4blocks_ssse3)
 	paddd		0x30(%rsp),%xmm3
 	movdqa		%xmm3,0x30(%rsp)
 
-	# x4[0-3] += s1[0]
-	# x5[0-3] += s1[1]
+	# x4[0-3] += s[4]
+	# x5[0-3] += s[5]
 	movq		0x10(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3
 	paddd		%xmm2,%xmm4
 	paddd		%xmm3,%xmm5
-	# x6[0-3] += s1[2]
-	# x7[0-3] += s1[3]
+	# x6[0-3] += s[6]
+	# x7[0-3] += s[7]
 	movq		0x18(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3
 	paddd		%xmm2,%xmm6
 	paddd		%xmm3,%xmm7
 
-	# x8[0-3] += s2[0]
-	# x9[0-3] += s2[1]
+	# x8[0-3] += s[8]
+	# x9[0-3] += s[9]
 	movq		0x20(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3
 	paddd		%xmm2,%xmm8
 	paddd		%xmm3,%xmm9
-	# x10[0-3] += s2[2]
-	# x11[0-3] += s2[3]
+	# x10[0-3] += s[10]
+	# x11[0-3] += s[11]
 	movq		0x28(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3
 	paddd		%xmm2,%xmm10
 	paddd		%xmm3,%xmm11
 
-	# x12[0-3] += s3[0]
-	# x13[0-3] += s3[1]
+	# x12[0-3] += s[12]
+	# x13[0-3] += s[13]
 	movq		0x30(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3
 	paddd		%xmm2,%xmm12
 	paddd		%xmm3,%xmm13
-	# x14[0-3] += s3[2]
-	# x15[0-3] += s3[3]
+	# x14[0-3] += s[14]
+	# x15[0-3] += s[15]
 	movq		0x38(%rdi),%xmm3
 	pshufd		$0x00,%xmm3,%xmm2
 	pshufd		$0x55,%xmm3,%xmm3

base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.1

