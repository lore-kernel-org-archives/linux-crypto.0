From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 16/22] staging: ccree: fix spelling mistakes
Date: Tue, 15 Aug 2017 09:26:44 +0300
Message-ID: <1502778412-16255-17-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix various spelling mistakes in comments.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c      | 2 +-
 drivers/staging/ccree/ssi_hash.c        | 2 +-
 drivers/staging/ccree/ssi_hash.h        | 2 +-
 drivers/staging/ccree/ssi_ivgen.c       | 2 +-
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 drivers/staging/ccree/ssi_request_mgr.h | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 8d65e97..e417bfd 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -697,7 +697,7 @@ static int ssi_blkcipher_complete(struct device *dev,
 
 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 
-	/*Set the inflight couter value to local variable*/
+	/*Set the inflight counter value to local variable*/
 	inflight_counter =  ctx_p->drvdata->inflight_counter;
 	/*Decrease the inflight counter*/
 	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 6baa449..cfd5f5c 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2575,7 +2575,7 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
  * \param drvdata
  * \param mode The Hash mode. Supported modes: MD5/SHA1/SHA224/SHA256
  *
- * \return u32 The address of the inital digest in SRAM
+ * \return u32 The address of the initial digest in SRAM
  */
 ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode)
 {
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 2400e38..c884727 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -95,7 +95,7 @@ ssi_ahash_get_initial_digest_len_sram_addr(void *drvdata, u32 mode);
  * \param drvdata
  * \param mode The Hash mode. Supported modes: MD5/SHA1/SHA224/SHA256/SHA384/SHA512
  *
- * \return u32 The address of the inital digest in SRAM
+ * \return u32 The address of the initial digest in SRAM
  */
 ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode);
 
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 93a2a94..ba70237 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -200,7 +200,7 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 	}
 	ivgen_ctx = drvdata->ivgen_handle;
 
-	/* Allocate pool's header for intial enc. key/IV */
+	/* Allocate pool's header for initial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, SSI_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma,
 						  GFP_KERNEL);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 27324bb..9ca2536 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -205,7 +205,7 @@ static inline int request_mgr_queues_status_check(
 	unsigned long poll_queue;
 
 	/* SW queue is checked only once as it will not
-	 * be chaned during the poll becasue the spinlock_bh
+	 * be chaned during the poll because the spinlock_bh
 	 * is held by the thread
 	 */
 	if (unlikely(((req_mgr_h->req_queue_head + 1) &
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index bdbbf89..b248fb6 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -36,7 +36,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata);
  *	  If "false": this function adds a dummy descriptor completion
  *	  and waits upon completion signal.
  *
- * \return int Returns -EINPROGRESS if "is_dout=ture"; "0" if "is_dout=false"
+ * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
  */
 int send_request(
 	struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
-- 
2.1.4
