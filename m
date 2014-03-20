From: Yashpal Dutta <yashpal.dutta@freescale.com>
Subject: [PATCH v2] crypto: caam - fix caamrng compilation warning
Date: Fri, 21 Mar 2014 00:45:28 +0545
Message-ID: <1395342028-60770-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yashpal Dutta <yashpal.dutta@freescale.com>,
	<stable@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <ruchika.gupta@freescale.com>,
	<vakul@freescale.com>, <horia.geanta@freescale.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

caam_init_rng was erroneously passed pointer address instead of
rng context pointer. This results in Linux compilation warnings

Cc: <stable@vger.kernel.org> # 3.13.6: 6e4e603: crypto: caam - Dynamic memory
Cc: <stable@vger.kernel.org> # 3.13.6
Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
---
 drivers/crypto/caam/caamrng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 403d8d5..3529b54 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -290,7 +290,7 @@ static int __init caam_rng_init(void)
 	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
 	if (!rng_ctx)
 		return -ENOMEM;
-	caam_init_rng(&rng_ctx, dev);
+	caam_init_rng(rng_ctx, dev);
 
 	dev_info(dev, "registering rng-caam\n");
 	return hwrng_register(&caam_rng);
-- 
1.8.1.2
