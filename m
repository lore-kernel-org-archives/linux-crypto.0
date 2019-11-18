Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC6AC432C3
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EB7E21A46
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="paoK1bSy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKRPjR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 10:39:17 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43303 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbfKRPjR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 10:39:17 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so323162pgq.10;
        Mon, 18 Nov 2019 07:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nxVu6jtA8AokWDkx0sh9PMR+Vf8gqiLuOYYBOFYUbUI=;
        b=paoK1bSyBmaR478X5wtbVD1sMaRCe3xDBzY5GaROJUIXUfcXnnQY0YlcFgPQS9v1xE
         ypA+dKOqLMGnJD27Rw2p9dk+ZVp4sv2Cs+csBb9IL2C+S+4+5TKXhQZpxy87L5rKQ4Vs
         snO4iqOvYPtnO/vn4ysMKI49mRyQf1ZWUsKV/9SoauEkC04Jxgxmh8iAJRlDDmOgEoj2
         SHMxPCvMLY3DXDzMwWJCDGWVk7YSUvYT479Y0EYaQzZs5+2mJxRLZ4G0hbZ65U/ziXjN
         6XJ/C+e7V+s6Oyhu5RDOlYlNxemb4bafA9/WZajA3ix5SOnO/04P/yOBhubz3LjX4TZn
         zatg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nxVu6jtA8AokWDkx0sh9PMR+Vf8gqiLuOYYBOFYUbUI=;
        b=eTLJl9IGBHqtut8CKzTXuPp+QRJ64YgGJ69m8BHCAz0XVGLfeDjzLWOgLwjTka2Ua/
         Bj8OTyO0WUwWyeojOTQiYJOC8wl5opiIi+EVJ5XUIoLbrlscnLafARhF9OtyfcDTkS4B
         k4s5lhx+YMIPTl/puEKsr+gVDFUepS+3A4QUTAo/iPJkcjVE/HtgdhyH34KFhYWMOLuN
         6+onJUOH+FuLnJcvFjAeqIscKdSoAwDw/0shrwmCMvZd3swFmMLYXMOCQSJsvBtBu1gA
         Y1bP6/U5gHbNjHrVf0g1qstHu+ucwLzrPuY5FxOCrVSUiXNcSzXBUiSmiLOVPZP0Zeuv
         Dlng==
X-Gm-Message-State: APjAAAUZ56zVxfZAx66lXfl8Tu8u5KA4HL89Dqtf05kDGDXUR/wnRkMd
        K/NwTnq5XzryKenoT3E3cF4La/lI
X-Google-Smtp-Source: APXvYqxnJe1hUOWvhUxaZOItcJOGk4eZQLs8/gUxLtC6ubS6Enqy4Q08rPmkl4jzdzDg1cnmJWsRpQ==
X-Received: by 2002:a62:545:: with SMTP id 66mr34016944pff.1.1574091555794;
        Mon, 18 Nov 2019 07:39:15 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id z7sm23573732pfr.165.2019.11.18.07.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 07:39:14 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] crypto: caam - expose SEC4 DRNG via crypto RNG API
Date:   Mon, 18 Nov 2019 07:38:43 -0800
Message-Id: <20191118153843.28136-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118153843.28136-1-andrew.smirnov@gmail.com>
References: <20191118153843.28136-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose SEC4 DRNG IP block using crypto RNG API so it could be used
both by kernel and userspace code.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/Kconfig  |   8 ++
 drivers/crypto/caam/Makefile |   1 +
 drivers/crypto/caam/drng.c   | 175 +++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/intern.h |  13 +++
 drivers/crypto/caam/jr.c     |   1 +
 5 files changed, 198 insertions(+)
 create mode 100644 drivers/crypto/caam/drng.c

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 22116a8e2ff3..11a8f9c02448 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -146,6 +146,14 @@ config CRYPTO_DEV_FSL_CAAM_PKC_API
           Supported cryptographic primitives: encryption, decryption,
           signature and verification.
 
+config CRYPTO_DEV_FSL_CAAM_DRNG_API
+	bool "Register caam device for hwrng API"
+	default y
+	select CRYPTO_RNG
+	help
+	  Selecting this will register the SEC4 DRNG to
+	  the crypto RNG API.
+
 endif # CRYPTO_DEV_FSL_CAAM_JR
 
 endif # CRYPTO_DEV_FSL_CAAM
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 04884fc087f9..02b7ed8823ce 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -20,6 +20,7 @@ caam_jr-y := jr.o key_gen.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
+caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_DRNG_API) += drng.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caampkc.o pkc_desc.o
 
 caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += qi.o
