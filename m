From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/8] crypto: talitos - remove unused giv from ablkcipher methods
Date: Fri, 8 Jul 2011 17:57:24 -0500
Message-ID: <1310165849-22177-3-git-send-email-kim.phillips@freescale.com>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:12603
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553Ab1GHW6K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:10 -0400
Received: from mail31-am1 (localhost.localdomain [127.0.0.1])	by
 mail31-am1-R.bigfish.com (Postfix) with ESMTP id 0C14C12E8076	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:09 +0000 (UTC)
Received: from AM1EHSMHS017.bigfish.com (unknown [10.3.201.246])	by
 mail31-am1.bigfish.com (Postfix) with ESMTP id D9601104804B	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:08 +0000 (UTC)
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bd9e2ca..521244e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1429,7 +1429,6 @@ static void ablkcipher_done(struct device *dev,
 
 static int common_nonsnoop(struct talitos_edesc *edesc,
 			   struct ablkcipher_request *areq,
-			   u8 *giv,
 			   void (*callback) (struct device *dev,
 					     struct talitos_desc *desc,
 					     void *context, int error))
@@ -1449,7 +1448,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 
 	/* cipher iv */
 	ivsize = crypto_ablkcipher_ivsize(cipher);
-	map_single_talitos_ptr(dev, &desc->ptr[1], ivsize, giv ?: areq->info, 0,
+	map_single_talitos_ptr(dev, &desc->ptr[1], ivsize, areq->info, 0,
 			       DMA_TO_DEVICE);
 
 	/* cipher key */
@@ -1552,7 +1551,7 @@ static int ablkcipher_encrypt(struct ablkcipher_request *areq)
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
-	return common_nonsnoop(edesc, areq, NULL, ablkcipher_done);
+	return common_nonsnoop(edesc, areq, ablkcipher_done);
 }
 
 static int ablkcipher_decrypt(struct ablkcipher_request *areq)
@@ -1568,7 +1567,7 @@ static int ablkcipher_decrypt(struct ablkcipher_request *areq)
 
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
 
-	return common_nonsnoop(edesc, areq, NULL, ablkcipher_done);
+	return common_nonsnoop(edesc, areq, ablkcipher_done);
 }
 
 static void common_nonsnoop_hash_unmap(struct device *dev,
-- 
1.7.6
