From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 02/11] Fix ERROR: spaces required around that
Date: Tue, 20 Jun 2017 13:20:59 +0800
Message-ID: <1497936059-4477-1-git-send-email-fbihjmeric@gmail.com>
References: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33952 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdFTFVH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 01:21:07 -0400
In-Reply-To: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Fixed 'ERROR: spaces required around that'

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 5bc3a53..0f95a54 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -663,7 +663,7 @@ static int ssi_aead_setauthsize(
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	/* Unsupported auth. sizes */
 	if ((authsize == 0) ||
-	    (authsize >crypto_aead_maxauthsize(authenc))) {
+	    (authsize > crypto_aead_maxauthsize(authenc))) {
 		return -ENOTSUPP;
 	}
 
@@ -1715,7 +1715,7 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only==false)){
+	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only == false)){
 		/* load AES/CTR initial CTR value inc by 2*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
@@ -1815,7 +1815,7 @@ static inline int ssi_aead_gcm(
 
 
 	//in RFC4543 no data to encrypt. just copy data from src to dest.
-	if (req_ctx->plaintext_authenticate_only==true){
+	if (req_ctx->plaintext_authenticate_only == true){
 		ssi_aead_process_cipher_data_desc(req, BYPASS, desc, seq_size);
 		ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
 		/* process(ghash) assoc data */
@@ -1877,11 +1877,11 @@ static inline void ssi_aead_dump_gcm(
 
 	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
 
-	if (req->src!=NULL && req->cryptlen) {
+	if (req->src != NULL && req->cryptlen) {
 		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen+req->assoclen);
 	}
 
-	if (req->dst!=NULL) {
+	if (req->dst != NULL) {
 		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
     }
 }
@@ -1959,7 +1959,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 
 
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
-		((direct==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"), ctx, req, req->iv,
+		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"), ctx, req, req->iv,
 		sg_virt(req->src), req->src->offset, sg_virt(req->dst), req->dst->offset, req->cryptlen);
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
-- 
2.7.4
