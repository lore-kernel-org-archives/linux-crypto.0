From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 12/12] crypto: x86/twofish - assembler clean-ups: use
 ENTRY/ENDPROC, localize jump labels
Date: Sat, 19 Jan 2013 13:39:46 +0200
Message-ID: <20130119113946.22319.68494.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:36974 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:49 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S  |   35 ++++++++------------------
 arch/x86/crypto/twofish-i586-asm_32.S        |   11 ++++----
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S |   20 ++++++---------
 arch/x86/crypto/twofish-x86_64-asm_64.S      |   11 ++++----
 4 files changed, 29 insertions(+), 48 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index ebac16b..8d3e113 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/linkage.h>
 #include "glue_helper-asm-avx.S"
 
 .file "twofish-avx-x86_64-asm_64.S"
@@ -243,8 +244,6 @@
 	vpxor		x3, wkey, x3;
 
 .align 8
-.type	__twofish_enc_blk8,@function;
-
 __twofish_enc_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -284,10 +283,9 @@ __twofish_enc_blk8:
 	outunpack_blocks(RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 
 	ret;
+ENDPROC(__twofish_enc_blk8)
 
 .align 8
-.type	__twofish_dec_blk8,@function;
-
 __twofish_dec_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -325,12 +323,9 @@ __twofish_dec_blk8:
 	outunpack_blocks(RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
 
 	ret;
+ENDPROC(__twofish_dec_blk8)
 
-.align 8
-.global twofish_ecb_enc_8way
-.type   twofish_ecb_enc_8way,@function;
-
-twofish_ecb_enc_8way:
+ENTRY(twofish_ecb_enc_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -346,12 +341,9 @@ twofish_ecb_enc_8way:
 	store_8way(%r11, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
 
 	ret;
+ENDPROC(twofish_ecb_enc_8way)
 
-.align 8
-.global twofish_ecb_dec_8way
-.type   twofish_ecb_dec_8way,@function;
-
-twofish_ecb_dec_8way:
+ENTRY(twofish_ecb_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -367,12 +359,9 @@ twofish_ecb_dec_8way:
 	store_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	ret;
+ENDPROC(twofish_ecb_dec_8way)
 
-.align 8
-.global twofish_cbc_dec_8way
-.type   twofish_cbc_dec_8way,@function;
-
-twofish_cbc_dec_8way:
+ENTRY(twofish_cbc_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -393,12 +382,9 @@ twofish_cbc_dec_8way:
 	popq %r12;
 
 	ret;
+ENDPROC(twofish_cbc_dec_8way)
 
-.align 8
-.global twofish_ctr_8way
-.type   twofish_ctr_8way,@function;
-
-twofish_ctr_8way:
+ENTRY(twofish_ctr_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -421,3 +407,4 @@ twofish_ctr_8way:
 	popq %r12;
 
 	ret;
+ENDPROC(twofish_ctr_8way)
diff --git a/arch/x86/crypto/twofish-i586-asm_32.S b/arch/x86/crypto/twofish-i586-asm_32.S
index 658af4b..694ea45 100644
--- a/arch/x86/crypto/twofish-i586-asm_32.S
+++ b/arch/x86/crypto/twofish-i586-asm_32.S
@@ -20,6 +20,7 @@
 .file "twofish-i586-asm.S"
 .text
 
+#include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 
 /* return address at 0 */
@@ -219,11 +220,7 @@
 	xor	%esi,		d ## D;\
 	ror	$1,		d ## D;
 
-.align 4
-.global twofish_enc_blk
-.global twofish_dec_blk
-
-twofish_enc_blk:
+ENTRY(twofish_enc_blk)
 	push	%ebp			/* save registers according to calling convention*/
 	push    %ebx
 	push    %esi
@@ -277,8 +274,9 @@ twofish_enc_blk:
 	pop	%ebp
 	mov	$1,	%eax
 	ret
+ENDPROC(twofish_enc_blk)
 
-twofish_dec_blk:
+ENTRY(twofish_dec_blk)
 	push	%ebp			/* save registers according to calling convention*/
 	push    %ebx
 	push    %esi
@@ -333,3 +331,4 @@ twofish_dec_blk:
 	pop	%ebp
 	mov	$1,	%eax
 	ret
+ENDPROC(twofish_dec_blk)
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
index 5b012a2..1c3b7ce 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -20,6 +20,8 @@
  *
  */
 
+#include <linux/linkage.h>
+
 .file "twofish-x86_64-asm-3way.S"
 .text
 
@@ -214,11 +216,7 @@
 	rorq $32,			RAB2; \
 	outunpack3(mov, RIO, 2, RAB, 2);
 
-.align 8
-.global __twofish_enc_blk_3way
-.type   __twofish_enc_blk_3way,@function;
-
-__twofish_enc_blk_3way:
+ENTRY(__twofish_enc_blk_3way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -250,7 +248,7 @@ __twofish_enc_blk_3way:
 	popq %rbp; /* bool xor */
 
 	testb %bpl, %bpl;
-	jnz __enc_xor3;
+	jnz .L__enc_xor3;
 
 	outunpack_enc3(mov);
 
@@ -262,7 +260,7 @@ __twofish_enc_blk_3way:
 	popq %r15;
 	ret;
 
-__enc_xor3:
+.L__enc_xor3:
 	outunpack_enc3(xor);
 
 	popq %rbx;
@@ -272,11 +270,9 @@ __enc_xor3:
 	popq %r14;
 	popq %r15;
 	ret;
+ENDPROC(__twofish_enc_blk_3way)
 
-.global twofish_dec_blk_3way
-.type   twofish_dec_blk_3way,@function;
-
-twofish_dec_blk_3way:
+ENTRY(twofish_dec_blk_3way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -313,4 +309,4 @@ twofish_dec_blk_3way:
 	popq %r14;
 	popq %r15;
 	ret;
-
+ENDPROC(twofish_dec_blk_3way)
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64.S b/arch/x86/crypto/twofish-x86_64-asm_64.S
index 7bcf3fc..a039d21 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64.S
@@ -20,6 +20,7 @@
 .file "twofish-x86_64-asm.S"
 .text
 
+#include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 
 #define a_offset	0
@@ -214,11 +215,7 @@
 	xor	%r8d,		d ## D;\
 	ror	$1,		d ## D;
 
-.align 8
-.global twofish_enc_blk
-.global twofish_dec_blk
-
-twofish_enc_blk:
+ENTRY(twofish_enc_blk)
 	pushq    R1
 
 	/* %rdi contains the ctx address */
@@ -269,8 +266,9 @@ twofish_enc_blk:
 	popq	R1
 	movq	$1,%rax
 	ret
+ENDPROC(twofish_enc_blk)
 
-twofish_dec_blk:
+ENTRY(twofish_dec_blk)
 	pushq    R1
 
 	/* %rdi contains the ctx address */
@@ -320,3 +318,4 @@ twofish_dec_blk:
 	popq	R1
 	movq	$1,%rax
 	ret
+ENDPROC(twofish_dec_blk)
