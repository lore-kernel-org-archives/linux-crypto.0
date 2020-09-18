Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF91C43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A9221741
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="ZDRzGUQk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIRHXd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgIRHXb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:31 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E469C061788
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:30 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w2so4292758wmi.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q6TYTCUU/KgL5sUUAD12Wafz78xkFRxwFB1EMNpAWEQ=;
        b=ZDRzGUQkw+3sljIgyDqEWit2/s3gA3Y8jYWFlbQjEIzhqTuQkIf/SUBnfzKlxXAjb4
         iEqzxqisgtg9u3te4u4klLrZf9hOy0v7JzKug2wRB3VXQoCRueXBe5KXyA5/OsGOkH3w
         frKTqFHeXijr7lhoA2pFcTMo1OKFpeoI32bK425b3ctcXrKLX6gD3ZzwDrCej1jV6x9K
         AYn9sy54APJN2zKQDK0hq5psB5jLo5GOgSRkDcpB0eVnwlp+qLQARGY2es/wwEKqPIEW
         Wsr7AL3daCbLWMhDqWzswoVqwaK1vxc6vfVFB60dAPeBS36qlIif6cUeyckz8rWAlxY8
         fd2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q6TYTCUU/KgL5sUUAD12Wafz78xkFRxwFB1EMNpAWEQ=;
        b=uErjXSE3Z6NN23QM/DURXg0hRZI2XMqMe5QIcfqxas+mqi+DG8ZoY6MIH0ChWRdUDG
         11v6lzGVFkzg6n9g30KFA5FZ0JQg+T//aX8rB+CN5+L7xUP9rqXRy1lN9FQ4ytN2o8vA
         lNjWThVthtU1Lc99mNLCugxo/kHr++uVBvVuZmWX32HWeHyrSaaODEy75cwxjuX5GaTC
         886uV5JL3jbU3aD5fDVdFC0HRTRuUqhwS9G2n5JaxGKRAutz/w5DqciJXPeSGjelgtzY
         84dAwVCzoUrQw0gl0sOvFXw13dkR4iAh3zFZkzXb/LcG8Zc9HUXIzcqyek+i3qyDMmff
         lYIA==
X-Gm-Message-State: AOAM532fuCHh2uNonk+VesaHNlYP+zYZxmhqag09KUiaOJHjgQIQLgnK
        PpYlKIVPi0FgezWEwN8383TW7A==
X-Google-Smtp-Source: ABdhPJyKgK+kbknJLuS0nI5uAK5lne1SP8pBA8ReSCm0dzUlN5IDRCaaa1dWziAlnCANLYrzikM8vQ==
X-Received: by 2002:a05:600c:228e:: with SMTP id 14mr14806242wmf.17.1600413808999;
        Fri, 18 Sep 2020 00:23:28 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 03/17] crypto: sun8i-ss: support hash algorithms
Date:   Fri, 18 Sep 2020 07:23:01 +0000
Message-Id: <1600413795-39256-4-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SS support multiples hash algorithms, this patch adds support for
MD5, SHA1, SHA224 and SHA256.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/Kconfig              |   9 +
 drivers/crypto/allwinner/sun8i-ss/Makefile    |   1 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 155 ++++++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 444 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  58 +++
 5 files changed, 667 insertions(+)
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index b5f4f1c090ce..b346850a91b9 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -112,3 +112,12 @@ config CRYPTO_DEV_SUN8I_SS_PRNG
 	help
 	  Select this option if you want to provide kernel-side support for
 	  the Pseudo-Random Number Generator found in the Security System.
+
+config CRYPTO_DEV_SUN8I_SS_HASH
+	bool "Enable support for hash on sun8i-ss"
+	depends on CRYPTO_DEV_SUN8I_SS
+	select MD5
+	select SHA1
+	select SHA256
+	help
+	  Say y to enable support for hash algorithms.
diff --git a/drivers/crypto/allwinner/sun8i-ss/Makefile b/drivers/crypto/allwinner/sun8i-ss/Makefile
index 49f2f912c816..aabfd893c817 100644
--- a/drivers/crypto/allwinner/sun8i-ss/Makefile
+++ b/drivers/crypto/allwinner/sun8i-ss/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_CRYPTO_DEV_SUN8I_SS) += sun8i-ss.o
 sun8i-ss-y += sun8i-ss-core.o sun8i-ss-cipher.o
 sun8i-ss-$(CONFIG_CRYPTO_DEV_SUN8I_SS_PRNG) += sun8i-ss-prng.o
