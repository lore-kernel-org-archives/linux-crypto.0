From: Kyle Spiers <ksspiers@google.com>
Subject: [PATCH v3] async_pq: Remove VLA usage
Date: Fri,  1 Jun 2018 13:20:16 -0700
Message-ID: <20180601202016.169085-1-ksspiers@google.com>
Cc: davem@davemloft.net, keescook@chromium.org, ray.jui@broadcom.com,
        vkoul@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Kyle Spiers <ksspiers@google.com>
To: dan.j.williams@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove VLAs from the kernel[1], this adjusts the
allocation of coefs and blocks to use the existing maximum values
(with one new define, MAX_DISKS for coefs, and a reuse of the
existing NDISKS for blocks).

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Kyle Spiers <ksspiers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
Switch from kmalloc() coefs and blocks to using maximum values
---
 crypto/async_tx/async_pq.c  | 10 ++++++----
 crypto/async_tx/raid6test.c |  4 +++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 56bd612927ab..80dc567801ec 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -42,6 +42,8 @@ static struct page *pq_scribble_page;
 #define P(b, d) (b[d-2])
 #define Q(b, d) (b[d-1])
 
+#define MAX_DISKS 255
+
 /**
  * do_async_gen_syndrome - asynchronously calculate P and/or Q
  */
@@ -184,7 +186,7 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
-	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
+	BUG_ON(disks > MAX_DISKS || !(P(blocks, disks) || Q(blocks, disks)));
 
 	if (device)
 		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
@@ -196,7 +198,7 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	    is_dma_pq_aligned(device, offset, 0, len)) {
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = 0;
-		unsigned char coefs[src_cnt];
+		unsigned char coefs[MAX_DISKS];
 		int i, j;
 
 		/* run the p+q asynchronously */
@@ -299,11 +301,11 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 	struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx;
-	unsigned char coefs[disks-2];
+	unsigned char coefs[MAX_DISKS];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
 	struct dmaengine_unmap_data *unmap = NULL;
 
-	BUG_ON(disks < 4);
+	BUG_ON(disks < 4 || disks > MAX_DISKS);
 
 	if (device)
 		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index dad95f45b88f..a5edaabae12a 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -81,11 +81,13 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
 			tx = async_gen_syndrome(ptrs, 0, disks, bytes, &submit);
 		} else {
-			struct page *blocks[disks];
+			struct page *blocks[NDISKS];
 			struct page *dest;
 			int count = 0;
 			int i;
 
+			BUG_ON(disks > NDISKS);
+
 			/* data+Q failure.  Reconstruct data from P,
 			 * then rebuild syndrome
 			 */
-- 
2.17.0.921.gf22659ad46-goog
