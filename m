From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 5/8] crypto: inside-secure - do not process request if no command was issued
Date: Tue, 13 Feb 2018 09:26:54 +0100
Message-ID: <20180213082657.4759-6-antoine.tenart@bootlin.com>
References: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, oferh@marvell.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44275 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933680AbeBMIaW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:22 -0500
In-Reply-To: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a check in the SafeXcel dequeue function, to avoid
processing request further if no hardware command was issued. This can
happen in certain cases where the ->send() function caches all the data
that would have been send.

Fixes: 809778e02cd4 ("crypto: inside-secure - fix hash when length is a multiple of a block")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5cb90bcd3f18..0642d7181c9e 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -490,6 +490,15 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
 
+		/* In case the send() helper did not issue any command to push
+		 * to the engine because the input data was cached, continue to
+		 * dequeue other requests as this is valid and not an error.
+		 */
+		if (!commands && !results) {
+			kfree(request);
+			continue;
+		}
+
 		spin_lock_bh(&priv->ring[ring].egress_lock);
 		list_add_tail(&request->list, &priv->ring[ring].list);
 		spin_unlock_bh(&priv->ring[ring].egress_lock);
-- 
2.14.3
