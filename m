From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: caam - Fix error handling in caam_rng_init()
Date: Wed, 12 Aug 2015 11:48:42 -0300
Message-ID: <1439390922-25091-1-git-send-email-festevam@gmail.com>
Cc: vicki.milhoan@freescale.com, steve.cornelius@freescale.com,
	horia.geanta@freescale.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:35494 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbbHLOtF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2015 10:49:05 -0400
Received: by ykdz80 with SMTP id z80so15749545ykd.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2015 07:49:04 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

In the error paths we should free the resources that were 
previously acquired, so fix it accordingly.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/caam/caamrng.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 345024c..fb0cc54 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -352,14 +352,22 @@ static int __init caam_rng_init(void)
 		return PTR_ERR(dev);
 	}
 	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
-	if (!rng_ctx)
-		return -ENOMEM;
+	if (!rng_ctx) {
+		err = -ENOMEM;
+		goto free_caam_alloc;
+	}
 	err = caam_init_rng(rng_ctx, dev);
 	if (err)
-		return err;
+		goto free_rng_ctx;
 
 	dev_info(dev, "registering rng-caam\n");
 	return hwrng_register(&caam_rng);
+
+free_rng_ctx:
+	kfree(rng_ctx);
+free_caam_alloc:
+	caam_jr_free(dev);
+	return err;
 }
 
 module_init(caam_rng_init);
-- 
1.9.1
