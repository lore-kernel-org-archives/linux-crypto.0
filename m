From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 04/12] crypto: camellia-x86_64/aes-ni: use ENTRY()/ENDPROC()
 for assembler functions and localize jump targets
Date: Sat, 19 Jan 2013 13:39:05 +0200
Message-ID: <20130119113905.22319.19576.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:36836 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:09 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/camellia-aesni-avx-asm_64.S |   38 ++++++++-------------
 arch/x86/crypto/camellia-x86_64-asm_64.S    |   50 ++++++++++++---------------
 2 files changed, 36 insertions(+), 52 deletions(-)

diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index 2306d2e..cfc1634 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -15,6 +15,8 @@
  *	http://koti.mbnet.fi/axh/crypto/camellia-BSD-1.2.0-aesni1.tar.xz
  */
 
+#include <linux/linkage.h>
+
 #define CAMELLIA_TABLE_BYTE_LEN 272
 
 /* struct camellia_ctx: */
@@ -190,6 +192,7 @@ roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd:
 		  %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm15,
 		  %rcx, (%r9));
 	ret;
+ENDPROC(roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
 
 .align 8
 roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab:
@@ -197,6 +200,7 @@ roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab:
 		  %xmm12, %xmm13, %xmm14, %xmm15, %xmm8, %xmm9, %xmm10, %xmm11,
 		  %rax, (%r9));
 	ret;
+ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 
 /*
  * IN/OUT:
@@ -709,8 +713,6 @@ roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab:
 .text
 
 .align 8
-.type   __camellia_enc_blk16,@function;
-
 __camellia_enc_blk16:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -793,10 +795,9 @@ __camellia_enc_blk16:
 		     %xmm15, %rax, %rcx, 24);
 
 	jmp .Lenc_done;
+ENDPROC(__camellia_enc_blk16)
 
 .align 8
-.type   __camellia_dec_blk16,@function;
-
 __camellia_dec_blk16:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -877,12 +878,9 @@ __camellia_dec_blk16:
 	      ((key_table + (24) * 8) + 4)(CTX));
 
 	jmp .Ldec_max24;
+ENDPROC(__camellia_dec_blk16)
 
-.align 8
-.global camellia_ecb_enc_16way
-.type   camellia_ecb_enc_16way,@function;
-
-camellia_ecb_enc_16way:
+ENTRY(camellia_ecb_enc_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -903,12 +901,9 @@ camellia_ecb_enc_16way:
 		     %xmm8, %rsi);
 
 	ret;
+ENDPROC(camellia_ecb_enc_16way)
 
-.align 8
-.global camellia_ecb_dec_16way
-.type   camellia_ecb_dec_16way,@function;
-
-camellia_ecb_dec_16way:
+ENTRY(camellia_ecb_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -934,12 +929,9 @@ camellia_ecb_dec_16way:
 		     %xmm8, %rsi);
 
 	ret;
+ENDPROC(camellia_ecb_dec_16way)
 
-.align 8
-.global camellia_cbc_dec_16way
-.type   camellia_cbc_dec_16way,@function;
-
-camellia_cbc_dec_16way:
+ENTRY(camellia_cbc_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -986,6 +978,7 @@ camellia_cbc_dec_16way:
 		     %xmm8, %rsi);
 
 	ret;
+ENDPROC(camellia_cbc_dec_16way)
 
 #define inc_le128(x, minus_one, tmp) \
 	vpcmpeqq minus_one, x, tmp; \
@@ -993,11 +986,7 @@ camellia_cbc_dec_16way:
 	vpslldq $8, tmp, tmp; \
 	vpsubq tmp, x, x;
 
-.align 8
-.global camellia_ctr_16way
-.type   camellia_ctr_16way,@function;
-
-camellia_ctr_16way:
+ENTRY(camellia_ctr_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -1100,3 +1089,4 @@ camellia_ctr_16way:
 		     %xmm8, %rsi);
 
 	ret;
+ENDPROC(camellia_ctr_16way)
diff --git a/arch/x86/crypto/camellia-x86_64-asm_64.S b/arch/x86/crypto/camellia-x86_64-asm_64.S
index 0b33743..310319c 100644
--- a/arch/x86/crypto/camellia-x86_64-asm_64.S
+++ b/arch/x86/crypto/camellia-x86_64-asm_64.S
@@ -20,6 +20,8 @@
  *
  */
 
