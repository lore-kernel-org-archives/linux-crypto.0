From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 05/11] Fix ERROR: space prohibited after that open parenthesis '('
Date: Tue, 20 Jun 2017 13:21:46 +0800
Message-ID: <1497936106-4673-1-git-send-email-fbihjmeric@gmail.com>
References: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33166 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbdFTFVx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 01:21:53 -0400
In-Reply-To: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Fixed "ERROR: space prohibited after that open parenthesis '('".

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 6bcab5a..5166874 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1375,10 +1375,10 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 static unsigned int format_ccm_a0(u8 *pA0Buff, u32 headerSize)
 {
 	unsigned int len = 0;
-	if ( headerSize == 0 ) {
+	if (headerSize == 0 ) {
 		return 0;
 	}
-	if ( headerSize < ((1UL << 16) - (1UL << 8) )) {
+	if (headerSize < ((1UL << 16) - (1UL << 8) )) {
 		len = 2;
 
 		pA0Buff[0] = (headerSize >> 8) & 0xFF;
@@ -1860,7 +1860,7 @@ static inline void ssi_aead_dump_gcm(
 	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d \n", \
 				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen );
 
-	if ( ctx->enckey != NULL ) {
+	if (ctx->enckey != NULL ) {
 		dump_byte_array("mac key", ctx->enckey, 16);
 	}
 
@@ -1914,16 +1914,16 @@ static int config_gcm_context(struct aead_request *req) {
 	if (req_ctx->plaintext_authenticate_only == false) {
 		__be64 temp64;
 		temp64 = cpu_to_be64(req->assoclen * 8);
-		memcpy ( &req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
+		memcpy (&req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
 		temp64 = cpu_to_be64(cryptlen * 8);
-		memcpy ( &req_ctx->gcm_len_block.lenC , &temp64, 8 );
+		memcpy (&req_ctx->gcm_len_block.lenC , &temp64, 8 );
 	}
 	else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
 		temp64 = cpu_to_be64((req->assoclen+GCM_BLOCK_RFC4_IV_SIZE+cryptlen) * 8);
-		memcpy ( &req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
+		memcpy (&req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
 		temp64 = 0;
-		memcpy ( &req_ctx->gcm_len_block.lenC , &temp64, 8 );
+		memcpy (&req_ctx->gcm_len_block.lenC , &temp64, 8 );
 	}
 
 	return 0;
@@ -2080,7 +2080,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	case DRV_HASH_XCBC_MAC:
 		ssi_aead_xcbc_authenc(req, desc, &seq_len);
 		break;
-#if ( SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM )
+#if (SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM )
 	case DRV_HASH_NULL:
 #if SSI_CC_HAS_AES_CCM
 		if (ctx->cipher_mode == DRV_CIPHER_CCM) {
-- 
2.7.4
