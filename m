From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] x86, crypto: ported aes-ni implementation to x86
Date: Wed,  3 Nov 2010 13:53:27 +0100
Message-ID: <1288788807-28521-1-git-send-email-minipli@googlemail.com>
Cc: Mathias Krause <minipli@googlemail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:50210 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab0KCMxa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Nov 2010 08:53:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES-NI instructions are also available in legacy mode so the 32-bit
architecture may profit from those, too.

To illustrate the performance gain here's a short summary of the tcrypt
speed test on a Core i7 M620 running at 2.67GHz comparing both assembler
implementations:

x86:                              i568       aes-ni   delta
256 bit, 8kB blocks, ECB:  125.94 MB/s  187.09 MB/s  +48.6%
256 bit, 8kB blocks, CBC:  118.04 MB/s  171.61 MB/s  +45.4%
320 bit, 8kB blocks, LRW:  128.20 MB/s  168.32 MB/s  +31.3%
512 bit, 8kB blocks, XTS:  118.35 MB/s  166.49 MB/s  +40.7%

Additionally, due to some minor optimizations, the 64-bit version also
get a performance gain up to 20% as seen below:

x86-64:                      old impl.     new impl.  delta
256 bit, 8kB blocks, ECB:  152.25 MB/s  183.84 MB/s  +20.7%
256 bit, 8kB blocks, CBC:  144.12 MB/s  170.03 MB/s  +18.0%
320 bit, 8kB blocks, LRW:  159.13 MB/s  169.69 MB/s   +6.6%
512 bit, 8kB blocks, XTS:  144.27 MB/s  172.14 MB/s  +19.3%

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
v2 changes:
* hide almost all register names in macros so the same code base can be shared
  between x86 and x86_64
* unified Kconfig documentation again
* added alignment constraints for internal functions.
---
 arch/x86/crypto/aesni-intel_asm.S  |  149 ++++++++++++++++++++++++++++-------
 arch/x86/crypto/aesni-intel_glue.c |   22 ++++-
 crypto/Kconfig                     |    8 +-
 3 files changed, 141 insertions(+), 38 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index ff16756..bf810b7 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -9,6 +9,9 @@
  *            Vinodh Gopal <vinodh.gopal@intel.com>
  *            Kahraman Akdemir
  *
+ * Ported x86_64 version to x86:
+ *    Author: Mathias Krause <minipli@googlemail.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -32,12 +35,16 @@
 #define IN	IN1
 #define KEY	%xmm2
 #define IV	%xmm3
+
 #define BSWAP_MASK %xmm10
 #define CTR	%xmm11
 #define INC	%xmm12
 
+#ifdef __x86_64__
+#define AREG	%rax
 #define KEYP	%rdi
 #define OUTP	%rsi
+#define UKEYP	OUTP
 #define INP	%rdx
 #define LEN	%rcx
 #define IVP	%r8
@@ -46,6 +53,18 @@
 #define TKEYP	T1
 #define T2	%r11
 #define TCTR_LOW T2
+#else
+#define AREG	%eax
+#define KEYP	%edi
+#define OUTP	AREG
+#define UKEYP	OUTP
+#define INP	%edx
+#define LEN	%esi
+#define IVP	%ebp
+#define KLEN	%ebx
+#define T1	%ecx
+#define TKEYP	T1
+#endif
 
 _key_expansion_128:
 _key_expansion_256a:
@@ -55,10 +74,11 @@ _key_expansion_256a:
 	shufps $0b10001100, %xmm0, %xmm4
 	pxor %xmm4, %xmm0
 	pxor %xmm1, %xmm0
-	movaps %xmm0, (%rcx)
-	add $0x10, %rcx
+	movaps %xmm0, (TKEYP)
+	add $0x10, TKEYP
 	ret
 
+.align 4
 _key_expansion_192a:
 	pshufd $0b01010101, %xmm1, %xmm1
 	shufps $0b00010000, %xmm0, %xmm4
@@ -76,12 +96,13 @@ _key_expansion_192a:
 
 	movaps %xmm0, %xmm1
 	shufps $0b01000100, %xmm0, %xmm6
-	movaps %xmm6, (%rcx)
+	movaps %xmm6, (TKEYP)
 	shufps $0b01001110, %xmm2, %xmm1
-	movaps %xmm1, 16(%rcx)
-	add $0x20, %rcx
+	movaps %xmm1, 0x10(TKEYP)
+	add $0x20, TKEYP
 	ret
 
+.align 4
 _key_expansion_192b:
 	pshufd $0b01010101, %xmm1, %xmm1
 	shufps $0b00010000, %xmm0, %xmm4
