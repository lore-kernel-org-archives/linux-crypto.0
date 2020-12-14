Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDADFC4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97B0E207A0
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502063AbgLNUFC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502925AbgLNUE4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:04:56 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA72C0613D3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:36 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id v3so9372018plz.13
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ogpWsvnZoTjsVLTMRwt0MUzlpuTaHOsyq+/rZpbzBIA=;
        b=KN7E6r54tS+57WRULrmmLeaw88D1Jj68cHY9ifod+rnE8TkdZfWWuAeHYfDl7npTuT
         Az9qnXF4556bv5SJSqaQyZUCfqF4kWCZEAVneVdpMnL2nZxN11iMWr0Xb44+DKmzhAwc
         xf4vxanuiHvuFo+ls2wKAZHPGUp+WRBr3y9W2mhxH71esdIH8mcok2/T2bfVbWJXYQ7y
         +Tbkb76pFVLwvyadTD+0kp84GYnmo3Di5fH2oHC3dQiu01lmOeZpusFNIMeF7sBU6DoG
         Uz3N5DLoYy38B6ZNilVRqdOaXcvaj1t7KWSr7owWHoaKTbx84jjrt/oedwjZT2Se+5RI
         39fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ogpWsvnZoTjsVLTMRwt0MUzlpuTaHOsyq+/rZpbzBIA=;
        b=dl7WCjj9Gl6zD+YmIpINSbD3PmmI/zfm1UQj/cbOhZWvKEZiH+wP/WK1S0EHvJjbUg
         IRphXBLR4d72cZ3SdTD3TD13ZOqPlnsLl8t1MqT+uINSouFl8JE+jb7e0kulMNZNGjRe
         CevNlPt9fnNei584U+8vQ5bt8cIwRjc9/R5m6KJ1WDGk8F1UNePgK7hvnYY6l3t3CQev
         HYwIAGOjL+oaEYvMLQZsxOgiyaMhts1DMwBdyYHKAFWOhrrlUbgBO3wmoadBdRkhBZ9B
         9l0RgsYv2EjLTYO1ssDeAf6ys8i96KCgy26jTUTXDg+AG5TwQ2oCvpdL59wVp3eCRsfk
         +rfg==
X-Gm-Message-State: AOAM532uepih0ofKkdit/6W9axsgmrbwskoplFr9ONYxOUNxc9iyA2lG
        +cVRMieGR/Qx314wrC3gHQmUZw==
X-Google-Smtp-Source: ABdhPJxnwCeO9nOyTdaRjxZ6GMaPGJjCrMkYzCFe+XNY3AESM6nW89/uvfknHadfXxweJ1ZLXeY7mw==
X-Received: by 2002:a17:90b:346:: with SMTP id fh6mr15544080pjb.225.1607976215664;
        Mon, 14 Dec 2020 12:03:35 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:35 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 7/8] crypto: sun4i-ss: enabled stats via debugfs
Date:   Mon, 14 Dec 2020 20:02:31 +0000
Message-Id: <20201214200232.17357-8-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch enable to access usage stats for each algorithm.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/Kconfig              |  9 ++++
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 20 +++++++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 52 +++++++++++++++++++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  6 +++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-prng.c |  5 ++
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  6 +++
 6 files changed, 98 insertions(+)

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 3bd917584754..16eb42140e28 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -51,6 +51,15 @@ config CRYPTO_DEV_SUN4I_SS_PRNG
 	  Select this option if you want to provide kernel-side support for
 	  the Pseudo-Random Number Generator found in the Security System.
 
+config CRYPTO_DEV_SUN4I_SS_DEBUG
+	bool "Enable sun4i-ss stats"
+	depends on CRYPTO_DEV_SUN4I_SS
+	depends on DEBUG_FS
+	help
+	  Say y to enable sun4i-ss debug stats.
+	  This will create /sys/kernel/debug/sun4i-ss/stats for displaying
+	  the number of requests per algorithm.
+
 config CRYPTO_DEV_SUN8I_CE
 	tristate "Support for Allwinner Crypto Engine cryptographic offloader"
 	select CRYPTO_SKCIPHER
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index ffa628c89e21..d5275d914d09 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -36,6 +36,8 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo; /* offset for in and out */
 	unsigned long flags;
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct sun4i_ss_alg_template *algt;
 
 	if (!areq->cryptlen)
 		return 0;
