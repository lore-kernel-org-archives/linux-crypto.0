Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794730256;
	b=KvzhQJghPPwrOy04QIIYSUDUkSElUyagndBOrb+RpqBrLO/XtPY17N5XojZb5ERQBFYq
	 0PqFhfk8WB3fsJRfiHJBtWA17bS8oknVCo2FXQiBtLyV5+guQoXdyL/kOZ9EQIl6F3Yly
	 vv+v1ZWWG62E7ZAy9jfr90w5sAcHzQdEfccZR+MYdXl/GT9ocfKRSMMOPibH8wZwONiLH
	 o6Dwamx7Kto16B9vqCJAaI9IuizrFTHP1cCD5RmyFx4JAt2oE05D93N8aBGHkNIgq3LI6
	 EjqfLQmnbgZOV3kcWmzajxWx5qiNa5jFrwKIDrIQRrM0QZqFJhhpxQZPhyk6DqGJtog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794730256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nwscTsqgqssmIDyWAeLyUmnJvB/vNyUmHRUrvEerbUg=;
	b=yTjCf7gjGYf9PmVPx2PhGyZvZbRyy1m6dL5hGpNPaKOztMJkxB9mi/z8Va9w5e/LtdrF
	 6SM6OKhg2QIrNoRQRymaG9eIEqWIeGM84XX5rNYgRNtOg90iGIBAhErvghsAMJjFB/6kN
	 4OlPosWPkXzKaok2iaf36Y1jnmVFL/mv2QvDvvXApx0wougNTHS/QXfFtBUpXh6wYXUO5
	 ZoDwddkyh9uKf4MrBnqWsw5QBn9C3vaRaXS+dnbPv/z/X2aYSdOxTCDEFZnjx/JJM9W42
	 lR4IA5p7PB7ahX1wWH1v2VFT0hdnUOQgKz8BsZpuV3q1oB1QVKL4ag2b93BNxIUWlLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dn241xvr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D62A606A31D;
	Sun, 15 Nov 2026 08:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dn241xvr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F5F1F000C4;
	Sun, 15 Nov 2026 08:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794730256;
	bh=nwscTsqgqssmIDyWAeLyUmnJvB/vNyUmHRUrvEerbUg=;
	h=From:To:Cc:Subject:Date;
	b=dn241xvraI5GdRm9AWLAUg2XaQ+CAWku0TGeA3RUhNjwNcEFD8K8zY/7KAN8WhWMS
	 BZK8N9VL7ztDkSKiO1IQ+JxaN9Hqp9HDcUD8wckdl3a+Rn+MVQOT/Q6revkcQRi+/Y
	 nkHi+JlWCB7Hep5fifaMBhJeNPXDt0JY+nBWZ6FjGs9hIUcFPjMxCICd63ybxIw1Lx
	 dljHq5QXxHYT+tD2Pn0lqg/wxf0Y4BVlGqI82NzTzKAvBpEq9TSWt2Bc+nVeqA+G61
	 rB6kYjKwuLWY3Jf5IayiQC1TEs8xJ8c+vGPf/jUMWetqeVWHvHtQOb68KD2y94SXeW
	 /EmrajYpr8DEQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/sha2: Drop one-off implementations for Sandy/Ivy Bridge
Date: Sun, 15 Nov 2026 00:09:00 -0800
Message-ID: <20261115080900.216434-1-ebiggers@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ This is proposed to supersede my patch
  "lib/crypto: x86/sha512: Partially roll up sha512_transform_avx()"
  which was starting to clean up one of the files being dropped. ]

Currently, the kernel has SSSE3, AVX, and AVX2 implementations of each
of SHA-256 and SHA-512.

The AVX implementations of SHA-256 and SHA-512 run only on CPUs that
have AVX but do *not* have AVX2.  These are all the ones I could find:

    - Intel Sandy Bridge and Ivy Bridge
    - AMD Bulldozer, Piledriver, Steamroller, Jaguar, and Puma
    - Zhaoxin KX-5000 and KX-6000 (possibly SHA-512 only, as these CPUs
      might be able to run the PHE optimized SHA-256 code)
    - Maybe some oddly configured VMs

Oddly enough, this "AVX" code doesn't actually have much to do with AVX.
The only AVX capability it uses is support for 3-operand VEX-coded
instructions, which is unlikely to make a huge difference.

Its actual purpose is mostly unrelated to AVX: it replaces the 'ror'
instruction with 'shld'.  This is entirely to work around a quirk
specific to Sandy Bridge and Ivy Bridge where the 'ror' instruction was
very slow for microarchitectural reasons, and 'shld' worked better.

