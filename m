Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51178396D2E;
	Fri, 12 Jun 2026 04:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781239356; cv=none; b=RC/cakM6XcY9uF0bIONiFPRAkpQ2sOCroc3U5X5fyA1+y2OgK2xE0pOoJrFe3//oJQDxYs/x42APoG8whbybBdRGIkeYRAuOQn/8b0tJTEmV1Fi8RlFSEoUqofDW6byUSZSYX87Oz4FM+HPXfFcrsOza8X5lyxQVBWZouRPgl/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781239356; c=relaxed/simple;
	bh=nDdoZJ9apHldlxS1hMjpDiGX4smnjZCjlc2rwhTtzRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i+v3lPSk6ABdiFANlNLSVZADKI6y/hhcTOE60bu7WgC4Mqna0rP6tUeUFz8Md0xw1DXoYpiPkqDqLEc4yNmFdr/CB5ghz32a/VWAB6YDpOzx+eeVuei4xEpTOvtHwbYkvA0k4T6o5wMTduk9ah+DOfXb5nDi6RdLvb3mhPcd0Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGI/eO75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGI/eO75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAB31F000E9;
	Fri, 12 Jun 2026 04:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781239354;
	bh=Q7PcHELE+k/xy0DQZJZB9ZuvNQ+59hvPnfSjQX9ZaoY=;
	h=From:To:Cc:Subject:Date;
	b=OGI/eO75PucgmjryWJbftBucGv2KyV0jVP/iDcq34Ix9b34jkh/Q0/7iF/oroke3B
	 LuP516XAy9pEOkth74FK3VgxHNwadiquTcHCS6jTIcBPTYk0GorOxj6ODpkoZZO6W1
	 kri04E88VCbN73/IfacbA4np2Iaev18LRKMU+UfFOuOAbloxBxSp7J+ZepGDWLYuMW
	 DN2kETzxqucq5Iy3XOcaT7Lbeby5b0oGaEKCh+hKsoyjVPp6dkPlkVJsjIJRmGYiLc
	 Ic+YHizGcRGA6VVejMPfv7bMqoR2XrEbvRkMhTBE8vEqlYbDjgyk79UApOQ7MfQu+b
	 lBMWgA4vPKncg==
