From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v3 3/3] ARM: multi_v7_defconfig: Enable Exynos RNG and user-space crypto API
Date: Sat, 25 Mar 2017 19:26:54 +0300
Message-ID: <20170325162654.3827-4-krzk@kernel.org>
References: <20170325162654.3827-1-krzk@kernel.org>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbdCYQ2Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2017 12:28:16 -0400
In-Reply-To: <20170325162654.3827-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable the new Exynos pseudo random number generator driver and
user-space API to access crypto algorithms and devices (not only RNG).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm/configs/multi_v7_defconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 36c1b39cfb54..9bc1bd7f2afa 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -935,7 +935,13 @@ CONFIG_CPUFREQ_DT=y
 CONFIG_KEYSTONE_IRQ=y
 CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_ST=y
+CONFIG_CRYPTO_USER=m
+CONFIG_CRYPTO_USER_API_HASH=m
+CONFIG_CRYPTO_USER_API_SKCIPHER=m
+CONFIG_CRYPTO_USER_API_RNG=m
+CONFIG_CRYPTO_USER_API_AEAD=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
+CONFIG_CRYPTO_DEV_EXYNOS_RNG=m
 CONFIG_CRYPTO_DEV_S5P=m
 CONFIG_CRYPTO_DEV_SUN4I_SS=m
 CONFIG_CRYPTO_DEV_ROCKCHIP=m
-- 
2.9.3
