Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED4DC433FC
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 157C822453
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGNMsh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:48:37 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:37587 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgGNMsQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 08:48:16 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N0Zfg-1kpNO54Buu-00wYyD; Tue, 14 Jul 2020 14:48:14 +0200
Received: by mail-qt1-f173.google.com with SMTP id e12so12598976qtr.9;
        Tue, 14 Jul 2020 05:48:13 -0700 (PDT)
X-Gm-Message-State: AOAM53136LyPXLhI3tS8U4sjkpRtrAH+5vomOVClwR9hUqoTfxYIBN8x
        c3hS627Z4K/Uxg5TyOq3QzstMZvOunD3Sv18VrU=
X-Google-Smtp-Source: ABdhPJz0Z9SjMA2TiRfvVF5+QL/VnAcXuYiITPjmPiu/IFxPN+hb/xCmz8NbiS+7xnqFLUv/TcXHUKAGTUzOUOis+tM=
X-Received: by 2002:ac8:4ccb:: with SMTP id l11mr4345870qtv.18.1594730892682;
 Tue, 14 Jul 2020 05:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200714123920.23711-1-horia.geanta@nxp.com> <20200714123920.23711-6-horia.geanta@nxp.com>
In-Reply-To: <20200714123920.23711-6-horia.geanta@nxp.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Jul 2020 14:47:56 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3eQ2a3QV=0XAumHAOssddAZ_sBs=Y0D736Sp7_P8Jvuw@mail.gmail.com>
Message-ID: <CAK8P3a3eQ2a3QV=0XAumHAOssddAZ_sBs=Y0D736Sp7_P8Jvuw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] hwrng: imx-rngc: enable driver for i.MX6
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:81kDPhRRuj+8IBXZ0Wc3qn8zBLzUvMRlI++0v4OOYmr3S7wJXnU
 wNoa9drx2atFGvHTPDiRxuKj0D7t7Ul7qe6yOtUcgYWEII5sBvOCYGVEYMJC1p4aWi4jWiw
 /ymC/Xq1VE9TXEYRhAfanSG6mZKKdT0ElCXqXtnSyzeNW56LepLNocO/eoQinvMe+M/mJeR
 F2BsrhhFJNPq4bbEcUbdQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+QDhVOF4bgQ=:0VNFKV52MZawUlao+T7Lxd
 gYzJXJ7TPNd2idUBmL8p0VhFr2jFNKCypSTJ+9uqgbEh5ch5Uybvg8j1ReWSERx91kTqsdtIC
 xIozrfhtagb0uyYOnEYOHSoulxmgnVaKmadFZGvYAcGMh3RODYiG25eTwTUjVDQJ2h1nCDe1a
 Phfe2PUJJBil0AFMkw9ydXExhOLstQWoFMRIF4bvaILeSsboJETdavUf90Ke2rLHuk+usGnTi
 5TbCIaXApxremtNHnI/4z9CNcELoKfu5k5ixqEymuKlKZ836NbpayESwz9fysHEp4Z0iJGGMS
 fWaEjPyp3X5VgzuSAzqouwhJYelWMIhf3GWvNu9mlroa3JTT1j0e19a/DgyQcTZvJFz1qa4zz
 g1ZPf9kHoUXLJSPojeum9Euzn6SgCuMCuD73Etmg3BD3RkGDe3H9ZS9mvmi/JgBsLQ9obLjdD
 ZSo06WkDBJ3yCIRaOxqXkp/jL92JuBOPY1CGzm1VLHBGSoTPShhcV53s2qYJgWOxtox080tca
 qiq3XW3jzYaOa+z4/wp39BgR3JpiRtYk/fhiLNqtlu+MTIl/5MAwHMnP5lFbB6Ksy4cY8o2DP
 jkU8jximE4iVem4sILrQUjuS9crCcxdE0EEmV/IzYrxj46RBCC/HUfkVBIkDgWFNcw5gW2S4N
 VkBZCaCjlFcmk0E1YaaS+CeyUImhb8OTBg0+wLgAyF+bHJN/KEALQoBbsd8P20DNiK6GNWysM
 CsvFhjgLcZdBAj3F9LtSL9Yk2RWhGFFI4ydBvK1qkMqY+S9YQDmBj4jAKYoFqQD2x8siBU/qN
 oLIwtBcEa61mjvYqtvlFdbjyXwarDWCjTX8iQ5/CaJ6vQ+QYaNW+JZOVOmTJvYpaiuyXLwLIT
 TtRXaqf5BD8P5fH0WP8J+d/tYXOqSyvoguESxqfBw8ScRTBgpAqSLkCWTVWSIml1SacA3G3s8
 svZXe7W/AcYY9cOIrTgdxrM2xtPrzST0Zucu8E/EE3SlX+uhlDIWq
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 14, 2020 at 2:39 PM Horia Geantă <horia.geanta@nxp.com> wrote:
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 8478eb757f3c..98f95a09ce55 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -255,7 +255,7 @@ config HW_RANDOM_MXC_RNGA
>  config HW_RANDOM_IMX_RNGC
>         tristate "Freescale i.MX RNGC Random Number Generator"
>         depends on HAS_IOMEM && HAVE_CLK
> -       depends on SOC_IMX25 || COMPILE_TEST
> +       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
>         default HW_RANDOM

Are these the only chips that have it? If other i.MX variations have
the same block,
or might have it in the future, maybe just generialize the dependency
to SOC_IMX6
or ARCH_IMX?

> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 9c47e431ce90..84576d2fbf8c 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -350,6 +350,9 @@ static SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);
>
>  static const struct of_device_id imx_rngc_dt_ids[] = {
>         { .compatible = "fsl,imx25-rngb", .data = NULL, },
> +       { .compatible = "fsl,imx6sl-rngb", .data = NULL, },
> +       { .compatible = "fsl,imx6sll-rngb", .data = NULL, },
> +       { .compatible = "fsl,imx6ull-rngb", .data = NULL, },
>         { /* sentinel */ }

In the .dts file you describe the devices as compatible with fsl,imx25-rngb,
so this change is not really needed, unless you want to add non-NULL
.data fields in a follow-up. It is usually a good idea to have the more
specialized compatible strings in the DT, but the driver change won't
do anything here.

       Arnd
