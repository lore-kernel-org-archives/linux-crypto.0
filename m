From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 19/22] staging: ccree: fix code indent
Date: Tue, 15 Aug 2017 09:26:47 +0300
Message-ID: <1502778412-16255-20-git-send-email-gilad@benyossef.com>
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

Fix multiple code indentation issues.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 23 ++++++++++++-----------
 drivers/staging/ccree/ssi_cipher.c     |  2 +-
 drivers/staging/ccree/ssi_sysfs.c      |  4 +++-
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 202387b..051d948 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -420,8 +420,8 @@ ssi_aead_handle_config_buf(struct device *dev,
 	sg_init_one(&areq_ctx->ccm_adata_sg, config_data, AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
 	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
-			SSI_LOG_ERR("dma_map_sg() config buffer failed\n");
-			return -ENOMEM;
+		SSI_LOG_ERR("dma_map_sg() config buffer failed\n");
+		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK "
 		     "offset=%u length=%u\n",
@@ -451,8 +451,8 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
 	if (unlikely(dma_map_sg(dev, areq_ctx->buff_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
-			SSI_LOG_ERR("dma_map_sg() src buffer failed\n");
-			return -ENOMEM;
+		SSI_LOG_ERR("dma_map_sg() src buffer failed\n");
+		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK "
 		     "offset=%u length=%u\n",
@@ -1050,15 +1050,16 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			 * verification is made by CPU compare in order to
 			 * simplify MAC verification upon request completion
 			 */
-			  u32 size_to_skip = req->assoclen;
+			u32 size_to_skip = req->assoclen;
 
-			  if (areq_ctx->is_gcm4543)
-				  size_to_skip += crypto_aead_ivsize(tfm);
+			if (areq_ctx->is_gcm4543)
+				size_to_skip += crypto_aead_ivsize(tfm);
 
-			  ssi_buffer_mgr_copy_scatterlist_portion(
-				  areq_ctx->backup_mac, req->src,
-				  size_to_skip + req->cryptlen - areq_ctx->req_authsize,
-				  size_to_skip + req->cryptlen, SSI_SG_TO_BUF);
+			ssi_buffer_mgr_copy_scatterlist_portion(areq_ctx->backup_mac,
+								req->src,
+								size_to_skip + req->cryptlen - areq_ctx->req_authsize,
+								size_to_skip + req->cryptlen,
+								SSI_SG_TO_BUF);
 			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 		} else { /* Contig. ICV */
 			/*Should hanlde if the sg is not contig.*/
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 14930ce..aa722e1 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -139,7 +139,7 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int siz
 		break;
 	case S_DIN_to_DES:
 		if (likely(IS_ALIGNED(size, DES_BLOCK_SIZE)))
-				return 0;
+			return 0;
 		break;
 #if SSI_CC_HAS_MULTI2
 	case S_DIN_to_MULTI2:
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index a0ab3c6..40cd3be2 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -316,7 +316,9 @@ static ssize_t ssi_sys_help_show(struct kobject *kobj,
 
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "Usage:\n");
 	for (i = 0; i < ARRAY_SIZE(help_str); i += 2)
-	   offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s\t\t%s\n", help_str[i], help_str[i + 1]);
+		offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+				    "%s\t\t%s\n", help_str[i],
+				    help_str[i + 1]);
 
 	return offset;
 }
-- 
2.1.4
