Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1748BC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 20:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C11A723A7C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 20:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404537AbgLJUEL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:04:11 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46520 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404556AbgLJUED (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 15:04:03 -0500
Received: by mail-ot1-f65.google.com with SMTP id w3so6090937otp.13;
        Thu, 10 Dec 2020 12:03:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yMZLlSq3lxvwuPHVX5TX4Re3z8tBFVB0mWh2Fx0zmtc=;
        b=XfltBRC4SFlhX4I+/9D9VQgA/qvYkni3CDkPGn0rjPjgR2efJC6w+knFsSblGFI61m
         Iobb4Wf0PcJNARK48YgiT9M4VnH9oySkBoi4WcRQv+f1g5QSykTcn60Yymcvf+Brxf7M
         gUswr8dlxGfxB1/MfbqXeqIbmWKMdhuF8LDdqG9wAw+GjaukCMjAFppnaiZgVn2sY43p
         U8FIFRmFqu70iEJrAkh0r8pjGhYlpvCy6oQ+tdqB986YSOWc3NzTmYJr6Pt/FUBWk7Mc
         LP00/S+Pv4Twas1jpOk+tkjm9AEco9T4exM9ipavaCrqA6WULhqsI8P3+b+eOa25sr1s
         J4Sw==
X-Gm-Message-State: AOAM532UaYNYhh8Wjkl2/iDRXwsuuSnA09T4g2h7PfUuu8Rpi2gTkvWf
        tpGqAd/Rhji78B4fqojrlaymCkwFGg==
X-Google-Smtp-Source: ABdhPJzlqBNeD22WHSE6CjWpP84aHB+xxtAgCBG7Ge75WUiIM6OmvPlMnMo3GFn3sC+vLh2YTJRsMQ==
X-Received: by 2002:a9d:2de9:: with SMTP id g96mr7098507otb.209.1607630601240;
        Thu, 10 Dec 2020 12:03:21 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id o82sm1220636oih.5.2020.12.10.12.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 12:03:20 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
List-Id: <soc.lore.kernel.org>
To:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 2/4] ARM: Remove PicoXcell platform support
Date:   Thu, 10 Dec 2020 14:03:13 -0600
Message-Id: <20201210200315.2965567-3-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201210200315.2965567-1-robh@kernel.org>
References: <20201210200315.2965567-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PicoXcell has had nothing but treewide cleanups for at least the last 8
years and no signs of activity. The most recent activity is a yocto vendor
kernel based on v3.0 in 2015.

Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 MAINTAINERS                      |  9 ----
 arch/arm/Kconfig                 |  2 -
 arch/arm/Kconfig.debug           | 13 +----
 arch/arm/Makefile                |  1 -
 arch/arm/mach-picoxcell/Kconfig  |  9 ----
 arch/arm/mach-picoxcell/Makefile |  2 -
 arch/arm/mach-picoxcell/common.c | 81 --------------------------------
 7 files changed, 1 insertion(+), 116 deletions(-)
 delete mode 100644 arch/arm/mach-picoxcell/Kconfig
 delete mode 100644 arch/arm/mach-picoxcell/Makefile
 delete mode 100644 arch/arm/mach-picoxcell/common.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b516bb34a8d5..48a971f61d77 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13760,15 +13760,6 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/hid/hid-picolcd*
 
-PICOXCELL SUPPORT
-M:	Jamie Iles <jamie@jamieiles.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Supported
-T:	git git://github.com/jamieiles/linux-2.6-ji.git
-F:	arch/arm/boot/dts/picoxcell*
-F:	arch/arm/mach-picoxcell/
-F:	drivers/crypto/picoxcell*
-
 PIDFD API
 M:	Christian Brauner <christian@brauner.io>
 L:	linux-kernel@vger.kernel.org
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fe2f17eb2b50..e59d9bee6cd4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -693,8 +693,6 @@ source "arch/arm/mach-orion5x/Kconfig"
 
 source "arch/arm/mach-oxnas/Kconfig"
 
-source "arch/arm/mach-picoxcell/Kconfig"
-
 source "arch/arm/mach-prima2/Kconfig"
 
 source "arch/arm/mach-pxa/Kconfig"
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8986a91a6f31..10a6b5d1f380 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -770,14 +770,6 @@ choice
 		depends on ARCH_OMAP2PLUS
 		select DEBUG_OMAP2PLUS_UART
 
-	config DEBUG_PICOXCELL_UART
-		depends on ARCH_PICOXCELL
-		bool "Use PicoXcell UART for low-level debug"
-		select DEBUG_UART_8250
-		help
-		  Say Y here if you want kernel low-level debugging support
-		  on PicoXcell based platforms.
-
 	config DEBUG_PXA_UART1
 		depends on ARCH_PXA
 		bool "Use PXA UART1 for low-level debug"
@@ -1717,7 +1709,6 @@ config DEBUG_UART_PHYS
 	default 0x80010000 if DEBUG_ASM9260_UART
 	default 0x80070000 if DEBUG_IMX23_UART
 	default 0x80074000 if DEBUG_IMX28_UART
-	default 0x80230000 if DEBUG_PICOXCELL_UART
 	default 0x808c0000 if DEBUG_EP93XX || ARCH_EP93XX
 	default 0x90020000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 	default 0xb0060000 if DEBUG_SIRFPRIMA2_UART1
@@ -1852,7 +1843,6 @@ config DEBUG_UART_VIRT
 	default 0xfe017000 if DEBUG_MMP_UART2
 	default 0xfe018000 if DEBUG_MMP_UART3
 	default 0xfe100000 if DEBUG_IMX23_UART || DEBUG_IMX28_UART
