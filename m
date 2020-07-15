Return-Path: <SRS0=MPTL=A2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07ACFC433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E26C220657
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbgGONTW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:19:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47194 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgGONTV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jul 2020 09:19:21 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jvhJe-0001bm-OZ
        for linux-crypto@vger.kernel.org; Wed, 15 Jul 2020 13:19:18 +0000
Received: by mail-qk1-f198.google.com with SMTP id k16so1449023qkh.12
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2020 06:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x5oYcTPzdr+xJ15lE6KuDSij2+aGOHHuEBh+2mqoDHw=;
        b=h9tt56/qe6XCTdL1yaVZe8zlgj0offkbBLekE5UPm+av41DEIGO1T5Lw9d2eADwm4h
         jQDSOQKVjAW+CQ4E1nE2rWbFWcISr0JUjW8bagGmDdrxhNR/IgbLz5IjkUOuy4b6jVkb
         zBZxIi8eIeitkLrxgfz9OWNp4d4kURaii6yJIyJOVn10WhBuyhLsdLnTaWh8GTvCtw1g
         2knj5oE8DutvZQ9mmbckdhISXCZgD0Vz+KKR4EvASYURf0YXa38vxylJhrwvmAaAOpJ7
         mycve8qxDKc2tKbQ9Cgh5RyP9zhVETsPX/EpwRzjvW3qXFuxMAvC7PL1MUaLlyAk2e4U
         5d6g==
X-Gm-Message-State: AOAM532qNRhL2f31if7oeAjYFJ/37hW4CW2isksIXE4v/XmiqdDSy1GW
        Fz3u4JLsP+1YqtPXk8NE4cWF27yO9DrfU9kdNLWzBrr3+LmV2Yyzkw3apgvaK+7/yPdfBHIQbNF
        0dy0fLn9rP/mudAzxFSiakT5vVOWE7Xo3Cp90WekW
X-Received: by 2002:a37:a056:: with SMTP id j83mr9844640qke.248.1594819157774;
        Wed, 15 Jul 2020 06:19:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWaRBs1Gkezg+OyOPcV8Hk/znrNRqNWJLDDg+QdNnWbeElKfVE5FYlkF91mZBl4PtKrsFONw==
X-Received: by 2002:a37:a056:: with SMTP id j83mr9844608qke.248.1594819157427;
        Wed, 15 Jul 2020 06:19:17 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:b5be:949b:8e92:2f08])
        by smtp.gmail.com with ESMTPSA id t65sm2408645qkf.119.2020.07.15.06.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:19:16 -0700 (PDT)
Date:   Wed, 15 Jul 2020 10:19:12 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 5/5] crypto: ECDH SP800-56A rev 3 local public key
 validation
Message-ID: <20200715131912.7enis4arnbs5lewt@valinor>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <3168469.44csPzL39Z@positron.chronox.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fmm4ojov23yrsynn"
Content-Disposition: inline
In-Reply-To: <3168469.44csPzL39Z@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--fmm4ojov23yrsynn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

