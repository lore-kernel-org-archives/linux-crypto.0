Return-Path: <SRS0=MPTL=A2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47729C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2672720657
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbgGONSk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:18:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47159 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731399AbgGONSk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jul 2020 09:18:40 -0400
Received: from mail-qt1-f199.google.com ([209.85.160.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jvhIz-0001XV-ER
        for linux-crypto@vger.kernel.org; Wed, 15 Jul 2020 13:18:37 +0000
Received: by mail-qt1-f199.google.com with SMTP id u93so1343644qtd.8
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2020 06:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o4t/KtWMbXFxTcUIcJnk7mtrUSGLSO747wwm5Je+/jk=;
        b=WGu0QlCyMB6adjd7UX1xCfDT7dyYUjl8mXJGqc1AcXkbEbyikO33EjMJxNNu4BAfEn
         UTwyc2NOgLKqagcBr5RFniBiGqRGJbdeDMMHla6G5W/vUTIWtzpmlsfnT4+kOCA4C0LU
         K1l6iQBvV+viXsHgq6tVxsHFGP43ff9LTcHkqs6PbwxmvNNh25a852e2X/SLI+bckZA7
         +ZwYHSCw1dqBRUWIl0IKpg0lyYGewdg6fr+at44w7ktzI9/SAFahKX18/BSjSgxcb5oE
         asZCskJt0pukS7T8vTiadW33EoDWtvX8boYthDTDK9278zbeZskGXs6pBo78KqWhwlBj
         sH6g==
X-Gm-Message-State: AOAM530C39FutVKHo9n1kt2PZ5c74+n62bZZJUpiMj+Q+ZnKJXB+KwjS
        MF3/bO/fbcOzr5oCtVqxRgTuFXrULAo7CKGaJK5WJGz7b4bDjR+jDmKbmuxbHB3KnQdYXiEJkzj
        fy8x6kl0dbCEaf8kqpzdVMiGDBgny6slZvRC0Gjwm
X-Received: by 2002:a05:620a:91b:: with SMTP id v27mr9262734qkv.499.1594819116508;
        Wed, 15 Jul 2020 06:18:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzk0Yh0RIkaWf1udU1M+UFm64hectEnZLtLQABJ0I5cvBUhT9ejx2b5FkEOlOHBvqbC+JslTw==
X-Received: by 2002:a05:620a:91b:: with SMTP id v27mr9262702qkv.499.1594819116197;
        Wed, 15 Jul 2020 06:18:36 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:b5be:949b:8e92:2f08])
        by smtp.gmail.com with ESMTPSA id p125sm2527531qke.78.2020.07.15.06.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:18:35 -0700 (PDT)
Date:   Wed, 15 Jul 2020 10:18:31 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 4/5] crypto: DH SP800-56A rev 3 local public key
 validation
Message-ID: <20200715131831.7zalbth5si2hp3fx@valinor>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <2833634.e9J7NaK4W3@positron.chronox.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mixkhwid6q43ktc7"
Content-Disposition: inline
In-Reply-To: <2833634.e9J7NaK4W3@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--mixkhwid6q43ktc7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

On Sun, Jul 12, 2020 at 06:40:57PM +0200, Stephan M=FCller wrote:
> After the generation of a local public key, SP800-56A rev 3 section
> 5.6.2.1.3 mandates a validation of that key with a full validation
> compliant to section 5.6.2.3.1.
>=20
> Only if the full validation passes, the key is allowed to be used.
>=20
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/dh.c | 59 ++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 34 insertions(+), 25 deletions(-)
>=20
> diff --git a/crypto/dh.c b/crypto/dh.c
> index f84fd50ec79b..cd4f32092e5c 100644
> --- a/crypto/dh.c
> +++ b/crypto/dh.c
> @@ -180,32 +180,41 @@ static int dh_compute_value(struct kpp_request *req)
>  	if (ret)
>  		goto err_free_base;
> =20
> -	/* SP800-56A rev3 5.7.1.1 check: Validation of shared secret */
> -	if (fips_enabled && req->src) {
> -		MPI pone;
> -
> -		/* z <=3D 1 */
> -		if (mpi_cmp_ui(val, 1) < 1) {
> -			ret =3D -EBADMSG;
> -			goto err_free_base;
> -		}
> -
> -		/* z =3D=3D p - 1 */
> -		pone =3D mpi_alloc(0);
> -
> -		if (!pone) {
> -			ret =3D -ENOMEM;
> -			goto err_free_base;
> +	if (fips_enabled) {
> +		/* SP800-56A rev3 5.7.1.1 check: Validation of shared secret */
> +		if (req->src) {
> +			MPI pone;
> +
> +			/* z <=3D 1 */
> +			if (mpi_cmp_ui(val, 1) < 1) {
> +				ret =3D -EBADMSG;
> +				goto err_free_base;
> +			}
> +
> +			/* z =3D=3D p - 1 */
> +			pone =3D mpi_alloc(0);
> +
> +			if (!pone) {
> +				ret =3D -ENOMEM;
> +				goto err_free_base;
> +			}
> +
> +			ret =3D mpi_sub_ui(pone, ctx->p, 1);
> +			if (!ret && !mpi_cmp(pone, val))
> +				ret =3D -EBADMSG;
> +
> +			mpi_free(pone);
> +
> +			if (ret)
> +				goto err_free_base;
> +
> +		/* SP800-56A rev 3 5.6.2.1.3 key check */
> +		} else {
> +			if (dh_is_pubkey_valid(ctx, val)) {
> +				ret =3D -EAGAIN;
> +				goto err_free_val;
> +			}
>  		}
> -
> -		ret =3D mpi_sub_ui(pone, ctx->p, 1);
> -		if (!ret && !mpi_cmp(pone, val))
> -			ret =3D -EBADMSG;
> -
> -		mpi_free(pone);
> -
> -		if (ret)
> -			goto err_free_base;
>  	}
> =20
>  	ret =3D mpi_write_to_sgl(val, req->dst, req->dst_len, &sign);
> --=20
> 2.26.2
>=20
>=20
>=20
>=20

--=20
Regards,
Marcelo


--mixkhwid6q43ktc7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8PAiYACgkQ6e82Loes
sAn5/Av9Fn9wfEkgBbWZr/PXbd5R3AG18oklqEbrjTdUeNhiki+JTOrrMd6r7TK0
szatWeDenwyiM7QeXFiMAinU9zeoqBlDHWMSAAY6iC1Iml/JQIChWXo/d8+lZ5ub
Ebp5xWE/hb0GFE7p4D86gmYSYSKpDFcNGG+4ne+YtW75LDHOrg1R/DQlov0Ntfc4
NhicP/4OYU1HSBC4CQlDOSs/j4tOdgZBslwBG1XcRxX4U2xvQmsOR2yKwoQ6jnD+
SsmAsRT0/5pzDKtGdV8qBzif42YlJ1QUIJwdhd+HDt93673G5QjPttSkdsU+KzJp
tlZdB+ggFKCiWo+2Ig9A0MZp9HuOq+k44ulrI2hoUAKBPDKJNlKkuRX8Mp4sMusd
sofMLv/EFPzqnNTciHMFp+K494gro8ocrthp2pQIhCG2HriKKXWLYuSmPxb0vTrI
dlw4VrXT95MBILyvmkVvHmfK8oibC9JNnqnLTntPnpCmaiHGnhux9Yw/F34244Fx
qzM7DIhq
=7W77
-----END PGP SIGNATURE-----

--mixkhwid6q43ktc7--
