From: Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 0/5] crypto:s5p-sss: Add DT and Exynos5 support
Date: Tue, 07 Jan 2014 17:21:44 +0530
Message-ID: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SSS module on Exynos5 SoCs has added features to the one on S5PV210
However minor changes to the s5p-sss.c driver are required to support
SSS modules on Exynos5 SoCs.

This patch set
1. Adds device tree support to the s5p-sss.c driver
2. Adds code to support SSS module on Exynos5 SoCs
3. Adds device tree node to Exynos5420
4. Also adds the DT binding documentation

Naveen Krishna Ch (4): [crypto-2.6.git]
  crypto:s5p-sss: Use platform_get_irq() instead of _byname()
  crypto:s5p-sss: Add device tree and Exynos5 support
  crypto:s5p-sss: Add support for SSS module on Exynos5
  crypto:s5p-sss: Exynos5 SoCs too can select SSS driver

Naveen Krishna Chatradhi (1): [linuxsamsung.git]
  ARM: exynos5420: add dt node for sss module

 .../devicetree/bindings/crypto/samsung-sss.txt     |   24 ++++
 arch/arm/boot/dts/exynos5420.dtsi                  |   10 ++
 drivers/crypto/Kconfig                             |    8 +-
 drivers/crypto/s5p-sss.c                           |  115 +++++++++++++++-----
 4 files changed, 127 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

-- 
1.7.9.5
