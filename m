Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E22C43219
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 275442077C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfDYQZV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:25:21 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35766 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbfDYQZV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 12:25:21 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E59A62003FF;
        Thu, 25 Apr 2019 18:25:18 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D7F072003F3;
        Thu, 25 Apr 2019 18:25:18 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 66C172061F;
        Thu, 25 Apr 2019 18:25:18 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 6/7] crypto: caam/qi - DMA map keys using proper device
Date:   Thu, 25 Apr 2019 19:25:00 +0300
Message-Id: <20190425162501.4565-7-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190425162501.4565-1-horia.geanta@nxp.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently there is a mismatch b/w the ICID (Isolation Context ID) used
for DMA mapping keys and ICID used for accessing them.
-keys are DMA mapped using a job ring device, thus a job ring ICID
-keys are accessed from descriptors enqueued via Queue Interface,
thus using QI ICID

[Note: ICIDs of JRs, QI are configured by U-boot / other entity by:
-fixing up the corresponding job ring and controller DT nodes
-setting up corresponding caam ICID registers]

In order to avoid IOMMU faults, DMA map the key using the controller
device instead of a job ring device.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 33 ++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index fd38200dbc1c..912d86afa99b 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -236,7 +236,7 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 		memcpy(ctx->key, keys.authkey, keys.authkeylen);
 		memcpy(ctx->key + ctx->adata.keylen_pad, keys.enckey,
 		       keys.enckeylen);
-		dma_sync_single_for_device(jrdev, ctx->key_dma,
+		dma_sync_single_for_device(jrdev->parent, ctx->key_dma,
 					   ctx->adata.keylen_pad +
 					   keys.enckeylen, ctx->dir);
 		goto skip_split_key;
@@ -250,8 +250,9 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 
 	/* postpend encryption key to auth split key */
 	memcpy(ctx->key + ctx->adata.keylen_pad, keys.enckey, keys.enckeylen);
-	dma_sync_single_for_device(jrdev, ctx->key_dma, ctx->adata.keylen_pad +
-				   keys.enckeylen, ctx->dir);
+	dma_sync_single_for_device(jrdev->parent, ctx->key_dma,
+				   ctx->adata.keylen_pad + keys.enckeylen,
+				   ctx->dir);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ctx.key@" __stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
@@ -391,7 +392,8 @@ static int gcm_setkey(struct crypto_aead *aead,
 #endif
 
 	memcpy(ctx->key, key, keylen);
-	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, ctx->dir);
+	dma_sync_single_for_device(jrdev->parent, ctx->key_dma, keylen,
+				   ctx->dir);
 	ctx->cdata.keylen = keylen;
 
 	ret = gcm_set_sh_desc(aead);
@@ -495,8 +497,8 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 	 * in the nonce. Update the AES key length.
 	 */
 	ctx->cdata.keylen = keylen - 4;
-	dma_sync_single_for_device(jrdev, ctx->key_dma, ctx->cdata.keylen,
-				   ctx->dir);
+	dma_sync_single_for_device(jrdev->parent, ctx->key_dma,
+				   ctx->cdata.keylen, ctx->dir);
 
 	ret = rfc4106_set_sh_desc(aead);
 	if (ret)
@@ -599,8 +601,8 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 	 * in the nonce. Update the AES key length.
 	 */
 	ctx->cdata.keylen = keylen - 4;
-	dma_sync_single_for_device(jrdev, ctx->key_dma, ctx->cdata.keylen,
-				   ctx->dir);
+	dma_sync_single_for_device(jrdev->parent, ctx->key_dma,
+				   ctx->cdata.keylen, ctx->dir);
 
 	ret = rfc4543_set_sh_desc(aead);
 	if (ret)
@@ -2410,6 +2412,7 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
 			    bool uses_dkp)
 {
 	struct caam_drv_private *priv;
+	struct device *dev;
 
 	/*
 	 * distribute tfms across job rings to ensure in-order
@@ -2421,16 +2424,17 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
 		return PTR_ERR(ctx->jrdev);
 	}
 
-	priv = dev_get_drvdata(ctx->jrdev->parent);
+	dev = ctx->jrdev->parent;
+	priv = dev_get_drvdata(dev);
 	if (priv->era >= 6 && uses_dkp)
 		ctx->dir = DMA_BIDIRECTIONAL;
 	else
 		ctx->dir = DMA_TO_DEVICE;
 
-	ctx->key_dma = dma_map_single(ctx->jrdev, ctx->key, sizeof(ctx->key),
+	ctx->key_dma = dma_map_single(dev, ctx->key, sizeof(ctx->key),
 				      ctx->dir);
-	if (dma_mapping_error(ctx->jrdev, ctx->key_dma)) {
-		dev_err(ctx->jrdev, "unable to map key\n");
+	if (dma_mapping_error(dev, ctx->key_dma)) {
+		dev_err(dev, "unable to map key\n");
 		caam_jr_free(ctx->jrdev);
 		return -ENOMEM;
 	}
@@ -2439,7 +2443,7 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
 	ctx->cdata.algtype = OP_TYPE_CLASS1_ALG | caam->class1_alg_type;
 	ctx->adata.algtype = OP_TYPE_CLASS2_ALG | caam->class2_alg_type;
 
-	ctx->qidev = ctx->jrdev->parent;
+	ctx->qidev = dev;
 
 	spin_lock_init(&ctx->lock);
 	ctx->drv_ctx[ENCRYPT] = NULL;
@@ -2474,7 +2478,8 @@ static void caam_exit_common(struct caam_ctx *ctx)
 	caam_drv_ctx_rel(ctx->drv_ctx[ENCRYPT]);
 	caam_drv_ctx_rel(ctx->drv_ctx[DECRYPT]);
 
-	dma_unmap_single(ctx->jrdev, ctx->key_dma, sizeof(ctx->key), ctx->dir);
+	dma_unmap_single(ctx->jrdev->parent, ctx->key_dma, sizeof(ctx->key),
+			 ctx->dir);
 
 	caam_jr_free(ctx->jrdev);
 }
-- 
2.17.1

