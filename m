Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.202.192.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793619608;
	b=SyvYpQU+PWRAqyRIEHYRJPRBFxX3OaI1ZvykHS6Z+eBbTK1jSw2qfZdVMvepZVE270zv
	 I76FhhA31j434pjZeyCEfICVZklXFPLcA5/HoMV/k4yXZYsewnXkrh2wyVC6cBU7RDQvg
	 EIj2j/Rd7vUv0tECFXeHBpXQM92nykG41kld3dm7rBfOyp7mEmFUjEdCySAxc+HU4h5mV
	 oxes+qkzFeEYJGOuUYNlZ8tOdCB3IsQgGn+bPsX0hv9ptSnNTPYZq+Csbx/1/5pTh6Zwq
	 ZUqe31HnRGh7Ol9EwWenJpZ0nHPjj3e2Jyb/zdycvJj7zS4EdD0MVer+n1/UMszlILg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793619608;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Uq/ZCoPTH0XGHsBq3JFsYN+r77aZl4TGYVNjWmwmeEw=;
	b=fh6Cs2DCBxIj89RQksb/RiKG+ZOiGB1JGi3WXkXLfHo3hlGQ/Vvs9ljuO1mtCQHByhNt
	 4ILa6XteswZJR1aXrwXPt7atb52iZMdczfSeeTRTwDaY/MQC0vkhaM5uWPeiavouXuPgj
	 kUwntsk9+lzkvjOyxNNltsygOi4hdN17PVMW7I+ZfIo/vPWmudHUhsxDl0Xq3aSlYnZ8o
	 yXNWh1gJrvvOBO1x782NYib4uJFgemMeI8zo4DzqdfZedgxOZInKjeKpuKUVbBhnBCBmU
	 gzqi9cWyW+z0AFS1TJgGF/T2W5bBvwDId7vC2yoMEJex8O8J+UqevjMqOFUUSP3/CEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=strongswan.org;
	spf=pass smtp.mailfrom=strongswan.org;
	dkim=pass header.d=strongswan.org header.i=@strongswan.org header.a=rsa-sha256 header.s=default header.b=hdOnvSst;
	arc=none smtp.remote-ip=109.202.192.35
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C66606A324
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 11:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59C66606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strongswan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=strongswan.org header.i=@strongswan.org header.a=rsa-sha256 header.s=default header.b=hdOnvSst
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id C21655A0007;
	Mon, 02 Nov 2026 12:39:58 +0100 (CET)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id 5U_VrSL3SejQ; Mon,  2 Nov 2026 12:39:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1793619596;
	bh=LoxWzGtdCZPSYcwMIr6yJwILLHno6CdGqejfzikpquI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdOnvSstFJVWPf0wdHgw0aPFga74TSFLR17u/DtD/VjYyiGAS1ThRTObVC/gAmclX
	 7chxt6BsrhRu/Mh6zn22+sVJUsB1eaWIeMrJJAct8wAbaOi1X5jvywT65TEEFpfmQG
	 NcY+0BHZYT1sabfJQUqbWjLPKDhMmVoXu85y2drX0zxRF8kp61hAEnPGbJ8dJQSsVF
	 HCklcgFhJYmfdidsEmpPHTx9XqbCt1qMmzCtmW1F+ZCXZ+SsmrznI79pupOme27R2E
	 e9+qLvmE4SoL0hN97QPSW2sq9fcLCIE84C6Nb0qUFUj1bI20FfmimwNPyS/4JYjmns
	 /bqX3firbPlVw==
Received: from ee00200a.home (unknown [185.12.128.224])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 6171E5A0006;
	Mon, 02 Nov 2026 12:39:56 +0100 (CET)
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: [PATCH v2 2/3] lib/crypto: x86/chacha: Wrap the 8-block AVX-512 code in a macro
Date: Mon,  2 Nov 2026 12:39:25 +0100
Message-ID: <20261102113926.2765176-3-martin@strongswan.org>
In-Reply-To: <20261102113926.2765176-1-martin@strongswan.org>
References: <20261102113926.2765176-1-martin@strongswan.org>
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

An upcoming 16-block zmm function shares almost everything with the
existing 8-block ymm function. Prepare for it by wrapping the 8-block
code in a macro parameterized by vector length.

The generated code stays byte-identical.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 lib/crypto/x86/chacha-avx512-x86_64.S | 580 ++++++++++++++------------
 1 file changed, 302 insertions(+), 278 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index cf784e148bdf..35e73de1c870 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -17,13 +17,28 @@ CTR2BL:	.octa 0x00000000000000000000000000000000
 CTR4BL:	.octa 0x00000000000000000000000000000002
 	.octa 0x00000000000000000000000000000003
 
