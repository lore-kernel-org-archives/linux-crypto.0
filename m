From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v2 0/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 21:26:03 +0300
Message-ID: <20170324182606.23339-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,


This is a follow up of my questions around exynos-rng [1].

Changes since v1:
=================
1. Re-work the code for seeding after system resume, following suggestions
   and review by Stephan Müller.
   The resume path was not tested.

2. Re-seed itself from time to time (every 100 ms), suggested by Stephan
   Müller.

3. Use a define for retries (Bartlomiej Zolnierkiewicz).
4. Add some docs.


Description:
============
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
 drivers/char/hw_random/exynos-rng.c | 231 ---------------------
 drivers/crypto/Kconfig              |  15 ++
 drivers/crypto/Makefile             |   1 +
 drivers/crypto/exynos-rng.c         | 392 ++++++++++++++++++++++++++++++++++++
 9 files changed, 428 insertions(+), 246 deletions(-)
 delete mode 100644 drivers/char/hw_random/exynos-rng.c
 create mode 100644 drivers/crypto/exynos-rng.c

-- 
2.9.3
