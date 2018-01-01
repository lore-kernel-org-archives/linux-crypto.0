From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: [PATCH] crypto: testmgr: change `guard` to unsigned char
Date: Mon, 1 Jan 2018 00:33:19 -1000
Message-ID: <20180101103319.fmmlpeg6kjdmhloq@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ggxylk6lfsot3643"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org,
        Joey Pabalinas <joeypabalinas@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--ggxylk6lfsot3643
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

When char is signed, storing the values 0xba (186) and 0xad (173) in the
`guard` array produces signed overflow. Change the type of `guard` to
unsigned char to remove undefined behavior.

Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 29d7020b8826faa3f0..e9a9faecf212bbd742 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -185,7 +185,7 @@ static int ahash_partial_update(struct ahash_request **=
preq,
 	char *state;
 	struct ahash_request *req;
 	int statesize, ret =3D -EINVAL;
-	const char guard[] =3D { 0x00, 0xba, 0xad, 0x00 };
+	const unsigned char guard[] =3D { 0x00, 0xba, 0xad, 0x00 };
=20
 	req =3D *preq;
 	statesize =3D crypto_ahash_statesize(
--=20
2.15.1

--ggxylk6lfsot3643
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKlZXrihdNOcUPZTNruvLfWhyVBkFAlpKDm8ACgkQruvLfWhy
VBlbLxAArzWc5P79Hj7a8onxv/tFYkTcFBsej0PNmaZY8I640FuB1DHwkQNAdZP+
nXOfZ/x5F6f6I+LTk4JoSXbtxObtbk24OWKEnSabwXkCRKHRfYIx/5xvPZIMjyAL
wEEuwe3NQOVq9+WY5lqgv+ln7Cie3kNd2P48xTBaDbPTmv0vWcCa3brHvNIh1+w0
ZhfjLN0zm+TIPDY9Nj7hdPN5EAAts/mAM/CHtr/nvD1WL0oqqxzR7SBxBLChx11Z
ww3huwXQCgQcBTSWDzLFleW4AKqXhByXClYZYyTHpRTRX5LwxwZhYhT49Je25MZ0
MQ46/CyxvUIThpOAsrjk8ormTlp+OJDtWeB7XTLg36/I1kcSWANViH24mcuIclzQ
4BQhtUIHHHaBmxBYa7Df3gvuZNd2BcEDSXwWwnPo493XqMIkyH7aGbpdM9j66KS/
ORnaxBj7Ra+MdSUw7BkEXb9LgXc2+FdzfJyAMQVITWW//7D4PygKGZpqYYfpG9No
uYFtUwXzUPF4dKKXDk2kq/gyTj36W6fNLdV/gSfAI97gpFIlytFtuC25BzoSMs60
GnkImvI/SVEhPhxofvOQGb/G0NravkZv6NO5jVCt8FlDxMmB19JA5CyoBfm4bpe2
GrywwbenpwV9Y9m9bdCE8uEgbX9tFtoFlUbcVVB2NlrZzesuD9A=
=ZfgA
-----END PGP SIGNATURE-----

--ggxylk6lfsot3643--
