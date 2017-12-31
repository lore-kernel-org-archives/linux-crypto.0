From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/3] crypto: x86/salsa20 - cleanup and convert to skcipher API
Date: Sun, 31 Dec 2017 17:46:42 -0600
Message-ID: <20171231234642.22621-4-ebiggers3@gmail.com>
References: <20171231234642.22621-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:45499 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdLaXwH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Dec 2017 18:52:07 -0500
Received: by mail-it0-f68.google.com with SMTP id z6so35631255iti.4
        for <linux-crypto@vger.kernel.org>; Sun, 31 Dec 2017 15:52:07 -0800 (PST)
In-Reply-To: <20171231234642.22621-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Convert salsa20-asm from the deprecated "blkcipher" API to the
"skcipher" API, in the process fixing it up to use the generic helpers.
This allows removing the salsa20_keysetup() and salsa20_ivsetup()
assembly functions, which aren't performance critical; the C versions do
just fine.

This also fixes the same bug that salsa20-generic had, where the state
array was being maintained directly in the transform context rather than
on the stack or in the request context.  Thus, if multiple threads used
the same Salsa20 transform concurrently they produced the wrong results.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/salsa20-i586-asm_32.S   | 184 +-------------------------------
 arch/x86/crypto/salsa20-x86_64-asm_64.S | 114 --------------------
 arch/x86/crypto/salsa20_glue.c          | 105 +++++++-----------
 crypto/Kconfig                          |   2 +
 4 files changed, 46 insertions(+), 359 deletions(-)

diff --git a/arch/x86/crypto/salsa20-i586-asm_32.S b/arch/x86/crypto/salsa20-i586-asm_32.S
index 329452b8f794..6014b7b9e52a 100644
--- a/arch/x86/crypto/salsa20-i586-asm_32.S
+++ b/arch/x86/crypto/salsa20-i586-asm_32.S
@@ -1,6 +1,7 @@
-# salsa20_pm.s version 20051229
-# D. J. Bernstein
-# Public domain.
+# Derived from:
+#	salsa20_pm.s version 20051229
+#	D. J. Bernstein
+#	Public domain.
 
 #include <linux/linkage.h>
 
@@ -935,180 +936,3 @@ ENTRY(salsa20_encrypt_bytes)
 	# goto bytesatleast1
 	jmp	._bytesatleast1
 ENDPROC(salsa20_encrypt_bytes)
