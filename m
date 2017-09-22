From: karthik@techveda.org
Subject: [PATCH] staging: ccree: Fix Kernel coding style issues
Date: Fri, 22 Sep 2017 14:15:34 +0530
Message-ID: <1506069934-28571-1-git-send-email-karthik@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, sunil.m@techveda.org,
        Karthik Tummala <karthik@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38769 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdIVIps (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 04:45:48 -0400
Received: by mail-pg0-f68.google.com with SMTP id m30so280849pgn.5
        for <linux-crypto@vger.kernel.org>; Fri, 22 Sep 2017 01:45:48 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Karthik Tummala <karthik@techveda.org>

Fixed following checkpatch warnings & checks:
CHECK: Unnecessary parentheses
WARNING: suspect code indent for conditional statements
WARNING: Missing a blank line after declarations

Signed-off-by: Karthik Tummala <karthik@techveda.org>
---
Note:
- Patch was tested & built (ARCH=arm) on staging, next trees.
- No build issues reported.
---
 drivers/staging/ccree/ssi_cipher.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index a462075..24dbe98 100644
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
@@ -140,7 +140,7 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int siz
 		break;
 	case S_DIN_to_DES:
 		if (likely(IS_ALIGNED(size, DES_BLOCK_SIZE)))
-				return 0;
+			return 0;
 		break;
 #if SSI_CC_HAS_MULTI2
 	case S_DIN_to_MULTI2:
@@ -337,9 +337,9 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			return -EINVAL;
 		}

-		if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) ||
-		    (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) ||
-		    (ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)) {
+		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
 			if (unlikely(hki->hw_key1 == hki->hw_key2)) {
 				SSI_LOG_ERR("Illegal hw key numbers (%d,%d)\n", hki->hw_key1, hki->hw_key2);
 				return -EINVAL;
@@ -366,13 +366,13 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			return -EINVAL;
 		}
 	}
-	if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) &&
+	if (ctx_p->cipher_mode == DRV_CIPHER_XTS &&
 	    xts_check_key(tfm, key, keylen) != 0) {
 		SSI_LOG_DEBUG("weak XTS key");
 		return -EINVAL;
 	}
-	if ((ctx_p->flow_mode == S_DIN_to_DES) &&
-	    (keylen == DES3_EDE_KEY_SIZE) &&
+	if (ctx_p->flow_mode == S_DIN_to_DES &&
+	    keylen == DES3_EDE_KEY_SIZE &&
 	    ssi_verify_3des_keys(key, keylen) != 0) {
 		SSI_LOG_DEBUG("weak 3DES key");
 		return -EINVAL;
@@ -401,6 +401,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			/* sha256 for key2 - use sw implementation */
 			int key_len = keylen >> 1;
 			int err;
+
 			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);

 			desc->tfm = ctx_p->shash_tfm;
@@ -457,8 +458,8 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
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
@@ -762,7 +763,7 @@ static int ssi_blkcipher_process(
 		goto exit_process;
 	}
 	/*For CTS in case of data size aligned to 16 use CBC mode*/
-	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)) {
+	if (((nbytes % AES_BLOCK_SIZE) == 0) && ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS) {
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
 		cts_restore_flag = 1;
 	}
