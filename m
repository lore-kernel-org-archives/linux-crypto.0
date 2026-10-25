Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792972100;
	b=Yl/cFuBRYkQan5PkAr5/O2e2nnRnVUGOong8MmuoJdsR9doI1f/a5euHbpXF35Ehu97N
	 UJoicQom5VJuC9yDCuee3tJK8nAnxZdQ9dL1ZjBCUdY4JY41HvUn72nL91sG37ivcjMN3
	 0oKakn77iBFHxiy4uK2sUkDB5tHikZYB5wcsdZC0716rAgZOCOiGk0HUDLkQsqOF4EMDn
	 iibX2F6Y5Qb7THIHQWa+O16xRnDpAqdLPKFDlJAouNtFLlQHX+SJhGMRkK6GDXyD28sSj
	 ekFYa6TE1S6QqnZrHCqP706BAiV21CFo/yiuDsUe43alBZTYeI/WKTFH/1FU8bOvEvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792972100;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id;
	bh=G2Tf8EF9FuFsKIqnBnCJrsbmoE9I8QynHiSaCBioZmI=;
	b=0D6oT/XELQ3SQxovfHK8p/WApepJAe9DF7D4QwZfkpZAFgZuIORq16TUcq+XlW5MiUnu
	 JWopHB4bD+W2UjSzPhEkOfcHryrjePrOxNnOgmPXP/UIoGjbFyi024MDuwFAcLPPy/IpA
	 fUkLTrbPfd5IIxS2ZGm5E8CykBWBxkhzpxQwDp9G5XyUao3aDACBQzet4wPhroAl6uRUO
	 Gsn6Bg/nsQLjxTNYzdwUvwI1VnXaTbsdQB0lGBdSwI7ozTFuiWSMr6mGSYZ+6x5r5l4Mo
	 Tlw2aByJFiH3WqgTRNdrbpTFx702fc2q6PKYWaMhEYWc5fvMb+QQVZL0X2J4ZH4mC4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=gYxM97xl;
	arc=none smtp.remote-ip=195.10.208.40
