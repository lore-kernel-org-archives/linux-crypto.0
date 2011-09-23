From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] crypto: blowfish-x86_64: improve x86_64 blowfish 4-way
	performance
Date: Fri, 23 Sep 2011 19:50:55 +0300
Message-ID: <20110923165055.29475.16493.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:57458 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1IWQu5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Sep 2011 12:50:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds improved F-macro for 4-way parallel functions. With new
F-macro for 4-way parallel functions, blowfish sees ~15% improvement in
speed tests on AMD Phenom II (~5% on Intel Xeon E7330).

However when used in 1-way blowfish function new macro would be ~10%
slower than original, so old F-macro is kept for 1-way functions.
Patch cleans up old F-macro as it is no longer needed in 4-way part.

Patch also does register macro renaming to reduce stack usage.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/blowfish-x86_64-asm_64.S |  198 +++++++++++++++---------------
 1 files changed, 98 insertions(+), 100 deletions(-)

diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
index 44eb23a..391d245 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -56,38 +56,32 @@
 
 #define RT0 %rbp
 #define RT1 %rsi
+#define RT2 %r8
+#define RT3 %r9
 
 #define RT0d %ebp
 #define RT1d %esi
+#define RT2d %r8d
+#define RT3d %r9d
 
-#define RK0 %r8
-#define RK1 %r9
-#define RK2 %r10
-#define RK3 %r11
-
-#define RK0d %r8d
-#define RK1d %r9d
-#define RK2d %r10d
-#define RK3d %r11d
-
-#define RKEY %r12
+#define RKEY %r10
 
 /***********************************************************************
  * 1-way blowfish
  ***********************************************************************/
-#define F(x, k) \
-	rorq $16,		x; \
-	movzbl x ## bh,		RT0d; \
-	movzbl x ## bl,		RT1d; \
-	rolq $16,		x; \
-	movl s0(CTX,RT0,4),	k ## d; \
-	addl s1(CTX,RT1,4),	k ## d; \
-	movzbl x ## bh,		RT0d; \
-	movzbl x ## bl,		RT1d; \
-	rolq $32,		x; \
-	xorl s2(CTX,RT0,4),	k ## d; \
-	addl s3(CTX,RT1,4),	k ## d; \
-	xorq k,			x;
+#define F() \
+	rorq $16,		RX0; \
+	movzbl RX0bh,		RT0d; \
+	movzbl RX0bl,		RT1d; \
+	rolq $16,		RX0; \
+	movl s0(CTX,RT0,4),	RT0d; \
+	addl s1(CTX,RT1,4),	RT0d; \
+	movzbl RX0bh,		RT1d; \
+	movzbl RX0bl,		RT2d; \
+	rolq $32,		RX0; \
+	xorl s2(CTX,RT1,4),	RT0d; \
+	addl s3(CTX,RT2,4),	RT0d; \
+	xorq RT0,		RX0;
 
 #define add_roundkey_enc(n) \
 	xorq p+4*(n)(CTX), 	RX0;
@@ -95,11 +89,8 @@
 #define round_enc(n) \
 	add_roundkey_enc(n); \
 	\
-	F(RX0, RK0); \
-	F(RX0, RK0);
-
-#define round_final_enc(n) \
-	xorq p+4*(n)(CTX), 	RX0;
+	F(); \
+	F();
 
 #define add_roundkey_dec(n) \
 	movq p+4*(n-1)(CTX),	RT0; \
@@ -109,8 +100,8 @@
 #define round_dec(n) \
 	add_roundkey_dec(n); \
 	\
-	F(RX0, RK0); \
-	F(RX0, RK0); \
+	F(); \
+	F(); \
 
 #define read_block() \
 	movq (RIO), 		RX0; \
@@ -130,16 +121,15 @@
 .type   __blowfish_enc_blk,@function;
 
 __blowfish_enc_blk:
-	// input:
-	//	%rdi: ctx, CTX
-	//	%rsi: dst
-	//	%rdx: src
-	//	%rcx: bool xor
-	pushq %rbp;
-	pushq %rbx;
-
-	pushq %rsi;
-	pushq %rcx;
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: bool, if true: xor output
+	 */
+	movq %rbp, %r11;
+
+	movq %rsi, %r10;
 	movq %rdx, RIO;
 
 	read_block();
@@ -154,38 +144,31 @@ __blowfish_enc_blk:
 	round_enc(14);
 	add_roundkey_enc(16);
 
-	popq %rbp;
-	popq RIO;
+	movq %r11, %rbp;
 
-	test %bpl, %bpl;
+	movq %r10, RIO;
+	test %cl, %cl;
 	jnz __enc_xor;
 
 	write_block();
-
-__enc_ret:
-	popq %rbx;
-	popq %rbp;
-
 	ret;
-
 __enc_xor:
 	xor_block();
-
-	jmp __enc_ret;
+	ret;
 
 .align 8
 .global blowfish_dec_blk
 .type   blowfish_dec_blk,@function;
 
 blowfish_dec_blk:
