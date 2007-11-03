From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [patch 1/2] AES i586, remove setkey
Date: Sat, 03 Nov 2007 11:05:03 +0100
Message-ID: <20071102181036.371060403@ml.breakpoint.cc>
References: <20071102180503.712394234@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52520 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbXKCKFR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Nov 2007 06:05:17 -0400
Content-Disposition: inline; filename=0001-crypto-AES-i586-remove-setkey.patch
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The setkey() function can be shared with the generic algorithm.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/x86/crypto/aes-i586-asm_32.S |   89 ++++----
 arch/x86/crypto/aes_32.c          |  461 +------------------------------------
 crypto/Kconfig                    |    1 +
 3 files changed, 47 insertions(+), 504 deletions(-)

diff --git a/arch/x86/crypto/aes-i586-asm_32.S b/arch/x86/crypto/aes-i586-asm_32.S
index f942f0c..1093bed 100644
--- a/arch/x86/crypto/aes-i586-asm_32.S
+++ b/arch/x86/crypto/aes-i586-asm_32.S
@@ -46,9 +46,9 @@
 #define in_blk 16
 
 /* offsets in crypto_tfm structure */
-#define ekey (crypto_tfm_ctx_offset + 0)
-#define nrnd (crypto_tfm_ctx_offset + 256)
-#define dkey (crypto_tfm_ctx_offset + 260)
+#define klen (crypto_tfm_ctx_offset + 0)
+#define ekey (crypto_tfm_ctx_offset + 4)
+#define dkey (crypto_tfm_ctx_offset + 244)
 
 // register mapping for encrypt and decrypt subroutines
 
@@ -221,8 +221,8 @@
 
 .global  aes_enc_blk
 
-.extern  ft_tab
-.extern  fl_tab
+.extern  crypto_ft_tab
+.extern  crypto_fl_tab
 
 .align 4
 
@@ -236,7 +236,7 @@ aes_enc_blk:
 1:	push    %ebx
 	mov     in_blk+4(%esp),%r2
 	push    %esi
-	mov     nrnd(%ebp),%r3   // number of rounds
+	mov     klen(%ebp),%r3   // key size
 	push    %edi
 #if ekey != 0
 	lea     ekey(%ebp),%ebp  // key pointer
@@ -255,26 +255,26 @@ aes_enc_blk:
 
 	sub     $8,%esp		// space for register saves on stack
 	add     $16,%ebp	// increment to next round key
-	cmp     $12,%r3
+	cmp     $24,%r3
 	jb      4f		// 10 rounds for 128-bit key
 	lea     32(%ebp),%ebp
 	je      3f		// 12 rounds for 192-bit key
 	lea     32(%ebp),%ebp
 
-2:	fwd_rnd1( -64(%ebp) ,ft_tab)	// 14 rounds for 256-bit key
-	fwd_rnd2( -48(%ebp) ,ft_tab)
-3:	fwd_rnd1( -32(%ebp) ,ft_tab)	// 12 rounds for 192-bit key
-	fwd_rnd2( -16(%ebp) ,ft_tab)
-4:	fwd_rnd1(    (%ebp) ,ft_tab)	// 10 rounds for 128-bit key
-	fwd_rnd2( +16(%ebp) ,ft_tab)
-	fwd_rnd1( +32(%ebp) ,ft_tab)
-	fwd_rnd2( +48(%ebp) ,ft_tab)
-	fwd_rnd1( +64(%ebp) ,ft_tab)
-	fwd_rnd2( +80(%ebp) ,ft_tab)
-	fwd_rnd1( +96(%ebp) ,ft_tab)
-	fwd_rnd2(+112(%ebp) ,ft_tab)
-	fwd_rnd1(+128(%ebp) ,ft_tab)
-	fwd_rnd2(+144(%ebp) ,fl_tab)	// last round uses a different table
+2:	fwd_rnd1( -64(%ebp), crypto_ft_tab)	// 14 rounds for 256-bit key
+	fwd_rnd2( -48(%ebp), crypto_ft_tab)
+3:	fwd_rnd1( -32(%ebp), crypto_ft_tab)	// 12 rounds for 192-bit key
+	fwd_rnd2( -16(%ebp), crypto_ft_tab)
+4:	fwd_rnd1(    (%ebp), crypto_ft_tab)	// 10 rounds for 128-bit key
+	fwd_rnd2( +16(%ebp), crypto_ft_tab)
+	fwd_rnd1( +32(%ebp), crypto_ft_tab)
+	fwd_rnd2( +48(%ebp), crypto_ft_tab)
+	fwd_rnd1( +64(%ebp), crypto_ft_tab)
+	fwd_rnd2( +80(%ebp), crypto_ft_tab)
+	fwd_rnd1( +96(%ebp), crypto_ft_tab)
+	fwd_rnd2(+112(%ebp), crypto_ft_tab)
+	fwd_rnd1(+128(%ebp), crypto_ft_tab)
+	fwd_rnd2(+144(%ebp), crypto_fl_tab)	// last round uses a different table
 
 // move final values to the output array.  CAUTION: the 
 // order of these assigns rely on the register mappings
