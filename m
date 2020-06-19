Return-Path: <SRS0=Y8jf=AA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85447C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 21:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63755221EC
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 21:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Czjl8mUs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgFSVos (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jun 2020 17:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgFSVor (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jun 2020 17:44:47 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A571DC06174E;
        Fri, 19 Jun 2020 14:44:45 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id i27so13098042ljb.12;
        Fri, 19 Jun 2020 14:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1sgAegVrY9blSblu1TZdk7ru84pddJSX7s1mWVjCFHY=;
        b=Czjl8mUsGQTc1lSxSGKZDq2qIkoZ6c0YedfwqNeO9/0T7FCtDoH+6WQFrBv2cBzdn+
         cTlij+NcIB4hw/sztztKsjOJucRgSFPXQMIUqc4n5vKPHw/RW79ubQomSySgo+NcLgV7
         aYSd0pWD9fM9pHvWiGDu/X2JWn10thzLPJ/ywt4Kr5xfTicjCy4EfEOfJ4l7T2s+12WR
         7DYdsRHaleYRTMnzSDkHx2Bd4WaYvBuGAuHV07pIZjiBZXqrzVJ6JcamAqWj61NbgJth
         RuR6z4fvyJrc606GLz6XhDXvx6iQY1LjQnPQEz6Ey8+H4RHrG+VTDCXPBvL8d1MtdJ49
         53Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1sgAegVrY9blSblu1TZdk7ru84pddJSX7s1mWVjCFHY=;
        b=K39MV9qmMKF1ccHbxT16/RB4ZiEvMljQVWsb45xBRkWHkZZHyuMsviyjWPUZa94PRD
         aDxin7mlOjvOGVqbmfV/K8t6PNpYm0KjZv8jAFomtC+qRRrE+ritLJrn3pjisfrTiHqJ
         hFFwwiDXlBdiA4vNRX5/YxI9AHGqTsbCKysod7UDJjDEgJMlQcQ6DueTwzQb2MvWy9qX
         W3itnaRL2mFe+lyai1ODfFaOpVfiZxaNhAuKEIVi18wEqq9lqK1QdfkUaR/m6RBm9B2p
         /1uuALQIMX5epuZr14ribK+LHn6JMJsPW8/0u976xve0p13bwrTRGOxLDhOK4Qbt3Zjt
         jsdg==
X-Gm-Message-State: AOAM532OLzB5vuYk+ghKFvcUMlUd53/JyiQzSaerB1Hmta06Qw50slpR
        FaOUgwSgOqPS6v2Znh5MrlrAvfF0N/KKN0euvKg=
X-Google-Smtp-Source: ABdhPJzth0b/GB5i9sTZrVdEB33+r8JFn7mOeJFab1oUENjMBKqhM+AUuD9N/PknddsJzKwtRM4C3kCreusmjXDymdk=
X-Received: by 2002:a05:651c:2050:: with SMTP id t16mr2568936ljo.178.1592603083925;
 Fri, 19 Jun 2020 14:44:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200619213347.27826-1-horia.geanta@nxp.com> <20200619213347.27826-2-horia.geanta@nxp.com>
In-Reply-To: <20200619213347.27826-2-horia.geanta@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 19 Jun 2020 18:44:32 -0300
Message-ID: <CAOMZO5AMe-nDdaP+jVeUHEGn_FXiN9x29PsvDGzUmd9bRD3T6Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: dts: imx6sl: fix rng node
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

Hi Horia,

On Fri, Jun 19, 2020 at 6:34 PM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:
>
> rng DT node was added without a compatible string.
>
> i.MX driver for RNGC (drivers/char/hw_random/imx-rngc.c) also claims
> support for RNGB, and is currently used for i.MX25.
>
> Let's used this driver also for RNGB block in i.MX6SL.

"Let's use"

>
> Fixes: e29fe21cff96 ("ARM: dts: add device tree source for imx6sl SoC")
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> ---
>  arch/arm/boot/dts/imx6sl.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dts=
i
> index 911d8cf77f2c..1f0f250ee175 100644
> --- a/arch/arm/boot/dts/imx6sl.dtsi
> +++ b/arch/arm/boot/dts/imx6sl.dtsi
> @@ -939,8 +939,10 @@
>                         };
>
>                         rngb: rngb@21b4000 {
> +                               compatible =3D "fsl,imx25-rngb";

Better to use:

 compatible =3D "fsl,imx6sl-rngb","fsl,imx25-rngb";

and document fsl,imx6sl-rngb
