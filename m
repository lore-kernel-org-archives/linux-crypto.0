Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40FC41D135;
	Tue,  1 Sep 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274697; cv=none; b=qbzcY7aE8g9IyTRD6XSEe6oN93K42+CPm6EZ441n2pHrvej5LaH60Ys0DwjwIaqo4SOohAPucIsEKDhpLlwTXMn65tG2SHeQ9ATWtlHZ5TvHlfnrQ2D1M0sI2F3b4hx/P09ouTqRLyHC+BUtdak9GSEV5G7WKgE5jU/KTwwbRz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274697; c=relaxed/simple;
	bh=0NZj8dzHMvDPafeShpBt1PLgjhP7gFYn0JXz851agAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVcxduYfeuBd6iy5Ay/NtrE9LR8b6SOdIdGqwhnX0YcMZVcAmjXUjbBReRfWaRvB0c08cJcJf0G6d1JSNlJXlPdn3S/x1rg4aIyj1d0WlUJ3X+a25TcD88+uTRvGCfLyIKtjqkvsoYWNoSVd7eaLh7M2WAVZLYbFLJrWi+xx9bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHmVoYtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHmVoYtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF741F00ADE;
	Tue,  1 Sep 2026 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274695;
	bh=UTvJDIw3wcg7xi4i0kyVSun0Dn6RIuyJL6Ze7BRUb5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHmVoYtD48si7U4QBauUocNTZRD1pcYnoGOdDynX3BhCHV/UgsIB+z2JK1nYO11t8
	 JVRGqHItgAbcTdxPsb66Wk+Ro3HzpCxFUkarQlX9yShbQVZAejZNohwd3QUzip7HTx
	 kOlFQBv5nTbH304V+gsJvn+5WY3k++rpVpkiiOnLMYI3i/byofcDRs/VEYNnsetO46
	 AXWLkz3z1eMUD06SvLIF7oLZFGEIqd2oC54Tu7qs/JVJ81jzKMbS+H5YtJFCZe4Z03
	 OJi+j8iP4uy6xNa0eMsl4tyPxiNMtFDlv0RJU5uAGwo0iMO7kt5OmA+k/MUp8WvYfO
	 ioQkgoguf72Lg==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v5 8/8] xor: Add AVX-512 optimized xor_gen()
Date: Tue,  1 Sep 2026 07:57:40 -0700
Message-ID: <20260901145740.42337-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901145740.42337-1-ebiggers@kernel.org>
References: <20260901145740.42337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an implementation of xor_gen() using AVX-512.

It uses 512-bit vectors, i.e. ZMM registers.  It also uses the
vpternlogq instruction to do three-input XORs when applicable.

It's enabled on x86_64 CPUs that have AVX512F && !PREFER_YMM.  In
practice that means:

    - AMD Zen 4 and later (client and server)
    - Intel Sapphire Rapids and later (server)
    - Intel Rocket Lake (client)
    - Intel Nova Lake and later (client)

The !PREFER_YMM condition excludes the older AVX-512 implementations in
Intel Skylake Server and Intel Ice Lake.  They could run this code, but
they're known to have overly-eager downclocking when ZMM registers are
used.  This is the same policy that the crypto and CRC code uses.

Results from xor_benchmark on AMD Ryzen 9 9950X (Zen 5):

Before:

    # xor_benchmark:           	 4096 bytes	16384 bytes
    # xor_benchmark:   4 disks:	  256  GB/s	  185  GB/s
    # xor_benchmark:   5 disks:	  233  GB/s	  165  GB/s
    # xor_benchmark:   6 disks:	  243  GB/s	  174  GB/s
    # xor_benchmark:   7 disks:	  244  GB/s	  176  GB/s
    # xor_benchmark:   8 disks:	  265  GB/s	  179  GB/s
    # xor_benchmark:  10 disks:	  249  GB/s	  175  GB/s
    # xor_benchmark:  12 disks:	  219  GB/s	  173  GB/s
    # xor_benchmark:  15 disks:	  206  GB/s	  177  GB/s
    # xor_benchmark:  16 disks:	  212  GB/s	  180  GB/s
    # xor_benchmark:  32 disks:	  193  GB/s	  177  GB/s

