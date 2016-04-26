From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] crypto: gcm - Fix rfc4543 decryption crash
Date: Tue, 26 Apr 2016 23:05:48 +0200
Message-ID: <1461704748.5852.18.camel@decadent.org.uk>
References: <20160318144240.GA20816@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SgjgrZYlmCj5zt9cEiYh"
To: Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	patrick.meyer@vasgard.com
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160318144240.GA20816@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-SgjgrZYlmCj5zt9cEiYh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-03-18 at 22:42 +0800, Herbert Xu wrote:
> This bug has already bee fixed upstream since 4.2.=C2=A0=C2=A0However, it
> was fixed during the AEAD conversion so no fix was backported to
> the older kernels.
>=20
> When we do an RFC 4543 decryption, we will end up writing the
> ICV beyond the end of the dst buffer.=C2=A0=C2=A0This should lead to a
> crash but for some reason it was never noticed.
>=20
> This patch fixes it by only writing back the ICV for encryption.
>=20
> Fixes: d733ac90f9fe ("crypto: gcm - fix rfc4543 to handle async...")
> Reported-by: Patrick Meyer <patrick.meyer@vasgard.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Queued up for 3.16, thanks.

Ben.

>=20
> diff --git a/crypto/gcm.c b/crypto/gcm.c
> index b4c2520..cd97cdd 100644
> --- a/crypto/gcm.c
> +++ b/crypto/gcm.c
> @@ -1173,6 +1173,9 @@ static struct aead_request *crypto_rfc4543_crypt(st=
ruct aead_request *req,
> =C2=A0	aead_request_set_tfm(subreq, ctx->child);
> =C2=A0	aead_request_set_callback(subreq, req->base.flags, crypto_rfc4543_=
done,
> =C2=A0				=C2=A0=C2=A0req);
> +	if (!enc)
> +		aead_request_set_callback(subreq, req->base.flags,
> +					=C2=A0=C2=A0req->base.complete, req->base.data);
> =C2=A0	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize,=
 iv);
> =C2=A0	aead_request_set_assoc(subreq, assoc, assoclen);
> =C2=A0
--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u
--=-SgjgrZYlmCj5zt9cEiYh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXH9gsAAoJEOe/yOyVhhEJ5J8QAIJ9hRfHG1ti6hlsc0KxV/gM
Z0f3Td7pszYNcrgAe3JJ5V3Bc2M9/CnYh9i0E+kiXFSdYDKQMQc08Eon8jHFN8ob
e0NOZbcmpHoBDVXn3YO5+ykYmf5WvvIjQrVzuFT10AfzTaJwqjV6HssKp7XPp6Gm
FCocvMYbt/wecjv+GuQGDJBCEVPA3cPTQoTOvijei9D6pFPBUD0SAjBTb0cAGzqc
LuDQZutVjbG5twTvbOWFCazzAeHfN62HFLjdZs3DRW1z91b87bfZaryoxBz9nH80
twuqrO83b71yzn8SovGZeSi9aiUxcAHo66+olDs/wZiIgvH7Xm2IPHWPAGpX/RT6
TjdXsLj1MEAd1ziJTAczaVj8YuA7QiHfSabRx+/CKnoeK/LRG7cV4eYfWpzhS0hr
QomFS7R9ojj1SCEp52D+jP9IZQ/X4gQB/A6Yr5sbOMbfJ0hc04GuV1zO6OUajBck
jZhb1VvHNemKQ3GYHoNrwEMrkMBZrDP1003VAEmEzn/uxL6BmP95Yxid3XaYBU6t
JfpG+KDBCBTJP+QcCZwYrg+tHKHhI7XRE+hkCYbCpbyk22Ca3cc9YI5f0qh/brAX
nX46TV6xTKPauzHemXwNhB2fpvUW2wlCjxgjUbFpSZdSGMbrwAxFr3UuDY4Sjsua
OfElbW7pp18EpX+/X/0J
=GXuQ
-----END PGP SIGNATURE-----

--=-SgjgrZYlmCj5zt9cEiYh--