@@ -96,10 +117,11 @@ _key_expansion_192b:
 	pxor %xmm3, %xmm2
 	pxor %xmm5, %xmm2
 
-	movaps %xmm0, (%rcx)
-	add $0x10, %rcx
+	movaps %xmm0, (TKEYP)
+	add $0x10, TKEYP
 	ret
 
+.align 4
 _key_expansion_256b:
 	pshufd $0b10101010, %xmm1, %xmm1
 	shufps $0b00010000, %xmm2, %xmm4
@@ -107,8 +129,8 @@ _key_expansion_256b:
 	shufps $0b10001100, %xmm2, %xmm4
 	pxor %xmm4, %xmm2
 	pxor %xmm1, %xmm2
-	movaps %xmm2, (%rcx)
-	add $0x10, %rcx
+	movaps %xmm2, (TKEYP)
+	add $0x10, TKEYP
 	ret
 
 /*
@@ -116,17 +138,23 @@ _key_expansion_256b:
  *                   unsigned int key_len)
  */
 ENTRY(aesni_set_key)
-	movups (%rsi), %xmm0		# user key (first 16 bytes)
-	movaps %xmm0, (%rdi)
-	lea 0x10(%rdi), %rcx		# key addr
-	movl %edx, 480(%rdi)
+#ifndef __x86_64__
+	pushl KEYP
+	movl 8(%esp), KEYP		# ctx
+	movl 12(%esp), UKEYP		# in_key
+	movl 16(%esp), %edx		# key_len
+#endif
+	movups (UKEYP), %xmm0		# user key (first 16 bytes)
+	movaps %xmm0, (KEYP)
+	lea 0x10(KEYP), TKEYP		# key addr
+	movl %edx, 480(KEYP)
 	pxor %xmm4, %xmm4		# xmm4 is assumed 0 in _key_expansion_x
 	cmp $24, %dl
 	jb .Lenc_key128
 	je .Lenc_key192
-	movups 0x10(%rsi), %xmm2	# other user key
-	movaps %xmm2, (%rcx)
-	add $0x10, %rcx
+	movups 0x10(UKEYP), %xmm2	# other user key
+	movaps %xmm2, (TKEYP)
+	add $0x10, TKEYP
 	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
 	call _key_expansion_256a
 	AESKEYGENASSIST 0x1 %xmm0 %xmm1
@@ -155,7 +183,7 @@ ENTRY(aesni_set_key)
 	call _key_expansion_256a
 	jmp .Ldec_key
 .Lenc_key192:
-	movq 0x10(%rsi), %xmm2		# other user key
+	movq 0x10(UKEYP), %xmm2		# other user key
 	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
 	call _key_expansion_192a
 	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
@@ -195,33 +223,47 @@ ENTRY(aesni_set_key)
 	AESKEYGENASSIST 0x36 %xmm0 %xmm1	# round 10
 	call _key_expansion_128
 .Ldec_key:
-	sub $0x10, %rcx
-	movaps (%rdi), %xmm0
-	movaps (%rcx), %xmm1
-	movaps %xmm0, 240(%rcx)
-	movaps %xmm1, 240(%rdi)
-	add $0x10, %rdi
-	lea 240-16(%rcx), %rsi
+	sub $0x10, TKEYP
+	movaps (KEYP), %xmm0
+	movaps (TKEYP), %xmm1
+	movaps %xmm0, 240(TKEYP)
+	movaps %xmm1, 240(KEYP)
+	add $0x10, KEYP
+	lea 240-16(TKEYP), UKEYP
 .align 4
 .Ldec_key_loop:
-	movaps (%rdi), %xmm0
+	movaps (KEYP), %xmm0
 	AESIMC %xmm0 %xmm1
-	movaps %xmm1, (%rsi)
-	add $0x10, %rdi
-	sub $0x10, %rsi
-	cmp %rcx, %rdi
+	movaps %xmm1, (UKEYP)
+	add $0x10, KEYP
+	sub $0x10, UKEYP
+	cmp TKEYP, KEYP
 	jb .Ldec_key_loop
-	xor %rax, %rax
+	xor AREG, AREG
+#ifndef __x86_64__
+	popl KEYP
+#endif
 	ret
 
 /*
  * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_enc)
+#ifndef __x86_64__
+	pushl KEYP
+	pushl KLEN
+	movl 12(%esp), KEYP
+	movl 16(%esp), OUTP
+	movl 20(%esp), INP
+#endif
 	movl 480(KEYP), KLEN		# key length
 	movups (INP), STATE		# input
 	call _aesni_enc1
 	movups STATE, (OUTP)		# output
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+#endif
 	ret
 
 /*
@@ -236,6 +278,7 @@ ENTRY(aesni_enc)
  *	KEY
  *	TKEYP (T1)
  */
