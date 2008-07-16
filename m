From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 4/6] crypto: talitos - fix GFP flag usage
Date: Wed, 16 Jul 2008 18:22:15 -0500
Message-ID: <20080716182215.36c1bd11.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:64623 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224AbYGPXXM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 19:23:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

use GFP_ATOMIC when necessary; use atomic_t when allocating submit_count.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Lee Nipper <lee.nipper@freescale.com>
---
 drivers/crypto/talitos.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index fdb0680..79fdba2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1015,6 +1015,8 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct ipsec_esp_edesc *edesc;
 	int src_nents, dst_nents, alloc_len, dma_len;
+	gfp_t flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+		      GFP_ATOMIC;
 
 	if (areq->cryptlen + ctx->authsize > TALITOS_MAX_DATA_LEN) {
 		dev_err(ctx->dev, "cryptlen exceeds h/w max limit\n");
@@ -1046,7 +1048,7 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 		alloc_len += icv_stashing ? ctx->authsize : 0;
 	}
 
-	edesc = kmalloc(alloc_len, GFP_DMA);
+	edesc = kmalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(ctx->dev, "could not allocate edescriptor\n");
 		return ERR_PTR(-ENOMEM);
@@ -1508,7 +1510,7 @@ static int talitos_probe(struct of_device *ofdev,
 		}
 	}
 
-	priv->submit_count = kmalloc(sizeof(int) * priv->num_channels,
+	priv->submit_count = kmalloc(sizeof(atomic_t) * priv->num_channels,
 				     GFP_KERNEL);
 	if (!priv->submit_count) {
 		dev_err(dev, "failed to allocate fifo submit count space\n");
-- 
1.5.6

