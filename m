From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 05/12] crypto: cast5-avx: use ENTRY()/ENDPROC() for
 assembler functions and localize jump targets
Date: Sat, 19 Jan 2013 13:39:11 +0200
Message-ID: <20130119113910.22319.56361.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58284 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:14 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S |   48 +++++++++++------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index 15b00ac..c35fd5d 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -23,6 +23,8 @@
  *
  */
 
+#include <linux/linkage.h>
+
 .file "cast5-avx-x86_64-asm_64.S"
 
 .extern cast_s1
@@ -211,8 +213,6 @@
 .text
 
 .align 16
-.type   __cast5_enc_blk16,@function;
-
 __cast5_enc_blk16:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -263,14 +263,14 @@ __cast5_enc_blk16:
 
 	movzbl rr(CTX), %eax;
 	testl %eax, %eax;
-	jnz __skip_enc;
+	jnz .L__skip_enc;
 
 	round(RL, RR, 12, 1);
 	round(RR, RL, 13, 2);
 	round(RL, RR, 14, 3);
 	round(RR, RL, 15, 1);
 
-__skip_enc:
+.L__skip_enc:
 	popq %rbx;
 	popq %rbp;
 
@@ -282,10 +282,9 @@ __skip_enc:
 	outunpack_blocks(RR4, RL4, RTMP, RX, RKM);
 
 	ret;
+ENDPROC(__cast5_enc_blk16)
 
 .align 16
-.type   __cast5_dec_blk16,@function;
-
 __cast5_dec_blk16:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -323,14 +322,14 @@ __cast5_dec_blk16:
 
 	movzbl rr(CTX), %eax;
 	testl %eax, %eax;
-	jnz __skip_dec;
+	jnz .L__skip_dec;
 
 	round(RL, RR, 15, 1);
 	round(RR, RL, 14, 3);
 	round(RL, RR, 13, 2);
 	round(RR, RL, 12, 1);
 
-__dec_tail:
+.L__dec_tail:
 	round(RL, RR, 11, 3);
 	round(RR, RL, 10, 2);
 	round(RL, RR, 9, 1);
@@ -355,15 +354,12 @@ __dec_tail:
 
 	ret;
 
-__skip_dec:
+.L__skip_dec:
 	vpsrldq $4, RKR, RKR;
-	jmp __dec_tail;
+	jmp .L__dec_tail;
+ENDPROC(__cast5_dec_blk16)
 
-.align 16
-.global cast5_ecb_enc_16way
-.type   cast5_ecb_enc_16way,@function;
-
-cast5_ecb_enc_16way:
+ENTRY(cast5_ecb_enc_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -393,12 +389,9 @@ cast5_ecb_enc_16way:
 	vmovdqu RL4, (7*4*4)(%r11);
 
 	ret;
+ENDPROC(cast5_ecb_enc_16way)
 
-.align 16
-.global cast5_ecb_dec_16way
-.type   cast5_ecb_dec_16way,@function;
-
-cast5_ecb_dec_16way:
+ENTRY(cast5_ecb_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -428,12 +421,9 @@ cast5_ecb_dec_16way:
 	vmovdqu RL4, (7*4*4)(%r11);
 
 	ret;
+ENDPROC(cast5_ecb_dec_16way)
 
-.align 16
-.global cast5_cbc_dec_16way
-.type   cast5_cbc_dec_16way,@function;
-
-cast5_cbc_dec_16way:
+ENTRY(cast5_cbc_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -480,12 +470,9 @@ cast5_cbc_dec_16way:
 	popq %r12;
 
 	ret;
+ENDPROC(cast5_cbc_dec_16way)
 
-.align 16
-.global cast5_ctr_16way
-.type   cast5_ctr_16way,@function;
-
-cast5_ctr_16way:
+ENTRY(cast5_ctr_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -556,3 +543,4 @@ cast5_ctr_16way:
 	popq %r12;
 
 	ret;
+ENDPROC(cast5_ctr_16way)
