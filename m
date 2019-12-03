Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D779C432C3
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54D1D206EC
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tfHrWx0E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfLCQYX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:24:23 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43698 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfLCQYU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 11:24:20 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so1875452pgq.10;
        Tue, 03 Dec 2019 08:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=csJknXoAEAep/w6gJ0VcZdy3jBlPD/zGz+DMoQC1qmc=;
        b=tfHrWx0EEMC12Q+upcbJ8j8p6BUgA8DlNk9q4TxqDTDOG1qE5ucC6crb+mV63Mo+dE
         2XG0sXsHLwDCJhYKowU6D3OjRV9ULkiJ6mtFYQhHqaIsCjh4iJByv2tyQX57+BTyUC2G
         csBmJCemsNfyYn0A+j82xSrfN2qMXHo4D34TxxAhRvDgVUgGO482ecud6dso36DPqwLm
         M9sHW0V5abbrj9h6YJyqCG/O+6n4dM60ZBzYt1op7ZlS2gGrh2P+WisvW32Fq6AO7YnZ
         U9vMxkQl0dmlxvcR8DUykLhk+U1jWPTUsXebEhuh72ZExRfbbOTOSJBbX1zwSQdwTdKF
         PHPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=csJknXoAEAep/w6gJ0VcZdy3jBlPD/zGz+DMoQC1qmc=;
        b=IP3i2Xr/ibw7I0zajefyIzF+kpf9nRayd2LogKTAAkU8lB/ETjrri/4BPdinjuJk/Y
         iuF3UPnvUCcWeHoyEZaKDcQFulCUXNLvjTSPLe7wh/YVCzD2Z6SXMIrYoJ8Nltx1CD0V
         oFgmDMWS2jdSMjth4a3qxR6m94YB981joTRAN/En1qZ0QHrOin1xijJDbpGbEY0a9DdT
         /43Z2u8KgWWkBjQ7KlqEeEB10raz/5v7QkmRQ2LPo/f+ZEXfo48zr36PXmYgonziwORF
         K4T6Y46QZEhaskv7D8mIV5QXpyKcgD0dOl5f5ARsCsrskVCX/nz+KvLye0xArmESqIza
         an4Q==
X-Gm-Message-State: APjAAAUkXF4g7wrG28DXSOLJlW13H5mquu0pTpcesN4kV5ejgvqhR+hG
        tZmqy4okRAGN8hEQD7bslluXx/rPD0Q=
X-Google-Smtp-Source: APXvYqxwtIphqp9JNec8mvInyqwbrXKalS/a+XiFGTj0wT65SWmKvpgrlPtWsd4BUZnVLOTUB7QUig==
X-Received: by 2002:a65:56c9:: with SMTP id w9mr6027699pgs.296.1575390259304;
        Tue, 03 Dec 2019 08:24:19 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id g10sm4052093pgh.35.2019.12.03.08.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:24:18 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/4] crypto: caam - expose SEC4 DRNG via crypto RNG API
Date:   Tue,  3 Dec 2019 08:23:57 -0800
Message-Id: <20191203162357.21942-5-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203162357.21942-1-andrew.smirnov@gmail.com>
References: <20191203162357.21942-1-andrew.smirnov@gmail.com>
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
Tested-by: Chris Healy <cphealy@gmail.com>
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
 drivers/crypto/caam/drng.c   | 174 +++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/intern.h |  13 +++
 drivers/crypto/caam/jr.c     |   1 +
 5 files changed, 197 insertions(+)
 create mode 100644 drivers/crypto/caam/drng.c

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 31ecf165bc03..b6d9f3caa9ba 100644
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
index 000000000000..88b13a54e90f
--- /dev/null
+++ b/drivers/crypto/caam/drng.c
@@ -0,0 +1,174 @@
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
+		init_job_desc(desc, 0);
+		/* Generate random bytes */
+		append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
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
+		.cra_name = "stdrng",
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

