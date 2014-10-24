From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v3 1/3] crypto: sahara - initialize spinlock
Date: Fri, 24 Oct 2014 16:20:56 +0200
Message-ID: <1414160458-6548-2-git-send-email-s.trumtrar@pengutronix.de>
References: <1414160458-6548-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39783 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaJXOVF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:21:05 -0400
In-Reply-To: <1414160458-6548-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver uses a spinlock, but never initializes it.
Fix this.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/crypto/sahara.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 164e1ec624e3..6fb16fe7eea5 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -956,6 +956,8 @@ static int sahara_probe(struct platform_device *pdev)
 
 	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
 
+	spin_lock_init(&dev->lock);
+
 	dev_ptr = dev;
 
 	tasklet_init(&dev->queue_task, sahara_aes_queue_task,
-- 
2.1.1
