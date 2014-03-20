From: Yashpal Dutta <yashpal.dutta@freescale.com>
Subject: [PATCH] crypto: caam - fix caamrng compilation warning
Date: Thu, 20 Mar 2014 07:55:38 +0545
Message-ID: <1395281438-45018-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yashpal Dutta <yashpal.dutta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:1415 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbaCSSPx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Mar 2014 14:15:53 -0400
Received: from mail91-co9 (localhost [127.0.0.1])	by mail91-co9-R.bigfish.com
 (Postfix) with ESMTP id E99E5680163	for <linux-crypto@vger.kernel.org>; Wed,
 19 Mar 2014 18:15:52 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam_init_rng was erroneously passed pointer address instead of
rng context pointer. This results in Linux compilation warnings

Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
---
 drivers/crypto/caam/caamrng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 403d8d5..3529b54 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -290,7 +290,7 @@ static int __init caam_rng_init(void)
 	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
 	if (!rng_ctx)
 		return -ENOMEM;
-	caam_init_rng(&rng_ctx, dev);
+	caam_init_rng(rng_ctx, dev);
 
 	dev_info(dev, "registering rng-caam\n");
 	return hwrng_register(&caam_rng);
-- 
1.8.1.2
