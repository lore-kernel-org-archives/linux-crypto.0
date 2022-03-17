Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD2FC43219
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiCQU6K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiCQU5v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B629D1B7566
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:25 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r6so9037530wrr.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pMl873O8vI6SYZNC19sMCGneuUcHABXdwkWv+o7Nxkg=;
        b=HWAvqST7dJbnOtU4PW1/781DREJgx5RXg73kNaslQM+zRMkR4AcNlM7ziagamJeTkz
         W1p3Sx4tTVLpQgQQQ2FI+g/ofcJ/u2maqXm/HcTjg6gCx2e9a/pUqNXjD3QDirswv1ch
         CLqzeLi8DD0bO6g2lQy/gQrBrw4KlH4G5XHmzhkozC5uiXWYg7prCMqDv9ZNQeSePBk3
         0+OK4l9SIxY6hMnNIzdRYTyAuokDWiMAPhA2jsl5YqaSvSr0SK4tC3jRARAD+gEng1yp
         Y6ltds6ZDt7B2UhQybE+v2zV+X3oheFC7lXoOV2NJ9x7YGV2I78NVwxZ8fWYuuzQkD/Y
         AAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pMl873O8vI6SYZNC19sMCGneuUcHABXdwkWv+o7Nxkg=;
        b=nXDNJ5kmS+F82aWyhKBDTHQXwgLWYsGJjI1rktV1XxyrGx7ZJV9GHrHD0rq3BY81+J
         pauzZGujp7j2G/oIvi1um9yBl6PX8KtTGhvkJuVbTCPy/i9g/8p88zfBE8+7Of+QpIt/
         +FfCDS3DxvfdcHG46rR+Ps/hW0Y/hWCVnaWNJX9FIC2bzIh+rQM35ldVtzDXPQRmV1iN
         YCd2JNvsGV8uZGgaV2pnRcKYxfJwWZeYN4UsEIrYph7ATYU/KFwfDLvzFxT3O7zC/CfR
         g36YJLRw7dk47uX0ZJwk5r1TiDAVbqoNA/NYPBd8XqxBdHU72vVhwtPsdoKO8/niEaoH
         Tx/g==
X-Gm-Message-State: AOAM533fWAeoT80PY82JPCFCEU7KEzF9m+PK7ytDUFFT7ucSZS5R67av
        UriGM2LCocFrhdVAyQgM5+LHIw==
X-Google-Smtp-Source: ABdhPJz4Ar/EZRadJ4P59734QQCUPQ/f2i88Q+GIAXOWs9zVAVhi5Q/W3kye+qhZ7jVHjXr8UL4gWQ==
X-Received: by 2002:a05:6000:1561:b0:203:7b90:1da0 with SMTP id 1-20020a056000156100b002037b901da0mr5641845wrz.629.1647550584166;
        Thu, 17 Mar 2022 13:56:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:23 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 18/19] crypto: sun8i-ce: rework debugging
Date:   Thu, 17 Mar 2022 20:56:04 +0000
Message-Id: <20220317205605.3924836-19-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "Fallback for xxx" message is annoying, remove it and store the
information in the debugfs.
Let's add more precise fallback stats and display it better.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 43 +++++++++++++++----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 34 +++++++++++++--
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 27 +++++++++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 11 ++++-
 4 files changed, 96 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 35ab71d3a82d..315a62e424d6 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -25,27 +25,54 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct scatterlist *sg;
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct sun8i_ce_alg_template *algt;
+
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
 
 	if (sg_nents_for_len(areq->src, areq->cryptlen) > MAX_SG ||
-	    sg_nents_for_len(areq->dst, areq->cryptlen) > MAX_SG)
+	    sg_nents_for_len(areq->dst, areq->cryptlen) > MAX_SG) {
+		algt->stat_fb_maxsg++;
 		return true;
+	}
+
+	if (areq->cryptlen < crypto_skcipher_ivsize(tfm)) {
+		algt->stat_fb_leniv++;
+		return true;
+	}
 
-	if (areq->cryptlen < crypto_skcipher_ivsize(tfm))
+	if (areq->cryptlen == 0) {
+		algt->stat_fb_len0++;
 		return true;
+	}
 
-	if (areq->cryptlen == 0 || areq->cryptlen % 16)
+	if (areq->cryptlen % 16) {
+		algt->stat_fb_mod16++;
 		return true;
+	}
 
 	sg = areq->src;
 	while (sg) {
-		if (sg->length % 4 || !IS_ALIGNED(sg->offset, sizeof(u32)))
+		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
+			algt->stat_fb_srcali++;
+			return true;
+		}
+		if (sg->length % 4) {
+			algt->stat_fb_srclen++;
 			return true;
+		}
 		sg = sg_next(sg);
 	}
 	sg = areq->dst;
 	while (sg) {
-		if (sg->length % 4 || !IS_ALIGNED(sg->offset, sizeof(u32)))
+		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
+			algt->stat_fb_dstali++;
+			return true;
+		}
+		if (sg->length % 4) {
+			algt->stat_fb_dstlen++;
 			return true;
+		}
 		sg = sg_next(sg);
 	}
 	return false;
@@ -384,9 +411,9 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 	sktfm->reqsize = sizeof(struct sun8i_cipher_req_ctx) +
 			 crypto_skcipher_reqsize(op->fallback_tfm);
 
