Return-Path: <SRS0=7V1w=66=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E5BC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 May 2020 16:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4337D206D8
	for <linux-crypto@archiver.kernel.org>; Sat, 16 May 2020 16:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1kduRrm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgEPQnG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 May 2020 12:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgEPQnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 May 2020 12:43:06 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A957C061A0C;
        Sat, 16 May 2020 09:43:06 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j8so5953916iog.13;
        Sat, 16 May 2020 09:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=es9nL54eWtZHft09jub95D9GHT1PJmvu2Z8TIUZE1HE=;
        b=M1kduRrmNJ2LfBxzdNYtGyJIwFzAT8zQ07ft97xpD7bINmJeTahKoii+pK8MSBuefX
         jTNWAKUldm4hLlI4GQAox/u0GNKJg1Jy+PeFq9IcrjhZd9G1gtqJzJDdtYar8DmV+9X5
         2JYcRhXv455Hp8H/VI9+SgmLsccCrRiTizqJmVU53PGnO7ghr2hyyy/eSERlASO6QYq4
         AhiTJ25AR/74KnKmYpT05UZmPcrduy9yWJLEJMgYLw09yfoBz0adOZCl9kpW4PDVHXx7
         SMQoJ51RzgphlHzkts7N9X0wVhnBeeN/KjjSJTbb69LFzZHet7JJxtlwYu2A/MENSg1u
         Nxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=es9nL54eWtZHft09jub95D9GHT1PJmvu2Z8TIUZE1HE=;
        b=G39ej229Rbh/agbeGxMvo5taCRZMXmcriDlwRxc1k6hXgav1gvOvILt2A7rJ7vgA6O
         Gpn5QCn8PXi4c70WD9YOaEqPQnrj15IY6qiaMLHl+RKc2q4jPqjFzfOto2pdLEiVmPoy
         L2aC2UN56VJ1eIX9idEo77NJQS+rYkoA/kNqrSH03gjvsl/sB5thw6mCdMkubm7YBE2L
         Yz4CgEnBo2qNIU7bDKpIFj1c2HQxjMmRtSXn6N6z7fpAeJa8pl7PYxArsQDp33+f3Ea0
         BpJf2WJAvmU672f+0SrTYwu75WTENmzLedKsQHNqop01D4n9onYrwl5yp1/NL4EXpp6/
         a0nw==
X-Gm-Message-State: AOAM533OCCGLOLw4xFsjuzGLOWGzSMATY5bkQQ6mgG7R6cQYVeh9sPk8
        V48+l/DWAiKKprlHVldFQmD6/TQog6S2wUrAUY4=
X-Google-Smtp-Source: ABdhPJyWt1i35sqAOn9/rO23bWin4il7OPHMsfMMrRANxiNO7OJknI3O+Ga/dVCgUlPGa/if769CICudAjNGcHdWOyk=
X-Received: by 2002:a5e:8717:: with SMTP id y23mr7822272ioj.172.1589647385473;
 Sat, 16 May 2020 09:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200516042303.6070-1-andrew.smirnov@gmail.com>
In-Reply-To: <20200516042303.6070-1-andrew.smirnov@gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sat, 16 May 2020 09:42:51 -0700
Message-ID: <CAFXsbZoZWzD5deLfCS=rMcw80-gBcm30_3CSMm--Cc-fPSq=BA@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - make soc match data optional
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>, linux-imx@nxp.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With all four of Vybrid VF610, i.MX6q, i.MX6qp, and i.MX8M, this patch
caused no regressions for me.  Additionally, with the VF610 and a
follow on devicetree patch, the CAAM is detected and works.

Tested by: Chris Healy <cphealy@gmail.com>

On Fri, May 15, 2020 at 9:23 PM Andrey Smirnov <andrew.smirnov@gmail.com> w=
rote:
>
> Vyrbrid devices don't have any clock that need to be taken care of, so
> make clock data optional on i.MX.
>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Horia Geant=C4=83 <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: linux-imx@nxp.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/caam/ctrl.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 4fcdd262e581..6aba430793cc 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -630,12 +630,7 @@ static int caam_probe(struct platform_device *pdev)
>         imx_soc_match =3D soc_device_match(caam_imx_soc_table);
>         caam_imx =3D (bool)imx_soc_match;
>
> -       if (imx_soc_match) {
> -               if (!imx_soc_match->data) {
> -                       dev_err(dev, "No clock data provided for i.MX SoC=
");
> -                       return -EINVAL;
> -               }
> -
> +       if (imx_soc_match && imx_soc_match->data) {
>                 ret =3D init_clocks(dev, imx_soc_match->data);
>                 if (ret)
>                         return ret;
> --
> 2.21.3
