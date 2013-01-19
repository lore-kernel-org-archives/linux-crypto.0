From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 10/12] crypto: x86/serpent - use ENTRY/ENDPROC for assember
 functions and localize jump targets
Date: Sat, 19 Jan 2013 13:39:36 +0200
Message-ID: <20130119113936.22319.5134.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:36935 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:40 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S  |   35 ++++++++------------------
 arch/x86/crypto/serpent-sse2-i586-asm_32.S   |   20 ++++++---------
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |   20 ++++++---------
 3 files changed, 27 insertions(+), 48 deletions(-)

diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index 02b0e9f..43c9386 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -24,6 +24,7 @@
  *
  */
 
+#include <linux/linkage.h>
 #include "glue_helper-asm-avx.S"
 
 .file "serpent-avx-x86_64-asm_64.S"
@@ -566,8 +567,6 @@
 	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
 
 .align 8
-.type   __serpent_enc_blk8_avx,@function;
-
 __serpent_enc_blk8_avx:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -619,10 +618,9 @@ __serpent_enc_blk8_avx:
 	write_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 	ret;
+ENDPROC(__serpent_enc_blk8_avx)
 
 .align 8
-.type   __serpent_dec_blk8_avx,@function;
-
 __serpent_dec_blk8_avx:
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -674,12 +672,9 @@ __serpent_dec_blk8_avx:
 	write_blocks(RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
 	ret;
+ENDPROC(__serpent_dec_blk8_avx)
 
-.align 8
-.global serpent_ecb_enc_8way_avx
-.type   serpent_ecb_enc_8way_avx,@function;
-
-serpent_ecb_enc_8way_avx:
+ENTRY(serpent_ecb_enc_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -693,12 +688,9 @@ serpent_ecb_enc_8way_avx:
 	store_8way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	ret;
+ENDPROC(serpent_ecb_enc_8way_avx)
 
-.align 8
-.global serpent_ecb_dec_8way_avx
-.type   serpent_ecb_dec_8way_avx,@function;
-
-serpent_ecb_dec_8way_avx:
+ENTRY(serpent_ecb_dec_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -712,12 +704,9 @@ serpent_ecb_dec_8way_avx:
 	store_8way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
 
 	ret;
+ENDPROC(serpent_ecb_dec_8way_avx)
 
-.align 8
-.global serpent_cbc_dec_8way_avx
-.type   serpent_cbc_dec_8way_avx,@function;
-
-serpent_cbc_dec_8way_avx:
+ENTRY(serpent_cbc_dec_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -731,12 +720,9 @@ serpent_cbc_dec_8way_avx:
 	store_cbc_8way(%rdx, %rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
 
 	ret;
+ENDPROC(serpent_cbc_dec_8way_avx)
 
-.align 8
-.global serpent_ctr_8way_avx
-.type   serpent_ctr_8way_avx,@function;
-
-serpent_ctr_8way_avx:
+ENTRY(serpent_ctr_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -752,3 +738,4 @@ serpent_ctr_8way_avx:
 	store_ctr_8way(%rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	ret;
+ENDPROC(serpent_ctr_8way_avx)
diff --git a/arch/x86/crypto/serpent-sse2-i586-asm_32.S b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
index c00053d..d348f15 100644
--- a/arch/x86/crypto/serpent-sse2-i586-asm_32.S
+++ b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
@@ -24,6 +24,8 @@
  *
  */
 
+#include <linux/linkage.h>
+
 .file "serpent-sse2-i586-asm_32.S"
 .text
 
@@ -510,11 +512,7 @@
 	pxor t0,		x3; \
 	movdqu x3,		(3*4*4)(out);
 
-.align 8
-.global __serpent_enc_blk_4way
-.type   __serpent_enc_blk_4way,@function;
-
-__serpent_enc_blk_4way:
+ENTRY(__serpent_enc_blk_4way)
 	/* input:
 	 *	arg_ctx(%esp): ctx, CTX
 	 *	arg_dst(%esp): dst
@@ -566,22 +564,19 @@ __serpent_enc_blk_4way:
 	movl arg_dst(%esp), %eax;
 
 	cmpb $0, arg_xor(%esp);
-	jnz __enc_xor4;
+	jnz .L__enc_xor4;
 
 	write_blocks(%eax, RA, RB, RC, RD, RT0, RT1, RE);
 
 	ret;
 
-__enc_xor4:
+.L__enc_xor4:
 	xor_blocks(%eax, RA, RB, RC, RD, RT0, RT1, RE);
 
 	ret;
+ENDPROC(__serpent_enc_blk_4way)
 
-.align 8
-.global serpent_dec_blk_4way
-.type   serpent_dec_blk_4way,@function;
-
-serpent_dec_blk_4way:
+ENTRY(serpent_dec_blk_4way)
 	/* input:
 	 *	arg_ctx(%esp): ctx, CTX
 	 *	arg_dst(%esp): dst
@@ -633,3 +628,4 @@ serpent_dec_blk_4way:
 	write_blocks(%eax, RC, RD, RB, RE, RT0, RT1, RA);
 
 	ret;
+ENDPROC(serpent_dec_blk_4way)
diff --git a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
index 3ee1ff0..acc066c 100644
--- a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
@@ -24,6 +24,8 @@
  *
  */
 
+#include <linux/linkage.h>
+
 .file "serpent-sse2-x86_64-asm_64.S"
 .text
 
@@ -632,11 +634,7 @@
 	pxor t0,		x3; \
 	movdqu x3,		(3*4*4)(out);
 
-.align 8
-.global __serpent_enc_blk_8way
-.type   __serpent_enc_blk_8way,@function;
-
-__serpent_enc_blk_8way:
+ENTRY(__serpent_enc_blk_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -687,24 +685,21 @@ __serpent_enc_blk_8way:
 	leaq (4*4*4)(%rsi), %rax;
 
 	testb %cl, %cl;
-	jnz __enc_xor8;
+	jnz .L__enc_xor8;
 
 	write_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
 	write_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 	ret;
 
-__enc_xor8:
+.L__enc_xor8:
 	xor_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
 	xor_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 	ret;
+ENDPROC(__serpent_enc_blk_8way)
 
-.align 8
-.global serpent_dec_blk_8way
-.type   serpent_dec_blk_8way,@function;
-
-serpent_dec_blk_8way:
+ENTRY(serpent_dec_blk_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -756,3 +751,4 @@ serpent_dec_blk_8way:
 	write_blocks(%rax, RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
 	ret;
+ENDPROC(serpent_dec_blk_8way)
