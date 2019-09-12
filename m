Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1135C49ED9
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 06:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 867EE20CC7
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 06:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=anandra.org header.i=@anandra.org header.b="eeSmJ5xc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfILGcd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 02:32:33 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:46437 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbfILGcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 02:32:32 -0400
Received: by mail-vs1-f65.google.com with SMTP id z14so15428784vsz.13
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 23:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anandra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3n6GltZO+OtJoQdKROJI96T9MrzZAMOjs1puX9Kbpvo=;
        b=eeSmJ5xcN10sZAnGEHc7gqbVzHCrYTdEovfohCNylc4pLZtuIYAhzjMUD3M1DGIymd
         m/N74veb7vmeZ2JP9x/KxBQ9rh35PjFTIayrjQWOy+QP5+m3DYoZLu2ZGjuJtQ6wBne5
         mRP0tP+WH20jlTsBlohSb3dPGPbmr46j5isRGh0lSSF8CrRu6NXcobR3Mw66kFrZtLyU
         uckshBb+hoPb1NMv0VjL6AO/dxRxtAggeAQ7ky1bDMigvhROajTJXxorAbheefsX0neG
         ShZUGlk46y9t/YxtaI4a1i7M3fFaZpTRpFYDH/13n+uFEOeCsLWk+E+zkBZ8+XgcPx5+
         O6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3n6GltZO+OtJoQdKROJI96T9MrzZAMOjs1puX9Kbpvo=;
        b=jt93i+p3CpcAU6zaGYJKtTYdKGBMIc4PJjFw9tyP/Q1JSnG7Zp53PEzkFB/2yuUy7v
         gaPrrHI4h7DwS8o+ZDN/64XvXAkNePBzbGW2jUZ1J9Cb5LBch3I1U8NQ0JKipX5dgdT9
         CbQTvo5sladL5D1Prww9LvOkhyma0eVHh/5Pk41CY3EAuPkegQM+NK9JOMYYXJEIorpz
         GVydBpMxFn4x2ndlf52IUDHhH0UEAYivauSKKoB1Gy/h0PABQxr+bivVduuRz6g69ChD
         bzF6fQxX35GGYWKuP1AFqyZhJ11i3Y8wzwp2GW2xKS4CTJW9lH98RND6wSxjGNtGfrNS
         DTcQ==
X-Gm-Message-State: APjAAAW4yJQZ1UwDAPv9r8b0fEgatmGKgIAcj/Q9L5hq7h9h5Inl2G0v
        pu7QkAlxD3aW6x9xG5JrNXe1eDiJDAl93bV6f9wDIw==
X-Google-Smtp-Source: APXvYqxvw33app8ehwtG/HmDhiiAhumgM1IZ5mmnHdjYx87w8KSdlbyLbdfva5l2gg3rQlcCuertnre8gSf8mdOAf/4=
X-Received: by 2002:a67:e886:: with SMTP id x6mr22255618vsn.117.1568269950234;
 Wed, 11 Sep 2019 23:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190911114650.20567-1-clabbe.montjoie@gmail.com> <20190911114650.20567-2-clabbe.montjoie@gmail.com>
In-Reply-To: <20190911114650.20567-2-clabbe.montjoie@gmail.com>
From:   Maxime Ripard <maxime.ripard@anandra.org>
Date:   Thu, 12 Sep 2019 08:32:19 +0200
Message-ID: <CAO4ZVTPAX8FsSWHNAbCV3XSEe5BjDM+s9cB_TbF-2t8g-u4TKQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: sun4i-ss: simplify enable/disable of the device
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
> This patch regroups resource enabling/disabling in dedicated function.
> This simplify error handling and will permit to support power
> management.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c | 73 ++++++++++++++-----------
>  1 file changed, 42 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sun=
xi-ss/sun4i-ss-core.c
> index 9aa6fe081a27..2c9ff01dddfc 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> @@ -223,6 +223,41 @@ static struct sun4i_ss_alg_template ss_algs[] =3D {
>  #endif
>  };
>
> +static void sun4i_ss_disable(struct sun4i_ss_ctx *ss)
> +{
> +       if (ss->reset)
> +               reset_control_assert(ss->reset);
> +       clk_disable_unprepare(ss->ssclk);
> +       clk_disable_unprepare(ss->busclk);
> +}

While you're at it, can you add a new line after the reset_control_assert h=
ere?

> +static int sun4i_ss_enable(struct sun4i_ss_ctx *ss)
> +{
> +       int err;
> +
> +       err =3D clk_prepare_enable(ss->busclk);
> +       if (err) {
> +               dev_err(ss->dev, "Cannot prepare_enable busclk\n");
> +               goto err_enable;
> +       }
> +       err =3D clk_prepare_enable(ss->ssclk);
> +       if (err) {
> +               dev_err(ss->dev, "Cannot prepare_enable ssclk\n");
> +               goto err_enable;
> +       }
> +       if (ss->reset) {
> +               err =3D reset_control_deassert(ss->reset);
> +               if (err) {
> +                       dev_err(ss->dev, "Cannot deassert reset control\n=
");
> +                       goto err_enable;
> +               }
> +       }
> +       return err;

And after each block here?

With that fixed:
Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime
