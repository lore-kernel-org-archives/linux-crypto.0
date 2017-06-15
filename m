From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 10/13] crypto: inside-secure - get the backlog before dequeueing the request
Date: Thu, 15 Jun 2017 09:56:26 +0200
Message-ID: <20170615075629.30907-11-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53373 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752072AbdFOIAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:04 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Get the backlog before dequeuing the request otherwise we'll miss the
first request in line.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 8ae133a9e3f2..8f195e031938 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -431,8 +431,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 
 	do {
 		spin_lock_bh(&priv->ring[ring].queue_lock);
-		req = crypto_dequeue_request(&priv->ring[ring].queue);
 		backlog = crypto_get_backlog(&priv->ring[ring].queue);
+		req = crypto_dequeue_request(&priv->ring[ring].queue);
 		spin_unlock_bh(&priv->ring[ring].queue_lock);
 
 		if (!req)
-- 
2.9.4
