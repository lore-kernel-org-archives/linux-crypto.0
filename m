From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v3 03/13] crypto: sun4i-ss: use lower/upper_32_bits helpers
Date: Thu,  1 Jun 2017 21:38:55 +0200
Message-ID: <20170601193905.28829-4-antoine.tenart@free-electrons.com>
References: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46581 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFATjj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 15:39:39 -0400
In-Reply-To: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace custom bit shifts and masks with lower/upper_32_bits helpers.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 39f0abe5ee25..e53c3127b743 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -188,7 +188,6 @@ static int sun4i_hash(struct ahash_request *areq)
 	struct sg_mapping_iter mi;
 	int in_r, err = 0, zeros;
 	size_t copied = 0;
-	__be64 bits;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
@@ -423,12 +422,13 @@ static int sun4i_hash(struct ahash_request *areq)
 
 	/* write the length of data */
 	if (op->mode == SS_OP_SHA1) {
-		bits = cpu_to_be64(op->byte_count << 3);
-		bf[j++] = bits & 0xffffffff;
-		bf[j++] = (bits >> 32) & 0xffffffff;
+		__be64 bits = cpu_to_be64(op->byte_count << 3);
+		bf[j++] = lower_32_bits(bits);
+		bf[j++] = upper_32_bits(bits);
 	} else {
-		bf[j++] = (op->byte_count << 3) & 0xffffffff;
-		bf[j++] = (op->byte_count >> 29) & 0xffffffff;
+		__le64 bits = op->byte_count << 3;
+		bf[j++] = lower_32_bits(bits);
+		bf[j++] = upper_32_bits(bits);
 	}
 	writesl(ss->base + SS_RXFIFO, bf, j);
 
-- 
2.9.4
