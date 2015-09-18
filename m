From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/8] crypto: amcc replace get_sg_count by sg_nents_for_len
Date: Fri, 18 Sep 2015 14:57:10 +0200
Message-ID: <1442581036-23789-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe.montjoie@gmail.com, dmitry.torokhov@gmail.com,
	fabio.estevam@freescale.com, wsa@the-dreams.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The get_sg_count function of amcc is the same as sg_nents_for_len from
lib/scatterlist.c

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 192a8fa..27288fc 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -740,26 +740,6 @@ void crypto4xx_return_pd(struct crypto4xx_device *dev,
 	pd_uinfo->state = PD_ENTRY_FREE;
 }
 
-/*
- * derive number of elements in scatterlist
- * Shamlessly copy from talitos.c
- */
-static int get_sg_count(struct scatterlist *sg_list, int nbytes)
-{
-	struct scatterlist *sg = sg_list;
-	int sg_nents = 0;
-
-	while (nbytes) {
-		sg_nents++;
-		if (sg->length > nbytes)
-			break;
-		nbytes -= sg->length;
-		sg = sg_next(sg);
-	}
-
-	return sg_nents;
-}
-
 static u32 get_next_gd(u32 current)
 {
 	if (current != PPC4XX_LAST_GD)
@@ -800,7 +780,7 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	u32 gd_idx = 0;
 
 	/* figure how many gd is needed */
-	num_gd = get_sg_count(src, datalen);
+	num_gd = sg_nents_for_len(src, datalen);
 	if (num_gd == 1)
 		num_gd = 0;
 
-- 
2.4.6
