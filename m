From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 01/12] staging: ccree remove unnecessary parentheses
Date: Thu, 13 Jul 2017 11:19:51 +0300
Message-ID: <1499934004-28513-2-git-send-email-gilad@benyossef.com>
References: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
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

Remove unnecessary parentheses from ccree driver code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 4 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 8 ++++----
 drivers/staging/ccree/ssi_driver.c      | 2 +-
 drivers/staging/ccree/ssi_ivgen.c       | 2 +-
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 drivers/staging/ccree/ssi_sysfs.c       | 8 ++++----
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 3a10c31..99eeeda 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -92,7 +92,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
 	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
-		crypto_aead_ctx(tfm), crypto_tfm_alg_name(&(tfm->base)));
+		crypto_aead_ctx(tfm), crypto_tfm_alg_name(&tfm->base));
 
 	dev = &ctx->drvdata->plat_dev->dev;
 	/* Unmap enckey buffer */
@@ -143,7 +143,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct ssi_crypto_alg *ssi_alg =
 			container_of(alg, struct ssi_crypto_alg, aead_alg);
-	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx, crypto_tfm_alg_name(&(tfm->base)));
+	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx, crypto_tfm_alg_name(&tfm->base));
 
 	/* Initialize modes in instance */
 	ctx->cipher_mode = ssi_alg->cipher_mode;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index feeaf8d..4127f9f 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -221,7 +221,7 @@ static int ssi_buffer_mgr_generate_mlli(
 	/* Allocate memory from the pointed pool */
 	mlli_params->mlli_virt_addr = dma_pool_alloc(
 			mlli_params->curr_pool, GFP_KERNEL,
-			&(mlli_params->mlli_dma_addr));
+			&mlli_params->mlli_dma_addr);
 	if (unlikely(!mlli_params->mlli_virt_addr)) {
 		SSI_LOG_ERR("dma_pool_alloc() failed\n");
 		rc = -ENOMEM;
@@ -249,7 +249,7 @@ static int ssi_buffer_mgr_generate_mlli(
 			/*Calculate the current MLLI table length for the
 			 *length field in the descriptor
 			 */
-			*(sg_data->mlli_nents[i]) +=
+			*sg_data->mlli_nents[i] +=
 				(total_nents - prev_total_nents);
 			prev_total_nents = total_nents;
 		}
@@ -1176,7 +1176,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 
 		rc = ssi_buffer_mgr_map_scatterlist(dev, req->dst, size_for_map,
 						    DMA_BIDIRECTIONAL,
-						    &(areq_ctx->dst.nents),
+						    &areq_ctx->dst.nents,
 						    LLI_MAX_NUM_OF_DATA_ENTRIES,
 						    &dst_last_bytes,
 						    &dst_mapped_nents);
@@ -1407,7 +1407,7 @@ int ssi_buffer_mgr_map_aead_request(
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = ssi_buffer_mgr_map_scatterlist(dev, req->src,
-					    size_to_map, DMA_BIDIRECTIONAL, &(areq_ctx->src.nents),
+					    size_to_map, DMA_BIDIRECTIONAL, &areq_ctx->src.nents,
 					    LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES + LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
 	if (unlikely(rc != 0)) {
 		rc = -ENOMEM;
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index afb7c48..4246c9b 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -327,7 +327,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 #ifdef ENABLE_CC_SYSFS
-	rc = ssi_sysfs_init(&(plat_dev->dev.kobj), new_drvdata);
+	rc = ssi_sysfs_init(&plat_dev->dev.kobj, new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("init_stat_db failed\n");
 		goto init_cc_res_err;
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 5ff3368..025bff5 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -158,7 +158,7 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
 void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
 {
 	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
-	struct device *device = &(drvdata->plat_dev->dev);
+	struct device *device = &drvdata->plat_dev->dev;
 
 	if (!ivgen_ctx)
 		return;
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 3d6020a..0c8988c 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -317,7 +317,7 @@ int send_request(
 	if (!is_dout) {
 		init_completion(&ssi_req->seq_compl);
 		ssi_req->user_cb = request_mgr_complete;
-		ssi_req->user_arg = &(ssi_req->seq_compl);
+		ssi_req->user_arg = &ssi_req->seq_compl;
 		total_seq_len++;
 	}
 
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 28a46c7..802fd49 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -257,7 +257,7 @@ void update_host_stat(unsigned int op_type, unsigned int phase, cycles_t result)
 	unsigned long flags;
 
 	spin_lock_irqsave(&stat_lock, flags);
-	update_db(&(stat_host_db[op_type][phase]), (unsigned int)result);
+	update_db(&stat_host_db[op_type][phase], (unsigned int)result);
 	spin_unlock_irqrestore(&stat_lock, flags);
 }
 
@@ -266,7 +266,7 @@ void update_cc_stat(
 	unsigned int phase,
 	unsigned int elapsed_cycles)
 {
-	update_db(&(stat_cc_db[op_type][phase]), elapsed_cycles);
+	update_db(&stat_cc_db[op_type][phase], elapsed_cycles);
 }
 
 void display_all_stat_db(void)
@@ -388,7 +388,7 @@ static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
 
 	/* initialize attributes list */
 	for (i = 0; i < num_of_attrs; ++i)
-		sys_dir->sys_dir_attr_list[i] = &(attrs[i].attr);
+		sys_dir->sys_dir_attr_list[i] = &attrs[i].attr;
 
 	/* last list entry should be NULL */
 	sys_dir->sys_dir_attr_list[num_of_attrs] = NULL;
@@ -396,7 +396,7 @@ static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
 	sys_dir->sys_dir_attr_group.attrs = sys_dir->sys_dir_attr_list;
 
 	return sysfs_create_group(sys_dir->sys_dir_kobj,
-			&(sys_dir->sys_dir_attr_group));
+			&sys_dir->sys_dir_attr_group);
 }
 
 static void sys_free_dir(struct sys_dir *sys_dir)
-- 
2.1.4
