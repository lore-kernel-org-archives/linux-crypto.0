From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 16/20] staging: ccree: use snake_case for hash enums
Date: Thu,  1 Jun 2017 14:03:06 +0300
Message-ID: <1496314993-30229-17-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hash enum were named using CamelCase, move over to snake_case.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 4 ++--
 drivers/staging/ccree/hash_defs.h        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index 8dc9b6e..1cbd2e1 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -505,7 +505,7 @@ static inline void set_cipher_config0(struct cc_hw_desc *pdesc,
  * @config: Any one of the modes defined in [CC7x-DESC]
  */
 static inline void set_cipher_config1(struct cc_hw_desc *pdesc,
-				      enum HashConfig1Padding config)
+				      enum cc_hash_conf_pad config)
 {
 	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF1, config);
 }
@@ -598,7 +598,7 @@ static inline void set_setup_mode(struct cc_hw_desc *pdesc,
  * @config: Any one of the cipher do defined in [CC7x-DESC]
  */
 static inline void set_cipher_do(struct cc_hw_desc *pdesc,
-				 enum HashCipherDoPadding config)
+				 enum cc_hash_cipher_pad config)
 {
 	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_DO,
 				(config & HW_KEY_MASK_CIPHER_DO));
diff --git a/drivers/staging/ccree/hash_defs.h b/drivers/staging/ccree/hash_defs.h
index 9e01219..872ed97 100644
--- a/drivers/staging/ccree/hash_defs.h
+++ b/drivers/staging/ccree/hash_defs.h
@@ -44,14 +44,14 @@
 #define HASH_LARVAL_SHA512 0x5be0cd19, 0x137e2179, 0x1f83d9ab, 0xfb41bd6b, 0x9b05688c, 0x2b3e6c1f, 0x510e527f, 0xade682d1, 0xa54ff53a, 0x5f1d36f1, 0x3c6ef372, 0xfe94f82b, 0xbb67ae85, 0x84caa73b, 0x6a09e667, 0xf3bcc908
 #endif
 
-enum HashConfig1Padding {
+enum cc_hash_conf_pad {
 	HASH_PADDING_DISABLED = 0,
 	HASH_PADDING_ENABLED = 1,
 	HASH_DIGEST_RESULT_LITTLE_ENDIAN = 2,
 	HASH_CONFIG1_PADDING_RESERVE32 = S32_MAX,
 };
 
-enum HashCipherDoPadding {
+enum cc_hash_cipher_pad {
 	DO_NOT_PAD = 0,
 	DO_PAD = 1,
 	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
-- 
2.1.4
