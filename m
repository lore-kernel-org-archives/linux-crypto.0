Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A4FC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245213AbiCBVNV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245144AbiCBVMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:12:38 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4130CDEA00
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:11:35 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id bk29so4750177wrb.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QhVmbKgT5iP1VQinzUKuE0L2YMmEX9JoxlQygaDVjoU=;
        b=2MeXx5RAK2ozS8SHbKlD5HyrJC8DOgXimK5Bwa0/ohCi8i92tfuQlP4J6ibhQcA7yo
         zGxCPnpyOH7C1OLjPXyyeyFsR+8qa3m/KamlJ9pUOsEFcCGixDKD1OU6f5XRLWaHsYhX
         RIR6y3pbma6HAzGBkM/eGOGKyWcTNgV5xefjz4foPPgCkRzugVvOag66ae6W17Bo5QuS
         7Z6Y2+k/2XTFlpVZMOsZtZ1ry+1uJrvPUFnpdzIHmgGH9owVaqe+CJpEwFiSQSHVJdkf
         TDRQ/3HwjzUvueu6AoKVhCCG2tVgv4FB9x/nANHtR0cF6OtFGJkF/cp4iaya4d1uFYak
         uV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QhVmbKgT5iP1VQinzUKuE0L2YMmEX9JoxlQygaDVjoU=;
        b=ib9dBJUiE3G+PC4lMPaQgD9bQdEZsheF7p0XTUcoOApPP5SaGKXxZPE6Ft9kiYLBAp
         cbcLMa7v2aAWjcZM/QmxTiguOyJ8YzHQt1hoJ9jtXy6JKSI2f9eEy5kAUCRop37p1XBq
         AEMP6hQNAmzyjxgNDl1V7TFTR8ecwNnRX5YFwEDL8i7tceSmTkiKbhud0ERZd+jBzNyi
         XY5PYarTTlPwwDakUFUg1eKRc9QvQw9fHRy74934yolFndsi2EFuSBQI5u9JlLkiS1ha
         r8NcQ3QMfxrvyqDiN+LB3DlmkY1jo4ZDa4BMEylAKgXJAVVtacZ0B0tK9WNeeqKlfLth
         5R+Q==
X-Gm-Message-State: AOAM530Cwp8eg+WHijnGFrZDZk5S0PDMfQgMwOuGObbo5Z088ttnuNea
        albsaqH335F+cNdPXfDi1WytXA==
X-Google-Smtp-Source: ABdhPJyd7edZaKL0yRYdilhPX5NSk48PanC9YeJh0yyLgLWiVS5LmfSff9pFsjL1p5maJWyKqFELOg==
X-Received: by 2002:a05:6000:178e:b0:1ef:b76e:f54 with SMTP id e14-20020a056000178e00b001efb76e0f54mr13245377wrg.324.1646255493742;
        Wed, 02 Mar 2022 13:11:33 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm145776wmp.44.2022.03.02.13.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:11:33 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, john@metanate.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 14/18] crypto: rockchip: add debugfs
Date:   Wed,  2 Mar 2022 21:11:09 +0000
Message-Id: <20220302211113.4003816-15-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302211113.4003816-1-clabbe@baylibre.com>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch enable to access usage stats for each algorithm.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/Kconfig                        | 10 ++++
 drivers/crypto/rockchip/rk3288_crypto.c       | 47 +++++++++++++++++++
 drivers/crypto/rockchip/rk3288_crypto.h       | 11 +++++
 drivers/crypto/rockchip/rk3288_crypto_ahash.c |  8 ++++
 .../crypto/rockchip/rk3288_crypto_skcipher.c  | 19 +++++++-
 5 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 6c939214833f..04c8e332c5a1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -797,6 +797,16 @@ config CRYPTO_DEV_ROCKCHIP
 	  This driver interfaces with the hardware crypto accelerator.
 	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
 
+config CRYPTO_DEV_ROCKCHIP_DEBUG
+	bool "Enable Rockchip crypto stats"
+	depends on CRYPTO_DEV_ROCKCHIP
+	depends on DEBUG_FS
+	help
+	  Say y to enable Rockchip crypto debug stats.
+	  This will create /sys/kernel/debug/rk3288_crypto/stats for displaying
+	  the number of requests per algorithm and other internal stats.
+
+
 config CRYPTO_DEV_ZYNQMP_AES
 	tristate "Support for Xilinx ZynqMP AES hw accelerator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 5eabac0ea047..cd0755731cf7 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -87,6 +87,41 @@ static struct rk_crypto_tmp *rk_cipher_algs[] = {
 	&rk_ahash_md5,
 };
 
+#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
+static int rk_crypto_debugfs_show(struct seq_file *seq, void *v)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(rk_cipher_algs); i++) {
+		if (!rk_cipher_algs[i]->dev)
+			continue;
+		switch (rk_cipher_algs[i]->type) {
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
+				   rk_cipher_algs[i]->alg.skcipher.base.cra_driver_name,
+				   rk_cipher_algs[i]->alg.skcipher.base.cra_name,
+				   rk_cipher_algs[i]->stat_req, rk_cipher_algs[i]->stat_fb);
+			seq_printf(seq, "\tfallback due to length: %lu\n",
+				   rk_cipher_algs[i]->stat_fb_len);
+			seq_printf(seq, "\tfallback due to alignment: %lu\n",
+				   rk_cipher_algs[i]->stat_fb_align);
+			seq_printf(seq, "\tfallback due to SGs: %lu\n",
+				   rk_cipher_algs[i]->stat_fb_sgdiff);
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
+				   rk_cipher_algs[i]->alg.hash.halg.base.cra_driver_name,
+				   rk_cipher_algs[i]->alg.hash.halg.base.cra_name,
+				   rk_cipher_algs[i]->stat_req, rk_cipher_algs[i]->stat_fb);
+			break;
+		}
+	}
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(rk_crypto_debugfs);
+#endif
+
 static int rk_crypto_register(struct rk_crypto_info *crypto_info)
 {
 	unsigned int i, k;
@@ -232,6 +267,15 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_register_alg;
 	}
 
