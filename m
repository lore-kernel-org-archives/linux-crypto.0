Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAD43D1CAA
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.202.192.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734954; cv=none; b=lfLMHQoMSyHXjGh8jj3vQrgDeFznGDQxT2sk1NyPvUBbUsTcY1R9CTCh/U78pQVgmK0PiwQcwsTov/O0vVMMFEOl6oOIgXP3T0rgN02cUrV/Zv0SDC7XwMEJk+C8Q1nuqbGaf752QTPJtC0I6QByHckZgC3byQpzdIT5fXQT09c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734954; c=relaxed/simple;
	bh=PNbeJWa//sC9MKmIEe2yX63ELnFYhs/JtHfKvihHmwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e6YB54OpxYI3hY8FsG/NuQp7IxNWqB9HmfDbPjzaFiUZOVkMxPhXSZADFAr4n3rsqD6wuojpKWYalic3ftO+P+lhjROJHvdqgiKbuMcWQfLyrOrKbjRmF4nWYVcb1OYOxKygraZ6hU/aBJ1UHxnkTw9nxZYKF1ZHHRI/vlx85uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org; spf=pass smtp.mailfrom=strongswan.org; dkim=pass (2048-bit key) header.d=strongswan.org header.i=@strongswan.org header.b=tMT/fO4W; arc=none smtp.client-ip=109.202.192.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strongswan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=strongswan.org header.i=@strongswan.org header.b="tMT/fO4W"
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 1B7585A0005;
	Wed, 22 Jul 2026 17:33:18 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id dKOXXAnqrf2f; Wed, 22 Jul 2026 17:33:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1784734396;
	bh=PNbeJWa//sC9MKmIEe2yX63ELnFYhs/JtHfKvihHmwA=;
	h=From:To:Cc:Subject:Date:From;
	b=tMT/fO4W5S9AoKo6QL3KIDRV1QMj2QFSEQhHAcXGaPy/nlHukOYSADgneBzb/M1yo
	 g2F25P9iUa3BfDkkRmxUvCV+C1g374HoYVSrR3K+x6Kcb3V+r/qa1B6KtJhBmtS7zw
	 wKUV6GYCcsaCk/kmTViTlvYjXzWrAMqHVRZlWZEvSdCOmPam7eyJabyslAp6Mn3Zz5
	 FoZd7MjU3VYsFKJjDpLAhWnbZHHVwFdJOhQBk+aAf/MDChOGvwqe7U1orpUvfsxIkh
	 ZPuM+hsLHuFyRCIBtz7xWGJWfBgqpMfjRarn6PdWoGvEMO7oX8dchaKazYnD6xw1mN
	 ZOlgoOSGcAgZw==
Received: from ee00200a.home (unknown [185.12.128.224])
	by mail.codelabs.ch (Postfix) with ESMTPSA id A60E45A0004;
	Wed, 22 Jul 2026 17:33:16 +0200 (CEST)
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
Date: Wed, 22 Jul 2026 17:32:47 +0200
Message-ID: <20260722153247.630519-1-martin@strongswan.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing AVX-512VL code processes at most eight blocks at a time
using 256-bit ymm registers. This width was chosen deliberately to
avoid the heavy core down-clocking that 512-bit zmm instructions
triggered on Skylake-X.

That penalty is gone on more recent AVX-512 microarchitectures, where
full 512-bit zmm registers can encrypt sixteen blocks per invocation
and roughly double the data-level parallelism for bulk traffic. Add
such a 16-block variant and dispatch to it for inputs larger than
eight blocks, ahead of the AVX-512VL path which still handles the
remainder.

On a Zen 5, the tcrypt speed test for chacha20 with 1024-byte blocks
reports 7.5 GB/s with the new variant versus 4.2 GB/s for the
AVX-512VL path, roughly a 1.8x improvement.

Enable it only on CPUs advertising AVX-512F with full zmm XSAVE state,
and keep it disabled when X86_FEATURE_PREFER_YMM is set so
down-clocking parts continue to use the ymm-based AVX-512VL path.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
Eric,

This will conflict with your cpu_has_xfeatures() removal [1]. Let me know
if I shall drop the cpu_has_xfeatures(XFEATURE_MASK_AVX512) line.

[1] https://lore.kernel.org/all/20260626043731.319287-5-ebiggers@kernel.org/
---
 lib/crypto/Makefile                   |   1 +
 lib/crypto/x86/chacha-avx512-x86_64.S | 403 ++++++++++++++++++++++++++
 lib/crypto/x86/chacha.h               |  30 +-
 3 files changed, 433 insertions(+), 1 deletion(-)
 create mode 100644 lib/crypto/x86/chacha-avx512-x86_64.S

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index f1e9bf89785f..6b9668d414c2 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -118,6 +118,7 @@ libchacha-$(CONFIG_RISCV) += riscv/chacha-riscv64-zvkb.o
 libchacha-$(CONFIG_S390) += s390/chacha-s390.o
 libchacha-$(CONFIG_X86) += x86/chacha-ssse3-x86_64.o \
 			   x86/chacha-avx2-x86_64.o \
