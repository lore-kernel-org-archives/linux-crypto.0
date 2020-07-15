Return-Path: <SRS0=MPTL=A2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56726C433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2E520658
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 13:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgGONSI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:18:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47123 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731423AbgGONSI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jul 2020 09:18:08 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jvhIT-0001VB-Ho
        for linux-crypto@vger.kernel.org; Wed, 15 Jul 2020 13:18:05 +0000
Received: by mail-qk1-f198.google.com with SMTP id u186so1462221qka.4
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2020 06:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d1rNvyhuW4htCxB7htMDN/EPqlnojy7ptTbMsgZk498=;
        b=YOk11NDfCzF0Q5c+Mel33i9PwUl/bD8ICo3bjJRYORPPBiPICoMRFpd3opV2kU+vkl
         AMJsaGVyBW/vpik6GX3PphXY8sinuxUYZGDRGoK4UKcoZdbIPIZtMtCXcbLE65qhehKE
         3W4e2lBKTcwgortl6bPXu5jHeTa4kHKkSj5T+N6vsNeIq/hvCs1ITEx2UUQwAN3XuYea
         z4LLLLRKglw8jAbXDziq+tkGVitjsJxwumbmtDUKHrBmVyCOKBz7Shh5DCrNvIYulKwQ
         rLa3XeQK8pQqXk78jaTgIiYMM1dt1UcSufO1AETqGo2INAhr0pLb134TF5Jmea3RQHE+
         bcug==
X-Gm-Message-State: AOAM533zLYC4GKBsD22oEEchjeR8P9o6wZyHnjsa2gpIg0haLLhdeSLI
        HyoT6Ugy70La25iqNl6+eEO2b+DEtyHnXPL0aHJaTbJXZbDLUmOFtPn9BwAYFQQYUzFv1hQRJyc
        XPUM+Ucl7SVseKMmp8nMDMcShfWH0NjLU/TXJy0pA
X-Received: by 2002:a37:8a06:: with SMTP id m6mr9650304qkd.191.1594819084548;
        Wed, 15 Jul 2020 06:18:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYzerwV756whFdw4EBQCxI8LUexmh5zwi4ydM1zuscWIDNu4bc0wYlPCwhc+K8imcnlNpQuA==
X-Received: by 2002:a37:8a06:: with SMTP id m6mr9650245qkd.191.1594819083886;
        Wed, 15 Jul 2020 06:18:03 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:b5be:949b:8e92:2f08])
        by smtp.gmail.com with ESMTPSA id f15sm2244901qka.120.2020.07.15.06.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:18:02 -0700 (PDT)
Date:   Wed, 15 Jul 2020 10:17:58 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 3/5] crypto: DH - check validity of Z before export
Message-ID: <20200715131758.mbiro6hyahsfrrew@valinor>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <2134009.irdbgypaU6@positron.chronox.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qlkbrt42fslsqbd2"
Content-Disposition: inline
In-Reply-To: <2134009.irdbgypaU6@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--qlkbrt42fslsqbd2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

On Sun, Jul 12, 2020 at 06:40:20PM +0200, Stephan M=FCller wrote:
> SP800-56A rev3 section 5.7.1.1 step 2 mandates that the validity of the
> calculated shared secret is verified before the data is returned to the
> caller. This patch adds the validation check.
>=20
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/dh.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/crypto/dh.c b/crypto/dh.c
> index 566f624a2de2..f84fd50ec79b 100644
> --- a/crypto/dh.c
> +++ b/crypto/dh.c
> @@ -9,6 +9,7 @@
>  #include <crypto/internal/kpp.h>
>  #include <crypto/kpp.h>
>  #include <crypto/dh.h>
> +#include <linux/fips.h>
>  #include <linux/mpi.h>
> =20
>  struct dh_ctx {
> @@ -179,6 +180,34 @@ static int dh_compute_value(struct kpp_request *req)
>  	if (ret)
>  		goto err_free_base;
> =20
> +	/* SP800-56A rev3 5.7.1.1 check: Validation of shared secret */
> +	if (fips_enabled && req->src) {
> +		MPI pone;
> +
> +		/* z <=3D 1 */
> +		if (mpi_cmp_ui(val, 1) < 1) {
> +			ret =3D -EBADMSG;
> +			goto err_free_base;
> +		}
> +
> +		/* z =3D=3D p - 1 */
> +		pone =3D mpi_alloc(0);
> +
> +		if (!pone) {
> +			ret =3D -ENOMEM;
> +			goto err_free_base;
> +		}
> +
> +		ret =3D mpi_sub_ui(pone, ctx->p, 1);
> +		if (!ret && !mpi_cmp(pone, val))
> +			ret =3D -EBADMSG;
> +
> +		mpi_free(pone);
> +
> +		if (ret)
> +			goto err_free_base;
> +	}
> +
>  	ret =3D mpi_write_to_sgl(val, req->dst, req->dst_len, &sign);
>  	if (ret)
>  		goto err_free_base;
> --=20
> 2.26.2
>=20
>=20
>=20
>=20

--=20
Regards,
Marcelo


--qlkbrt42fslsqbd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8PAgYACgkQ6e82Loes
sAnIbgwAlJ85FjGJfq8OjHAcJMFDZlyIiBBabnbvaJKCKupakZpCWbWFne5OUZuf
Y6KVhnlbOCXqOMuStfrTPk0gz3cOQetM4BApNjq9vcqtyVU0TlDsa0tPyEWJL+3S
iiS7iqglYUVDctOdcQS4xpDBkSYahh6/bSMJyNOVoLAyMdRfQUAUlFek56WAyJmx
1X0BUjHrL7XMcC6CrNv4gLrNQCmVOLyQizpUya4d7eR4JMVy2kpusDeWX09jzp9n
tiWPHvDZ87AVOsmZVBy+F20IkkPq3Puga6Dgo52986CX39RV/3U5RZEJGzqI+lik
BJ5m/u9XxqMgMecQcQ9i4PFgyOp4bcoRTZSV3QoCH0MD/8H/kIqfA/MmP/Y4yxcT
RlyYVB89VmYHQnLCjnWG1Q8OBkUQJrIvEcl1SBfCWlnIsBhe0GZA5LTn9y3bBxvd
JX4DX0JYVYUf9xOcG0AeLDN7NDIq7yDVgL0sS9kvrFWEFrcwWuqi/BwgJ4MXap1k
NdO25iAW
=Sc2I
-----END PGP SIGNATURE-----

--qlkbrt42fslsqbd2--
