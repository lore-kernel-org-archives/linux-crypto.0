From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/2] crypto: talitos: Use common error handling code in
 talitos_edesc_alloc()
Date: Mon, 12 Mar 2018 14:31:54 +0100
Message-ID: <330e4ffc-64dc-5474-4c84-916561cf0783@users.sourceforge.net>
References: <ad256dc9-a064-37f9-fb8e-aea22ba40a2b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ad256dc9-a064-37f9-fb8e-aea22ba40a2b@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 12 Mar 2018 14:08:55 +0100

Add jump targets so that an error message and the setting of a specific
error code is stored only once at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/talitos.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6882fa2f8bad..a2271322db34 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1352,29 +1352,24 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	if (!dst || dst == src) {
 		src_len = assoclen + cryptlen + authsize;
 		src_nents = sg_nents_for_len(src, src_len);
-		if (src_nents < 0) {
-			dev_err(dev, "Invalid number of src SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
-		}
+		if (src_nents < 0)
+			goto report_failure;
+
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
 		dst_len = 0;
 	} else { /* dst && dst != src*/
 		src_len = assoclen + cryptlen + (encrypt ? 0 : authsize);
 		src_nents = sg_nents_for_len(src, src_len);
-		if (src_nents < 0) {
-			dev_err(dev, "Invalid number of src SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
-		}
+		if (src_nents < 0)
+			goto report_failure;
+
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_len = assoclen + cryptlen + (encrypt ? authsize : 0);
 		dst_nents = sg_nents_for_len(dst, dst_len);
 		if (dst_nents < 0) {
 			dev_err(dev, "Invalid number of dst SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
+			goto set_error_code;
 		}
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
@@ -1424,6 +1419,11 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						     DMA_BIDIRECTIONAL);
 	}
 	return edesc;
+
+report_failure:
+	dev_err(dev, "Invalid number of src SG.\n");
+set_error_code:
+	err = ERR_PTR(-EINVAL);
 error_sg:
 	if (iv_dma)
 		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
-- 
2.16.2
