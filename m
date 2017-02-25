From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Sat, 25 Feb 2017 16:20:22 -0300
Message-ID: <20170225192022.GA18004@gallifrey>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
 <20170223113909.GA14090@gondor.apana.org.au>
 <20170224234400.GA2758@gallifrey>
 <20170225151707.GA28667@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, schwidefsky@de.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36121 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbdBYTVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Feb 2017 14:21:22 -0500
Received: by mail-qk0-f174.google.com with SMTP id x71so49044418qkb.3
        for <linux-crypto@vger.kernel.org>; Sat, 25 Feb 2017 11:20:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170225151707.GA28667@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 25, 2017 at 11:17:07PM +0800, Herbert Xu wrote:
> On Fri, Feb 24, 2017 at 08:44:00PM -0300, Marcelo Cerri wrote:
> >
> > This is probably caused by the way that the xts template is handling the
> > underline algorithm selection.
>=20
> Good catch.  I think the bigger issue here is that when requesting
> for an XTS that doesn't need a fallback we shouldn't be using an
> underlying ECB that needs one.  So this patch should fix the hang.

Yeah, I agree. This should work as long as the module aliases are
correct, which is enough.

Other templates will not trigger the same error since they don't have to
try more than one underlying algorithm. But I think this is still
desirable for the remaining templates to avoid a long chain of unused
fallbacks as in the example I gave in my previous email.

Probably a helper function to return the correct mask might be useful
for readability and to avoid duplicate code.

>=20
> Thanks,
>=20
> ---8<---
> Subject: crypto: xts - Propagate NEED_FALLBACK bit
>=20
> When we're used as a fallback algorithm, we should propagate
> the NEED_FALLBACK bit when searching for the underlying ECB mode.
>=20
> This just happens to fix a hang too because otherwise the search
> may end up loading the same module that triggered this XTS creation.
>=20
> Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
> Reported-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/crypto/xts.c b/crypto/xts.c
> index 410a2e2..2066161 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -463,6 +463,7 @@ static int create(struct crypto_template *tmpl, struc=
t rtattr **tb)
>  	struct xts_instance_ctx *ctx;
>  	struct skcipher_alg *alg;
>  	const char *cipher_name;
> +	u32 mask;
>  	int err;
> =20
>  	algt =3D crypto_get_attr_type(tb);
> @@ -483,18 +484,19 @@ static int create(struct crypto_template *tmpl, str=
uct rtattr **tb)
>  	ctx =3D skcipher_instance_ctx(inst);
> =20
>  	crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
> -	err =3D crypto_grab_skcipher(&ctx->spawn, cipher_name, 0,
> -				   crypto_requires_sync(algt->type,
> -							algt->mask));
> +
> +	mask =3D crypto_requires_sync(algt->type, algt->mask) |
> +	       ((algt->type ^ CRYPTO_ALG_NEED_FALLBACK) & algt->mask &
> +	        CRYPTO_ALG_NEED_FALLBACK);
> +
> +	err =3D crypto_grab_skcipher(&ctx->spawn, cipher_name, 0, mask);
>  	if (err =3D=3D -ENOENT) {
>  		err =3D -ENAMETOOLONG;
>  		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
>  			     cipher_name) >=3D CRYPTO_MAX_ALG_NAME)
>  			goto err_free_inst;
> =20
> -		err =3D crypto_grab_skcipher(&ctx->spawn, ctx->name, 0,
> -					   crypto_requires_sync(algt->type,
> -								algt->mask));
> +		err =3D crypto_grab_skcipher(&ctx->spawn, ctx->name, 0, mask);
>  	}
> =20
>  	if (err)
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--=20
Regards,
Marcelo


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYsdj2AAoJEM8aS8c01e1H9rwIAJgpPGU7A2qhoAPdocJXdmz0
gMmI3piy/CB9poslpisVHO+wG4hRI8otaH5zsdm8Uxypy6L5p7d/8rNlJ+8NsWA/
Du6Mlf4lkWfulc1l5TqsZYgcLf0laK8WNTLBmxWdjIX554irom3Ksdu6UiOZIGfe
FCaA4pmhluizFPepXdxMCtHu3Qvy3mKx6rMKiyCLnXKe3P1CD2WgGL8B+IyZ65iM
AuRPeDJKzRu28hran5t6ma6pvwfaUmVh9w3yHphg6AqPRK4xkSLub3f8UzBzqInS
5CcOXOZAtsyyU3yrjbfPNlLLU1NgMZ4GHVR4vKPsy8ofkFsLg144+XEj5VdntRg=
=Ejgg
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
