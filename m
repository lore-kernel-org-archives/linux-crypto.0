From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/2] crypto: s5p-sss: Remove redundant platform_set_drvdata()
Date: Fri,  3 May 2013 14:48:15 +0530
Message-ID: <1367572695-10713-2-git-send-email-sachin.kamat@linaro.org>
References: <1367572695-10713-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	sachin.kamat@linaro.org, patches@linaro.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57098 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3ECJbQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 May 2013 05:31:16 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so835006pab.20
        for <linux-crypto@vger.kernel.org>; Fri, 03 May 2013 02:31:15 -0700 (PDT)
In-Reply-To: <1367572695-10713-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
---
 drivers/crypto/s5p-sss.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 4b31432..cf149b1 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -647,7 +647,6 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	clk_disable(pdata->clk);
 
 	s5p_dev = NULL;
-	platform_set_drvdata(pdev, NULL);
 
 	return err;
 }
@@ -668,7 +667,6 @@ static int s5p_aes_remove(struct platform_device *pdev)
 	clk_disable(pdata->clk);
 
 	s5p_dev = NULL;
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.9.5
