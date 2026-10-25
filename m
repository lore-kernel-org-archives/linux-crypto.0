Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792955551;
	b=1bI9bhPp7zcyMWIUPOqWEx/0zs71a9z6G20jU++ExIIKdIGJz4ZjrS/CxXhv654/VQnq
	 +FNpJ3GTqbsDmhe92s91hNCxiHzA6vqzjuDbZM8zviGnIwT/HugMoYxTQaIanDt2CBMYg
	 2SqXmGmQRNjPZjrBf8B7Bo53YNh0GdXqHvYdqmDc2tgkS1PKNNK4m5Nhvr2f5pp6HfPzH
	 kqdnGMKW0XesaqIwbloQ9BIfOKHlEjkljYssAemIILU1GLmKIG1xrcRSkZpG6q64g6iQa
	 e1gMY5Mbi8OppJLd5//gtKhk7W7LYIPArvlo/g0Bw2QlBmEuPmEQXWMRI00VpY1rN0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792955551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wC0I1+krNoOJrd0SMrgBAZIz3+ubw1NyoMfQtLzjC5A=;
	b=FIeQ/JSLchnaYJVNoDsQgfZRVXAJOefgEkfiRrAOl4olBNSZlXTfU+GWRRFKhca/txlA
	 264ZcI8DGDGMwz9dygqF7zU4WiB0g+CtMDR2L4HuK2J/Eg6N7hXFVt5zvTN6BKL8r9jo8
	 gu6BPqgFbnz78cDYZfme31LKsk/rLw4AvZlRyb6Ou+vzAXKc0HTX9c0Yf79Cj/weQfH2s
	 6jwPoA06NBqJdYr7xeV2Un9u3VDNmBB3WDWMrcepRujc/Y2kYot5RWkJvVpXJOg8jCbf2
	 hLcNd+TaUvdZh+Znd0cHteRleUodHXNOS28Co5JtvEkgjU5WKmxbnm8W0pIrTFH7n0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auoAI0bi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C39B606A320;
	Sun, 25 Oct 2026 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auoAI0bi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD8F1F01828;
	Sun, 25 Oct 2026 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792955551;
	bh=wC0I1+krNoOJrd0SMrgBAZIz3+ubw1NyoMfQtLzjC5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auoAI0bihOA1YUyE2UWRA9EozOXUXAl6cO3xX5j9IKD0GKr7/uPHrU0bvFYqI4bdv
	 aXuamiOD+FWo0OZ2KggKMuTzO5iv1jjm7ivqbQR00348VOYNhrpPHIXZha3H4TKrej
	 xDwtcuXJbdvokJ2rCFNcECjIlXsv6jveIUJ14MsZveDKvsmX43GhlRyyTujrNUCimI
	 4VBnFxDLPvs4kIOaljI1vmsM0qqMT9bSz5dEoHdib56KpzwwWGEjmE4cy4J2re3VK1
	 mbO6+ZVcB0njNyFFP55uN9YI5y28uLlIDRCQ8sygAqz7x3GMUpmrJZl3TBtELlMlt6
	 xs9L5N0mtrANw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-raid@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] raid6: remove obsolete MMX optimized code
Date: Sun, 25 Oct 2026 12:12:06 -0700
Message-ID: <20261025191207.86590-3-ebiggers@kernel.org>
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

The MMX optimized RAID6 code is used only on 25-year old 32-bit CPUs
that lack SSE2 support -- and only on systems that actually have a RAID
array.  Those CPUs already have well-tested scalar C fallbacks.

It's also the only remaining MMX optimized code in the kernel.  MMX
optimizations for the much more commonly called functions memcpy(),
copy_page(), and clear_page() were already removed years ago by
commit c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").

Remove the MMX optimized RAID6 code.  This includes
lib/raid/raid6/x86/sse1.c, which was really an MMX implementation with
SSE1 prefetches and non-temporal stores added on top.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/raid6/Makefile      |   4 --
 lib/raid/raid6/x86/mmx.c     | 118 ------------------------------
 lib/raid/raid6/x86/pq_arch.h |  18 -----
 lib/raid/raid6/x86/sse1.c    | 136 -----------------------------------
 4 files changed, 276 deletions(-)
 delete mode 100644 lib/raid/raid6/x86/mmx.c
 delete mode 100644 lib/raid/raid6/x86/sse1.c