+			   x86/chacha-avx512-x86_64.o \
 			   x86/chacha-avx512vl-x86_64.o
 endif # CONFIG_CRYPTO_LIB_CHACHA_ARCH
 
diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
new file mode 100644
index 000000000000..c7e35fa3a5e7
--- /dev/null
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -0,0 +1,403 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * ChaCha 256-bit cipher algorithm, x64 AVX-512 functions
+ *
+ * Copyright (C) 2026 Martin Willi
+ */
+
+#include <linux/linkage.h>
+
+.section	.rodata.cst64.CTR16BL, "aM", @progbits, 64
+.align 64
+CTR16BL:	.octa 0x00000003000000020000000100000000
+		.octa 0x00000007000000060000000500000004
+		.octa 0x0000000b0000000a0000000900000008
+		.octa 0x0000000f0000000e0000000d0000000c
+
+.text
+
+SYM_FUNC_START(chacha_16block_xor_avx512)
+	# %rdi: Input state matrix, s
+	# %rsi: up to 16 data blocks output, o
+	# %rdx: up to 16 data blocks input, i
+	# %rcx: input/output length in bytes
+	# %r8d: nrounds
+
+	# This function encrypts sixteen consecutive ChaCha blocks by loading
+	# the state matrix in 512-bit AVX-512 (zmm) registers sixteen times.
+	# Compared to AVX-512VL, this doubles the data-level parallelism using
+	# full-width zmm registers, which pays off on CPUs that do not throttle
+	# on 512-bit instructions.
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
+	# Only x12 carries a per-block value (the counter), so only it needs a
+	# saved copy for the final state add. The other fifteen words are scalar
+	# broadcasts of s[], re-added at the end via {1to16} embedded broadcast
+	# straight from the state matrix, dropping fifteen vmovdqa64 copies.
+	vmovdqa64	%zmm12,%zmm28
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
+	# x0..15[0-15] += s[0..15]; all but x12 broadcast straight from s[]
+	vpaddd		0x00(%rdi){1to16},%zmm0,%zmm0
+	vpaddd		0x04(%rdi){1to16},%zmm1,%zmm1
+	vpaddd		0x08(%rdi){1to16},%zmm2,%zmm2
+	vpaddd		0x0c(%rdi){1to16},%zmm3,%zmm3
+	vpaddd		0x10(%rdi){1to16},%zmm4,%zmm4
+	vpaddd		0x14(%rdi){1to16},%zmm5,%zmm5
+	vpaddd		0x18(%rdi){1to16},%zmm6,%zmm6
+	vpaddd		0x1c(%rdi){1to16},%zmm7,%zmm7
+	vpaddd		0x20(%rdi){1to16},%zmm8,%zmm8
+	vpaddd		0x24(%rdi){1to16},%zmm9,%zmm9
+	vpaddd		0x28(%rdi){1to16},%zmm10,%zmm10
+	vpaddd		0x2c(%rdi){1to16},%zmm11,%zmm11
+	vpaddd		%zmm28,%zmm12,%zmm12
+	vpaddd		0x34(%rdi){1to16},%zmm13,%zmm13
+	vpaddd		0x38(%rdi){1to16},%zmm14,%zmm14
+	vpaddd		0x3c(%rdi){1to16},%zmm15,%zmm15
+
+	# Transpose the 16x16 dword matrix: register n holds word n of all 16
+	# blocks, but we need register n to hold all 16 words of block n. This
+	# is the 8-block (vperm2i128) transpose extended by one level, since a
+	# zmm holds four 128-bit lanes instead of two.
+
+	# interleave 32-bit words in state n, n+1 -> zmm16..31
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
+	# interleave 64-bit words in state n, n+2 -> zmm0..15
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
+	# At this point lane L of zmm{r}, zmm{4+r}, zmm{8+r}, zmm{12+r} holds
+	# word groups 0-3, 4-7, 8-11, 12-15 of block (4*L + r). Gather the four
+	# 128-bit lanes of a block into one register with two levels of 128-bit
+	# lane shuffles.
+
+	# interleave 128-bit lanes in state n, n+4 -> zmm16..31
+	vshufi64x2	$0x88,%zmm4,%zmm0,%zmm16
+	vshufi64x2	$0x88,%zmm12,%zmm8,%zmm20
+	vshufi64x2	$0xdd,%zmm4,%zmm0,%zmm24
+	vshufi64x2	$0xdd,%zmm12,%zmm8,%zmm28
+	vshufi64x2	$0x88,%zmm5,%zmm1,%zmm17
+	vshufi64x2	$0x88,%zmm13,%zmm9,%zmm21
+	vshufi64x2	$0xdd,%zmm5,%zmm1,%zmm25
+	vshufi64x2	$0xdd,%zmm13,%zmm9,%zmm29
+	vshufi64x2	$0x88,%zmm6,%zmm2,%zmm18
+	vshufi64x2	$0x88,%zmm14,%zmm10,%zmm22
+	vshufi64x2	$0xdd,%zmm6,%zmm2,%zmm26
+	vshufi64x2	$0xdd,%zmm14,%zmm10,%zmm30
+	vshufi64x2	$0x88,%zmm7,%zmm3,%zmm19
+	vshufi64x2	$0x88,%zmm15,%zmm11,%zmm23
+	vshufi64x2	$0xdd,%zmm7,%zmm3,%zmm27
+	vshufi64x2	$0xdd,%zmm15,%zmm11,%zmm31
+
+	# Fuse the final 256-bit interleave into the xor/store ladder.
+	vshufi64x2	$0x88,%zmm20,%zmm16,%zmm0
+	cmp		$0x0040,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0000(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0000(%rsi)
+
+	vshufi64x2	$0x88,%zmm21,%zmm17,%zmm0
+	cmp		$0x0080,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0040(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0040(%rsi)
+
+	vshufi64x2	$0x88,%zmm22,%zmm18,%zmm0
+	cmp		$0x00c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0080(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0080(%rsi)
+
+	vshufi64x2	$0x88,%zmm23,%zmm19,%zmm0
+	cmp		$0x0100,%rcx
+	jl		.Lxorpart16
+	vpxord		0x00c0(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x00c0(%rsi)
+
+	vshufi64x2	$0x88,%zmm28,%zmm24,%zmm0
+	cmp		$0x0140,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0100(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0100(%rsi)
+
+	vshufi64x2	$0x88,%zmm29,%zmm25,%zmm0
+	cmp		$0x0180,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0140(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0140(%rsi)
+
+	vshufi64x2	$0x88,%zmm30,%zmm26,%zmm0
+	cmp		$0x01c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0180(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0180(%rsi)
+
+	vshufi64x2	$0x88,%zmm31,%zmm27,%zmm0
+	cmp		$0x0200,%rcx
+	jl		.Lxorpart16
+	vpxord		0x01c0(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x01c0(%rsi)
+
+	vshufi64x2	$0xdd,%zmm20,%zmm16,%zmm0
+	cmp		$0x0240,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0200(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0200(%rsi)
+
+	vshufi64x2	$0xdd,%zmm21,%zmm17,%zmm0
+	cmp		$0x0280,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0240(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0240(%rsi)
+
+	vshufi64x2	$0xdd,%zmm22,%zmm18,%zmm0
+	cmp		$0x02c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0280(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0280(%rsi)
+
+	vshufi64x2	$0xdd,%zmm23,%zmm19,%zmm0
+	cmp		$0x0300,%rcx
+	jl		.Lxorpart16
+	vpxord		0x02c0(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x02c0(%rsi)
+
+	vshufi64x2	$0xdd,%zmm28,%zmm24,%zmm0
+	cmp		$0x0340,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0300(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0300(%rsi)
+
+	vshufi64x2	$0xdd,%zmm29,%zmm25,%zmm0
+	cmp		$0x0380,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0340(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0340(%rsi)
+
+	vshufi64x2	$0xdd,%zmm30,%zmm26,%zmm0
+	cmp		$0x03c0,%rcx
+	jl		.Lxorpart16
+	vpxord		0x0380(%rdx),%zmm0,%zmm0
+	vmovdqu64	%zmm0,0x0380(%rsi)
+
+	vshufi64x2	$0xdd,%zmm31,%zmm27,%zmm0
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
index 10cf8f1c569d..a42b3f45c281 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -39,9 +39,14 @@ asmlinkage void chacha_8block_xor_avx512vl(const struct chacha_state *state,
 					   u8 *dst, const u8 *src,
 					   unsigned int len, int nrounds);
 
+asmlinkage void chacha_16block_xor_avx512(const struct chacha_state *state,
+					  u8 *dst, const u8 *src,
+					  unsigned int len, int nrounds);
+
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_simd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512);
 
 static unsigned int chacha_advance(unsigned int len, unsigned int maxblocks)
 {
@@ -52,6 +57,23 @@ static unsigned int chacha_advance(unsigned int len, unsigned int maxblocks)
 static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds)
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
@@ -170,7 +192,13 @@ static void chacha_mod_init_arch(void)
 		static_branch_enable(&chacha_use_avx2);
 
 		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
+		    boot_cpu_has(X86_FEATURE_AVX512BW)) { /* kmovq */
 			static_branch_enable(&chacha_use_avx512vl);
+
+			if (boot_cpu_has(X86_FEATURE_AVX512F) &&
+			    !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&
+			    cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL))
+				static_branch_enable(&chacha_use_avx512);
+		}
 	}
 }
-- 
2.53.0

