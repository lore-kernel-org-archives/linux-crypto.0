From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/39] crypto: ux500/cryp - Prepare clock before enabling it
Date: Wed, 15 May 2013 10:51:38 +0100
Message-ID: <1368611522-9984-16-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If we fail to prepare the ux500-cryp clock before enabling it the
platform will fail to boot. Here we insure this happens.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 32f4806..ccdf173 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1458,11 +1458,17 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_regulator;
 	}
 
+	ret = clk_prepare(device_data->clk);
+	if (ret) {
+		dev_err(dev, "[%s]: clk_prepare() failed!", __func__);
+		goto out_clk;
+	}
+
 	/* Enable device power (and clock) */
 	ret = cryp_enable_power(device_data->dev, device_data, false);
 	if (ret) {
 		dev_err(dev, "[%s]: cryp_enable_power() failed!", __func__);
-		goto out_clk;
+		goto out_clk_unprepare;
 	}
 
 	cryp_error = cryp_check(device_data);
@@ -1523,6 +1529,9 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 out_power:
 	cryp_disable_power(device_data->dev, device_data, false);
 
+out_clk_unprepare:
+	clk_unprepare(device_data->clk);
+
 out_clk:
 	clk_put(device_data->clk);
 
@@ -1593,6 +1602,7 @@ static int ux500_cryp_remove(struct platform_device *pdev)
 		dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
 			__func__);
 
+	clk_unprepare(device_data->clk);
 	clk_put(device_data->clk);
 	regulator_put(device_data->pwr_regulator);
 
-- 
1.7.10.4
