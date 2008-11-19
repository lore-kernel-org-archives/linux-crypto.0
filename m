From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] Fix queue processing.
Date: Wed, 19 Nov 2008 17:03:31 +0300
Message-ID: <12271034143351-git-send-email-zbr@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net>
 <12271034132587-git-send-email-zbr@ioremap.net>
 <12271034131753-git-send-email-zbr@ioremap.net>
 <1227103414646-git-send-email-zbr@ioremap.net>
 <1227103414418-git-send-email-zbr@ioremap.net>
 <12271034142436-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37380 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753980AbYKSOHy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:54 -0500
In-Reply-To: <12271034142436-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/crypto/hifn_795x.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 9a9e7ea..47952d8 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2158,7 +2158,7 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 
 static int hifn_process_queue(struct hifn_device *dev)
 {
-	struct crypto_async_request *async_req;
+	struct crypto_async_request *async_req, *backlog;
 	struct hifn_context *ctx;
 	struct ablkcipher_request *req;
 	unsigned long flags;
@@ -2166,12 +2166,16 @@ static int hifn_process_queue(struct hifn_device *dev)
 
 	while (dev->started < HIFN_QUEUE_LENGTH) {
 		spin_lock_irqsave(&dev->lock, flags);
+		backlog = crypto_get_backlog(&dev->queue);
 		async_req = crypto_dequeue_request(&dev->queue);
 		spin_unlock_irqrestore(&dev->lock, flags);
 
 		if (!async_req)
 			break;
 
+		if (backlog)
+			backlog->complete(backlog, -EINPROGRESS);
+
 		ctx = crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
 
@@ -2575,6 +2579,9 @@ static void hifn_tasklet_callback(unsigned long data)
 	 * context or update is atomic (like setting dev->sa[i] to NULL).
 	 */
 	hifn_check_for_completion(dev, 0);
+
+	if (dev->started < HIFN_QUEUE_LENGTH &&	dev->queue.qlen)
+		hifn_process_queue(dev);
 }
 
 static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.5.2.5

