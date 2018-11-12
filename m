Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43056 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbeKLRwj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 12:52:39 -0500
From: Kenneth Lee <nek.in.cn@gmail.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Sell <timothy.sell@unisys.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>, Vinod Koul <vkoul@kernel.org>,
        David Kershner <david.kershner@unisys.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        Jens Axboe <axboe@kernel.dk>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Johan Hovold <johan@kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Cc: linuxarm@huawei.com, guodong.xu@linaro.org,
        zhangfei.gao@foxmail.com, haojian.zhuang@linaro.org,
        Kenneth Lee <liguozhu@hisilicon.com>
Subject: [RFCv3 PATCH 4/6] crypto/hisilicon: add Hisilicon zip driver
Date: Mon, 12 Nov 2018 15:58:05 +0800
Message-Id: <20181112075807.9291-5-nek.in.cn@gmail.com>
In-Reply-To: <20181112075807.9291-1-nek.in.cn@gmail.com>
References: <20181112075807.9291-1-nek.in.cn@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Kenneth Lee <liguozhu@hisilicon.com>

The Hisilicon ZIP accelerator implements the zlib and gzip algorithm. It
uses Hisilicon QM as the interface to the CPU.

This patch provides PCIE driver to the accelerator and register it to
the crypto subsystem.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Hao Fang <fanghao11@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig          |   7 +
 drivers/crypto/hisilicon/Makefile         |   1 +
 drivers/crypto/hisilicon/zip/Makefile     |   2 +
 drivers/crypto/hisilicon/zip/zip.h        |  57 ++++
 drivers/crypto/hisilicon/zip/zip_crypto.c | 362 ++++++++++++++++++++++
 drivers/crypto/hisilicon/zip/zip_crypto.h |  18 ++
 drivers/crypto/hisilicon/zip/zip_main.c   | 174 +++++++++++
 7 files changed, 621 insertions(+)
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 0e40f4a6666b..ce9deefbf037 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -15,3 +15,10 @@ config CRYPTO_DEV_HISI_SEC
 config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 && PCI
+
+config CRYPTO_DEV_HISI_ZIP
+	tristate "Support for HISI ZIP Driver"
+	depends on ARM64
+	select CRYPTO_DEV_HISI_QM
+	help
+	  Support for HiSilicon HIP08 ZIP Driver.
diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
index 05e9052e0f52..c97c5b27c3cb 100644
--- a/drivers/crypto/hisilicon/Makefile
+++ b/drivers/crypto/hisilicon/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += sec/
 obj-$(CONFIG_CRYPTO_DEV_HISI_QM) += qm.o
