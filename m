From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH 0/3] True RNG driver for Samsung Exynos 5250+ SoCs
Date: Thu, 23 Nov 2017 16:09:11 +0100
Message-ID: <20171123150914.31462-1-l.stelmach@samsung.com>
References: <CGME20171123150956eucas1p2e6d42c88692291e4e0d0e7719519bf35@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To: Rob Herring <robh+dt@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58892 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbdKWPKA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 10:10:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello.

The following patches add support for the true random number generator
found in Samsung Exynos 5250+ SoCs.

Patch #1 adds documentation for devicetree bindings.

Patch #2 introduces the driver and appropriate changes in Makefile and Kconfig.

Patch #3 adds nodes in devicetree files for Exynos SoCs.

Łukasz Stelmach (3):
  dt-bindings: hwrng: Add Samsung Exynos 5250+ True RNG bindings
  hwrng: exynos - add Samsung Exynos True RNG driver
  ARM: dts: exynos: Add nodes for True Random Number Generator

 .../bindings/rng/samsung,exynos5250-trng.txt       |  17 ++
 MAINTAINERS                                        |   7 +
 arch/arm/boot/dts/exynos5.dtsi                     |   5 +
 arch/arm/boot/dts/exynos5250.dtsi                  |   5 +
 arch/arm/boot/dts/exynos5410.dtsi                  |   5 +
 arch/arm/boot/dts/exynos5420.dtsi                  |   5 +
 drivers/char/hw_random/Kconfig                     |  12 +
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/exynos-trng.c               | 256 +++++++++++++++++++++
 9 files changed, 313 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
 create mode 100644 drivers/char/hw_random/exynos-trng.c

-- 
2.11.0