From: Eric Biggers <ebiggers@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Date: Thu, 11 Jun 2026 21:40:34 -0700
Message-ID: <20260612044034.117442-1-ebiggers@kernel.org>
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

    src_cnt    avx2         avx512       Improvement
    =======    ==========   ==========   ===========
    1          68423 MB/s   81940 MB/s   19%
    2          56035 MB/s   74112 MB/s   32%
    3          49396 MB/s   67011 MB/s   35%
    4          43056 MB/s   60823 MB/s   41%

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/Makefile         |   2 +-
 lib/raid/xor/x86/xor-avx512.c | 155 ++++++++++++++++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h   |  27 +++---
 3 files changed, 172 insertions(+), 12 deletions(-)
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
index 000000000000..d2b54aa2be98
--- /dev/null
+++ b/lib/raid/xor/x86/xor-avx512.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * AVX-512 optimized implementation of xor_gen()
+ *
+ * Copyright 2026 Google LLC
+ */
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/fpu/api.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
+
+struct block64 {
+	u8 x[64];
+} __aligned(64);
+
+/*
+ * Use different registers for each unrolled iteration just in case it helps,
+ * though the hardware register renamer should make it unnecessary.
+ */
+
+#define DO_XOR2(i, reg0)                                   \
+	asm volatile("vmovdqa64 %0, %%" reg0 "\n"          \
+		     "vpxorq %1, %%" reg0 ", %%" reg0 "\n" \
+		     "vmovdqa64 %%" reg0 ", %0\n"          \
+		     : "+m"(p0[i])                         \
+		     : "m"(p1[i]))
+
+#define DO_XOR3(i, reg0, reg1)                                        \
+	asm volatile("vmovdqa64 %0, %%" reg0 "\n"                     \
+		     "vmovdqa64 %1, %%" reg1 "\n"                     \
+		     "vpternlogq $0x96, %2, %%" reg1 ", %%" reg0 "\n" \
+		     "vmovdqa64 %%" reg0 ", %0\n"                     \
+		     : "+m"(p0[i])                                    \
+		     : "m"(p1[i]), "m"(p2[i]))
+
+#define DO_XOR4(i, reg0, reg1)                                        \
+	asm volatile("vmovdqa64 %0, %%" reg0 "\n"                     \
+		     "vmovdqa64 %1, %%" reg1 "\n"                     \
+		     "vpxorq %2, %%" reg0 ", %%" reg0 "\n"            \
+		     "vpternlogq $0x96, %3, %%" reg1 ", %%" reg0 "\n" \
+		     "vmovdqa64 %%" reg0 ", %0\n"                     \
+		     : "+m"(p0[i])                                    \
+		     : "m"(p1[i]), "m"(p2[i]), "m"(p3[i]))
+
+#define DO_XOR5(i, reg0, reg1)                                        \
+	asm volatile("vmovdqa64 %0, %%" reg0 "\n"                     \
+		     "vmovdqa64 %1, %%" reg1 "\n"                     \
+		     "vpternlogq $0x96, %2, %%" reg1 ", %%" reg0 "\n" \
+		     "vmovdqa64 %3, %%" reg1 "\n"                     \
+		     "vpternlogq $0x96, %4, %%" reg1 ", %%" reg0 "\n" \
+		     "vmovdqa64 %%" reg0 ", %0\n"                     \
+		     : "+m"(p0[i])                                    \
+		     : "m"(p1[i]), "m"(p2[i]), "m"(p3[i]), "m"(p4[i]))
+
+static void xor_avx512_2(size_t bytes, struct block64 *p0,
+			 const struct block64 *p1)
+{
+	do {
+		DO_XOR2(0, "zmm0");
+		DO_XOR2(1, "zmm1");
+		DO_XOR2(2, "zmm2");
+		DO_XOR2(3, "zmm3");
+		DO_XOR2(4, "zmm4");
+		DO_XOR2(5, "zmm5");
+		DO_XOR2(6, "zmm6");
+		DO_XOR2(7, "zmm7");
+		p0 += 512 / sizeof(*p0);
+		p1 += 512 / sizeof(*p1);
+		bytes -= 512;
+	} while (bytes);
+}
+
+static void xor_avx512_3(size_t bytes, struct block64 *p0,
+			 const struct block64 *p1, const struct block64 *p2)
+{
+	do {
+		DO_XOR3(0, "zmm0", "zmm1");
+		DO_XOR3(1, "zmm2", "zmm3");
+		DO_XOR3(2, "zmm4", "zmm5");
+		DO_XOR3(3, "zmm6", "zmm7");
+		DO_XOR3(4, "zmm8", "zmm9");
+		DO_XOR3(5, "zmm10", "zmm11");
+		DO_XOR3(6, "zmm12", "zmm13");
+		DO_XOR3(7, "zmm14", "zmm15");
+		p0 += 512 / sizeof(*p0);
+		p1 += 512 / sizeof(*p1);
+		p2 += 512 / sizeof(*p2);
+		bytes -= 512;
+	} while (bytes);
+}
+
+static void xor_avx512_4(size_t bytes, struct block64 *p0,
+			 const struct block64 *p1, const struct block64 *p2,
+			 const struct block64 *p3)
+{
+	do {
+		DO_XOR4(0, "zmm0", "zmm1");
+		DO_XOR4(1, "zmm2", "zmm3");
+		DO_XOR4(2, "zmm4", "zmm5");
+		DO_XOR4(3, "zmm6", "zmm7");
+		DO_XOR4(4, "zmm8", "zmm9");
+		DO_XOR4(5, "zmm10", "zmm11");
+		DO_XOR4(6, "zmm12", "zmm13");
+		DO_XOR4(7, "zmm14", "zmm15");
+		p0 += 512 / sizeof(*p0);
+		p1 += 512 / sizeof(*p1);
+		p2 += 512 / sizeof(*p2);
+		p3 += 512 / sizeof(*p3);
+		bytes -= 512;
+	} while (bytes);
+}
+
+static void xor_avx512_5(size_t bytes, struct block64 *p0,
+			 const struct block64 *p1, const struct block64 *p2,
+			 const struct block64 *p3, const struct block64 *p4)
+{
+	do {
+		DO_XOR5(0, "zmm0", "zmm1");
+		DO_XOR5(1, "zmm2", "zmm3");
+		DO_XOR5(2, "zmm4", "zmm5");
+		DO_XOR5(3, "zmm6", "zmm7");
+		DO_XOR5(4, "zmm8", "zmm9");
+		DO_XOR5(5, "zmm10", "zmm11");
+		DO_XOR5(6, "zmm12", "zmm13");
+		DO_XOR5(7, "zmm14", "zmm15");
+		p0 += 512 / sizeof(*p0);
+		p1 += 512 / sizeof(*p1);
+		p2 += 512 / sizeof(*p2);
+		p3 += 512 / sizeof(*p3);
+		p4 += 512 / sizeof(*p4);
+		bytes -= 512;
+	} while (bytes);
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
index 99fe85a213c6..199124e32c27 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -1,29 +1,34 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 #include <asm/cpufeature.h>
+#include <asm/fpu/api.h>
 
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
+	    !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL)) {
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

base-commit: 9716c086c8e8b141d35aa61f2e96a2e83de212a7
-- 
2.54.0

