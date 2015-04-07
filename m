From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH 1/2] crypto: sahara - use the backlog
Date: Tue,  7 Apr 2015 17:13:41 +0200
Message-ID: <1428419622-1263-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32927 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbbDGPN7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 11:13:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With commit

	7e77bdebff5cb1e9876c561f69710b9ab8fa1f7e crypto: af_alg - fix backlog handling

in place, the backlog works under all circumstances where it previously failed, atleast
for the sahara driver. Use it.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/crypto/sahara.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 290a7f0a681f..d488d97fcee3 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1092,15 +1092,20 @@ static int sahara_queue_manage(void *data)
 {
 	struct sahara_dev *dev = (struct sahara_dev *)data;
 	struct crypto_async_request *async_req;
+	struct crypto_async_request *backlog;
 	int ret = 0;
 
 	do {
 		__set_current_state(TASK_INTERRUPTIBLE);
 
 		mutex_lock(&dev->queue_mutex);
+		backlog = crypto_get_backlog(&dev->queue);
 		async_req = crypto_dequeue_request(&dev->queue);
 		mutex_unlock(&dev->queue_mutex);
 
+		if (backlog)
+			backlog->complete(backlog, -EINPROGRESS);
+
 		if (async_req) {
 			if (crypto_tfm_alg_type(async_req->tfm) ==
 			    CRYPTO_ALG_TYPE_AHASH) {
-- 
2.1.4
