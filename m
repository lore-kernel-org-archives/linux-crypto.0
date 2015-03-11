From: Alexander Bergmann <abergmann@suse.com>
Subject: [PATCH] crypto: testmgr - fix RNG return code enforcement
Date: Wed, 11 Mar 2015 13:11:07 +0100
Message-ID: <20150311121107.GY786@surtsey.monkey.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="15rqq6UvmZq3FwB1"
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbbCKMNR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 08:13:17 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--15rqq6UvmZq3FwB1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom 0c7233769665f03e9f91342770dba7279f928c23 Mon Sep 17 00:00:00 2001
=46rom: Stephan Mueller <smueller@chronox.de>
Date: Tue, 10 Mar 2015 17:00:36 +0100
Subject: [PATCH] crypto: testmgr - fix RNG return code enforcement

Due to the change to RNGs to always return zero in success case, the
invocation of the RNGs in the test manager must be updated as otherwise
the RNG self tests are not properly executed any more.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Alexander Bergmann <abergmann@suse.com>
---
 crypto/testmgr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f4ed6d4..1f879ad 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1474,11 +1474,11 @@ static int test_cprng(struct crypto_rng *tfm, struc=
t cprng_testvec *template,
 		for (j =3D 0; j < template[i].loops; j++) {
 			err =3D crypto_rng_get_bytes(tfm, result,
 						   template[i].rlen);
-			if (err !=3D template[i].rlen) {
+			if (err < 0) {
 				printk(KERN_ERR "alg: cprng: Failed to obtain "
 				       "the correct amount of random data for "
-				       "%s (requested %d, got %d)\n", algo,
-				       template[i].rlen, err);
+				       "%s (requested %d)\n", algo,
+				       template[i].rlen);
 				goto out;
 			}
 		}
@@ -1759,7 +1759,7 @@ static int drbg_cavs_test(struct drbg_testvec *test, =
int pr,
 		ret =3D crypto_drbg_get_bytes_addtl(drng,
 			buf, test->expectedlen, &addtl);
 	}
-	if (ret <=3D 0) {
+	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
@@ -1774,7 +1774,7 @@ static int drbg_cavs_test(struct drbg_testvec *test, =
int pr,
 		ret =3D crypto_drbg_get_bytes_addtl(drng,
 			buf, test->expectedlen, &addtl);
 	}
-	if (ret <=3D 0) {
+	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
--=20
1.8.1.4

--=20
Alexander Bergmann <abergmann@suse.com>, Security Engineer,
SUSE Linux GmbH,
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton, HRB 21284 (AG N=FCrnberg)

--15rqq6UvmZq3FwB1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJVADDbAAoJEN5U6HWf+kiGifgIALFee9/OhsrAmyX3Y7YBZgwV
/KtCVowFqbc7EgqJZUhM8JAm78r4Oh7D7sg/t9wV+Co4UCU9NbgYWM+lA2r1VEMF
CuS5Z6MGotP4yqI8SpFjdlR4Dj/dU5dWJS5RfUyggC571p00hBslXHmB2C6/CsSu
H9OmSuwZMUcTIJi1BTvrfGen0HrVrYGvFmwkdYp8zio9ADnY7nL1rBN4o+jPBa2t
rQw/U/nlKjbP1kMM3NJNubp0RviKVj+O8LTTJq1nyEVp+C+6LVps6iHBxuc+0Gw+
uuwKOTuM6rqD+dhBTX91pzwJoJ35yqa7x415IdO8hVLFmIGnCWFOyq/OZJqG8Lo=
=BLel
-----END PGP SIGNATURE-----

--15rqq6UvmZq3FwB1--