@@ -297,8 +297,8 @@ aes_enc_blk:
 
 .global  aes_dec_blk
 
-.extern  it_tab
-.extern  il_tab
+.extern  crypto_it_tab
+.extern  crypto_il_tab
 
 .align 4
 
@@ -312,14 +312,11 @@ aes_dec_blk:
 1:	push    %ebx
 	mov     in_blk+4(%esp),%r2
 	push    %esi
-	mov     nrnd(%ebp),%r3   // number of rounds
+	mov     klen(%ebp),%r3   // key size
 	push    %edi
 #if dkey != 0
 	lea     dkey(%ebp),%ebp  // key pointer
 #endif
-	mov     %r3,%r0
-	shl     $4,%r0
-	add     %r0,%ebp
 	
 // input four columns and xor in first round key
 
@@ -333,27 +330,27 @@ aes_dec_blk:
 	xor     12(%ebp),%r5
 
 	sub     $8,%esp		// space for register saves on stack
-	sub     $16,%ebp	// increment to next round key
-	cmp     $12,%r3
+	add     $16,%ebp	// increment to next round key
+	cmp     $24,%r3
 	jb      4f		// 10 rounds for 128-bit key
-	lea     -32(%ebp),%ebp
+	lea     32(%ebp),%ebp
 	je      3f		// 12 rounds for 192-bit key
-	lea     -32(%ebp),%ebp
-
-2:	inv_rnd1( +64(%ebp), it_tab)	// 14 rounds for 256-bit key
-	inv_rnd2( +48(%ebp), it_tab)
-3:	inv_rnd1( +32(%ebp), it_tab)	// 12 rounds for 192-bit key
-	inv_rnd2( +16(%ebp), it_tab)
-4:	inv_rnd1(    (%ebp), it_tab)	// 10 rounds for 128-bit key
-	inv_rnd2( -16(%ebp), it_tab)
-	inv_rnd1( -32(%ebp), it_tab)
-	inv_rnd2( -48(%ebp), it_tab)
-	inv_rnd1( -64(%ebp), it_tab)
-	inv_rnd2( -80(%ebp), it_tab)
-	inv_rnd1( -96(%ebp), it_tab)
-	inv_rnd2(-112(%ebp), it_tab)
-	inv_rnd1(-128(%ebp), it_tab)
-	inv_rnd2(-144(%ebp), il_tab)	// last round uses a different table
+	lea     32(%ebp),%ebp
+
+2:	inv_rnd1( -64(%ebp), crypto_it_tab)	// 14 rounds for 256-bit key
+	inv_rnd2( -48(%ebp), crypto_it_tab)
+3:	inv_rnd1( -32(%ebp), crypto_it_tab)	// 12 rounds for 192-bit key
+	inv_rnd2( -16(%ebp), crypto_it_tab)
+4:	inv_rnd1(    (%ebp), crypto_it_tab)	// 10 rounds for 128-bit key
+	inv_rnd2( +16(%ebp), crypto_it_tab)
+	inv_rnd1( +32(%ebp), crypto_it_tab)
+	inv_rnd2( +48(%ebp), crypto_it_tab)
+	inv_rnd1( +64(%ebp), crypto_it_tab)
+	inv_rnd2( +80(%ebp), crypto_it_tab)
+	inv_rnd1( +96(%ebp), crypto_it_tab)
+	inv_rnd2(+112(%ebp), crypto_it_tab)
+	inv_rnd1(+128(%ebp), crypto_it_tab)
+	inv_rnd2(+144(%ebp), crypto_il_tab)	// last round uses a different table
 
 // move final values to the output array.  CAUTION: the 
 // order of these assigns rely on the register mappings
