From: "Sebastian A. Siewior" <arm-kernel@ml.breakpoint.cc>
Subject: [RFC 1/2] crypto/cesa: add idma for Orion5X support
Date: Fri, 14 Aug 2009 21:09:49 +0200
Message-ID: <1250276990-28006-2-git-send-email-arm-kernel@ml.breakpoint.cc>
References: <1250276990-28006-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57743 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756912AbZHNTKL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 15:10:11 -0400
In-Reply-To: <1250276990-28006-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Siewior <sebastian@breakpoint.cc>

This patch adds iDMA support and wires up the CESA engine

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/arm/include/asm/idma.h                  |   15 ++
 arch/arm/mach-orion5x/addr-map.c             |   11 +
 arch/arm/mach-orion5x/common.c               |   45 +++++
 arch/arm/mach-orion5x/common.h               |    3 +
 arch/arm/mach-orion5x/include/mach/orion5x.h |    1 +
 drivers/crypto/Kconfig                       |    5 +
 drivers/crypto/Makefile                      |    1 +
 drivers/crypto/mv_cesa.c                     |  144 +++++++++++----
 drivers/crypto/mv_idma.c                     |  259 ++++++++++++++++++++++++++
 9 files changed, 446 insertions(+), 38 deletions(-)
 create mode 100644 arch/arm/include/asm/idma.h
 create mode 100644 drivers/crypto/mv_idma.c

diff --git a/arch/arm/include/asm/idma.h b/arch/arm/include/asm/idma.h
new file mode 100644
index 0000000..45799ad
--- /dev/null
+++ b/arch/arm/include/asm/idma.h
@@ -0,0 +1,15 @@
+#ifndef __ASMARM_IDMA__
+#define __ASMARM_IDMA__
+
+struct cesa_sram_info {
+	unsigned int target_id;
+	unsigned int attr;
+	unsigned int base;
+};
+
+struct idma_pdata {
+	struct cesa_sram_info *sram;
+	struct mbus_dram_target_info *dram;
+};
+
+#endif
diff --git a/arch/arm/mach-orion5x/addr-map.c b/arch/arm/mach-orion5x/addr-map.c
index d78731e..dc36ceb 100644
--- a/arch/arm/mach-orion5x/addr-map.c
+++ b/arch/arm/mach-orion5x/addr-map.c
@@ -75,6 +75,17 @@
 
 
 struct mbus_dram_target_info orion5x_mbus_dram_info;
+struct cesa_sram_info orion5x_sram_info = {
+	/* Form some reason it is different than for the CPU. Ask me why */
+#if 0
+	.target_id = TARGET_SRAM,
+	.attr = ATTR_SRAM,
+#endif
+	.target_id = 5,
+	.attr = 0,
+	.base = ORION5X_SRAM_PHYS_BASE,
+};
+
 static int __initdata win_alloc_count;
 
 static int __init orion5x_cpu_win_can_remap(int win)
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index f87fa12..b464aed 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -26,6 +26,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
+#include <asm/idma.h>
 #include <mach/hardware.h>
 #include <mach/orion5x.h>
 #include <plat/ehci-orion.h>
@@ -562,6 +563,46 @@ static struct platform_device orion5x_crypto_device = {
 	.resource       = orion5x_crypto_res,
 };
 
