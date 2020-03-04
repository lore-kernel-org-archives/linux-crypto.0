Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210FBC3F2CD
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 12:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895CA2166E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 12:26:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Fy6MVALb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387919AbgCDM0P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 07:26:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41836 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729118AbgCDM0O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 07:26:14 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024CB5TM030954;
        Wed, 4 Mar 2020 04:25:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=RtdanAeexJ7YC9x0WXX5Ui9/O0EsxtYQZTcDOgGCu/U=;
 b=Fy6MVALb+WpMWu+eogLhlpv9XxKBAPnxgKNRfIx1EwKDbuRk4c4yIvBD7iekp2V42ybA
 jkgxfuyoAtam11/liVUNshn/nvpffHsSrPPOa8/d6AS+Vj2rHoL/vYxdXEi/191IfEpl
 IrCoGF0W8qd2bqjtTq6VVvmLKiKLsWh3SxGFJCy+lt9JHycO0djQnWBuo+XTJ+3u5KS1
 Y4vO0s9+d1jzX3vchvAlz3G8/ktsLQPmpK1QAd/pMQnFz+Ft7eyCGnefJAA5j23P9V6I
 4rN+gMbMW8Cf6F02RAHGaSslcuLq0n1OjgBVKC1f6oRuhNpyDKNK6xGsEwh1eT31WRIV rA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yhn0xy9jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Mar 2020 04:25:37 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Mar
 2020 04:25:33 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 4 Mar 2020 04:25:33 -0800
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 01FB73F7041;
        Wed,  4 Mar 2020 04:25:30 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <pathreya@marvell.com>, SrujanaChalla <schalla@marvell.com>
Subject: [PATCH 1/4] drivers: crypto: create common Kconfig and Makefile for Marvell
Date:   Wed, 4 Mar 2020 17:55:13 +0530
Message-ID: <1583324716-23633-2-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1583324716-23633-1-git-send-email-schalla@marvell.com>
References: <1583324716-23633-1-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_03:2020-03-04,2020-03-04 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: SrujanaChalla <schalla@marvell.com>

Creats common Kconfig and Makefile for Marvell crypto drivers.

Signed-off-by: SrujanaChalla <schalla@marvell.com>
---
 drivers/crypto/Kconfig               |   15 +-
 drivers/crypto/Makefile              |    2 +-
 drivers/crypto/marvell/Kconfig       |   21 +
 drivers/crypto/marvell/Makefile      |    6 +-
 drivers/crypto/marvell/cesa.c        |  615 ---------------
 drivers/crypto/marvell/cesa.h        |  880 ---------------------
 drivers/crypto/marvell/cesa/Makefile |    3 +
 drivers/crypto/marvell/cesa/cesa.c   |  615 +++++++++++++++
 drivers/crypto/marvell/cesa/cesa.h   |  881 +++++++++++++++++++++
 drivers/crypto/marvell/cesa/cipher.c |  801 +++++++++++++++++++
 drivers/crypto/marvell/cesa/hash.c   | 1448 ++++++++++++++++++++++++++++++++++
 drivers/crypto/marvell/cesa/tdma.c   |  352 +++++++++
 drivers/crypto/marvell/cipher.c      |  798 -------------------
 drivers/crypto/marvell/hash.c        | 1442 ---------------------------------
 drivers/crypto/marvell/tdma.c        |  350 --------
 15 files changed, 4126 insertions(+), 4103 deletions(-)
 create mode 100644 drivers/crypto/marvell/Kconfig
 delete mode 100644 drivers/crypto/marvell/cesa.c
 delete mode 100644 drivers/crypto/marvell/cesa.h
 create mode 100644 drivers/crypto/marvell/cesa/Makefile
 create mode 100644 drivers/crypto/marvell/cesa/cesa.c
 create mode 100644 drivers/crypto/marvell/cesa/cesa.h
 create mode 100644 drivers/crypto/marvell/cesa/cipher.c
 create mode 100644 drivers/crypto/marvell/cesa/hash.c
 create mode 100644 drivers/crypto/marvell/cesa/tdma.c
 delete mode 100644 drivers/crypto/marvell/cipher.c
 delete mode 100644 drivers/crypto/marvell/hash.c
 delete mode 100644 drivers/crypto/marvell/tdma.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index c2767ed..a829f94 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -233,20 +233,6 @@ config CRYPTO_CRC32_S390
 
 	  It is available with IBM z13 or later.
 
-config CRYPTO_DEV_MARVELL_CESA
-	tristate "Marvell's Cryptographic Engine driver"
-	depends on PLAT_ORION || ARCH_MVEBU
-	select CRYPTO_LIB_AES
-	select CRYPTO_LIB_DES
-	select CRYPTO_SKCIPHER
-	select CRYPTO_HASH
-	select SRAM
-	help
-	  This driver allows you to utilize the Cryptographic Engines and
-	  Security Accelerator (CESA) which can be found on MVEBU and ORION
-	  platforms.
-	  This driver supports CPU offload through DMA transfers.
-
 config CRYPTO_DEV_NIAGARA2
 	tristate "Niagara2 Stream Processing Unit driver"
 	select CRYPTO_LIB_DES
@@ -606,6 +592,7 @@ config CRYPTO_DEV_MXS_DCP
 source "drivers/crypto/qat/Kconfig"
 source "drivers/crypto/cavium/cpt/Kconfig"
 source "drivers/crypto/cavium/nitrox/Kconfig"
+source "drivers/crypto/marvell/Kconfig"
 
 config CRYPTO_DEV_CAVIUM_ZIP
 	tristate "Cavium ZIP driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 40229d4..2306d41 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_IMGTEC_HASH) += img-hash.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
-obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += marvell/
+obj-$(CONFIG_CRYPTO_DEV_MARVELL) += marvell/
 obj-$(CONFIG_CRYPTO_DEV_MEDIATEK) += mediatek/
 obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) += mxs-dcp.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
