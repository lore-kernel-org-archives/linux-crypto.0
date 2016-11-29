From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam - fix key pointer size warning
Date: Tue, 29 Nov 2016 10:22:49 +0200
Message-ID: <1480407769-15336-1-git-send-email-horia.geanta@nxp.com>
References: <201611290428.uAmzPb1J%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, Dan Douglass <dan.douglass@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0055.outbound.protection.outlook.com ([104.47.34.55]:25376
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756118AbcK2IXp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 03:23:45 -0500
In-Reply-To: <201611290428.uAmzPb1J%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When building on 32-bit, compiler issues [-Wint-to-pointer-cast] warnings:

drivers/crypto/caam/caamalg_desc.c: In function 'cnstr_shdsc_aead_null_encap':
drivers/crypto/caam/caamalg_desc.c:67:27: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   append_key_as_imm(desc, (void *)adata->key, adata->keylen_pad,
[...]

Since in all these cases the u64 "key" member of alginfo struct holds
a uintptr_t value, we can safely remove the warnings by explicitly casting
to uinptr_t (before any other existing cast).

Fixes: 8cea7b66b821 ("crypto: caam - refactor encryption descriptors generation")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c | 64 +++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index fa2479d9da24..d4ccd164890d 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -64,9 +64,9 @@ void cnstr_shdsc_aead_null_encap(u32 * const desc, struct alginfo *adata,
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
 	if (adata->key_inline)
-		append_key_as_imm(desc, (void *)adata->key, adata->keylen_pad,
-				  adata->keylen, CLASS_2 | KEY_DEST_MDHA_SPLIT |
-				  KEY_ENC);
+		append_key_as_imm(desc, (void *)(uintptr_t)adata->key,
+				  adata->keylen_pad, adata->keylen, CLASS_2 |
+				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
 	else
 		append_key(desc, adata->key, adata->keylen, CLASS_2 |
 			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
@@ -140,8 +140,8 @@ void cnstr_shdsc_aead_null_decap(u32 * const desc, struct alginfo *adata,
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
 	if (adata->key_inline)
-		append_key_as_imm(desc, (void *)adata->key, adata->keylen_pad,
-				  adata->keylen, CLASS_2 |
+		append_key_as_imm(desc, (void *)(uintptr_t)adata->key,
+				  adata->keylen_pad, adata->keylen, CLASS_2 |
 				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
 	else
 		append_key(desc, adata->key, adata->keylen, CLASS_2 |
@@ -225,16 +225,17 @@ static void init_sh_desc_key_aead(u32 * const desc,
 		enckeylen -= CTR_RFC3686_NONCE_SIZE;
 
 	if (adata->key_inline)
-		append_key_as_imm(desc, (void *)adata->key, adata->keylen_pad,
-				  adata->keylen, CLASS_2 |
+		append_key_as_imm(desc, (void *)(uintptr_t)adata->key,
+				  adata->keylen_pad, adata->keylen, CLASS_2 |
 				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
 	else
 		append_key(desc, adata->key, adata->keylen, CLASS_2 |
 			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
 
 	if (cdata->key_inline)
-		append_key_as_imm(desc, (void *)cdata->key, enckeylen,
-				  enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		append_key_as_imm(desc, (void *)(uintptr_t)cdata->key,
+				  enckeylen, enckeylen, CLASS_1 |
+				  KEY_DEST_CLASS_REG);
 	else
 		append_key(desc, cdata->key, enckeylen, CLASS_1 |
 			   KEY_DEST_CLASS_REG);
@@ -536,8 +537,9 @@ void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD | JUMP_COND_SELF);
 	if (cdata->key_inline)
-		append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
-				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		append_key_as_imm(desc, (void *)(uintptr_t)cdata->key,
+				  cdata->keylen, cdata->keylen, CLASS_1 |
+				  KEY_DEST_CLASS_REG);
 	else
 		append_key(desc, cdata->key, cdata->keylen, CLASS_1 |
 			   KEY_DEST_CLASS_REG);
@@ -626,8 +628,9 @@ void cnstr_shdsc_gcm_decap(u32 * const desc, struct alginfo *cdata,
 				   JUMP_TEST_ALL | JUMP_COND_SHRD |
 				   JUMP_COND_SELF);
 	if (cdata->key_inline)
-		append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
-				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		append_key_as_imm(desc, (void *)(uintptr_t)cdata->key,
+				  cdata->keylen, cdata->keylen, CLASS_1 |
+				  KEY_DEST_CLASS_REG);
 	else
 		append_key(desc, cdata->key, cdata->keylen, CLASS_1 |
 			   KEY_DEST_CLASS_REG);
@@ -702,8 +705,9 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
 	if (cdata->key_inline)
-		append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
-				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		append_key_as_imm(desc, (void *)(uintptr_t)cdata->key,
+				  cdata->keylen, cdata->keylen, CLASS_1 |
+				  KEY_DEST_CLASS_REG);
 	else
 		append_key(desc, cdata->key, cdata->keylen, CLASS_1 |
 			   KEY_DEST_CLASS_REG);
@@ -773,8 +777,8 @@ void cnstr_shdsc_rfc4106_decap(u32 * const desc, struct alginfo *cdata,
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
 	if (cdata->key_inline)
-		append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
-				  cdata->keylen, CLASS_1 |
+		append_key_as_imm(desc, (void *)(uintptr_t)cdata->key,
+				  cdata->keylen, cdata->keylen, CLASS_1 |
 				  KEY_DEST_CLASS_REG);
 	else
 		append_key(desc, cdata->key, cdata->keylen, CLASS_1 |
@@ -845,8 +849,9 @@ void cnstr_shdsc_rfc4543_encap(u32 * const desc, struct alginfo *cdata,
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
 	if (cdata->key_inline)
-		append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
-				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		append_key_as_imm(desc, (void *)(uintptr_t)cdata->key,
+				  cdata->keylen, cdata->keylen, CLASS_1 |
+				  KEY_DEST_CLASS_REG);
 	else
 		append_key(desc, cdata->key, cdata->keylen, CLASS_1 |
 			   KEY_DEST_CLASS_REG);
@@ -915,8 +920,9 @@ void cnstr_shdsc_rfc4543_decap(u32 * const desc, struct alginfo *cdata,
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
 	if (cdata->key_inline)
-		append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
-				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		append_key_as_imm(desc, (void *)(uintptr_t)cdata->key,
+				  cdata->keylen, cdata->keylen, CLASS_1 |
+				  KEY_DEST_CLASS_REG);
 	else
 		append_key(desc, cdata->key, cdata->keylen, CLASS_1 |
 			   KEY_DEST_CLASS_REG);
@@ -1006,12 +1012,12 @@ void cnstr_shdsc_ablkcipher_encap(u32 * const desc, struct alginfo *cdata,
 				   JUMP_COND_SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
+	append_key_as_imm(desc, (void *)(uintptr_t)cdata->key, cdata->keylen,
 			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		u8 *nonce = (u8 *)cdata->key + cdata->keylen;
+		u8 *nonce = (u8 *)(uintptr_t)cdata->key + cdata->keylen;
 
 		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
 				   LDST_CLASS_IND_CCB |
@@ -1071,12 +1077,12 @@ void cnstr_shdsc_ablkcipher_decap(u32 * const desc, struct alginfo *cdata,
 				   JUMP_COND_SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
+	append_key_as_imm(desc, (void *)(uintptr_t)cdata->key, cdata->keylen,
 			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		u8 *nonce = (u8 *)cdata->key + cdata->keylen;
+		u8 *nonce = (u8 *)(uintptr_t)cdata->key + cdata->keylen;
 
 		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
 				   LDST_CLASS_IND_CCB |
@@ -1140,12 +1146,12 @@ void cnstr_shdsc_ablkcipher_givencap(u32 * const desc, struct alginfo *cdata,
 				   JUMP_COND_SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
+	append_key_as_imm(desc, (void *)(uintptr_t)cdata->key, cdata->keylen,
 			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
 	/* Load Nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		u8 *nonce = (u8 *)cdata->key + cdata->keylen;
+		u8 *nonce = (u8 *)(uintptr_t)cdata->key + cdata->keylen;
 
 		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
 				   LDST_CLASS_IND_CCB |
@@ -1216,7 +1222,7 @@ void cnstr_shdsc_xts_ablkcipher_encap(u32 * const desc, struct alginfo *cdata)
 				   JUMP_COND_SHRD);
 
 	/* Load class1 keys only */
-	append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
+	append_key_as_imm(desc, (void *)(uintptr_t)cdata->key, cdata->keylen,
 			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
 	/* Load sector size with index 40 bytes (0x28) */
@@ -1268,7 +1274,7 @@ void cnstr_shdsc_xts_ablkcipher_decap(u32 * const desc, struct alginfo *cdata)
 				   JUMP_COND_SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, (void *)cdata->key, cdata->keylen,
+	append_key_as_imm(desc, (void *)(uintptr_t)cdata->key, cdata->keylen,
 			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
 	/* Load sector size with index 40 bytes (0x28) */
-- 
2.4.4
