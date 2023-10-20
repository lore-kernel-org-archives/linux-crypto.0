Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89174C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 14:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377495AbjJTOJS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 10:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377429AbjJTOJR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 10:09:17 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2541AB
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 07:09:15 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2c4fe37f166so12525781fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 07:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697810954; x=1698415754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAk8jT42K0k51X/whGDwwkWdg31+jN6q/2Mef/7UWrE=;
        b=jSVpmLQEr4Era56fUg/4RV2Oqtj9V4Q0lFzMgv98eGNViwILp/BJM1Uzg5gJqcWR0D
         WoCUQ66JzHqKIlJSAZzPBaz28uiUtzeyKIjPfF3eO0WTDc1aTAibKorgU+f+M6MbxOJ/
         xA7hGrPiGI2ZV3iY8mR0/5zhSIWOzPcstujNmpjabiJM37g/Wqw2Bf6PdyiH3N1crJgS
         y/3gde0ktC9O9zEmoNwjavQZFh+PrlFhjsDvD8ei4qmRv3r18czZeRQJGr45GrAmPa4t
         WgciBsdQ9DvviHC9BvnrT2YaFdgnXcvL2Hf/g1hiC5h5wMdyWBcbHblBCBWrSDgbIRGa
         vgjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697810954; x=1698415754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mAk8jT42K0k51X/whGDwwkWdg31+jN6q/2Mef/7UWrE=;
        b=ctV96h5EfRAzNRjSVHU1PtLrFFuCBhYT+LACy3JbGq4YeXxJ8mYDEdDOxBNbeCDKN3
         7gepWyqWhGE7c67ZDQOT15gXORGWXGJd6QwitwkmkBTeTaePnIQGmTk75ulhzT581FWK
         rSSp6fW53PkjbVJ0aPAASJA2zkTRhqx9ADQbYS1whakl+jqu4MtrvQ1QEWQ7W2mtkKAQ
         91T8zvc+mnhL50r8t2MRM0Q6/qVTXzDzfguVVvaP0ywzJpbkQEhoWc40KyGfpRWyfv4z
         /ofAIosxaomZ4XA79uQvcmotkeSGBD+qsxPUvz+1YAKwW7c/1HCRpMgVtCDJGWbTKKZq
         64mQ==
X-Gm-Message-State: AOJu0YzgO7KnsPIjWHRWO9PiQLwQwceT4dUgygzwIZ/Rd4+0EN7WMHu4
        Peq05zitM4Au9zeaLJYpM60=
X-Google-Smtp-Source: AGHT+IEcjRrEpDSqzSmBRW8cEQW7ATxuQF+r5HjzhQL71YF4PNK4hVxqHzayJTA6OlG1si/9bOF1Ng==
X-Received: by 2002:a05:651c:a0a:b0:2bb:a28b:58e1 with SMTP id k10-20020a05651c0a0a00b002bba28b58e1mr2191009ljq.41.1697810953817;
        Fri, 20 Oct 2023 07:09:13 -0700 (PDT)
Received: from jernej-laptop.localnet (82-149-12-148.dynamic.telemach.net. [82.149.12.148])
        by smtp.gmail.com with ESMTPSA id l23-20020a1c7917000000b004063cced50bsm2248792wme.23.2023.10.20.07.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 07:09:13 -0700 (PDT)
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
Subject: Re: [PATCH 03/42] crypto: sun8i-ss - Convert to platform remove callback
 returning void
Date:   Fri, 20 Oct 2023 16:09:11 +0200
Message-ID: <1885790.tdWV9SEqCh@jernej-laptop>
In-Reply-To: <20231020075521.2121571-47-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-47-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dne petek, 20. oktober 2023 ob 09:55:25 CEST je Uwe Kleine-K=F6nig napisal(=
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

>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/=
crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> index 4a9587285c04..f14c60359d19 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> @@ -908,7 +908,7 @@ static int sun8i_ss_probe(struct platform_device *pde=
v)
>  	return err;
>  }
> =20
> -static int sun8i_ss_remove(struct platform_device *pdev)
> +static void sun8i_ss_remove(struct platform_device *pdev)
>  {
>  	struct sun8i_ss_dev *ss =3D platform_get_drvdata(pdev);
> =20
> @@ -921,8 +921,6 @@ static int sun8i_ss_remove(struct platform_device *pd=
ev)
>  	sun8i_ss_free_flows(ss, MAXFLOW - 1);
> =20
>  	sun8i_ss_pm_exit(ss);
> -
> -	return 0;
>  }
> =20
>  static const struct of_device_id sun8i_ss_crypto_of_match_table[] =3D {
> @@ -936,7 +934,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ss_crypto_of_match_tabl=
e);
> =20
>  static struct platform_driver sun8i_ss_driver =3D {
>  	.probe		 =3D sun8i_ss_probe,
> -	.remove		 =3D sun8i_ss_remove,
> +	.remove_new	 =3D sun8i_ss_remove,
>  	.driver		 =3D {
>  		.name		=3D "sun8i-ss",
>  		.pm             =3D &sun8i_ss_pm_ops,
>=20