-.section	.rodata.cst32.CTR8BL, "aM", @progbits, 32
+.section	.rodata.cst32.CTRBL, "aM", @progbits, 32
 .align 32
-CTR8BL:	.octa 0x00000003000000020000000100000000
+CTRBL:	.octa 0x00000003000000020000000100000000
 	.octa 0x00000007000000060000000500000004
 
 .text
 
+.macro _define_Vi	i
+.if VL == 32
+	.set	V\i,		%ymm\i
+.else
+	.error	"Unsupported vector length"
+.endif
+.endm
+
+.macro _define_aliases
+	# alias V0-V31 to the vector registers of the selected width VL
+.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	_define_Vi	\i
+.endr
+.endm
+
 SYM_FUNC_START(chacha_2block_xor_avx512vl)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 2 data blocks output, o
@@ -455,382 +470,391 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 
 SYM_FUNC_END(chacha_4block_xor_avx512vl)
 
-SYM_FUNC_START(chacha_8block_xor_avx512vl)
+.macro _chacha_words	vl
+	.set	VL,		\vl
+
+	_define_aliases
+
 	# %rdi: Input state matrix, s
-	# %rsi: up to 8 data blocks output, o
-	# %rdx: up to 8 data blocks input, i
+	# %rsi: up to VL/4 data blocks output, o
+	# %rdx: up to VL/4 data blocks input, i
 	# %rcx: input/output length in bytes
 	# %r8d: nrounds
 
-	# This function encrypts eight consecutive ChaCha blocks by loading
-	# the state matrix in AVX registers eight times. Compared to AVX2, this
-	# mostly benefits from the new rotate instructions in VL and the
-	# additional registers.
+	# This encrypts VL/4 consecutive ChaCha blocks by loading the state
+	# matrix in as many vector registers. Compared to AVX2, this mostly
+	# benefits from the new rotate instructions and the additional
+	# registers.
+	#
+	# VL=32 encrypts eight blocks in 256-bit ymm registers.
 
 	vzeroupper
 
-	# x0..15[0-7] = s[0..15]
-	vpbroadcastd	0x00(%rdi),%ymm0
-	vpbroadcastd	0x04(%rdi),%ymm1
-	vpbroadcastd	0x08(%rdi),%ymm2
-	vpbroadcastd	0x0c(%rdi),%ymm3
-	vpbroadcastd	0x10(%rdi),%ymm4
-	vpbroadcastd	0x14(%rdi),%ymm5
-	vpbroadcastd	0x18(%rdi),%ymm6
-	vpbroadcastd	0x1c(%rdi),%ymm7
-	vpbroadcastd	0x20(%rdi),%ymm8
-	vpbroadcastd	0x24(%rdi),%ymm9
-	vpbroadcastd	0x28(%rdi),%ymm10
-	vpbroadcastd	0x2c(%rdi),%ymm11
-	vpbroadcastd	0x30(%rdi),%ymm12
-	vpbroadcastd	0x34(%rdi),%ymm13
-	vpbroadcastd	0x38(%rdi),%ymm14
-	vpbroadcastd	0x3c(%rdi),%ymm15
-
-	# x12 += counter values 0-3
-	vpaddd		CTR8BL(%rip),%ymm12,%ymm12
-
-	vmovdqa64	%ymm0,%ymm16
-	vmovdqa64	%ymm1,%ymm17
-	vmovdqa64	%ymm2,%ymm18
-	vmovdqa64	%ymm3,%ymm19
-	vmovdqa64	%ymm4,%ymm20
-	vmovdqa64	%ymm5,%ymm21
-	vmovdqa64	%ymm6,%ymm22
-	vmovdqa64	%ymm7,%ymm23
-	vmovdqa64	%ymm8,%ymm24
-	vmovdqa64	%ymm9,%ymm25
-	vmovdqa64	%ymm10,%ymm26
-	vmovdqa64	%ymm11,%ymm27
-	vmovdqa64	%ymm12,%ymm28
-	vmovdqa64	%ymm13,%ymm29
-	vmovdqa64	%ymm14,%ymm30
-	vmovdqa64	%ymm15,%ymm31
-
-.Ldoubleround8:
+	# x0..15[0-VL/4] = s[0..15]
+	vpbroadcastd	0x00(%rdi),V0
+	vpbroadcastd	0x04(%rdi),V1
+	vpbroadcastd	0x08(%rdi),V2
+	vpbroadcastd	0x0c(%rdi),V3
+	vpbroadcastd	0x10(%rdi),V4
+	vpbroadcastd	0x14(%rdi),V5
+	vpbroadcastd	0x18(%rdi),V6
+	vpbroadcastd	0x1c(%rdi),V7
+	vpbroadcastd	0x20(%rdi),V8
+	vpbroadcastd	0x24(%rdi),V9
+	vpbroadcastd	0x28(%rdi),V10
+	vpbroadcastd	0x2c(%rdi),V11
+	vpbroadcastd	0x30(%rdi),V12
+	vpbroadcastd	0x34(%rdi),V13
+	vpbroadcastd	0x38(%rdi),V14
+	vpbroadcastd	0x3c(%rdi),V15
+
+	# x12 += counter values, one per block
+	vpaddd		CTRBL(%rip),V12,V12
+
+	vmovdqa64	V0,V16
+	vmovdqa64	V1,V17
+	vmovdqa64	V2,V18
+	vmovdqa64	V3,V19
+	vmovdqa64	V4,V20
+	vmovdqa64	V5,V21
+	vmovdqa64	V6,V22
+	vmovdqa64	V7,V23
+	vmovdqa64	V8,V24
+	vmovdqa64	V9,V25
+	vmovdqa64	V10,V26
+	vmovdqa64	V11,V27
+	vmovdqa64	V12,V28
+	vmovdqa64	V13,V29
+	vmovdqa64	V14,V30
+	vmovdqa64	V15,V31
+
+.Ldoubleround\@:
 	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
