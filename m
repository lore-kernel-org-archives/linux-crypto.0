From: Sonic Zhang <sonic.adi@gmail.com>
Subject: [PATCH v2] crypt: bfin_crc: access crc registers by readl and writel functions
Date: Thu, 10 Apr 2014 14:30:56 +0800
Message-ID: <1397111456-17371-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:59005
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933287AbaDJG3L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 02:29:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

Move architecture independant crc header file out of the blackfin folder.


Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
v2-changes:
- avoid combine the IO accessors into each other
- use readl/writel other than ioread32/iowrite32

 drivers/crypto/bfin_crc.c                          | 42 +++++++++++++---------
 .../include/asm => drivers/crypto}/bfin_crc.h      |  0
 2 files changed, 25 insertions(+), 17 deletions(-)
 rename {arch/blackfin/include/asm => drivers/crypto}/bfin_crc.h (100%)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index c9ff298..cea3e8c 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -30,9 +30,11 @@
 #include <crypto/internal/hash.h>
 
 #include <asm/blackfin.h>
-#include <asm/bfin_crc.h>
 #include <asm/dma.h>
 #include <asm/portmux.h>
+#include <asm/io.h>
+
+#include "bfin_crc.h"
 
 #define CRC_CCRYPTO_QUEUE_LENGTH	5
 
@@ -54,7 +56,7 @@ struct bfin_crypto_crc {
 	int			irq;
 	int			dma_ch;
 	u32			poly;
-	volatile struct crc_register *regs;
+	struct crc_register	*regs;
 
 	struct ahash_request	*req; /* current request in operation */
 	struct dma_desc_array	*sg_cpu; /* virt addr of sg dma descriptors */
@@ -132,13 +134,13 @@ static struct scatterlist *sg_get(struct scatterlist *sg_list, unsigned int nent
 
 static int bfin_crypto_crc_init_hw(struct bfin_crypto_crc *crc, u32 key)
 {
-	crc->regs->datacntrld = 0;
-	crc->regs->control = MODE_CALC_CRC << OPMODE_OFFSET;
-	crc->regs->curresult = key;
+	writel(0, &crc->regs->datacntrld);
+	writel(MODE_CALC_CRC << OPMODE_OFFSET, &crc->regs->control);
+	writel(key, &crc->regs->curresult);
 
 	/* setup CRC interrupts */
-	crc->regs->status = CMPERRI | DCNTEXPI;
-	crc->regs->intrenset = CMPERRI | DCNTEXPI;
+	writel(CMPERRI | DCNTEXPI, &crc->regs->status);
+	writel(CMPERRI | DCNTEXPI, &crc->regs->intrenset);
 
 	return 0;
 }
@@ -303,6 +305,7 @@ static int bfin_crypto_crc_handle_queue(struct bfin_crypto_crc *crc,
 	int nsg, i, j;
 	unsigned int nextlen;
 	unsigned long flags;
+	u32 reg;
 
 	spin_lock_irqsave(&crc->lock, flags);
 	if (req)
@@ -402,13 +405,14 @@ finish_update:
 		ctx->sg_buflen += CHKSUM_DIGEST_SIZE;
 
 	/* set CRC data count before start DMA */
-	crc->regs->datacnt = ctx->sg_buflen >> 2;
+	writel(ctx->sg_buflen >> 2, &crc->regs->datacnt);
 
 	/* setup and enable CRC DMA */
 	bfin_crypto_crc_config_dma(crc);
 
 	/* finally kick off CRC operation */
-	crc->regs->control |= BLKEN;
+	reg = readl(&crc->regs->control);
+	writel(reg | BLKEN, &crc->regs->control);
 
 	return -EINPROGRESS;
 }
@@ -529,14 +533,17 @@ static void bfin_crypto_crc_done_task(unsigned long data)
 static irqreturn_t bfin_crypto_crc_handler(int irq, void *dev_id)
 {
 	struct bfin_crypto_crc *crc = dev_id;
+	u32 reg;
 
-	if (crc->regs->status & DCNTEXP) {
-		crc->regs->status = DCNTEXP;
+	if (readl(&crc->regs->status) & DCNTEXP) {
+		writel(DCNTEXP, &crc->regs->status);
 
 		/* prepare results */
-		put_unaligned_le32(crc->regs->result, crc->req->result);
+		put_unaligned_le32(readl(&crc->regs->result),
+			crc->req->result);
 
-		crc->regs->control &= ~BLKEN;
+		reg = readl(&crc->regs->control);
+		writel(reg & ~BLKEN, &crc->regs->control);
 		crc->busy = 0;
 
 		if (crc->req->base.complete)
@@ -560,7 +567,7 @@ static int bfin_crypto_crc_suspend(struct platform_device *pdev, pm_message_t st
 	struct bfin_crypto_crc *crc = platform_get_drvdata(pdev);
 	int i = 100000;
 
-	while ((crc->regs->control & BLKEN) && --i)
+	while ((readl(&crc->regs->control) & BLKEN) && --i)
 		cpu_relax();
 
 	if (i == 0)
@@ -648,10 +655,11 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	 */
 	crc->sg_mid_buf = (u8 *)(crc->sg_cpu + ((CRC_MAX_DMA_DESC + 1) << 1));
 
-	crc->regs->control = 0;
-	crc->regs->poly = crc->poly = (u32)pdev->dev.platform_data;
+	writel(0, &crc->regs->control);
+	crc->poly = (u32)pdev->dev.platform_data;
+	writel(crc->poly, &crc->regs->poly);
 
-	while (!(crc->regs->status & LUTDONE) && (--timeout) > 0)
+	while (!(readl(&crc->regs->status) & LUTDONE) && (--timeout) > 0)
 		cpu_relax();
 
 	if (timeout == 0)
diff --git a/arch/blackfin/include/asm/bfin_crc.h b/drivers/crypto/bfin_crc.h
similarity index 100%
rename from arch/blackfin/include/asm/bfin_crc.h
rename to drivers/crypto/bfin_crc.h
-- 
1.8.2.3
