Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793775449;
	b=tI7yx07+V1BC2nUB4QRbnQvrxVIcCKjdsh9ClGaPtAwLBYFp/a41j66PPFQjlb1RrRMv
	 MZhayXE6Zj4o/D8hoer+sCpcqfSJoyFIzJHUtwyUvTRjBOMnwDqd6JqCAmuIK+cUiyuHF
	 eGxdizTAaEcx8/h981Xkm2+8CbkdYCx1X1eTKcE+b+C5Td5aa1AN4Vq4P7YUJbk/KLqlu
	 o9uzv8VhPlZVIdq5u6zOIh2nOWlhqUywGuJPNjVv5gqu40kRa+M8FWciQn1kkm8nDdvZ6
	 OT3K63PVKQ8eATwhzd8iWau6s9xYH8zuVe6zt6Osdj70/ohvx5NaZW7RWGCWgPLUuzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793775449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRrCyzj/0UT7qDL+X/Hk0Ju/p9T3I7JV8tBIQMN/fBg=;
	b=ZPYwxwawwP47dByz7bopmbQZxgB9VjQl/eLVsdoi0cCDNatDu1hFAPd/TxlAuP+XfnvL
	 LUdzllTSqnopnrsej8V18Im7AsSO5UvEHz/eQ8QqPZSwxDTWXeSp/LcrFg41x3RznCdKd
	 H+ZP2afQA/gH1nz50XdlroXzqYuON7Aj5DtarXUzQHK9blj1NNyxPG9Lsk9kN+e544LrE
	 yPFrCUnmFJBFRKq7V0UdYOQ1OVKFl6CbFgANrpYR2B1my3YJMWpxfncil4/B0wWSEOOQC
	 seS5MZoYGU+WPw8GrPpGMZgz42liGTIWuCs1sr0jdhHgPZOzEim0qJF0+PUk9hI/wGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IrdiT27n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FF0606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 06:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IrdiT27n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE8B1F000C1;
	Wed,  4 Nov 2026 06:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793775448;
	bh=iRrCyzj/0UT7qDL+X/Hk0Ju/p9T3I7JV8tBIQMN/fBg=;
	h=From:To:Cc:Subject:Date;
	b=IrdiT27n914agNlTdCzSEJWG9l8yyNrOOgar/X+LvL+LaW+wNNAhWcD2BimA5gUog
	 uA0M4OFZVCQOkfBUo8eo/dDR5Tr/xPd8YIkqTrPNWnpmTSykdnoEMM106FkpUflEOH
	 jQd8Drq3qlOb07APXTrwrrbpMgJSkMFQZWIowYmsV7HHD3YNdiDzspiTAFM56Pl+kb
	 lpbkUt9n5R6BxsfqHL9rIY5rEet1lxU5LRnYCsdWmuxWdcl7NqOcZ8PzxZ8UXQhG2c
	 JyFGL66krmM43exa52k8eZMtCL5QIsdNy4LBvjzLB7y+/Gsfu9KlUF7P+teGAWGpzG
	 dGerS8MCBu1Lg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Avoid overly-narrow keystream XORs
Date: Tue,  3 Nov 2026 22:57:03 -0800
Message-ID: <20261104065703.247316-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

chacha_2block_xor_avx2(), chacha_4block_xor_avx2(),
chacha_2block_xor_avx512vl(), and chacha_4block_xor_avx512vl() currently
XOR the data with the keystream 128 bits at a time.  This is
unnecessarily narrow; the same functions already use 256-bit vectors
elsewhere.  Do it 256 bits at a time instead, which is more efficient.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha-avx2-x86_64.S   | 220 +++++++++-----------------
 lib/crypto/x86/chacha-avx512-x86_64.S | 220 +++++++++-----------------
 2 files changed, 150 insertions(+), 290 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx2-x86_64.S b/lib/crypto/x86/chacha-avx2-x86_64.S
