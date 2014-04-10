From: Sonic Zhang <sonic.adi@gmail.com>
Subject: [PATCH 2/2] crypto: bfin_crc: avoid get physical address of coherence memory by dma_map_single
Date: Thu, 10 Apr 2014 16:40:59 +0800
Message-ID: <1397119259-20638-2-git-send-email-sonic.adi@gmail.com>
References: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:15606
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964832AbaDJIip (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 04:38:45 -0400
In-Reply-To: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

- The 4-byte sg_mid_buf is located in the middle of the coherence memory
sg_cpu. Don't call dma_map_single to get its physical address. Get the its
base physical address from the physical address of sg_cpu instead.
- Should set up the dma descriptor data after the 4-byte sg_mid_buf is
filled in completely from next sg buffer.
- memory copy from sg buffer should be done via virtual address.
- Remove unused reference to blackfin header

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/crypto/bfin_crc.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 5f5f427..94a0792 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -29,7 +29,6 @@
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 
-#include <asm/blackfin.h>
 #include <asm/dma.h>
 #include <asm/portmux.h>
 #include <asm/io.h>
@@ -62,6 +61,7 @@ struct bfin_crypto_crc {
 	struct dma_desc_array	*sg_cpu; /* virt addr of sg dma descriptors */
 	dma_addr_t		sg_dma; /* phy addr of sg dma descriptors */
 	u8			*sg_mid_buf;
+	dma_addr_t		sg_mid_dma; /* phy addr of sg mid buffer */
 
 	struct tasklet_struct	done_task;
 	struct crypto_queue	queue; /* waiting requests */
@@ -196,7 +196,6 @@ static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
 	dma_map_sg(crc->dev, ctx->sg, ctx->sg_nents, DMA_TO_DEVICE);
 
 	for_each_sg(ctx->sg, sg, ctx->sg_nents, j) {
-		dma_config = DMAFLOW_ARRAY | RESTART | NDSIZE_3 | DMAEN | PSIZE_32;
 		dma_addr = sg_dma_address(sg);
 		/* deduce extra bytes in last sg */
 		if (sg_is_last(sg))
@@ -209,12 +208,29 @@ static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
 			   bytes in current sg buffer. Move addr of current
 			   sg and deduce the length of current sg.
 			 */
-			memcpy(crc->sg_mid_buf +((i-1) << 2) + mid_dma_count,
-				(void *)dma_addr,
+			memcpy(crc->sg_mid_buf +(i << 2) + mid_dma_count,
+				sg_virt(sg),
 				CHKSUM_DIGEST_SIZE - mid_dma_count);
 			dma_addr += CHKSUM_DIGEST_SIZE - mid_dma_count;
 			dma_count -= CHKSUM_DIGEST_SIZE - mid_dma_count;
+
+			dma_config = DMAFLOW_ARRAY | RESTART | NDSIZE_3 |
+				DMAEN | PSIZE_32 | WDSIZE_32;
+
+			/* setup new dma descriptor for next middle dma */
+			crc->sg_cpu[i].start_addr = crc->sg_mid_dma + (i << 2);
+			crc->sg_cpu[i].cfg = dma_config;
+			crc->sg_cpu[i].x_count = 1;
+			crc->sg_cpu[i].x_modify = CHKSUM_DIGEST_SIZE;
+			dev_dbg(crc->dev, "%d: crc_dma: start_addr:0x%lx, "
+				"cfg:0x%lx, x_count:0x%lx, x_modify:0x%lx\n",
+				i, crc->sg_cpu[i].start_addr,
+				crc->sg_cpu[i].cfg, crc->sg_cpu[i].x_count,
+				crc->sg_cpu[i].x_modify);
+			i++;
 		}
+
+		dma_config = DMAFLOW_ARRAY | RESTART | NDSIZE_3 | DMAEN | PSIZE_32;
 		/* chop current sg dma len to multiple of 32 bits */
 		mid_dma_count = dma_count % 4;
 		dma_count &= ~0x3;
@@ -245,24 +261,9 @@ static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
 
 		if (mid_dma_count) {
 			/* copy extra bytes to next middle dma buffer */
-			dma_config = DMAFLOW_ARRAY | RESTART | NDSIZE_3 |
-				DMAEN | PSIZE_32 | WDSIZE_32;
 			memcpy(crc->sg_mid_buf + (i << 2),
-				(void *)(dma_addr + (dma_count << 2)),
+				(u8*)sg_virt(sg) + (dma_count << 2),
 				mid_dma_count);
-			/* setup new dma descriptor for next middle dma */
-			crc->sg_cpu[i].start_addr = dma_map_single(crc->dev,
-					crc->sg_mid_buf + (i << 2),
-					CHKSUM_DIGEST_SIZE, DMA_TO_DEVICE);
-			crc->sg_cpu[i].cfg = dma_config;
-			crc->sg_cpu[i].x_count = 1;
-			crc->sg_cpu[i].x_modify = CHKSUM_DIGEST_SIZE;
-			dev_dbg(crc->dev, "%d: crc_dma: start_addr:0x%lx, "
-				"cfg:0x%lx, x_count:0x%lx, x_modify:0x%lx\n",
-				i, crc->sg_cpu[i].start_addr,
-				crc->sg_cpu[i].cfg, crc->sg_cpu[i].x_count,
-				crc->sg_cpu[i].x_modify);
-			i++;
 		}
 	}
 
@@ -654,6 +655,8 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	 * 1 last + 1 next dma descriptors
 	 */
 	crc->sg_mid_buf = (u8 *)(crc->sg_cpu + ((CRC_MAX_DMA_DESC + 1) << 1));
+	crc->sg_mid_dma = crc->sg_dma + sizeof(struct dma_desc_array)
+			* ((CRC_MAX_DMA_DESC + 1) << 1);
 
 	writel(0, &crc->regs->control);
 	crc->poly = (u32)pdev->dev.platform_data;
-- 
1.8.2.3
