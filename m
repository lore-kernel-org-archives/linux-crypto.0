From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 2/5] crypto: add Atmel AES driver
Date: Sun,  1 Jul 2012 19:19:44 +0200
Message-ID: <1341163187-14946-3-git-send-email-eric@eukrea.com>
References: <1341163187-14946-1-git-send-email-eric@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, plagnioj@jcrosoft.com, nicolas@eukrea.com,
	eric@eukrea.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341163187-14946-1-git-send-email-eric@eukrea.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Nicolas Royer <nicolas@eukrea.com>

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric B=C3=A9nard <eric@eukrea.com>
Tested-by: Eric B=C3=A9nard <eric@eukrea.com>
---
 drivers/crypto/Kconfig          |   17 +
 drivers/crypto/Makefile         |    3 +-
 drivers/crypto/atmel-aes-regs.h |   62 ++
 drivers/crypto/atmel-aes.c      | 1206 +++++++++++++++++++++++++++++++=
++++++++
 4 files changed, 1287 insertions(+), 1 deletions(-)
 create mode 100644 drivers/crypto/atmel-aes-regs.h
 create mode 100644 drivers/crypto/atmel-aes.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1092a77..1be94e5 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -325,4 +325,21 @@ if CRYPTO_DEV_UX500
 	source "drivers/crypto/ux500/Kconfig"
 endif # if CRYPTO_DEV_UX500