This is documented in the contemporaneous paper "Speeding up SHA-1,
SHA-256 and SHA-512 on the 2nd Generation Intel Core Processors"
(https://ieeexplore.ieee.org/document/6209073).  There, the 'shld'
workaround was claimed to speed up SHA-256 and SHA-512 by about 20% on
Sandy Bridge.

However, that was a one-off quirk.  And even the paper itself warns
about using the 'shld' approach on other microarchitectures.

On AMD CPUs, and on Intel CPUs after Sandy and Ivy Bridge, the exact
opposite applies: ror is a fast single-cycle and single µop instruction,
while shld is either a slow microcoded or multi-µop instruction.

From what I can find, this is true even on the older AMD CPUs mentioned
above that run this code.  Thus this code has likely always been harmful
on AMD.  (I don't have such a CPU available to test, but for what it's
worth, on Zen 5 the AVX SHA-512 code is 58% as fast as the SSSE3 code.
Clearly, the 'shld' hack can be quite slow on CPUs it wasn't meant for.)

We generally shouldn't be carrying asm files that are one-offs for
single microarchitectures, as it's just not worth it.  This is
especially true when the code has been mistakenly targeted to other CPUs
on which it is likely harmful, and when it has other issues that would
require maintenance, such as excessive loop unrolling and spilling the
entire 640-byte SHA-512 message schedule to the stack.  (The SSSE3 code
has the same issues, but it's easier to fix it in one place.)

Therefore, let's drop sha256-avx-asm.S and sha512-avx-asm.S.

The CPUs that could have run this code will instead run
sha256-ssse3-asm.S and sha512-ssse3-asm.S.  SHA-256 and SHA-512 may get
around 20% slower on Sandy and Ivy Bridge, but they likely get
significantly faster on AMD CPUs from around the same time (2011-2014).

Everything with AVX2 continues to run the newer code and is entirely
unaffected by this cleanup.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Makefile             |   2 -
 lib/crypto/x86/sha256-avx-asm.S | 493 --------------------------------
 lib/crypto/x86/sha256.h         |  12 +-
 lib/crypto/x86/sha512-avx-asm.S | 421 ---------------------------
 lib/crypto/x86/sha512.h         |  14 +-
 5 files changed, 6 insertions(+), 936 deletions(-)
 delete mode 100644 lib/crypto/x86/sha256-avx-asm.S
 delete mode 100644 lib/crypto/x86/sha512-avx-asm.S

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 171b926afc39..cefec4304d80 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -330,7 +330,6 @@ libsha256-$(CONFIG_PPC) += powerpc/sha256-spe-asm.o
 libsha256-$(CONFIG_RISCV) += riscv/sha256-riscv64-zvknha_or_zvknhb-zvkb.o
 libsha256-$(CONFIG_SPARC) += sparc/sha256_asm.o
 libsha256-$(CONFIG_X86) += x86/sha256-ssse3-asm.o \
-			   x86/sha256-avx-asm.o \
 			   x86/sha256-avx2-asm.o \
 			   x86/sha256-ni-asm.o
 endif # CONFIG_CRYPTO_LIB_SHA256_ARCH
@@ -358,7 +357,6 @@ endif
 libsha512-$(CONFIG_RISCV) += riscv/sha512-riscv64-zvknhb-zvkb.o
 libsha512-$(CONFIG_SPARC) += sparc/sha512_asm.o
 libsha512-$(CONFIG_X86) += x86/sha512-ssse3-asm.o \
-			   x86/sha512-avx-asm.o \
 			   x86/sha512-avx2-asm.o
 endif # CONFIG_CRYPTO_LIB_SHA512_ARCH
 
diff --git a/lib/crypto/x86/sha256-avx-asm.S b/lib/crypto/x86/sha256-avx-asm.S
deleted file mode 100644
index efb8dff5e8a9..000000000000
--- a/lib/crypto/x86/sha256-avx-asm.S
+++ /dev/null
@@ -1,493 +0,0 @@
-########################################################################
-# Implement fast SHA-256 with AVX1 instructions. (x86_64)
-#
-# Copyright (C) 2013 Intel Corporation.
-#
-# Authors:
-#     James Guilford <james.guilford@intel.com>
-#     Kirk Yap <kirk.s.yap@intel.com>
-#     Tim Chen <tim.c.chen@linux.intel.com>
-#
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
-########################################################################
-#
-# This code is described in an Intel White-Paper:
-# "Fast SHA-256 Implementations on Intel Architecture Processors"
-#
-# To find it, surf to http://www.intel.com/p/en_US/embedded
-# and search for that title.
-#
-########################################################################
-# This code schedules 1 block at a time, with 4 lanes per block
-########################################################################
-
-#include <linux/linkage.h>
-
-## assume buffers not aligned
-#define    VMOVDQ vmovdqu
-
-################################ Define Macros
-
-# addm [mem], reg
-# Add reg to mem using reg-mem add and store
-.macro addm p1 p2
-	add     \p1, \p2
-	mov     \p2, \p1
-.endm
-
-
-.macro MY_ROR p1 p2
-	shld    $(32-(\p1)), \p2, \p2
-.endm
-
-################################
-
-# COPY_XMM_AND_BSWAP xmm, [mem], byte_flip_mask
-# Load xmm with mem and byte swap each dword
-.macro COPY_XMM_AND_BSWAP p1 p2 p3
-	VMOVDQ \p2, \p1
-	vpshufb \p3, \p1, \p1
-.endm
-
-################################
-
-X0 = %xmm4
-X1 = %xmm5
-X2 = %xmm6
-X3 = %xmm7
-
-XTMP0 = %xmm0
-XTMP1 = %xmm1
-XTMP2 = %xmm2
-XTMP3 = %xmm3
-XTMP4 = %xmm8
-XFER = %xmm9
-XTMP5 = %xmm11
-
-SHUF_00BA = %xmm10      # shuffle xBxA -> 00BA
-SHUF_DC00 = %xmm12      # shuffle xDxC -> DC00
-BYTE_FLIP_MASK = %xmm13
-
-NUM_BLKS = %rdx   # 3rd arg
-INP = %rsi        # 2nd arg
-CTX = %rdi        # 1st arg
-
-SRND = %rsi       # clobbers INP
-c = %ecx
-d = %r8d
-e = %edx
-TBL = %r12
-a = %eax
-b = %ebx
-
-f = %r9d
-g = %r10d
-h = %r11d
-
-y0 = %r13d
-y1 = %r14d
-y2 = %r15d
-
-
-_INP_END_SIZE = 8
-_INP_SIZE = 8
-_XFER_SIZE = 16
-_XMM_SAVE_SIZE = 0
-
-_INP_END = 0
-_INP            = _INP_END  + _INP_END_SIZE
-_XFER           = _INP      + _INP_SIZE
-_XMM_SAVE       = _XFER     + _XFER_SIZE
-STACK_SIZE      = _XMM_SAVE + _XMM_SAVE_SIZE
-
-# rotate_Xs
-# Rotate values of symbols X0...X3
-.macro rotate_Xs
-X_ = X0
-X0 = X1
-X1 = X2
-X2 = X3
-X3 = X_
-.endm
-
-# ROTATE_ARGS
-# Rotate values of symbols a...h
-.macro ROTATE_ARGS
-TMP_ = h
-h = g
-g = f
-f = e
-e = d
-d = c
-c = b
-b = a
-a = TMP_
-.endm
-
-.macro FOUR_ROUNDS_AND_SCHED
-	## compute s0 four at a time and s1 two at a time
-	## compute W[-16] + W[-7] 4 at a time
-
-	mov     e, y0			# y0 = e
-	MY_ROR  (25-11), y0             # y0 = e >> (25-11)
-	mov     a, y1                   # y1 = a
-	vpalignr $4, X2, X3, XTMP0      # XTMP0 = W[-7]
-	MY_ROR  (22-13), y1             # y1 = a >> (22-13)
-	xor     e, y0                   # y0 = e ^ (e >> (25-11))
-	mov     f, y2                   # y2 = f
-	MY_ROR  (11-6), y0              # y0 = (e >> (11-6)) ^ (e >> (25-6))
-	xor     a, y1                   # y1 = a ^ (a >> (22-13)
-	xor     g, y2                   # y2 = f^g
-	vpaddd  X0, XTMP0, XTMP0        # XTMP0 = W[-7] + W[-16]
-	xor     e, y0                   # y0 = e ^ (e >> (11-6)) ^ (e >> (25-6))
-	and     e, y2                   # y2 = (f^g)&e
-	MY_ROR  (13-2), y1              # y1 = (a >> (13-2)) ^ (a >> (22-2))
-	## compute s0
-	vpalignr $4, X0, X1, XTMP1      # XTMP1 = W[-15]
-	xor     a, y1                   # y1 = a ^ (a >> (13-2)) ^ (a >> (22-2))
-	MY_ROR  6, y0                   # y0 = S1 = (e>>6) & (e>>11) ^ (e>>25)
-	xor     g, y2                   # y2 = CH = ((f^g)&e)^g
-	MY_ROR  2, y1                   # y1 = S0 = (a>>2) ^ (a>>13) ^ (a>>22)
-	add     y0, y2                  # y2 = S1 + CH
-	add     _XFER(%rsp), y2         # y2 = k + w + S1 + CH
-	mov     a, y0                   # y0 = a
-	add     y2, h                   # h = h + S1 + CH + k + w
-	mov     a, y2                   # y2 = a
-	vpsrld  $7, XTMP1, XTMP2
-	or      c, y0                   # y0 = a|c
-	add     h, d                    # d = d + h + S1 + CH + k + w
-	and     c, y2                   # y2 = a&c
-	vpslld  $(32-7), XTMP1, XTMP3
-	and     b, y0                   # y0 = (a|c)&b
-	add     y1, h                   # h = h + S1 + CH + k + w + S0
-	vpor    XTMP2, XTMP3, XTMP3     # XTMP1 = W[-15] MY_ROR 7
-	or      y2, y0                  # y0 = MAJ = (a|c)&b)|(a&c)
-	add     y0, h                   # h = h + S1 + CH + k + w + S0 + MAJ
-	ROTATE_ARGS
-	mov     e, y0                   # y0 = e
-	mov     a, y1                   # y1 = a
-	MY_ROR  (25-11), y0             # y0 = e >> (25-11)
-	xor     e, y0                   # y0 = e ^ (e >> (25-11))
-	mov     f, y2                   # y2 = f
-	MY_ROR  (22-13), y1             # y1 = a >> (22-13)
-	vpsrld  $18, XTMP1, XTMP2       #
-	xor     a, y1                   # y1 = a ^ (a >> (22-13)
-	MY_ROR  (11-6), y0              # y0 = (e >> (11-6)) ^ (e >> (25-6))
-	xor     g, y2                   # y2 = f^g
-	vpsrld  $3, XTMP1, XTMP4        # XTMP4 = W[-15] >> 3
-	MY_ROR  (13-2), y1              # y1 = (a >> (13-2)) ^ (a >> (22-2))
-	xor     e, y0                   # y0 = e ^ (e >> (11-6)) ^ (e >> (25-6))
-	and     e, y2                   # y2 = (f^g)&e
-	MY_ROR  6, y0                   # y0 = S1 = (e>>6) & (e>>11) ^ (e>>25)
-	vpslld  $(32-18), XTMP1, XTMP1
-	xor     a, y1                   # y1 = a ^ (a >> (13-2)) ^ (a >> (22-2))
-	xor     g, y2                   # y2 = CH = ((f^g)&e)^g
-	vpxor   XTMP1, XTMP3, XTMP3     #
-	add     y0, y2                  # y2 = S1 + CH
-	add     (1*4 + _XFER)(%rsp), y2 # y2 = k + w + S1 + CH
-	MY_ROR  2, y1                   # y1 = S0 = (a>>2) ^ (a>>13) ^ (a>>22)
-	vpxor   XTMP2, XTMP3, XTMP3     # XTMP1 = W[-15] MY_ROR 7 ^ W[-15] MY_ROR
-	mov     a, y0                   # y0 = a
-	add     y2, h                   # h = h + S1 + CH + k + w
-	mov     a, y2                   # y2 = a
-	vpxor   XTMP4, XTMP3, XTMP1     # XTMP1 = s0
-	or      c, y0                   # y0 = a|c
-	add     h, d                    # d = d + h + S1 + CH + k + w
-	and     c, y2                   # y2 = a&c
-	## compute low s1
-	vpshufd $0b11111010, X3, XTMP2  # XTMP2 = W[-2] {BBAA}
-	and     b, y0                   # y0 = (a|c)&b
-	add     y1, h                   # h = h + S1 + CH + k + w + S0
-	vpaddd  XTMP1, XTMP0, XTMP0     # XTMP0 = W[-16] + W[-7] + s0
-	or      y2, y0                  # y0 = MAJ = (a|c)&b)|(a&c)
-	add     y0, h                   # h = h + S1 + CH + k + w + S0 + MAJ
-	ROTATE_ARGS
-	mov     e, y0                   # y0 = e
-	mov     a, y1                   # y1 = a
-	MY_ROR  (25-11), y0             # y0 = e >> (25-11)
-	xor     e, y0                   # y0 = e ^ (e >> (25-11))
-	MY_ROR  (22-13), y1             # y1 = a >> (22-13)
-	mov     f, y2                   # y2 = f
-	xor     a, y1                   # y1 = a ^ (a >> (22-13)
-	MY_ROR  (11-6), y0              # y0 = (e >> (11-6)) ^ (e >> (25-6))
-	vpsrld  $10, XTMP2, XTMP4       # XTMP4 = W[-2] >> 10 {BBAA}
-	xor     g, y2                   # y2 = f^g
-	vpsrlq  $19, XTMP2, XTMP3       # XTMP3 = W[-2] MY_ROR 19 {xBxA}
-	xor     e, y0                   # y0 = e ^ (e >> (11-6)) ^ (e >> (25-6))
-	and     e, y2                   # y2 = (f^g)&e
-	vpsrlq  $17, XTMP2, XTMP2       # XTMP2 = W[-2] MY_ROR 17 {xBxA}
-	MY_ROR  (13-2), y1              # y1 = (a >> (13-2)) ^ (a >> (22-2))
-	xor     a, y1                   # y1 = a ^ (a >> (13-2)) ^ (a >> (22-2))
-	xor     g, y2                   # y2 = CH = ((f^g)&e)^g
-	MY_ROR  6, y0                   # y0 = S1 = (e>>6) & (e>>11) ^ (e>>25)
-	vpxor   XTMP3, XTMP2, XTMP2     #
-	add     y0, y2                  # y2 = S1 + CH
-	MY_ROR  2, y1                   # y1 = S0 = (a>>2) ^ (a>>13) ^ (a>>22)
-	add     (2*4 + _XFER)(%rsp), y2 # y2 = k + w + S1 + CH
-	vpxor   XTMP2, XTMP4, XTMP4     # XTMP4 = s1 {xBxA}
-	mov     a, y0                   # y0 = a
-	add     y2, h                   # h = h + S1 + CH + k + w
-	mov     a, y2                   # y2 = a
-	vpshufb SHUF_00BA, XTMP4, XTMP4 # XTMP4 = s1 {00BA}
-	or      c, y0                   # y0 = a|c
-	add     h, d                    # d = d + h + S1 + CH + k + w
-	and     c, y2                   # y2 = a&c
-	vpaddd  XTMP4, XTMP0, XTMP0     # XTMP0 = {..., ..., W[1], W[0]}
-	and     b, y0                   # y0 = (a|c)&b
-	add     y1, h                   # h = h + S1 + CH + k + w + S0
-	## compute high s1
-	vpshufd $0b01010000, XTMP0, XTMP2 # XTMP2 = W[-2] {DDCC}
-	or      y2, y0                  # y0 = MAJ = (a|c)&b)|(a&c)
-	add     y0, h                   # h = h + S1 + CH + k + w + S0 + MAJ
-	ROTATE_ARGS
-	mov     e, y0                   # y0 = e
-	MY_ROR  (25-11), y0             # y0 = e >> (25-11)
-	mov     a, y1                   # y1 = a
-	MY_ROR  (22-13), y1             # y1 = a >> (22-13)
-	xor     e, y0                   # y0 = e ^ (e >> (25-11))
-	mov     f, y2                   # y2 = f
-	MY_ROR  (11-6), y0              # y0 = (e >> (11-6)) ^ (e >> (25-6))
-	vpsrld  $10, XTMP2, XTMP5       # XTMP5 = W[-2] >> 10 {DDCC}
-	xor     a, y1                   # y1 = a ^ (a >> (22-13)
-	xor     g, y2                   # y2 = f^g
-	vpsrlq  $19, XTMP2, XTMP3       # XTMP3 = W[-2] MY_ROR 19 {xDxC}
-	xor     e, y0                   # y0 = e ^ (e >> (11-6)) ^ (e >> (25-6))
-	and     e, y2                   # y2 = (f^g)&e
-	MY_ROR  (13-2), y1              # y1 = (a >> (13-2)) ^ (a >> (22-2))
-	vpsrlq  $17, XTMP2, XTMP2       # XTMP2 = W[-2] MY_ROR 17 {xDxC}
-	xor     a, y1                   # y1 = a ^ (a >> (13-2)) ^ (a >> (22-2))
-	MY_ROR  6, y0                   # y0 = S1 = (e>>6) & (e>>11) ^ (e>>25)
-	xor     g, y2                   # y2 = CH = ((f^g)&e)^g
-	vpxor   XTMP3, XTMP2, XTMP2
-	MY_ROR  2, y1                   # y1 = S0 = (a>>2) ^ (a>>13) ^ (a>>22)
-	add     y0, y2                  # y2 = S1 + CH
-	add     (3*4 + _XFER)(%rsp), y2 # y2 = k + w + S1 + CH
-	vpxor   XTMP2, XTMP5, XTMP5     # XTMP5 = s1 {xDxC}
-	mov     a, y0                   # y0 = a
-	add     y2, h                   # h = h + S1 + CH + k + w
-	mov     a, y2                   # y2 = a
-	vpshufb SHUF_DC00, XTMP5, XTMP5 # XTMP5 = s1 {DC00}
-	or      c, y0                   # y0 = a|c
-	add     h, d                    # d = d + h + S1 + CH + k + w
-	and     c, y2                   # y2 = a&c
-	vpaddd  XTMP0, XTMP5, X0        # X0 = {W[3], W[2], W[1], W[0]}
-	and     b, y0                   # y0 = (a|c)&b
-	add     y1, h                   # h = h + S1 + CH + k + w + S0
-	or      y2, y0                  # y0 = MAJ = (a|c)&b)|(a&c)
-	add     y0, h                   # h = h + S1 + CH + k + w + S0 + MAJ
-	ROTATE_ARGS
-	rotate_Xs
-.endm
-
-## input is [rsp + _XFER + %1 * 4]
-.macro DO_ROUND round
-	mov	e, y0			# y0 = e
-        MY_ROR  (25-11), y0             # y0 = e >> (25-11)
-        mov     a, y1                   # y1 = a
-        xor     e, y0                   # y0 = e ^ (e >> (25-11))
-        MY_ROR  (22-13), y1             # y1 = a >> (22-13)
-        mov     f, y2                   # y2 = f
-        xor     a, y1                   # y1 = a ^ (a >> (22-13)
-        MY_ROR  (11-6), y0              # y0 = (e >> (11-6)) ^ (e >> (25-6))
-        xor     g, y2                   # y2 = f^g
-        xor     e, y0                   # y0 = e ^ (e >> (11-6)) ^ (e >> (25-6))
-        MY_ROR  (13-2), y1              # y1 = (a >> (13-2)) ^ (a >> (22-2))
-        and     e, y2                   # y2 = (f^g)&e
-        xor     a, y1                   # y1 = a ^ (a >> (13-2)) ^ (a >> (22-2))
-        MY_ROR  6, y0                   # y0 = S1 = (e>>6) & (e>>11) ^ (e>>25)
-        xor     g, y2                   # y2 = CH = ((f^g)&e)^g
-        add     y0, y2                  # y2 = S1 + CH
-        MY_ROR  2, y1                   # y1 = S0 = (a>>2) ^ (a>>13) ^ (a>>22)
-        offset = \round * 4 + _XFER     #
-        add     offset(%rsp), y2	# y2 = k + w + S1 + CH
-        mov     a, y0			# y0 = a
-        add     y2, h                   # h = h + S1 + CH + k + w
-        mov     a, y2                   # y2 = a
-        or      c, y0                   # y0 = a|c
-        add     h, d                    # d = d + h + S1 + CH + k + w
-        and     c, y2                   # y2 = a&c
-        and     b, y0                   # y0 = (a|c)&b
-        add     y1, h                   # h = h + S1 + CH + k + w + S0
-        or      y2, y0                  # y0 = MAJ = (a|c)&b)|(a&c)
-        add     y0, h                   # h = h + S1 + CH + k + w + S0 + MAJ
-        ROTATE_ARGS
-.endm
-
-########################################################################
-## void sha256_transform_avx(struct sha256_block_state *state,
-##			     const u8 *data, size_t nblocks);
-########################################################################
-.text
-SYM_FUNC_START(sha256_transform_avx)
-	pushq   %rbp
-	movq    %rsp, %rbp
-	pushq   %rbx
-	pushq   %r12
-	pushq   %r13
-	pushq   %r14
-	pushq   %r15
-
-	subq    $STACK_SIZE, %rsp	# allocate stack space
-	and	$~15, %rsp		# align stack pointer
-
-	shl     $6, NUM_BLKS		# convert to bytes
-	add     INP, NUM_BLKS		# pointer to end of data
-	mov     NUM_BLKS, _INP_END(%rsp)
-
-	## load initial digest
-	mov     4*0(CTX), a
-	mov     4*1(CTX), b
-	mov     4*2(CTX), c
-	mov     4*3(CTX), d
-	mov     4*4(CTX), e
-	mov     4*5(CTX), f
-	mov     4*6(CTX), g
-	mov     4*7(CTX), h
-
-	vmovdqa  PSHUFFLE_BYTE_FLIP_MASK(%rip), BYTE_FLIP_MASK
-	vmovdqa  _SHUF_00BA(%rip), SHUF_00BA
-	vmovdqa  _SHUF_DC00(%rip), SHUF_DC00
-.Lloop0:
-	lea     K256(%rip), TBL
-
-	## byte swap first 16 dwords
-	COPY_XMM_AND_BSWAP      X0, 0*16(INP), BYTE_FLIP_MASK
-	COPY_XMM_AND_BSWAP      X1, 1*16(INP), BYTE_FLIP_MASK
-	COPY_XMM_AND_BSWAP      X2, 2*16(INP), BYTE_FLIP_MASK
-	COPY_XMM_AND_BSWAP      X3, 3*16(INP), BYTE_FLIP_MASK
-
-	mov     INP, _INP(%rsp)
-
-	## schedule 48 input dwords, by doing 3 rounds of 16 each
-	mov     $3, SRND
-.align 16
-.Lloop1:
-	vpaddd  (TBL), X0, XFER
-	vmovdqa XFER, _XFER(%rsp)
-	FOUR_ROUNDS_AND_SCHED
-
-	vpaddd  1*16(TBL), X0, XFER
-	vmovdqa XFER, _XFER(%rsp)
-	FOUR_ROUNDS_AND_SCHED
-
-	vpaddd  2*16(TBL), X0, XFER
-	vmovdqa XFER, _XFER(%rsp)
-	FOUR_ROUNDS_AND_SCHED
-
-	vpaddd  3*16(TBL), X0, XFER
-	vmovdqa XFER, _XFER(%rsp)
-	add	$4*16, TBL
-	FOUR_ROUNDS_AND_SCHED
-
-	sub     $1, SRND
-	jne     .Lloop1
-
-	mov     $2, SRND
-.Lloop2:
-	vpaddd  (TBL), X0, XFER
-	vmovdqa XFER, _XFER(%rsp)
-	DO_ROUND        0
-	DO_ROUND        1
-	DO_ROUND        2
-	DO_ROUND        3
-
-	vpaddd  1*16(TBL), X1, XFER
-	vmovdqa XFER, _XFER(%rsp)
-	add     $2*16, TBL
-	DO_ROUND        0
-	DO_ROUND        1
-	DO_ROUND        2
-	DO_ROUND        3
-
-	vmovdqa X2, X0
-	vmovdqa X3, X1
-
-	sub     $1, SRND
-	jne     .Lloop2
-
-	addm    (4*0)(CTX),a
-	addm    (4*1)(CTX),b
-	addm    (4*2)(CTX),c
-	addm    (4*3)(CTX),d
-	addm    (4*4)(CTX),e
-	addm    (4*5)(CTX),f
-	addm    (4*6)(CTX),g
-	addm    (4*7)(CTX),h
-
-	mov     _INP(%rsp), INP
-	add     $64, INP
-	cmp     _INP_END(%rsp), INP
-	jne     .Lloop0
-
-	lea     -40(%rbp), %rsp
-	popq    %r15
-	popq    %r14
-	popq    %r13
-	popq    %r12
-	popq    %rbx
-	popq    %rbp
-	RET
-SYM_FUNC_END(sha256_transform_avx)
-
-.section	.rodata.cst256.K256, "aM", @progbits, 256
-.align 64
-K256:
-	.long 0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
-	.long 0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
-	.long 0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
-	.long 0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
-	.long 0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
-	.long 0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
-	.long 0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
-	.long 0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
-	.long 0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
-	.long 0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
-	.long 0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
-	.long 0xd192e819,0xd6990624,0xf40e3585,0x106aa070
-	.long 0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
-	.long 0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
-	.long 0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
-	.long 0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
-
-.section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
-.align 16
-PSHUFFLE_BYTE_FLIP_MASK:
-	.octa 0x0c0d0e0f08090a0b0405060700010203
-
-.section	.rodata.cst16._SHUF_00BA, "aM", @progbits, 16
-.align 16
-# shuffle xBxA -> 00BA
-_SHUF_00BA:
-	.octa 0xFFFFFFFFFFFFFFFF0b0a090803020100
-
-.section	.rodata.cst16._SHUF_DC00, "aM", @progbits, 16
-.align 16
-# shuffle xDxC -> DC00
-_SHUF_DC00:
-	.octa 0x0b0a090803020100FFFFFFFFFFFFFFFF
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 72bce769aa92..6bcc4b46d59f 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -27,7 +27,6 @@ DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_blocks_generic);
 	}
 
 DEFINE_X86_SHA256_FN(sha256_blocks_ssse3, sha256_transform_ssse3);
-DEFINE_X86_SHA256_FN(sha256_blocks_avx, sha256_transform_avx);
 DEFINE_X86_SHA256_FN(sha256_blocks_avx2, sha256_transform_rorx);
 DEFINE_X86_SHA256_FN(sha256_blocks_ni, sha256_ni_transform);
 
@@ -104,14 +103,9 @@ static void sha256_mod_init_arch(void)
 		   boot_cpu_has(X86_FEATURE_PHE_EN) &&
 		   boot_cpu_data.x86 >= 0x07) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_phe);
