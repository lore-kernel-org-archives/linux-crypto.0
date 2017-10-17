From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH v7 2/2] crypto: s5p-sss: Add HASH support for Exynos
Date: Tue, 17 Oct 2017 13:28:24 +0200
Message-ID: <20171017112824.10231-3-k.konieczny@partner.samsung.com>
References: <20171017112824.10231-1-k.konieczny@partner.samsung.com>
        <CGME20171017112846eucas1p17185d93eb5f837643c880357b3a8053b@eucas1p1.samsung.com>
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20171017112824.10231-1-k.konieczny@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
It uses the crypto framework asynchronous hash api.
It is based on omap-sham.c driver.
S5P has some HW differencies and is not implemented.

Modifications in s5p-sss:

- Add hash supporting structures and functions.

- Modify irq handler to handle both aes and hash signals.

- Resize resource end in probe if EXYNOS_HASH is enabled in
  Kconfig.

- Add new copyright line and new author.

- Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.13-rc6
  with crypto run-time self test testmgr
  and with tcrypt module with: modprobe tcrypt sec=1 mode=N
  where N=402, 403, 404 (MD5, SHA1, SHA256).

Modifications in drivers/crypto/Kconfig:

- Add new CRYPTO_DEV_EXYNOS_HASH, depend on !EXYNOS_RNG
  and CRYPTO_DEV_S5P

- Select sw algorithms MD5, SHA1 and SHA256 in EXYNOS_HASH
  as they are nedded for fallback.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/Kconfig   |   14 +
 drivers/crypto/s5p-sss.c | 1407 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 1411 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4b75084fabad..dea4d33d9c7f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -439,6 +439,20 @@ config CRYPTO_DEV_S5P
 	  Select this to offload Samsung S5PV210 or S5PC110, Exynos from AES
 	  algorithms execution.
 
+config CRYPTO_DEV_EXYNOS_HASH
+	bool "Support for Samsung Exynos HASH accelerator"
+	depends on CRYPTO_DEV_S5P
+	depends on !CRYPTO_DEV_EXYNOS_RNG && CRYPTO_DEV_EXYNOS_RNG!=m
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	select CRYPTO_SHA256
+	help
+	  Select this to offload Exynos from HASH MD5/SHA1/SHA256.
+	  This will select software SHA1, MD5 and SHA256 as they are
+	  needed for small and zero-size messages.
+	  HASH algorithms will be disabled if EXYNOS_RNG
+	  is enabled due to hw conflict.
+
 config CRYPTO_DEV_NX
 	bool "Support for IBM PowerPC Nest (NX) cryptographic acceleration"
 	depends on PPC64
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index dfae1865c384..c9feccf21efe 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1,18 +1,21 @@
 /*
  * Cryptographic API.
  *
- * Support for Samsung S5PV210 HW acceleration.
+ * Support for Samsung S5PV210 and Exynos HW acceleration.
  *
  * Copyright (C) 2011 NetUP Inc. All rights reserved.
+ * Copyright (c) 2017 Samsung Electronics Co., Ltd. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as published
  * by the Free Software Foundation.
  *
+ * Hash part based on omap-sham.c driver.
  */
 
 #include <linux/clk.h>
 #include <linux/crypto.h>
+#include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -30,28 +33,41 @@
 #include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 
+#include <crypto/hash.h>
+#include <crypto/md5.h>
+#include <crypto/sha.h>
+#include <crypto/internal/hash.h>
+
 #define _SBF(s, v)			((v) << (s))
 
 /* Feed control registers */
 #define SSS_REG_FCINTSTAT		0x0000
+#define SSS_FCINTSTAT_HPARTINT		BIT(7)
+#define SSS_FCINTSTAT_HDONEINT		BIT(5)
 #define SSS_FCINTSTAT_BRDMAINT		BIT(3)
 #define SSS_FCINTSTAT_BTDMAINT		BIT(2)
 #define SSS_FCINTSTAT_HRDMAINT		BIT(1)
 #define SSS_FCINTSTAT_PKDMAINT		BIT(0)
 
 #define SSS_REG_FCINTENSET		0x0004
+#define SSS_FCINTENSET_HPARTINTENSET	BIT(7)
+#define SSS_FCINTENSET_HDONEINTENSET	BIT(5)
 #define SSS_FCINTENSET_BRDMAINTENSET	BIT(3)
 #define SSS_FCINTENSET_BTDMAINTENSET	BIT(2)
 #define SSS_FCINTENSET_HRDMAINTENSET	BIT(1)
 #define SSS_FCINTENSET_PKDMAINTENSET	BIT(0)
 
 #define SSS_REG_FCINTENCLR		0x0008
+#define SSS_FCINTENCLR_HPARTINTENCLR	BIT(7)
+#define SSS_FCINTENCLR_HDONEINTENCLR	BIT(5)
 #define SSS_FCINTENCLR_BRDMAINTENCLR	BIT(3)
 #define SSS_FCINTENCLR_BTDMAINTENCLR	BIT(2)
 #define SSS_FCINTENCLR_HRDMAINTENCLR	BIT(1)
 #define SSS_FCINTENCLR_PKDMAINTENCLR	BIT(0)
 
 #define SSS_REG_FCINTPEND		0x000C
+#define SSS_FCINTPEND_HPARTINTP		BIT(7)
+#define SSS_FCINTPEND_HDONEINTP		BIT(5)
 #define SSS_FCINTPEND_BRDMAINTP		BIT(3)
 #define SSS_FCINTPEND_BTDMAINTP		BIT(2)
 #define SSS_FCINTPEND_HRDMAINTP		BIT(1)
@@ -72,6 +88,7 @@
 #define SSS_HASHIN_INDEPENDENT		_SBF(0, 0x00)
 #define SSS_HASHIN_CIPHER_INPUT		_SBF(0, 0x01)
 #define SSS_HASHIN_CIPHER_OUTPUT	_SBF(0, 0x02)
+#define SSS_HASHIN_MASK			_SBF(0, 0x03)
 
 #define SSS_REG_FCBRDMAS		0x0020
 #define SSS_REG_FCBRDMAL		0x0024
@@ -146,9 +163,80 @@
 #define AES_KEY_LEN			16
 #define CRYPTO_QUEUE_LEN		1
 