+.align 4
 _aesni_enc1:
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
@@ -298,6 +341,7 @@ _aesni_enc1:
  *	KEY
  *	TKEYP (T1)
  */
+.align 4
 _aesni_enc4:
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
@@ -391,11 +435,22 @@ _aesni_enc4:
  * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_dec)
+#ifndef __x86_64__
+	pushl KEYP
+	pushl KLEN
+	movl 12(%esp), KEYP
+	movl 16(%esp), OUTP
+	movl 20(%esp), INP
+#endif
 	mov 480(KEYP), KLEN		# key length
 	add $240, KEYP
 	movups (INP), STATE		# input
 	call _aesni_dec1
 	movups STATE, (OUTP)		#output
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+#endif
 	ret
 
 /*
@@ -410,6 +465,7 @@ ENTRY(aesni_dec)
  *	KEY
  *	TKEYP (T1)
  */
+.align 4
 _aesni_dec1:
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
@@ -472,6 +528,7 @@ _aesni_dec1:
  *	KEY
  *	TKEYP (T1)
  */
+.align 4
 _aesni_dec4:
 	movaps (KEYP), KEY		# key
 	mov KEYP, TKEYP
@@ -566,6 +623,15 @@ _aesni_dec4:
  *		      size_t len)
  */
 ENTRY(aesni_ecb_enc)
+#ifndef __x86_64__
+	pushl LEN
+	pushl KEYP
+	pushl KLEN
+	movl 16(%esp), KEYP
+	movl 20(%esp), OUTP
+	movl 24(%esp), INP
+	movl 28(%esp), LEN
+#endif
 	test LEN, LEN		# check length
 	jz .Lecb_enc_ret
 	mov 480(KEYP), KLEN
@@ -609,6 +675,15 @@ ENTRY(aesni_ecb_enc)
  *		      size_t len);
  */
 ENTRY(aesni_ecb_dec)
+#ifndef __x86_64__
+	pushl LEN
+	pushl KEYP
+	pushl KLEN
+	movl 16(%esp), KEYP
+	movl 20(%esp), OUTP
+	movl 24(%esp), INP
+	movl 28(%esp), LEN
+#endif
 	test LEN, LEN
 	jz .Lecb_dec_ret
 	mov 480(KEYP), KLEN
@@ -646,6 +721,11 @@ ENTRY(aesni_ecb_dec)
 	cmp $16, LEN
 	jge .Lecb_dec_loop1
 .Lecb_dec_ret:
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+	popl LEN
+#endif
 	ret
 
 /*
@@ -670,8 +750,14 @@ ENTRY(aesni_cbc_enc)
 	jge .Lcbc_enc_loop
 	movups STATE, (IVP)
 .Lcbc_enc_ret:
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+	popl LEN
+#endif
 	ret
 
+#ifdef __x86_64__
 /*
  * void aesni_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *		      size_t len, u8 *iv)
@@ -744,6 +830,7 @@ ENTRY(aesni_cbc_dec)
  *	INC:	== 1, in little endian
  *	BSWAP_MASK == endian swapping mask
  */
+.align 4
 _aesni_inc_init:
 	movaps .Lbswap_mask, BSWAP_MASK
 	movaps IV, CTR
@@ -768,6 +855,7 @@ _aesni_inc_init:
  *	CTR:	== output IV, in little endian
  *	TCTR_LOW: == lower qword of CTR
  */
+.align 4
 _aesni_inc:
 	paddq INC, CTR
 	add $1, TCTR_LOW
@@ -839,3 +927,4 @@ ENTRY(aesni_ctr_enc)
 	movups IV, (IVP)
 .Lctr_enc_just_ret:
 	ret
+#endif
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2cb3dcc..d0f0e7b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -55,12 +55,14 @@ asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
 asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
+#ifdef CONFIG_X86_64
 asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+#endif
 
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
@@ -254,6 +256,7 @@ static struct crypto_alg blk_ecb_alg = {
 	},
 };
 
+#ifdef CONFIG_X86_64
 static int cbc_encrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -389,6 +392,7 @@ static struct crypto_alg blk_ctr_alg = {
 		},
 	},
 };
+#endif
 
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int key_len)
@@ -500,6 +504,7 @@ static struct crypto_alg ablk_ecb_alg = {
 	},
 };
 
