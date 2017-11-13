From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 01/24] staging: ccree: fix typos
Date: Mon, 13 Nov 2017 14:45:29 +0000
Message-ID: <1510584358-29473-2-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fix a bunch of comment typos.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c        | 2 +-
 drivers/staging/ccree/ssi_hash.h        | 2 +-
 drivers/staging/ccree/ssi_ivgen.c       | 2 +-
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 drivers/staging/ccree/ssi_request_mgr.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 472d3b7..6687027 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2484,7 +2484,7 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
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
index a33fd76..2f9201e 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -198,7 +198,7 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 
 	ivgen_ctx = drvdata->ivgen_handle;
 
-	/* Allocate pool's header for intial enc. key/IV */
+	/* Allocate pool's header for initial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, SSI_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma,
 						  GFP_KERNEL);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index e9a09b3..597a71f 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -205,7 +205,7 @@ static inline int request_mgr_queues_status_check(
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* SW queue is checked only once as it will not
-	 * be chaned during the poll becasue the spinlock_bh
+	 * be chaned during the poll because the spinlock_bh
 	 * is held by the thread
 	 */
 	if (unlikely(((req_mgr_h->req_queue_head + 1) &
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index ba44ab4..23883e2 100644
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
2.7.4