+sun8i-ss-$(CONFIG_CRYPTO_DEV_SUN8I_SS_HASH) += sun8i-ss-hash.o
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index ae8321f9a1db..5cf00d03be1f 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -41,6 +41,8 @@ static const struct ss_variant ss_a80_variant = {
 static const struct ss_variant ss_a83t_variant = {
 	.alg_cipher = { SS_ALG_AES, SS_ALG_DES, SS_ALG_3DES,
 	},
+	.alg_hash = { SS_ALG_MD5, SS_ALG_SHA1, SS_ALG_SHA224, SS_ALG_SHA256,
+	},
 	.op_mode = { SS_OP_ECB, SS_OP_CBC,
 	},
 	.ss_clks = {
@@ -284,6 +286,128 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 	}
 },
 #endif
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_HASH
+{	.type = CRYPTO_ALG_TYPE_AHASH,
+	.ss_algo_id = SS_ID_HASH_MD5,
+	.alg.hash = {
+		.init = sun8i_ss_hash_init,
+		.update = sun8i_ss_hash_update,
+		.final = sun8i_ss_hash_final,
+		.finup = sun8i_ss_hash_finup,
+		.digest = sun8i_ss_hash_digest,
+		.export = sun8i_ss_hash_export,
+		.import = sun8i_ss_hash_import,
+		.halg = {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct md5_state),
+			.base = {
+				.cra_name = "md5",
+				.cra_driver_name = "md5-sun8i-ss",
+				.cra_priority = 300,
+				.cra_alignmask = 3,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
+				.cra_module = THIS_MODULE,
+				.cra_init = sun8i_ss_hash_crainit,
+				.cra_exit = sun8i_ss_hash_craexit,
+			}
+		}
+	}
+},
+{	.type = CRYPTO_ALG_TYPE_AHASH,
+	.ss_algo_id = SS_ID_HASH_SHA1,
+	.alg.hash = {
+		.init = sun8i_ss_hash_init,
+		.update = sun8i_ss_hash_update,
+		.final = sun8i_ss_hash_final,
+		.finup = sun8i_ss_hash_finup,
+		.digest = sun8i_ss_hash_digest,
+		.export = sun8i_ss_hash_export,
+		.import = sun8i_ss_hash_import,
+		.halg = {
+			.digestsize = SHA1_DIGEST_SIZE,
+			.statesize = sizeof(struct sha1_state),
+			.base = {
+				.cra_name = "sha1",
+				.cra_driver_name = "sha1-sun8i-ss",
+				.cra_priority = 300,
+				.cra_alignmask = 3,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
+				.cra_module = THIS_MODULE,
+				.cra_init = sun8i_ss_hash_crainit,
+				.cra_exit = sun8i_ss_hash_craexit,
+			}
+		}
+	}
+},
+{	.type = CRYPTO_ALG_TYPE_AHASH,
+	.ss_algo_id = SS_ID_HASH_SHA224,
+	.alg.hash = {
+		.init = sun8i_ss_hash_init,
+		.update = sun8i_ss_hash_update,
+		.final = sun8i_ss_hash_final,
+		.finup = sun8i_ss_hash_finup,
+		.digest = sun8i_ss_hash_digest,
+		.export = sun8i_ss_hash_export,
+		.import = sun8i_ss_hash_import,
+		.halg = {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct sha256_state),
+			.base = {
+				.cra_name = "sha224",
+				.cra_driver_name = "sha224-sun8i-ss",
+				.cra_priority = 300,
+				.cra_alignmask = 3,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
+				.cra_module = THIS_MODULE,
+				.cra_init = sun8i_ss_hash_crainit,
+				.cra_exit = sun8i_ss_hash_craexit,
+			}
+		}
+	}
+},
+{	.type = CRYPTO_ALG_TYPE_AHASH,
+	.ss_algo_id = SS_ID_HASH_SHA256,
+	.alg.hash = {
+		.init = sun8i_ss_hash_init,
+		.update = sun8i_ss_hash_update,
+		.final = sun8i_ss_hash_final,
+		.finup = sun8i_ss_hash_finup,
+		.digest = sun8i_ss_hash_digest,
+		.export = sun8i_ss_hash_export,
+		.import = sun8i_ss_hash_import,
+		.halg = {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct sha256_state),
+			.base = {
+				.cra_name = "sha256",
+				.cra_driver_name = "sha256-sun8i-ss",
+				.cra_priority = 300,
+				.cra_alignmask = 3,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
+				.cra_module = THIS_MODULE,
+				.cra_init = sun8i_ss_hash_crainit,
+				.cra_exit = sun8i_ss_hash_craexit,
+			}
+		}
+	}
+},
+#endif
 };
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
@@ -311,6 +435,12 @@ static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
 				   ss_algs[i].alg.rng.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
 			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			seq_printf(seq, "%s %s %lu %lu\n",
+				   ss_algs[i].alg.hash.halg.base.cra_driver_name,
+				   ss_algs[i].alg.hash.halg.base.cra_name,
+				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
+			break;
 		}
 	}
 	return 0;
