Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30FFC2BA83
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 16:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B66F720714
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 16:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cP7Dc2Vt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBLQZD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 11:25:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37238 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLQZC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 11:25:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id z12so1479072pgl.4;
        Wed, 12 Feb 2020 08:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zweDaFEU0USsV+JX/LUuDeDmSUEHYWtL+9GANBjwgS4=;
        b=cP7Dc2VtOxGDgxZ6JHdE2q9Lyhmqv0k2cCO7w6iMWAwBuUc4X1hTFNxnXVCptDXT5x
         NkTwJ4HwJDTYlXQ/5Q7HYPa3LjvpoW91An4WuKSfHiHl1cCp/idPPX1hDnIWFfwgILph
         QW9+RaPIhjuK1G7zJ38FF3O6vqRsLjyTFD1u6DPY3hwHwnUAu83W+GE02P7wMvEy32l3
         eXIX+9iUpxb5H7wLek1JA/nyj2rTQruJVFD7L9dgv3URdIlaLvOkvra0G4uAdd98IqUt
         FLJTU0BiinQI0yNZwHtYRV5wtxUSO5kAqzg2SG6UUvGIfNaKdm2lxG4iEEO/0uByivN6
         2ENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zweDaFEU0USsV+JX/LUuDeDmSUEHYWtL+9GANBjwgS4=;
        b=IVjO0a134bw4yJMmWAJVond4xkwVesau28rgyMA5uNt9aiRwgd5B1wBNO8w3YTcB/f
         UF/DwqdTuutW/dd/TWsz+Lo0gVDjDDyVCwKUzzWibX6tFnAWYjQSTMNaXueFCRonNJuO
         ynrakaJe8thJuOYQ8EmJc7seFIDYo/PWmSQrHvXJSsmS9Pl8g9+SmUm4REC9nKYHHrBf
         mJxL2Lf++Lc0JOySCvLhXZtSc0nuQr2Gn5tcMDNbFBmStRbxiUyja+BL4Nlq2wMnTDAB
         n+Zn9RXW03gtrws7hCYfN2VQG2jYhQxaXdjju+jLaiUv66Vt3Rlo/Wt9bSYFLudjQa/m
         JAlQ==
X-Gm-Message-State: APjAAAUIk15enj7dsG5CJ7HXmnpjy2W4ZQZbDis2LC/I6kOQ3W+E3MlR
        BY8c+f70PCE+yGkT+dqrNmxiPdNO9j6DGfAqrsw=
X-Google-Smtp-Source: APXvYqxdvvvgkWHaTR3wCKLim8YYFZ3Gilg23ZQv1CNAsUnE4dlwsUOhdWPRIYUJ8aFymPSp2AKT9wOK4ZMF4Mx3X+0=
X-Received: by 2002:a63:306:: with SMTP id 6mr9363242pgd.337.1581524702320;
 Wed, 12 Feb 2020 08:25:02 -0800 (PST)
MIME-Version: 1.0
References: <20200128110102.11522-1-martin@kaiser.cx> <20200128110102.11522-3-martin@kaiser.cx>
In-Reply-To: <20200128110102.11522-3-martin@kaiser.cx>
From:   PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date:   Wed, 12 Feb 2020 21:54:51 +0530
Message-ID: <CANc+2y60cCtDwBi1jaV=eMtTwoihRf2WiKW7Zo3iC9ALv2OVSw@mail.gmail.com>
Subject: Re: [PATCH 2/6] hwrng: imx-rngc - use automatic seeding
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
> The rngc requires a new seed for its prng after generating 2^20 160-bit
> words of random data. At the moment, we seed the prng only once during
> initalisation.
>
> Set the rngc to auto seed mode so that it kicks off the internal
> reseeding operation when a new seed is required.
>
> Keep the manual calculation of the initial seed when the device is
> probed and switch to automatic seeding afterwards.
>
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  drivers/char/hw_random/imx-rngc.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 0576801944fd..903894518c8d 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -31,6 +31,7 @@
>
>  #define RNGC_CTRL_MASK_ERROR           0x00000040
>  #define RNGC_CTRL_MASK_DONE            0x00000020
> +#define RNGC_CTRL_AUTO_SEED            0x00000010
>
>  #define RNGC_STATUS_ERROR              0x00010000
>  #define RNGC_STATUS_FIFO_LEVEL_MASK    0x00000f00
> @@ -167,7 +168,7 @@ static irqreturn_t imx_rngc_irq(int irq, void *priv)
>  static int imx_rngc_init(struct hwrng *rng)
>  {
>         struct imx_rngc *rngc = container_of(rng, struct imx_rngc, rng);
> -       u32 cmd;
> +       u32 cmd, ctrl;
>         int ret;
>
>         /* clear error */
> @@ -192,7 +193,18 @@ static int imx_rngc_init(struct hwrng *rng)
>
>         } while (rngc->err_reg == RNGC_ERROR_STATUS_STAT_ERR);
>
> -       return rngc->err_reg ? -EIO : 0;
> +       if (rngc->err_reg)
> +               return -EIO;
> +
> +       /*
> +        * enable automatic seeding, the rngc creates a new seed automatically
> +        * after serving 2^20 random 160-bit words
> +        */
> +       ctrl = readl(rngc->base + RNGC_CONTROL);
> +       ctrl |= RNGC_CTRL_AUTO_SEED;
> +       writel(ctrl, rngc->base + RNGC_CONTROL);
> +
> +       return 0;
>  }
>
>  static int imx_rngc_probe(struct platform_device *pdev)
> --
> 2.20.1
>

Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
