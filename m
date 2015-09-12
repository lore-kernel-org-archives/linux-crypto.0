From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 1/4] hwrng: mxc-rnga - Remove unneeded goto label
Date: Sat, 12 Sep 2015 20:19:50 -0300
Message-ID: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:35414 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbbILXUZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Sep 2015 19:20:25 -0400
Received: by ykdu9 with SMTP id u9so124138319ykd.2
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2015 16:20:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

We can simplify the code by returning the error code immediately
instead of jumping to a goto label.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/char/hw_random/mxc-rnga.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 6cbb72e..8803126 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -160,13 +160,12 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	mxc_rng->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(mxc_rng->clk)) {
 		dev_err(&pdev->dev, "Could not get rng_clk!\n");
-		err = PTR_ERR(mxc_rng->clk);
-		goto out;
+		return PTR_ERR(mxc_rng->clk);
 	}
 
 	err = clk_prepare_enable(mxc_rng->clk);
 	if (err)
-		goto out;
+		return err;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mxc_rng->mem = devm_ioremap_resource(&pdev->dev, res);
@@ -187,8 +186,6 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 
 err_ioremap:
 	clk_disable_unprepare(mxc_rng->clk);
-
-out:
 	return err;
 }
 
-- 
1.9.1
