From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 11/13] crypto: inside-secure - only dequeue when needed
Date: Thu, 15 Jun 2017 09:56:27 +0200
Message-ID: <20170615075629.30907-12-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53375 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbdFOIAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:04 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This force the need_dequeue flag to be unset whenever the dequeue
function is called, to avoid calling it when it is not necessary.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 8f195e031938..e7f87ac12685 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -429,6 +429,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	struct safexcel_request *request;
 	int ret, nreq = 0, cdesc = 0, rdesc = 0, commands, results;
 
+	priv->ring[ring].need_dequeue = false;
+
 	do {
 		spin_lock_bh(&priv->ring[ring].queue_lock);
 		backlog = crypto_get_backlog(&priv->ring[ring].queue);
@@ -631,10 +633,8 @@ static void safexcel_handle_result_work(struct work_struct *work)
 
 	safexcel_handle_result_descriptor(priv, data->ring);
 
-	if (priv->ring[data->ring].need_dequeue) {
-		priv->ring[data->ring].need_dequeue = false;
+	if (priv->ring[data->ring].need_dequeue)
 		safexcel_dequeue(data->priv, data->ring);
-	}
 }
 
 struct safexcel_ring_irq_data {
-- 
2.9.4