+obj-$(CONFIG_CRYPTO_DEV_HISI_ZIP) += zip/
diff --git a/drivers/crypto/hisilicon/zip/Makefile b/drivers/crypto/hisilicon/zip/Makefile
new file mode 100644
index 000000000000..a936f099ee22
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_HISI_ZIP) += hisi_zip.o
+hisi_zip-objs = zip_main.o zip_crypto.o
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
new file mode 100644
index 000000000000..26d72f7153b0
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef HISI_ZIP_H
+#define HISI_ZIP_H
+
+#include <linux/list.h>
+#include "../qm.h"
+
+#define HZIP_SQE_SIZE			128
+#define HZIP_SQ_SIZE			(HZIP_SQE_SIZE * QM_Q_DEPTH)
+#define QM_CQ_SIZE			(QM_CQE_SIZE * QM_Q_DEPTH)
+#define HZIP_PF_DEF_Q_NUM		64
+#define HZIP_PF_DEF_Q_BASE		0
+
+struct hisi_zip {
+	struct qm_info qm;
+	struct list_head list;
+
+#ifdef CONFIG_UACCE
+	struct uacce *uacce;
+#endif
+};
+
+struct hisi_zip_sqe {
+	__u32 consumed;
+	__u32 produced;
+	__u32 comp_data_length;
+	__u32 dw3;
+	__u32 input_data_length;
+	__u32 lba_l;
+	__u32 lba_h;
+	__u32 dw7;
+	__u32 dw8;
+	__u32 dw9;
+	__u32 dw10;
+	__u32 priv_info;
+	__u32 dw12;
+	__u32 tag;
+	__u32 dest_avail_out;
+	__u32 rsvd0;
+	__u32 comp_head_addr_l;
+	__u32 comp_head_addr_h;
+	__u32 source_addr_l;
+	__u32 source_addr_h;
+	__u32 dest_addr_l;
+	__u32 dest_addr_h;
+	__u32 stream_ctx_addr_l;
+	__u32 stream_ctx_addr_h;
+	__u32 cipher_key1_addr_l;
+	__u32 cipher_key1_addr_h;
+	__u32 cipher_key2_addr_l;
+	__u32 cipher_key2_addr_h;
+	__u32 rsvd1[4];
+};
+
+extern struct list_head hisi_zip_list;
+
+#endif
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
new file mode 100644
index 000000000000..104e5140bf4b
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -0,0 +1,362 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright 2018 (c) HiSilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/crypto.h>
+#include <linux/dma-mapping.h>
+#include <linux/pci.h>
+#include <linux/topology.h>
+#include "../qm.h"
+#include "zip.h"
+
+#define INPUT_BUFFER_SIZE	(64 * 1024)
+#define OUTPUT_BUFFER_SIZE	(64 * 1024)
+
+#define COMP_NAME_TO_TYPE(alg_name)			\
+	(!strcmp((alg_name), "zlib-deflate") ? 0x02 :	\
+	 !strcmp((alg_name), "gzip") ? 0x03 : 0)	\
+
+struct hisi_zip_buffer {
+	u8 *input;
+	dma_addr_t input_dma;
+	u8 *output;
+	dma_addr_t output_dma;
+};
+
+struct hisi_zip_qp_ctx {
+	struct hisi_zip_buffer buffer;
+	struct hisi_qp *qp;
+	struct hisi_zip_sqe zip_sqe;
+};
+
+struct hisi_zip_ctx {
+#define QPC_COMP	0
+#define QPC_DECOMP	1
+	struct hisi_zip_qp_ctx qp_ctx[2];
+};
+
+static struct hisi_zip *find_zip_device(int node)
+{
+	struct hisi_zip *hisi_zip, *ret = NULL;
+	struct device *dev;
+	int min_distance = 100;
+
+	list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
+		dev = &hisi_zip->qm.pdev->dev;
+		if (node_distance(dev->numa_node, node) < min_distance) {
+			ret = hisi_zip;
+			min_distance = node_distance(dev->numa_node, node);
+		}
+	}
+
+	return ret;
+}
+
+static void hisi_zip_qp_event_notifier(struct hisi_qp *qp)
+{
+	complete(&qp->completion);
+}
+
+static int hisi_zip_fill_sqe_v1(void *sqe, void *q_parm, u32 len)
+{
+	struct hisi_zip_sqe *zip_sqe = (struct hisi_zip_sqe *)sqe;
+	struct hisi_zip_qp_ctx *qp_ctx = (struct hisi_zip_qp_ctx *)q_parm;
+	struct hisi_zip_buffer *buffer = &qp_ctx->buffer;
+
+	memset(zip_sqe, 0, sizeof(struct hisi_zip_sqe));
+
+	zip_sqe->input_data_length = len;
+	zip_sqe->dw9 = qp_ctx->qp->req_type;
+	zip_sqe->dest_avail_out = OUTPUT_BUFFER_SIZE;
+	zip_sqe->source_addr_l = lower_32_bits(buffer->input_dma);
+	zip_sqe->source_addr_h = upper_32_bits(buffer->input_dma);
+	zip_sqe->dest_addr_l = lower_32_bits(buffer->output_dma);
+	zip_sqe->dest_addr_h = upper_32_bits(buffer->output_dma);
+
+	return 0;
+}
+
+/* let's allocate one buffer now, may have problem in async case */
+static int hisi_zip_alloc_qp_buffer(struct hisi_zip_qp_ctx *hisi_zip_qp_ctx)
+{
+	struct hisi_zip_buffer *buffer = &hisi_zip_qp_ctx->buffer;
+	struct hisi_qp *qp = hisi_zip_qp_ctx->qp;
+	struct device *dev = &qp->qm->pdev->dev;
+	int ret;
+
+	/* todo: we are using dma api here. it should be updated to uacce api
+	 * for user and kernel mode working at the same time
+	 */
+	buffer->input = dma_alloc_coherent(dev, INPUT_BUFFER_SIZE,
+					   &buffer->input_dma, GFP_KERNEL);
+	if (!buffer->input)
+		return -ENOMEM;
+
+	buffer->output = dma_alloc_coherent(dev, OUTPUT_BUFFER_SIZE,
+					    &buffer->output_dma, GFP_KERNEL);
+	if (!buffer->output) {
+		ret = -ENOMEM;
+		goto err_alloc_output_buffer;
+	}
+
+	return 0;
+
+err_alloc_output_buffer:
+	dma_free_coherent(dev, INPUT_BUFFER_SIZE, buffer->input,
+			  buffer->input_dma);
+	return ret;
+}
+
+static void hisi_zip_free_qp_buffer(struct hisi_zip_qp_ctx *hisi_zip_qp_ctx)
+{
+	struct hisi_zip_buffer *buffer = &hisi_zip_qp_ctx->buffer;
+	struct hisi_qp *qp = hisi_zip_qp_ctx->qp;
+	struct device *dev = &qp->qm->pdev->dev;
+
+	dma_free_coherent(dev, INPUT_BUFFER_SIZE, buffer->input,
+			  buffer->input_dma);
+	dma_free_coherent(dev, OUTPUT_BUFFER_SIZE, buffer->output,
+			  buffer->output_dma);
+}
+
+static int hisi_zip_create_qp(struct qm_info *qm, struct hisi_zip_qp_ctx *ctx,
+			      int alg_type, int req_type)
+{
+	struct hisi_qp *qp;
+	int ret;
+
+	qp = hisi_qm_create_qp(qm, alg_type);
+
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+
+	qp->event_cb = hisi_zip_qp_event_notifier;
+	qp->req_type = req_type;
+
+	qp->qp_ctx = ctx;
+	ctx->qp = qp;
+
+	ret = hisi_zip_alloc_qp_buffer(ctx);
+	if (ret)
+		goto err_with_qp;
+
+	ret = hisi_qm_start_qp(qp, 0);
+	if (ret)
+		goto err_with_qp_buffer;
+
+	return 0;
+err_with_qp_buffer:
+	hisi_zip_free_qp_buffer(ctx);
+err_with_qp:
+	hisi_qm_release_qp(qp);
+	return ret;
+}
+
+static void hisi_zip_release_qp(struct hisi_zip_qp_ctx *ctx)
+{
+	hisi_qm_release_qp(ctx->qp);
+	hisi_zip_free_qp_buffer(ctx);
+}
+
+static int hisi_zip_alloc_comp_ctx(struct crypto_tfm *tfm)
+{
+	struct hisi_zip_ctx *hisi_zip_ctx = crypto_tfm_ctx(tfm);
+	const char *alg_name = crypto_tfm_alg_name(tfm);
+	struct hisi_zip *hisi_zip;
+	struct qm_info *qm;
+	int ret, i, j;
+	u8 req_type = COMP_NAME_TO_TYPE(alg_name);
+
+	pr_debug("hisi_zip init %s \n", alg_name);
+
+	/* find the proper zip device */
+	hisi_zip = find_zip_device(cpu_to_node(smp_processor_id()));
+	if (!hisi_zip) {
+		pr_err("Can not find proper ZIP device!\n");
+		return -1;
+	}
+	qm = &hisi_zip->qm;
+
+	for (i = 0; i < 2; i++) {
+	/* it is just happen that 0 is compress, 1 is decompress on alg_type */
+		ret = hisi_zip_create_qp(qm, &hisi_zip_ctx->qp_ctx[i], i,
+					 req_type);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	for (j = i-1; j >= 0; j--)
+		hisi_zip_release_qp(&hisi_zip_ctx->qp_ctx[j]);
+
+	return ret;
+}
+
+static void hisi_zip_free_comp_ctx(struct crypto_tfm *tfm)
+{
+	struct hisi_zip_ctx *hisi_zip_ctx = crypto_tfm_ctx(tfm);
+	int i;
+
+	/* release the qp */
+	for (i = 1; i >= 0; i--)
+		hisi_zip_release_qp(&hisi_zip_ctx->qp_ctx[i]);
+}
+
+static int hisi_zip_copy_data_to_buffer(struct hisi_zip_qp_ctx *qp_ctx,
+					const u8 *src, unsigned int slen)
+{
+	struct hisi_zip_buffer *buffer = &qp_ctx->buffer;
+
+	if (slen > INPUT_BUFFER_SIZE)
+		return -EINVAL;
+
+	memcpy(buffer->input, src, slen);
+
+	return 0;
+}
+
+static struct hisi_zip_sqe *hisi_zip_get_writeback_sqe(struct hisi_qp *qp)
+{
+	struct hisi_acc_qp_status *qp_status = &qp->qp_status;
+	struct hisi_zip_sqe *sq_base = qp->sqe;
+	u16 sq_head = qp_status->sq_head;
+
+	return sq_base + sq_head;
+}
+
+static int hisi_zip_copy_data_from_buffer(struct hisi_zip_qp_ctx *qp_ctx,
+					   u8 *dst, unsigned int *dlen)
+{
+	struct hisi_zip_buffer *buffer = &qp_ctx->buffer;
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = hisi_zip_get_writeback_sqe(qp);
+	u32 status = zip_sqe->dw3 & 0xff;
+
+	if (status != 0) {
+		pr_err("hisi zip: %s fail!\n", (qp->alg_type == 0) ?
+		       "compression" : "decompression");
+		return status;
+	}
+
+	if (zip_sqe->produced > OUTPUT_BUFFER_SIZE)
+		return -ENOMEM;
+
+	memcpy(dst, buffer->output, zip_sqe->produced);
+	*dlen = zip_sqe->produced;
+	qp->qp_status.sq_head++;
+
+	return 0;
+}
+
+static int hisi_zip_compress(struct crypto_tfm *tfm, const u8 *src,
+			     unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct hisi_zip_ctx *hisi_zip_ctx = crypto_tfm_ctx(tfm);
+	struct hisi_zip_qp_ctx *qp_ctx = &hisi_zip_ctx->qp_ctx[QPC_COMP];
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
+	int ret;
+
+	ret = hisi_zip_copy_data_to_buffer(qp_ctx, src, slen);
+	if (ret < 0)
+		return ret;
+
+	hisi_zip_fill_sqe_v1(zip_sqe, qp_ctx, slen);
+
+	/* send command to start the compress job */
+	hisi_qp_send(qp, zip_sqe);
+
+	return hisi_zip_copy_data_from_buffer(qp_ctx, dst, dlen);
+}
+
+static int hisi_zip_decompress(struct crypto_tfm *tfm, const u8 *src,
+			       unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct hisi_zip_ctx *hisi_zip_ctx = crypto_tfm_ctx(tfm);
+	struct hisi_zip_qp_ctx *qp_ctx = &hisi_zip_ctx->qp_ctx[QPC_DECOMP];
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
+	int ret;
+
+	ret = hisi_zip_copy_data_to_buffer(qp_ctx, src, slen);
+	if (ret < 0)
+		return ret;
+
+	hisi_zip_fill_sqe_v1(zip_sqe, qp_ctx, slen);
+
+	/* send command to start the compress job */
+	hisi_qp_send(qp, zip_sqe);
+
+	return hisi_zip_copy_data_from_buffer(qp_ctx, dst, dlen);
+}
+
+static struct crypto_alg hisi_zip_zlib = {
+	.cra_name		= "zlib-deflate",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
+	.cra_priority           = 300,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= hisi_zip_alloc_comp_ctx,
+	.cra_exit		= hisi_zip_free_comp_ctx,
+	.cra_u			= {
+		.compress = {
+			.coa_compress	= hisi_zip_compress,
+			.coa_decompress	= hisi_zip_decompress
+		}
+	}
+};
+
+static struct crypto_alg hisi_zip_gzip = {
+	.cra_name		= "gzip",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
+	.cra_priority           = 300,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= hisi_zip_alloc_comp_ctx,
+	.cra_exit		= hisi_zip_free_comp_ctx,
+	.cra_u			= {
+		.compress = {
+			.coa_compress	= hisi_zip_compress,
+			.coa_decompress	= hisi_zip_decompress
+		}
+	}
+};
+
+int hisi_zip_register_to_crypto(void)
+{
+	int ret;
+
+	ret = crypto_register_alg(&hisi_zip_zlib);
+	if (ret) {
+		pr_err("Zlib algorithm registration failed\n");
+		return ret;
+	} else
+		pr_debug("hisi_zip: registered algorithm zlib\n");
+
+	ret = crypto_register_alg(&hisi_zip_gzip);
+	if (ret) {
+		pr_err("Gzip algorithm registration failed\n");
+		goto err_unregister_zlib;
+	} else
+		pr_debug("hisi_zip: registered algorithm gzip\n");
+
+	return 0;
+
+err_unregister_zlib:
+	crypto_unregister_alg(&hisi_zip_zlib);
+
+	return ret;
+}
+
+void hisi_zip_unregister_from_crypto(void)
+{
+	crypto_unregister_alg(&hisi_zip_zlib);
+	crypto_unregister_alg(&hisi_zip_gzip);
+}
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.h b/drivers/crypto/hisilicon/zip/zip_crypto.h
new file mode 100644
index 000000000000..6fae34b4df3a
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (c) 2018 HiSilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef HISI_ZIP_CRYPTO_H
+#define HISI_ZIP_CRYPTO_H
+
+int hisi_zip_register_to_crypto(void);
+void hisi_zip_unregister_from_crypto(void);
+
+#endif
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
new file mode 100644
index 000000000000..f4f3b6d89340
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <linux/io.h>
+#include <linux/bitops.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include "zip.h"
+#include "zip_crypto.h"
+
+#define HZIP_VF_NUM			63
+#define HZIP_QUEUE_NUM_V1		4096
+#define HZIP_QUEUE_NUM_V2		1024
+
+#define HZIP_FSM_MAX_CNT		0x301008
+
+#define HZIP_PORT_ARCA_CHE_0		0x301040
+#define HZIP_PORT_ARCA_CHE_1		0x301044
+#define HZIP_PORT_AWCA_CHE_0		0x301060
+#define HZIP_PORT_AWCA_CHE_1		0x301064
+
+#define HZIP_BD_RUSER_32_63		0x301110
+#define HZIP_SGL_RUSER_32_63		0x30111c
+#define HZIP_DATA_RUSER_32_63		0x301128
+#define HZIP_DATA_WUSER_32_63		0x301134
+#define HZIP_BD_WUSER_32_63		0x301140
+
+LIST_HEAD(hisi_zip_list);
+DEFINE_MUTEX(hisi_zip_list_lock);
+
+static const char hisi_zip_name[] = "hisi_zip";
+
+static const struct pci_device_id hisi_zip_dev_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, 0xa250) },
+	{ 0, }
+};
+
+static inline void hisi_zip_add_to_list(struct hisi_zip *hisi_zip)
+{
+	mutex_lock(&hisi_zip_list_lock);
+	list_add_tail(&hisi_zip->list, &hisi_zip_list);
+	mutex_unlock(&hisi_zip_list_lock);
+}
+
+static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
+{
+	u32 val;
+
+	/* qm user domain */
+	writel(0x40001070, hisi_zip->qm.io_base + QM_ARUSER_M_CFG_1);
+	writel(0xfffffffe, hisi_zip->qm.io_base + QM_ARUSER_M_CFG_ENABLE);
+	writel(0x40001070, hisi_zip->qm.io_base + QM_AWUSER_M_CFG_1);
+	writel(0xfffffffe, hisi_zip->qm.io_base + QM_AWUSER_M_CFG_ENABLE);
+	writel(0xffffffff, hisi_zip->qm.io_base + QM_WUSER_M_CFG_ENABLE);
+	writel(0x4893,     hisi_zip->qm.io_base + QM_CACHE_CTL);
+
+	val = readl(hisi_zip->qm.io_base + QM_PEH_AXUSER_CFG);
+	val |= (1 << 11);
+	writel(val, hisi_zip->qm.io_base + QM_PEH_AXUSER_CFG);
+
+	/* qm cache */
+	writel(0xffff,     hisi_zip->qm.io_base + QM_AXI_M_CFG);
+	writel(0xffffffff, hisi_zip->qm.io_base + QM_AXI_M_CFG_ENABLE);
+	writel(0xffffffff, hisi_zip->qm.io_base + QM_PEH_AXUSER_CFG_ENABLE);
+
+	/* cache */
+	writel(0xffffffff, hisi_zip->qm.io_base + HZIP_PORT_ARCA_CHE_0);
+	writel(0xffffffff, hisi_zip->qm.io_base + HZIP_PORT_ARCA_CHE_1);
+	writel(0xffffffff, hisi_zip->qm.io_base + HZIP_PORT_AWCA_CHE_0);
+	writel(0xffffffff, hisi_zip->qm.io_base + HZIP_PORT_AWCA_CHE_1);
+	/* user domain configurations */
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_BD_RUSER_32_63);
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_SGL_RUSER_32_63);
+	writel(0x40001071, hisi_zip->qm.io_base + HZIP_DATA_RUSER_32_63);
+	writel(0x40001071, hisi_zip->qm.io_base + HZIP_DATA_WUSER_32_63);
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_BD_WUSER_32_63);
+
+	/* fsm count */
+	writel(0xfffffff, hisi_zip->qm.io_base + HZIP_FSM_MAX_CNT);
+
+	/* clock gating, core, decompress verify enable */
+	writel(0x10005, hisi_zip->qm.io_base + 0x301004);
+}
+
+static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct hisi_zip *hisi_zip;
+	struct qm_info *qm;
+	int ret;
+	u8 rev_id;
+
+	hisi_zip = devm_kzalloc(&pdev->dev, sizeof(*hisi_zip), GFP_KERNEL);
+	if (!hisi_zip)
+		return -ENOMEM;
+	hisi_zip_add_to_list(hisi_zip); //todo: this is needed only by crypto
+
+	qm = &hisi_zip->qm;
+	qm->pdev = pdev;
+	qm->qp_base = HZIP_PF_DEF_Q_BASE;
+	qm->qp_num = HZIP_PF_DEF_Q_NUM;
+	qm->sqe_size = HZIP_SQE_SIZE;
+
+	pci_set_drvdata(pdev, hisi_zip);
+
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &rev_id);
+	if (rev_id == 0x20)
+		qm->ver = 1;
+
+	ret = hisi_qm_init(qm);
+	if (ret)
+		return ret;
+
+	if (pdev->is_physfn)
+		hisi_zip_set_user_domain_and_cache(hisi_zip);
+
+	ret = hisi_qm_start(qm);
+	if (ret)
+		goto err_with_qm_init;
+
+	return 0;
+
+err_with_qm_init:
+	hisi_qm_uninit(qm);
+	return ret;
+}
+
+static void hisi_zip_remove(struct pci_dev *pdev)
+{
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+	struct qm_info *qm = &hisi_zip->qm;
+
+	hisi_qm_stop(qm);
+	hisi_qm_uninit(qm);
+}
+
+static struct pci_driver hisi_zip_pci_driver = {
+	.name		= "hisi_zip",
+	.id_table	= hisi_zip_dev_ids,
+	.probe		= hisi_zip_probe,
+	.remove		= hisi_zip_remove,
+};
+
+static int __init hisi_zip_init(void)
+{
+	int ret;
+
+	ret = pci_register_driver(&hisi_zip_pci_driver);
+	if (ret < 0) {
+		pr_err("zip: can't register hisi zip driver.\n");
+		return ret;
+	}
+
+	ret = hisi_zip_register_to_crypto();
+	if (ret < 0) {
+		pci_unregister_driver(&hisi_zip_pci_driver);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit hisi_zip_exit(void)
+{
+	hisi_zip_unregister_from_crypto();
+	pci_unregister_driver(&hisi_zip_pci_driver);
+}
+
+module_init(hisi_zip_init);
+module_exit(hisi_zip_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Zhou Wang <wangzhou1@hisilicon.com>");
+MODULE_DESCRIPTION("Driver for HiSilicon ZIP accelerator");
+MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
-- 
2.17.1