diff --git a/lib/raid/raid6/Makefile b/lib/raid/raid6/Makefile
index 5cdb7223de2af..0bfc20a60ae92 100644
--- a/lib/raid/raid6/Makefile
+++ b/lib/raid/raid6/Makefile
@@ -38,10 +38,6 @@ raid6_pq-$(CONFIG_RISCV_ISA_V)	+= riscv/rvv.o \
 				   riscv/recov_rvv.o
 raid6_pq-$(CONFIG_S390)		+= s390/s390vx8.o \
 				   s390/recov_s390xc.o
-ifeq ($(CONFIG_X86),y)
-raid6_pq-$(CONFIG_X86_32)	+= x86/mmx.o \
-				   x86/sse1.o
-endif
 raid6_pq-$(CONFIG_X86)		+= x86/sse2.o \
 				   x86/avx2.o \
 				   x86/avx512.o \
diff --git a/lib/raid/raid6/x86/mmx.c b/lib/raid/raid6/x86/mmx.c
deleted file mode 100644
index afa82536142da..0000000000000
--- a/lib/raid/raid6/x86/mmx.c
+++ /dev/null
@@ -1,118 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright 2002 H. Peter Anvin - All Rights Reserved
- *
- * MMX implementation of RAID-6 syndrome functions.
- */
-
-#include <asm/cpufeature.h>
-#include <asm/fpu/api.h>
-#include "algos.h"
-
-/* Shared with raid6/sse1.c */
-const struct raid6_mmx_constants {
-	u64 x1d;
-} raid6_mmx_constants = {
-	0x1d1d1d1d1d1d1d1dULL,
-};
-
-/*
- * Plain MMX implementation
- */
-static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-
-	for ( d = 0 ; d < bytes ; d += 8 ) {
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
-			asm volatile("movq %0,%%mm6" : : "m" (dptr[z][d]));
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm6,%mm2");
-			asm volatile("pxor %mm6,%mm4");
-		}
-		asm volatile("movq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("pxor %mm2,%mm2");
-		asm volatile("movq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("pxor %mm4,%mm4");
-	}
-
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_mmxx1 = {
-	.gen_syndrome	= raid6_mmx1_gen_syndrome,
-	.name		= "mmxx1",
-};
-
-/*
- * Unrolled-by-2 MMX implementation
- */
-static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-	asm volatile("pxor %mm7,%mm7"); /* Zero temp */
-
-	for ( d = 0 ; d < bytes ; d += 16 ) {
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d+8]));
-		asm volatile("movq %mm2,%mm4"); /* Q[0] */
-		asm volatile("movq %mm3,%mm6"); /* Q[1] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("pcmpgtb %mm6,%mm7");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("paddb %mm6,%mm6");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pand %mm0,%mm7");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("movq %0,%%mm5" : : "m" (dptr[z][d]));
-			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d+8]));
-			asm volatile("pxor %mm5,%mm2");
-			asm volatile("pxor %mm7,%mm3");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm7,%mm7");
-		}
-		asm volatile("movq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movq %%mm3,%0" : "=m" (p[d+8]));
-		asm volatile("movq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("movq %%mm6,%0" : "=m" (q[d+8]));
-	}
-
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_mmxx2 = {
-	.gen_syndrome	= raid6_mmx2_gen_syndrome,
-	.name		= "mmxx2",
-};
diff --git a/lib/raid/raid6/x86/pq_arch.h b/lib/raid/raid6/x86/pq_arch.h
index 02f8843b05372..4a863b253b909 100644
--- a/lib/raid/raid6/x86/pq_arch.h
+++ b/lib/raid/raid6/x86/pq_arch.h
@@ -2,10 +2,6 @@
 
 #include <asm/cpufeature.h>
 
-extern const struct raid6_calls raid6_mmxx1;
-extern const struct raid6_calls raid6_mmxx2;
-extern const struct raid6_calls raid6_sse1x1;
-extern const struct raid6_calls raid6_sse1x2;
 extern const struct raid6_calls raid6_sse2x1;
 extern const struct raid6_calls raid6_sse2x2;
 extern const struct raid6_calls raid6_sse2x4;
@@ -50,13 +46,6 @@ static inline bool raid6_has_sse2(void)
 		    boot_cpu_has(X86_FEATURE_XMM2);
 }
 
-static inline bool raid6_has_sse1_or_mmxext(void)
-{
-	return boot_cpu_has(X86_FEATURE_MMX) &&
-		(boot_cpu_has(X86_FEATURE_XMM) ||
-		 boot_cpu_has(X86_FEATURE_MMXEXT));
-}
-
 static __always_inline void __init arch_raid6_init(void)
 {
 	if (raid6_has_avx2()) {
@@ -78,13 +67,6 @@ static __always_inline void __init arch_raid6_init(void)
 			raid6_algo_add(&raid6_sse2x4);
 	} else {
 		raid6_algo_add_default();
-		if (raid6_has_sse1_or_mmxext()) {
-			raid6_algo_add(&raid6_sse1x1);
-			raid6_algo_add(&raid6_sse1x2);
-		} else if (boot_cpu_has(X86_FEATURE_MMX)) {
-			raid6_algo_add(&raid6_mmxx1);
-			raid6_algo_add(&raid6_mmxx2);
-		}
 	}
 
 	if (raid6_has_avx512())
diff --git a/lib/raid/raid6/x86/sse1.c b/lib/raid/raid6/x86/sse1.c
deleted file mode 100644
index f4b260df522a3..0000000000000
--- a/lib/raid/raid6/x86/sse1.c
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright 2002 H. Peter Anvin - All Rights Reserved
- *
- * SSE-1/MMXEXT implementation of RAID-6 syndrome functions.
- *
- * This is really an MMX implementation, but it requires SSE-1 or AMD MMXEXT for
- * prefetch support and a few other features.  The support for nontemporal
- * memory accesses is enough to make this worthwhile as a separate
- * implementation.
- */
-
-#include <asm/cpufeature.h>
-#include <asm/fpu/api.h>
-#include "algos.h"
-
-/* Defined in raid6/mmx.c */
-extern const struct raid6_mmx_constants {
-	u64 x1d;
-} raid6_mmx_constants;
-
-/*
- * Plain SSE1 implementation
- */
-static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-
-	for ( d = 0 ; d < bytes ; d += 8 ) {
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0-1][d]));
-		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		asm volatile("movq %0,%%mm6" : : "m" (dptr[z0-1][d]));
-		for ( z = z0-2 ; z >= 0 ; z-- ) {
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm6,%mm2");
-			asm volatile("pxor %mm6,%mm4");
-			asm volatile("movq %0,%%mm6" : : "m" (dptr[z][d]));
-		}
-		asm volatile("pcmpgtb %mm4,%mm5");
-		asm volatile("paddb %mm4,%mm4");
-		asm volatile("pand %mm0,%mm5");
-		asm volatile("pxor %mm5,%mm4");
-		asm volatile("pxor %mm5,%mm5");
-		asm volatile("pxor %mm6,%mm2");
-		asm volatile("pxor %mm6,%mm4");
-
-		asm volatile("movntq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movntq %%mm4,%0" : "=m" (q[d]));
-	}
-
-	asm volatile("sfence" : : : "memory");
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_sse1x1 = {
-	.gen_syndrome	= raid6_sse11_gen_syndrome,
-	.name		= "sse1x1",
-};
-
-/*
- * Unrolled-by-2 SSE1 implementation
- */
-static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-	asm volatile("pxor %mm7,%mm7"); /* Zero temp */
-
-	/* We uniformly assume a single prefetch covers at least 16 bytes */
-	for ( d = 0 ; d < bytes ; d += 16 ) {
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d+8])); /* P[1] */
-		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		asm volatile("movq %mm3,%mm6"); /* Q[1] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("pcmpgtb %mm6,%mm7");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("paddb %mm6,%mm6");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pand %mm0,%mm7");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("movq %0,%%mm5" : : "m" (dptr[z][d]));
-			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d+8]));
-			asm volatile("pxor %mm5,%mm2");
-			asm volatile("pxor %mm7,%mm3");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm7,%mm7");
-		}
-		asm volatile("movntq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movntq %%mm3,%0" : "=m" (p[d+8]));
-		asm volatile("movntq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("movntq %%mm6,%0" : "=m" (q[d+8]));
-	}
-
-	asm volatile("sfence" : :: "memory");
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_sse1x2 = {
-	.gen_syndrome	= raid6_sse12_gen_syndrome,
-	.name		= "sse1x2",
-};
-- 
2.56.0

