From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 2/8] crypto: inside-secure - do not overwrite the threshold value
Date: Tue, 13 Feb 2018 09:26:51 +0100
Message-ID: <20180213082657.4759-3-antoine.tenart@bootlin.com>
References: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, oferh@marvell.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44254 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933651AbeBMIaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:13 -0500
In-Reply-To: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the Inside Secure SafeXcel driver not to overwrite the
interrupt threshold value. In certain cases the value of this register,
which controls when to fire an interrupt, was overwritten. This lead to
packet not being processed or acked as the driver never was aware of
their completion.

This patch fixes this behaviour by not setting the threshold when
requests are being processed by the engine.

Fixes: dc7e28a3286e ("crypto: inside-secure - dequeue all requests at once")
Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 225e74a7f724..5cb90bcd3f18 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -514,8 +514,7 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 
 	if (!priv->ring[ring].busy) {
 		nreq -= safexcel_try_push_requests(priv, ring, nreq);
-		if (nreq)
-			priv->ring[ring].busy = true;
+		priv->ring[ring].busy = true;
 	}
 
 	priv->ring[ring].requests_left += nreq;
-- 
2.14.3
