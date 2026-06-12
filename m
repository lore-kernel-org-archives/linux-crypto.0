Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9E03A7F69;
	Fri, 12 Jun 2026 05:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781241780; cv=none; b=EpdRa4vZ0y8ztleP0S51pGY6jRQwZ7JatBWxbpbUEOEXxXg789GszX71NflMhWyxD1+BvRoGuIpbwv9vk3qthx+0uMc/yP9wk2lTNLeXkN1t9qfvOeoWvaMBUe6KQKIBhD9aXrnZ45Kz2hmTPNiikbvwuDm2cMgeXLZh451zBgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781241780; c=relaxed/simple;
	bh=IhxxVjPtIx7YVdHyVMzyVLXVukNRI+stQdGXjnGxNzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzU6aellbSREfe123IjrZxeIkDjE/58KF/DUCF/IwGX1F3SnhiV3X6Cun4qe2w1WY3JtNcVnwFSmpjzCQrNgm/9lDVo9WpsyDilRdrF/o/pa2NK768tQI3CA5lsymzoSP3RlXBDtS1xiqazevK/Nt1Iuf5eTCvF/YAYW71yqThY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C55B68BFE; Fri, 12 Jun 2026 07:22:47 +0200 (CEST)
Date: Fri, 12 Jun 2026 07:22:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
	x86@kernel.org, Andrea Mazzoleni <amadvance@gmail.com>
Subject: Re: [PATCH] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260612052247.GA8848@lst.de>
References: <20260612044034.117442-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612044034.117442-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 11, 2026 at 09:40:34PM -0700, Eric Biggers wrote:
> Add an implementation of xor_gen() using AVX-512.

> Benchmark on AMD Ryzen 9 9950X (Zen 5):

Can you share the benchmark?

In my local tree I have ports of the AVX2 and AVX512 implementations
from snapraid (https://github.com/amadvance/snapraid), which in userspace
give really good performance.  On my Laptop with a AMD Ryzen AI 7 PRO 350
(which is a Zen5 with the slower double pumped AVX512 unit), both of
them get over 1GB/s throughput on the snapraid benchmarks.  I've been
holding them back as I don't have a good kernel benchmarking harness,
and it's missing the quirks for old AVX512 or the newer AMD special
cases.

Attached for reference.

Note that either way I'd prefer if we could get away from the stange
old code organization with the DO{1-4} helpers which don't really
help.

diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 4d633dfd5b90..3d5ebeda241e 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -28,7 +28,7 @@ xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
 xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
 xor-$(CONFIG_S390)		+= s390/xor.o
 xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
-xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o
+xor-$(CONFIG_X86_64)		+= x86/xor-avx512.o x86/xor-avx.o x86/xor-sse.o
 obj-y				+= tests/
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
diff --git a/lib/raid/xor/x86/xor-avx.c b/lib/raid/xor/x86/xor-avx.c
index f7777d7aa269..cd376a7c52d3 100644
--- a/lib/raid/xor/x86/xor-avx.c
+++ b/lib/raid/xor/x86/xor-avx.c
@@ -1,152 +1,31 @@
-// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Optimized XOR parity functions for AVX
- *
- * Copyright (C) 2012 Intel Corporation
- * Author: Jim Kukunas <james.t.kukunas@linux.intel.com>
- *
- * Based on Ingo Molnar and Zach Brown's respective MMX and SSE routines
+ * Copyright (C) 2026 Andrea Mazzoleni
  */
-#include <linux/compiler.h>
 #include <asm/fpu/api.h>
 #include "xor_impl.h"
 #include "xor_arch.h"
 
-#define BLOCK4(i) \
-		BLOCK(32 * i, 0) \
-		BLOCK(32 * (i + 1), 1) \
-		BLOCK(32 * (i + 2), 2) \
-		BLOCK(32 * (i + 3), 3)
-
-#define BLOCK16() \
-		BLOCK4(0) \
-		BLOCK4(4) \
-		BLOCK4(8) \
-		BLOCK4(12)
-
-static void xor_avx_2(unsigned long bytes, unsigned long * __restrict p0,
-		      const unsigned long * __restrict p1)
-{
-	unsigned long lines = bytes >> 9;
-
-	while (lines--) {
-#undef BLOCK
-#define BLOCK(i, reg) \
-do { \
-	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p1[i / sizeof(*p1)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm"  #reg : : \
-		"m" (p0[i / sizeof(*p0)])); \
-	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
-		"=m" (p0[i / sizeof(*p0)])); \
-} while (0);
-
-		BLOCK16()
-
-		p0 = (unsigned long *)((uintptr_t)p0 + 512);
-		p1 = (unsigned long *)((uintptr_t)p1 + 512);
-	}
-}
-
-static void xor_avx_3(unsigned long bytes, unsigned long * __restrict p0,
-		      const unsigned long * __restrict p1,
-		      const unsigned long * __restrict p2)
-{
-	unsigned long lines = bytes >> 9;
-
-	while (lines--) {
-#undef BLOCK
-#define BLOCK(i, reg) \
-do { \
-	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p2[i / sizeof(*p2)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p1[i / sizeof(*p1)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p0[i / sizeof(*p0)])); \
-	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
-		"=m" (p0[i / sizeof(*p0)])); \
-} while (0);
-
-		BLOCK16()
-
-		p0 = (unsigned long *)((uintptr_t)p0 + 512);
-		p1 = (unsigned long *)((uintptr_t)p1 + 512);
-		p2 = (unsigned long *)((uintptr_t)p2 + 512);
-	}
-}
-
-static void xor_avx_4(unsigned long bytes, unsigned long * __restrict p0,
-		      const unsigned long * __restrict p1,
-		      const unsigned long * __restrict p2,
-		      const unsigned long * __restrict p3)
-{
-	unsigned long lines = bytes >> 9;
-
-	while (lines--) {
-#undef BLOCK
-#define BLOCK(i, reg) \
-do { \
-	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p3[i / sizeof(*p3)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p2[i / sizeof(*p2)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p1[i / sizeof(*p1)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p0[i / sizeof(*p0)])); \
-	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
-		"=m" (p0[i / sizeof(*p0)])); \
-} while (0);
-
-		BLOCK16();
-
-		p0 = (unsigned long *)((uintptr_t)p0 + 512);
-		p1 = (unsigned long *)((uintptr_t)p1 + 512);
-		p2 = (unsigned long *)((uintptr_t)p2 + 512);
-		p3 = (unsigned long *)((uintptr_t)p3 + 512);
-	}
-}
-
-static void xor_avx_5(unsigned long bytes, unsigned long * __restrict p0,
-	     const unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3,
-	     const unsigned long * __restrict p4)
-{
-	unsigned long lines = bytes >> 9;
-
-	while (lines--) {
-#undef BLOCK
-#define BLOCK(i, reg) \
-do { \
-	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p4[i / sizeof(*p4)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p3[i / sizeof(*p3)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p2[i / sizeof(*p2)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p1[i / sizeof(*p1)])); \
-	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
-		"m" (p0[i / sizeof(*p0)])); \
-	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
-		"=m" (p0[i / sizeof(*p0)])); \
-} while (0);
-
-		BLOCK16()
-
-		p0 = (unsigned long *)((uintptr_t)p0 + 512);
-		p1 = (unsigned long *)((uintptr_t)p1 + 512);
-		p2 = (unsigned long *)((uintptr_t)p2 + 512);
-		p3 = (unsigned long *)((uintptr_t)p3 + 512);
-		p4 = (unsigned long *)((uintptr_t)p4 + 512);
-	}
-}
-
-DO_XOR_BLOCKS(avx_inner, xor_avx_2, xor_avx_3, xor_avx_4, xor_avx_5);
-
 static void xor_gen_avx(void *dest, void **srcs, unsigned int src_cnt,
 			unsigned int bytes)
 {
+	u8 **v = (u8 **)srcs;
+	u8 *p = dest;
+	unsigned int i, d;
+
 	kernel_fpu_begin();
-	xor_gen_avx_inner(dest, srcs, src_cnt, bytes);
+	for (i = 0; i < bytes; i += 64) {
+		asm volatile ("vmovdqa %0,%%ymm0" : : "m" (p[i]));
+		asm volatile ("vmovdqa %0,%%ymm1" : : "m" (p[i + 32]));
+		for (d = 0; d < src_cnt; ++d) {
+			asm volatile ("vpxor %0,%%ymm0,%%ymm0"
+				: : "m" (v[d][i]));
+			asm volatile ("vpxor %0,%%ymm1,%%ymm1"
+				: : "m" (v[d][i + 32]));
+		}
+		asm volatile ("vmovntdq %%ymm0,%0" : "=m" (p[i]));
+		asm volatile ("vmovntdq %%ymm1,%0" : "=m" (p[i + 32]));
+	}
 	kernel_fpu_end();
 }
 
