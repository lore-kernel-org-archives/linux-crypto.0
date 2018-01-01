From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: [PATCH v2] crypto: testmgr: change `guard` to unsigned char
Date: Mon, 1 Jan 2018 10:40:14 -1000
Message-ID: <20180101204014.643vntmxqdbfqmvb@gmail.com>
References: <20180101103319.fmmlpeg6kjdmhloq@gmail.com>
 <1514819026.1967.37.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7ihfx5dpudnfdo2m"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org,
        Joey Pabalinas <joeypabalinas@gmail.com>
To: Joe Perches <joe@perches.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:39400 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbeAAUkR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jan 2018 15:40:17 -0500
Content-Disposition: inline
In-Reply-To: <1514819026.1967.37.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--7ihfx5dpudnfdo2m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

When char is signed, storing the values 0xba (186) and 0xad (173) in the
`guard` array produces signed overflow. Change the type of `guard` to
static unsigned char to correct undefined behavior and reduce function
stack usage.

Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 29d7020b8826faa3f0..44a85d4b3561acbca6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -185,7 +185,7 @@ static int ahash_partial_update(struct ahash_request **=
preq,
 	char *state;
 	struct ahash_request *req;
 	int statesize, ret =3D -EINVAL;
-	const char guard[] =3D { 0x00, 0xba, 0xad, 0x00 };
+	static const unsigned char guard[] =3D { 0x00, 0xba, 0xad, 0x00 };
=20
 	req =3D *preq;
 	statesize =3D crypto_ahash_statesize(
--=20
2.15.1

--7ihfx5dpudnfdo2m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKlZXrihdNOcUPZTNruvLfWhyVBkFAlpKnK4ACgkQruvLfWhy
VBlUfA/7B4AWBNB+yrkSotHbySPpX4Z6NO8jojDuOk1Ef/ji0qcwAZZPjS7sO8sx
7aEngOlXwh8mmBgxtRP/ftRId9mUNhLhsPGwV5XLftZuvpToFezjm83gvLcitbD1
i42mj4EjVhHc27HBhlNzqA3r/iDUrmuvQAOPt06IMdIBuim3NhIHGrBFNVq4a8Aw
b6wxeBA2hyzQ5TgCNUYTs5AQa8y6qQiLxp8VKimW5yCmmpU7lwJf8u5E6uxSAvnT
xrh/ByN33DFj0aH255lMi4HVdiF2ofbfGDwTyqxI6Mqv/px9eG2/O+/Hv+2l6AZT
XvOQxWNWrrC+TB87vQmJCbwSk3iAXHuLN1uBO85A+SG8W+KPgkvyPFadUuQ9vsuf
4Ctdc2iZI8AJYhaNfKY1jjiTxL/hPsl7Qsgb948BHJACp7Sv5Ng8UFaEHJAYOnE9
py2mx7pUQu/67sa/Hn3DoOq2sr6g0OaCBXFYsW50KSEV7cD0rtIxKWYdgp/ySaLK
vMo2BtOThhHD1xKYZcxafGUbJks9PiJtjMQww3kKcS4e8VkWIiBsbVDpz6JL0bCN
UxBSmHzRy92GiwQeU8vWx6nsW9fJCzSgpb1Z8Db0hZUVHeSmNn04JQmbvTTw8SKt
89WUTFx3uRXTN11/8ZhAVHe52vzAMK9ZPiZD8Jci07QGgsApxr0=
=g1hN
-----END PGP SIGNATURE-----

--7ihfx5dpudnfdo2m--
