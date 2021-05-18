Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB13C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34C73611CC
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350067AbhERPSb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 11:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350031AbhERPS2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 11:18:28 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB822C061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:09 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id y14so8573376wrm.13
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hVlnWb5EkXaGbT5CSV8p9U9NwVptGcpFI08Tyh8ld6o=;
        b=Znw/SQYpRKbooIlN2bOlZTzjkAtItg0S9gYccuSMOPF+c7OC0Xfhkpxb4+TjxM1cgw
         JB/HvJISZOCC6rNt3b2DSzMrp28CCFj0ThLRidGUtVshgmDjCPwR+E25K7FzKaf0g7EN
         Alrhfmvze4PANxjuqwMvfAroZ/1CL0KdsSXV9/sq3q7kIc5inBBf6x6VTuobt3QWzAuU
         xH6X7EotuWXgwM6Vw2TSPjbbhFVfTNxhI8WL4BflunNiImIMoJic4rs4K88o77Vv6T47
         yMM/XB8jDEc9mDHnE6Sh0fL5c4zPs/y+UatSM2+bcJg5Cx9lcGNUsTpEug23VnfX6Uht
         R7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hVlnWb5EkXaGbT5CSV8p9U9NwVptGcpFI08Tyh8ld6o=;
        b=SBGb4v16NYD+gUXAk2xYd/LbTBqt/yCvFCawqR1H5XlJDO5P4OBcOyZiKz6FBrZHEP
         4H4tUvaIxToqc89hx3BO2uLoPcRnzXbV6nS7bgr3/diQrMeELOb5+9kDlUT5/FTUqA8/
         F1vFjn+wl7qyP+C8M2uerjfRf4aV8+obsU5S6lJFQQvseeHmrEdASKIblkmS99qwcVVD
         WmS8kXQIWXeAK/xFj7UZhzS+fDnev9XcpXFvBmv0woeQRDblQwjb9R0Hc+brU12nJdcq
         vKgP1tq5H6+skpQRrMyjBq0a8P6eYnXedsqNChN0gHhTZJ0qod2zKzYmV3guugbksg2r
         E4ig==
X-Gm-Message-State: AOAM532tjJKWAdfVKsXt8Ft6aXnWS+SZ7TT3E20KPdCdaT/0OQMuW2NR
        7lZqMHRBKoWWwHjPaf7aIZNN+A==
X-Google-Smtp-Source: ABdhPJw6qFMsuxJJpjr5FjNfb9kl3UFD5KdI1kZ2wRtxwNx1Kxs6Cibm2O+brT1mqZNeqS20su6AMw==
X-Received: by 2002:adf:e944:: with SMTP id m4mr7724281wrn.10.1621351028485;
        Tue, 18 May 2021 08:17:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z9sm18005808wmi.17.2021.05.18.08.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 08:17:07 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/5] crypto: Add sl3516 crypto engine
Date:   Tue, 18 May 2021 15:16:52 +0000
Message-Id: <20210518151655.125153-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518151655.125153-1-clabbe@baylibre.com>
References: <20210518151655.125153-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The cortina/gemini SL3516 SoC has a crypto IP name either (crypto
engine/crypto acceleration engine in the datasheet).
It support many algorithms like [AES|DES|3DES][ECB|CBC], SHA1, MD5 and
some HMAC.

This patch adds the core files and support for ecb(aes) and the RNG.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/Kconfig                   |  19 +
 drivers/crypto/Makefile                  |   1 +
 drivers/crypto/gemini/Makefile           |   2 +
 drivers/crypto/gemini/sl3516-ce-cipher.c | 388 ++++++++++++++++
 drivers/crypto/gemini/sl3516-ce-core.c   | 535 +++++++++++++++++++++++
 drivers/crypto/gemini/sl3516-ce-rng.c    |  61 +++
 drivers/crypto/gemini/sl3516-ce.h        | 349 +++++++++++++++
 7 files changed, 1355 insertions(+)
 create mode 100644 drivers/crypto/gemini/Makefile
 create mode 100644 drivers/crypto/gemini/sl3516-ce-cipher.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-core.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-rng.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1d5b342e6b42..99b090790178 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -266,6 +266,25 @@ config CRYPTO_DEV_NIAGARA2
 	  Group, which can perform encryption, decryption, hashing,
 	  checksumming, and raw copies.
 
+config CRYPTO_DEV_SL3516
+	tristate "Stormlink SL3516 crypto offloader"
+	select CRYPTO_SKCIPHER
+	select CRYPTO_ENGINE
+	select CRYPTO_ECB
+	select CRYPTO_AES
+	select HW_RANDOM
+	help
+	  This option allows you to have support for SL3516 crypto offloader.
+
+config CRYPTO_DEV_SL3516_DEBUG
+	bool "Enable SL3516 stats"
+	depends on CRYPTO_DEV_SL3516
+	depends on DEBUG_FS
+	help
+	  Say y to enable SL3516 debug stats.
+	  This will create /sys/kernel/debug/sl3516/stats for displaying
+	  the number of requests per algorithm and other internal stats.
+
 config CRYPTO_DEV_HIFN_795X
 	tristate "Driver HIFN 795x crypto accelerator chips"
 	select CRYPTO_LIB_DES
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index fa22cb19e242..1fe5120eb966 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SA2UL) += sa2ul.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
+obj-$(CONFIG_CRYPTO_DEV_SL3516) += gemini/
 obj-$(CONFIG_ARCH_STM32) += stm32/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
