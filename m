From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/4] arm64/lib: add accelerated crc32 routines
Date: Mon, 27 Aug 2018 13:02:44 +0200
Message-ID: <20180827110245.14812-4-ard.biesheuvel@linaro.org>
References: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, ebiggers@google.com,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Unlike crc32c(), which is wired up to the crypto API internally so the
optimal driver is selected based on the platform's capabilities,
crc32_le() is implemented as a library function using a slice-by-8 table
based C implementation. Even though few of the call sites may be
bottlenecks, calling a time variant implementation with a non-negligible
D-cache footprint is a bit of a waste, given that ARMv8.1 and up mandates
support for the CRC32 instructions that were optional in ARMv8.0, but are
already widely available, even on the Cortex-A53 based Raspberry Pi.

So implement routines that use these instructions if available, and fall
back to the existing generic routines otherwise. The selection is based
on alternatives patching.

Note that this unconditionally selects CONFIG_CRC32 as a builtin. Since
CRC32 is relied upon by core functionality such as CONFIG_OF_FLATTREE,
this just codifies the status quo.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig      |  1 +
 arch/arm64/lib/Makefile |  2 +
 arch/arm64/lib/crc32.S  | 60 ++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 29e75b47becd..0625355f12fa 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -75,6 +75,7 @@ config ARM64
 	select CLONE_BACKWARDS
 	select COMMON_CLK
 	select CPU_PM if (SUSPEND || CPU_IDLE)
+	select CRC32
 	select DCACHE_WORD_ACCESS
 	select DMA_DIRECT_OPS
 	select EDAC_SUPPORT
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 68755fd70dcf..f28f91fd96a2 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -25,3 +25,5 @@ KCOV_INSTRUMENT_atomic_ll_sc.o	:= n
 UBSAN_SANITIZE_atomic_ll_sc.o	:= n
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
+
+obj-$(CONFIG_CRC32) += crc32.o
diff --git a/arch/arm64/lib/crc32.S b/arch/arm64/lib/crc32.S
new file mode 100644
index 000000000000..5bc1e85b4e1c
--- /dev/null
+++ b/arch/arm64/lib/crc32.S
@@ -0,0 +1,60 @@
+/*
+ * Accelerated CRC32(C) using AArch64 CRC instructions
+ *
+ * Copyright (C) 2016 - 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative.h>
+#include <asm/assembler.h>
+
+	.cpu		generic+crc
+
+	.macro		__crc32, c
+0:	subs		x2, x2, #16
+	b.mi		8f
+	ldp		x3, x4, [x1], #16
+CPU_BE(	rev		x3, x3		)
+CPU_BE(	rev		x4, x4		)
+	crc32\c\()x	w0, w0, x3
+	crc32\c\()x	w0, w0, x4
+	b.ne		0b
+	ret
+
+8:	tbz		x2, #3, 4f
+	ldr		x3, [x1], #8
+CPU_BE(	rev		x3, x3		)
+	crc32\c\()x	w0, w0, x3
+4:	tbz		x2, #2, 2f
+	ldr		w3, [x1], #4
+CPU_BE(	rev		w3, w3		)
+	crc32\c\()w	w0, w0, w3
+2:	tbz		x2, #1, 1f
+	ldrh		w3, [x1], #2
+CPU_BE(	rev16		w3, w3		)
+	crc32\c\()h	w0, w0, w3
+1:	tbz		x2, #0, 0f
+	ldrb		w3, [x1]
+	crc32\c\()b	w0, w0, w3
+0:	ret
+	.endm
+
+	.align		5
+ENTRY(crc32_le)
+alternative_if_not ARM64_HAS_CRC32
+	b		crc32_le_base
+alternative_else_nop_endif
+	__crc32
+ENDPROC(crc32_le)
+
+	.align		5
+ENTRY(__crc32c_le)
+alternative_if_not ARM64_HAS_CRC32
+	b		__crc32c_le_base
+alternative_else_nop_endif
+	__crc32		c
+ENDPROC(__crc32c_le)
-- 
2.18.0
