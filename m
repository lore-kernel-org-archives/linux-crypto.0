From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 1/3] crypto: Fix tfm allocation in
	cryptd_alloc_ablkcipher
Date: Mon, 09 Mar 2009 16:52:14 +0800
Message-ID: <1236588734.24215.111.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tpPR5WrC+jf1ZFP/9NFY"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZCIIwS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2009 04:52:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-tpPR5WrC+jf1ZFP/9NFY
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


--=-tpPR5WrC+jf1ZFP/9NFY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm02LoACgkQKhFGF+eHlpg2jwCfRzMjYvG8kGwsjqgsdH+PhwzL
NaAAniyYoSgX4exQfAPD9Te+p/grCdH5
=tG9+
-----END PGP SIGNATURE-----

--=-tpPR5WrC+jf1ZFP/9NFY--

