From: Iaroslav Gridin <voker57@gmail.com>
Subject: [PATCH 1/4] crypto: qce: Remove unneeded length check for scatterlist
Date: Tue, 30 Aug 2016 18:53:50 +0300
Message-ID: <20160830155353.19500-2-voker57@gmail.com>
References: <20160830155353.19500-1-voker57@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.gross@linaro.org,
        david.brown@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, Voker57 <voker57@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20160830155353.19500-1-voker57@gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Voker57 <voker57@gmail.com>

Current code avoids supplying scatterlist containing more data than used
to DMA. This leads to dropping data from scatterlists which would
leave some for next run.
Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
---
 drivers/crypto/qce/sha.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 47e114a..a124bb9 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -282,8 +282,6 @@ static int qce_ahash_update(struct ahash_request *req)
 	sg = sg_last = req->src;
 
 	while (len < nbytes && sg) {
-		if (len + sg_dma_len(sg) > nbytes)
-			break;
 		len += sg_dma_len(sg);
 		sg_last = sg;
 		sg = sg_next(sg);
-- 
2.9.3
