From: Huang Ying <ying.huang@intel.com>
Subject: Re: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Tue, 23 Dec 2008 16:49:26 +0800
Message-ID: <1230022166.17529.82.camel@yhuang-dev.sh.intel.com>
References: <20081219202603.GA31265@lst.de>
	 <20081220032159.GA15615@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8G5jBxXbDXe9INQEHVIB"
Cc: Christoph Hellwig <hch@lst.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56380 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYLWIt3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2008 03:49:29 -0500
In-Reply-To: <20081220032159.GA15615@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-8G5jBxXbDXe9INQEHVIB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-20 at 11:21 +0800, Herbert Xu wrote:
> Weird.  I've got exactly the same versions as you, using yesterday's
> Linus git tree, and it works just fine on a Core 2 Quad Q6600.  From
> /proc/crypto after boot:
>=20
> name         : aes
> driver       : aes-asm
> module       : aes_x86_64
> priority     : 200
> refcnt       : 1
> selftest     : passed
> type         : cipher
> blocksize    : 16
> min keysize  : 16
> max keysize  : 32
>=20
> name         : aes
> driver       : aes-generic
> module       : aes_generic
> priority     : 100
> refcnt       : 1
> selftest     : passed
> type         : cipher
> blocksize    : 16
> min keysize  : 16
> max keysize  : 32
>=20
> Are you in 64-bit mode or legacy mode? I'm in 64.

I get the same error on 64-bit mode. If aes_x86_64 is compiled as
module, everything is OK. But if it is compiled as built-in, the error
message print during system boot. Because aes_x86_64 may be registered
before aes_generic, but the tables used by AES have not been generated
when aes_x86_64 is registered.

This can be resolved by the following patch.
------------------------------------------------------------------->
Fix a bug of aes_x86_64, aes_generic initialization order issue.

If aes_x86_64 and aes_generic are compiled as builtin, the
initialization order is undetermined. That is, aes_x86_64 may be
initilized before aes_generic is initilized, but aes_x86_64 depends on
tables generated in aes_generic initialization code. aes_x86_64 can
not work before aes_generic is initialized, so that cause register
time testing failed with following error message:

[    0.657034] alg: cipher: Test 1 failed on encryption for aes-asm
[    0.657111] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08=20

This patch fixes this bug via making crypto_aes_gen_tabs public and
invoking it in aes_x86_64 and aes_generic.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aes_glue.c |    1 +
 crypto/aes_generic.c       |   20 +++++++++++++++++++-
 include/crypto/aes.h       |    1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -157,6 +157,24 @@ static void __init gen_tabs(void)
 	}
 }
=20
+/*
+ * gen_tabs() will only be called from init sectoin. Named to *_ops to
+ * avoid unnecessary section mismatch warning.
+ */
+static void (*gen_tabs_ops)(void) =3D gen_tabs;
+
+/**
+ * crypto_aes_gen_tabs - Generate tables for AES algorithm
+ */
+void crypto_aes_gen_tabs(void)
+{
+	if (gen_tabs_ops) {
+		gen_tabs_ops();
+		gen_tabs_ops =3D NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(crypto_aes_gen_tabs);
+
 /* initialise the key schedule from the user supplied key */
=20
 #define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) *=
 0x1b)
@@ -491,7 +509,7 @@ static struct crypto_alg aes_alg =3D {
=20
 static int __init aes_init(void)
 {
-	gen_tabs();
+	crypto_aes_gen_tabs();
 	return crypto_register_alg(&aes_alg);
 }
=20
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -28,6 +28,7 @@ extern u32 crypto_fl_tab[4][256];
 extern u32 crypto_it_tab[4][256];
 extern u32 crypto_il_tab[4][256];
=20
+void crypto_aes_gen_tabs(void);
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
 int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -40,6 +40,7 @@ static struct crypto_alg aes_alg =3D {
=20
 static int __init aes_init(void)
 {
+	crypto_aes_gen_tabs();
 	return crypto_register_alg(&aes_alg);
 }
=20


--=-8G5jBxXbDXe9INQEHVIB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklQpg8ACgkQKhFGF+eHlpjnfQCeOoqKJcqsdAWIYqGiqa2pFhx0
W3UAoKSbnkEwDe89U4SEjPMYevst+ZmW
=Olpx
-----END PGP SIGNATURE-----

--=-8G5jBxXbDXe9INQEHVIB--

