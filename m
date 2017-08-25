From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [RFC PATCH 10/12] crypto: crypto4xx: replace crypto4xx_dev's scatter_buffer_size with constant
Date: Fri, 25 Aug 2017 15:47:23 +0200
Message-ID: <5ef8c95cbfd1d4e0c3aa3a4279af82a5d6ebbcc3.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37770 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932465AbdHYNrh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:37 -0400
Received: by mail-wm0-f66.google.com with SMTP id b189so2624133wmd.4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:36 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <26b1303367e13a4c0d61cdfbae90dbf588bcc9b5.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com> <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com> <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com> <575e998ebe72ea59e785263e11b2a44fb1c6d910.1503668705.git.chunkeey@googlemail.com> <0521bf298c4b6aeba2d1e1e89aac9929ebffd0d4.1503668705.git.chunkeey@googlemail.com> <668f5f89e62ccb2e410c5a63f35c64efe9bd0686.1503668705.git.chunkeey@googlemail.com> <26b1303367e13a4c0d61cdfbae90dbf588bcc9b5.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

scatter_buffer_size is always set to PPC4XX_SD_BUFFER_SIZE.
I don't think there's any point in keeping the variable
around.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 7 +++----
 drivers/crypto/amcc/crypto4xx_core.h | 1 -
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index f3f151820373..c47c84f7492a 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -394,10 +394,9 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 	if (!dev->sdr)
 		return -ENOMEM;
 
-	dev->scatter_buffer_size = PPC4XX_SD_BUFFER_SIZE;
 	dev->scatter_buffer_va =
 		dma_alloc_coherent(dev->core_dev->device,
-			dev->scatter_buffer_size * PPC4XX_NUM_SD,
+			PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD,
 			&dev->scatter_buffer_pa, GFP_ATOMIC);
 	if (!dev->scatter_buffer_va) {
 		dma_free_coherent(dev->core_dev->device,
@@ -410,7 +409,7 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 
 	for (i = 0; i < PPC4XX_NUM_SD; i++) {
 		sd_array[i].ptr = dev->scatter_buffer_pa +
-				  dev->scatter_buffer_size * i;
+				  PPC4XX_SD_BUFFER_SIZE * i;
 	}
 
 	return 0;
@@ -425,7 +424,7 @@ static void crypto4xx_destroy_sdr(struct crypto4xx_device *dev)
 
 	if (dev->scatter_buffer_va != NULL)
 		dma_free_coherent(dev->core_dev->device,
-				  dev->scatter_buffer_size * PPC4XX_NUM_SD,
+				  PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD,
 				  dev->scatter_buffer_va,
 				  dev->scatter_buffer_pa);
 }
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index f886b8bdc868..dc8452be1003 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -87,7 +87,6 @@ struct crypto4xx_device {
 					program ce sdr_base_register */
 	void *scatter_buffer_va;
 	dma_addr_t scatter_buffer_pa;
-	u32 scatter_buffer_size;
 
 	void *shadow_sa_pool;		/* pool of memory for sa in pd_uinfo */
 	dma_addr_t shadow_sa_pool_pa;
-- 
2.14.1
