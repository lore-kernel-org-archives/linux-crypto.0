From: Huang Ying <ying.huang@intel.com>
Subject: [RFC PATCH crypto 3/4] AES-NI: Make it possible to use
	blkcipher_walk for ablkcipher algorithm
Date: Mon, 05 Jan 2009 10:02:21 +0800
Message-ID: <1231120941.5937.30.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bUmkSVEZ16LgnLvUAQN9"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109AbZAECCY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Jan 2009 21:02:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-bUmkSVEZ16LgnLvUAQN9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Current blkcipher_walk can be used for ablkcipher crypto_tfm +
blkcipher crypto_alg. This patch make it possible to use
blkcipher_walk for ablkcipher algorithm. The only field in
cra_blkcipher used is ivsize, which is wrapped in a function to
support both cra_blkcipher and cra_ablkcipher.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/blkcipher.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -68,6 +68,16 @@ static inline u8 *blkcipher_get_spot(u8=20
 	return max(start, end_page);
 }
=20
+static inline unsigned int blkcipher_walk_ivsize(struct crypto_blkcipher *=
tfm)
+{
+	struct crypto_tfm *tfm_base =3D crypto_blkcipher_tfm(tfm);
+
+	if (crypto_tfm_alg_type(tfm_base) =3D=3D CRYPTO_ALG_TYPE_ABLKCIPHER)
+		return tfm_base->__crt_alg->cra_ablkcipher.ivsize;
+	else
+		return crypto_blkcipher_ivsize(tfm);
+}
+
 static inline unsigned int blkcipher_done_slow(struct crypto_blkcipher *tf=
m,
 					       struct blkcipher_walk *walk,
 					       unsigned int bsize)
@@ -134,7 +144,7 @@ int blkcipher_walk_done(struct blkcipher
=20
 err:
 	if (walk->iv !=3D desc->info)
-		memcpy(desc->info, walk->iv, crypto_blkcipher_ivsize(tfm));
+		memcpy(desc->info, walk->iv, blkcipher_walk_ivsize(tfm));
 	if (walk->buffer !=3D walk->page)
 		kfree(walk->buffer);
 	if (walk->page)
@@ -280,7 +290,7 @@ static inline int blkcipher_copy_iv(stru
 				    unsigned int alignmask)
 {
 	unsigned bs =3D walk->blocksize;
-	unsigned int ivsize =3D crypto_blkcipher_ivsize(tfm);
+	unsigned int ivsize =3D blkcipher_walk_ivsize(tfm);
 	unsigned aligned_bs =3D ALIGN(bs, alignmask + 1);
 	unsigned int size =3D aligned_bs * 2 + ivsize + max(aligned_bs, ivsize) -
 			    (alignmask + 1);


--=-bUmkSVEZ16LgnLvUAQN9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklhaioACgkQKhFGF+eHlpg86ACgjBmBinZtB3F8mkNXfGEhMgSf
WNQAnRgZ21P7DgWy0TJVwdfPWwfzo750
=uc81
-----END PGP SIGNATURE-----

--=-bUmkSVEZ16LgnLvUAQN9--

