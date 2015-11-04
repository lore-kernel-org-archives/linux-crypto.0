From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/7] crypto: sahara: check return value of sg_nents_for_len
Date: Wed,  4 Nov 2015 21:13:35 +0100
Message-ID: <1446668045-8620-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sg_nents_for_len() function could fail, this patch add a check for
its return value.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sahara.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index f68c24a..ea9f56a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -477,7 +477,15 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	}
 
 	dev->nb_in_sg = sg_nents_for_len(dev->in_sg, dev->total);
+	if (dev->nb_in_sg < 0) {
+		dev_err(dev->device, "Invalid numbers of src SG.\n");
+		return dev->nb_in_sg;
+	}
 	dev->nb_out_sg = sg_nents_for_len(dev->out_sg, dev->total);
+	if (dev->nb_out_sg < 0) {
+		dev_err(dev->device, "Invalid numbers of dst SG.\n");
+		return dev->nb_out_sg;
+	}
 	if ((dev->nb_in_sg + dev->nb_out_sg) > SAHARA_MAX_HW_LINK) {
 		dev_err(dev->device, "not enough hw links (%d)\n",
 			dev->nb_in_sg + dev->nb_out_sg);
@@ -793,6 +801,10 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 	dev->in_sg = rctx->in_sg;
 
 	dev->nb_in_sg = sg_nents_for_len(dev->in_sg, rctx->total);
+	if (dev->nb_in_sg < 0) {
+		dev_err(dev->device, "Invalid numbers of src SG.\n");
+		return dev->nb_in_sg;
+	}
 	if ((dev->nb_in_sg) > SAHARA_MAX_HW_LINK) {
 		dev_err(dev->device, "not enough hw links (%d)\n",
 			dev->nb_in_sg + dev->nb_out_sg);
-- 
2.4.10