+#include <linux/linkage.h>
+
 .file "camellia-x86_64-asm_64.S"
 .text
 
@@ -188,10 +190,7 @@
 	bswapq				RAB0; \
 	movq RAB0,			4*2(RIO);
 
-.global __camellia_enc_blk;
-.type   __camellia_enc_blk,@function;
-
-__camellia_enc_blk:
+ENTRY(__camellia_enc_blk)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -214,33 +213,31 @@ __camellia_enc_blk:
 	movl $24, RT1d; /* max */
 
 	cmpb $16, key_length(CTX);
-	je __enc_done;
+	je .L__enc_done;
 
 	enc_fls(24);
 	enc_rounds(24);
 	movl $32, RT1d; /* max */
 
-__enc_done:
+.L__enc_done:
 	testb RXORbl, RXORbl;
 	movq RDST, RIO;
 
-	jnz __enc_xor;
+	jnz .L__enc_xor;
 
 	enc_outunpack(mov, RT1);
 
 	movq RRBP, %rbp;
 	ret;
 
-__enc_xor:
+.L__enc_xor:
 	enc_outunpack(xor, RT1);
 
 	movq RRBP, %rbp;
 	ret;
+ENDPROC(__camellia_enc_blk)
 
-.global camellia_dec_blk;
-.type   camellia_dec_blk,@function;
-
-camellia_dec_blk:
+ENTRY(camellia_dec_blk)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -258,12 +255,12 @@ camellia_dec_blk:
 	dec_inpack(RT2);
 
 	cmpb $24, RT2bl;
-	je __dec_rounds16;
+	je .L__dec_rounds16;
 
 	dec_rounds(24);
 	dec_fls(24);
 
-__dec_rounds16:
+.L__dec_rounds16:
 	dec_rounds(16);
 	dec_fls(16);
 	dec_rounds(8);
@@ -276,6 +273,7 @@ __dec_rounds16:
 
 	movq RRBP, %rbp;
 	ret;
+ENDPROC(camellia_dec_blk)
 
 /**********************************************************************
   2-way camellia
@@ -426,10 +424,7 @@ __dec_rounds16:
 		bswapq				RAB1; \
 		movq RAB1,			12*2(RIO);
 
-.global __camellia_enc_blk_2way;
-.type   __camellia_enc_blk_2way,@function;
-
-__camellia_enc_blk_2way:
+ENTRY(__camellia_enc_blk_2way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -453,16 +448,16 @@ __camellia_enc_blk_2way:
 	movl $24, RT2d; /* max */
 
 	cmpb $16, key_length(CTX);
-	je __enc2_done;
+	je .L__enc2_done;
 
 	enc_fls2(24);
 	enc_rounds2(24);
 	movl $32, RT2d; /* max */
 
-__enc2_done:
+.L__enc2_done:
 	test RXORbl, RXORbl;
 	movq RDST, RIO;
-	jnz __enc2_xor;
+	jnz .L__enc2_xor;
 
 	enc_outunpack2(mov, RT2);
 
@@ -470,17 +465,15 @@ __enc2_done:
 	popq %rbx;
 	ret;
 
-__enc2_xor:
+.L__enc2_xor:
 	enc_outunpack2(xor, RT2);
 
 	movq RRBP, %rbp;
 	popq %rbx;
 	ret;
+ENDPROC(__camellia_enc_blk_2way)
 
-.global camellia_dec_blk_2way;
-.type   camellia_dec_blk_2way,@function;
-
-camellia_dec_blk_2way:
+ENTRY(camellia_dec_blk_2way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -499,12 +492,12 @@ camellia_dec_blk_2way:
 	dec_inpack2(RT2);
 
 	cmpb $24, RT2bl;
-	je __dec2_rounds16;
+	je .L__dec2_rounds16;
 
 	dec_rounds2(24);
 	dec_fls2(24);
 
-__dec2_rounds16:
+.L__dec2_rounds16:
 	dec_rounds2(16);
 	dec_fls2(16);
 	dec_rounds2(8);
@@ -518,3 +511,4 @@ __dec2_rounds16:
 	movq RRBP, %rbp;
 	movq RXOR, %rbx;
 	ret;
+ENDPROC(camellia_dec_blk_2way)
