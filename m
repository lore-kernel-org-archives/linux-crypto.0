From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 2/4] crypto: inside-secure - free requests even if their handling failed
Date: Tue, 28 Nov 2017 10:05:16 +0100
Message-ID: <20171128090518.12469-3-antoine.tenart@free-electrons.com>
References: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:54769 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdK1JKD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 04:10:03 -0500
In-Reply-To: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch frees the request private data even if its handling failed,
as it would never be freed otherwise.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 89ba9e85c0f3..4bcef78a08aa 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -607,6 +607,7 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 		ndesc = ctx->handle_result(priv, ring, sreq->req,
 					   &should_complete, &ret);
 		if (ndesc < 0) {
+			kfree(sreq);
 			dev_err(priv->dev, "failed to handle result (%d)", ndesc);
 			return;
 		}
-- 
2.14.3
