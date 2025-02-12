Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7F31FFC66;
	Wed, 12 Feb 2025 20:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739390879; cv=none; b=LNj5soKi5sr3sS9GaOvmNtDcFDF05VQsyBZPh3Z6iVJYmIH1S+Mg/Lmqi2hC91OJjbGiqyxbI+wdfSxy6GPxx6GK6ucM0N5nCHKPAfqfavzZ73Z4vIJ0knjEjvCPpWtmZR467RQNl9jVCqGDsU7Na2HO7wkRBx8q5LtWPyNdHAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739390879; c=relaxed/simple;
	bh=7WTBunG74iXFuhyRtRY1W4TFzmye6XaIp6Qz/sWn+CU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=It/6lMQl08S2NiW5pe5YR7TLV+6yPQ+A52tEiEE/iG01zD2b2dZZoURP5vanNIZkpo9j4wkOERYBEAkmvcLGNbkmxoXMxqj2w83eV0gB75crydtZUX2cvLXiKfE28gzeyspXVlpSJYFKUjbjpItDm+r7spetfGTka7Y2eBeYrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RS6Ka6ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RS6Ka6ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDABC4CEDF;
	Wed, 12 Feb 2025 20:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739390878;
	bh=7WTBunG74iXFuhyRtRY1W4TFzmye6XaIp6Qz/sWn+CU=;
	h=From:To:Cc:Subject:Date:From;
	b=RS6Ka6roX53jJJY8YlRZNoSO8UMfs9WbxUSjnqE3pZ/kRLlnqEfbkg+8jo9wvavmS
	 Im1JudxYFQkGrzL8RQYIr7kymvEK+wGoPOSw2q1+BwijzcJVM/7tR3yWgxXFLF442n
	 oGfdjb6waJJ7qKhAksot8f3NmDsPucI5XTzzRLsCJxphORvtff5mxPNMWye7zCv0d5
	 Lf7g10WNH0WPGtlGVY2b7Mhg/dhG0/aC+VTZ94sD/xAB6ycKlHDvuPyN4YruKCFGwL
	 5imKsz1uxNIE2X5e96j8JjfZp0GxJCitmAaRXb2IMy85D7dvQ8UTIAie//UirrIRft
	 FQHMgpc8RDpmA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	linux-riscv@lists.infradead.org
Subject: [PATCH v4] riscv/crc-t10dif: Optimize crct10dif with zbc extension
Date: Wed, 12 Feb 2025 12:07:23 -0800
Message-ID: <20250212200723.135894-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhihang Shao <zhihang.shao.iscas@gmail.com>

The current CRC-T10DIF algorithm on RISC-V platform is based on
table-lookup optimization.  Given the previous work on optimizing crc32
calculations with zbc extension, it is believed that this will be
equally effective for accelerating crc-t10dif.

Therefore this patch adds an implementation of crc-t10dif using zbc
extension. It detects whether the current runtime environment supports
zbc feature and, if so, uses it to accelerate crc-t10dif calculations.

This patch is updated due to the patchset of updating kernel's
CRC-T10DIF library in 6.14, which is finished by Eric Biggers.  Also, I
used crc_kunit.c to test the performance of crc-t10dif optimized by crc
extension.

Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
[EB: fixed 32-bit build, added comments that explain the algorithm used,
     and various other cleanups]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch applies to 
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

 arch/riscv/Kconfig                |   1 +
 arch/riscv/lib/Makefile           |   1 +
 arch/riscv/lib/crc-t10dif-riscv.c | 131 ++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+)
 create mode 100644 arch/riscv/lib/crc-t10dif-riscv.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 7612c52e9b1e3..db1cf9666dfdd 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -23,10 +23,11 @@ config RISCV
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CRC32 if RISCV_ISA_ZBC
+	select ARCH_HAS_CRC_T10DIF if RISCV_ISA_ZBC
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_FAST_MULTIPLIER
diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
index 79368a895feed..d1d1f3d880e32 100644
--- a/arch/riscv/lib/Makefile
+++ b/arch/riscv/lib/Makefile
@@ -14,8 +14,9 @@ lib-$(CONFIG_RISCV_ISA_V)	+= uaccess_vector.o
 endif
 lib-$(CONFIG_MMU)	+= uaccess.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 lib-$(CONFIG_RISCV_ISA_ZICBOZ)	+= clear_page.o
 obj-$(CONFIG_CRC32_ARCH)	+= crc32-riscv.o
+obj-$(CONFIG_CRC_T10DIF_ARCH)	+= crc-t10dif-riscv.o
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 lib-$(CONFIG_RISCV_ISA_V)	+= xor.o
 lib-$(CONFIG_RISCV_ISA_V)	+= riscv_v_helpers.o
