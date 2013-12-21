From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 3/3] crypto: talitos: Remove redundant dev_set_drvdata
Date: Sat, 21 Dec 2013 12:52:30 +0530
Message-ID: <1387610550-13493-3-git-send-email-sachin.kamat@linaro.org>
References: <1387610550-13493-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, thomas.lendacky@amd.com,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64285 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3LUHZx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Dec 2013 02:25:53 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so3542052pbc.10
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2013 23:25:52 -0800 (PST)
In-Reply-To: <1387610550-13493-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Driver core sets it to NULL upon probe failure or release.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/talitos.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a3d2e9b88c41..5967667e1a8f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2495,8 +2495,6 @@ static int talitos_remove(struct platform_device *ofdev)
 
 	iounmap(priv->reg);
 
-	dev_set_drvdata(dev, NULL);
-
 	kfree(priv);
 
 	return 0;
-- 
1.7.9.5
