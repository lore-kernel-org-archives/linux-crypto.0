From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 13/39] crypto: ux500/hash - Set DMA configuration though dma_slave_config()
Date: Wed, 15 May 2013 10:51:36 +0100
Message-ID: <1368611522-9984-14-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linus.walleij-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org,
	srinidhi.kasagar-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Andreas Westin <andreas.westin-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	balbi-l0cyMroinI0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The DMA controller currently takes configuration information from
information passed though dma_channel_request(), but it shouldn't.
Using the API, the DMA channel should only be configured during
a dma_slave_config() call.

Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Andreas Westin <andreas.westin-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/crypto/ux500/hash/hash_alg.h  |    5 ++++-
 drivers/crypto/ux500/hash/hash_core.c |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index cd9351c..be6eb54 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 
 #define HASH_BLOCK_SIZE			64
+#define HASH_DMA_FIFO			4
 #define HASH_DMA_ALIGN_SIZE		4
 #define HASH_DMA_PERFORMANCE_MIN_SIZE	1024
 #define HASH_BYTES_PER_WORD		4
@@ -347,7 +348,8 @@ struct hash_req_ctx {
 
 /**
  * struct hash_device_data - structure for a hash device.
- * @base:		Pointer to the hardware base address.
+ * @base:		Pointer to virtual base address of the hash device.
+ * @phybase:		Pointer to physical memory location of the hash device.
  * @list_node:		For inclusion in klist.
  * @dev:		Pointer to the device dev structure.
  * @ctx_lock:		Spinlock for current_ctx.
@@ -361,6 +363,7 @@ struct hash_req_ctx {
  */
 struct hash_device_data {
 	struct hash_register __iomem	*base;
+	phys_addr_t             phybase;
 	struct klist_node	list_node;
 	struct device		*dev;
 	struct spinlock		ctx_lock;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 4b02428..6269576 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -122,6 +122,13 @@ static void hash_dma_setup_channel(struct hash_device_data *device_data,
 				struct device *dev)
 {
 	struct hash_platform_data *platform_data = dev->platform_data;
+	struct dma_slave_config conf = {
+		.direction = DMA_MEM_TO_DEV,
+		.dst_addr = device_data->phybase + HASH_DMA_FIFO,
+		.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
+		.dst_maxburst = 16,
+        };
+
 	dma_cap_zero(device_data->dma.mask);
 	dma_cap_set(DMA_SLAVE, device_data->dma.mask);
 
@@ -131,6 +138,8 @@ static void hash_dma_setup_channel(struct hash_device_data *device_data,
 				platform_data->dma_filter,
 				device_data->dma.cfg_mem2hash);
 
+	dmaengine_slave_config(device_data->dma.chan_mem2hash, &conf);
+
 	init_completion(&device_data->dma.complete);
 }
 
@@ -1699,6 +1708,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_kfree;
 	}
 
+	device_data->phybase = res->start;
 	device_data->base = ioremap(res->start, resource_size(res));
 	if (!device_data->base) {
 		dev_err(dev, "[%s] ioremap() failed!",
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
