From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 1/6] Staging: ccree: add space around comma,
 brace and operator.
Date: Tue, 20 Jun 2017 22:51:59 +0800
Message-ID: <1497970324-9725-2-git-send-email-fbihjmeric@gmail.com>
References: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
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

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Add space around comma, brace, and opertor.

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index e8936a3..ca3f11f 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -155,7 +155,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	ctx->auth_mode = ssi_alg->auth_mode;
 	ctx->drvdata = ssi_alg->drvdata;
 	dev = &ctx->drvdata->plat_dev->dev;
-	crypto_aead_set_reqsize(tfm,sizeof(struct aead_req_ctx));
+	crypto_aead_set_reqsize(tfm, sizeof(struct aead_req_ctx));
 
 	/* Allocate key buffer, cache line aligned */
 	ctx->enckey = dma_alloc_coherent(dev, AES_MAX_KEY_SIZE,
@@ -663,7 +663,7 @@ static int ssi_aead_setauthsize(
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* Unsupported auth. sizes */
 	if ((authsize == 0) ||
-	    (authsize >crypto_aead_maxauthsize(authenc))) {
+	    (authsize > crypto_aead_maxauthsize(authenc))) {
 		return -ENOTSUPP;
 	}
 
@@ -791,7 +791,7 @@ ssi_aead_process_authenc_data_desc(
 		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
 
 		if (likely(areq_ctx->is_single_pass == true)) {
-			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT){
+			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 				mlli_addr = areq_ctx->dst.sram_addr;
 				mlli_nents = areq_ctx->dst.mlli_nents;
 			} else {
@@ -1566,7 +1566,7 @@ static int config_ccm_adata(struct aead_request *req) {
 	/* taken from crypto/ccm.c */
 	/* 2 <= L <= 8, so 1 <= L' <= 7. */
 	if (2 > l || l > 8) {
-		SSI_LOG_ERR("illegal iv value %X\n",req->iv[0]);
+		SSI_LOG_ERR("illegal iv value %X\n", req->iv[0]);
 		return -EINVAL;
 	}
 	memcpy(b0, req->iv, AES_BLOCK_SIZE);
@@ -1715,7 +1715,7 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only==false)){
+	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only == false)) {
 		/* load AES/CTR initial CTR value inc by 2*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
@@ -1815,7 +1815,7 @@ static inline int ssi_aead_gcm(
 
 
 	//in RFC4543 no data to encrypt. just copy data from src to dest.
-	if (req_ctx->plaintext_authenticate_only==true){
+	if (req_ctx->plaintext_authenticate_only == true) {
 		ssi_aead_process_cipher_data_desc(req, BYPASS, desc, seq_size);
 		ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
 		/* process(ghash) assoc data */
@@ -1862,27 +1862,27 @@ static inline void ssi_aead_dump_gcm(
 				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen );
 
 	if ( ctx->enckey != NULL ) {
-		dump_byte_array("mac key",ctx->enckey, 16);
+		dump_byte_array("mac key", ctx->enckey, 16);
 	}
 
-	dump_byte_array("req->iv",req->iv, AES_BLOCK_SIZE);
+	dump_byte_array("req->iv", req->iv, AES_BLOCK_SIZE);
 
-	dump_byte_array("gcm_iv_inc1",req_ctx->gcm_iv_inc1, AES_BLOCK_SIZE);
+	dump_byte_array("gcm_iv_inc1", req_ctx->gcm_iv_inc1, AES_BLOCK_SIZE);
 
-	dump_byte_array("gcm_iv_inc2",req_ctx->gcm_iv_inc2, AES_BLOCK_SIZE);
+	dump_byte_array("gcm_iv_inc2", req_ctx->gcm_iv_inc2, AES_BLOCK_SIZE);
 
-	dump_byte_array("hkey",req_ctx->hkey, AES_BLOCK_SIZE);
+	dump_byte_array("hkey", req_ctx->hkey, AES_BLOCK_SIZE);
 
-	dump_byte_array("mac_buf",req_ctx->mac_buf, AES_BLOCK_SIZE);
+	dump_byte_array("mac_buf", req_ctx->mac_buf, AES_BLOCK_SIZE);
 
-	dump_byte_array("gcm_len_block",req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
+	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
 
-	if (req->src!=NULL && req->cryptlen) {
-		dump_byte_array("req->src",sg_virt(req->src), req->cryptlen+req->assoclen);
+	if (req->src != NULL && req->cryptlen) {
+		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen+req->assoclen);
 	}
 
-	if (req->dst!=NULL) {
-		dump_byte_array("req->dst",sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
+	if (req->dst != NULL) {
+		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
     }
 }
 #endif
@@ -1959,7 +1959,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 
 
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
-		((direct==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"), ctx, req, req->iv,
+		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"), ctx, req, req->iv,
 		sg_virt(req->src), req->src->offset, sg_virt(req->dst), req->dst->offset, req->cryptlen);
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
-- 
2.7.4
