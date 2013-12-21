From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/3] crypto: crypto4xx_core: Remove redundant dev_set_drvdata
Date: Sat, 21 Dec 2013 12:52:28 +0530
Message-ID: <1387610550-13493-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, thomas.lendacky@amd.com,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54953 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3LUHZs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Dec 2013 02:25:48 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so3437799pdi.10
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2013 23:25:47 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Driver core sets it to NULL upon probe failure or release.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/amcc/crypto4xx_core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index efaf6302405f..37f9cc98ba17 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -724,7 +724,6 @@ static void crypto4xx_stop_all(struct crypto4xx_core_device *core_dev)
 	crypto4xx_destroy_pdr(core_dev->dev);
 	crypto4xx_destroy_gdr(core_dev->dev);
 	crypto4xx_destroy_sdr(core_dev->dev);
-	dev_set_drvdata(core_dev->device, NULL);
 	iounmap(core_dev->dev->ce_base);
 	kfree(core_dev->dev);
 	kfree(core_dev);
-- 
1.7.9.5