-	vpaddd		%ymm0,%ymm4,%ymm0
-	vpxord		%ymm0,%ymm12,%ymm12
-	vprold		$16,%ymm12,%ymm12
+	vpaddd		V0,V4,V0
+	vpxord		V0,V12,V12
+	vprold		$16,V12,V12
 	# x1 += x5, x13 = rotl32(x13 ^ x1, 16)
-	vpaddd		%ymm1,%ymm5,%ymm1
-	vpxord		%ymm1,%ymm13,%ymm13
-	vprold		$16,%ymm13,%ymm13
+	vpaddd		V1,V5,V1
+	vpxord		V1,V13,V13
+	vprold		$16,V13,V13
 	# x2 += x6, x14 = rotl32(x14 ^ x2, 16)
-	vpaddd		%ymm2,%ymm6,%ymm2
-	vpxord		%ymm2,%ymm14,%ymm14
-	vprold		$16,%ymm14,%ymm14
+	vpaddd		V2,V6,V2
+	vpxord		V2,V14,V14
+	vprold		$16,V14,V14
 	# x3 += x7, x15 = rotl32(x15 ^ x3, 16)
-	vpaddd		%ymm3,%ymm7,%ymm3
-	vpxord		%ymm3,%ymm15,%ymm15
-	vprold		$16,%ymm15,%ymm15
+	vpaddd		V3,V7,V3
+	vpxord		V3,V15,V15
+	vprold		$16,V15,V15
 
 	# x8 += x12, x4 = rotl32(x4 ^ x8, 12)
-	vpaddd		%ymm12,%ymm8,%ymm8
-	vpxord		%ymm8,%ymm4,%ymm4
-	vprold		$12,%ymm4,%ymm4
+	vpaddd		V12,V8,V8
+	vpxord		V8,V4,V4
+	vprold		$12,V4,V4
 	# x9 += x13, x5 = rotl32(x5 ^ x9, 12)
-	vpaddd		%ymm13,%ymm9,%ymm9
-	vpxord		%ymm9,%ymm5,%ymm5
-	vprold		$12,%ymm5,%ymm5
+	vpaddd		V13,V9,V9
+	vpxord		V9,V5,V5
+	vprold		$12,V5,V5
 	# x10 += x14, x6 = rotl32(x6 ^ x10, 12)
-	vpaddd		%ymm14,%ymm10,%ymm10
-	vpxord		%ymm10,%ymm6,%ymm6
-	vprold		$12,%ymm6,%ymm6
+	vpaddd		V14,V10,V10
+	vpxord		V10,V6,V6
+	vprold		$12,V6,V6
 	# x11 += x15, x7 = rotl32(x7 ^ x11, 12)
-	vpaddd		%ymm15,%ymm11,%ymm11
-	vpxord		%ymm11,%ymm7,%ymm7
-	vprold		$12,%ymm7,%ymm7
+	vpaddd		V15,V11,V11
+	vpxord		V11,V7,V7
+	vprold		$12,V7,V7
 
 	# x0 += x4, x12 = rotl32(x12 ^ x0, 8)
-	vpaddd		%ymm0,%ymm4,%ymm0
-	vpxord		%ymm0,%ymm12,%ymm12
-	vprold		$8,%ymm12,%ymm12
+	vpaddd		V0,V4,V0
+	vpxord		V0,V12,V12
+	vprold		$8,V12,V12
 	# x1 += x5, x13 = rotl32(x13 ^ x1, 8)
