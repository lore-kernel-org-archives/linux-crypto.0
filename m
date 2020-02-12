Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29489C2BA83
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 16:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF6EF20714
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 16:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="miH8EZwy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgBLQYP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 11:24:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34922 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgBLQYP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 11:24:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so1478619pgk.2;
        Wed, 12 Feb 2020 08:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EdJ9jznJ6wCoLx3M+Q7vLWwv5VYzXfXi+Eg2gF08D2I=;
        b=miH8EZwyrhb+567BJVz1H3LtOZjolN68vVQomtTgvaRF686bLqKCfLLvGqjKZCAIfO
         vEwZnoZTnct1ylTVoh6kwFNTk0xX28/mT2r+cZIP+nVlkmL+PT00G5vmr2dEifKCK6t9
         e0cymh4CgsQiIxIAgrASohWQ2vHA/1ShVebZKDRY0sDXK4egykHjQbpcWfowbTtEbqfB
         VOD6PXOrRpH0E4EsE0KHSi/EMIbadnTfgueujtGvt9H0KJtvh5EVf9ju7oPDxuoMLhsx
         T6qp7GJc8KKEtqqSi82gAJA0KqRiTRPiDKeHxotQ2YirxY68n1MR+s0fMKhBznbGtwxC
         S9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EdJ9jznJ6wCoLx3M+Q7vLWwv5VYzXfXi+Eg2gF08D2I=;
        b=tXFW3luD3H34nUh58tLObqNsbfVnuV5MWfA+o3la2dKN9LLr/ruNOMAbRM1UwbGT9i
         fTYY+zyTX7Z19a+plZQgqppU+9SGxOcaNzQa0JR8LhkF6Sx8D45MAegjKImG8e8d+HxZ
         407Xs3g0XvWYymD5yweDD6X94s61Hra+1wpBGv2Un2tcB9MJPg1vtodrAccuAgDYE7XV
         1jIka8qn+K/ObqKPH8iMP8MKBRAe/3ElElVW06dMcDFtauCeTI9mx2iuOrGcyXFjC79L
         xymRLOjN7E0AD66B0H2fpv0RCI025120BMQTgYXACBOVOes6wCDHO+3sUuDlHI4JBHy9
         V3RA==
X-Gm-Message-State: APjAAAXoX5BiiJX8r4aI0VTt9QU2T6QLzFt845cPM1Wu0dd3ft6DiJXo
        fEylpDdQdxG0/7O1IvQd2S9ZN3eeKkjIWCa5r3Y=
X-Google-Smtp-Source: APXvYqwzBgfyekxP6cVyPe5nEedZ7+Oaj2Yy8d5xqV52U+jREyuWzXUbC7v7ynDyQxgDAtlZRKMM87v5w+R1JwlTBNE=
X-Received: by 2002:a63:583:: with SMTP id 125mr9266610pgf.100.1581524654460;
 Wed, 12 Feb 2020 08:24:14 -0800 (PST)
MIME-Version: 1.0
References: <20200128110102.11522-1-martin@kaiser.cx> <20200128110102.11522-5-martin@kaiser.cx>
In-Reply-To: <20200128110102.11522-5-martin@kaiser.cx>
From:   PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date:   Wed, 12 Feb 2020 21:54:03 +0530
Message-ID: <CANc+2y7ToOCEzRjJR=Mx6LpGim-StDw_NEZAZjT+WWXpK39n1A@mail.gmail.com>
Subject: Re: [PATCH 4/6] hwrng: imx-rngc - (trivial) simplify error prints
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 Jan 2020 at 16:31, Martin Kaiser <martin@kaiser.cx> wrote:
>
> Remove the device name, it is added by the dev_...() routines.
>
> Drop the error code as well. It will be shown by the driver core when
> the probe operation failed.
>
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  drivers/char/hw_random/imx-rngc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 1381ddd5b891..8222055b9e9b 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -258,14 +258,14 @@ static int imx_rngc_probe(struct platform_device *pdev)
>         if (self_test) {
>                 ret = imx_rngc_self_test(rngc);
>                 if (ret) {
> -                       dev_err(rngc->dev, "FSL RNGC self test failed.\n");
> +                       dev_err(rngc->dev, "self test failed\n");
>                         goto err;
>                 }
>         }
>
>         ret = devm_hwrng_register(&pdev->dev, &rngc->rng);
>         if (ret) {
> -               dev_err(&pdev->dev, "FSL RNGC registering failed (%d)\n", ret);
> +               dev_err(&pdev->dev, "hwrng registration failed\n");
>                 goto err;
>         }
>
> --
> 2.20.1
>

Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
