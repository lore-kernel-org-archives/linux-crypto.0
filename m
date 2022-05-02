Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F58C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 20:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387296AbiEBUXO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 16:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352110AbiEBUXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 16:23:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68039DF2E
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 13:19:43 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e24so20855819wrc.9
        for <linux-crypto@vger.kernel.org>; Mon, 02 May 2022 13:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iftm/xI9kjeXJZ8tzRtFxN8q5aP521PJh04tHDEPczk=;
        b=OLZn8wzs0SlfRU2PIzVeps0bRFz+wb+TGtOfLraEFXJFFGA3kIyDJUg8dcHMJOIGZ3
         0T1FNYkhv+JvfAAvvLRs85Lykfa4N3MCf8p8jbRh4Z4/3p+FOvg0KDST4OMckcEeMywq
         SXfJia350VVa8y+bQIDyKCiWfm4G2ncaxLwrvmWbkRQMqGE24S2LSEz9ooNsVXCOhqve
         gsvX2DU1cp1cDDtpm9PyXnO6NP/YRGyrH75M4JLvWSNy1DZxu6LKyr++lXyYyj2SDDbN
         x78Mn+RCZXdBKSzXlVRbyS5js58uH95FpkrXRuruhtjj8LnLK29m51ROwOvTDhkmodMR
         os/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iftm/xI9kjeXJZ8tzRtFxN8q5aP521PJh04tHDEPczk=;
        b=mXtZjYUPjMdzN8RiHbYahblP6k3bI6i+pjL2ECKrpWCOkGPM+rSg4PJvMKhprE15F8
         uNNJtvdZo2fd5BZIR6eZnZfDqqGK3m4VodkFSMTw4zXi6OxCLglXXei29kaNvdBG/S6T
         V99zX/Ag9VBrQM5EuhYztFykB+qrFJIJoyy8h1/UcLG8iBG5CzxJ35EpM8LWuwRYwSJw
         RHijHOZHzfoJ1ZOYhtrHwEFpM5Mb0KR4/D4kapP3uGkcmkWd63NnJuOeYIx000VT0jA6
         jFEZDUZ0YAqmAYlcAHjW0QzlQ/d4ITqEGMBLcqrKsJaZL6CyExw52IJG5/OJNY5j1Z8N
         ToXQ==
X-Gm-Message-State: AOAM532R2bR4c01QiuZnnTOCC1FyXNnx2ov9YMGJXRrsKRUe107Mt7Qt
        4AEvGb7WipAinEwuUFsg9UZLGQ==
X-Google-Smtp-Source: ABdhPJzBRUXtiwQ8U2lS/OaOJ883x4sxzqJC8uGEldMd2VYPU4VjUCeKbJeBUiCkCytoCUYs3LwcTw==
X-Received: by 2002:adf:ec89:0:b0:20a:c0a4:e4a3 with SMTP id z9-20020adfec89000000b0020ac0a4e4a3mr10218312wrn.98.1651522781952;
        Mon, 02 May 2022 13:19:41 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l2-20020adfb102000000b0020c547f75easm7238183wra.101.2022.05.02.13.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:19:41 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 02/19] crypto: sun8i-ce: do not allocate memory when handling requests
Date:   Mon,  2 May 2022 20:19:12 +0000
Message-Id: <20220502201929.843194-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220502201929.843194-1-clabbe@baylibre.com>
References: <20220502201929.843194-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of allocate memory on each requests, it is easier to
pre-allocate buffer for IV.
This made error path easier.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 29 ++++++-------------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 20 ++++++++++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  8 ++---
 3 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 01d032e08825..0b1ce58bdeb9 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -152,23 +152,13 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	ivsize = crypto_skcipher_ivsize(tfm);
 	if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
 		rctx->ivlen = ivsize;
