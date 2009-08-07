From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/3] crypto: talitos - simplify hmac data size calculation
Date: Fri, 7 Aug 2009 18:39:58 -0500
Message-ID: <20090807183958.94650fb7.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:55407 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbZHGXki (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2009 19:40:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

don't do request->src vs. assoc pointer math - it's the same as adding
assoclen and ivsize (just with more effort).

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c70775f..b1a651c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -970,7 +970,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	struct talitos_desc *desc = &edesc->desc;
 	unsigned int cryptlen = areq->cryptlen;
 	unsigned int authsize = ctx->authsize;
-	unsigned int ivsize;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	int sg_count, ret;
 	int sg_link_tbl_len;
 
@@ -978,11 +978,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
 			       0, DMA_TO_DEVICE);
 	/* hmac data */
-	map_single_talitos_ptr(dev, &desc->ptr[1], sg_virt(areq->src) -
-			       sg_virt(areq->assoc), sg_virt(areq->assoc), 0,
-			       DMA_TO_DEVICE);
+	map_single_talitos_ptr(dev, &desc->ptr[1], areq->assoclen + ivsize,
+			       sg_virt(areq->assoc), 0, DMA_TO_DEVICE);
 	/* cipher iv */
-	ivsize = crypto_aead_ivsize(aead);
 	map_single_talitos_ptr(dev, &desc->ptr[2], ivsize, giv ?: areq->iv, 0,
 			       DMA_TO_DEVICE);
 
-- 
1.6.3

