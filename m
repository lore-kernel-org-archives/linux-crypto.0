From: Huang Ying <ying.huang@intel.com>
Subject: [RFC PATCH crypto 1/4] AES-NI: Move key_length in struct
	crypto_aes_ctx to be the last field
Date: Mon, 05 Jan 2009 10:02:07 +0800
Message-ID: <1231120927.5937.26.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m7rYrI7bqU9HPY22dook"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZAECCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Jan 2009 21:02:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-m7rYrI7bqU9HPY22dook
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The Intel AES-NI AES acceleration instructions need key_enc, key_dec
in struct crypto_aes_ctx to be 16 byte aligned, it make this easier to
move key_length to be the last one.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aes-i586-asm_32.S   |    6 +++---
 arch/x86/crypto/aes-x86_64-asm_64.S |    4 ++--
 include/crypto/aes.h                |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/crypto/aes-i586-asm_32.S
+++ b/arch/x86/crypto/aes-i586-asm_32.S
@@ -46,9 +46,9 @@
 #define in_blk 16
=20
 /* offsets in crypto_tfm structure */
-#define klen (crypto_tfm_ctx_offset + 0)
-#define ekey (crypto_tfm_ctx_offset + 4)
-#define dkey (crypto_tfm_ctx_offset + 244)
+#define klen (crypto_tfm_ctx_offset + 480)
+#define ekey (crypto_tfm_ctx_offset + 0)
+#define dkey (crypto_tfm_ctx_offset + 240)
=20
 // register mapping for encrypt and decrypt subroutines
=20
--- a/arch/x86/crypto/aes-x86_64-asm_64.S
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -56,13 +56,13 @@
 	.align	8;			\
 FUNC:	movq	r1,r2;			\
 	movq	r3,r4;			\
-	leaq	BASE+KEY+48+4(r8),r9;	\
+	leaq	BASE+KEY+48(r8),r9;	\
 	movq	r10,r11;		\
 	movl	(r7),r5 ## E;		\
 	movl	4(r7),r1 ## E;		\
 	movl	8(r7),r6 ## E;		\
 	movl	12(r7),r7 ## E;		\
-	movl	BASE+0(r8),r10 ## E;	\
+	movl	BASE+480(r8),r10 ## E;	\
 	xorl	-48(r9),r5 ## E;	\
 	xorl	-44(r9),r1 ## E;	\
 	xorl	-40(r9),r6 ## E;	\
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -18,9 +18,9 @@
 #define AES_MAX_KEYLENGTH_U32	(AES_MAX_KEYLENGTH / sizeof(u32))
=20
 struct crypto_aes_ctx {
-	u32 key_length;
 	u32 key_enc[AES_MAX_KEYLENGTH_U32];
 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
+	u32 key_length;
 };
=20
 extern const u32 crypto_ft_tab[4][256];


--=-m7rYrI7bqU9HPY22dook
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklhahsACgkQKhFGF+eHlpgGVwCeOZ4tzLK4yZdci2GrtiUDvwvl
ftMAn0+ekkPjgiXNwapfGatZCHzGnlrK
=Yb/g
-----END PGP SIGNATURE-----

--=-m7rYrI7bqU9HPY22dook--