On Sun, Jul 12, 2020 at 06:42:14PM +0200, Stephan M=FCller wrote:
> After the generation of a local public key, SP800-56A rev 3 section
> 5.6.2.1.3 mandates a validation of that key with a full validation
> compliant to section 5.6.2.3.3.
>=20
> Only if the full validation passes, the key is allowed to be used.
>=20
> The patch adds the full key validation compliant to 5.6.2.3.3 and
> performs the required check on the generated public key.
>=20
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/ecc.c | 31 ++++++++++++++++++++++++++++++-
>  crypto/ecc.h | 14 ++++++++++++++
>  2 files changed, 44 insertions(+), 1 deletion(-)
>=20
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 52e2d49262f2..7308487e7c55 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1404,7 +1404,9 @@ int ecc_make_pub_key(unsigned int curve_id, unsigne=
d int ndigits,
>  	}
> =20
>  	ecc_point_mult(pk, &curve->g, priv, NULL, curve, ndigits);
> -	if (ecc_point_is_zero(pk)) {
> +
> +	/* SP800-56A rev 3 5.6.2.1.3 key check */
> +	if (ecc_is_pubkey_valid_full(curve, pk)) {
>  		ret =3D -EAGAIN;
>  		goto err_free_point;
>  	}
> @@ -1452,6 +1454,33 @@ int ecc_is_pubkey_valid_partial(const struct ecc_c=
urve *curve,
>  }
>  EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
> =20
> +/* SP800-56A section 5.6.2.3.3 full verification */
> +int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
> +			     struct ecc_point *pk)
> +{
> +	struct ecc_point *nQ;
> +
> +	/* Checks 1 through 3 */
> +	int ret =3D ecc_is_pubkey_valid_partial(curve, pk);
> +
> +	if (ret)
> +		return ret;
> +
> +	/* Check 4: Verify that nQ is the zero point. */
> +	nQ =3D ecc_alloc_point(pk->ndigits);
> +	if (!nQ)
> +		return -ENOMEM;
> +
> +	ecc_point_mult(nQ, pk, curve->n, NULL, curve, pk->ndigits);
> +	if (!ecc_point_is_zero(nQ))
> +		ret =3D -EINVAL;
> +
> +	ecc_free_point(nQ);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ecc_is_pubkey_valid_full);
> +
>  int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigit=
s,
>  			      const u64 *private_key, const u64 *public_key,
>  			      u64 *secret)
> diff --git a/crypto/ecc.h b/crypto/ecc.h
> index ab0eb70b9c09..d4e546b9ad79 100644
> --- a/crypto/ecc.h
> +++ b/crypto/ecc.h
> @@ -147,6 +147,20 @@ int crypto_ecdh_shared_secret(unsigned int curve_id,=
 unsigned int ndigits,
>  int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
>  				struct ecc_point *pk);
> =20
> +/**
> + * ecc_is_pubkey_valid_full() - Full public key validation
> + *
> + * @curve:		elliptic curve domain parameters
> + * @pk:			public key as a point
> + *
> + * Valdiate public key according to SP800-56A section 5.6.2.3.3 ECC Full
> + * Public-Key Validation Routine.
> + *
> + * Return: 0 if validation is successful, -EINVAL if validation is faile=
d.
> + */
> +int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
> +			     struct ecc_point *pk);
> +
>  /**
>   * vli_is_zero() - Determine is vli is zero
>   *
> --=20
> 2.26.2
>=20
>=20
>=20
>=20

--=20
Regards,
Marcelo


--fmm4ojov23yrsynn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8PAlAACgkQ6e82Loes
sAkieQv/VhkrvVr850pBnR37bx2Omr9SNVrqayM3rBjnpWtpnqyC55seK0zHKFDm
THdi+I/cCLvMSfyPJyz2eS8CPBFoFxw6Vhh7HCm6gKfJn7SzN21x/05pxUlexMq4
1YwAg3rCb1j7ToNxiYgvXaB869oEXoFRLvDtT+V43Nip21FJ00Gef94s2Dg1ClyY
fH0g5e64iH6zct/07HGYZQn7L9ErOow52z1O66pYv20VCVzIjGH/UNNZolYSRtSV
Np+37N0N0TZQ9QrCNlBtwBz6YH5n+IJozMKfulv5YA2zwgC8E4Fyt/lAKeAyYbF6
m/Q2T5JcR5kJ15h2aH77LNFc0C7qMSn74Ns2+ViQ8kSSrdOZ1eSPHPUL2sK9CX3l
2xtyzSYlUuVr/TtZFD3Nz2+VuAa+Z8qNrHvLu37mCyJhJ1Fuozc/dkZx2sgF4j9+
6ap5ZtlhblTW9+YQ9GUfd9+T6NXEBD+6ijE8Z/vQYfZZAp+tJlHp8GK1jErFkUXH
BsAqxVmQ
=5NAS
-----END PGP SIGNATURE-----

--fmm4ojov23yrsynn--
