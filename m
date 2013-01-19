From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 03/12] crypto: blowfish-x86_64: use ENTRY()/ENDPROC() for
 assembler functions and localize jump targets
Date: Sat, 19 Jan 2013 13:39:00 +0200
Message-ID: <20130119113900.22319.61254.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58246 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:03 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/blowfish-x86_64-asm_64.S |   39 +++++++++++-------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
index 391d245..246c670 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -20,6 +20,8 @@
  *
  */
 
+#include <linux/linkage.h>
+
 .file "blowfish-x86_64-asm.S"
 .text
 
@@ -116,11 +118,7 @@
 	bswapq 			RX0; \
 	xorq RX0, 		(RIO);
 
-.align 8
-.global __blowfish_enc_blk
-.type   __blowfish_enc_blk,@function;
-
-__blowfish_enc_blk:
+ENTRY(__blowfish_enc_blk)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -148,19 +146,16 @@ __blowfish_enc_blk:
 
 	movq %r10, RIO;
 	test %cl, %cl;
-	jnz __enc_xor;
+	jnz .L__enc_xor;
 
 	write_block();
 	ret;
-__enc_xor:
+.L__enc_xor:
 	xor_block();
 	ret;
+ENDPROC(__blowfish_enc_blk)
 
-.align 8
-.global blowfish_dec_blk
-.type   blowfish_dec_blk,@function;
-
-blowfish_dec_blk:
+ENTRY(blowfish_dec_blk)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -189,6 +184,7 @@ blowfish_dec_blk:
 	movq %r11, %rbp;
 
 	ret;
+ENDPROC(blowfish_dec_blk)
 
 /**********************************************************************
   4-way blowfish, four blocks parallel
@@ -300,11 +296,7 @@ blowfish_dec_blk:
 	bswapq 			RX3; \
 	xorq RX3,		24(RIO);
 
-.align 8
-.global __blowfish_enc_blk_4way
-.type   __blowfish_enc_blk_4way,@function;
-
-__blowfish_enc_blk_4way:
+ENTRY(__blowfish_enc_blk_4way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -336,7 +328,7 @@ __blowfish_enc_blk_4way:
 	movq %r11, RIO;
 
 	test %bpl, %bpl;
-	jnz __enc_xor4;
+	jnz .L__enc_xor4;
 
 	write_block4();
 
@@ -344,18 +336,15 @@ __blowfish_enc_blk_4way:
 	popq %rbp;
 	ret;
 
-__enc_xor4:
+.L__enc_xor4:
 	xor_block4();
 
 	popq %rbx;
 	popq %rbp;
 	ret;
+ENDPROC(__blowfish_enc_blk_4way)
 
-.align 8
-.global blowfish_dec_blk_4way
-.type   blowfish_dec_blk_4way,@function;
-
-blowfish_dec_blk_4way:
+ENTRY(blowfish_dec_blk_4way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -387,4 +376,4 @@ blowfish_dec_blk_4way:
 	popq %rbp;
 
 	ret;
-
+ENDPROC(blowfish_dec_blk_4way)
