From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: x86/aes - Don't use %rbp as temporary register
Date: Tue, 16 May 2017 21:03:08 -0700
Message-ID: <20170517040308.406-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35883 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbdEQEHU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 00:07:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

When using the "aes-asm" implementation of AES (*not* the AES-NI
implementation) on an x86_64, v4.12-rc1 kernel with lockdep enabled, the
following warning was reported, along with a long unwinder dump:

	WARNING: kernel stack regs at ffffc90000643558 in kworker/u4:2:155 has bad 'bp' value 000000000000001c

The problem is that aes_enc_block() and aes_dec_block() use %rbp as a
temporary register, which breaks stack traces if an interrupt occurs.

Fix this by replacing %rbp with %r9, which was being used to hold the
saved value of %rbp.  This required rearranging the AES round macro
slightly since %r9d cannot be used as the target of a move from %ah-%dh.

Performance is essentially unchanged --- actually about 0.2% faster than
before.  Interestingly, I also measured aes-generic as being nearly 7%
faster than aes-asm, so perhaps aes-asm has outlived its usefulness...

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-x86_64-asm_64.S | 47 +++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/aes-x86_64-asm_64.S b/arch/x86/crypto/aes-x86_64-asm_64.S
index 910565547163..8739cf7795de 100644
--- a/arch/x86/crypto/aes-x86_64-asm_64.S
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -42,17 +42,15 @@
 #define R5E	%esi
 #define R6	%rdi
 #define R6E	%edi
-#define R7	%rbp
-#define R7E	%ebp
+#define R7	%r9	/* don't use %rbp; it breaks stack traces */
+#define R7E	%r9d
 #define R8	%r8
-#define R9	%r9
 #define R10	%r10
 #define R11	%r11
 
-#define prologue(FUNC,KEY,B128,B192,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11) \
+#define prologue(FUNC,KEY,B128,B192,r1,r2,r5,r6,r7,r8,r9,r10,r11) \
 	ENTRY(FUNC);			\
 	movq	r1,r2;			\
-	movq	r3,r4;			\
 	leaq	KEY+48(r8),r9;		\
 	movq	r10,r11;		\
 	movl	(r7),r5 ## E;		\
@@ -70,9 +68,8 @@
 	je	B192;			\
 	leaq	32(r9),r9;
 
-#define epilogue(FUNC,r1,r2,r3,r4,r5,r6,r7,r8,r9) \
+#define epilogue(FUNC,r1,r2,r5,r6,r7,r8,r9) \
 	movq	r1,r2;			\
-	movq	r3,r4;			\
 	movl	r5 ## E,(r9);		\
 	movl	r6 ## E,4(r9);		\
 	movl	r7 ## E,8(r9);		\
@@ -88,12 +85,12 @@
 	movl	TAB(,r6,4),r6 ## E;	\
 	roll	$16,r2 ## E;		\
 	shrl	$16,r4 ## E;		\
-	movzbl	r4 ## H,r7 ## E;	\
-	movzbl	r4 ## L,r4 ## E;	\
+	movzbl	r4 ## L,r7 ## E;	\
+	movzbl	r4 ## H,r4 ## E;	\
 	xorl	OFFSET(r8),ra ## E;	\
 	xorl	OFFSET+4(r8),rb ## E;	\
-	xorl	TAB+3072(,r7,4),r5 ## E;\
-	xorl	TAB+2048(,r4,4),r6 ## E;\
+	xorl	TAB+3072(,r4,4),r5 ## E;\
+	xorl	TAB+2048(,r7,4),r6 ## E;\
 	movzbl	r1 ## L,r7 ## E;	\
 	movzbl	r1 ## H,r4 ## E;	\
 	movl	TAB+1024(,r4,4),r4 ## E;\
@@ -101,19 +98,19 @@
 	roll	$16,r1 ## E;		\
 	shrl	$16,r3 ## E;		\
 	xorl	TAB(,r7,4),r5 ## E;	\
-	movzbl	r3 ## H,r7 ## E;	\
-	movzbl	r3 ## L,r3 ## E;	\
-	xorl	TAB+3072(,r7,4),r4 ## E;\
-	xorl	TAB+2048(,r3,4),r5 ## E;\
-	movzbl	r1 ## H,r7 ## E;	\
-	movzbl	r1 ## L,r3 ## E;	\
+	movzbl	r3 ## L,r7 ## E;	\
+	movzbl	r3 ## H,r3 ## E;	\
+	xorl	TAB+3072(,r3,4),r4 ## E;\
+	xorl	TAB+2048(,r7,4),r5 ## E;\
+	movzbl	r1 ## L,r7 ## E;	\
+	movzbl	r1 ## H,r3 ## E;	\
 	shrl	$16,r1 ## E;		\
-	xorl	TAB+3072(,r7,4),r6 ## E;\
-	movl	TAB+2048(,r3,4),r3 ## E;\
-	movzbl	r1 ## H,r7 ## E;	\
-	movzbl	r1 ## L,r1 ## E;	\
-	xorl	TAB+1024(,r7,4),r6 ## E;\
-	xorl	TAB(,r1,4),r3 ## E;	\
+	xorl	TAB+3072(,r3,4),r6 ## E;\
+	movl	TAB+2048(,r7,4),r3 ## E;\
+	movzbl	r1 ## L,r7 ## E;	\
+	movzbl	r1 ## H,r1 ## E;	\
+	xorl	TAB+1024(,r1,4),r6 ## E;\
+	xorl	TAB(,r7,4),r3 ## E;	\
 	movzbl	r2 ## H,r1 ## E;	\
 	movzbl	r2 ## L,r7 ## E;	\
 	shrl	$16,r2 ## E;		\
@@ -131,9 +128,9 @@
 	movl	r4 ## E,r2 ## E;
 
 #define entry(FUNC,KEY,B128,B192) \
-	prologue(FUNC,KEY,B128,B192,R2,R8,R7,R9,R1,R3,R4,R6,R10,R5,R11)
+	prologue(FUNC,KEY,B128,B192,R2,R8,R1,R3,R4,R6,R10,R5,R11)
 
-#define return(FUNC) epilogue(FUNC,R8,R2,R9,R7,R5,R6,R3,R4,R11)
+#define return(FUNC) epilogue(FUNC,R8,R2,R5,R6,R3,R4,R11)
 
 #define encrypt_round(TAB,OFFSET) \
 	round(TAB,OFFSET,R1,R2,R3,R4,R5,R6,R7,R10,R5,R6,R3,R4) \
-- 
2.13.0