-	default 0xfe230000 if DEBUG_PICOXCELL_UART
 	default 0xfe300000 if DEBUG_BCM_KONA_UART
 	default 0xfe800000 if ARCH_IOP32X
 	default 0xfeb00000 if DEBUG_HI3620_UART || DEBUG_HIX5HD2_UART
@@ -1907,8 +1897,7 @@ config DEBUG_UART_8250_WORD
 	bool "Use 32-bit accesses for 8250 UART"
 	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
 	depends on DEBUG_UART_8250_SHIFT >= 2
-	default y if DEBUG_PICOXCELL_UART || \
-		DEBUG_SOCFPGA_UART0 || DEBUG_SOCFPGA_ARRIA10_UART1 || \
+	default y if DEBUG_SOCFPGA_UART0 || DEBUG_SOCFPGA_ARRIA10_UART1 || \
 		DEBUG_SOCFPGA_CYCLONE5_UART1 || DEBUG_KEYSTONE_UART0 || \
 		DEBUG_KEYSTONE_UART1 || DEBUG_ALPINE_UART0 || \
 		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 4d76eab2b22d..81142fb677cd 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -204,7 +204,6 @@ machine-$(CONFIG_ARCH_OXNAS)		+= oxnas
 machine-$(CONFIG_ARCH_OMAP1)		+= omap1
 machine-$(CONFIG_ARCH_OMAP2PLUS)	+= omap2
 machine-$(CONFIG_ARCH_ORION5X)		+= orion5x
-machine-$(CONFIG_ARCH_PICOXCELL)	+= picoxcell
 machine-$(CONFIG_ARCH_PXA)		+= pxa
 machine-$(CONFIG_ARCH_QCOM)		+= qcom
 machine-$(CONFIG_ARCH_RDA)		+= rda
diff --git a/arch/arm/mach-picoxcell/Kconfig b/arch/arm/mach-picoxcell/Kconfig
deleted file mode 100644
index b8eba18c0265..000000000000
--- a/arch/arm/mach-picoxcell/Kconfig
+++ /dev/null
@@ -1,9 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-config ARCH_PICOXCELL
-	bool "Picochip PicoXcell"
-	depends on ARCH_MULTI_V6
-	select ARM_VIC
-	select DW_APB_TIMER_OF
-	select GPIOLIB
-	select HAVE_TCM
-	select NO_IOPORT_MAP
diff --git a/arch/arm/mach-picoxcell/Makefile b/arch/arm/mach-picoxcell/Makefile
deleted file mode 100644
index aef03938005c..000000000000
--- a/arch/arm/mach-picoxcell/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-obj-y	:= common.o
diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
deleted file mode 100644
index 8e738266a66a..000000000000
--- a/arch/arm/mach-picoxcell/common.c
+++ /dev/null
@@ -1,81 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (c) 2011 Picochip Ltd., Jamie Iles
- *
- * All enquiries to support@picochip.com
- */
-#include <linux/delay.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/reboot.h>
-
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-
-#define PHYS_TO_IO(x)			(((x) & 0x00ffffff) | 0xfe000000)
-#define PICOXCELL_PERIPH_BASE		0x80000000
-#define PICOXCELL_PERIPH_LENGTH		SZ_4M
-
-#define WDT_CTRL_REG_EN_MASK		(1 << 0)
-#define WDT_CTRL_REG_OFFS		(0x00)
-#define WDT_TIMEOUT_REG_OFFS		(0x04)
-static void __iomem *wdt_regs;
-
-/*
- * The machine restart method can be called from an atomic context so we won't
- * be able to ioremap the regs then.
- */
-static void picoxcell_setup_restart(void)
-{
-	struct device_node *np = of_find_compatible_node(NULL, NULL,
-							 "snps,dw-apb-wdg");
-	if (WARN(!np, "unable to setup watchdog restart"))
-		return;
-
-	wdt_regs = of_iomap(np, 0);
-	WARN(!wdt_regs, "failed to remap watchdog regs");
-}
-
-static struct map_desc io_map __initdata = {
-	.virtual	= PHYS_TO_IO(PICOXCELL_PERIPH_BASE),
-	.pfn		= __phys_to_pfn(PICOXCELL_PERIPH_BASE),
-	.length		= PICOXCELL_PERIPH_LENGTH,
-	.type		= MT_DEVICE,
-};
-
-static void __init picoxcell_map_io(void)
-{
-	iotable_init(&io_map, 1);
-}
-
-static void __init picoxcell_init_machine(void)
-{
-	picoxcell_setup_restart();
-}
-
-static const char *picoxcell_dt_match[] = {
-	"picochip,pc3x2",
-	"picochip,pc3x3",
-	NULL
-};
-
-static void picoxcell_wdt_restart(enum reboot_mode mode, const char *cmd)
-{
-	/*
-	 * Configure the watchdog to reset with the shortest possible timeout
-	 * and give it chance to do the reset.
-	 */
-	if (wdt_regs) {
-		writel_relaxed(WDT_CTRL_REG_EN_MASK, wdt_regs + WDT_CTRL_REG_OFFS);
-		writel_relaxed(0, wdt_regs + WDT_TIMEOUT_REG_OFFS);
-		/* No sleeping, possibly atomic. */
-		mdelay(500);
-	}
-}
-
-DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
-	.map_io		= picoxcell_map_io,
-	.init_machine	= picoxcell_init_machine,
-	.dt_compat	= picoxcell_dt_match,
-	.restart	= picoxcell_wdt_restart,
-MACHINE_END
-- 
2.25.1

