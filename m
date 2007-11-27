From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] remove similar aes glue code
Date: Tue, 27 Nov 2007 20:31:59 +0100
Message-ID: <20071127193159.GA3506@Chamillionaire.breakpoint.cc>
References: <20071102180503.712394234@ml.breakpoint.cc> <20071102181036.701800933@ml.breakpoint.cc> <20071110111955.GB5485@gondor.apana.org.au> <20071110212000.GC15150@Chamillionaire.breakpoint.cc> <20071111011856.GA10745@gondor.apana.org.au> <20071126093500.GD18309@Chamillionaire.breakpoint.cc> <20071126103222.GA26178@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38959 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbXK0TcD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Nov 2007 14:32:03 -0500
Content-Disposition: inline
In-Reply-To: <20071126103222.GA26178@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

32 bit and 64 bit glue code is using (now) the same
piece code. This patch unifies them.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/x86/crypto/Makefile                 |    4 +-
 arch/x86/crypto/aes_32.c                 |   58 ------------------------------
 arch/x86/crypto/{aes_64.c => aes_glue.c} |   35 +++++++++---------
 3 files changed, 20 insertions(+), 77 deletions(-)
 delete mode 100644 arch/x86/crypto/aes_32.c
 rename arch/x86/crypto/{aes_64.c => aes_glue.c} (52%)

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
similarity index 52%
rename from arch/x86/crypto/aes_64.c
rename to arch/x86/crypto/aes_glue.c
index d7a41a9..71f4578 100644
--- a/arch/x86/crypto/aes_64.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -1,5 +1,5 @@
 /*
- * Glue Code for AES Cipher Algorithm
+ * Glue Code for the asm optimized version of the AES Cipher Algorithm
  *
  */
 
@@ -19,21 +19,21 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 }
 
 static struct crypto_alg aes_alg = {
-	.cra_name		=	"aes",
-	.cra_driver_name	=	"aes-x86_64",
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
+	.cra_name		= "aes",
+	.cra_driver_name	= "aes-asm",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(aes_alg.cra_list),
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= AES_MIN_KEY_SIZE,
+			.cia_max_keysize	= AES_MAX_KEY_SIZE,
+			.cia_setkey		= crypto_aes_set_key,
+			.cia_encrypt		= aes_encrypt,
+			.cia_decrypt		= aes_decrypt
 		}
 	}
 };
@@ -51,6 +51,7 @@ static void __exit aes_fini(void)
 module_init(aes_init);
 module_exit(aes_fini);
 
-MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, asm optimized");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("aes");
+MODULE_ALIAS("aes-asm");
-- 
1.5.2.5