diff --git a/drivers/crypto/gemini/Makefile b/drivers/crypto/gemini/Makefile
new file mode 100644
index 000000000000..c73c8b69260d
--- /dev/null
+++ b/drivers/crypto/gemini/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_SL3516) += sl3516-ce.o
+sl3516-ce-y += sl3516-ce-core.o sl3516-ce-cipher.o sl3516-ce-rng.o
diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
new file mode 100644
index 000000000000..d9564c5c5ff7
--- /dev/null
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -0,0 +1,388 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sl3516-ce-cipher.c - hardware cryptographic offloader for Stormlink SL3516 SoC
+ *
+ * Copyright (C) 2021 Corentin LABBE <clabbe@baylibre.com>
+ *
+ * This file adds support for AES cipher with 128,192,256 bits keysize in
+ * ECB mode.
+ */
+
+#include <linux/crypto.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/skcipher.h>
+#include "sl3516-ce.h"
+
+/* sl3516_ce_need_fallback - check if a request can be handled by the CE */
+static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sl3516_ce_dev *ce = op->ce;
+	struct scatterlist *in_sg = areq->src;
+	struct scatterlist *out_sg = areq->dst;
+	struct scatterlist *sg;
+
+	if (areq->cryptlen == 0 || areq->cryptlen % 16) {
+		ce->fallback_mod16++;
+		return true;
+	}
+
+	/*
+	 * check if we have enough descriptors for TX
+	 * Note: TX need one control desc for each SG
+	 */
+	if (sg_nents(areq->src) > MAXDESC / 2) {
+		ce->fallback_sg_count_tx++;
+		return true;
+	}
+	/* check if we have enough descriptors for RX */
+	if (sg_nents(areq->dst) > MAXDESC) {
+		ce->fallback_sg_count_rx++;
+		return true;
+	}
+
+	sg = areq->src;
+	while (sg) {
+		if ((sg->length % 16) != 0) {
+			ce->fallback_mod16++;
+			return true;
+		}
+		if ((sg_dma_len(sg) % 16) != 0) {
+			ce->fallback_mod16++;
+			return true;
+		}
+		if (!IS_ALIGNED(sg->offset, 16)) {
+			ce->fallback_align16++;
+			return true;
+		}
+		sg = sg_next(sg);
+	}
+	sg = areq->dst;
+	while (sg) {
+		if ((sg->length % 16) != 0) {
+			ce->fallback_mod16++;
+			return true;
+		}
+		if ((sg_dma_len(sg) % 16) != 0) {
+			ce->fallback_mod16++;
+			return true;
+		}
+		if (!IS_ALIGNED(sg->offset, 16)) {
+			ce->fallback_align16++;
+			return true;
+		}
+		sg = sg_next(sg);
+	}
+
+	/* need same numbers of SG (with same length) for source and destination */
+	in_sg = areq->src;
+	out_sg = areq->dst;
+	while (in_sg && out_sg) {
+		if (in_sg->length != out_sg->length) {
+			ce->fallback_not_same_len++;
+			return true;
+		}
+		in_sg = sg_next(in_sg);
+		out_sg = sg_next(out_sg);
+	}
+	if (in_sg || out_sg)
+		return true;
+
+	return false;
+}
+
+static int sl3516_ce_cipher_fallback(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sl3516_ce_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct sl3516_ce_alg_template *algt;
+	int err;
+
+	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher);
+	algt->stat_fb++;
+
+	skcipher_request_set_tfm(&rctx->fallback_req, op->fallback_tfm);
+	skcipher_request_set_callback(&rctx->fallback_req, areq->base.flags,
+				      areq->base.complete, areq->base.data);
+	skcipher_request_set_crypt(&rctx->fallback_req, areq->src, areq->dst,
+				   areq->cryptlen, areq->iv);
+	if (rctx->op_dir == CE_DECRYPTION)
+		err = crypto_skcipher_decrypt(&rctx->fallback_req);
+	else
+		err = crypto_skcipher_encrypt(&rctx->fallback_req);
+	return err;
+}
+
+static int sl3516_ce_cipher(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sl3516_ce_dev *ce = op->ce;
+	struct sl3516_ce_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct sl3516_ce_alg_template *algt;
+	struct scatterlist *sg;
+	unsigned int todo, len;
+	struct pkt_control_ecb *ecb;
+	int nr_sgs = 0;
+	int nr_sgd = 0;
+	int err = 0;
+	int i;
+
+	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher);
+
+	dev_dbg(ce->dev, "%s %s %u %x IV(%p %u) key=%u\n", __func__,
+		crypto_tfm_alg_name(areq->base.tfm),
+		areq->cryptlen,
+		rctx->op_dir, areq->iv, crypto_skcipher_ivsize(tfm),
+		op->keylen);
+
+	algt->stat_req++;
+
+	if (areq->src == areq->dst) {
+		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
+				    DMA_BIDIRECTIONAL);
+		if (nr_sgs <= 0 || nr_sgs > MAXDESC / 2) {
+			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
+			err = -EINVAL;
+			goto theend;
+		}
+		nr_sgd = nr_sgs;
+	} else {
+		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
+				    DMA_TO_DEVICE);
+		if (nr_sgs <= 0 || nr_sgs > MAXDESC / 2) {
+			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
+			err = -EINVAL;
+			goto theend;
+		}
+		nr_sgd = dma_map_sg(ce->dev, areq->dst, sg_nents(areq->dst),
+				    DMA_FROM_DEVICE);
+		if (nr_sgd <= 0 || nr_sgd > MAXDESC) {
+			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgd);
+			err = -EINVAL;
+			goto theend_sgs;
+		}
+	}
+
+	len = areq->cryptlen;
+	i = 0;
+	sg = areq->src;
+	while (i < nr_sgs && sg && len) {
+		if (sg_dma_len(sg) == 0)
+			goto sgs_next;
+		rctx->t_src[i].addr = sg_dma_address(sg);
+		todo = min(len, sg_dma_len(sg));
+		rctx->t_src[i].len = todo;
+		dev_dbg(ce->dev, "%s total=%u SGS(%d %u off=%d) todo=%u\n", __func__,
+			areq->cryptlen, i, rctx->t_src[i].len, sg->offset, todo);
+		len -= todo;
+		i++;
+sgs_next:
+		sg = sg_next(sg);
+	}
+	if (len > 0) {
+		dev_err(ce->dev, "remaining len %d/%u nr_sgs=%d\n", len, areq->cryptlen, nr_sgs);
+		err = -EINVAL;
+		goto theend_sgs;
+	}
+
+	len = areq->cryptlen;
+	i = 0;
+	sg = areq->dst;
+	while (i < nr_sgd && sg && len) {
+		if (sg_dma_len(sg) == 0)
+			goto sgd_next;
+		rctx->t_dst[i].addr = sg_dma_address(sg);
+		todo = min(len, sg_dma_len(sg));
+		rctx->t_dst[i].len = todo;
+		dev_dbg(ce->dev, "%s total=%u SGD(%d %u off=%d) todo=%u\n", __func__,
+			areq->cryptlen, i, rctx->t_dst[i].len, sg->offset, todo);
+		len -= todo;
+		i++;
+
+sgd_next:
+		sg = sg_next(sg);
+	}
+	if (len > 0) {
+		dev_err(ce->dev, "remaining len %d\n", len);
+		err = -EINVAL;
+		goto theend_sgs;
+	}
+
+	switch (algt->mode) {
+	case ECB_AES:
+		rctx->pctrllen = sizeof(struct pkt_control_ecb);
+		ecb = (struct pkt_control_ecb *)ce->pctrl;
+
+		rctx->tqflag = TQ0_TYPE_CTRL;
+		rctx->tqflag |= TQ1_CIPHER;
+		ecb->control.op_mode = rctx->op_dir;
+		ecb->control.cipher_algorithm = ECB_AES;
+		ecb->cipher.header_len = 0;
+		ecb->cipher.algorithm_len = areq->cryptlen;
+		cpu_to_be32_array((__be32 *)ecb->key, (u32 *)op->key, op->keylen / 4);
+		rctx->h = &ecb->cipher;
+
+		rctx->tqflag |= TQ4_KEY0;
+		rctx->tqflag |= TQ5_KEY4;
+		rctx->tqflag |= TQ6_KEY6;
+		ecb->control.aesnk = op->keylen / 4;
+		break;
+	}
+
+	rctx->nr_sgs = nr_sgs;
+	rctx->nr_sgd = nr_sgd;
+	err = sl3516_ce_run_task(ce, rctx, crypto_tfm_alg_name(areq->base.tfm));
+
+theend_sgs:
+	if (areq->src == areq->dst) {
+		dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
+			     DMA_BIDIRECTIONAL);
+	} else {
+		dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
+			     DMA_TO_DEVICE);
+		dma_unmap_sg(ce->dev, areq->dst, sg_nents(areq->dst),
+			     DMA_FROM_DEVICE);
+	}
+
+theend:
+
+	return err;
+}
+
+static int sl3516_ce_handle_cipher_request(struct crypto_engine *engine, void *areq)
+{
+	int err;
+	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
+
+	err = sl3516_ce_cipher(breq);
+	crypto_finalize_skcipher_request(engine, breq, err);
+
+	return 0;
+}
+
+int sl3516_ce_skdecrypt(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sl3516_ce_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
+	struct crypto_engine *engine;
+
+	memset(rctx, 0, sizeof(struct sl3516_ce_cipher_req_ctx));
+	rctx->op_dir = CE_DECRYPTION;
+
+	if (sl3516_ce_need_fallback(areq))
+		return sl3516_ce_cipher_fallback(areq);
+
+	engine = op->ce->engine;
+
+	return crypto_transfer_skcipher_request_to_engine(engine, areq);
+}
+
+int sl3516_ce_skencrypt(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sl3516_ce_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
+	struct crypto_engine *engine;
+
+	memset(rctx, 0, sizeof(struct sl3516_ce_cipher_req_ctx));
+	rctx->op_dir = CE_ENCRYPTION;
+
+	if (sl3516_ce_need_fallback(areq))
+		return sl3516_ce_cipher_fallback(areq);
+
+	engine = op->ce->engine;
+
+	return crypto_transfer_skcipher_request_to_engine(engine, areq);
+}
+
+int sl3516_ce_cipher_init(struct crypto_tfm *tfm)
+{
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	struct sl3516_ce_alg_template *algt;
+	const char *name = crypto_tfm_alg_name(tfm);
+	struct crypto_skcipher *sktfm = __crypto_skcipher_cast(tfm);
+	struct skcipher_alg *alg = crypto_skcipher_alg(sktfm);
+	int err;
+
+	memset(op, 0, sizeof(struct sl3516_ce_cipher_tfm_ctx));
+
+	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher);
+	op->ce = algt->ce;
+
+	op->fallback_tfm = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(op->fallback_tfm)) {
+		dev_err(op->ce->dev, "ERROR: Cannot allocate fallback for %s %ld\n",
+			name, PTR_ERR(op->fallback_tfm));
+		return PTR_ERR(op->fallback_tfm);
+	}
+
+	sktfm->reqsize = sizeof(struct sl3516_ce_cipher_req_ctx) +
+			 crypto_skcipher_reqsize(op->fallback_tfm);
+
+	dev_info(op->ce->dev, "Fallback for %s is %s\n",
+		 crypto_tfm_alg_driver_name(&sktfm->base),
+		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)));
+
+	op->enginectx.op.do_one_request = sl3516_ce_handle_cipher_request;
+	op->enginectx.op.prepare_request = NULL;
+	op->enginectx.op.unprepare_request = NULL;
+
+	err = pm_runtime_get_sync(op->ce->dev);
+	if (err < 0)
+		goto error_pm;
+
+	return 0;
+error_pm:
+	pm_runtime_put_noidle(op->ce->dev);
+	crypto_free_skcipher(op->fallback_tfm);
+	return err;
+}
+
+void sl3516_ce_cipher_exit(struct crypto_tfm *tfm)
+{
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
+
+	kfree_sensitive(op->key);
+	crypto_free_skcipher(op->fallback_tfm);
+	pm_runtime_put_sync_suspend(op->ce->dev);
+}
+
+int sl3516_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			 unsigned int keylen)
+{
+	struct sl3516_ce_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sl3516_ce_dev *ce = op->ce;
+
+	switch (keylen) {
+	case 128 / 8:
+		break;
+	case 192 / 8:
+		break;
+	case 256 / 8:
+		break;
+	default:
+		dev_dbg(ce->dev, "ERROR: Invalid keylen %u\n", keylen);
+		return -EINVAL;
+	}
+	kfree_sensitive(op->key);
+	op->keylen = keylen;
+	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
+	if (!op->key)
+		return -ENOMEM;
+
+	crypto_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
+
+	return crypto_skcipher_setkey(op->fallback_tfm, key, keylen);
+}
diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
new file mode 100644
index 000000000000..9fa1b366ca8a
--- /dev/null
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -0,0 +1,535 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sl3516-ce-core.c - hardware cryptographic offloader for Stormlink SL3516 SoC
+ *
+ * Copyright (C) 2021 Corentin Labbe <clabbe@baylibre.com>
+ *
+ * Core file which registers crypto algorithms supported by the CryptoEngine
+ */
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/debugfs.h>
+#include <linux/dev_printk.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/reset.h>
+#include <crypto/internal/rng.h>
+#include <crypto/internal/skcipher.h>
+
+#include "sl3516-ce.h"
+
+static int sl3516_ce_desc_init(struct sl3516_ce_dev *ce)
+{
+	const size_t sz = sizeof(struct descriptor) * MAXDESC;
+	int i;
+
+	ce->tx = dma_alloc_coherent(ce->dev, sz, &ce->dtx, GFP_KERNEL);
+	if (!ce->tx)
+		return -ENOMEM;
+	ce->rx = dma_alloc_coherent(ce->dev, sz, &ce->drx, GFP_KERNEL);
+	if (!ce->rx)
+		goto err_rx;
+
+	for (i = 0; i < MAXDESC; i++) {
+		ce->tx[i].frame_ctrl.bits.own = CE_CPU;
+		ce->tx[i].next_desc.next_descriptor = ce->dtx + (i + 1) * sizeof(struct descriptor);
+	}
+	ce->tx[MAXDESC - 1].next_desc.next_descriptor = ce->dtx;
+
+	for (i = 0; i < MAXDESC; i++) {
+		ce->rx[i].frame_ctrl.bits.own = CE_CPU;
+		ce->rx[i].next_desc.next_descriptor = ce->drx + (i + 1) * sizeof(struct descriptor);
+	}
+	ce->rx[MAXDESC - 1].next_desc.next_descriptor = ce->drx;
+
+	ce->pctrl = dma_alloc_coherent(ce->dev, sizeof(struct pkt_control_ecb),
+				       &ce->dctrl, GFP_KERNEL);
+	if (!ce->pctrl)
+		goto err_pctrl;
+
+	return 0;
+err_pctrl:
+	dma_free_coherent(ce->dev, sz, ce->rx, ce->drx);
+err_rx:
+	dma_free_coherent(ce->dev, sz, ce->tx, ce->dtx);
+	return -ENOMEM;
+}
+
+static void sl3516_ce_free_descs(struct sl3516_ce_dev *ce)
+{
+	const size_t sz = sizeof(struct descriptor) * MAXDESC;
+
+	dma_free_coherent(ce->dev, sz, ce->tx, ce->dtx);
+	dma_free_coherent(ce->dev, sz, ce->rx, ce->drx);
+	dma_free_coherent(ce->dev, sizeof(struct pkt_control_ecb), ce->pctrl,
+			  ce->dctrl);
+}
+
+static void start_dma_tx(struct sl3516_ce_dev *ce)
+{
+	u32 v;
+
+	v = TXDMA_CTRL_START | TXDMA_CTRL_CHAIN_MODE | TXDMA_CTRL_CONTINUE | \
+		TXDMA_CTRL_INT_FAIL | TXDMA_CTRL_INT_PERR | TXDMA_CTRL_BURST_UNK;
+
+	writel(v, ce->base + IPSEC_TXDMA_CTRL);
+}
+
+static void start_dma_rx(struct sl3516_ce_dev *ce)
+{
+	u32 v;
+
+	v = RXDMA_CTRL_START | RXDMA_CTRL_CHAIN_MODE | RXDMA_CTRL_CONTINUE | \
+		RXDMA_CTRL_BURST_UNK | RXDMA_CTRL_INT_FINISH | \
+		RXDMA_CTRL_INT_FAIL | RXDMA_CTRL_INT_PERR | \
+		RXDMA_CTRL_INT_EOD | RXDMA_CTRL_INT_EOF;
+
+	writel(v, ce->base + IPSEC_RXDMA_CTRL);
+}
+
+static struct descriptor *get_desc_tx(struct sl3516_ce_dev *ce)
+{
+	struct descriptor *dd;
+
+	dd = &ce->tx[ce->ctx];
+	ce->ctx++;
+	if (ce->ctx >= MAXDESC)
+		ce->ctx = 0;
+	return dd;
+}
+
+static struct descriptor *get_desc_rx(struct sl3516_ce_dev *ce)
+{
+	struct descriptor *rdd;
+
+	rdd = &ce->rx[ce->crx];
+	ce->crx++;
+	if (ce->crx >= MAXDESC)
+		ce->crx = 0;
+	return rdd;
+}
+
+int sl3516_ce_run_task(struct sl3516_ce_dev *ce, struct sl3516_ce_cipher_req_ctx *rctx,
+		       const char *name)
+{
+	struct descriptor *dd, *rdd = NULL;
+	u32 v;
+	int i, err = 0;
+
+	ce->stat_req++;
+
+	reinit_completion(&ce->complete);
+	ce->status = 0;
+
+	for (i = 0; i < rctx->nr_sgd; i++) {
+		dev_dbg(ce->dev, "%s handle DST SG %d/%d len=%d\n", __func__,
+			i, rctx->nr_sgd, rctx->t_dst[i].len);
+		rdd = get_desc_rx(ce);
+		rdd->buf_adr = rctx->t_dst[i].addr;
+		rdd->frame_ctrl.bits.buffer_size = rctx->t_dst[i].len;
+		rdd->frame_ctrl.bits.own = CE_DMA;
+	}
+	rdd->next_desc.bits.eofie = 1;
+
+	for (i = 0; i < rctx->nr_sgs; i++) {
+		dev_dbg(ce->dev, "%s handle SRC SG %d/%d len=%d\n", __func__,
+			i, rctx->nr_sgs, rctx->t_src[i].len);
+		rctx->h->algorithm_len = rctx->t_src[i].len;
+
+		dd = get_desc_tx(ce);
+		dd->frame_ctrl.raw = 0;
+		dd->flag_status.raw = 0;
+		dd->frame_ctrl.bits.buffer_size = rctx->pctrllen;
+		dd->buf_adr = ce->dctrl;
+		dd->flag_status.tx_flag.tqflag = rctx->tqflag;
+		dd->next_desc.bits.eofie = 0;
+		dd->next_desc.bits.dec = 0;
+		dd->next_desc.bits.sof_eof = DESC_FIRST | DESC_LAST;
+		dd->frame_ctrl.bits.own = CE_DMA;
+
+		dd = get_desc_tx(ce);
+		dd->frame_ctrl.raw = 0;
+		dd->flag_status.raw = 0;
+		dd->frame_ctrl.bits.buffer_size = rctx->t_src[i].len;
+		dd->buf_adr = rctx->t_src[i].addr;
+		dd->flag_status.tx_flag.tqflag = 0;
+		dd->next_desc.bits.eofie = 0;
+		dd->next_desc.bits.dec = 0;
+		dd->next_desc.bits.sof_eof = DESC_FIRST | DESC_LAST;
+		dd->frame_ctrl.bits.own = CE_DMA;
+		start_dma_tx(ce);
+		start_dma_rx(ce);
+	}
+	wait_for_completion_interruptible_timeout(&ce->complete,
+						  msecs_to_jiffies(5000));
+	if (ce->status == 0) {
+		dev_err(ce->dev, "DMA timeout for %s\n", name);
+		err = -EFAULT;
+	}
+	v = readl(ce->base + IPSEC_STATUS_REG);
+	if (v & 0xFFF) {
+		dev_err(ce->dev, "IPSEC_STATUS_REG %x\n", v);
+		err = -EFAULT;
+	}
+
+	return err;
+}
+
+static irqreturn_t ce_irq_handler(int irq, void *data)
+{
+	struct sl3516_ce_dev *ce = (struct sl3516_ce_dev *)data;
+	u32 v;
+
+	ce->stat_irq++;
+
+	v = readl(ce->base + IPSEC_DMA_STATUS);
+	writel(v, ce->base + IPSEC_DMA_STATUS);
+
+	if (v & DMA_STATUS_TS_DERR)
+		dev_err(ce->dev, "AHB bus Error While Tx !!!\n");
+	if (v & DMA_STATUS_TS_PERR)
+		dev_err(ce->dev, "Tx Descriptor Protocol Error !!!\n");
+	if (v & DMA_STATUS_RS_DERR)
+		dev_err(ce->dev, "AHB bus Error While Rx !!!\n");
+	if (v & DMA_STATUS_RS_PERR)
+		dev_err(ce->dev, "Rx Descriptor Protocol Error !!!\n");
+
+	if (v & DMA_STATUS_TS_EOFI)
+		ce->stat_irq_tx++;
+	if (v & DMA_STATUS_RS_EOFI) {
+		ce->status = 1;
+		complete(&ce->complete);
+		ce->stat_irq_rx++;
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct sl3516_ce_alg_template ce_algs[] = {
+{
+	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+	.mode = ECB_AES,
+	.alg.skcipher = {
+		.base = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "ecb-aes-sl3516",
+			.cra_priority = 400,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			.cra_ctxsize = sizeof(struct sl3516_ce_cipher_tfm_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 0xf,
+			.cra_init = sl3516_ce_cipher_init,
+			.cra_exit = sl3516_ce_cipher_exit,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= sl3516_ce_aes_setkey,
+		.encrypt	= sl3516_ce_skencrypt,
+		.decrypt	= sl3516_ce_skdecrypt,
+	}
+},
+};
+
+#ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
+static int sl3516_ce_debugfs_show(struct seq_file *seq, void *v)
+{
+	struct sl3516_ce_dev *ce = seq->private;
+	unsigned int i;
+
+	seq_printf(seq, "HWRNG %lu %lu\n",
+		   ce->hwrng_stat_req, ce->hwrng_stat_bytes);
+	seq_printf(seq, "IRQ %lu\n", ce->stat_irq);
+	seq_printf(seq, "IRQ TX %lu\n", ce->stat_irq_tx);
+	seq_printf(seq, "IRQ RX %lu\n", ce->stat_irq_rx);
+	seq_printf(seq, "nreq %lu\n", ce->stat_req);
+	seq_printf(seq, "fallback SG count TX %lu\n", ce->fallback_sg_count_tx);
+	seq_printf(seq, "fallback SG count RX %lu\n", ce->fallback_sg_count_rx);
+	seq_printf(seq, "fallback modulo16 %lu\n", ce->fallback_mod16);
+	seq_printf(seq, "fallback align16 %lu\n", ce->fallback_align16);
+	seq_printf(seq, "fallback not same len %lu\n", ce->fallback_not_same_len);
+
+	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
+		if (!ce_algs[i].ce)
+			continue;
+		switch (ce_algs[i].type) {
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
+				   ce_algs[i].alg.skcipher.base.cra_driver_name,
+				   ce_algs[i].alg.skcipher.base.cra_name,
+				   ce_algs[i].stat_req, ce_algs[i].stat_fb);
+			break;
+		}
+	}
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(sl3516_ce_debugfs);
+#endif
+
+static int sl3516_ce_register_algs(struct sl3516_ce_dev *ce)
+{
+	int err;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
+		ce_algs[i].ce = ce;
+		switch (ce_algs[i].type) {
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			dev_info(ce->dev, "DEBUG: Register %s\n",
+				 ce_algs[i].alg.skcipher.base.cra_name);
+			err = crypto_register_skcipher(&ce_algs[i].alg.skcipher);
+			if (err) {
+				dev_err(ce->dev, "Fail to register %s\n",
+					ce_algs[i].alg.skcipher.base.cra_name);
+				ce_algs[i].ce = NULL;
+				return err;
+			}
+			break;
+		default:
+			ce_algs[i].ce = NULL;
+			dev_err(ce->dev, "ERROR: tried to register an unknown algo\n");
+		}
+	}
+	return 0;
+}
+
+static void sl3516_ce_unregister_algs(struct sl3516_ce_dev *ce)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
+		if (!ce_algs[i].ce)
+			continue;
+		switch (ce_algs[i].type) {
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			dev_info(ce->dev, "Unregister %d %s\n", i,
+				 ce_algs[i].alg.skcipher.base.cra_name);
+			crypto_unregister_skcipher(&ce_algs[i].alg.skcipher);
+			break;
+		}
+	}
+}
+
+static void sl3516_ce_start(struct sl3516_ce_dev *ce)
+{
+	ce->ctx = 0;
+	ce->crx = 0;
+	writel(ce->dtx, ce->base + IPSEC_TXDMA_CURR_DESC);
+	writel(ce->drx, ce->base + IPSEC_RXDMA_CURR_DESC);
+	writel(0, ce->base + IPSEC_DMA_STATUS);
+}
+
+/*
+ * Power management strategy: The device is suspended unless a TFM exists for
+ * one of the algorithms proposed by this driver.
+ */
+static int sl3516_ce_pm_suspend(struct device *dev)
+{
+	struct sl3516_ce_dev *ce = dev_get_drvdata(dev);
+
+	reset_control_assert(ce->reset);
+	clk_disable_unprepare(ce->clks);
+	return 0;
+}
+
+static int sl3516_ce_pm_resume(struct device *dev)
+{
+	struct sl3516_ce_dev *ce = dev_get_drvdata(dev);
+	int err;
+
+	err = clk_prepare_enable(ce->clks);
+	if (err) {
+		dev_err(ce->dev, "Cannot prepare_enable\n");
+		goto error;
+	}
+	err = reset_control_deassert(ce->reset);
+	if (err) {
+		dev_err(ce->dev, "Cannot deassert reset control\n");
+		goto error;
+	}
+
+	sl3516_ce_start(ce);
+
+	return 0;
+error:
+	sl3516_ce_pm_suspend(dev);
+	return err;
+}
+
+static const struct dev_pm_ops sl3516_ce_pm_ops = {
+	SET_RUNTIME_PM_OPS(sl3516_ce_pm_suspend, sl3516_ce_pm_resume, NULL)
+};
+
+static int sl3516_ce_pm_init(struct sl3516_ce_dev *ce)
+{
+	int err;
+
+	pm_runtime_use_autosuspend(ce->dev);
+	pm_runtime_set_autosuspend_delay(ce->dev, 2000);
+
+	err = pm_runtime_set_suspended(ce->dev);
+	if (err)
+		return err;
+	pm_runtime_enable(ce->dev);
+	return err;
+}
+
+static void sl3516_ce_pm_exit(struct sl3516_ce_dev *ce)
+{
+	pm_runtime_disable(ce->dev);
+}
+
+static int sl3516_ce_probe(struct platform_device *pdev)
+{
+	struct sl3516_ce_dev *ce;
+	int err, irq;
+	u32 v;
+
+	ce = devm_kzalloc(&pdev->dev, sizeof(*ce), GFP_KERNEL);
+	if (!ce)
+		return -ENOMEM;
+
+	ce->dev = &pdev->dev;
+	platform_set_drvdata(pdev, ce);
+
+	ce->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(ce->base))
+		return PTR_ERR(ce->base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	err = devm_request_irq(&pdev->dev, irq, ce_irq_handler, 0, "crypto", ce);
+	if (err) {
+		dev_err(ce->dev, "Cannot request Crypto Engine IRQ (err=%d)\n", err);
+		return err;
+	}
+
+	ce->reset = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(ce->reset))
+		return dev_err_probe(&pdev->dev, PTR_ERR(ce->reset),
+				     "No reset control found\n");
+	ce->clks = devm_clk_get(ce->dev, NULL);
+	if (IS_ERR(ce->clks)) {
+		err = PTR_ERR(ce->clks);
+		dev_err(ce->dev, "Cannot get clock err=%d\n", err);
+		return err;
+	}
+
+	err = sl3516_ce_desc_init(ce);
+	if (err)
+		return err;
+
+	err = sl3516_ce_pm_init(ce);
+	if (err)
+		goto error_pm;
+
+	init_completion(&ce->complete);
+
+	ce->engine = crypto_engine_alloc_init(ce->dev, true);
+	if (!ce->engine) {
+		dev_err(ce->dev, "Cannot allocate engine\n");
+		err = -ENOMEM;
+		goto error_engine;
+	}
+
+	err = crypto_engine_start(ce->engine);
+	if (err) {
+		dev_err(ce->dev, "Cannot start engine\n");
+		goto error_engine;
+	}
+
+	err = sl3516_ce_register_algs(ce);
+	if (err)
+		goto error_alg;
+
+	err = sl3516_ce_rng_register(ce);
+	if (err)
+		goto error_rng;
+
+	err = pm_runtime_resume_and_get(ce->dev);
+	if (err < 0)
+		goto error_pmuse;
+
+	v = readl(ce->base + IPSEC_ID);
+	dev_info(ce->dev, "SL3516 dev %lx rev %lx\n",
+		 v & GENMASK(31, 4),
+		 v & GENMASK(3, 0));
+	v = readl(ce->base + IPSEC_DMA_DEVICE_ID);
+	dev_info(ce->dev, "SL3516 DMA dev %lx rev %lx\n",
+		 v & GENMASK(15, 4),
+		 v & GENMASK(3, 0));
+
+	pm_runtime_put_sync(ce->dev);
+
+#ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
+	/* Ignore error of debugfs */
+	ce->dbgfs_dir = debugfs_create_dir("sl3516", NULL);
+	ce->dbgfs_stats = debugfs_create_file("stats", 0444,
+					      ce->dbgfs_dir, ce,
+					      &sl3516_ce_debugfs_fops);
+#endif
+
+	return 0;
+error_pmuse:
+	sl3516_ce_rng_unregister(ce);
+error_rng:
+	sl3516_ce_unregister_algs(ce);
+error_alg:
+	crypto_engine_exit(ce->engine);
+error_engine:
+	sl3516_ce_pm_exit(ce);
+error_pm:
+	sl3516_ce_free_descs(ce);
+	return err;
+}
+
+static int sl3516_ce_remove(struct platform_device *pdev)
+{
+	struct sl3516_ce_dev *ce = platform_get_drvdata(pdev);
+
+	sl3516_ce_rng_unregister(ce);
+	sl3516_ce_unregister_algs(ce);
+	crypto_engine_exit(ce->engine);
+	sl3516_ce_pm_exit(ce);
+	sl3516_ce_free_descs(ce);
+
+#ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
+	debugfs_remove_recursive(ce->dbgfs_dir);
+#endif
+
+	return 0;
+}
+
+static const struct of_device_id sl3516_ce_crypto_of_match_table[] = {
+	{ .compatible = "cortina,sl3516-crypto"},
+	{}
+};
+MODULE_DEVICE_TABLE(of, sl3516_ce_crypto_of_match_table);
+
+static struct platform_driver sl3516_ce_driver = {
+	.probe		 = sl3516_ce_probe,
+	.remove		 = sl3516_ce_remove,
+	.driver		 = {
+		.name		= "sl3516-crypto",
+		.pm		= &sl3516_ce_pm_ops,
+		.of_match_table	= sl3516_ce_crypto_of_match_table,
+	},
+};
+
+module_platform_driver(sl3516_ce_driver);
+
+MODULE_DESCRIPTION("SL3516 cryptographic offloader");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin Labbe <clabbe@baylibre.com>");
diff --git a/drivers/crypto/gemini/sl3516-ce-rng.c b/drivers/crypto/gemini/sl3516-ce-rng.c
new file mode 100644
index 000000000000..76931ec1cec5
--- /dev/null
+++ b/drivers/crypto/gemini/sl3516-ce-rng.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sl3516-ce-rng.c - hardware cryptographic offloader for SL3516 SoC.
+ *
+ * Copyright (C) 2021 Corentin Labbe <clabbe@baylibre.com>
+ *
+ * This file handle the RNG found in the SL3516 crypto engine
+ */
+#include "sl3516-ce.h"
+#include <linux/pm_runtime.h>
+#include <linux/hw_random.h>
+
+static int sl3516_ce_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct sl3516_ce_dev *ce;
+	u32 *data = buf;
+	size_t read = 0;
+	int err;
+
+	ce = container_of(rng, struct sl3516_ce_dev, trng);
+
+#ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
+	ce->hwrng_stat_req++;
+	ce->hwrng_stat_bytes += max;
+#endif
+
+	err = pm_runtime_get_sync(ce->dev);
+	if (err < 0) {
+		pm_runtime_put_noidle(ce->dev);
+		return err;
+	}
+
+	while (read < max) {
+		*data = readl(ce->base + IPSEC_RAND_NUM_REG);
+		data++;
+		read += 4;
+	}
+
+	pm_runtime_put(ce->dev);
+
+	return read;
+}
+
+int sl3516_ce_rng_register(struct sl3516_ce_dev *ce)
+{
+	int ret;
+
+	ce->trng.name = "SL3516 Crypto Engine RNG";
+	ce->trng.read = sl3516_ce_rng_read;
+	ce->trng.quality = 700;
+
+	ret = hwrng_register(&ce->trng);
+	if (ret)
+		dev_err(ce->dev, "Fail to register the RNG\n");
+	return ret;
+}
+
+void sl3516_ce_rng_unregister(struct sl3516_ce_dev *ce)
+{
+	hwrng_unregister(&ce->trng);
+}
diff --git a/drivers/crypto/gemini/sl3516-ce.h b/drivers/crypto/gemini/sl3516-ce.h
new file mode 100644
index 000000000000..911309b81e10
--- /dev/null
+++ b/drivers/crypto/gemini/sl3516-ce.h
@@ -0,0 +1,349 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * sl3516-ce.h - hardware cryptographic offloader for cortina/gemini SoC
+ *
+ * Copyright (C) 2021 Corentin LABBE <clabbe@baylibre.com>
+ *
+ * General notes on this driver:
+ * Called either Crypto Acceleration Engine Module, Security Acceleration Engine
+ * or IPSEC module in the datasheet, it will be called Crypto Engine for short
+ * in this driver.
+ * The CE was designed to handle IPSEC and wifi(TKIP WEP) protocol.
+ * It can handle AES, DES, 3DES, MD5, WEP, TKIP, SHA1, HMAC(MD5), HMAC(SHA1),
+ * Michael cipher/digest suites.
+ * It acts the same as a network hw, with both RX and TX chained descriptors.
+ */
+#include <crypto/aes.h>
+#include <crypto/engine.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
+#include <linux/crypto.h>
+#include <linux/debugfs.h>
+#include <linux/hw_random.h>
+
+#define TQ0_TYPE_DATA 0
+#define TQ0_TYPE_CTRL BIT(0)
+#define TQ1_CIPHER BIT(1)
+#define TQ2_AUTH BIT(2)
+#define TQ3_IV BIT(3)
+#define TQ4_KEY0 BIT(4)
+#define TQ5_KEY4 BIT(5)
+#define TQ6_KEY6 BIT(6)
+#define TQ7_AKEY0 BIT(7)
+#define TQ8_AKEY2 BIT(8)
+#define TQ9_AKEY2 BIT(9)
+
+#define ECB_AES       0x2
+
+#define DESC_LAST 0x01
+#define DESC_FIRST 0x02
+
+#define IPSEC_ID		0x0000
+#define IPSEC_STATUS_REG	0x00a8
+#define IPSEC_RAND_NUM_REG	0x00ac
+#define IPSEC_DMA_DEVICE_ID	0xff00
+#define IPSEC_DMA_STATUS	0xff04
+#define IPSEC_TXDMA_CTRL	0xff08
+#define IPSEC_TXDMA_FIRST_DESC	0xff0c
+#define IPSEC_TXDMA_CURR_DESC	0xff10
+#define IPSEC_RXDMA_CTRL	0xff14
+#define IPSEC_RXDMA_FIRST_DESC	0xff18
+#define IPSEC_RXDMA_CURR_DESC	0xff1c
+#define IPSEC_TXDMA_BUF_ADDR	0xff28
+#define IPSEC_RXDMA_BUF_ADDR	0xff38
+#define IPSEC_RXDMA_BUF_SIZE	0xff30
+
+#define CE_ENCRYPTION		0x01
+#define CE_DECRYPTION		0x03
+
+#define MAXDESC 6
+
+#define DMA_STATUS_RS_EOFI	BIT(22)
+#define DMA_STATUS_RS_PERR	BIT(24)
+#define DMA_STATUS_RS_DERR	BIT(25)
+#define DMA_STATUS_TS_EOFI	BIT(27)
+#define DMA_STATUS_TS_PERR	BIT(29)
+#define DMA_STATUS_TS_DERR	BIT(30)
+
+#define TXDMA_CTRL_START BIT(31)
+#define TXDMA_CTRL_CONTINUE BIT(30)
+#define TXDMA_CTRL_CHAIN_MODE BIT(29)
+/* the burst value is not documented in the datasheet */
+#define TXDMA_CTRL_BURST_UNK BIT(22)
+#define TXDMA_CTRL_INT_FAIL BIT(17)
+#define TXDMA_CTRL_INT_PERR BIT(16)
+
+#define RXDMA_CTRL_START BIT(31)
+#define RXDMA_CTRL_CONTINUE BIT(30)
+#define RXDMA_CTRL_CHAIN_MODE BIT(29)
+/* the burst value is not documented in the datasheet */
+#define RXDMA_CTRL_BURST_UNK BIT(22)
+#define RXDMA_CTRL_INT_FINISH BIT(18)
+#define RXDMA_CTRL_INT_FAIL BIT(17)
+#define RXDMA_CTRL_INT_PERR BIT(16)
+#define RXDMA_CTRL_INT_EOD BIT(15)
+#define RXDMA_CTRL_INT_EOF BIT(14)
+
+#define CE_CPU 0
+#define CE_DMA 1
+
+/*
+ * struct sl3516_ce_descriptor - descriptor for CE operations
+ * @frame_ctrl:		Information for the current descriptor
+ * @flag_status:	For send packet, describe flag of operations.
+ * @buf_adr:		pointer to a send/recv buffer for data packet
+ * @next_desc:		control linking to other descriptors
+ */
+struct descriptor {
+	union {
+		u32 raw;
+		/*
+		 * struct desc_frame_ctrl - Information for the current descriptor
+		 * @buffer_size:	the size of buffer at buf_adr
+		 * @desc_count:		Upon completion of a DMA operation, DMA
+		 *			write the number of descriptors used
+		 *			for the current frame
+		 * @checksum:		unknown
+		 * @authcomp:		unknown
+		 * @perr:		Protocol error during processing this descriptor
+		 * @derr:		Data error during processing this descriptor
+		 * @own:		0 if owned by CPU, 1 for DMA
+		 */
+		struct desc_frame_ctrl {
+			u32 buffer_size	:16;
+			u32 desc_count	:6;
+			u32 checksum	:6;
+			u32 authcomp	:1;
+			u32 perr	:1;
+			u32 derr	:1;
+			u32 own		:1;
+		} bits;
+	} frame_ctrl;
+
+	union {
+		u32 raw;
+		/*
+		 * struct desc_flag_status - flag for this descriptor
+		 * @tqflag:	list of flag describing the type of operation
+		 *		to be performed.
+		 */
+		struct desc_tx_flag_status {
+			u32 tqflag	:10;
+			u32 unused	:22;
+		} tx_flag;
+	} flag_status;
+
+	u32 buf_adr;
+
+	union {
+		u32 next_descriptor;
+		/*
+		 * struct desc_next - describe chaining of descriptors
+		 * @sof_eof:	does the descriptor is first (0x11),
+		 *		the last (0x01), middle of a chan (0x00)
+		 *		or the only one (0x11)
+		 * @dec:	AHB bus address increase (0), decrease (1)
+		 * @eofie:	End of frame interrupt enable
+		 * @ndar:	Next descriptor address
+		 */
+		struct desc_next {
+			u32 sof_eof	:2;
+			u32 dec		:1;
+			u32 eofie	:1;
+			u32 ndar	:28;
+		} bits;
+	} next_desc;
+};
+
+/*
+ * struct control - The value of this register is used to set the
+ *			operation mode of the IPSec Module.
+ * @process_id:		Used to identify the process. The number will be copied
+ *			to the descriptor status of the received packet.
+ * @auth_check_len:	Number of 32-bit words to be checked or appended by the
+ *			authentication module
+ * @auth_algorithm:
+ * @auth_mode:		0:append 1:Check Authentication Result
+ * @fcs_stream_copy:	0:enable 1:disable authentication stream copy
+ * @mix_key_sel:	0:use rCipherKey0-3  1:use Key Mixer
+ * @aesnk:		AES Key Size
+ * @cipher_algorithm:	choice of CBC/ECE and AES/DES/3DES
+ * @op_mode:		Operation Mode for the IPSec Module
+ */
+struct pkt_control_header {
+	u32 process_id		:8;
+	u32 auth_check_len	:3;
+	u32 un1			:1;
+	u32 auth_algorithm	:3;
+	u32 auth_mode		:1;
+	u32 fcs_stream_copy	:1;
+	u32 un2			:2;
+	u32 mix_key_sel		:1;
+	u32 aesnk		:4;
+	u32 cipher_algorithm	:3;
+	u32 un3			:1;
+	u32 op_mode		:4;
+};
+
+struct pkt_control_cipher {
+	u32 algorithm_len	:16;
+	u32 header_len		:16;
+};
+
+/*
+ * struct pkt_control_ecb - control packet for ECB
+ */
+struct pkt_control_ecb {
+	struct pkt_control_header control;
+	struct pkt_control_cipher cipher;
+	unsigned char key[AES_MAX_KEY_SIZE];
+};
+
+/*
+ * struct sl3516_ce_dev - main container for all this driver information
+ * @base:	base address
+ * @clks:	clocks used
+ * @reset:	pointer to reset controller
+ * @dev:	the platform device
+ * @engine:	ptr to the crypto/crypto_engine
+ * @complete:	completion for the current task on this flow
+ * @status:	set to 1 by interrupt if task is done
+ * @dtx:	base DMA address for TX descriptors
+ * @tx		base address of TX descriptors
+ * @drx:	base DMA address for RX descriptors
+ * @rx		base address of RX descriptors
+ * @ctx		current used TX descriptor
+ * @crx		current used RX descriptor
+ * @trng	hw_random structure for RNG
+ * @hwrng_stat_req	number of HWRNG requests
+ * @hwrng_stat_bytes	total number of bytes generated by RNG
+ * @stat_irq	number of IRQ handled by CE
+ * @stat_irq_tx	number of TX IRQ handled by CE
+ * @stat_irq_rx	number of RX IRQ handled by CE
+ * @stat_req	number of requests handled by CE
+ * @fallbak_sg_count_tx		number of fallback due to destination SG count
+ * @fallbak_sg_count_rx		number of fallback due to source SG count
+ * @fallbak_not_same_len	number of fallback due to difference in SG length
+ * @dbgfs_dir:	Debugfs dentry for statistic directory
+ * @dbgfs_stats: Debugfs dentry for statistic counters
+ */
+struct sl3516_ce_dev {
+	void __iomem *base;
+	struct clk *clks;
+	struct reset_control *reset;
+	struct device *dev;
+	struct crypto_engine *engine;
+	struct completion complete;
+	int status;
+	dma_addr_t dtx;
+	struct descriptor *tx;
+	dma_addr_t drx;
+	struct descriptor *rx;
+	int ctx;
+	int crx;
+	struct hwrng trng;
+	unsigned long hwrng_stat_req;
+	unsigned long hwrng_stat_bytes;
+	unsigned long stat_irq;
+	unsigned long stat_irq_tx;
+	unsigned long stat_irq_rx;
+	unsigned long stat_req;
+	unsigned long fallback_sg_count_tx;
+	unsigned long fallback_sg_count_rx;
+	unsigned long fallback_not_same_len;
+	unsigned long fallback_mod16;
+	unsigned long fallback_align16;
+#ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
+	struct dentry *dbgfs_dir;
+	struct dentry *dbgfs_stats;
+#endif
+	void *pctrl;
+	dma_addr_t dctrl;
+};
+
+struct sginfo {
+	u32 addr;
+	u32 len;
+};
+
+/*
+ * struct sl3516_ce_cipher_req_ctx - context for a skcipher request
+ * @t_src:		list of mapped SGs with their size
+ * @t_dst:		list of mapped SGs with their size
+ * @op_dir:		direction (encrypt vs decrypt) for this request
+ * @pctrllen:		the length of the ctrl packet
+ * @tqflag:		the TQflag to set in data packet
+ * @h			pointer to the pkt_control_cipher header
+ * @nr_sgs:		number of source SG
+ * @nr_sgd:		number of destination SG
+ * @fallback_req:	request struct for invoking the fallback skcipher TFM
+ */
+struct sl3516_ce_cipher_req_ctx {
+	struct sginfo t_src[MAXDESC];
+	struct sginfo t_dst[MAXDESC];
+	u32 op_dir;
+	unsigned int pctrllen;
+	u32 tqflag;
+	struct pkt_control_cipher *h;
+	int nr_sgs;
+	int nr_sgd;
+	struct skcipher_request fallback_req;   // keep at the end
+};
+
+/*
+ * struct sl3516_ce_cipher_tfm_ctx - context for a skcipher TFM
+ * @enginectx:		crypto_engine used by this TFM
+ * @key:		pointer to key data
+ * @keylen:		len of the key
+ * @ce:			pointer to the private data of driver handling this TFM
+ * @fallback_tfm:	pointer to the fallback TFM
+ *
+ * enginectx must be the first element
+ */
+struct sl3516_ce_cipher_tfm_ctx {
+	struct crypto_engine_ctx enginectx;
+	u32 *key;
+	u32 keylen;
+	struct sl3516_ce_dev *ce;
+	struct crypto_skcipher *fallback_tfm;
+};
+
+/*
+ * struct sl3516_ce_alg_template - crypto_alg template
+ * @type:		the CRYPTO_ALG_TYPE for this template
+ * @mode:		value to be used in control packet for this algorithm
+ * @ce:			pointer to the sl3516_ce_dev structure associated with
+ *			this template
+ * @alg:		one of sub struct must be used
+ * @stat_req:		number of request done on this template
+ * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
+ */
+struct sl3516_ce_alg_template {
+	u32 type;
+	u32 mode;
+	struct sl3516_ce_dev *ce;
+	union {
+		struct skcipher_alg skcipher;
+	} alg;
+#ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
+	unsigned long stat_req;
+	unsigned long stat_fb;
+	unsigned long stat_bytes;
+#endif
+};
+
+int sl3516_ce_enqueue(struct crypto_async_request *areq, u32 type);
+
+int sl3516_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			 unsigned int keylen);
+int sl3516_ce_cipher_init(struct crypto_tfm *tfm);
+void sl3516_ce_cipher_exit(struct crypto_tfm *tfm);
+int sl3516_ce_skdecrypt(struct skcipher_request *areq);
+int sl3516_ce_skencrypt(struct skcipher_request *areq);
+
+int sl3516_ce_run_task(struct sl3516_ce_dev *ce,
+		       struct sl3516_ce_cipher_req_ctx *rctx, const char *name);
+
+int sl3516_ce_rng_register(struct sl3516_ce_dev *ce);
+void sl3516_ce_rng_unregister(struct sl3516_ce_dev *ce);
-- 
2.26.3

