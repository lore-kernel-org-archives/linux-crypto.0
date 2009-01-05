From: Huang Ying <ying.huang@intel.com>
Subject: [RFC PATCH crypto 2/4] AES-NI: Export x86 AES encrypt/decrypt
	functions
Date: Mon, 05 Jan 2009 10:02:15 +0800
Message-ID: <1231120935.5937.29.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5wWxStMPzkVFNDLwdUit"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8019 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZAECCT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Jan 2009 21:02:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-5wWxStMPzkVFNDLwdUit
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Export x86 AES encrypt/decrypt functions

Intel AES-NI AES acceleration instructions touch XMM state, to use
that in soft_irq context, general x86 AES implementation is used as
fallback. The first parameter is changed from struct crypto_tfm * to
struct crypto_aes_ctx * to make it easier to deal with 16 bytes
alignment requirement of AES-NI implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aes-i586-asm_32.S   |   18 +++++++++---------
 arch/x86/crypto/aes-x86_64-asm_64.S |    6 ++----
 arch/x86/crypto/aes_glue.c          |   20 ++++++++++++++++----
 arch/x86/include/asm/aes.h          |   11 +++++++++++
 4 files changed, 38 insertions(+), 17 deletions(-)

--- /dev/null
+++ b/arch/x86/include/asm/aes.h
@@ -0,0 +1,11 @@
+#ifndef ASM_X86_AES_H
+#define ASM_X86_AES_H
+
+#include <linux/crypto.h>
+#include <crypto/aes.h>
+
+void crypto_aes_encrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
+			    const u8 *src);
+void crypto_aes_decrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
+			    const u8 *src);
+#endif
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -5,17 +5,29 @@
=20
 #include <crypto/aes.h>
=20
-asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in)=
;
-asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in)=
;
+asmlinkage void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 =
*in);
+asmlinkage void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 =
*in);
+
+void crypto_aes_encrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst, const u8 =
*src)
+{
+	aes_enc_blk(ctx, dst, src);
+}
+EXPORT_SYMBOL_GPL(crypto_aes_encrypt_x86);
+
+void crypto_aes_decrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst, const u8 =
*src)
+{
+	aes_dec_blk(ctx, dst, src);
+}
+EXPORT_SYMBOL_GPL(crypto_aes_decrypt_x86);
=20
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
-	aes_enc_blk(tfm, dst, src);
+	aes_enc_blk(crypto_tfm_ctx(tfm), dst, src);
 }
=20
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
-	aes_dec_blk(tfm, dst, src);
+	aes_dec_blk(crypto_tfm_ctx(tfm), dst, src);
 }
=20
 static struct crypto_alg aes_alg =3D {
--- a/arch/x86/crypto/aes-i586-asm_32.S
+++ b/arch/x86/crypto/aes-i586-asm_32.S
@@ -41,14 +41,14 @@
 #define tlen 1024   // length of each of 4 'xor' arrays (256 32-bit words)
=20
 /* offsets to parameters with one register pushed onto stack */
-#define tfm 8
+#define ctx 8
 #define out_blk 12
 #define in_blk 16
=20
-/* offsets in crypto_tfm structure */
-#define klen (crypto_tfm_ctx_offset + 480)
-#define ekey (crypto_tfm_ctx_offset + 0)
-#define dkey (crypto_tfm_ctx_offset + 240)
+/* offsets in crypto_aes_ctx structure */
+#define klen (480)
+#define ekey (0)
+#define dkey (240)
=20
 // register mapping for encrypt and decrypt subroutines
=20
@@ -217,7 +217,7 @@
 	do_col (table, r5,r0,r1,r4, r2,r3);		/* idx=3Dr5 */
=20
 // AES (Rijndael) Encryption Subroutine
-/* void aes_enc_blk(struct crypto_tfm *tfm, u8 *out_blk, const u8 *in_blk)=
 */
+/* void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out_blk, const u8 *in_=
blk) */
=20
 .global  aes_enc_blk
=20
@@ -228,7 +228,7 @@
=20
 aes_enc_blk:
 	push    %ebp
-	mov     tfm(%esp),%ebp
+	mov     ctx(%esp),%ebp
=20
 // CAUTION: the order and the values used in these assigns=20
 // rely on the register mappings
@@ -292,7 +292,7 @@ aes_enc_blk:
 	ret
=20
 // AES (Rijndael) Decryption Subroutine
-/* void aes_dec_blk(struct crypto_tfm *tfm, u8 *out_blk, const u8 *in_blk)=
 */
+/* void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out_blk, const u8 *in_=
blk) */
=20
 .global  aes_dec_blk
=20
@@ -303,7 +303,7 @@ aes_enc_blk:
=20
 aes_dec_blk:
 	push    %ebp
-	mov     tfm(%esp),%ebp
+	mov     ctx(%esp),%ebp
=20
 // CAUTION: the order and the values used in these assigns=20
 // rely on the register mappings
--- a/arch/x86/crypto/aes-x86_64-asm_64.S
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -17,8 +17,6 @@
=20
 #include <asm/asm-offsets.h>
=20
-#define BASE crypto_tfm_ctx_offset
-
 #define R1	%rax
 #define R1E	%eax
 #define R1X	%ax
@@ -56,13 +54,13 @@
 	.align	8;			\
 FUNC:	movq	r1,r2;			\
 	movq	r3,r4;			\
-	leaq	BASE+KEY+48(r8),r9;	\
+	leaq	KEY+48(r8),r9;		\
 	movq	r10,r11;		\
 	movl	(r7),r5 ## E;		\
 	movl	4(r7),r1 ## E;		\
 	movl	8(r7),r6 ## E;		\
 	movl	12(r7),r7 ## E;		\
-	movl	BASE+480(r8),r10 ## E;	\
+	movl	480(r8),r10 ## E;	\
 	xorl	-48(r9),r5 ## E;	\
 	xorl	-44(r9),r1 ## E;	\
 	xorl	-40(r9),r6 ## E;	\


--=-5wWxStMPzkVFNDLwdUit
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklhaiMACgkQKhFGF+eHlpiGJgCfbOifExanfmEYmq5qFDeDZDoi
cNUAnirW76LxMokwkxD8K1vkdRi/aY2i
=yaGn
-----END PGP SIGNATURE-----

--=-5wWxStMPzkVFNDLwdUit--