-	dev_info(op->ce->dev, "Fallback for %s is %s\n",
-		 crypto_tfm_alg_driver_name(&sktfm->base),
-		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)));
+	memcpy(algt->fbname,
+	       crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)),
+	       CRYPTO_MAX_ALG_NAME);
 
 	op->enginectx.op.do_one_request = sun8i_ce_cipher_run;
 	op->enginectx.op.prepare_request = sun8i_ce_cipher_prepare;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 8f902607af68..7f608e1e6bde 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -644,19 +644,47 @@ static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 			continue;
 		switch (ce_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
 				   ce_algs[i].alg.skcipher.base.cra_driver_name,
 				   ce_algs[i].alg.skcipher.base.cra_name,
 				   ce_algs[i].stat_req, ce_algs[i].stat_fb);
+			seq_printf(seq, "\tLast fallback is: %s\n",
+				   ce_algs[i].fbname);
+			seq_printf(seq, "\tFallback due to 0 length: %lu\n",
+				   ce_algs[i].stat_fb_len0);
+			seq_printf(seq, "\tFallback due to length !mod16: %lu\n",
+				   ce_algs[i].stat_fb_mod16);
+			seq_printf(seq, "\tFallback due to length < IV: %lu\n",
+				   ce_algs[i].stat_fb_leniv);
+			seq_printf(seq, "\tFallback due to source alignment: %lu\n",
+				   ce_algs[i].stat_fb_srcali);
+			seq_printf(seq, "\tFallback due to dest alignment: %lu\n",
+				   ce_algs[i].stat_fb_dstali);
+			seq_printf(seq, "\tFallback due to source length: %lu\n",
+				   ce_algs[i].stat_fb_srclen);
+			seq_printf(seq, "\tFallback due to dest length: %lu\n",
+				   ce_algs[i].stat_fb_dstlen);
+			seq_printf(seq, "\tFallback due to SG numbers: %lu\n",
+				   ce_algs[i].stat_fb_maxsg);
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
 				   ce_algs[i].alg.hash.halg.base.cra_driver_name,
 				   ce_algs[i].alg.hash.halg.base.cra_name,
 				   ce_algs[i].stat_req, ce_algs[i].stat_fb);
+			seq_printf(seq, "\tLast fallback is: %s\n",
+				   ce_algs[i].fbname);
+			seq_printf(seq, "\tFallback due to 0 length: %lu\n",
+				   ce_algs[i].stat_fb_len0);
+			seq_printf(seq, "\tFallback due to length: %lu\n",
+				   ce_algs[i].stat_fb_srclen);
+			seq_printf(seq, "\tFallback due to alignment: %lu\n",
+				   ce_algs[i].stat_fb_srcali);
+			seq_printf(seq, "\tFallback due to SG numbers: %lu\n",
+				   ce_algs[i].stat_fb_maxsg);
 			break;
 		case CRYPTO_ALG_TYPE_RNG:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu bytes=%lu\n",
 				   ce_algs[i].alg.rng.base.cra_driver_name,
 				   ce_algs[i].alg.rng.base.cra_name,
 				   ce_algs[i].stat_req, ce_algs[i].stat_bytes);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 17f6885dbe35..0568fffc4dd3 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -50,9 +50,9 @@ int sun8i_ce_hash_crainit(struct crypto_tfm *tfm)
 				 sizeof(struct sun8i_ce_hash_reqctx) +
 				 crypto_ahash_reqsize(op->fallback_tfm));
 
-	dev_info(op->ce->dev, "Fallback for %s is %s\n",
-		 crypto_tfm_alg_driver_name(tfm),
-		 crypto_tfm_alg_driver_name(&op->fallback_tfm->base));
+	memcpy(algt->fbname, crypto_tfm_alg_driver_name(&op->fallback_tfm->base),
+	       CRYPTO_MAX_ALG_NAME);
+
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
 		goto error_pm;
@@ -199,17 +199,32 @@ static int sun8i_ce_hash_digest_fb(struct ahash_request *areq)
 
 static bool sun8i_ce_hash_need_fallback(struct ahash_request *areq)
 {
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sun8i_ce_alg_template *algt;
 	struct scatterlist *sg;
 
-	if (areq->nbytes == 0)
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
+
+	if (areq->nbytes == 0) {
+		algt->stat_fb_len0++;
 		return true;
+	}
 	/* we need to reserve one SG for padding one */
-	if (sg_nents_for_len(areq->src, areq->nbytes) > MAX_SG - 1)
+	if (sg_nents_for_len(areq->src, areq->nbytes) > MAX_SG - 1) {
+		algt->stat_fb_maxsg++;
 		return true;
+	}
 	sg = areq->src;
 	while (sg) {
-		if (sg->length % 4 || !IS_ALIGNED(sg->offset, sizeof(u32)))
+		if (sg->length % 4) {
+			algt->stat_fb_srclen++;
 			return true;
+		}
+		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
+			algt->stat_fb_srcali++;
+			return true;
+		}
 		sg = sg_next(sg);
 	}
 	return false;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 229b696d5a2c..30a6405b2051 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -393,11 +393,18 @@ struct sun8i_ce_alg_template {
 		struct rng_alg rng;
 		struct akcipher_alg rsa;
 	} alg;
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
 	unsigned long stat_bytes;
-#endif
+	unsigned long stat_fb_maxsg;
+	unsigned long stat_fb_leniv;
+	unsigned long stat_fb_len0;
+	unsigned long stat_fb_mod16;
+	unsigned long stat_fb_srcali;
+	unsigned long stat_fb_srclen;
+	unsigned long stat_fb_dstali;
+	unsigned long stat_fb_dstlen;
+	char fbname[CRYPTO_MAX_ALG_NAME];
 };
 
 int sun8i_ce_enqueue(struct crypto_async_request *areq, u32 type);
-- 
2.34.1

