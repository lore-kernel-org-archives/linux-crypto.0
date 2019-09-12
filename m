Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4A4C5ACAE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 06:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFABB20684
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 06:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=anandra.org header.i=@anandra.org header.b="O3ail7do"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfILGgD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 02:36:03 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40745 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbfILGgD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 02:36:03 -0400
Received: by mail-vs1-f67.google.com with SMTP id v10so12217316vsc.7
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 23:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anandra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nmpGWYLtPSGrl1YWqJfUO5R7bgXryGBrcoRpFN/0a0g=;
        b=O3ail7doj7o7Ovvdm3xbfylphlfCHkXhRP/yCEXns19SI/49dj1zJ4ofS+2ymWt+g/
         y3q+7bsHhKZFTNIpho1NHXrbDOdNcKjML+gCzkCZ+eLyV+AqGgc9o4+wnx+HuUy+3hez
         q0rJuJtUyNvi5UZacXPNLJQdCthFS0Q25TmxVvFnqiqA592RsAQBs99I3jOtyvmTdOvu
         dFCpvzJT4TmCrUFXGkMWFmoe5L8WsPrO889Dvxz2XXHJ7oQ/RSdg2r4En1N7OJUqfYpr
         mjhDbzRkmwSlM9gb5CdLpopbdfxbi9icDKEIkwf9cUNCAAjaRZrmxC1rVSj01sJbkeID
         IuBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nmpGWYLtPSGrl1YWqJfUO5R7bgXryGBrcoRpFN/0a0g=;
        b=lzj8mYEikiA/PjftwNh6fgImKBTAFH/KzaFP6jXc7Bt3zO4xkBCCG4j+EeMm1AhMt8
         0KrUeFR6yIKCk4tTozvL3a1b0ja7L/Nfe6VTaeNyOuDqEfwFtf/y51kV7AmXWkyZoquh
         RRebwL77/lriO9E2+uSUIJaGXo4+iNJAgbklSero/IGVXhm4569yo3mGRA+5biemwWPx
         Jguv51NK+nG8HLbv65+TWRa3LvSoNan44j4R+uo87Ax3G6W4FuJ0c9wYEYbWX0FUbKuf
         sp9R3UklfX4BpmK3pkz8A5NRplgUCu450n61aDijyjimCRKILTDtyv8obBVH7AZjdun8
         HKRg==
X-Gm-Message-State: APjAAAWvwfjDLKRO1igBn4qj9vBY/z1MOdEJWKCHo5JeL6c8ZY1qYoxi
        1cDtiRk2ro6zayNLH0cgX91nCVPQmVUWJRLmLCw2ow==
X-Google-Smtp-Source: APXvYqzfE/Y4NxqCwMzVJjDMqfSUa87VwUqGZkEU9X98b47pKVZNAOOE5Iwr+L1cGROF1MU6wEDKkyLDzUkDX8srS94=
X-Received: by 2002:a67:f504:: with SMTP id u4mr22402937vsn.146.1568270162133;
 Wed, 11 Sep 2019 23:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190911114650.20567-1-clabbe.montjoie@gmail.com> <20190911114650.20567-3-clabbe.montjoie@gmail.com>
In-Reply-To: <20190911114650.20567-3-clabbe.montjoie@gmail.com>
From:   Maxime Ripard <maxime.ripard@anandra.org>
Date:   Thu, 12 Sep 2019 08:35:51 +0200
Message-ID: <CAO4ZVTM99FksM71BAiraYj7eyREO1Qi=L1NFzEkNmMgBmphBww@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: sun4i-ss: enable pm_runtime
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le mer. 11 sept. 2019 =C3=A0 13:46, Corentin Labbe
<clabbe.montjoie@gmail.com> a =C3=A9crit :
>
> This patch enables power management on the Security System.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |  5 +++
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 42 ++++++++++++++++++++++-
>  2 files changed, 46 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/s=
unxi-ss/sun4i-ss-cipher.c
> index fa4b1b47822e..1fedec9e83b0 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -10,6 +10,8 @@
>   *
>   * You could find the datasheet in Documentation/arm/sunxi.rst
>   */
> +
> +#include <linux/pm_runtime.h>
>  #include "sun4i-ss.h"
>
>  static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request=
 *areq)
> @@ -497,13 +499,16 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
>                 return PTR_ERR(op->fallback_tfm);
>         }
>
> +       pm_runtime_get_sync(op->ss->dev);
>         return 0;
>  }
>
>  void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
>  {
>         struct sun4i_tfm_ctx *op =3D crypto_tfm_ctx(tfm);
> +
>         crypto_free_sync_skcipher(op->fallback_tfm);
> +       pm_runtime_put_sync(op->ss->dev);
>  }
>
>  /* check and set the AES key, prepare the mode to be used */
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sun=
xi-ss/sun4i-ss-core.c
> index 2c9ff01dddfc..5e6e1a308f60 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> @@ -14,6 +14,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/scatterlist.h>
>  #include <linux/interrupt.h>
> @@ -258,6 +259,37 @@ static int sun4i_ss_enable(struct sun4i_ss_ctx *ss)
>         return err;
>  }
>
> +#ifdef CONFIG_PM
> +static int sun4i_ss_pm_suspend(struct device *dev)
> +{
> +       struct sun4i_ss_ctx *ss =3D dev_get_drvdata(dev);
> +
> +       sun4i_ss_disable(ss);
> +       return 0;
> +}
> +
> +static int sun4i_ss_pm_resume(struct device *dev)
> +{
> +       struct sun4i_ss_ctx *ss =3D dev_get_drvdata(dev);
> +
> +       return sun4i_ss_enable(ss);
> +}
> +#endif
> +
> +const struct dev_pm_ops sun4i_ss_pm_ops =3D {
> +       SET_RUNTIME_PM_OPS(sun4i_ss_pm_suspend, sun4i_ss_pm_resume, NULL)
> +};
> +
> +static void sun4i_ss_pm_init(struct sun4i_ss_ctx *ss)
> +{
> +       pm_runtime_use_autosuspend(ss->dev);
> +       pm_runtime_set_autosuspend_delay(ss->dev, 1000);
> +
> +       pm_runtime_get_noresume(ss->dev);
> +       pm_runtime_set_active(ss->dev);
> +       pm_runtime_enable(ss->dev);
> +}

It's not really clear to me what you're doing here? Can you explain?

The rest looks fine.

Maxime
