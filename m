From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/2] crypto: ccree: remove unused enums
Date: Mon, 26 Mar 2018 08:32:18 +0100
Message-ID: <1522049540-10042-2-git-send-email-gilad@benyossef.com>
References: <1522049540-10042-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522049540-10042-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove enums definitions unused in the driver code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_hw_queue_defs.h | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index bf0d235..a091ae5 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -124,13 +124,6 @@ enum cc_flow_mode {
 	FLOW_MODE_END = S32_MAX,
 };
 
-enum cc_tunnel_op {
-	TUNNEL_OP_INVALID = -1,
-	TUNNEL_OFF = 0,
-	TUNNEL_ON = 1,
-	TUNNEL_OP_END = S32_MAX,
-};
-
 enum cc_setup_op {
 	SETUP_LOAD_NOP		= 0,
 	SETUP_LOAD_STATE0	= 1,
@@ -145,6 +138,13 @@ enum cc_setup_op {
 	SETUP_OP_END = S32_MAX,
 };
 
+enum cc_hash_conf_pad {
+	HASH_PADDING_DISABLED = 0,
+	HASH_PADDING_ENABLED = 1,
+	HASH_DIGEST_RESULT_LITTLE_ENDIAN = 2,
+	HASH_CONFIG1_PADDING_RESERVE32 = S32_MAX,
+};
+
 enum cc_aes_mac_selector {
 	AES_SK = 1,
 	AES_CMAC_INIT = 2,
@@ -179,20 +179,6 @@ enum cc_hw_aes_key_size {
 	END_OF_AES_KEYS = S32_MAX,
 };
 
-enum cc_hw_des_key_size {
-	DES_ONE_KEY = 0,
-	DES_TWO_KEYS = 1,
-	DES_THREE_KEYS = 2,
-	END_OF_DES_KEYS = S32_MAX,
-};
-
-enum cc_hash_conf_pad {
-	HASH_PADDING_DISABLED = 0,
-	HASH_PADDING_ENABLED = 1,
-	HASH_DIGEST_RESULT_LITTLE_ENDIAN = 2,
-	HASH_CONFIG1_PADDING_RESERVE32 = S32_MAX,
-};
-
 enum cc_hash_cipher_pad {
 	DO_NOT_PAD = 0,
 	DO_PAD = 1,
-- 
2.7.4
