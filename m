From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: potential bug in GMAC implementation. not work in ESN mode
Date: Tue, 26 Mar 2013 22:16:21 +0200
Message-ID: <51520215.4020300@iki.fi>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C58F28@RockMX01.rock.corp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2DQBWJGTRHQHRAAPUNTCD"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:34545 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3CZUQe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Mar 2013 16:16:34 -0400
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C58F28@RockMX01.rock.corp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2DQBWJGTRHQHRAAPUNTCD
Content-Type: multipart/mixed;
 boundary="------------040601060408020603010807"

This is a multi-part message in MIME format.
--------------040601060408020603010807
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25.03.2013 18:12, Chaoxing Lin wrote:
> 2nd ping....
>=20
> Nobody is maintaining crypto/gcm.c?
>=20
>=20
>=20
> -----Original Message-----
> From: Chaoxing Lin=20
> Sent: Friday, March 08, 2013 11:38 AM
> To: 'linux-crypto@vger.kernel.org'
> Subject: potential bug in GMAC implementation. not work in ESN mode
>=20
> I was testing ipsec with GMAC and found that the rfc4543 GMAC implement=
ation in kernel software crypto work in "esp=3Daes256gmac-noesn!" mode.
> It does not work in in "esp=3Daes256gmac-esn!" mode. The tunnel was est=
ablished but no data traffic is possible.
>=20
> Looking at source code, I found this piece of code is suspicious.
> Line 1146~1147 tries to put req->assoc to assoc[1]. But I think this wa=
y only works when req->assoc has only one segment. In ESN mode, req->asso=
c contains 3 segments (SPI, SN-hi, SN-low). Line 1146~1147 will only atta=
ch SPI segment(with total length) in assoc.
>=20
> Please let me know whether I understand it right.

Your analysis seems correct. Does attached the patch fix the problem? (I'=
ve only compile tested it.)

-Jussi

> Thanks,
>=20
> Chaoxing
>=20
>=20
> Source from kernel 3.8.2
> path: root/crypto/gcm.c
>=20
> 1136: /* construct the aad */
> 1137:	dstp =3D sg_page(dst);
> 	vdst =3D PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
>=20
> 	sg_init_table(payload, 2);
> 	sg_set_buf(payload, req->iv, 8);
> 	scatterwalk_crypto_chain(payload, dst, vdst =3D=3D req->iv + 8, 2);
> 	assoclen +=3D 8 + req->cryptlen - (enc ? 0 : authsize);
>=20
> 	sg_init_table(assoc, 2);
> 1146:	sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
> 1147:		    req->assoc->offset);
> 	scatterwalk_crypto_chain(assoc, payload, 0, 2);
>=20
> 	aead_request_set_tfm(subreq, ctx->child);
> 	aead_request_set_callback(subreq, req->base.flags, req->base.complete,=

> 				  req->base.data);
> 	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize, iv)=
;
> 1154:	aead_request_set_assoc(subreq, assoc, assoclen);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--------------040601060408020603010807
Content-Type: text/x-patch;
 name="10-gcm-fix-assumption-that-assoc-has-one-segment.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="10-gcm-fix-assumption-that-assoc-has-one-segment.patch"

crypto: gcm - fix assumption that assoc has one segment

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/gcm.c    |   17 ++++++++++++++---
 crypto/tcrypt.c |    4 ++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 137ad1e..13ccbda 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -44,6 +44,7 @@ struct crypto_rfc4543_ctx {
=20
 struct crypto_rfc4543_req_ctx {
 	u8 auth_tag[16];
+	u8 assocbuf[32];
 	struct scatterlist cipher[1];
 	struct scatterlist payload[2];
 	struct scatterlist assoc[2];
@@ -1133,9 +1134,19 @@ static struct aead_request *crypto_rfc4543_crypt(s=
truct aead_request *req,
 	scatterwalk_crypto_chain(payload, dst, vdst =3D=3D req->iv + 8, 2);
 	assoclen +=3D 8 + req->cryptlen - (enc ? 0 : authsize);
=20
-	sg_init_table(assoc, 2);
-	sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
-		    req->assoc->offset);
+	if (req->assoc->length =3D=3D req->assoclen) {
+		sg_init_table(assoc, 2);
+		sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
+			    req->assoc->offset);
+	} else {
+		BUG_ON(req->assoclen > sizeof(rctx->assocbuf));
+
+		scatterwalk_map_and_copy(rctx->assocbuf, req->assoc, 0,
+					 req->assoclen, 0);
+
+		sg_init_table(assoc, 2);
+		sg_set_buf(assoc, rctx->assocbuf, req->assoclen);
+	}
 	scatterwalk_crypto_chain(assoc, payload, 0, 2);
=20
 	aead_request_set_tfm(subreq, ctx->child);
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 87ef7d6..6b911ef 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1225,6 +1225,10 @@ static int do_test(int m)
 		ret +=3D tcrypt_test("rfc4106(gcm(aes))");
 		break;
=20
+	case 152:
+		ret +=3D tcrypt_test("rfc4543(gcm(aes))");
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);

--------------040601060408020603010807--

------enig2DQBWJGTRHQHRAAPUNTCD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBCAAGBQJRUgIbAAoJEAaL+yOpMWaGEJAMAJtsiSjdpTvr4XT7qIiruYGZ
eKGI6QUVyJEa2aq79awY3dHkWiyVYxto1xjc8QzuHwfyjbqWoclqmIulsX4jngiE
K8l7xXD4CtJlKN+83YbsM0aTgDFzS5rUfuLUUVevPgxtzEmwmOvWJBEqZigXgvY9
W+gw42ZVl7lrbyjNC+b43oPrUQx4rqIb4oH64cZL3UuAkmbLSZVAr2etEXi1BGK2
OUgLZw/VRSoqZ5XpRsf2t6TWd1K7RUUi3JvcQOD6uInjMts9M0cfMl8DKwFEwmA1
Jx4RrgxwmJfGLbPgyvNpebdXx63IKpXv/voSlrrKG7xfRVnEkA4xC7ILufcrNKAB
6yIPdcpji4vIBMMs+IiWje9/n5IgrcZJfT3Tk9dzmL1YZ8slyyLkrsN4yAvkPJ8z
IaloEivzMlnoTcZx7RZqYk736Ugp4bSt7TIxotIh1UUd1U5qu+8wcZ10SglEr6hJ
ZU2RxixmNpP0f/4P228NpRk8qN+jqCwCZBVv8JQM/w==
=jbwm
-----END PGP SIGNATURE-----

------enig2DQBWJGTRHQHRAAPUNTCD--
