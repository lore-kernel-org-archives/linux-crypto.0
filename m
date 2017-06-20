From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 5/6] staging: ccree: remove improper space
Date: Tue, 20 Jun 2017 22:52:03 +0800
Message-ID: <1497970324-9725-6-git-send-email-fbihjmeric@gmail.com>
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

Remove improper space.

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 6b9de35..57c7c68 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1375,10 +1375,10 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 static unsigned int format_ccm_a0(u8 *pA0Buff, u32 headerSize)
 {
 	unsigned int len = 0;
-	if ( headerSize == 0 ) {
+	if (headerSize == 0) {
 		return 0;
 	}
-	if ( headerSize < ((1UL << 16) - (1UL << 8) )) {
+	if (headerSize < ((1UL << 16) - (1UL << 8))) {
 		len = 2;
 
 		pA0Buff[0] = (headerSize >> 8) & 0xFF;
@@ -1588,7 +1588,7 @@ static int config_ccm_adata(struct aead_request *req)
 	req_ctx->ccm_hdr_size = format_ccm_a0 (a0, req->assoclen);
 
 	memset(req->iv + 15 - req->iv[0], 0, req->iv[0] + 1);
-	req->iv [15] = 1;
+	req->iv[15] = 1;
 
 	memcpy(ctr_count_0, req->iv, AES_BLOCK_SIZE) ;
 	ctr_count_0[15] = 0;
@@ -1859,9 +1859,9 @@ static inline void ssi_aead_dump_gcm(
 	}
 
 	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d \n", \
-				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen );
+				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen);
 
-	if ( ctx->enckey != NULL ) {
+	if (ctx->enckey != NULL) {
 		dump_byte_array("mac key", ctx->enckey, 16);
 	}
 
@@ -1916,16 +1916,16 @@ static int config_gcm_context(struct aead_request *req)
 	if (req_ctx->plaintext_authenticate_only == false) {
 		__be64 temp64;
 		temp64 = cpu_to_be64(req->assoclen * 8);
-		memcpy ( &req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
+		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
-		memcpy ( &req_ctx->gcm_len_block.lenC , &temp64, 8 );
+		memcpy (&req_ctx->gcm_len_block.lenC, &temp64, 8);
 	}
 	else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
 		temp64 = cpu_to_be64((req->assoclen+GCM_BLOCK_RFC4_IV_SIZE+cryptlen) * 8);
-		memcpy ( &req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
+		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = 0;
-		memcpy ( &req_ctx->gcm_len_block.lenC , &temp64, 8 );
+		memcpy (&req_ctx->gcm_len_block.lenC, &temp64, 8);
 	}
 
 	return 0;
@@ -2001,7 +2001,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		req->iv = areq_ctx->ctr_iv;
 		areq_ctx->hw_iv_size = CTR_RFC3686_BLOCK_SIZE;
 	} else if ((ctx->cipher_mode == DRV_CIPHER_CCM) ||
-		   (ctx->cipher_mode == DRV_CIPHER_GCTR) ) {
+		   (ctx->cipher_mode == DRV_CIPHER_GCTR)) {
 		areq_ctx->hw_iv_size = AES_BLOCK_SIZE;
 		if (areq_ctx->ctr_iv != req->iv) {
 			memcpy(areq_ctx->ctr_iv, req->iv, crypto_aead_ivsize(tfm));
@@ -2082,7 +2082,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	case DRV_HASH_XCBC_MAC:
 		ssi_aead_xcbc_authenc(req, desc, &seq_len);
 		break;
-#if ( SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM )
+#if (SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM)
 	case DRV_HASH_NULL:
 #if SSI_CC_HAS_AES_CCM
 		if (ctx->cipher_mode == DRV_CIPHER_CCM) {
@@ -2146,7 +2146,7 @@ static int ssi_rfc4309_ccm_encrypt(struct aead_request *req)
 	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
-		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen );
+		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen);
 		goto out;
 	}
 
@@ -2221,7 +2221,7 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p \n", keylen, key );
+	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p \n", keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -2239,7 +2239,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p \n", keylen, key );
+	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p \n", keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -2274,7 +2274,7 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 				      unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d \n", authsize );
+	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d \n", authsize);
 
 	switch (authsize) {
 	case 8:
@@ -2291,7 +2291,7 @@ static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
 				       unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d \n", authsize );
+	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d \n", authsize);
 
 	if (authsize != 16)
 		return -EINVAL;
-- 
2.7.4
