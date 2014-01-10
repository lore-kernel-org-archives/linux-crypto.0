From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 0/8 v3] crypto:s5p-sss: Add DT and Exynos support
Date: Fri, 10 Jan 2014 17:11:15 +0530
Message-ID: <1389354075-31636-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44085 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJLk7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jan 2014 06:40:59 -0500
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
features to the one on S5PV210. However minor changes to the s5p-sss.c
driver are required to support SSS modules on Exynos4 and 5 SoCs.

This patch set
1. Adds device tree support to the s5p-sss.c driver and Documentation
2. Adds code to support SSS module on Exynos4 and 5 SoCs
3. Adds device tree node to Exynos5250 and Exynos5420
4. Adds variant struct to handle the differences in SSS modules
5. Adds clk_prepare/clk_unprepare clocks to the s5p-sss.c driver

Note: Compatible "exynos4210-secss" should work for Exynos4412 and
      Exynos5260 (Exynos5260, for which ARCH code is under review)
I couldn't test on Exynos4412 and Exynos4210 boards, Should be able to
test with addition of DT node and clocks support.

Naveen Krishna Ch (6): [crypto-2.6.git]
  crypto:s5p-sss: Use platform_get_irq() instead of _byname()
  crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
  crypto:s5p-sss: Add device tree support
  crypto:s5p-sss: Add support for SSS module on Exynos
  crypto:s5p-sss: validate iv before memcpy
  crypto:s5p-sss: Use clk_prepare/clk_unprepare

Naveen Krishna Chatradhi (2): [linuxsamsung.git]
  clk:exynos5250: Add gate clock for SSS module
  ARM: dts: exynos5250/5420: add dt node for sss module

 .../devicetree/bindings/crypto/samsung-sss.txt     |   40 ++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    8 ++
 arch/arm/boot/dts/exynos5420.dtsi                  |   10 ++
 drivers/clk/samsung/clk-exynos5250.c               |    3 +-
 drivers/crypto/Kconfig                             |    8 +-
 drivers/crypto/s5p-sss.c                           |  131 +++++++++++++++-----
 6 files changed, 165 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

-- 
1.7.9.5