diff --git a/arch/riscv/lib/crc-t10dif-riscv.c b/arch/riscv/lib/crc-t10dif-riscv.c
new file mode 100644
index 0000000000000..2e9c3dcba8a0e
--- /dev/null
+++ b/arch/riscv/lib/crc-t10dif-riscv.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Accelerated CRC-T10DIF implementation with RISC-V Zbc extension.
+ *
+ * Copyright (C) 2024 Institute of Software, CAS.
+ */
+
+#include <asm/alternative-macros.h>
+#include <asm/byteorder.h>
+#include <asm/hwcap.h>
+
+#include <linux/crc-t10dif.h>
+#include <linux/module.h>
+
+/*
+ * CRC-T10DIF is a 16-bit CRC that uses most-significant-bit-first bit order,
+ * i.e. bit i contains the coefficient of x^i (not reflected).
+ */
+
+#define CRCT10DIF_POLY		0x18bb7 /* The generator polynomial G */
+
+#if __riscv_xlen == 64
+#define CRCT10DIF_QUOTIENT_POLY	0xf65a57f81d33a48a /* floor(x^80 / G) - x^64 */
+#define load_be_long(x)		be64_to_cpup(x)
+#elif __riscv_xlen == 32
+#define CRCT10DIF_QUOTIENT_POLY	0xf65a57f8	   /* floor(x^48 / G) - x^32 */
+#define load_be_long(x)		be32_to_cpup(x)
+#else
+#error "Unsupported __riscv_xlen"
+#endif
+
+/*
+ * Multiply the XLEN-bit message polynomial @m by x^16 and reduce it modulo the
+ * generator polynomial G.  This gives the CRC of the message polynomial @m.
+ */
+static inline u16 crct10dif_zbc(unsigned long m)
+{
+	u16 crc;
+
+	asm volatile(".option push\n"
+		     ".option arch,+zbc\n"
+		     /*
+		      * First step of Barrett reduction with integrated
+		      * multiplication by x^16:
+		      *
+		      *    %0 := floor((m * floor(x^(XLEN+16) / G)) / x^XLEN)
+		      *
+		      * The resulting value is equal to floor((m * x^16) / G).
+		      *
+		      * The constant floor(x^(XLEN+16) / G) has degree x^XLEN,
+		      * i.e. it has XLEN+1 bits.  The clmulh instruction
+		      * multiplies m by the x^0 through x^(XLEN-1) terms of this
+		      * constant and does the floored division by x^XLEN.  The
+		      * xor instruction handles the x^XLEN term of the constant
+		      * by adding an additional (m * x^XLEN) / x^XLEN = m.
+		      */
+		     "clmulh %0, %1, %2\n"
+		     "xor    %0, %0, %1\n"
+		     /*
+		      * Second step of Barrett reduction:
+		      *
+		      *    crc := (m * x^16) + (G * floor((m * x^16) / G))
+		      *
+		      * This reduces (m * x^16) modulo G by adding the
+		      * appropriate multiple of G to it.  The result uses only
+		      * the x^0 through x^15 terms.  HOWEVER, since the
+		      * unreduced value (m * x^16) is zero in those terms in the
+		      * first place, it is more efficient to do the equivalent:
+		      *
+		      *    crc := (G * floor((m * x^16) / G)) mod x^16
+		      */
+		     "clmul  %0, %0, %3\n"
+		     ".option pop\n"
+		     : "=&r" (crc)
+		     : "r" (m),
+		     "r" (CRCT10DIF_QUOTIENT_POLY),
+		     "r" (CRCT10DIF_POLY));
+	return crc;
+}
+
+static inline u16 crct10dif_unaligned(u16 crc, const u8 *p, size_t len)
+{
+	unsigned long m;
+	size_t i;
+
+	if (len == 1)
+		return crct10dif_zbc(p[0] ^ (crc >> 8)) ^ (crc << 8);
+
+	/* assuming len >= 2 here */
+	m = crc ^ (p[0] << 8) ^ p[1];
+	for (i = 2; i < len; i++)
+		m = (m << 8) ^ p[i];
+	return crct10dif_zbc(m);
+}
+
+u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len)
+{
+	size_t align;
+	unsigned long m;
+
+	asm goto(ALTERNATIVE("j %l[fallback]", "nop", 0,
+			     RISCV_ISA_EXT_ZBC, 1) : : : : fallback);
+
+	align = -(unsigned long)p % sizeof(unsigned long);
+	if (align && len) {
+		align = min(align, len);
+		crc = crct10dif_unaligned(crc, p, align);
+		p += align;
+		len -= align;
+	}
+
+	while (len >= sizeof(unsigned long)) {
+		m = ((unsigned long)crc << (8 * sizeof(unsigned long) - 16)) ^
+		    load_be_long((const void *)p);
+		crc = crct10dif_zbc(m);
+		p += sizeof(unsigned long);
+		len -= sizeof(unsigned long);
+	}
+
+	if (len)
+		crc = crct10dif_unaligned(crc, p, len);
+
+	return crc;
+
+fallback:
+	return crc_t10dif_generic(crc, p, len);
+}
+EXPORT_SYMBOL(crc_t10dif_arch);
+
+MODULE_DESCRIPTION("CRC-T10DIF using RISC-V ZBC Extension");
+MODULE_LICENSE("GPL");

base-commit: 4ffd50862d41e5aaf2e749efa354afaa1317c309
-- 
2.48.1

