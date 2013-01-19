From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 01/12] crypto: x86/aes - assembler clean-ups: use
 ENTRY/ENDPROC, localize jump targets
Date: Sat, 19 Jan 2013 13:38:50 +0200
Message-ID: <20130119113850.22319.43587.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58207 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLix (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:38:53 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aes-i586-asm_32.S   |   15 +++++----------
 arch/x86/crypto/aes-x86_64-asm_64.S |   30 +++++++++++++++---------------
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/aes-i586-asm_32.S b/arch/x86/crypto/aes-i586-asm_32.S
index b949ec2..2849dbc 100644
--- a/arch/x86/crypto/aes-i586-asm_32.S
+++ b/arch/x86/crypto/aes-i586-asm_32.S
@@ -36,6 +36,7 @@
 .file "aes-i586-asm.S"
 .text
 
+#include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 
 #define tlen 1024   // length of each of 4 'xor' arrays (256 32-bit words)
@@ -219,14 +220,10 @@
 // AES (Rijndael) Encryption Subroutine
 /* void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out_blk, const u8 *in_blk) */
 
-.global  aes_enc_blk
-
 .extern  crypto_ft_tab
 .extern  crypto_fl_tab
 
-.align 4
-
-aes_enc_blk:
+ENTRY(aes_enc_blk)
 	push    %ebp
 	mov     ctx(%esp),%ebp
 
@@ -290,18 +287,15 @@ aes_enc_blk:
 	mov     %r0,(%ebp)
 	pop     %ebp
 	ret
+ENDPROC(aes_enc_blk)
 
 // AES (Rijndael) Decryption Subroutine
 /* void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out_blk, const u8 *in_blk) */
 
-.global  aes_dec_blk
-
 .extern  crypto_it_tab
 .extern  crypto_il_tab
 
-.align 4
-
-aes_dec_blk:
+ENTRY(aes_dec_blk)
 	push    %ebp
 	mov     ctx(%esp),%ebp
 
@@ -365,3 +359,4 @@ aes_dec_blk:
 	mov     %r0,(%ebp)
 	pop     %ebp
 	ret
+ENDPROC(aes_dec_blk)
diff --git a/arch/x86/crypto/aes-x86_64-asm_64.S b/arch/x86/crypto/aes-x86_64-asm_64.S
index 5b577d5..9105655 100644
--- a/arch/x86/crypto/aes-x86_64-asm_64.S
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -15,6 +15,7 @@
 
 .text
 
+#include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 
 #define R1	%rax
@@ -49,10 +50,8 @@
 #define R11	%r11
 
 #define prologue(FUNC,KEY,B128,B192,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11) \
-	.global	FUNC;			\
-	.type	FUNC,@function;		\
-	.align	8;			\
-FUNC:	movq	r1,r2;			\
+	ENTRY(FUNC);			\
+	movq	r1,r2;			\
 	movq	r3,r4;			\
 	leaq	KEY+48(r8),r9;		\
 	movq	r10,r11;		\
@@ -71,14 +70,15 @@ FUNC:	movq	r1,r2;			\
 	je	B192;			\
 	leaq	32(r9),r9;
 
-#define epilogue(r1,r2,r3,r4,r5,r6,r7,r8,r9) \
+#define epilogue(FUNC,r1,r2,r3,r4,r5,r6,r7,r8,r9) \
 	movq	r1,r2;			\
 	movq	r3,r4;			\
 	movl	r5 ## E,(r9);		\
 	movl	r6 ## E,4(r9);		\
 	movl	r7 ## E,8(r9);		\
 	movl	r8 ## E,12(r9);		\
-	ret;
+	ret;				\
+	ENDPROC(FUNC);
 
 #define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
 	movzbl	r2 ## H,r5 ## E;	\
@@ -133,7 +133,7 @@ FUNC:	movq	r1,r2;			\
 #define entry(FUNC,KEY,B128,B192) \
 	prologue(FUNC,KEY,B128,B192,R2,R8,R7,R9,R1,R3,R4,R6,R10,R5,R11)
 
-#define return epilogue(R8,R2,R9,R7,R5,R6,R3,R4,R11)
+#define return(FUNC) epilogue(FUNC,R8,R2,R9,R7,R5,R6,R3,R4,R11)
 
 #define encrypt_round(TAB,OFFSET) \
 	round(TAB,OFFSET,R1,R2,R3,R4,R5,R6,R7,R10,R5,R6,R3,R4) \
@@ -151,12 +151,12 @@ FUNC:	movq	r1,r2;			\
 
 /* void aes_enc_blk(stuct crypto_tfm *tfm, u8 *out, const u8 *in) */
 
-	entry(aes_enc_blk,0,enc128,enc192)
+	entry(aes_enc_blk,0,.Le128,.Le192)
 	encrypt_round(crypto_ft_tab,-96)
 	encrypt_round(crypto_ft_tab,-80)
-enc192:	encrypt_round(crypto_ft_tab,-64)
+.Le192:	encrypt_round(crypto_ft_tab,-64)
 	encrypt_round(crypto_ft_tab,-48)
-enc128:	encrypt_round(crypto_ft_tab,-32)
+.Le128:	encrypt_round(crypto_ft_tab,-32)
 	encrypt_round(crypto_ft_tab,-16)
 	encrypt_round(crypto_ft_tab,  0)
 	encrypt_round(crypto_ft_tab, 16)
@@ -166,16 +166,16 @@ enc128:	encrypt_round(crypto_ft_tab,-32)
 	encrypt_round(crypto_ft_tab, 80)
 	encrypt_round(crypto_ft_tab, 96)
 	encrypt_final(crypto_fl_tab,112)
-	return
+	return(aes_enc_blk)
 
 /* void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in) */
 
-	entry(aes_dec_blk,240,dec128,dec192)
+	entry(aes_dec_blk,240,.Ld128,.Ld192)
 	decrypt_round(crypto_it_tab,-96)
 	decrypt_round(crypto_it_tab,-80)
-dec192:	decrypt_round(crypto_it_tab,-64)
+.Ld192:	decrypt_round(crypto_it_tab,-64)
 	decrypt_round(crypto_it_tab,-48)
-dec128:	decrypt_round(crypto_it_tab,-32)
+.Ld128:	decrypt_round(crypto_it_tab,-32)
 	decrypt_round(crypto_it_tab,-16)
 	decrypt_round(crypto_it_tab,  0)
 	decrypt_round(crypto_it_tab, 16)
@@ -185,4 +185,4 @@ dec128:	decrypt_round(crypto_it_tab,-32)
 	decrypt_round(crypto_it_tab, 80)
 	decrypt_round(crypto_it_tab, 96)
 	decrypt_final(crypto_il_tab,112)
-	return
+	return(aes_dec_blk)
