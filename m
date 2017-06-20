From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 03/11] Fix ERROR: space required before the open brace
Date: Tue, 20 Jun 2017 13:21:23 +0800
Message-ID: <1497936083-4573-1-git-send-email-fbihjmeric@gmail.com>
References: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32938 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdFTFV3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 01:21:29 -0400
In-Reply-To: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Fixed 'ERROR: space required before the open brace'.

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 0f95a54..ca3f11f 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -791,7 +791,7 @@ ssi_aead_process_authenc_data_desc(
 		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
 
 		if (likely(areq_ctx->is_single_pass == true)) {
-			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT){
+			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 				mlli_addr = areq_ctx->dst.sram_addr;
 				mlli_nents = areq_ctx->dst.mlli_nents;
 			} else {
@@ -1715,7 +1715,7 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only == false)){
+	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only == false)) {
 		/* load AES/CTR initial CTR value inc by 2*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
@@ -1815,7 +1815,7 @@ static inline int ssi_aead_gcm(
 
 
 	//in RFC4543 no data to encrypt. just copy data from src to dest.
-	if (req_ctx->plaintext_authenticate_only == true){
+	if (req_ctx->plaintext_authenticate_only == true) {
 		ssi_aead_process_cipher_data_desc(req, BYPASS, desc, seq_size);
 		ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
 		/* process(ghash) assoc data */
-- 
2.7.4
