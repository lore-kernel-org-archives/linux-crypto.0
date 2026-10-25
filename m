Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792955551;
	b=QuwQnqK2gIzQKUy1IY3w1aY2foS/CDI7dYBM8X4tOB1ZMVwhueTKzeqc4W3MRcUKrHMg
	 DQ0gszDAMT33IVkTwGGyRh4xlYIl2D4NaZzefrGVDkmscdcg0NXZk7pG19RKvaff+ao8s
	 FZOQ62DaCHr1zI6k2kc9rHSV8A21/vQ0xqo4fXLwDiObiF1xjLE6xPSpax4hvfZQWYCLT
	 VZQq4vcesq5NqJET7eQgZT608MOcxwRSwW7aJLeHTZ29NpJbr04V5QTL5OaGkiATuTS5m
	 urtOdZxg+kNGGtKWqN0tsALpwzB1AsUjp5HHGfP9Lukz2POKe501ATc1M7ilAP9E4ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792955551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0L5P6EOY7VFdulE3YIvIBktl1Bbt2LFtSd5kxoViI9M=;
	b=LXeF9DMxf0KWFufZHddI6q1PFY+XOkeVrVgAgRGztZPQ4r8Ft5vsxAKs1JVbPm/pPOdn
	 YjmmX4fl4R+QGWxQUx+J5/ieYg6MgrY878CpJ5E8oS3TL4uzDKIXBZKcvATvGzHngBBAr
	 /eCC/mX9i81jzYm1hf59gHx6jBGfxq2vWz5wyvHSy+CmFUrKTcUBzpzDxot32XwBRmRS+
	 5VzT8UJUXM26HhoyO9NhmaKEdfVjYRX0QNdiF0xH826t+5367rECqKZa4uclIRwhk6tCi
	 sfzLzupQvAHqvkzQMLpPUbVtmhUYdwjUqu4cHUtpbA/8K/MvJf3Yr3Ftp6viB3RUGKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opjSucSx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF155606A31B;
	Sun, 25 Oct 2026 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opjSucSx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F6E1F031E0;
	Sun, 25 Oct 2026 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792955550;
	bh=0L5P6EOY7VFdulE3YIvIBktl1Bbt2LFtSd5kxoViI9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opjSucSx8rEryJRde8dDI53d2WdktAn3ij4my1/s7p5p/riCUMU5DL97dkznk/qOG
	 BS8CDfcJiRzUHTPfa4LXHYmwlU0cYe7Q6zD0i+AhinkGziZjs3ZmwOj22JZJI3OgIg
	 Q3Z1OHp8EWcTVJliFErUw4rcCi8V125+r1BSuV/Sx4RBrJRq3eA2tBqcwmT66MiLVR
	 XFB5AFnie/P6Dxdl6Y9g6IKtf8d+vXk347tczI2yRQmRt/UiBq4SPf3wxr+cFYEkQZ
	 8c9M8uuohNGN5ii1sgaFZwx6HDp5o9gt+fAgmSzxR4dAkMLxyFZb9IG7VbPeqIkziE
	 HPa4qXjJ9oueg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-raid@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] xor: remove obsolete MMX optimized code
Date: Sun, 25 Oct 2026 12:12:05 -0700
Message-ID: <20261025191207.86590-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261025191207.86590-1-ebiggers@kernel.org>
References: <20261025191207.86590-1-ebiggers@kernel.org>
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

The MMX optimized XOR code is used only on 25-year old 32-bit CPUs that
lack SSE support -- and only on systems that actually have a RAID array.
Those CPUs already have well-tested scalar C fallbacks.

Together with the RAID6 code, it's also the only remaining MMX optimized
code in the kernel.  MMX optimizations for the much more commonly called
functions memcpy(), copy_page(), and clear_page() were already removed
years ago by commit c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").

Remove the MMX optimized XOR code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/Makefile       |   2 +-
 lib/raid/xor/x86/xor-mmx.c  | 515 ------------------------------------
 lib/raid/xor/x86/xor_arch.h |   5 -
 3 files changed, 1 insertion(+), 521 deletions(-)
 delete mode 100644 lib/raid/xor/x86/xor-mmx.c

diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index e1e3455c219de..0b6ddacf442c3 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -30,7 +30,7 @@ xor-$(CONFIG_RISCV_ISA_V)	+= riscv/xor.o riscv/xor-glue.o
 xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
 xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
 xor-$(CONFIG_S390)		+= s390/xor.o
-xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
+xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o
 xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-avx512.o
 obj-y				+= tests/
 