-
-# enter salsa20_keysetup
-ENTRY(salsa20_keysetup)
-	mov	%esp,%eax
-	and	$31,%eax
-	add	$256,%eax
-	sub	%eax,%esp
-	#   eax_stack = eax
-	movl	%eax,64(%esp)
-	#   ebx_stack = ebx
-	movl	%ebx,68(%esp)
-	#   esi_stack = esi
-	movl	%esi,72(%esp)
-	#   edi_stack = edi
-	movl	%edi,76(%esp)
-	#   ebp_stack = ebp
-	movl	%ebp,80(%esp)
-	#   k = arg2
-	movl	8(%esp,%eax),%ecx
-	#   kbits = arg3
-	movl	12(%esp,%eax),%edx
-	#   x = arg1
-	movl	4(%esp,%eax),%eax
-	#   in1 = *(uint32 *) (k + 0)
-	movl	0(%ecx),%ebx
-	#   in2 = *(uint32 *) (k + 4)
-	movl	4(%ecx),%esi
-	#   in3 = *(uint32 *) (k + 8)
-	movl	8(%ecx),%edi
-	#   in4 = *(uint32 *) (k + 12)
-	movl	12(%ecx),%ebp
-	#   *(uint32 *) (x + 4) = in1
-	movl	%ebx,4(%eax)
-	#   *(uint32 *) (x + 8) = in2
-	movl	%esi,8(%eax)
-	#   *(uint32 *) (x + 12) = in3
-	movl	%edi,12(%eax)
-	#   *(uint32 *) (x + 16) = in4
-	movl	%ebp,16(%eax)
-	#   kbits - 256
-	cmp	$256,%edx
-	#   goto kbits128 if unsigned<
-	jb	._kbits128
-._kbits256:
-	#     in11 = *(uint32 *) (k + 16)
-	movl	16(%ecx),%edx
-	#     in12 = *(uint32 *) (k + 20)
-	movl	20(%ecx),%ebx
-	#     in13 = *(uint32 *) (k + 24)
-	movl	24(%ecx),%esi
-	#     in14 = *(uint32 *) (k + 28)
-	movl	28(%ecx),%ecx
-	#     *(uint32 *) (x + 44) = in11
-	movl	%edx,44(%eax)
-	#     *(uint32 *) (x + 48) = in12
-	movl	%ebx,48(%eax)
-	#     *(uint32 *) (x + 52) = in13
-	movl	%esi,52(%eax)
-	#     *(uint32 *) (x + 56) = in14
-	movl	%ecx,56(%eax)
-	#     in0 = 1634760805
-	mov	$1634760805,%ecx
-	#     in5 = 857760878
-	mov	$857760878,%edx
-	#     in10 = 2036477234
-	mov	$2036477234,%ebx
-	#     in15 = 1797285236
-	mov	$1797285236,%esi
-	#     *(uint32 *) (x + 0) = in0
-	movl	%ecx,0(%eax)
-	#     *(uint32 *) (x + 20) = in5
-	movl	%edx,20(%eax)
-	#     *(uint32 *) (x + 40) = in10
-	movl	%ebx,40(%eax)
-	#     *(uint32 *) (x + 60) = in15
-	movl	%esi,60(%eax)
-	#   goto keysetupdone
-	jmp	._keysetupdone
-._kbits128:
-	#     in11 = *(uint32 *) (k + 0)
-	movl	0(%ecx),%edx
-	#     in12 = *(uint32 *) (k + 4)
-	movl	4(%ecx),%ebx
-	#     in13 = *(uint32 *) (k + 8)
-	movl	8(%ecx),%esi
-	#     in14 = *(uint32 *) (k + 12)
-	movl	12(%ecx),%ecx
-	#     *(uint32 *) (x + 44) = in11
-	movl	%edx,44(%eax)
-	#     *(uint32 *) (x + 48) = in12
-	movl	%ebx,48(%eax)
-	#     *(uint32 *) (x + 52) = in13
-	movl	%esi,52(%eax)
-	#     *(uint32 *) (x + 56) = in14
-	movl	%ecx,56(%eax)
-	#     in0 = 1634760805
-	mov	$1634760805,%ecx
-	#     in5 = 824206446
-	mov	$824206446,%edx
-	#     in10 = 2036477238
-	mov	$2036477238,%ebx
-	#     in15 = 1797285236
-	mov	$1797285236,%esi
-	#     *(uint32 *) (x + 0) = in0
-	movl	%ecx,0(%eax)
-	#     *(uint32 *) (x + 20) = in5
-	movl	%edx,20(%eax)
-	#     *(uint32 *) (x + 40) = in10
-	movl	%ebx,40(%eax)
-	#     *(uint32 *) (x + 60) = in15
-	movl	%esi,60(%eax)
-._keysetupdone:
-	#   eax = eax_stack
-	movl	64(%esp),%eax
-	#   ebx = ebx_stack
-	movl	68(%esp),%ebx
-	#   esi = esi_stack
-	movl	72(%esp),%esi
-	#   edi = edi_stack
-	movl	76(%esp),%edi
-	#   ebp = ebp_stack
-	movl	80(%esp),%ebp
-	# leave
-	add	%eax,%esp
-	ret
-ENDPROC(salsa20_keysetup)
-
-# enter salsa20_ivsetup
-ENTRY(salsa20_ivsetup)
-	mov	%esp,%eax
-	and	$31,%eax
-	add	$256,%eax
-	sub	%eax,%esp
-	#   eax_stack = eax
-	movl	%eax,64(%esp)
-	#   ebx_stack = ebx
-	movl	%ebx,68(%esp)
-	#   esi_stack = esi
-	movl	%esi,72(%esp)
-	#   edi_stack = edi
-	movl	%edi,76(%esp)
-	#   ebp_stack = ebp
-	movl	%ebp,80(%esp)
-	#   iv = arg2
-	movl	8(%esp,%eax),%ecx
-	#   x = arg1
-	movl	4(%esp,%eax),%eax
-	#   in6 = *(uint32 *) (iv + 0)
-	movl	0(%ecx),%edx
-	#   in7 = *(uint32 *) (iv + 4)
-	movl	4(%ecx),%ecx
-	#   in8 = 0
-	mov	$0,%ebx
-	#   in9 = 0
-	mov	$0,%esi
-	#   *(uint32 *) (x + 24) = in6
-	movl	%edx,24(%eax)
-	#   *(uint32 *) (x + 28) = in7
-	movl	%ecx,28(%eax)
-	#   *(uint32 *) (x + 32) = in8
-	movl	%ebx,32(%eax)
-	#   *(uint32 *) (x + 36) = in9
-	movl	%esi,36(%eax)
-	#   eax = eax_stack
-	movl	64(%esp),%eax
-	#   ebx = ebx_stack
-	movl	68(%esp),%ebx
-	#   esi = esi_stack
-	movl	72(%esp),%esi
-	#   edi = edi_stack
-	movl	76(%esp),%edi
-	#   ebp = ebp_stack
-	movl	80(%esp),%ebp
-	# leave
-	add	%eax,%esp
-	ret
-ENDPROC(salsa20_ivsetup)
diff --git a/arch/x86/crypto/salsa20-x86_64-asm_64.S b/arch/x86/crypto/salsa20-x86_64-asm_64.S
index 10db30d58006..03a4918f41ee 100644
--- a/arch/x86/crypto/salsa20-x86_64-asm_64.S
+++ b/arch/x86/crypto/salsa20-x86_64-asm_64.S
@@ -803,117 +803,3 @@ ENTRY(salsa20_encrypt_bytes)
 	# goto bytesatleast1
 	jmp	._bytesatleast1
 ENDPROC(salsa20_encrypt_bytes)
