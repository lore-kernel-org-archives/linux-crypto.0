From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v4 01/20] asm: simd context helper API
Date: Fri, 14 Sep 2018 18:22:21 +0200
Message-ID: <20180914162240.7925-2-Jason@zx2c4.com>
References: <20180914162240.7925-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arch@vger.kernel.org
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914162240.7925-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sometimes it's useful to amortize calls to XSAVE/XRSTOR and the related
FPU/SIMD functions over a number of calls, because FPU restoration is
quite expensive. This adds a simple header for carrying out this pattern:

    simd_context_t simd_context = simd_get();
    while ((item = get_item_from_queue()) != NULL) {
        encrypt_item(item, simd_context);
        simd_context = simd_relax(simd_context);
    }
    simd_put(simd_context);

The relaxation step ensures that we don't trample over preemption, and
the get/put API should be a familiar paradigm in the kernel.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-arch@vger.kernel.org
---
 arch/alpha/include/asm/Kbuild      |  5 ++--
 arch/arc/include/asm/Kbuild        |  1 +
 arch/arm/include/asm/simd.h        | 42 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/simd.h      | 37 +++++++++++++++++++++-----
 arch/c6x/include/asm/Kbuild        |  3 ++-
 arch/h8300/include/asm/Kbuild      |  3 ++-
 arch/hexagon/include/asm/Kbuild    |  1 +
 arch/ia64/include/asm/Kbuild       |  1 +
 arch/m68k/include/asm/Kbuild       |  1 +
 arch/microblaze/include/asm/Kbuild |  1 +
 arch/mips/include/asm/Kbuild       |  1 +
 arch/nds32/include/asm/Kbuild      |  7 ++---
 arch/nios2/include/asm/Kbuild      |  1 +
 arch/openrisc/include/asm/Kbuild   |  7 ++---
 arch/parisc/include/asm/Kbuild     |  1 +
 arch/powerpc/include/asm/Kbuild    |  3 ++-
 arch/riscv/include/asm/Kbuild      |  3 ++-
 arch/s390/include/asm/Kbuild       |  3 ++-
 arch/sh/include/asm/Kbuild         |  1 +
 arch/sparc/include/asm/Kbuild      |  1 +
 arch/um/include/asm/Kbuild         |  3 ++-
 arch/unicore32/include/asm/Kbuild  |  1 +
 arch/x86/include/asm/simd.h        | 30 ++++++++++++++++++++-
 arch/xtensa/include/asm/Kbuild     |  1 +
 include/asm-generic/simd.h         | 15 +++++++++++
 include/linux/simd.h               | 28 ++++++++++++++++++++
 26 files changed, 180 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm/include/asm/simd.h
 create mode 100644 include/linux/simd.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 0580cb8c84b2..07b2c1025d34 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -2,14 +2,15 @@
 
 
 generic-y += compat.h
+generic-y += current.h
 generic-y += exec.h
 generic-y += export.h
 generic-y += fb.h
 generic-y += irq_work.h
+generic-y += kprobes.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += sections.h
+generic-y += simd.h
 generic-y += trace_clock.h
-generic-y += current.h
-generic-y += kprobes.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index feed50ce89fa..a7f4255f1649 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -22,6 +22,7 @@ generic-y += parport.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += preempt.h
+generic-y += simd.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += user.h
diff --git a/arch/arm/include/asm/simd.h b/arch/arm/include/asm/simd.h
new file mode 100644
index 000000000000..bf468993bbef
--- /dev/null
+++ b/arch/arm/include/asm/simd.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <linux/simd.h>
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
+
+static __must_check inline bool may_use_simd(void)
+{
+	return !in_interrupt();
+}
+
+#ifdef CONFIG_KERNEL_MODE_NEON
+#include <asm/neon.h>
+
+static inline simd_context_t simd_get(void)
+{
+	bool have_simd = may_use_simd();
+	if (have_simd)
+		kernel_neon_begin();
+	return have_simd ? HAVE_FULL_SIMD : HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t prior_context)
+{
+	if (prior_context != HAVE_NO_SIMD)
+		kernel_neon_end();
+}
+#else
+static inline simd_context_t simd_get(void)
+{
+	return HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t prior_context)
+{
+}
+#endif
+
+#endif /* _ASM_SIMD_H */
diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
index 6495cc51246f..058c336de38d 100644
--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -1,11 +1,10 @@
-/*
- * Copyright (C) 2017 Linaro Ltd. <ard.biesheuvel@linaro.org>
+/* SPDX-License-Identifier: GPL-2.0
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
+ * Copyright (C) 2017 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
+#include <linux/simd.h>
 #ifndef __ASM_SIMD_H
 #define __ASM_SIMD_H
 
@@ -16,6 +15,8 @@
 #include <linux/types.h>
 
 #ifdef CONFIG_KERNEL_MODE_NEON
+#include <asm/neon.h>
+#include <asm/simd.h>
 
 DECLARE_PER_CPU(bool, kernel_neon_busy);
 
@@ -40,12 +41,36 @@ static __must_check inline bool may_use_simd(void)
 		!this_cpu_read(kernel_neon_busy);
 }
 
+static inline simd_context_t simd_get(void)
+{
+	bool have_simd = may_use_simd();
+	if (have_simd)
+		kernel_neon_begin();
+	return have_simd ? HAVE_FULL_SIMD : HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t prior_context)
+{
+	if (prior_context != HAVE_NO_SIMD)
+		kernel_neon_end();
+}
+
 #else /* ! CONFIG_KERNEL_MODE_NEON */
 
