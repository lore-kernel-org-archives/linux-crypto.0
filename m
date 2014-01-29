From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 4/9 v5] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Wed, 29 Jan 2014 14:52:34 +0530
Message-ID: <1390987354-18665-1-git-send-email-ch.naveen@samsung.com>
References: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, devicetree@vger.kernel.org,
	Naveen Krishna Ch <ch.naveen@samsung.com>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:16121 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaA2JWl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jan 2014 04:22:41 -0500
In-reply-to: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Naveen Krishna Ch <ch.naveen@samsung.com>

This patch modifies Kconfig such that ARCH_EXYNOS SoCs
which includes (Exynos4210, Exynos5250 and Exynos5420)
can also select Samsung SSS(Security SubSystem) driver.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v4:
none
Changes since v3:
Modified description to use "Exynos" instead of individual SoC name
 drivers/crypto/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f4fd837..cb38863 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -300,14 +300,14 @@ config CRYPTO_DEV_DCP
 	  capabilities of the DCP co-processor
 
 config CRYPTO_DEV_S5P
-	tristate "Support for Samsung S5PV210 crypto accelerator"
-	depends on ARCH_S5PV210
+	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
+	depends on ARCH_S5PV210 || ARCH_EXYNOS
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
-	  Select this to offload Samsung S5PV210 or S5PC110 from AES
+	  Select this to offload Samsung S5PV210 or S5PC110, Exynos from AES
 	  algorithms execution.
 
 config CRYPTO_DEV_TEGRA_AES
-- 
1.7.9.5
