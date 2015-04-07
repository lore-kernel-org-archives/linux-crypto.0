From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH 2/2] crypto: sahara - fix AES descriptor create
Date: Tue,  7 Apr 2015 17:13:42 +0200
Message-ID: <1428419622-1263-2-git-send-email-s.trumtrar@pengutronix.de>
References: <1428419622-1263-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32928 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbbDGPN7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 11:13:59 -0400
In-Reply-To: <1428419622-1263-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES implementation still assumes, that the hw_desc[0] has a valid
key as long as no new key needs to be set; consequentialy it always
sets the AES key header for the first descriptor and puts data into
the second one (hw_desc[1]).

Change this to only update the key in the hardware, when a new key is
to be set and use the first descriptor for data otherwise.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/crypto/sahara.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index d488d97fcee3..84397e0ad647 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -479,6 +479,7 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	struct scatterlist *sg;
 	int ret;
 	int i, j;
+	int idx = 0;
 
 	/* Copy new key if necessary */
 	if (ctx->flags & FLAGS_NEW_KEY) {
@@ -486,17 +487,20 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 		ctx->flags &= ~FLAGS_NEW_KEY;
 
 		if (dev->flags & FLAGS_CBC) {
-			dev->hw_desc[0]->len1 = AES_BLOCK_SIZE;
-			dev->hw_desc[0]->p1 = dev->iv_phys_base;
+			dev->hw_desc[idx]->len1 = AES_BLOCK_SIZE;
+			dev->hw_desc[idx]->p1 = dev->iv_phys_base;
 		} else {
-			dev->hw_desc[0]->len1 = 0;
-			dev->hw_desc[0]->p1 = 0;
+			dev->hw_desc[idx]->len1 = 0;
+			dev->hw_desc[idx]->p1 = 0;
 		}
-		dev->hw_desc[0]->len2 = ctx->keylen;
-		dev->hw_desc[0]->p2 = dev->key_phys_base;
-		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
+		dev->hw_desc[idx]->len2 = ctx->keylen;
+		dev->hw_desc[idx]->p2 = dev->key_phys_base;
+		dev->hw_desc[idx]->next = dev->hw_phys_desc[1];
+
+		dev->hw_desc[idx]->hdr = sahara_aes_key_hdr(dev);
+
+		idx++;
 	}
-	dev->hw_desc[0]->hdr = sahara_aes_key_hdr(dev);
 
 	dev->nb_in_sg = sahara_sg_length(dev->in_sg, dev->total);
 	dev->nb_out_sg = sahara_sg_length(dev->out_sg, dev->total);
@@ -520,7 +524,7 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	}
 
 	/* Create input links */
-	dev->hw_desc[1]->p1 = dev->hw_phys_link[0];
+	dev->hw_desc[idx]->p1 = dev->hw_phys_link[0];
 	sg = dev->in_sg;
 	for (i = 0; i < dev->nb_in_sg; i++) {
 		dev->hw_link[i]->len = sg->length;
@@ -534,7 +538,7 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	}
 
 	/* Create output links */
-	dev->hw_desc[1]->p2 = dev->hw_phys_link[i];
+	dev->hw_desc[idx]->p2 = dev->hw_phys_link[i];
 	sg = dev->out_sg;
 	for (j = i; j < dev->nb_out_sg + i; j++) {
 		dev->hw_link[j]->len = sg->length;
@@ -548,10 +552,10 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	}
 
 	/* Fill remaining fields of hw_desc[1] */
-	dev->hw_desc[1]->hdr = sahara_aes_data_link_hdr(dev);
-	dev->hw_desc[1]->len1 = dev->total;
-	dev->hw_desc[1]->len2 = dev->total;
-	dev->hw_desc[1]->next = 0;
+	dev->hw_desc[idx]->hdr = sahara_aes_data_link_hdr(dev);
+	dev->hw_desc[idx]->len1 = dev->total;
+	dev->hw_desc[idx]->len2 = dev->total;
+	dev->hw_desc[idx]->next = 0;
 
 	sahara_dump_descriptors(dev);
 	sahara_dump_links(dev);
-- 
2.1.4
