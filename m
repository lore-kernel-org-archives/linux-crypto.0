Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47494 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbeKGTJ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 14:09:56 -0500
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: yamada.masahiro@socionext.com, linux-crypto@vger.kernel.org,
        linux-kbuild@vger.kernel.org, kbuild-all@01.org,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 3/4] arm64: turn "broken gas inst" into real config option
Date: Wed,  7 Nov 2018 09:40:07 +0000
Message-Id: <1541583608-26375-4-git-send-email-vladimir.murzin@arm.com>
In-Reply-To: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
References: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So it is available everywhere and there is no need to keep
CONFIG_ARM64 workaround ;)

Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/Kconfig  | 3 +++
 arch/arm64/Makefile | 9 ++-------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7978aee..86fc357 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -287,6 +287,9 @@ config ARCH_SUPPORTS_UPROBES
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
 
+config BROKEN_GAS_INST
+	def_bool y if !$(as-instr,1:\n.inst 0\n.rept . - 1b\n\nnop\n.endr\n)
+
 source "arch/arm64/Kconfig.platforms"
 
 menu "Bus support"
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 3054757..9860d3a 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -32,17 +32,12 @@ endif
 
 KBUILD_DEFCONFIG := defconfig
 
-ifeq ($(CONFIG_ARM64), y)
-brokengasinst := $(call as-instr,1:\n.inst 0\n.rept . - 1b\n\nnop\n.endr\n,,-DCONFIG_BROKEN_GAS_INST=1)
-
-  ifneq ($(brokengasinst),)
+ifeq ($(CONFIG_BROKEN_GAS_INST),y)
 $(warning Detected assembler with broken .inst; disassembly will be unreliable)
-  endif
 endif
 
-KBUILD_CFLAGS	+= -mgeneral-regs-only $(brokengasinst)
+KBUILD_CFLAGS	+= -mgeneral-regs-only
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
-KBUILD_AFLAGS	+= $(brokengasinst)
 
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
 KBUILD_AFLAGS	+= $(call cc-option,-mabi=lp64)
-- 
1.9.1