@@ -482,6 +612,26 @@ static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 				ss_algs[i].ss = NULL;
 			}
 			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			id = ss_algs[i].ss_algo_id;
+			ss_method = ss->variant->alg_hash[id];
+			if (ss_method == SS_ID_NOTSUPP) {
+				dev_info(ss->dev,
+					"DEBUG: Algo of %s not supported\n",
+					ss_algs[i].alg.hash.halg.base.cra_name);
+				ss_algs[i].ss = NULL;
+				break;
+			}
+			dev_info(ss->dev, "Register %s\n",
+				 ss_algs[i].alg.hash.halg.base.cra_name);
+			err = crypto_register_ahash(&ss_algs[i].alg.hash);
+			if (err) {
+				dev_err(ss->dev, "ERROR: Fail to register %s\n",
+					ss_algs[i].alg.hash.halg.base.cra_name);
+				ss_algs[i].ss = NULL;
+				return err;
+			}
+			break;
 		default:
 			ss_algs[i].ss = NULL;
 			dev_err(ss->dev, "ERROR: tried to register an unknown algo\n");
@@ -508,6 +658,11 @@ static void sun8i_ss_unregister_algs(struct sun8i_ss_dev *ss)
 				 ss_algs[i].alg.rng.base.cra_name);
 			crypto_unregister_rng(&ss_algs[i].alg.rng);
 			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			dev_info(ss->dev, "Unregister %d %s\n", i,
+				 ss_algs[i].alg.hash.halg.base.cra_name);
+			crypto_unregister_ahash(&ss_algs[i].alg.hash);
+			break;
 		}
 	}
 }
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
new file mode 100644
index 000000000000..44bfd7c72922
--- /dev/null
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -0,0 +1,444 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sun8i-ss-hash.c - hardware cryptographic offloader for
+ * Allwinner A80/A83T SoC
+ *
+ * Copyright (C) 2015-2020 Corentin Labbe <clabbe@baylibre.com>
+ *
+ * This file add support for MD5 and SHA1/SHA224/SHA256.
+ *
+ * You could find the datasheet in Documentation/arm/sunxi.rst
+ */
+#include <linux/dma-mapping.h>
+#include <linux/pm_runtime.h>
+#include <linux/scatterlist.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include "sun8i-ss.h"
+
+int sun8i_ss_hash_crainit(struct crypto_tfm *tfm)
+{
+	struct sun8i_ss_hash_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
+	struct sun8i_ss_alg_template *algt;
+	int err;
+
+	memset(op, 0, sizeof(struct sun8i_ss_hash_tfm_ctx));
+
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	op->ss = algt->ss;
+
+	op->enginectx.op.do_one_request = sun8i_ss_hash_run;
+	op->enginectx.op.prepare_request = NULL;
+	op->enginectx.op.unprepare_request = NULL;
+
+	/* FALLBACK */
+	op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
+					      CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(op->fallback_tfm)) {
+		dev_err(algt->ss->dev, "Fallback driver could no be loaded\n");
+		return PTR_ERR(op->fallback_tfm);
+	}
+
+	if (algt->alg.hash.halg.statesize < crypto_ahash_statesize(op->fallback_tfm))
+		algt->alg.hash.halg.statesize = crypto_ahash_statesize(op->fallback_tfm);
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct sun8i_ss_hash_reqctx) +
+				 crypto_ahash_reqsize(op->fallback_tfm));
+
+	dev_info(op->ss->dev, "Fallback for %s is %s\n",
+		 crypto_tfm_alg_driver_name(tfm),
+		 crypto_tfm_alg_driver_name(&op->fallback_tfm->base));
+	err = pm_runtime_get_sync(op->ss->dev);
+	if (err < 0)
+		goto error_pm;
+	return 0;
+error_pm:
+	pm_runtime_put_noidle(op->ss->dev);
+	crypto_free_ahash(op->fallback_tfm);
+	return err;
+}
+
+void sun8i_ss_hash_craexit(struct crypto_tfm *tfm)
+{
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_ahash(tfmctx->fallback_tfm);
+	pm_runtime_put_sync_suspend(tfmctx->ss->dev);
+}
+
+int sun8i_ss_hash_init(struct ahash_request *areq)
+{
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+
+	memset(rctx, 0, sizeof(struct sun8i_ss_hash_reqctx));
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_ahash_init(&rctx->fallback_req);
+}
+
+int sun8i_ss_hash_export(struct ahash_request *areq, void *out)
+{
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_ahash_export(&rctx->fallback_req, out);
+}
+
+int sun8i_ss_hash_import(struct ahash_request *areq, const void *in)
+{
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_ahash_import(&rctx->fallback_req, in);
+}
+
+int sun8i_ss_hash_final(struct ahash_request *areq)
+{
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sun8i_ss_alg_template *algt;
+#endif
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags &
+					CRYPTO_TFM_REQ_MAY_SLEEP;
+	rctx->fallback_req.result = areq->result;
+
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt->stat_fb++;
+#endif
+
+	return crypto_ahash_final(&rctx->fallback_req);
+}
+
+int sun8i_ss_hash_update(struct ahash_request *areq)
+{
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags &
+					CRYPTO_TFM_REQ_MAY_SLEEP;
+	rctx->fallback_req.nbytes = areq->nbytes;
+	rctx->fallback_req.src = areq->src;
+
+	return crypto_ahash_update(&rctx->fallback_req);
+}
+
+int sun8i_ss_hash_finup(struct ahash_request *areq)
+{
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sun8i_ss_alg_template *algt;
+#endif
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags &
+					CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	rctx->fallback_req.nbytes = areq->nbytes;
+	rctx->fallback_req.src = areq->src;
+	rctx->fallback_req.result = areq->result;
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt->stat_fb++;
+#endif
+
+	return crypto_ahash_finup(&rctx->fallback_req);
+}
+
+static int sun8i_ss_hash_digest_fb(struct ahash_request *areq)
+{
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sun8i_ss_alg_template *algt;
+#endif
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags &
+					CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	rctx->fallback_req.nbytes = areq->nbytes;
+	rctx->fallback_req.src = areq->src;
+	rctx->fallback_req.result = areq->result;
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt->stat_fb++;
+#endif
+
+	return crypto_ahash_digest(&rctx->fallback_req);
+}
+
+static int sun8i_ss_run_hash_task(struct sun8i_ss_dev *ss,
+				  struct sun8i_ss_hash_reqctx *rctx,
+				  const char *name)
+{
+	int flow = rctx->flow;
+	u32 v = SS_START;
+	int i;
+
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	ss->flows[flow].stat_req++;
+#endif
+
+	/* choose between stream0/stream1 */
+	if (flow)
+		v |= SS_FLOW1;
+	else
+		v |= SS_FLOW0;
+
+	v |= rctx->method;
+
+	for (i = 0; i < MAX_SG; i++) {
+		if (!rctx->t_dst[i].addr)
+			break;
+
+		mutex_lock(&ss->mlock);
+		if (i > 0) {
+			v |= BIT(17);
+			writel(rctx->t_dst[i - 1].addr, ss->base + SS_KEY_ADR_REG);
+			writel(rctx->t_dst[i - 1].addr, ss->base + SS_IV_ADR_REG);
+		}
+
+		dev_dbg(ss->dev,
+			"Processing SG %d on flow %d %s ctl=%x %d to %d method=%x src=%x dst=%x\n",
+			i, flow, name, v,
+			rctx->t_src[i].len, rctx->t_dst[i].len,
+			rctx->method, rctx->t_src[i].addr, rctx->t_dst[i].addr);
+
+		writel(rctx->t_src[i].addr, ss->base + SS_SRC_ADR_REG);
+		writel(rctx->t_dst[i].addr, ss->base + SS_DST_ADR_REG);
+		writel(rctx->t_src[i].len, ss->base + SS_LEN_ADR_REG);
+		writel(BIT(0) | BIT(1), ss->base + SS_INT_CTL_REG);
+
+		reinit_completion(&ss->flows[flow].complete);
+		ss->flows[flow].status = 0;
+		wmb();
+
+		writel(v, ss->base + SS_CTL_REG);
+		mutex_unlock(&ss->mlock);
+		wait_for_completion_interruptible_timeout(&ss->flows[flow].complete,
+							  msecs_to_jiffies(2000));
+		if (ss->flows[flow].status == 0) {
+			dev_err(ss->dev, "DMA timeout for %s\n", name);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
+static bool sun8i_ss_hash_need_fallback(struct ahash_request *areq)
+{
+	struct scatterlist *sg;
+
+	if (areq->nbytes == 0)
+		return true;
+	/* we need to reserve one SG for the padding one */
+	if (sg_nents(areq->src) > MAX_SG - 1)
+		return true;
+	sg = areq->src;
+	while (sg) {
+		/* SS can operate hash only on full block size
+		 * since SS support only MD5,sha1,sha224 and sha256, blocksize
+		 * is always 64
+		 * TODO: handle request if last SG is not len%64
+		 * but this will need to copy data on a new SG of size=64
+		 */
+		if (sg->length % 64 || !IS_ALIGNED(sg->offset, sizeof(u32)))
+			return true;
+		sg = sg_next(sg);
+	}
+	return false;
+}
+
+int sun8i_ss_hash_digest(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct sun8i_ss_alg_template *algt;
+	struct sun8i_ss_dev *ss;
+	struct crypto_engine *engine;
+	struct scatterlist *sg;
+	int nr_sgs, e, i;
+
+	if (sun8i_ss_hash_need_fallback(areq))
+		return sun8i_ss_hash_digest_fb(areq);
+
+	nr_sgs = sg_nents(areq->src);
+	if (nr_sgs > MAX_SG - 1)
+		return sun8i_ss_hash_digest_fb(areq);
+
+	for_each_sg(areq->src, sg, nr_sgs, i) {
+		if (sg->length % 4 || !IS_ALIGNED(sg->offset, sizeof(u32)))
+			return sun8i_ss_hash_digest_fb(areq);
+	}
+
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	ss = algt->ss;
+
+	e = sun8i_ss_get_engine_number(ss);
+	rctx->flow = e;
+	engine = ss->flows[e].engine;
+
+	return crypto_transfer_hash_request_to_engine(engine, areq);
+}
+
+/* sun8i_ss_hash_run - run an ahash request
+ * Send the data of the request to the SS along with an extra SG with padding
+ */
+int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
+{
+	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct sun8i_ss_alg_template *algt;
+	struct sun8i_ss_dev *ss;
+	struct scatterlist *sg;
+	int nr_sgs, err, digestsize;
+	unsigned int len;
+	u64 fill, min_fill, byte_count;
+	void *pad, *result;
+	int j, i, todo;
+	__be64 *bebits;
+	__le64 *lebits;
+	dma_addr_t addr_res, addr_pad;
+	__le32 *bf;
+
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	ss = algt->ss;
+
+	digestsize = algt->alg.hash.halg.digestsize;
+	if (digestsize == SHA224_DIGEST_SIZE)
+		digestsize = SHA256_DIGEST_SIZE;
+
+	/* the padding could be up to two block. */
+	pad = kzalloc(algt->alg.hash.halg.base.cra_blocksize * 2, GFP_KERNEL | GFP_DMA);
+	if (!pad)
+		return -ENOMEM;
+	bf = (__le32 *)pad;
+
+	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
+	if (!result)
+		return -ENOMEM;
+
+	for (i = 0; i < MAX_SG; i++) {
+		rctx->t_dst[i].addr = 0;
+		rctx->t_dst[i].len = 0;
+	}
+
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+	algt->stat_req++;
+#endif
+
+	rctx->method = ss->variant->alg_hash[algt->ss_algo_id];
+
+	nr_sgs = dma_map_sg(ss->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
+		dev_err(ss->dev, "Invalid sg number %d\n", nr_sgs);
+		err = -EINVAL;
+		goto theend;
+	}
+
+	addr_res = dma_map_single(ss->dev, result, digestsize, DMA_FROM_DEVICE);
+	if (dma_mapping_error(ss->dev, addr_res)) {
+		dev_err(ss->dev, "DMA map dest\n");
+		err = -EINVAL;
+		goto theend;
+	}
+
+	len = areq->nbytes;
+	for_each_sg(areq->src, sg, nr_sgs, i) {
+		rctx->t_src[i].addr = sg_dma_address(sg);
+		todo = min(len, sg_dma_len(sg));
+		rctx->t_src[i].len = todo / 4;
+		len -= todo;
+		rctx->t_dst[i].addr = addr_res;
+		rctx->t_dst[i].len = digestsize / 4;
+	}
+	if (len > 0) {
+		dev_err(ss->dev, "remaining len %d\n", len);
+		err = -EINVAL;
+		goto theend;
+	}
+
+	byte_count = areq->nbytes;
+	j = 0;
+	bf[j++] = cpu_to_le32(0x80);
+
+	fill = 64 - (byte_count % 64);
+	min_fill = 3 * sizeof(u32);
+
+	if (fill < min_fill)
+		fill += 64;
+
+	j += (fill - min_fill) / sizeof(u32);
+
+	switch (algt->ss_algo_id) {
+	case SS_ID_HASH_MD5:
+		lebits = (__le64 *)&bf[j];
+		*lebits = cpu_to_le64(byte_count << 3);
+		j += 2;
+		break;
+	case SS_ID_HASH_SHA1:
+	case SS_ID_HASH_SHA224:
+	case SS_ID_HASH_SHA256:
+		bebits = (__be64 *)&bf[j];
+		*bebits = cpu_to_be64(byte_count << 3);
+		j += 2;
+		break;
+	}
+
+	addr_pad = dma_map_single(ss->dev, pad, j * 4, DMA_TO_DEVICE);
+	rctx->t_src[i].addr = addr_pad;
+	rctx->t_src[i].len = j;
+	rctx->t_dst[i].addr = addr_res;
+	rctx->t_dst[i].len = digestsize / 4;
+	if (dma_mapping_error(ss->dev, addr_pad)) {
+		dev_err(ss->dev, "DMA error on padding SG\n");
+		err = -EINVAL;
+		goto theend;
+	}
+
+	err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
+
+	dma_unmap_single(ss->dev, addr_pad, j * 4, DMA_TO_DEVICE);
+	dma_unmap_sg(ss->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
+	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
+
+	kfree(pad);
+
+	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
+	kfree(result);
+theend:
+	crypto_finalize_hash_request(engine, breq, err);
+	return 0;
+}
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index adf2ee2395c1..377ea7acb54d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -13,6 +13,9 @@
 #include <linux/atomic.h>
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <crypto/md5.h>
+#include <crypto/sha.h>
 
 #define SS_START	1
 
@@ -22,7 +25,11 @@
 #define SS_ALG_AES		0
 #define SS_ALG_DES		(1 << 2)
 #define SS_ALG_3DES		(2 << 2)
+#define SS_ALG_MD5		(3 << 2)
 #define SS_ALG_PRNG		(4 << 2)
+#define SS_ALG_SHA1		(6 << 2)
+#define SS_ALG_SHA224		(7 << 2)
+#define SS_ALG_SHA256		(8 << 2)
 
 #define SS_CTL_REG		0x00
 #define SS_INT_CTL_REG		0x04
@@ -51,6 +58,12 @@
 #define SS_OP_ECB	0
 #define SS_OP_CBC	(1 << 13)
 
+#define SS_ID_HASH_MD5	0
+#define SS_ID_HASH_SHA1	1
+#define SS_ID_HASH_SHA224	2
+#define SS_ID_HASH_SHA256	3
+#define SS_ID_HASH_MAX	4
+
 #define SS_FLOW0	BIT(30)
 #define SS_FLOW1	BIT(31)
 
@@ -84,11 +97,14 @@ struct ss_clock {
  * struct ss_variant - Describe SS capability for each variant hardware
  * @alg_cipher:	list of supported ciphers. for each SS_ID_ this will give the
  *              coresponding SS_ALG_XXX value
+ * @alg_hash:	list of supported hashes. for each SS_ID_ this will give the
+ *              corresponding SS_ALG_XXX value
  * @op_mode:	list of supported block modes
  * @ss_clks!	list of clock needed by this variant
  */
 struct ss_variant {
 	char alg_cipher[SS_ID_CIPHER_MAX];
+	char alg_hash[SS_ID_HASH_MAX];
 	u32 op_mode[SS_ID_OP_MAX];
 	struct ss_clock ss_clks[SS_MAX_CLOCKS];
 };
@@ -198,6 +214,36 @@ struct sun8i_ss_rng_tfm_ctx {
 	unsigned int slen;
 };
 
+/*
+ * struct sun8i_ss_hash_tfm_ctx - context for an ahash TFM
+ * @enginectx:		crypto_engine used by this TFM
+ * @fallback_tfm:	pointer to the fallback TFM
+ * @ss:			pointer to the private data of driver handling this TFM
+ *
+ * enginectx must be the first element
+ */
+struct sun8i_ss_hash_tfm_ctx {
+	struct crypto_engine_ctx enginectx;
+	struct crypto_ahash *fallback_tfm;
+	struct sun8i_ss_dev *ss;
+};
+
+/*
+ * struct sun8i_ss_hash_reqctx - context for an ahash request
+ * @t_src:	list of DMA address and size for source SGs
+ * @t_dst:	list of DMA address and size for destination SGs
+ * @fallback_req:	pre-allocated fallback request
+ * @method:	the register value for the algorithm used by this request
+ * @flow:	the flow to use for this request
+ */
+struct sun8i_ss_hash_reqctx {
+	struct sginfo t_src[MAX_SG];
+	struct sginfo t_dst[MAX_SG];
+	struct ahash_request fallback_req;
+	u32 method;
+	int flow;
+};
+
 /*
  * struct sun8i_ss_alg_template - crypto_alg template
  * @type:		the CRYPTO_ALG_TYPE for this template
@@ -218,6 +264,7 @@ struct sun8i_ss_alg_template {
 	union {
 		struct skcipher_alg skcipher;
 		struct rng_alg rng;
+		struct ahash_alg hash;
 	} alg;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
 	unsigned long stat_req;
@@ -245,3 +292,14 @@ int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
 int sun8i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
 int sun8i_ss_prng_init(struct crypto_tfm *tfm);
 void sun8i_ss_prng_exit(struct crypto_tfm *tfm);
+
+int sun8i_ss_hash_crainit(struct crypto_tfm *tfm);
+void sun8i_ss_hash_craexit(struct crypto_tfm *tfm);
+int sun8i_ss_hash_init(struct ahash_request *areq);
+int sun8i_ss_hash_export(struct ahash_request *areq, void *out);
+int sun8i_ss_hash_import(struct ahash_request *areq, const void *in);
+int sun8i_ss_hash_final(struct ahash_request *areq);
+int sun8i_ss_hash_update(struct ahash_request *areq);
+int sun8i_ss_hash_finup(struct ahash_request *areq);
+int sun8i_ss_hash_digest(struct ahash_request *areq);
+int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq);
-- 
2.26.2

