Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6D438B12C;
	Mon, 15 Jun 2026 19:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781550371; cv=none; b=RPHQt36szpVEnp6NIZWU0M1ZOHEM/e9qPp38jRr9BNWc1dDXscNP35WxL6kP67bmmuZewIcWwlCTIN1E0/c4lo6C2b06X6X10rLmhIyvi9UGEqSeeXSSSG5Qh2GKEvWoz7cP/bLfoFgF6zztTNrIXGOmYdZP+PbhkjNAHW4yI24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781550371; c=relaxed/simple;
	bh=CwDUzrw1PQIj5RwmXdrCS093W2d82qVer5cbXdF1Z+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ARFNwtJWhnyVX3oKr8v+HW9V2Tt9i64Pyaw59XlWr/o7PPGNAtOYkH/ABJHBPPkzh/dtqIIXUWYsDcWR4AmfZyh95VDaJXgyikVAARoOYkto1G8gIPv8M5ibtB73d1uuGom7zqxx2TewDdQ9ebn5T2bzf064QfXiDIkb8eTSZv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZPWOKY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZPWOKY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D970D1F000E9;
	Mon, 15 Jun 2026 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781550370;
	bh=jdmIHPzPTzBdGzCJTVAbUpj8/UkL1BNAEEEf85jTvBc=;
	h=From:To:Cc:Subject:Date;
	b=eZPWOKY+Cpq4jAQcGYNj7dKmFKbnWDqFJynEgneqBmrhJ92NiJeFD28nWjME4IWwy
	 zF5eNetbGqK/e+PMkaqxDVQZPO8ApoAhbRVbYUgyVi5YIYhiWMdcJhGdy7jiU0DEXI
	 Y9FZGjKL2kb8+HyCmlIu9Ip2Wq5wMqy7zIAOGBreWftNftJ/SUo4/XNKYZEliDldnb
	 5Eu7IN8U8xk9bNBpaqHVJ2UiJRzZyIJZMs+fHQTQEkGAT60gE502tWLAqG3wy+EUKk
	 fvGPvYHzVsMK5ihAIfcq6MTAM5m+mrF10y/HiqZxND0GQ0VtIda7wpDk2MxdNKxUMT
	 GtzL+m3zNYjmg==
From: Eric Biggers <ebiggers@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-raid@vger.kernel.org
Subject: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Date: Mon, 15 Jun 2026 12:03:38 -0700
Message-ID: <20260615190338.26581-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
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

Benchmark on AMD Ryzen 9 9950X (Zen 5):

    src_cnt    avx          avx512       Improvement
    =======    ==========   ==========   ===========
    1          56353 MB/s   75388 MB/s   33%
    2          54274 MB/s   68409 MB/s   26%
    3          44649 MB/s   64042 MB/s   43%
    4          41315 MB/s   55002 MB/s   33%

Note: for now I omitted the cpu_has_xfeatures() check that the AVX-512
optimized crypto and CRC code does, since it's not implemented on
User-Mode Linux and it's never been present in the RAID6 code either.

Reviewed-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

Changed in v3:
    - Renamed p0-p4 to p1-p5 to match the inline asm indices
    - Swapped the base and index registers to the logical order
    - Added David's Reviewed-by

Changed in v2:
    - Fixed build on UML
    - Reworked the implementation

 lib/raid/xor/Makefile         |   2 +-
 lib/raid/xor/x86/xor-avx512.c | 121 ++++++++++++++++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h   |  26 ++++----
 3 files changed, 137 insertions(+), 12 deletions(-)
 create mode 100644 lib/raid/xor/x86/xor-avx512.c

diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 4d633dfd5b90..4af945861a51 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -26,11 +26,11 @@ xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vmx.o powerpc/xor_vmx_glue.o
 xor-$(CONFIG_RISCV_ISA_V)	+= riscv/xor.o riscv/xor-glue.o
 xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
 xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
 xor-$(CONFIG_S390)		+= s390/xor.o
 xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
-xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o
+xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-avx512.o
 obj-y				+= tests/
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
 CFLAGS_REMOVE_arm/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
 
diff --git a/lib/raid/xor/x86/xor-avx512.c b/lib/raid/xor/x86/xor-avx512.c
new file mode 100644
index 000000000000..17f57900d827
--- /dev/null
+++ b/lib/raid/xor/x86/xor-avx512.c
@@ -0,0 +1,121 @@
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
+	kernel_fpu_end();
+}
+
+struct xor_block_template xor_block_avx512 = {
+	.name = "avx512",
+	.xor_gen = xor_gen_avx512,
+};
diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index 99fe85a213c6..b5d49376fc97 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -4,26 +4,30 @@
 extern struct xor_block_template xor_block_pII_mmx;
 extern struct xor_block_template xor_block_p5_mmx;
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
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_AVX512F) &&
+	    boot_cpu_has(X86_FEATURE_OSXSAVE) &&
+	    !boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
+		/* AVX-512 will be the best; no need to try others. */
+		/* !PREFER_YMM excludes CPUs with overly-eager downclocking. */
+		xor_force(&xor_block_avx512);
+	} else if (boot_cpu_has(X86_FEATURE_AVX) &&
+		   boot_cpu_has(X86_FEATURE_OSXSAVE)) {
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
 		xor_register(&xor_block_pII_mmx);
 		xor_register(&xor_block_p5_mmx);

base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
2.54.0

