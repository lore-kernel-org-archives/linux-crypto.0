From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/3] crypto: twofish-x86-asm: make assembler functions use
	twofish_ctx instead of crypto_tfm
Date: Mon, 26 Sep 2011 16:47:20 +0300
Message-ID: <20110926134720.21453.93330.stgit@localhost6.localdomain6>
References: <20110926134715.21453.18179.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Joachim Fritschi <jfritschi@freenet.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:49385 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1IZNrY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 09:47:24 -0400
In-Reply-To: <20110926134715.21453.18179.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This needed by 3-way twofish patch to be able to easily use one block
assembler functions. As glue code is shared between i586/x86_64 apply
change to i586 assembler too. Also export assembler functions for
3-way parallel twofish module.

CC: Joachim Fritschi <jfritschi@freenet.de>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish-i586-asm_32.S   |   10 +++++-----
 arch/x86/crypto/twofish-x86_64-asm_64.S |    6 ++----
 arch/x86/crypto/twofish_glue.c          |   12 ++++++++----
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/crypto/twofish-i586-asm_32.S b/arch/x86/crypto/twofish-i586-asm_32.S
index 575331c..658af4b 100644
--- a/arch/x86/crypto/twofish-i586-asm_32.S
+++ b/arch/x86/crypto/twofish-i586-asm_32.S
@@ -26,7 +26,7 @@
 
 #define in_blk    12  /* input byte array address parameter*/
 #define out_blk   8  /* output byte array address parameter*/
-#define tfm       4  /* Twofish context structure */
+#define ctx       4  /* Twofish context structure */
 
 #define a_offset	0
 #define b_offset	4
@@ -229,8 +229,8 @@ twofish_enc_blk:
 	push    %esi
 	push    %edi
 
-	mov	tfm + 16(%esp),	%ebp	/* abuse the base pointer: set new base bointer to the crypto tfm */
-	add	$crypto_tfm_ctx_offset, %ebp	/* ctx address */
+	mov	ctx + 16(%esp),	%ebp	/* abuse the base pointer: set new base
+					 * pointer to the ctx address */
 	mov     in_blk+16(%esp),%edi	/* input address in edi */
 
 	mov	(%edi),		%eax
@@ -285,8 +285,8 @@ twofish_dec_blk:
 	push    %edi
 
 
-	mov	tfm + 16(%esp),	%ebp	/* abuse the base pointer: set new base bointer to the crypto tfm */
-	add	$crypto_tfm_ctx_offset, %ebp	/* ctx address */
+	mov	ctx + 16(%esp),	%ebp	/* abuse the base pointer: set new base
+					 * pointer to the ctx address */
 	mov     in_blk+16(%esp),%edi	/* input address in edi */
 
 	mov	(%edi),		%eax
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64.S b/arch/x86/crypto/twofish-x86_64-asm_64.S
index 573aa10..7bcf3fc 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64.S
@@ -221,10 +221,9 @@
 twofish_enc_blk:
 	pushq    R1
 
-	/* %rdi contains the crypto tfm address */
+	/* %rdi contains the ctx address */
 	/* %rsi contains the output address */
 	/* %rdx contains the input address */
-	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx address */
 	/* ctx address is moved to free one non-rex register
 	as target for the 8bit high operations */
 	mov	%rdi,		%r11
@@ -274,10 +273,9 @@ twofish_enc_blk:
 twofish_dec_blk:
 	pushq    R1
 
-	/* %rdi contains the crypto tfm address */
+	/* %rdi contains the ctx address */
 	/* %rsi contains the output address */
 	/* %rdx contains the input address */
-	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx address */
 	/* ctx address is moved to free one non-rex register
 	as target for the 8bit high operations */
 	mov	%rdi,		%r11
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index cefaf8b..dc6b3fb 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -44,17 +44,21 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-asmlinkage void twofish_enc_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-asmlinkage void twofish_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
+asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+EXPORT_SYMBOL_GPL(twofish_enc_blk);
+asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+EXPORT_SYMBOL_GPL(twofish_dec_blk);
 
 static void twofish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
-	twofish_enc_blk(tfm, dst, src);
+	twofish_enc_blk(crypto_tfm_ctx(tfm), dst, src);
 }
 
 static void twofish_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
-	twofish_dec_blk(tfm, dst, src);
+	twofish_dec_blk(crypto_tfm_ctx(tfm), dst, src);
 }
 
 static struct crypto_alg alg = {