After:

    # xor_benchmark:           	 4096 bytes	16384 bytes
    # xor_benchmark:   4 disks:	  492  GB/s	  202  GB/s
    # xor_benchmark:   5 disks:	  436  GB/s	  191  GB/s
    # xor_benchmark:   6 disks:	  466  GB/s	  193  GB/s
    # xor_benchmark:   7 disks:	  491  GB/s	  194  GB/s
    # xor_benchmark:   8 disks:	  513  GB/s	  205  GB/s
    # xor_benchmark:  10 disks:	  454  GB/s	  199  GB/s
    # xor_benchmark:  12 disks:	  330  GB/s	  204  GB/s
    # xor_benchmark:  15 disks:	  266  GB/s	  198  GB/s
    # xor_benchmark:  16 disks:	  243  GB/s	  177  GB/s
    # xor_benchmark:  32 disks:	  187  GB/s	  165  GB/s

Reviewed-by: David Laight <david.laight.linux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/Makefile         |   2 +-
 lib/raid/xor/x86/xor-avx512.c | 122 ++++++++++++++++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h   |  30 ++++++---
 3 files changed, 143 insertions(+), 11 deletions(-)
 create mode 100644 lib/raid/xor/x86/xor-avx512.c

diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 9b0fad459cdb..e1e3455c219d 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -31,7 +31,7 @@ xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
 xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
 xor-$(CONFIG_S390)		+= s390/xor.o
 xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
-xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o
+xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-avx512.o
 obj-y				+= tests/
 
 CFLAGS_xor-neon.o		+= $(CC_FLAGS_FPU) -I$(src)/$(SRCARCH)
diff --git a/lib/raid/xor/x86/xor-avx512.c b/lib/raid/xor/x86/xor-avx512.c
new file mode 100644
index 000000000000..c11d83441875
--- /dev/null
+++ b/lib/raid/xor/x86/xor-avx512.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * AVX-512 optimized implementation of xor_gen()
+ *
+ * Copyright 2026 Google LLC
+ */
+
+#include <linux/types.h>
+#include <asm/fpu/api.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
+
+/*
+ * Implementation notes:
+ *
+ * Unrolling by the number of buffers (2-5) is very important.
+ *
+ * Unrolling by length is less important, especially when using register-indexed
+ * addressing with negative indices from the end of the buffers.  That approach
+ * results in just two loop control instructions being needed per iteration,
+ * regardless of the number of buffers.
+ *
+ * In fact, benchmarks showed that the 2 and 3 buffer cases require only 2x
+ * unrolling by length, while the 4 and 5 buffer cases don't require any
+ * unrolling by length.  Benchmarks also showed that the register-indexed
+ * addressing isn't a bottleneck either; i.e., we can't do any better by
+ * incrementing the pointers as we go along, even with more unrolling.
+ */
+
+static void xor_avx512_2(long bytes, u8 *p1, const u8 *p2)
+{
+	long i = -bytes;
+
+	asm volatile("1: vmovdqa64 (%1,%0), %%zmm0\n"
+		     "vmovdqa64 64(%1,%0), %%zmm1\n"
+		     "vpxorq (%2,%0), %%zmm0, %%zmm0\n"
+		     "vpxorq 64(%2,%0), %%zmm1, %%zmm1\n"
+		     "vmovdqa64 %%zmm0, (%1,%0)\n"
+		     "vmovdqa64 %%zmm1, 64(%1,%0)\n"
+		     "add $128, %0\n"
+		     "jnz 1b\n"
+		     : "+&r"(i)
+		     : "r"(p1 + bytes), "r"(p2 + bytes)
+		     : "memory", "cc");
+}
+
+static void xor_avx512_3(long bytes, u8 *p1, const u8 *p2, const u8 *p3)
+{
+	long i = -bytes;
+
+	asm volatile("1: vmovdqa64 (%1,%0), %%zmm0\n"
+		     "vmovdqa64 64(%1,%0), %%zmm1\n"
+		     "vmovdqa64 (%2,%0), %%zmm2\n"
+		     "vmovdqa64 64(%2,%0), %%zmm3\n"
+		     "vpternlogq $0x96, (%3,%0), %%zmm2, %%zmm0\n"
+		     "vpternlogq $0x96, 64(%3,%0), %%zmm3, %%zmm1\n"
+		     "vmovdqa64 %%zmm0, (%1,%0)\n"
+		     "vmovdqa64 %%zmm1, 64(%1,%0)\n"
+		     "add $128, %0\n"
+		     "jnz 1b\n"
+		     : "+&r"(i)
+		     : "r"(p1 + bytes), "r"(p2 + bytes), "r"(p3 + bytes)
+		     : "memory", "cc");
+}
+
+static void xor_avx512_4(long bytes, u8 *p1, const u8 *p2, const u8 *p3,
+			 const u8 *p4)
+{
+	long i = -bytes;
+
+	asm volatile("1: vmovdqa64 (%1,%0), %%zmm0\n"
+		     "vmovdqa64 (%2,%0), %%zmm1\n"
+		     "vpxorq (%3,%0), %%zmm0, %%zmm0\n"
+		     "vpternlogq $0x96, (%4,%0), %%zmm1, %%zmm0\n"
+		     "vmovdqa64 %%zmm0, (%1,%0)\n"
+		     "add $64, %0\n"
+		     "jnz 1b\n"
+		     : "+&r"(i)
+		     : "r"(p1 + bytes), "r"(p2 + bytes), "r"(p3 + bytes),
+		       "r"(p4 + bytes)
+		     : "memory", "cc");
+}
+
+static void xor_avx512_5(long bytes, u8 *p1, const u8 *p2, const u8 *p3,
+			 const u8 *p4, const u8 *p5)
+{
+	long i = -bytes;
+
+	asm volatile("1: vmovdqa64 (%1,%0), %%zmm0\n"
+		     "vmovdqa64 (%2,%0), %%zmm1\n"
+		     "vpternlogq $0x96, (%3,%0), %%zmm1, %%zmm0\n"
+		     "vmovdqa64 (%4,%0), %%zmm1\n"
+		     "vpternlogq $0x96, (%5,%0), %%zmm1, %%zmm0\n"
+		     "vmovdqa64 %%zmm0, (%1,%0)\n"
+		     "add $64, %0\n"
+		     "jnz 1b\n"
+		     : "+&r"(i)
+		     : "r"(p1 + bytes), "r"(p2 + bytes), "r"(p3 + bytes),
+		       "r"(p4 + bytes), "r"(p5 + bytes)
+		     : "memory", "cc");
+}
+
+DO_XOR_BLOCKS(avx512_inner, xor_avx512_2, xor_avx512_3, xor_avx512_4,
+	      xor_avx512_5);
+
+/*
+ * Preconditions: bytes is a nonzero multiple of 512, and all buffers are
+ * 64-byte aligned.
+ */
+static void xor_gen_avx512(void *dest, void **srcs, unsigned int src_cnt,
+			   unsigned int bytes)
+{
+	kernel_fpu_begin();
+	xor_gen_avx512_inner(dest, srcs, src_cnt, bytes);
+	asm volatile("vzeroupper");
+	kernel_fpu_end();
+}
+
+struct xor_block_template xor_block_avx512 = {
+	.name = "avx512",
+	.xor_gen = xor_gen_avx512,
+};
diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index 991abe3f4bbd..ed5921d2e2aa 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -6,21 +6,31 @@ extern struct xor_block_template xor_block_p5_mmx;
 extern struct xor_block_template xor_block_sse;
 extern struct xor_block_template xor_block_sse_pf64;
 extern struct xor_block_template xor_block_avx;
