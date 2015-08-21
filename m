From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 2/4] crypto: caam: ctrl: Propagate the real error code
Date: Fri, 21 Aug 2015 11:49:28 -0300
Message-ID: <1440168570-13635-2-git-send-email-festevam@gmail.com>
References: <1440168570-13635-1-git-send-email-festevam@gmail.com>
Cc: vicki.milhoan@freescale.com, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34770 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbbHUOuB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 10:50:01 -0400
Received: by ykdt205 with SMTP id t205so72728235ykd.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2015 07:50:00 -0700 (PDT)
In-Reply-To: <1440168570-13635-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Instead of propagating a 'fake' error code, just propagate the real
one in the case of caam_drv_identify_clk() failure.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 9c5ca46..1153417 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -440,7 +440,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret = PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM ipg clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_ipg = clk;
 
@@ -449,7 +449,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret = PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM mem clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_mem = clk;
 
@@ -458,7 +458,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret = PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM aclk clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_aclk = clk;
 
@@ -467,7 +467,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret = PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM emi_slow clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_emi_slow = clk;
 
-- 
1.9.1
