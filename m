From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [patch 2/2] remove similar aes glue code
Date: Sat, 03 Nov 2007 11:05:03 +0100
Message-ID: <20071102181036.701800933@ml.breakpoint.cc>
References: <20071102180503.712394234@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52519 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbXKCKFQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Nov 2007 06:05:16 -0400
Content-Disposition: inline; filename=0002-crypto-remove-similar-aes-glue-code.patch
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

32 bit and 64 bit glue code is using (now) the same
gleue code. Make it one.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/x86/crypto/Makefile                 |    4 +-
 arch/x86/crypto/aes_32.c                 |   58 ------------------------------
 arch/x86/crypto/{aes_64.c => aes_glue.c} |   23 ++++++------
 3 files changed, 14 insertions(+), 71 deletions(-)
 delete mode 100644 arch/x86/crypto/aes_32.c
 rename arch/x86/crypto/{aes_64.c => aes_glue.c} (69%)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 46bb609..b8fbb43 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -8,8 +8,8 @@ obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 
-aes-i586-y := aes-i586-asm_32.o aes_32.o
+aes-i586-y := aes-i586-asm_32.o aes_glue.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_32.o
 
-aes-x86_64-y := aes-x86_64-asm_64.o aes_64.o
+aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_64.o
diff --git a/arch/x86/crypto/aes_32.c b/arch/x86/crypto/aes_32.c
deleted file mode 100644
index 8556d95..0000000
--- a/arch/x86/crypto/aes_32.c
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * Glue Code for optimized 586 assembler version of AES
- */
-
-#include <crypto/aes.h>
-#include <linux/module.h>
-#include <linux/crypto.h>
-
-asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	aes_enc_blk(tfm, dst, src);
-}
-
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	aes_dec_blk(tfm, dst, src);
-}
-
-static struct crypto_alg aes_alg = {
-	.cra_name		=	"aes",
-	.cra_driver_name	=	"aes-i586",
-	.cra_priority		=	200,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
-			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey		=	crypto_aes_set_key,
-			.cia_encrypt	 	=	aes_encrypt,
-			.cia_decrypt	  	=	aes_decrypt
-		}
-	}
-};
-
-static int __init aes_init(void)
-{
-	return crypto_register_alg(&aes_alg);
-}
-
-static void __exit aes_fini(void)
-{
-	crypto_unregister_alg(&aes_alg);
-}
-
-module_init(aes_init);
-module_exit(aes_fini);
-
-MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, i586 asm optimized");
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_AUTHOR("Fruhwirth Clemens, James Morris, Brian Gladman, Adam Richter");
-MODULE_ALIAS("aes");
diff --git a/arch/x86/crypto/aes_64.c b/arch/x86/crypto/aes_glue.c
similarity index 69%
rename from arch/x86/crypto/aes_64.c
rename to arch/x86/crypto/aes_glue.c
index d7a41a9..5a283a4 100644
--- a/arch/x86/crypto/aes_64.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -4,6 +4,7 @@
  */
 
 #include <crypto/aes.h>
+#include <linux/module.h>
 
 asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in);
 asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in);
@@ -19,21 +20,21 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 }
 
 static struct crypto_alg aes_alg = {
-	.cra_name		=	"aes",
-	.cra_driver_name	=	"aes-x86_64",
+	.cra_name			=	"aes",
+	.cra_driver_name	=	"aes-asm",
 	.cra_priority		=	200,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_flags			=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
-	.cra_u			=	{
-		.cipher = {
+	.cra_module			=	THIS_MODULE,
+	.cra_list			=	LIST_HEAD_INIT(aes_alg.cra_list),
+	.cra_u	=	{
+		.cipher	=	{
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey		=	crypto_aes_set_key,
-			.cia_encrypt	 	=	aes_encrypt,
-			.cia_decrypt	  	=	aes_decrypt
+			.cia_setkey			=	crypto_aes_set_key,
+			.cia_encrypt		=	aes_encrypt,
+			.cia_decrypt		=	aes_decrypt
 		}
 	}
 };
@@ -51,6 +52,6 @@ static void __exit aes_fini(void)
 module_init(aes_init);
 module_exit(aes_fini);
 
-MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, asm optimized");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("aes");
-- 
1.5.3.4