+#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
+	/* Ignore error of debugfs */
+	crypto_info->dbgfs_dir = debugfs_create_dir("rk3288_crypto", NULL);
+	crypto_info->dbgfs_stats = debugfs_create_file("stats", 0444,
+						       crypto_info->dbgfs_dir,
+						       crypto_info,
+						       &rk_crypto_debugfs_fops);
+#endif
+
 	dev_info(dev, "Crypto Accelerator successfully registered\n");
 	return 0;
 
@@ -245,6 +289,9 @@ static int rk_crypto_remove(struct platform_device *pdev)
 {
 	struct rk_crypto_info *crypto_tmp = platform_get_drvdata(pdev);
 
+#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
+	debugfs_remove_recursive(crypto_tmp->dbgfs_dir);
+#endif
 	rk_crypto_unregister();
 	rk_crypto_disable_clk(crypto_tmp);
 	return 0;
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index c94ae950d2fa..e2a6d735f2e2 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -7,6 +7,7 @@
 #include <crypto/algapi.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <crypto/engine.h>
@@ -198,6 +199,10 @@ struct rk_crypto_info {
 	struct crypto_engine *engine;
 	struct completion complete;
 	int status;
+#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
+	struct dentry *dbgfs_dir;
+	struct dentry *dbgfs_stats;
+#endif
 };
 
 /* the private variable of hash */
@@ -238,6 +243,12 @@ struct rk_crypto_tmp {
 		struct skcipher_alg	skcipher;
 		struct ahash_alg	hash;
 	} alg;
+	unsigned long stat_req;
+	unsigned long stat_fb;
+	unsigned long stat_fb_len;
+	unsigned long stat_fb_sglen;
+	unsigned long stat_fb_align;
+	unsigned long stat_fb_sgdiff;
 };
 
 extern struct rk_crypto_tmp rk_ecb_aes_alg;
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index d08e2438d356..8856c6226be6 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -39,6 +39,10 @@ static int rk_ahash_digest_fb(struct ahash_request *areq)
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct rk_ahash_ctx *tfmctx = crypto_ahash_ctx(tfm);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
+
+	algt->stat_fb++;
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
 	rctx->fallback_req.base.flags = areq->base.flags &
@@ -249,6 +253,8 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
 	struct scatterlist *sg = areq->src;
 	int err = 0;
 	int i;
@@ -256,6 +262,8 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 
 	rctx->mode = 0;
 
+	algt->stat_req++;
+
 	switch (crypto_ahash_digestsize(tfm)) {
 	case SHA1_DIGEST_SIZE:
 		rctx->mode = RK_CRYPTO_HASH_SHA1;
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index df1c11e126dd..a8cfb520eaf8 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -16,6 +16,9 @@
 
 static int rk_cipher_need_fallback(struct skcipher_request *req)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
 	struct scatterlist *sgs, *sgd;
 
 	if (!req->cryptlen)
@@ -24,9 +27,11 @@ static int rk_cipher_need_fallback(struct skcipher_request *req)
 	sgs = req->src;
 	while (sgs) {
 		if (!IS_ALIGNED(sgs->offset, sizeof(u32))) {
+			algt->stat_fb_align++;
 			return true;
 		}
 		if (sgs->length % 16) {
+			algt->stat_fb_len++;
 			return true;
 		}
 		sgs = sg_next(sgs);
@@ -34,9 +39,11 @@ static int rk_cipher_need_fallback(struct skcipher_request *req)
 	sgd = req->dst;
 	while (sgd) {
 		if (!IS_ALIGNED(sgd->offset, sizeof(u32))) {
+			algt->stat_fb_align++;
 			return true;
 		}
 		if (sgd->length % 16) {
+			algt->stat_fb_len++;
 			return true;
 		}
 		sgd = sg_next(sgd);
@@ -44,8 +51,10 @@ static int rk_cipher_need_fallback(struct skcipher_request *req)
 	sgs = req->src;
 	sgd = req->dst;
 	while (sgs && sgd) {
-		if (sgs->length != sgd->length)
+		if (sgs->length != sgd->length) {
+			algt->stat_fb_sgdiff++;
 			return true;
+		}
 		sgs = sg_next(sgs);
 		sgd = sg_next(sgd);
 	}
@@ -57,8 +66,12 @@ static int rk_cipher_fallback(struct skcipher_request *areq)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct rk_cipher_ctx *op = crypto_skcipher_ctx(tfm);
 	struct rk_cipher_rctx *rctx = skcipher_request_ctx(areq);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
 	int err;
 
+	algt->stat_fb++;
+
 	skcipher_request_set_tfm(&rctx->fallback_req, op->fallback_tfm);
 	skcipher_request_set_callback(&rctx->fallback_req, areq->base.flags,
 				      areq->base.complete, areq->base.data);
@@ -325,6 +338,10 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 	u8 *ivtouse = areq->iv;
 	unsigned int len = areq->cryptlen;
 	unsigned int todo;
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
+
+	algt->stat_req++;
 
 	ivsize = crypto_skcipher_ivsize(tfm);
 	if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
-- 
2.34.1