Received: from mout-b-210.mailbox.org (mout-b-210.mailbox.org [195.10.208.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B561B606A31E;
	Sun, 25 Oct 2026 23:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B561B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=gYxM97xl
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-210.mailbox.org (Postfix) with ESMTPS id 4jCYNV1DtxzFpb2;
	Mon, 26 Oct 2026 00:48:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1792972090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2Tf8EF9FuFsKIqnBnCJrsbmoE9I8QynHiSaCBioZmI=;
	b=gYxM97xl7qAfG16B6esV+dqcAc+2nVXfMIQBei4zSO3SMnD+Eo7g2b3kZOwcMJxQiQvlAb
	CplUG/fTwqrlhrbTCtXWAkIvz+rc+T1/GdfhU+mLe5emTp0rpKEdGcBQdf6STKWWa3n+tP
	syfYrB2NbYz1SeqEpC0POsiY2L8MNSguY0nniSELh/Uaw1S6gHHzf+cG9UhtF9VLKueJrc
	IBPqIJmB1pxUIVpWLu8vrIPMXloa83MuoKCjr8CUbHGj+IIhWEa6MUjrDF3P87SxkhtNDD
	2Eablpfo1qlieE/omWy6DufinBrts4APMeAoHd8hbkgHOtruiVqgJzsAvgjYzw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
From: Antonio Quartulli <antonio@mandelbit.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] lib/crypto: x86/chacha: Add 16-block AVX-512 (zmm) implementation
Date: Mon, 26 Oct 2026 00:47:55 +0100
Message-ID: <20261025234758.3219829-3-antonio@mandelbit.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261025234758.3219829-1-antonio@mandelbit.com>
References: <20261025234758.3219829-1-antonio@mandelbit.com>
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
X-Rspamd-Queue-Id: 4jCYNV1DtxzFpb2

Add chacha_16block_xor_avx512(), which processes sixteen ChaCha blocks
(1024 bytes) at once in 512-bit registers. It follows the structure of
the existing eight-block AVX-512VL code: the state is broadcast into
sixteen registers, the rounds use vprold, and the keystream is
transposed back with dword/qword interleaves plus a final 4x4
transpose of 128-bit lanes using vshufi32x4. Partial trailing blocks
are handled with masked loads and stores, as in the existing code.

Use it for inputs longer than eight blocks on the CPUs using the
AVX-512VL code, unless they set X86_FEATURE_PREFER_YMM because 512-bit
registers make them downclock, and keep the existing code for a
remaining tail of at most eight blocks.

Throughput of chacha_crypt() on AMD Zen 5, from benchmark_chacha in a
KVM guest, in MB/s (lengths up to 512 bytes don't use the new code):

	len	before	after
	1024	5168	10168
	1420	4856	7099
	4096	5213	10270
	16384	5227	10177

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 lib/crypto/x86/chacha-avx512vl-x86_64.S | 413 +++++++++++++++++++++++-
 lib/crypto/x86/chacha.h                 |  29 +-
 2 files changed, 440 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx512vl-x86_64.S b/lib/crypto/x86/chacha-avx512vl-x86_64.S
index 259383e1ad44..adf1759b7ae5 100644
--- a/lib/crypto/x86/chacha-avx512vl-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512vl-x86_64.S
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * ChaCha 256-bit cipher algorithm, x64 AVX-512VL functions
+ * ChaCha 256-bit cipher algorithm, x64 AVX-512VL and AVX-512F (zmm) functions
  *
  * Copyright (C) 2018 Martin Willi
  */
@@ -22,6 +22,13 @@ CTR4BL:	.octa 0x00000000000000000000000000000002
 CTR8BL:	.octa 0x00000003000000020000000100000000
 	.octa 0x00000007000000060000000500000004
 
+.section	.rodata.cst64.CTR16BL, "aM", @progbits, 64
+.align 64
+CTR16BL:.octa 0x00000003000000020000000100000000
+	.octa 0x00000007000000060000000500000004
+	.octa 0x0000000b0000000a0000000900000008
+	.octa 0x0000000f0000000e0000000d0000000c
+
 .text
 
 SYM_FUNC_START(chacha_2block_xor_avx512vl)
@@ -834,3 +841,407 @@ SYM_FUNC_START(chacha_8block_xor_avx512vl)
 	jmp		.Ldone8
 
 SYM_FUNC_END(chacha_8block_xor_avx512vl)
+
+SYM_FUNC_START(chacha_16block_xor_avx512)
+	# %rdi: Input state matrix, s
+	# %rsi: up to 16 data blocks output, o
+	# %rdx: up to 16 data blocks input, i
+	# %rcx: input/output length in bytes
+	# %r8d: nrounds
+
+	# This function encrypts sixteen consecutive ChaCha blocks by loading
+	# the state matrix in 512-bit AVX-512 registers sixteen times. It is
+	# the same algorithm as the eight block AVX-512VL variant, but using
+	# zmm registers to double the number of blocks processed in parallel.
+
+	vzeroupper
+
+	# x0..15[0-15] = s[0..15]
+	vpbroadcastd	0x00(%rdi),%zmm0
+	vpbroadcastd	0x04(%rdi),%zmm1
+	vpbroadcastd	0x08(%rdi),%zmm2
+	vpbroadcastd	0x0c(%rdi),%zmm3
+	vpbroadcastd	0x10(%rdi),%zmm4
+	vpbroadcastd	0x14(%rdi),%zmm5
+	vpbroadcastd	0x18(%rdi),%zmm6
+	vpbroadcastd	0x1c(%rdi),%zmm7
+	vpbroadcastd	0x20(%rdi),%zmm8
+	vpbroadcastd	0x24(%rdi),%zmm9
+	vpbroadcastd	0x28(%rdi),%zmm10
+	vpbroadcastd	0x2c(%rdi),%zmm11
+	vpbroadcastd	0x30(%rdi),%zmm12
+	vpbroadcastd	0x34(%rdi),%zmm13
+	vpbroadcastd	0x38(%rdi),%zmm14
+	vpbroadcastd	0x3c(%rdi),%zmm15
+
+	# x12 += counter values 0-15
+	vpaddd		CTR16BL(%rip),%zmm12,%zmm12
+
+	vmovdqa64	%zmm0,%zmm16
+	vmovdqa64	%zmm1,%zmm17
+	vmovdqa64	%zmm2,%zmm18
+	vmovdqa64	%zmm3,%zmm19
+	vmovdqa64	%zmm4,%zmm20
+	vmovdqa64	%zmm5,%zmm21
+	vmovdqa64	%zmm6,%zmm22
+	vmovdqa64	%zmm7,%zmm23
+	vmovdqa64	%zmm8,%zmm24
+	vmovdqa64	%zmm9,%zmm25
+	vmovdqa64	%zmm10,%zmm26
+	vmovdqa64	%zmm11,%zmm27
+	vmovdqa64	%zmm12,%zmm28
+	vmovdqa64	%zmm13,%zmm29
+	vmovdqa64	%zmm14,%zmm30
+	vmovdqa64	%zmm15,%zmm31
+
+.Ldoubleround16:
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
+	vpaddd		%zmm0,%zmm4,%zmm0
+	vpxord		%zmm0,%zmm12,%zmm12
+	vprold		$16,%zmm12,%zmm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 16)
+	vpaddd		%zmm1,%zmm5,%zmm1
+	vpxord		%zmm1,%zmm13,%zmm13
+	vprold		$16,%zmm13,%zmm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 16)
+	vpaddd		%zmm2,%zmm6,%zmm2
+	vpxord		%zmm2,%zmm14,%zmm14
+	vprold		$16,%zmm14,%zmm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 16)
+	vpaddd		%zmm3,%zmm7,%zmm3
+	vpxord		%zmm3,%zmm15,%zmm15
+	vprold		$16,%zmm15,%zmm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 12)
+	vpaddd		%zmm12,%zmm8,%zmm8
+	vpxord		%zmm8,%zmm4,%zmm4
+	vprold		$12,%zmm4,%zmm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 12)
+	vpaddd		%zmm13,%zmm9,%zmm9
+	vpxord		%zmm9,%zmm5,%zmm5
+	vprold		$12,%zmm5,%zmm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 12)
+	vpaddd		%zmm14,%zmm10,%zmm10
+	vpxord		%zmm10,%zmm6,%zmm6
+	vprold		$12,%zmm6,%zmm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 12)
+	vpaddd		%zmm15,%zmm11,%zmm11
+	vpxord		%zmm11,%zmm7,%zmm7
+	vprold		$12,%zmm7,%zmm7
+
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 8)
+	vpaddd		%zmm0,%zmm4,%zmm0
+	vpxord		%zmm0,%zmm12,%zmm12
+	vprold		$8,%zmm12,%zmm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 8)
+	vpaddd		%zmm1,%zmm5,%zmm1
+	vpxord		%zmm1,%zmm13,%zmm13
+	vprold		$8,%zmm13,%zmm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 8)
+	vpaddd		%zmm2,%zmm6,%zmm2
+	vpxord		%zmm2,%zmm14,%zmm14
+	vprold		$8,%zmm14,%zmm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 8)
+	vpaddd		%zmm3,%zmm7,%zmm3
+	vpxord		%zmm3,%zmm15,%zmm15
+	vprold		$8,%zmm15,%zmm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 7)
+	vpaddd		%zmm12,%zmm8,%zmm8
+	vpxord		%zmm8,%zmm4,%zmm4
+	vprold		$7,%zmm4,%zmm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 7)
+	vpaddd		%zmm13,%zmm9,%zmm9
+	vpxord		%zmm9,%zmm5,%zmm5
+	vprold		$7,%zmm5,%zmm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 7)
+	vpaddd		%zmm14,%zmm10,%zmm10
+	vpxord		%zmm10,%zmm6,%zmm6
+	vprold		$7,%zmm6,%zmm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 7)
+	vpaddd		%zmm15,%zmm11,%zmm11
+	vpxord		%zmm11,%zmm7,%zmm7
+	vprold		$7,%zmm7,%zmm7
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 16)
+	vpaddd		%zmm0,%zmm5,%zmm0
+	vpxord		%zmm0,%zmm15,%zmm15
+	vprold		$16,%zmm15,%zmm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)
+	vpaddd		%zmm1,%zmm6,%zmm1
+	vpxord		%zmm1,%zmm12,%zmm12
+	vprold		$16,%zmm12,%zmm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 16)
+	vpaddd		%zmm2,%zmm7,%zmm2
+	vpxord		%zmm2,%zmm13,%zmm13
+	vprold		$16,%zmm13,%zmm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 16)
+	vpaddd		%zmm3,%zmm4,%zmm3
+	vpxord		%zmm3,%zmm14,%zmm14
+	vprold		$16,%zmm14,%zmm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 12)
+	vpaddd		%zmm15,%zmm10,%zmm10
+	vpxord		%zmm10,%zmm5,%zmm5
+	vprold		$12,%zmm5,%zmm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 12)
+	vpaddd		%zmm12,%zmm11,%zmm11
+	vpxord		%zmm11,%zmm6,%zmm6
+	vprold		$12,%zmm6,%zmm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 12)
+	vpaddd		%zmm13,%zmm8,%zmm8
+	vpxord		%zmm8,%zmm7,%zmm7
+	vprold		$12,%zmm7,%zmm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 12)
+	vpaddd		%zmm14,%zmm9,%zmm9
+	vpxord		%zmm9,%zmm4,%zmm4
+	vprold		$12,%zmm4,%zmm4
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 8)
+	vpaddd		%zmm0,%zmm5,%zmm0
+	vpxord		%zmm0,%zmm15,%zmm15
+	vprold		$8,%zmm15,%zmm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 8)
+	vpaddd		%zmm1,%zmm6,%zmm1
+	vpxord		%zmm1,%zmm12,%zmm12
+	vprold		$8,%zmm12,%zmm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 8)
+	vpaddd		%zmm2,%zmm7,%zmm2
+	vpxord		%zmm2,%zmm13,%zmm13
+	vprold		$8,%zmm13,%zmm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 8)
+	vpaddd		%zmm3,%zmm4,%zmm3
+	vpxord		%zmm3,%zmm14,%zmm14
+	vprold		$8,%zmm14,%zmm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 7)
+	vpaddd		%zmm15,%zmm10,%zmm10
+	vpxord		%zmm10,%zmm5,%zmm5
+	vprold		$7,%zmm5,%zmm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 7)
+	vpaddd		%zmm12,%zmm11,%zmm11
+	vpxord		%zmm11,%zmm6,%zmm6
+	vprold		$7,%zmm6,%zmm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 7)
+	vpaddd		%zmm13,%zmm8,%zmm8
+	vpxord		%zmm8,%zmm7,%zmm7
+	vprold		$7,%zmm7,%zmm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 7)
+	vpaddd		%zmm14,%zmm9,%zmm9
+	vpxord		%zmm9,%zmm4,%zmm4
+	vprold		$7,%zmm4,%zmm4
+
+	sub		$2,%r8d
+	jnz		.Ldoubleround16
+
+	# x0..15[0-15] += s[0..15]
+	vpaddd		%zmm16,%zmm0,%zmm0
+	vpaddd		%zmm17,%zmm1,%zmm1
+	vpaddd		%zmm18,%zmm2,%zmm2
+	vpaddd		%zmm19,%zmm3,%zmm3
+	vpaddd		%zmm20,%zmm4,%zmm4
+	vpaddd		%zmm21,%zmm5,%zmm5
+	vpaddd		%zmm22,%zmm6,%zmm6
+	vpaddd		%zmm23,%zmm7,%zmm7
+	vpaddd		%zmm24,%zmm8,%zmm8
+	vpaddd		%zmm25,%zmm9,%zmm9
+	vpaddd		%zmm26,%zmm10,%zmm10
+	vpaddd		%zmm27,%zmm11,%zmm11
+	vpaddd		%zmm28,%zmm12,%zmm12
+	vpaddd		%zmm29,%zmm13,%zmm13
+	vpaddd		%zmm30,%zmm14,%zmm14
+	vpaddd		%zmm31,%zmm15,%zmm15
+
+	# interleave 32-bit words in state n, n+1
+	vpunpckldq	%zmm1,%zmm0,%zmm16
+	vpunpckhdq	%zmm1,%zmm0,%zmm17
+	vpunpckldq	%zmm3,%zmm2,%zmm18
+	vpunpckhdq	%zmm3,%zmm2,%zmm19
+	vpunpckldq	%zmm5,%zmm4,%zmm20
+	vpunpckhdq	%zmm5,%zmm4,%zmm21
+	vpunpckldq	%zmm7,%zmm6,%zmm22
+	vpunpckhdq	%zmm7,%zmm6,%zmm23
+	vpunpckldq	%zmm9,%zmm8,%zmm24
+	vpunpckhdq	%zmm9,%zmm8,%zmm25
+	vpunpckldq	%zmm11,%zmm10,%zmm26
+	vpunpckhdq	%zmm11,%zmm10,%zmm27
+	vpunpckldq	%zmm13,%zmm12,%zmm28
+	vpunpckhdq	%zmm13,%zmm12,%zmm29
+	vpunpckldq	%zmm15,%zmm14,%zmm30
+	vpunpckhdq	%zmm15,%zmm14,%zmm31
+
+	# interleave 64-bit words in state n, n+2; afterwards, 128-bit lane l
+	# of register 4*g+j holds words 4*g..4*g+3 of block 4*l+j
+	vpunpcklqdq	%zmm18,%zmm16,%zmm0
+	vpunpckhqdq	%zmm18,%zmm16,%zmm1
+	vpunpcklqdq	%zmm19,%zmm17,%zmm2
+	vpunpckhqdq	%zmm19,%zmm17,%zmm3
+	vpunpcklqdq	%zmm22,%zmm20,%zmm4
+	vpunpckhqdq	%zmm22,%zmm20,%zmm5
+	vpunpcklqdq	%zmm23,%zmm21,%zmm6
+	vpunpckhqdq	%zmm23,%zmm21,%zmm7
+	vpunpcklqdq	%zmm26,%zmm24,%zmm8
+	vpunpckhqdq	%zmm26,%zmm24,%zmm9
+	vpunpcklqdq	%zmm27,%zmm25,%zmm10
+	vpunpckhqdq	%zmm27,%zmm25,%zmm11
+	vpunpcklqdq	%zmm30,%zmm28,%zmm12
+	vpunpckhqdq	%zmm30,%zmm28,%zmm13
+	vpunpcklqdq	%zmm31,%zmm29,%zmm14
+	vpunpckhqdq	%zmm31,%zmm29,%zmm15
+
+	# transpose 128-bit lanes across registers j, j+4, j+8, j+12, so that
+	# register k holds the full keystream block k
+	vshufi32x4	$0x44,%zmm4,%zmm0,%zmm16
+	vshufi32x4	$0xee,%zmm4,%zmm0,%zmm17
+	vshufi32x4	$0x44,%zmm12,%zmm8,%zmm18
+	vshufi32x4	$0xee,%zmm12,%zmm8,%zmm19
+	vshufi32x4	$0x88,%zmm18,%zmm16,%zmm0
+	vshufi32x4	$0xdd,%zmm18,%zmm16,%zmm4
+	vshufi32x4	$0x88,%zmm19,%zmm17,%zmm8
+	vshufi32x4	$0xdd,%zmm19,%zmm17,%zmm12
+	vshufi32x4	$0x44,%zmm5,%zmm1,%zmm20
+	vshufi32x4	$0xee,%zmm5,%zmm1,%zmm21
+	vshufi32x4	$0x44,%zmm13,%zmm9,%zmm22
+	vshufi32x4	$0xee,%zmm13,%zmm9,%zmm23
+	vshufi32x4	$0x88,%zmm22,%zmm20,%zmm1
+	vshufi32x4	$0xdd,%zmm22,%zmm20,%zmm5
+	vshufi32x4	$0x88,%zmm23,%zmm21,%zmm9
+	vshufi32x4	$0xdd,%zmm23,%zmm21,%zmm13
+	vshufi32x4	$0x44,%zmm6,%zmm2,%zmm24
+	vshufi32x4	$0xee,%zmm6,%zmm2,%zmm25
+	vshufi32x4	$0x44,%zmm14,%zmm10,%zmm26
+	vshufi32x4	$0xee,%zmm14,%zmm10,%zmm27
+	vshufi32x4	$0x88,%zmm26,%zmm24,%zmm2
+	vshufi32x4	$0xdd,%zmm26,%zmm24,%zmm6
+	vshufi32x4	$0x88,%zmm27,%zmm25,%zmm10
+	vshufi32x4	$0xdd,%zmm27,%zmm25,%zmm14
+	vshufi32x4	$0x44,%zmm7,%zmm3,%zmm28
+	vshufi32x4	$0xee,%zmm7,%zmm3,%zmm29
+	vshufi32x4	$0x44,%zmm15,%zmm11,%zmm30
+	vshufi32x4	$0xee,%zmm15,%zmm11,%zmm31
+	vshufi32x4	$0x88,%zmm30,%zmm28,%zmm3
+	vshufi32x4	$0xdd,%zmm30,%zmm28,%zmm7
+	vshufi32x4	$0x88,%zmm31,%zmm29,%zmm11
+	vshufi32x4	$0xdd,%zmm31,%zmm29,%zmm15
+
+	# xor/write blocks, jump to partial block handling with the block in
+	# zmm0 if the length ends before the end of the block
+	cmp		$0x0040,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0000(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0000(%rsi)
+
+	vmovdqa64	%zmm1,%zmm0
+	cmp		$0x0080,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0040(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0040(%rsi)
+
+	vmovdqa64	%zmm2,%zmm0
+	cmp		$0x00c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0080(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0080(%rsi)
+
+	vmovdqa64	%zmm3,%zmm0
+	cmp		$0x0100,%rcx
+	jl		.Lxorpart16
+	vpxord		0x00c0(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x00c0(%rsi)
+
+	vmovdqa64	%zmm4,%zmm0
+	cmp		$0x0140,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0100(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0100(%rsi)
+
+	vmovdqa64	%zmm5,%zmm0
+	cmp		$0x0180,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0140(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0140(%rsi)
+
+	vmovdqa64	%zmm6,%zmm0
+	cmp		$0x01c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0180(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0180(%rsi)
+
+	vmovdqa64	%zmm7,%zmm0
+	cmp		$0x0200,%rcx
+	jl		.Lxorpart16
+	vpxord		0x01c0(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x01c0(%rsi)
+
+	vmovdqa64	%zmm8,%zmm0
+	cmp		$0x0240,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0200(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0200(%rsi)
+
+	vmovdqa64	%zmm9,%zmm0
+	cmp		$0x0280,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0240(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0240(%rsi)
+
+	vmovdqa64	%zmm10,%zmm0
+	cmp		$0x02c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0280(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0280(%rsi)
+
+	vmovdqa64	%zmm11,%zmm0
+	cmp		$0x0300,%rcx
+	jl		.Lxorpart16
+	vpxord		0x02c0(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x02c0(%rsi)
+
+	vmovdqa64	%zmm12,%zmm0
+	cmp		$0x0340,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0300(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0300(%rsi)
+
+	vmovdqa64	%zmm13,%zmm0
+	cmp		$0x0380,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0340(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0340(%rsi)
+
+	vmovdqa64	%zmm14,%zmm0
+	cmp		$0x03c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0380(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0380(%rsi)
+
+	vmovdqa64	%zmm15,%zmm0
+	cmp		$0x0400,%rcx
+	jl		.Lxorpart16
+	vpxord		0x03c0(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x03c0(%rsi)
+
+.Ldone16:
+	vzeroupper
+	RET
+
+.Lxorpart16:
+	# xor remaining bytes from partial register into output
+	mov		%rcx,%rax
+	and		$0x3f,%rcx
+	jz		.Ldone16
+	mov		%rax,%r9
+	and		$~0x3f,%r9
+
+	mov		$1,%rax
+	shld		%cl,%rax,%rax
+	sub		$1,%rax
+	kmovq		%rax,%k1
+
+	vmovdqu8	(%rdx,%r9),%zmm1{%k1}{z}
+	vpxord		%zmm0,%zmm1,%zmm1
+	vmovdqu8	%zmm1,(%rsi,%r9){%k1}
+
+	jmp		.Ldone16
+
+SYM_FUNC_END(chacha_16block_xor_avx512)
diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index b971fb0f3d47..c8a105c86db6 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -38,10 +38,14 @@ asmlinkage void chacha_4block_xor_avx512vl(const struct chacha_state *state,
 asmlinkage void chacha_8block_xor_avx512vl(const struct chacha_state *state,
 					   u8 *dst, const u8 *src, size_t len,
 					   int nrounds);
+asmlinkage void chacha_16block_xor_avx512(const struct chacha_state *state,
+					  u8 *dst, const u8 *src, size_t len,
+					  int nrounds);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_simd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512);
 
 static size_t chacha_advance(size_t len, size_t maxblocks)
 {
@@ -52,6 +56,23 @@ static size_t chacha_advance(size_t len, size_t maxblocks)
 static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			  size_t bytes, int nrounds)
 {
+	if (static_branch_likely(&chacha_use_avx512)) {
+		while (bytes >= CHACHA_BLOCK_SIZE * 16) {
+			chacha_16block_xor_avx512(state, dst, src, bytes,
+						  nrounds);
+			bytes -= CHACHA_BLOCK_SIZE * 16;
+			src += CHACHA_BLOCK_SIZE * 16;
+			dst += CHACHA_BLOCK_SIZE * 16;
+			state->x[12] += 16;
+		}
+		if (bytes > CHACHA_BLOCK_SIZE * 8) {
+			chacha_16block_xor_avx512(state, dst, src, bytes,
+						  nrounds);
+			state->x[12] += chacha_advance(bytes, 16);
+			return;
+		}
+	}
+
 	if (static_branch_likely(&chacha_use_avx512vl)) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
 			chacha_8block_xor_avx512vl(state, dst, src, bytes,
@@ -170,7 +191,13 @@ static void chacha_mod_init_arch(void)
 		static_branch_enable(&chacha_use_avx2);
 
 		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
+		    boot_cpu_has(X86_FEATURE_AVX512BW)) { /* kmovq */
 			static_branch_enable(&chacha_use_avx512vl);
+
+			/* zmm registers downclock CPUs preferring ymm ones */
+			if (!boot_cpu_has(X86_FEATURE_PREFER_YMM) &&
+			    cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL))
+				static_branch_enable(&chacha_use_avx512);
+		}
 	}
 }
-- 
2.55.0