diff --git a/lib/raid/xor/x86/xor-avx512.c b/lib/raid/xor/x86/xor-avx512.c
new file mode 100644
index 000000000000..9b323a0e1821
--- /dev/null
+++ b/lib/raid/xor/x86/xor-avx512.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2026 Andrea Mazzoleni
+ */
+#include <asm/fpu/api.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
+
+static void xor_gen_avx512bw(void *dest, void **srcs, unsigned int src_cnt,
+		unsigned int bytes)
+{
+	unsigned int last = src_cnt - 1, i, d;
+	u8 **v = (u8 **)srcs;
+	u8 *p = dest;
+
+	kernel_fpu_begin();
+	for (i = 0; i < bytes; i += 64) {
+		asm volatile("vmovdqa64 %0,%%zmm0" : : "m" (p[i]));
+		for (d = 0; d < last; d += 2)
+			asm volatile("vmovdqa64 %0,%%zmm1\n\t"
+				     "vpternlogq $0x96,%1,%%zmm1,%%zmm0"
+				     : : "m" (v[d][i]), "m" (v[d + 1][i]));
+		if (d == last)
+			asm volatile("vpxorq %0,%%zmm0,%%zmm0"
+				     : : "m" (v[last][i]));
+		asm volatile("vmovntdq %%zmm0,%0" : "=m" (p[i]));
+	}
+	kernel_fpu_end();
+}
+
+struct xor_block_template xor_block_avx512bw = {
+	.name		= "avx512bw",
+	.xor_gen	= xor_gen_avx512bw,
+};
diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index 99fe85a213c6..73c81221fc01 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -6,6 +6,7 @@ extern struct xor_block_template xor_block_p5_mmx;
 extern struct xor_block_template xor_block_sse;
 extern struct xor_block_template xor_block_sse_pf64;
 extern struct xor_block_template xor_block_avx;
+extern struct xor_block_template xor_block_avx512bw;
 
 /*
  * When SSE is available, use it as it can write around L2.  We may also be able
@@ -20,7 +21,12 @@ static __always_inline void __init arch_xor_init(void)
 {
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
 	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
-		xor_force(&xor_block_avx);
+		if (boot_cpu_has(X86_FEATURE_AVX2) &&
+		    boot_cpu_has(X86_FEATURE_AVX512F) &&
+		    boot_cpu_has(X86_FEATURE_AVX512BW))
+			xor_force(&xor_block_avx512bw);
+		else
+			xor_force(&xor_block_avx);
 	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
 		xor_register(&xor_block_sse);
 		xor_register(&xor_block_sse_pf64);
