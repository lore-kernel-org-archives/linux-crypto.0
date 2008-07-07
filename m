From: austin zhang <austin_zhang@linux.intel.com>
Subject: [Fwd: [PATCH]Using Intel CRC32 instruction to implement hardware
	accelerated CRC32c algorithm.]
Date: Mon, 07 Jul 2008 05:17:38 -0400
Message-ID: <1215422258.19059.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: chaapala@cisco.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, arjan@linux.intel.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYGGJSB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2008 05:18:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 From NHM processor onward, Intel processors can support hardware accelerated
 CRC32c algorithm with the new CRC32 instruction in SSE 4.2 instruction set. 
 The patch detects the availability of the feature, and chooses the most proper 
 way to calculate CRC32c checksum.
 Byte code instructions are used for compiler compatibility. No MMX / XMM 
 registers is involved in the implementation.
 
 After basic testing with iSCSI and confirmed that the iSCSI head digest 
 routines can be speeded up by 4x - 10x.
 
 This patch is created against mainline 2.6.26-rc8

 Signed-off-by: Austin Zhang <austin_zhang@linux.intel.com>
 Signed-off-by: Kent Liu <kent.liu@linux.intel.com>
---
 include/asm-x86/cpufeature.h |    2 +
 include/asm-x86/crc32c-hw.h  |   63 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor.h  |    3 ++
 lib/libcrc32c.c              |   20 ++++++++++++-
 4 files changed, 86 insertions(+), 2 deletions(-)

diff -Naurp linux-2.6-rc8/include/asm-x86/cpufeature.h linux-2.6-rc8-patch/include/asm-x86/cpufeature.h
--- linux-2.6-rc8/include/asm-x86/cpufeature.h	2008-05-19 03:33:37.000000000 -0400
+++ linux-2.6-rc8-patch/include/asm-x86/cpufeature.h	2008-07-07 17:49:22.000000000 -0400
@@ -90,6 +90,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2 */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
@@ -187,6 +188,7 @@ extern const char * const x86_power_flag
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff -Naurp linux-2.6-rc8/include/asm-x86/crc32c-hw.h linux-2.6-rc8-patch/include/asm-x86/crc32c-hw.h
--- linux-2.6-rc8/include/asm-x86/crc32c-hw.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6-rc8-patch/include/asm-x86/crc32c-hw.h	2008-07-07 18:05:39.000000000 -0400
@@ -0,0 +1,63 @@
+/*
+ * Using hardware provided CRC32 instruction to accelerate the CRC32 disposal.
+ * CRC32C polynomial:0x1EDC6F41(BE)/0x82F63B78(LE)
+ * CRC32 is a new instruction in Intel SSE4.2, the reference can be found at:
+ * http://www.intel.com/products/processor/manuals/
+ * Intel(R) 64 and IA-32 Architectures Software Developer's Manual
+ * Volume 2A: Instruction Set Reference, A-M
+ */
+#ifndef __ASM_X86_CRC32C_HW_H
+#define __ASM_X86_CRC32C_HW_H
+
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+
+#ifdef CONFIG_X86_64
+#define REX_PRE	"0x48, "
+#define SCALE_F	8
+#else
+#define REX_PRE
+#define SCALE_F	4
+#endif
+
+u32 crc32c_le_hw_byte(u32 crc, unsigned char const *data, size_t length)
+{
+	while (length--) {
+		__asm__ __volatile__(
+			".byte 0xf2, 0xf, 0x38, 0xf0, 0xf1"
+			:"=S"(crc)
+			:"0"(crc), "c"(*data)
+		);
+		data++;
+	}
+
+	return crc;
+}
+
+u32 __pure crc32c_le_hw(u32 crc, unsigned char const *p, size_t len)
+{
+	unsigned int iquotient = len / SCALE_F;
+	unsigned int iremainder = len % SCALE_F;
+#ifdef CONFIG_X86_64
+	u64 *ptmp = (u64 *)p;
+#else
+	u32 *ptmp = (u32 *)p;
+#endif
+
+	while (iquotient--) {
+		__asm__ __volatile__(
+			".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
+			:"=S"(crc)
+			:"0"(crc), "c"(*ptmp)
+		);
+		ptmp++;
+	}
+
+	if (iremainder)
+		crc = crc32c_le_hw_byte(crc, (unsigned char *)ptmp, iremainder);
+
+	return crc;
+}
+
+#endif /* __ASM_X86_CRC32C_HW_H */
+
diff -Naurp linux-2.6-rc8/include/asm-x86/processor.h linux-2.6-rc8-patch/include/asm-x86/processor.h
--- linux-2.6-rc8/include/asm-x86/processor.h	2008-05-19 03:33:37.000000000 -0400
+++ linux-2.6-rc8-patch/include/asm-x86/processor.h	2008-07-07 18:02:40.000000000 -0400
@@ -777,6 +777,9 @@ extern char			ignore_fpu_irq;
 # define BASE_PREFETCH		"prefetcht0 (%1)"
 #endif
 
+/* Hardware provides CRC32C accelerated instruction */
+#define ARCH_HAS_CRC32C_HW	1
+
 /*
  * Prefetch instructions for Pentium III (+) and AMD Athlon (+)
  *
diff -Naurp linux-2.6-rc8/lib/libcrc32c.c linux-2.6-rc8-patch/lib/libcrc32c.c
--- linux-2.6-rc8/lib/libcrc32c.c	2008-05-19 03:33:38.000000000 -0400
+++ linux-2.6-rc8-patch/lib/libcrc32c.c	2008-07-07 18:30:42.000000000 -0400
@@ -34,6 +34,10 @@
 #include <linux/compiler.h>
 #include <linux/module.h>
 
+#ifdef ARCH_HAS_CRC32C_HW
+#include <asm/crc32c-hw.h>
+#endif
+
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations");
 MODULE_LICENSE("GPL");
@@ -66,7 +70,7 @@ EXPORT_SYMBOL(crc32c_le);
  * of space and maintainability in keeping the two modules separate.
  */
 u32 __pure
-crc32c_le(u32 crc, unsigned char const *p, size_t len)
+crc32c_le_sw(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
 	while (len--) {
@@ -160,7 +164,7 @@ static const u32 crc32c_table[256] = {
  */
 
 u32 __pure
-crc32c_le(u32 crc, unsigned char const *data, size_t length)
+crc32c_le_sw(u32 crc, unsigned char const *data, size_t length)
 {
 	while (length--)
 		crc =
@@ -171,6 +175,18 @@ crc32c_le(u32 crc, unsigned char const *
 
 #endif	/* CRC_LE_BITS == 8 */
 
+u32 __pure
+crc32c_le(u32 crc, unsigned char const *p, size_t len)
+{
+#ifdef ARCH_HAS_CRC32C_HW
+	if (cpu_has_xmm4_2)
+		return crc32c_le_hw(crc, p, len);
+#endif
+
+	return crc32c_le_sw(crc, p, len);
+}
+
+
 EXPORT_SYMBOL(crc32c_be);
 
 #if CRC_BE_BITS == 1


