From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] crypto: Use PTR_ERR_ZERO
Date: Sun, 27 Aug 2017 11:52:48 +0530
Message-ID: <1503814968-8798-1-git-send-email-himanshujha199640@gmail.com>
Cc: davem@davemloft.net, arno@natisbad.org,
        boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35607 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdH0GXO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Aug 2017 02:23:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use PTR_ERROR_ZERO rather than if(IS_ERR(...)) + PTR_ERR.
Build successfully.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/crypto/marvell/tdma.c   | 5 +----
 drivers/crypto/mv_cesa.c        | 5 +----
 drivers/crypto/qce/ablkcipher.c | 5 +----
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index c76375f..d0ef171 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -304,10 +304,7 @@ int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain, gfp_t flags)
 	struct mv_cesa_tdma_desc *tdma;
 
 	tdma = mv_cesa_dma_add_desc(chain, flags);
-	if (IS_ERR(tdma))
-		return PTR_ERR(tdma);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(tdma);
 }
 
 int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, gfp_t flags)
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index bf25f41..c3883b4 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1052,10 +1052,7 @@ static int mv_cesa_get_sram(struct platform_device *pdev,
 		return -EINVAL;
 
 	cp->sram = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(cp->sram))
-		return PTR_ERR(cp->sram);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(cp->sram);
 }
 
 static int mv_probe(struct platform_device *pdev)
diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index b04b42f..ea4d96b 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -248,10 +248,7 @@ static int qce_ablkcipher_init(struct crypto_tfm *tfm)
 	ctx->fallback = crypto_alloc_skcipher(crypto_tfm_alg_name(tfm), 0,
 					      CRYPTO_ALG_ASYNC |
 					      CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->fallback))
-		return PTR_ERR(ctx->fallback);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(ctx->fallback);
 }
 
 static void qce_ablkcipher_exit(struct crypto_tfm *tfm)
-- 
2.7.4
