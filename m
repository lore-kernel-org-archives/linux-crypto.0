From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v3 01/13] crypto: sun4i-ss: group variable definitions in sun4i_hash()
Date: Thu,  1 Jun 2017 21:38:53 +0200
Message-ID: <20170601193905.28829-2-antoine.tenart@free-electrons.com>
References: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46570 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdFATji (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 15:39:38 -0400
In-Reply-To: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cosmetic change to avoid having a full screen a variable definitions. It
also helps to see which variables share the same type.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 0de2f62d51ff..855325338844 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -167,37 +167,28 @@ int sun4i_hash_import_sha1(struct ahash_request *areq, const void *in)
  */
 static int sun4i_hash(struct ahash_request *areq)
 {
-	u32 v, ivmode = 0;
-	unsigned int i = 0;
 	/*
 	 * i is the total bytes read from SGs, to be compared to areq->nbytes
 	 * i is important because we cannot rely on SG length since the sum of
 	 * SG->length could be greater than areq->nbytes
+	 *
+	 * end is the position when we need to stop writing to the device,
+	 * to be compared to i
+	 *
+	 * in_i: advancement in the current SG
 	 */
-
+	unsigned int i = 0, end, index, padlen, nwait, nbw = 0, j = 0, todo;
+	unsigned int in_i = 0;
+	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32], wb = 0, v, ivmode = 0;
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun4i_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 	struct sun4i_ss_ctx *ss = tfmctx->ss;
-	unsigned int in_i = 0; /* advancement in the current SG */
-	unsigned int end;
-	/*
-	 * end is the position when we need to stop writing to the device,
-	 * to be compared to i
-	 */
-	int in_r, err = 0;
-	unsigned int todo;
-	u32 spaces, rx_cnt = SS_RX_DEFAULT;
-	size_t copied = 0;
+	struct scatterlist *in_sg = areq->src;
 	struct sg_mapping_iter mi;
-	unsigned int j = 0;
-	int zeros;
-	unsigned int index, padlen;
+	int in_r, err = 0, zeros;
+	size_t copied = 0;
 	__be64 bits;
-	u32 bf[32];
-	u32 wb = 0;
-	unsigned int nwait, nbw = 0;
-	struct scatterlist *in_sg = areq->src;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
-- 
2.9.4
