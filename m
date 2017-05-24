From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 05/11] crypto: sun4i-ss: do not dynamically set parts of the last buffer to 0
Date: Wed, 24 May 2017 21:06:46 +0200
Message-ID: <20170524190652.13278-6-antoine.tenart@free-electrons.com>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50317 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937720AbdEXV1U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 17:27:20 -0400
In-Reply-To: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Parts of the bf buffer were dynamically set to 0. Change this to set the
whole buffer to 0 by default to avoid any mistake.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index bc3cbde07219..518bc7a7df6a 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -179,7 +179,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	 */
 	unsigned int i = 0, end, index, padlen, nwait, nbw = 0, j = 0, todo;
 	unsigned int in_i = 0;
-	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32], wb = 0, v, ivmode = 0;
+	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, wb = 0, v, ivmode = 0;
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun4i_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
@@ -417,7 +417,6 @@ static int sun4i_hash(struct ahash_request *areq)
 		zeros = (padlen - 1) / 4;
 	}
 
-	memset(bf + j, 0, 4 * zeros);
 	j += zeros;
 
 	/* write the length of data */
-- 
2.9.4
