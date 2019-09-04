Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4603EC3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13EB021897
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:43:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uXsOnRFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDCn3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:43:29 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34625 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfIDCn3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:43:29 -0400
Received: by mail-lf1-f66.google.com with SMTP id z21so14591587lfe.1;
        Tue, 03 Sep 2019 19:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CwK23xPpYFlnNotNnYk+1iYKSuN+ml12AXV6B26pZf0=;
        b=uXsOnRFFDi2b8/ipU2eyjEB3sSKJayZpraSUjoggznxbw/R7pF/aI4ttIMPV8kUsva
         0QqQycJ7+LTyV7LAGsFFsLCBh6NktgFgU5hq5EujBpHh3rqh60TD6KhxYGbdN+lBSJUV
         T4WoDTZUseQllvOI/axceEgvkbFc3YJMKc/XSfdSxk1GMp4Wqz71DuQ//HCRb7+OZtAa
         SHV7IPHAZ0lJA7qa7DKF/EgDk04j4e3ZTRX6SHwzlpXU8X1vxBjp2ZHTkcqZSdnCNfNM
         2hXTkzS/iirtOFyIM/xaTsoAN27LMJUe8Cb+86aRBN78dsICoOq5L41ZoRZc98RWbcJK
         iLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CwK23xPpYFlnNotNnYk+1iYKSuN+ml12AXV6B26pZf0=;
        b=hMSA1+69/g011VrUxiskL2P44XF7r6x6btV7CzVZ4RvhMbE4iyFf0l9cNfKsgkAmM1
         gKAf6gGoDMe7uatFEx+jdI6Gy4O+gor88BAirKPlnetDtG3yuCwFRXDrt3orQa/VHIXp
         z69jWfoTDiXhxgFbBCz7LmFcjqAWS8GYYPFB32h42oePepzgda2SOTDqmPhpumJbSWlQ
         j4DU0QjZjr/4u8M4FG14Mu5qImPT8Ac09SlUvXGAMMmSS8iBGHtDBP6Op60WbVqOZZ5o
         ROh7549XUDOUD7KGP2aH/uoL/074x4i12tt5SAH0NshBnxfrvn/3sAiLaLbj0ioi60S4
         Hx6w==
X-Gm-Message-State: APjAAAVaEsMknxE+moIADj1AE2mq9Rzz3XApPyAHA97XWwhPaIrUyXmQ
        BgsnB9/gBYryLaZd8bIUcLMimcv0/tos+Rd1j+c=
X-Google-Smtp-Source: APXvYqxxhG04p1JNdfc68KG2HLqo7QVaF0mE1eci4BxrF4cMUB6MUeLAvMcIVfgCy4HjHb+tYw/36YgwU/Vnd1P0NDk=
X-Received: by 2002:a19:2207:: with SMTP id i7mr22422761lfi.185.1567565007131;
 Tue, 03 Sep 2019 19:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190904023515.7107-1-andrew.smirnov@gmail.com> <20190904023515.7107-3-andrew.smirnov@gmail.com>
In-Reply-To: <20190904023515.7107-3-andrew.smirnov@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 3 Sep 2019 23:43:17 -0300
Message-ID: <CAOMZO5DoaLkycXOfzYQv2CHKSRA9sri5igaVSNhQvxR06Gzv+g@mail.gmail.com>
Subject: Re: [PATCH 02/12] crypto: caam - use devres to unmap JR's registers
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrey,

On Tue, Sep 3, 2019 at 11:37 PM Andrey Smirnov <andrew.smirnov@gmail.com> w=
rote:
>
> Use devres to unmap memory and drop explicit de-initialization
> code.
>
> NOTE: There's no corresponding unmapping code in caam_jr_remove which
> seems like a resource leak.
>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geant=C4=83 <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/caam/jr.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 417ad52615c6..7947d61a25cf 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -498,6 +498,7 @@ static int caam_jr_probe(struct platform_device *pdev=
)
>         struct caam_job_ring __iomem *ctrl;
>         struct caam_drv_private_jr *jrpriv;
>         static int total_jobrs;
> +       struct resource *r;
>         int error;
>
>         jrdev =3D &pdev->dev;
> @@ -513,9 +514,15 @@ static int caam_jr_probe(struct platform_device *pde=
v)
>         nprop =3D pdev->dev.of_node;
>         /* Get configuration properties from device tree */
>         /* First, get register page */
> -       ctrl =3D of_iomap(nprop, 0);
> +       r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!r) {
> +               dev_err(jrdev, "platform_get_resource() failed\n");
> +               return -ENOMEM;
> +       }
> +
> +       ctrl =3D devm_ioremap(jrdev, r->start, resource_size(r));

It seems that using devm_platform_ioremap_resource() could make the
code even smaller.

Regards,

Fabio Estevam