-		rctx->bounce_iv = kzalloc(ivsize, GFP_KERNEL | GFP_DMA);
-		if (!rctx->bounce_iv) {
-			err = -ENOMEM;
-			goto theend_key;
-		}
 		if (rctx->op_dir & CE_DECRYPTION) {
-			rctx->backup_iv = kzalloc(ivsize, GFP_KERNEL);
-			if (!rctx->backup_iv) {
-				err = -ENOMEM;
-				goto theend_key;
-			}
 			offset = areq->cryptlen - ivsize;
-			scatterwalk_map_and_copy(rctx->backup_iv, areq->src,
+			scatterwalk_map_and_copy(chan->backup_iv, areq->src,
 						 offset, ivsize, 0);
 		}
-		memcpy(rctx->bounce_iv, areq->iv, ivsize);
-		rctx->addr_iv = dma_map_single(ce->dev, rctx->bounce_iv, rctx->ivlen,
+		memcpy(chan->bounce_iv, areq->iv, ivsize);
+		rctx->addr_iv = dma_map_single(ce->dev, chan->bounce_iv, rctx->ivlen,
 					       DMA_TO_DEVICE);
 		if (dma_mapping_error(ce->dev, rctx->addr_iv)) {
 			dev_err(ce->dev, "Cannot DMA MAP IV\n");
@@ -257,16 +247,15 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 			dma_unmap_single(ce->dev, rctx->addr_iv, rctx->ivlen, DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, rctx->backup_iv, ivsize);
-			kfree_sensitive(rctx->backup_iv);
+			memcpy(areq->iv, chan->backup_iv, ivsize);
+			memzero_explicit(chan->backup_iv, ivsize);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		kfree(rctx->bounce_iv);
+		memzero_explicit(chan->bounce_iv, ivsize);
 	}
 
-theend_key:
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
 
 theend:
@@ -322,13 +311,13 @@ static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_r
 			dma_unmap_single(ce->dev, rctx->addr_iv, rctx->ivlen, DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, rctx->backup_iv, ivsize);
-			kfree_sensitive(rctx->backup_iv);
+			memcpy(areq->iv, chan->backup_iv, ivsize);
+			memzero_explicit(chan->backup_iv, ivsize);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		kfree(rctx->bounce_iv);
+		memzero_explicit(chan->bounce_iv, ivsize);
 	}
 
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 8be27a462784..8f902607af68 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -305,7 +305,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
@@ -332,7 +332,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
@@ -358,7 +358,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
@@ -385,7 +385,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
@@ -728,6 +728,18 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
 			err = -ENOMEM;
 			goto error_engine;
 		}
+		ce->chanlist[i].bounce_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
+							 GFP_KERNEL | GFP_DMA);
+		if (!ce->chanlist[i].bounce_iv) {
+			err = -ENOMEM;
+			goto error_engine;
+		}
+		ce->chanlist[i].backup_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
+							 GFP_KERNEL);
+		if (!ce->chanlist[i].backup_iv) {
+			err = -ENOMEM;
+			goto error_engine;
+		}
 	}
 	return 0;
 error_engine:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 719f9a730857..229b696d5a2c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -213,6 +213,8 @@ struct ce_task {
  * @status:	set to 1 by interrupt if task is done
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
+ * @backup_iv:		buffer which contain the next IV to store
+ * @bounce_iv:		buffer which contain the IV
  * @stat_req:	number of request done by this flow
  */
 struct sun8i_ce_flow {
@@ -222,6 +224,8 @@ struct sun8i_ce_flow {
 	dma_addr_t t_phy;
 	int timeout;
 	struct ce_task *tl;
+	void *backup_iv;
+	void *bounce_iv;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 #endif
@@ -268,8 +272,6 @@ struct sun8i_ce_dev {
  * struct sun8i_cipher_req_ctx - context for a skcipher request
  * @op_dir:		direction (encrypt vs decrypt) for this request
  * @flow:		the flow to use for this request
- * @backup_iv:		buffer which contain the next IV to store
- * @bounce_iv:		buffer which contain the IV
  * @ivlen:		size of bounce_iv
  * @nr_sgs:		The number of source SG (as given by dma_map_sg())
  * @nr_sgd:		The number of destination SG (as given by dma_map_sg())
@@ -280,8 +282,6 @@ struct sun8i_ce_dev {
 struct sun8i_cipher_req_ctx {
 	u32 op_dir;
 	int flow;
-	void *backup_iv;
-	void *bounce_iv;
 	unsigned int ivlen;
 	int nr_sgs;
 	int nr_sgd;
-- 
2.35.1

