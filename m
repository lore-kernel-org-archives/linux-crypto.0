From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v3 1/3] crypto: Fix tfm allocation in
	cryptd_alloc_ablkcipher
Date: Wed, 18 Mar 2009 11:21:47 +0800
Message-ID: <1237346507.24215.240.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YdaYaqIwvx3H+jKnEl2I"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11252 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbZCRDVv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2009 23:21:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-YdaYaqIwvx3H+jKnEl2I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Use crypto_alloc_base() instead of crypto_alloc_ablkcipher() to
allocate underlying tfm in cryptd_alloc_ablkcipher. Because
crypto_alloc_ablkcipher() prefer GENIV encapsulated crypto instead of
raw one, while cryptd_alloc_ablkcipher needed the raw one.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -586,20 +586,24 @@ struct cryptd_ablkcipher *cryptd_alloc_a
 						  u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
-	struct crypto_ablkcipher *tfm;
+	struct crypto_tfm *tfm;
=20
 	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
 		     "cryptd(%s)", alg_name) >=3D CRYPTO_MAX_ALG_NAME)
 		return ERR_PTR(-EINVAL);
-	tfm =3D crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
+	type &=3D ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type |=3D CRYPTO_ALG_TYPE_BLKCIPHER;
+	mask &=3D ~CRYPTO_ALG_TYPE_MASK;
+	mask |=3D (CRYPTO_ALG_GENIV | CRYPTO_ALG_TYPE_BLKCIPHER_MASK);
+	tfm =3D crypto_alloc_base(cryptd_alg_name, type, mask);
 	if (IS_ERR(tfm))
 		return ERR_CAST(tfm);
-	if (crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D THIS_MODULE) {
-		crypto_free_ablkcipher(tfm);
+	if (tfm->__crt_alg->cra_module !=3D THIS_MODULE) {
+		crypto_free_tfm(tfm);
 		return ERR_PTR(-EINVAL);
 	}
=20
-	return __cryptd_ablkcipher_cast(tfm);
+	return __cryptd_ablkcipher_cast(__crypto_ablkcipher_cast(tfm));
 }
 EXPORT_SYMBOL_GPL(cryptd_alloc_ablkcipher);
=20


--=-YdaYaqIwvx3H+jKnEl2I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknAaMMACgkQKhFGF+eHlpj1BwCgmeqnAcM+0Hpj8baMdsx/Vl3M
aJkAoJIKnxMdnFOx7q1PbrGma9enPs+B
=Ds/H
-----END PGP SIGNATURE-----

--=-YdaYaqIwvx3H+jKnEl2I--

