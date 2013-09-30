From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/2] crypto: mv_cesa: Remove redundant of_match_ptr
Date: Mon, 30 Sep 2013 08:49:42 +0530
Message-ID: <1380511182-18424-2-git-send-email-sachin.kamat@linaro.org>
References: <1380511182-18424-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, sachin.kamat@linaro.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34424 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3I3DT5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Sep 2013 23:19:57 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so4987634pbc.15
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2013 20:19:57 -0700 (PDT)
In-Reply-To: <1380511182-18424-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/mv_cesa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index f9b9560..2662d1b 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1187,7 +1187,7 @@ static struct platform_driver marvell_crypto = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "mv_crypto",
-		.of_match_table = of_match_ptr(mv_cesa_of_match_table),
+		.of_match_table = mv_cesa_of_match_table,
 	},
 };
 MODULE_ALIAS("platform:mv_crypto");
-- 
1.7.9.5
