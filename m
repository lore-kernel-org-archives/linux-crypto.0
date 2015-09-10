From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/7] crypto: sahara replace sahara_sg_length with sg_nents_for_len
Date: Thu, 10 Sep 2015 15:21:38 +0200
Message-ID: <1441891302-12014-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sahara.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 820dc3a..cea2411 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -274,30 +274,6 @@ static u32 sahara_aes_data_link_hdr(struct sahara_dev *dev)
 			SAHARA_HDR_CHA_SKHA | SAHARA_HDR_PARITY_BIT;
 }
 
-static int sahara_sg_length(struct scatterlist *sg,
-			    unsigned int total)
-{
-	int sg_nb;
-	unsigned int len;
-	struct scatterlist *sg_list;
-
-	sg_nb = 0;
-	sg_list = sg;
-
-	while (total) {
-		len = min(sg_list->length, total);
-
-		sg_nb++;
-		total -= len;
-
-		sg_list = sg_next(sg_list);
-		if (!sg_list)
-			total = 0;
-	}
-
-	return sg_nb;
-}
-
 static char *sahara_err_src[16] = {
 	"No error",
 	"Header error",
@@ -502,8 +478,8 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 		idx++;
 	}
 
-	dev->nb_in_sg = sahara_sg_length(dev->in_sg, dev->total);
-	dev->nb_out_sg = sahara_sg_length(dev->out_sg, dev->total);
+	dev->nb_in_sg = sg_nents_for_len(dev->in_sg, dev->total);
+	dev->nb_out_sg = sg_nents_for_len(dev->out_sg, dev->total);
 	if ((dev->nb_in_sg + dev->nb_out_sg) > SAHARA_MAX_HW_LINK) {
 		dev_err(dev->device, "not enough hw links (%d)\n",
 			dev->nb_in_sg + dev->nb_out_sg);
@@ -818,7 +794,7 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 
 	dev->in_sg = rctx->in_sg;
 
-	dev->nb_in_sg = sahara_sg_length(dev->in_sg, rctx->total);
+	dev->nb_in_sg = sg_nents_for_len(dev->in_sg, rctx->total);
 	if ((dev->nb_in_sg) > SAHARA_MAX_HW_LINK) {
 		dev_err(dev->device, "not enough hw links (%d)\n",
 			dev->nb_in_sg + dev->nb_out_sg);
-- 
2.4.6