-	} else if (boot_cpu_has(X86_FEATURE_AVX)) {
-		if (boot_cpu_has(X86_FEATURE_AVX2) &&
-		    boot_cpu_has(X86_FEATURE_BMI2))
-			static_call_update(sha256_blocks_x86,
-					   sha256_blocks_avx2);
-		else
-			static_call_update(sha256_blocks_x86,
-					   sha256_blocks_avx);
+	} else if (boot_cpu_has(X86_FEATURE_AVX2) &&
+		   boot_cpu_has(X86_FEATURE_BMI2)) {
+		static_call_update(sha256_blocks_x86, sha256_blocks_avx2);
 	} else if (boot_cpu_has(X86_FEATURE_SSSE3)) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_ssse3);
 	}
diff --git a/lib/crypto/x86/sha512-avx-asm.S b/lib/crypto/x86/sha512-avx-asm.S
deleted file mode 100644
index a17dfedc1c51..000000000000
--- a/lib/crypto/x86/sha512-avx-asm.S
+++ /dev/null
@@ -1,421 +0,0 @@
-########################################################################
-# Implement fast SHA-512 with AVX instructions. (x86_64)
-#
-# Copyright (C) 2013 Intel Corporation.
-#
-# Authors:
-#     James Guilford <james.guilford@intel.com>
-#     Kirk Yap <kirk.s.yap@intel.com>
-#     David Cote <david.m.cote@intel.com>
-#     Tim Chen <tim.c.chen@linux.intel.com>
-#
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
-#
-########################################################################
-#
-# This code is described in an Intel White-Paper:
-# "Fast SHA-512 Implementations on Intel Architecture Processors"
-#
-# To find it, surf to http://www.intel.com/p/en_US/embedded
-# and search for that title.
-#
-########################################################################
-
-#include <linux/linkage.h>
-
-.text
-
-# Virtual Registers
-# ARG1
-digest	= %rdi
-# ARG2
-msg	= %rsi
-# ARG3
-msglen	= %rdx
-T1	= %rcx
-T2	= %r8
-a_64	= %r9
-b_64	= %r10
-c_64	= %r11
-d_64	= %r12
-e_64	= %r13
-f_64	= %r14
-g_64	= %r15
-h_64	= %rbx
-tmp0	= %rax
-
-# Local variables (stack frame)
-
-# Message Schedule
-W_SIZE = 80*8
-# W[t] + K[t] | W[t+1] + K[t+1]
-WK_SIZE = 2*8
-
-frame_W = 0
-frame_WK = frame_W + W_SIZE
-frame_size = frame_WK + WK_SIZE
-
-# Useful QWORD "arrays" for simpler memory references
-# MSG, DIGEST, K_t, W_t are arrays
-# WK_2(t) points to 1 of 2 qwords at frame.WK depending on t being odd/even
-
-# Input message (arg1)
-#define MSG(i)    8*i(msg)
-
-# Output Digest (arg2)
-#define DIGEST(i) 8*i(digest)
-
-# SHA Constants (static mem)
-#define K_t(i)    8*i+K512(%rip)
-
-# Message Schedule (stack frame)
-#define W_t(i)    8*i+frame_W(%rsp)
-
-# W[t]+K[t] (stack frame)
-#define WK_2(i)   8*((i%2))+frame_WK(%rsp)
-
-.macro RotateState
-	# Rotate symbols a..h right
-	TMP   = h_64
-	h_64  = g_64
-	g_64  = f_64
-	f_64  = e_64
-	e_64  = d_64
-	d_64  = c_64
-	c_64  = b_64
-	b_64  = a_64
-	a_64  = TMP
-.endm
-
-.macro RORQ p1 p2
-	# shld is faster than ror on Sandybridge
-	shld	$(64-\p2), \p1, \p1
-.endm
-
-.macro SHA512_Round rnd
-	# Compute Round %%t
-	mov     f_64, T1          # T1 = f
-	mov     e_64, tmp0        # tmp = e
-	xor     g_64, T1          # T1 = f ^ g
-	RORQ    tmp0, 23   # 41    # tmp = e ror 23
-	and     e_64, T1          # T1 = (f ^ g) & e
-	xor     e_64, tmp0        # tmp = (e ror 23) ^ e
-	xor     g_64, T1          # T1 = ((f ^ g) & e) ^ g = CH(e,f,g)
-	idx = \rnd
-	add     WK_2(idx), T1     # W[t] + K[t] from message scheduler
-	RORQ    tmp0, 4   # 18    # tmp = ((e ror 23) ^ e) ror 4
-	xor     e_64, tmp0        # tmp = (((e ror 23) ^ e) ror 4) ^ e
-	mov     a_64, T2          # T2 = a
-	add     h_64, T1          # T1 = CH(e,f,g) + W[t] + K[t] + h
-	RORQ    tmp0, 14  # 14    # tmp = ((((e ror23)^e)ror4)^e)ror14 = S1(e)
-	add     tmp0, T1          # T1 = CH(e,f,g) + W[t] + K[t] + S1(e)
-	mov     a_64, tmp0        # tmp = a
-	xor     c_64, T2          # T2 = a ^ c
-	and     c_64, tmp0        # tmp = a & c
-	and     b_64, T2          # T2 = (a ^ c) & b
-	xor     tmp0, T2          # T2 = ((a ^ c) & b) ^ (a & c) = Maj(a,b,c)
-	mov     a_64, tmp0        # tmp = a
-	RORQ    tmp0, 5  # 39     # tmp = a ror 5
-	xor     a_64, tmp0        # tmp = (a ror 5) ^ a
-	add     T1, d_64          # e(next_state) = d + T1
-	RORQ    tmp0, 6  # 34     # tmp = ((a ror 5) ^ a) ror 6
-	xor     a_64, tmp0        # tmp = (((a ror 5) ^ a) ror 6) ^ a
-	lea     (T1, T2), h_64    # a(next_state) = T1 + Maj(a,b,c)
-	RORQ    tmp0, 28  # 28    # tmp = ((((a ror5)^a)ror6)^a)ror28 = S0(a)
-	add     tmp0, h_64        # a(next_state) = T1 + Maj(a,b,c) S0(a)
-	RotateState
-.endm
-
-.macro SHA512_2Sched_2Round_avx rnd
-	# Compute rounds t-2 and t-1
-	# Compute message schedule QWORDS t and t+1
-
-	#   Two rounds are computed based on the values for K[t-2]+W[t-2] and
-	# K[t-1]+W[t-1] which were previously stored at WK_2 by the message
-	# scheduler.
-	#   The two new schedule QWORDS are stored at [W_t(t)] and [W_t(t+1)].
-	# They are then added to their respective SHA512 constants at
-	# [K_t(t)] and [K_t(t+1)] and stored at dqword [WK_2(t)]
-	#   For brievity, the comments following vectored instructions only refer to
-	# the first of a pair of QWORDS.
-	# Eg. XMM4=W[t-2] really means XMM4={W[t-2]|W[t-1]}
-	#   The computation of the message schedule and the rounds are tightly
-	# stitched to take advantage of instruction-level parallelism.
-
-	idx = \rnd - 2
-	vmovdqa	W_t(idx), %xmm4		# XMM4 = W[t-2]
-	idx = \rnd - 15
-	vmovdqu	W_t(idx), %xmm5		# XMM5 = W[t-15]
-	mov	f_64, T1
-	vpsrlq	$61, %xmm4, %xmm0	# XMM0 = W[t-2]>>61
-	mov	e_64, tmp0
-	vpsrlq	$1, %xmm5, %xmm6	# XMM6 = W[t-15]>>1
-	xor	g_64, T1
-	RORQ	tmp0, 23 # 41
-	vpsrlq	$19, %xmm4, %xmm1	# XMM1 = W[t-2]>>19
-	and	e_64, T1
-	xor	e_64, tmp0
-	vpxor	%xmm1, %xmm0, %xmm0	# XMM0 = W[t-2]>>61 ^ W[t-2]>>19
-	xor	g_64, T1
-	idx = \rnd
-	add	WK_2(idx), T1#
-	vpsrlq	$8, %xmm5, %xmm7	# XMM7 = W[t-15]>>8
-	RORQ	tmp0, 4 # 18
-	vpsrlq	$6, %xmm4, %xmm2	# XMM2 = W[t-2]>>6
-	xor	e_64, tmp0
-	mov	a_64, T2
-	add	h_64, T1
-	vpxor	%xmm7, %xmm6, %xmm6	# XMM6 = W[t-15]>>1 ^ W[t-15]>>8
-	RORQ	tmp0, 14 # 14
-	add	tmp0, T1
-	vpsrlq	$7, %xmm5, %xmm8	# XMM8 = W[t-15]>>7
-	mov	a_64, tmp0
-	xor	c_64, T2
-	vpsllq	$(64-61), %xmm4, %xmm3  # XMM3 = W[t-2]<<3
-	and	c_64, tmp0
-	and	b_64, T2
-	vpxor	%xmm3, %xmm2, %xmm2	# XMM2 = W[t-2]>>6 ^ W[t-2]<<3
-	xor	tmp0, T2
-	mov	a_64, tmp0
-	vpsllq	$(64-1), %xmm5, %xmm9	# XMM9 = W[t-15]<<63
-	RORQ	tmp0, 5 # 39
-	vpxor	%xmm9, %xmm8, %xmm8	# XMM8 = W[t-15]>>7 ^ W[t-15]<<63
-	xor	a_64, tmp0
-	add	T1, d_64
-	RORQ	tmp0, 6 # 34
-	xor	a_64, tmp0
-	vpxor	%xmm8, %xmm6, %xmm6	# XMM6 = W[t-15]>>1 ^ W[t-15]>>8 ^
-					#  W[t-15]>>7 ^ W[t-15]<<63
-	lea	(T1, T2), h_64
-	RORQ	tmp0, 28 # 28
-	vpsllq	$(64-19), %xmm4, %xmm4  # XMM4 = W[t-2]<<25
-	add	tmp0, h_64
-	RotateState
-	vpxor	%xmm4, %xmm0, %xmm0     # XMM0 = W[t-2]>>61 ^ W[t-2]>>19 ^
-					#        W[t-2]<<25
-	mov	f_64, T1
-	vpxor	%xmm2, %xmm0, %xmm0     # XMM0 = s1(W[t-2])
-	mov	e_64, tmp0
-	xor	g_64, T1
-	idx = \rnd - 16
-	vpaddq	W_t(idx), %xmm0, %xmm0  # XMM0 = s1(W[t-2]) + W[t-16]
-	idx = \rnd - 7
-	vmovdqu	W_t(idx), %xmm1		# XMM1 = W[t-7]
-	RORQ	tmp0, 23 # 41
-	and	e_64, T1
-	xor	e_64, tmp0
-	xor	g_64, T1
-	vpsllq	$(64-8), %xmm5, %xmm5   # XMM5 = W[t-15]<<56
-	idx = \rnd + 1
-	add	WK_2(idx), T1
-	vpxor	%xmm5, %xmm6, %xmm6     # XMM6 = s0(W[t-15])
-	RORQ	tmp0, 4 # 18
-	vpaddq	%xmm6, %xmm0, %xmm0     # XMM0 = s1(W[t-2]) + W[t-16] + s0(W[t-15])
-	xor	e_64, tmp0
-	vpaddq	%xmm1, %xmm0, %xmm0     # XMM0 = W[t] = s1(W[t-2]) + W[t-7] +
-					#               s0(W[t-15]) + W[t-16]
-	mov	a_64, T2
-	add	h_64, T1
-	RORQ	tmp0, 14 # 14
-	add	tmp0, T1
-	idx = \rnd
-	vmovdqa	%xmm0, W_t(idx)		# Store W[t]
-	vpaddq	K_t(idx), %xmm0, %xmm0  # Compute W[t]+K[t]
-	vmovdqa	%xmm0, WK_2(idx)	# Store W[t]+K[t] for next rounds
-	mov	a_64, tmp0
-	xor	c_64, T2
-	and	c_64, tmp0
-	and	b_64, T2
-	xor	tmp0, T2
-	mov	a_64, tmp0
-	RORQ	tmp0, 5 # 39
-	xor	a_64, tmp0
-	add	T1, d_64
-	RORQ	tmp0, 6 # 34
-	xor	a_64, tmp0
-	lea	(T1, T2), h_64
-	RORQ	tmp0, 28 # 28
-	add	tmp0, h_64
-	RotateState
-.endm
-
-########################################################################
-# void sha512_transform_avx(struct sha512_block_state *state,
-#			    const u8 *data, size_t nblocks);
-# Purpose: Updates the SHA512 digest stored at "state" with the message
-# stored in "data".
-# The size of the message pointed to by "data" must be an integer multiple
-# of SHA512 message blocks.
-# "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
-########################################################################
-SYM_FUNC_START(sha512_transform_avx)
-
-	push	%rbp
-	mov	%rsp, %rbp
-
-	# Save GPRs
-	push	%rbx
-	push	%r12
-	push	%r13
-	push	%r14
-	push	%r15
-
-	# Allocate Stack Space
-	sub     $frame_size, %rsp
-	and	$~(0x20 - 1), %rsp
-
-.Lupdateblock:
-
-	# Load state variables
-	mov     DIGEST(0), a_64
-	mov     DIGEST(1), b_64
-	mov     DIGEST(2), c_64
-	mov     DIGEST(3), d_64
-	mov     DIGEST(4), e_64
-	mov     DIGEST(5), f_64
-	mov     DIGEST(6), g_64
-	mov     DIGEST(7), h_64
-
-	t = 0
-	.rept 80/2 + 1
-	# (80 rounds) / (2 rounds/iteration) + (1 iteration)
-	# +1 iteration because the scheduler leads hashing by 1 iteration
-		.if t < 2
-			# BSWAP 2 QWORDS
-			vmovdqa  XMM_QWORD_BSWAP(%rip), %xmm1
-			vmovdqu  MSG(t), %xmm0
-			vpshufb  %xmm1, %xmm0, %xmm0    # BSWAP
-			vmovdqa  %xmm0, W_t(t) # Store Scheduled Pair
-			vpaddq   K_t(t), %xmm0, %xmm0 # Compute W[t]+K[t]
-			vmovdqa  %xmm0, WK_2(t) # Store into WK for rounds
-		.elseif t < 16
-			# BSWAP 2 QWORDS# Compute 2 Rounds
-			vmovdqu  MSG(t), %xmm0
-			vpshufb  %xmm1, %xmm0, %xmm0    # BSWAP
-			SHA512_Round t-2    # Round t-2
-			vmovdqa  %xmm0, W_t(t) # Store Scheduled Pair
-			vpaddq   K_t(t), %xmm0, %xmm0 # Compute W[t]+K[t]
-			SHA512_Round t-1    # Round t-1
-			vmovdqa  %xmm0, WK_2(t)# Store W[t]+K[t] into WK
-		.elseif t < 79
-			# Schedule 2 QWORDS# Compute 2 Rounds
-			SHA512_2Sched_2Round_avx t
-		.else
-			# Compute 2 Rounds
-			SHA512_Round t-2
-			SHA512_Round t-1
-		.endif
-		t = t+2
-	.endr
-
-	# Update digest
-	add     a_64, DIGEST(0)
-	add     b_64, DIGEST(1)
-	add     c_64, DIGEST(2)
-	add     d_64, DIGEST(3)
-	add     e_64, DIGEST(4)
-	add     f_64, DIGEST(5)
-	add     g_64, DIGEST(6)
-	add     h_64, DIGEST(7)
-
-	# Advance to next message block
-	add     $16*8, msg
-	dec     msglen
-	jnz     .Lupdateblock
-
-	# Deallocate Stack Space
-	lea	-40(%rbp), %rsp
-
-	# Restore GPRs
-	pop	%r15
-	pop	%r14
-	pop	%r13
-	pop	%r12
-	pop	%rbx
-	pop	%rbp
-
-	RET
-SYM_FUNC_END(sha512_transform_avx)
-
-########################################################################
-### Binary Data
-
-.section	.rodata.cst16.XMM_QWORD_BSWAP, "aM", @progbits, 16
-.align 16
-# Mask for byte-swapping a couple of qwords in an XMM register using (v)pshufb.
-XMM_QWORD_BSWAP:
-	.octa 0x08090a0b0c0d0e0f0001020304050607
-
-# Mergeable 640-byte rodata section. This allows linker to merge the table
-# with other, exactly the same 640-byte fragment of another rodata section
-# (if such section exists).
-.section	.rodata.cst640.K512, "aM", @progbits, 640
-.align 64
-# K[t] used in SHA512 hashing
-K512:
-	.quad 0x428a2f98d728ae22,0x7137449123ef65cd
-	.quad 0xb5c0fbcfec4d3b2f,0xe9b5dba58189dbbc
-	.quad 0x3956c25bf348b538,0x59f111f1b605d019
-	.quad 0x923f82a4af194f9b,0xab1c5ed5da6d8118
-	.quad 0xd807aa98a3030242,0x12835b0145706fbe
-	.quad 0x243185be4ee4b28c,0x550c7dc3d5ffb4e2
-	.quad 0x72be5d74f27b896f,0x80deb1fe3b1696b1
-	.quad 0x9bdc06a725c71235,0xc19bf174cf692694
-	.quad 0xe49b69c19ef14ad2,0xefbe4786384f25e3
-	.quad 0x0fc19dc68b8cd5b5,0x240ca1cc77ac9c65
-	.quad 0x2de92c6f592b0275,0x4a7484aa6ea6e483
-	.quad 0x5cb0a9dcbd41fbd4,0x76f988da831153b5
-	.quad 0x983e5152ee66dfab,0xa831c66d2db43210
-	.quad 0xb00327c898fb213f,0xbf597fc7beef0ee4
-	.quad 0xc6e00bf33da88fc2,0xd5a79147930aa725
-	.quad 0x06ca6351e003826f,0x142929670a0e6e70
-	.quad 0x27b70a8546d22ffc,0x2e1b21385c26c926
-	.quad 0x4d2c6dfc5ac42aed,0x53380d139d95b3df
-	.quad 0x650a73548baf63de,0x766a0abb3c77b2a8
-	.quad 0x81c2c92e47edaee6,0x92722c851482353b
-	.quad 0xa2bfe8a14cf10364,0xa81a664bbc423001
-	.quad 0xc24b8b70d0f89791,0xc76c51a30654be30
-	.quad 0xd192e819d6ef5218,0xd69906245565a910
-	.quad 0xf40e35855771202a,0x106aa07032bbd1b8
-	.quad 0x19a4c116b8d2d0c8,0x1e376c085141ab53
-	.quad 0x2748774cdf8eeb99,0x34b0bcb5e19b48a8
-	.quad 0x391c0cb3c5c95a63,0x4ed8aa4ae3418acb
-	.quad 0x5b9cca4f7763e373,0x682e6ff3d6b2b8a3
-	.quad 0x748f82ee5defb2fc,0x78a5636f43172f60
-	.quad 0x84c87814a1f0ab72,0x8cc702081a6439ec
-	.quad 0x90befffa23631e28,0xa4506cebde82bde9
-	.quad 0xbef9a3f7b2c67915,0xc67178f2e372532b
-	.quad 0xca273eceea26619c,0xd186b8c721c0c207
-	.quad 0xeada7dd6cde0eb1e,0xf57d4f7fee6ed178
-	.quad 0x06f067aa72176fba,0x0a637dc5a2c898a6
-	.quad 0x113f9804bef90dae,0x1b710b35131c471b
-	.quad 0x28db77f523047d84,0x32caab7b40c72493
-	.quad 0x3c9ebe0a15c9bebc,0x431d67c49c100d4c
-	.quad 0x4cc5d4becb3e42b6,0x597f299cfc657e2a
-	.quad 0x5fcb6fab3ad6faec,0x6c44198c4a475817
diff --git a/lib/crypto/x86/sha512.h b/lib/crypto/x86/sha512.h
index d16be7c03a41..d4d15ac0ee7c 100644
--- a/lib/crypto/x86/sha512.h
+++ b/lib/crypto/x86/sha512.h
@@ -25,7 +25,6 @@ DEFINE_STATIC_CALL(sha512_blocks_x86, sha512_blocks_generic);
 	}
 
 DEFINE_X86_SHA512_FN(sha512_blocks_ssse3, sha512_transform_ssse3);
-DEFINE_X86_SHA512_FN(sha512_blocks_avx, sha512_transform_avx);
 DEFINE_X86_SHA512_FN(sha512_blocks_avx2, sha512_transform_rorx);
 
 static void sha512_blocks(struct sha512_block_state *state,
@@ -37,15 +36,8 @@ static void sha512_blocks(struct sha512_block_state *state,
 #define sha512_mod_init_arch sha512_mod_init_arch
 static void sha512_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX)) {
-		if (boot_cpu_has(X86_FEATURE_AVX2) &&
-		    boot_cpu_has(X86_FEATURE_BMI2))
-			static_call_update(sha512_blocks_x86,
-					   sha512_blocks_avx2);
-		else
-			static_call_update(sha512_blocks_x86,
-					   sha512_blocks_avx);
-	} else if (boot_cpu_has(X86_FEATURE_SSSE3)) {
+	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_BMI2))
+		static_call_update(sha512_blocks_x86, sha512_blocks_avx2);
+	else if (boot_cpu_has(X86_FEATURE_SSSE3))
 		static_call_update(sha512_blocks_x86, sha512_blocks_ssse3);
-	}
 }

base-commit: 37b86799c8fd38b2d640d4cac900a2c9de94271a
-- 
2.56.1

