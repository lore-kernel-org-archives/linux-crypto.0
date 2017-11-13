From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 03/24] staging: ccree: remove unnecessary parentheses
Date: Mon, 13 Nov 2017 14:45:31 +0000
Message-ID: <1510584358-29473-4-git-send-email-gilad@benyossef.com>
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

Remove unnecessary parentheses in if statements across the driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c       | 36 +++++++++++++++++-----------------
 drivers/staging/ccree/ssi_buffer_mgr.c | 28 +++++++++++++-------------
 drivers/staging/ccree/ssi_cipher.c     | 34 ++++++++++++++++----------------
 drivers/staging/ccree/ssi_hash.c       | 16 +++++++--------
 drivers/staging/ccree/ssi_ivgen.c      |  4 ++--
 5 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 9e24783..7abc352 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -391,9 +391,9 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 	case DRV_HASH_SHA256:
 		break;
 	case DRV_HASH_XCBC_MAC:
-		if ((ctx->auth_keylen != AES_KEYSIZE_128) &&
-		    (ctx->auth_keylen != AES_KEYSIZE_192) &&
-		    (ctx->auth_keylen != AES_KEYSIZE_256))
+		if (ctx->auth_keylen != AES_KEYSIZE_128 &&
+		    ctx->auth_keylen != AES_KEYSIZE_192 &&
+		    ctx->auth_keylen != AES_KEYSIZE_256)
 			return -ENOTSUPP;
 		break;
 	case DRV_HASH_NULL: /* Not authenc (e.g., CCM) - no auth_key) */
