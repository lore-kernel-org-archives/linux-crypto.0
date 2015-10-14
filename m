From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH] hwrng: stm32 - Fix build with CONFIG_PM
Date: Wed, 14 Oct 2015 17:04:55 +0100
Message-ID: <1444838695-7182-1-git-send-email-daniel.thompson@linaro.org>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, linaro-kernel@lists.linaro.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35728 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbbJNQFL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 12:05:11 -0400
Received: by wicll6 with SMTP id ll6so4169770wic.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2015 09:05:10 -0700 (PDT)
In-Reply-To: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
was inadequately tested (actually it was tested quite hard so
incompetent would be a better description that inadequate) and does
not compile on platforms with CONFIG_PM set.

Fix this.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    Herbert: This is the diff between v2 and v3 of my STM32 HW RNG
             patch. This is partly reassurance of what has changed
             and also "just in case" you prefer to simply fix the
    	 problem.

 drivers/char/hw_random/stm32-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 7fa3656a5fc5..92a810648bd0 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -160,7 +160,7 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 #ifdef CONFIG_PM
 static int stm32_rng_runtime_suspend(struct device *dev)
 {
-	struct stm32_rng_private *priv = dev_get_drvdata(pdev);
+	struct stm32_rng_private *priv = dev_get_drvdata(dev);

 	stm32_rng_cleanup(&priv->rng);

@@ -169,7 +169,7 @@ static int stm32_rng_runtime_suspend(struct device *dev)

 static int stm32_rng_runtime_resume(struct device *dev)
 {
-	struct stm32_rng_private *priv = dev_get_drvdata(pdev);
+	struct stm32_rng_private *priv = dev_get_drvdata(dev);

 	return stm32_rng_init(&priv->rng);
 }
--
2.4.3
