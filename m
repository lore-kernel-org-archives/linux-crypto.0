From: Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH v3 1/3] crypto: sahara - remove unneeded mutex in the exported state
Date: Wed, 3 Feb 2016 10:46:50 -0200
Message-ID: <1454503612-21344-1-git-send-email-fabio.estevam@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <s.trumtrar@pengutronix.de>, <marex@denx.de>,
	<linux@arm.linux.org.uk>, <linux-crypto@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0099.outbound.protection.outlook.com ([157.56.111.99]:19136
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751682AbcBCNTw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 08:19:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As pointed out by Herbert Xu we should not include the mutex in the
exported state, so let's just get rid of it.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/crypto/sahara.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 6c4f91c..7e8147d 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -182,7 +182,6 @@ struct sahara_sha_reqctx {
 	u8			buf[SAHARA_MAX_SHA_BLOCK_SIZE];
 	u8			rembuf[SAHARA_MAX_SHA_BLOCK_SIZE];
 	u8			context[SHA256_DIGEST_SIZE + 4];
-	struct mutex		mutex;
 	unsigned int		mode;
 	unsigned int		digest_size;
 	unsigned int		context_size;
@@ -1096,7 +1095,6 @@ static int sahara_sha_enqueue(struct ahash_request *req, int last)
 	if (!req->nbytes && !last)
 		return 0;
 
-	mutex_lock(&rctx->mutex);
 	rctx->last = last;
 
 	if (!rctx->active) {
@@ -1109,7 +1107,6 @@ static int sahara_sha_enqueue(struct ahash_request *req, int last)
 	mutex_unlock(&dev->queue_mutex);
 
 	wake_up_process(dev->kthread);
-	mutex_unlock(&rctx->mutex);
 
 	return ret;
 }
@@ -1137,8 +1134,6 @@ static int sahara_sha_init(struct ahash_request *req)
 	rctx->context_size = rctx->digest_size + 4;
 	rctx->active = 0;
 
-	mutex_init(&rctx->mutex);
-
 	return 0;
 }
 
-- 
1.9.1
