From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 3/4] crypto: dcp: Use NULL instead of 0
Date: Wed, 29 May 2013 17:09:11 +0530
Message-ID: <1369827552-28373-3-git-send-email-sachin.kamat@linaro.org>
References: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, tobias.rauter@gmail.com,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65220 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418Ab3E2LxQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 May 2013 07:53:16 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so9049041pbb.5
        for <linux-crypto@vger.kernel.org>; Wed, 29 May 2013 04:53:15 -0700 (PDT)
In-Reply-To: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use NULL instead of 0 for pointer variables.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/dcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index 9e91c2c..49dd560 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -408,7 +408,7 @@ static void dcp_done_task(unsigned long data)
 	ablkcipher_walk_complete(&dev->ctx->walk);
 	dev->ctx->req->base.complete(&dev->ctx->req->base,
 			dev->ctx->stat);
-	dev->ctx->req = 0;
+	dev->ctx->req = NULL;
 	/* in case there are other requests in the queue */
 	tasklet_schedule(&dev->queue_task);
 }
-- 
1.7.9.5