-
-# enter salsa20_keysetup
-ENTRY(salsa20_keysetup)
-	mov	%rsp,%r11
-	and	$31,%r11
-	add	$256,%r11
-	sub	%r11,%rsp
-	#   k = arg2
-	mov	%rsi,%rsi
-	#   kbits = arg3
-	mov	%rdx,%rdx
-	#   x = arg1
-	mov	%rdi,%rdi
-	#   in0 = *(uint64 *) (k + 0)
-	movq	0(%rsi),%r8
-	#   in2 = *(uint64 *) (k + 8)
-	movq	8(%rsi),%r9
-	#   *(uint64 *) (x + 4) = in0
-	movq	%r8,4(%rdi)
-	#   *(uint64 *) (x + 12) = in2
-	movq	%r9,12(%rdi)
-	#                    unsigned<? kbits - 256
-	cmp	$256,%rdx
-	# comment:fp stack unchanged by jump
-	#   goto kbits128 if unsigned<
-	jb	._kbits128
-#   kbits256:
-._kbits256:
-	#     in10 = *(uint64 *) (k + 16)
-	movq	16(%rsi),%rdx
-	#     in12 = *(uint64 *) (k + 24)
-	movq	24(%rsi),%rsi
-	#     *(uint64 *) (x + 44) = in10
-	movq	%rdx,44(%rdi)
-	#     *(uint64 *) (x + 52) = in12
-	movq	%rsi,52(%rdi)
-	#     in0 = 1634760805
-	mov	$1634760805,%rsi
-	#     in4 = 857760878
-	mov	$857760878,%rdx
-	#     in10 = 2036477234
-	mov	$2036477234,%rcx
-	#     in14 = 1797285236
-	mov	$1797285236,%r8
-	#     *(uint32 *) (x + 0) = in0
-	movl	%esi,0(%rdi)
-	#     *(uint32 *) (x + 20) = in4
-	movl	%edx,20(%rdi)
-	#     *(uint32 *) (x + 40) = in10
-	movl	%ecx,40(%rdi)
-	#     *(uint32 *) (x + 60) = in14
-	movl	%r8d,60(%rdi)
-	# comment:fp stack unchanged by jump
-	#   goto keysetupdone
-	jmp	._keysetupdone
-#   kbits128:
-._kbits128:
-	#     in10 = *(uint64 *) (k + 0)
-	movq	0(%rsi),%rdx
-	#     in12 = *(uint64 *) (k + 8)
-	movq	8(%rsi),%rsi
-	#     *(uint64 *) (x + 44) = in10
-	movq	%rdx,44(%rdi)
-	#     *(uint64 *) (x + 52) = in12
-	movq	%rsi,52(%rdi)
-	#     in0 = 1634760805
-	mov	$1634760805,%rsi
-	#     in4 = 824206446
-	mov	$824206446,%rdx
-	#     in10 = 2036477238
-	mov	$2036477238,%rcx
-	#     in14 = 1797285236
-	mov	$1797285236,%r8
-	#     *(uint32 *) (x + 0) = in0
-	movl	%esi,0(%rdi)
-	#     *(uint32 *) (x + 20) = in4
-	movl	%edx,20(%rdi)
-	#     *(uint32 *) (x + 40) = in10
-	movl	%ecx,40(%rdi)
-	#     *(uint32 *) (x + 60) = in14
-	movl	%r8d,60(%rdi)
-#   keysetupdone:
-._keysetupdone:
-	# leave
-	add	%r11,%rsp
-	mov	%rdi,%rax
-	mov	%rsi,%rdx
-	ret
-ENDPROC(salsa20_keysetup)
-
-# enter salsa20_ivsetup
-ENTRY(salsa20_ivsetup)
-	mov	%rsp,%r11
-	and	$31,%r11
-	add	$256,%r11
-	sub	%r11,%rsp
-	#   iv = arg2
-	mov	%rsi,%rsi
-	#   x = arg1
-	mov	%rdi,%rdi
-	#   in6 = *(uint64 *) (iv + 0)
-	movq	0(%rsi),%rsi
-	#   in8 = 0
-	mov	$0,%r8
-	#   *(uint64 *) (x + 24) = in6
-	movq	%rsi,24(%rdi)
-	#   *(uint64 *) (x + 32) = in8
-	movq	%r8,32(%rdi)
-	# leave
-	add	%r11,%rsp
-	mov	%rdi,%rax
-	mov	%rsi,%rdx
-	ret
-ENDPROC(salsa20_ivsetup)
diff --git a/arch/x86/crypto/salsa20_glue.c b/arch/x86/crypto/salsa20_glue.c
index cb91a64a99e7..b07d7d959806 100644
--- a/arch/x86/crypto/salsa20_glue.c
+++ b/arch/x86/crypto/salsa20_glue.c
@@ -11,6 +11,9 @@
  * - x86-64 version, renamed as salsa20-x86_64-asm_64.S
  *   available from <http://cr.yp.to/snuffle/salsa20/amd64-3/salsa20.s>
  *