index 0b0cf92a022c..8179a04a3027 100644
--- a/lib/crypto/x86/chacha-avx2-x86_64.S
+++ b/lib/crypto/x86/chacha-avx2-x86_64.S
@@ -135,59 +135,37 @@ SYM_FUNC_START(chacha_2block_xor_avx2)
 	sub		$2,%r8d
 	jnz		.Ldoubleround
 
-	# o0 = i0 ^ (x0 + s0)
-	vpaddd		%ymm8,%ymm0,%ymm7
-	cmp		$0x10,%rax
-	jl		.Lxorpart2
-	vpxor		0x00(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x00(%rsi)
-	vextracti128	$1,%ymm7,%xmm0
-	# o1 = i1 ^ (x1 + s1)
-	vpaddd		%ymm9,%ymm1,%ymm7
-	cmp		$0x20,%rax
-	jl		.Lxorpart2
-	vpxor		0x10(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x10(%rsi)
-	vextracti128	$1,%ymm7,%xmm1
-	# o2 = i2 ^ (x2 + s2)
-	vpaddd		%ymm10,%ymm2,%ymm7
-	cmp		$0x30,%rax
-	jl		.Lxorpart2
-	vpxor		0x20(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x20(%rsi)
-	vextracti128	$1,%ymm7,%xmm2
-	# o3 = i3 ^ (x3 + s3)
-	vpaddd		%ymm11,%ymm3,%ymm7
-	cmp		$0x40,%rax
-	jl		.Lxorpart2
-	vpxor		0x30(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x30(%rsi)
-	vextracti128	$1,%ymm7,%xmm3
+	# x0 += s0, x1 += s1, x2 += s2, x3 += s3
+	vpaddd		%ymm8,%ymm0,%ymm0
+	vpaddd		%ymm9,%ymm1,%ymm1
+	vpaddd		%ymm10,%ymm2,%ymm2
+	vpaddd		%ymm11,%ymm3,%ymm3
 
-	# xor and write second block
-	vmovdqa		%xmm0,%xmm7
-	cmp		$0x50,%rax
+	# xor the data with the keystream
+
+	vperm2i128	$0x20, %ymm1, %ymm0, %ymm4
+	cmp		$1*32,%rax
 	jl		.Lxorpart2
-	vpxor		0x40(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x40(%rsi)
+	vpxor		0*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,0*32(%rsi)
 
-	vmovdqa		%xmm1,%xmm7
-	cmp		$0x60,%rax
+	vperm2i128	$0x20, %ymm3, %ymm2, %ymm4
+	cmp		$2*32,%rax
 	jl		.Lxorpart2
-	vpxor		0x50(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x50(%rsi)
+	vpxor		1*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,1*32(%rsi)
 
-	vmovdqa		%xmm2,%xmm7
-	cmp		$0x70,%rax
+	vperm2i128	$0x31, %ymm1, %ymm0, %ymm4
+	cmp		$3*32,%rax
 	jl		.Lxorpart2
-	vpxor		0x60(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x60(%rsi)
+	vpxor		2*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,2*32(%rsi)
 
-	vmovdqa		%xmm3,%xmm7
-	cmp		$0x80,%rax
+	vperm2i128	$0x31, %ymm3, %ymm2, %ymm4
+	cmp		$4*32,%rax
 	jl		.Lxorpart2
-	vpxor		0x70(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x70(%rsi)
+	vpxor		3*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,3*32(%rsi)
 
 .Ldone2:
 	vzeroupper
@@ -196,14 +174,14 @@ SYM_FUNC_START(chacha_2block_xor_avx2)
 .Lxorpart2:
 	# xor remaining bytes from partial register into output
 	mov		%rax,%r9
-	and		$0x0f,%r9
+	and		$31,%r9
 	jz		.Ldone2
-	and		$~0x0f,%rax
+	and		$~31,%rax
 
 	mov		%rsi,%r11
 
 	lea		8(%rsp),%r10
-	sub		$0x10,%rsp
+	sub		$32,%rsp
 	and		$~31,%rsp
 
 	lea		(%rdx,%rax),%rsi
@@ -211,8 +189,8 @@ SYM_FUNC_START(chacha_2block_xor_avx2)
 	mov		%r9,%rcx
 	rep movsb
 
-	vpxor		0x00(%rsp),%xmm7,%xmm7
-	vmovdqa		%xmm7,0x00(%rsp)
+	vpxor		0x00(%rsp),%ymm4,%ymm4
+	vmovdqa		%ymm4,0x00(%rsp)
 
 	mov		%rsp,%rsi
 	lea		(%r11,%rax),%rdi
@@ -384,113 +362,65 @@ SYM_FUNC_START(chacha_4block_xor_avx2)
 	sub		$2,%r8d
 	jnz		.Ldoubleround4
 
-	# o0 = i0 ^ (x0 + s0), first block
-	vpaddd		%ymm11,%ymm0,%ymm10
-	cmp		$0x10,%rax
-	jl		.Lxorpart4
-	vpxor		0x00(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x00(%rsi)
-	vextracti128	$1,%ymm10,%xmm0
-	# o1 = i1 ^ (x1 + s1), first block
-	vpaddd		%ymm12,%ymm1,%ymm10
-	cmp		$0x20,%rax
-	jl		.Lxorpart4
-	vpxor		0x10(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x10(%rsi)
-	vextracti128	$1,%ymm10,%xmm1
-	# o2 = i2 ^ (x2 + s2), first block
-	vpaddd		%ymm13,%ymm2,%ymm10
-	cmp		$0x30,%rax
-	jl		.Lxorpart4
-	vpxor		0x20(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x20(%rsi)
-	vextracti128	$1,%ymm10,%xmm2
-	# o3 = i3 ^ (x3 + s3), first block
-	vpaddd		%ymm14,%ymm3,%ymm10
-	cmp		$0x40,%rax
-	jl		.Lxorpart4
-	vpxor		0x30(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x30(%rsi)
-	vextracti128	$1,%ymm10,%xmm3
+	# x0 += s0, x1 += s1, x2 += s2, x3 += s3
+	vpaddd		%ymm11,%ymm0,%ymm0
+	vpaddd		%ymm12,%ymm1,%ymm1
+	vpaddd		%ymm13,%ymm2,%ymm2
+	vpaddd		%ymm14,%ymm3,%ymm3
+	vpaddd		%ymm11,%ymm4,%ymm4
+	vpaddd		%ymm12,%ymm5,%ymm5
+	vpaddd		%ymm13,%ymm6,%ymm6
+	vpaddd		%ymm15,%ymm7,%ymm7
 
-	# xor and write second block
-	vmovdqa		%xmm0,%xmm10
-	cmp		$0x50,%rax
-	jl		.Lxorpart4
-	vpxor		0x40(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x40(%rsi)
+	# xor the data with the keystream
 
-	vmovdqa		%xmm1,%xmm10
-	cmp		$0x60,%rax
+	vperm2i128	$0x20, %ymm1, %ymm0, %ymm8
+	cmp		$1*32,%rax
 	jl		.Lxorpart4
-	vpxor		0x50(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x50(%rsi)
+	vpxor		0*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,0*32(%rsi)
 
-	vmovdqa		%xmm2,%xmm10
-	cmp		$0x70,%rax
+	vperm2i128	$0x20, %ymm3, %ymm2, %ymm8
+	cmp		$2*32,%rax
 	jl		.Lxorpart4
-	vpxor		0x60(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x60(%rsi)
+	vpxor		1*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,1*32(%rsi)
 
-	vmovdqa		%xmm3,%xmm10
-	cmp		$0x80,%rax
+	vperm2i128	$0x31, %ymm1, %ymm0, %ymm8
+	cmp		$3*32,%rax
 	jl		.Lxorpart4
-	vpxor		0x70(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x70(%rsi)
+	vpxor		2*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,2*32(%rsi)
 
-	# o0 = i0 ^ (x0 + s0), third block
-	vpaddd		%ymm11,%ymm4,%ymm10
-	cmp		$0x90,%rax
-	jl		.Lxorpart4
-	vpxor		0x80(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x80(%rsi)
-	vextracti128	$1,%ymm10,%xmm4
-	# o1 = i1 ^ (x1 + s1), third block
-	vpaddd		%ymm12,%ymm5,%ymm10
-	cmp		$0xa0,%rax
-	jl		.Lxorpart4
-	vpxor		0x90(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x90(%rsi)
-	vextracti128	$1,%ymm10,%xmm5
-	# o2 = i2 ^ (x2 + s2), third block
-	vpaddd		%ymm13,%ymm6,%ymm10
-	cmp		$0xb0,%rax
-	jl		.Lxorpart4
-	vpxor		0xa0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xa0(%rsi)
-	vextracti128	$1,%ymm10,%xmm6
-	# o3 = i3 ^ (x3 + s3), third block
-	vpaddd		%ymm15,%ymm7,%ymm10
-	cmp		$0xc0,%rax
+	vperm2i128	$0x31, %ymm3, %ymm2, %ymm8
+	cmp		$4*32,%rax
 	jl		.Lxorpart4
-	vpxor		0xb0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xb0(%rsi)
-	vextracti128	$1,%ymm10,%xmm7
+	vpxor		3*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,3*32(%rsi)
 
-	# xor and write fourth block
-	vmovdqa		%xmm4,%xmm10
-	cmp		$0xd0,%rax
+	vperm2i128	$0x20, %ymm5, %ymm4, %ymm8
+	cmp		$5*32,%rax
 	jl		.Lxorpart4
-	vpxor		0xc0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xc0(%rsi)
+	vpxor		4*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,4*32(%rsi)
 
-	vmovdqa		%xmm5,%xmm10
-	cmp		$0xe0,%rax
+	vperm2i128	$0x20, %ymm7, %ymm6, %ymm8
+	cmp		$6*32,%rax
 	jl		.Lxorpart4
-	vpxor		0xd0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xd0(%rsi)
+	vpxor		5*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,5*32(%rsi)
 
-	vmovdqa		%xmm6,%xmm10
-	cmp		$0xf0,%rax
+	vperm2i128	$0x31, %ymm5, %ymm4, %ymm8
+	cmp		$7*32,%rax
 	jl		.Lxorpart4
-	vpxor		0xe0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xe0(%rsi)
+	vpxor		6*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,6*32(%rsi)
 
-	vmovdqa		%xmm7,%xmm10
-	cmp		$0x100,%rax
+	vperm2i128	$0x31, %ymm7, %ymm6, %ymm8
+	cmp		$8*32,%rax
 	jl		.Lxorpart4
-	vpxor		0xf0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xf0(%rsi)
+	vpxor		7*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,7*32(%rsi)
 
 .Ldone4:
 	vzeroupper
@@ -499,14 +429,14 @@ SYM_FUNC_START(chacha_4block_xor_avx2)
 .Lxorpart4:
 	# xor remaining bytes from partial register into output
 	mov		%rax,%r9
-	and		$0x0f,%r9
+	and		$31,%r9
 	jz		.Ldone4
-	and		$~0x0f,%rax
+	and		$~31,%rax
 
 	mov		%rsi,%r11
 
 	lea		8(%rsp),%r10
-	sub		$0x10,%rsp
+	sub		$32,%rsp
 	and		$~31,%rsp
 
 	lea		(%rdx,%rax),%rsi
@@ -514,8 +444,8 @@ SYM_FUNC_START(chacha_4block_xor_avx2)
 	mov		%r9,%rcx
 	rep movsb
 
-	vpxor		0x00(%rsp),%xmm10,%xmm10
-	vmovdqa		%xmm10,0x00(%rsp)
+	vpxor		0x00(%rsp),%ymm8,%ymm8
+	vmovdqa		%ymm8,0x00(%rsp)
 
 	mov		%rsp,%rsi
 	lea		(%r11,%rax),%rdi
diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index bfa708c5e3ee..a0553decd9c5 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -127,59 +127,37 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 	sub		$2,%r8d
 	jnz		.Ldoubleround
 
-	# o0 = i0 ^ (x0 + s0)
-	vpaddd		%ymm8,%ymm0,%ymm7
-	cmp		$0x10,%rcx
-	jl		.Lxorpart2
-	vpxord		0x00(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x00(%rsi)
-	vextracti128	$1,%ymm7,%xmm0
-	# o1 = i1 ^ (x1 + s1)
-	vpaddd		%ymm9,%ymm1,%ymm7
-	cmp		$0x20,%rcx
-	jl		.Lxorpart2
-	vpxord		0x10(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x10(%rsi)
-	vextracti128	$1,%ymm7,%xmm1
-	# o2 = i2 ^ (x2 + s2)
-	vpaddd		%ymm10,%ymm2,%ymm7
-	cmp		$0x30,%rcx
-	jl		.Lxorpart2
-	vpxord		0x20(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x20(%rsi)
-	vextracti128	$1,%ymm7,%xmm2
-	# o3 = i3 ^ (x3 + s3)
-	vpaddd		%ymm11,%ymm3,%ymm7
-	cmp		$0x40,%rcx
-	jl		.Lxorpart2
-	vpxord		0x30(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x30(%rsi)
-	vextracti128	$1,%ymm7,%xmm3
+	# x0 += s0, x1 += s1, x2 += s2, x3 += s3
+	vpaddd		%ymm8,%ymm0,%ymm0
+	vpaddd		%ymm9,%ymm1,%ymm1
+	vpaddd		%ymm10,%ymm2,%ymm2
+	vpaddd		%ymm11,%ymm3,%ymm3
 
-	# xor and write second block
-	vmovdqa		%xmm0,%xmm7
-	cmp		$0x50,%rcx
+	# xor the data with the keystream
+
+	vperm2i128	$0x20, %ymm1, %ymm0, %ymm4
+	cmp		$1*32,%rcx
 	jl		.Lxorpart2
-	vpxord		0x40(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x40(%rsi)
+	vpxor		0*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,0*32(%rsi)
 
-	vmovdqa		%xmm1,%xmm7
-	cmp		$0x60,%rcx
+	vperm2i128	$0x20, %ymm3, %ymm2, %ymm4
+	cmp		$2*32,%rcx
 	jl		.Lxorpart2
-	vpxord		0x50(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x50(%rsi)
+	vpxor		1*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,1*32(%rsi)
 
-	vmovdqa		%xmm2,%xmm7
-	cmp		$0x70,%rcx
+	vperm2i128	$0x31, %ymm1, %ymm0, %ymm4
+	cmp		$3*32,%rcx
 	jl		.Lxorpart2
-	vpxord		0x60(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x60(%rsi)
+	vpxor		2*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,2*32(%rsi)
 
-	vmovdqa		%xmm3,%xmm7
-	cmp		$0x80,%rcx
+	vperm2i128	$0x31, %ymm3, %ymm2, %ymm4
+	cmp		$4*32,%rcx
 	jl		.Lxorpart2
-	vpxord		0x70(%rdx),%xmm7,%xmm6
-	vmovdqu		%xmm6,0x70(%rsi)
+	vpxor		3*32(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,3*32(%rsi)
 
 .Ldone2:
 	vzeroupper
@@ -188,17 +166,17 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 .Lxorpart2:
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%r9
-	and		$~0xf,%r9
-	and		$0xf,%rcx
+	and		$~31,%r9
+	and		$31,%rcx
 	jz		.Ldone2
 
 	mov		$-1,%rax
 	bzhi		%rcx,%rax,%rax
 	kmovq		%rax,%k1
 
-	vmovdqu8	(%rdx,%r9),%xmm1{%k1}{z}
-	vpxord		%xmm7,%xmm1,%xmm1
-	vmovdqu8	%xmm1,(%rsi,%r9){%k1}
+	vmovdqu8	(%rdx,%r9),%ymm0{%k1}{z}
+	vpxor		%ymm4,%ymm0,%ymm0
+	vmovdqu8	%ymm0,(%rsi,%r9){%k1}
 
 	jmp		.Ldone2
 
@@ -335,113 +313,65 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 	sub		$2,%r8d
 	jnz		.Ldoubleround4
 
-	# o0 = i0 ^ (x0 + s0), first block
-	vpaddd		%ymm11,%ymm0,%ymm10
-	cmp		$0x10,%rcx
-	jl		.Lxorpart4
-	vpxord		0x00(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x00(%rsi)
-	vextracti128	$1,%ymm10,%xmm0
-	# o1 = i1 ^ (x1 + s1), first block
-	vpaddd		%ymm12,%ymm1,%ymm10
-	cmp		$0x20,%rcx
-	jl		.Lxorpart4
-	vpxord		0x10(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x10(%rsi)
-	vextracti128	$1,%ymm10,%xmm1
-	# o2 = i2 ^ (x2 + s2), first block
-	vpaddd		%ymm13,%ymm2,%ymm10
-	cmp		$0x30,%rcx
-	jl		.Lxorpart4
-	vpxord		0x20(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x20(%rsi)
-	vextracti128	$1,%ymm10,%xmm2
-	# o3 = i3 ^ (x3 + s3), first block
-	vpaddd		%ymm14,%ymm3,%ymm10
-	cmp		$0x40,%rcx
-	jl		.Lxorpart4
-	vpxord		0x30(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x30(%rsi)
-	vextracti128	$1,%ymm10,%xmm3
+	# x0 += s0, x1 += s1, x2 += s2, x3 += s3
+	vpaddd		%ymm11,%ymm0,%ymm0
+	vpaddd		%ymm12,%ymm1,%ymm1
+	vpaddd		%ymm13,%ymm2,%ymm2
+	vpaddd		%ymm14,%ymm3,%ymm3
+	vpaddd		%ymm11,%ymm4,%ymm4
+	vpaddd		%ymm12,%ymm5,%ymm5
+	vpaddd		%ymm13,%ymm6,%ymm6
+	vpaddd		%ymm15,%ymm7,%ymm7
 
-	# xor and write second block
-	vmovdqa		%xmm0,%xmm10
-	cmp		$0x50,%rcx
-	jl		.Lxorpart4
-	vpxord		0x40(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x40(%rsi)
+	# xor the data with the keystream
 
-	vmovdqa		%xmm1,%xmm10
-	cmp		$0x60,%rcx
+	vperm2i128	$0x20, %ymm1, %ymm0, %ymm8
+	cmp		$1*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0x50(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x50(%rsi)
+	vpxor		0*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,0*32(%rsi)
 
-	vmovdqa		%xmm2,%xmm10
-	cmp		$0x70,%rcx
+	vperm2i128	$0x20, %ymm3, %ymm2, %ymm8
+	cmp		$2*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0x60(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x60(%rsi)
+	vpxor		1*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,1*32(%rsi)
 
-	vmovdqa		%xmm3,%xmm10
-	cmp		$0x80,%rcx
+	vperm2i128	$0x31, %ymm1, %ymm0, %ymm8
+	cmp		$3*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0x70(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x70(%rsi)
+	vpxor		2*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,2*32(%rsi)
 
-	# o0 = i0 ^ (x0 + s0), third block
-	vpaddd		%ymm11,%ymm4,%ymm10
-	cmp		$0x90,%rcx
-	jl		.Lxorpart4
-	vpxord		0x80(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x80(%rsi)
-	vextracti128	$1,%ymm10,%xmm4
-	# o1 = i1 ^ (x1 + s1), third block
-	vpaddd		%ymm12,%ymm5,%ymm10
-	cmp		$0xa0,%rcx
-	jl		.Lxorpart4
-	vpxord		0x90(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0x90(%rsi)
-	vextracti128	$1,%ymm10,%xmm5
-	# o2 = i2 ^ (x2 + s2), third block
-	vpaddd		%ymm13,%ymm6,%ymm10
-	cmp		$0xb0,%rcx
-	jl		.Lxorpart4
-	vpxord		0xa0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xa0(%rsi)
-	vextracti128	$1,%ymm10,%xmm6
-	# o3 = i3 ^ (x3 + s3), third block
-	vpaddd		%ymm15,%ymm7,%ymm10
-	cmp		$0xc0,%rcx
+	vperm2i128	$0x31, %ymm3, %ymm2, %ymm8
+	cmp		$4*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0xb0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xb0(%rsi)
-	vextracti128	$1,%ymm10,%xmm7
+	vpxor		3*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,3*32(%rsi)
 
-	# xor and write fourth block
-	vmovdqa		%xmm4,%xmm10
-	cmp		$0xd0,%rcx
+	vperm2i128	$0x20, %ymm5, %ymm4, %ymm8
+	cmp		$5*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0xc0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xc0(%rsi)
+	vpxor		4*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,4*32(%rsi)
 
-	vmovdqa		%xmm5,%xmm10
-	cmp		$0xe0,%rcx
+	vperm2i128	$0x20, %ymm7, %ymm6, %ymm8
+	cmp		$6*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0xd0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xd0(%rsi)
+	vpxor		5*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,5*32(%rsi)
 
-	vmovdqa		%xmm6,%xmm10
-	cmp		$0xf0,%rcx
+	vperm2i128	$0x31, %ymm5, %ymm4, %ymm8
+	cmp		$7*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0xe0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xe0(%rsi)
+	vpxor		6*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,6*32(%rsi)
 
-	vmovdqa		%xmm7,%xmm10
-	cmp		$0x100,%rcx
+	vperm2i128	$0x31, %ymm7, %ymm6, %ymm8
+	cmp		$8*32,%rcx
 	jl		.Lxorpart4
-	vpxord		0xf0(%rdx),%xmm10,%xmm9
-	vmovdqu		%xmm9,0xf0(%rsi)
+	vpxor		7*32(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,7*32(%rsi)
 
 .Ldone4:
 	vzeroupper
@@ -450,17 +380,17 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 .Lxorpart4:
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%r9
-	and		$~0xf,%r9
-	and		$0xf,%rcx
+	and		$~31,%r9
+	and		$31,%rcx
 	jz		.Ldone4
 
 	mov		$-1,%rax
 	bzhi		%rcx,%rax,%rax
 	kmovq		%rax,%k1
 
-	vmovdqu8	(%rdx,%r9),%xmm1{%k1}{z}
-	vpxord		%xmm10,%xmm1,%xmm1
-	vmovdqu8	%xmm1,(%rsi,%r9){%k1}
+	vmovdqu8	(%rdx,%r9),%ymm0{%k1}{z}
+	vpxor		%ymm8,%ymm0,%ymm0
+	vmovdqu8	%ymm0,(%rsi,%r9){%k1}
 
 	jmp		.Ldone4
 

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
prerequisite-patch-id: 890b33260038bff2e3adfe7867af5919666677fc
prerequisite-patch-id: 36cadf8c358a9778d745637c00368df82a93ce0d
prerequisite-patch-id: b9ef92f4abcdfe8946d645db12187f6293a46381
-- 
2.56.0