diff --git a/arch/x86/crypto/aes_32.c b/arch/x86/crypto/aes_32.c
index 9b0ab50..8556d95 100644
--- a/arch/x86/crypto/aes_32.c
+++ b/arch/x86/crypto/aes_32.c
@@ -1,468 +1,14 @@
-/* 
- * 
+/*
  * Glue Code for optimized 586 assembler version of AES
- *
- * Copyright (c) 2002, Dr Brian Gladman <>, Worcester, UK.
- * All rights reserved.
- *
- * LICENSE TERMS
- *
- * The free distribution and use of this software in both source and binary
- * form is allowed (with or without changes) provided that:
- *
- *   1. distributions of this source code include the above copyright
- *      notice, this list of conditions and the following disclaimer;
- *
- *   2. distributions in binary form include the above copyright
- *      notice, this list of conditions and the following disclaimer
- *      in the documentation and/or other associated materials;
- *
- *   3. the copyright holder's name is not used to endorse products
- *      built using this software without specific written permission.
- *
- * ALTERNATIVELY, provided that this notice is retained in full, this product
- * may be distributed under the terms of the GNU General Public License (GPL),
- * in which case the provisions of the GPL apply INSTEAD OF those given above.
- *
- * DISCLAIMER
- *
- * This software is provided 'as is' with no explicit or implied warranties
- * in respect of its properties, including, but not limited to, correctness
- * and/or fitness for purpose.
- *
- * Copyright (c) 2003, Adam J. Richter <adam@yggdrasil.com> (conversion to
- * 2.5 API).
- * Copyright (c) 2003, 2004 Fruhwirth Clemens <clemens@endorphin.org>
- * Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
- *
  */
 
-#include <asm/byteorder.h>
 #include <crypto/aes.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
 #include <linux/crypto.h>
-#include <linux/linkage.h>
 
 asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 
