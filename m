From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 06/11] crypto: sun4i-ss: simplify the pad length calculation
Date: Wed, 24 May 2017 21:06:47 +0200
Message-ID: <20170524190652.13278-7-antoine.tenart@free-electrons.com>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50327 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937734AbdEXV1V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 17:27:21 -0400
In-Reply-To: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When sending the last block of data to the engine, it should be padded
so that the total length of the request can be given to the engine as
the last 2 words of the last 64 bytes block.

Simplify the calculation of this pad offset.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 518bc7a7df6a..59d9b4412aca 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -177,7 +177,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	 *
 	 * in_i: advancement in the current SG
 	 */
-	unsigned int i = 0, end, index, padlen, nwait, nbw = 0, j = 0, todo;
+	unsigned int i = 0, end, fill, min_fill, nwait, nbw = 0, j = 0, todo;
 	unsigned int in_i = 0;
 	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, wb = 0, v, ivmode = 0;
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
@@ -186,7 +186,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	struct sun4i_ss_ctx *ss = tfmctx->ss;
 	struct scatterlist *in_sg = areq->src;
 	struct sg_mapping_iter mi;
-	int in_r, err = 0, zeros;
+	int in_r, err = 0;
 	size_t copied = 0;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
@@ -387,6 +387,8 @@ static int sun4i_hash(struct ahash_request *areq)
 		nbw = op->len - 4 * nwait;
 		wb = *(u32 *)(op->buf + nwait * 4);
 		wb &= (0xFFFFFFFF >> (4 - nbw) * 8);
+
+		op->byte_count += nbw;
 	}
 
 	/* write the remaining bytes of the nbw buffer */
@@ -402,22 +404,15 @@ static int sun4i_hash(struct ahash_request *areq)
 	 * I take the operations from other MD5/SHA1 implementations
 	 */
 
-	/* we have already send 4 more byte of which nbw data */
-	if (op->mode == SS_OP_MD5) {
-		index = (op->byte_count + 4) & 0x3f;
-		op->byte_count += nbw;
-		if (index > 56)
-			zeros = (120 - index) / 4;
-		else
-			zeros = (56 - index) / 4;
-	} else {
-		op->byte_count += nbw;
-		index = op->byte_count & 0x3f;
-		padlen = (index < 56) ? (56 - index) : ((64 + 56) - index);
-		zeros = (padlen - 1) / 4;
-	}
+	/* last block size */
+	fill = 64 - (op->byte_count % 64);
+	min_fill = 2 * sizeof(u32) + (nbw ? 0 : sizeof(u32));
+
+	/* if we can't fill all data, jump to the next 64 block */
+	if (fill < min_fill)
+		fill += 64;
 
-	j += zeros;
+	j += (fill - min_fill) / sizeof(u32);
 
 	/* write the length of data */
 	if (op->mode == SS_OP_SHA1) {
-- 
2.9.4
