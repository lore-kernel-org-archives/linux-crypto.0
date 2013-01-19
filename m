From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 06/12] crypto: cast6-avx: use ENTRY()/ENDPROC() for
 assembler functions
Date: Sat, 19 Jan 2013 13:39:16 +0200
Message-ID: <20130119113916.22319.6131.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:36858 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:18 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S |   35 +++++++++--------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 2569d0d..f93b610 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/linkage.h>
 #include "glue_helper-asm-avx.S"
 
 .file "cast6-avx-x86_64-asm_64.S"
@@ -250,8 +251,6 @@
 .text
 
 .align 8
-.type   __cast6_enc_blk8,@function;
-
 __cast6_enc_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -295,10 +294,9 @@ __cast6_enc_blk8:
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
 	ret;
+ENDPROC(__cast6_enc_blk8)
 
 .align 8
-.type   __cast6_dec_blk8,@function;
-
 __cast6_dec_blk8:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -341,12 +339,9 @@ __cast6_dec_blk8:
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
 	ret;
+ENDPROC(__cast6_dec_blk8)
 
-.align 8
-.global cast6_ecb_enc_8way
-.type   cast6_ecb_enc_8way,@function;
-
-cast6_ecb_enc_8way:
+ENTRY(cast6_ecb_enc_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -362,12 +357,9 @@ cast6_ecb_enc_8way:
 	store_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	ret;
+ENDPROC(cast6_ecb_enc_8way)
 
-.align 8
-.global cast6_ecb_dec_8way
-.type   cast6_ecb_dec_8way,@function;
-
-cast6_ecb_dec_8way:
+ENTRY(cast6_ecb_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -383,12 +375,9 @@ cast6_ecb_dec_8way:
 	store_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	ret;
+ENDPROC(cast6_ecb_dec_8way)
 
-.align 8
-.global cast6_cbc_dec_8way
-.type   cast6_cbc_dec_8way,@function;
-
-cast6_cbc_dec_8way:
+ENTRY(cast6_cbc_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -409,12 +398,9 @@ cast6_cbc_dec_8way:
 	popq %r12;
 
 	ret;
+ENDPROC(cast6_cbc_dec_8way)
 
-.align 8
-.global cast6_ctr_8way
-.type   cast6_ctr_8way,@function;
-
-cast6_ctr_8way:
+ENTRY(cast6_ctr_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -437,3 +423,4 @@ cast6_ctr_8way:
 	popq %r12;
 
 	ret;
+ENDPROC(cast6_ctr_8way)