@@ -52,6 +54,12 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
 	}
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG)) {
+		algt = container_of(alg, struct sun4i_ss_alg_template, alg.crypto);
+		algt->stat_opti++;
+		algt->stat_bytes += areq->cryptlen;
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen / 4; i++)
@@ -147,6 +155,13 @@ static int noinline_for_stack sun4i_ss_cipher_poll_fallback(struct skcipher_requ
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
 	int err;
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct sun4i_ss_alg_template *algt;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG)) {
+		algt = container_of(alg, struct sun4i_ss_alg_template, alg.crypto);
+		algt->stat_fb++;
+	}
 
 	skcipher_request_set_tfm(&ctx->fallback_req, op->fallback_tfm);
 	skcipher_request_set_callback(&ctx->fallback_req, areq->base.flags,
@@ -236,6 +251,11 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
 	}
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG)) {
+		algt->stat_req++;
+		algt->stat_bytes += areq->cryptlen;
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen / 4; i++)
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index a2b67f7f8a81..709905ec4680 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -10,6 +10,7 @@
  */
 #include <linux/clk.h>
 #include <linux/crypto.h>
+#include <linux/debugfs.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -234,6 +235,51 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 #endif
 };
 
+static int sun4i_ss_dbgfs_read(struct seq_file *seq, void *v)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
+		if (!ss_algs[i].ss)
+			continue;
+		switch (ss_algs[i].type) {
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			seq_printf(seq, "%s %s reqs=%lu opti=%lu fallback=%lu tsize=%lu\n",
+				   ss_algs[i].alg.crypto.base.cra_driver_name,
+				   ss_algs[i].alg.crypto.base.cra_name,
+				   ss_algs[i].stat_req, ss_algs[i].stat_opti, ss_algs[i].stat_fb,
+				   ss_algs[i].stat_bytes);
+			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			seq_printf(seq, "%s %s reqs=%lu tsize=%lu\n",
+				   ss_algs[i].alg.rng.base.cra_driver_name,
+				   ss_algs[i].alg.rng.base.cra_name,
+				   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			seq_printf(seq, "%s %s reqs=%lu\n",
+				   ss_algs[i].alg.hash.halg.base.cra_driver_name,
+				   ss_algs[i].alg.hash.halg.base.cra_name,
+				   ss_algs[i].stat_req);
+			break;
+		}
+	}
+	return 0;
+}
+
+static int sun4i_ss_dbgfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sun4i_ss_dbgfs_read, inode->i_private);
+}
+
+static const struct file_operations sun4i_ss_debugfs_fops = {
+	.owner = THIS_MODULE,
+	.open = sun4i_ss_dbgfs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 /*
  * Power management strategy: The device is suspended unless a TFM exists for
  * one of the algorithms proposed by this driver.
@@ -454,6 +500,12 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 			break;
 		}
 	}
+
+	/* Ignore error of debugfs */
+	ss->dbgfs_dir = debugfs_create_dir("sun4i-ss", NULL);
+	ss->dbgfs_stats = debugfs_create_file("stats", 0444, ss->dbgfs_dir, ss,
+					      &sun4i_ss_debugfs_fops);
+
 	return 0;
 error_alg:
 	i--;
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index 1dff48558f53..c1b4585e9bbc 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
@@ -191,8 +191,10 @@ static int sun4i_hash(struct ahash_request *areq)
 	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, v, ivmode = 0;
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct sun4i_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 	struct sun4i_ss_ctx *ss = tfmctx->ss;
+	struct sun4i_ss_alg_template *algt;
 	struct scatterlist *in_sg = areq->src;
 	struct sg_mapping_iter mi;
 	int in_r, err = 0;
@@ -398,6 +400,10 @@ static int sun4i_hash(struct ahash_request *areq)
  */
 
 hash_final:
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG)) {
+		algt = container_of(alg, struct sun4i_ss_alg_template, alg.hash);
+		algt->stat_req++;
+	}
 
 	/* write the remaining words of the wait buffer */
 	if (op->len) {
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
index 729aafdbea84..152841076e3a 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
@@ -32,6 +32,11 @@ int sun4i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
 	if (err < 0)
 		return err;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG)) {
+		algt->stat_req++;
+		algt->stat_bytes += todo;
+	}
+
 	spin_lock_bh(&ss->slock);
 
 	writel(mode, ss->base + SS_CTL);
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
index c242fccb2ab6..0fee6f4e2d90 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
@@ -154,6 +154,8 @@ struct sun4i_ss_ctx {
 #ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
 	u32 seed[SS_SEED_LEN / BITS_PER_LONG];
 #endif
+	struct dentry *dbgfs_dir;
+	struct dentry *dbgfs_stats;
 };
 
 struct sun4i_ss_alg_template {
@@ -165,6 +167,10 @@ struct sun4i_ss_alg_template {
 		struct rng_alg rng;
 	} alg;
 	struct sun4i_ss_ctx *ss;
+	unsigned long stat_req;
+	unsigned long stat_fb;
+	unsigned long stat_bytes;
+	unsigned long stat_opti;
 };
 
 struct sun4i_tfm_ctx {
-- 
2.26.2