diff --git a/lib/raid/xor/x86/xor-mmx.c b/lib/raid/xor/x86/xor-mmx.c
deleted file mode 100644
index 63a8b0444fcef..0000000000000
--- a/lib/raid/xor/x86/xor-mmx.c
+++ /dev/null
@@ -1,515 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Optimized XOR parity functions for MMX.
- *
- * Copyright (C) 1998 Ingo Molnar.
- */
-#include <asm/fpu/api.h>
-#include "xor_impl.h"
-#include "xor_arch.h"
-
-#define LD(x, y)	"       movq   8*("#x")(%1), %%mm"#y"   ;\n"
-#define ST(x, y)	"       movq %%mm"#y",   8*("#x")(%1)   ;\n"
-#define XO1(x, y)	"       pxor   8*("#x")(%2), %%mm"#y"   ;\n"
-#define XO2(x, y)	"       pxor   8*("#x")(%3), %%mm"#y"   ;\n"
-#define XO3(x, y)	"       pxor   8*("#x")(%4), %%mm"#y"   ;\n"
-#define XO4(x, y)	"       pxor   8*("#x")(%5), %%mm"#y"   ;\n"
-
-static void
-xor_pII_mmx_2(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2)
-{
-	unsigned long lines = bytes >> 7;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-	ST(i, 0)				\
-		XO1(i+1, 1)			\
-		ST(i+1, 1)			\
-			XO1(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2)
-	:
-	: "memory");
-}
-
-static void
-xor_pII_mmx_3(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3)
-{
-	unsigned long lines = bytes >> 7;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-		XO1(i + 1, 1)			\
-			XO1(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-	XO2(i, 0)				\
-	ST(i, 0)				\
-		XO2(i + 1, 1)			\
-		ST(i + 1, 1)			\
-			XO2(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO2(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       addl $128, %3         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	:
-	: "memory");
-}
-
-static void
-xor_pII_mmx_4(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3,
-	      const unsigned long * __restrict p4)
-{
-	unsigned long lines = bytes >> 7;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-		XO1(i + 1, 1)			\
-			XO1(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-	XO2(i, 0)				\
-		XO2(i + 1, 1)			\
-			XO2(i + 2, 2)		\
-				XO2(i + 3, 3)	\
-	XO3(i, 0)				\
-	ST(i, 0)				\
-		XO3(i + 1, 1)			\
-		ST(i + 1, 1)			\
-			XO3(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO3(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       addl $128, %3         ;\n"
-	"       addl $128, %4         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
-	:
-	: "memory");
-}
-
-
-static void
-xor_pII_mmx_5(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3,
-	      const unsigned long * __restrict p4,
-	      const unsigned long * __restrict p5)
-{
-	unsigned long lines = bytes >> 7;
-
-	/* Make sure GCC forgets anything it knows about p4 or p5,
-	   such that it won't pass to the asm volatile below a
-	   register that is shared with any other variable.  That's
-	   because we modify p4 and p5 there, but we can't mark them
-	   as read/write, otherwise we'd overflow the 10-asm-operands
-	   limit of GCC < 3.1.  */
-	asm("" : "+r" (p4), "+r" (p5));
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-		XO1(i + 1, 1)			\
-			XO1(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-	XO2(i, 0)				\
-		XO2(i + 1, 1)			\
-			XO2(i + 2, 2)		\
-				XO2(i + 3, 3)	\
-	XO3(i, 0)				\
-		XO3(i + 1, 1)			\
-			XO3(i + 2, 2)		\
-				XO3(i + 3, 3)	\
-	XO4(i, 0)				\
-	ST(i, 0)				\
-		XO4(i + 1, 1)			\
-		ST(i + 1, 1)			\
-			XO4(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO4(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       addl $128, %3         ;\n"
-	"       addl $128, %4         ;\n"
-	"       addl $128, %5         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5)
-	: "memory");
-
-	/* p4 and p5 were modified, and now the variables are dead.
-	   Clobber them just to be sure nobody does something stupid
-	   like assuming they have some legal value.  */
-	asm("" : "=r" (p4), "=r" (p5));
-}
-
-#undef LD
-#undef XO1
-#undef XO2
-#undef XO3
-#undef XO4
-#undef ST
-#undef BLOCK
-
-static void
-xor_p5_mmx_2(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2)
-{
-	unsigned long lines = bytes >> 6;
-
-	asm volatile(
-	" .align 32	             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2)
-	:
-	: "memory");
-}
-
-static void
-xor_p5_mmx_3(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3)
-{
-	unsigned long lines = bytes >> 6;
-
-	asm volatile(
-	" .align 32,0x90             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       pxor   (%3), %%mm0   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       pxor  8(%3), %%mm1   ;\n"
-	"       pxor 16(%3), %%mm2   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       pxor 24(%3), %%mm3   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       pxor 32(%3), %%mm4   ;\n"
-	"       pxor 40(%3), %%mm5   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       pxor 48(%3), %%mm6   ;\n"
-	"       pxor 56(%3), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       addl $64, %3         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	:
-	: "memory" );
-}
-
-static void
-xor_p5_mmx_4(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3,
-	     const unsigned long * __restrict p4)
-{
-	unsigned long lines = bytes >> 6;
-
-	asm volatile(
-	" .align 32,0x90             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       pxor   (%3), %%mm0   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       pxor  8(%3), %%mm1   ;\n"
-	"       pxor   (%4), %%mm0   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       pxor 16(%3), %%mm2   ;\n"
-	"       pxor  8(%4), %%mm1   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       pxor 16(%4), %%mm2   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       pxor 24(%3), %%mm3   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       pxor 32(%3), %%mm4   ;\n"
-	"       pxor 24(%4), %%mm3   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       pxor 40(%3), %%mm5   ;\n"
-	"       pxor 32(%4), %%mm4   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       pxor 40(%4), %%mm5   ;\n"
-	"       pxor 48(%3), %%mm6   ;\n"
-	"       pxor 56(%3), %%mm7   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 48(%4), %%mm6   ;\n"
-	"       pxor 56(%4), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       addl $64, %3         ;\n"
-	"       addl $64, %4         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
-	:
-	: "memory");
-}
-
-static void
-xor_p5_mmx_5(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3,
-	     const unsigned long * __restrict p4,
-	     const unsigned long * __restrict p5)
-{
-	unsigned long lines = bytes >> 6;
-
-	/* Make sure GCC forgets anything it knows about p4 or p5,
-	   such that it won't pass to the asm volatile below a
-	   register that is shared with any other variable.  That's
-	   because we modify p4 and p5 there, but we can't mark them
-	   as read/write, otherwise we'd overflow the 10-asm-operands
-	   limit of GCC < 3.1.  */
-	asm("" : "+r" (p4), "+r" (p5));
-
-	asm volatile(
-	" .align 32,0x90             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       pxor   (%3), %%mm0   ;\n"
-	"       pxor  8(%3), %%mm1   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       pxor   (%4), %%mm0   ;\n"
-	"       pxor  8(%4), %%mm1   ;\n"
-	"       pxor 16(%3), %%mm2   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       pxor   (%5), %%mm0   ;\n"
-	"       pxor  8(%5), %%mm1   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       pxor 16(%4), %%mm2   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       pxor 16(%5), %%mm2   ;\n"
-	"       pxor 24(%3), %%mm3   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 24(%4), %%mm3   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       pxor 24(%5), %%mm3   ;\n"
-	"       pxor 32(%3), %%mm4   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       pxor 32(%4), %%mm4   ;\n"
-	"       pxor 40(%3), %%mm5   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       pxor 32(%5), %%mm4   ;\n"
-	"       pxor 40(%4), %%mm5   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       pxor 48(%3), %%mm6   ;\n"
-	"       pxor 56(%3), %%mm7   ;\n"
-	"       pxor 40(%5), %%mm5   ;\n"
-	"       pxor 48(%4), %%mm6   ;\n"
-	"       pxor 56(%4), %%mm7   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 48(%5), %%mm6   ;\n"
-	"       pxor 56(%5), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       addl $64, %3         ;\n"
-	"       addl $64, %4         ;\n"
-	"       addl $64, %5         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5)
-	: "memory");
-
-	/* p4 and p5 were modified, and now the variables are dead.
-	   Clobber them just to be sure nobody does something stupid
-	   like assuming they have some legal value.  */
-	asm("" : "=r" (p4), "=r" (p5));
-}
-
-DO_XOR_BLOCKS(pII_mmx_inner, xor_pII_mmx_2, xor_pII_mmx_3, xor_pII_mmx_4,
-		xor_pII_mmx_5);
-
-static void xor_gen_pII_mmx(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes)
-{
-	kernel_fpu_begin();
-	xor_gen_pII_mmx_inner(dest, srcs, src_cnt, bytes);
-	kernel_fpu_end();
-}
-
-struct xor_block_template xor_block_pII_mmx = {
-	.name		= "pII_mmx",
-	.xor_gen	= xor_gen_pII_mmx,
-};
-
-DO_XOR_BLOCKS(p5_mmx_inner, xor_p5_mmx_2, xor_p5_mmx_3, xor_p5_mmx_4,
-		xor_p5_mmx_5);
-
-static void xor_gen_p5_mmx(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes)
-{
-	kernel_fpu_begin();
-	xor_gen_p5_mmx_inner(dest, srcs, src_cnt, bytes);
-	kernel_fpu_end();
-}
-
-struct xor_block_template xor_block_p5_mmx = {
-	.name		= "p5_mmx",
-	.xor_gen	= xor_gen_p5_mmx,
-};
diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index ed5921d2e2aad..3bc0e1650b78c 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 #include <asm/cpufeature.h>
 
-extern struct xor_block_template xor_block_pII_mmx;
-extern struct xor_block_template xor_block_p5_mmx;
 extern struct xor_block_template xor_block_sse;
 extern struct xor_block_template xor_block_sse_pf64;
 extern struct xor_block_template xor_block_avx;
@@ -33,9 +31,6 @@ static __always_inline void __init arch_xor_init(void)
 		 */
 		xor_register(&xor_block_sse);
 		xor_register(&xor_block_sse_pf64);
-	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
-		xor_register(&xor_block_pII_mmx);
-		xor_register(&xor_block_p5_mmx);
 	} else {
 		xor_register(&xor_block_8regs);
 		xor_register(&xor_block_8regs_p);
-- 
2.56.0