+/* HASH registers */
+#define SSS_REG_HASH_CTRL		0x00
+
+#define SSS_HASH_USER_IV_EN		BIT(5)
+#define SSS_HASH_INIT_BIT		BIT(4)
+#define SSS_HASH_ENGINE_SHA1		_SBF(1, 0x00)
+#define SSS_HASH_ENGINE_MD5		_SBF(1, 0x01)
+#define SSS_HASH_ENGINE_SHA256		_SBF(1, 0x02)
+
+#define SSS_HASH_ENGINE_MASK		_SBF(1, 0x03)
+
+#define SSS_REG_HASH_CTRL_PAUSE		0x04
+
+#define SSS_HASH_PAUSE			BIT(0)
+
+#define SSS_REG_HASH_CTRL_FIFO		0x08
+
+#define SSS_HASH_FIFO_MODE_DMA		BIT(0)
+#define SSS_HASH_FIFO_MODE_CPU          0
+
+#define SSS_REG_HASH_CTRL_SWAP		0x0C
+
+#define SSS_HASH_BYTESWAP_DI		BIT(3)
+#define SSS_HASH_BYTESWAP_DO		BIT(2)
+#define SSS_HASH_BYTESWAP_IV		BIT(1)
+#define SSS_HASH_BYTESWAP_KEY		BIT(0)
+
+#define SSS_REG_HASH_STATUS		0x10
+
+#define SSS_HASH_STATUS_MSG_DONE	BIT(6)
+#define SSS_HASH_STATUS_PARTIAL_DONE	BIT(4)
+#define SSS_HASH_STATUS_BUFFER_READY	BIT(0)
+
+#define SSS_REG_HASH_MSG_SIZE_LOW	0x20
+#define SSS_REG_HASH_MSG_SIZE_HIGH	0x24
+
+#define SSS_REG_HASH_PRE_MSG_SIZE_LOW	0x28
+#define SSS_REG_HASH_PRE_MSG_SIZE_HIGH	0x2C
+
+#define SSS_REG_HASH_IV(s)		(0xB0 + ((s) << 2))
+#define SSS_REG_HASH_OUT(s)		(0x100 + ((s) << 2))
+
+#define HASH_BLOCK_SIZE			64
+#define HASH_REG_SIZEOF			4
+#define HASH_MD5_MAX_REG		(MD5_DIGEST_SIZE / HASH_REG_SIZEOF)
+#define HASH_SHA1_MAX_REG		(SHA1_DIGEST_SIZE / HASH_REG_SIZEOF)
+#define HASH_SHA256_MAX_REG		(SHA256_DIGEST_SIZE / HASH_REG_SIZEOF)
+
+/*
+ * HASH bit numbers, used by device, setting in dev->hash_flags with
+ * functions set_bit(), clear_bit() or tested with test_bit() or BIT(),
+ * to keep HASH state BUSY or FREE, or to signal state from irq_handler
+ * to hash_tasklet. SGS keep track of allocated memory for scatterlist
+ */
+#define HASH_FLAGS_BUSY		0
+#define HASH_FLAGS_FINAL	1
+#define HASH_FLAGS_DMA_ACTIVE	2
+#define HASH_FLAGS_OUTPUT_READY	3
+#define HASH_FLAGS_DMA_READY	4
+#define HASH_FLAGS_SGS_COPIED	5
+#define HASH_FLAGS_SGS_ALLOCED	6
+
+/* HASH HW constants */
+#define BUFLEN			HASH_BLOCK_SIZE
+
+#define SSS_HASH_DMA_LEN_ALIGN	8
+#define SSS_HASH_DMA_ALIGN_MASK	(SSS_HASH_DMA_LEN_ALIGN - 1)
+
+#define SSS_HASH_QUEUE_LENGTH	10
+
 /**
  * struct samsung_aes_variant - platform specific SSS driver data
  * @aes_offset: AES register offset from SSS module's base.
+ * @hash_offset: HASH register offset from SSS module's base.
  *
  * Specifies platform specific configuration of SSS module.
  * Note: A structure for driver specific platform data is used for future
@@ -156,6 +244,7 @@
  */
 struct samsung_aes_variant {
 	unsigned int			aes_offset;
+	unsigned int			hash_offset;
 };
 
 struct s5p_aes_reqctx {
@@ -195,6 +284,19 @@ struct s5p_aes_ctx {
  *		protects against concurrent access to these fields.
  * @lock:	Lock for protecting both access to device hardware registers
  *		and fields related to current request (including the busy field).
+ * @res:	Resources for hash.
+ * @io_hash_base: Per-variant offset for HASH block IO memory.
+ * @hash_lock:	Lock for protecting hash_req, hash_queue and hash_flags
+ *		variable.
+ * @hash_flags:	Flags for current HASH op.
+ * @hash_queue:	Async hash queue.
+ * @hash_tasklet: New HASH request scheduling job.
+ * @xmit_buf:	Buffer for current HASH request transfer into SSS block.
+ * @hash_req:	Current request sending to SSS HASH block.
+ * @hash_sg_iter: Scatterlist transferred through DMA into SSS HASH block.
+ * @hash_sg_cnt: Counter for hash_sg_iter.
+ *
+ * @use_hash:	true if HASH algs enabled
  */
 struct s5p_aes_dev {
 	struct device			*dev;
@@ -215,16 +317,83 @@ struct s5p_aes_dev {
 	struct crypto_queue		queue;
 	bool				busy;
 	spinlock_t			lock;
+
+	struct resource			*res;
+	void __iomem			*io_hash_base;
+
+	spinlock_t			hash_lock; /* protect hash_ vars */
+	unsigned long			hash_flags;
+	struct crypto_queue		hash_queue;
+	struct tasklet_struct		hash_tasklet;
+
+	u8				xmit_buf[BUFLEN];
+	struct ahash_request		*hash_req;
+	struct scatterlist		*hash_sg_iter;
+	unsigned int			hash_sg_cnt;
+
+	bool				use_hash;
 };
 
-static struct s5p_aes_dev *s5p_dev;
+/**
+ * struct s5p_hash_reqctx - HASH request context
+ * @dev:	Associated device
+ * @op_update:	Current request operation (OP_UPDATE or OP_FINAL)
+ * @digcnt:	Number of bytes processed by HW (without buffer[] ones)
+ * @digest:	Digest message or IV for partial result
+ * @nregs:	Number of HW registers for digest or IV read/write
+ * @engine:	Bits for selecting type of HASH in SSS block
+ * @sg:		sg for DMA transfer
+ * @sg_len:	Length of sg for DMA transfer
+ * @sgl[]:	sg for joining buffer and req->src scatterlist
+ * @skip:	Skip offset in req->src for current op
+ * @total:	Total number of bytes for current request
+ * @finup:	Keep state for finup or final.
+ * @error:	Keep track of error.
+ * @bufcnt:	Number of bytes holded in buffer[]
+ * @buffer[]:	For byte(s) from end of req->src in UPDATE op
+ */
+struct s5p_hash_reqctx {
+	struct s5p_aes_dev	*dd;
+	bool			op_update;
+
+	u64			digcnt;
+	u8			digest[SHA256_DIGEST_SIZE];
+
+	unsigned int		nregs; /* digest_size / sizeof(reg) */
+	u32			engine;
+
+	struct scatterlist	*sg;
+	unsigned int		sg_len;
+	struct scatterlist	sgl[2];
+	unsigned int		skip;
+	unsigned int		total;
+	bool			finup;
+	bool			error;
+
+	u32			bufcnt;
+	u8			buffer[0];
+};
+
+/**
+ * struct s5p_hash_ctx - HASH transformation context
+ * @dd:		Associated device
+ * @flags:	Bits for algorithm HASH.
+ * @fallback:	Software transformation for zero message or size < BUFLEN.
+ */
+struct s5p_hash_ctx {
+	struct s5p_aes_dev	*dd;
+	unsigned long		flags;
+	struct crypto_shash	*fallback;
+};
 
 static const struct samsung_aes_variant s5p_aes_data = {
 	.aes_offset	= 0x4000,
+	.hash_offset	= 0x6000,
 };
 
 static const struct samsung_aes_variant exynos_aes_data = {
 	.aes_offset	= 0x200,
+	.hash_offset	= 0x400,
 };
 
 static const struct of_device_id s5p_sss_dt_match[] = {
@@ -254,6 +423,8 @@ static inline struct samsung_aes_variant *find_s5p_sss_version
 			platform_get_device_id(pdev)->driver_data;
 }
 
+static struct s5p_aes_dev *s5p_dev;
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -436,15 +607,65 @@ static int s5p_aes_rx(struct s5p_aes_dev *dev/*, bool *set_dma*/)
 	return ret;
 }
 
+static inline u32 s5p_hash_read(struct s5p_aes_dev *dd, u32 offset)
+{
+	return __raw_readl(dd->io_hash_base + offset);
+}
+
+static inline void s5p_hash_write(struct s5p_aes_dev *dd,
+				  u32 offset, u32 value)
+{
+	__raw_writel(value, dd->io_hash_base + offset);
+}
+
+/**
+ * s5p_set_dma_hashdata() - start DMA with sg
+ * @dev:	device
+ * @sg:		scatterlist ready to DMA transmit
+ */
+static void s5p_set_dma_hashdata(struct s5p_aes_dev *dev,
+				 struct scatterlist *sg)
+{
+	dev->hash_sg_cnt--;
+	SSS_WRITE(dev, FCHRDMAS, sg_dma_address(sg));
+	SSS_WRITE(dev, FCHRDMAL, sg_dma_len(sg)); /* DMA starts */
+}
+
+/**
+ * s5p_hash_rx() - get next hash_sg_iter
+ * @dev:	device
+ *
+ * Return:
+ * 2	if there is no more data and it is UPDATE op
+ * 1	if new receiving (input) data is ready and can be written to device
+ * 0	if there is no more data and it is FINAL op
+ */
+static int s5p_hash_rx(struct s5p_aes_dev *dev)
+{
+	if (dev->hash_sg_cnt > 0) {
+		dev->hash_sg_iter = sg_next(dev->hash_sg_iter);
+		return 1;
+	}
+
+	set_bit(HASH_FLAGS_DMA_READY, &dev->hash_flags);
+	if (test_bit(HASH_FLAGS_FINAL, &dev->hash_flags))
+		return 0;
+
+	return 2;
+}
+
 static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
 	int err_dma_tx = 0;
 	int err_dma_rx = 0;
+	int err_dma_hx = 0;
 	bool tx_end = false;
+	bool hx_end = false;
 	unsigned long flags;
 	uint32_t status;
+	u32 st_bits;
 	int err;
 
 	spin_lock_irqsave(&dev->lock, flags);
@@ -456,6 +677,8 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 	 *
 	 * If there is no more data in tx scatter list, call s5p_aes_complete()
 	 * and schedule new tasklet.
+	 *
+	 * Handle hx interrupt. If there is still data map next entry.
 	 */
 	status = SSS_READ(dev, FCINTSTAT);
 	if (status & SSS_FCINTSTAT_BRDMAINT)
@@ -467,7 +690,29 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 		err_dma_tx = s5p_aes_tx(dev);
 	}
 
-	SSS_WRITE(dev, FCINTPEND, status);
+	if (status & SSS_FCINTSTAT_HRDMAINT)
+		err_dma_hx = s5p_hash_rx(dev);
+
+	st_bits = status & (SSS_FCINTSTAT_BRDMAINT | SSS_FCINTSTAT_BTDMAINT |
+				SSS_FCINTSTAT_HRDMAINT);
+	/* clear DMA bits */
+	SSS_WRITE(dev, FCINTPEND, st_bits);
+
+	/* clear HASH irq bits */
+	if (status & (SSS_FCINTSTAT_HDONEINT | SSS_FCINTSTAT_HPARTINT)) {
+		/* cannot have both HPART and HDONE */
+		if (status & SSS_FCINTSTAT_HPARTINT)
+			st_bits = SSS_HASH_STATUS_PARTIAL_DONE;
+
+		if (status & SSS_FCINTSTAT_HDONEINT)
+			st_bits = SSS_HASH_STATUS_MSG_DONE;
+
+		set_bit(HASH_FLAGS_OUTPUT_READY, &dev->hash_flags);
+		s5p_hash_write(dev, SSS_REG_HASH_STATUS, st_bits);
+		hx_end = true;
+		/* when DONE or PART, do not handle HASH DMA */
+		err_dma_hx = 0;
+	}
 
 	if (err_dma_rx < 0) {
 		err = err_dma_rx;
@@ -480,6 +725,8 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 
 	if (tx_end) {
 		s5p_sg_done(dev);
+		if (err_dma_hx == 1)
+			s5p_set_dma_hashdata(dev, dev->hash_sg_iter);
 
 		spin_unlock_irqrestore(&dev->lock, flags);
 
@@ -497,21 +744,1100 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 			s5p_set_dma_outdata(dev, dev->sg_dst);
 		if (err_dma_rx == 1)
 			s5p_set_dma_indata(dev, dev->sg_src);
+		if (err_dma_hx == 1)
+			s5p_set_dma_hashdata(dev, dev->hash_sg_iter);
 
 		spin_unlock_irqrestore(&dev->lock, flags);
 	}
 
-	return IRQ_HANDLED;
+	goto hash_irq_end;
 
 error:
 	s5p_sg_done(dev);
 	dev->busy = false;
+	if (err_dma_hx == 1)
+		s5p_set_dma_hashdata(dev, dev->hash_sg_iter);
+
 	spin_unlock_irqrestore(&dev->lock, flags);
 	s5p_aes_complete(dev, err);
 
+hash_irq_end:
+	/*
+	 * Note about else if:
+	 *   when hash_sg_iter reaches end and its UPDATE op,
+	 *   issue SSS_HASH_PAUSE and wait for HPART irq
+	 */
+	if (hx_end)
+		tasklet_schedule(&dev->hash_tasklet);
+	else if (err_dma_hx == 2)
+		s5p_hash_write(dev, SSS_REG_HASH_CTRL_PAUSE,
+			       SSS_HASH_PAUSE);
+
 	return IRQ_HANDLED;
 }
 
+/**
+ * s5p_hash_read_msg() - read message or IV from HW
+ * @req:	AHASH request
+ */
+static void s5p_hash_read_msg(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	struct s5p_aes_dev *dd = ctx->dd;
+	u32 *hash = (u32 *)ctx->digest;
+	unsigned int i;
+
+	for (i = 0; i < ctx->nregs; i++)
+		hash[i] = s5p_hash_read(dd, SSS_REG_HASH_OUT(i));
+}
+
+/**
+ * s5p_hash_write_ctx_iv() - write IV for next partial/finup op.
+ * @dd:		device
+ * @ctx:	request context
+ */
+static void s5p_hash_write_ctx_iv(struct s5p_aes_dev *dd,
+				  struct s5p_hash_reqctx *ctx)
+{
+	u32 *hash = (u32 *)ctx->digest;
+	unsigned int i;
+
+	for (i = 0; i < ctx->nregs; i++)
+		s5p_hash_write(dd, SSS_REG_HASH_IV(i), hash[i]);
+}
+
+/**
+ * s5p_hash_write_iv() - write IV for next partial/finup op.
+ * @req:	AHASH request
+ */
+static void s5p_hash_write_iv(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+
+	s5p_hash_write_ctx_iv(ctx->dd, ctx);
+}
+
+/**
+ * s5p_hash_copy_result() - copy digest into req->result
+ * @req:	AHASH request
+ */
+static void s5p_hash_copy_result(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+
+	if (!req->result)
+		return;
+
+	memcpy(req->result, ctx->digest, ctx->nregs * HASH_REG_SIZEOF);
+}
+
+/**
+ * s5p_hash_dma_flush() - flush HASH DMA
+ * @dev:	secss device
+ */
+static void s5p_hash_dma_flush(struct s5p_aes_dev *dev)
+{
+	SSS_WRITE(dev, FCHRDMAC, SSS_FCHRDMAC_FLUSH);
+}
+
+/**
+ * s5p_hash_dma_enable() - enable DMA mode for HASH
+ * @dev:	secss device
+ *
+ * enable DMA mode for HASH
+ */
+static void s5p_hash_dma_enable(struct s5p_aes_dev *dev)
+{
+	s5p_hash_write(dev, SSS_REG_HASH_CTRL_FIFO, SSS_HASH_FIFO_MODE_DMA);
+}
+
+/**
+ * s5p_hash_irq_disable() - disable irq HASH signals
+ * @dev:	secss device
+ * @flags:	bitfield with irq's to be disabled
+ */
+static void s5p_hash_irq_disable(struct s5p_aes_dev *dev, u32 flags)
+{
+	SSS_WRITE(dev, FCINTENCLR, flags);
+}
+
+/**
+ * s5p_hash_irq_enable() - enable irq signals
+ * @dev:	secss device
+ * @flags:	bitfield with irq's to be enabled
+ */
+static void s5p_hash_irq_enable(struct s5p_aes_dev *dev, int flags)
+{
+	SSS_WRITE(dev, FCINTENSET, flags);
+}
+
+/**
+ * s5p_hash_set_flow() - set flow inside SecSS AES/DES with/without HASH
+ * @dev:	secss device
+ * @hashflow:	HASH stream flow with/without crypto AES/DES
+ */
+static void s5p_hash_set_flow(struct s5p_aes_dev *dev, u32 hashflow)
+{
+	unsigned long flags;
+	u32 flow;
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	flow = SSS_READ(dev, FCFIFOCTRL);
+	flow &= ~SSS_HASHIN_MASK;
+	flow |= hashflow;
+	SSS_WRITE(dev, FCFIFOCTRL, flow);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+}
+
+/**
+ * s5p_ahash_dma_init() - enable DMA and set HASH flow inside SecSS
+ * @dev:	secss device
+ * @hashflow:	HASH stream flow with/without AES/DES
+ *
+ * flush HASH DMA and enable DMA, set HASH stream flow inside SecSS HW,
+ * enable HASH irq's HRDMA, HDONE, HPART
+ */
+static void s5p_ahash_dma_init(struct s5p_aes_dev *dev, u32 hashflow)
+{
+	s5p_hash_irq_disable(dev, SSS_FCINTENCLR_HRDMAINTENCLR |
+			     SSS_FCINTENCLR_HDONEINTENCLR |
+			     SSS_FCINTENCLR_HPARTINTENCLR);
+	s5p_hash_dma_flush(dev);
+
+	s5p_hash_dma_enable(dev);
+	s5p_hash_set_flow(dev, hashflow & SSS_HASHIN_MASK);
+	s5p_hash_irq_enable(dev, SSS_FCINTENSET_HRDMAINTENSET |
+			    SSS_FCINTENSET_HDONEINTENSET |
+			    SSS_FCINTENSET_HPARTINTENSET);
+}
+
+/**
+ * s5p_hash_write_ctrl() - prepare HASH block in SecSS for processing
+ * @dd:		secss device
+ * @length:	length for request
+ * @final:	true if final op
+ *
+ * Prepare SSS HASH block for processing bytes in DMA mode. If it is called
+ * after previous updates, fill up IV words. For final, calculate and set
+ * lengths for HASH so SecSS can finalize hash. For partial, set SSS HASH
+ * length as 2^63 so it will be never reached and set to zero prelow and
+ * prehigh.
+ *
+ * This function does not start DMA transfer.
+ */
+static void s5p_hash_write_ctrl(struct s5p_aes_dev *dd, size_t length,
+				bool final)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(dd->hash_req);
+	u32 prelow, prehigh, low, high;
+	u32 configflags, swapflags;
+	u64 tmplen;
+
+	configflags = ctx->engine | SSS_HASH_INIT_BIT;
+
+	if (likely(ctx->digcnt)) {
+		s5p_hash_write_ctx_iv(dd, ctx);
+		configflags |= SSS_HASH_USER_IV_EN;
+	}
+
+	if (final) {
+		/* number of bytes for last part */
+		low = length;
+		high = 0;
+		/* total number of bits prev hashed */
+		tmplen = ctx->digcnt * 8;
+		prelow = (u32)tmplen;
+		prehigh = (u32)(tmplen >> 32);
+	} else {
+		prelow = 0;
+		prehigh = 0;
+		low = 0;
+		high = BIT(31);
+	}
+
+	swapflags = SSS_HASH_BYTESWAP_DI | SSS_HASH_BYTESWAP_DO |
+		    SSS_HASH_BYTESWAP_IV | SSS_HASH_BYTESWAP_KEY;
+
+	s5p_hash_write(dd, SSS_REG_HASH_MSG_SIZE_LOW, low);
+	s5p_hash_write(dd, SSS_REG_HASH_MSG_SIZE_HIGH, high);
+	s5p_hash_write(dd, SSS_REG_HASH_PRE_MSG_SIZE_LOW, prelow);
+	s5p_hash_write(dd, SSS_REG_HASH_PRE_MSG_SIZE_HIGH, prehigh);
+
+	s5p_hash_write(dd, SSS_REG_HASH_CTRL_SWAP, swapflags);
+	s5p_hash_write(dd, SSS_REG_HASH_CTRL, configflags);
+}
+
+/**
+ * s5p_hash_xmit_dma() - start DMA hash processing
+ * @dd:		secss device
+ * @length:	length for request
+ * @final:	true if final op
+ *
+ * Update digcnt here, as it is needed for finup/final op.
+ */
+static int s5p_hash_xmit_dma(struct s5p_aes_dev *dd, size_t length,
+			     bool final)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(dd->hash_req);
+	unsigned int cnt;
+
+	cnt = dma_map_sg(dd->dev, ctx->sg, ctx->sg_len, DMA_TO_DEVICE);
+	if (!cnt) {
+		dev_err(dd->dev, "dma_map_sg error\n");
+		ctx->error = true;
+		return -EINVAL;
+	}
+
+	set_bit(HASH_FLAGS_DMA_ACTIVE, &dd->hash_flags);
+	dd->hash_sg_iter = ctx->sg;
+	dd->hash_sg_cnt = cnt;
+	s5p_hash_write_ctrl(dd, length, final);
+	ctx->digcnt += length;
+	ctx->total -= length;
+
+	/* catch last interrupt */
+	if (final)
+		set_bit(HASH_FLAGS_FINAL, &dd->hash_flags);
+
+	s5p_set_dma_hashdata(dd, dd->hash_sg_iter); /* DMA starts */
+
+	return -EINPROGRESS;
+}
+
+/**
+ * s5p_hash_copy_sgs() - copy request's bytes into new buffer
+ * @ctx:	request context
+ * @sg:		source scatterlist request
+ * @new_len:	number of bytes to process from sg
+ *
+ * Allocate new buffer, copy data for HASH into it. If there was xmit_buf
+ * filled, copy it first, then copy data from sg into it. Prepare one sgl[0]
+ * with allocated buffer.
+ *
+ * Set bit in dd->hash_flag so we can free it after irq ends processing.
+ */
+static int s5p_hash_copy_sgs(struct s5p_hash_reqctx *ctx,
+			     struct scatterlist *sg, unsigned int new_len)
+{
+	unsigned int pages, len;
+	void *buf;
+
+	len = new_len + ctx->bufcnt;
+	pages = get_order(len);
+
+	buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
+	if (!buf) {
+		dev_err(ctx->dd->dev, "alloc pages for unaligned case.\n");
+		ctx->error = true;
+		return -ENOMEM;
+	}
+
+	if (ctx->bufcnt)
+		memcpy(buf, ctx->dd->xmit_buf, ctx->bufcnt);
+
+	scatterwalk_map_and_copy(buf + ctx->bufcnt, sg, ctx->skip,
+				 new_len, 0);
+	sg_init_table(ctx->sgl, 1);
+	sg_set_buf(ctx->sgl, buf, len);
+	ctx->sg = ctx->sgl;
+	ctx->sg_len = 1;
+	ctx->bufcnt = 0;
+	ctx->skip = 0;
+	set_bit(HASH_FLAGS_SGS_COPIED, &ctx->dd->hash_flags);
+
+	return 0;
+}
+
+/**
+ * s5p_hash_copy_sg_lists() - copy sg list and make fixes in copy
+ * @ctx:	request context
+ * @sg:		source scatterlist request
+ * @new_len:	number of bytes to process from sg
+ *
+ * Allocate new scatterlist table, copy data for HASH into it. If there was
+ * xmit_buf filled, prepare it first, then copy page, length and offset from
+ * source sg into it, adjusting begin and/or end for skip offset and
+ * hash_later value.
+ *
+ * Resulting sg table will be assigned to ctx->sg. Set flag so we can free
+ * it after irq ends processing.
+ */
+static int s5p_hash_copy_sg_lists(struct s5p_hash_reqctx *ctx,
+				  struct scatterlist *sg, unsigned int new_len)
+{
+	unsigned int skip = ctx->skip, n = sg_nents(sg);
+	struct scatterlist *tmp;
+	unsigned int len;
+
+	if (ctx->bufcnt)
+		n++;
+
+	ctx->sg = kmalloc_array(n, sizeof(*sg), GFP_KERNEL);
+	if (!ctx->sg) {
+		ctx->error = true;
+		return -ENOMEM;
+	}
+
+	sg_init_table(ctx->sg, n);
+
+	tmp = ctx->sg;
+
+	ctx->sg_len = 0;
+
+	if (ctx->bufcnt) {
+		sg_set_buf(tmp, ctx->dd->xmit_buf, ctx->bufcnt);
+		tmp = sg_next(tmp);
+		ctx->sg_len++;
+	}
+
+	while (sg && skip >= sg->length) {
+		skip -= sg->length;
+		sg = sg_next(sg);
+	}
+
+	while (sg && new_len) {
+		len = sg->length - skip;
+		if (new_len < len)
+			len = new_len;
+
+		new_len -= len;
+		sg_set_page(tmp, sg_page(sg), len, sg->offset + skip);
+		skip = 0;
+		if (new_len <= 0)
+			sg_mark_end(tmp);
+
+		tmp = sg_next(tmp);
+		ctx->sg_len++;
+		sg = sg_next(sg);
+	}
+
+	set_bit(HASH_FLAGS_SGS_ALLOCED, &ctx->dd->hash_flags);
+
+	return 0;
+}
+
+/**
+ * s5p_hash_prepare_sgs() - prepare sg for processing
+ * @ctx:	request context
+ * @sg:		source scatterlist request
+ * @nbytes:	number of bytes to process from sg
+ * @final:	final flag
+ *
+ * Check two conditions: (1) if buffers in sg have len aligned data, and (2)
+ * sg table have good aligned elements (list_ok). If one of this checks fails,
+ * then either (1) allocates new buffer for data with s5p_hash_copy_sgs, copy
+ * data into this buffer and prepare request in sgl, or (2) allocates new sg
+ * table and prepare sg elements.
+ *
+ * For digest or finup all conditions can be good, and we may not need any
+ * fixes.
+ */
+static int s5p_hash_prepare_sgs(struct s5p_hash_reqctx *ctx,
+				struct scatterlist *sg,
+				unsigned int new_len, bool final)
+{
+	unsigned int skip = ctx->skip, nbytes = new_len, n = 0;
+	bool aligned = true, list_ok = true;
+	struct scatterlist *sg_tmp = sg;
+
+	if (!sg || !sg->length || !new_len)
+		return 0;
+
+	if (skip || !final)
+		list_ok = false;
+
+	while (nbytes > 0 && sg_tmp) {
+		n++;
+		if (skip >= sg_tmp->length) {
+			skip -= sg_tmp->length;
+			if (!sg_tmp->length) {
+				aligned = false;
+				break;
+			}
+		} else {
+			if (!IS_ALIGNED(sg_tmp->length - skip, BUFLEN)) {
+				aligned = false;
+				break;
+			}
+
+			if (nbytes < sg_tmp->length - skip) {
+				list_ok = false;
+				break;
+			}
+
+			nbytes -= sg_tmp->length - skip;
+			skip = 0;
+		}
+
+		sg_tmp = sg_next(sg_tmp);
+	}
+
+	if (!aligned)
+		return s5p_hash_copy_sgs(ctx, sg, new_len);
+	else if (!list_ok)
+		return s5p_hash_copy_sg_lists(ctx, sg, new_len);
+
+	/*
+	 * Have aligned data from previous operation and/or current
+	 * Note: will enter here only if (digest or finup) and aligned
+	 */
+	if (ctx->bufcnt) {
+		ctx->sg_len = n;
+		sg_init_table(ctx->sgl, 2);
+		sg_set_buf(ctx->sgl, ctx->dd->xmit_buf, ctx->bufcnt);
+		sg_chain(ctx->sgl, 2, sg);
+		ctx->sg = ctx->sgl;
+		ctx->sg_len++;
+	} else {
+		ctx->sg = sg;
+		ctx->sg_len = n;
+	}
+
+	return 0;
+}
+
+/**
+ * s5p_hash_prepare_request() - prepare request for processing
+ * @req:	AHASH request
+ * @update:	true if UPDATE op
+ *
+ * Note 1: we can have update flag _and_ final flag at the same time.
+ * Note 2: we enter here when digcnt > BUFLEN (=HASH_BLOCK_SIZE) or
+ *	   either req->nbytes or ctx->bufcnt + req->nbytes is > BUFLEN or
+ *	   we have final op
+ */
+static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	bool final = ctx->finup;
+	int xmit_len, hash_later, nbytes;
+	int ret;
+
+	if (!req)
+		return 0;
+
+	if (update)
+		nbytes = req->nbytes;
+	else
+		nbytes = 0;
+
+	ctx->total = nbytes + ctx->bufcnt;
+	if (!ctx->total)
+		return 0;
+
+	if (nbytes && (!IS_ALIGNED(ctx->bufcnt, BUFLEN))) {
+		/* bytes left from previous request, so fill up to BUFLEN */
+		int len = BUFLEN - ctx->bufcnt % BUFLEN;
+
+		if (len > nbytes)
+			len = nbytes;
+
+		scatterwalk_map_and_copy(ctx->buffer + ctx->bufcnt, req->src,
+					 0, len, 0);
+		ctx->bufcnt += len;
+		nbytes -= len;
+		ctx->skip = len;
+	} else {
+		ctx->skip = 0;
+	}
+
+	if (ctx->bufcnt)
+		memcpy(ctx->dd->xmit_buf, ctx->buffer, ctx->bufcnt);
+
+	xmit_len = ctx->total;
+	if (final) {
+		hash_later = 0;
+	} else {
+		if (IS_ALIGNED(xmit_len, BUFLEN))
+			xmit_len -= BUFLEN;
+		else
+			xmit_len -= xmit_len & (BUFLEN - 1);
+
+		hash_later = ctx->total - xmit_len;
+		/* copy hash_later bytes from end of req->src */
+		/* previous bytes are in xmit_buf, so no overwrite */
+		scatterwalk_map_and_copy(ctx->buffer, req->src,
+					 req->nbytes - hash_later,
+					 hash_later, 0);
+	}
+
+	if (xmit_len > BUFLEN) {
+		ret = s5p_hash_prepare_sgs(ctx, req->src, nbytes - hash_later,
+					   final);
+		if (ret)
+			return ret;
+	} else {
+		/* have buffered data only */
+		if (unlikely(!ctx->bufcnt)) {
+			/* first update didn't fill up buffer */
+			scatterwalk_map_and_copy(ctx->dd->xmit_buf, req->src,
+						 0, xmit_len, 0);
+		}
+
+		sg_init_table(ctx->sgl, 1);
+		sg_set_buf(ctx->sgl, ctx->dd->xmit_buf, xmit_len);
+
+		ctx->sg = ctx->sgl;
+		ctx->sg_len = 1;
+	}
+
+	ctx->bufcnt = hash_later;
+	if (!final)
+		ctx->total = xmit_len;
+
+	return 0;
+}
+
+/**
+ * s5p_hash_update_dma_stop() - unmap DMA
+ * @dd:		secss device
+ *
+ * Unmap scatterlist ctx->sg.
+ */
+static void s5p_hash_update_dma_stop(struct s5p_aes_dev *dd)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(dd->hash_req);
+
+	dma_unmap_sg(dd->dev, ctx->sg, ctx->sg_len, DMA_TO_DEVICE);
+	clear_bit(HASH_FLAGS_DMA_ACTIVE, &dd->hash_flags);
+}
+
+/**
+ * s5p_hash_finish() - copy calculated digest to crypto layer
+ * @req:	AHASH request
+ */
+static void s5p_hash_finish(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	struct s5p_aes_dev *dd = ctx->dd;
+
+	if (ctx->digcnt)
+		s5p_hash_copy_result(req);
+
+	dev_dbg(dd->dev, "hash_finish digcnt: %lld\n", ctx->digcnt);
+}
+
+/**
+ * s5p_hash_finish_req() - finish request
+ * @req:	AHASH request
+ * @err:	error
+ */
+static void s5p_hash_finish_req(struct ahash_request *req, int err)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	struct s5p_aes_dev *dd = ctx->dd;
+	unsigned long flags;
+
+	if (test_bit(HASH_FLAGS_SGS_COPIED, &dd->hash_flags))
+		free_pages((unsigned long)sg_virt(ctx->sg),
+			   get_order(ctx->sg->length));
+
+	if (test_bit(HASH_FLAGS_SGS_ALLOCED, &dd->hash_flags))
+		kfree(ctx->sg);
+
+	ctx->sg = NULL;
+	dd->hash_flags &= ~(BIT(HASH_FLAGS_SGS_ALLOCED) |
+			    BIT(HASH_FLAGS_SGS_COPIED));
+
+	if (!err && !ctx->error) {
+		s5p_hash_read_msg(req);
+		if (test_bit(HASH_FLAGS_FINAL, &dd->hash_flags))
+			s5p_hash_finish(req);
+	} else {
+		ctx->error = true;
+	}
+
+	spin_lock_irqsave(&dd->hash_lock, flags);
+	dd->hash_flags &= ~(BIT(HASH_FLAGS_BUSY) | BIT(HASH_FLAGS_FINAL) |
+			    BIT(HASH_FLAGS_DMA_READY) |
+			    BIT(HASH_FLAGS_OUTPUT_READY));
+	spin_unlock_irqrestore(&dd->hash_lock, flags);
+
+	if (req->base.complete)
+		req->base.complete(&req->base, err);
+}
+
+/**
+ * s5p_hash_handle_queue() - handle hash queue
+ * @dd:		device s5p_aes_dev
+ * @req:	AHASH request
+ *
+ * If req!=NULL enqueue it on dd->queue, if FLAGS_BUSY is not set on the
+ * device then processes the first request from the dd->queue
+ *
+ * Returns: see s5p_hash_final below.
+ */
+static int s5p_hash_handle_queue(struct s5p_aes_dev *dd,
+				 struct ahash_request *req)
+{
+	struct crypto_async_request *async_req, *backlog;
+	struct s5p_hash_reqctx *ctx;
+	unsigned long flags;
+	int err = 0, ret = 0;
+
+retry:
+	spin_lock_irqsave(&dd->hash_lock, flags);
+	if (req)
+		ret = ahash_enqueue_request(&dd->hash_queue, req);
+
+	if (test_bit(HASH_FLAGS_BUSY, &dd->hash_flags)) {
+		spin_unlock_irqrestore(&dd->hash_lock, flags);
+		return ret;
+	}
+
+	backlog = crypto_get_backlog(&dd->hash_queue);
+	async_req = crypto_dequeue_request(&dd->hash_queue);
+	if (async_req)
+		set_bit(HASH_FLAGS_BUSY, &dd->hash_flags);
+
+	spin_unlock_irqrestore(&dd->hash_lock, flags);
+
+	if (!async_req)
+		return ret;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	req = ahash_request_cast(async_req);
+	dd->hash_req = req;
+	ctx = ahash_request_ctx(req);
+
+	err = s5p_hash_prepare_request(req, ctx->op_update);
+	if (err || !ctx->total)
+		goto out;
+
+	dev_dbg(dd->dev, "handling new req, op_update: %u, nbytes: %d\n",
+		ctx->op_update, req->nbytes);
+
+	s5p_ahash_dma_init(dd, SSS_HASHIN_INDEPENDENT);
+	if (ctx->digcnt)
+		s5p_hash_write_iv(req); /* restore hash IV */
+
+	if (ctx->op_update) { /* HASH_OP_UPDATE */
+		err = s5p_hash_xmit_dma(dd, ctx->total, ctx->finup);
+		if (err != -EINPROGRESS && ctx->finup && !ctx->error)
+			/* no final() after finup() */
+			err = s5p_hash_xmit_dma(dd, ctx->total, true);
+	} else { /* HASH_OP_FINAL */
+		err = s5p_hash_xmit_dma(dd, ctx->total, true);
+	}
+out:
+	if (err != -EINPROGRESS) {
+		/* hash_tasklet_cb will not finish it, so do it here */
+		s5p_hash_finish_req(req, err);
+		req = NULL;
+
+		/*
+		 * Execute next request immediately if there is anything
+		 * in queue.
+		 */
+		goto retry;
+	}
+
+	return ret;
+}
+
+/**
+ * s5p_hash_tasklet_cb() - hash tasklet
+ * @data:	ptr to s5p_aes_dev
+ */
+static void s5p_hash_tasklet_cb(unsigned long data)
+{
+	struct s5p_aes_dev *dd = (struct s5p_aes_dev *)data;
+
+	if (!test_bit(HASH_FLAGS_BUSY, &dd->hash_flags)) {
+		s5p_hash_handle_queue(dd, NULL);
+		return;
+	}
+
+	if (test_bit(HASH_FLAGS_DMA_READY, &dd->hash_flags)) {
+		if (test_and_clear_bit(HASH_FLAGS_DMA_ACTIVE,
+				       &dd->hash_flags)) {
+			s5p_hash_update_dma_stop(dd);
+		}
+
+		if (test_and_clear_bit(HASH_FLAGS_OUTPUT_READY,
+				       &dd->hash_flags)) {
+			/* hash or semi-hash ready */
+			clear_bit(HASH_FLAGS_DMA_READY, &dd->hash_flags);
+				goto finish;
+		}
+	}
+
+	return;
+
+finish:
+	/* finish curent request */
+	s5p_hash_finish_req(dd->hash_req, 0);
+
+	/* If we are not busy, process next req */
+	if (!test_bit(HASH_FLAGS_BUSY, &dd->hash_flags))
+		s5p_hash_handle_queue(dd, NULL);
+}
+
+/**
+ * s5p_hash_enqueue() - enqueue request
+ * @req:	AHASH request
+ * @op:		operation UPDATE (true) or FINAL (false)
+ *
+ * Returns: see s5p_hash_final below.
+ */
+static int s5p_hash_enqueue(struct ahash_request *req, bool op)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+
+	ctx->op_update = op;
+
+	return s5p_hash_handle_queue(tctx->dd, req);
+}
+
+/**
+ * s5p_hash_update() - process the hash input data
+ * @req:	AHASH request
+ *
+ * If request will fit in buffer, copy it and return immediately
+ * else enqueue it with OP_UPDATE.
+ *
+ * Returns: see s5p_hash_final below.
+ */
+static int s5p_hash_update(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+
+	if (!req->nbytes)
+		return 0;
+
+	if (ctx->bufcnt + req->nbytes <= BUFLEN) {
+		scatterwalk_map_and_copy(ctx->buffer + ctx->bufcnt, req->src,
+					 0, req->nbytes, 0);
+		ctx->bufcnt += req->nbytes;
+		return 0;
+	}
+
+	return s5p_hash_enqueue(req, true); /* HASH_OP_UPDATE */
+}
+
+/**
+ * s5p_hash_shash_digest() - calculate shash digest
+ * @tfm:	crypto transformation
+ * @flags:	tfm flags
+ * @data:	input data
+ * @len:	length of data
+ * @out:	output buffer
+ */
+static int s5p_hash_shash_digest(struct crypto_shash *tfm, u32 flags,
+				 const u8 *data, unsigned int len, u8 *out)
+{
+	SHASH_DESC_ON_STACK(shash, tfm);
+
+	shash->tfm = tfm;
+	shash->flags = flags & ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_shash_digest(shash, data, len, out);
+}
+
+/**
+ * s5p_hash_final_shash() - calculate shash digest
+ * @req:	AHASH request
+ */
+static int s5p_hash_final_shash(struct ahash_request *req)
+{
+	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+
+	return s5p_hash_shash_digest(tctx->fallback, req->base.flags,
+				     ctx->buffer, ctx->bufcnt, req->result);
+}
+
+/**
+ * s5p_hash_final() - close up hash and calculate digest
+ * @req:	AHASH request
+ *
+ * Note: in final req->src do not have any data, and req->nbytes can be
+ * non-zero.
+ *
+ * If there were no input data processed yet and the buffered hash data is
+ * less than BUFLEN (64) then calculate the final hash immediately by using
+ * SW algorithm fallback.
+ *
+ * Otherwise enqueues the current AHASH request with OP_FINAL operation op
+ * and finalize hash message in HW. Note that if digcnt!=0 then there were
+ * previous update op, so there are always some buffered bytes in ctx->buffer,
+ * which means that ctx->bufcnt!=0
+ *
+ * Returns:
+ * 0 if the request has been processed immediately,
+ * -EINPROGRESS if the operation has been queued for later execution or is set
+ *		to processing by HW,
+ * -EBUSY if queue is full and request should be resubmitted later, other
+ *		negative values on error.
+ */
+static int s5p_hash_final(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+
+	ctx->finup = true;
+	if (ctx->error)
+		return -EINVAL; /* uncompleted hash is not needed */
+
+	if (!ctx->digcnt && ctx->bufcnt < BUFLEN)
+		return s5p_hash_final_shash(req);
+
+	return s5p_hash_enqueue(req, false); /* HASH_OP_FINAL */
+}
+
+/**
+ * s5p_hash_finup() - process last req->src and calculate digest
+ * @req:	AHASH request containing the last update data
+ *
+ * Return values: see s5p_hash_final above.
+ */
+static int s5p_hash_finup(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	int err1, err2;
+
+	ctx->finup = true;
+
+	err1 = s5p_hash_update(req);
+	if (err1 == -EINPROGRESS || err1 == -EBUSY)
+		return err1;
+
+	/*
+	 * final() has to be always called to cleanup resources even if
+	 * update() failed, except EINPROGRESS or calculate digest for small
+	 * size
+	 */
+	err2 = s5p_hash_final(req);
+
+	return err1 ?: err2;
+}
+
+/**
+ * s5p_hash_init() - initialize AHASH request contex
+ * @req:	AHASH request
+ *
+ * Init async hash request context.
+ */
+static int s5p_hash_init(struct ahash_request *req)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s5p_hash_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	ctx->dd = tctx->dd;
+	ctx->error = false;
+	ctx->finup = false;
+	ctx->bufcnt = 0;
+	ctx->digcnt = 0;
+	ctx->total = 0;
+	ctx->skip = 0;
+
+	dev_dbg(tctx->dd->dev, "init: digest size: %d\n",
+		crypto_ahash_digestsize(tfm));
+
+	switch (crypto_ahash_digestsize(tfm)) {
+	case MD5_DIGEST_SIZE:
+		ctx->engine = SSS_HASH_ENGINE_MD5;
+		ctx->nregs = HASH_MD5_MAX_REG;
+		break;
+	case SHA1_DIGEST_SIZE:
+		ctx->engine = SSS_HASH_ENGINE_SHA1;
+		ctx->nregs = HASH_SHA1_MAX_REG;
+		break;
+	case SHA256_DIGEST_SIZE:
+		ctx->engine = SSS_HASH_ENGINE_SHA256;
+		ctx->nregs = HASH_SHA256_MAX_REG;
+		break;
+	default:
+		ctx->error = true;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * s5p_hash_digest - calculate digest from req->src
+ * @req:	AHASH request
+ *
+ * Return values: see s5p_hash_final above.
+ */
+static int s5p_hash_digest(struct ahash_request *req)
+{
+	return s5p_hash_init(req) ?: s5p_hash_finup(req);
+}
+
+/**
+ * s5p_hash_cra_init_alg - init crypto alg transformation
+ * @tfm:	crypto transformation
+ */
+static int s5p_hash_cra_init_alg(struct crypto_tfm *tfm)
+{
+	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(tfm);
+	const char *alg_name = crypto_tfm_alg_name(tfm);
+
+	tctx->dd = s5p_dev;
+	/* Allocate a fallback and abort if it failed. */
+	tctx->fallback = crypto_alloc_shash(alg_name, 0,
+					    CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(tctx->fallback)) {
+		pr_err("fallback alloc fails for '%s'\n", alg_name);
+		return PTR_ERR(tctx->fallback);
+	}
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct s5p_hash_reqctx) + BUFLEN);
+
+	return 0;
+}
+
+/**
+ * s5p_hash_cra_init - init crypto tfm
+ * @tfm:	crypto transformation
+ */
+static int s5p_hash_cra_init(struct crypto_tfm *tfm)
+{
+	return s5p_hash_cra_init_alg(tfm);
+}
+
+/**
+ * s5p_hash_cra_exit - exit crypto tfm
+ * @tfm:	crypto transformation
+ *
+ * free allocated fallback
+ */
+static void s5p_hash_cra_exit(struct crypto_tfm *tfm)
+{
+	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(tctx->fallback);
+	tctx->fallback = NULL;
+}
+
+/**
+ * s5p_hash_export - export hash state
+ * @req:	AHASH request
+ * @out:	buffer for exported state
+ */
+static int s5p_hash_export(struct ahash_request *req, void *out)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+
+	memcpy(out, ctx, sizeof(*ctx) + ctx->bufcnt);
+
+	return 0;
+}
+
+/**
+ * s5p_hash_import - import hash state
+ * @req:	AHASH request
+ * @in:		buffer with state to be imported from
+ */
+static int s5p_hash_import(struct ahash_request *req, const void *in)
+{
+	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s5p_hash_ctx *tctx = crypto_ahash_ctx(tfm);
+	const struct s5p_hash_reqctx *ctx_in = in;
+
+	memcpy(ctx, in, sizeof(*ctx) + BUFLEN);
+	if (ctx_in->bufcnt < 0 || ctx_in->bufcnt > BUFLEN) {
+		ctx->error = true;
+		return -EINVAL;
+	}
+
+	ctx->dd = tctx->dd;
+	ctx->error = false;
+
+	return 0;
+}
+
+static struct ahash_alg algs_sha1_md5_sha256[] = {
+{
+	.init		= s5p_hash_init,
+	.update		= s5p_hash_update,
+	.final		= s5p_hash_final,
+	.finup		= s5p_hash_finup,
+	.digest		= s5p_hash_digest,
+	.export		= s5p_hash_export,
+	.import		= s5p_hash_import,
+	.halg.statesize = sizeof(struct s5p_hash_reqctx) + BUFLEN,
+	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha1",
+		.cra_driver_name	= "exynos-sha1",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= HASH_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
+		.cra_alignmask		= SSS_HASH_DMA_ALIGN_MASK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= s5p_hash_cra_init,
+		.cra_exit		= s5p_hash_cra_exit,
+	}
+},
+{
+	.init		= s5p_hash_init,
+	.update		= s5p_hash_update,
+	.final		= s5p_hash_final,
+	.finup		= s5p_hash_finup,
+	.digest		= s5p_hash_digest,
+	.export		= s5p_hash_export,
+	.import		= s5p_hash_import,
+	.halg.statesize = sizeof(struct s5p_hash_reqctx) + BUFLEN,
+	.halg.digestsize	= MD5_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "md5",
+		.cra_driver_name	= "exynos-md5",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= HASH_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
+		.cra_alignmask		= SSS_HASH_DMA_ALIGN_MASK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= s5p_hash_cra_init,
+		.cra_exit		= s5p_hash_cra_exit,
+	}
+},
+{
+	.init		= s5p_hash_init,
+	.update		= s5p_hash_update,
+	.final		= s5p_hash_final,
+	.finup		= s5p_hash_finup,
+	.digest		= s5p_hash_digest,
+	.export		= s5p_hash_export,
+	.import		= s5p_hash_import,
+	.halg.statesize = sizeof(struct s5p_hash_reqctx) + BUFLEN,
+	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha256",
+		.cra_driver_name	= "exynos-sha256",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= HASH_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
+		.cra_alignmask		= SSS_HASH_DMA_ALIGN_MASK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= s5p_hash_cra_init,
+		.cra_exit		= s5p_hash_cra_exit,
+	}
+}
+
+};
+
 static void s5p_set_aes(struct s5p_aes_dev *dev,
 			uint8_t *key, uint8_t *iv, unsigned int keylen)
 {
@@ -829,6 +2155,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	struct samsung_aes_variant *variant;
 	struct s5p_aes_dev *pdata;
 	struct resource *res;
+	unsigned int hash_i;
 
 	if (s5p_dev)
 		return -EEXIST;
@@ -837,12 +2164,34 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -ENOMEM;
 
+	variant = find_s5p_sss_version(pdev);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(pdata->ioaddr))
-		return PTR_ERR(pdata->ioaddr);
 
