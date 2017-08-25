From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 11/12] crypto: crypto4xx: fix crypto4xx_build_pdr, crypto4xx_build_sdr leak
Date: Fri, 25 Aug 2017 15:47:24 +0200
Message-ID: <e7da31017c70967765211867a902a09b2be82b2f.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33870 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932473AbdHYNre (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:34 -0400
Received: by mail-wm0-f65.google.com with SMTP id i76so2655880wme.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:33 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <5ef8c95cbfd1d4e0c3aa3a4279af82a5d6ebbcc3.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com> <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com> <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com> <575e998ebe72ea59e785263e11b2a44fb1c6d910.1503668705.git.chunkeey@googlemail.com> <0521bf298c4b6aeba2d1e1e89aac9929ebffd0d4.1503668705.git.chunkeey@googlemail.com> <668f5f89e62ccb2e410c5a63f35c64efe9bd0686.1503668705.git.chunkeey@googlemail.com> <26b1303367e13a4c0d61cdfbae90dbf588bcc9b5.1503668705.git.chunkeey@googlemail.com> <5ef8c95cbfd1d4e0c3aa3a4279af82a5d6ebbcc3.15036687
 05.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If one of the later memory allocations in rypto4xx_build_pdr()
fails: dev->pdr (and/or) dev->pdr_uinfo wouldn't be freed.

crypto4xx_build_sdr() has the same issue with dev->sdr.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index c47c84f7492a..817c44703a07 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -209,7 +209,7 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 				  dev->pdr_pa);
 		return -ENOMEM;
 	}
-	memset(dev->pdr, 0,  sizeof(struct ce_pd) * PPC4XX_NUM_PD);
+	memset(dev->pdr, 0, sizeof(struct ce_pd) * PPC4XX_NUM_PD);
 	dev->shadow_sa_pool = dma_alloc_coherent(dev->core_dev->device,
 				   256 * PPC4XX_NUM_PD,
 				   &dev->shadow_sa_pool_pa,
@@ -242,13 +242,15 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 
 static void crypto4xx_destroy_pdr(struct crypto4xx_device *dev)
 {
-	if (dev->pdr != NULL)
+	if (dev->pdr)
 		dma_free_coherent(dev->core_dev->device,
 				  sizeof(struct ce_pd) * PPC4XX_NUM_PD,
 				  dev->pdr, dev->pdr_pa);
+
 	if (dev->shadow_sa_pool)
 		dma_free_coherent(dev->core_dev->device, 256 * PPC4XX_NUM_PD,
 				  dev->shadow_sa_pool, dev->shadow_sa_pool_pa);
+
 	if (dev->shadow_sr_pool)
 		dma_free_coherent(dev->core_dev->device,
 			sizeof(struct sa_state_record) * PPC4XX_NUM_PD,
@@ -417,12 +419,12 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 
 static void crypto4xx_destroy_sdr(struct crypto4xx_device *dev)
 {
-	if (dev->sdr != NULL)
+	if (dev->sdr)
 		dma_free_coherent(dev->core_dev->device,
 				  sizeof(struct ce_sd) * PPC4XX_NUM_SD,
 				  dev->sdr, dev->sdr_pa);
 
-	if (dev->scatter_buffer_va != NULL)
+	if (dev->scatter_buffer_va)
 		dma_free_coherent(dev->core_dev->device,
 				  PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD,
 				  dev->scatter_buffer_va,
@@ -1223,7 +1225,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 
 	rc = crypto4xx_build_gdr(core_dev->dev);
 	if (rc)
-		goto err_build_gdr;
+		goto err_build_pdr;
 
 	rc = crypto4xx_build_sdr(core_dev->dev);
 	if (rc)
@@ -1266,12 +1268,11 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 err_request_irq:
 	irq_dispose_mapping(core_dev->irq);
 	tasklet_kill(&core_dev->tasklet);
-	crypto4xx_destroy_sdr(core_dev->dev);
 err_build_sdr:
+	crypto4xx_destroy_sdr(core_dev->dev);
 	crypto4xx_destroy_gdr(core_dev->dev);
-err_build_gdr:
-	crypto4xx_destroy_pdr(core_dev->dev);
 err_build_pdr:
+	crypto4xx_destroy_pdr(core_dev->dev);
 	kfree(core_dev->dev);
 err_alloc_dev:
 	kfree(core_dev);
-- 
2.14.1