-static __must_check inline bool may_use_simd(void) {
+static __must_check inline bool may_use_simd(void)
+{
 	return false;
 }
 
+static inline simd_context_t simd_get(void)
+{
+	return HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t prior_context)
+{
+}
+
 #endif /* ! CONFIG_KERNEL_MODE_NEON */
 
 #endif
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 33a2c94fed0d..22f3d8333c74 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -5,8 +5,8 @@ generic-y += compat.h
 generic-y += current.h
 generic-y += device.h
 generic-y += div64.h
-generic-y += dma.h
 generic-y += dma-mapping.h
+generic-y += dma.h
 generic-y += emergency-restart.h
 generic-y += exec.h
 generic-y += extable.h
@@ -30,6 +30,7 @@ generic-y += pgalloc.h
 generic-y += preempt.h
 generic-y += segment.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += tlbflush.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index a5d0b2991f47..f5c2f12d593e 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -8,8 +8,8 @@ generic-y += current.h
 generic-y += delay.h
 generic-y += device.h
 generic-y += div64.h
-generic-y += dma.h
 generic-y += dma-mapping.h
+generic-y += dma.h
 generic-y += emergency-restart.h
 generic-y += exec.h
 generic-y += extable.h
@@ -39,6 +39,7 @@ generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += sizes.h
 generic-y += spinlock.h
 generic-y += timex.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index dd2fd9c0d292..217d4695fd8a 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -29,6 +29,7 @@ generic-y += rwsem.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += sizes.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 557bbc8ba9f5..41c5ebdf79e5 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
 generic-y += preempt.h
+generic-y += simd.h
 generic-y += trace_clock.h
 generic-y += vtime.h
 generic-y += word-at-a-time.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index a4b8d3331a9e..73898dd1a4d0 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -19,6 +19,7 @@ generic-y += mm-arch-hooks.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += sections.h
+generic-y += simd.h
 generic-y += spinlock.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 569ba9e670c1..7a877eea99d3 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += parport.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += syscalls.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 58351e48421e..e8868e0fb2c3 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -16,6 +16,7 @@ generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += sections.h
 generic-y += segment.h
+generic-y += simd.h
 generic-y += trace_clock.h
 generic-y += unaligned.h
 generic-y += user.h
diff --git a/arch/nds32/include/asm/Kbuild b/arch/nds32/include/asm/Kbuild
index dbc4e5422550..603c1d020620 100644
--- a/arch/nds32/include/asm/Kbuild
+++ b/arch/nds32/include/asm/Kbuild
@@ -7,14 +7,14 @@ generic-y += bug.h
 generic-y += bugs.h
 generic-y += checksum.h
 generic-y += clkdev.h
-generic-y += cmpxchg.h
 generic-y += cmpxchg-local.h
+generic-y += cmpxchg.h
 generic-y += compat.h
 generic-y += cputime.h
 generic-y += device.h
 generic-y += div64.h
-generic-y += dma.h
 generic-y += dma-mapping.h
+generic-y += dma.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
@@ -46,14 +46,15 @@ generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
 generic-y += shmbuf.h
+generic-y += simd.h
 generic-y += sizes.h
 generic-y += stat.h
 generic-y += switch_to.h
 generic-y += timex.h
 generic-y += topology.h
 generic-y += trace_clock.h
-generic-y += xor.h
 generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
+generic-y += xor.h
diff --git a/arch/nios2/include/asm/Kbuild b/arch/nios2/include/asm/Kbuild
index 8fde4fa2c34f..571a9d9ad107 100644
--- a/arch/nios2/include/asm/Kbuild
+++ b/arch/nios2/include/asm/Kbuild
@@ -33,6 +33,7 @@ generic-y += preempt.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += spinlock.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index eb87cd8327c8..5e9f2f4c4d39 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -28,12 +28,13 @@ generic-y += module.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += preempt.h
-generic-y += qspinlock_types.h
-generic-y += qspinlock.h
-generic-y += qrwlock_types.h
 generic-y += qrwlock.h
+generic-y += qrwlock_types.h
+generic-y += qspinlock.h
+generic-y += qspinlock_types.h
 generic-y += sections.h
 generic-y += segment.h
+generic-y += simd.h
 generic-y += string.h
 generic-y += switch_to.h
 generic-y += topology.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 2013d639e735..97970b4d05ab 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -17,6 +17,7 @@ generic-y += percpu.h
 generic-y += preempt.h
 generic-y += seccomp.h
 generic-y += segment.h
+generic-y += simd.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += user.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 3196d227e351..64290f48e733 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -4,7 +4,8 @@ generic-y += irq_regs.h
 generic-y += irq_work.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += msi.h
 generic-y += preempt.h
 generic-y += rwsem.h
+generic-y += simd.h
 generic-y += vtime.h
-generic-y += msi.h
diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuild
index efdbe311e936..6669b7374c0a 100644
--- a/arch/riscv/include/asm/Kbuild
+++ b/arch/riscv/include/asm/Kbuild
@@ -5,9 +5,9 @@ generic-y += compat.h
 generic-y += cputime.h
 generic-y += device.h
 generic-y += div64.h
-generic-y += dma.h
 generic-y += dma-contiguous.h
 generic-y += dma-mapping.h
+generic-y += dma.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
@@ -46,6 +46,7 @@ generic-y += setup.h
 generic-y += shmbuf.h
 generic-y += shmparam.h
 generic-y += signal.h
+generic-y += simd.h
 generic-y += socket.h
 generic-y += sockios.h
 generic-y += stat.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index e3239772887a..7a26dc6ce815 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -7,9 +7,9 @@ generated-y += unistd_nr.h
 generic-y += asm-offsets.h
 generic-y += cacheflush.h
 generic-y += device.h
+generic-y += div64.h
 generic-y += dma-contiguous.h
 generic-y += dma-mapping.h
-generic-y += div64.h
 generic-y += emergency-restart.h
 generic-y += export.h
 generic-y += fb.h
@@ -22,6 +22,7 @@ generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += rwsem.h
+generic-y += simd.h
 generic-y += trace_clock.h
 generic-y += unaligned.h
 generic-y += word-at-a-time.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 6a5609a55965..8e64ff35a933 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -16,6 +16,7 @@ generic-y += percpu.h
 generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += sizes.h
 generic-y += trace_clock.h
 generic-y += xor.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 410b263ef5c8..72b9e08fb350 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -17,5 +17,6 @@ generic-y += msi.h
 generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index b10dde6cb793..d37288b08dd2 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -16,15 +16,16 @@ generic-y += io.h
 generic-y += irq_regs.h
 generic-y += irq_work.h
 generic-y += kdebug.h
+generic-y += kprobes.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
 generic-y += param.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += preempt.h
+generic-y += simd.h
 generic-y += switch_to.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
-generic-y += kprobes.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index bfc7abe77905..98a908720bbd 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -27,6 +27,7 @@ generic-y += preempt.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
+generic-y += simd.h
 generic-y += sizes.h
 generic-y += syscalls.h
 generic-y += topology.h
diff --git a/arch/x86/include/asm/simd.h b/arch/x86/include/asm/simd.h
index a341c878e977..79411178988a 100644
--- a/arch/x86/include/asm/simd.h
+++ b/arch/x86/include/asm/simd.h
@@ -1,4 +1,11 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <linux/simd.h>
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
 
 #include <asm/fpu/api.h>
 
@@ -10,3 +17,24 @@ static __must_check inline bool may_use_simd(void)
 {
 	return irq_fpu_usable();
 }
+
+static inline simd_context_t simd_get(void)
+{
+	bool have_simd = false;
+#if !defined(CONFIG_UML)
+	have_simd = may_use_simd();
+	if (have_simd)
+		kernel_fpu_begin();
+#endif
+	return have_simd ? HAVE_FULL_SIMD : HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t prior_context)
+{
+#if !defined(CONFIG_UML)
+	if (prior_context != HAVE_NO_SIMD)
+		kernel_fpu_end();
+#endif
+}
+
+#endif /* _ASM_SIMD_H */
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 82c756431b49..7950f359649d 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -24,6 +24,7 @@ generic-y += percpu.h
 generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += sections.h
+generic-y += simd.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
diff --git a/include/asm-generic/simd.h b/include/asm-generic/simd.h
index d0343d58a74a..fad899a5a92d 100644
--- a/include/asm-generic/simd.h
+++ b/include/asm-generic/simd.h
@@ -1,5 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#include <linux/simd.h>
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
+
 #include <linux/hardirq.h>
 
 /*
@@ -13,3 +17,14 @@ static __must_check inline bool may_use_simd(void)
 {
 	return !in_interrupt();
 }
+
+static inline simd_context_t simd_get(void)
+{
+	return HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t prior_context)
+{
+}
+
+#endif /* _ASM_SIMD_H */
diff --git a/include/linux/simd.h b/include/linux/simd.h
new file mode 100644
index 000000000000..f62d047188bf
--- /dev/null
+++ b/include/linux/simd.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#ifndef _SIMD_H
+#define _SIMD_H
+
+typedef enum {
+	HAVE_NO_SIMD,
+	HAVE_FULL_SIMD
+} simd_context_t;
+
+#include <linux/sched.h>
+#include <asm/simd.h>
+
+static inline simd_context_t simd_relax(simd_context_t prior_context)
+{
+#ifdef CONFIG_PREEMPT
+	if (prior_context != HAVE_NO_SIMD && need_resched()) {
+		simd_put(prior_context);
+		return simd_get();
+	}
+#endif
+	return prior_context;
+}
+
+#endif /* _SIMD_H */
-- 
2.19.0
