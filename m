From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH 1/4] Talitos: move the data structure into header file
Date: Tue, 10 Jul 2012 13:56:46 +0800
Message-ID: <1341899809-20630-2-git-send-email-qiang.liu@freescale.com>
References: <1341899809-20630-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <leoli@freescale.com>, <kim.phillips@freescale.com>,
	Qiang Liu <qiang.liu@freescale.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:2089
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab2GJGSE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 02:18:04 -0400
In-Reply-To: <1341899809-20630-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the declaration of talitos data structure into talitos.h.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/crypto/talitos.c |  108 ----------------------------------------------
 drivers/crypto/talitos.h |  108 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dc641c7..cb9e4cd 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -53,114 +53,6 @@

 #include "talitos.h"

-#define TALITOS_TIMEOUT 100000
-#define TALITOS_MAX_DATA_LEN 65535
-
-#define DESC_TYPE(desc_hdr) ((be32_to_cpu(desc_hdr) >> 3) & 0x1f)
-#define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
-#define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
-
-/* descriptor pointer entry */
-struct talitos_ptr {
-	__be16 len;	/* length */
-	u8 j_extent;	/* jump to sg link table and/or extent */
-	u8 eptr;	/* extended address */
-	__be32 ptr;	/* address */
-};
-
-static const struct talitos_ptr zero_entry = {
-	.len = 0,
-	.j_extent = 0,
-	.eptr = 0,
-	.ptr = 0
-};
-
-/* descriptor */
-struct talitos_desc {
-	__be32 hdr;			/* header high bits */
-	__be32 hdr_lo;			/* header low bits */
-	struct talitos_ptr ptr[7];	/* ptr/len pair array */
-};
-
-/**
- * talitos_request - descriptor submission request
- * @desc: descriptor pointer (kernel virtual)
- * @dma_desc: descriptor's physical bus address
- * @callback: whom to call when descriptor processing is done
- * @context: caller context (optional)
- */
-struct talitos_request {
-	struct talitos_desc *desc;
-	dma_addr_t dma_desc;
-	void (*callback) (struct device *dev, struct talitos_desc *desc,
-	                  void *context, int error);
-	void *context;
-};
-
-/* per-channel fifo management */
-struct talitos_channel {
-	void __iomem *reg;
-
-	/* request fifo */
-	struct talitos_request *fifo;
-
-	/* number of requests pending in channel h/w fifo */
-	atomic_t submit_count ____cacheline_aligned;
-
-	/* request submission (head) lock */
-	spinlock_t head_lock ____cacheline_aligned;
-	/* index to next free descriptor request */
-	int head;
-
-	/* request release (tail) lock */
-	spinlock_t tail_lock ____cacheline_aligned;
-	/* index to next in-progress/done descriptor request */
-	int tail;
-};
-
-struct talitos_private {
-	struct device *dev;
-	struct platform_device *ofdev;
-	void __iomem *reg;
-	int irq[2];
-
-	/* SEC version geometry (from device tree node) */
-	unsigned int num_channels;
-	unsigned int chfifo_len;
-	unsigned int exec_units;
-	unsigned int desc_types;
-
-	/* SEC Compatibility info */
-	unsigned long features;
-
-	/*
-	 * length of the request fifo
-	 * fifo_len is chfifo_len rounded up to next power of 2
-	 * so we can use bitwise ops to wrap
-	 */
-	unsigned int fifo_len;
-
-	struct talitos_channel *chan;
-
-	/* next channel to be assigned next incoming descriptor */
-	atomic_t last_chan ____cacheline_aligned;
-
-	/* request callback tasklet */
-	struct tasklet_struct done_task[2];
-
-	/* list of registered algorithms */
-	struct list_head alg_list;
-
-	/* hwrng device */
-	struct hwrng rng;
-};
-
-/* .features flag */
-#define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
-#define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
-#define TALITOS_FTR_SHA224_HWINIT 0x00000004
-#define TALITOS_FTR_HMAC_OK 0x00000008
-
 static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_addr_t dma_addr)
 {
 	talitos_ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 3c17395..21934be 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -28,6 +28,114 @@
  *
  */

+#define TALITOS_TIMEOUT 100000
+#define TALITOS_MAX_DATA_LEN 65535
+
+#define DESC_TYPE(desc_hdr) ((be32_to_cpu(desc_hdr) >> 3) & 0x1f)
+#define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
+#define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
+
+/* descriptor pointer entry */
+struct talitos_ptr {
+	__be16 len;	/* length */
+	u8 j_extent;	/* jump to sg link table and/or extent */
+	u8 eptr;	/* extended address */
+	__be32 ptr;	/* address */
+};
+
+static const struct talitos_ptr zero_entry = {
+	.len = 0,
+	.j_extent = 0,
+	.eptr = 0,
+	.ptr = 0
+};
+
+/* descriptor */
+struct talitos_desc {
+	__be32 hdr;			/* header high bits */
+	__be32 hdr_lo;			/* header low bits */
+	struct talitos_ptr ptr[7];	/* ptr/len pair array */
+};
+
+/**
+ * talitos_request - descriptor submission request
+ * @desc: descriptor pointer (kernel virtual)
+ * @dma_desc: descriptor's physical bus address
+ * @callback: whom to call when descriptor processing is done
+ * @context: caller context (optional)
+ */
+struct talitos_request {
+	struct talitos_desc *desc;
+	dma_addr_t dma_desc;
+	void (*callback) (struct device *dev, struct talitos_desc *desc,
+	                  void *context, int error);
+	void *context;
+};
+
+/* per-channel fifo management */
+struct talitos_channel {
+	void __iomem *reg;
+
+	/* request fifo */
+	struct talitos_request *fifo;
+
+	/* number of requests pending in channel h/w fifo */
+	atomic_t submit_count ____cacheline_aligned;
+
+	/* request submission (head) lock */
+	spinlock_t head_lock ____cacheline_aligned;
+	/* index to next free descriptor request */
+	int head;
+
+	/* request release (tail) lock */
+	spinlock_t tail_lock ____cacheline_aligned;
+	/* index to next in-progress/done descriptor request */
+	int tail;
+};
+
+struct talitos_private {
+	struct device *dev;
+	struct platform_device *ofdev;
+	void __iomem *reg;
+	int irq[2];
+
+	/* SEC version geometry (from device tree node) */
+	unsigned int num_channels;
+	unsigned int chfifo_len;
+	unsigned int exec_units;
+	unsigned int desc_types;
+
+	/* SEC Compatibility info */
+	unsigned long features;
+
+	/*
+	 * length of the request fifo
+	 * fifo_len is chfifo_len rounded up to next power of 2
+	 * so we can use bitwise ops to wrap
+	 */
+	unsigned int fifo_len;
+
+	struct talitos_channel *chan;
+
+	/* next channel to be assigned next incoming descriptor */
+	atomic_t last_chan ____cacheline_aligned;
+
+	/* request callback tasklet */
+	struct tasklet_struct done_task[2];
+
+	/* list of registered algorithms */
+	struct list_head alg_list;
+
+	/* hwrng device */
+	struct hwrng rng;
+};
+
+/* .features flag */
+#define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
+#define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
+#define TALITOS_FTR_SHA224_HWINIT 0x00000004
+#define TALITOS_FTR_HMAC_OK 0x00000008
+
 /*
  * TALITOS_xxx_LO addresses point to the low data bits (32-63) of the register
  */
--
1.7.5.1
