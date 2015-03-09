From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Mon, 09 Mar 2015 07:35:57 +0100
Message-ID: <1582962.nmzkjGWQFm@tauon>
References: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com> <1425610707-9869-2-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
	andrew.bresticker@chromium.org, ezequiel.garcia@imgtec.com,
	linux-crypto@vger.kernel.org
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:45970 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbbCIGgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 02:36:01 -0400
In-Reply-To: <1425610707-9869-2-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 6. M=E4rz 2015, 02:58:26 schrieb James Hartley:

Hi James,

>This adds support for the Imagination Technologies hash
>accelerator which provides hardware acceleration for
>SHA1 SHA224 SHA256 and MD5 hashes.
>
>Signed-off-by: James Hartley <james.hartley@imgtec.com>
>---
> drivers/crypto/Kconfig    |   14 +
> drivers/crypto/Makefile   |    2 +
> drivers/crypto/img-hash.c | 1037
>+++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 1053
>insertions(+)
> create mode 100644 drivers/crypto/img-hash.c
>
>diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>index 2fb0fdf..c72223e 100644
>--- a/drivers/crypto/Kconfig
>+++ b/drivers/crypto/Kconfig
>@@ -436,4 +436,18 @@ config CRYPTO_DEV_QCE
> 	  hardware. To compile this driver as a module, choose M here.=20
The
> 	  module will be called qcrypto.
>
>+config CRYPTO_DEV_IMGTEC_HASH
>+	depends on MIPS || COMPILE_TEST
>+	tristate "Imagination Technologies hardware hash accelerator"
>+	select CRYPTO_ALG_API
>+	select CRYPTO_MD5
>+	select CRYPTO_SHA1
>+	select CRYPTO_SHA224
>+	select CRYPTO_SHA256
>+	select CRYPTO_HASH
>+	help
>+	  This driver interfaces with the Imagination Technologies
>+	  hardware hash accelerator. Supporting MD5/SHA1/SHA224/SHA256
>+	  hashing algorithms.
>+
> endif # CRYPTO_HW
>diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
>index 3924f93..fb84be7 100644
>--- a/drivers/crypto/Makefile
>+++ b/drivers/crypto/Makefile
>@@ -6,6 +6,7 @@ obj-$(CONFIG_CRYPTO_DEV_CCP) +=3D ccp/
> obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) +=3D caam/
> obj-$(CONFIG_CRYPTO_DEV_GEODE) +=3D geode-aes.o
> obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) +=3D hifn_795x.o
>+obj-$(CONFIG_CRYPTO_DEV_IMGTEC_HASH) +=3D img-hash.o
> obj-$(CONFIG_CRYPTO_DEV_IXP4XX) +=3D ixp4xx_crypto.o
> obj-$(CONFIG_CRYPTO_DEV_MV_CESA) +=3D mv_cesa.o
> obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) +=3D mxs-dcp.o
>@@ -25,3 +26,4 @@ obj-$(CONFIG_CRYPTO_DEV_TALITOS) +=3D talitos.o
> obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
> obj-$(CONFIG_CRYPTO_DEV_QAT) +=3D qat/
> obj-$(CONFIG_CRYPTO_DEV_QCE) +=3D qce/
>+obj-$(CONFIG_CRYPTO_DEV_VMX) +=3D vmx/
>diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
>new file mode 100644
>index 0000000..94a3a6f
>--- /dev/null
>+++ b/drivers/crypto/img-hash.c
>@@ -0,0 +1,1037 @@
>+/*
>+ * Copyright (c) 2014 Imagination Technologies
>+ * Authors:  Will Thomas, James Hartley
>+ *
>+ * This program is free software; you can redistribute it and/or
>modify + * it under the terms of the GNU General Public License
>version 2 as published + * by the Free Software Foundation.
>+ *
>+ *	Interface structure taken from omap-sham driver
>+ */
>+
>+#include <linux/clk.h>
>+#include <linux/dmaengine.h>
>+#include <linux/interrupt.h>
>+#include <linux/io.h>
>+#include <linux/kernel.h>
>+#include <linux/module.h>
>+#include <linux/of_device.h>
>+#include <linux/platform_device.h>
>+#include <linux/scatterlist.h>
>+
>+#include <crypto/internal/hash.h>
>+#include <crypto/md5.h>
>+#include <crypto/sha.h>
>+
>+#define CR_RESET			0
>+#define CR_RESET_SET			1
>+#define CR_RESET_UNSET			0
>+
>+#define CR_MESSAGE_LENGTH_H		0x4
>+#define CR_MESSAGE_LENGTH_L		0x8
>+
>+#define CR_CONTROL			0xc
>+#define CR_CONTROL_BYTE_ORDER_3210	0
>+#define CR_CONTROL_BYTE_ORDER_0123	1
>+#define CR_CONTROL_BYTE_ORDER_2310	2
>+#define CR_CONTROL_BYTE_ORDER_1032	3
>+#define CR_CONTROL_BYTE_ORDER_SHIFT	8
>+#define CR_CONTROL_ALGO_MD5	0
>+#define CR_CONTROL_ALGO_SHA1	1
>+#define CR_CONTROL_ALGO_SHA224	2
>+#define CR_CONTROL_ALGO_SHA256	3
>+
>+#define CR_INTSTAT			0x10
>+#define CR_INTENAB			0x14
>+#define CR_INTCLEAR			0x18
>+#define CR_INT_RESULTS_AVAILABLE	BIT(0)
>+#define CR_INT_NEW_RESULTS_SET		BIT(1)
>+#define CR_INT_RESULT_READ_ERR		BIT(2)
>+#define CR_INT_MESSAGE_WRITE_ERROR	BIT(3)
>+#define CR_INT_STATUS			BIT(8)
>+
>+#define CR_RESULT_QUEUE		0x1c
>+#define CR_RSD0				0x40
>+#define CR_CORE_REV			0x50
>+#define CR_CORE_DES1		0x60
>+#define CR_CORE_DES2		0x70
>+
>+#define DRIVER_FLAGS_BUSY		BIT(0)
>+#define DRIVER_FLAGS_FINAL		BIT(1)
>+#define DRIVER_FLAGS_DMA_ACTIVE		BIT(2)
>+#define DRIVER_FLAGS_OUTPUT_READY	BIT(3)
>+#define DRIVER_FLAGS_INIT		BIT(4)
>+#define DRIVER_FLAGS_CPU		BIT(5)
>+#define DRIVER_FLAGS_DMA_READY		BIT(6)
>+#define DRIVER_FLAGS_ERROR		BIT(7)
>+#define DRIVER_FLAGS_SG			BIT(8)
>+#define DRIVER_FLAGS_SHA1		BIT(18)
>+#define DRIVER_FLAGS_SHA224		BIT(19)
>+#define DRIVER_FLAGS_SHA256		BIT(20)
>+#define DRIVER_FLAGS_MD5		BIT(21)
>+
>+#define IMG_HASH_QUEUE_LENGTH		20
>+#define IMG_HASH_DMA_THRESHOLD		64
>+
>+#ifdef __LITTLE_ENDIAN
>+#define IMG_HASH_BYTE_ORDER		(CR_CONTROL_BYTE_ORDER_3210)
>+#else
>+#define IMG_HASH_BYTE_ORDER		(CR_CONTROL_BYTE_ORDER_0123)
>+#endif
>+
>+struct img_hash_dev;
>+
>+struct img_hash_request_ctx {
>+	struct img_hash_dev	*hdev;
>+	u8 digest[SHA256_DIGEST_SIZE] __aligned(sizeof(u32));
>+	unsigned long		flags;
>+	size_t			digsize;
>+
>+	dma_addr_t		dma_addr;
>+	size_t			dma_ct;
>+
>+	/* sg root */
>+	struct scatterlist	*sgfirst;
>+	/* walk state */
>+	struct scatterlist	*sg;
>+	size_t			nents;
>+	size_t			offset;
>+	unsigned int		total;
>+	size_t			sent;
>+
>+	unsigned long		op;
>+
>+	size_t			bufcnt;
>+	u8 buffer[0] __aligned(sizeof(u32));
>+	struct ahash_request	fallback_req;
>+};
>+
>+struct img_hash_ctx {
>+	struct img_hash_dev	*hdev;
>+	unsigned long		flags;
>+	struct crypto_ahash	*fallback;
>+};
>+
>+struct img_hash_dev {
>+	struct list_head	list;
>+	struct device		*dev;
>+	struct clk		*iclk;
>+	struct clk		*fclk;
>+	int			irq;
>+	void __iomem		*io_base;
>+
>+	phys_addr_t		bus_addr;
>+	void __iomem		*cpu_addr;
>+
>+	spinlock_t		lock;
>+	int			err;
>+	struct tasklet_struct	done_task;
>+	struct tasklet_struct	dma_task;
>+
>+	unsigned long		flags;
>+	struct crypto_queue	queue;
>+	struct ahash_request	*req;
>+
>+	struct dma_chan		*dma_lch;
>+};
>+
>+struct img_hash_drv {
>+	struct list_head dev_list;
>+	spinlock_t lock;
>+};
>+
>+static struct img_hash_drv img_hash =3D {
>+	.dev_list =3D LIST_HEAD_INIT(img_hash.dev_list),
>+	.lock =3D __SPIN_LOCK_UNLOCKED(img_hash.lock),
>+};
>+
>+static inline u32 img_hash_read(struct img_hash_dev *hdev, u32 offset=
)
>+{
>+	return readl_relaxed(hdev->io_base + offset);
>+}
>+
>+static inline void img_hash_write(struct img_hash_dev *hdev,
>+				  u32 offset, u32 value)
>+{
>+	writel_relaxed(value, hdev->io_base + offset);
>+}
>+
>+static inline u32 img_hash_read_result_queue(struct img_hash_dev
>*hdev) +{
>+	return be32_to_cpu(img_hash_read(hdev, CR_RESULT_QUEUE));
>+}
>+
>+static void img_hash_start(struct img_hash_dev *hdev, bool dma)
>+{
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(hdev->req);
>+	u32 cr =3D IMG_HASH_BYTE_ORDER << CR_CONTROL_BYTE_ORDER_SHIFT;
>+
>+	if (ctx->flags & DRIVER_FLAGS_MD5)
>+		cr |=3D CR_CONTROL_ALGO_MD5;
>+	else if (ctx->flags & DRIVER_FLAGS_SHA1)
>+		cr |=3D CR_CONTROL_ALGO_SHA1;
>+	else if (ctx->flags & DRIVER_FLAGS_SHA224)
>+		cr |=3D CR_CONTROL_ALGO_SHA224;
>+	else if (ctx->flags & DRIVER_FLAGS_SHA256)
>+		cr |=3D CR_CONTROL_ALGO_SHA256;
>+	dev_dbg(hdev->dev, "Starting hash process\n");
>+	img_hash_write(hdev, CR_CONTROL, cr);
>+
>+	/*
>+	 * The hardware block requires two cycles between writing the=20
control
>+	 * register and writing the first word of data in non DMA mode,=20
to
>+	 * ensure the first data write is not grouped in burst with the
>control +	 * register write a read is issued to 'flush' the bus.
>+	 */
>+	if (!dma)
>+		img_hash_read(hdev, CR_CONTROL);
>+}
>+
>+static int img_hash_xmit_cpu(struct img_hash_dev *hdev, const u8 *buf=
,
>+			     size_t length, int final)
>+{
>+	u32 count, len32;
>+	const u32 *buffer =3D (const u32 *)buf;
>+
>+	dev_dbg(hdev->dev, "xmit_cpu:  length: %u bytes\n", length);
>+
>+	if (final)
>+		hdev->flags |=3D DRIVER_FLAGS_FINAL;
>+
>+	len32 =3D DIV_ROUND_UP(length, sizeof(u32));
>+
>+	for (count =3D 0; count < len32; count++)
>+		writel_relaxed(buffer[count], hdev->cpu_addr);
>+
>+	return -EINPROGRESS;
>+}
>+
>+static void img_hash_dma_callback(void *data)
>+{
>+	struct img_hash_dev *hdev =3D (struct img_hash_dev *)data;
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(hdev->req);
>+
>+	if (ctx->bufcnt) {
>+		img_hash_xmit_cpu(hdev, ctx->buffer, ctx->bufcnt, 0);
>+		ctx->bufcnt =3D 0;
>+	}
>+	if (ctx->sg)
>+		tasklet_schedule(&hdev->dma_task);
>+}
>+
>+static int img_hash_xmit_dma(struct img_hash_dev *hdev, struct
>scatterlist *sg) +{
>+	struct dma_async_tx_descriptor *desc;
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(hdev->req);
>+
>+	ctx->dma_ct =3D dma_map_sg(hdev->dev, sg, 1, DMA_MEM_TO_DEV);
>+	if (ctx->dma_ct =3D=3D 0) {
>+		dev_err(hdev->dev, "Invalid DMA sg\n");
>+		hdev->err =3D -EINVAL;
>+		return -EINVAL;
>+	}
>+
>+	desc =3D dmaengine_prep_slave_sg(hdev->dma_lch,
>+					sg,
>+					ctx->dma_ct,
>+					DMA_MEM_TO_DEV,
>+					DMA_PREP_INTERRUPT |=20
DMA_CTRL_ACK);
>+	if (!desc) {
>+		dev_err(hdev->dev, "Null DMA descriptor\n");
>+		hdev->err =3D -EINVAL;
>+		dma_unmap_sg(hdev->dev, sg, 1, DMA_MEM_TO_DEV);
>+		return -EINVAL;
>+	}
>+	desc->callback =3D img_hash_dma_callback;
>+	desc->callback_param =3D hdev;
>+	dmaengine_submit(desc);
>+	dma_async_issue_pending(hdev->dma_lch);
>+
>+	return 0;
>+}
>+
>+static int img_hash_write_via_cpu(struct img_hash_dev *hdev)
>+{
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(hdev->req);
>+	int ret =3D 0;
>+
>+	ctx->bufcnt =3D sg_copy_to_buffer(hdev->req->src, sg_nents(ctx-
>sg),
>+					ctx->buffer, hdev->req->nbytes);
>+
>+	ctx->total =3D hdev->req->nbytes;
>+	ctx->bufcnt =3D 0;
>+
>+	hdev->flags |=3D (DRIVER_FLAGS_CPU | DRIVER_FLAGS_FINAL);
>+
>+	img_hash_start(hdev, false);
>+
>+	if (ctx->total)
>+		ret =3D img_hash_xmit_cpu(hdev, ctx->buffer, ctx->total,=20
1);
>+	else
>+		ret =3D 0;
>+
>+	return ret;
>+}
>+
>+static int img_hash_finish(struct ahash_request *req)
>+{
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(req);
>+
>+	if (!req->result)
>+		return -EINVAL;
>+
>+	memcpy(req->result, ctx->digest, ctx->digsize);
>+
>+	return 0;
>+}
>+
>+static void img_hash_copy_hash(struct ahash_request *req)
>+{
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(req);
>+	u32 *hash =3D (u32 *)ctx->digest;
>+	int i;
>+
>+	for (i =3D (ctx->digsize / sizeof(u32)) - 1; i >=3D 0; i--)
>+		hash[i] =3D img_hash_read_result_queue(ctx->hdev);
>+}
>+
>+static void img_hash_finish_req(struct ahash_request *req, int err)
>+{
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(req);
>+	struct img_hash_dev *hdev =3D  ctx->hdev;
>+
>+	if (!err) {
>+		img_hash_copy_hash(req);
>+		if (DRIVER_FLAGS_FINAL & hdev->flags)
>+			err =3D img_hash_finish(req);
>+	} else {
>+		dev_warn(hdev->dev, "Hash failed with error %d\n", err);
>+		ctx->flags |=3D DRIVER_FLAGS_ERROR;
>+	}
>+
>+	hdev->flags &=3D ~(DRIVER_FLAGS_DMA_READY |=20
DRIVER_FLAGS_OUTPUT_READY |
>+		DRIVER_FLAGS_CPU | DRIVER_FLAGS_BUSY |=20
DRIVER_FLAGS_FINAL); +
>+	if (req->base.complete)
>+		req->base.complete(&req->base, err);
>+}
>+
>+static int img_hash_write_via_dma(struct img_hash_dev *hdev)
>+{
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(hdev->req);
>+
>+	img_hash_start(hdev, true);
>+
>+	dev_dbg(hdev->dev, "xmit dma size: %d\n", ctx->total);
>+
>+	if (!ctx->total)
>+		hdev->flags |=3D DRIVER_FLAGS_FINAL;
>+
>+	hdev->flags |=3D DRIVER_FLAGS_DMA_ACTIVE | DRIVER_FLAGS_FINAL;
>+
>+	tasklet_schedule(&hdev->dma_task);
>+
>+	return -EINPROGRESS;
>+}
>+
>+static int img_hash_dma_init(struct img_hash_dev *hdev)
>+{
>+	struct dma_slave_config dma_conf;
>+	int err =3D -EINVAL;
>+
>+	hdev->dma_lch =3D dma_request_slave_channel(hdev->dev, "tx");
>+	if (!hdev->dma_lch) {
>+		dev_err(hdev->dev, "Couldn't aquire a slave DMA channel.
\n");
>+		return -EBUSY;
>+	}
>+	dma_conf.direction =3D DMA_MEM_TO_DEV;
>+	dma_conf.dst_addr =3D hdev->bus_addr;
>+	dma_conf.dst_addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
>+	dma_conf.dst_maxburst =3D 16;
>+	dma_conf.device_fc =3D false;
>+
>+	err =3D dmaengine_slave_config(hdev->dma_lch,  &dma_conf);
>+
>+	if (err) {
>+		dev_err(hdev->dev, "Couldn't configure DMA slave.\n");
>+		dma_release_channel(hdev->dma_lch);
>+		return err;
>+	}
>+	return 0;
>+}
>+
>+static void img_hash_dma_task(unsigned long d)
>+{
>+	struct img_hash_dev *hdev =3D (struct img_hash_dev *)d;
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(hdev->req);
>+	u8 *addr;
>+	size_t nbytes, bleft, wsend, len, tbc;
>+	struct scatterlist tsg;
>+
>+	if (!ctx->sg)
>+		return;
>+
>+	addr =3D sg_virt(ctx->sg);
>+	nbytes =3D ctx->sg->length - ctx->offset;
>+
>+	/* The hash accelerator does not support a data valid mask. This
>means +	 * that if each dma (i.e. per page) is not a multiple of=20
4
>bytes, the +	 * padding bytes in the last word written by that dma
>would erroneously +	 * be included in the hash. To avoid this we=20
round
>down the transfer, +	 * and add the excess to the start of the next
>dma. It does not matter +	 * that the final dma may not be a=20
multiple
>of 4 bytes as the hashing +	 * block is programmed to accept the
>correct number of bytes. +	 */
>+
>+	bleft =3D nbytes % 4;
>+	wsend =3D (nbytes / 4);
>+
>+	if (wsend) {
>+		sg_init_one(&tsg, addr + ctx->offset, wsend * 4);
>+		if (img_hash_xmit_dma(hdev, &tsg)) {
>+			dev_err(hdev->dev, "DMA failed, falling back to=20
CPU");
>+			ctx->flags |=3D DRIVER_FLAGS_CPU;
>+			hdev->err =3D 0;
>+			img_hash_xmit_cpu(hdev, addr + ctx->offset,
>+					  wsend * 4, 0);
>+			ctx->sent +=3D wsend * 4;
>+			wsend =3D 0;
>+		} else {
>+			ctx->sent +=3D wsend * 4;
>+		}
>+	}
>+
>+	if (bleft) {
>+		ctx->bufcnt =3D sg_pcopy_to_buffer(ctx->sgfirst, ctx-
>nents,
>+						 ctx->buffer, bleft,=20
ctx->sent);
>+		tbc =3D 0;
>+		ctx->sg =3D sg_next(ctx->sg);
>+		while (ctx->sg && (ctx->bufcnt < 4)) {
>+			len =3D ctx->sg->length;
>+			if (likely(len > (4 - ctx->bufcnt)))
>+				len =3D 4 - ctx->bufcnt;
>+			tbc =3D sg_pcopy_to_buffer(ctx->sgfirst, ctx-
>nents,
>+						 ctx->buffer + ctx-
>bufcnt, len,
>+					ctx->sent + ctx->bufcnt);
>+			ctx->bufcnt +=3D tbc;
>+			if (tbc >=3D ctx->sg->length) {
>+				ctx->sg =3D sg_next(ctx->sg);
>+				tbc =3D 0;
>+			}
>+		}
>+
>+		ctx->sent +=3D ctx->bufcnt;
>+		ctx->offset =3D tbc;
>+
>+		if (!wsend)
>+			img_hash_dma_callback(hdev);
>+	} else {
>+		ctx->offset =3D 0;
>+		ctx->sg =3D sg_next(ctx->sg);
>+	}
>+}
>+
>+static int img_hash_write_via_dma_stop(struct img_hash_dev *hdev)
>+{
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(hdev->req);
>+
>+	if (ctx->flags & DRIVER_FLAGS_SG)
>+		dma_unmap_sg(hdev->dev, ctx->sg, ctx->dma_ct,=20
DMA_TO_DEVICE);
>+
>+	return 0;
>+}
>+
>+static int img_hash_process_data(struct img_hash_dev *hdev)
>+{
>+	struct ahash_request *req =3D hdev->req;
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(req);
>+	int err =3D 0;
>+
>+	ctx->bufcnt =3D 0;
>+
>+	if (req->nbytes >=3D IMG_HASH_DMA_THRESHOLD) {
>+		dev_dbg(hdev->dev, "process data request(%d bytes) using=20
DMA\n",
>+			req->nbytes);
>+		err =3D img_hash_write_via_dma(hdev);
>+	} else {
>+		dev_dbg(hdev->dev, "process data request(%d bytes) using=20
CPU\n",
>+			req->nbytes);
>+		err =3D img_hash_write_via_cpu(hdev);
>+	}
>+	return err;
>+}
>+
>+static int img_hash_hw_init(struct img_hash_dev *hdev)
>+{
>+	unsigned long long nbits;
>+	u32 u, l;
>+	int ret;
>+
>+	ret =3D clk_prepare_enable(hdev->iclk);
>+	if (ret)
>+		return ret;
>+
>+	img_hash_write(hdev, CR_RESET, CR_RESET_SET);
>+	img_hash_write(hdev, CR_RESET, CR_RESET_UNSET);
>+	img_hash_write(hdev, CR_INTENAB, CR_INT_NEW_RESULTS_SET);
>+
>+	nbits =3D (hdev->req->nbytes << 3);
>+	u =3D nbits >> 32;
>+	l =3D nbits;
>+	img_hash_write(hdev, CR_MESSAGE_LENGTH_H, u);
>+	img_hash_write(hdev, CR_MESSAGE_LENGTH_L, l);
>+
>+	if (!(DRIVER_FLAGS_INIT & hdev->flags)) {
>+		hdev->flags |=3D DRIVER_FLAGS_INIT;
>+		hdev->err =3D 0;
>+	}
>+	dev_dbg(hdev->dev, "hw initialized, nbits: %llx\n", nbits);
>+	return 0;
>+}
>+
>+static int img_hash_init(struct ahash_request *req)
>+{
>+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>+	struct img_hash_request_ctx *rctx =3D ahash_request_ctx(req);
>+	struct img_hash_ctx *ctx =3D crypto_ahash_ctx(tfm);
>+
>+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
>+	rctx->fallback_req.base.flags =3D	req->base.flags
>+		& CRYPTO_TFM_REQ_MAY_SLEEP;
>+
>+	return crypto_ahash_init(&rctx->fallback_req);
>+}
>+
>+static int img_hash_handle_queue(struct img_hash_dev *hdev,
>+				 struct ahash_request *req)
>+{
>+	struct crypto_async_request *async_req, *backlog;
>+	struct img_hash_request_ctx *ctx;
>+	unsigned long flags;
>+	int err =3D 0, res =3D 0;
>+
>+	spin_lock_irqsave(&hdev->lock, flags);
>+
>+	if (req)
>+		res =3D ahash_enqueue_request(&hdev->queue, req);
>+
>+	if (DRIVER_FLAGS_BUSY & hdev->flags) {
>+		spin_unlock_irqrestore(&hdev->lock, flags);
>+		return res;
>+	}
>+
>+	backlog =3D crypto_get_backlog(&hdev->queue);
>+	async_req =3D crypto_dequeue_request(&hdev->queue);
>+	if (async_req)
>+		hdev->flags |=3D DRIVER_FLAGS_BUSY;
>+
>+	spin_unlock_irqrestore(&hdev->lock, flags);
>+
>+	if (!async_req)
>+		return res;
>+
>+	if (backlog)
>+		backlog->complete(backlog, -EINPROGRESS);
>+
>+	req =3D ahash_request_cast(async_req);
>+	hdev->req =3D req;
>+
>+	ctx =3D ahash_request_ctx(req);
>+
>+	dev_info(hdev->dev, "processing req, op: %lu, bytes: %d\n",
>+		 ctx->op, req->nbytes);
>+
>+	err =3D img_hash_hw_init(hdev);
>+
>+	if (!err)
>+		err =3D img_hash_process_data(hdev);
>+
>+	if (err !=3D -EINPROGRESS) {
>+		/* done_task will not finish so do it here */
>+		img_hash_finish_req(req, err);
>+	}
>+	return res;
>+}
>+
>+static int img_hash_update(struct ahash_request *req)
>+{
>+	struct img_hash_request_ctx *rctx =3D ahash_request_ctx(req);
>+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>+	struct img_hash_ctx *ctx =3D crypto_ahash_ctx(tfm);
>+
>+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
>+	rctx->fallback_req.base.flags =3D req->base.flags
>+		& CRYPTO_TFM_REQ_MAY_SLEEP;
>+	rctx->fallback_req.nbytes =3D req->nbytes;
>+	rctx->fallback_req.src =3D req->src;
>+
>+	return crypto_ahash_update(&rctx->fallback_req);
>+}
>+
>+static int img_hash_final(struct ahash_request *req)
>+{
>+	struct img_hash_request_ctx *rctx =3D ahash_request_ctx(req);
>+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>+	struct img_hash_ctx *ctx =3D crypto_ahash_ctx(tfm);
>+
>+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
>+	rctx->fallback_req.base.flags =3D req->base.flags
>+		& CRYPTO_TFM_REQ_MAY_SLEEP;
>+	rctx->fallback_req.result =3D req->result;
>+
>+	return crypto_ahash_final(&rctx->fallback_req);
>+}
>+
>+static int img_hash_finup(struct ahash_request *req)
>+{
>+	struct img_hash_request_ctx *rctx =3D ahash_request_ctx(req);
>+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>+	struct img_hash_ctx *ctx =3D crypto_ahash_ctx(tfm);
>+
>+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
>+	rctx->fallback_req.base.flags =3D req->base.flags
>+		& CRYPTO_TFM_REQ_MAY_SLEEP;
>+	rctx->fallback_req.nbytes =3D req->nbytes;
>+	rctx->fallback_req.src =3D req->src;
>+	rctx->fallback_req.result =3D req->result;
>+
>+	return crypto_ahash_finup(&rctx->fallback_req);
>+}
>+
>+static int img_hash_digest(struct ahash_request *req)
>+{
>+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>+	struct img_hash_ctx *tctx =3D crypto_ahash_ctx(tfm);
>+	struct img_hash_request_ctx *ctx =3D ahash_request_ctx(req);
>+	struct img_hash_dev *hdev =3D NULL;
>+	struct img_hash_dev *tmp;
>+	int err;
>+
>+	spin_lock_bh(&img_hash.lock);
>+	if (!tctx->hdev) {
>+		list_for_each_entry(tmp, &img_hash.dev_list, list) {
>+			hdev =3D tmp;
>+			break;
>+		}
>+		tctx->hdev =3D hdev;
>+
>+	} else {
>+		hdev =3D tctx->hdev;
>+	}
>+
>+	spin_unlock_bh(&img_hash.lock);
>+	ctx->hdev =3D hdev;
>+	ctx->flags =3D 0;
>+	ctx->digsize =3D crypto_ahash_digestsize(tfm);
>+
>+	switch (ctx->digsize) {
>+	case SHA1_DIGEST_SIZE:
>+		ctx->flags |=3D DRIVER_FLAGS_SHA1;
>+		break;
>+	case SHA256_DIGEST_SIZE:
>+		ctx->flags |=3D DRIVER_FLAGS_SHA256;
>+		break;
>+	case SHA224_DIGEST_SIZE:
>+		ctx->flags |=3D DRIVER_FLAGS_SHA224;
>+		break;
>+	case MD5_DIGEST_SIZE:
>+		ctx->flags |=3D DRIVER_FLAGS_MD5;
>+		break;
>+	default:
>+		return -EINVAL;
>+	}
>+
>+	ctx->bufcnt =3D 0;
>+	ctx->offset =3D 0;
>+	ctx->sent =3D 0;
>+	ctx->total =3D req->nbytes;
>+	ctx->sg =3D req->src;
>+	ctx->sgfirst =3D req->src;
>+	ctx->nents =3D sg_nents(ctx->sg);
>+
>+	err =3D img_hash_handle_queue(tctx->hdev, req);
>+
>+	return err;
>+}
>+
>+static int img_hash_cra_init(struct crypto_tfm *tfm)
>+{
>+	struct img_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
>+	const char *alg_name =3D crypto_tfm_alg_name(tfm);
>+	int err =3D -ENOMEM;
>+
>+	ctx->fallback =3D crypto_alloc_ahash(alg_name, 0,
>+					   CRYPTO_ALG_NEED_FALLBACK);
>+	if (IS_ERR(ctx->fallback)) {
>+		pr_err("img_hash: Could not load fallback driver.\n");
>+		err =3D PTR_ERR(ctx->fallback);
>+		goto err;
>+	}
>+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
>+				 sizeof(struct img_hash_request_ctx) +
>+				 IMG_HASH_DMA_THRESHOLD);
>+
>+	return 0;
>+
>+err:
>+	return err;
>+}
>+
>+static void img_hash_cra_exit(struct crypto_tfm *tfm)
>+{
>+	struct img_hash_ctx *tctx =3D crypto_tfm_ctx(tfm);
>+
>+	crypto_free_ahash(tctx->fallback);
>+}
>+
>+static irqreturn_t img_irq_handler(int irq, void *dev_id)
>+{
>+	struct img_hash_dev *hdev =3D dev_id;
>+	u32 reg;
>+
>+	reg =3D img_hash_read(hdev, CR_INTSTAT);
>+	img_hash_write(hdev, CR_INTCLEAR, reg);
>+
>+	if (reg & CR_INT_NEW_RESULTS_SET) {
>+		dev_dbg(hdev->dev, "IRQ CR_INT_NEW_RESULTS_SET\n");
>+		if (DRIVER_FLAGS_BUSY & hdev->flags) {
>+			hdev->flags |=3D DRIVER_FLAGS_OUTPUT_READY;
>+			if (!(DRIVER_FLAGS_CPU & hdev->flags))
>+				hdev->flags |=3D DRIVER_FLAGS_DMA_READY;
>+			tasklet_schedule(&hdev->done_task);
>+		} else {
>+			dev_warn(hdev->dev,
>+				 "HASH interrupt when no active=20
requests.\n");
>+		}
>+	} else if (reg & CR_INT_RESULTS_AVAILABLE) {
>+		dev_warn(hdev->dev,
>+			 "IRQ triggered before the hash had=20
completed\n");
>+	} else if (reg & CR_INT_RESULT_READ_ERR) {
>+		dev_warn(hdev->dev,
>+			 "Attempt to read from an empty result=20
queue\n");
>+	} else if (reg & CR_INT_MESSAGE_WRITE_ERROR) {
>+		dev_warn(hdev->dev,
>+			 "Data written before the hardware was=20
configured\n");
>+	}
>+	return IRQ_HANDLED;
>+}
>+
>+static struct ahash_alg img_algs[] =3D {
>+	{
>+		.init =3D img_hash_init,
>+		.update =3D img_hash_update,
>+		.final =3D img_hash_final,
>+		.finup =3D img_hash_finup,
>+		.digest =3D img_hash_digest,
>+		.halg =3D {
>+			.digestsize =3D MD5_DIGEST_SIZE,
>+			.base =3D {
>+				.cra_name =3D "md5",
>+				.cra_driver_name =3D "img-md5",
>+				.cra_priority =3D 301,

Just curious: why do you use such odd priorities of 301 or 3000? IMHO,=20
all you need is a priority of more than 100 to "beat" the generic C=20
prios. Maybe you also need to beat the standard assembler=20
implementations which are routinely at 200 for hashes. So, a prio of 30=
0=20
should suffice, should it not?
>+				.cra_flags =3D
>+				CRYPTO_ALG_ASYNC |
>+				CRYPTO_ALG_NEED_FALLBACK,
>+				.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
>+				.cra_ctxsize =3D sizeof(struct=20
img_hash_ctx),
>+				.cra_init =3D img_hash_cra_init,
>+				.cra_exit =3D img_hash_cra_exit,
>+				.cra_module =3D THIS_MODULE,
>+			}
>+		}
>+	},
>+	{
>+		.init =3D img_hash_init,
>+		.update =3D img_hash_update,
>+		.final =3D img_hash_final,
>+		.finup =3D img_hash_finup,
>+		.digest =3D img_hash_digest,
>+		.halg =3D {
>+			.digestsize =3D SHA1_DIGEST_SIZE,
>+			.base =3D {
>+				.cra_name =3D "sha1",
>+				.cra_driver_name =3D "img-sha1",
>+				.cra_priority =3D 3000,
>+				.cra_flags =3D
>+				CRYPTO_ALG_ASYNC |
>+				CRYPTO_ALG_NEED_FALLBACK,
>+				.cra_blocksize =3D SHA1_BLOCK_SIZE,
>+				.cra_ctxsize =3D sizeof(struct=20
img_hash_ctx),
>+				.cra_init =3D img_hash_cra_init,
>+				.cra_exit =3D img_hash_cra_exit,
>+				.cra_module =3D THIS_MODULE,
>+			}
>+		}
>+	},
>+	{
>+		.init =3D img_hash_init,
>+		.update =3D img_hash_update,
>+		.final =3D img_hash_final,
>+		.finup =3D img_hash_finup,
>+		.digest =3D img_hash_digest,
>+		.halg =3D {
>+			.digestsize =3D SHA224_DIGEST_SIZE,
>+			.base =3D {
>+				.cra_name =3D "sha224",
>+				.cra_driver_name =3D "img-sha224",
>+				.cra_priority =3D 3000,
>+				.cra_flags =3D
>+				CRYPTO_ALG_ASYNC |
>+				CRYPTO_ALG_NEED_FALLBACK,
>+				.cra_blocksize =3D SHA224_BLOCK_SIZE,
>+				.cra_ctxsize =3D sizeof(struct=20
img_hash_ctx),
>+				.cra_init =3D img_hash_cra_init,
>+				.cra_exit =3D img_hash_cra_exit,
>+				.cra_module =3D THIS_MODULE,
>+			}
>+		}
>+	},
>+	{
>+		.init =3D img_hash_init,
>+		.update =3D img_hash_update,
>+		.final =3D img_hash_final,
>+		.finup =3D img_hash_finup,
>+		.digest =3D img_hash_digest,
>+		.halg =3D {
>+			.digestsize =3D SHA256_DIGEST_SIZE,
>+			.base =3D {
>+				.cra_name =3D "sha256",
>+				.cra_driver_name =3D "img-sha256",
>+				.cra_priority =3D 301,
>+				.cra_flags =3D
>+				CRYPTO_ALG_ASYNC |
>+				CRYPTO_ALG_NEED_FALLBACK,
>+				.cra_blocksize =3D SHA256_BLOCK_SIZE,
>+				.cra_ctxsize =3D sizeof(struct=20
img_hash_ctx),
>+				.cra_init =3D img_hash_cra_init,
>+				.cra_exit =3D img_hash_cra_exit,
>+				.cra_module =3D THIS_MODULE,
>+			}
>+		}
>+	}
>+};
>+
>+static int img_register_algs(struct img_hash_dev *hdev)
>+{
>+	int i, err;
>+
>+	for (i =3D 0; i < ARRAY_SIZE(img_algs); i++) {
>+		err =3D crypto_register_ahash(&img_algs[i]);
>+		if (err)
>+			goto err_reg;
>+	}
>+	return 0;
>+
>+err_reg:
>+	for (; i--; )
>+		crypto_unregister_ahash(&img_algs[i]);
>+
>+	return err;
>+}
>+
>+static int img_unregister_algs(struct img_hash_dev *hdev)
>+{
>+	int i;
>+
>+	for (i =3D 0; i < ARRAY_SIZE(img_algs); i++)
>+		crypto_unregister_ahash(&img_algs[i]);
>+	return 0;
>+}
>+
>+static void img_hash_done_task(unsigned long data)
>+{
>+	struct img_hash_dev *hdev =3D (struct img_hash_dev *)data;
>+	int err =3D 0;
>+
>+	if (hdev->err =3D=3D -EINVAL) {
>+		err =3D hdev->err;
>+		goto finish;
>+	}
>+
>+	if (!(DRIVER_FLAGS_BUSY & hdev->flags)) {
>+		img_hash_handle_queue(hdev, NULL);
>+		return;
>+	}
>+
>+	if (DRIVER_FLAGS_CPU & hdev->flags) {
>+		if (DRIVER_FLAGS_OUTPUT_READY & hdev->flags) {
>+			hdev->flags &=3D ~DRIVER_FLAGS_OUTPUT_READY;
>+			goto finish;
>+		}
>+	} else if (DRIVER_FLAGS_DMA_READY & hdev->flags) {
>+		if (DRIVER_FLAGS_DMA_ACTIVE & hdev->flags) {
>+			hdev->flags &=3D ~DRIVER_FLAGS_DMA_ACTIVE;
>+			img_hash_write_via_dma_stop(hdev);
>+			if (hdev->err) {
>+				err =3D hdev->err;
>+				goto finish;
>+			}
>+		}
>+		if (DRIVER_FLAGS_OUTPUT_READY & hdev->flags) {
>+			hdev->flags &=3D ~(DRIVER_FLAGS_DMA_READY |
>+					DRIVER_FLAGS_OUTPUT_READY);
>+			goto finish;
>+		}
>+	}
>+	return;
>+
>+finish:
>+	img_hash_finish_req(hdev->req, err);
>+}
>+
>+static const struct of_device_id img_hash_match[] =3D {
>+	{ .compatible =3D "img,hash-accelerator" },
>+	{}
>+};
>+MODULE_DEVICE_TABLE(of, img_hash_match)
>+
>+static int img_hash_probe(struct platform_device *pdev)
>+{
>+	struct img_hash_dev *hdev;
>+	struct device *dev =3D &pdev->dev;
>+	struct resource *hash_res;
>+	int err;
>+
>+	hdev =3D devm_kzalloc(dev, sizeof(*hdev), GFP_KERNEL);
>+	if (hdev =3D=3D NULL) {
>+		err =3D -ENOMEM;
>+		goto sha_dev_err;
>+	}
>+	spin_lock_init(&hdev->lock);
>+
>+	hdev->dev =3D dev;
>+
>+	platform_set_drvdata(pdev, hdev);
>+
>+	INIT_LIST_HEAD(&hdev->list);
>+
>+	tasklet_init(&hdev->done_task, img_hash_done_task, (unsigned
>long)hdev); +	tasklet_init(&hdev->dma_task, img_hash_dma_task,
>(unsigned long)hdev); +
>+	crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
>+
>+	/* Register bank */
>+	hash_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>+
>+	hdev->io_base =3D devm_ioremap_resource(dev, hash_res);
>+	if (IS_ERR(hdev->io_base)) {
>+		dev_err(dev, "can't ioremap\n");
>+		err =3D PTR_ERR(hdev->io_base);
>+		goto hash_io_err;
>+	}
>+
>+	/* Write port (DMA or CPU) */
>+	hash_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
>+	if (!hash_res) {
>+		dev_err(dev, "no write port resource info\n");
>+		err =3D -ENODEV;
>+		goto res_err;
>+	}
>+	hdev->bus_addr =3D hash_res->start;
>+	hdev->cpu_addr =3D devm_ioremap_resource(dev, hash_res);
>+	if (IS_ERR(hdev->cpu_addr)) {
>+		dev_err(dev, "can't ioremap write port\n");
>+		err =3D PTR_ERR(hdev->cpu_addr);
>+		goto res_err;
>+	}
>+
>+	hdev->irq =3D platform_get_irq(pdev, 0);
>+	if (hdev->irq < 0) {
>+		dev_err(dev, "no IRQ resource info\n");
>+		err =3D hdev->irq;
>+		goto res_err;
>+	}
>+
>+	err =3D devm_request_irq(dev, hdev->irq, img_irq_handler, 0,
>+			       dev_name(dev), hdev);
>+	if (err) {
>+		dev_err(dev, "unable to request %s irq\n",=20
dev_name(dev));
>+		goto res_err;
>+	}
>+	dev_dbg(dev, "using IRQ channel %d\n", hdev->irq);
>+
>+	hdev->iclk =3D devm_clk_get(&pdev->dev, "hash_clk");
>+	if (IS_ERR(hdev->iclk)) {
>+		dev_err(dev, "clock initialization failed.\n");
>+		err =3D PTR_ERR(hdev->iclk);
>+		goto res_err;
>+	}
>+
>+	hdev->fclk =3D devm_clk_get(&pdev->dev, "hash_reg_clk");
>+	if (IS_ERR(hdev->fclk)) {
>+		dev_err(dev, "clock initialization failed.\n");
>+		err =3D PTR_ERR(hdev->fclk);
>+		goto res_err;
>+	}
>+
>+	err =3D img_hash_dma_init(hdev);
>+	if (err)
>+		goto err_dma;
>+
>+	dev_dbg(dev, "using %s for DMA transfers\n",
>+		dma_chan_name(hdev->dma_lch));
>+
>+	spin_lock(&img_hash.lock);
>+	list_add_tail(&hdev->list, &img_hash.dev_list);
>+	spin_unlock(&img_hash.lock);
>+
>+	err =3D img_register_algs(hdev);
>+	if (err)
>+		goto err_algs;
>+	dev_info(dev, "data bus: 0x%x;\tsize:0x%x\n", hdev->bus_addr,=20
0x4);
>+	dev_info(dev, "Img MD5/SHA1/SHA224/SHA256 Hardware accelerator
>initialized\n"); +
>+	return 0;
>+
>+err_algs:
>+	spin_lock(&img_hash.lock);
>+	list_del(&hdev->list);
>+	spin_unlock(&img_hash.lock);
>+	dma_release_channel(hdev->dma_lch);
>+err_dma:
>+hash_io_err:
>+	devm_clk_put(dev, hdev->iclk);
>+	devm_clk_put(dev, hdev->fclk);
>+res_err:
>+	tasklet_kill(&hdev->done_task);
>+	tasklet_kill(&hdev->dma_task);
>+sha_dev_err:
>+	dev_err(dev, "initialization failed.\n");
>+	return err;
>+}
>+
>+static int img_hash_remove(struct platform_device *pdev)
>+{
>+	static struct img_hash_dev *hdev;
>+
>+	hdev =3D platform_get_drvdata(pdev);
>+	spin_lock(&img_hash.lock);
>+	list_del(&hdev->list);
>+	spin_unlock(&img_hash.lock);
>+
>+	img_unregister_algs(hdev);
>+
>+	tasklet_kill(&hdev->done_task);
>+	tasklet_kill(&hdev->dma_task);
>+
>+	dma_release_channel(hdev->dma_lch);
>+
>+	clk_disable_unprepare(hdev->iclk);
>+	clk_disable_unprepare(hdev->fclk);
>+	return 0;
>+}
>+
>+static struct platform_driver img_hash_driver =3D {
>+	.probe		=3D img_hash_probe,
>+	.remove		=3D img_hash_remove,
>+	.driver		=3D {
>+		.name	=3D "img-hash-accelerator",
>+		.of_match_table	=3D of_match_ptr(img_hash_match),
>+	}
>+};
>+module_platform_driver(img_hash_driver);
>+
>+MODULE_LICENSE("GPL v2");
>+MODULE_DESCRIPTION("Imgtec SHA1/224/256 & MD5 hw accelerator driver")=
;
>+MODULE_AUTHOR("Will Thomas.");
>+MODULE_AUTHOR("James Hartley.");


Ciao
Stephan