+extern struct xor_block_template xor_block_avx512;
 
-/*
- * When SSE is available, use it as it can write around L2.  We may also be able
- * to load into the L1 only depending on how the cpu deals with a load to a line
- * that is being prefetched.
- *
- * When AVX2 is available, force using it as it is better by all measures.
- *
- * 32-bit without MMX can fall back to the generic routines.
- */
 static __always_inline void __init arch_xor_init(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX)) {
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_AVX512F) &&
+	    !boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
+		/*
+		 * Use the AVX-512 code on CPUs that support AVX-512 without
+		 * overly-eager downclocking.  On such CPUs the AVX-512 code
+		 * should always work at least as well as the AVX code, so
+		 * runtime selection is unnecessary.
+		 *
+		 * The AVX-512 code can work on X86_32.  However, due to lack of
+		 * use case for that, for now it's built only for X86_64.
+		 */
+		xor_force(&xor_block_avx512);
+	} else if (boot_cpu_has(X86_FEATURE_AVX)) {
+		/* AVX will be the best; no need to try others. */
 		xor_force(&xor_block_avx);
 	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
+		/*
+		 * When SSE is available, use it as it can write around L2.  We
+		 * may also be able to load into the L1 only depending on how
+		 * the cpu deals with a load to a line that is being prefetched.
+		 */
 		xor_register(&xor_block_sse);
 		xor_register(&xor_block_sse_pf64);
 	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
-- 
2.55.0

