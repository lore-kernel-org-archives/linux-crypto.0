From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: caam: fix missing dma unmap on error path
Date: Thu, 30 Oct 2014 14:40:22 +0200
Message-ID: <1414672822-5067-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>,
	Cristian Stoica <cristian.stoica@freescale.com>,
	<stable@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If dma mapping for dma_addr_out fails, the descriptor memory is freed
but the previous dma mapping for dma_addr_in remains.
This patch resolves the missing dma unmap and groups resource
allocations at function start.

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/key_gen.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 871703c..e1eaf4f 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -48,23 +48,29 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	u32 *desc;
 	struct split_key_result result;
 	dma_addr_t dma_addr_in, dma_addr_out;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
 		dev_err(jrdev, "unable to allocate key input memory\n");
-		return -ENOMEM;
+		return ret;
 	}
 
-	init_job_desc(desc, 0);
-
 	dma_addr_in = dma_map_single(jrdev, (void *)key_in, keylen,
 				     DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, dma_addr_in)) {
 		dev_err(jrdev, "unable to map key input memory\n");
-		kfree(desc);
-		return -ENOMEM;
+		goto out_free;
 	}
+
+	dma_addr_out = dma_map_single(jrdev, key_out, split_key_pad_len,
+				      DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, dma_addr_out)) {
+		dev_err(jrdev, "unable to map key output memory\n");
+		goto out_unmap_in;
+	}
+
+	init_job_desc(desc, 0);
 	append_key(desc, dma_addr_in, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
 
 	/* Sets MDHA up into an HMAC-INIT */
@@ -81,13 +87,6 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	 * FIFO_STORE with the explicit split-key content store
 	 * (0x26 output type)
 	 */
-	dma_addr_out = dma_map_single(jrdev, key_out, split_key_pad_len,
-				      DMA_FROM_DEVICE);
-	if (dma_mapping_error(jrdev, dma_addr_out)) {
-		dev_err(jrdev, "unable to map key output memory\n");
-		kfree(desc);
-		return -ENOMEM;
-	}
 	append_fifo_store(desc, dma_addr_out, split_key_len,
 			  LDST_CLASS_2_CCB | FIFOST_TYPE_SPLIT_KEK);
 
@@ -115,10 +114,10 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 
 	dma_unmap_single(jrdev, dma_addr_out, split_key_pad_len,
 			 DMA_FROM_DEVICE);
+out_unmap_in:
 	dma_unmap_single(jrdev, dma_addr_in, keylen, DMA_TO_DEVICE);
-
+out_free:
 	kfree(desc);
-
 	return ret;
 }
 EXPORT_SYMBOL(gen_split_key);
-- 
1.8.3.1