+ * Also modified to set up the initial state using the generic C code rather
+ * than in assembly.
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
@@ -18,93 +21,65 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <asm/unaligned.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/salsa20.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
-
-#define SALSA20_IV_SIZE        8U
-#define SALSA20_MIN_KEY_SIZE  16U
-#define SALSA20_MAX_KEY_SIZE  32U
-
-struct salsa20_ctx
-{
-	u32 input[16];
-};
 
-asmlinkage void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k,
-				 u32 keysize, u32 ivsize);
-asmlinkage void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv);
-asmlinkage void salsa20_encrypt_bytes(struct salsa20_ctx *ctx,
-				      const u8 *src, u8 *dst, u32 bytes);
+asmlinkage void salsa20_encrypt_bytes(u32 state[16], const u8 *src, u8 *dst,
+				      u32 bytes);
 
-static int setkey(struct crypto_tfm *tfm, const u8 *key,
-		  unsigned int keysize)
+static int salsa20_asm_crypt(struct skcipher_request *req)
 {
-	struct salsa20_ctx *ctx = crypto_tfm_ctx(tfm);
-	salsa20_keysetup(ctx, key, keysize*8, SALSA20_IV_SIZE*8);
-	return 0;
-}
-
-static int encrypt(struct blkcipher_desc *desc,
-		   struct scatterlist *dst, struct scatterlist *src,
-		   unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct salsa20_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct salsa20_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	u32 state[16];
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, 64);
+	err = skcipher_walk_virt(&walk, req, true);
 
