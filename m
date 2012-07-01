From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 3/5] crypto: add Atmel DES/TDES driver
Date: Sun,  1 Jul 2012 19:19:45 +0200
Message-ID: <1341163187-14946-4-git-send-email-eric@eukrea.com>
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
 drivers/crypto/Kconfig           |   16 +
 drivers/crypto/Makefile          |    1 +
 drivers/crypto/atmel-tdes-regs.h |   89 +++
 drivers/crypto/atmel-tdes.c      | 1215 ++++++++++++++++++++++++++++++=
++++++++
 4 files changed, 1321 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/atmel-tdes-regs.h
 create mode 100644 drivers/crypto/atmel-tdes.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1be94e5..9ac7128 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -342,4 +342,20 @@ config CRYPTO_DEV_ATMEL_AES
 	  To compile this driver as a module, choose M here: the module
 	  will be called atmel-aes.
=20
+config CRYPTO_DEV_ATMEL_TDES
+	tristate "Support for Atmel DES/TDES hw accelerator"
+	depends on ARCH_AT91
+	select CRYPTO_DES
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  Some Atmel processors have DES/TDES hw accelerator.
+	  Select this if you want to use the Atmel module for
+	  DES/TDES algorithms.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called atmel-tdes.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 7d17b67..211fdc2 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) +=3D s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) +=3D tegra-aes.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) +=3D atmel-aes.o
+obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) +=3D atmel-tdes.o
diff --git a/drivers/crypto/atmel-tdes-regs.h b/drivers/crypto/atmel-td=
es-regs.h
new file mode 100644
index 0000000..5ac2a90
--- /dev/null
+++ b/drivers/crypto/atmel-tdes-regs.h
@@ -0,0 +1,89 @@
+#ifndef __ATMEL_TDES_REGS_H__
+#define __ATMEL_TDES_REGS_H__
+
+#define TDES_CR			0x00
+#define TDES_CR_START			(1 << 0)
+#define TDES_CR_SWRST			(1 << 8)
+#define TDES_CR_LOADSEED		(1 << 16)
+
+#define	TDES_MR			0x04
+#define TDES_MR_CYPHER_DEC		(0 << 0)
+#define TDES_MR_CYPHER_ENC		(1 << 0)
+#define TDES_MR_TDESMOD_MASK	(0x3 << 1)
+#define TDES_MR_TDESMOD_DES		(0x0 << 1)
+#define TDES_MR_TDESMOD_TDES	(0x1 << 1)
+#define TDES_MR_TDESMOD_XTEA	(0x2 << 1)
+#define TDES_MR_KEYMOD_3KEY		(0 << 4)
+#define TDES_MR_KEYMOD_2KEY		(1 << 4)
+#define TDES_MR_SMOD_MASK		(0x3 << 8)
+#define TDES_MR_SMOD_MANUAL		(0x0 << 8)
+#define TDES_MR_SMOD_AUTO		(0x1 << 8)
+#define TDES_MR_SMOD_PDC		(0x2 << 8)
+#define TDES_MR_OPMOD_MASK		(0x3 << 12)
+#define TDES_MR_OPMOD_ECB		(0x0 << 12)
+#define TDES_MR_OPMOD_CBC		(0x1 << 12)
+#define TDES_MR_OPMOD_OFB		(0x2 << 12)
+#define TDES_MR_OPMOD_CFB		(0x3 << 12)
+#define TDES_MR_LOD				(0x1 << 15)
+#define TDES_MR_CFBS_MASK		(0x3 << 16)
+#define TDES_MR_CFBS_64b		(0x0 << 16)
+#define TDES_MR_CFBS_32b		(0x1 << 16)
+#define TDES_MR_CFBS_16b		(0x2 << 16)
+#define TDES_MR_CFBS_8b			(0x3 << 16)
+#define TDES_MR_CKEY_MASK		(0xF << 20)
+#define TDES_MR_CKEY_OFFSET		20
+#define TDES_MR_CTYPE_MASK		(0x3F << 24)
+#define TDES_MR_CTYPE_OFFSET	24
+
+#define	TDES_IER		0x10
+#define	TDES_IDR		0x14
+#define	TDES_IMR		0x18
+#define	TDES_ISR		0x1C
+#define TDES_INT_DATARDY		(1 << 0)
+#define TDES_INT_ENDRX			(1 << 1)
+#define TDES_INT_ENDTX			(1 << 2)
+#define TDES_INT_RXBUFF			(1 << 3)
+#define TDES_INT_TXBUFE			(1 << 4)
+#define TDES_INT_URAD			(1 << 8)
+#define TDES_ISR_URAT_MASK		(0x3 << 12)
+#define TDES_ISR_URAT_IDR		(0x0 << 12)
+#define TDES_ISR_URAT_ODR		(0x1 << 12)
+#define TDES_ISR_URAT_MR		(0x2 << 12)
+#define TDES_ISR_URAT_WO		(0x3 << 12)
+
+
+#define	TDES_KEY1W1R	0x20
+#define	TDES_KEY1W2R	0x24
+#define	TDES_KEY2W1R	0x28
+#define	TDES_KEY2W2R	0x2C
+#define	TDES_KEY3W1R	0x30
+#define	TDES_KEY3W2R	0x34
+#define	TDES_IDATA1R	0x40
+#define	TDES_IDATA2R	0x44
+#define	TDES_ODATA1R	0x50
+#define	TDES_ODATA2R	0x54
+#define	TDES_IV1R		0x60
+#define	TDES_IV2R		0x64
+
+#define	TDES_XTEARNDR	0x70
+#define	TDES_XTEARNDR_XTEA_RNDS_MASK	(0x3F << 0)
+#define	TDES_XTEARNDR_XTEA_RNDS_OFFSET	0
+
+#define TDES_RPR		0x100
+#define TDES_RCR		0x104
+#define TDES_TPR		0x108
+#define TDES_TCR		0x10C
+#define TDES_RNPR		0x118
+#define TDES_RNCR		0x11C
+#define TDES_TNPR		0x118
+#define TDES_TNCR		0x11C
+#define TDES_PTCR		0x120
+#define TDES_PTCR_RXTEN			(1 << 0)
+#define TDES_PTCR_RXTDIS		(1 << 1)
+#define TDES_PTCR_TXTEN			(1 << 8)
+#define TDES_PTCR_TXTDIS		(1 << 9)
+#define TDES_PTSR		0x124
+#define TDES_PTSR_RXTEN			(1 << 0)
+#define TDES_PTSR_TXTEN			(1 << 8)
+
+#endif /* __ATMEL_TDES_REGS_H__ */
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
new file mode 100644
index 0000000..eb2b61e
--- /dev/null
+++ b/drivers/crypto/atmel-tdes.c
@@ -0,0 +1,1215 @@
+/*
+ * Cryptographic API.
+ *
+ * Support for ATMEL DES/TDES HW acceleration.
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
+ * Some ideas are from omap-aes.c drivers.
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
+#include <crypto/des.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include "atmel-tdes-regs.h"
+
+/* TDES flags  */
+#define TDES_FLAGS_MODE_MASK		0x007f
+#define TDES_FLAGS_ENCRYPT	BIT(0)
+#define TDES_FLAGS_CBC		BIT(1)
+#define TDES_FLAGS_CFB		BIT(2)
+#define TDES_FLAGS_CFB8		BIT(3)
+#define TDES_FLAGS_CFB16	BIT(4)
+#define TDES_FLAGS_CFB32	BIT(5)
+#define TDES_FLAGS_OFB		BIT(6)
+
+#define TDES_FLAGS_INIT		BIT(16)
+#define TDES_FLAGS_FAST		BIT(17)
+#define TDES_FLAGS_BUSY		BIT(18)
+
+#define ATMEL_TDES_QUEUE_LENGTH	1
+
+#define CFB8_BLOCK_SIZE		1
+#define CFB16_BLOCK_SIZE	2
+#define CFB32_BLOCK_SIZE	4
+#define CFB64_BLOCK_SIZE	8
+
+
+struct atmel_tdes_dev;
+
+struct atmel_tdes_ctx {
+	struct atmel_tdes_dev *dd;
+
+	int		keylen;
+	u32		key[3*DES_KEY_SIZE / sizeof(u32)];
+	unsigned long	flags;
+};
+
+struct atmel_tdes_reqctx {
+	unsigned long mode;
+};
+
+struct atmel_tdes_dev {
+	struct list_head	list;
+	unsigned long		phys_base;
+	void __iomem		*io_base;
+
+	struct atmel_tdes_ctx	*ctx;
+	struct device		*dev;
+	struct clk			*iclk;
+	int					irq;
+
+	unsigned long		flags;
+	int			err;
+
+	spinlock_t		lock;
+	struct crypto_queue	queue;
+
+	struct tasklet_struct	done_task;
+	struct tasklet_struct	queue_task;
+
+	struct ablkcipher_request	*req;
+	size_t				total;
+
+	struct scatterlist	*in_sg;
+	size_t				in_offset;
+	struct scatterlist	*out_sg;
+	size_t				out_offset;
+
+	size_t	buflen;
+	size_t	dma_size;
+
+	void	*buf_in;
+	int		dma_in;
+	dma_addr_t	dma_addr_in;
+
+	void	*buf_out;
+	int		dma_out;
+	dma_addr_t	dma_addr_out;
+};
+
+struct atmel_tdes_drv {
+	struct list_head	dev_list;
+	spinlock_t		lock;
+};
+
+static struct atmel_tdes_drv atmel_tdes =3D {
+	.dev_list =3D LIST_HEAD_INIT(atmel_tdes.dev_list),
+	.lock =3D __SPIN_LOCK_UNLOCKED(atmel_tdes.lock),
+};
+
+static int atmel_tdes_sg_copy(struct scatterlist **sg, size_t *offset,
+			void *buf, size_t buflen, size_t total, int out)
+{
+	unsigned int count, off =3D 0;
+
+	while (buflen && total) {
+		count =3D min((*sg)->length - *offset, total);
+		count =3D min(count, buflen);
+
+		if (!count)
+			return off;
+
+		scatterwalk_map_and_copy(buf + off, *sg, *offset, count, out);
+
+		off +=3D count;
+		buflen -=3D count;
+		*offset +=3D count;
+		total -=3D count;
+
+		if (*offset =3D=3D (*sg)->length) {
+			*sg =3D sg_next(*sg);
+			if (*sg)
+				*offset =3D 0;
+			else
+				total =3D 0;
+		}
+	}
+
+	return off;
+}
+
+static inline u32 atmel_tdes_read(struct atmel_tdes_dev *dd, u32 offse=
t)
+{
+	return readl_relaxed(dd->io_base + offset);
+}
+
+static inline void atmel_tdes_write(struct atmel_tdes_dev *dd,
+					u32 offset, u32 value)
+{
+	writel_relaxed(value, dd->io_base + offset);
+}
+
+static void atmel_tdes_write_n(struct atmel_tdes_dev *dd, u32 offset,
+					u32 *value, int count)
+{
+	for (; count--; value++, offset +=3D 4)
+		atmel_tdes_write(dd, offset, *value);
+}
+
+static struct atmel_tdes_dev *atmel_tdes_find_dev(struct atmel_tdes_ct=
x *ctx)
+{
+	struct atmel_tdes_dev *tdes_dd =3D NULL;
+	struct atmel_tdes_dev *tmp;
+
+	spin_lock_bh(&atmel_tdes.lock);
+	if (!ctx->dd) {
+		list_for_each_entry(tmp, &atmel_tdes.dev_list, list) {
+			tdes_dd =3D tmp;
+			break;
+		}
+		ctx->dd =3D tdes_dd;
+	} else {
+		tdes_dd =3D ctx->dd;
+	}
+	spin_unlock_bh(&atmel_tdes.lock);
+
+	return tdes_dd;
+}
+
+static int atmel_tdes_hw_init(struct atmel_tdes_dev *dd)
+{
+	clk_prepare_enable(dd->iclk);
+
+	if (!(dd->flags & TDES_FLAGS_INIT)) {
+		atmel_tdes_write(dd, TDES_CR, TDES_CR_SWRST);
+		dd->flags |=3D TDES_FLAGS_INIT;
+		dd->err =3D 0;
+	}
+
+	return 0;
+}
+
+static int atmel_tdes_write_ctrl(struct atmel_tdes_dev *dd)
+{
+	int err;
+	u32 valcr =3D 0, valmr =3D TDES_MR_SMOD_PDC;
+
+	err =3D atmel_tdes_hw_init(dd);
+
+	if (err)
+		return err;
+
+	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
+
+	/* MR register must be set before IV registers */
+	if (dd->ctx->keylen > (DES_KEY_SIZE << 1)) {
+		valmr |=3D TDES_MR_KEYMOD_3KEY;
+		valmr |=3D TDES_MR_TDESMOD_TDES;
+	} else if (dd->ctx->keylen > DES_KEY_SIZE) {
+		valmr |=3D TDES_MR_KEYMOD_2KEY;
+		valmr |=3D TDES_MR_TDESMOD_TDES;
+	} else {
+		valmr |=3D TDES_MR_TDESMOD_DES;
+	}
+
+	if (dd->flags & TDES_FLAGS_CBC) {
+		valmr |=3D TDES_MR_OPMOD_CBC;
+	} else if (dd->flags & TDES_FLAGS_CFB) {
+		valmr |=3D TDES_MR_OPMOD_CFB;
+
+		if (dd->flags & TDES_FLAGS_CFB8)
+			valmr |=3D TDES_MR_CFBS_8b;
+		else if (dd->flags & TDES_FLAGS_CFB16)
+			valmr |=3D TDES_MR_CFBS_16b;
+		else if (dd->flags & TDES_FLAGS_CFB32)
+			valmr |=3D TDES_MR_CFBS_32b;
+	} else if (dd->flags & TDES_FLAGS_OFB) {
+		valmr |=3D TDES_MR_OPMOD_OFB;
+	}
+
+	if ((dd->flags & TDES_FLAGS_ENCRYPT) || (dd->flags & TDES_FLAGS_OFB))
+		valmr |=3D TDES_MR_CYPHER_ENC;
+
+	atmel_tdes_write(dd, TDES_CR, valcr);
+	atmel_tdes_write(dd, TDES_MR, valmr);
+
+	atmel_tdes_write_n(dd, TDES_KEY1W1R, dd->ctx->key,
+						dd->ctx->keylen >> 2);
+
+	if (((dd->flags & TDES_FLAGS_CBC) || (dd->flags & TDES_FLAGS_CFB) ||
+		(dd->flags & TDES_FLAGS_OFB)) && dd->req->info) {
+		atmel_tdes_write_n(dd, TDES_IV1R, dd->req->info, 2);
+	}
+
+	return 0;
+}
+
+static int atmel_tdes_crypt_dma_stop(struct atmel_tdes_dev *dd)
+{
+	int err =3D 0;
+	size_t count;
+
+	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
+
+	if (dd->flags & TDES_FLAGS_FAST) {
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
+		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+	} else {
+		dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
+					   dd->dma_size, DMA_FROM_DEVICE);
+
+		/* copy data */
+		count =3D atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
+				dd->buf_out, dd->buflen, dd->dma_size, 1);
+		if (count !=3D dd->dma_size) {
+			err =3D -EINVAL;
+			pr_err("not all data converted: %u\n", count);
+		}
+	}
+
+	return err;
+}
+
+static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd)
+{
+	int err =3D -ENOMEM;
+
+	dd->buf_in =3D (void *)__get_free_pages(GFP_KERNEL, 0);
+	dd->buf_out =3D (void *)__get_free_pages(GFP_KERNEL, 0);
+	dd->buflen =3D PAGE_SIZE;
+	dd->buflen &=3D ~(DES_BLOCK_SIZE - 1);
+
+	if (!dd->buf_in || !dd->buf_out) {
+		dev_err(dd->dev, "unable to alloc pages.\n");
+		goto err_alloc;
+	}
+
+	/* MAP here */
+	dd->dma_addr_in =3D dma_map_single(dd->dev, dd->buf_in,
+					dd->buflen, DMA_TO_DEVICE);
+	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
+		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		err =3D -EINVAL;
+		goto err_map_in;
+	}
+
+	dd->dma_addr_out =3D dma_map_single(dd->dev, dd->buf_out,
+					dd->buflen, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
+		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		err =3D -EINVAL;
+		goto err_map_out;
+	}
+
+	return 0;
+
+err_map_out:
+	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
+		DMA_TO_DEVICE);
+err_map_in:
+	free_page((unsigned long)dd->buf_out);
+	free_page((unsigned long)dd->buf_in);
+err_alloc:
+	if (err)
+		pr_err("error: %d\n", err);
+	return err;
+}
+
+static void atmel_tdes_dma_cleanup(struct atmel_tdes_dev *dd)
+{
+	dma_unmap_single(dd->dev, dd->dma_addr_out, dd->buflen,
+			 DMA_FROM_DEVICE);
+	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
+		DMA_TO_DEVICE);
+	free_page((unsigned long)dd->buf_out);
+	free_page((unsigned long)dd->buf_in);
+}
+
+static int atmel_tdes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma=
_addr_in,
+			       dma_addr_t dma_addr_out, int length)
+{
+	struct atmel_tdes_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	struct atmel_tdes_dev *dd =3D ctx->dd;
+	int len32;
+
+	dd->dma_size =3D length;
+
+	if (!(dd->flags & TDES_FLAGS_FAST)) {
+		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
+					   DMA_TO_DEVICE);
+	}
+
+	if ((dd->flags & TDES_FLAGS_CFB) && (dd->flags & TDES_FLAGS_CFB8))
+		len32 =3D DIV_ROUND_UP(length, sizeof(u8));
+	else if ((dd->flags & TDES_FLAGS_CFB) && (dd->flags & TDES_FLAGS_CFB1=
6))
+		len32 =3D DIV_ROUND_UP(length, sizeof(u16));
+	else
+		len32 =3D DIV_ROUND_UP(length, sizeof(u32));
+
+	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
+	atmel_tdes_write(dd, TDES_TPR, dma_addr_in);
+	atmel_tdes_write(dd, TDES_TCR, len32);
+	atmel_tdes_write(dd, TDES_RPR, dma_addr_out);
+	atmel_tdes_write(dd, TDES_RCR, len32);
+
+	/* Enable Interrupt */
+	atmel_tdes_write(dd, TDES_IER, TDES_INT_ENDRX);
+
+	/* Start DMA transfer */
+	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTEN | TDES_PTCR_RXTEN);
+
+	return 0;
+}
+
+static int atmel_tdes_crypt_dma_start(struct atmel_tdes_dev *dd)
+{
+	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(
+					crypto_ablkcipher_reqtfm(dd->req));
+	int err, fast =3D 0, in, out;
+	size_t count;
+	dma_addr_t addr_in, addr_out;
+
+	if (sg_is_last(dd->in_sg) && sg_is_last(dd->out_sg)) {
+		/* check for alignment */
+		in =3D IS_ALIGNED((u32)dd->in_sg->offset, sizeof(u32));
+		out =3D IS_ALIGNED((u32)dd->out_sg->offset, sizeof(u32));
+
+		fast =3D in && out;
+	}
+
+	if (fast)  {
+		count =3D min(dd->total, sg_dma_len(dd->in_sg));
+		count =3D min(count, sg_dma_len(dd->out_sg));
+
+		if (count !=3D dd->total) {
+			pr_err("request length !=3D buffer length\n");
+			return -EINVAL;
+		}
+
+		err =3D dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+		if (!err) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			return -EINVAL;
+		}
+
+		err =3D dma_map_sg(dd->dev, dd->out_sg, 1,
+				DMA_FROM_DEVICE);
+		if (!err) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			dma_unmap_sg(dd->dev, dd->in_sg, 1,
+				DMA_TO_DEVICE);
+			return -EINVAL;
+		}
+
+		addr_in =3D sg_dma_address(dd->in_sg);
+		addr_out =3D sg_dma_address(dd->out_sg);
+
+		dd->flags |=3D TDES_FLAGS_FAST;
+
+	} else {
+		/* use cache buffers */
+		count =3D atmel_tdes_sg_copy(&dd->in_sg, &dd->in_offset,
+				dd->buf_in, dd->buflen, dd->total, 0);
+
+		addr_in =3D dd->dma_addr_in;
+		addr_out =3D dd->dma_addr_out;
+
+		dd->flags &=3D ~TDES_FLAGS_FAST;
+
+	}
+
+	dd->total -=3D count;
+
+	err =3D atmel_tdes_crypt_dma(tfm, addr_in, addr_out, count);
+	if (err) {
+		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+	}
+
+	return err;
+}
+
+
+static void atmel_tdes_finish_req(struct atmel_tdes_dev *dd, int err)
+{
+	struct ablkcipher_request *req =3D dd->req;
+
+	clk_disable_unprepare(dd->iclk);
+
+	dd->flags &=3D ~TDES_FLAGS_BUSY;
+
+	req->base.complete(&req->base, err);
+}
+
+static int atmel_tdes_handle_queue(struct atmel_tdes_dev *dd,
+			       struct ablkcipher_request *req)
+{
+	struct crypto_async_request *async_req, *backlog;
+	struct atmel_tdes_ctx *ctx;
+	struct atmel_tdes_reqctx *rctx;
+	unsigned long flags;
+	int err, ret =3D 0;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	if (req)
+		ret =3D ablkcipher_enqueue_request(&dd->queue, req);
+	if (dd->flags & TDES_FLAGS_BUSY) {
+		spin_unlock_irqrestore(&dd->lock, flags);
+		return ret;
+	}
+	backlog =3D crypto_get_backlog(&dd->queue);
+	async_req =3D crypto_dequeue_request(&dd->queue);
+	if (async_req)
+		dd->flags |=3D TDES_FLAGS_BUSY;
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
+	dd->in_offset =3D 0;
+	dd->in_sg =3D req->src;
+	dd->out_offset =3D 0;
+	dd->out_sg =3D req->dst;
+
+	rctx =3D ablkcipher_request_ctx(req);
+	ctx =3D crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	rctx->mode &=3D TDES_FLAGS_MODE_MASK;
+	dd->flags =3D (dd->flags & ~TDES_FLAGS_MODE_MASK) | rctx->mode;
+	dd->ctx =3D ctx;
+	ctx->dd =3D dd;
+
+	err =3D atmel_tdes_write_ctrl(dd);
+	if (!err)
+		err =3D atmel_tdes_crypt_dma_start(dd);
+	if (err) {
+		/* des_task will not finish it, so do it here */
+		atmel_tdes_finish_req(dd, err);
+		tasklet_schedule(&dd->queue_task);
+	}
+
+	return ret;
+}
+
+
+static int atmel_tdes_crypt(struct ablkcipher_request *req, unsigned l=
ong mode)
+{
+	struct atmel_tdes_ctx *ctx =3D crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(req));
+	struct atmel_tdes_reqctx *rctx =3D ablkcipher_request_ctx(req);
+	struct atmel_tdes_dev *dd;
+
+	if (mode & TDES_FLAGS_CFB8) {
+		if (!IS_ALIGNED(req->nbytes, CFB8_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of CFB8 blocks\n");
+			return -EINVAL;
+		}
+	} else if (mode & TDES_FLAGS_CFB16) {
+		if (!IS_ALIGNED(req->nbytes, CFB16_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of CFB16 blocks\n");
+			return -EINVAL;
+		}
+	} else if (mode & TDES_FLAGS_CFB32) {
+		if (!IS_ALIGNED(req->nbytes, CFB32_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of CFB32 blocks\n");
+			return -EINVAL;
+		}
+	} else if (!IS_ALIGNED(req->nbytes, DES_BLOCK_SIZE)) {
+		pr_err("request size is not exact amount of DES blocks\n");
+		return -EINVAL;
+	}
+
+	dd =3D atmel_tdes_find_dev(ctx);
+	if (!dd)
+		return -ENODEV;
+
+	rctx->mode =3D mode;
+
+	return atmel_tdes_handle_queue(dd, req);
+}
+
+static int atmel_des_setkey(struct crypto_ablkcipher *tfm, const u8 *k=
ey,
+			   unsigned int keylen)
+{
+	u32 tmp[DES_EXPKEY_WORDS];
+	int err;
+	struct crypto_tfm *ctfm =3D crypto_ablkcipher_tfm(tfm);
+
+	struct atmel_tdes_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
+
+	if (keylen !=3D DES_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	err =3D des_ekey(tmp, key);
+	if (err =3D=3D 0 && (ctfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		ctfm->crt_flags |=3D CRYPTO_TFM_RES_WEAK_KEY;
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen =3D keylen;
+
+	return 0;
+}
+
+static int atmel_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *=
key,
+			   unsigned int keylen)
+{
+	struct atmel_tdes_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
+	const char *alg_name;
+
+	alg_name =3D crypto_tfm_alg_name(crypto_ablkcipher_tfm(tfm));
+
+	/*
+	 * HW bug in cfb 3-keys mode.
+	 */
+	if (strstr(alg_name, "cfb") && (keylen !=3D 2*DES_KEY_SIZE)) {
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	} else if ((keylen !=3D 2*DES_KEY_SIZE) && (keylen !=3D 3*DES_KEY_SIZ=
E)) {
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
+static int atmel_tdes_ecb_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT);
+}
+
+static int atmel_tdes_ecb_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, 0);
+}
+
+static int atmel_tdes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CBC);
+}
+
+static int atmel_tdes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_CBC);
+}
+static int atmel_tdes_cfb_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB);
+}
+
+static int atmel_tdes_cfb_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB);
+}
+
+static int atmel_tdes_cfb8_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
+						TDES_FLAGS_CFB8);
+}
+
+static int atmel_tdes_cfb8_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB8);
+}
+
+static int atmel_tdes_cfb16_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
+						TDES_FLAGS_CFB16);
+}
+
+static int atmel_tdes_cfb16_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB16);
+}
+
+static int atmel_tdes_cfb32_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
+						TDES_FLAGS_CFB32);
+}
+
+static int atmel_tdes_cfb32_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB32);
+}
+
+static int atmel_tdes_ofb_encrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_OFB);
+}
+
+static int atmel_tdes_ofb_decrypt(struct ablkcipher_request *req)
+{
+	return atmel_tdes_crypt(req, TDES_FLAGS_OFB);
+}
+
+static int atmel_tdes_cra_init(struct crypto_tfm *tfm)
+{
+	tfm->crt_ablkcipher.reqsize =3D sizeof(struct atmel_tdes_reqctx);
+
+	return 0;
+}
+
+static void atmel_tdes_cra_exit(struct crypto_tfm *tfm)
+{
+}
+
+static struct crypto_alg tdes_algs[] =3D {
+{
+	.cra_name		=3D "ecb(des)",
+	.cra_driver_name	=3D "atmel-ecb-des",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D DES_KEY_SIZE,
+		.max_keysize	=3D DES_KEY_SIZE,
+		.setkey		=3D atmel_des_setkey,
+		.encrypt	=3D atmel_tdes_ecb_encrypt,
+		.decrypt	=3D atmel_tdes_ecb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cbc(des)",
+	.cra_driver_name	=3D "atmel-cbc-des",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D DES_KEY_SIZE,
+		.max_keysize	=3D DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_des_setkey,
+		.encrypt	=3D atmel_tdes_cbc_encrypt,
+		.decrypt	=3D atmel_tdes_cbc_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb(des)",
+	.cra_driver_name	=3D "atmel-cfb-des",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D DES_KEY_SIZE,
+		.max_keysize	=3D DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_des_setkey,
+		.encrypt	=3D atmel_tdes_cfb_encrypt,
+		.decrypt	=3D atmel_tdes_cfb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb8(des)",
+	.cra_driver_name	=3D "atmel-cfb8-des",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB8_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D DES_KEY_SIZE,
+		.max_keysize	=3D DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_des_setkey,
+		.encrypt	=3D atmel_tdes_cfb8_encrypt,
+		.decrypt	=3D atmel_tdes_cfb8_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb16(des)",
+	.cra_driver_name	=3D "atmel-cfb16-des",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB16_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D DES_KEY_SIZE,
+		.max_keysize	=3D DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_des_setkey,
+		.encrypt	=3D atmel_tdes_cfb16_encrypt,
+		.decrypt	=3D atmel_tdes_cfb16_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb32(des)",
+	.cra_driver_name	=3D "atmel-cfb32-des",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB32_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D DES_KEY_SIZE,
+		.max_keysize	=3D DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_des_setkey,
+		.encrypt	=3D atmel_tdes_cfb32_encrypt,
+		.decrypt	=3D atmel_tdes_cfb32_decrypt,
+	}
+},
+{
+	.cra_name		=3D "ofb(des)",
+	.cra_driver_name	=3D "atmel-ofb-des",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D DES_KEY_SIZE,
+		.max_keysize	=3D DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_des_setkey,
+		.encrypt	=3D atmel_tdes_ofb_encrypt,
+		.decrypt	=3D atmel_tdes_ofb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "ecb(des3_ede)",
+	.cra_driver_name	=3D "atmel-ecb-tdes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D 2 * DES_KEY_SIZE,
+		.max_keysize	=3D 3 * DES_KEY_SIZE,
+		.setkey		=3D atmel_tdes_setkey,
+		.encrypt	=3D atmel_tdes_ecb_encrypt,
+		.decrypt	=3D atmel_tdes_ecb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cbc(des3_ede)",
+	.cra_driver_name	=3D "atmel-cbc-tdes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D 2*DES_KEY_SIZE,
+		.max_keysize	=3D 3*DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_tdes_setkey,
+		.encrypt	=3D atmel_tdes_cbc_encrypt,
+		.decrypt	=3D atmel_tdes_cbc_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb(des3_ede)",
+	.cra_driver_name	=3D "atmel-cfb-tdes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D 2*DES_KEY_SIZE,
+		.max_keysize	=3D 2*DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_tdes_setkey,
+		.encrypt	=3D atmel_tdes_cfb_encrypt,
+		.decrypt	=3D atmel_tdes_cfb_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb8(des3_ede)",
+	.cra_driver_name	=3D "atmel-cfb8-tdes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB8_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D 2*DES_KEY_SIZE,
+		.max_keysize	=3D 2*DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_tdes_setkey,
+		.encrypt	=3D atmel_tdes_cfb8_encrypt,
+		.decrypt	=3D atmel_tdes_cfb8_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb16(des3_ede)",
+	.cra_driver_name	=3D "atmel-cfb16-tdes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB16_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D 2*DES_KEY_SIZE,
+		.max_keysize	=3D 2*DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_tdes_setkey,
+		.encrypt	=3D atmel_tdes_cfb16_encrypt,
+		.decrypt	=3D atmel_tdes_cfb16_decrypt,
+	}
+},
+{
+	.cra_name		=3D "cfb32(des3_ede)",
+	.cra_driver_name	=3D "atmel-cfb32-tdes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D CFB32_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D 2*DES_KEY_SIZE,
+		.max_keysize	=3D 2*DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_tdes_setkey,
+		.encrypt	=3D atmel_tdes_cfb32_encrypt,
+		.decrypt	=3D atmel_tdes_cfb32_decrypt,
+	}
+},
+{
+	.cra_name		=3D "ofb(des3_ede)",
+	.cra_driver_name	=3D "atmel-ofb-tdes",
+	.cra_priority		=3D 100,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D DES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct atmel_tdes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_init		=3D atmel_tdes_cra_init,
+	.cra_exit		=3D atmel_tdes_cra_exit,
+	.cra_u.ablkcipher =3D {
+		.min_keysize	=3D 2*DES_KEY_SIZE,
+		.max_keysize	=3D 3*DES_KEY_SIZE,
+		.ivsize		=3D DES_BLOCK_SIZE,
+		.setkey		=3D atmel_tdes_setkey,
+		.encrypt	=3D atmel_tdes_ofb_encrypt,
+		.decrypt	=3D atmel_tdes_ofb_decrypt,
+	}
+},
+};
+
+static void atmel_tdes_queue_task(unsigned long data)
+{
+	struct atmel_tdes_dev *dd =3D (struct atmel_tdes_dev *)data;
+
+	atmel_tdes_handle_queue(dd, NULL);
+}
+
+static void atmel_tdes_done_task(unsigned long data)
+{
+	struct atmel_tdes_dev *dd =3D (struct atmel_tdes_dev *) data;
+	int err;
+
+	err =3D atmel_tdes_crypt_dma_stop(dd);
+
+	err =3D dd->err ? : err;
+
+	if (dd->total && !err) {
+		err =3D atmel_tdes_crypt_dma_start(dd);
+		if (!err)
+			return;
+	}
+
+	atmel_tdes_finish_req(dd, err);
+	atmel_tdes_handle_queue(dd, NULL);
+}
+
+static irqreturn_t atmel_tdes_irq(int irq, void *dev_id)
+{
+	struct atmel_tdes_dev *tdes_dd =3D dev_id;
+	u32 reg;
+
+	reg =3D atmel_tdes_read(tdes_dd, TDES_ISR);
+	if (reg & atmel_tdes_read(tdes_dd, TDES_IMR)) {
+		atmel_tdes_write(tdes_dd, TDES_IDR, reg);
+		if (TDES_FLAGS_BUSY & tdes_dd->flags)
+			tasklet_schedule(&tdes_dd->done_task);
+		else
+			dev_warn(tdes_dd->dev, "TDES interrupt when no active requests.\n")=
;
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void atmel_tdes_unregister_algs(struct atmel_tdes_dev *dd)
+{
+	int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(tdes_algs); i++)
+		crypto_unregister_alg(&tdes_algs[i]);
+}
+
+static int atmel_tdes_register_algs(struct atmel_tdes_dev *dd)
+{
+	int err, i, j;
+
+	for (i =3D 0; i < ARRAY_SIZE(tdes_algs); i++) {
+		INIT_LIST_HEAD(&tdes_algs[i].cra_list);
+		err =3D crypto_register_alg(&tdes_algs[i]);
+		if (err)
+			goto err_tdes_algs;
+	}
+
+	return 0;
+
+err_tdes_algs:
+	for (j =3D 0; j < i; j++)
+		crypto_unregister_alg(&tdes_algs[j]);
+
+	return err;
+}
+
+static int __devinit atmel_tdes_probe(struct platform_device *pdev)
+{
+	struct atmel_tdes_dev *tdes_dd;
+	struct device *dev =3D &pdev->dev;
+	struct resource *tdes_res;
+	unsigned long tdes_phys_size;
+	int err;
+
+	tdes_dd =3D kzalloc(sizeof(struct atmel_tdes_dev), GFP_KERNEL);
+	if (tdes_dd =3D=3D NULL) {
+		dev_err(dev, "unable to alloc data struct.\n");
+		err =3D -ENOMEM;
+		goto tdes_dd_err;
+	}
+
+	tdes_dd->dev =3D dev;
+
+	platform_set_drvdata(pdev, tdes_dd);
+
+	INIT_LIST_HEAD(&tdes_dd->list);
+
+	tasklet_init(&tdes_dd->done_task, atmel_tdes_done_task,
+					(unsigned long)tdes_dd);
+	tasklet_init(&tdes_dd->queue_task, atmel_tdes_queue_task,
+					(unsigned long)tdes_dd);
+
+	crypto_init_queue(&tdes_dd->queue, ATMEL_TDES_QUEUE_LENGTH);
+
+	tdes_dd->irq =3D -1;
+
+	/* Get the base address */
+	tdes_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!tdes_res) {
+		dev_err(dev, "no MEM resource info\n");
+		err =3D -ENODEV;
+		goto res_err;
+	}
+	tdes_dd->phys_base =3D tdes_res->start;
+	tdes_phys_size =3D resource_size(tdes_res);
+
+	/* Get the IRQ */
+	tdes_dd->irq =3D platform_get_irq(pdev,  0);
+	if (tdes_dd->irq < 0) {
+		dev_err(dev, "no IRQ resource info\n");
+		err =3D tdes_dd->irq;
+		goto res_err;
+	}
+
+	err =3D request_irq(tdes_dd->irq, atmel_tdes_irq, IRQF_SHARED,
+			"atmel-tdes", tdes_dd);
+	if (err) {
+		dev_err(dev, "unable to request tdes irq.\n");
+		goto tdes_irq_err;
+	}
+
+	/* Initializing the clock */
+	tdes_dd->iclk =3D clk_get(&pdev->dev, NULL);
+	if (IS_ERR(tdes_dd->iclk)) {
+		dev_err(dev, "clock intialization failed.\n");
+		err =3D PTR_ERR(tdes_dd->iclk);
+		goto clk_err;
+	}
+
+	tdes_dd->io_base =3D ioremap(tdes_dd->phys_base, tdes_phys_size);
+	if (!tdes_dd->io_base) {
+		dev_err(dev, "can't ioremap\n");
+		err =3D -ENOMEM;
+		goto tdes_io_err;
+	}
+
+	err =3D atmel_tdes_dma_init(tdes_dd);
+	if (err)
+		goto err_tdes_dma;
+
+	spin_lock(&atmel_tdes.lock);
+	list_add_tail(&tdes_dd->list, &atmel_tdes.dev_list);
+	spin_unlock(&atmel_tdes.lock);
+
+	err =3D atmel_tdes_register_algs(tdes_dd);
+	if (err)
+		goto err_algs;
+
+	dev_info(dev, "Atmel DES/TDES\n");
+
+	return 0;
+
+err_algs:
+	spin_lock(&atmel_tdes.lock);
+	list_del(&tdes_dd->list);
+	spin_unlock(&atmel_tdes.lock);
+	atmel_tdes_dma_cleanup(tdes_dd);
+err_tdes_dma:
+	iounmap(tdes_dd->io_base);
+tdes_io_err:
+	clk_put(tdes_dd->iclk);
+clk_err:
+	free_irq(tdes_dd->irq, tdes_dd);
+tdes_irq_err:
+res_err:
+	tasklet_kill(&tdes_dd->done_task);
+	tasklet_kill(&tdes_dd->queue_task);
+	kfree(tdes_dd);
+	tdes_dd =3D NULL;
+tdes_dd_err:
+	dev_err(dev, "initialization failed.\n");
+
+	return err;
+}
+
+static int __devexit atmel_tdes_remove(struct platform_device *pdev)
+{
+	static struct atmel_tdes_dev *tdes_dd;
+
+	tdes_dd =3D platform_get_drvdata(pdev);
+	if (!tdes_dd)
+		return -ENODEV;
+	spin_lock(&atmel_tdes.lock);
+	list_del(&tdes_dd->list);
+	spin_unlock(&atmel_tdes.lock);
+
+	atmel_tdes_unregister_algs(tdes_dd);
+
+	tasklet_kill(&tdes_dd->done_task);
+	tasklet_kill(&tdes_dd->queue_task);
+
+	atmel_tdes_dma_cleanup(tdes_dd);
+
+	iounmap(tdes_dd->io_base);
+
+	clk_put(tdes_dd->iclk);
+
+	if (tdes_dd->irq >=3D 0)
+		free_irq(tdes_dd->irq, tdes_dd);
+
+	kfree(tdes_dd);
+	tdes_dd =3D NULL;
+
+	return 0;
+}
+
+static struct platform_driver atmel_tdes_driver =3D {
+	.probe		=3D atmel_tdes_probe,
+	.remove		=3D __devexit_p(atmel_tdes_remove),
+	.driver		=3D {
+		.name	=3D "atmel_tdes",
+		.owner	=3D THIS_MODULE,
+	},
+};
+
+module_platform_driver(atmel_tdes_driver);
+
+MODULE_DESCRIPTION("Atmel DES/TDES hw acceleration support.");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Nicolas Royer - Eukr=C3=A9a Electromatique");
--=20
1.7.7.6