diff --git a/drivers/crypto/caam/drng.c b/drivers/crypto/caam/drng.c
new file mode 100644
index 000000000000..75dbe4abdaa3
--- /dev/null
+++ b/drivers/crypto/caam/drng.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver to expose SEC4 DRNG via crypto RNG API
+ *
+ * Copyright 2019 Zodiac Inflight Innovations
+ *
+ * Based on CAAM SEC4 hw_random driver
+ *
+ * Copyright 2011 Freescale Semiconductor, Inc.
+ * Copyright 2018-2019 NXP
+ *
+ * Based on caamalg.c crypto API driver.
+ *
+ */
+
+#include <linux/completion.h>
+#include <linux/atomic.h>
+
+#include <crypto/internal/rng.h>
+
+#include "compat.h"
+
+#include "regs.h"
+#include "intern.h"
+#include "desc_constr.h"
+#include "jr.h"
+#include "error.h"
+
+#define CAAM_DRNG_MAX_FIFO_STORE_SIZE	((unsigned int)U16_MAX)
+
+/* rng per-device context */
+struct caam_drng_ctx {
+	struct device *jrdev;
+	struct completion done;
+};
+
+static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
+{
+	struct caam_drng_ctx *ctx = context;
+
+	if (err)
+		caam_jr_strstatus(jrdev, err);
+
+	complete(&ctx->done);
+}
+
+static int caam_drng_generate(struct crypto_rng *tfm,
+			     const u8 *src, unsigned int slen,
+			     u8 *dst, unsigned int dlen)
+{
+	struct caam_drng_ctx *ctx = crypto_rng_ctx(tfm);
+	struct device *jrdev = ctx->jrdev;
+	unsigned int residue = dlen;
+	dma_addr_t dst_dma, cur_dma;
+	u32 *desc;
+	int ret;
+
+	desc = kzalloc(5 * CAAM_CMD_SZ + CAAM_PTR_SZ_MAX,
+		       GFP_KERNEL | GFP_DMA);
+	if (!desc)
+		return -ENOMEM;
+
+	cur_dma = dst_dma = dma_map_single(jrdev, dst, dlen, DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, dst_dma)) {
+		dev_err(jrdev, "unable to map destination memory\n");
+		ret = -ENOMEM;
+		goto free_mem;
+	}
+
+	do {
+		const unsigned int chunk = min(residue,
+					       CAAM_DRNG_MAX_FIFO_STORE_SIZE);
+
+		init_job_desc(desc, 0);	/* 1 word */
+		/* Generate random bytes */
+		append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
+				 OP_ALG_PR_ON); /* 1 word */
+		/* Store bytes */
+		append_seq_out_ptr_intlen(desc, cur_dma, chunk, 0);
+		append_seq_fifo_store(desc, chunk, FIFOST_TYPE_RNGSTORE);
+
+		print_hex_dump_debug("rng job desc@: ", DUMP_PREFIX_ADDRESS,
+				     16, 4, desc, desc_bytes(desc), 1);
+
+		init_completion(&ctx->done);
+		ret = caam_jr_enqueue(jrdev, desc, rng_done, ctx);
+		if (ret)
+			break;
+
+		wait_for_completion(&ctx->done);
+
+		cur_dma += chunk;
+		residue -= chunk;
+	} while (residue);
+
+	dma_unmap_single(jrdev, dst_dma, dlen, DMA_FROM_DEVICE);
+free_mem:
+	kfree(desc);
+	return ret;
+}
+
+static int caam_drng_init(struct crypto_tfm *tfm)
+{
+	struct caam_drng_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ctx->jrdev = caam_jr_alloc();
+	ret = PTR_ERR_OR_ZERO(ctx->jrdev);
+	if (ret) {
+		pr_err("Job Ring Device allocation for transform failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void caam_drng_exit(struct crypto_tfm *tfm)
+{
+	struct caam_drng_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	caam_jr_free(ctx->jrdev);
+}
+
+static int caam_drng_seed(struct crypto_rng *tfm,
+			 const u8 *seed, unsigned int slen)
+{
+	return 0;
+}
+
+static struct rng_alg caam_drng_alg = {
+	.generate = caam_drng_generate,
+	.seed = caam_drng_seed,
+	.seedsize = 0,
+	.base = {
+		.cra_name = "drng-caam",
+		.cra_driver_name = "drng-caam",
+		.cra_priority = 300,
+		.cra_ctxsize = sizeof(struct caam_drng_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_init = caam_drng_init,
+		.cra_exit = caam_drng_exit,
+	},
+};
+
+static void caam_drng_unregister(void *data)
+{
+	crypto_unregister_rng(&caam_drng_alg);
+}
+
+int caam_drng_register(struct device *ctrldev)
+{
+	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
+
+	if (caam_has_rng(priv)) {
+		int ret;
+
+		ret = crypto_register_rng(&caam_drng_alg);
+		if (ret) {
+			dev_err(ctrldev,
+				"couldn't register rng crypto alg: %d\n",
+				ret);
+			return ret;
+		}
+
+		ret = devm_add_action_or_reset(ctrldev, caam_drng_unregister,
+					       NULL);
+		if (ret)
+			return ret;
+
+		dev_info(ctrldev,
+			 "registering %s\n", caam_drng_alg.base.cra_name);
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 54bb04aa86bd..0c81eefd13a9 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -185,6 +185,19 @@ static inline int caam_trng_register(struct device *dev)
 
 #endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API */
 
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_DRNG_API
+
+int caam_drng_register(struct device *dev);
+
+#else
+
+static inline int caam_drng_register(struct device *dev)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_DRNG_API */
+
 #ifdef CONFIG_CAAM_QI
 
 int caam_qi_algapi_init(struct device *dev);
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index c745b7044fe6..e68ba0606e3f 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -38,6 +38,7 @@ static void register_algs(struct device *dev)
 	caam_algapi_hash_init(dev);
 	caam_pkc_init(dev);
 	caam_qi_algapi_init(dev);
+	caam_drng_register(dev);
 
 algs_unlock:
 	mutex_unlock(&algs_lock);
-- 
2.21.0

