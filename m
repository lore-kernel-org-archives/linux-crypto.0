From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 2/4] hwrng: omap - use devm_clk_get() instead of of_clk_get()
Date: Tue,  7 Mar 2017 15:14:47 +0100
Message-ID: <1488896089-17586-3-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org
To: Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58575 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752390AbdCGORb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2017 09:17:31 -0500
In-Reply-To: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The omap-rng driver currently uses of_clk_get() to get a reference to
the clock, but never releases that reference. This commit fixes that by
using devm_clk_get() instead.

Fixes: 383212425c926 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index efa3747..d286628 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -398,7 +398,7 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 			return err;
 		}
 
-		priv->clk = of_clk_get(pdev->dev.of_node, 0);
+		priv->clk = devm_clk_get(&pdev->dev, NULL);
 		if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 		if (!IS_ERR(priv->clk)) {
-- 
2.7.4