-#define AES_KS_LENGTH		4 * AES_BLOCK_SIZE
-#define RC_LENGTH		29
-
-struct aes_ctx {
-	u32 ekey[AES_KS_LENGTH];
-	u32 rounds;
-	u32 dkey[AES_KS_LENGTH];
-};
-
-#define WPOLY 0x011b
-#define bytes2word(b0, b1, b2, b3)  \
-	(((u32)(b3) << 24) | ((u32)(b2) << 16) | ((u32)(b1) << 8) | (b0))
-
-/* define the finite field multiplies required for Rijndael */
-#define f2(x) ((x) ? pow[log[x] + 0x19] : 0)
-#define f3(x) ((x) ? pow[log[x] + 0x01] : 0)
-#define f9(x) ((x) ? pow[log[x] + 0xc7] : 0)
-#define fb(x) ((x) ? pow[log[x] + 0x68] : 0)
-#define fd(x) ((x) ? pow[log[x] + 0xee] : 0)
-#define fe(x) ((x) ? pow[log[x] + 0xdf] : 0)
-#define fi(x) ((x) ?   pow[255 - log[x]]: 0)
-
-static inline u32 upr(u32 x, int n)
-{
-	return (x << 8 * n) | (x >> (32 - 8 * n));
-}
-
-static inline u8 bval(u32 x, int n)
-{
-	return x >> 8 * n;
-}
-
-/* The forward and inverse affine transformations used in the S-box */
-#define fwd_affine(x) \
-	(w = (u32)x, w ^= (w<<1)^(w<<2)^(w<<3)^(w<<4), 0x63^(u8)(w^(w>>8)))
-
-#define inv_affine(x) \
-	(w = (u32)x, w = (w<<1)^(w<<3)^(w<<6), 0x05^(u8)(w^(w>>8)))
-
-static u32 rcon_tab[RC_LENGTH];
-
-u32 ft_tab[4][256];
-u32 fl_tab[4][256];
-static u32 im_tab[4][256];
-u32 il_tab[4][256];
-u32 it_tab[4][256];
-
-static void gen_tabs(void)
-{
-	u32 i, w;
-	u8 pow[512], log[256];
-
-	/*
-	 * log and power tables for GF(2^8) finite field with
-	 * WPOLY as modular polynomial - the simplest primitive
-	 * root is 0x03, used here to generate the tables.
-	 */
-	i = 0; w = 1; 
-	
-	do {
-		pow[i] = (u8)w;
-		pow[i + 255] = (u8)w;
-		log[w] = (u8)i++;
-		w ^=  (w << 1) ^ (w & 0x80 ? WPOLY : 0);
-	} while (w != 1);
-	
-	for(i = 0, w = 1; i < RC_LENGTH; ++i) {
-		rcon_tab[i] = bytes2word(w, 0, 0, 0);
-		w = f2(w);
-	}
-
-	for(i = 0; i < 256; ++i) {
-		u8 b;
-		
-		b = fwd_affine(fi((u8)i));
-		w = bytes2word(f2(b), b, b, f3(b));
-
-		/* tables for a normal encryption round */
-		ft_tab[0][i] = w;
-		ft_tab[1][i] = upr(w, 1);
-		ft_tab[2][i] = upr(w, 2);
-		ft_tab[3][i] = upr(w, 3);
-		w = bytes2word(b, 0, 0, 0);
-		
-		/*
-		 * tables for last encryption round
-		 * (may also be used in the key schedule)
-		 */
-		fl_tab[0][i] = w;
-		fl_tab[1][i] = upr(w, 1);
-		fl_tab[2][i] = upr(w, 2);
-		fl_tab[3][i] = upr(w, 3);
-		
-		b = fi(inv_affine((u8)i));
-		w = bytes2word(fe(b), f9(b), fd(b), fb(b));
-
-		/* tables for the inverse mix column operation  */
-		im_tab[0][b] = w;
-		im_tab[1][b] = upr(w, 1);
-		im_tab[2][b] = upr(w, 2);
-		im_tab[3][b] = upr(w, 3);
-
-		/* tables for a normal decryption round */
-		it_tab[0][i] = w;
-		it_tab[1][i] = upr(w,1);
-		it_tab[2][i] = upr(w,2);
-		it_tab[3][i] = upr(w,3);
-
-		w = bytes2word(b, 0, 0, 0);
-		
-		/* tables for last decryption round */
-		il_tab[0][i] = w;
-		il_tab[1][i] = upr(w,1);
-		il_tab[2][i] = upr(w,2);
-		il_tab[3][i] = upr(w,3);
-    }
-}
-
-#define four_tables(x,tab,vf,rf,c)		\
-(	tab[0][bval(vf(x,0,c),rf(0,c))]	^	\
-	tab[1][bval(vf(x,1,c),rf(1,c))] ^	\
-	tab[2][bval(vf(x,2,c),rf(2,c))] ^	\
-	tab[3][bval(vf(x,3,c),rf(3,c))]		\
-)
-
-#define vf1(x,r,c)  (x)
-#define rf1(r,c)    (r)
-#define rf2(r,c)    ((r-c)&3)
-
-#define inv_mcol(x) four_tables(x,im_tab,vf1,rf1,0)
-#define ls_box(x,c) four_tables(x,fl_tab,vf1,rf2,c)
-
-#define ff(x) inv_mcol(x)
-
-#define ke4(k,i)							\
-{									\
-	k[4*(i)+4] = ss[0] ^= ls_box(ss[3],3) ^ rcon_tab[i];		\
-	k[4*(i)+5] = ss[1] ^= ss[0];					\
-	k[4*(i)+6] = ss[2] ^= ss[1];					\
-	k[4*(i)+7] = ss[3] ^= ss[2];					\
-}
-
-#define kel4(k,i)							\
-{									\
-	k[4*(i)+4] = ss[0] ^= ls_box(ss[3],3) ^ rcon_tab[i];		\
-	k[4*(i)+5] = ss[1] ^= ss[0];					\
-	k[4*(i)+6] = ss[2] ^= ss[1]; k[4*(i)+7] = ss[3] ^= ss[2];	\
-}
-
-#define ke6(k,i)							\
-{									\
-	k[6*(i)+ 6] = ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i];		\
-	k[6*(i)+ 7] = ss[1] ^= ss[0];					\
-	k[6*(i)+ 8] = ss[2] ^= ss[1];					\
-	k[6*(i)+ 9] = ss[3] ^= ss[2];					\
-	k[6*(i)+10] = ss[4] ^= ss[3];					\
-	k[6*(i)+11] = ss[5] ^= ss[4];					\
-}
-
-#define kel6(k,i)							\
-{									\
-	k[6*(i)+ 6] = ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i];		\
-	k[6*(i)+ 7] = ss[1] ^= ss[0];					\
-	k[6*(i)+ 8] = ss[2] ^= ss[1];					\
-	k[6*(i)+ 9] = ss[3] ^= ss[2];					\
-}
-
-#define ke8(k,i)							\
-{									\
-	k[8*(i)+ 8] = ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i];		\
-	k[8*(i)+ 9] = ss[1] ^= ss[0];					\
-	k[8*(i)+10] = ss[2] ^= ss[1];					\
-	k[8*(i)+11] = ss[3] ^= ss[2];					\
-	k[8*(i)+12] = ss[4] ^= ls_box(ss[3],0);				\
-	k[8*(i)+13] = ss[5] ^= ss[4];					\
-	k[8*(i)+14] = ss[6] ^= ss[5];					\
-	k[8*(i)+15] = ss[7] ^= ss[6];					\
-}
-
-#define kel8(k,i)							\
-{									\
-	k[8*(i)+ 8] = ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i];		\
-	k[8*(i)+ 9] = ss[1] ^= ss[0];					\
-	k[8*(i)+10] = ss[2] ^= ss[1];					\
-	k[8*(i)+11] = ss[3] ^= ss[2];					\
-}
-
-#define kdf4(k,i)							\
-{									\
-	ss[0] = ss[0] ^ ss[2] ^ ss[1] ^ ss[3];				\
-	ss[1] = ss[1] ^ ss[3];						\
-	ss[2] = ss[2] ^ ss[3];						\
-	ss[3] = ss[3];							\
-	ss[4] = ls_box(ss[(i+3) % 4], 3) ^ rcon_tab[i];			\
-	ss[i % 4] ^= ss[4];						\
-	ss[4] ^= k[4*(i)];						\
-	k[4*(i)+4] = ff(ss[4]);						\
-	ss[4] ^= k[4*(i)+1];						\
-	k[4*(i)+5] = ff(ss[4]);						\
-	ss[4] ^= k[4*(i)+2];						\
-	k[4*(i)+6] = ff(ss[4]);						\
-	ss[4] ^= k[4*(i)+3];						\
-	k[4*(i)+7] = ff(ss[4]);						\
-}
-
-#define kd4(k,i)							\
-{									\
-	ss[4] = ls_box(ss[(i+3) % 4], 3) ^ rcon_tab[i];			\
-	ss[i % 4] ^= ss[4];						\
-	ss[4] = ff(ss[4]);						\
-	k[4*(i)+4] = ss[4] ^= k[4*(i)];					\
-	k[4*(i)+5] = ss[4] ^= k[4*(i)+1];				\
-	k[4*(i)+6] = ss[4] ^= k[4*(i)+2];				\
-	k[4*(i)+7] = ss[4] ^= k[4*(i)+3];				\
-}
-
-#define kdl4(k,i)							\
-{									\
-	ss[4] = ls_box(ss[(i+3) % 4], 3) ^ rcon_tab[i];			\
-	ss[i % 4] ^= ss[4];						\
-	k[4*(i)+4] = (ss[0] ^= ss[1]) ^ ss[2] ^ ss[3];			\
-	k[4*(i)+5] = ss[1] ^ ss[3];					\
-	k[4*(i)+6] = ss[0];						\
-	k[4*(i)+7] = ss[1];						\
-}
-
-#define kdf6(k,i)							\
-{									\
-	ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i];				\
-	k[6*(i)+ 6] = ff(ss[0]);					\
-	ss[1] ^= ss[0];							\
-	k[6*(i)+ 7] = ff(ss[1]);					\
-	ss[2] ^= ss[1];							\
-	k[6*(i)+ 8] = ff(ss[2]);					\
-	ss[3] ^= ss[2];							\
-	k[6*(i)+ 9] = ff(ss[3]);					\
-	ss[4] ^= ss[3];							\
-	k[6*(i)+10] = ff(ss[4]);					\
-	ss[5] ^= ss[4];							\
-	k[6*(i)+11] = ff(ss[5]);					\
-}
-
-#define kd6(k,i)							\
-{									\
-	ss[6] = ls_box(ss[5],3) ^ rcon_tab[i];				\
-	ss[0] ^= ss[6]; ss[6] = ff(ss[6]);				\
-	k[6*(i)+ 6] = ss[6] ^= k[6*(i)];				\
-	ss[1] ^= ss[0];							\
-	k[6*(i)+ 7] = ss[6] ^= k[6*(i)+ 1];				\
-	ss[2] ^= ss[1];							\
-	k[6*(i)+ 8] = ss[6] ^= k[6*(i)+ 2];				\
-	ss[3] ^= ss[2];							\
-	k[6*(i)+ 9] = ss[6] ^= k[6*(i)+ 3];				\
-	ss[4] ^= ss[3];							\
-	k[6*(i)+10] = ss[6] ^= k[6*(i)+ 4];				\
-	ss[5] ^= ss[4];							\
-	k[6*(i)+11] = ss[6] ^= k[6*(i)+ 5];				\
-}
-
-#define kdl6(k,i)							\
-{									\
-	ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i];				\
-	k[6*(i)+ 6] = ss[0];						\
-	ss[1] ^= ss[0];							\
-	k[6*(i)+ 7] = ss[1];						\
-	ss[2] ^= ss[1];							\
-	k[6*(i)+ 8] = ss[2];						\
-	ss[3] ^= ss[2];							\
-	k[6*(i)+ 9] = ss[3];						\
-}
-
-#define kdf8(k,i)							\
-{									\
-	ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i];				\
-	k[8*(i)+ 8] = ff(ss[0]);					\
-	ss[1] ^= ss[0];							\
-	k[8*(i)+ 9] = ff(ss[1]);					\
-	ss[2] ^= ss[1];							\
-	k[8*(i)+10] = ff(ss[2]);					\
-	ss[3] ^= ss[2];							\
-	k[8*(i)+11] = ff(ss[3]);					\
-	ss[4] ^= ls_box(ss[3],0);					\
-	k[8*(i)+12] = ff(ss[4]);					\
-	ss[5] ^= ss[4];							\
-	k[8*(i)+13] = ff(ss[5]);					\
-	ss[6] ^= ss[5];							\
-	k[8*(i)+14] = ff(ss[6]);					\
-	ss[7] ^= ss[6];							\
-	k[8*(i)+15] = ff(ss[7]);					\
-}
-
-#define kd8(k,i)							\
-{									\
-	u32 __g = ls_box(ss[7],3) ^ rcon_tab[i];			\
-	ss[0] ^= __g;							\
-	__g = ff(__g);							\
-	k[8*(i)+ 8] = __g ^= k[8*(i)];					\
-	ss[1] ^= ss[0];							\
-	k[8*(i)+ 9] = __g ^= k[8*(i)+ 1];				\
-	ss[2] ^= ss[1];							\
-	k[8*(i)+10] = __g ^= k[8*(i)+ 2];				\
-	ss[3] ^= ss[2];							\
-	k[8*(i)+11] = __g ^= k[8*(i)+ 3];				\
-	__g = ls_box(ss[3],0);						\
-	ss[4] ^= __g;							\
-	__g = ff(__g);							\
-	k[8*(i)+12] = __g ^= k[8*(i)+ 4];				\
-	ss[5] ^= ss[4];							\
-	k[8*(i)+13] = __g ^= k[8*(i)+ 5];				\
-	ss[6] ^= ss[5];							\
-	k[8*(i)+14] = __g ^= k[8*(i)+ 6];				\
-	ss[7] ^= ss[6];							\
-	k[8*(i)+15] = __g ^= k[8*(i)+ 7];				\
-}
-
-#define kdl8(k,i)							\
-{									\
-	ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i];				\
-	k[8*(i)+ 8] = ss[0];						\
-	ss[1] ^= ss[0];							\
-	k[8*(i)+ 9] = ss[1];						\
-	ss[2] ^= ss[1];							\
-	k[8*(i)+10] = ss[2];						\
-	ss[3] ^= ss[2];							\
-	k[8*(i)+11] = ss[3];						\
-}
-
-static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		       unsigned int key_len)
-{
-	int i;
-	u32 ss[8];
-	struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *key = (const __le32 *)in_key;
-	u32 *flags = &tfm->crt_flags;
-
-	/* encryption schedule */
-	
-	ctx->ekey[0] = ss[0] = le32_to_cpu(key[0]);
-	ctx->ekey[1] = ss[1] = le32_to_cpu(key[1]);
-	ctx->ekey[2] = ss[2] = le32_to_cpu(key[2]);
-	ctx->ekey[3] = ss[3] = le32_to_cpu(key[3]);
-
-	switch(key_len) {
-	case 16:
-		for (i = 0; i < 9; i++)
-			ke4(ctx->ekey, i);
-		kel4(ctx->ekey, 9);
-		ctx->rounds = 10;
-		break;
-		
-	case 24:
-		ctx->ekey[4] = ss[4] = le32_to_cpu(key[4]);
-		ctx->ekey[5] = ss[5] = le32_to_cpu(key[5]);
-		for (i = 0; i < 7; i++)
-			ke6(ctx->ekey, i);
-		kel6(ctx->ekey, 7); 
-		ctx->rounds = 12;
-		break;
-
-	case 32:
-		ctx->ekey[4] = ss[4] = le32_to_cpu(key[4]);
-		ctx->ekey[5] = ss[5] = le32_to_cpu(key[5]);
-		ctx->ekey[6] = ss[6] = le32_to_cpu(key[6]);
-		ctx->ekey[7] = ss[7] = le32_to_cpu(key[7]);
-		for (i = 0; i < 6; i++)
-			ke8(ctx->ekey, i);
-		kel8(ctx->ekey, 6);
-		ctx->rounds = 14;
-		break;
-
-	default:
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		return -EINVAL;
-	}
-	
-	/* decryption schedule */
-	
-	ctx->dkey[0] = ss[0] = le32_to_cpu(key[0]);
-	ctx->dkey[1] = ss[1] = le32_to_cpu(key[1]);
-	ctx->dkey[2] = ss[2] = le32_to_cpu(key[2]);
-	ctx->dkey[3] = ss[3] = le32_to_cpu(key[3]);
-
-	switch (key_len) {
-	case 16:
-		kdf4(ctx->dkey, 0);
-		for (i = 1; i < 9; i++)
-			kd4(ctx->dkey, i);
-		kdl4(ctx->dkey, 9);
-		break;
-		
-	case 24:
-		ctx->dkey[4] = ff(ss[4] = le32_to_cpu(key[4]));
-		ctx->dkey[5] = ff(ss[5] = le32_to_cpu(key[5]));
-		kdf6(ctx->dkey, 0);
-		for (i = 1; i < 7; i++)
-			kd6(ctx->dkey, i);
-		kdl6(ctx->dkey, 7);
-		break;
-
-	case 32:
-		ctx->dkey[4] = ff(ss[4] = le32_to_cpu(key[4]));
-		ctx->dkey[5] = ff(ss[5] = le32_to_cpu(key[5]));
-		ctx->dkey[6] = ff(ss[6] = le32_to_cpu(key[6]));
-		ctx->dkey[7] = ff(ss[7] = le32_to_cpu(key[7]));
-		kdf8(ctx->dkey, 0);
-		for (i = 1; i < 6; i++)
-			kd8(ctx->dkey, i);
-		kdl8(ctx->dkey, 6);
-		break;
-	}
-	return 0;
-}
-
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	aes_enc_blk(tfm, dst, src);
@@ -479,14 +25,14 @@ static struct crypto_alg aes_alg = {
 	.cra_priority		=	200,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct aes_ctx),
+	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey	   	= 	aes_set_key,
+			.cia_setkey		=	crypto_aes_set_key,
 			.cia_encrypt	 	=	aes_encrypt,
 			.cia_decrypt	  	=	aes_decrypt
 		}
@@ -495,7 +41,6 @@ static struct crypto_alg aes_alg = {
 
 static int __init aes_init(void)
 {
-	gen_tabs();
 	return crypto_register_alg(&aes_alg);
 }
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3f0bc0e..12b4542 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -329,6 +329,7 @@ config CRYPTO_AES_586
 	tristate "AES cipher algorithms (i586)"
 	depends on (X86 || UML_X86) && !64BIT
 	select CRYPTO_ALGAPI
+	select CRYPTO_AES
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
 	  algorithm.
-- 
1.5.3.4
