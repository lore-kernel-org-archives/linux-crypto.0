From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: caam - Remove unneeded 'ret' variable
Date: Wed, 12 Aug 2015 14:39:38 -0300
Message-ID: <1439401178-3583-1-git-send-email-festevam@gmail.com>
Cc: horia.geanta@freescale.com, vicki.milhoan@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:34426 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbHLRj6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2015 13:39:58 -0400
Received: by ykdt205 with SMTP id t205so20380264ykd.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2015 10:39:58 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Variable 'ret' is only used for returning the value 0.

We can make it simpler and just return 0 instead.

The semantic patch that makes this change is available
in scripts/coccinelle/misc/returnvar.cocci.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 37c2d8d..4f174ee 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -298,7 +298,7 @@ static int caam_remove(struct platform_device *pdev)
 	struct device *ctrldev;
 	struct caam_drv_private *ctrlpriv;
 	struct caam_ctrl __iomem *ctrl;
-	int ring, ret = 0;
+	int ring;
 
 	ctrldev = &pdev->dev;
 	ctrlpriv = dev_get_drvdata(ctrldev);
@@ -328,7 +328,7 @@ static int caam_remove(struct platform_device *pdev)
 	clk_disable_unprepare(ctrlpriv->caam_aclk);
 	clk_disable_unprepare(ctrlpriv->caam_emi_slow);
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.9.1
