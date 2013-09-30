From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/2] crypto: sahara: Remove redundant of_match_ptr
Date: Mon, 30 Sep 2013 08:49:41 +0530
Message-ID: <1380511182-18424-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, sachin.kamat@linaro.org,
	Javier Martin <javier.martin@vista-silicon.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41848 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3I3DTz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Sep 2013 23:19:55 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz1so5215338pad.30
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2013 20:19:54 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/crypto/sahara.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index d7bb8ba..785a9de 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1058,7 +1058,7 @@ static struct platform_driver sahara_driver = {
 	.driver		= {
 		.name	= SAHARA_NAME,
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(sahara_dt_ids),
+		.of_match_table = sahara_dt_ids,
 	},
 	.id_table = sahara_platform_ids,
 };
-- 
1.7.9.5
