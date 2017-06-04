From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 18/18] staging: ccree: remove descriptor context definitions
Date: Sun,  4 Jun 2017 11:02:39 +0300
Message-ID: <1496563362-7954-19-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52866 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdFDIEc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 04:04:32 -0400
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove definitions of descriptor context which are not used
in the driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 86 -----------------------------------
 1 file changed, 86 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 20f3f9f..591f6fd 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -196,91 +196,5 @@ enum drv_crypto_padding_type {
 	DRV_PADDING_RESERVE32B = S32_MAX
 };
 
-/*******************************************************************/
-/***************** DESCRIPTOR BASED CONTEXTS ***********************/
-/*******************************************************************/
-
- /* Generic context ("super-class") */
-struct drv_ctx_generic {
-	enum drv_crypto_alg alg;
-} __attribute__((__may_alias__));
-
-struct drv_ctx_hash {
-	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HASH */
-	enum drv_hash_mode mode;
-	u8 digest[CC_DIGEST_SIZE_MAX];
-	/* reserve to end of allocated context size */
-	u8 reserved[CC_CTX_SIZE - 2 * sizeof(u32) -
-			CC_DIGEST_SIZE_MAX];
-};
-
-/* NOTE! drv_ctx_hmac should have the same structure as drv_ctx_hash except
- * k0, k0_size fields
- */
-struct drv_ctx_hmac {
-	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
-	enum drv_hash_mode mode;
-	u8 digest[CC_DIGEST_SIZE_MAX];
-	u32 k0[CC_HMAC_BLOCK_SIZE_MAX / sizeof(u32)];
-	u32 k0_size;
-	/* reserve to end of allocated context size */
-	u8 reserved[CC_CTX_SIZE - 3 * sizeof(u32) -
-			CC_DIGEST_SIZE_MAX - CC_HMAC_BLOCK_SIZE_MAX];
-};
-
-struct drv_ctx_cipher {
-	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_AES */
-	enum drv_cipher_mode mode;
-	enum drv_crypto_direction direction;
-	enum drv_crypto_key_type crypto_key_type;
-	enum drv_crypto_padding_type padding_type;
-	u32 key_size; /* numeric value in bytes   */
-	u32 data_unit_size; /* required for XTS */
-	/* block_state is the AES engine block state.
-	 * It is used by the host to pass IV or counter at initialization.
-	 * It is used by SeP for intermediate block chaining state and for
-	 * returning MAC algorithms results.
-	 */
-	u8 block_state[CC_AES_BLOCK_SIZE];
-	u8 key[CC_AES_KEY_SIZE_MAX];
-	u8 xex_key[CC_AES_KEY_SIZE_MAX];
-	/* reserve to end of allocated context size */
-	u32 reserved[CC_DRV_CTX_SIZE_WORDS - 7 -
-		CC_AES_BLOCK_SIZE / sizeof(u32) - 2 *
-		(CC_AES_KEY_SIZE_MAX / sizeof(u32))];
-};
-
-/* authentication and encryption with associated data class */
-struct drv_ctx_aead {
-	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_AES */
-	enum drv_cipher_mode mode;
-	enum drv_crypto_direction direction;
-	u32 key_size; /* numeric value in bytes   */
-	u32 nonce_size; /* nonce size (octets) */
-	u32 header_size; /* finit additional data size (octets) */
-	u32 text_size; /* finit text data size (octets) */
-	u32 tag_size; /* mac size, element of {4, 6, 8, 10, 12, 14, 16} */
-	/* block_state1/2 is the AES engine block state */
-	u8 block_state[CC_AES_BLOCK_SIZE];
-	u8 mac_state[CC_AES_BLOCK_SIZE]; /* MAC result */
-	u8 nonce[CC_AES_BLOCK_SIZE]; /* nonce buffer */
-	u8 key[CC_AES_KEY_SIZE_MAX];
-	/* reserve to end of allocated context size */
-	u32 reserved[CC_DRV_CTX_SIZE_WORDS - 8 -
-		3 * (CC_AES_BLOCK_SIZE / sizeof(u32)) -
-		CC_AES_KEY_SIZE_MAX / sizeof(u32)];
-};
-
-/*******************************************************************/
-/***************** MESSAGE BASED CONTEXTS **************************/
-/*******************************************************************/
-
-/* Get the address of a @member within a given @ctx address
- * @ctx: The context address
- * @type: Type of context structure
- * @member: Associated context field
- */
-#define GET_CTX_FIELD_ADDR(ctx, type, member) ((ctx) + offsetof(type, member))
-
 #endif /* _CC_CRYPTO_CTX_H_ */
 
-- 
2.1.4
