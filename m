Return-Path: <SRS0=Hyrp=2W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFB1C2D0DE
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 22:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E7B2072C
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 22:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WLwZN7rf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgAAWli (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jan 2020 17:41:38 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39585 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbgAAWli (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jan 2020 17:41:38 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so6968185ioh.6;
        Wed, 01 Jan 2020 14:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=onn2kaRu8qHeOZCfu0hDViiisLBTz+9+t6L3wfr8DUc=;
        b=WLwZN7rfzNDtuKGgQ50YNh1Ptb/5IhKEp1Ugg02orWYHliwrTp4i/WpQ84fPfF/xd6
         HM28dUtBsh3qdRrHED54HHve30uwQRjzAe9yPyuiHswRNxuaLNasjUrBpVs9tk9EBfwp
         JGNrtrxVQC0xnUYd7rfBigqkyE8j8CPivvX8tvU4R1Q3l0SXHqq8rBRqTEYWYfeLHDyW
         Hf2wsq6S6sqTNlIQXmmRKJHkdJ4ohYqwcB57i8ZBIBpVkOPQGsqazsTeMuGysznyc6wf
         +I03Lm49PgF63eQ1zzwAsRR2WSYiFbASOunR6KjsX90hy2xzTBNpBqFNcqUvahQS9Z5P
         9gjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onn2kaRu8qHeOZCfu0hDViiisLBTz+9+t6L3wfr8DUc=;
        b=Ad+0QPYJoeYTV5IR16k4+4oByaCBbUDjml06KWVQqXYcllfG6cC3XzNSfIUybq3vCn
         rgfwnEbx+bTzRV9p6tVcgw5dUj/7Uok547+hz2wm8i2k1Y8QLdPO8TYkhaMnla1ar4cR
         C87qgkcrZbM+u+r77EJBi6KcffXNYDNb9suq2wo7ZZqYma3KH65PgL4DZp5UWUVfSck9
         nOA1ROuOHbU+qiYSwK44RYwVwu7Qlgh85o4j2XPaYdTuylqcO8fzJB0DV78Glmf9U2pV
         dmspYJSYtwcHeLtxF6lCH1oln4zYTp7oJP5pHy6ILWaSfsmR4HyVkGkypEUIl391Wcdu
         3aDQ==
X-Gm-Message-State: APjAAAXFj8/hRjPWvxL+Ul07EnSB0xwWfClmHDfM/tO13mfmHsw5haH5
        mq3/jOiupxdtZppnkzWPT972OjUEDH98V6F3V5g=
X-Google-Smtp-Source: APXvYqx6ei8sTZU+VpaBvdE5BPvS2Lf8otC9ORUm8LAyhktY0sGrmucBFvIIqydp9NRNLgqtuEW+yjYVaTvUmJLD5gc=
X-Received: by 2002:a5e:8505:: with SMTP id i5mr49776442ioj.158.1577918497545;
 Wed, 01 Jan 2020 14:41:37 -0800 (PST)
MIME-Version: 1.0
References: <20200101175011.1875-1-michael@amarulasolutions.com>
In-Reply-To: <20200101175011.1875-1-michael@amarulasolutions.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Wed, 1 Jan 2020 16:41:26 -0600
Message-ID: <CAHCN7xL_jAT4PYtkMXZbBy=VCUyzRqYaCbKs0oi6p297CCiOdg@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: dts: imx8mm: Add CAAM node
To:     Michael Trimarchi <michael@amarulasolutions.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-amarula@amarulasolutions.com,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 1, 2020 at 11:50 AM Michael Trimarchi
<michael@amarulasolutions.com> wrote:
>
> Add node for CAAM - Cryptographic Acceleration and Assurance Module.
>

I believe a series similar to this was already done and applied:

https://patchwork.kernel.org/patch/11300663/

adam

> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> ---
>  arch/arm64/boot/dts/freescale/imx8mm.dtsi | 31 +++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
> index 7360dc0685eb..428a8b43086e 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
> @@ -667,6 +667,37 @@
>                                 status = "disabled";
>                         };
>
> +                       crypto: crypto@30900000 {
> +                               compatible = "fsl,sec-v4.0";
> +                               #address-cells = <1>;
> +                               #size-cells = <1>;
> +                               reg = <0x30900000 0x40000>;
> +                               ranges = <0 0x30900000 0x40000>;
> +                               interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> +                               clocks = <&clk IMX8MM_CLK_AHB>,
> +                                        <&clk IMX8MM_CLK_IPG_ROOT>;
> +                               clock-names = "aclk", "ipg";
> +                               status = "disabled";
> +
> +                               sec_jr0: jr0@1000 {
> +                                        compatible = "fsl,sec-v4.0-job-ring";
> +                                        reg = <0x1000 0x1000>;
> +                                        interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
> +                               };
> +
> +                               sec_jr1: jr1@2000 {
> +                                        compatible = "fsl,sec-v4.0-job-ring";
> +                                        reg = <0x2000 0x1000>;
> +                                        interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
> +                               };
> +
> +                               sec_jr2: jr2@3000 {
> +                                        compatible = "fsl,sec-v4.0-job-ring";
> +                                        reg = <0x3000 0x1000>;
> +                                        interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
> +                               };
> +                       };
> +
>                         i2c1: i2c@30a20000 {
>                                 compatible = "fsl,imx8mm-i2c", "fsl,imx21-i2c";
>                                 #address-cells = <1>;
> --
> 2.17.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
