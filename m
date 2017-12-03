From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 01/10] staging: ccree: remove inline qualifiers
Date: Sun,  3 Dec 2017 13:58:12 +0000
Message-ID: <1512309503-29766-2-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:55140 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752352AbdLCN7S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Dec 2017 08:59:18 -0500
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ccree drivers was marking a lot of big functions in C file as
static inline for no good reason. Remove the inline qualifier from
any but the few truly single line functions.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 40 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 35 ++++++++++++++---------------
 drivers/staging/ccree/ssi_cipher.c      |  6 ++---
 drivers/staging/ccree/ssi_hash.c        |  2 +-
 drivers/staging/ccree/ssi_request_mgr.c |  4 ++--
 5 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 2cd2b0f..56a4059 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -733,7 +733,7 @@ static int ssi_ccm_setauthsize(struct crypto_aead *authenc,
 }
 #endif /*SSI_CC_HAS_AES_CCM*/
 
-static inline void
+static void
 ssi_aead_create_assoc_desc(
 	struct aead_request *areq,
 	unsigned int flow_mode,
@@ -776,7 +776,7 @@ ssi_aead_create_assoc_desc(
 	*seq_size = (++idx);
 }
 
-static inline void
+static void
 ssi_aead_process_authenc_data_desc(
 	struct aead_request *areq,
 	unsigned int flow_mode,
@@ -843,7 +843,7 @@ ssi_aead_process_authenc_data_desc(
 	*seq_size = (++idx);
 }
 
-static inline void
+static void
 ssi_aead_process_cipher_data_desc(
 	struct aead_request *areq,
 	unsigned int flow_mode,
@@ -891,7 +891,7 @@ ssi_aead_process_cipher_data_desc(
 	*seq_size = (++idx);
 }
 
-static inline void ssi_aead_process_digest_result_desc(
+static void ssi_aead_process_digest_result_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -942,7 +942,7 @@ static inline void ssi_aead_process_digest_result_desc(
 	*seq_size = (++idx);
 }
 
-static inline void ssi_aead_setup_cipher_desc(
+static void ssi_aead_setup_cipher_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -988,7 +988,7 @@ static inline void ssi_aead_setup_cipher_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_cipher(
+static void ssi_aead_process_cipher(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size,
@@ -1014,7 +1014,7 @@ static inline void ssi_aead_process_cipher(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_hmac_setup_digest_desc(
+static void ssi_aead_hmac_setup_digest_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1051,7 +1051,7 @@ static inline void ssi_aead_hmac_setup_digest_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_xcbc_setup_digest_desc(
+static void ssi_aead_xcbc_setup_digest_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1113,7 +1113,7 @@ static inline void ssi_aead_xcbc_setup_digest_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_digest_header_desc(
+static void ssi_aead_process_digest_header_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1127,7 +1127,7 @@ static inline void ssi_aead_process_digest_header_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_digest_scheme_desc(
+static void ssi_aead_process_digest_scheme_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1192,7 +1192,7 @@ static inline void ssi_aead_process_digest_scheme_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_load_mlli_to_sram(
+static void ssi_aead_load_mlli_to_sram(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1222,7 +1222,7 @@ static inline void ssi_aead_load_mlli_to_sram(
 	}
 }
 
-static inline enum cc_flow_mode ssi_aead_get_data_flow_mode(
+static enum cc_flow_mode ssi_aead_get_data_flow_mode(
 	enum drv_crypto_direction direct,
 	enum cc_flow_mode setup_flow_mode,
 	bool is_single_pass)
@@ -1248,7 +1248,7 @@ static inline enum cc_flow_mode ssi_aead_get_data_flow_mode(
 	return data_flow_mode;
 }
 
-static inline void ssi_aead_hmac_authenc(
+static void ssi_aead_hmac_authenc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1304,7 +1304,7 @@ static inline void ssi_aead_hmac_authenc(
 	}
 }
 
-static inline void
+static void
 ssi_aead_xcbc_authenc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
@@ -1456,7 +1456,7 @@ static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
 	return 0;
 }
 
-static inline int ssi_aead_ccm(
+static int ssi_aead_ccm(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1667,7 +1667,7 @@ static void ssi_rfc4309_ccm_process(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static inline void ssi_aead_gcm_setup_ghash_desc(
+static void ssi_aead_gcm_setup_ghash_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1747,7 +1747,7 @@ static inline void ssi_aead_gcm_setup_ghash_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_gcm_setup_gctr_desc(
+static void ssi_aead_gcm_setup_gctr_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1785,7 +1785,7 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_gcm_result_desc(
+static void ssi_aead_process_gcm_result_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1851,7 +1851,7 @@ static inline void ssi_aead_process_gcm_result_desc(
 	*seq_size = idx;
 }
 
-static inline int ssi_aead_gcm(
+static int ssi_aead_gcm(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1892,7 +1892,7 @@ static inline int ssi_aead_gcm(
 }
 
 #ifdef CC_DEBUG
-static inline void ssi_aead_dump_gcm(
+static void ssi_aead_dump_gcm(
 	const char *title,
 	struct aead_request *req)
 {
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index c542225..dc45333 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -80,8 +80,8 @@ static inline char *cc_dma_buf_type(enum ssi_req_dma_buf_type type)
  * @req: aead request object
  * @dir: [IN] copy from/to sgl
  */
-static inline void cc_copy_mac(struct device *dev, struct aead_request *req,
-			       enum ssi_sg_cpy_direct dir)
+static void cc_copy_mac(struct device *dev, struct aead_request *req,
+			enum ssi_sg_cpy_direct dir)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -168,7 +168,7 @@ void cc_copy_sg_portion(
 		       (direct == SSI_SG_TO_BUF));
 }
 
-static inline int cc_render_buff_to_mlli(
+static int cc_render_buff_to_mlli(
 	struct device *dev, dma_addr_t buff_dma, u32 buff_size,
 	u32 *curr_nents, u32 **mlli_entry_pp)
 {
@@ -204,7 +204,7 @@ static inline int cc_render_buff_to_mlli(
 	return 0;
 }
 
-static inline int cc_render_sg_to_mlli(
+static int cc_render_sg_to_mlli(
 	struct device *dev, struct scatterlist *sgl,
 	u32 sgl_data_len, u32 sgl_offset, u32 *curr_nents,
 	u32 **mlli_entry_pp)
@@ -293,7 +293,7 @@ static int cc_generate_mlli(
 	return rc;
 }
 
-static inline void cc_add_buffer_entry(
+static void cc_add_buffer_entry(
 	struct device *dev, struct buffer_array *sgl_data,
 	dma_addr_t buffer_dma, unsigned int buffer_len,
 	bool is_last_entry, u32 *mlli_nents)
@@ -314,7 +314,7 @@ static inline void cc_add_buffer_entry(
 	sgl_data->num_of_buffers++;
 }
 
-static inline void cc_add_sg_entry(
+static void cc_add_sg_entry(
 	struct device *dev,
 	struct buffer_array *sgl_data,
 	unsigned int nents,
@@ -425,7 +425,7 @@ static int cc_map_sg(
 	return 0;
 }
 
-static inline int
+static int
 ssi_aead_handle_config_buf(struct device *dev,
 			   struct aead_req_ctx *areq_ctx,
 			   u8 *config_data,
@@ -455,11 +455,10 @@ ssi_aead_handle_config_buf(struct device *dev,
 	return 0;
 }
 
-static inline int ssi_ahash_handle_curr_buf(struct device *dev,
-					    struct ahash_req_ctx *areq_ctx,
-					    u8 *curr_buff,
-					    u32 curr_buff_cnt,
-					    struct buffer_array *sg_data)
+static int ssi_ahash_handle_curr_buf(struct device *dev,
+				     struct ahash_req_ctx *areq_ctx,
+				     u8 *curr_buff, u32 curr_buff_cnt,
+				     struct buffer_array *sg_data)
 {
 	dev_dbg(dev, " handle curr buff %x set to   DLLI\n", curr_buff_cnt);
 	/* create sg for the current buffer */
@@ -710,7 +709,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	}
 }
 
-static inline int cc_get_aead_icv_nents(
+static int cc_get_aead_icv_nents(
 	struct device *dev,
 	struct scatterlist *sgl,
 	unsigned int sgl_nents,
@@ -764,7 +763,7 @@ static inline int cc_get_aead_icv_nents(
 	return nents;
 }
 
-static inline int cc_aead_chain_iv(
+static int cc_aead_chain_iv(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
@@ -809,7 +808,7 @@ static inline int cc_aead_chain_iv(
 	return rc;
 }
 
-static inline int cc_aead_chain_assoc(
+static int cc_aead_chain_assoc(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
@@ -904,7 +903,7 @@ static inline int cc_aead_chain_assoc(
 	return rc;
 }
 
-static inline void cc_prepare_aead_data_dlli(
+static void cc_prepare_aead_data_dlli(
 	struct aead_request *req,
 	u32 *src_last_bytes, u32 *dst_last_bytes)
 {
@@ -940,7 +939,7 @@ static inline void cc_prepare_aead_data_dlli(
 	}
 }
 
-static inline int cc_prepare_aead_data_mlli(
+static int cc_prepare_aead_data_mlli(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
@@ -1075,7 +1074,7 @@ static inline int cc_prepare_aead_data_mlli(
 	return rc;
 }
 
-static inline int cc_aead_chain_data(
+static int cc_aead_chain_data(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index f6e680c..6c4b93d 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -432,7 +432,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	return 0;
 }
 
-static inline void
+static void
 ssi_blkcipher_create_setup_desc(
 	struct crypto_tfm *tfm,
 	struct blkcipher_req_ctx *req_ctx,
@@ -562,7 +562,7 @@ ssi_blkcipher_create_setup_desc(
 }
 
 #if SSI_CC_HAS_MULTI2
-static inline void ssi_blkcipher_create_multi2_setup_desc(
+static void ssi_blkcipher_create_multi2_setup_desc(
 	struct crypto_tfm *tfm,
 	struct blkcipher_req_ctx *req_ctx,
 	unsigned int ivsize,
@@ -606,7 +606,7 @@ static inline void ssi_blkcipher_create_multi2_setup_desc(
 }
 #endif /*SSI_CC_HAS_MULTI2*/
 
-static inline void
+static void
 ssi_blkcipher_create_data_desc(
 	struct crypto_tfm *tfm,
 	struct blkcipher_req_ctx *req_ctx,
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 4d79725..c955e50 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -114,7 +114,7 @@ static void ssi_hash_create_data_desc(
 	bool is_not_last_data,
 	unsigned int *seq_size);
 
-static inline void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
+static void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 {
 	if (unlikely(mode == DRV_HASH_MD5 ||
 		     mode == DRV_HASH_SHA384 ||
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 0882efd..9883d14 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -165,7 +165,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-static inline void enqueue_seq(
+static void enqueue_seq(
 	void __iomem *cc_base,
 	struct cc_hw_desc seq[], unsigned int seq_len)
 {
@@ -202,7 +202,7 @@ static void request_mgr_complete(struct device *dev, void *dx_compl_h)
 	complete(this_compl);
 }
 
-static inline int request_mgr_queues_status_check(
+static int request_mgr_queues_status_check(
 		struct ssi_drvdata *drvdata,
 		struct ssi_request_mgr_handle *req_mgr_h,
 		unsigned int total_seq_len)
-- 
2.7.4
