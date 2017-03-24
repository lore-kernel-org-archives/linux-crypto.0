From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 0/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 17:24:43 +0300
Message-ID: <20170324142446.31129-1-krzk@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934155AbdCXOZc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:25:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This is a follow up of my questions around exynos-rng [1].

The existing exynos-rng has many issues.  The most important one is that
it is a pseudo RNG device but uses hw_random interface which does not allow
proper seeding.

The RNG module on Exynos4 requires seeding.  On newer SoCs (like Exynos5420)
it can seed itself from a true RNG.  Converting the existing driver
to use TRNG would effectively drop support for Exynos4 and break
compatibility with existing users.

Instead I decided to convert it to crypto API.  In the future I hope
to add support for seeding from TRNG module.

Tested with app [2].

Patches are independent. I will take the defconfig changes (2/3 and 3/3)
through samsung-soc tree.

Best regards,
Krzysztof

[1] https://www.spinics.net/lists/arm-kernel/msg569641.html
[2] https://www.spinics.net/lists/arm-kernel/msg571184.html

Krzysztof Kozlowski (3):
  crypto: hw_random - Add new Exynos RNG driver
  ARM: exynos_defconfig: Enable Exynos RNG and user-space crypto API
  ARM: multi_v7_defconfig: Enable Exynos RNG and user-space crypto API

 MAINTAINERS                         |   8 +
 arch/arm/configs/exynos_defconfig   |   6 +
 arch/arm/configs/multi_v7_defconfig |   6 +
 drivers/char/hw_random/Kconfig      |  14 --
 drivers/char/hw_random/Makefile     |   1 -
 drivers/char/hw_random/exynos-rng.c | 231 ---------------------------
 drivers/crypto/Kconfig              |  15 ++
 drivers/crypto/Makefile             |   1 +
 drivers/crypto/exynos-rng.c         | 306 ++++++++++++++++++++++++++++++++++++
 9 files changed, 342 insertions(+), 246 deletions(-)
 delete mode 100644 drivers/char/hw_random/exynos-rng.c
 create mode 100644 drivers/crypto/exynos-rng.c

-- 
2.9.3