-	vpaddd		%ymm1,%ymm5,%ymm1
-	vpxord		%ymm1,%ymm13,%ymm13
-	vprold		$8,%ymm13,%ymm13
+	vpaddd		V1,V5,V1
+	vpxord		V1,V13,V13
+	vprold		$8,V13,V13
 	# x2 += x6, x14 = rotl32(x14 ^ x2, 8)
-	vpaddd		%ymm2,%ymm6,%ymm2
-	vpxord		%ymm2,%ymm14,%ymm14
-	vprold		$8,%ymm14,%ymm14
+	vpaddd		V2,V6,V2
+	vpxord		V2,V14,V14
+	vprold		$8,V14,V14
 	# x3 += x7, x15 = rotl32(x15 ^ x3, 8)
-	vpaddd		%ymm3,%ymm7,%ymm3
-	vpxord		%ymm3,%ymm15,%ymm15
-	vprold		$8,%ymm15,%ymm15
+	vpaddd		V3,V7,V3
+	vpxord		V3,V15,V15
+	vprold		$8,V15,V15
 
 	# x8 += x12, x4 = rotl32(x4 ^ x8, 7)
-	vpaddd		%ymm12,%ymm8,%ymm8
-	vpxord		%ymm8,%ymm4,%ymm4
-	vprold		$7,%ymm4,%ymm4
+	vpaddd		V12,V8,V8
+	vpxord		V8,V4,V4
+	vprold		$7,V4,V4
 	# x9 += x13, x5 = rotl32(x5 ^ x9, 7)
-	vpaddd		%ymm13,%ymm9,%ymm9
-	vpxord		%ymm9,%ymm5,%ymm5
-	vprold		$7,%ymm5,%ymm5
+	vpaddd		V13,V9,V9
+	vpxord		V9,V5,V5
+	vprold		$7,V5,V5
 	# x10 += x14, x6 = rotl32(x6 ^ x10, 7)
-	vpaddd		%ymm14,%ymm10,%ymm10
-	vpxord		%ymm10,%ymm6,%ymm6
-	vprold		$7,%ymm6,%ymm6
+	vpaddd		V14,V10,V10
+	vpxord		V10,V6,V6
+	vprold		$7,V6,V6
 	# x11 += x15, x7 = rotl32(x7 ^ x11, 7)
-	vpaddd		%ymm15,%ymm11,%ymm11
-	vpxord		%ymm11,%ymm7,%ymm7
-	vprold		$7,%ymm7,%ymm7
+	vpaddd		V15,V11,V11
+	vpxord		V11,V7,V7
+	vprold		$7,V7,V7
 
 	# x0 += x5, x15 = rotl32(x15 ^ x0, 16)
-	vpaddd		%ymm0,%ymm5,%ymm0
-	vpxord		%ymm0,%ymm15,%ymm15
-	vprold		$16,%ymm15,%ymm15
+	vpaddd		V0,V5,V0
+	vpxord		V0,V15,V15
+	vprold		$16,V15,V15
 	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)
-	vpaddd		%ymm1,%ymm6,%ymm1
-	vpxord		%ymm1,%ymm12,%ymm12
-	vprold		$16,%ymm12,%ymm12
+	vpaddd		V1,V6,V1
+	vpxord		V1,V12,V12
+	vprold		$16,V12,V12
 	# x2 += x7, x13 = rotl32(x13 ^ x2, 16)
-	vpaddd		%ymm2,%ymm7,%ymm2
-	vpxord		%ymm2,%ymm13,%ymm13
-	vprold		$16,%ymm13,%ymm13
+	vpaddd		V2,V7,V2
+	vpxord		V2,V13,V13
+	vprold		$16,V13,V13
 	# x3 += x4, x14 = rotl32(x14 ^ x3, 16)
-	vpaddd		%ymm3,%ymm4,%ymm3
-	vpxord		%ymm3,%ymm14,%ymm14
-	vprold		$16,%ymm14,%ymm14
+	vpaddd		V3,V4,V3
+	vpxord		V3,V14,V14
+	vprold		$16,V14,V14
 
 	# x10 += x15, x5 = rotl32(x5 ^ x10, 12)
-	vpaddd		%ymm15,%ymm10,%ymm10
-	vpxord		%ymm10,%ymm5,%ymm5
-	vprold		$12,%ymm5,%ymm5
+	vpaddd		V15,V10,V10
+	vpxord		V10,V5,V5
+	vprold		$12,V5,V5
 	# x11 += x12, x6 = rotl32(x6 ^ x11, 12)