-	variant = find_s5p_sss_version(pdev);
+	/*
+	 * Note: HASH and PRNG uses the same registers in secss, avoid
+	 * overwrite each other. This will drop HASH when CONFIG_EXYNOS_RNG
+	 * is enabled in config. We need larger size for HASH registers in
+	 * secss, current describe only AES/DES
+	 */
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_EXYNOS_HASH)) {
+		if (variant == &exynos_aes_data) {
+			res->end += 0x300;
+			pdata->use_hash = true;
+		}
+	}
+
+	pdata->res = res;
+	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->ioaddr)) {
+		if (!pdata->use_hash)
+			return PTR_ERR(pdata->ioaddr);
+		/* try AES without HASH */
+		res->end -= 0x300;
+		pdata->use_hash = false;
+		pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(pdata->ioaddr))
+			return PTR_ERR(pdata->ioaddr);
+	}
 
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
@@ -857,8 +2206,10 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&pdata->lock);
+	spin_lock_init(&pdata->hash_lock);
 
 	pdata->aes_ioaddr = pdata->ioaddr + variant->aes_offset;
+	pdata->io_hash_base = pdata->ioaddr + variant->hash_offset;
 
 	pdata->irq_fc = platform_get_irq(pdev, 0);
 	if (pdata->irq_fc < 0) {
@@ -888,12 +2239,40 @@ static int s5p_aes_probe(struct platform_device *pdev)
 			goto err_algs;
 	}
 
