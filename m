From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/4] crypto: dcp: Remove redundant platform_set_drvdata()
Date: Wed, 29 May 2013 17:09:09 +0530
Message-ID: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, tobias.rauter@gmail.com,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38550 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418Ab3E2LxL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 May 2013 07:53:11 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so85711pad.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 May 2013 04:53:11 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Tobias Rauter <tobias.rauter@gmail.com>
---
This series compile tested against linux-next (20130529).
---
 drivers/crypto/dcp.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index eea194c..83eaefc 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -876,7 +876,6 @@ static int dcp_remove(struct platform_device *pdev)
 	struct dcp_dev *dev;
 	int j;
 	dev = platform_get_drvdata(pdev);
-	platform_set_drvdata(pdev, NULL);
 
 	dma_free_coherent(&pdev->dev,
 			DCP_MAX_PKG * sizeof(struct dcp_hw_packet),
-- 
1.7.9.5
