From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 3/4] crypto: inside-secure - only update the result buffer when provided
Date: Tue, 28 Nov 2017 10:05:17 +0100
Message-ID: <20171128090518.12469-4-antoine.tenart@free-electrons.com>
References: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:54773 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdK1JKE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 04:10:04 -0500
In-Reply-To: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch fixes the ahash support by only updating the result buffer
when provided. Otherwise the driver could crash with NULL pointer
exceptions, because the ahash caller isn't required to supply a result
buffer on all calls.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 6135c9f5742c..424f4c5d4d25 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -150,7 +150,12 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 
 	if (sreq->finish)
 		result_sz = crypto_ahash_digestsize(ahash);
-	memcpy(sreq->state, areq->result, result_sz);
+
+	/* The called isn't required to supply a result buffer. Updated it only
+	 * when provided.
+	 */
+	if (areq->result)
+		memcpy(sreq->state, areq->result, result_sz);
 
 	dma_unmap_sg(priv->dev, areq->src,
 		     sg_nents_for_len(areq->src, areq->nbytes), DMA_TO_DEVICE);
-- 
2.14.3
