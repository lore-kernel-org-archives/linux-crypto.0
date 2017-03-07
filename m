From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 4/4] hwrng: omap - move clock related code to omap_rng_probe()
Date: Tue,  7 Mar 2017 15:14:49 +0100
Message-ID: <1488896089-17586-5-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58592 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755144AbdCGOQa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2017 09:16:30 -0500
In-Reply-To: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, the code that takes a reference to the clock and enables it
is located inside of_get_omap_rng_device_details(), called only when
probing through the Device Tree.

However, there is nothing that makes this clock logic dependent on the
Device Tree, so it makes more sense to have it in omap_rng_probe()
directly.

Moreover, we make sure to bail out if we can't enable the clock. Indeed,
while the clock is optional, if a clock is present, we really want to
succeed in enabling it. And we fix the error message to fit on one line,
so that it is grep-friendly.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index b1ad125..74d11ae 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -398,16 +398,6 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 			return err;
 		}
 
-		priv->clk = devm_clk_get(&pdev->dev, NULL);
-		if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		if (!IS_ERR(priv->clk)) {
-			err = clk_prepare_enable(priv->clk);
-			if (err)
-				dev_err(&pdev->dev, "unable to enable the clk, "
-						    "err = %d\n", err);
-		}
-
 		/*
 		 * On OMAP4, enabling the shutdown_oflo interrupt is
 		 * done in the interrupt mask register. There is no
@@ -478,6 +468,18 @@ static int omap_rng_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+	if (!IS_ERR(priv->clk)) {
+		ret = clk_prepare_enable(priv->clk);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Unable to enable the clk: %d\n", ret);
+			goto err_register;
+		}
+	}
+
 	ret = (dev->of_node) ? of_get_omap_rng_device_details(priv, pdev) :
 				get_omap_rng_device_details(priv);
 	if (ret)
-- 
2.7.4