-	// input:
-	//	%rdi: ctx, CTX
-	//	%rsi: dst
-	//	%rdx: src
-	pushq %rbp;
-	pushq %rbx;
-
-	pushq %rsi;
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+	movq %rbp, %r11;
+
+	movq %rsi, %r10;
 	movq %rdx, RIO;
 
 	read_block();
@@ -200,17 +183,33 @@ blowfish_dec_blk:
 	round_dec(3);
 	add_roundkey_dec(1);
 
-	popq RIO;
+	movq %r10, RIO;
 	write_block();
 
-	popq %rbx;
-	popq %rbp;
+	movq %r11, %rbp;
 
 	ret;
 
 /**********************************************************************
   4-way blowfish, four blocks parallel
  **********************************************************************/
+
+/* F() for 4-way. Slower when used alone/1-way, but faster when used
+ * parallel/4-way (tested on AMD Phenom II & Intel Xeon E7330).
+ */
+#define F4(x) \
+	movzbl x ## bh,		RT1d; \
+	movzbl x ## bl,		RT3d; \
+	rorq $16,		x; \
+	movzbl x ## bh,		RT0d; \
+	movzbl x ## bl,		RT2d; \
+	rorq $16,		x; \
+	movl s0(CTX,RT0,4),	RT0d; \
+	addl s1(CTX,RT2,4),	RT0d; \
+	xorl s2(CTX,RT1,4),	RT0d; \
+	addl s3(CTX,RT3,4),	RT0d; \
+	xorq RT0,		x;
+
 #define add_preloaded_roundkey4() \
 	xorq RKEY,		RX0; \
 	xorq RKEY,		RX1; \
@@ -227,15 +226,15 @@ blowfish_dec_blk:
 #define round_enc4(n) \
 	add_roundkey_enc4(n); \
 	\
-	F(RX0, RK0); \
-	F(RX1, RK1); \
-	F(RX2, RK2); \
-	F(RX3, RK3); \
+	F4(RX0); \
+	F4(RX1); \
+	F4(RX2); \
+	F4(RX3); \
 	\
-	F(RX0, RK0); \
-	F(RX1, RK1); \
-	F(RX2, RK2); \
-	F(RX3, RK3);
+	F4(RX0); \
+	F4(RX1); \
+	F4(RX2); \
+	F4(RX3);
 
 #define preload_roundkey_dec(n) \
 	movq p+4*((n)-1)(CTX),	RKEY; \
@@ -248,15 +247,15 @@ blowfish_dec_blk:
 #define round_dec4(n) \
 	add_roundkey_dec4(n); \
 	\
-	F(RX0, RK0); \
-	F(RX1, RK1); \
-	F(RX2, RK2); \
-	F(RX3, RK3); \
+	F4(RX0); \
+	F4(RX1); \
+	F4(RX2); \
+	F4(RX3); \
 	\
-	F(RX0, RK0); \
-	F(RX1, RK1); \
-	F(RX2, RK2); \
-	F(RX3, RK3);
+	F4(RX0); \
+	F4(RX1); \
+	F4(RX2); \
+	F4(RX3);
 
 #define read_block4() \
 	movq (RIO),		RX0; \
@@ -306,18 +305,19 @@ blowfish_dec_blk:
 .type   __blowfish_enc_blk_4way,@function;
 
 __blowfish_enc_blk_4way:
-	// input:
-	//	%rdi: ctx, CTX
-	//	%rsi: dst
-	//	%rdx: src
-	//	%rcx: bool xor
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: bool, if true: xor output
+	 */
 	pushq %rbp;
 	pushq %rbx;
-	pushq RKEY;
+	pushq %rcx;
+
 	preload_roundkey_enc(0);
 
-	pushq %rsi;
-	pushq %rcx;
+	movq %rsi, %r11;
 	movq %rdx, RIO;
 
 	read_block4();
@@ -333,40 +333,39 @@ __blowfish_enc_blk_4way:
 	add_preloaded_roundkey4();
 
 	popq %rbp;
-	popq RIO;
+	movq %r11, RIO;
 
 	test %bpl, %bpl;
 	jnz __enc_xor4;
 
 	write_block4();
 
-__enc_ret4:
-	popq RKEY;
 	popq %rbx;
 	popq %rbp;
-
 	ret;
 
 __enc_xor4:
 	xor_block4();
 
-	jmp __enc_ret4;
+	popq %rbx;
+	popq %rbp;
+	ret;
 
 .align 8
 .global blowfish_dec_blk_4way
 .type   blowfish_dec_blk_4way,@function;
 
 blowfish_dec_blk_4way:
-	// input:
-	//	%rdi: ctx, CTX
-	//	%rsi: dst
-	//	%rdx: src
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
 	pushq %rbp;
 	pushq %rbx;
-	pushq RKEY;
 	preload_roundkey_dec(17);
 
-	pushq %rsi;
+	movq %rsi, %r11;
 	movq %rdx, RIO;
 
 	read_block4();
@@ -381,10 +380,9 @@ blowfish_dec_blk_4way:
 	round_dec4(3);
 	add_preloaded_roundkey4();
 
-	popq RIO;
+	movq %r11, RIO;
 	write_block4();
 
-	popq RKEY;
 	popq %rbx;
 	popq %rbp;
 