-	vpaddd		%ymm12,%ymm11,%ymm11
-	vpxord		%ymm11,%ymm6,%ymm6
-	vprold		$12,%ymm6,%ymm6
+	vpaddd		V12,V11,V11
+	vpxord		V11,V6,V6
+	vprold		$12,V6,V6
 	# x8 += x13, x7 = rotl32(x7 ^ x8, 12)
-	vpaddd		%ymm13,%ymm8,%ymm8
-	vpxord		%ymm8,%ymm7,%ymm7
-	vprold		$12,%ymm7,%ymm7
+	vpaddd		V13,V8,V8
+	vpxord		V8,V7,V7
+	vprold		$12,V7,V7
 	# x9 += x14, x4 = rotl32(x4 ^ x9, 12)
-	vpaddd		%ymm14,%ymm9,%ymm9
-	vpxord		%ymm9,%ymm4,%ymm4
-	vprold		$12,%ymm4,%ymm4
+	vpaddd		V14,V9,V9
+	vpxord		V9,V4,V4
+	vprold		$12,V4,V4
 
 	# x0 += x5, x15 = rotl32(x15 ^ x0, 8)
-	vpaddd		%ymm0,%ymm5,%ymm0
-	vpxord		%ymm0,%ymm15,%ymm15
-	vprold		$8,%ymm15,%ymm15
+	vpaddd		V0,V5,V0
+	vpxord		V0,V15,V15
+	vprold		$8,V15,V15
 	# x1 += x6, x12 = rotl32(x12 ^ x1, 8)
-	vpaddd		%ymm1,%ymm6,%ymm1
-	vpxord		%ymm1,%ymm12,%ymm12
-	vprold		$8,%ymm12,%ymm12
+	vpaddd		V1,V6,V1
+	vpxord		V1,V12,V12
+	vprold		$8,V12,V12
 	# x2 += x7, x13 = rotl32(x13 ^ x2, 8)
-	vpaddd		%ymm2,%ymm7,%ymm2
-	vpxord		%ymm2,%ymm13,%ymm13
-	vprold		$8,%ymm13,%ymm13
+	vpaddd		V2,V7,V2
+	vpxord		V2,V13,V13
+	vprold		$8,V13,V13
 	# x3 += x4, x14 = rotl32(x14 ^ x3, 8)
-	vpaddd		%ymm3,%ymm4,%ymm3
-	vpxord		%ymm3,%ymm14,%ymm14
-	vprold		$8,%ymm14,%ymm14
+	vpaddd		V3,V4,V3
+	vpxord		V3,V14,V14
+	vprold		$8,V14,V14
 
 	# x10 += x15, x5 = rotl32(x5 ^ x10, 7)
-	vpaddd		%ymm15,%ymm10,%ymm10
-	vpxord		%ymm10,%ymm5,%ymm5
-	vprold		$7,%ymm5,%ymm5
+	vpaddd		V15,V10,V10
+	vpxord		V10,V5,V5
+	vprold		$7,V5,V5
 	# x11 += x12, x6 = rotl32(x6 ^ x11, 7)
-	vpaddd		%ymm12,%ymm11,%ymm11
-	vpxord		%ymm11,%ymm6,%ymm6
-	vprold		$7,%ymm6,%ymm6
+	vpaddd		V12,V11,V11
+	vpxord		V11,V6,V6
+	vprold		$7,V6,V6
 	# x8 += x13, x7 = rotl32(x7 ^ x8, 7)
-	vpaddd		%ymm13,%ymm8,%ymm8
-	vpxord		%ymm8,%ymm7,%ymm7
-	vprold		$7,%ymm7,%ymm7
+	vpaddd		V13,V8,V8
+	vpxord		V8,V7,V7
+	vprold		$7,V7,V7
 	# x9 += x14, x4 = rotl32(x4 ^ x9, 7)
-	vpaddd		%ymm14,%ymm9,%ymm9
-	vpxord		%ymm9,%ymm4,%ymm4
-	vprold		$7,%ymm4,%ymm4
+	vpaddd		V14,V9,V9
+	vpxord		V9,V4,V4
+	vprold		$7,V4,V4
 
 	sub		$2,%r8d
