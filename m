Return-Path: <SRS0=MPTL=A2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE97DC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF42F20657
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgGONRQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:17:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47097 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgGONRQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jul 2020 09:17:16 -0400
Received: from mail-qv1-f71.google.com ([209.85.219.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jvhHd-0001SF-Ih
        for linux-crypto@vger.kernel.org; Wed, 15 Jul 2020 13:17:13 +0000
Received: by mail-qv1-f71.google.com with SMTP id j18so1304785qvk.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2020 06:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fzvg4FJ5nDPHzhIwTMam7V3XpVmbUvLGytN6+0UR7gE=;
        b=pCmofSXa1dWdOcRK6rqjyKWLgOcNEB0VyvoZtWDApbZgkb3ewsMYhIu5p2Qd2lFQME
         A0O4IOFEsM8HASm12MDkPKdJ1JtBKYSwpWvX7SVV8mwCOsQXluS6r05TjjYy7DFOSPqj
         WdQ9rr7SFURpynJrF+yeYl3Q6OmqcYJfJcqRfq5AEa/2+HfSGS01drB4RSiWJwwqxVsS
         ddZIAWal5rmEWqcO7yrzazUrfj9s6ZFcKp9gmLZiS4ZeVyd1nw9czJBZdl89XGCdzpG9
         uXEL0bpobrlJOkGjDzXcrJ9OVnZhrC1HBd5MlYg/1awGm6DpcIOz7rCcb57YWY8P9SD4
         NmWg==
X-Gm-Message-State: AOAM5329d6NTxVf9e9R/MTDqAFd1OJ0Q+2yXgeuplk48+UfWkDA79eha
        W9jh4t0u9ixRyknbvdnpBK6+Pfexu3kOVo7aXChlUrtZEsuApH2aztH8LY3lVz9fCSmCN2dRsK8
        mRIdoxIs6YSL2bl/g7oiITnf5SB3dbIA0mAen9xA1
X-Received: by 2002:a05:6214:4c4:: with SMTP id ck4mr9631171qvb.202.1594819031968;
        Wed, 15 Jul 2020 06:17:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBMy/Nec+jimavNh5Ue9LiYLy9rNN7nMmdV9tZhUUPp9O3q7IXI0k1jEn7nckwN9rGgRrlvQ==
X-Received: by 2002:a05:6214:4c4:: with SMTP id ck4mr9631127qvb.202.1594819031468;
        Wed, 15 Jul 2020 06:17:11 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:b5be:949b:8e92:2f08])
        by smtp.gmail.com with ESMTPSA id c27sm2378896qka.23.2020.07.15.06.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:17:09 -0700 (PDT)
Date:   Wed, 15 Jul 2020 10:17:03 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 1/5] crypto: ECDH - check validity of Z before export
Message-ID: <20200715131703.ig27p5f7thuf5gjr@valinor>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4348752.LvFx2qVVIh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vj5zeh2cohrjjqqm"
Content-Disposition: inline
In-Reply-To: <4348752.LvFx2qVVIh@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--vj5zeh2cohrjjqqm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

On Sun, Jul 12, 2020 at 06:39:26PM +0200, Stephan M=FCller wrote:
> SP800-56A rev3 section 5.7.1.2 step 2 mandates that the validity of the
> calculated shared secret is verified before the data is returned to the
> caller. Thus, the export function and the validity check functions are
> reversed. In addition, the sensitive variables of priv and rand_z are
> zeroized.
>=20
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/ecc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 02d35be7702b..52e2d49262f2 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1495,11 +1495,16 @@ int crypto_ecdh_shared_secret(unsigned int curve_=
id, unsigned int ndigits,
> =20
>  	ecc_point_mult(product, pk, priv, rand_z, curve, ndigits);
> =20
> -	ecc_swap_digits(product->x, secret, ndigits);
> -
> -	if (ecc_point_is_zero(product))
> +	if (ecc_point_is_zero(product)) {
>  		ret =3D -EFAULT;
> +		goto err_validity;
> +	}
> +
> +	ecc_swap_digits(product->x, secret, ndigits);
> =20
> +err_validity:
> +	memzero_explicit(priv, sizeof(priv));
> +	memzero_explicit(rand_z, sizeof(rand_z));
>  	ecc_free_point(product);
>  err_alloc_product:
>  	ecc_free_point(pk);
> --=20
> 2.26.2
>=20
>=20
>=20
>=20

--=20
Regards,
Marcelo


--vj5zeh2cohrjjqqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8PAc8ACgkQ6e82Loes
sAl/Wgv/eAJoM8sE0bIT0lK/24WjEqaL3WDXl7v9w/0guCtXuihopHUEV1KKiUUH
WMtF6V65X9LPmuwX4S3hjhCXv8d2X/X8sMKBRiWk2XzsJp4DGth3bZU/r0REBwNz
rq/cqLmNxK82Jq7BoHK8Emw4C+fZnIQ4Ocwj5Vt58KOu+k05WkDaPaMvcC9e1yR1
muTLsvg2Ayjws7i6/alZk66I1O+x4noI/dQrtscccgXpgF7ngvKFMs8yaS8lc09G
Ut23NrfE1MVCXzalH4aSlTnwiU4KD09iF0FSVyZljfyRXTgAMVAZOb5xPZtxMZxU
bDZ3foHQZy9NoWsoXgdbt1iQKAdfXNfLJQcm/Zcy8t/t9pH5SBC4Db29vAUI4iIJ
iGa3tbwa1OyO3kaX66FjIumbCZH/KFiKRN5J6CkpcHPPyrl6qxOOKQlrpQzkKi9n
tqa9KZONcFzGNzc3VzRStFRWZQtzvLgSGl/tBiixZJXyPLG3EKfRR7vsXBLx1gN/
goJuDiLy
=awao
-----END PGP SIGNATURE-----

--vj5zeh2cohrjjqqm--
