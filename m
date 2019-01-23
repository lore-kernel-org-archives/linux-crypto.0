Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3900DC282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6DE320854
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfAWNIu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:08:50 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:2730 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbfAWNIo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 08:08:44 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7BC846BB108E763F0DF9;
        Wed, 23 Jan 2019 21:08:40 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.408.0; Wed, 23 Jan 2019 21:08:30 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>
Subject: [PATCH v2 3/4] crypto: hisilicon: Add HiSilicon ZIP accelerator support
Date:   Wed, 23 Jan 2019 21:08:52 +0800
Message-ID: <1548248933-149853-4-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The HiSilicon ZIP accelerator implements the zlib and gzip algorithm. It
uses Hisilicon QM as the interface to the CPU.

This patch provides PCIe driver to the accelerator and register it to
the crypto subsystem.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Hao Fang <fanghao11@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig          |    7 +
 drivers/crypto/hisilicon/Makefile         |    1 +
 drivers/crypto/hisilicon/zip/Makefile     |    2 +
 drivers/crypto/hisilicon/zip/zip.h        |   60 ++
 drivers/crypto/hisilicon/zip/zip_crypto.c |  484 ++++++++++++
 drivers/crypto/hisilicon/zip/zip_main.c   | 1199 +++++++++++++++++++++++++++++
 6 files changed, 1753 insertions(+)
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 993a98d..338a70a 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -16,3 +16,10 @@ config CRYPTO_DEV_HISI_SEC
 config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 && PCI && PCI_MSI
+
+config CRYPTO_DEV_HISI_ZIP
+	tristate "Support for HiSilicon ZIP accelerator"
+	depends on ARM64
+	select CRYPTO_DEV_HISI_QM
+	help
+	  Support for HiSilicon ZIP Driver
diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
index 05e9052..c97c5b2 100644
--- a/drivers/crypto/hisilicon/Makefile
+++ b/drivers/crypto/hisilicon/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += sec/
 obj-$(CONFIG_CRYPTO_DEV_HISI_QM) += qm.o
