Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B497CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 14:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377419AbjJTOIn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 10:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377405AbjJTOIm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 10:08:42 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA984AB
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 07:08:39 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c5028e5b88so12459781fa.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 07:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697810918; x=1698415718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMflfsDmr9yqToB8PqgOeqaiOA6GNOMvcqe9gF64FHI=;
        b=iBJIzltKfyci6zlgYWKPCdkqG5SXO9rqqy7DMZBXCe+npuO6p//2pya3JxF43CEueW
         cKntjug6NM9RLON+UPcasmmzj+NK/QVJfB1ic/5lHT0eOO+vkr2xN/L348qvctovwEU7
         YW3NhT9FIGnw6bF6egk4Qt5nSX2tPN5zk/L/D+uPqKledCtPq13twI9NSHHbsz/zvXhX
         6k0qYrPBjwWz3FVfkOXmFRZHxSPnUs89SJO/O9x/9U4ViirOi1xoyuzYguAa8TsTDkj0
         QIRpXlr1b1+ymyYaUkMMBMULJBVUIXp1kwmosyzhj5If06Jq/2FP0NDh6MqfRni95MIW
         oD9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697810918; x=1698415718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMflfsDmr9yqToB8PqgOeqaiOA6GNOMvcqe9gF64FHI=;
        b=KUtFjSfTa8W536eP36g0Mj1nPHJ0YlW8mxzRIfakV6tNP1HIvOuifo/RJOn4+ROJwy
         RgS8i3JrWdSh5QBrYg1B+YjI4UHp+YIG155L/IDQd199BQj+GOsc/oRKMW8ClDGSbT+H
         OJw4Mjo6DwZo7mssHziBEqkwj1CPF0wo4ONRG+Mzjnf8q0uazUU9uT9qtR8doBSteEu4
         KtaOhxHKfIgyI0p6+kLcNaPSwH/txHiPVRAG1+LIR/w36h50bSjqbwzuvbVI0Af8W5Cg
         7V6+6zHDNmoeRLI6he1dGfAQaElbArSfImkyB+04P9ididWhTtAK62YzzSogcxh3Hm7f
         4SMQ==
X-Gm-Message-State: AOJu0YxRtLnCjTZ6Mc8DW6FpeJwrRyYVKTp51zfv2XkFuvO1wzDSCSzn
        k79vQznbxGhcygEj68a/xU0=
X-Google-Smtp-Source: AGHT+IEtk/yAj3a8PCb0KZzldeCx2CbR79ZxGh0hDIudcXsx+etyQ8nDzlijIASYKTsxGNlegWLaLA==
X-Received: by 2002:a2e:9a8a:0:b0:2bf:b133:dd65 with SMTP id p10-20020a2e9a8a000000b002bfb133dd65mr1330993lji.38.1697810917790;
        Fri, 20 Oct 2023 07:08:37 -0700 (PDT)
Received: from jernej-laptop.localnet (82-149-12-148.dynamic.telemach.net. [82.149.12.148])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c130e00b0040772934b12sm6964862wmf.7.2023.10.20.07.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 07:08:37 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        kernel@pengutronix.de
Subject: Re: [PATCH 01/42] crypto: sun4i-ss - Convert to platform remove callback
 returning void
Date:   Fri, 20 Oct 2023 16:08:35 +0200
Message-ID: <4886899.31r3eYUQgx@jernej-laptop>
In-Reply-To: <20231020075521.2121571-45-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-45-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dne petek, 20. oktober 2023 ob 09:55:23 CEST je Uwe Kleine-K=F6nig napisal(=
a):
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>=20
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> ---

Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej

>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/=
crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> index 3bcfcfc37084..ba80878e2df5 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> @@ -509,7 +509,7 @@ static int sun4i_ss_probe(struct platform_device *pde=
v)
>  	return err;
>  }
> =20
> -static int sun4i_ss_remove(struct platform_device *pdev)
> +static void sun4i_ss_remove(struct platform_device *pdev)
>  {
>  	int i;
>  	struct sun4i_ss_ctx *ss =3D platform_get_drvdata(pdev);
> @@ -529,7 +529,6 @@ static int sun4i_ss_remove(struct platform_device *pd=
ev)
>  	}
> =20
>  	sun4i_ss_pm_exit(ss);
> -	return 0;
>  }
> =20
>  static const struct of_device_id a20ss_crypto_of_match_table[] =3D {
> @@ -545,7 +544,7 @@ MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
> =20
>  static struct platform_driver sun4i_ss_driver =3D {
>  	.probe          =3D sun4i_ss_probe,
> -	.remove         =3D sun4i_ss_remove,
> +	.remove_new     =3D sun4i_ss_remove,
>  	.driver         =3D {
>  		.name           =3D "sun4i-ss",
>  		.pm		=3D &sun4i_ss_pm_ops,
>=20