new file mode 100644
index 0000000..9f09845
--- /dev/null
+++ b/drivers/crypto/marvell/Kconfig
@@ -0,0 +1,21 @@
+#
+# Marvell crypto drivers configuration
+#
+
+config CRYPTO_DEV_MARVELL
+	tristate
+
+config CRYPTO_DEV_MARVELL_CESA
+	tristate "Marvell's Cryptographic Engine driver"
+	depends on PLAT_ORION || ARCH_MVEBU
+	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_DES
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_HASH
+	select SRAM
+	select CRYPTO_DEV_MARVELL
+	help
+	  This driver allows you to utilize the Cryptographic Engines and
+	  Security Accelerator (CESA) which can be found on MVEBU and ORION
+	  platforms.
+	  This driver supports CPU offload through DMA transfers.
diff --git a/drivers/crypto/marvell/Makefile b/drivers/crypto/marvell/Makefile
index b27cab6..2030b0b 100644
--- a/drivers/crypto/marvell/Makefile
+++ b/drivers/crypto/marvell/Makefile
@@ -1,3 +1,3 @@
-# SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += marvell-cesa.o
-marvell-cesa-objs := cesa.o cipher.o hash.o tdma.o
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += cesa/
diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
deleted file mode 100644
index 8a5f0b0..0000000
--- a/drivers/crypto/marvell/cesa.c
+++ /dev/null
@@ -1,615 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Support for Marvell's Cryptographic Engine and Security Accelerator (CESA)
- * that can be found on the following platform: Orion, Kirkwood, Armada. This
- * driver supports the TDMA engine on platforms on which it is available.
- *
- * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
- * Author: Arnaud Ebalard <arno@natisbad.org>
- *
- * This work is based on an initial version written by
- * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
- */
-
-#include <linux/delay.h>
-#include <linux/dma-mapping.h>
-#include <linux/genalloc.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/kthread.h>
-#include <linux/mbus.h>
-#include <linux/platform_device.h>
-#include <linux/scatterlist.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/clk.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_irq.h>
-
-#include "cesa.h"
-
-/* Limit of the crypto queue before reaching the backlog */
-#define CESA_CRYPTO_DEFAULT_MAX_QLEN 128
-
-struct mv_cesa_dev *cesa_dev;
-
-struct crypto_async_request *
-mv_cesa_dequeue_req_locked(struct mv_cesa_engine *engine,
-			   struct crypto_async_request **backlog)
-{
-	struct crypto_async_request *req;
-
-	*backlog = crypto_get_backlog(&engine->queue);
-	req = crypto_dequeue_request(&engine->queue);
-
-	if (!req)
-		return NULL;
-
-	return req;
-}
-
-static void mv_cesa_rearm_engine(struct mv_cesa_engine *engine)
-{
-	struct crypto_async_request *req = NULL, *backlog = NULL;
-	struct mv_cesa_ctx *ctx;
-
-
-	spin_lock_bh(&engine->lock);
-	if (!engine->req) {
-		req = mv_cesa_dequeue_req_locked(engine, &backlog);
-		engine->req = req;
-	}
-	spin_unlock_bh(&engine->lock);
-
-	if (!req)
-		return;
-
-	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
-
-	ctx = crypto_tfm_ctx(req->tfm);
-	ctx->ops->step(req);
-}
-
-static int mv_cesa_std_process(struct mv_cesa_engine *engine, u32 status)
-{
-	struct crypto_async_request *req;
-	struct mv_cesa_ctx *ctx;
-	int res;
-
-	req = engine->req;
-	ctx = crypto_tfm_ctx(req->tfm);
-	res = ctx->ops->process(req, status);
-
-	if (res == 0) {
-		ctx->ops->complete(req);
-		mv_cesa_engine_enqueue_complete_request(engine, req);
-	} else if (res == -EINPROGRESS) {
-		ctx->ops->step(req);
-	}
-
-	return res;
-}
-
-static int mv_cesa_int_process(struct mv_cesa_engine *engine, u32 status)
-{
-	if (engine->chain.first && engine->chain.last)
-		return mv_cesa_tdma_process(engine, status);
-
-	return mv_cesa_std_process(engine, status);
-}
-
-static inline void
-mv_cesa_complete_req(struct mv_cesa_ctx *ctx, struct crypto_async_request *req,
-		     int res)
-{
-	ctx->ops->cleanup(req);
-	local_bh_disable();
-	req->complete(req, res);
-	local_bh_enable();
-}
-
-static irqreturn_t mv_cesa_int(int irq, void *priv)
-{
-	struct mv_cesa_engine *engine = priv;
-	struct crypto_async_request *req;
-	struct mv_cesa_ctx *ctx;
-	u32 status, mask;
-	irqreturn_t ret = IRQ_NONE;
-
-	while (true) {
-		int res;
-
-		mask = mv_cesa_get_int_mask(engine);
-		status = readl(engine->regs + CESA_SA_INT_STATUS);
-
-		if (!(status & mask))
-			break;
-
-		/*
-		 * TODO: avoid clearing the FPGA_INT_STATUS if this not
-		 * relevant on some platforms.
-		 */
-		writel(~status, engine->regs + CESA_SA_FPGA_INT_STATUS);
-		writel(~status, engine->regs + CESA_SA_INT_STATUS);
-
-		/* Process fetched requests */
-		res = mv_cesa_int_process(engine, status & mask);
-		ret = IRQ_HANDLED;
-
-		spin_lock_bh(&engine->lock);
-		req = engine->req;
-		if (res != -EINPROGRESS)
-			engine->req = NULL;
-		spin_unlock_bh(&engine->lock);
-
-		ctx = crypto_tfm_ctx(req->tfm);
-
-		if (res && res != -EINPROGRESS)
-			mv_cesa_complete_req(ctx, req, res);
-
-		/* Launch the next pending request */
-		mv_cesa_rearm_engine(engine);
-
-		/* Iterate over the complete queue */
-		while (true) {
-			req = mv_cesa_engine_dequeue_complete_request(engine);
-			if (!req)
-				break;
-
-			ctx = crypto_tfm_ctx(req->tfm);
-			mv_cesa_complete_req(ctx, req, 0);
-		}
-	}
-
-	return ret;
-}
-
-int mv_cesa_queue_req(struct crypto_async_request *req,
-		      struct mv_cesa_req *creq)
-{
-	int ret;
-	struct mv_cesa_engine *engine = creq->engine;
-
-	spin_lock_bh(&engine->lock);
-	ret = crypto_enqueue_request(&engine->queue, req);
-	if ((mv_cesa_req_get_type(creq) == CESA_DMA_REQ) &&
-	    (ret == -EINPROGRESS || ret == -EBUSY))
-		mv_cesa_tdma_chain(engine, creq);
-	spin_unlock_bh(&engine->lock);
-
-	if (ret != -EINPROGRESS)
-		return ret;
-
-	mv_cesa_rearm_engine(engine);
-
-	return -EINPROGRESS;
-}
-
-static int mv_cesa_add_algs(struct mv_cesa_dev *cesa)
-{
-	int ret;
-	int i, j;
-
-	for (i = 0; i < cesa->caps->ncipher_algs; i++) {
-		ret = crypto_register_skcipher(cesa->caps->cipher_algs[i]);
-		if (ret)
-			goto err_unregister_crypto;
-	}
-
-	for (i = 0; i < cesa->caps->nahash_algs; i++) {
-		ret = crypto_register_ahash(cesa->caps->ahash_algs[i]);
-		if (ret)
-			goto err_unregister_ahash;
-	}
-
-	return 0;
-
-err_unregister_ahash:
-	for (j = 0; j < i; j++)
-		crypto_unregister_ahash(cesa->caps->ahash_algs[j]);
-	i = cesa->caps->ncipher_algs;
-
-err_unregister_crypto:
-	for (j = 0; j < i; j++)
-		crypto_unregister_skcipher(cesa->caps->cipher_algs[j]);
-
-	return ret;
-}
-
-static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
-{
-	int i;
-
-	for (i = 0; i < cesa->caps->nahash_algs; i++)
-		crypto_unregister_ahash(cesa->caps->ahash_algs[i]);
-
-	for (i = 0; i < cesa->caps->ncipher_algs; i++)
-		crypto_unregister_skcipher(cesa->caps->cipher_algs[i]);
-}
-
-static struct skcipher_alg *orion_cipher_algs[] = {
-	&mv_cesa_ecb_des_alg,
-	&mv_cesa_cbc_des_alg,
-	&mv_cesa_ecb_des3_ede_alg,
-	&mv_cesa_cbc_des3_ede_alg,
-	&mv_cesa_ecb_aes_alg,
-	&mv_cesa_cbc_aes_alg,
-};
-
-static struct ahash_alg *orion_ahash_algs[] = {
-	&mv_md5_alg,
-	&mv_sha1_alg,
-	&mv_ahmac_md5_alg,
-	&mv_ahmac_sha1_alg,
-};
-
-static struct skcipher_alg *armada_370_cipher_algs[] = {
-	&mv_cesa_ecb_des_alg,
-	&mv_cesa_cbc_des_alg,
-	&mv_cesa_ecb_des3_ede_alg,
-	&mv_cesa_cbc_des3_ede_alg,
-	&mv_cesa_ecb_aes_alg,
-	&mv_cesa_cbc_aes_alg,
-};
-
-static struct ahash_alg *armada_370_ahash_algs[] = {
-	&mv_md5_alg,
-	&mv_sha1_alg,
-	&mv_sha256_alg,
-	&mv_ahmac_md5_alg,
-	&mv_ahmac_sha1_alg,
-	&mv_ahmac_sha256_alg,
-};
-
-static const struct mv_cesa_caps orion_caps = {
-	.nengines = 1,
-	.cipher_algs = orion_cipher_algs,
-	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
-	.ahash_algs = orion_ahash_algs,
-	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
-	.has_tdma = false,
-};
-
-static const struct mv_cesa_caps kirkwood_caps = {
-	.nengines = 1,
-	.cipher_algs = orion_cipher_algs,
-	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
-	.ahash_algs = orion_ahash_algs,
-	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
-	.has_tdma = true,
-};
-
-static const struct mv_cesa_caps armada_370_caps = {
-	.nengines = 1,
-	.cipher_algs = armada_370_cipher_algs,
-	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
-	.ahash_algs = armada_370_ahash_algs,
-	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
-	.has_tdma = true,
-};
-
-static const struct mv_cesa_caps armada_xp_caps = {
-	.nengines = 2,
-	.cipher_algs = armada_370_cipher_algs,
-	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
-	.ahash_algs = armada_370_ahash_algs,
-	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
-	.has_tdma = true,
-};
-
-static const struct of_device_id mv_cesa_of_match_table[] = {
-	{ .compatible = "marvell,orion-crypto", .data = &orion_caps },
-	{ .compatible = "marvell,kirkwood-crypto", .data = &kirkwood_caps },
-	{ .compatible = "marvell,dove-crypto", .data = &kirkwood_caps },
-	{ .compatible = "marvell,armada-370-crypto", .data = &armada_370_caps },
-	{ .compatible = "marvell,armada-xp-crypto", .data = &armada_xp_caps },
-	{ .compatible = "marvell,armada-375-crypto", .data = &armada_xp_caps },
-	{ .compatible = "marvell,armada-38x-crypto", .data = &armada_xp_caps },
-	{}
-};
-MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
-
-static void
-mv_cesa_conf_mbus_windows(struct mv_cesa_engine *engine,
-			  const struct mbus_dram_target_info *dram)
-{
-	void __iomem *iobase = engine->regs;
-	int i;
-
-	for (i = 0; i < 4; i++) {
-		writel(0, iobase + CESA_TDMA_WINDOW_CTRL(i));
-		writel(0, iobase + CESA_TDMA_WINDOW_BASE(i));
-	}
-
-	for (i = 0; i < dram->num_cs; i++) {
-		const struct mbus_dram_window *cs = dram->cs + i;
-
-		writel(((cs->size - 1) & 0xffff0000) |
-		       (cs->mbus_attr << 8) |
-		       (dram->mbus_dram_target_id << 4) | 1,
-		       iobase + CESA_TDMA_WINDOW_CTRL(i));
-		writel(cs->base, iobase + CESA_TDMA_WINDOW_BASE(i));
-	}
-}
-
-static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
-{
-	struct device *dev = cesa->dev;
-	struct mv_cesa_dev_dma *dma;
-
-	if (!cesa->caps->has_tdma)
-		return 0;
-
-	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
-	if (!dma)
-		return -ENOMEM;
-
-	dma->tdma_desc_pool = dmam_pool_create("tdma_desc", dev,
-					sizeof(struct mv_cesa_tdma_desc),
-					16, 0);
-	if (!dma->tdma_desc_pool)
-		return -ENOMEM;
-
-	dma->op_pool = dmam_pool_create("cesa_op", dev,
-					sizeof(struct mv_cesa_op_ctx), 16, 0);
-	if (!dma->op_pool)
-		return -ENOMEM;
-
-	dma->cache_pool = dmam_pool_create("cesa_cache", dev,
-					   CESA_MAX_HASH_BLOCK_SIZE, 1, 0);
-	if (!dma->cache_pool)
-		return -ENOMEM;
-
-	dma->padding_pool = dmam_pool_create("cesa_padding", dev, 72, 1, 0);
-	if (!dma->padding_pool)
-		return -ENOMEM;
-
-	cesa->dma = dma;
-
-	return 0;
-}
-
-static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
-{
-	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
-	struct mv_cesa_engine *engine = &cesa->engines[idx];
-	const char *res_name = "sram";
-	struct resource *res;
-
-	engine->pool = of_gen_pool_get(cesa->dev->of_node,
-				       "marvell,crypto-srams", idx);
-	if (engine->pool) {
-		engine->sram = gen_pool_dma_alloc(engine->pool,
-						  cesa->sram_size,
-						  &engine->sram_dma);
-		if (engine->sram)
-			return 0;
-
-		engine->pool = NULL;
-		return -ENOMEM;
-	}
-
-	if (cesa->caps->nengines > 1) {
-		if (!idx)
-			res_name = "sram0";
-		else
-			res_name = "sram1";
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-					   res_name);
-	if (!res || resource_size(res) < cesa->sram_size)
-		return -EINVAL;
-
-	engine->sram = devm_ioremap_resource(cesa->dev, res);
-	if (IS_ERR(engine->sram))
-		return PTR_ERR(engine->sram);
-
-	engine->sram_dma = dma_map_resource(cesa->dev, res->start,
-					    cesa->sram_size,
-					    DMA_BIDIRECTIONAL, 0);
-	if (dma_mapping_error(cesa->dev, engine->sram_dma))
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
-{
-	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
-	struct mv_cesa_engine *engine = &cesa->engines[idx];
-
-	if (engine->pool)
-		gen_pool_free(engine->pool, (unsigned long)engine->sram,
-			      cesa->sram_size);
-	else
-		dma_unmap_resource(cesa->dev, engine->sram_dma,
-				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
-}
-
-static int mv_cesa_probe(struct platform_device *pdev)
-{
-	const struct mv_cesa_caps *caps = &orion_caps;
-	const struct mbus_dram_target_info *dram;
-	const struct of_device_id *match;
-	struct device *dev = &pdev->dev;
-	struct mv_cesa_dev *cesa;
-	struct mv_cesa_engine *engines;
-	struct resource *res;
-	int irq, ret, i;
-	u32 sram_size;
-
-	if (cesa_dev) {
-		dev_err(&pdev->dev, "Only one CESA device authorized\n");
-		return -EEXIST;
-	}
-
-	if (dev->of_node) {
-		match = of_match_node(mv_cesa_of_match_table, dev->of_node);
-		if (!match || !match->data)
-			return -ENOTSUPP;
-
-		caps = match->data;
-	}
-
-	cesa = devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
-	if (!cesa)
-		return -ENOMEM;
-
-	cesa->caps = caps;
-	cesa->dev = dev;
-
-	sram_size = CESA_SA_DEFAULT_SRAM_SIZE;
-	of_property_read_u32(cesa->dev->of_node, "marvell,crypto-sram-size",
-			     &sram_size);
-	if (sram_size < CESA_SA_MIN_SRAM_SIZE)
-		sram_size = CESA_SA_MIN_SRAM_SIZE;
-
-	cesa->sram_size = sram_size;
-	cesa->engines = devm_kcalloc(dev, caps->nengines, sizeof(*engines),
-				     GFP_KERNEL);
-	if (!cesa->engines)
-		return -ENOMEM;
-
-	spin_lock_init(&cesa->lock);
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
-	cesa->regs = devm_ioremap_resource(dev, res);
-	if (IS_ERR(cesa->regs))
-		return PTR_ERR(cesa->regs);
-
-	ret = mv_cesa_dev_dma_init(cesa);
-	if (ret)
-		return ret;
-
-	dram = mv_mbus_dram_info_nooverlap();
-
-	platform_set_drvdata(pdev, cesa);
-
-	for (i = 0; i < caps->nengines; i++) {
-		struct mv_cesa_engine *engine = &cesa->engines[i];
-		char res_name[7];
-
-		engine->id = i;
-		spin_lock_init(&engine->lock);
-
-		ret = mv_cesa_get_sram(pdev, i);
-		if (ret)
-			goto err_cleanup;
-
-		irq = platform_get_irq(pdev, i);
-		if (irq < 0) {
-			ret = irq;
-			goto err_cleanup;
-		}
-
-		/*
-		 * Not all platforms can gate the CESA clocks: do not complain
-		 * if the clock does not exist.
-		 */
-		snprintf(res_name, sizeof(res_name), "cesa%d", i);
-		engine->clk = devm_clk_get(dev, res_name);
-		if (IS_ERR(engine->clk)) {
-			engine->clk = devm_clk_get(dev, NULL);
-			if (IS_ERR(engine->clk))
-				engine->clk = NULL;
-		}
-
-		snprintf(res_name, sizeof(res_name), "cesaz%d", i);
-		engine->zclk = devm_clk_get(dev, res_name);
-		if (IS_ERR(engine->zclk))
-			engine->zclk = NULL;
-
-		ret = clk_prepare_enable(engine->clk);
-		if (ret)
-			goto err_cleanup;
-
-		ret = clk_prepare_enable(engine->zclk);
-		if (ret)
-			goto err_cleanup;
-
-		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
-
-		if (dram && cesa->caps->has_tdma)
-			mv_cesa_conf_mbus_windows(engine, dram);
-
-		writel(0, engine->regs + CESA_SA_INT_STATUS);
-		writel(CESA_SA_CFG_STOP_DIG_ERR,
-		       engine->regs + CESA_SA_CFG);
-		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
-		       engine->regs + CESA_SA_DESC_P0);
-
-		ret = devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
-						IRQF_ONESHOT,
-						dev_name(&pdev->dev),
-						engine);
-		if (ret)
-			goto err_cleanup;
-
-		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
-		atomic_set(&engine->load, 0);
-		INIT_LIST_HEAD(&engine->complete_queue);
-	}
-
-	cesa_dev = cesa;
-
-	ret = mv_cesa_add_algs(cesa);
-	if (ret) {
-		cesa_dev = NULL;
-		goto err_cleanup;
-	}
-
-	dev_info(dev, "CESA device successfully registered\n");
-
-	return 0;
-
-err_cleanup:
-	for (i = 0; i < caps->nengines; i++) {
-		clk_disable_unprepare(cesa->engines[i].zclk);
-		clk_disable_unprepare(cesa->engines[i].clk);
-		mv_cesa_put_sram(pdev, i);
-	}
-
-	return ret;
-}
-
-static int mv_cesa_remove(struct platform_device *pdev)
-{
-	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
-	int i;
-
-	mv_cesa_remove_algs(cesa);
-
-	for (i = 0; i < cesa->caps->nengines; i++) {
-		clk_disable_unprepare(cesa->engines[i].zclk);
-		clk_disable_unprepare(cesa->engines[i].clk);
-		mv_cesa_put_sram(pdev, i);
-	}
-
-	return 0;
-}
-
-static const struct platform_device_id mv_cesa_plat_id_table[] = {
-	{ .name = "mv_crypto" },
-	{ /* sentinel */ },
-};
-MODULE_DEVICE_TABLE(platform, mv_cesa_plat_id_table);
-
-static struct platform_driver marvell_cesa = {
-	.probe		= mv_cesa_probe,
-	.remove		= mv_cesa_remove,
-	.id_table	= mv_cesa_plat_id_table,
-	.driver		= {
-		.name	= "marvell-cesa",
-		.of_match_table = mv_cesa_of_match_table,
-	},
-};
-module_platform_driver(marvell_cesa);
-
-MODULE_ALIAS("platform:mv_crypto");
-MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
-MODULE_AUTHOR("Arnaud Ebalard <arno@natisbad.org>");
-MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
deleted file mode 100644
index f1ed3b8..0000000
--- a/drivers/crypto/marvell/cesa.h
+++ /dev/null
@@ -1,880 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __MARVELL_CESA_H__
-#define __MARVELL_CESA_H__
-
-#include <crypto/algapi.h>
-#include <crypto/hash.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/skcipher.h>
-
-#include <linux/crypto.h>
-#include <linux/dmapool.h>
-
-#define CESA_ENGINE_OFF(i)			(((i) * 0x2000))
-
-#define CESA_TDMA_BYTE_CNT			0x800
-#define CESA_TDMA_SRC_ADDR			0x810
-#define CESA_TDMA_DST_ADDR			0x820
-#define CESA_TDMA_NEXT_ADDR			0x830
-
-#define CESA_TDMA_CONTROL			0x840
-#define CESA_TDMA_DST_BURST			GENMASK(2, 0)
-#define CESA_TDMA_DST_BURST_32B			3
-#define CESA_TDMA_DST_BURST_128B		4
-#define CESA_TDMA_OUT_RD_EN			BIT(4)
-#define CESA_TDMA_SRC_BURST			GENMASK(8, 6)
-#define CESA_TDMA_SRC_BURST_32B			(3 << 6)
-#define CESA_TDMA_SRC_BURST_128B		(4 << 6)
-#define CESA_TDMA_CHAIN				BIT(9)
-#define CESA_TDMA_BYTE_SWAP			BIT(11)
-#define CESA_TDMA_NO_BYTE_SWAP			BIT(11)
-#define CESA_TDMA_EN				BIT(12)
-#define CESA_TDMA_FETCH_ND			BIT(13)
-#define CESA_TDMA_ACT				BIT(14)
-
-#define CESA_TDMA_CUR				0x870
-#define CESA_TDMA_ERROR_CAUSE			0x8c8
-#define CESA_TDMA_ERROR_MSK			0x8cc
-
-#define CESA_TDMA_WINDOW_BASE(x)		(((x) * 0x8) + 0xa00)
-#define CESA_TDMA_WINDOW_CTRL(x)		(((x) * 0x8) + 0xa04)
-
-#define CESA_IVDIG(x)				(0xdd00 + ((x) * 4) +	\
-						 (((x) < 5) ? 0 : 0x14))
-
-#define CESA_SA_CMD				0xde00
-#define CESA_SA_CMD_EN_CESA_SA_ACCL0		BIT(0)
-#define CESA_SA_CMD_EN_CESA_SA_ACCL1		BIT(1)
-#define CESA_SA_CMD_DISABLE_SEC			BIT(2)
-
-#define CESA_SA_DESC_P0				0xde04
-
-#define CESA_SA_DESC_P1				0xde14
-
-#define CESA_SA_CFG				0xde08
-#define CESA_SA_CFG_STOP_DIG_ERR		GENMASK(1, 0)
-#define CESA_SA_CFG_DIG_ERR_CONT		0
-#define CESA_SA_CFG_DIG_ERR_SKIP		1
-#define CESA_SA_CFG_DIG_ERR_STOP		3
-#define CESA_SA_CFG_CH0_W_IDMA			BIT(7)
-#define CESA_SA_CFG_CH1_W_IDMA			BIT(8)
-#define CESA_SA_CFG_ACT_CH0_IDMA		BIT(9)
-#define CESA_SA_CFG_ACT_CH1_IDMA		BIT(10)
-#define CESA_SA_CFG_MULTI_PKT			BIT(11)
-#define CESA_SA_CFG_PARA_DIS			BIT(13)
-
-#define CESA_SA_ACCEL_STATUS			0xde0c
-#define CESA_SA_ST_ACT_0			BIT(0)
-#define CESA_SA_ST_ACT_1			BIT(1)
-
-/*
- * CESA_SA_FPGA_INT_STATUS looks like a FPGA leftover and is documented only
- * in Errata 4.12. It looks like that it was part of an IRQ-controller in FPGA
- * and someone forgot to remove  it while switching to the core and moving to
- * CESA_SA_INT_STATUS.
- */
-#define CESA_SA_FPGA_INT_STATUS			0xdd68
-#define CESA_SA_INT_STATUS			0xde20
-#define CESA_SA_INT_AUTH_DONE			BIT(0)
-#define CESA_SA_INT_DES_E_DONE			BIT(1)
-#define CESA_SA_INT_AES_E_DONE			BIT(2)
-#define CESA_SA_INT_AES_D_DONE			BIT(3)
-#define CESA_SA_INT_ENC_DONE			BIT(4)
-#define CESA_SA_INT_ACCEL0_DONE			BIT(5)
-#define CESA_SA_INT_ACCEL1_DONE			BIT(6)
-#define CESA_SA_INT_ACC0_IDMA_DONE		BIT(7)
-#define CESA_SA_INT_ACC1_IDMA_DONE		BIT(8)
-#define CESA_SA_INT_IDMA_DONE			BIT(9)
-#define CESA_SA_INT_IDMA_OWN_ERR		BIT(10)
-
-#define CESA_SA_INT_MSK				0xde24
-
-#define CESA_SA_DESC_CFG_OP_MAC_ONLY		0
-#define CESA_SA_DESC_CFG_OP_CRYPT_ONLY		1
-#define CESA_SA_DESC_CFG_OP_MAC_CRYPT		2
-#define CESA_SA_DESC_CFG_OP_CRYPT_MAC		3
-#define CESA_SA_DESC_CFG_OP_MSK			GENMASK(1, 0)
-#define CESA_SA_DESC_CFG_MACM_SHA256		(1 << 4)
-#define CESA_SA_DESC_CFG_MACM_HMAC_SHA256	(3 << 4)
-#define CESA_SA_DESC_CFG_MACM_MD5		(4 << 4)
-#define CESA_SA_DESC_CFG_MACM_SHA1		(5 << 4)
-#define CESA_SA_DESC_CFG_MACM_HMAC_MD5		(6 << 4)
-#define CESA_SA_DESC_CFG_MACM_HMAC_SHA1		(7 << 4)
-#define CESA_SA_DESC_CFG_MACM_MSK		GENMASK(6, 4)
-#define CESA_SA_DESC_CFG_CRYPTM_DES		(1 << 8)
-#define CESA_SA_DESC_CFG_CRYPTM_3DES		(2 << 8)
-#define CESA_SA_DESC_CFG_CRYPTM_AES		(3 << 8)
-#define CESA_SA_DESC_CFG_CRYPTM_MSK		GENMASK(9, 8)
-#define CESA_SA_DESC_CFG_DIR_ENC		(0 << 12)
-#define CESA_SA_DESC_CFG_DIR_DEC		(1 << 12)
-#define CESA_SA_DESC_CFG_CRYPTCM_ECB		(0 << 16)
-#define CESA_SA_DESC_CFG_CRYPTCM_CBC		(1 << 16)
-#define CESA_SA_DESC_CFG_CRYPTCM_MSK		BIT(16)
-#define CESA_SA_DESC_CFG_3DES_EEE		(0 << 20)
-#define CESA_SA_DESC_CFG_3DES_EDE		(1 << 20)
-#define CESA_SA_DESC_CFG_AES_LEN_128		(0 << 24)
-#define CESA_SA_DESC_CFG_AES_LEN_192		(1 << 24)
-#define CESA_SA_DESC_CFG_AES_LEN_256		(2 << 24)
-#define CESA_SA_DESC_CFG_AES_LEN_MSK		GENMASK(25, 24)
-#define CESA_SA_DESC_CFG_NOT_FRAG		(0 << 30)
-#define CESA_SA_DESC_CFG_FIRST_FRAG		(1 << 30)
-#define CESA_SA_DESC_CFG_LAST_FRAG		(2 << 30)
-#define CESA_SA_DESC_CFG_MID_FRAG		(3 << 30)
-#define CESA_SA_DESC_CFG_FRAG_MSK		GENMASK(31, 30)
-
-/*
- * /-----------\ 0
- * | ACCEL CFG |	4 * 8
- * |-----------| 0x20
- * | CRYPT KEY |	8 * 4
- * |-----------| 0x40
- * |  IV   IN  |	4 * 4
- * |-----------| 0x40 (inplace)
- * |  IV BUF   |	4 * 4
- * |-----------| 0x80
- * |  DATA IN  |	16 * x (max ->max_req_size)
- * |-----------| 0x80 (inplace operation)
- * |  DATA OUT |	16 * x (max ->max_req_size)
- * \-----------/ SRAM size
- */
-
-/*
- * Hashing memory map:
- * /-----------\ 0
- * | ACCEL CFG |        4 * 8
- * |-----------| 0x20
- * | Inner IV  |        8 * 4
- * |-----------| 0x40
- * | Outer IV  |        8 * 4
- * |-----------| 0x60
- * | Output BUF|        8 * 4
- * |-----------| 0x80
- * |  DATA IN  |        64 * x (max ->max_req_size)
- * \-----------/ SRAM size
- */
-
-#define CESA_SA_CFG_SRAM_OFFSET			0x00
-#define CESA_SA_DATA_SRAM_OFFSET		0x80
-
-#define CESA_SA_CRYPT_KEY_SRAM_OFFSET		0x20
-#define CESA_SA_CRYPT_IV_SRAM_OFFSET		0x40
-
-#define CESA_SA_MAC_IIV_SRAM_OFFSET		0x20
-#define CESA_SA_MAC_OIV_SRAM_OFFSET		0x40
-#define CESA_SA_MAC_DIG_SRAM_OFFSET		0x60
-
-#define CESA_SA_DESC_CRYPT_DATA(offset)					\
-	cpu_to_le32((CESA_SA_DATA_SRAM_OFFSET + (offset)) |		\
-		    ((CESA_SA_DATA_SRAM_OFFSET + (offset)) << 16))
-
-#define CESA_SA_DESC_CRYPT_IV(offset)					\
-	cpu_to_le32((CESA_SA_CRYPT_IV_SRAM_OFFSET + (offset)) |	\
-		    ((CESA_SA_CRYPT_IV_SRAM_OFFSET + (offset)) << 16))
-
-#define CESA_SA_DESC_CRYPT_KEY(offset)					\
-	cpu_to_le32(CESA_SA_CRYPT_KEY_SRAM_OFFSET + (offset))
-
-#define CESA_SA_DESC_MAC_DATA(offset)					\
-	cpu_to_le32(CESA_SA_DATA_SRAM_OFFSET + (offset))
-#define CESA_SA_DESC_MAC_DATA_MSK		cpu_to_le32(GENMASK(15, 0))
-
-#define CESA_SA_DESC_MAC_TOTAL_LEN(total_len)	cpu_to_le32((total_len) << 16)
-#define CESA_SA_DESC_MAC_TOTAL_LEN_MSK		cpu_to_le32(GENMASK(31, 16))
-
-#define CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX	0xffff
-
-#define CESA_SA_DESC_MAC_DIGEST(offset)					\
-	cpu_to_le32(CESA_SA_MAC_DIG_SRAM_OFFSET + (offset))
-#define CESA_SA_DESC_MAC_DIGEST_MSK		cpu_to_le32(GENMASK(15, 0))
-
-#define CESA_SA_DESC_MAC_FRAG_LEN(frag_len)	cpu_to_le32((frag_len) << 16)
-#define CESA_SA_DESC_MAC_FRAG_LEN_MSK		cpu_to_le32(GENMASK(31, 16))
-
-#define CESA_SA_DESC_MAC_IV(offset)					\
-	cpu_to_le32((CESA_SA_MAC_IIV_SRAM_OFFSET + (offset)) |		\
-		    ((CESA_SA_MAC_OIV_SRAM_OFFSET + (offset)) << 16))
-
-#define CESA_SA_SRAM_SIZE			2048
-#define CESA_SA_SRAM_PAYLOAD_SIZE		(cesa_dev->sram_size - \
-						 CESA_SA_DATA_SRAM_OFFSET)
-
-#define CESA_SA_DEFAULT_SRAM_SIZE		2048
-#define CESA_SA_MIN_SRAM_SIZE			1024
-
-#define CESA_SA_SRAM_MSK			(2048 - 1)
-
-#define CESA_MAX_HASH_BLOCK_SIZE		64
-#define CESA_HASH_BLOCK_SIZE_MSK		(CESA_MAX_HASH_BLOCK_SIZE - 1)
-
-/**
- * struct mv_cesa_sec_accel_desc - security accelerator descriptor
- * @config:	engine config
- * @enc_p:	input and output data pointers for a cipher operation
- * @enc_len:	cipher operation length
- * @enc_key_p:	cipher key pointer
- * @enc_iv:	cipher IV pointers
- * @mac_src_p:	input pointer and total hash length
- * @mac_digest:	digest pointer and hash operation length
- * @mac_iv:	hmac IV pointers
- *
- * Structure passed to the CESA engine to describe the crypto operation
- * to be executed.
- */
-struct mv_cesa_sec_accel_desc {
-	__le32 config;
-	__le32 enc_p;
-	__le32 enc_len;
-	__le32 enc_key_p;
-	__le32 enc_iv;
-	__le32 mac_src_p;
-	__le32 mac_digest;
-	__le32 mac_iv;
-};
-
-/**
- * struct mv_cesa_skcipher_op_ctx - cipher operation context
- * @key:	cipher key
- * @iv:		cipher IV
- *
- * Context associated to a cipher operation.
- */
-struct mv_cesa_skcipher_op_ctx {
-	u32 key[8];
-	u32 iv[4];
-};
-
-/**
- * struct mv_cesa_hash_op_ctx - hash or hmac operation context
- * @key:	cipher key
- * @iv:		cipher IV
- *
- * Context associated to an hash or hmac operation.
- */
-struct mv_cesa_hash_op_ctx {
-	u32 iv[16];
-	u32 hash[8];
-};
-
-/**
- * struct mv_cesa_op_ctx - crypto operation context
- * @desc:	CESA descriptor
- * @ctx:	context associated to the crypto operation
- *
- * Context associated to a crypto operation.
- */
-struct mv_cesa_op_ctx {
-	struct mv_cesa_sec_accel_desc desc;
-	union {
-		struct mv_cesa_skcipher_op_ctx skcipher;
-		struct mv_cesa_hash_op_ctx hash;
-	} ctx;
-};
-
-/* TDMA descriptor flags */
-#define CESA_TDMA_DST_IN_SRAM			BIT(31)
-#define CESA_TDMA_SRC_IN_SRAM			BIT(30)
-#define CESA_TDMA_END_OF_REQ			BIT(29)
-#define CESA_TDMA_BREAK_CHAIN			BIT(28)
-#define CESA_TDMA_SET_STATE			BIT(27)
-#define CESA_TDMA_TYPE_MSK			GENMASK(26, 0)
-#define CESA_TDMA_DUMMY				0
-#define CESA_TDMA_DATA				1
-#define CESA_TDMA_OP				2
-#define CESA_TDMA_RESULT			3
-
-/**
- * struct mv_cesa_tdma_desc - TDMA descriptor
- * @byte_cnt:	number of bytes to transfer
- * @src:	DMA address of the source
- * @dst:	DMA address of the destination
- * @next_dma:	DMA address of the next TDMA descriptor
- * @cur_dma:	DMA address of this TDMA descriptor
- * @next:	pointer to the next TDMA descriptor
- * @op:		CESA operation attached to this TDMA descriptor
- * @data:	raw data attached to this TDMA descriptor
- * @flags:	flags describing the TDMA transfer. See the
- *		"TDMA descriptor flags" section above
- *
- * TDMA descriptor used to create a transfer chain describing a crypto
- * operation.
- */
-struct mv_cesa_tdma_desc {
-	__le32 byte_cnt;
-	__le32 src;
-	__le32 dst;
-	__le32 next_dma;
-
-	/* Software state */
-	dma_addr_t cur_dma;
-	struct mv_cesa_tdma_desc *next;
-	union {
-		struct mv_cesa_op_ctx *op;
-		void *data;
-	};
-	u32 flags;
-};
-
-/**
- * struct mv_cesa_sg_dma_iter - scatter-gather iterator
- * @dir:	transfer direction
- * @sg:		scatter list
- * @offset:	current position in the scatter list
- * @op_offset:	current position in the crypto operation
- *
- * Iterator used to iterate over a scatterlist while creating a TDMA chain for
- * a crypto operation.
- */
-struct mv_cesa_sg_dma_iter {
-	enum dma_data_direction dir;
-	struct scatterlist *sg;
-	unsigned int offset;
-	unsigned int op_offset;
-};
-
-/**
- * struct mv_cesa_dma_iter - crypto operation iterator
- * @len:	the crypto operation length
- * @offset:	current position in the crypto operation
- * @op_len:	sub-operation length (the crypto engine can only act on 2kb
- *		chunks)
- *
- * Iterator used to create a TDMA chain for a given crypto operation.
- */
-struct mv_cesa_dma_iter {
-	unsigned int len;
-	unsigned int offset;
-	unsigned int op_len;
-};
-
-/**
- * struct mv_cesa_tdma_chain - TDMA chain
- * @first:	first entry in the TDMA chain
- * @last:	last entry in the TDMA chain
- *
- * Stores a TDMA chain for a specific crypto operation.
- */
-struct mv_cesa_tdma_chain {
-	struct mv_cesa_tdma_desc *first;
-	struct mv_cesa_tdma_desc *last;
-};
-
-struct mv_cesa_engine;
-
-/**
- * struct mv_cesa_caps - CESA device capabilities
- * @engines:		number of engines
- * @has_tdma:		whether this device has a TDMA block
- * @cipher_algs:	supported cipher algorithms
- * @ncipher_algs:	number of supported cipher algorithms
- * @ahash_algs:		supported hash algorithms
- * @nahash_algs:	number of supported hash algorithms
- *
- * Structure used to describe CESA device capabilities.
- */
-struct mv_cesa_caps {
-	int nengines;
-	bool has_tdma;
-	struct skcipher_alg **cipher_algs;
-	int ncipher_algs;
-	struct ahash_alg **ahash_algs;
-	int nahash_algs;
-};
-
-/**
- * struct mv_cesa_dev_dma - DMA pools
- * @tdma_desc_pool:	TDMA desc pool
- * @op_pool:		crypto operation pool
- * @cache_pool:		data cache pool (used by hash implementation when the
- *			hash request is smaller than the hash block size)
- * @padding_pool:	padding pool (used by hash implementation when hardware
- *			padding cannot be used)
- *
- * Structure containing the different DMA pools used by this driver.
- */
-struct mv_cesa_dev_dma {
-	struct dma_pool *tdma_desc_pool;
-	struct dma_pool *op_pool;
-	struct dma_pool *cache_pool;
-	struct dma_pool *padding_pool;
-};
-
-/**
- * struct mv_cesa_dev - CESA device
- * @caps:	device capabilities
- * @regs:	device registers
- * @sram_size:	usable SRAM size
- * @lock:	device lock
- * @engines:	array of engines
- * @dma:	dma pools
- *
- * Structure storing CESA device information.
- */
-struct mv_cesa_dev {
-	const struct mv_cesa_caps *caps;
-	void __iomem *regs;
-	struct device *dev;
-	unsigned int sram_size;
-	spinlock_t lock;
-	struct mv_cesa_engine *engines;
-	struct mv_cesa_dev_dma *dma;
-};
-
-/**
- * struct mv_cesa_engine - CESA engine
- * @id:			engine id
- * @regs:		engine registers
- * @sram:		SRAM memory region
- * @sram_dma:		DMA address of the SRAM memory region
- * @lock:		engine lock
- * @req:		current crypto request
- * @clk:		engine clk
- * @zclk:		engine zclk
- * @max_req_len:	maximum chunk length (useful to create the TDMA chain)
- * @int_mask:		interrupt mask cache
- * @pool:		memory pool pointing to the memory region reserved in
- *			SRAM
- * @queue:		fifo of the pending crypto requests
- * @load:		engine load counter, useful for load balancing
- * @chain:		list of the current tdma descriptors being processed
- * 			by this engine.
- * @complete_queue:	fifo of the processed requests by the engine
- *
- * Structure storing CESA engine information.
- */
-struct mv_cesa_engine {
-	int id;
-	void __iomem *regs;
-	void __iomem *sram;
-	dma_addr_t sram_dma;
-	spinlock_t lock;
-	struct crypto_async_request *req;
-	struct clk *clk;
-	struct clk *zclk;
-	size_t max_req_len;
-	u32 int_mask;
-	struct gen_pool *pool;
-	struct crypto_queue queue;
-	atomic_t load;
-	struct mv_cesa_tdma_chain chain;
-	struct list_head complete_queue;
-};
-
-/**
- * struct mv_cesa_req_ops - CESA request operations
- * @process:	process a request chunk result (should return 0 if the
- *		operation, -EINPROGRESS if it needs more steps or an error
- *		code)
- * @step:	launch the crypto operation on the next chunk
- * @cleanup:	cleanup the crypto request (release associated data)
- * @complete:	complete the request, i.e copy result or context from sram when
- * 		needed.
- */
-struct mv_cesa_req_ops {
-	int (*process)(struct crypto_async_request *req, u32 status);
-	void (*step)(struct crypto_async_request *req);
-	void (*cleanup)(struct crypto_async_request *req);
-	void (*complete)(struct crypto_async_request *req);
-};
-
-/**
- * struct mv_cesa_ctx - CESA operation context
- * @ops:	crypto operations
- *
- * Base context structure inherited by operation specific ones.
- */
-struct mv_cesa_ctx {
-	const struct mv_cesa_req_ops *ops;
-};
-
-/**
- * struct mv_cesa_hash_ctx - CESA hash operation context
- * @base:	base context structure
- *
- * Hash context structure.
- */
-struct mv_cesa_hash_ctx {
-	struct mv_cesa_ctx base;
-};
-
-/**
- * struct mv_cesa_hash_ctx - CESA hmac operation context
- * @base:	base context structure
- * @iv:		initialization vectors
- *
- * HMAC context structure.
- */
-struct mv_cesa_hmac_ctx {
-	struct mv_cesa_ctx base;
-	u32 iv[16];
-};
-
-/**
- * enum mv_cesa_req_type - request type definitions
- * @CESA_STD_REQ:	standard request
- * @CESA_DMA_REQ:	DMA request
- */
-enum mv_cesa_req_type {
-	CESA_STD_REQ,
-	CESA_DMA_REQ,
-};
-
-/**
- * struct mv_cesa_req - CESA request
- * @engine:	engine associated with this request
- * @chain:	list of tdma descriptors associated  with this request
- */
-struct mv_cesa_req {
-	struct mv_cesa_engine *engine;
-	struct mv_cesa_tdma_chain chain;
-};
-
-/**
- * struct mv_cesa_sg_std_iter - CESA scatter-gather iterator for standard
- *				requests
- * @iter:	sg mapping iterator
- * @offset:	current offset in the SG entry mapped in memory
- */
-struct mv_cesa_sg_std_iter {
-	struct sg_mapping_iter iter;
-	unsigned int offset;
-};
-
-/**
- * struct mv_cesa_skcipher_std_req - cipher standard request
- * @op:		operation context
- * @offset:	current operation offset
- * @size:	size of the crypto operation
- */
-struct mv_cesa_skcipher_std_req {
-	struct mv_cesa_op_ctx op;
-	unsigned int offset;
-	unsigned int size;
-	bool skip_ctx;
-};
-
-/**
- * struct mv_cesa_skcipher_req - cipher request
- * @req:	type specific request information
- * @src_nents:	number of entries in the src sg list
- * @dst_nents:	number of entries in the dest sg list
- */
-struct mv_cesa_skcipher_req {
-	struct mv_cesa_req base;
-	struct mv_cesa_skcipher_std_req std;
-	int src_nents;
-	int dst_nents;
-};
-
-/**
- * struct mv_cesa_ahash_std_req - standard hash request
- * @offset:	current operation offset
- */
-struct mv_cesa_ahash_std_req {
-	unsigned int offset;
-};
-
-/**
- * struct mv_cesa_ahash_dma_req - DMA hash request
- * @padding:		padding buffer
- * @padding_dma:	DMA address of the padding buffer
- * @cache_dma:		DMA address of the cache buffer
- */
-struct mv_cesa_ahash_dma_req {
-	u8 *padding;
-	dma_addr_t padding_dma;
-	u8 *cache;
-	dma_addr_t cache_dma;
-};
-
-/**
- * struct mv_cesa_ahash_req - hash request
- * @req:		type specific request information
- * @cache:		cache buffer
- * @cache_ptr:		write pointer in the cache buffer
- * @len:		hash total length
- * @src_nents:		number of entries in the scatterlist
- * @last_req:		define whether the current operation is the last one
- *			or not
- * @state:		hash state
- */
-struct mv_cesa_ahash_req {
-	struct mv_cesa_req base;
-	union {
-		struct mv_cesa_ahash_dma_req dma;
-		struct mv_cesa_ahash_std_req std;
-	} req;
-	struct mv_cesa_op_ctx op_tmpl;
-	u8 cache[CESA_MAX_HASH_BLOCK_SIZE];
-	unsigned int cache_ptr;
-	u64 len;
-	int src_nents;
-	bool last_req;
-	bool algo_le;
-	u32 state[8];
-};
-
-/* CESA functions */
-
-extern struct mv_cesa_dev *cesa_dev;
-
-
-static inline void
-mv_cesa_engine_enqueue_complete_request(struct mv_cesa_engine *engine,
-					struct crypto_async_request *req)
-{
-	list_add_tail(&req->list, &engine->complete_queue);
-}
-
-static inline struct crypto_async_request *
-mv_cesa_engine_dequeue_complete_request(struct mv_cesa_engine *engine)
-{
-	struct crypto_async_request *req;
-
-	req = list_first_entry_or_null(&engine->complete_queue,
-				       struct crypto_async_request,
-				       list);
-	if (req)
-		list_del(&req->list);
-
-	return req;
-}
-
-
-static inline enum mv_cesa_req_type
-mv_cesa_req_get_type(struct mv_cesa_req *req)
-{
-	return req->chain.first ? CESA_DMA_REQ : CESA_STD_REQ;
-}
-
-static inline void mv_cesa_update_op_cfg(struct mv_cesa_op_ctx *op,
-					 u32 cfg, u32 mask)
-{
-	op->desc.config &= cpu_to_le32(~mask);
-	op->desc.config |= cpu_to_le32(cfg);
-}
-
-static inline u32 mv_cesa_get_op_cfg(const struct mv_cesa_op_ctx *op)
-{
-	return le32_to_cpu(op->desc.config);
-}
-
-static inline void mv_cesa_set_op_cfg(struct mv_cesa_op_ctx *op, u32 cfg)
-{
-	op->desc.config = cpu_to_le32(cfg);
-}
-
-static inline void mv_cesa_adjust_op(struct mv_cesa_engine *engine,
-				     struct mv_cesa_op_ctx *op)
-{
-	u32 offset = engine->sram_dma & CESA_SA_SRAM_MSK;
-
-	op->desc.enc_p = CESA_SA_DESC_CRYPT_DATA(offset);
-	op->desc.enc_key_p = CESA_SA_DESC_CRYPT_KEY(offset);
-	op->desc.enc_iv = CESA_SA_DESC_CRYPT_IV(offset);
-	op->desc.mac_src_p &= ~CESA_SA_DESC_MAC_DATA_MSK;
-	op->desc.mac_src_p |= CESA_SA_DESC_MAC_DATA(offset);
-	op->desc.mac_digest &= ~CESA_SA_DESC_MAC_DIGEST_MSK;
-	op->desc.mac_digest |= CESA_SA_DESC_MAC_DIGEST(offset);
-	op->desc.mac_iv = CESA_SA_DESC_MAC_IV(offset);
-}
-
-static inline void mv_cesa_set_crypt_op_len(struct mv_cesa_op_ctx *op, int len)
-{
-	op->desc.enc_len = cpu_to_le32(len);
-}
-
-static inline void mv_cesa_set_mac_op_total_len(struct mv_cesa_op_ctx *op,
-						int len)
-{
-	op->desc.mac_src_p &= ~CESA_SA_DESC_MAC_TOTAL_LEN_MSK;
-	op->desc.mac_src_p |= CESA_SA_DESC_MAC_TOTAL_LEN(len);
-}
-
-static inline void mv_cesa_set_mac_op_frag_len(struct mv_cesa_op_ctx *op,
-					       int len)
-{
-	op->desc.mac_digest &= ~CESA_SA_DESC_MAC_FRAG_LEN_MSK;
-	op->desc.mac_digest |= CESA_SA_DESC_MAC_FRAG_LEN(len);
-}
-
-static inline void mv_cesa_set_int_mask(struct mv_cesa_engine *engine,
-					u32 int_mask)
-{
-	if (int_mask == engine->int_mask)
-		return;
-
-	writel_relaxed(int_mask, engine->regs + CESA_SA_INT_MSK);
-	engine->int_mask = int_mask;
-}
-
-static inline u32 mv_cesa_get_int_mask(struct mv_cesa_engine *engine)
-{
-	return engine->int_mask;
-}
-
-static inline bool mv_cesa_mac_op_is_first_frag(const struct mv_cesa_op_ctx *op)
-{
-	return (mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK) ==
-		CESA_SA_DESC_CFG_FIRST_FRAG;
-}
-
-int mv_cesa_queue_req(struct crypto_async_request *req,
-		      struct mv_cesa_req *creq);
-
-struct crypto_async_request *
-mv_cesa_dequeue_req_locked(struct mv_cesa_engine *engine,
-			   struct crypto_async_request **backlog);
-
-static inline struct mv_cesa_engine *mv_cesa_select_engine(int weight)
-{
-	int i;
-	u32 min_load = U32_MAX;
-	struct mv_cesa_engine *selected = NULL;
-
-	for (i = 0; i < cesa_dev->caps->nengines; i++) {
-		struct mv_cesa_engine *engine = cesa_dev->engines + i;
-		u32 load = atomic_read(&engine->load);
-		if (load < min_load) {
-			min_load = load;
-			selected = engine;
-		}
-	}
-
-	atomic_add(weight, &selected->load);
-
-	return selected;
-}
-
-/*
- * Helper function that indicates whether a crypto request needs to be
- * cleaned up or not after being enqueued using mv_cesa_queue_req().
- */
-static inline int mv_cesa_req_needs_cleanup(struct crypto_async_request *req,
-					    int ret)
-{
-	/*
-	 * The queue still had some space, the request was queued
-	 * normally, so there's no need to clean it up.
-	 */
-	if (ret == -EINPROGRESS)
-		return false;
-
-	/*
-	 * The queue had not space left, but since the request is
-	 * flagged with CRYPTO_TFM_REQ_MAY_BACKLOG, it was added to
-	 * the backlog and will be processed later. There's no need to
-	 * clean it up.
-	 */
-	if (ret == -EBUSY)
-		return false;
-
-	/* Request wasn't queued, we need to clean it up */
-	return true;
-}
-
-/* TDMA functions */
-
-static inline void mv_cesa_req_dma_iter_init(struct mv_cesa_dma_iter *iter,
-					     unsigned int len)
-{
-	iter->len = len;
-	iter->op_len = min(len, CESA_SA_SRAM_PAYLOAD_SIZE);
-	iter->offset = 0;
-}
-
-static inline void mv_cesa_sg_dma_iter_init(struct mv_cesa_sg_dma_iter *iter,
-					    struct scatterlist *sg,
-					    enum dma_data_direction dir)
-{
-	iter->op_offset = 0;
-	iter->offset = 0;
-	iter->sg = sg;
-	iter->dir = dir;
-}
-
-static inline unsigned int
-mv_cesa_req_dma_iter_transfer_len(struct mv_cesa_dma_iter *iter,
-				  struct mv_cesa_sg_dma_iter *sgiter)
-{
-	return min(iter->op_len - sgiter->op_offset,
-		   sg_dma_len(sgiter->sg) - sgiter->offset);
-}
-
-bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *chain,
-					struct mv_cesa_sg_dma_iter *sgiter,
-					unsigned int len);
-
-static inline bool mv_cesa_req_dma_iter_next_op(struct mv_cesa_dma_iter *iter)
-{
-	iter->offset += iter->op_len;
-	iter->op_len = min(iter->len - iter->offset,
-			   CESA_SA_SRAM_PAYLOAD_SIZE);
-
-	return iter->op_len;
-}
-
-void mv_cesa_dma_step(struct mv_cesa_req *dreq);
-
-static inline int mv_cesa_dma_process(struct mv_cesa_req *dreq,
-				      u32 status)
-{
-	if (!(status & CESA_SA_INT_ACC0_IDMA_DONE))
-		return -EINPROGRESS;
-
-	if (status & CESA_SA_INT_IDMA_OWN_ERR)
-		return -EINVAL;
-
-	return 0;
-}
-
-void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
-			 struct mv_cesa_engine *engine);
-void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq);
-void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
-			struct mv_cesa_req *dreq);
-int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status);
-
-
-static inline void
-mv_cesa_tdma_desc_iter_init(struct mv_cesa_tdma_chain *chain)
-{
-	memset(chain, 0, sizeof(*chain));
-}
-
-int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
-			  u32 size, u32 flags, gfp_t gfp_flags);
-
-struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
-					const struct mv_cesa_op_ctx *op_templ,
-					bool skip_ctx,
-					gfp_t flags);
-
-int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
-				  dma_addr_t dst, dma_addr_t src, u32 size,
-				  u32 flags, gfp_t gfp_flags);
-
-int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain, gfp_t flags);
-int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, gfp_t flags);
-
-int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
-				 struct mv_cesa_dma_iter *dma_iter,
-				 struct mv_cesa_sg_dma_iter *sgiter,
-				 gfp_t gfp_flags);
-
-/* Algorithm definitions */
-
-extern struct ahash_alg mv_md5_alg;
-extern struct ahash_alg mv_sha1_alg;
-extern struct ahash_alg mv_sha256_alg;
-extern struct ahash_alg mv_ahmac_md5_alg;
-extern struct ahash_alg mv_ahmac_sha1_alg;
-extern struct ahash_alg mv_ahmac_sha256_alg;
-
-extern struct skcipher_alg mv_cesa_ecb_des_alg;
-extern struct skcipher_alg mv_cesa_cbc_des_alg;
-extern struct skcipher_alg mv_cesa_ecb_des3_ede_alg;
-extern struct skcipher_alg mv_cesa_cbc_des3_ede_alg;
-extern struct skcipher_alg mv_cesa_ecb_aes_alg;
-extern struct skcipher_alg mv_cesa_cbc_aes_alg;
-
-#endif /* __MARVELL_CESA_H__ */
diff --git a/drivers/crypto/marvell/cesa/Makefile b/drivers/crypto/marvell/cesa/Makefile
new file mode 100644
index 0000000..b27cab6
--- /dev/null
+++ b/drivers/crypto/marvell/cesa/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += marvell-cesa.o
+marvell-cesa-objs := cesa.o cipher.o hash.o tdma.o
diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
new file mode 100644
index 0000000..8a5f0b0
--- /dev/null
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -0,0 +1,615 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Support for Marvell's Cryptographic Engine and Security Accelerator (CESA)
+ * that can be found on the following platform: Orion, Kirkwood, Armada. This
+ * driver supports the TDMA engine on platforms on which it is available.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/genalloc.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kthread.h>
+#include <linux/mbus.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_irq.h>
+
+#include "cesa.h"
+
+/* Limit of the crypto queue before reaching the backlog */
+#define CESA_CRYPTO_DEFAULT_MAX_QLEN 128
+
+struct mv_cesa_dev *cesa_dev;
+
+struct crypto_async_request *
+mv_cesa_dequeue_req_locked(struct mv_cesa_engine *engine,
+			   struct crypto_async_request **backlog)
+{
+	struct crypto_async_request *req;
+
+	*backlog = crypto_get_backlog(&engine->queue);
+	req = crypto_dequeue_request(&engine->queue);
+
+	if (!req)
+		return NULL;
+
+	return req;
+}
+
+static void mv_cesa_rearm_engine(struct mv_cesa_engine *engine)
+{
+	struct crypto_async_request *req = NULL, *backlog = NULL;
+	struct mv_cesa_ctx *ctx;
+
+
+	spin_lock_bh(&engine->lock);
+	if (!engine->req) {
+		req = mv_cesa_dequeue_req_locked(engine, &backlog);
+		engine->req = req;
+	}
+	spin_unlock_bh(&engine->lock);
+
+	if (!req)
+		return;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	ctx = crypto_tfm_ctx(req->tfm);
+	ctx->ops->step(req);
+}
+
+static int mv_cesa_std_process(struct mv_cesa_engine *engine, u32 status)
+{
+	struct crypto_async_request *req;
+	struct mv_cesa_ctx *ctx;
+	int res;
+
+	req = engine->req;
+	ctx = crypto_tfm_ctx(req->tfm);
+	res = ctx->ops->process(req, status);
+
+	if (res == 0) {
+		ctx->ops->complete(req);
+		mv_cesa_engine_enqueue_complete_request(engine, req);
+	} else if (res == -EINPROGRESS) {
+		ctx->ops->step(req);
+	}
+
+	return res;
+}
+
+static int mv_cesa_int_process(struct mv_cesa_engine *engine, u32 status)
+{
+	if (engine->chain.first && engine->chain.last)
+		return mv_cesa_tdma_process(engine, status);
+
+	return mv_cesa_std_process(engine, status);
+}
+
+static inline void
+mv_cesa_complete_req(struct mv_cesa_ctx *ctx, struct crypto_async_request *req,
+		     int res)
+{
+	ctx->ops->cleanup(req);
+	local_bh_disable();
+	req->complete(req, res);
+	local_bh_enable();
+}
+
+static irqreturn_t mv_cesa_int(int irq, void *priv)
+{
+	struct mv_cesa_engine *engine = priv;
+	struct crypto_async_request *req;
+	struct mv_cesa_ctx *ctx;
+	u32 status, mask;
+	irqreturn_t ret = IRQ_NONE;
+
+	while (true) {
+		int res;
+
+		mask = mv_cesa_get_int_mask(engine);
+		status = readl(engine->regs + CESA_SA_INT_STATUS);
+
+		if (!(status & mask))
+			break;
+
+		/*
+		 * TODO: avoid clearing the FPGA_INT_STATUS if this not
+		 * relevant on some platforms.
+		 */
+		writel(~status, engine->regs + CESA_SA_FPGA_INT_STATUS);
+		writel(~status, engine->regs + CESA_SA_INT_STATUS);
+
+		/* Process fetched requests */
+		res = mv_cesa_int_process(engine, status & mask);
+		ret = IRQ_HANDLED;
+
+		spin_lock_bh(&engine->lock);
+		req = engine->req;
+		if (res != -EINPROGRESS)
+			engine->req = NULL;
+		spin_unlock_bh(&engine->lock);
+
+		ctx = crypto_tfm_ctx(req->tfm);
+
+		if (res && res != -EINPROGRESS)
+			mv_cesa_complete_req(ctx, req, res);
+
+		/* Launch the next pending request */
+		mv_cesa_rearm_engine(engine);
+
+		/* Iterate over the complete queue */
+		while (true) {
+			req = mv_cesa_engine_dequeue_complete_request(engine);
+			if (!req)
+				break;
+
+			ctx = crypto_tfm_ctx(req->tfm);
+			mv_cesa_complete_req(ctx, req, 0);
+		}
+	}
+
+	return ret;
+}
+
+int mv_cesa_queue_req(struct crypto_async_request *req,
+		      struct mv_cesa_req *creq)
+{
+	int ret;
+	struct mv_cesa_engine *engine = creq->engine;
+
+	spin_lock_bh(&engine->lock);
+	ret = crypto_enqueue_request(&engine->queue, req);
+	if ((mv_cesa_req_get_type(creq) == CESA_DMA_REQ) &&
+	    (ret == -EINPROGRESS || ret == -EBUSY))
+		mv_cesa_tdma_chain(engine, creq);
+	spin_unlock_bh(&engine->lock);
+
+	if (ret != -EINPROGRESS)
+		return ret;
+
+	mv_cesa_rearm_engine(engine);
+
+	return -EINPROGRESS;
+}
+
+static int mv_cesa_add_algs(struct mv_cesa_dev *cesa)
+{
+	int ret;
+	int i, j;
+
+	for (i = 0; i < cesa->caps->ncipher_algs; i++) {
+		ret = crypto_register_skcipher(cesa->caps->cipher_algs[i]);
+		if (ret)
+			goto err_unregister_crypto;
+	}
+
+	for (i = 0; i < cesa->caps->nahash_algs; i++) {
+		ret = crypto_register_ahash(cesa->caps->ahash_algs[i]);
+		if (ret)
+			goto err_unregister_ahash;
+	}
+
+	return 0;
+
+err_unregister_ahash:
+	for (j = 0; j < i; j++)
+		crypto_unregister_ahash(cesa->caps->ahash_algs[j]);
+	i = cesa->caps->ncipher_algs;
+
+err_unregister_crypto:
+	for (j = 0; j < i; j++)
+		crypto_unregister_skcipher(cesa->caps->cipher_algs[j]);
+
+	return ret;
+}
+
+static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
+{
+	int i;
+
+	for (i = 0; i < cesa->caps->nahash_algs; i++)
+		crypto_unregister_ahash(cesa->caps->ahash_algs[i]);
+
+	for (i = 0; i < cesa->caps->ncipher_algs; i++)
+		crypto_unregister_skcipher(cesa->caps->cipher_algs[i]);
+}
+
+static struct skcipher_alg *orion_cipher_algs[] = {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
+	&mv_cesa_ecb_aes_alg,
+	&mv_cesa_cbc_aes_alg,
+};
+
+static struct ahash_alg *orion_ahash_algs[] = {
+	&mv_md5_alg,
+	&mv_sha1_alg,
+	&mv_ahmac_md5_alg,
+	&mv_ahmac_sha1_alg,
+};
+
+static struct skcipher_alg *armada_370_cipher_algs[] = {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
+	&mv_cesa_ecb_aes_alg,
+	&mv_cesa_cbc_aes_alg,
+};
+
+static struct ahash_alg *armada_370_ahash_algs[] = {
+	&mv_md5_alg,
+	&mv_sha1_alg,
+	&mv_sha256_alg,
+	&mv_ahmac_md5_alg,
+	&mv_ahmac_sha1_alg,
+	&mv_ahmac_sha256_alg,
+};
+
+static const struct mv_cesa_caps orion_caps = {
+	.nengines = 1,
+	.cipher_algs = orion_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs = orion_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma = false,
+};
+
+static const struct mv_cesa_caps kirkwood_caps = {
+	.nengines = 1,
+	.cipher_algs = orion_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
+	.ahash_algs = orion_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
+	.has_tdma = true,
+};
+
+static const struct mv_cesa_caps armada_370_caps = {
+	.nengines = 1,
+	.cipher_algs = armada_370_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
+	.ahash_algs = armada_370_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
+	.has_tdma = true,
+};
+
+static const struct mv_cesa_caps armada_xp_caps = {
+	.nengines = 2,
+	.cipher_algs = armada_370_cipher_algs,
+	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
+	.ahash_algs = armada_370_ahash_algs,
+	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
+	.has_tdma = true,
+};
+
+static const struct of_device_id mv_cesa_of_match_table[] = {
+	{ .compatible = "marvell,orion-crypto", .data = &orion_caps },
+	{ .compatible = "marvell,kirkwood-crypto", .data = &kirkwood_caps },
+	{ .compatible = "marvell,dove-crypto", .data = &kirkwood_caps },
+	{ .compatible = "marvell,armada-370-crypto", .data = &armada_370_caps },
+	{ .compatible = "marvell,armada-xp-crypto", .data = &armada_xp_caps },
+	{ .compatible = "marvell,armada-375-crypto", .data = &armada_xp_caps },
+	{ .compatible = "marvell,armada-38x-crypto", .data = &armada_xp_caps },
+	{}
+};
+MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
+
+static void
+mv_cesa_conf_mbus_windows(struct mv_cesa_engine *engine,
+			  const struct mbus_dram_target_info *dram)
+{
+	void __iomem *iobase = engine->regs;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		writel(0, iobase + CESA_TDMA_WINDOW_CTRL(i));
+		writel(0, iobase + CESA_TDMA_WINDOW_BASE(i));
+	}
+
+	for (i = 0; i < dram->num_cs; i++) {
+		const struct mbus_dram_window *cs = dram->cs + i;
+
+		writel(((cs->size - 1) & 0xffff0000) |
+		       (cs->mbus_attr << 8) |
+		       (dram->mbus_dram_target_id << 4) | 1,
+		       iobase + CESA_TDMA_WINDOW_CTRL(i));
+		writel(cs->base, iobase + CESA_TDMA_WINDOW_BASE(i));
+	}
+}
+
+static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
+{
+	struct device *dev = cesa->dev;
+	struct mv_cesa_dev_dma *dma;
+
+	if (!cesa->caps->has_tdma)
+		return 0;
+
+	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
+	if (!dma)
+		return -ENOMEM;
+
+	dma->tdma_desc_pool = dmam_pool_create("tdma_desc", dev,
+					sizeof(struct mv_cesa_tdma_desc),
+					16, 0);
+	if (!dma->tdma_desc_pool)
+		return -ENOMEM;
+
+	dma->op_pool = dmam_pool_create("cesa_op", dev,
+					sizeof(struct mv_cesa_op_ctx), 16, 0);
+	if (!dma->op_pool)
+		return -ENOMEM;
+
+	dma->cache_pool = dmam_pool_create("cesa_cache", dev,
+					   CESA_MAX_HASH_BLOCK_SIZE, 1, 0);
+	if (!dma->cache_pool)
+		return -ENOMEM;
+
+	dma->padding_pool = dmam_pool_create("cesa_padding", dev, 72, 1, 0);
+	if (!dma->padding_pool)
+		return -ENOMEM;
+
+	cesa->dma = dma;
+
+	return 0;
+}
+
+static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
+{
+	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
+	struct mv_cesa_engine *engine = &cesa->engines[idx];
+	const char *res_name = "sram";
+	struct resource *res;
+
+	engine->pool = of_gen_pool_get(cesa->dev->of_node,
+				       "marvell,crypto-srams", idx);
+	if (engine->pool) {
+		engine->sram = gen_pool_dma_alloc(engine->pool,
+						  cesa->sram_size,
+						  &engine->sram_dma);
+		if (engine->sram)
+			return 0;
+
+		engine->pool = NULL;
+		return -ENOMEM;
+	}
+
+	if (cesa->caps->nengines > 1) {
+		if (!idx)
+			res_name = "sram0";
+		else
+			res_name = "sram1";
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+					   res_name);
+	if (!res || resource_size(res) < cesa->sram_size)
+		return -EINVAL;
+
+	engine->sram = devm_ioremap_resource(cesa->dev, res);
+	if (IS_ERR(engine->sram))
+		return PTR_ERR(engine->sram);
+
+	engine->sram_dma = dma_map_resource(cesa->dev, res->start,
+					    cesa->sram_size,
+					    DMA_BIDIRECTIONAL, 0);
+	if (dma_mapping_error(cesa->dev, engine->sram_dma))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
+{
+	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
+	struct mv_cesa_engine *engine = &cesa->engines[idx];
+
+	if (engine->pool)
+		gen_pool_free(engine->pool, (unsigned long)engine->sram,
+			      cesa->sram_size);
+	else
+		dma_unmap_resource(cesa->dev, engine->sram_dma,
+				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
+}
+
+static int mv_cesa_probe(struct platform_device *pdev)
+{
+	const struct mv_cesa_caps *caps = &orion_caps;
+	const struct mbus_dram_target_info *dram;
+	const struct of_device_id *match;
+	struct device *dev = &pdev->dev;
+	struct mv_cesa_dev *cesa;
+	struct mv_cesa_engine *engines;
+	struct resource *res;
+	int irq, ret, i;
+	u32 sram_size;
+
+	if (cesa_dev) {
+		dev_err(&pdev->dev, "Only one CESA device authorized\n");
+		return -EEXIST;
+	}
+
+	if (dev->of_node) {
+		match = of_match_node(mv_cesa_of_match_table, dev->of_node);
+		if (!match || !match->data)
+			return -ENOTSUPP;
+
+		caps = match->data;
+	}
+
+	cesa = devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
+	if (!cesa)
+		return -ENOMEM;
+
+	cesa->caps = caps;
+	cesa->dev = dev;
+
+	sram_size = CESA_SA_DEFAULT_SRAM_SIZE;
+	of_property_read_u32(cesa->dev->of_node, "marvell,crypto-sram-size",
+			     &sram_size);
+	if (sram_size < CESA_SA_MIN_SRAM_SIZE)
+		sram_size = CESA_SA_MIN_SRAM_SIZE;
+
+	cesa->sram_size = sram_size;
+	cesa->engines = devm_kcalloc(dev, caps->nengines, sizeof(*engines),
+				     GFP_KERNEL);
+	if (!cesa->engines)
+		return -ENOMEM;
+
+	spin_lock_init(&cesa->lock);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	cesa->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(cesa->regs))
+		return PTR_ERR(cesa->regs);
+
+	ret = mv_cesa_dev_dma_init(cesa);
+	if (ret)
+		return ret;
+
+	dram = mv_mbus_dram_info_nooverlap();
+
+	platform_set_drvdata(pdev, cesa);
+
+	for (i = 0; i < caps->nengines; i++) {
+		struct mv_cesa_engine *engine = &cesa->engines[i];
+		char res_name[7];
+
+		engine->id = i;
+		spin_lock_init(&engine->lock);
+
+		ret = mv_cesa_get_sram(pdev, i);
+		if (ret)
+			goto err_cleanup;
+
+		irq = platform_get_irq(pdev, i);
+		if (irq < 0) {
+			ret = irq;
+			goto err_cleanup;
+		}
+
+		/*
+		 * Not all platforms can gate the CESA clocks: do not complain
+		 * if the clock does not exist.
+		 */
+		snprintf(res_name, sizeof(res_name), "cesa%d", i);
+		engine->clk = devm_clk_get(dev, res_name);
+		if (IS_ERR(engine->clk)) {
+			engine->clk = devm_clk_get(dev, NULL);
+			if (IS_ERR(engine->clk))
+				engine->clk = NULL;
+		}
+
+		snprintf(res_name, sizeof(res_name), "cesaz%d", i);
+		engine->zclk = devm_clk_get(dev, res_name);
+		if (IS_ERR(engine->zclk))
+			engine->zclk = NULL;
+
+		ret = clk_prepare_enable(engine->clk);
+		if (ret)
+			goto err_cleanup;
+
+		ret = clk_prepare_enable(engine->zclk);
+		if (ret)
+			goto err_cleanup;
+
+		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
+
+		if (dram && cesa->caps->has_tdma)
+			mv_cesa_conf_mbus_windows(engine, dram);
+
+		writel(0, engine->regs + CESA_SA_INT_STATUS);
+		writel(CESA_SA_CFG_STOP_DIG_ERR,
+		       engine->regs + CESA_SA_CFG);
+		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
+		       engine->regs + CESA_SA_DESC_P0);
+
+		ret = devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
+						IRQF_ONESHOT,
+						dev_name(&pdev->dev),
+						engine);
+		if (ret)
+			goto err_cleanup;
+
+		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
+		atomic_set(&engine->load, 0);
+		INIT_LIST_HEAD(&engine->complete_queue);
+	}
+
+	cesa_dev = cesa;
+
+	ret = mv_cesa_add_algs(cesa);
+	if (ret) {
+		cesa_dev = NULL;
+		goto err_cleanup;
+	}
+
+	dev_info(dev, "CESA device successfully registered\n");
+
+	return 0;
+
+err_cleanup:
+	for (i = 0; i < caps->nengines; i++) {
+		clk_disable_unprepare(cesa->engines[i].zclk);
+		clk_disable_unprepare(cesa->engines[i].clk);
+		mv_cesa_put_sram(pdev, i);
+	}
+
+	return ret;
+}
+
+static int mv_cesa_remove(struct platform_device *pdev)
+{
+	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
+	int i;
+
+	mv_cesa_remove_algs(cesa);
+
+	for (i = 0; i < cesa->caps->nengines; i++) {
+		clk_disable_unprepare(cesa->engines[i].zclk);
+		clk_disable_unprepare(cesa->engines[i].clk);
+		mv_cesa_put_sram(pdev, i);
+	}
+
+	return 0;
+}
+
+static const struct platform_device_id mv_cesa_plat_id_table[] = {
+	{ .name = "mv_crypto" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(platform, mv_cesa_plat_id_table);
+
+static struct platform_driver marvell_cesa = {
+	.probe		= mv_cesa_probe,
+	.remove		= mv_cesa_remove,
+	.id_table	= mv_cesa_plat_id_table,
+	.driver		= {
+		.name	= "marvell-cesa",
+		.of_match_table = mv_cesa_of_match_table,
+	},
+};
+module_platform_driver(marvell_cesa);
+
+MODULE_ALIAS("platform:mv_crypto");
+MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
+MODULE_AUTHOR("Arnaud Ebalard <arno@natisbad.org>");
+MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
new file mode 100644
index 0000000..e8632d5
--- /dev/null
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -0,0 +1,881 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MARVELL_CESA_H__
+#define __MARVELL_CESA_H__
+
+#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+
+#include <linux/crypto.h>
+#include <linux/dmapool.h>
+
+#define CESA_ENGINE_OFF(i)			(((i) * 0x2000))
+
+#define CESA_TDMA_BYTE_CNT			0x800
+#define CESA_TDMA_SRC_ADDR			0x810
+#define CESA_TDMA_DST_ADDR			0x820
+#define CESA_TDMA_NEXT_ADDR			0x830
+
+#define CESA_TDMA_CONTROL			0x840
+#define CESA_TDMA_DST_BURST			GENMASK(2, 0)
+#define CESA_TDMA_DST_BURST_32B			3
+#define CESA_TDMA_DST_BURST_128B		4
+#define CESA_TDMA_OUT_RD_EN			BIT(4)
+#define CESA_TDMA_SRC_BURST			GENMASK(8, 6)
+#define CESA_TDMA_SRC_BURST_32B			(3 << 6)
+#define CESA_TDMA_SRC_BURST_128B		(4 << 6)
+#define CESA_TDMA_CHAIN				BIT(9)
+#define CESA_TDMA_BYTE_SWAP			BIT(11)
+#define CESA_TDMA_NO_BYTE_SWAP			BIT(11)
+#define CESA_TDMA_EN				BIT(12)
+#define CESA_TDMA_FETCH_ND			BIT(13)
+#define CESA_TDMA_ACT				BIT(14)
+
+#define CESA_TDMA_CUR				0x870
+#define CESA_TDMA_ERROR_CAUSE			0x8c8
+#define CESA_TDMA_ERROR_MSK			0x8cc
+
+#define CESA_TDMA_WINDOW_BASE(x)		(((x) * 0x8) + 0xa00)
+#define CESA_TDMA_WINDOW_CTRL(x)		(((x) * 0x8) + 0xa04)
+
+#define CESA_IVDIG(x)				(0xdd00 + ((x) * 4) +	\
+						 (((x) < 5) ? 0 : 0x14))
+
+#define CESA_SA_CMD				0xde00
+#define CESA_SA_CMD_EN_CESA_SA_ACCL0		BIT(0)
+#define CESA_SA_CMD_EN_CESA_SA_ACCL1		BIT(1)
+#define CESA_SA_CMD_DISABLE_SEC			BIT(2)
+
+#define CESA_SA_DESC_P0				0xde04
+
+#define CESA_SA_DESC_P1				0xde14
+
+#define CESA_SA_CFG				0xde08
+#define CESA_SA_CFG_STOP_DIG_ERR		GENMASK(1, 0)
+#define CESA_SA_CFG_DIG_ERR_CONT		0
+#define CESA_SA_CFG_DIG_ERR_SKIP		1
+#define CESA_SA_CFG_DIG_ERR_STOP		3
+#define CESA_SA_CFG_CH0_W_IDMA			BIT(7)
+#define CESA_SA_CFG_CH1_W_IDMA			BIT(8)
+#define CESA_SA_CFG_ACT_CH0_IDMA		BIT(9)
+#define CESA_SA_CFG_ACT_CH1_IDMA		BIT(10)
+#define CESA_SA_CFG_MULTI_PKT			BIT(11)
+#define CESA_SA_CFG_PARA_DIS			BIT(13)
+
+#define CESA_SA_ACCEL_STATUS			0xde0c
+#define CESA_SA_ST_ACT_0			BIT(0)
+#define CESA_SA_ST_ACT_1			BIT(1)
+
+/*
+ * CESA_SA_FPGA_INT_STATUS looks like a FPGA leftover and is documented only
+ * in Errata 4.12. It looks like that it was part of an IRQ-controller in FPGA
+ * and someone forgot to remove  it while switching to the core and moving to
+ * CESA_SA_INT_STATUS.
+ */
+#define CESA_SA_FPGA_INT_STATUS			0xdd68
+#define CESA_SA_INT_STATUS			0xde20
+#define CESA_SA_INT_AUTH_DONE			BIT(0)
+#define CESA_SA_INT_DES_E_DONE			BIT(1)
+#define CESA_SA_INT_AES_E_DONE			BIT(2)
+#define CESA_SA_INT_AES_D_DONE			BIT(3)
+#define CESA_SA_INT_ENC_DONE			BIT(4)
+#define CESA_SA_INT_ACCEL0_DONE			BIT(5)
+#define CESA_SA_INT_ACCEL1_DONE			BIT(6)
+#define CESA_SA_INT_ACC0_IDMA_DONE		BIT(7)
+#define CESA_SA_INT_ACC1_IDMA_DONE		BIT(8)
+#define CESA_SA_INT_IDMA_DONE			BIT(9)
+#define CESA_SA_INT_IDMA_OWN_ERR		BIT(10)
+
+#define CESA_SA_INT_MSK				0xde24
+
+#define CESA_SA_DESC_CFG_OP_MAC_ONLY		0
+#define CESA_SA_DESC_CFG_OP_CRYPT_ONLY		1
+#define CESA_SA_DESC_CFG_OP_MAC_CRYPT		2
+#define CESA_SA_DESC_CFG_OP_CRYPT_MAC		3
+#define CESA_SA_DESC_CFG_OP_MSK			GENMASK(1, 0)
+#define CESA_SA_DESC_CFG_MACM_SHA256		(1 << 4)
+#define CESA_SA_DESC_CFG_MACM_HMAC_SHA256	(3 << 4)
+#define CESA_SA_DESC_CFG_MACM_MD5		(4 << 4)
+#define CESA_SA_DESC_CFG_MACM_SHA1		(5 << 4)
+#define CESA_SA_DESC_CFG_MACM_HMAC_MD5		(6 << 4)
+#define CESA_SA_DESC_CFG_MACM_HMAC_SHA1		(7 << 4)
+#define CESA_SA_DESC_CFG_MACM_MSK		GENMASK(6, 4)
+#define CESA_SA_DESC_CFG_CRYPTM_DES		(1 << 8)
+#define CESA_SA_DESC_CFG_CRYPTM_3DES		(2 << 8)
+#define CESA_SA_DESC_CFG_CRYPTM_AES		(3 << 8)
+#define CESA_SA_DESC_CFG_CRYPTM_MSK		GENMASK(9, 8)
+#define CESA_SA_DESC_CFG_DIR_ENC		(0 << 12)
+#define CESA_SA_DESC_CFG_DIR_DEC		(1 << 12)
+#define CESA_SA_DESC_CFG_CRYPTCM_ECB		(0 << 16)
+#define CESA_SA_DESC_CFG_CRYPTCM_CBC		(1 << 16)
+#define CESA_SA_DESC_CFG_CRYPTCM_MSK		BIT(16)
+#define CESA_SA_DESC_CFG_3DES_EEE		(0 << 20)
+#define CESA_SA_DESC_CFG_3DES_EDE		(1 << 20)
+#define CESA_SA_DESC_CFG_AES_LEN_128		(0 << 24)
+#define CESA_SA_DESC_CFG_AES_LEN_192		(1 << 24)
+#define CESA_SA_DESC_CFG_AES_LEN_256		(2 << 24)
+#define CESA_SA_DESC_CFG_AES_LEN_MSK		GENMASK(25, 24)
+#define CESA_SA_DESC_CFG_NOT_FRAG		(0 << 30)
+#define CESA_SA_DESC_CFG_FIRST_FRAG		(1 << 30)
+#define CESA_SA_DESC_CFG_LAST_FRAG		(2 << 30)
+#define CESA_SA_DESC_CFG_MID_FRAG		(3 << 30)
+#define CESA_SA_DESC_CFG_FRAG_MSK		GENMASK(31, 30)
+
+/*
+ * /-----------\ 0
+ * | ACCEL CFG |	4 * 8
+ * |-----------| 0x20
+ * | CRYPT KEY |	8 * 4
+ * |-----------| 0x40
+ * |  IV   IN  |	4 * 4
+ * |-----------| 0x40 (inplace)
+ * |  IV BUF   |	4 * 4
+ * |-----------| 0x80
+ * |  DATA IN  |	16 * x (max ->max_req_size)
+ * |-----------| 0x80 (inplace operation)
+ * |  DATA OUT |	16 * x (max ->max_req_size)
+ * \-----------/ SRAM size
+ */
+
+/*
+ * Hashing memory map:
+ * /-----------\ 0
+ * | ACCEL CFG |        4 * 8
+ * |-----------| 0x20
+ * | Inner IV  |        8 * 4
+ * |-----------| 0x40
+ * | Outer IV  |        8 * 4
+ * |-----------| 0x60
+ * | Output BUF|        8 * 4
+ * |-----------| 0x80
+ * |  DATA IN  |        64 * x (max ->max_req_size)
+ * \-----------/ SRAM size
+ */
+
+#define CESA_SA_CFG_SRAM_OFFSET			0x00
+#define CESA_SA_DATA_SRAM_OFFSET		0x80
+
+#define CESA_SA_CRYPT_KEY_SRAM_OFFSET		0x20
+#define CESA_SA_CRYPT_IV_SRAM_OFFSET		0x40
+
+#define CESA_SA_MAC_IIV_SRAM_OFFSET		0x20
+#define CESA_SA_MAC_OIV_SRAM_OFFSET		0x40
+#define CESA_SA_MAC_DIG_SRAM_OFFSET		0x60
+
+#define CESA_SA_DESC_CRYPT_DATA(offset)					\
+	cpu_to_le32((CESA_SA_DATA_SRAM_OFFSET + (offset)) |		\
+		    ((CESA_SA_DATA_SRAM_OFFSET + (offset)) << 16))
+
+#define CESA_SA_DESC_CRYPT_IV(offset)					\
+	cpu_to_le32((CESA_SA_CRYPT_IV_SRAM_OFFSET + (offset)) |	\
+		    ((CESA_SA_CRYPT_IV_SRAM_OFFSET + (offset)) << 16))
+
+#define CESA_SA_DESC_CRYPT_KEY(offset)					\
+	cpu_to_le32(CESA_SA_CRYPT_KEY_SRAM_OFFSET + (offset))
+
+#define CESA_SA_DESC_MAC_DATA(offset)					\
+	cpu_to_le32(CESA_SA_DATA_SRAM_OFFSET + (offset))
+#define CESA_SA_DESC_MAC_DATA_MSK		cpu_to_le32(GENMASK(15, 0))
+
+#define CESA_SA_DESC_MAC_TOTAL_LEN(total_len)	cpu_to_le32((total_len) << 16)
+#define CESA_SA_DESC_MAC_TOTAL_LEN_MSK		cpu_to_le32(GENMASK(31, 16))
+
+#define CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX	0xffff
+
+#define CESA_SA_DESC_MAC_DIGEST(offset)					\
+	cpu_to_le32(CESA_SA_MAC_DIG_SRAM_OFFSET + (offset))
+#define CESA_SA_DESC_MAC_DIGEST_MSK		cpu_to_le32(GENMASK(15, 0))
+
+#define CESA_SA_DESC_MAC_FRAG_LEN(frag_len)	cpu_to_le32((frag_len) << 16)
+#define CESA_SA_DESC_MAC_FRAG_LEN_MSK		cpu_to_le32(GENMASK(31, 16))
+
+#define CESA_SA_DESC_MAC_IV(offset)					\
+	cpu_to_le32((CESA_SA_MAC_IIV_SRAM_OFFSET + (offset)) |		\
+		    ((CESA_SA_MAC_OIV_SRAM_OFFSET + (offset)) << 16))
+
+#define CESA_SA_SRAM_SIZE			2048
+#define CESA_SA_SRAM_PAYLOAD_SIZE		(cesa_dev->sram_size - \
+						 CESA_SA_DATA_SRAM_OFFSET)
+
+#define CESA_SA_DEFAULT_SRAM_SIZE		2048
+#define CESA_SA_MIN_SRAM_SIZE			1024
+
+#define CESA_SA_SRAM_MSK			(2048 - 1)
+
+#define CESA_MAX_HASH_BLOCK_SIZE		64
+#define CESA_HASH_BLOCK_SIZE_MSK		(CESA_MAX_HASH_BLOCK_SIZE - 1)
+
+/**
+ * struct mv_cesa_sec_accel_desc - security accelerator descriptor
+ * @config:	engine config
+ * @enc_p:	input and output data pointers for a cipher operation
+ * @enc_len:	cipher operation length
+ * @enc_key_p:	cipher key pointer
+ * @enc_iv:	cipher IV pointers
+ * @mac_src_p:	input pointer and total hash length
+ * @mac_digest:	digest pointer and hash operation length
+ * @mac_iv:	hmac IV pointers
+ *
+ * Structure passed to the CESA engine to describe the crypto operation
+ * to be executed.
+ */
+struct mv_cesa_sec_accel_desc {
+	__le32 config;
+	__le32 enc_p;
+	__le32 enc_len;
+	__le32 enc_key_p;
+	__le32 enc_iv;
+	__le32 mac_src_p;
+	__le32 mac_digest;
+	__le32 mac_iv;
+};
+
+/**
+ * struct mv_cesa_skcipher_op_ctx - cipher operation context
+ * @key:	cipher key
+ * @iv:		cipher IV
+ *
+ * Context associated to a cipher operation.
+ */
+struct mv_cesa_skcipher_op_ctx {
+	u32 key[8];
+	u32 iv[4];
+};
+
+/**
+ * struct mv_cesa_hash_op_ctx - hash or hmac operation context
+ * @key:	cipher key
+ * @iv:		cipher IV
+ *
+ * Context associated to an hash or hmac operation.
+ */
+struct mv_cesa_hash_op_ctx {
+	u32 iv[16];
+	u32 hash[8];
+};
+
+/**
+ * struct mv_cesa_op_ctx - crypto operation context
+ * @desc:	CESA descriptor
+ * @ctx:	context associated to the crypto operation
+ *
+ * Context associated to a crypto operation.
+ */
+struct mv_cesa_op_ctx {
+	struct mv_cesa_sec_accel_desc desc;
+	union {
+		struct mv_cesa_skcipher_op_ctx skcipher;
+		struct mv_cesa_hash_op_ctx hash;
+	} ctx;
+};
+
+/* TDMA descriptor flags */
+#define CESA_TDMA_DST_IN_SRAM			BIT(31)
+#define CESA_TDMA_SRC_IN_SRAM			BIT(30)
+#define CESA_TDMA_END_OF_REQ			BIT(29)
+#define CESA_TDMA_BREAK_CHAIN			BIT(28)
+#define CESA_TDMA_SET_STATE			BIT(27)
+#define CESA_TDMA_TYPE_MSK			GENMASK(26, 0)
+#define CESA_TDMA_DUMMY				0
+#define CESA_TDMA_DATA				1
+#define CESA_TDMA_OP				2
+#define CESA_TDMA_RESULT			3
+
+/**
+ * struct mv_cesa_tdma_desc - TDMA descriptor
+ * @byte_cnt:	number of bytes to transfer
+ * @src:	DMA address of the source
+ * @dst:	DMA address of the destination
+ * @next_dma:	DMA address of the next TDMA descriptor
+ * @cur_dma:	DMA address of this TDMA descriptor
+ * @next:	pointer to the next TDMA descriptor
+ * @op:		CESA operation attached to this TDMA descriptor
+ * @data:	raw data attached to this TDMA descriptor
+ * @flags:	flags describing the TDMA transfer. See the
+ *		"TDMA descriptor flags" section above
+ *
+ * TDMA descriptor used to create a transfer chain describing a crypto
+ * operation.
+ */
+struct mv_cesa_tdma_desc {
+	__le32 byte_cnt;
+	__le32 src;
+	__le32 dst;
+	__le32 next_dma;
+
+	/* Software state */
+	dma_addr_t cur_dma;
+	struct mv_cesa_tdma_desc *next;
+	union {
+		struct mv_cesa_op_ctx *op;
+		void *data;
+	};
+	u32 flags;
+};
+
+/**
+ * struct mv_cesa_sg_dma_iter - scatter-gather iterator
+ * @dir:	transfer direction
+ * @sg:		scatter list
+ * @offset:	current position in the scatter list
+ * @op_offset:	current position in the crypto operation
+ *
+ * Iterator used to iterate over a scatterlist while creating a TDMA chain for
+ * a crypto operation.
+ */
+struct mv_cesa_sg_dma_iter {
+	enum dma_data_direction dir;
+	struct scatterlist *sg;
+	unsigned int offset;
+	unsigned int op_offset;
+};
+
+/**
+ * struct mv_cesa_dma_iter - crypto operation iterator
+ * @len:	the crypto operation length
+ * @offset:	current position in the crypto operation
+ * @op_len:	sub-operation length (the crypto engine can only act on 2kb
+ *		chunks)
+ *
+ * Iterator used to create a TDMA chain for a given crypto operation.
+ */
+struct mv_cesa_dma_iter {
+	unsigned int len;
+	unsigned int offset;
+	unsigned int op_len;
+};
+
+/**
+ * struct mv_cesa_tdma_chain - TDMA chain
+ * @first:	first entry in the TDMA chain
+ * @last:	last entry in the TDMA chain
+ *
+ * Stores a TDMA chain for a specific crypto operation.
+ */
+struct mv_cesa_tdma_chain {
+	struct mv_cesa_tdma_desc *first;
+	struct mv_cesa_tdma_desc *last;
+};
+
+struct mv_cesa_engine;
+
+/**
+ * struct mv_cesa_caps - CESA device capabilities
+ * @engines:		number of engines
+ * @has_tdma:		whether this device has a TDMA block
+ * @cipher_algs:	supported cipher algorithms
+ * @ncipher_algs:	number of supported cipher algorithms
+ * @ahash_algs:		supported hash algorithms
+ * @nahash_algs:	number of supported hash algorithms
+ *
+ * Structure used to describe CESA device capabilities.
+ */
+struct mv_cesa_caps {
+	int nengines;
+	bool has_tdma;
+	struct skcipher_alg **cipher_algs;
+	int ncipher_algs;
+	struct ahash_alg **ahash_algs;
+	int nahash_algs;
+};
+
+/**
+ * struct mv_cesa_dev_dma - DMA pools
+ * @tdma_desc_pool:	TDMA desc pool
+ * @op_pool:		crypto operation pool
+ * @cache_pool:		data cache pool (used by hash implementation when the
+ *			hash request is smaller than the hash block size)
+ * @padding_pool:	padding pool (used by hash implementation when hardware
+ *			padding cannot be used)
+ *
+ * Structure containing the different DMA pools used by this driver.
+ */
+struct mv_cesa_dev_dma {
+	struct dma_pool *tdma_desc_pool;
+	struct dma_pool *op_pool;
+	struct dma_pool *cache_pool;
+	struct dma_pool *padding_pool;
+};
+
+/**
+ * struct mv_cesa_dev - CESA device
+ * @caps:	device capabilities
+ * @regs:	device registers
+ * @sram_size:	usable SRAM size
+ * @lock:	device lock
+ * @engines:	array of engines
+ * @dma:	dma pools
+ *
+ * Structure storing CESA device information.
+ */
+struct mv_cesa_dev {
+	const struct mv_cesa_caps *caps;
+	void __iomem *regs;
+	struct device *dev;
+	unsigned int sram_size;
+	spinlock_t lock;
+	struct mv_cesa_engine *engines;
+	struct mv_cesa_dev_dma *dma;
+};
+
+/**
+ * struct mv_cesa_engine - CESA engine
+ * @id:			engine id
+ * @regs:		engine registers
+ * @sram:		SRAM memory region
+ * @sram_dma:		DMA address of the SRAM memory region
+ * @lock:		engine lock
+ * @req:		current crypto request
+ * @clk:		engine clk
+ * @zclk:		engine zclk
+ * @max_req_len:	maximum chunk length (useful to create the TDMA chain)
+ * @int_mask:		interrupt mask cache
+ * @pool:		memory pool pointing to the memory region reserved in
+ *			SRAM
+ * @queue:		fifo of the pending crypto requests
+ * @load:		engine load counter, useful for load balancing
+ * @chain:		list of the current tdma descriptors being processed
+ *			by this engine.
+ * @complete_queue:	fifo of the processed requests by the engine
+ *
+ * Structure storing CESA engine information.
+ */
+struct mv_cesa_engine {
+	int id;
+	void __iomem *regs;
+	void __iomem *sram;
+	dma_addr_t sram_dma;
+	spinlock_t lock;
+	struct crypto_async_request *req;
+	struct clk *clk;
+	struct clk *zclk;
+	size_t max_req_len;
+	u32 int_mask;
+	struct gen_pool *pool;
+	struct crypto_queue queue;
+	atomic_t load;
+	struct mv_cesa_tdma_chain chain;
+	struct list_head complete_queue;
+};
+
+/**
+ * struct mv_cesa_req_ops - CESA request operations
+ * @process:	process a request chunk result (should return 0 if the
+ *		operation, -EINPROGRESS if it needs more steps or an error
+ *		code)
+ * @step:	launch the crypto operation on the next chunk
+ * @cleanup:	cleanup the crypto request (release associated data)
+ * @complete:	complete the request, i.e copy result or context from sram when
+ *		needed.
+ */
+struct mv_cesa_req_ops {
+	int (*process)(struct crypto_async_request *req, u32 status);
+	void (*step)(struct crypto_async_request *req);
+	void (*cleanup)(struct crypto_async_request *req);
+	void (*complete)(struct crypto_async_request *req);
+};
+
+/**
+ * struct mv_cesa_ctx - CESA operation context
+ * @ops:	crypto operations
+ *
+ * Base context structure inherited by operation specific ones.
+ */
+struct mv_cesa_ctx {
+	const struct mv_cesa_req_ops *ops;
+};
+
+/**
+ * struct mv_cesa_hash_ctx - CESA hash operation context
+ * @base:	base context structure
+ *
+ * Hash context structure.
+ */
+struct mv_cesa_hash_ctx {
+	struct mv_cesa_ctx base;
+};
+
+/**
+ * struct mv_cesa_hash_ctx - CESA hmac operation context
+ * @base:	base context structure
+ * @iv:		initialization vectors
+ *
+ * HMAC context structure.
+ */
+struct mv_cesa_hmac_ctx {
+	struct mv_cesa_ctx base;
+	u32 iv[16];
+};
+
+/**
+ * enum mv_cesa_req_type - request type definitions
+ * @CESA_STD_REQ:	standard request
+ * @CESA_DMA_REQ:	DMA request
+ */
+enum mv_cesa_req_type {
+	CESA_STD_REQ,
+	CESA_DMA_REQ,
+};
+
+/**
+ * struct mv_cesa_req - CESA request
+ * @engine:	engine associated with this request
+ * @chain:	list of tdma descriptors associated  with this request
+ */
+struct mv_cesa_req {
+	struct mv_cesa_engine *engine;
+	struct mv_cesa_tdma_chain chain;
+};
+
+/**
+ * struct mv_cesa_sg_std_iter - CESA scatter-gather iterator for standard
+ *				requests
+ * @iter:	sg mapping iterator
+ * @offset:	current offset in the SG entry mapped in memory
+ */
+struct mv_cesa_sg_std_iter {
+	struct sg_mapping_iter iter;
+	unsigned int offset;
+};
+
+/**
+ * struct mv_cesa_skcipher_std_req - cipher standard request
+ * @op:		operation context
+ * @offset:	current operation offset
+ * @size:	size of the crypto operation
+ */
+struct mv_cesa_skcipher_std_req {
+	struct mv_cesa_op_ctx op;
+	unsigned int offset;
+	unsigned int size;
+	bool skip_ctx;
+};
+
+/**
+ * struct mv_cesa_skcipher_req - cipher request
+ * @req:	type specific request information
+ * @src_nents:	number of entries in the src sg list
+ * @dst_nents:	number of entries in the dest sg list
+ */
+struct mv_cesa_skcipher_req {
+	struct mv_cesa_req base;
+	struct mv_cesa_skcipher_std_req std;
+	int src_nents;
+	int dst_nents;
+};
+
+/**
+ * struct mv_cesa_ahash_std_req - standard hash request
+ * @offset:	current operation offset
+ */
+struct mv_cesa_ahash_std_req {
+	unsigned int offset;
+};
+
+/**
+ * struct mv_cesa_ahash_dma_req - DMA hash request
+ * @padding:		padding buffer
+ * @padding_dma:	DMA address of the padding buffer
+ * @cache_dma:		DMA address of the cache buffer
+ */
+struct mv_cesa_ahash_dma_req {
+	u8 *padding;
+	dma_addr_t padding_dma;
+	u8 *cache;
+	dma_addr_t cache_dma;
+};
+
+/**
+ * struct mv_cesa_ahash_req - hash request
+ * @req:		type specific request information
+ * @cache:		cache buffer
+ * @cache_ptr:		write pointer in the cache buffer
+ * @len:		hash total length
+ * @src_nents:		number of entries in the scatterlist
+ * @last_req:		define whether the current operation is the last one
+ *			or not
+ * @state:		hash state
+ */
+struct mv_cesa_ahash_req {
+	struct mv_cesa_req base;
+	union {
+		struct mv_cesa_ahash_dma_req dma;
+		struct mv_cesa_ahash_std_req std;
+	} req;
+	struct mv_cesa_op_ctx op_tmpl;
+	u8 cache[CESA_MAX_HASH_BLOCK_SIZE];
+	unsigned int cache_ptr;
+	u64 len;
+	int src_nents;
+	bool last_req;
+	bool algo_le;
+	u32 state[8];
+};
+
+/* CESA functions */
+
+extern struct mv_cesa_dev *cesa_dev;
+
+
+static inline void
+mv_cesa_engine_enqueue_complete_request(struct mv_cesa_engine *engine,
+					struct crypto_async_request *req)
+{
+	list_add_tail(&req->list, &engine->complete_queue);
+}
+
+static inline struct crypto_async_request *
+mv_cesa_engine_dequeue_complete_request(struct mv_cesa_engine *engine)
+{
+	struct crypto_async_request *req;
+
+	req = list_first_entry_or_null(&engine->complete_queue,
+				       struct crypto_async_request,
+				       list);
+	if (req)
+		list_del(&req->list);
+
+	return req;
+}
+
+
+static inline enum mv_cesa_req_type
+mv_cesa_req_get_type(struct mv_cesa_req *req)
+{
+	return req->chain.first ? CESA_DMA_REQ : CESA_STD_REQ;
+}
+
+static inline void mv_cesa_update_op_cfg(struct mv_cesa_op_ctx *op,
+					 u32 cfg, u32 mask)
+{
+	op->desc.config &= cpu_to_le32(~mask);
+	op->desc.config |= cpu_to_le32(cfg);
+}
+
+static inline u32 mv_cesa_get_op_cfg(const struct mv_cesa_op_ctx *op)
+{
+	return le32_to_cpu(op->desc.config);
+}
+
+static inline void mv_cesa_set_op_cfg(struct mv_cesa_op_ctx *op, u32 cfg)
+{
+	op->desc.config = cpu_to_le32(cfg);
+}
+
+static inline void mv_cesa_adjust_op(struct mv_cesa_engine *engine,
+				     struct mv_cesa_op_ctx *op)
+{
+	u32 offset = engine->sram_dma & CESA_SA_SRAM_MSK;
+
+	op->desc.enc_p = CESA_SA_DESC_CRYPT_DATA(offset);
+	op->desc.enc_key_p = CESA_SA_DESC_CRYPT_KEY(offset);
+	op->desc.enc_iv = CESA_SA_DESC_CRYPT_IV(offset);
+	op->desc.mac_src_p &= ~CESA_SA_DESC_MAC_DATA_MSK;
+	op->desc.mac_src_p |= CESA_SA_DESC_MAC_DATA(offset);
+	op->desc.mac_digest &= ~CESA_SA_DESC_MAC_DIGEST_MSK;
+	op->desc.mac_digest |= CESA_SA_DESC_MAC_DIGEST(offset);
+	op->desc.mac_iv = CESA_SA_DESC_MAC_IV(offset);
+}
+
+static inline void mv_cesa_set_crypt_op_len(struct mv_cesa_op_ctx *op, int len)
+{
+	op->desc.enc_len = cpu_to_le32(len);
+}
+
+static inline void mv_cesa_set_mac_op_total_len(struct mv_cesa_op_ctx *op,
+						int len)
+{
+	op->desc.mac_src_p &= ~CESA_SA_DESC_MAC_TOTAL_LEN_MSK;
+	op->desc.mac_src_p |= CESA_SA_DESC_MAC_TOTAL_LEN(len);
+}
+
+static inline void mv_cesa_set_mac_op_frag_len(struct mv_cesa_op_ctx *op,
+					       int len)
+{
+	op->desc.mac_digest &= ~CESA_SA_DESC_MAC_FRAG_LEN_MSK;
+	op->desc.mac_digest |= CESA_SA_DESC_MAC_FRAG_LEN(len);
+}
+
+static inline void mv_cesa_set_int_mask(struct mv_cesa_engine *engine,
+					u32 int_mask)
+{
+	if (int_mask == engine->int_mask)
+		return;
+
+	writel_relaxed(int_mask, engine->regs + CESA_SA_INT_MSK);
+	engine->int_mask = int_mask;
+}
+
+static inline u32 mv_cesa_get_int_mask(struct mv_cesa_engine *engine)
+{
+	return engine->int_mask;
+}
+
+static inline bool mv_cesa_mac_op_is_first_frag(const struct mv_cesa_op_ctx *op)
+{
+	return (mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK) ==
+		CESA_SA_DESC_CFG_FIRST_FRAG;
+}
+
+int mv_cesa_queue_req(struct crypto_async_request *req,
+		      struct mv_cesa_req *creq);
+
+struct crypto_async_request *
+mv_cesa_dequeue_req_locked(struct mv_cesa_engine *engine,
+			   struct crypto_async_request **backlog);
+
+static inline struct mv_cesa_engine *mv_cesa_select_engine(int weight)
+{
+	int i;
+	u32 min_load = U32_MAX;
+	struct mv_cesa_engine *selected = NULL;
+
+	for (i = 0; i < cesa_dev->caps->nengines; i++) {
+		struct mv_cesa_engine *engine = cesa_dev->engines + i;
+		u32 load = atomic_read(&engine->load);
+
+		if (load < min_load) {
+			min_load = load;
+			selected = engine;
+		}
+	}
+
+	atomic_add(weight, &selected->load);
+
+	return selected;
+}
+
+/*
+ * Helper function that indicates whether a crypto request needs to be
+ * cleaned up or not after being enqueued using mv_cesa_queue_req().
+ */
+static inline int mv_cesa_req_needs_cleanup(struct crypto_async_request *req,
+					    int ret)
+{
+	/*
+	 * The queue still had some space, the request was queued
+	 * normally, so there's no need to clean it up.
+	 */
+	if (ret == -EINPROGRESS)
+		return false;
+
+	/*
+	 * The queue had not space left, but since the request is
+	 * flagged with CRYPTO_TFM_REQ_MAY_BACKLOG, it was added to
+	 * the backlog and will be processed later. There's no need to
+	 * clean it up.
+	 */
+	if (ret == -EBUSY)
+		return false;
+
+	/* Request wasn't queued, we need to clean it up */
+	return true;
+}
+
+/* TDMA functions */
+
+static inline void mv_cesa_req_dma_iter_init(struct mv_cesa_dma_iter *iter,
+					     unsigned int len)
+{
+	iter->len = len;
+	iter->op_len = min(len, CESA_SA_SRAM_PAYLOAD_SIZE);
+	iter->offset = 0;
+}
+
+static inline void mv_cesa_sg_dma_iter_init(struct mv_cesa_sg_dma_iter *iter,
+					    struct scatterlist *sg,
+					    enum dma_data_direction dir)
+{
+	iter->op_offset = 0;
+	iter->offset = 0;
+	iter->sg = sg;
+	iter->dir = dir;
+}
+
+static inline unsigned int
+mv_cesa_req_dma_iter_transfer_len(struct mv_cesa_dma_iter *iter,
+				  struct mv_cesa_sg_dma_iter *sgiter)
+{
+	return min(iter->op_len - sgiter->op_offset,
+		   sg_dma_len(sgiter->sg) - sgiter->offset);
+}
+
+bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *chain,
+					struct mv_cesa_sg_dma_iter *sgiter,
+					unsigned int len);
+
+static inline bool mv_cesa_req_dma_iter_next_op(struct mv_cesa_dma_iter *iter)
+{
+	iter->offset += iter->op_len;
+	iter->op_len = min(iter->len - iter->offset,
+			   CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	return iter->op_len;
+}
+
+void mv_cesa_dma_step(struct mv_cesa_req *dreq);
+
+static inline int mv_cesa_dma_process(struct mv_cesa_req *dreq,
+				      u32 status)
+{
+	if (!(status & CESA_SA_INT_ACC0_IDMA_DONE))
+		return -EINPROGRESS;
+
+	if (status & CESA_SA_INT_IDMA_OWN_ERR)
+		return -EINVAL;
+
+	return 0;
+}
+
+void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
+			 struct mv_cesa_engine *engine);
+void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq);
+void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
+			struct mv_cesa_req *dreq);
+int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status);
+
+
+static inline void
+mv_cesa_tdma_desc_iter_init(struct mv_cesa_tdma_chain *chain)
+{
+	memset(chain, 0, sizeof(*chain));
+}
+
+int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
+			  u32 size, u32 flags, gfp_t gfp_flags);
+
+struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
+					const struct mv_cesa_op_ctx *op_templ,
+					bool skip_ctx,
+					gfp_t flags);
+
+int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
+				  dma_addr_t dst, dma_addr_t src, u32 size,
+				  u32 flags, gfp_t gfp_flags);
+
+int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain, gfp_t flags);
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, gfp_t flags);
+
+int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
+				 struct mv_cesa_dma_iter *dma_iter,
+				 struct mv_cesa_sg_dma_iter *sgiter,
+				 gfp_t gfp_flags);
+
+/* Algorithm definitions */
+
+extern struct ahash_alg mv_md5_alg;
+extern struct ahash_alg mv_sha1_alg;
+extern struct ahash_alg mv_sha256_alg;
+extern struct ahash_alg mv_ahmac_md5_alg;
+extern struct ahash_alg mv_ahmac_sha1_alg;
+extern struct ahash_alg mv_ahmac_sha256_alg;
+
+extern struct skcipher_alg mv_cesa_ecb_des_alg;
+extern struct skcipher_alg mv_cesa_cbc_des_alg;
+extern struct skcipher_alg mv_cesa_ecb_des3_ede_alg;
+extern struct skcipher_alg mv_cesa_cbc_des3_ede_alg;
+extern struct skcipher_alg mv_cesa_ecb_aes_alg;
+extern struct skcipher_alg mv_cesa_cbc_aes_alg;
+
+#endif /* __MARVELL_CESA_H__ */
diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
new file mode 100644
index 0000000..f133c2c
--- /dev/null
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -0,0 +1,801 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Cipher algorithms supported by the CESA: DES, 3DES and AES.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ */
+
+#include <crypto/aes.h>
+#include <crypto/internal/des.h>
+
+#include "cesa.h"
+
+struct mv_cesa_des_ctx {
+	struct mv_cesa_ctx base;
+	u8 key[DES_KEY_SIZE];
+};
+
+struct mv_cesa_des3_ctx {
+	struct mv_cesa_ctx base;
+	u8 key[DES3_EDE_KEY_SIZE];
+};
+
+struct mv_cesa_aes_ctx {
+	struct mv_cesa_ctx base;
+	struct crypto_aes_ctx aes;
+};
+
+struct mv_cesa_skcipher_dma_iter {
+	struct mv_cesa_dma_iter base;
+	struct mv_cesa_sg_dma_iter src;
+	struct mv_cesa_sg_dma_iter dst;
+};
+
+static inline void
+mv_cesa_skcipher_req_iter_init(struct mv_cesa_skcipher_dma_iter *iter,
+			       struct skcipher_request *req)
+{
+	mv_cesa_req_dma_iter_init(&iter->base, req->cryptlen);
+	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
+	mv_cesa_sg_dma_iter_init(&iter->dst, req->dst, DMA_FROM_DEVICE);
+}
+
+static inline bool
+mv_cesa_skcipher_req_iter_next_op(struct mv_cesa_skcipher_dma_iter *iter)
+{
+	iter->src.op_offset = 0;
+	iter->dst.op_offset = 0;
+
+	return mv_cesa_req_dma_iter_next_op(&iter->base);
+}
+
+static inline void
+mv_cesa_skcipher_dma_cleanup(struct skcipher_request *req)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+
+	if (req->dst != req->src) {
+		dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents,
+			     DMA_FROM_DEVICE);
+		dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents,
+			     DMA_TO_DEVICE);
+	} else {
+		dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents,
+			     DMA_BIDIRECTIONAL);
+	}
+	mv_cesa_dma_cleanup(&creq->base);
+}
+
+static inline void mv_cesa_skcipher_cleanup(struct skcipher_request *req)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		mv_cesa_skcipher_dma_cleanup(req);
+}
+
+static void mv_cesa_skcipher_std_step(struct skcipher_request *req)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
+	struct mv_cesa_engine *engine = creq->base.engine;
+	size_t  len = min_t(size_t, req->cryptlen - sreq->offset,
+			    CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	mv_cesa_adjust_op(engine, &sreq->op);
+	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
+
+	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
+				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+				 len, sreq->offset);
+
+	sreq->size = len;
+	mv_cesa_set_crypt_op_len(&sreq->op, len);
+
+	/* FIXME: only update enc_len field */
+	if (!sreq->skip_ctx) {
+		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
+		sreq->skip_ctx = true;
+	} else {
+		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op.desc));
+	}
+
+	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
+	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	WARN_ON(readl(engine->regs + CESA_SA_CMD) &
+		CESA_SA_CMD_EN_CESA_SA_ACCL0);
+	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
+}
+
+static int mv_cesa_skcipher_std_process(struct skcipher_request *req,
+					u32 status)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
+	struct mv_cesa_engine *engine = creq->base.engine;
+	size_t len;
+
+	len = sg_pcopy_from_buffer(req->dst, creq->dst_nents,
+				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+				   sreq->size, sreq->offset);
+
+	sreq->offset += len;
+	if (sreq->offset < req->cryptlen)
+		return -EINPROGRESS;
+
+	return 0;
+}
+
+static int mv_cesa_skcipher_process(struct crypto_async_request *req,
+				    u32 status)
+{
+	struct skcipher_request *skreq = skcipher_request_cast(req);
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
+	struct mv_cesa_req *basereq = &creq->base;
+
+	if (mv_cesa_req_get_type(basereq) == CESA_STD_REQ)
+		return mv_cesa_skcipher_std_process(skreq, status);
+
+	return mv_cesa_dma_process(basereq, status);
+}
+
+static void mv_cesa_skcipher_step(struct crypto_async_request *req)
+{
+	struct skcipher_request *skreq = skcipher_request_cast(req);
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		mv_cesa_dma_step(&creq->base);
+	else
+		mv_cesa_skcipher_std_step(skreq);
+}
+
+static inline void
+mv_cesa_skcipher_dma_prepare(struct skcipher_request *req)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_req *basereq = &creq->base;
+
+	mv_cesa_dma_prepare(basereq, basereq->engine);
+}
+
+static inline void
+mv_cesa_skcipher_std_prepare(struct skcipher_request *req)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
+
+	sreq->size = 0;
+	sreq->offset = 0;
+}
+
+static inline void mv_cesa_skcipher_prepare(struct crypto_async_request *req,
+					    struct mv_cesa_engine *engine)
+{
+	struct skcipher_request *skreq = skcipher_request_cast(req);
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
+
+	creq->base.engine = engine;
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		mv_cesa_skcipher_dma_prepare(skreq);
+	else
+		mv_cesa_skcipher_std_prepare(skreq);
+}
+
+static inline void
+mv_cesa_skcipher_req_cleanup(struct crypto_async_request *req)
+{
+	struct skcipher_request *skreq = skcipher_request_cast(req);
+
+	mv_cesa_skcipher_cleanup(skreq);
+}
+
+static void
+mv_cesa_skcipher_complete(struct crypto_async_request *req)
+{
+	struct skcipher_request *skreq = skcipher_request_cast(req);
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
+	struct mv_cesa_engine *engine = creq->base.engine;
+	unsigned int ivsize;
+
+	atomic_sub(skreq->cryptlen, &engine->load);
+	ivsize = crypto_skcipher_ivsize(crypto_skcipher_reqtfm(skreq));
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ) {
+		struct mv_cesa_req *basereq;
+
+		basereq = &creq->base;
+		memcpy(skreq->iv, basereq->chain.last->op->ctx.skcipher.iv,
+		       ivsize);
+	} else {
+		memcpy_fromio(skreq->iv,
+			      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
+			      ivsize);
+	}
+}
+
+static const struct mv_cesa_req_ops mv_cesa_skcipher_req_ops = {
+	.step = mv_cesa_skcipher_step,
+	.process = mv_cesa_skcipher_process,
+	.cleanup = mv_cesa_skcipher_req_cleanup,
+	.complete = mv_cesa_skcipher_complete,
+};
+
+static void mv_cesa_skcipher_cra_exit(struct crypto_tfm *tfm)
+{
+	void *ctx = crypto_tfm_ctx(tfm);
+
+	memzero_explicit(ctx, tfm->__crt_alg->cra_ctxsize);
+}
+
+static int mv_cesa_skcipher_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->ops = &mv_cesa_skcipher_req_ops;
+
+	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+				    sizeof(struct mv_cesa_skcipher_req));
+
+	return 0;
+}
+
+static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
+			      unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
+	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	int remaining;
+	int offset;
+	int ret;
+	int i;
+
+	ret = aes_expandkey(&ctx->aes, key, len);
+	if (ret)
+		return ret;
+
+	remaining = (ctx->aes.key_length - 16) / 4;
+	offset = ctx->aes.key_length + 24 - remaining;
+	for (i = 0; i < remaining; i++)
+		ctx->aes.key_dec[4 + i] =
+			cpu_to_le32(ctx->aes.key_enc[offset + i]);
+
+	return 0;
+}
+
+static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
+			      unsigned int len)
+{
+	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
+	int err;
+
+	err = verify_skcipher_des_key(cipher, key);
+	if (err)
+		return err;
+
+	memcpy(ctx->key, key, DES_KEY_SIZE);
+
+	return 0;
+}
+
+static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
+				   const u8 *key, unsigned int len)
+{
+	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
+	int err;
+
+	err = verify_skcipher_des3_key(cipher, key);
+	if (err)
+		return err;
+
+	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
+
+	return 0;
+}
+
+static int mv_cesa_skcipher_dma_req_init(struct skcipher_request *req,
+					 const struct mv_cesa_op_ctx *op_templ)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	struct mv_cesa_req *basereq = &creq->base;
+	struct mv_cesa_skcipher_dma_iter iter;
+	bool skip_ctx = false;
+	int ret;
+
+	basereq->chain.first = NULL;
+	basereq->chain.last = NULL;
+
+	if (req->src != req->dst) {
+		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
+				 DMA_TO_DEVICE);
+		if (!ret)
+			return -ENOMEM;
+
+		ret = dma_map_sg(cesa_dev->dev, req->dst, creq->dst_nents,
+				 DMA_FROM_DEVICE);
+		if (!ret) {
+			ret = -ENOMEM;
+			goto err_unmap_src;
+		}
+	} else {
+		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
+				 DMA_BIDIRECTIONAL);
+		if (!ret)
+			return -ENOMEM;
+	}
+
+	mv_cesa_tdma_desc_iter_init(&basereq->chain);
+	mv_cesa_skcipher_req_iter_init(&iter, req);
+
+	do {
+		struct mv_cesa_op_ctx *op;
+
+		op = mv_cesa_dma_add_op(&basereq->chain, op_templ, skip_ctx,
+					flags);
+		if (IS_ERR(op)) {
+			ret = PTR_ERR(op);
+			goto err_free_tdma;
+		}
+		skip_ctx = true;
+
+		mv_cesa_set_crypt_op_len(op, iter.base.op_len);
+
+		/* Add input transfers */
+		ret = mv_cesa_dma_add_op_transfers(&basereq->chain, &iter.base,
+						   &iter.src, flags);
+		if (ret)
+			goto err_free_tdma;
+
+		/* Add dummy desc to launch the crypto operation */
+		ret = mv_cesa_dma_add_dummy_launch(&basereq->chain, flags);
+		if (ret)
+			goto err_free_tdma;
+
+		/* Add output transfers */
+		ret = mv_cesa_dma_add_op_transfers(&basereq->chain, &iter.base,
+						   &iter.dst, flags);
+		if (ret)
+			goto err_free_tdma;
+
+	} while (mv_cesa_skcipher_req_iter_next_op(&iter));
+
+	/* Add output data for IV */
+	ret = mv_cesa_dma_add_result_op(&basereq->chain,
+					CESA_SA_CFG_SRAM_OFFSET,
+					CESA_SA_DATA_SRAM_OFFSET,
+					CESA_TDMA_SRC_IN_SRAM, flags);
+
+	if (ret)
+		goto err_free_tdma;
+
+	basereq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
+
+	return 0;
+
+err_free_tdma:
+	mv_cesa_dma_cleanup(basereq);
+	if (req->dst != req->src)
+		dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents,
+			     DMA_FROM_DEVICE);
+
+err_unmap_src:
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents,
+		     req->dst != req->src ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL);
+
+	return ret;
+}
+
+static inline int
+mv_cesa_skcipher_std_req_init(struct skcipher_request *req,
+			      const struct mv_cesa_op_ctx *op_templ)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
+	struct mv_cesa_req *basereq = &creq->base;
+
+	sreq->op = *op_templ;
+	sreq->skip_ctx = false;
+	basereq->chain.first = NULL;
+	basereq->chain.last = NULL;
+
+	return 0;
+}
+
+static int mv_cesa_skcipher_req_init(struct skcipher_request *req,
+				     struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	unsigned int blksize = crypto_skcipher_blocksize(tfm);
+	int ret;
+
+	if (!IS_ALIGNED(req->cryptlen, blksize))
+		return -EINVAL;
+
+	creq->src_nents = sg_nents_for_len(req->src, req->cryptlen);
+	if (creq->src_nents < 0) {
+		dev_err(cesa_dev->dev, "Invalid number of src SG");
+		return creq->src_nents;
+	}
+	creq->dst_nents = sg_nents_for_len(req->dst, req->cryptlen);
+	if (creq->dst_nents < 0) {
+		dev_err(cesa_dev->dev, "Invalid number of dst SG");
+		return creq->dst_nents;
+	}
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_OP_CRYPT_ONLY,
+			      CESA_SA_DESC_CFG_OP_MSK);
+
+	if (cesa_dev->caps->has_tdma)
+		ret = mv_cesa_skcipher_dma_req_init(req, tmpl);
+	else
+		ret = mv_cesa_skcipher_std_req_init(req, tmpl);
+
+	return ret;
+}
+
+static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
+				      struct mv_cesa_op_ctx *tmpl)
+{
+	int ret;
+	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_engine *engine;
+
+	ret = mv_cesa_skcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	engine = mv_cesa_select_engine(req->cryptlen);
+	mv_cesa_skcipher_prepare(&req->base, engine);
+
+	ret = mv_cesa_queue_req(&req->base, &creq->base);
+
+	if (mv_cesa_req_needs_cleanup(&req->base, ret))
+		mv_cesa_skcipher_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_des_op(struct skcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.skcipher.key, ctx->key, DES_KEY_SIZE);
+
+	return mv_cesa_skcipher_queue_req(req, tmpl);
+}
+
+static int mv_cesa_ecb_des_encrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_des_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_des_decrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_des_op(req, &tmpl);
+}
+
+struct skcipher_alg mv_cesa_ecb_des_alg = {
+	.setkey = mv_cesa_des_setkey,
+	.encrypt = mv_cesa_ecb_des_encrypt,
+	.decrypt = mv_cesa_ecb_des_decrypt,
+	.min_keysize = DES_KEY_SIZE,
+	.max_keysize = DES_KEY_SIZE,
+	.base = {
+		.cra_name = "ecb(des)",
+		.cra_driver_name = "mv-ecb-des",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = DES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_init = mv_cesa_skcipher_cra_init,
+		.cra_exit = mv_cesa_skcipher_cra_exit,
+	},
+};
+
+static int mv_cesa_cbc_des_op(struct skcipher_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
+			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
+
+	memcpy(tmpl->ctx.skcipher.iv, req->iv, DES_BLOCK_SIZE);
+
+	return mv_cesa_des_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_des_encrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_des_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_des_decrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_des_op(req, &tmpl);
+}
+
+struct skcipher_alg mv_cesa_cbc_des_alg = {
+	.setkey = mv_cesa_des_setkey,
+	.encrypt = mv_cesa_cbc_des_encrypt,
+	.decrypt = mv_cesa_cbc_des_decrypt,
+	.min_keysize = DES_KEY_SIZE,
+	.max_keysize = DES_KEY_SIZE,
+	.ivsize = DES_BLOCK_SIZE,
+	.base = {
+		.cra_name = "cbc(des)",
+		.cra_driver_name = "mv-cbc-des",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = DES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_init = mv_cesa_skcipher_cra_init,
+		.cra_exit = mv_cesa_skcipher_cra_exit,
+	},
+};
+
+static int mv_cesa_des3_op(struct skcipher_request *req,
+			   struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des3_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_3DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.skcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
+
+	return mv_cesa_skcipher_queue_req(req, tmpl);
+}
+
+static int mv_cesa_ecb_des3_ede_encrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_des3_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_des3_ede_decrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_des3_op(req, &tmpl);
+}
+
+struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
+	.setkey = mv_cesa_des3_ede_setkey,
+	.encrypt = mv_cesa_ecb_des3_ede_encrypt,
+	.decrypt = mv_cesa_ecb_des3_ede_decrypt,
+	.min_keysize = DES3_EDE_KEY_SIZE,
+	.max_keysize = DES3_EDE_KEY_SIZE,
+	.ivsize = DES3_EDE_BLOCK_SIZE,
+	.base = {
+		.cra_name = "ecb(des3_ede)",
+		.cra_driver_name = "mv-ecb-des3-ede",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_init = mv_cesa_skcipher_cra_init,
+		.cra_exit = mv_cesa_skcipher_cra_exit,
+	},
+};
+
+static int mv_cesa_cbc_des3_op(struct skcipher_request *req,
+			       struct mv_cesa_op_ctx *tmpl)
+{
+	memcpy(tmpl->ctx.skcipher.iv, req->iv, DES3_EDE_BLOCK_SIZE);
+
+	return mv_cesa_des3_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_des3_ede_encrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_des3_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_des3_ede_decrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_des3_op(req, &tmpl);
+}
+
+struct skcipher_alg mv_cesa_cbc_des3_ede_alg = {
+	.setkey = mv_cesa_des3_ede_setkey,
+	.encrypt = mv_cesa_cbc_des3_ede_encrypt,
+	.decrypt = mv_cesa_cbc_des3_ede_decrypt,
+	.min_keysize = DES3_EDE_KEY_SIZE,
+	.max_keysize = DES3_EDE_KEY_SIZE,
+	.ivsize = DES3_EDE_BLOCK_SIZE,
+	.base = {
+		.cra_name = "cbc(des3_ede)",
+		.cra_driver_name = "mv-cbc-des3-ede",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_init = mv_cesa_skcipher_cra_init,
+		.cra_exit = mv_cesa_skcipher_cra_exit,
+	},
+};
+
+static int mv_cesa_aes_op(struct skcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	int i;
+	u32 *key;
+	u32 cfg;
+
+	cfg = CESA_SA_DESC_CFG_CRYPTM_AES;
+
+	if (mv_cesa_get_op_cfg(tmpl) & CESA_SA_DESC_CFG_DIR_DEC)
+		key = ctx->aes.key_dec;
+	else
+		key = ctx->aes.key_enc;
+
+	for (i = 0; i < ctx->aes.key_length / sizeof(u32); i++)
+		tmpl->ctx.skcipher.key[i] = cpu_to_le32(key[i]);
+
+	if (ctx->aes.key_length == 24)
+		cfg |= CESA_SA_DESC_CFG_AES_LEN_192;
+	else if (ctx->aes.key_length == 32)
+		cfg |= CESA_SA_DESC_CFG_AES_LEN_256;
+
+	mv_cesa_update_op_cfg(tmpl, cfg,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK |
+			      CESA_SA_DESC_CFG_AES_LEN_MSK);
+
+	return mv_cesa_skcipher_queue_req(req, tmpl);
+}
+
+static int mv_cesa_ecb_aes_encrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_aes_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_aes_decrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_aes_op(req, &tmpl);
+}
+
+struct skcipher_alg mv_cesa_ecb_aes_alg = {
+	.setkey = mv_cesa_aes_setkey,
+	.encrypt = mv_cesa_ecb_aes_encrypt,
+	.decrypt = mv_cesa_ecb_aes_decrypt,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.base = {
+		.cra_name = "ecb(aes)",
+		.cra_driver_name = "mv-ecb-aes",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_init = mv_cesa_skcipher_cra_init,
+		.cra_exit = mv_cesa_skcipher_cra_exit,
+	},
+};
+
+static int mv_cesa_cbc_aes_op(struct skcipher_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
+			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
+	memcpy(tmpl->ctx.skcipher.iv, req->iv, AES_BLOCK_SIZE);
+
+	return mv_cesa_aes_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_aes_encrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_aes_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_aes_decrypt(struct skcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_aes_op(req, &tmpl);
+}
+
+struct skcipher_alg mv_cesa_cbc_aes_alg = {
+	.setkey = mv_cesa_aes_setkey,
+	.encrypt = mv_cesa_cbc_aes_encrypt,
+	.decrypt = mv_cesa_cbc_aes_decrypt,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.ivsize = AES_BLOCK_SIZE,
+	.base = {
+		.cra_name = "cbc(aes)",
+		.cra_driver_name = "mv-cbc-aes",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_init = mv_cesa_skcipher_cra_init,
+		.cra_exit = mv_cesa_skcipher_cra_exit,
+	},
+};
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
new file mode 100644
index 0000000..b971284
--- /dev/null
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -0,0 +1,1448 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Hash algorithms supported by the CESA: MD5, SHA1 and SHA256.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ */
+
+#include <crypto/hmac.h>
+#include <crypto/md5.h>
+#include <crypto/sha.h>
+
+#include "cesa.h"
+
+struct mv_cesa_ahash_dma_iter {
+	struct mv_cesa_dma_iter base;
+	struct mv_cesa_sg_dma_iter src;
+};
+
+static inline void
+mv_cesa_ahash_req_iter_init(struct mv_cesa_ahash_dma_iter *iter,
+			    struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int len = req->nbytes + creq->cache_ptr;
+
+	if (!creq->last_req)
+		len &= ~CESA_HASH_BLOCK_SIZE_MSK;
+
+	mv_cesa_req_dma_iter_init(&iter->base, len);
+	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
+	iter->src.op_offset = creq->cache_ptr;
+}
+
+static inline bool
+mv_cesa_ahash_req_iter_next_op(struct mv_cesa_ahash_dma_iter *iter)
+{
+	iter->src.op_offset = 0;
+
+	return mv_cesa_req_dma_iter_next_op(&iter->base);
+}
+
+static inline int
+mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_dma_req *req, gfp_t flags)
+{
+	req->cache = dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
+				    &req->cache_dma);
+	if (!req->cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline void
+mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_dma_req *req)
+{
+	if (!req->cache)
+		return;
+
+	dma_pool_free(cesa_dev->dma->cache_pool, req->cache,
+		      req->cache_dma);
+}
+
+static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
+					   gfp_t flags)
+{
+	if (req->padding)
+		return 0;
+
+	req->padding = dma_pool_alloc(cesa_dev->dma->padding_pool, flags,
+				      &req->padding_dma);
+	if (!req->padding)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mv_cesa_ahash_dma_free_padding(struct mv_cesa_ahash_dma_req *req)
+{
+	if (!req->padding)
+		return;
+
+	dma_pool_free(cesa_dev->dma->padding_pool, req->padding,
+		      req->padding_dma);
+	req->padding = NULL;
+}
+
+static inline void mv_cesa_ahash_dma_last_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	mv_cesa_ahash_dma_free_padding(&creq->req.dma);
+}
+
+static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
+	mv_cesa_ahash_dma_free_cache(&creq->req.dma);
+	mv_cesa_dma_cleanup(&creq->base);
+}
+
+static inline void mv_cesa_ahash_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_cleanup(req);
+}
+
+static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_last_cleanup(req);
+}
+
+static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
+{
+	unsigned int index, padlen;
+
+	index = creq->len & CESA_HASH_BLOCK_SIZE_MSK;
+	padlen = (index < 56) ? (56 - index) : (64 + 56 - index);
+
+	return padlen;
+}
+
+static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
+{
+	unsigned int padlen;
+
+	buf[0] = 0x80;
+	/* Pad out to 56 mod 64 */
+	padlen = mv_cesa_ahash_pad_len(creq);
+	memset(buf + 1, 0, padlen - 1);
+
+	if (creq->algo_le) {
+		__le64 bits = cpu_to_le64(creq->len << 3);
+
+		memcpy(buf + padlen, &bits, sizeof(bits));
+	} else {
+		__be64 bits = cpu_to_be64(creq->len << 3);
+
+		memcpy(buf + padlen, &bits, sizeof(bits));
+	}
+
+	return padlen + 8;
+}
+
+static void mv_cesa_ahash_std_step(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
+	struct mv_cesa_engine *engine = creq->base.engine;
+	struct mv_cesa_op_ctx *op;
+	unsigned int new_cache_ptr = 0;
+	u32 frag_mode;
+	size_t  len;
+	unsigned int digsize;
+	int i;
+
+	mv_cesa_adjust_op(engine, &creq->op_tmpl);
+	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
+
+	if (!sreq->offset) {
+		digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+		for (i = 0; i < digsize / 4; i++)
+			writel_relaxed(creq->state[i],
+				       engine->regs + CESA_IVDIG(i));
+	}
+
+	if (creq->cache_ptr)
+		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+			    creq->cache, creq->cache_ptr);
+
+	len = min_t(size_t, req->nbytes + creq->cache_ptr - sreq->offset,
+		    CESA_SA_SRAM_PAYLOAD_SIZE);
+
+	if (!creq->last_req) {
+		new_cache_ptr = len & CESA_HASH_BLOCK_SIZE_MSK;
+		len &= ~CESA_HASH_BLOCK_SIZE_MSK;
+	}
+
+	if (len - creq->cache_ptr)
+		sreq->offset += sg_pcopy_to_buffer(req->src, creq->src_nents,
+						   engine->sram +
+						   CESA_SA_DATA_SRAM_OFFSET +
+						   creq->cache_ptr,
+						   len - creq->cache_ptr,
+						   sreq->offset);
+
+	op = &creq->op_tmpl;
+
+	frag_mode = mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK;
+
+	if (creq->last_req && sreq->offset == req->nbytes &&
+	    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+		if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
+			frag_mode = CESA_SA_DESC_CFG_NOT_FRAG;
+		else if (frag_mode == CESA_SA_DESC_CFG_MID_FRAG)
+			frag_mode = CESA_SA_DESC_CFG_LAST_FRAG;
+	}
+
+	if (frag_mode == CESA_SA_DESC_CFG_NOT_FRAG ||
+	    frag_mode == CESA_SA_DESC_CFG_LAST_FRAG) {
+		if (len &&
+		    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+			mv_cesa_set_mac_op_total_len(op, creq->len);
+		} else {
+			int trailerlen = mv_cesa_ahash_pad_len(creq) + 8;
+
+			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
+				len &= CESA_HASH_BLOCK_SIZE_MSK;
+				new_cache_ptr = 64 - trailerlen;
+				memcpy_fromio(creq->cache,
+					      engine->sram +
+					      CESA_SA_DATA_SRAM_OFFSET + len,
+					      new_cache_ptr);
+			} else {
+				len += mv_cesa_ahash_pad_req(creq,
+						engine->sram + len +
+						CESA_SA_DATA_SRAM_OFFSET);
+			}
+
+			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
+				frag_mode = CESA_SA_DESC_CFG_MID_FRAG;
+			else
+				frag_mode = CESA_SA_DESC_CFG_FIRST_FRAG;
+		}
+	}
+
+	mv_cesa_set_mac_op_frag_len(op, len);
+	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
+
+	/* FIXME: only update enc_len field */
+	memcpy_toio(engine->sram, op, sizeof(*op));
+
+	if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
+		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	creq->cache_ptr = new_cache_ptr;
+
+	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
+	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	WARN_ON(readl(engine->regs + CESA_SA_CMD) &
+		CESA_SA_CMD_EN_CESA_SA_ACCL0);
+	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
+}
+
+static int mv_cesa_ahash_std_process(struct ahash_request *req, u32 status)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
+
+	if (sreq->offset < (req->nbytes - creq->cache_ptr))
+		return -EINPROGRESS;
+
+	return 0;
+}
+
+static inline void mv_cesa_ahash_dma_prepare(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_req *basereq = &creq->base;
+
+	mv_cesa_dma_prepare(basereq, basereq->engine);
+}
+
+static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
+
+	sreq->offset = 0;
+}
+
+static void mv_cesa_ahash_dma_step(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_req *base = &creq->base;
+
+	/* We must explicitly set the digest state. */
+	if (base->chain.first->flags & CESA_TDMA_SET_STATE) {
+		struct mv_cesa_engine *engine = base->engine;
+		int i;
+
+		/* Set the hash state in the IVDIG regs. */
+		for (i = 0; i < ARRAY_SIZE(creq->state); i++)
+			writel_relaxed(creq->state[i], engine->regs +
+				       CESA_IVDIG(i));
+	}
+
+	mv_cesa_dma_step(base);
+}
+
+static void mv_cesa_ahash_step(struct crypto_async_request *req)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_step(ahashreq);
+	else
+		mv_cesa_ahash_std_step(ahashreq);
+}
+
+static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		return mv_cesa_dma_process(&creq->base, status);
+
+	return mv_cesa_ahash_std_process(ahashreq, status);
+}
+
+static void mv_cesa_ahash_complete(struct crypto_async_request *req)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+	struct mv_cesa_engine *engine = creq->base.engine;
+	unsigned int digsize;
+	int i;
+
+	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ &&
+	    (creq->base.chain.last->flags & CESA_TDMA_TYPE_MSK) ==
+	     CESA_TDMA_RESULT) {
+		__le32 *data = NULL;
+
+		/*
+		 * Result is already in the correct endianness when the SA is
+		 * used
+		 */
+		data = creq->base.chain.last->op->ctx.hash.hash;
+		for (i = 0; i < digsize / 4; i++)
+			creq->state[i] = cpu_to_le32(data[i]);
+
+		memcpy(ahashreq->result, data, digsize);
+	} else {
+		for (i = 0; i < digsize / 4; i++)
+			creq->state[i] = readl_relaxed(engine->regs +
+						       CESA_IVDIG(i));
+		if (creq->last_req) {
+			/*
+			 * Hardware's MD5 digest is in little endian format, but
+			 * SHA in big endian format
+			 */
+			if (creq->algo_le) {
+				__le32 *result = (void *)ahashreq->result;
+
+				for (i = 0; i < digsize / 4; i++)
+					result[i] = cpu_to_le32(creq->state[i]);
+			} else {
+				__be32 *result = (void *)ahashreq->result;
+
+				for (i = 0; i < digsize / 4; i++)
+					result[i] = cpu_to_be32(creq->state[i]);
+			}
+		}
+	}
+
+	atomic_sub(ahashreq->nbytes, &engine->load);
+}
+
+static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
+				  struct mv_cesa_engine *engine)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+
+	creq->base.engine = engine;
+
+	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
+		mv_cesa_ahash_dma_prepare(ahashreq);
+	else
+		mv_cesa_ahash_std_prepare(ahashreq);
+}
+
+static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
+{
+	struct ahash_request *ahashreq = ahash_request_cast(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+
+	if (creq->last_req)
+		mv_cesa_ahash_last_cleanup(ahashreq);
+
+	mv_cesa_ahash_cleanup(ahashreq);
+
+	if (creq->cache_ptr)
+		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
+				   creq->cache,
+				   creq->cache_ptr,
+				   ahashreq->nbytes - creq->cache_ptr);
+}
+
+static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
+	.step = mv_cesa_ahash_step,
+	.process = mv_cesa_ahash_process,
+	.cleanup = mv_cesa_ahash_req_cleanup,
+	.complete = mv_cesa_ahash_complete,
+};
+
+static void mv_cesa_ahash_init(struct ahash_request *req,
+			      struct mv_cesa_op_ctx *tmpl, bool algo_le)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	memset(creq, 0, sizeof(*creq));
+	mv_cesa_update_op_cfg(tmpl,
+			      CESA_SA_DESC_CFG_OP_MAC_ONLY |
+			      CESA_SA_DESC_CFG_FIRST_FRAG,
+			      CESA_SA_DESC_CFG_OP_MSK |
+			      CESA_SA_DESC_CFG_FRAG_MSK);
+	mv_cesa_set_mac_op_total_len(tmpl, 0);
+	mv_cesa_set_mac_op_frag_len(tmpl, 0);
+	creq->op_tmpl = *tmpl;
+	creq->len = 0;
+	creq->algo_le = algo_le;
+}
+
+static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->base.ops = &mv_cesa_ahash_req_ops;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mv_cesa_ahash_req));
+	return 0;
+}
+
+static bool mv_cesa_ahash_cache_req(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	bool cached = false;
+
+	if (creq->cache_ptr + req->nbytes < CESA_MAX_HASH_BLOCK_SIZE &&
+	    !creq->last_req) {
+		cached = true;
+
+		if (!req->nbytes)
+			return cached;
+
+		sg_pcopy_to_buffer(req->src, creq->src_nents,
+				   creq->cache + creq->cache_ptr,
+				   req->nbytes, 0);
+
+		creq->cache_ptr += req->nbytes;
+	}
+
+	return cached;
+}
+
+static struct mv_cesa_op_ctx *
+mv_cesa_dma_add_frag(struct mv_cesa_tdma_chain *chain,
+		     struct mv_cesa_op_ctx *tmpl, unsigned int frag_len,
+		     gfp_t flags)
+{
+	struct mv_cesa_op_ctx *op;
+	int ret;
+
+	op = mv_cesa_dma_add_op(chain, tmpl, false, flags);
+	if (IS_ERR(op))
+		return op;
+
+	/* Set the operation block fragment length. */
+	mv_cesa_set_mac_op_frag_len(op, frag_len);
+
+	/* Append dummy desc to launch operation */
+	ret = mv_cesa_dma_add_dummy_launch(chain, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (mv_cesa_mac_op_is_first_frag(tmpl))
+		mv_cesa_update_op_cfg(tmpl,
+				      CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	return op;
+}
+
+static int
+mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
+			    struct mv_cesa_ahash_req *creq,
+			    gfp_t flags)
+{
+	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
+	int ret;
+
+	if (!creq->cache_ptr)
+		return 0;
+
+	ret = mv_cesa_ahash_dma_alloc_cache(ahashdreq, flags);
+	if (ret)
+		return ret;
+
+	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
+
+	return mv_cesa_dma_add_data_transfer(chain,
+					     CESA_SA_DATA_SRAM_OFFSET,
+					     ahashdreq->cache_dma,
+					     creq->cache_ptr,
+					     CESA_TDMA_DST_IN_SRAM,
+					     flags);
+}
+
+static struct mv_cesa_op_ctx *
+mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
+			   struct mv_cesa_ahash_dma_iter *dma_iter,
+			   struct mv_cesa_ahash_req *creq,
+			   unsigned int frag_len, gfp_t flags)
+{
+	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
+	unsigned int len, trailerlen, padoff = 0;
+	struct mv_cesa_op_ctx *op;
+	int ret;
+
+	/*
+	 * If the transfer is smaller than our maximum length, and we have
+	 * some data outstanding, we can ask the engine to finish the hash.
+	 */
+	if (creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX && frag_len) {
+		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len,
+					  flags);
+		if (IS_ERR(op))
+			return op;
+
+		mv_cesa_set_mac_op_total_len(op, creq->len);
+		mv_cesa_update_op_cfg(op, mv_cesa_mac_op_is_first_frag(op) ?
+						CESA_SA_DESC_CFG_NOT_FRAG :
+						CESA_SA_DESC_CFG_LAST_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+		ret = mv_cesa_dma_add_result_op(chain,
+						CESA_SA_CFG_SRAM_OFFSET,
+						CESA_SA_DATA_SRAM_OFFSET,
+						CESA_TDMA_SRC_IN_SRAM, flags);
+		if (ret)
+			return ERR_PTR(-ENOMEM);
+		return op;
+	}
+
+	/*
+	 * The request is longer than the engine can handle, or we have
+	 * no data outstanding. Manually generate the padding, adding it
+	 * as a "mid" fragment.
+	 */
+	ret = mv_cesa_ahash_dma_alloc_padding(ahashdreq, flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	trailerlen = mv_cesa_ahash_pad_req(creq, ahashdreq->padding);
+
+	len = min(CESA_SA_SRAM_PAYLOAD_SIZE - frag_len, trailerlen);
+	if (len) {
+		ret = mv_cesa_dma_add_data_transfer(chain,
+						CESA_SA_DATA_SRAM_OFFSET +
+						frag_len,
+						ahashdreq->padding_dma,
+						len, CESA_TDMA_DST_IN_SRAM,
+						flags);
+		if (ret)
+			return ERR_PTR(ret);
+
+		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len + len,
+					  flags);
+		if (IS_ERR(op))
+			return op;
+
+		if (len == trailerlen)
+			return op;
+
+		padoff += len;
+	}
+
+	ret = mv_cesa_dma_add_data_transfer(chain,
+					    CESA_SA_DATA_SRAM_OFFSET,
+					    ahashdreq->padding_dma +
+					    padoff,
+					    trailerlen - padoff,
+					    CESA_TDMA_DST_IN_SRAM,
+					    flags);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return mv_cesa_dma_add_frag(chain, &creq->op_tmpl, trailerlen - padoff,
+				    flags);
+}
+
+static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+	struct mv_cesa_req *basereq = &creq->base;
+	struct mv_cesa_ahash_dma_iter iter;
+	struct mv_cesa_op_ctx *op = NULL;
+	unsigned int frag_len;
+	bool set_state = false;
+	int ret;
+	u32 type;
+
+	basereq->chain.first = NULL;
+	basereq->chain.last = NULL;
+
+	if (!mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
+		set_state = true;
+
+	if (creq->src_nents) {
+		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
+				 DMA_TO_DEVICE);
+		if (!ret) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+
+	mv_cesa_tdma_desc_iter_init(&basereq->chain);
+	mv_cesa_ahash_req_iter_init(&iter, req);
+
+	/*
+	 * Add the cache (left-over data from a previous block) first.
+	 * This will never overflow the SRAM size.
+	 */
+	ret = mv_cesa_ahash_dma_add_cache(&basereq->chain, creq, flags);
+	if (ret)
+		goto err_free_tdma;
+
+	if (iter.src.sg) {
+		/*
+		 * Add all the new data, inserting an operation block and
+		 * launch command between each full SRAM block-worth of
+		 * data. We intentionally do not add the final op block.
+		 */
+		while (true) {
+			ret = mv_cesa_dma_add_op_transfers(&basereq->chain,
+							   &iter.base,
+							   &iter.src, flags);
+			if (ret)
+				goto err_free_tdma;
+
+			frag_len = iter.base.op_len;
+
+			if (!mv_cesa_ahash_req_iter_next_op(&iter))
+				break;
+
+			op = mv_cesa_dma_add_frag(&basereq->chain,
+						  &creq->op_tmpl,
+						  frag_len, flags);
+			if (IS_ERR(op)) {
+				ret = PTR_ERR(op);
+				goto err_free_tdma;
+			}
+		}
+	} else {
+		/* Account for the data that was in the cache. */
+		frag_len = iter.base.op_len;
+	}
+
+	/*
+	 * At this point, frag_len indicates whether we have any data
+	 * outstanding which needs an operation.  Queue up the final
+	 * operation, which depends whether this is the final request.
+	 */
+	if (creq->last_req)
+		op = mv_cesa_ahash_dma_last_req(&basereq->chain, &iter, creq,
+						frag_len, flags);
+	else if (frag_len)
+		op = mv_cesa_dma_add_frag(&basereq->chain, &creq->op_tmpl,
+					  frag_len, flags);
+
+	if (IS_ERR(op)) {
+		ret = PTR_ERR(op);
+		goto err_free_tdma;
+	}
+
+	/*
+	 * If results are copied via DMA, this means that this
+	 * request can be directly processed by the engine,
+	 * without partial updates. So we can chain it at the
+	 * DMA level with other requests.
+	 */
+	type = basereq->chain.last->flags & CESA_TDMA_TYPE_MSK;
+
+	if (op && type != CESA_TDMA_RESULT) {
+		/* Add dummy desc to wait for crypto operation end */
+		ret = mv_cesa_dma_add_dummy_end(&basereq->chain, flags);
+		if (ret)
+			goto err_free_tdma;
+	}
+
+	if (!creq->last_req)
+		creq->cache_ptr = req->nbytes + creq->cache_ptr -
+				  iter.base.len;
+	else
+		creq->cache_ptr = 0;
+
+	basereq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
+
+	if (type != CESA_TDMA_RESULT)
+		basereq->chain.last->flags |= CESA_TDMA_BREAK_CHAIN;
+
+	if (set_state) {
+		/*
+		 * Put the CESA_TDMA_SET_STATE flag on the first tdma desc to
+		 * let the step logic know that the IVDIG registers should be
+		 * explicitly set before launching a TDMA chain.
+		 */
+		basereq->chain.first->flags |= CESA_TDMA_SET_STATE;
+	}
+
+	return 0;
+
+err_free_tdma:
+	mv_cesa_dma_cleanup(basereq);
+	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
+
+err:
+	mv_cesa_ahash_last_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	creq->src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (creq->src_nents < 0) {
+		dev_err(cesa_dev->dev, "Invalid number of src SG");
+		return creq->src_nents;
+	}
+
+	*cached = mv_cesa_ahash_cache_req(req);
+
+	if (*cached)
+		return 0;
+
+	if (cesa_dev->caps->has_tdma)
+		return mv_cesa_ahash_dma_req_init(req);
+	else
+		return 0;
+}
+
+static int mv_cesa_ahash_queue_req(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_engine *engine;
+	bool cached = false;
+	int ret;
+
+	ret = mv_cesa_ahash_req_init(req, &cached);
+	if (ret)
+		return ret;
+
+	if (cached)
+		return 0;
+
+	engine = mv_cesa_select_engine(req->nbytes);
+	mv_cesa_ahash_prepare(&req->base, engine);
+
+	ret = mv_cesa_queue_req(&req->base, &creq->base);
+
+	if (mv_cesa_req_needs_cleanup(&req->base, ret))
+		mv_cesa_ahash_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ahash_update(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	creq->len += req->nbytes;
+
+	return mv_cesa_ahash_queue_req(req);
+}
+
+static int mv_cesa_ahash_final(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
+
+	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
+	creq->last_req = true;
+	req->nbytes = 0;
+
+	return mv_cesa_ahash_queue_req(req);
+}
+
+static int mv_cesa_ahash_finup(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
+
+	creq->len += req->nbytes;
+	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
+	creq->last_req = true;
+
+	return mv_cesa_ahash_queue_req(req);
+}
+
+static int mv_cesa_ahash_export(struct ahash_request *req, void *hash,
+				u64 *len, void *cache)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int digsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize;
+
+	blocksize = crypto_ahash_blocksize(ahash);
+
+	*len = creq->len;
+	memcpy(hash, creq->state, digsize);
+	memset(cache, 0, blocksize);
+	memcpy(cache, creq->cache, creq->cache_ptr);
+
+	return 0;
+}
+
+static int mv_cesa_ahash_import(struct ahash_request *req, const void *hash,
+				u64 len, const void *cache)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int digsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize;
+	unsigned int cache_ptr;
+	int ret;
+
+	ret = crypto_ahash_init(req);
+	if (ret)
+		return ret;
+
+	blocksize = crypto_ahash_blocksize(ahash);
+	if (len >= blocksize)
+		mv_cesa_update_op_cfg(&creq->op_tmpl,
+				      CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+	creq->len = len;
+	memcpy(creq->state, hash, digsize);
+	creq->cache_ptr = 0;
+
+	cache_ptr = do_div(len, blocksize);
+	if (!cache_ptr)
+		return 0;
+
+	memcpy(creq->cache, cache, cache_ptr);
+	creq->cache_ptr = cache_ptr;
+
+	return 0;
+}
+
+static int mv_cesa_md5_init(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_op_ctx tmpl = { };
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
+
+	mv_cesa_ahash_init(req, &tmpl, true);
+
+	creq->state[0] = MD5_H0;
+	creq->state[1] = MD5_H1;
+	creq->state[2] = MD5_H2;
+	creq->state[3] = MD5_H3;
+
+	return 0;
+}
+
+static int mv_cesa_md5_export(struct ahash_request *req, void *out)
+{
+	struct md5_state *out_state = out;
+
+	return mv_cesa_ahash_export(req, out_state->hash,
+				    &out_state->byte_count, out_state->block);
+}
+
+static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
+{
+	const struct md5_state *in_state = in;
+
+	return mv_cesa_ahash_import(req, in_state->hash, in_state->byte_count,
+				    in_state->block);
+}
+
+static int mv_cesa_md5_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_md5_alg = {
+	.init = mv_cesa_md5_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_md5_digest,
+	.export = mv_cesa_md5_export,
+	.import = mv_cesa_md5_import,
+	.halg = {
+		.digestsize = MD5_DIGEST_SIZE,
+		.statesize = sizeof(struct md5_state),
+		.base = {
+			.cra_name = "md5",
+			.cra_driver_name = "mv-md5",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		}
+	}
+};
+
+static int mv_cesa_sha1_init(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_op_ctx tmpl = { };
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA1);
+
+	mv_cesa_ahash_init(req, &tmpl, false);
+
+	creq->state[0] = SHA1_H0;
+	creq->state[1] = SHA1_H1;
+	creq->state[2] = SHA1_H2;
+	creq->state[3] = SHA1_H3;
+	creq->state[4] = SHA1_H4;
+
+	return 0;
+}
+
+static int mv_cesa_sha1_export(struct ahash_request *req, void *out)
+{
+	struct sha1_state *out_state = out;
+
+	return mv_cesa_ahash_export(req, out_state->state, &out_state->count,
+				    out_state->buffer);
+}
+
+static int mv_cesa_sha1_import(struct ahash_request *req, const void *in)
+{
+	const struct sha1_state *in_state = in;
+
+	return mv_cesa_ahash_import(req, in_state->state, in_state->count,
+				    in_state->buffer);
+}
+
+static int mv_cesa_sha1_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_sha1_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_sha1_alg = {
+	.init = mv_cesa_sha1_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_sha1_digest,
+	.export = mv_cesa_sha1_export,
+	.import = mv_cesa_sha1_import,
+	.halg = {
+		.digestsize = SHA1_DIGEST_SIZE,
+		.statesize = sizeof(struct sha1_state),
+		.base = {
+			.cra_name = "sha1",
+			.cra_driver_name = "mv-sha1",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA1_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		}
+	}
+};
+
+static int mv_cesa_sha256_init(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_op_ctx tmpl = { };
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
+
+	mv_cesa_ahash_init(req, &tmpl, false);
+
+	creq->state[0] = SHA256_H0;
+	creq->state[1] = SHA256_H1;
+	creq->state[2] = SHA256_H2;
+	creq->state[3] = SHA256_H3;
+	creq->state[4] = SHA256_H4;
+	creq->state[5] = SHA256_H5;
+	creq->state[6] = SHA256_H6;
+	creq->state[7] = SHA256_H7;
+
+	return 0;
+}
+
+static int mv_cesa_sha256_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+static int mv_cesa_sha256_export(struct ahash_request *req, void *out)
+{
+	struct sha256_state *out_state = out;
+
+	return mv_cesa_ahash_export(req, out_state->state, &out_state->count,
+				    out_state->buf);
+}
+
+static int mv_cesa_sha256_import(struct ahash_request *req, const void *in)
+{
+	const struct sha256_state *in_state = in;
+
+	return mv_cesa_ahash_import(req, in_state->state, in_state->count,
+				    in_state->buf);
+}
+
+struct ahash_alg mv_sha256_alg = {
+	.init = mv_cesa_sha256_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_sha256_digest,
+	.export = mv_cesa_sha256_export,
+	.import = mv_cesa_sha256_import,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.statesize = sizeof(struct sha256_state),
+		.base = {
+			.cra_name = "sha256",
+			.cra_driver_name = "mv-sha256",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		}
+	}
+};
+
+struct mv_cesa_ahash_result {
+	struct completion completion;
+	int error;
+};
+
+static void mv_cesa_hmac_ahash_complete(struct crypto_async_request *req,
+					int error)
+{
+	struct mv_cesa_ahash_result *result = req->data;
+
+	if (error == -EINPROGRESS)
+		return;
+
+	result->error = error;
+	complete(&result->completion);
+}
+
+static int mv_cesa_ahmac_iv_state_init(struct ahash_request *req, u8 *pad,
+				       void *state, unsigned int blocksize)
+{
+	struct mv_cesa_ahash_result result;
+	struct scatterlist sg;
+	int ret;
+
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   mv_cesa_hmac_ahash_complete, &result);
+	sg_init_one(&sg, pad, blocksize);
+	ahash_request_set_crypt(req, &sg, pad, blocksize);
+	init_completion(&result.completion);
+
+	ret = crypto_ahash_init(req);
+	if (ret)
+		return ret;
+
+	ret = crypto_ahash_update(req);
+	if (ret && ret != -EINPROGRESS)
+		return ret;
+
+	wait_for_completion_interruptible(&result.completion);
+	if (result.error)
+		return result.error;
+
+	ret = crypto_ahash_export(req, state);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
+				  const u8 *key, unsigned int keylen,
+				  u8 *ipad, u8 *opad,
+				  unsigned int blocksize)
+{
+	struct mv_cesa_ahash_result result;
+	struct scatterlist sg;
+	int ret;
+	int i;
+
+	if (keylen <= blocksize) {
+		memcpy(ipad, key, keylen);
+	} else {
+		u8 *keydup = kmemdup(key, keylen, GFP_KERNEL);
+
+		if (!keydup)
+			return -ENOMEM;
+
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   mv_cesa_hmac_ahash_complete,
+					   &result);
+		sg_init_one(&sg, keydup, keylen);
+		ahash_request_set_crypt(req, &sg, ipad, keylen);
+		init_completion(&result.completion);
+
+		ret = crypto_ahash_digest(req);
+		if (ret == -EINPROGRESS) {
+			wait_for_completion_interruptible(&result.completion);
+			ret = result.error;
+		}
+
+		/* Set the memory region to 0 to avoid any leak. */
+		kzfree(keydup);
+
+		if (ret)
+			return ret;
+
+		keylen = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+	}
+
+	memset(ipad + keylen, 0, blocksize - keylen);
+	memcpy(opad, ipad, blocksize);
+
+	for (i = 0; i < blocksize; i++) {
+		ipad[i] ^= HMAC_IPAD_VALUE;
+		opad[i] ^= HMAC_OPAD_VALUE;
+	}
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_setkey(const char *hash_alg_name,
+				const u8 *key, unsigned int keylen,
+				void *istate, void *ostate)
+{
+	struct ahash_request *req;
+	struct crypto_ahash *tfm;
+	unsigned int blocksize;
+	u8 *ipad = NULL;
+	u8 *opad;
+	int ret;
+
+	tfm = crypto_alloc_ahash(hash_alg_name, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto free_ahash;
+	}
+
+	crypto_ahash_clear_flags(tfm, ~0);
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+
+	ipad = kcalloc(2, blocksize, GFP_KERNEL);
+	if (!ipad) {
+		ret = -ENOMEM;
+		goto free_req;
+	}
+
+	opad = ipad + blocksize;
+
+	ret = mv_cesa_ahmac_pad_init(req, key, keylen, ipad, opad, blocksize);
+	if (ret)
+		goto free_ipad;
+
+	ret = mv_cesa_ahmac_iv_state_init(req, ipad, istate, blocksize);
+	if (ret)
+		goto free_ipad;
+
+	ret = mv_cesa_ahmac_iv_state_init(req, opad, ostate, blocksize);
+
+free_ipad:
+	kfree(ipad);
+free_req:
+	ahash_request_free(req);
+free_ahash:
+	crypto_free_ahash(tfm);
+
+	return ret;
+}
+
+static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->base.ops = &mv_cesa_ahash_req_ops;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mv_cesa_ahash_req));
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl = { };
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_MD5);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl, true);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_setkey(struct crypto_ahash *tfm, const u8 *key,
+				    unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct md5_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-md5", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.hash); i++)
+		ctx->iv[i] = be32_to_cpu(istate.hash[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.hash); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.hash[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_md5_alg = {
+	.init = mv_cesa_ahmac_md5_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_md5_digest,
+	.setkey = mv_cesa_ahmac_md5_setkey,
+	.export = mv_cesa_md5_export,
+	.import = mv_cesa_md5_import,
+	.halg = {
+		.digestsize = MD5_DIGEST_SIZE,
+		.statesize = sizeof(struct md5_state),
+		.base = {
+			.cra_name = "hmac(md5)",
+			.cra_driver_name = "mv-hmac-md5",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		}
+	}
+};
+
+static int mv_cesa_ahmac_sha1_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl = { };
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA1);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl, false);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
+				     unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct sha1_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-sha1", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
+		ctx->iv[i] = be32_to_cpu(istate.state[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha1_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_sha1_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_sha1_alg = {
+	.init = mv_cesa_ahmac_sha1_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_sha1_digest,
+	.setkey = mv_cesa_ahmac_sha1_setkey,
+	.export = mv_cesa_sha1_export,
+	.import = mv_cesa_sha1_import,
+	.halg = {
+		.digestsize = SHA1_DIGEST_SIZE,
+		.statesize = sizeof(struct sha1_state),
+		.base = {
+			.cra_name = "hmac(sha1)",
+			.cra_driver_name = "mv-hmac-sha1",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA1_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		}
+	}
+};
+
+static int mv_cesa_ahmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
+				       unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct sha256_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-sha256", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
+		ctx->iv[i] = be32_to_cpu(istate.state[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha256_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl = { };
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA256);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl, false);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha256_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_sha256_alg = {
+	.init = mv_cesa_ahmac_sha256_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_sha256_digest,
+	.setkey = mv_cesa_ahmac_sha256_setkey,
+	.export = mv_cesa_sha256_export,
+	.import = mv_cesa_sha256_import,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.statesize = sizeof(struct sha256_state),
+		.base = {
+			.cra_name = "hmac(sha256)",
+			.cra_driver_name = "mv-hmac-sha256",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		}
+	}
+};
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
new file mode 100644
index 0000000..b81ee27
--- /dev/null
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -0,0 +1,352 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Provide TDMA helper functions used by cipher and hash algorithm
+ * implementations.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ * Author: Arnaud Ebalard <arno@natisbad.org>
+ *
+ * This work is based on an initial version written by
+ * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ */
+
+#include "cesa.h"
+
+bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *iter,
+					struct mv_cesa_sg_dma_iter *sgiter,
+					unsigned int len)
+{
+	if (!sgiter->sg)
+		return false;
+
+	sgiter->op_offset += len;
+	sgiter->offset += len;
+	if (sgiter->offset == sg_dma_len(sgiter->sg)) {
+		if (sg_is_last(sgiter->sg))
+			return false;
+		sgiter->offset = 0;
+		sgiter->sg = sg_next(sgiter->sg);
+	}
+
+	if (sgiter->op_offset == iter->op_len)
+		return false;
+
+	return true;
+}
+
+void mv_cesa_dma_step(struct mv_cesa_req *dreq)
+{
+	struct mv_cesa_engine *engine = dreq->engine;
+
+	writel_relaxed(0, engine->regs + CESA_SA_CFG);
+
+	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
+	writel_relaxed(CESA_TDMA_DST_BURST_128B | CESA_TDMA_SRC_BURST_128B |
+		       CESA_TDMA_NO_BYTE_SWAP | CESA_TDMA_EN,
+		       engine->regs + CESA_TDMA_CONTROL);
+
+	writel_relaxed(CESA_SA_CFG_ACT_CH0_IDMA | CESA_SA_CFG_MULTI_PKT |
+		       CESA_SA_CFG_CH0_W_IDMA | CESA_SA_CFG_PARA_DIS,
+		       engine->regs + CESA_SA_CFG);
+	writel_relaxed(dreq->chain.first->cur_dma,
+		       engine->regs + CESA_TDMA_NEXT_ADDR);
+	WARN_ON(readl(engine->regs + CESA_SA_CMD) &
+		CESA_SA_CMD_EN_CESA_SA_ACCL0);
+	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
+}
+
+void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	for (tdma = dreq->chain.first; tdma;) {
+		struct mv_cesa_tdma_desc *old_tdma = tdma;
+		u32 type = tdma->flags & CESA_TDMA_TYPE_MSK;
+
+		if (type == CESA_TDMA_OP)
+			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
+				      le32_to_cpu(tdma->src));
+
+		tdma = tdma->next;
+		dma_pool_free(cesa_dev->dma->tdma_desc_pool, old_tdma,
+			      old_tdma->cur_dma);
+	}
+
+	dreq->chain.first = NULL;
+	dreq->chain.last = NULL;
+}
+
+void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
+			 struct mv_cesa_engine *engine)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	for (tdma = dreq->chain.first; tdma; tdma = tdma->next) {
+		if (tdma->flags & CESA_TDMA_DST_IN_SRAM)
+			tdma->dst = cpu_to_le32(tdma->dst + engine->sram_dma);
+
+		if (tdma->flags & CESA_TDMA_SRC_IN_SRAM)
+			tdma->src = cpu_to_le32(tdma->src + engine->sram_dma);
+
+		if ((tdma->flags & CESA_TDMA_TYPE_MSK) == CESA_TDMA_OP)
+			mv_cesa_adjust_op(engine, tdma->op);
+	}
+}
+
+void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
+			struct mv_cesa_req *dreq)
+{
+	if (engine->chain.first == NULL && engine->chain.last == NULL) {
+		engine->chain.first = dreq->chain.first;
+		engine->chain.last  = dreq->chain.last;
+	} else {
+		struct mv_cesa_tdma_desc *last;
+
+		last = engine->chain.last;
+		last->next = dreq->chain.first;
+		engine->chain.last = dreq->chain.last;
+
+		/*
+		 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
+		 * the last element of the current chain, or if the request
+		 * being queued needs the IV regs to be set before lauching
+		 * the request.
+		 */
+		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
+		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
+			last->next_dma = dreq->chain.first->cur_dma;
+	}
+}
+
+int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
+{
+	struct crypto_async_request *req = NULL;
+	struct mv_cesa_tdma_desc *tdma = NULL, *next = NULL;
+	dma_addr_t tdma_cur;
+	int res = 0;
+
+	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
+
+	for (tdma = engine->chain.first; tdma; tdma = next) {
+		spin_lock_bh(&engine->lock);
+		next = tdma->next;
+		spin_unlock_bh(&engine->lock);
+
+		if (tdma->flags & CESA_TDMA_END_OF_REQ) {
+			struct crypto_async_request *backlog = NULL;
+			struct mv_cesa_ctx *ctx;
+			u32 current_status;
+
+			spin_lock_bh(&engine->lock);
+			/*
+			 * if req is NULL, this means we're processing the
+			 * request in engine->req.
+			 */
+			if (!req)
+				req = engine->req;
+			else
+				req = mv_cesa_dequeue_req_locked(engine,
+								 &backlog);
+
+			/* Re-chaining to the next request */
+			engine->chain.first = tdma->next;
+			tdma->next = NULL;
+
+			/* If this is the last request, clear the chain */
+			if (engine->chain.first == NULL)
+				engine->chain.last  = NULL;
+			spin_unlock_bh(&engine->lock);
+
+			ctx = crypto_tfm_ctx(req->tfm);
+			current_status = (tdma->cur_dma == tdma_cur) ?
+					  status : CESA_SA_INT_ACC0_IDMA_DONE;
+			res = ctx->ops->process(req, current_status);
+			ctx->ops->complete(req);
+
+			if (res == 0)
+				mv_cesa_engine_enqueue_complete_request(engine,
+									req);
+
+			if (backlog)
+				backlog->complete(backlog, -EINPROGRESS);
+		}
+
+		if (res || tdma->cur_dma == tdma_cur)
+			break;
+	}
+
+	/*
+	 * Save the last request in error to engine->req, so that the core
+	 * knows which request was fautly
+	 */
+	if (res) {
+		spin_lock_bh(&engine->lock);
+		engine->req = req;
+		spin_unlock_bh(&engine->lock);
+	}
+
+	return res;
+}
+
+static struct mv_cesa_tdma_desc *
+mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *new_tdma = NULL;
+	dma_addr_t dma_handle;
+
+	new_tdma = dma_pool_zalloc(cesa_dev->dma->tdma_desc_pool, flags,
+				   &dma_handle);
+	if (!new_tdma)
+		return ERR_PTR(-ENOMEM);
+
+	new_tdma->cur_dma = dma_handle;
+	if (chain->last) {
+		chain->last->next_dma = cpu_to_le32(dma_handle);
+		chain->last->next = new_tdma;
+	} else {
+		chain->first = new_tdma;
+	}
+
+	chain->last = new_tdma;
+
+	return new_tdma;
+}
+
+int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
+			  u32 size, u32 flags, gfp_t gfp_flags)
+{
+	struct mv_cesa_tdma_desc *tdma, *op_desc;
+
+	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	/* We re-use an existing op_desc object to retrieve the context
+	 * and result instead of allocating a new one.
+	 * There is at least one object of this type in a CESA crypto
+	 * req, just pick the first one in the chain.
+	 */
+	for (op_desc = chain->first; op_desc; op_desc = op_desc->next) {
+		u32 type = op_desc->flags & CESA_TDMA_TYPE_MSK;
+
+		if (type == CESA_TDMA_OP)
+			break;
+	}
+
+	if (!op_desc)
+		return -EIO;
+
+	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
+	tdma->src = src;
+	tdma->dst = op_desc->src;
+	tdma->op = op_desc->op;
+
+	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
+	tdma->flags = flags | CESA_TDMA_RESULT;
+	return 0;
+}
+
+struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
+					const struct mv_cesa_op_ctx *op_templ,
+					bool skip_ctx,
+					gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+	struct mv_cesa_op_ctx *op;
+	dma_addr_t dma_handle;
+	unsigned int size;
+
+	tdma = mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return ERR_CAST(tdma);
+
+	op = dma_pool_alloc(cesa_dev->dma->op_pool, flags, &dma_handle);
+	if (!op)
+		return ERR_PTR(-ENOMEM);
+
+	*op = *op_templ;
+
+	size = skip_ctx ? sizeof(op->desc) : sizeof(*op);
+
+	tdma = chain->last;
+	tdma->op = op;
+	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
+	tdma->src = cpu_to_le32(dma_handle);
+	tdma->dst = CESA_SA_CFG_SRAM_OFFSET;
+	tdma->flags = CESA_TDMA_DST_IN_SRAM | CESA_TDMA_OP;
+
+	return op;
+}
+
+int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
+				  dma_addr_t dst, dma_addr_t src, u32 size,
+				  u32 flags, gfp_t gfp_flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
+	tdma->src = src;
+	tdma->dst = dst;
+
+	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
+	tdma->flags = flags | CESA_TDMA_DATA;
+
+	return 0;
+}
+
+int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain, gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma = mv_cesa_dma_add_desc(chain, flags);
+	return PTR_ERR_OR_ZERO(tdma);
+}
+
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, gfp_t flags)
+{
+	struct mv_cesa_tdma_desc *tdma;
+
+	tdma = mv_cesa_dma_add_desc(chain, flags);
+	if (IS_ERR(tdma))
+		return PTR_ERR(tdma);
+
+	tdma->byte_cnt = cpu_to_le32(BIT(31));
+
+	return 0;
+}
+
+int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
+				 struct mv_cesa_dma_iter *dma_iter,
+				 struct mv_cesa_sg_dma_iter *sgiter,
+				 gfp_t gfp_flags)
+{
+	u32 flags = sgiter->dir == DMA_TO_DEVICE ?
+		    CESA_TDMA_DST_IN_SRAM : CESA_TDMA_SRC_IN_SRAM;
+	unsigned int len;
+
+	do {
+		dma_addr_t dst, src;
+		int ret;
+
+		len = mv_cesa_req_dma_iter_transfer_len(dma_iter, sgiter);
+		if (sgiter->dir == DMA_TO_DEVICE) {
+			dst = CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
+			src = sg_dma_address(sgiter->sg) + sgiter->offset;
+		} else {
+			dst = sg_dma_address(sgiter->sg) + sgiter->offset;
+			src = CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
+		}
+
+		ret = mv_cesa_dma_add_data_transfer(chain, dst, src, len,
+						    flags, gfp_flags);
+		if (ret)
+			return ret;
+
+	} while (mv_cesa_req_dma_iter_next_transfer(dma_iter, sgiter, len));
+
+	return 0;
+}
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
deleted file mode 100644
index c24f34a..0000000
--- a/drivers/crypto/marvell/cipher.c
+++ /dev/null
@@ -1,798 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Cipher algorithms supported by the CESA: DES, 3DES and AES.
- *
- * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
- * Author: Arnaud Ebalard <arno@natisbad.org>
- *
- * This work is based on an initial version written by
- * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
- */
-
-#include <crypto/aes.h>
-#include <crypto/internal/des.h>
-
-#include "cesa.h"
-
-struct mv_cesa_des_ctx {
-	struct mv_cesa_ctx base;
-	u8 key[DES_KEY_SIZE];
-};
-
-struct mv_cesa_des3_ctx {
-	struct mv_cesa_ctx base;
-	u8 key[DES3_EDE_KEY_SIZE];
-};
-
-struct mv_cesa_aes_ctx {
-	struct mv_cesa_ctx base;
-	struct crypto_aes_ctx aes;
-};
-
-struct mv_cesa_skcipher_dma_iter {
-	struct mv_cesa_dma_iter base;
-	struct mv_cesa_sg_dma_iter src;
-	struct mv_cesa_sg_dma_iter dst;
-};
-
-static inline void
-mv_cesa_skcipher_req_iter_init(struct mv_cesa_skcipher_dma_iter *iter,
-			       struct skcipher_request *req)
-{
-	mv_cesa_req_dma_iter_init(&iter->base, req->cryptlen);
-	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
-	mv_cesa_sg_dma_iter_init(&iter->dst, req->dst, DMA_FROM_DEVICE);
-}
-
-static inline bool
-mv_cesa_skcipher_req_iter_next_op(struct mv_cesa_skcipher_dma_iter *iter)
-{
-	iter->src.op_offset = 0;
-	iter->dst.op_offset = 0;
-
-	return mv_cesa_req_dma_iter_next_op(&iter->base);
-}
-
-static inline void
-mv_cesa_skcipher_dma_cleanup(struct skcipher_request *req)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-
-	if (req->dst != req->src) {
-		dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents,
-			     DMA_FROM_DEVICE);
-		dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents,
-			     DMA_TO_DEVICE);
-	} else {
-		dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents,
-			     DMA_BIDIRECTIONAL);
-	}
-	mv_cesa_dma_cleanup(&creq->base);
-}
-
-static inline void mv_cesa_skcipher_cleanup(struct skcipher_request *req)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_skcipher_dma_cleanup(req);
-}
-
-static void mv_cesa_skcipher_std_step(struct skcipher_request *req)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
-	struct mv_cesa_engine *engine = creq->base.engine;
-	size_t  len = min_t(size_t, req->cryptlen - sreq->offset,
-			    CESA_SA_SRAM_PAYLOAD_SIZE);
-
-	mv_cesa_adjust_op(engine, &sreq->op);
-	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
-
-	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
-				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
-				 len, sreq->offset);
-
-	sreq->size = len;
-	mv_cesa_set_crypt_op_len(&sreq->op, len);
-
-	/* FIXME: only update enc_len field */
-	if (!sreq->skip_ctx) {
-		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
-		sreq->skip_ctx = true;
-	} else {
-		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op.desc));
-	}
-
-	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
-	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
-	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
-	       CESA_SA_CMD_EN_CESA_SA_ACCL0);
-	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
-}
-
-static int mv_cesa_skcipher_std_process(struct skcipher_request *req,
-					u32 status)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
-	struct mv_cesa_engine *engine = creq->base.engine;
-	size_t len;
-
-	len = sg_pcopy_from_buffer(req->dst, creq->dst_nents,
-				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
-				   sreq->size, sreq->offset);
-
-	sreq->offset += len;
-	if (sreq->offset < req->cryptlen)
-		return -EINPROGRESS;
-
-	return 0;
-}
-
-static int mv_cesa_skcipher_process(struct crypto_async_request *req,
-				    u32 status)
-{
-	struct skcipher_request *skreq = skcipher_request_cast(req);
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
-	struct mv_cesa_req *basereq = &creq->base;
-
-	if (mv_cesa_req_get_type(basereq) == CESA_STD_REQ)
-		return mv_cesa_skcipher_std_process(skreq, status);
-
-	return mv_cesa_dma_process(basereq, status);
-}
-
-static void mv_cesa_skcipher_step(struct crypto_async_request *req)
-{
-	struct skcipher_request *skreq = skcipher_request_cast(req);
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_dma_step(&creq->base);
-	else
-		mv_cesa_skcipher_std_step(skreq);
-}
-
-static inline void
-mv_cesa_skcipher_dma_prepare(struct skcipher_request *req)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	struct mv_cesa_req *basereq = &creq->base;
-
-	mv_cesa_dma_prepare(basereq, basereq->engine);
-}
-
-static inline void
-mv_cesa_skcipher_std_prepare(struct skcipher_request *req)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
-
-	sreq->size = 0;
-	sreq->offset = 0;
-}
-
-static inline void mv_cesa_skcipher_prepare(struct crypto_async_request *req,
-					    struct mv_cesa_engine *engine)
-{
-	struct skcipher_request *skreq = skcipher_request_cast(req);
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
-	creq->base.engine = engine;
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_skcipher_dma_prepare(skreq);
-	else
-		mv_cesa_skcipher_std_prepare(skreq);
-}
-
-static inline void
-mv_cesa_skcipher_req_cleanup(struct crypto_async_request *req)
-{
-	struct skcipher_request *skreq = skcipher_request_cast(req);
-
-	mv_cesa_skcipher_cleanup(skreq);
-}
-
-static void
-mv_cesa_skcipher_complete(struct crypto_async_request *req)
-{
-	struct skcipher_request *skreq = skcipher_request_cast(req);
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(skreq);
-	struct mv_cesa_engine *engine = creq->base.engine;
-	unsigned int ivsize;
-
-	atomic_sub(skreq->cryptlen, &engine->load);
-	ivsize = crypto_skcipher_ivsize(crypto_skcipher_reqtfm(skreq));
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ) {
-		struct mv_cesa_req *basereq;
-
-		basereq = &creq->base;
-		memcpy(skreq->iv, basereq->chain.last->op->ctx.skcipher.iv,
-		       ivsize);
-	} else {
-		memcpy_fromio(skreq->iv,
-			      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
-			      ivsize);
-	}
-}
-
-static const struct mv_cesa_req_ops mv_cesa_skcipher_req_ops = {
-	.step = mv_cesa_skcipher_step,
-	.process = mv_cesa_skcipher_process,
-	.cleanup = mv_cesa_skcipher_req_cleanup,
-	.complete = mv_cesa_skcipher_complete,
-};
-
-static void mv_cesa_skcipher_cra_exit(struct crypto_tfm *tfm)
-{
-	void *ctx = crypto_tfm_ctx(tfm);
-
-	memzero_explicit(ctx, tfm->__crt_alg->cra_ctxsize);
-}
-
-static int mv_cesa_skcipher_cra_init(struct crypto_tfm *tfm)
-{
-	struct mv_cesa_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->ops = &mv_cesa_skcipher_req_ops;
-
-	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
-				    sizeof(struct mv_cesa_skcipher_req));
-
-	return 0;
-}
-
-static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
-			      unsigned int len)
-{
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
-	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	int remaining;
-	int offset;
-	int ret;
-	int i;
-
-	ret = aes_expandkey(&ctx->aes, key, len);
-	if (ret)
-		return ret;
-
-	remaining = (ctx->aes.key_length - 16) / 4;
-	offset = ctx->aes.key_length + 24 - remaining;
-	for (i = 0; i < remaining; i++)
-		ctx->aes.key_dec[4 + i] =
-			cpu_to_le32(ctx->aes.key_enc[offset + i]);
-
-	return 0;
-}
-
-static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
-			      unsigned int len)
-{
-	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
-	int err;
-
-	err = verify_skcipher_des_key(cipher, key);
-	if (err)
-		return err;
-
-	memcpy(ctx->key, key, DES_KEY_SIZE);
-
-	return 0;
-}
-
-static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
-				   const u8 *key, unsigned int len)
-{
-	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
-	int err;
-
-	err = verify_skcipher_des3_key(cipher, key);
-	if (err)
-		return err;
-
-	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
-
-	return 0;
-}
-
-static int mv_cesa_skcipher_dma_req_init(struct skcipher_request *req,
-					 const struct mv_cesa_op_ctx *op_templ)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		      GFP_KERNEL : GFP_ATOMIC;
-	struct mv_cesa_req *basereq = &creq->base;
-	struct mv_cesa_skcipher_dma_iter iter;
-	bool skip_ctx = false;
-	int ret;
-
-	basereq->chain.first = NULL;
-	basereq->chain.last = NULL;
-
-	if (req->src != req->dst) {
-		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
-				 DMA_TO_DEVICE);
-		if (!ret)
-			return -ENOMEM;
-
-		ret = dma_map_sg(cesa_dev->dev, req->dst, creq->dst_nents,
-				 DMA_FROM_DEVICE);
-		if (!ret) {
-			ret = -ENOMEM;
-			goto err_unmap_src;
-		}
-	} else {
-		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
-				 DMA_BIDIRECTIONAL);
-		if (!ret)
-			return -ENOMEM;
-	}
-
-	mv_cesa_tdma_desc_iter_init(&basereq->chain);
-	mv_cesa_skcipher_req_iter_init(&iter, req);
-
-	do {
-		struct mv_cesa_op_ctx *op;
-
-		op = mv_cesa_dma_add_op(&basereq->chain, op_templ, skip_ctx, flags);
-		if (IS_ERR(op)) {
-			ret = PTR_ERR(op);
-			goto err_free_tdma;
-		}
-		skip_ctx = true;
-
-		mv_cesa_set_crypt_op_len(op, iter.base.op_len);
-
-		/* Add input transfers */
-		ret = mv_cesa_dma_add_op_transfers(&basereq->chain, &iter.base,
-						   &iter.src, flags);
-		if (ret)
-			goto err_free_tdma;
-
-		/* Add dummy desc to launch the crypto operation */
-		ret = mv_cesa_dma_add_dummy_launch(&basereq->chain, flags);
-		if (ret)
-			goto err_free_tdma;
-
-		/* Add output transfers */
-		ret = mv_cesa_dma_add_op_transfers(&basereq->chain, &iter.base,
-						   &iter.dst, flags);
-		if (ret)
-			goto err_free_tdma;
-
-	} while (mv_cesa_skcipher_req_iter_next_op(&iter));
-
-	/* Add output data for IV */
-	ret = mv_cesa_dma_add_result_op(&basereq->chain, CESA_SA_CFG_SRAM_OFFSET,
-				    CESA_SA_DATA_SRAM_OFFSET,
-				    CESA_TDMA_SRC_IN_SRAM, flags);
-
-	if (ret)
-		goto err_free_tdma;
-
-	basereq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
-
-	return 0;
-
-err_free_tdma:
-	mv_cesa_dma_cleanup(basereq);
-	if (req->dst != req->src)
-		dma_unmap_sg(cesa_dev->dev, req->dst, creq->dst_nents,
-			     DMA_FROM_DEVICE);
-
-err_unmap_src:
-	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents,
-		     req->dst != req->src ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL);
-
-	return ret;
-}
-
-static inline int
-mv_cesa_skcipher_std_req_init(struct skcipher_request *req,
-			      const struct mv_cesa_op_ctx *op_templ)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	struct mv_cesa_skcipher_std_req *sreq = &creq->std;
-	struct mv_cesa_req *basereq = &creq->base;
-
-	sreq->op = *op_templ;
-	sreq->skip_ctx = false;
-	basereq->chain.first = NULL;
-	basereq->chain.last = NULL;
-
-	return 0;
-}
-
-static int mv_cesa_skcipher_req_init(struct skcipher_request *req,
-				     struct mv_cesa_op_ctx *tmpl)
-{
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	unsigned int blksize = crypto_skcipher_blocksize(tfm);
-	int ret;
-
-	if (!IS_ALIGNED(req->cryptlen, blksize))
-		return -EINVAL;
-
-	creq->src_nents = sg_nents_for_len(req->src, req->cryptlen);
-	if (creq->src_nents < 0) {
-		dev_err(cesa_dev->dev, "Invalid number of src SG");
-		return creq->src_nents;
-	}
-	creq->dst_nents = sg_nents_for_len(req->dst, req->cryptlen);
-	if (creq->dst_nents < 0) {
-		dev_err(cesa_dev->dev, "Invalid number of dst SG");
-		return creq->dst_nents;
-	}
-
-	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_OP_CRYPT_ONLY,
-			      CESA_SA_DESC_CFG_OP_MSK);
-
-	if (cesa_dev->caps->has_tdma)
-		ret = mv_cesa_skcipher_dma_req_init(req, tmpl);
-	else
-		ret = mv_cesa_skcipher_std_req_init(req, tmpl);
-
-	return ret;
-}
-
-static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
-				      struct mv_cesa_op_ctx *tmpl)
-{
-	int ret;
-	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
-	struct mv_cesa_engine *engine;
-
-	ret = mv_cesa_skcipher_req_init(req, tmpl);
-	if (ret)
-		return ret;
-
-	engine = mv_cesa_select_engine(req->cryptlen);
-	mv_cesa_skcipher_prepare(&req->base, engine);
-
-	ret = mv_cesa_queue_req(&req->base, &creq->base);
-
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_skcipher_cleanup(req);
-
-	return ret;
-}
-
-static int mv_cesa_des_op(struct skcipher_request *req,
-			  struct mv_cesa_op_ctx *tmpl)
-{
-	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-
-	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
-			      CESA_SA_DESC_CFG_CRYPTM_MSK);
-
-	memcpy(tmpl->ctx.skcipher.key, ctx->key, DES_KEY_SIZE);
-
-	return mv_cesa_skcipher_queue_req(req, tmpl);
-}
-
-static int mv_cesa_ecb_des_encrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
-			   CESA_SA_DESC_CFG_DIR_ENC);
-
-	return mv_cesa_des_op(req, &tmpl);
-}
-
-static int mv_cesa_ecb_des_decrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
-			   CESA_SA_DESC_CFG_DIR_DEC);
-
-	return mv_cesa_des_op(req, &tmpl);
-}
-
-struct skcipher_alg mv_cesa_ecb_des_alg = {
-	.setkey = mv_cesa_des_setkey,
-	.encrypt = mv_cesa_ecb_des_encrypt,
-	.decrypt = mv_cesa_ecb_des_decrypt,
-	.min_keysize = DES_KEY_SIZE,
-	.max_keysize = DES_KEY_SIZE,
-	.base = {
-		.cra_name = "ecb(des)",
-		.cra_driver_name = "mv-ecb-des",
-		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-		.cra_blocksize = DES_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
-		.cra_alignmask = 0,
-		.cra_module = THIS_MODULE,
-		.cra_init = mv_cesa_skcipher_cra_init,
-		.cra_exit = mv_cesa_skcipher_cra_exit,
-	},
-};
-
-static int mv_cesa_cbc_des_op(struct skcipher_request *req,
-			      struct mv_cesa_op_ctx *tmpl)
-{
-	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
-			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
-
-	memcpy(tmpl->ctx.skcipher.iv, req->iv, DES_BLOCK_SIZE);
-
-	return mv_cesa_des_op(req, tmpl);
-}
-
-static int mv_cesa_cbc_des_encrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
-
-	return mv_cesa_cbc_des_op(req, &tmpl);
-}
-
-static int mv_cesa_cbc_des_decrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
-
-	return mv_cesa_cbc_des_op(req, &tmpl);
-}
-
-struct skcipher_alg mv_cesa_cbc_des_alg = {
-	.setkey = mv_cesa_des_setkey,
-	.encrypt = mv_cesa_cbc_des_encrypt,
-	.decrypt = mv_cesa_cbc_des_decrypt,
-	.min_keysize = DES_KEY_SIZE,
-	.max_keysize = DES_KEY_SIZE,
-	.ivsize = DES_BLOCK_SIZE,
-	.base = {
-		.cra_name = "cbc(des)",
-		.cra_driver_name = "mv-cbc-des",
-		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-		.cra_blocksize = DES_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
-		.cra_alignmask = 0,
-		.cra_module = THIS_MODULE,
-		.cra_init = mv_cesa_skcipher_cra_init,
-		.cra_exit = mv_cesa_skcipher_cra_exit,
-	},
-};
-
-static int mv_cesa_des3_op(struct skcipher_request *req,
-			   struct mv_cesa_op_ctx *tmpl)
-{
-	struct mv_cesa_des3_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-
-	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_3DES,
-			      CESA_SA_DESC_CFG_CRYPTM_MSK);
-
-	memcpy(tmpl->ctx.skcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
-
-	return mv_cesa_skcipher_queue_req(req, tmpl);
-}
-
-static int mv_cesa_ecb_des3_ede_encrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
-			   CESA_SA_DESC_CFG_3DES_EDE |
-			   CESA_SA_DESC_CFG_DIR_ENC);
-
-	return mv_cesa_des3_op(req, &tmpl);
-}
-
-static int mv_cesa_ecb_des3_ede_decrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
-			   CESA_SA_DESC_CFG_3DES_EDE |
-			   CESA_SA_DESC_CFG_DIR_DEC);
-
-	return mv_cesa_des3_op(req, &tmpl);
-}
-
-struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
-	.setkey = mv_cesa_des3_ede_setkey,
-	.encrypt = mv_cesa_ecb_des3_ede_encrypt,
-	.decrypt = mv_cesa_ecb_des3_ede_decrypt,
-	.min_keysize = DES3_EDE_KEY_SIZE,
-	.max_keysize = DES3_EDE_KEY_SIZE,
-	.ivsize = DES3_EDE_BLOCK_SIZE,
-	.base = {
-		.cra_name = "ecb(des3_ede)",
-		.cra_driver_name = "mv-ecb-des3-ede",
-		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
-		.cra_alignmask = 0,
-		.cra_module = THIS_MODULE,
-		.cra_init = mv_cesa_skcipher_cra_init,
-		.cra_exit = mv_cesa_skcipher_cra_exit,
-	},
-};
-
-static int mv_cesa_cbc_des3_op(struct skcipher_request *req,
-			       struct mv_cesa_op_ctx *tmpl)
-{
-	memcpy(tmpl->ctx.skcipher.iv, req->iv, DES3_EDE_BLOCK_SIZE);
-
-	return mv_cesa_des3_op(req, tmpl);
-}
-
-static int mv_cesa_cbc_des3_ede_encrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
-			   CESA_SA_DESC_CFG_3DES_EDE |
-			   CESA_SA_DESC_CFG_DIR_ENC);
-
-	return mv_cesa_cbc_des3_op(req, &tmpl);
-}
-
-static int mv_cesa_cbc_des3_ede_decrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
-			   CESA_SA_DESC_CFG_3DES_EDE |
-			   CESA_SA_DESC_CFG_DIR_DEC);
-
-	return mv_cesa_cbc_des3_op(req, &tmpl);
-}
-
-struct skcipher_alg mv_cesa_cbc_des3_ede_alg = {
-	.setkey = mv_cesa_des3_ede_setkey,
-	.encrypt = mv_cesa_cbc_des3_ede_encrypt,
-	.decrypt = mv_cesa_cbc_des3_ede_decrypt,
-	.min_keysize = DES3_EDE_KEY_SIZE,
-	.max_keysize = DES3_EDE_KEY_SIZE,
-	.ivsize = DES3_EDE_BLOCK_SIZE,
-	.base = {
-		.cra_name = "cbc(des3_ede)",
-		.cra_driver_name = "mv-cbc-des3-ede",
-		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
-		.cra_alignmask = 0,
-		.cra_module = THIS_MODULE,
-		.cra_init = mv_cesa_skcipher_cra_init,
-		.cra_exit = mv_cesa_skcipher_cra_exit,
-	},
-};
-
-static int mv_cesa_aes_op(struct skcipher_request *req,
-			  struct mv_cesa_op_ctx *tmpl)
-{
-	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	int i;
-	u32 *key;
-	u32 cfg;
-
-	cfg = CESA_SA_DESC_CFG_CRYPTM_AES;
-
-	if (mv_cesa_get_op_cfg(tmpl) & CESA_SA_DESC_CFG_DIR_DEC)
-		key = ctx->aes.key_dec;
-	else
-		key = ctx->aes.key_enc;
-
-	for (i = 0; i < ctx->aes.key_length / sizeof(u32); i++)
-		tmpl->ctx.skcipher.key[i] = cpu_to_le32(key[i]);
-
-	if (ctx->aes.key_length == 24)
-		cfg |= CESA_SA_DESC_CFG_AES_LEN_192;
-	else if (ctx->aes.key_length == 32)
-		cfg |= CESA_SA_DESC_CFG_AES_LEN_256;
-
-	mv_cesa_update_op_cfg(tmpl, cfg,
-			      CESA_SA_DESC_CFG_CRYPTM_MSK |
-			      CESA_SA_DESC_CFG_AES_LEN_MSK);
-
-	return mv_cesa_skcipher_queue_req(req, tmpl);
-}
-
-static int mv_cesa_ecb_aes_encrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
-			   CESA_SA_DESC_CFG_DIR_ENC);
-
-	return mv_cesa_aes_op(req, &tmpl);
-}
-
-static int mv_cesa_ecb_aes_decrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl,
-			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
-			   CESA_SA_DESC_CFG_DIR_DEC);
-
-	return mv_cesa_aes_op(req, &tmpl);
-}
-
-struct skcipher_alg mv_cesa_ecb_aes_alg = {
-	.setkey = mv_cesa_aes_setkey,
-	.encrypt = mv_cesa_ecb_aes_encrypt,
-	.decrypt = mv_cesa_ecb_aes_decrypt,
-	.min_keysize = AES_MIN_KEY_SIZE,
-	.max_keysize = AES_MAX_KEY_SIZE,
-	.base = {
-		.cra_name = "ecb(aes)",
-		.cra_driver_name = "mv-ecb-aes",
-		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
-		.cra_alignmask = 0,
-		.cra_module = THIS_MODULE,
-		.cra_init = mv_cesa_skcipher_cra_init,
-		.cra_exit = mv_cesa_skcipher_cra_exit,
-	},
-};
-
-static int mv_cesa_cbc_aes_op(struct skcipher_request *req,
-			      struct mv_cesa_op_ctx *tmpl)
-{
-	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
-			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
-	memcpy(tmpl->ctx.skcipher.iv, req->iv, AES_BLOCK_SIZE);
-
-	return mv_cesa_aes_op(req, tmpl);
-}
-
-static int mv_cesa_cbc_aes_encrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
-
-	return mv_cesa_cbc_aes_op(req, &tmpl);
-}
-
-static int mv_cesa_cbc_aes_decrypt(struct skcipher_request *req)
-{
-	struct mv_cesa_op_ctx tmpl;
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
-
-	return mv_cesa_cbc_aes_op(req, &tmpl);
-}
-
-struct skcipher_alg mv_cesa_cbc_aes_alg = {
-	.setkey = mv_cesa_aes_setkey,
-	.encrypt = mv_cesa_cbc_aes_encrypt,
-	.decrypt = mv_cesa_cbc_aes_decrypt,
-	.min_keysize = AES_MIN_KEY_SIZE,
-	.max_keysize = AES_MAX_KEY_SIZE,
-	.ivsize = AES_BLOCK_SIZE,
-	.base = {
-		.cra_name = "cbc(aes)",
-		.cra_driver_name = "mv-cbc-aes",
-		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
-		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
-		.cra_alignmask = 0,
-		.cra_module = THIS_MODULE,
-		.cra_init = mv_cesa_skcipher_cra_init,
-		.cra_exit = mv_cesa_skcipher_cra_exit,
-	},
-};
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
deleted file mode 100644
index a2b35fb..0000000
--- a/drivers/crypto/marvell/hash.c
+++ /dev/null
@@ -1,1442 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Hash algorithms supported by the CESA: MD5, SHA1 and SHA256.
- *
- * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
- * Author: Arnaud Ebalard <arno@natisbad.org>
- *
- * This work is based on an initial version written by
- * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
- */
-
-#include <crypto/hmac.h>
-#include <crypto/md5.h>
-#include <crypto/sha.h>
-
-#include "cesa.h"
-
-struct mv_cesa_ahash_dma_iter {
-	struct mv_cesa_dma_iter base;
-	struct mv_cesa_sg_dma_iter src;
-};
-
-static inline void
-mv_cesa_ahash_req_iter_init(struct mv_cesa_ahash_dma_iter *iter,
-			    struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	unsigned int len = req->nbytes + creq->cache_ptr;
-
-	if (!creq->last_req)
-		len &= ~CESA_HASH_BLOCK_SIZE_MSK;
-
-	mv_cesa_req_dma_iter_init(&iter->base, len);
-	mv_cesa_sg_dma_iter_init(&iter->src, req->src, DMA_TO_DEVICE);
-	iter->src.op_offset = creq->cache_ptr;
-}
-
-static inline bool
-mv_cesa_ahash_req_iter_next_op(struct mv_cesa_ahash_dma_iter *iter)
-{
-	iter->src.op_offset = 0;
-
-	return mv_cesa_req_dma_iter_next_op(&iter->base);
-}
-
-static inline int
-mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_dma_req *req, gfp_t flags)
-{
-	req->cache = dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
-				    &req->cache_dma);
-	if (!req->cache)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static inline void
-mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_dma_req *req)
-{
-	if (!req->cache)
-		return;
-
-	dma_pool_free(cesa_dev->dma->cache_pool, req->cache,
-		      req->cache_dma);
-}
-
-static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
-					   gfp_t flags)
-{
-	if (req->padding)
-		return 0;
-
-	req->padding = dma_pool_alloc(cesa_dev->dma->padding_pool, flags,
-				      &req->padding_dma);
-	if (!req->padding)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void mv_cesa_ahash_dma_free_padding(struct mv_cesa_ahash_dma_req *req)
-{
-	if (!req->padding)
-		return;
-
-	dma_pool_free(cesa_dev->dma->padding_pool, req->padding,
-		      req->padding_dma);
-	req->padding = NULL;
-}
-
-static inline void mv_cesa_ahash_dma_last_cleanup(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-
-	mv_cesa_ahash_dma_free_padding(&creq->req.dma);
-}
-
-static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-
-	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
-	mv_cesa_ahash_dma_free_cache(&creq->req.dma);
-	mv_cesa_dma_cleanup(&creq->base);
-}
-
-static inline void mv_cesa_ahash_cleanup(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_ahash_dma_cleanup(req);
-}
-
-static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_ahash_dma_last_cleanup(req);
-}
-
-static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
-{
-	unsigned int index, padlen;
-
-	index = creq->len & CESA_HASH_BLOCK_SIZE_MSK;
-	padlen = (index < 56) ? (56 - index) : (64 + 56 - index);
-
-	return padlen;
-}
-
-static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
-{
-	unsigned int padlen;
-
-	buf[0] = 0x80;
-	/* Pad out to 56 mod 64 */
-	padlen = mv_cesa_ahash_pad_len(creq);
-	memset(buf + 1, 0, padlen - 1);
-
-	if (creq->algo_le) {
-		__le64 bits = cpu_to_le64(creq->len << 3);
-		memcpy(buf + padlen, &bits, sizeof(bits));
-	} else {
-		__be64 bits = cpu_to_be64(creq->len << 3);
-		memcpy(buf + padlen, &bits, sizeof(bits));
-	}
-
-	return padlen + 8;
-}
-
-static void mv_cesa_ahash_std_step(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
-	struct mv_cesa_engine *engine = creq->base.engine;
-	struct mv_cesa_op_ctx *op;
-	unsigned int new_cache_ptr = 0;
-	u32 frag_mode;
-	size_t  len;
-	unsigned int digsize;
-	int i;
-
-	mv_cesa_adjust_op(engine, &creq->op_tmpl);
-	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
-
-	if (!sreq->offset) {
-		digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
-		for (i = 0; i < digsize / 4; i++)
-			writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
-	}
-
-	if (creq->cache_ptr)
-		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
-			    creq->cache, creq->cache_ptr);
-
-	len = min_t(size_t, req->nbytes + creq->cache_ptr - sreq->offset,
-		    CESA_SA_SRAM_PAYLOAD_SIZE);
-
-	if (!creq->last_req) {
-		new_cache_ptr = len & CESA_HASH_BLOCK_SIZE_MSK;
-		len &= ~CESA_HASH_BLOCK_SIZE_MSK;
-	}
-
-	if (len - creq->cache_ptr)
-		sreq->offset += sg_pcopy_to_buffer(req->src, creq->src_nents,
-						   engine->sram +
-						   CESA_SA_DATA_SRAM_OFFSET +
-						   creq->cache_ptr,
-						   len - creq->cache_ptr,
-						   sreq->offset);
-
-	op = &creq->op_tmpl;
-
-	frag_mode = mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK;
-
-	if (creq->last_req && sreq->offset == req->nbytes &&
-	    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
-		if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
-			frag_mode = CESA_SA_DESC_CFG_NOT_FRAG;
-		else if (frag_mode == CESA_SA_DESC_CFG_MID_FRAG)
-			frag_mode = CESA_SA_DESC_CFG_LAST_FRAG;
-	}
-
-	if (frag_mode == CESA_SA_DESC_CFG_NOT_FRAG ||
-	    frag_mode == CESA_SA_DESC_CFG_LAST_FRAG) {
-		if (len &&
-		    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
-			mv_cesa_set_mac_op_total_len(op, creq->len);
-		} else {
-			int trailerlen = mv_cesa_ahash_pad_len(creq) + 8;
-
-			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
-				len &= CESA_HASH_BLOCK_SIZE_MSK;
-				new_cache_ptr = 64 - trailerlen;
-				memcpy_fromio(creq->cache,
-					      engine->sram +
-					      CESA_SA_DATA_SRAM_OFFSET + len,
-					      new_cache_ptr);
-			} else {
-				len += mv_cesa_ahash_pad_req(creq,
-						engine->sram + len +
-						CESA_SA_DATA_SRAM_OFFSET);
-			}
-
-			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
-				frag_mode = CESA_SA_DESC_CFG_MID_FRAG;
-			else
-				frag_mode = CESA_SA_DESC_CFG_FIRST_FRAG;
-		}
-	}
-
-	mv_cesa_set_mac_op_frag_len(op, len);
-	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
-
-	/* FIXME: only update enc_len field */
-	memcpy_toio(engine->sram, op, sizeof(*op));
-
-	if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
-		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
-	creq->cache_ptr = new_cache_ptr;
-
-	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
-	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
-	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
-	       CESA_SA_CMD_EN_CESA_SA_ACCL0);
-	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
-}
-
-static int mv_cesa_ahash_std_process(struct ahash_request *req, u32 status)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
-
-	if (sreq->offset < (req->nbytes - creq->cache_ptr))
-		return -EINPROGRESS;
-
-	return 0;
-}
-
-static inline void mv_cesa_ahash_dma_prepare(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_req *basereq = &creq->base;
-
-	mv_cesa_dma_prepare(basereq, basereq->engine);
-}
-
-static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
-
-	sreq->offset = 0;
-}
-
-static void mv_cesa_ahash_dma_step(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_req *base = &creq->base;
-
-	/* We must explicitly set the digest state. */
-	if (base->chain.first->flags & CESA_TDMA_SET_STATE) {
-		struct mv_cesa_engine *engine = base->engine;
-		int i;
-
-		/* Set the hash state in the IVDIG regs. */
-		for (i = 0; i < ARRAY_SIZE(creq->state); i++)
-			writel_relaxed(creq->state[i], engine->regs +
-				       CESA_IVDIG(i));
-	}
-
-	mv_cesa_dma_step(base);
-}
-
-static void mv_cesa_ahash_step(struct crypto_async_request *req)
-{
-	struct ahash_request *ahashreq = ahash_request_cast(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_ahash_dma_step(ahashreq);
-	else
-		mv_cesa_ahash_std_step(ahashreq);
-}
-
-static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
-{
-	struct ahash_request *ahashreq = ahash_request_cast(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		return mv_cesa_dma_process(&creq->base, status);
-
-	return mv_cesa_ahash_std_process(ahashreq, status);
-}
-
-static void mv_cesa_ahash_complete(struct crypto_async_request *req)
-{
-	struct ahash_request *ahashreq = ahash_request_cast(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-	struct mv_cesa_engine *engine = creq->base.engine;
-	unsigned int digsize;
-	int i;
-
-	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ &&
-	    (creq->base.chain.last->flags & CESA_TDMA_TYPE_MSK) == CESA_TDMA_RESULT) {
-		__le32 *data = NULL;
-
-		/*
-		 * Result is already in the correct endianess when the SA is
-		 * used
-		 */
-		data = creq->base.chain.last->op->ctx.hash.hash;
-		for (i = 0; i < digsize / 4; i++)
-			creq->state[i] = cpu_to_le32(data[i]);
-
-		memcpy(ahashreq->result, data, digsize);
-	} else {
-		for (i = 0; i < digsize / 4; i++)
-			creq->state[i] = readl_relaxed(engine->regs +
-						       CESA_IVDIG(i));
-		if (creq->last_req) {
-			/*
-			* Hardware's MD5 digest is in little endian format, but
-			* SHA in big endian format
-			*/
-			if (creq->algo_le) {
-				__le32 *result = (void *)ahashreq->result;
-
-				for (i = 0; i < digsize / 4; i++)
-					result[i] = cpu_to_le32(creq->state[i]);
-			} else {
-				__be32 *result = (void *)ahashreq->result;
-
-				for (i = 0; i < digsize / 4; i++)
-					result[i] = cpu_to_be32(creq->state[i]);
-			}
-		}
-	}
-
-	atomic_sub(ahashreq->nbytes, &engine->load);
-}
-
-static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
-				  struct mv_cesa_engine *engine)
-{
-	struct ahash_request *ahashreq = ahash_request_cast(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-
-	creq->base.engine = engine;
-
-	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
-		mv_cesa_ahash_dma_prepare(ahashreq);
-	else
-		mv_cesa_ahash_std_prepare(ahashreq);
-}
-
-static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
-{
-	struct ahash_request *ahashreq = ahash_request_cast(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-
-	if (creq->last_req)
-		mv_cesa_ahash_last_cleanup(ahashreq);
-
-	mv_cesa_ahash_cleanup(ahashreq);
-
-	if (creq->cache_ptr)
-		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
-				   creq->cache,
-				   creq->cache_ptr,
-				   ahashreq->nbytes - creq->cache_ptr);
-}
-
-static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
-	.step = mv_cesa_ahash_step,
-	.process = mv_cesa_ahash_process,
-	.cleanup = mv_cesa_ahash_req_cleanup,
-	.complete = mv_cesa_ahash_complete,
-};
-
-static void mv_cesa_ahash_init(struct ahash_request *req,
-			      struct mv_cesa_op_ctx *tmpl, bool algo_le)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-
-	memset(creq, 0, sizeof(*creq));
-	mv_cesa_update_op_cfg(tmpl,
-			      CESA_SA_DESC_CFG_OP_MAC_ONLY |
-			      CESA_SA_DESC_CFG_FIRST_FRAG,
-			      CESA_SA_DESC_CFG_OP_MSK |
-			      CESA_SA_DESC_CFG_FRAG_MSK);
-	mv_cesa_set_mac_op_total_len(tmpl, 0);
-	mv_cesa_set_mac_op_frag_len(tmpl, 0);
-	creq->op_tmpl = *tmpl;
-	creq->len = 0;
-	creq->algo_le = algo_le;
-}
-
-static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
-{
-	struct mv_cesa_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->base.ops = &mv_cesa_ahash_req_ops;
-
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct mv_cesa_ahash_req));
-	return 0;
-}
-
-static bool mv_cesa_ahash_cache_req(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	bool cached = false;
-
-	if (creq->cache_ptr + req->nbytes < CESA_MAX_HASH_BLOCK_SIZE && !creq->last_req) {
-		cached = true;
-
-		if (!req->nbytes)
-			return cached;
-
-		sg_pcopy_to_buffer(req->src, creq->src_nents,
-				   creq->cache + creq->cache_ptr,
-				   req->nbytes, 0);
-
-		creq->cache_ptr += req->nbytes;
-	}
-
-	return cached;
-}
-
-static struct mv_cesa_op_ctx *
-mv_cesa_dma_add_frag(struct mv_cesa_tdma_chain *chain,
-		     struct mv_cesa_op_ctx *tmpl, unsigned int frag_len,
-		     gfp_t flags)
-{
-	struct mv_cesa_op_ctx *op;
-	int ret;
-
-	op = mv_cesa_dma_add_op(chain, tmpl, false, flags);
-	if (IS_ERR(op))
-		return op;
-
-	/* Set the operation block fragment length. */
-	mv_cesa_set_mac_op_frag_len(op, frag_len);
-
-	/* Append dummy desc to launch operation */
-	ret = mv_cesa_dma_add_dummy_launch(chain, flags);
-	if (ret)
-		return ERR_PTR(ret);
-
-	if (mv_cesa_mac_op_is_first_frag(tmpl))
-		mv_cesa_update_op_cfg(tmpl,
-				      CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
-	return op;
-}
-
-static int
-mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
-			    struct mv_cesa_ahash_req *creq,
-			    gfp_t flags)
-{
-	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
-	int ret;
-
-	if (!creq->cache_ptr)
-		return 0;
-
-	ret = mv_cesa_ahash_dma_alloc_cache(ahashdreq, flags);
-	if (ret)
-		return ret;
-
-	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
-
-	return mv_cesa_dma_add_data_transfer(chain,
-					     CESA_SA_DATA_SRAM_OFFSET,
-					     ahashdreq->cache_dma,
-					     creq->cache_ptr,
-					     CESA_TDMA_DST_IN_SRAM,
-					     flags);
-}
-
-static struct mv_cesa_op_ctx *
-mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
-			   struct mv_cesa_ahash_dma_iter *dma_iter,
-			   struct mv_cesa_ahash_req *creq,
-			   unsigned int frag_len, gfp_t flags)
-{
-	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
-	unsigned int len, trailerlen, padoff = 0;
-	struct mv_cesa_op_ctx *op;
-	int ret;
-
-	/*
-	 * If the transfer is smaller than our maximum length, and we have
-	 * some data outstanding, we can ask the engine to finish the hash.
-	 */
-	if (creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX && frag_len) {
-		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len,
-					  flags);
-		if (IS_ERR(op))
-			return op;
-
-		mv_cesa_set_mac_op_total_len(op, creq->len);
-		mv_cesa_update_op_cfg(op, mv_cesa_mac_op_is_first_frag(op) ?
-						CESA_SA_DESC_CFG_NOT_FRAG :
-						CESA_SA_DESC_CFG_LAST_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
-		ret = mv_cesa_dma_add_result_op(chain,
-						CESA_SA_CFG_SRAM_OFFSET,
-						CESA_SA_DATA_SRAM_OFFSET,
-						CESA_TDMA_SRC_IN_SRAM, flags);
-		if (ret)
-			return ERR_PTR(-ENOMEM);
-		return op;
-	}
-
-	/*
-	 * The request is longer than the engine can handle, or we have
-	 * no data outstanding. Manually generate the padding, adding it
-	 * as a "mid" fragment.
-	 */
-	ret = mv_cesa_ahash_dma_alloc_padding(ahashdreq, flags);
-	if (ret)
-		return ERR_PTR(ret);
-
-	trailerlen = mv_cesa_ahash_pad_req(creq, ahashdreq->padding);
-
-	len = min(CESA_SA_SRAM_PAYLOAD_SIZE - frag_len, trailerlen);
-	if (len) {
-		ret = mv_cesa_dma_add_data_transfer(chain,
-						CESA_SA_DATA_SRAM_OFFSET +
-						frag_len,
-						ahashdreq->padding_dma,
-						len, CESA_TDMA_DST_IN_SRAM,
-						flags);
-		if (ret)
-			return ERR_PTR(ret);
-
-		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len + len,
-					  flags);
-		if (IS_ERR(op))
-			return op;
-
-		if (len == trailerlen)
-			return op;
-
-		padoff += len;
-	}
-
-	ret = mv_cesa_dma_add_data_transfer(chain,
-					    CESA_SA_DATA_SRAM_OFFSET,
-					    ahashdreq->padding_dma +
-					    padoff,
-					    trailerlen - padoff,
-					    CESA_TDMA_DST_IN_SRAM,
-					    flags);
-	if (ret)
-		return ERR_PTR(ret);
-
-	return mv_cesa_dma_add_frag(chain, &creq->op_tmpl, trailerlen - padoff,
-				    flags);
-}
-
-static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		      GFP_KERNEL : GFP_ATOMIC;
-	struct mv_cesa_req *basereq = &creq->base;
-	struct mv_cesa_ahash_dma_iter iter;
-	struct mv_cesa_op_ctx *op = NULL;
-	unsigned int frag_len;
-	bool set_state = false;
-	int ret;
-	u32 type;
-
-	basereq->chain.first = NULL;
-	basereq->chain.last = NULL;
-
-	if (!mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
-		set_state = true;
-
-	if (creq->src_nents) {
-		ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
-				 DMA_TO_DEVICE);
-		if (!ret) {
-			ret = -ENOMEM;
-			goto err;
-		}
-	}
-
-	mv_cesa_tdma_desc_iter_init(&basereq->chain);
-	mv_cesa_ahash_req_iter_init(&iter, req);
-
-	/*
-	 * Add the cache (left-over data from a previous block) first.
-	 * This will never overflow the SRAM size.
-	 */
-	ret = mv_cesa_ahash_dma_add_cache(&basereq->chain, creq, flags);
-	if (ret)
-		goto err_free_tdma;
-
-	if (iter.src.sg) {
-		/*
-		 * Add all the new data, inserting an operation block and
-		 * launch command between each full SRAM block-worth of
-		 * data. We intentionally do not add the final op block.
-		 */
-		while (true) {
-			ret = mv_cesa_dma_add_op_transfers(&basereq->chain,
-							   &iter.base,
-							   &iter.src, flags);
-			if (ret)
-				goto err_free_tdma;
-
-			frag_len = iter.base.op_len;
-
-			if (!mv_cesa_ahash_req_iter_next_op(&iter))
-				break;
-
-			op = mv_cesa_dma_add_frag(&basereq->chain, &creq->op_tmpl,
-						  frag_len, flags);
-			if (IS_ERR(op)) {
-				ret = PTR_ERR(op);
-				goto err_free_tdma;
-			}
-		}
-	} else {
-		/* Account for the data that was in the cache. */
-		frag_len = iter.base.op_len;
-	}
-
-	/*
-	 * At this point, frag_len indicates whether we have any data
-	 * outstanding which needs an operation.  Queue up the final
-	 * operation, which depends whether this is the final request.
-	 */
-	if (creq->last_req)
-		op = mv_cesa_ahash_dma_last_req(&basereq->chain, &iter, creq,
-						frag_len, flags);
-	else if (frag_len)
-		op = mv_cesa_dma_add_frag(&basereq->chain, &creq->op_tmpl,
-					  frag_len, flags);
-
-	if (IS_ERR(op)) {
-		ret = PTR_ERR(op);
-		goto err_free_tdma;
-	}
-
-	/*
-	 * If results are copied via DMA, this means that this
-	 * request can be directly processed by the engine,
-	 * without partial updates. So we can chain it at the
-	 * DMA level with other requests.
-	 */
-	type = basereq->chain.last->flags & CESA_TDMA_TYPE_MSK;
-
-	if (op && type != CESA_TDMA_RESULT) {
-		/* Add dummy desc to wait for crypto operation end */
-		ret = mv_cesa_dma_add_dummy_end(&basereq->chain, flags);
-		if (ret)
-			goto err_free_tdma;
-	}
-
-	if (!creq->last_req)
-		creq->cache_ptr = req->nbytes + creq->cache_ptr -
-				  iter.base.len;
-	else
-		creq->cache_ptr = 0;
-
-	basereq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
-
-	if (type != CESA_TDMA_RESULT)
-		basereq->chain.last->flags |= CESA_TDMA_BREAK_CHAIN;
-
-	if (set_state) {
-		/*
-		 * Put the CESA_TDMA_SET_STATE flag on the first tdma desc to
-		 * let the step logic know that the IVDIG registers should be
-		 * explicitly set before launching a TDMA chain.
-		 */
-		basereq->chain.first->flags |= CESA_TDMA_SET_STATE;
-	}
-
-	return 0;
-
-err_free_tdma:
-	mv_cesa_dma_cleanup(basereq);
-	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
-
-err:
-	mv_cesa_ahash_last_cleanup(req);
-
-	return ret;
-}
-
-static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-
-	creq->src_nents = sg_nents_for_len(req->src, req->nbytes);
-	if (creq->src_nents < 0) {
-		dev_err(cesa_dev->dev, "Invalid number of src SG");
-		return creq->src_nents;
-	}
-
-	*cached = mv_cesa_ahash_cache_req(req);
-
-	if (*cached)
-		return 0;
-
-	if (cesa_dev->caps->has_tdma)
-		return mv_cesa_ahash_dma_req_init(req);
-	else
-		return 0;
-}
-
-static int mv_cesa_ahash_queue_req(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_engine *engine;
-	bool cached = false;
-	int ret;
-
-	ret = mv_cesa_ahash_req_init(req, &cached);
-	if (ret)
-		return ret;
-
-	if (cached)
-		return 0;
-
-	engine = mv_cesa_select_engine(req->nbytes);
-	mv_cesa_ahash_prepare(&req->base, engine);
-
-	ret = mv_cesa_queue_req(&req->base, &creq->base);
-
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ahash_cleanup(req);
-
-	return ret;
-}
-
-static int mv_cesa_ahash_update(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-
-	creq->len += req->nbytes;
-
-	return mv_cesa_ahash_queue_req(req);
-}
-
-static int mv_cesa_ahash_final(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
-
-	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
-	creq->last_req = true;
-	req->nbytes = 0;
-
-	return mv_cesa_ahash_queue_req(req);
-}
-
-static int mv_cesa_ahash_finup(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
-
-	creq->len += req->nbytes;
-	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
-	creq->last_req = true;
-
-	return mv_cesa_ahash_queue_req(req);
-}
-
-static int mv_cesa_ahash_export(struct ahash_request *req, void *hash,
-				u64 *len, void *cache)
-{
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	unsigned int digsize = crypto_ahash_digestsize(ahash);
-	unsigned int blocksize;
-
-	blocksize = crypto_ahash_blocksize(ahash);
-
-	*len = creq->len;
-	memcpy(hash, creq->state, digsize);
-	memset(cache, 0, blocksize);
-	memcpy(cache, creq->cache, creq->cache_ptr);
-
-	return 0;
-}
-
-static int mv_cesa_ahash_import(struct ahash_request *req, const void *hash,
-				u64 len, const void *cache)
-{
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	unsigned int digsize = crypto_ahash_digestsize(ahash);
-	unsigned int blocksize;
-	unsigned int cache_ptr;
-	int ret;
-
-	ret = crypto_ahash_init(req);
-	if (ret)
-		return ret;
-
-	blocksize = crypto_ahash_blocksize(ahash);
-	if (len >= blocksize)
-		mv_cesa_update_op_cfg(&creq->op_tmpl,
-				      CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
-	creq->len = len;
-	memcpy(creq->state, hash, digsize);
-	creq->cache_ptr = 0;
-
-	cache_ptr = do_div(len, blocksize);
-	if (!cache_ptr)
-		return 0;
-
-	memcpy(creq->cache, cache, cache_ptr);
-	creq->cache_ptr = cache_ptr;
-
-	return 0;
-}
-
-static int mv_cesa_md5_init(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_op_ctx tmpl = { };
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
-
-	mv_cesa_ahash_init(req, &tmpl, true);
-
-	creq->state[0] = MD5_H0;
-	creq->state[1] = MD5_H1;
-	creq->state[2] = MD5_H2;
-	creq->state[3] = MD5_H3;
-
-	return 0;
-}
-
-static int mv_cesa_md5_export(struct ahash_request *req, void *out)
-{
-	struct md5_state *out_state = out;
-
-	return mv_cesa_ahash_export(req, out_state->hash,
-				    &out_state->byte_count, out_state->block);
-}
-
-static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
-{
-	const struct md5_state *in_state = in;
-
-	return mv_cesa_ahash_import(req, in_state->hash, in_state->byte_count,
-				    in_state->block);
-}
-
-static int mv_cesa_md5_digest(struct ahash_request *req)
-{
-	int ret;
-
-	ret = mv_cesa_md5_init(req);
-	if (ret)
-		return ret;
-
-	return mv_cesa_ahash_finup(req);
-}
-
-struct ahash_alg mv_md5_alg = {
-	.init = mv_cesa_md5_init,
-	.update = mv_cesa_ahash_update,
-	.final = mv_cesa_ahash_final,
-	.finup = mv_cesa_ahash_finup,
-	.digest = mv_cesa_md5_digest,
-	.export = mv_cesa_md5_export,
-	.import = mv_cesa_md5_import,
-	.halg = {
-		.digestsize = MD5_DIGEST_SIZE,
-		.statesize = sizeof(struct md5_state),
-		.base = {
-			.cra_name = "md5",
-			.cra_driver_name = "mv-md5",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
-			.cra_init = mv_cesa_ahash_cra_init,
-			.cra_module = THIS_MODULE,
-		 }
-	}
-};
-
-static int mv_cesa_sha1_init(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_op_ctx tmpl = { };
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA1);
-
-	mv_cesa_ahash_init(req, &tmpl, false);
-
-	creq->state[0] = SHA1_H0;
-	creq->state[1] = SHA1_H1;
-	creq->state[2] = SHA1_H2;
-	creq->state[3] = SHA1_H3;
-	creq->state[4] = SHA1_H4;
-
-	return 0;
-}
-
-static int mv_cesa_sha1_export(struct ahash_request *req, void *out)
-{
-	struct sha1_state *out_state = out;
-
-	return mv_cesa_ahash_export(req, out_state->state, &out_state->count,
-				    out_state->buffer);
-}
-
-static int mv_cesa_sha1_import(struct ahash_request *req, const void *in)
-{
-	const struct sha1_state *in_state = in;
-
-	return mv_cesa_ahash_import(req, in_state->state, in_state->count,
-				    in_state->buffer);
-}
-
-static int mv_cesa_sha1_digest(struct ahash_request *req)
-{
-	int ret;
-
-	ret = mv_cesa_sha1_init(req);
-	if (ret)
-		return ret;
-
-	return mv_cesa_ahash_finup(req);
-}
-
-struct ahash_alg mv_sha1_alg = {
-	.init = mv_cesa_sha1_init,
-	.update = mv_cesa_ahash_update,
-	.final = mv_cesa_ahash_final,
-	.finup = mv_cesa_ahash_finup,
-	.digest = mv_cesa_sha1_digest,
-	.export = mv_cesa_sha1_export,
-	.import = mv_cesa_sha1_import,
-	.halg = {
-		.digestsize = SHA1_DIGEST_SIZE,
-		.statesize = sizeof(struct sha1_state),
-		.base = {
-			.cra_name = "sha1",
-			.cra_driver_name = "mv-sha1",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = SHA1_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
-			.cra_init = mv_cesa_ahash_cra_init,
-			.cra_module = THIS_MODULE,
-		 }
-	}
-};
-
-static int mv_cesa_sha256_init(struct ahash_request *req)
-{
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	struct mv_cesa_op_ctx tmpl = { };
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
-
-	mv_cesa_ahash_init(req, &tmpl, false);
-
-	creq->state[0] = SHA256_H0;
-	creq->state[1] = SHA256_H1;
-	creq->state[2] = SHA256_H2;
-	creq->state[3] = SHA256_H3;
-	creq->state[4] = SHA256_H4;
-	creq->state[5] = SHA256_H5;
-	creq->state[6] = SHA256_H6;
-	creq->state[7] = SHA256_H7;
-
-	return 0;
-}
-
-static int mv_cesa_sha256_digest(struct ahash_request *req)
-{
-	int ret;
-
-	ret = mv_cesa_sha256_init(req);
-	if (ret)
-		return ret;
-
-	return mv_cesa_ahash_finup(req);
-}
-
-static int mv_cesa_sha256_export(struct ahash_request *req, void *out)
-{
-	struct sha256_state *out_state = out;
-
-	return mv_cesa_ahash_export(req, out_state->state, &out_state->count,
-				    out_state->buf);
-}
-
-static int mv_cesa_sha256_import(struct ahash_request *req, const void *in)
-{
-	const struct sha256_state *in_state = in;
-
-	return mv_cesa_ahash_import(req, in_state->state, in_state->count,
-				    in_state->buf);
-}
-
-struct ahash_alg mv_sha256_alg = {
-	.init = mv_cesa_sha256_init,
-	.update = mv_cesa_ahash_update,
-	.final = mv_cesa_ahash_final,
-	.finup = mv_cesa_ahash_finup,
-	.digest = mv_cesa_sha256_digest,
-	.export = mv_cesa_sha256_export,
-	.import = mv_cesa_sha256_import,
-	.halg = {
-		.digestsize = SHA256_DIGEST_SIZE,
-		.statesize = sizeof(struct sha256_state),
-		.base = {
-			.cra_name = "sha256",
-			.cra_driver_name = "mv-sha256",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = SHA256_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
-			.cra_init = mv_cesa_ahash_cra_init,
-			.cra_module = THIS_MODULE,
-		 }
-	}
-};
-
-struct mv_cesa_ahash_result {
-	struct completion completion;
-	int error;
-};
-
-static void mv_cesa_hmac_ahash_complete(struct crypto_async_request *req,
-					int error)
-{
-	struct mv_cesa_ahash_result *result = req->data;
-
-	if (error == -EINPROGRESS)
-		return;
-
-	result->error = error;
-	complete(&result->completion);
-}
-
-static int mv_cesa_ahmac_iv_state_init(struct ahash_request *req, u8 *pad,
-				       void *state, unsigned int blocksize)
-{
-	struct mv_cesa_ahash_result result;
-	struct scatterlist sg;
-	int ret;
-
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   mv_cesa_hmac_ahash_complete, &result);
-	sg_init_one(&sg, pad, blocksize);
-	ahash_request_set_crypt(req, &sg, pad, blocksize);
-	init_completion(&result.completion);
-
-	ret = crypto_ahash_init(req);
-	if (ret)
-		return ret;
-
-	ret = crypto_ahash_update(req);
-	if (ret && ret != -EINPROGRESS)
-		return ret;
-
-	wait_for_completion_interruptible(&result.completion);
-	if (result.error)
-		return result.error;
-
-	ret = crypto_ahash_export(req, state);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
-				  const u8 *key, unsigned int keylen,
-				  u8 *ipad, u8 *opad,
-				  unsigned int blocksize)
-{
-	struct mv_cesa_ahash_result result;
-	struct scatterlist sg;
-	int ret;
-	int i;
-
-	if (keylen <= blocksize) {
-		memcpy(ipad, key, keylen);
-	} else {
-		u8 *keydup = kmemdup(key, keylen, GFP_KERNEL);
-
-		if (!keydup)
-			return -ENOMEM;
-
-		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   mv_cesa_hmac_ahash_complete,
-					   &result);
-		sg_init_one(&sg, keydup, keylen);
-		ahash_request_set_crypt(req, &sg, ipad, keylen);
-		init_completion(&result.completion);
-
-		ret = crypto_ahash_digest(req);
-		if (ret == -EINPROGRESS) {
-			wait_for_completion_interruptible(&result.completion);
-			ret = result.error;
-		}
-
-		/* Set the memory region to 0 to avoid any leak. */
-		kzfree(keydup);
-
-		if (ret)
-			return ret;
-
-		keylen = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
-	}
-
-	memset(ipad + keylen, 0, blocksize - keylen);
-	memcpy(opad, ipad, blocksize);
-
-	for (i = 0; i < blocksize; i++) {
-		ipad[i] ^= HMAC_IPAD_VALUE;
-		opad[i] ^= HMAC_OPAD_VALUE;
-	}
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_setkey(const char *hash_alg_name,
-				const u8 *key, unsigned int keylen,
-				void *istate, void *ostate)
-{
-	struct ahash_request *req;
-	struct crypto_ahash *tfm;
-	unsigned int blocksize;
-	u8 *ipad = NULL;
-	u8 *opad;
-	int ret;
-
-	tfm = crypto_alloc_ahash(hash_alg_name, 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	req = ahash_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		ret = -ENOMEM;
-		goto free_ahash;
-	}
-
-	crypto_ahash_clear_flags(tfm, ~0);
-
-	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-
-	ipad = kcalloc(2, blocksize, GFP_KERNEL);
-	if (!ipad) {
-		ret = -ENOMEM;
-		goto free_req;
-	}
-
-	opad = ipad + blocksize;
-
-	ret = mv_cesa_ahmac_pad_init(req, key, keylen, ipad, opad, blocksize);
-	if (ret)
-		goto free_ipad;
-
-	ret = mv_cesa_ahmac_iv_state_init(req, ipad, istate, blocksize);
-	if (ret)
-		goto free_ipad;
-
-	ret = mv_cesa_ahmac_iv_state_init(req, opad, ostate, blocksize);
-
-free_ipad:
-	kfree(ipad);
-free_req:
-	ahash_request_free(req);
-free_ahash:
-	crypto_free_ahash(tfm);
-
-	return ret;
-}
-
-static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm)
-{
-	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->base.ops = &mv_cesa_ahash_req_ops;
-
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct mv_cesa_ahash_req));
-	return 0;
-}
-
-static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
-{
-	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct mv_cesa_op_ctx tmpl = { };
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_MD5);
-	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
-
-	mv_cesa_ahash_init(req, &tmpl, true);
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_md5_setkey(struct crypto_ahash *tfm, const u8 *key,
-				    unsigned int keylen)
-{
-	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct md5_state istate, ostate;
-	int ret, i;
-
-	ret = mv_cesa_ahmac_setkey("mv-md5", key, keylen, &istate, &ostate);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < ARRAY_SIZE(istate.hash); i++)
-		ctx->iv[i] = be32_to_cpu(istate.hash[i]);
-
-	for (i = 0; i < ARRAY_SIZE(ostate.hash); i++)
-		ctx->iv[i + 8] = be32_to_cpu(ostate.hash[i]);
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_md5_digest(struct ahash_request *req)
-{
-	int ret;
-
-	ret = mv_cesa_ahmac_md5_init(req);
-	if (ret)
-		return ret;
-
-	return mv_cesa_ahash_finup(req);
-}
-
-struct ahash_alg mv_ahmac_md5_alg = {
-	.init = mv_cesa_ahmac_md5_init,
-	.update = mv_cesa_ahash_update,
-	.final = mv_cesa_ahash_final,
-	.finup = mv_cesa_ahash_finup,
-	.digest = mv_cesa_ahmac_md5_digest,
-	.setkey = mv_cesa_ahmac_md5_setkey,
-	.export = mv_cesa_md5_export,
-	.import = mv_cesa_md5_import,
-	.halg = {
-		.digestsize = MD5_DIGEST_SIZE,
-		.statesize = sizeof(struct md5_state),
-		.base = {
-			.cra_name = "hmac(md5)",
-			.cra_driver_name = "mv-hmac-md5",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
-			.cra_init = mv_cesa_ahmac_cra_init,
-			.cra_module = THIS_MODULE,
-		 }
-	}
-};
-
-static int mv_cesa_ahmac_sha1_init(struct ahash_request *req)
-{
-	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct mv_cesa_op_ctx tmpl = { };
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA1);
-	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
-
-	mv_cesa_ahash_init(req, &tmpl, false);
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
-				     unsigned int keylen)
-{
-	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct sha1_state istate, ostate;
-	int ret, i;
-
-	ret = mv_cesa_ahmac_setkey("mv-sha1", key, keylen, &istate, &ostate);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
-		ctx->iv[i] = be32_to_cpu(istate.state[i]);
-
-	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
-		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_sha1_digest(struct ahash_request *req)
-{
-	int ret;
-
-	ret = mv_cesa_ahmac_sha1_init(req);
-	if (ret)
-		return ret;
-
-	return mv_cesa_ahash_finup(req);
-}
-
-struct ahash_alg mv_ahmac_sha1_alg = {
-	.init = mv_cesa_ahmac_sha1_init,
-	.update = mv_cesa_ahash_update,
-	.final = mv_cesa_ahash_final,
-	.finup = mv_cesa_ahash_finup,
-	.digest = mv_cesa_ahmac_sha1_digest,
-	.setkey = mv_cesa_ahmac_sha1_setkey,
-	.export = mv_cesa_sha1_export,
-	.import = mv_cesa_sha1_import,
-	.halg = {
-		.digestsize = SHA1_DIGEST_SIZE,
-		.statesize = sizeof(struct sha1_state),
-		.base = {
-			.cra_name = "hmac(sha1)",
-			.cra_driver_name = "mv-hmac-sha1",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = SHA1_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
-			.cra_init = mv_cesa_ahmac_cra_init,
-			.cra_module = THIS_MODULE,
-		 }
-	}
-};
-
-static int mv_cesa_ahmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
-				       unsigned int keylen)
-{
-	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct sha256_state istate, ostate;
-	int ret, i;
-
-	ret = mv_cesa_ahmac_setkey("mv-sha256", key, keylen, &istate, &ostate);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
-		ctx->iv[i] = be32_to_cpu(istate.state[i]);
-
-	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
-		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_sha256_init(struct ahash_request *req)
-{
-	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct mv_cesa_op_ctx tmpl = { };
-
-	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA256);
-	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
-
-	mv_cesa_ahash_init(req, &tmpl, false);
-
-	return 0;
-}
-
-static int mv_cesa_ahmac_sha256_digest(struct ahash_request *req)
-{
-	int ret;
-
-	ret = mv_cesa_ahmac_sha256_init(req);
-	if (ret)
-		return ret;
-
-	return mv_cesa_ahash_finup(req);
-}
-
-struct ahash_alg mv_ahmac_sha256_alg = {
-	.init = mv_cesa_ahmac_sha256_init,
-	.update = mv_cesa_ahash_update,
-	.final = mv_cesa_ahash_final,
-	.finup = mv_cesa_ahash_finup,
-	.digest = mv_cesa_ahmac_sha256_digest,
-	.setkey = mv_cesa_ahmac_sha256_setkey,
-	.export = mv_cesa_sha256_export,
-	.import = mv_cesa_sha256_import,
-	.halg = {
-		.digestsize = SHA256_DIGEST_SIZE,
-		.statesize = sizeof(struct sha256_state),
-		.base = {
-			.cra_name = "hmac(sha256)",
-			.cra_driver_name = "mv-hmac-sha256",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = SHA256_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
-			.cra_init = mv_cesa_ahmac_cra_init,
-			.cra_module = THIS_MODULE,
-		 }
-	}
-};
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
deleted file mode 100644
index 45939d5..0000000
--- a/drivers/crypto/marvell/tdma.c
+++ /dev/null
@@ -1,350 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Provide TDMA helper functions used by cipher and hash algorithm
- * implementations.
- *
- * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
- * Author: Arnaud Ebalard <arno@natisbad.org>
- *
- * This work is based on an initial version written by
- * Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
- */
-
-#include "cesa.h"
-
-bool mv_cesa_req_dma_iter_next_transfer(struct mv_cesa_dma_iter *iter,
-					struct mv_cesa_sg_dma_iter *sgiter,
-					unsigned int len)
-{
-	if (!sgiter->sg)
-		return false;
-
-	sgiter->op_offset += len;
-	sgiter->offset += len;
-	if (sgiter->offset == sg_dma_len(sgiter->sg)) {
-		if (sg_is_last(sgiter->sg))
-			return false;
-		sgiter->offset = 0;
-		sgiter->sg = sg_next(sgiter->sg);
-	}
-
-	if (sgiter->op_offset == iter->op_len)
-		return false;
-
-	return true;
-}
-
-void mv_cesa_dma_step(struct mv_cesa_req *dreq)
-{
-	struct mv_cesa_engine *engine = dreq->engine;
-
-	writel_relaxed(0, engine->regs + CESA_SA_CFG);
-
-	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
-	writel_relaxed(CESA_TDMA_DST_BURST_128B | CESA_TDMA_SRC_BURST_128B |
-		       CESA_TDMA_NO_BYTE_SWAP | CESA_TDMA_EN,
-		       engine->regs + CESA_TDMA_CONTROL);
-
-	writel_relaxed(CESA_SA_CFG_ACT_CH0_IDMA | CESA_SA_CFG_MULTI_PKT |
-		       CESA_SA_CFG_CH0_W_IDMA | CESA_SA_CFG_PARA_DIS,
-		       engine->regs + CESA_SA_CFG);
-	writel_relaxed(dreq->chain.first->cur_dma,
-		       engine->regs + CESA_TDMA_NEXT_ADDR);
-	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
-	       CESA_SA_CMD_EN_CESA_SA_ACCL0);
-	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
-}
-
-void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq)
-{
-	struct mv_cesa_tdma_desc *tdma;
-
-	for (tdma = dreq->chain.first; tdma;) {
-		struct mv_cesa_tdma_desc *old_tdma = tdma;
-		u32 type = tdma->flags & CESA_TDMA_TYPE_MSK;
-
-		if (type == CESA_TDMA_OP)
-			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
-				      le32_to_cpu(tdma->src));
-
-		tdma = tdma->next;
-		dma_pool_free(cesa_dev->dma->tdma_desc_pool, old_tdma,
-			      old_tdma->cur_dma);
-	}
-
-	dreq->chain.first = NULL;
-	dreq->chain.last = NULL;
-}
-
-void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
-			 struct mv_cesa_engine *engine)
-{
-	struct mv_cesa_tdma_desc *tdma;
-
-	for (tdma = dreq->chain.first; tdma; tdma = tdma->next) {
-		if (tdma->flags & CESA_TDMA_DST_IN_SRAM)
-			tdma->dst = cpu_to_le32(tdma->dst + engine->sram_dma);
-
-		if (tdma->flags & CESA_TDMA_SRC_IN_SRAM)
-			tdma->src = cpu_to_le32(tdma->src + engine->sram_dma);
-
-		if ((tdma->flags & CESA_TDMA_TYPE_MSK) == CESA_TDMA_OP)
-			mv_cesa_adjust_op(engine, tdma->op);
-	}
-}
-
-void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
-			struct mv_cesa_req *dreq)
-{
-	if (engine->chain.first == NULL && engine->chain.last == NULL) {
-		engine->chain.first = dreq->chain.first;
-		engine->chain.last  = dreq->chain.last;
-	} else {
-		struct mv_cesa_tdma_desc *last;
-
-		last = engine->chain.last;
-		last->next = dreq->chain.first;
-		engine->chain.last = dreq->chain.last;
-
-		/*
-		 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
-		 * the last element of the current chain, or if the request
-		 * being queued needs the IV regs to be set before lauching
-		 * the request.
-		 */
-		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
-		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
-			last->next_dma = dreq->chain.first->cur_dma;
-	}
-}
-
-int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
-{
-	struct crypto_async_request *req = NULL;
-	struct mv_cesa_tdma_desc *tdma = NULL, *next = NULL;
-	dma_addr_t tdma_cur;
-	int res = 0;
-
-	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
-
-	for (tdma = engine->chain.first; tdma; tdma = next) {
-		spin_lock_bh(&engine->lock);
-		next = tdma->next;
-		spin_unlock_bh(&engine->lock);
-
-		if (tdma->flags & CESA_TDMA_END_OF_REQ) {
-			struct crypto_async_request *backlog = NULL;
-			struct mv_cesa_ctx *ctx;
-			u32 current_status;
-
-			spin_lock_bh(&engine->lock);
-			/*
-			 * if req is NULL, this means we're processing the
-			 * request in engine->req.
-			 */
-			if (!req)
-				req = engine->req;
-			else
-				req = mv_cesa_dequeue_req_locked(engine,
-								 &backlog);
-
-			/* Re-chaining to the next request */
-			engine->chain.first = tdma->next;
-			tdma->next = NULL;
-
-			/* If this is the last request, clear the chain */
-			if (engine->chain.first == NULL)
-				engine->chain.last  = NULL;
-			spin_unlock_bh(&engine->lock);
-
-			ctx = crypto_tfm_ctx(req->tfm);
-			current_status = (tdma->cur_dma == tdma_cur) ?
-					  status : CESA_SA_INT_ACC0_IDMA_DONE;
-			res = ctx->ops->process(req, current_status);
-			ctx->ops->complete(req);
-
-			if (res == 0)
-				mv_cesa_engine_enqueue_complete_request(engine,
-									req);
-
-			if (backlog)
-				backlog->complete(backlog, -EINPROGRESS);
-		}
-
-		if (res || tdma->cur_dma == tdma_cur)
-			break;
-	}
-
-	/* Save the last request in error to engine->req, so that the core
-	 * knows which request was fautly */
-	if (res) {
-		spin_lock_bh(&engine->lock);
-		engine->req = req;
-		spin_unlock_bh(&engine->lock);
-	}
-
-	return res;
-}
-
-static struct mv_cesa_tdma_desc *
-mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
-{
-	struct mv_cesa_tdma_desc *new_tdma = NULL;
-	dma_addr_t dma_handle;
-
-	new_tdma = dma_pool_zalloc(cesa_dev->dma->tdma_desc_pool, flags,
-				   &dma_handle);
-	if (!new_tdma)
-		return ERR_PTR(-ENOMEM);
-
-	new_tdma->cur_dma = dma_handle;
-	if (chain->last) {
-		chain->last->next_dma = cpu_to_le32(dma_handle);
-		chain->last->next = new_tdma;
-	} else {
-		chain->first = new_tdma;
-	}
-
-	chain->last = new_tdma;
-
-	return new_tdma;
-}
-
-int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
-			  u32 size, u32 flags, gfp_t gfp_flags)
-{
-	struct mv_cesa_tdma_desc *tdma, *op_desc;
-
-	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
-	if (IS_ERR(tdma))
-		return PTR_ERR(tdma);
-
-	/* We re-use an existing op_desc object to retrieve the context
-	 * and result instead of allocating a new one.
-	 * There is at least one object of this type in a CESA crypto
-	 * req, just pick the first one in the chain.
-	 */
-	for (op_desc = chain->first; op_desc; op_desc = op_desc->next) {
-		u32 type = op_desc->flags & CESA_TDMA_TYPE_MSK;
-
-		if (type == CESA_TDMA_OP)
-			break;
-	}
-
-	if (!op_desc)
-		return -EIO;
-
-	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
-	tdma->src = src;
-	tdma->dst = op_desc->src;
-	tdma->op = op_desc->op;
-
-	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
-	tdma->flags = flags | CESA_TDMA_RESULT;
-	return 0;
-}
-
-struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
-					const struct mv_cesa_op_ctx *op_templ,
-					bool skip_ctx,
-					gfp_t flags)
-{
-	struct mv_cesa_tdma_desc *tdma;
-	struct mv_cesa_op_ctx *op;
-	dma_addr_t dma_handle;
-	unsigned int size;
-
-	tdma = mv_cesa_dma_add_desc(chain, flags);
-	if (IS_ERR(tdma))
-		return ERR_CAST(tdma);
-
-	op = dma_pool_alloc(cesa_dev->dma->op_pool, flags, &dma_handle);
-	if (!op)
-		return ERR_PTR(-ENOMEM);
-
-	*op = *op_templ;
-
-	size = skip_ctx ? sizeof(op->desc) : sizeof(*op);
-
-	tdma = chain->last;
-	tdma->op = op;
-	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
-	tdma->src = cpu_to_le32(dma_handle);
-	tdma->dst = CESA_SA_CFG_SRAM_OFFSET;
-	tdma->flags = CESA_TDMA_DST_IN_SRAM | CESA_TDMA_OP;
-
-	return op;
-}
-
-int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
-				  dma_addr_t dst, dma_addr_t src, u32 size,
-				  u32 flags, gfp_t gfp_flags)
-{
-	struct mv_cesa_tdma_desc *tdma;
-
-	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
-	if (IS_ERR(tdma))
-		return PTR_ERR(tdma);
-
-	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
-	tdma->src = src;
-	tdma->dst = dst;
-
-	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
-	tdma->flags = flags | CESA_TDMA_DATA;
-
-	return 0;
-}
-
-int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain, gfp_t flags)
-{
-	struct mv_cesa_tdma_desc *tdma;
-
-	tdma = mv_cesa_dma_add_desc(chain, flags);
-	return PTR_ERR_OR_ZERO(tdma);
-}
-
-int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, gfp_t flags)
-{
-	struct mv_cesa_tdma_desc *tdma;
-
-	tdma = mv_cesa_dma_add_desc(chain, flags);
-	if (IS_ERR(tdma))
-		return PTR_ERR(tdma);
-
-	tdma->byte_cnt = cpu_to_le32(BIT(31));
-
-	return 0;
-}
-
-int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
-				 struct mv_cesa_dma_iter *dma_iter,
-				 struct mv_cesa_sg_dma_iter *sgiter,
-				 gfp_t gfp_flags)
-{
-	u32 flags = sgiter->dir == DMA_TO_DEVICE ?
-		    CESA_TDMA_DST_IN_SRAM : CESA_TDMA_SRC_IN_SRAM;
-	unsigned int len;
-
-	do {
-		dma_addr_t dst, src;
-		int ret;
-
-		len = mv_cesa_req_dma_iter_transfer_len(dma_iter, sgiter);
-		if (sgiter->dir == DMA_TO_DEVICE) {
-			dst = CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
-			src = sg_dma_address(sgiter->sg) + sgiter->offset;
-		} else {
-			dst = sg_dma_address(sgiter->sg) + sgiter->offset;
-			src = CESA_SA_DATA_SRAM_OFFSET + sgiter->op_offset;
-		}
-
-		ret = mv_cesa_dma_add_data_transfer(chain, dst, src, len,
-						    flags, gfp_flags);
-		if (ret)
-			return ret;
-
-	} while (mv_cesa_req_dma_iter_next_transfer(dma_iter, sgiter, len));
-
-	return 0;
-}
-- 
1.9.1