@@ -412,9 +412,9 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 			return -EINVAL;
 		}
 	} else { /* Default assumed to be AES ciphers */
-		if ((ctx->enc_keylen != AES_KEYSIZE_128) &&
-		    (ctx->enc_keylen != AES_KEYSIZE_192) &&
-		    (ctx->enc_keylen != AES_KEYSIZE_256)) {
+		if (ctx->enc_keylen != AES_KEYSIZE_128 &&
+		    ctx->enc_keylen != AES_KEYSIZE_192 &&
+		    ctx->enc_keylen != AES_KEYSIZE_256) {
 			dev_err(dev, "Invalid cipher(AES) key size: %u\n",
 				ctx->enc_keylen);
 			return -EINVAL;
@@ -676,8 +676,8 @@ static int ssi_aead_setauthsize(
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	/* Unsupported auth. sizes */
-	if ((authsize == 0) ||
-	    (authsize > crypto_aead_maxauthsize(authenc))) {
+	if (authsize == 0 ||
+	    authsize > crypto_aead_maxauthsize(authenc)) {
 		return -ENOTSUPP;
 	}
 
@@ -744,8 +744,8 @@ ssi_aead_create_assoc_desc(
 		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
 			     areq->assoclen, NS_BIT); set_flow_mode(&desc[idx],
 			     flow_mode);
-		if ((ctx->auth_mode == DRV_HASH_XCBC_MAC) &&
-		    (areq_ctx->cryptlen > 0))
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
+		    areq_ctx->cryptlen > 0)
 			set_din_not_last_indication(&desc[idx]);
 		break;
 	case SSI_DMA_BUF_MLLI:
@@ -754,8 +754,8 @@ ssi_aead_create_assoc_desc(
 		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->assoc.sram_addr,
 			     areq_ctx->assoc.mlli_nents, NS_BIT);
 		set_flow_mode(&desc[idx], flow_mode);
-		if ((ctx->auth_mode == DRV_HASH_XCBC_MAC) &&
-		    (areq_ctx->cryptlen > 0))
+		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
+		    areq_ctx->cryptlen > 0)
 			set_din_not_last_indication(&desc[idx]);
 		break;
 	case SSI_DMA_BUF_NULL:
@@ -1192,8 +1192,8 @@ static inline void ssi_aead_load_mlli_to_sram(
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	if (unlikely(
-		(req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
-		(req_ctx->data_buff_type == SSI_DMA_BUF_MLLI) ||
+		req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
+		req_ctx->data_buff_type == SSI_DMA_BUF_MLLI ||
 		!req_ctx->is_single_pass)) {
 		dev_dbg(dev, "Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
 			(unsigned int)ctx->drvdata->mlli_sram_addr,
@@ -1350,15 +1350,15 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
 			(req->cryptlen - ctx->authsize) : req->cryptlen;
 
-	if (unlikely((direct == DRV_CRYPTO_DIRECTION_DECRYPT) &&
-		     (req->cryptlen < ctx->authsize)))
+	if (unlikely(direct == DRV_CRYPTO_DIRECTION_DECRYPT &&
+		     req->cryptlen < ctx->authsize))
 		goto data_size_err;
 
 	areq_ctx->is_single_pass = true; /*defaulted to fast flow*/
 
 	switch (ctx->flow_mode) {
 	case S_DIN_to_AES:
-		if (unlikely((ctx->cipher_mode == DRV_CIPHER_CBC) &&
+		if (unlikely(ctx->cipher_mode == DRV_CIPHER_CBC &&
 			     !IS_ALIGNED(cipherlen, AES_BLOCK_SIZE)))
 			goto data_size_err;
 		if (ctx->cipher_mode == DRV_CIPHER_CCM)
@@ -1372,7 +1372,7 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 		if (!IS_ALIGNED(assoclen, sizeof(u32)))
 			areq_ctx->is_single_pass = false;
 
-		if ((ctx->cipher_mode == DRV_CIPHER_CTR) &&
+		if (ctx->cipher_mode == DRV_CIPHER_CTR &&
 		    !IS_ALIGNED(cipherlen, sizeof(u32)))
 			areq_ctx->is_single_pass = false;
 
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index bfabb5b..923a0df 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -576,7 +576,7 @@ int cc_map_blkcipher_request(
 		if (mapped_nents > 1)
 			req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
 
-		if (unlikely((req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI))) {
+		if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
 			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
 					nbytes, 0, true,
 					&req_ctx->in_mlli_nents);
@@ -689,7 +689,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
-	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
+	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
 	    likely(req->src == req->dst)) {
 
 		/* copy back mac from temporary location to deal with possible
@@ -864,13 +864,13 @@ static inline int cc_aead_chain_assoc(
 	}
 
 	if (likely(mapped_nents == 1) &&
-	    (areq_ctx->ccm_hdr_size == ccm_header_size_null))
+	    areq_ctx->ccm_hdr_size == ccm_header_size_null)
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_DLLI;
 	else
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
 
 	if (unlikely((do_chain) ||
-		     (areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI))) {
+		     areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI)) {
 		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
 			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
@@ -1155,8 +1155,8 @@ static inline int cc_aead_chain_data(
 	}
 	areq_ctx->dst.nents = dst_mapped_nents;
 	areq_ctx->dst_offset = offset;
-	if ((src_mapped_nents > 1) ||
-	    (dst_mapped_nents  > 1) ||
+	if (src_mapped_nents > 1 ||
+	    dst_mapped_nents  > 1 ||
 	    do_chain) {
 		areq_ctx->data_buff_type = SSI_DMA_BUF_MLLI;
 		rc = cc_prepare_aead_data_mlli(drvdata, req, sg_data,
@@ -1247,7 +1247,7 @@ int cc_map_aead_request(
 	 * data memory overriding that caused by cache coherence problem.
 	 */
 	if (drvdata->coherent &&
-	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
+	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
 	    likely(req->src == req->dst))
 		cc_copy_mac(dev, req, SSI_SG_TO_BUF);
 
@@ -1408,8 +1408,8 @@ int cc_map_aead_request(
 
 	/* Mlli support -start building the MLLI according to the above results */
 	if (unlikely(
-		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
-		(areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI))) {
+		areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
+		areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI)) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
 		if (unlikely(rc))
@@ -1466,15 +1466,15 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 		}
 	}
 
-	if (src && (nbytes > 0) && do_update) {
+	if (src && nbytes > 0 && do_update) {
 		if (unlikely(cc_map_sg(dev, src, nbytes, DMA_TO_DEVICE,
 				       &areq_ctx->in_nents,
 				       LLI_MAX_NUM_OF_DATA_ENTRIES,
 				       &dummy, &mapped_nents))) {
 			goto unmap_curr_buff;
 		}
-		if (src && (mapped_nents == 1)
-		     && (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL)) {
+		if (src && mapped_nents == 1
+		     && areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
 			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
 			areq_ctx->buff_sg->length = nbytes;
@@ -1590,8 +1590,8 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 				       &mapped_nents))) {
 			goto unmap_curr_buff;
 		}
-		if ((mapped_nents == 1)
-		     && (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL)) {
+		if (mapped_nents == 1
+		     && areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
 			/* only one entry in the SG and no previous data */
 			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index b5bb97c..957138a 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -76,18 +76,18 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
 		switch (size) {
 		case CC_AES_128_BIT_KEY_SIZE:
 		case CC_AES_192_BIT_KEY_SIZE:
-			if (likely((ctx_p->cipher_mode != DRV_CIPHER_XTS) &&
-				   (ctx_p->cipher_mode != DRV_CIPHER_ESSIV) &&
-				   (ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)))
+			if (likely(ctx_p->cipher_mode != DRV_CIPHER_XTS &&
+				   ctx_p->cipher_mode != DRV_CIPHER_ESSIV &&
+				   ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER))
 				return 0;
 			break;
 		case CC_AES_256_BIT_KEY_SIZE:
 			return 0;
 		case (CC_AES_192_BIT_KEY_SIZE * 2):
 		case (CC_AES_256_BIT_KEY_SIZE * 2):
-			if (likely((ctx_p->cipher_mode == DRV_CIPHER_XTS) ||
-				   (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) ||
-				   (ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)))
+			if (likely(ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+				   ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+				   ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER))
 				return 0;
 			break;
 		default:
@@ -115,8 +115,8 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int siz
 	case S_DIN_to_AES:
 		switch (ctx_p->cipher_mode) {
 		case DRV_CIPHER_XTS:
-			if ((size >= SSI_MIN_AES_XTS_SIZE) &&
-			    (size <= SSI_MAX_AES_XTS_SIZE) &&
+			if (size >= SSI_MIN_AES_XTS_SIZE &&
+			    size <= SSI_MAX_AES_XTS_SIZE &&
 			    IS_ALIGNED(size, AES_BLOCK_SIZE))
 				return 0;
 			break;
@@ -333,9 +333,9 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			return -EINVAL;
 		}
 
-		if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) ||
-		    (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) ||
-		    (ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)) {
+		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
 			if (unlikely(hki->hw_key1 == hki->hw_key2)) {
 				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
 					hki->hw_key1, hki->hw_key2);
@@ -364,13 +364,13 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			return -EINVAL;
 		}
 	}
-	if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) &&
+	if (ctx_p->cipher_mode == DRV_CIPHER_XTS &&
 	    xts_check_key(tfm, key, keylen)) {
 		dev_dbg(dev, "weak XTS key");
 		return -EINVAL;
 	}
-	if ((ctx_p->flow_mode == S_DIN_to_DES) &&
-	    (keylen == DES3_EDE_KEY_SIZE) &&
+	if (ctx_p->flow_mode == S_DIN_to_DES &&
+	    keylen == DES3_EDE_KEY_SIZE &&
 	    ssi_verify_3des_keys(key, keylen)) {
 		dev_dbg(dev, "weak 3DES key");
 		return -EINVAL;
@@ -456,8 +456,8 @@ ssi_blkcipher_create_setup_desc(
 		set_cipher_config0(&desc[*seq_size], direction);
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		if ((cipher_mode == DRV_CIPHER_CTR) ||
-		    (cipher_mode == DRV_CIPHER_OFB)) {
+		if (cipher_mode == DRV_CIPHER_CTR ||
+		    cipher_mode == DRV_CIPHER_OFB) {
 			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
 		} else {
 			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
@@ -765,7 +765,7 @@ static int ssi_blkcipher_process(
 	memcpy(req_ctx->iv, info, ivsize);
 
 	/*For CTS in case of data size aligned to 16 use CBC mode*/
-	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)) {
+	if (((nbytes % AES_BLOCK_SIZE) == 0) && ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS) {
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
 		cts_restore_flag = 1;
 	}
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 6687027..1fda84d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -116,9 +116,9 @@ static void ssi_hash_create_data_desc(
 
 static inline void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 {
-	if (unlikely((mode == DRV_HASH_MD5) ||
-		     (mode == DRV_HASH_SHA384) ||
-		     (mode == DRV_HASH_SHA512))) {
+	if (unlikely(mode == DRV_HASH_MD5 ||
+		     mode == DRV_HASH_SHA384 ||
+		     mode == DRV_HASH_SHA512)) {
 		set_bytes_swap(desc, 1);
 	} else {
 		set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
@@ -204,12 +204,12 @@ static int ssi_hash_map_request(struct device *dev,
 
 	if (is_hmac) {
 		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		if ((ctx->hw_mode == DRV_CIPHER_XCBC_MAC) || (ctx->hw_mode == DRV_CIPHER_CMAC)) {
+		if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC || ctx->hw_mode == DRV_CIPHER_CMAC) {
 			memset(state->digest_buff, 0, ctx->inter_digestsize);
 		} else { /*sha*/
 			memcpy(state->digest_buff, ctx->digest_buff, ctx->inter_digestsize);
 #if (DX_DEV_SHA_MAX > 256)
-			if (unlikely((ctx->hash_mode == DRV_HASH_SHA512) || (ctx->hash_mode == DRV_HASH_SHA384)))
+			if (unlikely(ctx->hash_mode == DRV_HASH_SHA512 || ctx->hash_mode == DRV_HASH_SHA384))
 				memcpy(state->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
 			else
 				memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
@@ -1460,7 +1460,7 @@ static int ssi_mac_final(struct ahash_request *req)
 	ssi_req.user_cb = (void *)ssi_hash_complete;
 	ssi_req.user_arg = (void *)req;
 
-	if (state->xcbc_count && (rem_cnt == 0)) {
+	if (state->xcbc_count && rem_cnt == 0) {
 		/* Load key for ECB decryption */
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
@@ -2288,8 +2288,8 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 				      &hash_handle->hash_list);
 		}
 
-		if ((hw_mode == DRV_CIPHER_XCBC_MAC) ||
-		    (hw_mode == DRV_CIPHER_CMAC))
+		if (hw_mode == DRV_CIPHER_XCBC_MAC ||
+		    hw_mode == DRV_CIPHER_CMAC)
 			continue;
 
 		/* register hash version */
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 2f9201e..7171796 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -248,8 +248,8 @@ int ssi_ivgen_getiv(
 	struct device *dev = drvdata_to_dev(drvdata);
 	unsigned int t;
 
-	if ((iv_out_size != CC_AES_IV_SIZE) &&
-	    (iv_out_size != CTR_RFC3686_IV_SIZE)) {
+	if (iv_out_size != CC_AES_IV_SIZE &&
+	    iv_out_size != CTR_RFC3686_IV_SIZE) {
 		return -EINVAL;
 	}
 	if ((iv_out_dma_len + 1) > SSI_IVPOOL_SEQ_LEN) {
-- 
2.7.4
