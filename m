From: karthik@techveda.org
Subject: [PATCH 2/2] staging: ccree: Remove braces {} for single statement blocks
Date: Wed, 28 Jun 2017 15:07:13 +0530
Message-ID: <1498642633-3260-3-git-send-email-karthik@techveda.org>
References: <1498642633-3260-1-git-send-email-karthik@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, sunil.m@techveda.org,
        Karthik Tummala <karthik@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498642633-3260-1-git-send-email-karthik@techveda.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Karthik Tummala <karthik@techveda.org>

Fixed following checkpatch.pl warning:
	WARNING: braces {} are not necessary for single
statement blocks.

Signed-off-by: Karthik Tummala <karthik@techveda.org>
---
 drivers/staging/ccree/ssi_aead.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 4004d69..1a4664f 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -243,11 +243,10 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 
 		/* If an IV was generated, copy it back to the user provided buffer. */
 		if (areq_ctx->backup_giv != NULL) {
-			if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+			if (ctx->cipher_mode == DRV_CIPHER_CTR)
 				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_IV_SIZE);
-			} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
 				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
-			}
 		}
 	}
 
@@ -521,9 +520,8 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 	if (unlikely(rc != 0))
 		SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
 
-	if (likely(key_dma_addr != 0)) {
+	if (likely(key_dma_addr != 0))
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
-	}
 
 	return rc;
 }
@@ -928,11 +926,10 @@ static inline void ssi_aead_setup_cipher_desc(
 	set_flow_mode(&desc[idx], ctx->flow_mode);
 	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
 		     hw_iv_size, NS_BIT);
-	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+	if (ctx->cipher_mode == DRV_CIPHER_CTR)
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	} else {
+	else
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	}
 	set_cipher_mode(&desc[idx], ctx->cipher_mode);
 	idx++;
 
@@ -1375,9 +1372,9 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 static unsigned int format_ccm_a0(u8 *pA0Buff, u32 headerSize)
 {
 	unsigned int len = 0;
-	if (headerSize == 0) {
+	if (headerSize == 0)
 		return 0;
-	}
+
 	if (headerSize < ((1UL << 16) - (1UL << 8))) {
 		len = 2;
 
@@ -1498,9 +1495,8 @@ static inline int ssi_aead_ccm(
 	}
 
 	/* process the cipher */
-	if (req_ctx->cryptlen != 0) {
+	if (req_ctx->cryptlen != 0)
 		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, &idx);
-	}
 
 	/* Read temporal MAC */
 	hw_desc_init(&desc[idx]);
@@ -1579,9 +1575,8 @@ static int config_ccm_adata(struct aead_request *req)
 		*b0 |= 64;  /* Enable bit 6 if Adata exists. */
 
 	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
-	if (rc != 0) {
+	if (rc != 0)
 		return rc;
-	}
 	 /* END of "taken from crypto/ccm.c" */
 
 	/* l(a) - size of associated data. */
@@ -1861,9 +1856,8 @@ static inline void ssi_aead_dump_gcm(
 	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d \n", \
 				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen);
 
-	if (ctx->enckey != NULL) {
+	if (ctx->enckey != NULL)
 		dump_byte_array("mac key", ctx->enckey, 16);
-	}
 
 	dump_byte_array("req->iv", req->iv, AES_BLOCK_SIZE);
 
@@ -1877,13 +1871,11 @@ static inline void ssi_aead_dump_gcm(
 
 	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
 
-	if (req->src != NULL && req->cryptlen) {
+	if (req->src != NULL && req->cryptlen)
 		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen+req->assoclen);
-	}
 
-	if (req->dst != NULL) {
+	if (req->dst != NULL)
 		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
-    }
 }
 #endif
 
@@ -2084,14 +2076,12 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 #if (SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM)
 	case DRV_HASH_NULL:
 #if SSI_CC_HAS_AES_CCM
-		if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+		if (ctx->cipher_mode == DRV_CIPHER_CCM)
 			ssi_aead_ccm(req, desc, &seq_len);
-		}
 #endif /*SSI_CC_HAS_AES_CCM*/
 #if SSI_CC_HAS_AES_GCM
-		if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
 			ssi_aead_gcm(req, desc, &seq_len);
-		}
 #endif /*SSI_CC_HAS_AES_GCM*/
 			break;
 #endif
-- 
1.9.1