=20
+config CRYPTO_DEV_ATMEL_AES
+	tristate "Support for Atmel AES hw accelerator"
+	depends on ARCH_AT91
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_AES
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	select CONFIG_AT_HDMAC
+	help
+	  Some Atmel processors have AES hw accelerator.
+	  Select this if you want to use the Atmel module for
+	  AES algorithms.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called atmel-aes.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 0139032..7d17b67 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -14,4 +14,5 @@ obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) +=3D omap-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) +=3D picoxcell_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_S5P) +=3D s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) +=3D tegra-aes.o
-obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
\ No newline at end of file
+obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
+obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) +=3D atmel-aes.o
diff --git a/drivers/crypto/atmel-aes-regs.h b/drivers/crypto/atmel-aes=
-regs.h
new file mode 100644
index 0000000..2786bb1
--- /dev/null
+++ b/drivers/crypto/atmel-aes-regs.h
@@ -0,0 +1,62 @@
+#ifndef __ATMEL_AES_REGS_H__
+#define __ATMEL_AES_REGS_H__
+
+#define AES_CR			0x00
+#define AES_CR_START		(1 << 0)
+#define AES_CR_SWRST		(1 << 8)
+#define AES_CR_LOADSEED		(1 << 16)
+
+#define	AES_MR			0x04
+#define AES_MR_CYPHER_DEC		(0 << 0)
+#define AES_MR_CYPHER_ENC		(1 << 0)
+#define	AES_MR_DUALBUFF			(1 << 3)
+#define AES_MR_PROCDLY_MASK		(0xF << 4)
+#define AES_MR_PROCDLY_OFFSET	4
+#define AES_MR_SMOD_MASK		(0x3 << 8)
+#define AES_MR_SMOD_MANUAL		(0x0 << 8)
+#define AES_MR_SMOD_AUTO		(0x1 << 8)
+#define AES_MR_SMOD_IDATAR0		(0x2 << 8)
+#define	AES_MR_KEYSIZE_MASK		(0x3 << 10)
+#define	AES_MR_KEYSIZE_128		(0x0 << 10)
+#define	AES_MR_KEYSIZE_192		(0x1 << 10)
+#define	AES_MR_KEYSIZE_256		(0x2 << 10)
+#define AES_MR_OPMOD_MASK		(0x7 << 12)
+#define AES_MR_OPMOD_ECB		(0x0 << 12)
+#define AES_MR_OPMOD_CBC		(0x1 << 12)
+#define AES_MR_OPMOD_OFB		(0x2 << 12)
+#define AES_MR_OPMOD_CFB		(0x3 << 12)
+#define AES_MR_OPMOD_CTR		(0x4 << 12)
+#define AES_MR_LOD				(0x1 << 15)
+#define AES_MR_CFBS_MASK		(0x7 << 16)
+#define AES_MR_CFBS_128b		(0x0 << 16)
+#define AES_MR_CFBS_64b			(0x1 << 16)
+#define AES_MR_CFBS_32b			(0x2 << 16)
+#define AES_MR_CFBS_16b			(0x3 << 16)
+#define AES_MR_CFBS_8b			(0x4 << 16)
+#define AES_MR_CKEY_MASK		(0xF << 20)
+#define AES_MR_CKEY_OFFSET		20
+#define AES_MR_CMTYP_MASK		(0x1F << 24)
+#define AES_MR_CMTYP_OFFSET		24
+
+#define	AES_IER		0x10
+#define	AES_IDR		0x14
+#define	AES_IMR		0x18
+#define	AES_ISR		0x1C
+#define AES_INT_DATARDY		(1 << 0)
+#define AES_INT_URAD		(1 << 8)
+#define AES_ISR_URAT_MASK	(0xF << 12)
+#define AES_ISR_URAT_IDR_WR_PROC	(0x0 << 12)
+#define AES_ISR_URAT_ODR_RD_PROC	(0x1 << 12)
+#define AES_ISR_URAT_MR_WR_PROC		(0x2 << 12)
+#define AES_ISR_URAT_ODR_RD_SUBK	(0x3 << 12)
+#define AES_ISR_URAT_MR_WR_SUBK		(0x4 << 12)
+#define AES_ISR_URAT_WOR_RD			(0x5 << 12)
+
+#define AES_KEYWR(x)	(0x20 + ((x) * 0x04))
+#define AES_IDATAR(x)	(0x40 + ((x) * 0x04))
+#define AES_ODATAR(x)	(0x50 + ((x) * 0x04))
+#define AES_IVR(x)		(0x60 + ((x) * 0x04))
+
+#define AES_HW_VERSION	0xFC
+
+#endif /* __ATMEL_AES_REGS_H__ */
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
new file mode 100644
index 0000000..6bb20ff
--- /dev/null
+++ b/drivers/crypto/atmel-aes.c
@@ -0,0 +1,1206 @@
+/*
+ * Cryptographic API.
+ *
+ * Support for ATMEL AES HW acceleration.
+ *
+ * Copyright (c) 2012 Eukr=C3=A9a Electromatique - ATMEL
+ * Author: Nicolas Royer <nicolas@eukrea.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as p=
ublished
+ * by the Free Software Foundation.
+ *
+ * Some ideas are from omap-aes.c driver.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/hw_random.h>
+#include <linux/platform_device.h>
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/crypto.h>
+#include <linux/cryptohash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <linux/platform_data/atmel-aes.h>
+#include "atmel-aes-regs.h"
+
+#define CFB8_BLOCK_SIZE		1
+#define CFB16_BLOCK_SIZE	2
+#define CFB32_BLOCK_SIZE	4
+#define CFB64_BLOCK_SIZE	8
+
+/* AES flags */
+#define AES_FLAGS_MODE_MASK	0x01ff
+#define AES_FLAGS_ENCRYPT	BIT(0)
+#define AES_FLAGS_CBC		BIT(1)
+#define AES_FLAGS_CFB		BIT(2)
+#define AES_FLAGS_CFB8		BIT(3)
+#define AES_FLAGS_CFB16		BIT(4)
+#define AES_FLAGS_CFB32		BIT(5)
+#define AES_FLAGS_CFB64		BIT(6)
+#define AES_FLAGS_OFB		BIT(7)
+#define AES_FLAGS_CTR		BIT(8)
+
+#define AES_FLAGS_INIT		BIT(16)
+#define AES_FLAGS_DMA		BIT(17)
+#define AES_FLAGS_BUSY		BIT(18)
+
+#define AES_FLAGS_DUALBUFF	BIT(24)
+
+#define ATMEL_AES_QUEUE_LENGTH	1
+#define ATMEL_AES_CACHE_SIZE	0
+
+#define ATMEL_AES_DMA_THRESHOLD		16
+
+
+struct atmel_aes_dev;
+
+struct atmel_aes_ctx {
+	struct atmel_aes_dev *dd;
+
+	int		keylen;
+	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
+};
+
+struct atmel_aes_reqctx {
+	unsigned long mode;
+};
+
+struct atmel_aes_dma {
+	struct dma_chan			*chan;
+	struct dma_slave_config dma_conf;
+};
+
+struct atmel_aes_dev {
+	struct list_head	list;
+	unsigned long		phys_base;
+	void __iomem		*io_base;
+
+	struct atmel_aes_ctx	*ctx;
+	struct device		*dev;
+	struct clk		*iclk;
+	int	irq;
+
+	unsigned long		flags;
+	int	err;
+
+	spinlock_t		lock;
+	struct crypto_queue	queue;
+
+	struct tasklet_struct	done_task;
+	struct tasklet_struct	queue_task;
+
+	struct ablkcipher_request	*req;
+	size_t	total;
+
+	struct scatterlist	*in_sg;
+	unsigned int		nb_in_sg;
+
+	struct scatterlist	*out_sg;
+	unsigned int		nb_out_sg;
+
+	size_t	bufcnt;
+
+	u8	buf_in[ATMEL_AES_DMA_THRESHOLD] __aligned(sizeof(u32));
+	int	dma_in;
+	struct atmel_aes_dma	dma_lch_in;
+
+	u8	buf_out[ATMEL_AES_DMA_THRESHOLD] __aligned(sizeof(u32));
+	int	dma_out;
+	struct atmel_aes_dma	dma_lch_out;
+
+	u32	hw_version;
+};
+
+struct atmel_aes_drv {
+	struct list_head	dev_list;
+	spinlock_t		lock;
+};
+
+static struct atmel_aes_drv atmel_aes =3D {
+	.dev_list =3D LIST_HEAD_INIT(atmel_aes.dev_list),
+	.lock =3D __SPIN_LOCK_UNLOCKED(atmel_aes.lock),
+};
+
+static int atmel_aes_sg_length(struct ablkcipher_request *req,
+			struct scatterlist *sg)
+{
+	unsigned int total =3D req->nbytes;
+	int sg_nb;
+	unsigned int len;
+	struct scatterlist *sg_list;
+
+	sg_nb =3D 0;
+	sg_list =3D sg;
+	total =3D req->nbytes;
+
+	while (total) {
+		len =3D min(sg_list->length, total);
+
+		sg_nb++;
+		total -=3D len;
+
+		sg_list =3D sg_next(sg_list);
+		if (!sg_list)
+			total =3D 0;
+	}
+
+	return sg_nb;
+}
+
+static inline u32 atmel_aes_read(struct atmel_aes_dev *dd, u32 offset)
+{
+	return readl_relaxed(dd->io_base + offset);
+}
+
+static inline void atmel_aes_write(struct atmel_aes_dev *dd,
+					u32 offset, u32 value)
+{
+	writel_relaxed(value, dd->io_base + offset);
+}
+
+static void atmel_aes_read_n(struct atmel_aes_dev *dd, u32 offset,
+					u32 *value, int count)
+{
+	for (; count--; value++, offset +=3D 4)
+		*value =3D atmel_aes_read(dd, offset);
+}
+
+static void atmel_aes_write_n(struct atmel_aes_dev *dd, u32 offset,
+					u32 *value, int count)
+{
+	for (; count--; value++, offset +=3D 4)
+		atmel_aes_write(dd, offset, *value);
+}
+
+static void atmel_aes_dualbuff_test(struct atmel_aes_dev *dd)
+{
+	atmel_aes_write(dd, AES_MR, AES_MR_DUALBUFF);
+
+	if (atmel_aes_read(dd, AES_MR) & AES_MR_DUALBUFF)
+		dd->flags |=3D AES_FLAGS_DUALBUFF;
+}
+
+static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_ctx *=
ctx)
+{
+	struct atmel_aes_dev *aes_dd =3D NULL;
+	struct atmel_aes_dev *tmp;
+
+	spin_lock_bh(&atmel_aes.lock);
+	if (!ctx->dd) {
+		list_for_each_entry(tmp, &atmel_aes.dev_list, list) {
+			aes_dd =3D tmp;
+			break;
+		}
+		ctx->dd =3D aes_dd;
+	} else {
+		aes_dd =3D ctx->dd;
+	}
+
+	spin_unlock_bh(&atmel_aes.lock);
+
+	return aes_dd;
+}
+
+static int atmel_aes_hw_init(struct atmel_aes_dev *dd)
+{
+	clk_prepare_enable(dd->iclk);
+
+	if (!(dd->flags & AES_FLAGS_INIT)) {
+		atmel_aes_write(dd, AES_CR, AES_CR_SWRST);
+		atmel_aes_dualbuff_test(dd);
+		dd->flags |=3D AES_FLAGS_INIT;
+		dd->err =3D 0;
+	}
+
+	return 0;
+}
+
+static void atmel_aes_hw_version_init(struct atmel_aes_dev *dd)
+{
+	atmel_aes_hw_init(dd);
+
+	dd->hw_version =3D atmel_aes_read(dd, AES_HW_VERSION);
+
+	clk_disable_unprepare(dd->iclk);
+}
+
+static void atmel_aes_finish_req(struct atmel_aes_dev *dd, int err)
+{
+	struct ablkcipher_request *req =3D dd->req;
+
+	clk_disable_unprepare(dd->iclk);
+	dd->flags &=3D ~AES_FLAGS_BUSY;
+
+	req->base.complete(&req->base, err);
+}
+
+static void atmel_aes_dma_callback(void *data)
+{
+	struct atmel_aes_dev *dd =3D data;
+
+	/* dma_lch_out - completed */
+	tasklet_schedule(&dd->done_task);
+}
+
+static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd)
+{
+	struct dma_async_tx_descriptor	*in_desc, *out_desc;
+	int nb_dma_sg_in, nb_dma_sg_out;
+
+	dd->nb_in_sg =3D atmel_aes_sg_length(dd->req, dd->in_sg);
+	if (!dd->nb_in_sg)
+		goto exit_err;
+
+	nb_dma_sg_in =3D dma_map_sg(dd->dev, dd->in_sg, dd->nb_in_sg,
+			DMA_TO_DEVICE);
+	if (!nb_dma_sg_in)
+		goto exit_err;
+
+	in_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_in.chan, dd->in_sg,
+				nb_dma_sg_in, DMA_MEM_TO_DEV,
+				DMA_PREP_INTERRUPT  |  DMA_CTRL_ACK);
+
+	if (!in_desc)
+		goto unmap_in;
+
+	/* callback not needed */
+
+	dd->nb_out_sg =3D atmel_aes_sg_length(dd->req, dd->out_sg);
+	if (!dd->nb_out_sg)
+		goto unmap_in;
+
+	nb_dma_sg_out =3D dma_map_sg(dd->dev, dd->out_sg, dd->nb_out_sg,
+			DMA_FROM_DEVICE);
+	if (!nb_dma_sg_out)
+		goto unmap_out;
+
+	out_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_out.chan, dd->out_sg=
,
+				nb_dma_sg_out, DMA_DEV_TO_MEM,
+				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+
+	if (!out_desc)
+		goto unmap_out;
+
+	out_desc->callback =3D atmel_aes_dma_callback;
+	out_desc->callback_param =3D dd;
+
+	dd->total -=3D dd->req->nbytes;
+
+	dmaengine_submit(out_desc);
+	dma_async_issue_pending(dd->dma_lch_out.chan);
+
+	dmaengine_submit(in_desc);
+	dma_async_issue_pending(dd->dma_lch_in.chan);
+
+	return 0;
+
+unmap_out:
+	dma_unmap_sg(dd->dev, dd->out_sg, dd->nb_out_sg,
+		DMA_FROM_DEVICE);
+unmap_in:
+	dma_unmap_sg(dd->dev, dd->in_sg, dd->nb_in_sg,
+		DMA_TO_DEVICE);
+exit_err:
+	return -EINVAL;
+}
+
+static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
+{
+	dd->flags &=3D ~AES_FLAGS_DMA;
+
+	/* use cache buffers */
+	dd->nb_in_sg =3D atmel_aes_sg_length(dd->req, dd->in_sg);
+	if (!dd->nb_in_sg)
+		return -EINVAL;
+
+	dd->nb_out_sg =3D atmel_aes_sg_length(dd->req, dd->out_sg);
+	if (!dd->nb_in_sg)
+		return -EINVAL;
+
+	dd->bufcnt =3D sg_copy_to_buffer(dd->in_sg, dd->nb_in_sg,
+					dd->buf_in, dd->total);
+
+	if (!dd->bufcnt)
+		return -EINVAL;
+
+	dd->total -=3D dd->bufcnt;
+
+	atmel_aes_write(dd, AES_IER, AES_INT_DATARDY);
+	atmel_aes_write_n(dd, AES_IDATAR(0), (u32 *) dd->buf_in,
+				dd->bufcnt >> 2);
+
+	return 0;
+}
+
+static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
+{
+	int err;
+
+	if (dd->flags & AES_FLAGS_CFB8) {
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_1_BYTE;
+		dd->dma_lch_out.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_1_BYTE;
+	} else if (dd->flags & AES_FLAGS_CFB16) {
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_2_BYTES;
+		dd->dma_lch_out.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_2_BYTES;
+	} else {
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dd->dma_lch_out.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+	}
+
+	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf)=
;
+	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_con=
f);
+
+	dd->flags |=3D AES_FLAGS_DMA;
+	err =3D atmel_aes_crypt_dma(dd);
+
+	return err;
+}
+
+static int atmel_aes_write_ctrl(struct atmel_aes_dev *dd)
+{
+	int err;
+	u32 valcr =3D 0, valmr =3D 0;
+
+	err =3D atmel_aes_hw_init(dd);
+
+	if (err)
+		return err;
+
+	/* MR register must be set before IV registers */
+	if (dd->ctx->keylen =3D=3D AES_KEYSIZE_128)
+		valmr |=3D AES_MR_KEYSIZE_128;
+	else if (dd->ctx->keylen =3D=3D AES_KEYSIZE_192)
+		valmr |=3D AES_MR_KEYSIZE_192;
+	else
+		valmr |=3D AES_MR_KEYSIZE_256;
+
+	if (dd->flags & AES_FLAGS_CBC) {
+		valmr |=3D AES_MR_OPMOD_CBC;
+	} else if (dd->flags & AES_FLAGS_CFB) {
+		valmr |=3D AES_MR_OPMOD_CFB;
+		if (dd->flags & AES_FLAGS_CFB8)
+			valmr |=3D AES_MR_CFBS_8b;
+		else if (dd->flags & AES_FLAGS_CFB16)
+			valmr |=3D AES_MR_CFBS_16b;
+		else if (dd->flags & AES_FLAGS_CFB32)
+			valmr |=3D AES_MR_CFBS_32b;
+		else if (dd->flags & AES_FLAGS_CFB64)
+			valmr |=3D AES_MR_CFBS_64b;
+	} else if (dd->flags & AES_FLAGS_OFB) {
+		valmr |=3D AES_MR_OPMOD_OFB;
+	} else if (dd->flags & AES_FLAGS_CTR) {
+		valmr |=3D AES_MR_OPMOD_CTR;
+	} else {
+		valmr |=3D AES_MR_OPMOD_ECB;
+	}
+
+	if (dd->flags & AES_FLAGS_ENCRYPT)
+		valmr |=3D AES_MR_CYPHER_ENC;
+
+	if (dd->total > ATMEL_AES_DMA_THRESHOLD) {
+		valmr |=3D AES_MR_SMOD_IDATAR0;
+		if (dd->flags & AES_FLAGS_DUALBUFF)
+			valmr |=3D AES_MR_DUALBUFF;
+	} else {
+		valmr |=3D AES_MR_SMOD_AUTO;
+	}
+
+	atmel_aes_write(dd, AES_CR, valcr);
+	atmel_aes_write(dd, AES_MR, valmr);
+
+	atmel_aes_write_n(dd, AES_KEYWR(0), dd->ctx->key,
+						dd->ctx->keylen >> 2);
+
+	if (((dd->flags & AES_FLAGS_CBC) || (dd->flags & AES_FLAGS_CFB) ||
+	   (dd->flags & AES_FLAGS_OFB) || (dd->flags & AES_FLAGS_CTR)) &&
+	   dd->req->info) {
+		atmel_aes_write_n(dd, AES_IVR(0), dd->req->info, 4);
+	}
+
+	return 0;
+}
+
+static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
+			       struct ablkcipher_request *req)
+{
+	struct crypto_async_request *async_req, *backlog;
+	struct atmel_aes_ctx *ctx;
+	struct atmel_aes_reqctx *rctx;
+	unsigned long flags;
+	int err, ret =3D 0;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	if (req)
+		ret =3D ablkcipher_enqueue_request(&dd->queue, req);
+	if (dd->flags & AES_FLAGS_BUSY) {
+		spin_unlock_irqrestore(&dd->lock, flags);
+		return ret;
+	}
+	backlog =3D crypto_get_backlog(&dd->queue);
+	async_req =3D crypto_dequeue_request(&dd->queue);
+	if (async_req)
+		dd->flags |=3D AES_FLAGS_BUSY;
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	if (!async_req)
+		return ret;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	req =3D ablkcipher_request_cast(async_req);
+
+	/* assign new request to device */
+	dd->req =3D req;
+	dd->total =3D req->nbytes;
+	dd->in_sg =3D req->src;
+	dd->out_sg =3D req->dst;
+
+	rctx =3D ablkcipher_request_ctx(req);
+	ctx =3D crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	rctx->mode &=3D AES_FLAGS_MODE_MASK;
+	dd->flags =3D (dd->flags & ~AES_FLAGS_MODE_MASK) | rctx->mode;
+	dd->ctx =3D ctx;
+	ctx->dd =3D dd;
+
+	err =3D atmel_aes_write_ctrl(dd);
+	if (!err) {
+		if (dd->total > ATMEL_AES_DMA_THRESHOLD)
+			err =3D atmel_aes_crypt_dma_start(dd);
+		else
+			err =3D atmel_aes_crypt_cpu_start(dd);
+	}
+	if (err) {
+		/* aes_task will not finish it, so do it here */
+		atmel_aes_finish_req(dd, err);
+		tasklet_schedule(&dd->queue_task);
+	}
+
+	return ret;
+}
+
+static int atmel_aes_crypt_dma_stop(struct atmel_aes_dev *dd)
+{
+	int err =3D -EINVAL;
+
+	if (dd->flags & AES_FLAGS_DMA) {
+		dma_unmap_sg(dd->dev, dd->out_sg,
+			dd->nb_out_sg, DMA_FROM_DEVICE);
+		dma_unmap_sg(dd->dev, dd->in_sg,
+			dd->nb_in_sg, DMA_TO_DEVICE);
+		err =3D 0;
+	}
+
+	return err;
+}
+
+static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned lo=
ng mode)
+{
+	struct atmel_aes_ctx *ctx =3D crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(req));
+	struct atmel_aes_reqctx *rctx =3D ablkcipher_request_ctx(req);
+	struct atmel_aes_dev *dd;
+
+	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
+		pr_err("request size is not exact amount of AES blocks\n");
+		return -EINVAL;
+	}
+
+	dd =3D atmel_aes_find_dev(ctx);
+	if (!dd)
+		return -ENODEV;
+
+	rctx->mode =3D mode;
+
+	return atmel_aes_handle_queue(dd, req);
+}
+
+static bool atmel_aes_filter(struct dma_chan *chan, void *slave)
+{
+	struct at_dma_slave	*sl =3D slave;
+
+	if (sl && sl->dma_dev =3D=3D chan->device->dev) {
+		chan->private =3D sl;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+static int atmel_aes_dma_init(struct atmel_aes_dev *dd)
+{
+	int err =3D -ENOMEM;
+	struct aes_platform_data	*pdata;
+	dma_cap_mask_t mask_in, mask_out;
+
+	pdata =3D dd->dev->platform_data;
+
+	if (pdata && pdata->dma_slave->txdata.dma_dev &&
+		pdata->dma_slave->rxdata.dma_dev) {
+
+		/* Try to grab 2 DMA channels */
+		dma_cap_zero(mask_in);
+		dma_cap_set(DMA_SLAVE, mask_in);
+
+		dd->dma_lch_in.chan =3D dma_request_channel(mask_in,
+				atmel_aes_filter, &pdata->dma_slave->rxdata);
+		if (!dd->dma_lch_in.chan)
+			goto err_dma_in;
+
+		dd->dma_lch_in.dma_conf.direction =3D DMA_MEM_TO_DEV;
+		dd->dma_lch_in.dma_conf.dst_addr =3D dd->phys_base +
+			AES_IDATAR(0);
+		dd->dma_lch_in.dma_conf.src_maxburst =3D 1;
+		dd->dma_lch_in.dma_conf.dst_maxburst =3D 1;
+		dd->dma_lch_in.dma_conf.device_fc =3D false;
+
+		dma_cap_zero(mask_out);
+		dma_cap_set(DMA_SLAVE, mask_out);
+		dd->dma_lch_out.chan =3D dma_request_channel(mask_out,
+				atmel_aes_filter, &pdata->dma_slave->txdata);
+		if (!dd->dma_lch_out.chan)
+			goto err_dma_out;
+
+		dd->dma_lch_out.dma_conf.direction =3D DMA_DEV_TO_MEM;
+		dd->dma_lch_out.dma_conf.src_addr =3D dd->phys_base +
+			AES_ODATAR(0);
+		dd->dma_lch_out.dma_conf.src_maxburst =3D 1;
+		dd->dma_lch_out.dma_conf.dst_maxburst =3D 1;
+		dd->dma_lch_out.dma_conf.device_fc =3D false;
+
+		return 0;
+	} else {
+		return -ENODEV;
+	}
+
+err_dma_out:
+	dma_release_channel(dd->dma_lch_in.chan);
+err_dma_in:
+	return err;
+}
+
+static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
+{
+	dma_release_channel(dd->dma_lch_in.chan);
+	dma_release_channel(dd->dma_lch_out.chan);
+}
+
+static int atmel_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *k=
ey,
+			   unsigned int keylen)
+{
+	struct atmel_aes_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
+
+	if (keylen !=3D AES_KEYSIZE_128 && keylen !=3D AES_KEYSIZE_192 &&
+		   keylen !=3D AES_KEYSIZE_256) {
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen =3D keylen;
+
+	return 0;
+}
+
+static int atmel_aes_ecb_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT);
+}
+
+static int atmel_aes_ecb_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		0);
+}
+
+static int atmel_aes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT | AES_FLAGS_CBC);
+}
+
+static int atmel_aes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_CBC);
+}
+
+static int atmel_aes_ofb_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT | AES_FLAGS_OFB);
+}
+
+static int atmel_aes_ofb_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_OFB);
+}
+
+static int atmel_aes_cfb_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB);
+}
+
+static int atmel_aes_cfb_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_CFB);
+}
+
+static int atmel_aes_cfb64_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB64);
+}
+
+static int atmel_aes_cfb64_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_CFB | AES_FLAGS_CFB64);
+}
+
+static int atmel_aes_cfb32_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB32);
+}
+
+static int atmel_aes_cfb32_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_CFB | AES_FLAGS_CFB32);
+}
+
+static int atmel_aes_cfb16_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB16);
+}
+
+static int atmel_aes_cfb16_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_CFB | AES_FLAGS_CFB16);
+}
+
+static int atmel_aes_cfb8_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT |	AES_FLAGS_CFB | AES_FLAGS_CFB8);
+}
+
+static int atmel_aes_cfb8_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_CFB | AES_FLAGS_CFB8);
+}
+
+static int atmel_aes_ctr_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_ENCRYPT | AES_FLAGS_CTR);
+}
+
+static int atmel_aes_ctr_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_aes_crypt(req,
+		AES_FLAGS_CTR);
+}
+
+static int atmel_aes_cra_init(struct crypto_tfm *tfm)
+{
+	tfm->crt_ablkcipher.reqsize =3D sizeof(struct atmel_aes_reqctx);
+
+	return 0;
+}
+
+static void atmel_aes_cra_exit(struct crypto_tfm *tfm)
+{
+}
+
+static struct crypto_alg aes_algs[] =3D {
+{
+	.cra_name		=3D "ecb(aes)",
+	.cra_driver_name	=3D "atmel-ecb-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_ecb_encrypt,
+		.decrypt	=3D atmel_aes_ecb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cbc(aes)",
+	.cra_driver_name	=3D "atmel-cbc-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_cbc_encrypt,
+		.decrypt	=3D atmel_aes_cbc_decrypt,
+	}
+},
+{
+	.cra_name		=3D "ofb(aes)",
+	.cra_driver_name	=3D "atmel-ofb-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_ofb_encrypt,
+		.decrypt	=3D atmel_aes_ofb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb(aes)",
+	.cra_driver_name	=3D "atmel-cfb-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_cfb_encrypt,
+		.decrypt	=3D atmel_aes_cfb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb32(aes)",
+	.cra_driver_name	=3D "atmel-cfb32-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB32_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_cfb32_encrypt,
+		.decrypt	=3D atmel_aes_cfb32_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb16(aes)",
+	.cra_driver_name	=3D "atmel-cfb16-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB16_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_cfb16_encrypt,
+		.decrypt	=3D atmel_aes_cfb16_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb8(aes)",
+	.cra_driver_name	=3D "atmel-cfb8-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB64_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_cfb8_encrypt,
+		.decrypt	=3D atmel_aes_cfb8_decrypt,
+	}
+},
+{
+	.cra_name		=3D "ctr(aes)",
+	.cra_driver_name	=3D "atmel-ctr-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_ctr_encrypt,
+		.decrypt	=3D atmel_aes_ctr_decrypt,
+	}
+},
+};
+
+static struct crypto_alg aes_cfb64_alg[] =3D {
+{
+	.cra_name		=3D "cfb64(aes)",
+	.cra_driver_name	=3D "atmel-cfb64-aes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB64_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
+	.cra_alignmask		=3D 0x0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_aes_cra_init,
+	.cra_exit		=3D atmel_aes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D AES_MIN_KEY_SIZE,
+		.max_keysize	=3D AES_MAX_KEY_SIZE,
+		.ivsize		=3D AES_BLOCK_SIZE,
+		.setkey		=3D atmel_aes_setkey,
+		.encrypt	=3D atmel_aes_cfb64_encrypt,
+		.decrypt	=3D atmel_aes_cfb64_decrypt,
+	}
+},
+};
+
+static void atmel_aes_queue_task(unsigned long data)
+{
+	struct atmel_aes_dev *dd =3D (struct atmel_aes_dev *)data;
+
+	atmel_aes_handle_queue(dd, NULL);
+}
+
+static void atmel_aes_done_task(unsigned long data)
+{
+	struct atmel_aes_dev *dd =3D (struct atmel_aes_dev *) data;
+	int err;
+
+	if (!(dd->flags & AES_FLAGS_DMA)) {
+		atmel_aes_read_n(dd, AES_ODATAR(0), (u32 *) dd->buf_out,
+				dd->bufcnt >> 2);
+
+		if (sg_copy_from_buffer(dd->out_sg, dd->nb_out_sg,
+			dd->buf_out, dd->bufcnt))
+			err =3D 0;
+		else
+			err =3D -EINVAL;
+
+		goto cpu_end;
+	}
+
+	err =3D atmel_aes_crypt_dma_stop(dd);
+
+	err =3D dd->err ? : err;
+
+	if (dd->total && !err) {
+		err =3D atmel_aes_crypt_dma_start(dd);
+		if (!err)
+			return; /* DMA started. Not fininishing. */
+	}
+
+cpu_end:
+	atmel_aes_finish_req(dd, err);
+	atmel_aes_handle_queue(dd, NULL);
+}
+
+static irqreturn_t atmel_aes_irq(int irq, void *dev_id)
+{
+	struct atmel_aes_dev *aes_dd =3D dev_id;
+	u32 reg;
+
+	reg =3D atmel_aes_read(aes_dd, AES_ISR);
+	if (reg & atmel_aes_read(aes_dd, AES_IMR)) {
+		atmel_aes_write(aes_dd, AES_IDR, reg);
+		if (AES_FLAGS_BUSY & aes_dd->flags)
+			tasklet_schedule(&aes_dd->done_task);
+		else
+			dev_warn(aes_dd->dev, "AES interrupt when no active requests.\n");
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
+{
+	int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(aes_algs); i++)
+		crypto_unregister_alg(&aes_algs[i]);
+	if (dd->hw_version >=3D 0x130)
+		crypto_unregister_alg(&aes_cfb64_alg[0]);
+}
+
+static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
+{
+	int err, i, j;
+
+	for (i =3D 0; i < ARRAY_SIZE(aes_algs); i++) {
+		INIT_LIST_HEAD(&aes_algs[i].cra_list);
+		err =3D crypto_register_alg(&aes_algs[i]);
+		if (err)
+			goto err_aes_algs;
+	}
+
+	atmel_aes_hw_version_init(dd);
+
+	if (dd->hw_version >=3D 0x130) {
+		INIT_LIST_HEAD(&aes_cfb64_alg[0].cra_list);
+		err =3D crypto_register_alg(&aes_cfb64_alg[0]);
+		if (err)
+			goto err_aes_cfb64_alg;
+	}
+
+	return 0;
+
+err_aes_cfb64_alg:
+	i =3D ARRAY_SIZE(aes_algs);
+err_aes_algs:
+	for (j =3D 0; j < i; j++)
+		crypto_unregister_alg(&aes_algs[j]);
+
+	return err;
+}
+
+static int __devinit atmel_aes_probe(struct platform_device *pdev)
+{
+	struct atmel_aes_dev *aes_dd;
+	struct aes_platform_data	*pdata;
+	struct device *dev =3D &pdev->dev;
+	struct resource *aes_res;
+	unsigned long aes_phys_size;
+	int err;
+
+	pdata =3D pdev->dev.platform_data;
+	if (!pdata) {
+		err =3D -ENXIO;
+		goto aes_dd_err;
+	}
+
+	aes_dd =3D kzalloc(sizeof(struct atmel_aes_dev), GFP_KERNEL);
+	if (aes_dd =3D=3D NULL) {
+		dev_err(dev, "unable to alloc data struct.\n");
+		err =3D -ENOMEM;
+		goto aes_dd_err;
+	}
+
+	aes_dd->dev =3D dev;
+
+	platform_set_drvdata(pdev, aes_dd);
+
+	INIT_LIST_HEAD(&aes_dd->list);
+
+	tasklet_init(&aes_dd->done_task, atmel_aes_done_task,
+					(unsigned long)aes_dd);
+	tasklet_init(&aes_dd->queue_task, atmel_aes_queue_task,
+					(unsigned long)aes_dd);
+
+	crypto_init_queue(&aes_dd->queue, ATMEL_AES_QUEUE_LENGTH);
+
+	aes_dd->irq =3D -1;
+
+	/* Get the base address */
+	aes_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!aes_res) {
+		dev_err(dev, "no MEM resource info\n");
+		err =3D -ENODEV;
+		goto res_err;
+	}
+	aes_dd->phys_base =3D aes_res->start;
+	aes_phys_size =3D resource_size(aes_res);
+
+	/* Get the IRQ */
+	aes_dd->irq =3D platform_get_irq(pdev,  0);
+	if (aes_dd->irq < 0) {
+		dev_err(dev, "no IRQ resource info\n");
+		err =3D aes_dd->irq;
+		goto aes_irq_err;
+	}
+
+	err =3D request_irq(aes_dd->irq, atmel_aes_irq, IRQF_SHARED, "atmel-a=
es",
+						aes_dd);
+	if (err) {
+		dev_err(dev, "unable to request aes irq.\n");
+		goto aes_irq_err;
+	}
+
+	/* Initializing the clock */
+	aes_dd->iclk =3D clk_get(&pdev->dev, NULL);
+	if (IS_ERR(aes_dd->iclk)) {
+		dev_err(dev, "clock intialization failed.\n");
+		err =3D PTR_ERR(aes_dd->iclk);
+		goto clk_err;
+	}
+
+	aes_dd->io_base =3D ioremap(aes_dd->phys_base, aes_phys_size);
+	if (!aes_dd->io_base) {
+		dev_err(dev, "can't ioremap\n");
+		err =3D -ENOMEM;
+		goto aes_io_err;
+	}
+
+	err =3D atmel_aes_dma_init(aes_dd);
+	if (err)
+		goto err_aes_dma;
+
+	spin_lock(&atmel_aes.lock);
+	list_add_tail(&aes_dd->list, &atmel_aes.dev_list);
+	spin_unlock(&atmel_aes.lock);
+
+	err =3D atmel_aes_register_algs(aes_dd);
+	if (err)
+		goto err_algs;
+
+	dev_info(dev, "Atmel AES\n");
+
+	return 0;
+
+err_algs:
+	spin_lock(&atmel_aes.lock);
+	list_del(&aes_dd->list);
+	spin_unlock(&atmel_aes.lock);
+	atmel_aes_dma_cleanup(aes_dd);
+err_aes_dma:
+	iounmap(aes_dd->io_base);
+aes_io_err:
+	clk_put(aes_dd->iclk);
+clk_err:
+	free_irq(aes_dd->irq, aes_dd);
+aes_irq_err:
+res_err:
+	tasklet_kill(&aes_dd->done_task);
+	tasklet_kill(&aes_dd->queue_task);
+	kfree(aes_dd);
+	aes_dd =3D NULL;
+aes_dd_err:
+	dev_err(dev, "initialization failed.\n");
+
+	return err;
+}
+
+static int __devexit atmel_aes_remove(struct platform_device *pdev)
+{
+	static struct atmel_aes_dev *aes_dd;
+
+	aes_dd =3D platform_get_drvdata(pdev);
+	if (!aes_dd)
+		return -ENODEV;
+	spin_lock(&atmel_aes.lock);
+	list_del(&aes_dd->list);
+	spin_unlock(&atmel_aes.lock);
+
+	atmel_aes_unregister_algs(aes_dd);
+
+	tasklet_kill(&aes_dd->done_task);
+	tasklet_kill(&aes_dd->queue_task);
+
+	atmel_aes_dma_cleanup(aes_dd);
+
+	iounmap(aes_dd->io_base);
+
+	clk_put(aes_dd->iclk);
+
+	if (aes_dd->irq > 0)
+		free_irq(aes_dd->irq, aes_dd);
+
+	kfree(aes_dd);
+	aes_dd =3D NULL;
+
+	return 0;
+}
+
+static struct platform_driver atmel_aes_driver =3D {
+	.probe		=3D atmel_aes_probe,
+	.remove		=3D __devexit_p(atmel_aes_remove),
+	.driver		=3D {
+		.name	=3D "atmel_aes",
+		.owner	=3D THIS_MODULE,
+	},
+};
+
+module_platform_driver(atmel_aes_driver);
+
+MODULE_DESCRIPTION("Atmel AES hw acceleration support.");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Nicolas Royer - Eukr=C3=A9a Electromatique");
--=20
1.7.7.6
