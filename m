From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 06/13] crypto: inside-secure - align the cipher and hash send functions
Date: Thu, 15 Jun 2017 09:56:22 +0200
Message-ID: <20170615075629.30907-7-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Ofer Heifetz <oferh@marvell.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53413 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752142AbdFOIAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:06 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ofer Heifetz <oferh@marvell.com>

The cipher and hash send functions both set the results variable, to be
used later by the caller. Align the way they're setting this variable.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 59e6081602a2..8eea4d30db31 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -269,7 +269,7 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
 	*commands = n_cdesc;
-	*results = nr_dst;
+	*results = n_rdesc;
 	return 0;
 
 rdesc_rollback:
-- 
2.9.4
