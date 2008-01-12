From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] twofish-asm: Merge common glue code
Date: Sat, 12 Jan 2008 01:34:20 +0100
Message-ID: <20080112003420.GB23721@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54602 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762079AbYALAeV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2008 19:34:21 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is almost no difference between 32 & 64 bit glue code.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
Herbert, I wasn't able to compile / function test on 64bit but this
patch looks somehow trivial :)

 arch/x86/crypto/Makefile                         |    4 +-
 arch/x86/crypto/twofish_64.c                     |   97 ----------------------
 arch/x86/crypto/{twofish_32.c => twofish_glue.c} |    6 +-
 3 files changed, 5 insertions(+), 102 deletions(-)
 delete mode 100644 arch/x86/crypto/twofish_64.c
 rename arch/x86/crypto/{twofish_32.c => twofish_glue.c} (96%)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 09200e1..3874c2d 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -11,9 +11,9 @@ obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
-twofish-i586-y := twofish-i586-asm_32.o twofish_32.o
+twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
 salsa20-i586-y := salsa20-i586-asm_32.o salsa20_glue.o
 
 aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
-twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_64.o
+twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
diff --git a/arch/x86/crypto/twofish_64.c b/arch/x86/crypto/twofish_64.c
deleted file mode 100644
index 182d91d..0000000
--- a/arch/x86/crypto/twofish_64.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Glue Code for optimized x86_64 assembler version of TWOFISH
- *
- * Originally Twofish for GPG
- * By Matthew Skala <mskala@ansuz.sooke.bc.ca>, July 26, 1998
- * 256-bit key length added March 20, 1999
- * Some modifications to reduce the text size by Werner Koch, April, 1998
- * Ported to the kerneli patch by Marc Mutz <Marc@Mutz.com>
- * Ported to CryptoAPI by Colin Slater <hoho@tacomeat.net>
- *
- * The original author has disclaimed all copyright interest in this
- * code and thus put it in the public domain. The subsequent authors
- * have put this under the GNU General Public License.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
- *
- * This code is a "clean room" implementation, written from the paper
- * _Twofish: A 128-Bit Block Cipher_ by Bruce Schneier, John Kelsey,
- * Doug Whiting, David Wagner, Chris Hall, and Niels Ferguson, available
- * through http://www.counterpane.com/twofish.html
- *
- * For background information on multiplication in finite fields, used for
- * the matrix operations in the key schedule, see the book _Contemporary
- * Abstract Algebra_ by Joseph A. Gallian, especially chapter 22 in the
- * Third Edition.
- */
-
-#include <crypto/twofish.h>
-#include <linux/crypto.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/types.h>
-
-asmlinkage void twofish_enc_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-asmlinkage void twofish_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-
-static void twofish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	twofish_enc_blk(tfm, dst, src);
-}
-
-static void twofish_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	twofish_dec_blk(tfm, dst, src);
-}
-
-static struct crypto_alg alg = {
-	.cra_name		=	"twofish",
-	.cra_driver_name	=	"twofish-x86_64",
-	.cra_priority		=	200,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	TF_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct twofish_ctx),
-	.cra_alignmask		=	3,
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	TF_MIN_KEY_SIZE,
-			.cia_max_keysize	=	TF_MAX_KEY_SIZE,
-			.cia_setkey		=	twofish_setkey,
-			.cia_encrypt		=	twofish_encrypt,
-			.cia_decrypt		=	twofish_decrypt
-		}
-	}
-};
-
-static int __init init(void)
-{
-	return crypto_register_alg(&alg);
-}
-
-static void __exit fini(void)
-{
-	crypto_unregister_alg(&alg);
-}
-
-module_init(init);
-module_exit(fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION ("Twofish Cipher Algorithm, x86_64 asm optimized");
-MODULE_ALIAS("twofish");
diff --git a/arch/x86/crypto/twofish_32.c b/arch/x86/crypto/twofish_glue.c
similarity index 96%
rename from arch/x86/crypto/twofish_32.c
rename to arch/x86/crypto/twofish_glue.c
index e3004df..0c74675 100644
--- a/arch/x86/crypto/twofish_32.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -1,5 +1,5 @@
 /*
- *  Glue Code for optimized 586 assembler version of TWOFISH
+ * Glue Code for assembler optimized version of TWOFISH
  *
  * Originally Twofish for GPG
  * By Matthew Skala <mskala@ansuz.sooke.bc.ca>, July 26, 1998
@@ -44,7 +44,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-
 asmlinkage void twofish_enc_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 asmlinkage void twofish_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 
@@ -60,7 +59,7 @@ static void twofish_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 static struct crypto_alg alg = {
 	.cra_name		=	"twofish",
-	.cra_driver_name	=	"twofish-i586",
+	.cra_driver_name	=	"twofish-asm",
 	.cra_priority		=	200,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	TF_BLOCK_SIZE,
@@ -95,3 +94,4 @@ module_exit(fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Twofish Cipher Algorithm, i586 asm optimized");
 MODULE_ALIAS("twofish");
+MODULE_ALIAS("twofish-asm");
-- 
1.5.3.7