+	if (pdata->use_hash) {
+		tasklet_init(&pdata->hash_tasklet, s5p_hash_tasklet_cb,
+			     (unsigned long)pdata);
+		crypto_init_queue(&pdata->hash_queue, SSS_HASH_QUEUE_LENGTH);
+
+		for (hash_i = 0; hash_i < ARRAY_SIZE(algs_sha1_md5_sha256);
+		     hash_i++) {
+			struct ahash_alg *alg;
+
+			alg = &algs_sha1_md5_sha256[hash_i];
+			err = crypto_register_ahash(alg);
+			if (err) {
+				dev_err(dev, "can't register '%s': %d\n",
+					alg->halg.base.cra_driver_name, err);
+				goto err_hash;
+			}
+		}
+	}
+
 	dev_info(dev, "s5p-sss driver registered\n");
 
 	return 0;
 
+err_hash:
+	for (j = hash_i - 1; j >= 0; j--)
+		crypto_unregister_ahash(&algs_sha1_md5_sha256[j]);
+
+	tasklet_kill(&pdata->hash_tasklet);
+	res->end -= 0x300;
+
 err_algs:
-	dev_err(dev, "can't register '%s': %d\n", algs[i].cra_name, err);
+	if (i < ARRAY_SIZE(algs))
+		dev_err(dev, "can't register '%s': %d\n", algs[i].cra_name,
+			err);
 
 	for (j = 0; j < i; j++)
 		crypto_unregister_alg(&algs[j]);
@@ -920,9 +2299,16 @@ static int s5p_aes_remove(struct platform_device *pdev)
 		crypto_unregister_alg(&algs[i]);
 
 	tasklet_kill(&pdata->tasklet);
+	if (pdata->use_hash) {
+		for (i = ARRAY_SIZE(algs_sha1_md5_sha256) - 1; i >= 0; i--)
+			crypto_unregister_ahash(&algs_sha1_md5_sha256[i]);
 
-	clk_disable_unprepare(pdata->clk);
+		pdata->res->end -= 0x300;
+		tasklet_kill(&pdata->hash_tasklet);
+		pdata->use_hash = false;
+	}
 
+	clk_disable_unprepare(pdata->clk);
 	s5p_dev = NULL;
 
 	return 0;
@@ -942,3 +2328,4 @@ module_platform_driver(s5p_aes_crypto);
 MODULE_DESCRIPTION("S5PV210 AES hw acceleration support.");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Vladimir Zapolskiy <vzapolskiy@gmail.com>");
+MODULE_AUTHOR("Kamil Konieczny <k.konieczny@partner.samsung.com>");
-- 
2.14.1.536.g6867272d5b56
