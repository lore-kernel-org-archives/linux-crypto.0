Return-Path: <SRS0=Y8jf=AA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649FFC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 21:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB43221E6
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 21:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLnUGLWA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFSVqS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jun 2020 17:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgFSVqR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jun 2020 17:46:17 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE87C06174E;
        Fri, 19 Jun 2020 14:46:17 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id i8so6396411lfo.4;
        Fri, 19 Jun 2020 14:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A2wfnvUJcArOzvROBSxEDoq/2XoIUAY6WzwwQK6XXBA=;
        b=nLnUGLWAs48Qa1AROnzflrVrnCMRfjEeC6MyFecZs6Oasf93l21ztEgIrdY2KtNx1K
         2p27y+xawFZoVJYq1xw2kTX2YDQQCYljEBBmVQfZxy4Wfb6FQjiixh3E3BtTEx3EaI0A
         iGOfbOGUZXcU40AeUlMw5R8mcyRPPNrikomeI3CkDC//fMrg7nWgsMCgfUKAbTPnEfj/
         qaFieEIEyFBb/Ihz5mu/lSzOtprP62AG9GOV4rlzVHmv/JJHEozRPeZL30wJ3s/P+5Df
         yVP+rCkMO/3Imq4eJhTLcWxYY8SbjKHC8BlbgebI3tAj0onkSUkwcDRYHr2aKTUQrEWB
         zYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A2wfnvUJcArOzvROBSxEDoq/2XoIUAY6WzwwQK6XXBA=;
        b=JdAXSE6OXNjQUJg9pBWsdUPYP+8wZH6LnZZ/+vh5utdeQ66Q5FLU/QdvQaY5UuisxP
         RsMJx07McBPDorCZe3iaaTbScIJ2NChN84fbdxUcqZtGRQmNiTai7dGmFxBJjVlO0vy+
         Vzo2/EZyDiF1bAQCW/GOZ+s7+Tx06Fl+L2zmYLZZ5A7o5u9Nx5Vw0IINhfKZrJdS7zoH
         9XwqcvOEc2Y8jbBmI2v7zLRi/xF1QaHcYeEOVbJrqoQUMQY2yT14rgtZKhxN7PN4ZYh/
         wBW414yef/vryYtrOV+JEcb4K32cI5LGd18VrZ6tI3A/ZZyu04Tso+/0ryrTLKCvHOy/
         TWsg==
X-Gm-Message-State: AOAM530565kZNTgZjUYSCVL8FJxbTTJFe14sgKd83pWBMk0bZ2zJYV1A
        tUgpvCXQ9YZw99aYk+Yf/L2pzLMjHTRcgZ2Ujg0=
X-Google-Smtp-Source: ABdhPJwWM6oTSAjc4wRs57WscBG5w+nASFiuy+YVLKsV9iMVF+FCGc49KUQHQWCk1HhyNLNvYNpZTOhdDg0A4ZqvkK4=
X-Received: by 2002:a19:c214:: with SMTP id l20mr1072998lfc.56.1592603175449;
 Fri, 19 Jun 2020 14:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200619213347.27826-1-horia.geanta@nxp.com> <20200619213347.27826-5-horia.geanta@nxp.com>
In-Reply-To: <20200619213347.27826-5-horia.geanta@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 19 Jun 2020 18:46:04 -0300
Message-ID: <CAOMZO5AZLUxXhX-Maop8iQc0Qan5YqH2QFXaDpYq0hL+BP-L+w@mail.gmail.com>
Subject: Re: [PATCH 4/4] hwrng: imx-rngc: enable driver for i.MX6
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 19, 2020 at 6:34 PM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:
>
> i.MX6 SL, SLL, ULL, ULZ SoCs have an RNGB block.
>
> Since imx-rngc driver supports also rngb,
> let's enable it for these SoCs too.
>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> ---
>  drivers/char/hw_random/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kcon=
fig
> index 0ad17efc96df..53f6a7e4392f 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -245,7 +245,7 @@ config HW_RANDOM_MXC_RNGA
>  config HW_RANDOM_IMX_RNGC
>         tristate "Freescale i.MX RNGC Random Number Generator"
>         depends on HAS_IOMEM && HAVE_CLK
> -       depends on SOC_IMX25 || COMPILE_TEST
> +       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL |=
| COMPILE_TEST

If in the future more SoCs will use this IP, then we will need to keep
extending this list over and over again.

Maybe you could use:

depends on MACH_IMX || COMPILE_TEST



>         default HW_RANDOM
>         help
>           This driver provides kernel-side support for the Random Number
> --
> 2.17.1
>
