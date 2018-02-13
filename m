From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 3/8] crypto: inside-secure - fix the extra cache computation
Date: Tue, 13 Feb 2018 09:26:52 +0100
Message-ID: <20180213082657.4759-4-antoine.tenart@bootlin.com>
References: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, oferh@marvell.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44294 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933697AbeBMIaX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:23 -0500
In-Reply-To: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the extra cache computation when the queued data is a
multiple of a block size. This fixes the hash support in some cases.

Fixes: 809778e02cd4 ("crypto: inside-secure - fix hash when length is a multiple of a block")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 122a2a58e98f..8fac23b78da5 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -198,7 +198,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 			/* If this is not the last request and the queued data
 			 * is a multiple of a block, cache the last one for now.
 			 */
-			extra = queued - crypto_ahash_blocksize(ahash);
+			extra = crypto_ahash_blocksize(ahash);
 
 		if (extra) {
 			sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
-- 
2.14.3
