From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 01/11] Fix coding style of driver/staging/ccree/ssi_aead.c ERROR: space required after that
Date: Tue, 20 Jun 2017 13:19:44 +0800
Message-ID: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36734 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdFTFUA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 01:20:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

In this series patches, I fix all of the coding style error in 
driver/staging/ccree/ssi_aead.c from 54 errors to 0 error.

The first patch fixed 'ERROR: space required after that'.

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index e8936a3..5bc3a53 100644
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
@@ -1566,7 +1566,7 @@ static int config_ccm_adata(struct aead_request *req) {
 	/* taken from crypto/ccm.c */
 	/* 2 <= L <= 8, so 1 <= L' <= 7. */
 	if (2 > l || l > 8) {
-		SSI_LOG_ERR("illegal iv value %X\n",req->iv[0]);
+		SSI_LOG_ERR("illegal iv value %X\n", req->iv[0]);
 		return -EINVAL;
 	}
 	memcpy(b0, req->iv, AES_BLOCK_SIZE);
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
 
 	if (req->src!=NULL && req->cryptlen) {
-		dump_byte_array("req->src",sg_virt(req->src), req->cryptlen+req->assoclen);
+		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen+req->assoclen);
 	}
 
 	if (req->dst!=NULL) {
-		dump_byte_array("req->dst",sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
+		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
     }
 }
 #endif
-- 
2.7.4
