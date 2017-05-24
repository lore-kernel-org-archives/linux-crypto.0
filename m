From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 04/11] crypto: sun4i-ss: cannot use DMA is the request is 0 length
Date: Wed, 24 May 2017 21:06:45 +0200
Message-ID: <20170524190652.13278-5-antoine.tenart@free-electrons.com>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50312 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937716AbdEXV1T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 17:27:19 -0400
In-Reply-To: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Do not use DMA is the request is 0 length.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index e53c3127b743..bc3cbde07219 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -250,7 +250,7 @@ static int sun4i_hash(struct ahash_request *areq)
 			i = 0;
 		in_sg = sg_next(in_sg);
 	}
-	if (i == 1 && !op->len)
+	if (i == 1 && !op->len && areq->nbytes)
 		dev_dbg(ss->dev, "We can DMA\n");
 
 	i = 0;
-- 
2.9.4