-	jnz		.Ldoubleround8
-
-	# x0..15[0-3] += s[0..15]
-	vpaddd		%ymm16,%ymm0,%ymm0
-	vpaddd		%ymm17,%ymm1,%ymm1
-	vpaddd		%ymm18,%ymm2,%ymm2
-	vpaddd		%ymm19,%ymm3,%ymm3
-	vpaddd		%ymm20,%ymm4,%ymm4
-	vpaddd		%ymm21,%ymm5,%ymm5
-	vpaddd		%ymm22,%ymm6,%ymm6
-	vpaddd		%ymm23,%ymm7,%ymm7
-	vpaddd		%ymm24,%ymm8,%ymm8
-	vpaddd		%ymm25,%ymm9,%ymm9
-	vpaddd		%ymm26,%ymm10,%ymm10
-	vpaddd		%ymm27,%ymm11,%ymm11
-	vpaddd		%ymm28,%ymm12,%ymm12
-	vpaddd		%ymm29,%ymm13,%ymm13
-	vpaddd		%ymm30,%ymm14,%ymm14
-	vpaddd		%ymm31,%ymm15,%ymm15
+	jnz		.Ldoubleround\@
+
+	# x0..15 += s[0..15]
+	vpaddd		V16,V0,V0
+	vpaddd		V17,V1,V1
+	vpaddd		V18,V2,V2
+	vpaddd		V19,V3,V3
+	vpaddd		V20,V4,V4
+	vpaddd		V21,V5,V5
+	vpaddd		V22,V6,V6
+	vpaddd		V23,V7,V7
+	vpaddd		V24,V8,V8
+	vpaddd		V25,V9,V9
+	vpaddd		V26,V10,V10
+	vpaddd		V27,V11,V11
+	vpaddd		V28,V12,V12
+	vpaddd		V29,V13,V13
+	vpaddd		V30,V14,V14
+	vpaddd		V31,V15,V15
 
 	# interleave 32-bit words in state n, n+1
-	vpunpckldq	%ymm1,%ymm0,%ymm16
-	vpunpckhdq	%ymm1,%ymm0,%ymm17
-	vpunpckldq	%ymm3,%ymm2,%ymm18
-	vpunpckhdq	%ymm3,%ymm2,%ymm19
-	vpunpckldq	%ymm5,%ymm4,%ymm20
-	vpunpckhdq	%ymm5,%ymm4,%ymm21
-	vpunpckldq	%ymm7,%ymm6,%ymm22
-	vpunpckhdq	%ymm7,%ymm6,%ymm23
-	vpunpckldq	%ymm9,%ymm8,%ymm24
-	vpunpckhdq	%ymm9,%ymm8,%ymm25
-	vpunpckldq	%ymm11,%ymm10,%ymm26
-	vpunpckhdq	%ymm11,%ymm10,%ymm27
-	vpunpckldq	%ymm13,%ymm12,%ymm28
-	vpunpckhdq	%ymm13,%ymm12,%ymm29
-	vpunpckldq	%ymm15,%ymm14,%ymm30
-	vpunpckhdq	%ymm15,%ymm14,%ymm31
+	vpunpckldq	V1,V0,V16
+	vpunpckhdq	V1,V0,V17
+	vpunpckldq	V3,V2,V18
+	vpunpckhdq	V3,V2,V19
+	vpunpckldq	V5,V4,V20
+	vpunpckhdq	V5,V4,V21
+	vpunpckldq	V7,V6,V22
+	vpunpckhdq	V7,V6,V23
+	vpunpckldq	V9,V8,V24
+	vpunpckhdq	V9,V8,V25
+	vpunpckldq	V11,V10,V26
+	vpunpckhdq	V11,V10,V27
+	vpunpckldq	V13,V12,V28
+	vpunpckhdq	V13,V12,V29
+	vpunpckldq	V15,V14,V30
+	vpunpckhdq	V15,V14,V31
 
 	# interleave 64-bit words in state n, n+2
-	vpunpcklqdq	%ymm18,%ymm16,%ymm0
-	vpunpcklqdq	%ymm19,%ymm17,%ymm1
-	vpunpckhqdq	%ymm18,%ymm16,%ymm2
-	vpunpckhqdq	%ymm19,%ymm17,%ymm3
-	vpunpcklqdq	%ymm22,%ymm20,%ymm4
-	vpunpcklqdq	%ymm23,%ymm21,%ymm5
-	vpunpckhqdq	%ymm22,%ymm20,%ymm6
-	vpunpckhqdq	%ymm23,%ymm21,%ymm7
-	vpunpcklqdq	%ymm26,%ymm24,%ymm8
-	vpunpcklqdq	%ymm27,%ymm25,%ymm9
-	vpunpckhqdq	%ymm26,%ymm24,%ymm10
-	vpunpckhqdq	%ymm27,%ymm25,%ymm11
-	vpunpcklqdq	%ymm30,%ymm28,%ymm12
-	vpunpcklqdq	%ymm31,%ymm29,%ymm13
-	vpunpckhqdq	%ymm30,%ymm28,%ymm14
-	vpunpckhqdq	%ymm31,%ymm29,%ymm15
+	vpunpcklqdq	V18,V16,V0
+	vpunpcklqdq	V19,V17,V1
+	vpunpckhqdq	V18,V16,V2
+	vpunpckhqdq	V19,V17,V3
+	vpunpcklqdq	V22,V20,V4
+	vpunpcklqdq	V23,V21,V5
+	vpunpckhqdq	V22,V20,V6
+	vpunpckhqdq	V23,V21,V7
+	vpunpcklqdq	V26,V24,V8
+	vpunpcklqdq	V27,V25,V9
+	vpunpckhqdq	V26,V24,V10
+	vpunpckhqdq	V27,V25,V11
+	vpunpcklqdq	V30,V28,V12
+	vpunpcklqdq	V31,V29,V13
+	vpunpckhqdq	V30,V28,V14
+	vpunpckhqdq	V31,V29,V15
 
 	# interleave 128-bit words in state n, n+4
 	# xor/write first four blocks
