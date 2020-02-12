Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67C1C2BA83
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 16:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B9C820714
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 16:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cB8DmvKi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgBLQOH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 11:14:07 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41107 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgBLQOH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 11:14:07 -0500
Received: by mail-pf1-f195.google.com with SMTP id j9so1458927pfa.8;
        Wed, 12 Feb 2020 08:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OE7vpo0ZLwKc2Q/gSZxbs7a6GJfpkch8/DsdID/PORQ=;
        b=cB8DmvKisQrlJkwK9PyfwxgRrDpyXZNfhy4jncjU2FNYol3VGdk7rq+8a5hVaxYZ5b
         ZpPyNrN9c0EapSL7MNHmrc8cg2S+Ow4NmeKlXgLChPxipLIzdAFYLOK/p1+/3RPg00+5
         JJJJuwcuoyMaQdq6Gdn2gHR/EDiTHf9Bu2LSA4ngMyQZiJyoKJtayMFQwxOdH218jfnC
         VwL/uES+mHf2cP4IgFE6us8CV1MUaS51x3v2WA2Bl4/Jqy8wQLkG1Ck2tTeKUkdwAPxx
         him4NdBe2VsLUWQeMn5ZMu2HgZoBoP/Dxw2maCXEbyN7sA4X9p85DH5YaG23ZwinD7V0
         OOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OE7vpo0ZLwKc2Q/gSZxbs7a6GJfpkch8/DsdID/PORQ=;
        b=Az+iuXNLVwR1u0OO6KMYcsb32y0R6C2InzGYoTz2AZLMLOkQfx3ODBxlqIzbBWctqk
         DqDfEflVOuVH2d5kW4JMl8TmQoafcH2Hk3fPa10X1V5vtQ9GvzO/QOE2Kiocb/hcOPMC
         gNb1gs7uqoV8hTwqM7mDQCSDlK8pH8F33x4yFBDw+zF6jsAbg5REO/JpDG1FjRlTcvbQ
         WD/jdoxOjD6bc0CTC3c54YLUeFVzvvEvV9x57xt/B0rQCPJxrWgcp81lI4qYodMuqhDA
         3hDao+HiO84iatPFvjXEp+mcimL2YBj0ikZGp6ACwnNxoexN4ResOxna/mYINKY0yVqF
         tlzA==
X-Gm-Message-State: APjAAAWbHPSczBHJQQ5BUxSiN+35CUgCfvMxY/hEdgmKyMjHJif9sUxB
        frsoKw0l+Qs4FSzig6IVXRCGRnG8RMO6t0U05Ws=
X-Google-Smtp-Source: APXvYqxh5GSPAkd71YH7sbjXip6T8nkNYUtTrt6qORPoCu8bXvvIHMza/bhRQ2uItfBi8M2VJco7HFV7RTGY08zVjwM=
X-Received: by 2002:aa7:9796:: with SMTP id o22mr9076367pfp.101.1581524045940;
 Wed, 12 Feb 2020 08:14:05 -0800 (PST)
MIME-Version: 1.0
References: <20200128110102.11522-1-martin@kaiser.cx> <20200128110102.11522-4-martin@kaiser.cx>
In-Reply-To: <20200128110102.11522-4-martin@kaiser.cx>
From:   PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date:   Wed, 12 Feb 2020 21:43:55 +0530
Message-ID: <CANc+2y6Scy1=S7zeQ4gVowRoWmzsq4wiNXbLVeY1Qvu0oo9cUw@mail.gmail.com>
Subject: Re: [PATCH 3/6] hwrng: imx-rngc - use devres for registration
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

Hi Martin,

On Tue, 28 Jan 2020 at 16:31, Martin Kaiser <martin@kaiser.cx> wrote:
>
> Use devres to register the rngc with the hwrng core. Drop the explicit
> deregistration.
>
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  drivers/char/hw_random/imx-rngc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 903894518c8d..1381ddd5b891 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -263,7 +263,7 @@ static int imx_rngc_probe(struct platform_device *pdev)
>                 }
>         }
>
> -       ret = hwrng_register(&rngc->rng);
> +       ret = devm_hwrng_register(&pdev->dev, &rngc->rng);
>         if (ret) {
>                 dev_err(&pdev->dev, "FSL RNGC registering failed (%d)\n", ret);
>                 goto err;
> @@ -282,8 +282,6 @@ static int __exit imx_rngc_remove(struct platform_device *pdev)
>  {
>         struct imx_rngc *rngc = platform_get_drvdata(pdev);
>
> -       hwrng_unregister(&rngc->rng);
> -
>         clk_disable_unprepare(rngc->clk);
>
>         return 0;
> --
> 2.20.1
>

After imx_rngc_remove function hwrng_unregister will get called. This
leaves a window where the clock to rng hardware block is disabled but
still user space can access it via /dev/hwrng. This does not look
right, please revisit the patch.

Regards,
PrasannaKumar
