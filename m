From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 03/10] crypto: aead: Add aead_request_cast() api
Date: Thu, 2 Jul 2015 02:58:07 -0500
Message-ID: <20150702075807.GC4033@saruman.tx.rr.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-4-git-send-email-lokeshvutla@ti.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435814320-30347-4-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2015 at 10:48:33AM +0530, Lokesh Vutla wrote:
> Add aead_request_cast() api to get pointer to aead_request
> from cryto_async_request.
>=20
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  include/linux/crypto.h |    6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 10df5d2..20fac3d 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -1460,6 +1460,12 @@ static inline void aead_request_set_tfm(struct aea=
d_request *req,
>  	req->base.tfm =3D crypto_aead_tfm(crypto_aead_crt(tfm)->base);
>  }
> =20
> +static inline struct aead_request *aead_request_cast(
> +					struct crypto_async_request *req)
> +{
> +	return container_of(req, struct aead_request, base);

container_of() ensures type safety, this can be a macro just fine.

--=20
balbi

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVlO8PAAoJEIaOsuA1yqREXc4QAIi/b/QQy2Vgnbtlv5mcWZVf
4mSdqEa2BiIJ7JErAjjcmOeDE1RWgwDjdM+FUUUZEH0aQBcM+S2jKONvhuS6g3U2
u5Y7bcRucI5sHfAGxr3t5C4va3FpLNFNgJFolebpc/FuQIqpEjkVM9w60pwMv/86
1OHzTjSWZ5y2+IysboudLhkJp+LH6GE+qgKDU4ovIJFluWHMYSXBn5tHi6uZCdC/
AyeeiBsK5vCzE2OfZrapDh+jbZER/9sFbPxRkOpEysNnNY2cgAz6jkt2Af6B/6S1
LtDRVThcDR+1zKR3ujOQ5lLqBHoLOm7m7yRiUKZ7z1sNDa4vIxeXuhrqKpSWCnNH
4Fpq0OLO/BhBHlGc4elctDD+gSXlQ+XMTuY4fjA6JtHUL1TPBfxdMYFxmT/Y6mrz
NwNvNoJ6xSHAAOzaQ9uNL95OfHu5s0IwpnJ1HMrlQn2RTKnTVJCCk/VcpjkuuvDU
EcyU1dvmT28tZh2mJDMgY1Kj8ZZSbIPk4XIbr1+udR7moGBX7zuN3oHVhLvOtYPR
6IY0WAucWA3TWcR/8GtFLaVzys5xPRQ/EWdBCCHWq45/1L4toMU7tK8u1sLsfbGT
uaq+v4OzRIDoUeHTzKfDpJmTHVqgHI4nT7NtBwhc291jR2Qk0OOaczzBHTWi4lkV
/sVbmAAB/W5dsBgrqCb8
=wOIG
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
