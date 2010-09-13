From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/3] crypto: talitos - sparse check endian fixes
Date: Mon, 13 Sep 2010 17:45:39 -0500
Message-ID: <20100913174539.ea00897d.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:24271
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab0IMWqJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Sep 2010 18:46:09 -0400
Received: from mail68-db3 (localhost.localdomain [127.0.0.1])	by
 mail68-db3-R.bigfish.com (Postfix) with ESMTP id 0533C16D0317	for
 <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 22:46:08 +0000 (UTC)
Received: from DB3EHSMHS006.bigfish.com (unknown [10.3.81.252])	by
 mail68-db3.bigfish.com (Postfix) with ESMTP id F063E6A00C3	for
 <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 22:45:41 +0000 (UTC)
Received: from az33smr02.freescale.net (az33smr02.freescale.net
 [10.64.34.200])	by de01egw02.freescale.net (8.14.3/8.14.3) with ESMTP id
 o8DMje2C008144	for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 15:45:40
 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net
 [10.64.32.10])	by az33smr02.freescale.net (8.13.1/8.13.0) with ESMTP id
 o8DMjkrr018091	for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 17:45:46
 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f22666c..b879c3f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -161,7 +161,7 @@ struct talitos_private {
 static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_addr_t dma_addr)
 {
 	talitos_ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	talitos_ptr->eptr = cpu_to_be32(upper_32_bits(dma_addr));
+	talitos_ptr->eptr = upper_32_bits(dma_addr);
 }
 
 /*
@@ -332,10 +332,9 @@ static int talitos_submit(struct device *dev, struct talitos_desc *desc,
 
 	/* GO! */
 	wmb();
-	out_be32(priv->reg + TALITOS_FF(ch),
-		 cpu_to_be32(upper_32_bits(request->dma_desc)));
+	out_be32(priv->reg + TALITOS_FF(ch), upper_32_bits(request->dma_desc));
 	out_be32(priv->reg + TALITOS_FF_LO(ch),
-		 cpu_to_be32(lower_32_bits(request->dma_desc)));
+		 lower_32_bits(request->dma_desc));
 
 	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
 
@@ -1751,14 +1750,14 @@ static int ahash_init_sha224_swinit(struct ahash_request *areq)
 	ahash_init(areq);
 	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
 
-	req_ctx->hw_context[0] = cpu_to_be32(SHA224_H0);
-	req_ctx->hw_context[1] = cpu_to_be32(SHA224_H1);
-	req_ctx->hw_context[2] = cpu_to_be32(SHA224_H2);
-	req_ctx->hw_context[3] = cpu_to_be32(SHA224_H3);
-	req_ctx->hw_context[4] = cpu_to_be32(SHA224_H4);
-	req_ctx->hw_context[5] = cpu_to_be32(SHA224_H5);
-	req_ctx->hw_context[6] = cpu_to_be32(SHA224_H6);
-	req_ctx->hw_context[7] = cpu_to_be32(SHA224_H7);
+	req_ctx->hw_context[0] = SHA224_H0;
+	req_ctx->hw_context[1] = SHA224_H1;
+	req_ctx->hw_context[2] = SHA224_H2;
+	req_ctx->hw_context[3] = SHA224_H3;
+	req_ctx->hw_context[4] = SHA224_H4;
+	req_ctx->hw_context[5] = SHA224_H5;
+	req_ctx->hw_context[6] = SHA224_H6;
+	req_ctx->hw_context[7] = SHA224_H7;
 
 	/* init 64-bit count */
 	req_ctx->hw_context[8] = 0;
-- 
1.7.1