+#ifdef CONFIG_X86_64
 static int ablk_cbc_init(struct crypto_tfm *tfm)
 {
 	struct cryptd_ablkcipher *cryptd_tfm;
@@ -612,6 +617,7 @@ static struct crypto_alg ablk_rfc3686_ctr_alg = {
 	},
 };
 #endif
+#endif
 
 #ifdef HAS_LRW
 static int ablk_lrw_init(struct crypto_tfm *tfm)
@@ -744,12 +750,13 @@ static int __init aesni_init(void)
 		goto __aes_err;
 	if ((err = crypto_register_alg(&blk_ecb_alg)))
 		goto blk_ecb_err;
+	if ((err = crypto_register_alg(&ablk_ecb_alg)))
+		goto ablk_ecb_err;
+#ifdef CONFIG_X86_64
 	if ((err = crypto_register_alg(&blk_cbc_alg)))
 		goto blk_cbc_err;
 	if ((err = crypto_register_alg(&blk_ctr_alg)))
 		goto blk_ctr_err;
-	if ((err = crypto_register_alg(&ablk_ecb_alg)))
-		goto ablk_ecb_err;
 	if ((err = crypto_register_alg(&ablk_cbc_alg)))
 		goto ablk_cbc_err;
 	if ((err = crypto_register_alg(&ablk_ctr_alg)))
@@ -758,6 +765,7 @@ static int __init aesni_init(void)
 	if ((err = crypto_register_alg(&ablk_rfc3686_ctr_alg)))
 		goto ablk_rfc3686_ctr_err;
 #endif
+#endif
 #ifdef HAS_LRW
 	if ((err = crypto_register_alg(&ablk_lrw_alg)))
 		goto ablk_lrw_err;
@@ -784,6 +792,7 @@ ablk_pcbc_err:
 	crypto_unregister_alg(&ablk_lrw_alg);
 ablk_lrw_err:
 #endif
+#ifdef CONFIG_X86_64
 #ifdef HAS_CTR
 	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
 ablk_rfc3686_ctr_err:
@@ -792,12 +801,13 @@ ablk_rfc3686_ctr_err:
 ablk_ctr_err:
 	crypto_unregister_alg(&ablk_cbc_alg);
 ablk_cbc_err:
-	crypto_unregister_alg(&ablk_ecb_alg);
-ablk_ecb_err:
 	crypto_unregister_alg(&blk_ctr_alg);
 blk_ctr_err:
 	crypto_unregister_alg(&blk_cbc_alg);
 blk_cbc_err:
+#endif
+	crypto_unregister_alg(&ablk_ecb_alg);
+ablk_ecb_err:
 	crypto_unregister_alg(&blk_ecb_alg);
 blk_ecb_err:
 	crypto_unregister_alg(&__aesni_alg);
@@ -818,14 +828,16 @@ static void __exit aesni_exit(void)
 #ifdef HAS_LRW
 	crypto_unregister_alg(&ablk_lrw_alg);
 #endif
+#ifdef CONFIG_X86_64
 #ifdef HAS_CTR
 	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
 #endif
 	crypto_unregister_alg(&ablk_ctr_alg);
 	crypto_unregister_alg(&ablk_cbc_alg);
-	crypto_unregister_alg(&ablk_ecb_alg);
 	crypto_unregister_alg(&blk_ctr_alg);
 	crypto_unregister_alg(&blk_cbc_alg);
+#endif
+	crypto_unregister_alg(&ablk_ecb_alg);
 	crypto_unregister_alg(&blk_ecb_alg);
 	crypto_unregister_alg(&__aesni_alg);
 	crypto_unregister_alg(&aesni_alg);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index e4bac29..459fd35 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -539,8 +539,9 @@ config CRYPTO_AES_X86_64
 
 config CRYPTO_AES_NI_INTEL
 	tristate "AES cipher algorithms (AES-NI)"
-	depends on (X86 || UML_X86) && 64BIT
-	select CRYPTO_AES_X86_64
+	depends on (X86 || UML_X86)
+	select CRYPTO_AES_X86_64 if 64BIT
+	select CRYPTO_AES_586 if !64BIT
 	select CRYPTO_CRYPTD
 	select CRYPTO_ALGAPI
 	select CRYPTO_FPU
@@ -565,7 +566,8 @@ config CRYPTO_AES_NI_INTEL
 
 	  In addition to AES cipher algorithm support, the
 	  acceleration for some popular block cipher mode is supported
-	  too, including ECB, CBC, CTR, LRW, PCBC, XTS.
+	  too, including ECB, LRW, PCBC, XTS. The 64 bit version has
+	  additional acceleration for CBC and CTR.
 
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
-- 
1.5.6.5
