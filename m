From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/3] staging: ccree: copy IV to DMAable memory
Date: Tue, 31 Oct 2017 11:56:15 +0000
Message-ID: <1509450978-17784-2-git-send-email-gilad@benyossef.com>
References: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We are being passed an IV buffer from unknown origin, which may be
stack allocated and thus not safe for DMA. Allocate a DMA safe
buffer for the IV and use that instead.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 16 ++++++++++++++--
 drivers/staging/ccree/ssi_cipher.h |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 78706f5..0784c86 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -695,6 +695,7 @@ static int ssi_blkcipher_complete(struct device *dev,
 	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
 
 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	kfree(req_ctx->iv);
 
 	/*Decrease the inflight counter*/
 	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
@@ -757,6 +758,13 @@ static int ssi_blkcipher_process(
 		rc = 0;
 		goto exit_process;
 	}
+
+	/* The IV we are handed may be allocted from the stack so
+	 * we must copy it to a DMAable buffer before use.
+	 */
+	req_ctx->iv = kmalloc(ivsize, GFP_KERNEL);
+	memcpy(req_ctx->iv, info, ivsize);
+
 	/*For CTS in case of data size aligned to 16 use CBC mode*/
 	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)) {
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
@@ -778,7 +786,9 @@ static int ssi_blkcipher_process(
 
 	/* STAT_PHASE_1: Map buffers */
 
-	rc = ssi_buffer_mgr_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes, info, src, dst);
+	rc = ssi_buffer_mgr_map_blkcipher_request(ctx_p->drvdata, req_ctx,
+						  ivsize, nbytes, req_ctx->iv,
+						  src, dst);
 	if (unlikely(rc != 0)) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit_process;
@@ -830,8 +840,10 @@ static int ssi_blkcipher_process(
 	if (cts_restore_flag != 0)
 		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS) {
 		kfree(req_ctx->backup_info);
+		kfree(req_ctx->iv);
+	}
 
 	return rc;
 }
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index f499962..25e6335 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -43,6 +43,7 @@ struct blkcipher_req_ctx {
 	u32 out_nents;
 	u32 out_mlli_nents;
 	u8 *backup_info; /*store iv for generated IV flow*/
+	u8 *iv;
 	bool is_giv;
 	struct mlli_params mlli_params;
 };
-- 
2.7.4
