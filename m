From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Subject: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Fri, 11 Jun 2010 21:49:21 +0200
Message-ID: <4C129341.2060407@gmail.com>
References: <cover.1276284559.git.mcuelenaere@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <cover.1276284559.git.mcuelenaere@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds support for the Samsung crypto engine driver available in the
S3C64XX and S5PC100 SoCs. Currently this supports AES and (T)DES with ECB and
CBC block ciphers (also CTR for AES). Support for (HMAC)-SHA1 acceleration is
also available in this engine, but isn't used in the driver yet.

Support for DMA has been added in the code but is currently disabled due to
issues with data transfers.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
---
 drivers/crypto/Kconfig   |   11 +
 drivers/crypto/Makefile  |    1 +
 drivers/crypto/s3c-sss.c | 1320 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1332 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/s3c-sss.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b08403d..597a151 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -222,4 +222,15 @@ config CRYPTO_DEV_PPC4XX
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
 
+config CRYPTO_DEV_SSS
+	tristate "Samsung Security Sub-Systems"
+	depends on SAMSUNG_DEV_SSS
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_DES
+	select CRYPTO_HASH
+	help
+	    This driver utilizes the cryptographic engine in Samsung S3C64XX
+	    and S5PC100 SoCs.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6ffcb3f..ef14b4d 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
+obj-$(CONFIG_CRYPTO_DEV_SSS) += s3c-sss.o
diff --git a/drivers/crypto/s3c-sss.c b/drivers/crypto/s3c-sss.c
new file mode 100644
index 0000000..9fd5288
--- /dev/null
+++ b/drivers/crypto/s3c-sss.c
@@ -0,0 +1,1320 @@
+/*
+ * linux/drivers/crypto/s3c-sss.c
+ *
+ * Copyright (C) 2010 Maurus Cuelenaere
+ *
+ * Support for S3C64XX Security Sub-Systems
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/*#define DEBUG*/
+
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+
+#include <crypto/internal/hash.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/ctr.h>
+#include <crypto/des.h>
+#include <crypto/sha.h>
+#include <crypto/scatterwalk.h>
+
+#include <mach/dma.h>
+
+#include <plat/regs-sss.h>
+
+#define SSS_CRA_PRIORITY	300
+#define SSS_MAX_KEY_SIZE	AES_MAX_KEY_SIZE
+#define SSS_FIFO_SIZE		0x40U
+#define SSS_TIMEOUT		(3*HZ)
+
+/**
+ * struct s3c_sss - driver state.
+ * @dev: pointer to the device struct
+ * @clock: clock associated with peripheral
+ * @irq: irq associated with peripheral
+ * @regs: pointer to mapped registers
+ * @regs_phys: pointer to physical address of registers
+ * @regs_res: pointer to struct resource representing registers
+ * @cur_req: pointer to pending request (NULL indicates no current request)
+ * @dma_client: struct used for passing to DMA core
+ * @lock: lock used for synchronizing queue accesses
+ * @tasklet: tasklet doing the main work
+ * @timer: timer used for timing out faulty requests
+ * @queue: queue containing requests
+ */
+struct s3c_sss {
+	struct device			*dev;
+
+	struct clk			*clock;
+	int				irq;
+	void __iomem			*regs;
+	void __iomem			*regs_phys;
+	struct resource			*regs_res;
+
+	struct ablkcipher_request	*cur_req;
+	struct s3c2410_dma_client	dma_client;
+	spinlock_t			lock;
+	struct tasklet_struct		tasklet;
+	struct timer_list		timer;
+	struct crypto_queue		queue;
+};
+
+/**
+ * struct sss_context - cipher/hash key state
+ * @key: storage for the key
+ * @key_len: length of the key
+ * @dev: pointer to struct containing the driver state
+ */
+struct sss_context {
+	u8				key[SSS_MAX_KEY_SIZE];
+	unsigned int			key_len;
+
+	struct s3c_sss			*dev;
+};
+
+/**
+ * struct sss_fifo_channel - FIFO handling state
+ *
+ * @cur_sg: scatterlist used in current transfer
+ * @offset: offset within current scatterlist
+ * @dir: FIFO direction
+ * @sg: pointer to scatter-gather lists
+ * @sg_count: amount of scatter-gather lists
+ * @req_size: size of current request
+ * @bytes_done: amount of data transferred
+ * @dev: pointer to struct containing the driver state
+ */
+struct sss_fifo_channel {
+	/* DMA */
+	struct scatterlist		*cur_sg;
+	int				offset;
+	int				sg_count;
+
+	/* generic */
+	enum {
+		FIFO_RX,
+		FIFO_TX
+	}				dir;
+	struct scatterlist		*sg;
+	size_t				req_size;
+	size_t				bytes_done;
+	struct s3c_sss			*dev;
+};
+
+/**
+ * struct sss_req_context - driver-specific data associated with a request
+ * @algorithm: algorithm used in request
+ * @blk_cipher: block cipher used in request
+ * @direction: whether to encrypt or decrypt
+ * @rx: RX FIFO channel, see struct sss_fifo_channel
+ * @tx: TX FIFO channel, see struct sss_fifo_channel
+ * @setup_done: whether hardware has been set up
+ * @err: indicates any occured error during request
+ */
+struct sss_req_context {
+	enum sss_algorithm {
+		ALGO_AES,
+		ALGO_DES,
+		ALGO_TDES,
+		ALGO_SHA1,
+		ALGO_HMAC_SHA1,
+	}				algorithm;
+	enum sss_block_cipher {
+		CIPH_ECB,
+		CIPH_CBC,
+		CIPH_CTR,
+	}				blk_cipher;
+	enum sss_direction {
+		ENCRYPT,
+		DECRYPT,
+	}				direction;
+
+	struct sss_fifo_channel		rx;
+	struct sss_fifo_channel		tx;
+	bool				setup_done;
+	int				err;
+};
+
+/**
+ * struct sss_crypto_wrapper - simple wrapper for easy access to the driver data
+ * @alg: wrapped crypto algorithm
+ * @dev: pointer to the driver state
+ */
+struct sss_crypto_wrapper {
+	struct crypto_alg		 alg;
+	struct s3c_sss			*dev;
+};
+
+/*** Helper functions ***/
+
+#define fifo_to_req_ctx(fifo, dir) container_of((fifo), \
+						struct sss_req_context, dir)
+
+static inline struct sss_req_context *sss_to_req_ctx(struct s3c_sss *sss)
+{
+	struct ablkcipher_request *req = sss->cur_req;
+	return req ? ablkcipher_request_ctx(req) : NULL;
+}
+
+static inline unsigned int fifo_to_dma_channel(struct sss_fifo_channel *chan)
+{
+	return chan->dir == FIFO_TX ? DMACH_SECURITY_TX : DMACH_SECURITY_RX;
+}
+
+static inline bool sss_dma_enabled(void)
+{
+	/* DMA is disabled till someone figures out why it's not transmitting
+	   all data to the crypto engine. */
+	return false;
+}
+
+static int count_sgs(struct scatterlist *sg)
+{
+	int i;
+
+	for (i = 0; sg; i++)
+		sg = sg_next(sg);
+
+	return i;
+}
+
+static inline void orrl(u32 val, void __iomem *reg)
+{
+	writel(readl(reg) | val, reg);
+}
+
+#ifdef DEBUG
+static void sss_dump_regs(struct s3c_sss *sss)
+{
+	dev_dbg(sss->dev, "DnI_CFG: %x\n", readl(sss->regs + DnI_CFG));
+
+	dev_dbg(sss->dev, "FRx_Ctrl: %x\n", readl(sss->regs + FRx_Ctrl));
+	dev_dbg(sss->dev, "FRx_MLen: %x\n", readl(sss->regs + FRx_MLen));
+	dev_dbg(sss->dev, "FRx_BlkSz: %x\n", readl(sss->regs + FRx_BlkSz));
+	dev_dbg(sss->dev, "FRx_Addr: %x\n", readl(sss->regs + FRx_Addr));
+	dev_dbg(sss->dev, "FRx_MLenCnt: %x\n", readl(sss->regs + FRx_MLenCnt));
+
+	dev_dbg(sss->dev, "FTx_Ctrl: %x\n", readl(sss->regs + FTx_Ctrl));
+	dev_dbg(sss->dev, "FTx_MLen: %x\n", readl(sss->regs + FTx_MLen));
+	dev_dbg(sss->dev, "FTx_BlkSz: %x\n", readl(sss->regs + FTx_BlkSz));
+	dev_dbg(sss->dev, "FTx_Addr: %x\n", readl(sss->regs + FTx_Addr));
+	dev_dbg(sss->dev, "FTx_MLenCnt: %x\n", readl(sss->regs + FTx_MLenCnt));
+
+	dev_dbg(sss->dev, "AES_CTRL: %x\n", readl(sss->regs + AES_CTRL));
+	dev_dbg(sss->dev, "TDES_CTRL: %x\n", readl(sss->regs + TDES_CTRL));
+	dev_dbg(sss->dev, "HASH_CTRL: %x\n", readl(sss->regs + HASH_CTRL));
+	dev_dbg(sss->dev, "HASH_STATUS: %x\n", readl(sss->regs + HASH_STATUS));
+}
+#else
+#define sss_dump_regs(...)
+#endif
+
+#ifdef DEBUG
+static void sss_dump_channel(struct sss_fifo_channel *chan)
+{
+	struct s3c_sss *sss = chan->dev;
+	bool tx = (chan->dir == FIFO_TX);
+	u32 val;
+
+	val = readl(sss->regs + (tx ? FTx_Ctrl : FRx_Ctrl));
+
+	dev_dbg(sss->dev, "FIFO_%cX: %c%c%c%c%c\n", tx ? 'T' : 'R',
+		val & FXx_Ctrl_Full ? 'F' : ' ',
+		val & FXx_Ctrl_Empty ? 'E' : ' ',
+		val & FXx_Ctrl_Done ? 'D' : ' ',
+		val & FXx_Ctrl_Running ? 'R' : ' ',
+		val & FXx_Ctrl_Start ? 'S' : ' ');
+
+	if (sss_dma_enabled()) {
+		dev_dbg(sss->dev, "      cur_sg: %p\n", chan->cur_sg);
+		dev_dbg(sss->dev, "      offset: %d\n", chan->offset);
+		dev_dbg(sss->dev, "    sg_count: %d\n", chan->sg_count);
+	}
+
+	dev_dbg(sss->dev, "    req_size: %d\n", chan->req_size);
+	dev_dbg(sss->dev, "  bytes_done: %d\n", chan->bytes_done);
+	dev_dbg(sss->dev, "     mlencnt: %d\n",
+		readl(sss->regs + (tx ? FTx_MLenCnt : FRx_MLenCnt)) * 4);
+	dev_dbg(sss->dev, "    wd2write: %d\n", (val >> tx ? 8 : 16) & 0xFF);
+	dev_dbg(sss->dev, "     wd2read: %d\n", (val >> tx ? 16 : 8) & 0xFF);
+}
+#else
+#define sss_dump_channel(...)
+#endif
+
+static void sss_reset_fifo(struct s3c_sss *sss, int reg)
+{
+	int timeout = 1000;
+	u32 val;
+
+	writel(FXx_Ctrl_Reset, sss->regs + reg);
+
+	while (timeout-- > 0) {
+		val = readl(sss->regs + reg);
+		if (!(val & FXx_Ctrl_Reset))
+			break;
+	}
+
+	if (timeout <= 0)
+		dev_warn(sss->dev, "Failed to reset FIFO_%cX!\n",
+			 reg == FRx_Ctrl ? 'R' : 'T');
+}
+
+static void sss_reset_hw(struct s3c_sss *sss)
+{
+	u32 val = 0;
+
+	if (sss_dma_enabled())
+		val |= (DnI_CFG_RxDmaEnb | DnI_CFG_TxDmaEnb |
+			DnI_CFG_RxTrgLevel(16) | DnI_CFG_TxTrgLevel(16));
+
+	writel(val, sss->regs + DnI_CFG);
+
+	/* Reset FIFOs */
+	sss_reset_fifo(sss, FRx_Ctrl);
+	sss_reset_fifo(sss, FTx_Ctrl);
+
+	/* Ensure all subsystems are disabled */
+	writel(0, sss->regs + AES_CTRL);
+	writel(0, sss->regs + TDES_CTRL);
+	writel(0, sss->regs + HASH_CTRL);
+}
+
+#ifdef DEBUG
+static void check_priv_mismatch(struct s3c_sss *sss, const char* name, int reg)
+{
+	u32 val = readl(sss->regs + reg);
+
+	if (val & RdPrivMismatch)
+		dev_warn(sss->dev, "%s read privilege mismatch! (0x%x)\n", name,
+			 val);
+
+	if (val & WrPrivMismatch)
+		dev_warn(sss->dev, "%s write privilege mismatch! (0x%x)\n",
+			 name, val);
+}
+#else
+#define check_priv_mismatch(...)
+#endif
+
+static irqreturn_t sss_irq(int irq, void *priv)
+{
+	struct s3c_sss *sss = priv;
+	u32 cfg = readl(sss->regs + DnI_CFG);
+
+	check_priv_mismatch(sss, "CONFIG", DnI_CFG);
+
+	if (cfg & DnI_CFG_FRx_Intr_Status) {
+		dev_dbg(sss->dev, "%s: FIFO_RX IRQ\n", __func__);
+		check_priv_mismatch(sss, "FIFO RX", FRx_Ctrl);
+
+		if (sss->cur_req && !sss_dma_enabled()) {
+			struct sss_fifo_channel *ch = &sss_to_req_ctx(sss)->rx;
+			if (ch->req_size) {
+				dev_dbg(sss->dev, "Increasing consumption with "
+						  "%d bytes\n", ch->req_size);
+				ch->bytes_done += ch->req_size;
+				ch->req_size = 0;
+				tasklet_schedule(&sss->tasklet);
+			}
+		}
+	}
+
+	if (cfg & DnI_CFG_FTx_Intr_Status) {
+		dev_dbg(sss->dev, "%s: FIFO_TX IRQ\n", __func__);
+		check_priv_mismatch(sss, "FIFO TX", FTx_Ctrl);
+
+		if (sss->cur_req && !sss_dma_enabled())
+			tasklet_schedule(&sss->tasklet);
+	}
+
+	if (cfg & DnI_CFG_SHA_Intr_Status)
+		dev_dbg(sss->dev, "%s: HASH IRQ\n", __func__);
+
+	if (cfg & DnI_CFG_DES_Intr_Status) {
+		dev_dbg(sss->dev, "%s: TDES IRQ\n", __func__);
+		check_priv_mismatch(sss, "TDES", TDES_CTRL);
+	}
+
+	if (cfg & DnI_CFG_AES_Intr_Status) {
+		dev_dbg(sss->dev, "%s: AES IRQ\n", __func__);
+		check_priv_mismatch(sss, "AES", AES_CTRL);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void sss_dma_cb(struct s3c2410_dma_chan *chan, void *pw, int size,
+		       enum s3c2410_dma_buffresult res)
+{
+	struct sss_fifo_channel *fifo_chan = pw;
+	struct s3c_sss *sss = fifo_chan->dev;
+	struct sss_req_context *req_ctx;
+
+	dev_dbg(sss->dev, "%s: FIFO_%cX\n", __func__,
+		fifo_chan->dir == FIFO_RX ? 'R' : 'T');
+
+	if (fifo_chan->dir == FIFO_RX)
+		req_ctx = fifo_to_req_ctx(fifo_chan, rx);
+	else
+		req_ctx = fifo_to_req_ctx(fifo_chan, tx);
+
+	switch (res) {
+	case S3C2410_RES_OK:
+		fifo_chan->bytes_done += fifo_chan->req_size;
+		fifo_chan->offset += fifo_chan->req_size;
+		fifo_chan->req_size = 0;
+		break;
+	case S3C2410_RES_ERR:
+	case S3C2410_RES_ABORT:
+	default:
+		dev_err(sss->dev, "Error occured during DMA transfer!\n");
+		if (!req_ctx->err)
+			req_ctx->err = -EIO;
+	}
+
+	tasklet_schedule(&sss->tasklet);
+}
+
+static int sss_setup_dma(struct s3c_sss *sss, unsigned int channel)
+{
+	enum s3c2410_dmasrc source;
+	unsigned long reg;
+	int ret;
+
+	ret = s3c2410_dma_request(channel, &sss->dma_client, sss);
+	if (ret < 0)
+		return ret;
+
+	if (channel == DMACH_SECURITY_RX) {
+		reg = (unsigned long)(sss->regs_phys + SDMA_FRx_Buf);
+		source = S3C2410_DMASRC_MEM;
+	} else { /* DMACH_SECURITY_TX */
+		reg = (unsigned long)(sss->regs_phys + SDMA_FTx_Buf);
+		source = S3C2410_DMASRC_HW;
+	}
+
+	s3c2410_dma_config(channel, 4);
+	s3c2410_dma_devconfig(channel, source, reg);
+	s3c2410_dma_set_buffdone_fn(channel, sss_dma_cb);
+
+	return 0;
+}
+
+static void sss_setup_hw(struct s3c_sss *sss)
+{
+	struct ablkcipher_request *req = sss->cur_req;
+	struct sss_context *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct sss_req_context *req_ctx = ablkcipher_request_ctx(req);
+	u32 val, cfg, fifo_rx, fifo_tx;
+
+	dev_dbg(sss->dev, "%s: setting up hw\n", __func__);
+
+	sss_reset_hw(sss);
+
+	cfg = readl(sss->regs + DnI_CFG);
+	cfg |= (DnI_CFG_FTx_Intr_En | DnI_CFG_FRx_Intr_En);
+
+	fifo_rx = (FXx_Ctrl_Host_Rd_En | FXx_Ctrl_Host_Wr_En |
+		   FRx_Ctrl_Sync_Tx);
+	fifo_tx = (FXx_Ctrl_Host_Rd_En | FXx_Ctrl_Host_Wr_En);
+
+	switch (req_ctx->algorithm) {
+	case ALGO_AES:
+		cfg |= DnI_CFG_AES_Intr_En;
+		fifo_rx |= FXx_Ctrl_Module_AES;
+		fifo_tx |= FXx_Ctrl_Module_AES;
+
+		switch (req_ctx->blk_cipher) {
+		case CIPH_ECB:
+			val = AES_CTRL_OpMode_ECB;
+			break;
+		case CIPH_CBC:
+			val = AES_CTRL_OpMode_CBC;
+			memcpy(sss->regs + AES_IV, req->info, 16);
+			break;
+		case CIPH_CTR:
+			val = AES_CTRL_OpMode_CTR;
+			memcpy(sss->regs + AES_CTR, req->info, 16); /* ??? */
+			break;
+		}
+
+		if (req_ctx->direction == DECRYPT &&
+		    req_ctx->blk_cipher != CIPH_CTR)
+			val |= AES_CTRL_OpDirection_Dec;
+
+		switch (ctx->key_len) {
+		case AES_KEYSIZE_128:
+			val |= AES_CTRL_KeyMode_128bits;
+			break;
+		case AES_KEYSIZE_192:
+			val |= AES_CTRL_KeyMode_192bits;
+			break;
+		case AES_KEYSIZE_256:
+			val |= AES_CTRL_KeyMode_256bits;
+			break;
+		}
+		memcpy(sss->regs + AES_KEY, ctx->key, ctx->key_len);
+
+		writel(val, sss->regs + AES_CTRL);
+
+		writel(AES_BLOCK_SIZE / 4, sss->regs + FRx_BlkSz);
+		writel(AES_BLOCK_SIZE / 4, sss->regs + FTx_BlkSz);
+		writel(sss->regs_phys + AES_DIN, sss->regs + FRx_Addr);
+		writel(sss->regs_phys + AES_DOUT, sss->regs + FTx_Addr);
+
+		break;
+	case ALGO_DES:
+	case ALGO_TDES:
+		cfg |= DnI_CFG_DES_Intr_En;
+		fifo_rx |= FXx_Ctrl_Module_DES;
+		fifo_tx |= FXx_Ctrl_Module_DES;
+
+		switch (req_ctx->blk_cipher) {
+		case CIPH_ECB:
+			val = TDES_CTRL_Mode_ECB;
+			break;
+		case CIPH_CBC:
+			val = TDES_CTRL_Mode_CBC;
+			memcpy(sss->regs + TDES_IV, req->info, 16);
+			break;
+		case CIPH_CTR:
+			/* NOP */
+			break;
+		}
+
+		if (req_ctx->direction == DECRYPT)
+			val |= TDES_CTRL_OpDirection_Dec;
+
+		if (req_ctx->algorithm == ALGO_TDES)
+			val |= TDES_CTRL_Mode_Tdes;
+
+		val |= TDES_CTRL_IntMode;
+
+		memcpy(sss->regs + TDES_KEY, ctx->key, ctx->key_len);
+
+		writel(val, sss->regs + TDES_CTRL);
+
+		writel(DES_BLOCK_SIZE / 4, sss->regs + FRx_BlkSz);
+		writel(DES_BLOCK_SIZE / 4, sss->regs + FTx_BlkSz);
+		writel(sss->regs_phys + TDES_INPUT, sss->regs + FRx_Addr);
+		writel(sss->regs_phys + TDES_OUTPUT, sss->regs + FTx_Addr);
+
+		break;
+	case ALGO_SHA1:
+	case ALGO_HMAC_SHA1:
+		cfg |= DnI_CFG_SHA_Intr_En;
+		fifo_rx |= FXx_Ctrl_Module_SHA;
+		fifo_tx |= FXx_Ctrl_Module_SHA;
+
+		/*TODO*/
+
+		break;
+	}
+
+	writel(cfg, sss->regs + DnI_CFG);
+	writel(fifo_rx, sss->regs + FRx_Ctrl);
+	writel(fifo_tx, sss->regs + FTx_Ctrl);
+}
+
+static void sss_setup_hw_mlen(struct sss_fifo_channel *chan, size_t len)
+{
+	struct s3c_sss *sss = chan->dev;
+
+	if (chan->dir == FIFO_RX) {
+		writel(len / 4, sss->regs + FRx_MLen);
+		orrl(FXx_Ctrl_Start, sss->regs + FRx_Ctrl);
+	} else {
+		writel(len / 4, sss->regs + FTx_MLen);
+		orrl(FXx_Ctrl_Start, sss->regs + FTx_Ctrl);
+	}
+}
+
+static int sss_setup_dma_channel(struct sss_fifo_channel *chan)
+{
+	struct s3c_sss *sss = chan->dev;
+	unsigned int channel = fifo_to_dma_channel(chan);
+	int ret;
+
+	if (chan->offset >= sg_dma_len(chan->cur_sg)) {
+		chan->cur_sg = sg_next(chan->cur_sg);
+		chan->offset = 0;
+	}
+
+	chan->req_size = min(sg_dma_len(chan->cur_sg) - chan->offset,
+			     SSS_FIFO_SIZE);
+
+	sss_setup_hw_mlen(chan, chan->req_size);
+
+	dev_dbg(sss->dev, "Enqueue'ing for FIFO_%cX: %x (%d)\n",
+		channel == DMACH_SECURITY_TX ? 'T' : 'R',
+		sg_dma_address(chan->cur_sg) + chan->offset, chan->req_size);
+
+	ret = s3c2410_dma_enqueue(channel, chan,
+				  sg_dma_address(chan->cur_sg) + chan->offset,
+				  chan->req_size);
+	if (ret)
+		return ret;
+
+	return s3c2410_dma_ctrl(fifo_to_dma_channel(chan), S3C2410_DMAOP_START);
+}
+
+static void sss_setup_fifo(struct sss_fifo_channel *chan)
+{
+	struct s3c_sss *sss = chan->dev;
+	struct ablkcipher_request *req = sss->cur_req;
+	enum dma_data_direction dir;
+	unsigned int sg_flags;
+
+	if (chan->dir == FIFO_RX) {
+		sg_flags = SG_MITER_FROM_SG;
+		chan->sg = req->src;
+		dir = DMA_TO_DEVICE;
+	} else {
+		sg_flags = SG_MITER_TO_SG;
+		chan->sg = req->dst;
+		dir = DMA_FROM_DEVICE;
+	}
+
+	if (sss_dma_enabled()) {
+		int sg_count = count_sgs(chan->sg);
+		chan->sg_count = dma_map_sg(sss->dev, chan->sg, sg_count, dir);
+		chan->cur_sg = chan->sg;
+
+		s3c2410_dma_ctrl(fifo_to_dma_channel(chan),
+				 S3C2410_DMAOP_FLUSH);
+	}
+}
+
+static int sss_handle_fifo(struct sss_fifo_channel *chan)
+{
+	struct s3c_sss *sss = chan->dev;
+	struct ablkcipher_request *req = sss->cur_req;
+	void __iomem *fifo;
+
+	if (chan->req_size)
+		/* FIFO is still transferring data */
+		return -EINPROGRESS;
+
+	if (sss_dma_enabled())
+		return sss_setup_dma_channel(chan);
+
+	/* PIO */
+	if (chan->dir == FIFO_RX)
+		fifo = sss->regs + FRx_Buf;
+	else
+		fifo = sss->regs + FTx_Buf;
+
+	chan->req_size = min(req->nbytes - chan->bytes_done, SSS_FIFO_SIZE);
+
+	sss_setup_hw_mlen(chan, chan->req_size);
+
+	dev_dbg(sss->dev, "Transferring %d bytes to FIFO_%s\n", chan->req_size,
+		chan->dir == FIFO_TX ? "TX" : "RX");
+
+	scatterwalk_map_and_copy(fifo, chan->sg, chan->bytes_done,
+				 chan->req_size, (chan->dir == FIFO_TX));
+
+	if (chan->dir == FIFO_TX) {
+		chan->bytes_done += chan->req_size;
+		chan->req_size = 0;
+	}
+
+	return 0;
+}
+
+static void sss_cleanup_fifo(struct sss_fifo_channel *chan)
+{
+	struct s3c_sss *sss = chan->dev;
+	enum dma_data_direction dir;
+
+	if (sss_dma_enabled()) {
+		if (chan->dir == FIFO_RX)
+			dir = DMA_TO_DEVICE;
+		else
+			dir = DMA_FROM_DEVICE;
+
+		dma_unmap_sg(sss->dev, chan->sg, chan->sg_count, dir);
+
+		s3c2410_dma_ctrl(fifo_to_dma_channel(chan), S3C2410_DMAOP_STOP);
+	}
+}
+
+static void sss_timer_callback(unsigned long priv)
+{
+	struct s3c_sss *sss = (struct s3c_sss *)priv;
+	struct sss_req_context *req_ctx = sss_to_req_ctx(sss);
+
+	dev_err(sss->dev, "Request timed out!\n");
+	req_ctx->err = -ETIMEDOUT;
+
+	tasklet_schedule(&sss->tasklet);
+}
+
+static void sss_tasklet_callback(unsigned long priv)
+{
+	struct s3c_sss *sss = (struct s3c_sss *)priv;
+	struct sss_req_context *req_ctx;
+	struct ablkcipher_request *req;
+	unsigned long flags;
+
+	if (!sss->cur_req) {
+		spin_lock_irqsave(&sss->lock, flags);
+		sss->cur_req = ablkcipher_dequeue_request(&sss->queue);
+		spin_unlock_irqrestore(&sss->lock, flags);
+
+		if (!sss->cur_req) {
+			dev_warn(sss->dev, "Tasklet was called without any "
+					   "pending request!\n");
+			return;
+		}
+	}
+
+	/*TODO: backlog*/
+
+	req = sss->cur_req;
+	req_ctx = ablkcipher_request_ctx(req);
+
+	dev_dbg(sss->dev, "Current request: %p (%d)\n", req, req->nbytes);
+
+	if (!req_ctx->setup_done) {
+		clk_enable(sss->clock);
+
+		sss_setup_hw(sss);
+		sss_setup_fifo(&req_ctx->rx);
+		sss_setup_fifo(&req_ctx->tx);
+
+		req_ctx->setup_done = true;
+	}
+
+	/* Ensure timeout handler is killed */
+	if (timer_pending(&sss->timer))
+		del_timer(&sss->timer);
+
+	if (!req_ctx->err && (req_ctx->rx.bytes_done < req->nbytes ||
+			      req_ctx->tx.bytes_done < req->nbytes)) {
+		int ret;
+
+		if (req_ctx->tx.bytes_done < req_ctx->rx.bytes_done)
+			/* Keep TX in sync with RX */
+			ret = sss_handle_fifo(&req_ctx->tx);
+		else
+			/* Transmit some more data to RX */
+			ret = sss_handle_fifo(&req_ctx->rx);
+
+		sss_dump_channel(&req_ctx->tx);
+		sss_dump_channel(&req_ctx->rx);
+
+		if (ret && ret != -EINPROGRESS) {
+			req_ctx->err = ret;
+			goto cleanup;
+		}
+
+		mod_timer(&sss->timer, jiffies + SSS_TIMEOUT);
+		return;
+	}
+
+cleanup:
+	sss_cleanup_fifo(&req_ctx->rx);
+	sss_cleanup_fifo(&req_ctx->tx);
+
+	clk_disable(sss->clock);
+
+	/* Inform client of completion */
+	req->base.complete(&req->base, req_ctx->err);
+
+	spin_lock_irqsave(&sss->lock, flags);
+	sss->cur_req = NULL;
+	/* Check whether there's still work to do */
+	if (sss->queue.qlen || crypto_get_backlog(&sss->queue))
+		tasklet_schedule(&sss->tasklet);
+	spin_unlock_irqrestore(&sss->lock, flags);
+}
+
+/*** SW handling ***/
+
+static int sss_crypto_generic(struct ablkcipher_request *req,
+			      enum sss_algorithm alg,
+			      enum sss_block_cipher blk_ciph,
+			      enum sss_direction dir)
+{
+	struct sss_context *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct sss_req_context *req_ctx = ablkcipher_request_ctx(req);
+	struct s3c_sss *sss = ctx->dev;
+	unsigned long flags;
+	int ret;
+
+	/* Fill the request */
+	*req_ctx = (struct sss_req_context){
+		.algorithm	= alg,
+		.blk_cipher	= blk_ciph,
+		.direction	= dir,
+		.rx		= {
+				.dev = sss,
+				.dir = FIFO_RX,
+		},
+		.tx		= {
+				.dev = sss,
+				.dir = FIFO_TX,
+		},
+	};
+
+	/* Enqueue the request */
+	spin_lock_irqsave(&sss->lock, flags);
+	ret = ablkcipher_enqueue_request(&sss->queue, req);
+	if (ret == -EINPROGRESS && !sss->cur_req)
+		tasklet_schedule(&sss->tasklet);
+	spin_unlock_irqrestore(&sss->lock, flags);
+
+	if (ret != -EINPROGRESS)
+		dev_err(sss->dev, "Couldn't enqueue request!\n");
+
+	return ret;
+}
+
+static int sss_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			  unsigned int len)
+{
+	struct crypto_tfm *tfm	= crypto_ablkcipher_tfm(cipher);
+	struct sss_context *ctx	= crypto_tfm_ctx(tfm);
+
+	switch (len) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, len);
+	ctx->key_len = len;
+
+	return 0;
+}
+
+static int sss_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			  unsigned int len)
+{
+	struct crypto_tfm *tfm	= crypto_ablkcipher_tfm(cipher);
+	struct sss_context *ctx	= crypto_tfm_ctx(tfm);
+
+	if (len > SSS_MAX_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	/* RFC2451: weak key checks SHOULD be performed */
+	if (len == DES_KEY_SIZE) {
+		u32 tmp[DES_EXPKEY_WORDS];
+		int ret = des_ekey(tmp, key);
+
+		if (unlikely(ret == 0) &&
+		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+			return -EINVAL;
+		}
+	}
+
+	memcpy(ctx->key, key, len);
+	ctx->key_len = len;
+
+	return 0;
+}
+
+static int sss_cra_init(struct crypto_tfm *tfm)
+{
+	struct sss_crypto_wrapper *wrapper = container_of(tfm->__crt_alg,
+						struct sss_crypto_wrapper, alg);
+	struct s3c_sss *sss = wrapper->dev;
+	struct sss_context *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->dev = sss;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct sss_req_context);
+
+	return 0;
+}
+
+static int sss_aes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_AES, CIPH_CBC, ENCRYPT);
+}
+
+static int sss_aes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_AES, CIPH_CBC, DECRYPT);
+}
+
+static int sss_aes_ecb_encrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_AES, CIPH_ECB, ENCRYPT);
+}
+
+static int sss_aes_ecb_decrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_AES, CIPH_ECB, DECRYPT);
+}
+
+static int sss_aes_ctr_encrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_AES, CIPH_CTR, ENCRYPT);
+}
+
+static int sss_aes_ctr_decrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_AES, CIPH_CTR, DECRYPT);
+}
+
+static int sss_des_ecb_encrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_DES, CIPH_ECB, ENCRYPT);
+}
+
+static int sss_des_ecb_decrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_DES, CIPH_ECB, DECRYPT);
+}
+
+static int sss_des_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_DES, CIPH_CBC, ENCRYPT);
+}
+
+static int sss_des_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_DES, CIPH_CBC, DECRYPT);
+}
+
+static int sss_tdes_ecb_encrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_TDES, CIPH_ECB, ENCRYPT);
+}
+
+static int sss_tdes_ecb_decrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_TDES, CIPH_ECB, DECRYPT);
+}
+
+static int sss_tdes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_TDES, CIPH_CBC, ENCRYPT);
+}
+
+static int sss_tdes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return sss_crypto_generic(req, ALGO_TDES, CIPH_CBC, DECRYPT);
+}
+
+static struct sss_algo_template {
+	char				*alg_name;
+	char				*blk_ciph_name;
+	int				 blk_size;
+	struct ablkcipher_alg		 ablkcipher;
+
+	struct sss_crypto_wrapper	*alg;
+} sss_crypto_algos[] = {
+	/* AES ECB/CBC/CTR */
+	{
+		.alg_name = "aes",
+		.blk_ciph_name = "ecb",
+		.blk_size = AES_BLOCK_SIZE,
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	sss_aes_setkey,
+			.encrypt	=	sss_aes_ecb_encrypt,
+			.decrypt	=	sss_aes_ecb_decrypt,
+		},
+	},
+	{
+		.alg_name = "aes",
+		.blk_ciph_name = "cbc",
+		.blk_size = AES_BLOCK_SIZE,
+		.ablkcipher = {
+			.ivsize		=	AES_BLOCK_SIZE,
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	sss_aes_setkey,
+			.encrypt	=	sss_aes_cbc_encrypt,
+			.decrypt	=	sss_aes_cbc_decrypt,
+		},
+	},
+	{
+		.alg_name = "aes",
+		.blk_ciph_name = "ctr",
+		.blk_size = AES_BLOCK_SIZE,
+		.ablkcipher = {
+			.ivsize		=	CTR_RFC3686_IV_SIZE,
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	sss_aes_setkey,
+			.encrypt	=	sss_aes_ctr_encrypt,
+			.decrypt	=	sss_aes_ctr_decrypt,
+		},
+	},
+	/* DES CBC/ECB */
+	{
+		.alg_name = "des",
+		.blk_ciph_name = "cbc",
+		.blk_size = DES_BLOCK_SIZE,
+		.ablkcipher = {
+			.ivsize		=	DES_BLOCK_SIZE,
+			.min_keysize	=	DES_KEY_SIZE,
+			.max_keysize	=	DES_KEY_SIZE,
+			.setkey		=	sss_des_setkey,
+			.encrypt	=	sss_des_cbc_encrypt,
+			.decrypt	=	sss_des_cbc_decrypt,
+		},
+	},
+	{
+		.alg_name = "des",
+		.blk_ciph_name = "ecb",
+		.blk_size = DES_BLOCK_SIZE,
+		.ablkcipher = {
+			.min_keysize	=	DES_KEY_SIZE,
+			.max_keysize	=	DES_KEY_SIZE,
+			.setkey		=	sss_des_setkey,
+			.encrypt	=	sss_des_ecb_encrypt,
+			.decrypt	=	sss_des_ecb_decrypt,
+		},
+	},
+	/* TDES CBC/ECB */
+	{
+		.alg_name = "des3_ede",
+		.blk_ciph_name = "cbc",
+		.blk_size = DES3_EDE_BLOCK_SIZE,
+		.ablkcipher = {
+			.ivsize		=	DES3_EDE_BLOCK_SIZE,
+			.min_keysize	=	DES3_EDE_KEY_SIZE,
+			.max_keysize	=	DES3_EDE_KEY_SIZE,
+			.setkey		=	sss_des_setkey,
+			.encrypt	=	sss_tdes_cbc_encrypt,
+			.decrypt	=	sss_tdes_cbc_decrypt,
+		},
+	},
+	{
+		.alg_name = "des3_ede",
+		.blk_ciph_name = "ecb",
+		.blk_size = DES3_EDE_BLOCK_SIZE,
+		.ablkcipher = {
+			.min_keysize	=	DES3_EDE_KEY_SIZE,
+			.max_keysize	=	DES3_EDE_KEY_SIZE,
+			.setkey		=	sss_des_setkey,
+			.encrypt	=	sss_tdes_ecb_encrypt,
+			.decrypt	=	sss_tdes_ecb_decrypt,
+		},
+	},
+};
+
+static int sss_init_template(struct platform_device *pdev,
+			     struct sss_algo_template *templ)
+{
+	struct s3c_sss *sss = platform_get_drvdata(pdev);
+	struct sss_crypto_wrapper *alg;
+
+	alg = kzalloc(sizeof(struct sss_crypto_wrapper), GFP_KERNEL);
+	if (!alg)
+		return -ENOMEM;
+
+	alg->dev = sss;
+	alg->alg = (struct crypto_alg){
+			.cra_ablkcipher	= templ->ablkcipher,
+			.cra_blocksize	= templ->blk_size,
+			.cra_ctxsize	= sizeof(struct sss_context),
+			.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+					  CRYPTO_ALG_ASYNC,
+			.cra_init	= sss_cra_init,
+			.cra_module	= THIS_MODULE,
+			.cra_priority	= SSS_CRA_PRIORITY,
+			.cra_type	= &crypto_ablkcipher_type,
+	};
+
+	snprintf(alg->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+		 templ->blk_ciph_name, templ->alg_name);
+	snprintf(alg->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-%s-%s",
+		 pdev->name, templ->alg_name, templ->blk_ciph_name);
+
+	/* Save pointer for removal */
+	templ->alg = alg;
+
+	dev_info(sss->dev, "crypto acceleration for %s", alg->alg.cra_name);
+
+	return 0;
+}
+
+static struct ahash_alg sss_hash_algos[] = {
+#if 0
+	{
+		.init		=	sss_sha_init,
+		.update		=	sss_sha_update,
+		.final		=	sss_sha1_final,
+		.digest		=	sss_sha1_digest,
+		.halg		=	{
+			.digestsize		=	SHA1_DIGEST_SIZE,
+			.statesize		=	sizeof(struct sha1_state),
+			.base			=	{
+				.cra_name		=	"sha1",
+				.cra_driver_name	=	"s3c-sss-sha1",
+				.cra_priority		=	SSS_CRA_PRIORITY,
+				.cra_flags		=	CRYPTO_ALG_TYPE_AHASH |
+								CRYPTO_ALG_ASYNC,
+				.cra_blocksize		=	SHA1_BLOCK_SIZE,
+				.cra_ctxsize		=	sizeof(struct sss_context),
+				.cra_type		=	&crypto_ahash_type,
+				.cra_module		=	THIS_MODULE,
+				.cra_init		=	sss_cra_init,
+			}
+		},
+	},
+	{
+		.init		=	sss_sha_init,
+		.update		=	sss_sha_update,
+		.final		=	sss_sha1_final,
+		.digest		=	sss_sha1_digest,
+		.setkey		=	sss_sha1_setkey,
+		.halg		=	{
+			.digestsize		=	SHA1_DIGEST_SIZE,
+			.statesize		=	sizeof(struct sha1_state),
+			.base			=	{
+				.cra_name		=	"hmac(sha1)",
+				.cra_driver_name	=	"s3c-sss-hmac-sha1",
+				.cra_priority		=	SSS_CRA_PRIORITY,
+				.cra_flags		=	CRYPTO_ALG_TYPE_AHASH |
+								CRYPTO_ALG_ASYNC,
+				.cra_blocksize		=	SHA1_BLOCK_SIZE,
+				.cra_ctxsize		=	sizeof(struct sss_context),
+				.cra_type		=	&crypto_ahash_type,
+				.cra_module		=	THIS_MODULE,
+				.cra_init		=	sss_cra_init,
+			}
+		},
+	},
+#endif
+};
+
+static void sss_unregister_algos(void)
+{
+	struct sss_crypto_wrapper *alg;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sss_crypto_algos); i++) {
+		alg = sss_crypto_algos[i].alg;
+
+		if (alg) {
+			crypto_unregister_alg(&alg->alg);
+			kfree(alg);
+
+			sss_crypto_algos[i].alg = NULL;
+		}
+	}
+
+	/* Unregistering algorithms that weren't registered in the first place
+	   doesn't do any harm, so just do it for all. */
+	for (i = 0; i < ARRAY_SIZE(sss_hash_algos); i++)
+		crypto_unregister_ahash(&sss_hash_algos[i]);
+}
+
+static int sss_register_algos(struct platform_device *pdev)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(sss_crypto_algos); i++) {
+		ret = sss_init_template(pdev, &sss_crypto_algos[i]);
+		if (ret)
+			goto exit;
+
+		ret = crypto_register_alg(&sss_crypto_algos[i].alg->alg);
+		if (ret)
+			goto exit;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sss_hash_algos); i++) {
+		ret = crypto_register_ahash(&sss_hash_algos[i]);
+		if (ret)
+			goto exit;
+	}
+
+	return 0;
+
+exit:
+	sss_unregister_algos();
+	return ret;
+}
+
+static int __devinit sss_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct s3c_sss *sss;
+	int ret;
+
+	sss = kzalloc(sizeof(struct s3c_sss), GFP_KERNEL);
+	if (!sss) {
+		dev_err(dev, "cannot allocate memory\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&sss->lock);
+	crypto_init_queue(&sss->queue, 50);
+	tasklet_init(&sss->tasklet, sss_tasklet_callback, (unsigned long) sss);
+	setup_timer(&sss->timer, sss_timer_callback, (unsigned long) sss);
+
+	sss->dev = dev;
+	sss->dma_client.name = (char *) pdev->name;
+	platform_set_drvdata(pdev, sss);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "cannot find register resource\n");
+		ret = -EINVAL;
+		goto exit_dev;
+	}
+
+	sss->regs_res = request_mem_region(res->start, resource_size(res),
+					   dev_name(dev));
+	if (!sss->regs_res) {
+		dev_err(dev, "cannot request register resource\n");
+		ret = -ENOENT;
+		goto exit_dev;
+	}
+
+	sss->regs_phys = (void __iomem *) res->start;
+
+	sss->regs = ioremap(res->start, resource_size(res));
+	if (!sss->regs) {
+		dev_err(dev, "cannot map registers\n");
+		ret = -ENXIO;
+		goto exit_resource;
+	}
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0 || ret == NO_IRQ) {
+		dev_err(dev, "cannot find IRQ\n");
+		goto exit_regs_remap;
+	}
+
+	sss->irq = ret;
+
+	ret = request_irq(sss->irq, sss_irq, 0, dev_name(dev), sss);
+	if (ret < 0) {
+		dev_err(dev, "cannot claim IRQ\n");
+		goto exit_regs_remap;
+	}
+
+	sss->clock = clk_get(dev, "secur");
+	if (!sss->clock) {
+		dev_err(dev, "cannot find clock\n");
+		ret = -ENXIO;
+		goto exit_irq;
+	}
+
+	WARN_ON(clk_set_rate(sss->clock, 66*1000000)); /*REMOVEME*/
+
+	if (sss_dma_enabled()) {
+		ret = sss_setup_dma(sss, DMACH_SECURITY_RX);
+		if (ret < 0) {
+			dev_err(dev, "cannot setup SECURITY_RX DMA channel\n");
+			goto exit_clock;
+		}
+
+		ret = sss_setup_dma(sss, DMACH_SECURITY_TX);
+		if (ret < 0) {
+			dev_err(dev, "cannot setup SECURITY_TX DMA channel\n");
+			goto exit_dma_rx;
+		}
+	}
+
+	ret = sss_register_algos(pdev);
+	if (ret) {
+		dev_err(dev, "cannot register algos\n");
+		goto exit_dma_tx;
+	}
+
+	return 0;
+
+exit_dma_tx:
+	if (sss_dma_enabled())
+		s3c2410_dma_free(DMACH_SECURITY_TX, &sss->dma_client);
+exit_dma_rx:
+	if (sss_dma_enabled())
+		s3c2410_dma_free(DMACH_SECURITY_RX, &sss->dma_client);
+exit_clock:
+	clk_put(sss->clock);
+exit_irq:
+	free_irq(sss->irq, sss);
+exit_regs_remap:
+	iounmap(sss->regs);
+exit_resource:
+	release_resource(sss->regs_res);
+	kfree(sss->regs_res);
+exit_dev:
+	tasklet_kill(&sss->tasklet);
+	kfree(sss);
+
+	return ret;
+}
+
+static int __devexit sss_remove(struct platform_device *pdev)
+{
+	struct s3c_sss *sss = platform_get_drvdata(pdev);
+
+	if (timer_pending(&sss->timer))
+		del_timer(&sss->timer);
+
+	if (sss_dma_enabled()) {
+		s3c2410_dma_free(DMACH_SECURITY_TX, &sss->dma_client);
+		s3c2410_dma_free(DMACH_SECURITY_RX, &sss->dma_client);
+	}
+
+	sss_unregister_algos();
+	clk_put(sss->clock);
+	free_irq(sss->irq, sss);
+	iounmap(sss->regs);
+	release_resource(sss->regs_res);
+	kfree(sss->regs_res);
+	tasklet_kill(&sss->tasklet);
+	kfree(sss);
+
+	return 0;
+}
+
+static struct platform_driver sss_crypto = {
+	.driver		= {
+		.name	= "s3c-sss",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sss_probe,
+	.remove		= __devexit_p(sss_remove),
+};
+
+static int __init sss_crypto_init(void)
+{
+	return platform_driver_register(&sss_crypto);
+}
+module_init(sss_crypto_init);
+
+static void __exit sss_crypto_exit(void)
+{
+	platform_driver_unregister(&sss_crypto);
+}
+module_exit(sss_crypto_exit);
+
+MODULE_AUTHOR("Maurus Cuelenaere <mcuelenaere@gmail.com>");
+MODULE_DESCRIPTION("Support for Samsung's Security Sub-Systems");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sss_crypto");
-- 
1.7.1
