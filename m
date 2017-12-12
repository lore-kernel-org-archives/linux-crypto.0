From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 06/24] staging: ccree: fix func def and decl coding style
Date: Tue, 12 Dec 2017 14:52:52 +0000
Message-ID: <1513090395-7938-7-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

Fix functions definition and declaration indentation according to
coding style guide lines for better code readability

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c       |   5 +-
 drivers/staging/ccree/ssi_buffer_mgr.c | 144 +++++++++++++--------------------
 drivers/staging/ccree/ssi_sram_mgr.h   |   7 +-
 3 files changed, 63 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 62d45e9..112fba3 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -2686,9 +2686,8 @@ static struct ssi_alg_template aead_algs[] = {
 #endif /*SSI_CC_HAS_AES_GCM*/
 };
 
-static struct ssi_crypto_alg *cc_create_aead_alg(
-			struct ssi_alg_template *tmpl,
-			struct device *dev)
+static struct ssi_crypto_alg *cc_create_aead_alg(struct ssi_alg_template *tmpl,
+						 struct device *dev)
 {
 	struct ssi_crypto_alg *t_alg;
 	struct aead_alg *alg;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index c5bc027..099d83d 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -100,9 +100,10 @@ static void cc_copy_mac(struct device *dev, struct aead_request *req,
  * @nbytes: [IN] Total SGL data bytes.
  * @lbytes: [OUT] Returns the amount of bytes at the last entry
  */
-static unsigned int cc_get_sgl_nents(
-	struct device *dev, struct scatterlist *sg_list,
-	unsigned int nbytes, u32 *lbytes, bool *is_chained)
+static unsigned int cc_get_sgl_nents(struct device *dev,
+				     struct scatterlist *sg_list,
+				     unsigned int nbytes, u32 *lbytes,
+				     bool *is_chained)
 {
 	unsigned int nents = 0;
 
@@ -155,10 +156,8 @@ void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
  * @end:
  * @direct:
  */
-void cc_copy_sg_portion(
-	struct device *dev, u8 *dest,
-	struct scatterlist *sg, u32 to_skip,
-	u32 end, enum ssi_sg_cpy_direct direct)
+void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
+			u32 to_skip, u32 end, enum ssi_sg_cpy_direct direct)
 {
 	u32 nents, lbytes;
 
@@ -167,9 +166,9 @@ void cc_copy_sg_portion(
 		       (direct == SSI_SG_TO_BUF));
 }
 
-static int cc_render_buff_to_mlli(
-	struct device *dev, dma_addr_t buff_dma, u32 buff_size,
-	u32 *curr_nents, u32 **mlli_entry_pp)
+static int cc_render_buff_to_mlli(struct device *dev, dma_addr_t buff_dma,
+				  u32 buff_size, u32 *curr_nents,
+				  u32 **mlli_entry_pp)
 {
 	u32 *mlli_entry_p = *mlli_entry_pp;
 	u32 new_nents;
@@ -203,10 +202,9 @@ static int cc_render_buff_to_mlli(
 	return 0;
 }
 
-static int cc_render_sg_to_mlli(
-	struct device *dev, struct scatterlist *sgl,
-	u32 sgl_data_len, u32 sgl_offset, u32 *curr_nents,
-	u32 **mlli_entry_pp)
+static int cc_render_sg_to_mlli(struct device *dev, struct scatterlist *sgl,
+				u32 sgl_data_len, u32 sgl_offset,
+				u32 *curr_nents, u32 **mlli_entry_pp)
 {
 	struct scatterlist *curr_sgl = sgl;
 	u32 *mlli_entry_p = *mlli_entry_pp;
@@ -231,10 +229,8 @@ static int cc_render_sg_to_mlli(
 	return 0;
 }
 
-static int cc_generate_mlli(
-	struct device *dev,
-	struct buffer_array *sg_data,
-	struct mlli_params *mlli_params)
+static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
+			    struct mlli_params *mlli_params)
 {
 	u32 *mlli_p;
 	u32 total_nents = 0, prev_total_nents = 0;
@@ -292,10 +288,10 @@ static int cc_generate_mlli(
 	return rc;
 }
 
-static void cc_add_buffer_entry(
-	struct device *dev, struct buffer_array *sgl_data,
-	dma_addr_t buffer_dma, unsigned int buffer_len,
-	bool is_last_entry, u32 *mlli_nents)
+static void cc_add_buffer_entry(struct device *dev,
+				struct buffer_array *sgl_data,
+				dma_addr_t buffer_dma, unsigned int buffer_len,
+				bool is_last_entry, u32 *mlli_nents)
 {
 	unsigned int index = sgl_data->num_of_buffers;
 
@@ -313,15 +309,10 @@ static void cc_add_buffer_entry(
 	sgl_data->num_of_buffers++;
 }
 
-static void cc_add_sg_entry(
-	struct device *dev,
-	struct buffer_array *sgl_data,
-	unsigned int nents,
-	struct scatterlist *sgl,
-	unsigned int data_len,
-	unsigned int data_offset,
-	bool is_last_table,
-	u32 *mlli_nents)
+static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
+			    unsigned int nents, struct scatterlist *sgl,
+			    unsigned int data_len, unsigned int data_offset,
+			    bool is_last_table, u32 *mlli_nents)
 {
 	unsigned int index = sgl_data->num_of_buffers;
 
@@ -339,9 +330,8 @@ static void cc_add_sg_entry(
 	sgl_data->num_of_buffers++;
 }
 
-static int
-cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
-	      enum dma_data_direction direction)
+static int cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
+			 enum dma_data_direction direction)
 {
 	u32 i, j;
 	struct scatterlist *l_sg = sg;
@@ -368,11 +358,9 @@ cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 	return 0;
 }
 
-static int cc_map_sg(
-	struct device *dev, struct scatterlist *sg,
-	unsigned int nbytes, int direction,
-	u32 *nents, u32 max_sg_nents,
-	u32 *lbytes, u32 *mapped_nents)
+static int cc_map_sg(struct device *dev, struct scatterlist *sg,
+		     unsigned int nbytes, int direction, u32 *nents,
+		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
 {
 	bool is_chained = false;
 
@@ -478,12 +466,9 @@ static int ssi_ahash_handle_curr_buf(struct device *dev,
 	return 0;
 }
 
-void cc_unmap_blkcipher_request(
-	struct device *dev,
-	void *ctx,
-	unsigned int ivsize,
-	struct scatterlist *src,
-	struct scatterlist *dst)
+void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
+				unsigned int ivsize, struct scatterlist *src,
+				struct scatterlist *dst)
 {
 	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
 
@@ -511,14 +496,10 @@ void cc_unmap_blkcipher_request(
 	}
 }
 
-int cc_map_blkcipher_request(
-	struct ssi_drvdata *drvdata,
-	void *ctx,
-	unsigned int ivsize,
-	unsigned int nbytes,
-	void *info,
-	struct scatterlist *src,
-	struct scatterlist *dst)
+int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
+			     unsigned int ivsize, unsigned int nbytes,
+			     void *info, struct scatterlist *src,
+			     struct scatterlist *dst)
 {
 	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
 	struct mlli_params *mlli_params = &req_ctx->mlli_params;
@@ -704,13 +685,10 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	}
 }
 
-static int cc_get_aead_icv_nents(
-	struct device *dev,
-	struct scatterlist *sgl,
-	unsigned int sgl_nents,
-	unsigned int authsize,
-	u32 last_entry_data_size,
-	bool *is_icv_fragmented)
+static int cc_get_aead_icv_nents(struct device *dev, struct scatterlist *sgl,
+				 unsigned int sgl_nents, unsigned int authsize,
+				 u32 last_entry_data_size,
+				 bool *is_icv_fragmented)
 {
 	unsigned int icv_max_size = 0;
 	unsigned int icv_required_size = authsize > last_entry_data_size ?
@@ -758,11 +736,10 @@ static int cc_get_aead_icv_nents(
 	return nents;
 }
 
-static int cc_aead_chain_iv(
-	struct ssi_drvdata *drvdata,
-	struct aead_request *req,
-	struct buffer_array *sg_data,
-	bool is_last, bool do_chain)
+static int cc_aead_chain_iv(struct ssi_drvdata *drvdata,
+			    struct aead_request *req,
+			    struct buffer_array *sg_data,
+			    bool is_last, bool do_chain)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
@@ -803,11 +780,10 @@ static int cc_aead_chain_iv(
 	return rc;
 }
 
-static int cc_aead_chain_assoc(
-	struct ssi_drvdata *drvdata,
-	struct aead_request *req,
-	struct buffer_array *sg_data,
-	bool is_last, bool do_chain)
+static int cc_aead_chain_assoc(struct ssi_drvdata *drvdata,
+			       struct aead_request *req,
+			       struct buffer_array *sg_data,
+			       bool is_last, bool do_chain)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc = 0;
@@ -895,9 +871,8 @@ static int cc_aead_chain_assoc(
 	return rc;
 }
 
-static void cc_prepare_aead_data_dlli(
-	struct aead_request *req,
-	u32 *src_last_bytes, u32 *dst_last_bytes)
+static void cc_prepare_aead_data_dlli(struct aead_request *req,
+				      u32 *src_last_bytes, u32 *dst_last_bytes)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
@@ -931,12 +906,11 @@ static void cc_prepare_aead_data_dlli(
 	}
 }
 
-static int cc_prepare_aead_data_mlli(
-	struct ssi_drvdata *drvdata,
-	struct aead_request *req,
-	struct buffer_array *sg_data,
-	u32 *src_last_bytes, u32 *dst_last_bytes,
-	bool is_last_table)
+static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
+				     struct aead_request *req,
+				     struct buffer_array *sg_data,
+				     u32 *src_last_bytes, u32 *dst_last_bytes,
+				     bool is_last_table)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
@@ -1066,11 +1040,10 @@ static int cc_prepare_aead_data_mlli(
 	return rc;
 }
 
-static int cc_aead_chain_data(
-	struct ssi_drvdata *drvdata,
-	struct aead_request *req,
-	struct buffer_array *sg_data,
-	bool is_last_table, bool do_chain)
+static int cc_aead_chain_data(struct ssi_drvdata *drvdata,
+			      struct aead_request *req,
+			      struct buffer_array *sg_data,
+			      bool is_last_table, bool do_chain)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -1238,8 +1211,7 @@ static void cc_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 	}
 }
 
-int cc_map_aead_request(
-	struct ssi_drvdata *drvdata, struct aead_request *req)
+int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
index 9e39262..76719ec 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -71,9 +71,8 @@ ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size);
  * @seq:	  A pointer to the given IN/OUT descriptor sequence
  * @seq_len:	  A pointer to the given IN/OUT sequence length
  */
-void cc_set_sram_desc(
-	const u32 *src, ssi_sram_addr_t dst,
-	unsigned int nelement,
-	struct cc_hw_desc *seq, unsigned int *seq_len);
+void cc_set_sram_desc(const u32 *src, ssi_sram_addr_t dst,
+		      unsigned int nelement, struct cc_hw_desc *seq,
+		      unsigned int *seq_len);
 
 #endif /*__SSI_SRAM_MGR_H__*/
-- 
2.7.4