+obj-$(CONFIG_CRYPTO_DEV_HISI_ZIP) += zip/
diff --git a/drivers/crypto/hisilicon/zip/Makefile b/drivers/crypto/hisilicon/zip/Makefile
new file mode 100644
index 0000000..a936f09
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_HISI_ZIP) += hisi_zip.o
+hisi_zip-objs = zip_main.o zip_crypto.o
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
new file mode 100644
index 0000000..44a9e27
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Hisilicon Limited. */
+#ifndef HISI_ZIP_H
+#define HISI_ZIP_H
+
+#include <linux/list.h>
+#include "../qm.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"hisi_zip: " fmt
+
+enum hisi_zip_error_type {
+	/* negative compression */
+	HZIP_NC_ERR = 0x0d,
+};
+
+struct hisi_zip_ctrl;
+
+struct hisi_zip {
+	struct hisi_qm qm;
+	struct list_head list;
+	struct hisi_zip_ctrl *ctrl;
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
+struct hisi_zip *find_zip_device(int node);
+int hisi_zip_register_to_crypto(void);
+void hisi_zip_unregister_from_crypto(void);
+#endif
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
new file mode 100644
index 0000000..6fe1e40
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -0,0 +1,484 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Hisilicon Limited. */
+#include <crypto/internal/scompress.h>
+#include <linux/dma-mapping.h>
+#include "zip.h"
+
+#define HZIP_INPUT_BUFFER_SIZE			SZ_4M
+#define HZIP_OUTPUT_BUFFER_SIZE			SZ_4M
+
+#define HZIP_ALG_TYPE_ZLIB			0x02
+#define HZIP_ALG_TYPE_GZIP			0x03
+
+#define GZIP_HEAD_FHCRC_BIT			BIT(1)
+#define GZIP_HEAD_FEXTRA_BIT			BIT(2)
+#define GZIP_HEAD_FNAME_BIT			BIT(3)
+#define GZIP_HEAD_FCOMMENT_BIT			BIT(4)
+
+const u8 zlib_head[2] = {0x78, 0x9c};
+const u8 gzip_head[10] = {0x1f, 0x8b, 0x08, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x03};
+
+#define COMP_NAME_TO_TYPE(alg_name)					\
+	(!strcmp((alg_name), "zlib-deflate") ? HZIP_ALG_TYPE_ZLIB :	\
+	 !strcmp((alg_name), "gzip") ? HZIP_ALG_TYPE_GZIP : 0)		\
+
+#define TO_HEAD_SIZE(req_type)						\
+	(((req_type) == HZIP_ALG_TYPE_ZLIB) ? sizeof(zlib_head) :	\
+	 ((req_type) == HZIP_ALG_TYPE_GZIP) ? sizeof(gzip_head) : 0)	\
+
+#define TO_HEAD(req_type)						\
+	(((req_type) == HZIP_ALG_TYPE_ZLIB) ? zlib_head :		\
+	 ((req_type) == HZIP_ALG_TYPE_GZIP) ? gzip_head : 0)		\
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
+static void hisi_zip_fill_sqe(struct hisi_zip_sqe *sqe,
+			      struct hisi_zip_qp_ctx *qp_ctx, u32 len)
+{
+	struct hisi_zip_buffer *buffer = &qp_ctx->buffer;
+
+	memset(sqe, 0, sizeof(struct hisi_zip_sqe));
+
+	sqe->input_data_length = len;
+	sqe->dw9 = qp_ctx->qp->req_type;
+	sqe->dest_avail_out = HZIP_OUTPUT_BUFFER_SIZE;
+	sqe->source_addr_l = lower_32_bits(buffer->input_dma);
+	sqe->source_addr_h = upper_32_bits(buffer->input_dma);
+	sqe->dest_addr_l = lower_32_bits(buffer->output_dma);
+	sqe->dest_addr_h = upper_32_bits(buffer->output_dma);
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
+	buffer->input = dma_alloc_coherent(dev, HZIP_INPUT_BUFFER_SIZE,
+					   &buffer->input_dma, GFP_KERNEL);
+	if (!buffer->input)
+		return -ENOMEM;
+
+	buffer->output = dma_alloc_coherent(dev, HZIP_OUTPUT_BUFFER_SIZE,
+					    &buffer->output_dma, GFP_KERNEL);
+	if (!buffer->output) {
+		ret = -ENOMEM;
+		goto err_alloc_output_buffer;
+	}
+
+	return 0;
+
+err_alloc_output_buffer:
+	dma_free_coherent(dev, HZIP_INPUT_BUFFER_SIZE, buffer->input,
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
+	dma_free_coherent(dev, HZIP_INPUT_BUFFER_SIZE, buffer->input,
+			  buffer->input_dma);
+	dma_free_coherent(dev, HZIP_OUTPUT_BUFFER_SIZE, buffer->output,
+			  buffer->output_dma);
+}
+
+static int hisi_zip_create_qp(struct hisi_qm *qm, struct hisi_zip_qp_ctx *ctx,
+			      int alg_type, int req_type)
+{
+	struct hisi_qp *qp;
+	int ret;
+
+	qp = hisi_qm_create_qp(qm, alg_type);
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+
+	qp->req_type = req_type;
+	qp->qp_ctx = ctx;
+	ctx->qp = qp;
+
+	ret = hisi_zip_alloc_qp_buffer(ctx);
+	if (ret)
+		goto err_release_qp;
+
+	ret = hisi_qm_start_qp(qp, 0);
+	if (ret < 0)
+		goto err_free_qp_buffer;
+
+	return 0;
+
+err_free_qp_buffer:
+	hisi_zip_free_qp_buffer(ctx);
+err_release_qp:
+	hisi_qm_release_qp(qp);
+	return ret;
+}
+
+static void hisi_zip_release_qp(struct hisi_zip_qp_ctx *ctx)
+{
+	hisi_qm_stop_qp(ctx->qp);
+	hisi_zip_free_qp_buffer(ctx);
+	hisi_qm_release_qp(ctx->qp);
+}
+
+static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type)
+{
+	struct hisi_zip *hisi_zip;
+	struct hisi_qm *qm;
+	int ret, i, j;
+
+	/* find the proper zip device */
+	hisi_zip = find_zip_device(cpu_to_node(smp_processor_id()));
+	if (!hisi_zip) {
+		pr_err("Failed to find a proper ZIP device!\n");
+		return -ENODEV;
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
+	for (j = i - 1; j >= 0; j--)
+		hisi_zip_release_qp(&hisi_zip_ctx->qp_ctx[j]);
+
+	return ret;
+}
+
+static void *hisi_zip_alloc_scomp_ctx(struct crypto_scomp *tfm)
+{
+	const char *alg_name = crypto_tfm_alg_name(&tfm->base);
+	struct hisi_zip_ctx *hisi_zip_ctx;
+	int ret;
+
+	hisi_zip_ctx = kzalloc(sizeof(*hisi_zip_ctx), GFP_KERNEL);
+	if (!hisi_zip_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ret = hisi_zip_ctx_init(hisi_zip_ctx, COMP_NAME_TO_TYPE(alg_name));
+	if (ret) {
+		kzfree(hisi_zip_ctx);
+		return ERR_PTR(ret);
+	}
+
+	return hisi_zip_ctx;
+}
+
+static void hisi_zip_ctx_exit(struct hisi_zip_ctx *hisi_zip_ctx)
+{
+	int i;
+
+	/* release the qp */
+	for (i = 1; i >= 0; i--)
+		hisi_zip_release_qp(&hisi_zip_ctx->qp_ctx[i]);
+}
+
+static void hisi_zip_free_scomp_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	struct hisi_zip_ctx *hisi_zip_ctx = ctx;
+
+	hisi_zip_ctx_exit(hisi_zip_ctx);
+	kzfree(hisi_zip_ctx);
+}
+
+static int hisi_zip_copy_data_to_buffer(struct hisi_zip_qp_ctx *qp_ctx,
+					const u8 *src, unsigned int slen)
+{
+	struct hisi_zip_buffer *buffer = &qp_ctx->buffer;
+
+	if (slen > HZIP_INPUT_BUFFER_SIZE)
+		return -ENOSPC;
+
+	memcpy(buffer->input, src, slen);
+
+	return 0;
+}
+
+static struct hisi_zip_sqe *hisi_zip_get_writeback_sqe(struct hisi_qp *qp)
+{
+	struct hisi_qp_status *qp_status = &qp->qp_status;
+	struct hisi_zip_sqe *sq_base = qp->sqe;
+	u16 sq_head = qp_status->sq_head;
+
+	return sq_base + sq_head;
+}
+
+static void hisi_zip_add_comp_head(struct hisi_qp *qp, u8 *dst)
+{
+	u8 head_size = TO_HEAD_SIZE(qp->req_type);
+	const u8 *head = TO_HEAD(qp->req_type);
+
+	memcpy(dst, head, head_size);
+}
+
+static void hisi_zip_copy_data_from_buffer(struct hisi_zip_qp_ctx *qp_ctx,
+					   u8 *dst)
+{
+	struct hisi_zip_buffer *buffer = &qp_ctx->buffer;
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = hisi_zip_get_writeback_sqe(qp);
+	u16 sq_head;
+
+	memcpy(dst, buffer->output, zip_sqe->produced);
+
+	sq_head = qp->qp_status.sq_head;
+	if (sq_head == QM_Q_DEPTH - 1)
+		qp->qp_status.sq_head = 0;
+	else
+		qp->qp_status.sq_head++;
+
+	if (unlikely(test_bit(QP_FULL, &qp->qp_status.flags)))
+		clear_bit(QP_FULL, &qp->qp_status.flags);
+}
+
+static int hisi_zip_compress_data_output(struct hisi_zip_qp_ctx *qp_ctx,
+					 u8 *dst, unsigned int *dlen)
+{
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = hisi_zip_get_writeback_sqe(qp);
+	u32 status = zip_sqe->dw3 & 0xff;
+	u8 head_size = TO_HEAD_SIZE(qp->req_type);
+
+	if (status != 0 && status != HZIP_NC_ERR) {
+		dev_err(&qp->qm->pdev->dev, "Compression failed in qp%d!\n",
+			qp->qp_id);
+		return status;
+	}
+
+	if (zip_sqe->produced + head_size > *dlen)
+		return -ENOMEM;
+
+	hisi_zip_add_comp_head(qp, dst);
+	hisi_zip_copy_data_from_buffer(qp_ctx, dst + head_size);
+
+	*dlen = zip_sqe->produced + head_size;
+
+	return 0;
+}
+
+static int __zip_compress(struct hisi_zip_ctx *hisi_zip_ctx, const u8 *src,
+			  unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct hisi_zip_qp_ctx *qp_ctx = &hisi_zip_ctx->qp_ctx[QPC_COMP];
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
+	int ret;
+
+	if (!src || !slen || !dst || !dlen)
+		return -ENOMEM;
+
+	ret = hisi_zip_copy_data_to_buffer(qp_ctx, src, slen);
+	if (ret < 0)
+		return ret;
+
+	hisi_zip_fill_sqe(zip_sqe, qp_ctx, slen);
+
+	/* send command to start the compress job */
+	ret = hisi_qp_send(qp, zip_sqe);
+	if (ret < 0)
+		return ret;
+
+	ret = hisi_qp_poll(qp);
+	if (ret < 0)
+		return ret;
+
+	return hisi_zip_compress_data_output(qp_ctx, dst, dlen);
+}
+
+static int hisi_zip_scompress(struct crypto_scomp *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen,
+			      void *ctx)
+{
+	return __zip_compress((struct hisi_zip_ctx *)ctx, src, slen, dst, dlen);
+}
+
+static u16 get_extra_field_size(const u8 *start)
+{
+	return *((u16 *)start);
+}
+
+static u32 get_name_field_size(const u8 *start)
+{
+	return strlen(start) + 1;
+}
+
+static u32 get_comment_field_size(const u8 *start)
+{
+	return strlen(start) + 1;
+}
+
+static u32 get_gzip_head_size(const u8 *src)
+{
+	u8 head_flg = *(src + 3);
+	u32 size = 10;
+
+	if (head_flg & GZIP_HEAD_FEXTRA_BIT)
+		size += get_extra_field_size(src + size);
+	if (head_flg & GZIP_HEAD_FNAME_BIT)
+		size += get_name_field_size(src + size);
+	if (head_flg & GZIP_HEAD_FCOMMENT_BIT)
+		size += get_comment_field_size(src + size);
+	if (head_flg & GZIP_HEAD_FHCRC_BIT)
+		size += 2;
+
+	return size;
+}
+
+static int hisi_zip_get_comp_head_size(struct hisi_qp *qp, const u8 *src)
+{
+	switch (qp->req_type) {
+	case HZIP_ALG_TYPE_ZLIB:
+		return TO_HEAD_SIZE(HZIP_ALG_TYPE_ZLIB);
+	case HZIP_ALG_TYPE_GZIP:
+		return get_gzip_head_size(src);
+	default:
+		dev_err(&qp->qm->pdev->dev, "request type does not support!");
+		return -EINVAL;
+	}
+}
+
+static int hisi_zip_decompress_data_output(struct hisi_zip_qp_ctx *qp_ctx,
+					   u8 *dst, unsigned int *dlen)
+{
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = hisi_zip_get_writeback_sqe(qp);
+	u32 status = zip_sqe->dw3 & 0xff;
+
+	if (status != 0) {
+		dev_err(&qp->qm->pdev->dev, "Decompression fail in qp%u!\n",
+			qp->qp_id);
+		return status;
+	}
+
+	if (zip_sqe->produced > *dlen)
+		return -ENOMEM;
+
+	hisi_zip_copy_data_from_buffer(qp_ctx, dst);
+
+	*dlen = zip_sqe->produced;
+
+	return 0;
+}
+
+static int __zip_decompress(struct hisi_zip_ctx *hisi_zip_ctx, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct hisi_zip_qp_ctx *qp_ctx = &hisi_zip_ctx->qp_ctx[QPC_DECOMP];
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
+	u16 size;
+	int ret;
+
+	if (!src || !slen || !dst || !dlen)
+		return -ENOMEM;
+
+	size = hisi_zip_get_comp_head_size(qp, src);
+
+	ret = hisi_zip_copy_data_to_buffer(qp_ctx, src + size, slen - size);
+	if (ret < 0)
+		return ret;
+
+	hisi_zip_fill_sqe(zip_sqe, qp_ctx, slen - size);
+
+	/* send command to start the decompress job */
+	ret = hisi_qp_send(qp, zip_sqe);
+	if (ret < 0)
+		return ret;
+
+	ret = hisi_qp_poll(qp);
+	if (ret < 0)
+		return ret;
+
+	return hisi_zip_decompress_data_output(qp_ctx, dst, dlen);
+}
+
+static int hisi_zip_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+			       unsigned int slen, u8 *dst, unsigned int *dlen,
+			       void *ctx)
+{
+	return __zip_decompress((struct hisi_zip_ctx *)ctx, src, slen, dst,
+				dlen);
+}
+
+static struct scomp_alg hisi_zip_scomp_zlib = {
+	.alloc_ctx		= hisi_zip_alloc_scomp_ctx,
+	.free_ctx		= hisi_zip_free_scomp_ctx,
+	.compress		= hisi_zip_scompress,
+	.decompress		= hisi_zip_sdecompress,
+	.base			= {
+		.cra_name		= "zlib-deflate",
+		.cra_driver_name	= "hisi-zlib-scomp",
+		.cra_module		= THIS_MODULE,
+		.cra_priority           = 300,
+	}
+};
+
+static struct scomp_alg hisi_zip_scomp_gzip = {
+	.alloc_ctx		= hisi_zip_alloc_scomp_ctx,
+	.free_ctx		= hisi_zip_free_scomp_ctx,
+	.compress		= hisi_zip_scompress,
+	.decompress		= hisi_zip_sdecompress,
+	.base			= {
+		.cra_name		= "gzip",
+		.cra_driver_name	= "hisi-gzip-scomp",
+		.cra_module		= THIS_MODULE,
+		.cra_priority           = 300,
+	}
+};
+
+int hisi_zip_register_to_crypto(void)
+{
+	int ret;
+
+	ret = crypto_register_scomp(&hisi_zip_scomp_zlib);
+	if (ret < 0) {
+		pr_err("Zlib scomp algorithm registration failed\n");
+		return ret;
+	}
+
+	ret = crypto_register_scomp(&hisi_zip_scomp_gzip);
+	if (ret < 0) {
+		pr_err("Gzip scomp algorithm registration failed\n");
+		goto err_unregister_scomp_zlib;
+	}
+
+	return 0;
+
+err_unregister_scomp_zlib:
+	crypto_unregister_scomp(&hisi_zip_scomp_zlib);
+	return ret;
+}
+
+void hisi_zip_unregister_from_crypto(void)
+{
+	crypto_unregister_scomp(&hisi_zip_scomp_gzip);
+	crypto_unregister_scomp(&hisi_zip_scomp_zlib);
+}
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
new file mode 100644
index 0000000..e7471b7
--- /dev/null
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -0,0 +1,1199 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Hisilicon Limited. */
+#include <linux/acpi.h>
+#include <linux/aer.h>
+#include <linux/bitops.h>
+#include <linux/debugfs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/seq_file.h>
+#include <linux/topology.h>
+#include "zip.h"
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
+#define HZIP_QM_IDEL_STATUS		0x3040e4
+#define HZIP_MASTER_GLOBAL_CTRL		0x300000
+#define MASTER_GLOBAL_CTRL_SHUTDOWN	0x1
+#define HZIP_MASTER_TRANS_RETURN	0x300150
+#define MASTER_TRANS_RETURN_RW		0x3
+
+#define HZIP_CORE_DEBUG_COMP_0		0x302000
+#define HZIP_CORE_DEBUG_COMP_1		0x303000
+#define HZIP_CORE_DEBUG_DECOMP_0	0x304000
+#define HZIP_CORE_DEBUG_DECOMP_1	0x305000
+#define HZIP_CORE_DEBUG_DECOMP_2	0x306000
+#define HZIP_CORE_DEBUG_DECOMP_3	0x307000
+#define HZIP_CORE_DEBUG_DECOMP_4	0x308000
+#define HZIP_CORE_DEBUG_DECOMP_5	0x309000
+
+#define HZIP_CORE_INT_SOURCE		0x3010A0
+#define HZIP_CORE_INT_MASK		0x3010A4
+#define HZIP_CORE_INT_STATUS		0x3010AC
+#define HZIP_CORE_INT_STATUS_M_ECC	BIT(1)
+#define HZIP_CORE_SRAM_ECC_ERR_INFO	0x301148
+#define SRAM_ECC_ERR_NUM_SHIFT		16
+#define SRAM_ECC_ERR_ADDR_SHIFT		24
+#define HZIP_CORE_INT_DISABLE		0x000007FF
+#define HZIP_COMP_CORE_NUM		2
+#define HZIP_DECOMP_CORE_NUM		6
+#define HZIP_CORE_NUM			(HZIP_COMP_CORE_NUM + \
+					 HZIP_DECOMP_CORE_NUM)
+#define HZIP_SQE_SIZE			128
+#define HZIP_SQ_SIZE			(HZIP_SQE_SIZE * QM_Q_DEPTH)
+#define HZIP_PF_DEF_Q_NUM		64
+#define HZIP_PF_DEF_Q_BASE		0
+
+#define HZIP_SOFT_CTRL_CNT_CLR_CE	0x301000
+#define SOFT_CTRL_CNT_CLR_CE_BIT	BIT(0)
+
+static const char hisi_zip_name[] = "hisi_zip";
+static struct dentry *hzip_debugfs_root;
+LIST_HEAD(hisi_zip_list);
+DEFINE_MUTEX(hisi_zip_list_lock);
+
+struct hisi_zip *find_zip_device(int node)
+{
+	struct hisi_zip *ret = NULL;
+#ifdef CONFIG_NUMA
+	struct hisi_zip *hisi_zip;
+	int min_distance = 100;
+	struct device *dev;
+
+	mutex_lock(&hisi_zip_list_lock);
+
+	list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
+		dev = &hisi_zip->qm.pdev->dev;
+		if (node_distance(dev->numa_node, node) < min_distance) {
+			ret = hisi_zip;
+			min_distance = node_distance(dev->numa_node, node);
+		}
+	}
+#else
+	mutex_lock(&hisi_zip_list_lock);
+
+	ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
+#endif
+	mutex_unlock(&hisi_zip_list_lock);
+
+	return ret;
+}
+
+struct hisi_zip_hw_error {
+	u32 int_msk;
+	const char *msg;
+};
+
+static const struct hisi_zip_hw_error zip_hw_error[] = {
+	{ .int_msk = BIT(0), .msg = "zip_ecc_1bitt_err" },
+	{ .int_msk = BIT(1), .msg = "zip_ecc_2bit_err" },
+	{ .int_msk = BIT(2), .msg = "zip_axi_rresp_err" },
+	{ .int_msk = BIT(3), .msg = "zip_axi_bresp_err" },
+	{ .int_msk = BIT(4), .msg = "zip_src_addr_parse_err" },
+	{ .int_msk = BIT(5), .msg = "zip_dst_addr_parse_err" },
+	{ .int_msk = BIT(6), .msg = "zip_pre_in_addr_err" },
+	{ .int_msk = BIT(7), .msg = "zip_pre_in_data_err" },
+	{ .int_msk = BIT(8), .msg = "zip_com_inf_err" },
+	{ .int_msk = BIT(9), .msg = "zip_enc_inf_err" },
+	{ .int_msk = BIT(10), .msg = "zip_pre_out_err" },
+	{ /* sentinel */ }
+};
+
+enum ctrl_debug_file_index {
+	HZIP_CURRENT_QM,
+	HZIP_CLEAR_ENABLE,
+	HZIP_DEBUG_FILE_NUM,
+};
+
+static const char * const ctrl_debug_file_name[] = {
+	[HZIP_CURRENT_QM]   = "current_qm",
+	[HZIP_CLEAR_ENABLE] = "clear_enable",
+};
+
+struct ctrl_debug_file {
+	enum ctrl_debug_file_index index;
+	spinlock_t lock;
+	struct hisi_zip_ctrl *ctrl;
+};
+
+/*
+ * One ZIP controller has one PF and multiple VFs, some global configurations
+ * which PF has need this structure.
+ *
+ * Just relevant for PF.
+ */
+struct hisi_zip_ctrl {
+	u32 ctrl_q_num;
+	u32 num_vfs;
+	struct hisi_zip *hisi_zip;
+	struct dentry *debug_root;
+	struct ctrl_debug_file files[HZIP_DEBUG_FILE_NUM];
+};
+
+enum {
+	HZIP_COMP_CORE0,
+	HZIP_COMP_CORE1,
+	HZIP_DECOMP_CORE0,
+	HZIP_DECOMP_CORE1,
+	HZIP_DECOMP_CORE2,
+	HZIP_DECOMP_CORE3,
+	HZIP_DECOMP_CORE4,
+	HZIP_DECOMP_CORE5,
+};
+
+static const u64 core_offsets[] = {
+	[HZIP_COMP_CORE0]   = 0x302000,
+	[HZIP_COMP_CORE1]   = 0x303000,
+	[HZIP_DECOMP_CORE0] = 0x304000,
+	[HZIP_DECOMP_CORE1] = 0x305000,
+	[HZIP_DECOMP_CORE2] = 0x306000,
+	[HZIP_DECOMP_CORE3] = 0x307000,
+	[HZIP_DECOMP_CORE4] = 0x308000,
+	[HZIP_DECOMP_CORE5] = 0x309000,
+};
+
+static struct debugfs_reg32 hzip_dfx_regs[] = {
+	{"HZIP_GET_BD_NUM                ",  0x00ull},
+	{"HZIP_GET_RIGHT_BD              ",  0x04ull},
+	{"HZIP_GET_ERROR_BD              ",  0x08ull},
+	{"HZIP_DONE_BD_NUM               ",  0x0cull},
+	{"HZIP_WORK_CYCLE                ",  0x10ull},
+	{"HZIP_IDLE_CYCLE                ",  0x18ull},
+	{"HZIP_MAX_DELAY                 ",  0x20ull},
+	{"HZIP_MIN_DELAY                 ",  0x24ull},
+	{"HZIP_AVG_DELAY                 ",  0x28ull},
+	{"HZIP_MEM_VISIBLE_DATA          ",  0x30ull},
+	{"HZIP_MEM_VISIBLE_ADDR          ",  0x34ull},
+	{"HZIP_COMSUMED_BYTE             ",  0x38ull},
+	{"HZIP_PRODUCED_BYTE             ",  0x40ull},
+	{"HZIP_COMP_INF                  ",  0x70ull},
+	{"HZIP_PRE_OUT                   ",  0x78ull},
+	{"HZIP_BD_RD                     ",  0x7cull},
+	{"HZIP_BD_WR                     ",  0x80ull},
+	{"HZIP_GET_BD_AXI_ERR_NUM        ",  0x84ull},
+	{"HZIP_GET_BD_PARSE_ERR_NUM      ",  0x88ull},
+	{"HZIP_ADD_BD_AXI_ERR_NUM        ",  0x8cull},
+	{"HZIP_DECOMP_STF_RELOAD_CURR_ST ",  0x94ull},
+	{"HZIP_DECOMP_LZ77_CURR_ST       ",  0x9cull},
+};
+
+static int pf_q_num_set(const char *val, const struct kernel_param *kp)
+{
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI, 0xa250,
+					      NULL);
+	u32 n, q_num;
+	u8 rev_id;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	if (unlikely(!pdev)) {
+		q_num = min_t(u32, HZIP_QUEUE_NUM_V1, HZIP_QUEUE_NUM_V2);
+		pr_info("No device found currently, suppose queue number is %d\n",
+			q_num);
+	} else {
+		rev_id = pdev->revision;
+		switch (rev_id) {
+		case 0x20:
+			q_num = HZIP_QUEUE_NUM_V1;
+			break;
+		case 0x21:
+			q_num = HZIP_QUEUE_NUM_V2;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret != 0 || n > q_num)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+static const struct kernel_param_ops pf_q_num_ops = {
+	.set = pf_q_num_set,
+	.get = param_get_int,
+};
+
+static u32 pf_q_num = HZIP_PF_DEF_Q_NUM;
+module_param_cb(pf_q_num, &pf_q_num_ops, &pf_q_num, 0444);
+MODULE_PARM_DESC(pf_q_num, "Number of queues in PF(v1 0-4096, v2 0-1024)");
+
+static int uacce_mode;
+module_param(uacce_mode, int, 0);
+
+static const struct pci_device_id hisi_zip_dev_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, 0xa250) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, 0xa251) },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
+
+static inline void hisi_zip_add_to_list(struct hisi_zip *hisi_zip)
+{
+	mutex_lock(&hisi_zip_list_lock);
+	list_add_tail(&hisi_zip->list, &hisi_zip_list);
+	mutex_unlock(&hisi_zip_list_lock);
+}
+
+static inline void hisi_zip_remove_from_list(struct hisi_zip *hisi_zip)
+{
+	mutex_lock(&hisi_zip_list_lock);
+	list_del(&hisi_zip->list);
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
+
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_BD_RUSER_32_63);
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_SGL_RUSER_32_63);
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_DATA_RUSER_32_63);
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_DATA_WUSER_32_63);
+	writel(0x40001070, hisi_zip->qm.io_base + HZIP_BD_WUSER_32_63);
+
+	/* fsm count */
+	writel(0xfffffff, hisi_zip->qm.io_base + HZIP_FSM_MAX_CNT);
+
+	/* let's open all compression/decompression cores */
+	writel(0x100ff, hisi_zip->qm.io_base + 0x301004);
+
+	/* enable sqc writeback */
+	writel(0x1833, hisi_zip->qm.io_base + QM_CACHE_CTL);
+}
+
+static void hisi_zip_hw_error_set_state(struct hisi_zip *hisi_zip, bool state)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+
+	if (qm->ver == QM_HW_V1) {
+		writel(HZIP_CORE_INT_DISABLE, qm->io_base + HZIP_CORE_INT_MASK);
+		dev_info(&qm->pdev->dev, "ZIP v%d does not support hw error handle\n",
+			 qm->ver);
+		return;
+	}
+
+	if (state)
+		/* enable ZIP hw error interrupts */
+		writel(0, hisi_zip->qm.io_base + HZIP_CORE_INT_MASK);
+	else
+		/* disable ZIP hw error interrupts */
+		writel(HZIP_CORE_INT_DISABLE,
+		       hisi_zip->qm.io_base + HZIP_CORE_INT_MASK);
+}
+
+static inline struct hisi_qm *file_to_qm(struct ctrl_debug_file *file)
+{
+	struct hisi_zip *hisi_zip = file->ctrl->hisi_zip;
+
+	return &hisi_zip->qm;
+}
+
+static u32 current_qm_read(struct ctrl_debug_file *file)
+{
+	struct hisi_qm *qm = file_to_qm(file);
+
+	return readl(qm->io_base + QM_DFX_MB_CNT_VF);
+}
+
+static int current_qm_write(struct ctrl_debug_file *file, u32 val)
+{
+	struct hisi_qm *qm = file_to_qm(file);
+	struct hisi_zip_ctrl *ctrl = file->ctrl;
+
+	if (val > ctrl->num_vfs)
+		return -EINVAL;
+
+	writel(val, qm->io_base + QM_DFX_MB_CNT_VF);
+	writel(val, qm->io_base + QM_DFX_DB_CNT_VF);
+
+	return  0;
+}
+
+static u32 clear_enable_read(struct ctrl_debug_file *file)
+{
+	struct hisi_qm *qm = file_to_qm(file);
+
+	return readl(qm->io_base + HZIP_SOFT_CTRL_CNT_CLR_CE) &
+	       SOFT_CTRL_CNT_CLR_CE_BIT;
+}
+
+static int clear_enable_write(struct ctrl_debug_file *file, u32 val)
+{
+	struct hisi_qm *qm = file_to_qm(file);
+	u32 tmp;
+
+	if (val != 1 && val != 0)
+		return -EINVAL;
+
+	tmp = (readl(qm->io_base + HZIP_SOFT_CTRL_CNT_CLR_CE) &
+	       ~SOFT_CTRL_CNT_CLR_CE_BIT) | val;
+	writel(tmp, qm->io_base + HZIP_SOFT_CTRL_CNT_CLR_CE);
+
+	return  0;
+}
+
+static ssize_t ctrl_debug_read(struct file *filp, char __user *buf,
+			     size_t count, loff_t *pos)
+{
+	struct ctrl_debug_file *file = filp->private_data;
+	char tbuf[20];
+	u32 val;
+	int ret;
+
+	spin_lock_irq(&file->lock);
+	switch (file->index) {
+	case HZIP_CURRENT_QM:
+		val = current_qm_read(file);
+		break;
+	case HZIP_CLEAR_ENABLE:
+		val = clear_enable_read(file);
+		break;
+	default:
+		spin_unlock_irq(&file->lock);
+		return -EINVAL;
+	}
+	spin_unlock_irq(&file->lock);
+	ret = sprintf(tbuf, "%u\n", val);
+	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
+}
+
+static ssize_t ctrl_debug_write(struct file *filp, const char __user *buf,
+			      size_t count, loff_t *pos)
+{
+	struct ctrl_debug_file *file = filp->private_data;
+	char tbuf[20];
+	unsigned long val;
+	int len, ret;
+
+	if (*pos != 0)
+		return 0;
+
+	if (count >= 20)
+		return -ENOSPC;
+
+	len = simple_write_to_buffer(tbuf, 20 - 1, pos, buf, count);
+	if (len < 0)
+		return len;
+
+	tbuf[len] = '\0';
+	if (kstrtoul(tbuf, 0, &val))
+		return -EFAULT;
+
+	spin_lock_irq(&file->lock);
+	switch (file->index) {
+	case HZIP_CURRENT_QM:
+		ret = current_qm_write(file, val);
+		if (ret)
+			goto err_input;
+		break;
+	case HZIP_CLEAR_ENABLE:
+		ret = clear_enable_write(file, val);
+		if (ret)
+			goto err_input;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_input;
+	}
+	spin_unlock_irq(&file->lock);
+
+	return count;
+
+err_input:
+	spin_unlock_irq(&file->lock);
+	return ret;
+}
+
+static const struct file_operations ctrl_debug_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = ctrl_debug_read,
+	.write = ctrl_debug_write,
+};
+
+static int hisi_zip_core_debug_init(struct hisi_zip_ctrl *ctrl)
+{
+	struct hisi_zip *hisi_zip = ctrl->hisi_zip;
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct device *dev = &qm->pdev->dev;
+	struct debugfs_regset32 *regset;
+	struct dentry *tmp_d, *tmp;
+	char buf[20];
+	int i;
+
+	for (i = 0; i < HZIP_CORE_NUM; i++) {
+		if (i < HZIP_COMP_CORE_NUM)
+			sprintf(buf, "comp_core%d", i);
+		else
+			sprintf(buf, "decomp_core%d", i - HZIP_COMP_CORE_NUM);
+
+		tmp_d = debugfs_create_dir(buf, ctrl->debug_root);
+		if (!tmp_d)
+			return -ENOENT;
+
+		regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
+		if (!regset)
+			return -ENOENT;
+
+		regset->regs = hzip_dfx_regs;
+		regset->nregs = ARRAY_SIZE(hzip_dfx_regs);
+		regset->base = qm->io_base + core_offsets[i];
+
+		tmp = debugfs_create_regset32("regs", 0444, tmp_d, regset);
+		if (!tmp)
+			return -ENOENT;
+	}
+
+	return 0;
+}
+
+static int hisi_zip_ctrl_debug_init(struct hisi_zip_ctrl *ctrl)
+{
+	struct dentry *tmp;
+	int i;
+
+	for (i = HZIP_CURRENT_QM; i < HZIP_DEBUG_FILE_NUM; i++) {
+		spin_lock_init(&ctrl->files[i].lock);
+		ctrl->files[i].ctrl = ctrl;
+		ctrl->files[i].index = i;
+
+		tmp = debugfs_create_file(ctrl_debug_file_name[i], 0600,
+					  ctrl->debug_root, ctrl->files + i,
+					  &ctrl_debug_fops);
+		if (!tmp)
+			return -ENOENT;
+	}
+
+	return hisi_zip_core_debug_init(ctrl);
+}
+
+static int hisi_zip_debugfs_init(struct hisi_zip *hisi_zip)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct device *dev = &qm->pdev->dev;
+	struct dentry *dev_d;
+	int ret;
+
+	dev_d = debugfs_create_dir(dev_name(dev), hzip_debugfs_root);
+	if (!dev_d)
+		return -ENOENT;
+
+	qm->debug.debug_root = dev_d;
+	ret = hisi_qm_debug_init(qm);
+	if (ret)
+		goto failed_to_create;
+
+	if (qm->pdev->device == 0xa250) {
+		hisi_zip->ctrl->debug_root = dev_d;
+		ret = hisi_zip_ctrl_debug_init(hisi_zip->ctrl);
+		if (ret)
+			goto failed_to_create;
+	}
+
+	return 0;
+
+failed_to_create:
+	debugfs_remove_recursive(hzip_debugfs_root);
+	return ret;
+}
+
+static void hisi_zip_debugfs_exit(struct hisi_zip *hisi_zip)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+
+	debugfs_remove_recursive(qm->debug.debug_root);
+}
+
+static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct hisi_zip_ctrl *ctrl;
+	u32 nfe_flag;
+
+	ctrl = devm_kzalloc(&qm->pdev->dev, sizeof(*ctrl), GFP_KERNEL);
+	if (!ctrl)
+		return -ENOMEM;
+
+	hisi_zip->ctrl = ctrl;
+	ctrl->hisi_zip = hisi_zip;
+
+	switch (qm->ver) {
+	case QM_HW_V1:
+		ctrl->ctrl_q_num = HZIP_QUEUE_NUM_V1;
+		break;
+
+	case QM_HW_V2:
+		ctrl->ctrl_q_num = HZIP_QUEUE_NUM_V2;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	hisi_zip_set_user_domain_and_cache(hisi_zip);
+
+	nfe_flag = QM_BASE_NFE | QM_ACC_WB_NOT_READY_TIMEOUT;
+	hisi_qm_hw_error_init(qm, QM_BASE_CE, nfe_flag, 0,
+			      QM_DB_RANDOM_INVALID);
+	hisi_zip_hw_error_set_state(hisi_zip, true);
+
+	return 0;
+}
+
+static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct hisi_zip *hisi_zip;
+	enum qm_hw_ver rev_id;
+	struct hisi_qm *qm;
+	int ret;
+
+	rev_id = hisi_qm_get_hw_version(pdev);
+	if (rev_id == QM_HW_UNKNOWN)
+		return -EINVAL;
+
+	hisi_zip = devm_kzalloc(&pdev->dev, sizeof(*hisi_zip), GFP_KERNEL);
+	if (!hisi_zip)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, hisi_zip);
+
+	hisi_zip_add_to_list(hisi_zip);
+
+	qm = &hisi_zip->qm;
+	qm->pdev = pdev;
+	qm->ver = rev_id;
+
+	qm->sqe_size = HZIP_SQE_SIZE;
+	qm->dev_name = hisi_zip_name;
+	qm->fun_type = (pdev->device == 0xa250) ? QM_HW_PF : QM_HW_VF;
+
+	switch (uacce_mode) {
+	case 0:
+		qm->use_dma_api = true;
+		qm->use_uacce = false;
+		break;
+	case 1:
+		qm->use_dma_api = false;
+		qm->use_uacce = true;
+		break;
+	case 2:
+		qm->use_dma_api = true;
+		qm->use_uacce = true;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_remove_from_list;
+	}
+
+	ret = hisi_qm_init(qm);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to init qm!\n");
+		goto err_remove_from_list;
+	}
+
+	if (qm->fun_type == QM_HW_PF) {
+		ret = hisi_zip_pf_probe_init(hisi_zip);
+		if (ret)
+			goto err_remove_from_list;
+
+		qm->qp_base = HZIP_PF_DEF_Q_BASE;
+		qm->qp_num = pf_q_num;
+	} else if (qm->fun_type == QM_HW_VF) {
+		/*
+		 * have no way to get qm configure in VM in v1 hardware,
+		 * so currently force PF to uses HZIP_PF_DEF_Q_NUM, and force
+		 * to trigger only one VF in v1 hardware.
+		 *
+		 * v2 hardware has no such problem.
+		 */
+		if (qm->ver == QM_HW_V1) {
+			qm->qp_base = HZIP_PF_DEF_Q_NUM;
+			qm->qp_num = HZIP_QUEUE_NUM_V1 - HZIP_PF_DEF_Q_NUM;
+		} else if (qm->ver == QM_HW_V2)
+			/* v2 starts to support get vft by mailbox */
+			hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+	}
+
+	ret = hisi_qm_start(qm);
+	if (ret)
+		goto err_qm_uninit;
+
+	ret = hisi_zip_debugfs_init(hisi_zip);
+	if (ret)
+		dev_err(&pdev->dev, "Failed to init debugfs (%d)!\n", ret);
+
+	return 0;
+
+err_qm_uninit:
+	hisi_qm_uninit(qm);
+err_remove_from_list:
+	hisi_zip_remove_from_list(hisi_zip);
+	return ret;
+}
+
+/* now we only support equal assignment */
+static int hisi_zip_vf_q_assign(struct hisi_zip *hisi_zip, int num_vfs)
+{
+	struct hisi_zip_ctrl *ctrl = hisi_zip->ctrl;
+	struct hisi_qm *qm = &hisi_zip->qm;
+	u32 qp_num = qm->qp_num;
+	u32 q_base = qp_num;
+	u32 q_num, remain_q_num, i;
+	int ret;
+
+	remain_q_num = ctrl->ctrl_q_num - qp_num;
+	q_num = remain_q_num / num_vfs;
+
+	for (i = 1; i <= num_vfs; i++) {
+		if (i == num_vfs)
+			q_num += remain_q_num % num_vfs;
+		ret = hisi_qm_set_vft(qm, i, q_base, q_num);
+		if (ret)
+			return ret;
+		q_base += q_num;
+	}
+
+	return 0;
+}
+
+static int hisi_zip_clear_vft_config(struct hisi_zip *hisi_zip)
+{
+	struct hisi_zip_ctrl *ctrl = hisi_zip->ctrl;
+	struct hisi_qm *qm = &hisi_zip->qm;
+	u32 i, num_vfs = ctrl->num_vfs;
+	int ret;
+
+	for (i = 1; i <= num_vfs; i++) {
+		ret = hisi_qm_set_vft(qm, i, 0, 0);
+		if (ret)
+			return ret;
+	}
+
+	ctrl->num_vfs = 0;
+
+	return 0;
+}
+
+static int hisi_zip_sriov_enable(struct pci_dev *pdev, int max_vfs)
+{
+#ifdef CONFIG_PCI_IOV
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+	int pre_existing_vfs, num_vfs, ret;
+
+	pre_existing_vfs = pci_num_vf(pdev);
+
+	if (pre_existing_vfs) {
+		dev_err(&pdev->dev,
+			"Can't enable VF. Please disable pre-enabled VFs!\n");
+		return 0;
+	}
+
+	num_vfs = min_t(int, max_vfs, HZIP_VF_NUM);
+
+	ret = hisi_zip_vf_q_assign(hisi_zip, num_vfs);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't assign queues for VF!\n");
+		return ret;
+	}
+
+	hisi_zip->ctrl->num_vfs = num_vfs;
+
+	ret = pci_enable_sriov(pdev, num_vfs);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't enable VF!\n");
+		hisi_zip_clear_vft_config(hisi_zip);
+		return ret;
+	}
+
+	return num_vfs;
+#else
+	return 0;
+#endif
+}
+
+static int hisi_zip_sriov_disable(struct pci_dev *pdev)
+{
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+
+	if (pci_vfs_assigned(pdev)) {
+		dev_err(&pdev->dev,
+			"Can't disable VFs while VFs are assigned!\n");
+		return -EPERM;
+	}
+
+	/* remove in hisi_zip_pci_driver will be called to free VF resources */
+	pci_disable_sriov(pdev);
+
+	return hisi_zip_clear_vft_config(hisi_zip);
+}
+
+static int hisi_zip_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	if (num_vfs == 0)
+		return hisi_zip_sriov_disable(pdev);
+	else
+		return hisi_zip_sriov_enable(pdev, num_vfs);
+}
+
+static void hisi_zip_remove(struct pci_dev *pdev)
+{
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+	struct hisi_qm *qm = &hisi_zip->qm;
+
+	if (qm->fun_type == QM_HW_PF && hisi_zip->ctrl->num_vfs != 0)
+		hisi_zip_sriov_disable(pdev);
+
+	hisi_zip_debugfs_exit(hisi_zip);
+	hisi_qm_stop(qm);
+
+	if (qm->fun_type == QM_HW_PF)
+		hisi_zip_hw_error_set_state(hisi_zip, false);
+
+	hisi_qm_uninit(qm);
+	hisi_zip_remove_from_list(hisi_zip);
+}
+
+static void hisi_zip_log_hw_error(struct hisi_zip *hisi_zip, u32 err_sts)
+{
+	const struct hisi_zip_hw_error *err = zip_hw_error;
+	struct device *dev = &hisi_zip->qm.pdev->dev;
+	u32 err_val;
+
+	while (err->msg) {
+		if (err->int_msk & err_sts) {
+			dev_warn(dev, "%s [error status=0x%x] found\n",
+				 err->msg, err->int_msk);
+
+			if (HZIP_CORE_INT_STATUS_M_ECC & err_sts) {
+				err_val = readl(hisi_zip->qm.io_base +
+						HZIP_CORE_SRAM_ECC_ERR_INFO);
+				dev_warn(dev, "hisi-zip multi ecc sram num=0x%x\n",
+					 ((err_val >> SRAM_ECC_ERR_NUM_SHIFT) &
+					  0xFF));
+				dev_warn(dev, "hisi-zip multi ecc sram addr=0x%x\n",
+					 (err_val >> SRAM_ECC_ERR_ADDR_SHIFT));
+			}
+		}
+		err++;
+	}
+}
+
+static pci_ers_result_t hisi_zip_hw_error_handle(struct hisi_zip *hisi_zip)
+{
+	u32 err_sts;
+
+	/* read err sts */
+	err_sts = readl(hisi_zip->qm.io_base + HZIP_CORE_INT_STATUS);
+
+	if (err_sts) {
+		hisi_zip_log_hw_error(hisi_zip, err_sts);
+		/* clear error interrupts */
+		writel(err_sts, hisi_zip->qm.io_base + HZIP_CORE_INT_SOURCE);
+
+		return PCI_ERS_RESULT_NEED_RESET;
+	}
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static pci_ers_result_t hisi_zip_process_hw_error(struct pci_dev *pdev)
+{
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	pci_ers_result_t qm_ret, zip_ret;
+
+	if (!hisi_zip) {
+		dev_err(dev,
+			"Can't recover ZIP-error occurred during device init\n");
+		return PCI_ERS_RESULT_NONE;
+	}
+
+	/* log qm error */
+	qm_ret = hisi_qm_hw_error_handle(&hisi_zip->qm);
+
+	/* log zip error */
+	zip_ret = hisi_zip_hw_error_handle(hisi_zip);
+
+	return (qm_ret == PCI_ERS_RESULT_NEED_RESET ||
+		zip_ret == PCI_ERS_RESULT_NEED_RESET) ?
+	       PCI_ERS_RESULT_NEED_RESET : PCI_ERS_RESULT_RECOVERED;
+}
+
+static pci_ers_result_t hisi_zip_error_detected(struct pci_dev *pdev,
+						pci_channel_state_t state)
+{
+	dev_info(&pdev->dev, "PCI error detected, state(=%d)!!\n", state);
+	if (state == pci_channel_io_perm_failure)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	return hisi_zip_process_hw_error(pdev);
+}
+
+static int hisi_zip_controller_reset_prepare(struct hisi_zip *hisi_zip)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct pci_dev *pdev = qm->pdev;
+	int ret;
+
+	ret = hisi_qm_stop(qm);
+	if (ret) {
+		dev_err(&pdev->dev, "Fails to stop QM!\n");
+		return ret;
+	}
+
+	if (test_and_set_bit(QM_RESET, &qm->flags)) {
+		dev_warn(&pdev->dev, "Failed to set reset flag!");
+		return -EPERM;
+	}
+
+	/* If having VFs enable, let's disable them firstly */
+	if (hisi_zip->ctrl->num_vfs) {
+		ret = hisi_zip_sriov_disable(pdev);
+		if (ret) {
+			dev_err(&pdev->dev, "Fails to disable VFs!\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void hisi_zip_set_mse(struct hisi_zip *hisi_zip, bool set)
+{
+	struct pci_dev *pdev = hisi_zip->qm.pdev;
+	u16 sriov_ctrl;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
+	pci_read_config_word(pdev, pos + PCI_SRIOV_CTRL, &sriov_ctrl);
+	if (set)
+		sriov_ctrl |= PCI_SRIOV_CTRL_MSE;
+	else
+		sriov_ctrl &= ~PCI_SRIOV_CTRL_MSE;
+	pci_write_config_word(pdev, pos + PCI_SRIOV_CTRL, sriov_ctrl);
+}
+
+static int hisi_zip_soft_reset(struct hisi_zip *hisi_zip)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct device *dev = &qm->pdev->dev;
+	int ret;
+	u32 val;
+
+	/* Set VF MSE bit */
+	hisi_zip_set_mse(hisi_zip, 1);
+
+	/* OOO register set and check */
+	writel(MASTER_GLOBAL_CTRL_SHUTDOWN,
+	       hisi_zip->qm.io_base + HZIP_MASTER_GLOBAL_CTRL);
+
+	/* If bus lock, reset chip */
+	ret = readl_relaxed_poll_timeout(hisi_zip->qm.io_base +
+					 HZIP_MASTER_TRANS_RETURN, val,
+					 (val == MASTER_TRANS_RETURN_RW), 10,
+					 1000);
+	if (ret) {
+		dev_emerg(dev, "Bus lock! Please reset system.\n");
+		return ret;
+	}
+
+	/* The reset related sub-control registers are not in PCI BAR */
+	if (ACPI_HANDLE(dev)) {
+		acpi_status s;
+
+		s = acpi_evaluate_object(ACPI_HANDLE(dev), "_RST", NULL, NULL);
+		if (ACPI_FAILURE(s)) {
+			dev_err(dev, "Controller reset fails\n");
+			return -EIO;
+		}
+	} else {
+		dev_err(dev, "No reset method!\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hisi_zip_controller_reset_done(struct hisi_zip *hisi_zip)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct pci_dev *pdev = qm->pdev;
+	struct hisi_qp *qp;
+	int i, ret;
+
+	hisi_qm_clear_queues(qm);
+
+	hisi_zip_set_user_domain_and_cache(hisi_zip);
+
+	ret = hisi_qm_start(qm);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to start QM!\n");
+		return -EIO;
+	}
+
+	for (i = 0; i < qm->qp_num; i++) {
+		qp = qm->qp_array[i];
+		if (qp) {
+			ret = hisi_qm_start_qp(qp, 0);
+			if (ret < 0) {
+				dev_err(&pdev->dev, "Start qp%d failed\n", i);
+				return -EIO;
+			}
+		}
+	}
+
+	if (hisi_zip->ctrl->num_vfs) {
+		ret = hisi_zip_sriov_enable(pdev, hisi_zip->ctrl->num_vfs);
+		if (ret) {
+			dev_err(&pdev->dev, "Can't enable VFs!\n");
+			return ret;
+		}
+	}
+
+	/* Clear VF MSE bit */
+	hisi_zip_set_mse(hisi_zip, 0);
+
+	return 0;
+}
+
+static int hisi_zip_controller_reset(struct hisi_zip *hisi_zip)
+{
+	struct device *dev = &hisi_zip->qm.pdev->dev;
+	int ret;
+
+	dev_info(dev, "Controller resetting...\n");
+
+	ret = hisi_zip_controller_reset_prepare(hisi_zip);
+	if (ret)
+		return ret;
+
+	ret = hisi_zip_soft_reset(hisi_zip);
+	if (ret) {
+		dev_err(dev, "Controller reset failed (%d)\n", ret);
+		return ret;
+	}
+
+	ret = hisi_zip_controller_reset_done(hisi_zip);
+	if (ret)
+		return ret;
+
+	dev_info(dev, "Controller reset complete\n");
+	clear_bit(QM_RESET, &hisi_zip->qm.flags);
+
+	return 0;
+}
+
+static pci_ers_result_t hisi_zip_slot_reset(struct pci_dev *pdev)
+{
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+	int ret;
+
+	dev_info(&pdev->dev, "Requesting reset due to PCI error\n");
+
+	pci_cleanup_aer_uncorrect_error_status(pdev);
+
+	/* reset zip controller */
+	ret = hisi_zip_controller_reset(hisi_zip);
+	if (ret) {
+		dev_warn(&pdev->dev, "hisi_zip controller reset failed (%d)\n",
+			 ret);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static void hisi_zip_reset_prepare(struct pci_dev *pdev)
+{
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	ret = hisi_qm_stop(qm);
+	if (ret) {
+		dev_err(&pdev->dev, "Fails to stop QM!\n");
+		return;
+	}
+
+	if (test_and_set_bit(QM_RESET, &qm->flags)) {
+		dev_warn(dev, "Failed to set reset flag!");
+		return;
+	}
+
+	/* If having VFs in PF, disable VFs before PF FLR */
+	if (pdev->is_physfn && hisi_zip->ctrl->num_vfs) {
+		ret = hisi_zip_sriov_disable(pdev);
+		if (ret) {
+			dev_err(dev, "Fails to disable VFs\n");
+			return;
+		}
+	}
+
+	dev_info(dev, "FLR resetting...\n");
+}
+
+static void hisi_zip_reset_done(struct pci_dev *pdev)
+{
+	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
+	struct hisi_qm *qm = &hisi_zip->qm;
+	struct device *dev = &pdev->dev;
+	struct hisi_qp *qp;
+	int i, ret;
+
+	if (pdev->is_physfn) {
+		hisi_qm_clear_queues(qm);
+
+		hisi_zip_set_user_domain_and_cache(hisi_zip);
+
+		ret = hisi_qm_start(qm);
+		if (ret) {
+			dev_err(dev, "Failed to start QM!\n");
+			return;
+		}
+
+		for (i = 0; i < qm->qp_num; i++) {
+			qp = qm->qp_array[i];
+			if (qp) {
+				ret = hisi_qm_start_qp(qp, 0);
+				if (ret < 0) {
+					dev_err(dev, "Start qp%d failed\n", i);
+					return;
+				}
+			}
+		}
+
+		if (hisi_zip->ctrl->num_vfs) {
+			ret = hisi_zip_sriov_enable(pdev,
+						    hisi_zip->ctrl->num_vfs);
+			if (ret) {
+				dev_err(dev, "Can't enable VFs!\n");
+				return;
+			}
+		}
+
+		dev_info(dev, "FLR reset complete\n");
+	}
+}
+
+static const struct pci_error_handlers hisi_zip_err_handler = {
+	.error_detected	= hisi_zip_error_detected,
+	.slot_reset	= hisi_zip_slot_reset,
+	.reset_prepare	= hisi_zip_reset_prepare,
+	.reset_done	= hisi_zip_reset_done,
+};
+
+static struct pci_driver hisi_zip_pci_driver = {
+	.name			= "hisi_zip",
+	.id_table		= hisi_zip_dev_ids,
+	.probe			= hisi_zip_probe,
+	.remove			= hisi_zip_remove,
+	.sriov_configure	= hisi_zip_sriov_configure,
+	.err_handler		= &hisi_zip_err_handler,
+};
+
+static void hisi_zip_register_debugfs(void)
+{
+	if (!debugfs_initialized())
+		return;
+
+	hzip_debugfs_root = debugfs_create_dir("hisi_zip", NULL);
+	if (IS_ERR_OR_NULL(hzip_debugfs_root))
+		hzip_debugfs_root = NULL;
+}
+
+static void hisi_zip_unregister_debugfs(void)
+{
+	debugfs_remove_recursive(hzip_debugfs_root);
+}
+
+static int __init hisi_zip_init(void)
+{
+	int ret;
+
+	hisi_zip_register_debugfs();
+
+	ret = pci_register_driver(&hisi_zip_pci_driver);
+	if (ret < 0) {
+		pr_err("Failed to register pci driver.\n");
+		goto err_pci;
+	}
+
+	if (uacce_mode == 0 || uacce_mode == 2) {
+		ret = hisi_zip_register_to_crypto();
+		if (ret < 0) {
+			pr_err("Failed to register driver to crypto.\n");
+			goto err_crypto;
+		}
+	}
+
+	return 0;
+
+err_crypto:
+	pci_unregister_driver(&hisi_zip_pci_driver);
+err_pci:
+	hisi_zip_unregister_debugfs();
+
+	return ret;
+}
+
+static void __exit hisi_zip_exit(void)
+{
+	if (uacce_mode == 0 || uacce_mode == 2)
+		hisi_zip_unregister_from_crypto();
+	pci_unregister_driver(&hisi_zip_pci_driver);
+	hisi_zip_unregister_debugfs();
+}
+
+module_init(hisi_zip_init);
+module_exit(hisi_zip_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Zhou Wang <wangzhou1@hisilicon.com>");
+MODULE_DESCRIPTION("Driver for HiSilicon ZIP accelerator");
-- 
2.8.1

