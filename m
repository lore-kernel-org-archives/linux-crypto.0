From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH 33/45] arch/arm: remove duplicate includes
Date: Sat, 16 Dec 2017 17:13:02 +0530
Message-ID: <1513424582-6239-1-git-send-email-pravin.shedge4linux@gmail.com>
Cc: pravin.shedge4linux@gmail.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux@armlinux.org.uk, sstabellini@kernel.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38090 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdLPLnN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Dec 2017 06:43:13 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 arch/arm/crypto/aes-ce-glue.c        | 1 -
 arch/arm/mach-sa1100/hackkit.c       | 1 -
 arch/arm/mm/mmu.c                    | 2 --
 arch/arm/xen/mm.c                    | 1 -
 arch/arm64/kernel/armv8_deprecated.c | 1 -
 arch/arm64/kernel/fpsimd.c           | 1 -
 6 files changed, 7 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index d0a9cec..5affb84 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,7 +10,6 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
-#include <asm/hwcap.h>
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
diff --git a/arch/arm/mach-sa1100/hackkit.c b/arch/arm/mach-sa1100/hackkit.c
index 643d5f2..0016d25 100644
--- a/arch/arm/mach-sa1100/hackkit.c
+++ b/arch/arm/mach-sa1100/hackkit.c
@@ -22,7 +22,6 @@
 #include <linux/serial_core.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
-#include <linux/tty.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/platform_device.h>
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e46a6a4..56d265e 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -23,7 +23,6 @@
 #include <asm/sections.h>
 #include <asm/cachetype.h>
 #include <asm/fixmap.h>
-#include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp_plat.h>
 #include <asm/tlb.h>
@@ -36,7 +35,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/pci.h>
-#include <asm/fixmap.h>
 
 #include "fault.h"
 #include "mm.h"
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index 785d2a5..8ba803b 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -8,7 +8,6 @@
 #include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/swiotlb.h>
 
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index c33b5e4..6c25b8a 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -21,7 +21,6 @@
 #include <asm/traps.h>
 #include <asm/kprobes.h>
 #include <linux/uaccess.h>
-#include <asm/cpufeature.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace-events-emulation.h"
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5084e69..2f822dc2 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -31,7 +31,6 @@
 #include <linux/percpu.h>
 #include <linux/prctl.h>
 #include <linux/preempt.h>
-#include <linux/prctl.h>
 #include <linux/ptrace.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
-- 
2.7.4
