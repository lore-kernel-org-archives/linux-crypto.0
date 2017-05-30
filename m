From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 27/27] Drivers: ccree: cc_crypto_ctx.h - align block comments
Date: Tue, 30 May 2017 18:17:25 +1200
Message-ID: <20170530061725.14230-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34096 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdE3GRg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:17:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index ac39d349060d..191f92f0ef22 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -219,7 +219,8 @@ struct drv_ctx_hash {
 };
 
 /* !!!! drv_ctx_hmac should have the same structure as drv_ctx_hash except
-   k0, k0_size fields */
+ *  k0, k0_size fields
+ */
 struct drv_ctx_hmac {
 	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
 	enum drv_hash_mode mode;
@@ -240,9 +241,10 @@ struct drv_ctx_cipher {
 	u32 key_size; /* numeric value in bytes   */
 	u32 data_unit_size; /* required for XTS */
 	/* block_state is the AES engine block state.
-	*  It is used by the host to pass IV or counter at initialization.
-	*  It is used by SeP for intermediate block chaining state and for
-	*  returning MAC algorithms results.           */
+	 *  It is used by the host to pass IV or counter at initialization.
+	 *  It is used by SeP for intermediate block chaining state and for
+	 *  returning MAC algorithms results.
+         */
 	u8 block_state[CC_AES_BLOCK_SIZE];
 	u8 key[CC_AES_KEY_SIZE_MAX];
 	u8 xex_key[CC_AES_KEY_SIZE_MAX];
@@ -279,9 +281,10 @@ struct drv_ctx_aead {
 
 
 /* Get the address of a @member within a given @ctx address
-   @ctx: The context address
-   @type: Type of context structure
-   @member: Associated context field */
+ *  @ctx: The context address
+ *  @type: Type of context structure
+ *  @member: Associated context field
+ */
 #define GET_CTX_FIELD_ADDR(ctx, type, member) (ctx + offsetof(type, member))
 
 #endif /* _CC_CRYPTO_CTX_H_ */
-- 
2.13.0