-	salsa20_ivsetup(ctx, walk.iv);
+	crypto_salsa20_init(state, ctx, walk.iv);
 
-	while (walk.nbytes >= 64) {
-		salsa20_encrypt_bytes(ctx, walk.src.virt.addr,
-				      walk.dst.virt.addr,
-				      walk.nbytes - (walk.nbytes % 64));
-		err = blkcipher_walk_done(desc, &walk, walk.nbytes % 64);
-	}
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
 
-	if (walk.nbytes) {
-		salsa20_encrypt_bytes(ctx, walk.src.virt.addr,
-				      walk.dst.virt.addr, walk.nbytes);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
+		salsa20_encrypt_bytes(state, walk.src.virt.addr,
+				      walk.dst.virt.addr, nbytes);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	return err;
 }
 
-static struct crypto_alg alg = {
-	.cra_name           =   "salsa20",
-	.cra_driver_name    =   "salsa20-asm",
-	.cra_priority       =   200,
-	.cra_flags          =   CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_type           =   &crypto_blkcipher_type,
-	.cra_blocksize      =   1,
-	.cra_ctxsize        =   sizeof(struct salsa20_ctx),
-	.cra_alignmask      =	3,
-	.cra_module         =   THIS_MODULE,
-	.cra_u              =   {
-		.blkcipher = {
-			.setkey         =   setkey,
-			.encrypt        =   encrypt,
-			.decrypt        =   encrypt,
-			.min_keysize    =   SALSA20_MIN_KEY_SIZE,
-			.max_keysize    =   SALSA20_MAX_KEY_SIZE,
-			.ivsize         =   SALSA20_IV_SIZE,
-		}
-	}
+static struct skcipher_alg alg = {
+	.base.cra_name		= "salsa20",
+	.base.cra_driver_name	= "salsa20-asm",
+	.base.cra_priority	= 200,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct salsa20_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= SALSA20_MIN_KEY_SIZE,
+	.max_keysize		= SALSA20_MAX_KEY_SIZE,
+	.ivsize			= SALSA20_IV_SIZE,
+	.chunksize		= SALSA20_BLOCK_SIZE,
+	.setkey			= crypto_salsa20_setkey,
+	.encrypt		= salsa20_asm_crypt,
+	.decrypt		= salsa20_asm_crypt,
 };
 
 static int __init init(void)
 {
-	return crypto_register_alg(&alg);
+	return crypto_register_skcipher(&alg);
 }
 
 static void __exit fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_skcipher(&alg);
 }
 
 module_init(init);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9327fbfccf5a..b44c0ae04eb2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1339,6 +1339,7 @@ config CRYPTO_SALSA20_586
 	tristate "Salsa20 stream cipher algorithm (i586)"
 	depends on (X86 || UML_X86) && !64BIT
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_SALSA20
 	help
 	  Salsa20 stream cipher algorithm.
 
@@ -1352,6 +1353,7 @@ config CRYPTO_SALSA20_X86_64
 	tristate "Salsa20 stream cipher algorithm (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_SALSA20
 	help
 	  Salsa20 stream cipher algorithm.
 
-- 
2.15.1
