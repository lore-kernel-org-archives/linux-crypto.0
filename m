From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/4] ARM: move AES typedefs and function prototypes to separate header
Date: Fri, 20 Sep 2013 20:46:50 +0200
Message-ID: <1379702811-8025-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46188 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3ITSri (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Sep 2013 14:47:38 -0400
Received: by mail-wi0-f172.google.com with SMTP id hn9so7584349wib.5
        for <linux-crypto@vger.kernel.org>; Fri, 20 Sep 2013 11:47:37 -0700 (PDT)
In-Reply-To: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Put the struct definitions for AES keys and the asm function prototypes in a
separate header and export the asm functions from the module.
This allows other drivers to use them directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes_glue.c | 22 ++++++----------------
 arch/arm/crypto/aes_glue.h | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm/crypto/aes_glue.h

diff --git a/arch/arm/crypto/aes_glue.c b/arch/arm/crypto/aes_glue.c
index 59f7877..3003fa1 100644
--- a/arch/arm/crypto/aes_glue.c
+++ b/arch/arm/crypto/aes_glue.c
@@ -6,22 +6,12 @@
 #include <linux/crypto.h>
 #include <crypto/aes.h>
 
-#define AES_MAXNR 14
+#include "aes_glue.h"
 
-typedef struct {
-	unsigned int rd_key[4 *(AES_MAXNR + 1)];
-	int rounds;
-} AES_KEY;
-
-struct AES_CTX {
-	AES_KEY enc_key;
-	AES_KEY dec_key;
-};
-
-asmlinkage void AES_encrypt(const u8 *in, u8 *out, AES_KEY *ctx);
-asmlinkage void AES_decrypt(const u8 *in, u8 *out, AES_KEY *ctx);
-asmlinkage int private_AES_set_decrypt_key(const unsigned char *userKey, const int bits, AES_KEY *key);
-asmlinkage int private_AES_set_encrypt_key(const unsigned char *userKey, const int bits, AES_KEY *key);
+EXPORT_SYMBOL(AES_encrypt);
+EXPORT_SYMBOL(AES_decrypt);
+EXPORT_SYMBOL(private_AES_set_encrypt_key);
+EXPORT_SYMBOL(private_AES_set_decrypt_key);
 
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
@@ -81,7 +71,7 @@ static struct crypto_alg aes_alg = {
 		.cipher	= {
 			.cia_min_keysize	= AES_MIN_KEY_SIZE,
 			.cia_max_keysize	= AES_MAX_KEY_SIZE,
-			.cia_setkey			= aes_set_key,
+			.cia_setkey		= aes_set_key,
 			.cia_encrypt		= aes_encrypt,
 			.cia_decrypt		= aes_decrypt
 		}
diff --git a/arch/arm/crypto/aes_glue.h b/arch/arm/crypto/aes_glue.h
new file mode 100644
index 0000000..cca3e51
--- /dev/null
+++ b/arch/arm/crypto/aes_glue.h
@@ -0,0 +1,19 @@
+
+#define AES_MAXNR 14
+
+struct AES_KEY {
+	unsigned int rd_key[4 * (AES_MAXNR + 1)];
+	int rounds;
+};
+
+struct AES_CTX {
+	struct AES_KEY enc_key;
+	struct AES_KEY dec_key;
+};
+
+asmlinkage void AES_encrypt(const u8 *in, u8 *out, struct AES_KEY *ctx);
+asmlinkage void AES_decrypt(const u8 *in, u8 *out, struct AES_KEY *ctx);
+asmlinkage int private_AES_set_decrypt_key(const unsigned char *userKey,
+					   const int bits, struct AES_KEY *key);
+asmlinkage int private_AES_set_encrypt_key(const unsigned char *userKey,
+					   const int bits, struct AES_KEY *key);
-- 
1.8.1.2