+static struct resource orion5x_idma_res[] = {
+	/* The register space is a damn mess */
+	{
+		.name   = "regs base",
+		.start  = ORION5X_IDMA_PHYS_BASE + 0x800,
+		.end    = ORION5X_IDMA_PHYS_BASE + 0x800 + 0x100 - 1,
+		.flags  = IORESOURCE_MEM,
+	}, {
+		.name   = "regs deco",
+		.start  = ORION5X_IDMA_PHYS_BASE + 0xa00,
+		.end    = ORION5X_IDMA_PHYS_BASE + 0xa00 + 0x100  - 1,
+		.flags  = IORESOURCE_MEM,
+	}, {
+		.name   = "int 0",
+		.start  = IRQ_ORION5X_IDMA_0,
+		.end    = IRQ_ORION5X_IDMA_0,
+		.flags  = IORESOURCE_IRQ,
+	}, {
+		.name   = "int err",
+		.start  = IRQ_ORION5X_IDMA_ERR,
+		.end    = IRQ_ORION5X_IDMA_ERR,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct idma_pdata orion5x_idma_pdata = {
+	.sram = &orion5x_sram_info,
+	.dram = &orion5x_mbus_dram_info,
+};
+
+static struct platform_device orion5x_idma_device = {
+	.name           = "mv_idma",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(orion5x_idma_res),
+	.resource       = orion5x_idma_res,
+	.dev		= {
+		.platform_data	= &orion5x_idma_pdata,
+	},
+};
+
 static int __init orion5x_crypto_init(void)
 {
 	int ret;
@@ -570,6 +611,10 @@ static int __init orion5x_crypto_init(void)
 	if (ret)
 		return ret;
 
+	ret = platform_device_register(&orion5x_idma_device);
+	if (ret)
+		printk(KERN_ERR "ORiON iDMA error: %d\n", ret);
+
 	return platform_device_register(&orion5x_crypto_device);
 }
 
diff --git a/arch/arm/mach-orion5x/common.h b/arch/arm/mach-orion5x/common.h
index 8f00450..c00bd9a 100644
--- a/arch/arm/mach-orion5x/common.h
+++ b/arch/arm/mach-orion5x/common.h
@@ -1,5 +1,6 @@
 #ifndef __ARCH_ORION5X_COMMON_H
 #define __ARCH_ORION5X_COMMON_H
+#include <asm/idma.h>
 
 struct dsa_platform_data;
 struct mv643xx_eth_platform_data;
@@ -20,6 +21,8 @@ extern struct sys_timer orion5x_timer;
  * board devices. Details in /mach-orion/addr-map.c
  */
 extern struct mbus_dram_target_info orion5x_mbus_dram_info;
+extern struct cesa_sram_info orion5x_sram_info;
+
 void orion5x_setup_cpu_mbus_bridge(void);
 void orion5x_setup_dev_boot_win(u32 base, u32 size);
 void orion5x_setup_dev0_win(u32 base, u32 size);
diff --git a/arch/arm/mach-orion5x/include/mach/orion5x.h b/arch/arm/mach-orion5x/include/mach/orion5x.h
index 2d87665..e34357c 100644
--- a/arch/arm/mach-orion5x/include/mach/orion5x.h
+++ b/arch/arm/mach-orion5x/include/mach/orion5x.h
@@ -99,6 +99,7 @@
 #define ORION5X_SATA_VIRT_BASE		(ORION5X_REGS_VIRT_BASE | 0x80000)
 
 #define ORION5X_CRYPTO_PHYS_BASE	(ORION5X_REGS_PHYS_BASE | 0x90000)
+#define ORION5X_IDMA_PHYS_BASE		(ORION5X_REGS_PHYS_BASE | 0x60000)
 
 #define ORION5X_USB1_PHYS_BASE		(ORION5X_REGS_PHYS_BASE | 0xa0000)
 #define ORION5X_USB1_VIRT_BASE		(ORION5X_REGS_VIRT_BASE | 0xa0000)
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index efc9484..e67ed44 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -157,12 +157,17 @@ config S390_PRNG
 	  ANSI X9.17 standard. The PRNG is usable via the char device
 	  /dev/prandom.
 
+config CRYPTO_DEV_MV_IDMA
+	tristate
+	depends on PLAT_ORION
+
 config CRYPTO_DEV_MV_CESA
 	tristate "Marvell's Cryptographic Engine"
 	depends on PLAT_ORION
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
+	select CRYPTO_DEV_MV_IDMA
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6ffcb3f..c0d6252 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
+obj-$(CONFIG_CRYPTO_DEV_MV_IDMA) += mv_idma.o
 obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index f28502c..ef3404b 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 
 #include "mv_cesa.h"
 /*
@@ -36,10 +37,8 @@ enum engine_status {
  * struct req_progress - used for every crypt request
  * @src_sg_it:		sg iterator for src
  * @dst_sg_it:		sg iterator for dst
- * @sg_src_left:	bytes left in src to process (scatter list)
  * @src_start:		offset to add to src start position (scatter list)
  * @crypt_len:		length of current crypt process
- * @sg_dst_left:	bytes left dst to process in this scatter list
  * @dst_start:		offset to add to dst start position (scatter list)
  * @total_req_bytes:	total number of bytes processed (request).
  *
@@ -48,15 +47,10 @@ enum engine_status {
  * track of progress within current scatterlist.
  */
 struct req_progress {
-	struct sg_mapping_iter src_sg_it;
-	struct sg_mapping_iter dst_sg_it;
-
 	/* src mostly */
-	int sg_src_left;
 	int src_start;
 	int crypt_len;
 	/* dst mostly */
-	int sg_dst_left;
 	int dst_start;
 	int total_req_bytes;
 };
@@ -64,6 +58,7 @@ struct req_progress {
 struct crypto_priv {
 	void __iomem *reg;
 	void __iomem *sram;
+	u32 sram_phys;
 	int irq;
 	struct task_struct *queue_th;
 
@@ -94,6 +89,14 @@ enum crypto_op {
 struct mv_req_ctx {
 	enum crypto_op op;
 	int decrypt;
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
+	int num_src_sg;
+	int num_dst_sg;
+	int sg_src_left;
+	int sg_dst_left;
+	/* src == dst, bidi mapping */
+	int inplace;
 };
 
 static void compute_aes_dec_key(struct mv_ctx *ctx)
@@ -143,26 +146,30 @@ static int mv_setkey_aes(struct crypto_ablkcipher *cipher, const u8 *key,
 	return 0;
 }
 
+void mv_idma_memcpy(dma_addr_t dst, dma_addr_t src, unsigned int size);
+
 static void setup_data_in(struct ablkcipher_request *req)
 {
-	int ret;
-	void *buf;
+	dma_addr_t buf;
+	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 
-	if (!cpg->p.sg_src_left) {
-		ret = sg_miter_next(&cpg->p.src_sg_it);
-		BUG_ON(!ret);
-		cpg->p.sg_src_left = cpg->p.src_sg_it.length;
+	if (!req_ctx->sg_src_left) {
+		/* next sg please */
+		req_ctx->src_sg = sg_next(req_ctx->src_sg);
+		BUG_ON(!req_ctx->src_sg);
+		req_ctx->sg_src_left = sg_dma_len(req_ctx->src_sg);
 		cpg->p.src_start = 0;
 	}
 
-	cpg->p.crypt_len = min(cpg->p.sg_src_left, cpg->max_req_size);
+	cpg->p.crypt_len = min(req_ctx->sg_src_left, cpg->max_req_size);
 
-	buf = cpg->p.src_sg_it.addr;
+	buf = sg_dma_address(req_ctx->src_sg);
 	buf += cpg->p.src_start;
 
-	memcpy(cpg->sram + SRAM_DATA_IN_START, buf, cpg->p.crypt_len);
-
-	cpg->p.sg_src_left -= cpg->p.crypt_len;
+	mv_idma_memcpy(cpg->sram_phys + SRAM_DATA_IN_START,
+			buf,
+			cpg->p.crypt_len);
+	req_ctx->sg_src_left -= cpg->p.crypt_len;
 	cpg->p.src_start += cpg->p.crypt_len;
 }
 
@@ -218,7 +225,6 @@ static void mv_process_current_q(int first_block)
 	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 	/* GO */
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
-
 	/*
 	 * XXX: add timer if the interrupt does not occur for some mystery
 	 * reason
@@ -239,28 +245,30 @@ static void mv_crypto_algo_completion(void)
 static void dequeue_complete_req(void)
 {
 	struct ablkcipher_request *req = cpg->cur_req;
-	void *buf;
-	int ret;
+	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 
 	cpg->p.total_req_bytes += cpg->p.crypt_len;
 	do {
 		int dst_copy;
+		dma_addr_t buf;
 
-		if (!cpg->p.sg_dst_left) {
-			ret = sg_miter_next(&cpg->p.dst_sg_it);
-			BUG_ON(!ret);
-			cpg->p.sg_dst_left = cpg->p.dst_sg_it.length;
+		if (!req_ctx->sg_dst_left) {
+			/* next sg please */
+			req_ctx->dst_sg = sg_next(req_ctx->dst_sg);
+			BUG_ON(!req_ctx->dst_sg);
+			req_ctx->sg_dst_left = sg_dma_len(req_ctx->dst_sg);
 			cpg->p.dst_start = 0;
 		}
 
-		buf = cpg->p.dst_sg_it.addr;
+		buf = sg_dma_address(req_ctx->dst_sg);
 		buf += cpg->p.dst_start;
 
-		dst_copy = min(cpg->p.crypt_len, cpg->p.sg_dst_left);
+		dst_copy = min(cpg->p.crypt_len, cpg->p.crypt_len);
 
-		memcpy(buf, cpg->sram + SRAM_DATA_OUT_START, dst_copy);
-
-		cpg->p.sg_dst_left -= dst_copy;
+		mv_idma_memcpy(buf,
+			cpg->sram_phys + SRAM_DATA_OUT_START,
+			dst_copy);
+		req_ctx->sg_dst_left -= dst_copy;
 		cpg->p.crypt_len -= dst_copy;
 		cpg->p.dst_start += dst_copy;
 	} while (cpg->p.crypt_len > 0);
@@ -271,8 +279,12 @@ static void dequeue_complete_req(void)
 		cpg->eng_st = ENGINE_BUSY;
 		mv_process_current_q(0);
 	} else {
-		sg_miter_stop(&cpg->p.src_sg_it);
-		sg_miter_stop(&cpg->p.dst_sg_it);
+		if (req_ctx->inplace) {
+			dma_unmap_sg(NULL, req->src, req_ctx->num_src_sg, DMA_BIDIRECTIONAL);
+		} else {
+			dma_unmap_sg(NULL, req->src, req_ctx->num_src_sg, DMA_TO_DEVICE);
+			dma_unmap_sg(NULL, req->dst, req_ctx->num_dst_sg, DMA_FROM_DEVICE);
+		}
 		mv_crypto_algo_completion();
 		cpg->eng_st = ENGINE_IDLE;
 		req->base.complete(&req->base, 0);
@@ -294,8 +306,6 @@ static int count_sgs(struct scatterlist *sl, unsigned int total_bytes)
 
 static void mv_enqueue_new_req(struct ablkcipher_request *req)
 {
-	int num_sgs;
-
 	cpg->cur_req = req;
 	memset(&cpg->p, 0, sizeof(struct req_progress));
 
@@ -351,13 +361,70 @@ static int queue_manag(void *data)
 
 static int mv_handle_req(struct ablkcipher_request *req)
 {
+	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	unsigned long flags;
+	unsigned int n_sgs;
 	int ret;
+	int enqueue_plz = 0;
+
+	/* assume inplace request */
+	if (req->src == req->dst) {
+		n_sgs = count_sgs(req->src, req->nbytes);
+		req_ctx->src_sg = req->src;
+		req_ctx->dst_sg = req->src;
+		ret = dma_map_sg(NULL, req->src, n_sgs, DMA_BIDIRECTIONAL);
+		if (ret < 1) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		req_ctx->inplace = 1;
+		req_ctx->num_src_sg = ret;
+		req_ctx->sg_src_left = sg_dma_len(req->src);
+		req_ctx->sg_dst_left = sg_dma_len(req->src);
+	} else {
+		int src_sgs;
+		int dst_sgs;
+
+		n_sgs = count_sgs(req->src, req->nbytes);
+		src_sgs = dma_map_sg(NULL, req->src, n_sgs, DMA_TO_DEVICE);
+		if (src_sgs < 1) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		n_sgs = count_sgs(req->dst, req->nbytes);
+		dst_sgs = dma_map_sg(NULL, req->dst, n_sgs, DMA_FROM_DEVICE);
+		if (dst_sgs < 1) {
+			ret = -ENOMEM;
+			dma_unmap_sg(NULL, req->src, src_sgs, DMA_TO_DEVICE);
+			goto out;
+		}
+
+		req_ctx->num_src_sg = src_sgs;
+		req_ctx->num_dst_sg = dst_sgs;
+		req_ctx->src_sg = req->src;
+		req_ctx->dst_sg = req->dst;
+		req_ctx->sg_src_left = sg_dma_len(req->src);
+		req_ctx->sg_dst_left = sg_dma_len(req->dst);
+	}
 
 	spin_lock_irqsave(&cpg->lock, flags);
-	ret = ablkcipher_enqueue_request(&cpg->queue, req);
+	/* If the engine is idle, we enqueue it on HW start processing. In the
+	 * other case we put in in the queue and enqueue it once we dequeue the
+	 * earlier request.
+	 */
+	if (cpg->eng_st == ENGINE_IDLE) {
+		cpg->eng_st = ENGINE_BUSY;
+		enqueue_plz = 1;
+		ret = -EINPROGRESS;
+	} else {
+		ret = ablkcipher_enqueue_request(&cpg->queue, req);
+	}
 	spin_unlock_irqrestore(&cpg->lock, flags);
-	wake_up_process(cpg->queue_th);
+
+	if (enqueue_plz)
+		mv_enqueue_new_req(req);
+out:
 	return ret;
 }
 
@@ -435,7 +502,7 @@ struct crypto_alg mv_aes_alg_ecb = {
 	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= 16,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
-	.cra_alignmask	= 0,
+	.cra_alignmask	= 7,
 	.cra_type	= &crypto_ablkcipher_type,
 	.cra_module	= THIS_MODULE,
 	.cra_init	= mv_cra_init,
@@ -457,7 +524,7 @@ struct crypto_alg mv_aes_alg_cbc = {
 	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize	= AES_BLOCK_SIZE,
 	.cra_ctxsize	= sizeof(struct mv_ctx),
-	.cra_alignmask	= 0,
+	.cra_alignmask	= 7,
 	.cra_type	= &crypto_ablkcipher_type,
 	.cra_module	= THIS_MODULE,
 	.cra_init	= mv_cra_init,
@@ -508,6 +575,7 @@ static int mv_probe(struct platform_device *pdev)
 	}
 	cp->sram_size = res->end - res->start + 1;
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
+	cp->sram_phys = res->start;
 	cp->sram = ioremap(res->start, cp->sram_size);
 	if (!cp->sram) {
 		ret = -ENOMEM;
diff --git a/drivers/crypto/mv_idma.c b/drivers/crypto/mv_idma.c
new file mode 100644
index 0000000..7ffe604
--- /dev/null
+++ b/drivers/crypto/mv_idma.c
@@ -0,0 +1,259 @@
+/*
+ * Support for the IDMA engine. The driver is directly used by the CESA driver.
+ * Generall DMA driver is provided by the XOR driver and CH0 has to be used by
+ * the CESA unit.
+ */
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/mbus.h>
+#include <asm/idma.h>
+#include <linux/delay.h>
+
+/*
+ * descriptor
+ */
+
+struct idma_desc {
+	u32 bytes_count;
+	u32 src;
+	u32 dst;
+	u32 next_descr;
+} __attribute__ ((packed));
+
+/* "base" IDMA registers */
+
+#define IDMA_BYTE_CNT(chan)	(0x00000 + (chan) * 4)
+#define IDMA_BYTE_OWN		(1 << 31)
+
+#define IDMA_SRC_ADDR(chan)	(0x00010 + (chan) * 4)
+#define IDMA_DST_ADDR(chan)	(0x00020 + (chan) * 4)
+#define IDMA_NEXT_DESC(chan)	(0x00030 + (chan) * 4)
+#define IDMA_CUR_DESC(chan)	(0x00070 + (chan) * 4)
+
+#define CHAN_NEXT_DESCR(chan)	(0x00032 + (chan) * 4)
+
+#define IDMA_CTRL_CHAN(num)	(0x00040 + (num) * 4)
+#define CTRL_DST_BURST_128	4
+#define CTRL_SRC_BURST_128	(4 << 6)
+#define CTRL_NON_CHAIN		(1 << 9)
+#define CTRL_INT_NO_DESC	(1 << 10)
+#define CTRL_CHAN_EN		(1 << 12)
+#define CTRL_RESERVED_MUST1	(1 << 11)
+#define CTRL_FETCH_ND		(1 << 13)
+#define CTRL_CHAN_ACT		(1 << 14)
+#define CTRL_CDE		(1 << 17)
+#define CTRL_ABORT		(1 << 17)
+#define CTRL_DEST_16M		(1 << 31)
+
+/* "addr decode" IDMA registers */
+#define BASE_ADDR_BAR(num)	(0x00000 + (num) * 8)
+#define BASE_ATTR(x)		(x << 8)
+#define BASE_ADDR(x)		(x & 0xffff0000)
+
+#define BAR_SIZE(num)		(0x00004 + (num) * 8)
+#define IN_64KIB(x)		DIV_ROUND_UP(x, 64 * 1024)
+#define BAR_WND_SIZE_NUM(x)	((x - 1) & 0xffff0000)
+
+#define BASE_ADDR_EN		0x00080
+#define WIN_ACCESS_PROT(chan)	(0x00070 + (chan) * 4)
+#define WIN_ACCESS_RW(wnd)	(3 << (wnd * 2))
+
+struct idma_priv {
+	void __iomem *reg;
+	int irq_err;
+	int irq_0;
+	struct idma_desc *desc;
+	dma_addr_t desc_dma;
+};
+
+#define IDMA_CTRL_FLAGS	(CTRL_CHAN_EN | CTRL_NON_CHAIN | CTRL_RESERVED_MUST1 |\
+		CTRL_DST_BURST_128 | CTRL_SRC_BURST_128)
+
+static struct idma_priv *ipg;
+void mv_idma_memcpy(dma_addr_t dst, dma_addr_t src, unsigned int size)
+{
+	int status;
+	int count = 0;
+	static int init;
+	static void *src_data;
+	static dma_addr_t src_data_dma;
+
+	writel(src, ipg->reg + IDMA_SRC_ADDR(0));
+	writel(dst, ipg->reg + IDMA_DST_ADDR(0));
+	writel(size, ipg->reg + IDMA_BYTE_CNT(0));
+
+	writel(IDMA_CTRL_FLAGS, ipg->reg + IDMA_CTRL_CHAN(0));
+
+	do {
+		status = readl(ipg->reg + IDMA_CTRL_CHAN(0));
+		count++;
+
+	} while (status & CTRL_CHAN_ACT);
+
+	status = readl(ipg->reg + 0x000c0);
+	BUG_ON(status != 1);
+}
+EXPORT_SYMBOL_GPL(mv_idma_memcpy);
+
+irqreturn_t irq_panic(int num, void *data)
+{
+	panic(KERN_ERR "ERROR interrupt occured\n");
+}
+
+irqreturn_t irq_0_handler(int num, void *data)
+{
+	printk(KERN_ERR "%s(): %d", __func__, __LINE__);
+	return IRQ_HANDLED;
+}
+
+static void setup_mbus_windows_xp(void __iomem *regs,
+		struct idma_pdata *idma_pdata)
+{
+	unsigned int val;
+	struct mbus_dram_target_info *dram = idma_pdata->dram;
+	struct cesa_sram_info *sram = idma_pdata->sram;
+	int enable_window = 0xff;
+	int perm_window = 0;
+	int bar;
+
+	/* only transfers DRAM <-> CESA's SRAM are supported */
+	for (bar = 0; bar < dram->num_cs; bar++) {
+		struct mbus_dram_window *cs = &dram->cs[bar];
+
+		val = dram->mbus_dram_target_id;
+		val |= BASE_ATTR(cs->mbus_attr);
+		val |= BASE_ADDR(cs->base);
+		writel(val, regs + BASE_ADDR_BAR(bar));
+		writel(BAR_WND_SIZE_NUM(cs->size), regs + BAR_SIZE(bar));
+
+		enable_window &= ~(1 << bar);
+		perm_window |= WIN_ACCESS_RW(bar);
+	}
+
+	bar = dram->num_cs;
+	val = sram->target_id;
+	val |= BASE_ATTR(sram->attr);
+	val |= BASE_ADDR(sram->base);
+	writel(val, regs + BASE_ADDR_BAR(bar));
+	/* The largest SRAM is 8 KiB and since there are set 64KiB units...*/
+	writel(BAR_WND_SIZE_NUM(1), regs + BAR_SIZE(bar));
+
+	enable_window &= ~(1 << bar);
+	perm_window |= WIN_ACCESS_RW(bar);
+
+	writel(enable_window, regs + BASE_ADDR_EN);
+	writel(perm_window, regs + WIN_ACCESS_PROT(0));
+}
+
+static int mv_probe(struct platform_device *pdev)
+{
+	struct idma_priv *ip;
+	struct resource *res;
+	struct idma_pdata *idma_pdata;
+	void __iomem *reg_deco;
+	int ret;
+
+	idma_pdata = pdev->dev.platform_data;
+	if (!idma_pdata)
+		return -ENODATA;
+
+	ip = kmalloc(GFP_KERNEL, sizeof(*ip));
+	if (!ip)
+		return -ENOMEM;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs base");
+	if (!res)
+		return -ENXIO;
+	ip->reg = ioremap(res->start, res->end - res->start + 1);
+	if (!ip->reg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	writel(0, ip->reg + IDMA_CTRL_CHAN(0));
+	writel(CTRL_ABORT, ip->reg + 0xc0);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs deco");
+	if (!res)
+		return -ENXIO;
+	reg_deco = ioremap(res->start, res->end - res->start + 1);
+	if (!reg_deco) {
+		ret = -ENOMEM;
+		goto err_unmap_reg;
+	}
+	setup_mbus_windows_xp(reg_deco, idma_pdata);
+	iounmap(reg_deco);
+
+	ip->irq_err = platform_get_irq_byname(pdev, "int err");
+	if (ip->irq_err < 0) {
+		ret = ip->irq_err;
+		goto err_unmap_deco;
+	}
+
+	ret = request_irq(ip->irq_err, irq_panic, 0, "idma_error", NULL);
+	if (ret < 0)
+		goto err_unmap_deco;
+
+	ip->irq_0 = platform_get_irq_byname(pdev, "int 0");
+	if (ip->irq_0 < 0) {
+		ret = ip->irq_0;
+		goto err_f_irq_err;
+	}
+
+	ret = request_irq(ip->irq_0, irq_0_handler, 0, "idma_0", NULL);
+	if (ret < 0)
+		goto err_f_irq_err;
+	ipg = ip;
+	platform_set_drvdata(pdev, ip);
+	return 0;
+err_f_irq_err:
+	free_irq(ip->irq_err, NULL);
+err_unmap_deco:
+err_unmap_reg:
+	iounmap(ip->reg);
+err:
+	kfree(ip);
+	return ret;
+}
+
+
+static int mv_remove(struct platform_device *pdev)
+{
+	struct idma_priv *ip = platform_get_drvdata(pdev);
+
+	ipg = NULL;
+	free_irq(ip->irq_0, NULL);
+	free_irq(ip->irq_err, NULL);
+	iounmap(ip->reg);
+	kfree(ip);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver marvell_idma = {
+	.probe          = mv_probe,
+	.remove         = mv_remove,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = "mv_idma",
+	},
+};
+MODULE_ALIAS("platform:mv_idma");
+
+static int __init mv_idma_init(void)
+{
+	return platform_driver_register(&marvell_idma);
+}
+module_init(mv_idma_init);
+
+static void __exit mv_idma_exit(void)
+{
+	platform_driver_unregister(&marvell_idma);
+}
+module_exit(mv_idma_exit);
+
+MODULE_AUTHOR("Sebastian Andrzej Siewior <sebastian@breakpoint.cc>");
+MODULE_DESCRIPTION("Support for Marvell's IDMA engine");
+MODULE_LICENSE("GPL v2");
-- 
1.6.2.5