-	vmovdqa64	%ymm0,%ymm16
-	vperm2i128	$0x20,%ymm4,%ymm0,%ymm0
+	vmovdqa64	V0,V16
+	vperm2i128	$0x20,V4,V0,V0
 	cmp		$0x0020,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0000(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0000(%rsi)
-	vmovdqa64	%ymm16,%ymm0
-	vperm2i128	$0x31,%ymm4,%ymm0,%ymm4
+	jl		.Lxorpart\@
+	vpxord		0x0000(%rdx),V0,V0
+	vmovdqu64	V0,0x0000(%rsi)
+	vmovdqa64	V16,V0
+	vperm2i128	$0x31,V4,V0,V4
 
-	vperm2i128	$0x20,%ymm12,%ymm8,%ymm0
+	vperm2i128	$0x20,V12,V8,V0
 	cmp		$0x0040,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0020(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0020(%rsi)
-	vperm2i128	$0x31,%ymm12,%ymm8,%ymm12
+	jl		.Lxorpart\@
+	vpxord		0x0020(%rdx),V0,V0
+	vmovdqu64	V0,0x0020(%rsi)
+	vperm2i128	$0x31,V12,V8,V12
 
-	vperm2i128	$0x20,%ymm6,%ymm2,%ymm0
+	vperm2i128	$0x20,V6,V2,V0
 	cmp		$0x0060,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0040(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0040(%rsi)
-	vperm2i128	$0x31,%ymm6,%ymm2,%ymm6
+	jl		.Lxorpart\@
+	vpxord		0x0040(%rdx),V0,V0
+	vmovdqu64	V0,0x0040(%rsi)
+	vperm2i128	$0x31,V6,V2,V6
 
-	vperm2i128	$0x20,%ymm14,%ymm10,%ymm0
+	vperm2i128	$0x20,V14,V10,V0
 	cmp		$0x0080,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0060(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0060(%rsi)
-	vperm2i128	$0x31,%ymm14,%ymm10,%ymm14
+	jl		.Lxorpart\@
+	vpxord		0x0060(%rdx),V0,V0
+	vmovdqu64	V0,0x0060(%rsi)
+	vperm2i128	$0x31,V14,V10,V14
 
-	vperm2i128	$0x20,%ymm5,%ymm1,%ymm0
+	vperm2i128	$0x20,V5,V1,V0
 	cmp		$0x00a0,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0080(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0080(%rsi)
-	vperm2i128	$0x31,%ymm5,%ymm1,%ymm5
+	jl		.Lxorpart\@
+	vpxord		0x0080(%rdx),V0,V0
+	vmovdqu64	V0,0x0080(%rsi)
+	vperm2i128	$0x31,V5,V1,V5
 
-	vperm2i128	$0x20,%ymm13,%ymm9,%ymm0
+	vperm2i128	$0x20,V13,V9,V0
 	cmp		$0x00c0,%rcx
-	jl		.Lxorpart8
-	vpxord		0x00a0(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x00a0(%rsi)
-	vperm2i128	$0x31,%ymm13,%ymm9,%ymm13
+	jl		.Lxorpart\@
+	vpxord		0x00a0(%rdx),V0,V0
+	vmovdqu64	V0,0x00a0(%rsi)
+	vperm2i128	$0x31,V13,V9,V13
 
-	vperm2i128	$0x20,%ymm7,%ymm3,%ymm0
+	vperm2i128	$0x20,V7,V3,V0
 	cmp		$0x00e0,%rcx
-	jl		.Lxorpart8
-	vpxord		0x00c0(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x00c0(%rsi)
-	vperm2i128	$0x31,%ymm7,%ymm3,%ymm7
+	jl		.Lxorpart\@
+	vpxord		0x00c0(%rdx),V0,V0
+	vmovdqu64	V0,0x00c0(%rsi)
+	vperm2i128	$0x31,V7,V3,V7
 
-	vperm2i128	$0x20,%ymm15,%ymm11,%ymm0
+	vperm2i128	$0x20,V15,V11,V0
 	cmp		$0x0100,%rcx
-	jl		.Lxorpart8
-	vpxord		0x00e0(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x00e0(%rsi)
-	vperm2i128	$0x31,%ymm15,%ymm11,%ymm15
+	jl		.Lxorpart\@
+	vpxord		0x00e0(%rdx),V0,V0
+	vmovdqu64	V0,0x00e0(%rsi)
+	vperm2i128	$0x31,V15,V11,V15
 
 	# xor remaining blocks, write to output
-	vmovdqa64	%ymm4,%ymm0
+	vmovdqa64	V4,V0
 	cmp		$0x0120,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0100(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0100(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x0100(%rdx),V0,V0
+	vmovdqu64	V0,0x0100(%rsi)
 
-	vmovdqa64	%ymm12,%ymm0
+	vmovdqa64	V12,V0
 	cmp		$0x0140,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0120(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0120(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x0120(%rdx),V0,V0
+	vmovdqu64	V0,0x0120(%rsi)
 
-	vmovdqa64	%ymm6,%ymm0
+	vmovdqa64	V6,V0
 	cmp		$0x0160,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0140(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0140(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x0140(%rdx),V0,V0
+	vmovdqu64	V0,0x0140(%rsi)
 
-	vmovdqa64	%ymm14,%ymm0
+	vmovdqa64	V14,V0
 	cmp		$0x0180,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0160(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0160(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x0160(%rdx),V0,V0
+	vmovdqu64	V0,0x0160(%rsi)
 
-	vmovdqa64	%ymm5,%ymm0
+	vmovdqa64	V5,V0
 	cmp		$0x01a0,%rcx
-	jl		.Lxorpart8
-	vpxord		0x0180(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x0180(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x0180(%rdx),V0,V0
+	vmovdqu64	V0,0x0180(%rsi)
 
-	vmovdqa64	%ymm13,%ymm0
+	vmovdqa64	V13,V0
 	cmp		$0x01c0,%rcx
-	jl		.Lxorpart8
-	vpxord		0x01a0(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x01a0(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x01a0(%rdx),V0,V0
+	vmovdqu64	V0,0x01a0(%rsi)
 
-	vmovdqa64	%ymm7,%ymm0
+	vmovdqa64	V7,V0
 	cmp		$0x01e0,%rcx
-	jl		.Lxorpart8
-	vpxord		0x01c0(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x01c0(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x01c0(%rdx),V0,V0
+	vmovdqu64	V0,0x01c0(%rsi)
 
-	vmovdqa64	%ymm15,%ymm0
+	vmovdqa64	V15,V0
 	cmp		$0x0200,%rcx
-	jl		.Lxorpart8
-	vpxord		0x01e0(%rdx),%ymm0,%ymm0
-	vmovdqu64	%ymm0,0x01e0(%rsi)
+	jl		.Lxorpart\@
+	vpxord		0x01e0(%rdx),V0,V0
+	vmovdqu64	V0,0x01e0(%rsi)
 
-.Ldone8:
+.Ldone\@:
 	vzeroupper
 	RET
 
-.Lxorpart8:
+.Lxorpart\@:
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%rax
-	and		$0x1f,%rcx
-	jz		.Ldone8
+	and		$(VL - 1),%rcx
+	jz		.Ldone\@
 	mov		%rax,%r9
-	and		$~0x1f,%r9
+	and		$~(VL - 1),%r9
 
 	mov		$1,%rax
 	shld		%cl,%rax,%rax
 	sub		$1,%rax
 	kmovq		%rax,%k1
 
-	vmovdqu8	(%rdx,%r9),%ymm1{%k1}{z}
-	vpxord		%ymm0,%ymm1,%ymm1
-	vmovdqu8	%ymm1,(%rsi,%r9){%k1}
+	vmovdqu8	(%rdx,%r9),V1{%k1}{z}
+	vpxord		V0,V1,V1
+	vmovdqu8	V1,(%rsi,%r9){%k1}
 
-	jmp		.Ldone8
+	jmp		.Ldone\@
+.endm
 
+SYM_FUNC_START(chacha_8block_xor_avx512vl)
+	_chacha_words	vl=32
 SYM_FUNC_END(chacha_8block_xor_avx512vl)
-- 
2.53.0

