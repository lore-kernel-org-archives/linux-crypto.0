Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E52EC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 13:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0483A2146E
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 13:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uEdL9aQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfLQNHf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 08:07:35 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42466 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQNHf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 08:07:35 -0500
Received: by mail-io1-f68.google.com with SMTP id f82so10899844ioa.9;
        Tue, 17 Dec 2019 05:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=79YzXGa0/bKZjTejQkahRNRf5+MjE4e315RFe1Zru6E=;
        b=uEdL9aQ//2cvH7MK3vYjzUibPqOMpLbTDYx1ZHIvvwU2pO5qHei8XziqJDijRDJYJc
         HpOlQ4Bv3BgBvbn0qm4M9YVmWWm9cATm4M6kDXKvkICp6eBRBdnaML5iB5AMtVrYkZxY
         /sTSnc9hVxnVnEhbSw/HahNznZNn46SwQPIPn62mZ5zuoE6+eUYBVkPBZe2NcAuYIGgC
         ARr2MHogOpOibXiVkAYHBd/YpByoHF8+unLbdnMqC22s8+AIY4dtlB4gkb/87fW25ZVL
         NavvwR4u+E0Dewwms/s+luNATajh4dh6hCOj07nJj27T51LdntG2qA+h4Y6OVOG3Zfni
         R9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=79YzXGa0/bKZjTejQkahRNRf5+MjE4e315RFe1Zru6E=;
        b=aTbIRa5vWj32AaUVTgOt+iX05P4ZjmD6R7t3wQ9wmUyc9/n1Du1YBtqdYyVkr9qCWW
         wajZb/qCx+ODzT2yS1fYzhi/af/fqRCpio44D5zxCWFpIr0+MNmoUjIWf0ICgoU+KFGO
         ihcpCLgzPQRcpxQR9LprUPLPw6DGKq+lyE3ONLsIOB/tH4MLP2YuD/MWzamTP7tL2X6U
         6y0Yr45Tz8QSFTz+b+wyBRfAzr6DCpYzhyZhRCSKFFbdtlTEyk4G58Okka2NYfuVFnf0
         pi3uYxntxWlkw6ethADMqGUvELJOfscZQE/XvPbg1rTJKRvQyy/JZOTzFPtHpPRg11/Q
         Gwbw==
X-Gm-Message-State: APjAAAVqD7dN2OdDH5LvCzLkJzphjcK/AVSyB5HMjNpuggqaKLMrZyh5
        zaC0jXdtkFP+eR9r8FI8YSBNoShs+YamldpAx0s=
X-Google-Smtp-Source: APXvYqxs0JVvmohGW3CJM38cF0ip/ZTgWWaOjkWzTyyLdlMiI3ZT24dQAZUD4JM9uMEPgvaFWrK8qOAfXcEpluXtEiM=
X-Received: by 2002:a5d:9bd0:: with SMTP id d16mr3776062ion.78.1576588053967;
 Tue, 17 Dec 2019 05:07:33 -0800 (PST)
MIME-Version: 1.0
References: <20191213153910.11235-1-aford173@gmail.com> <20191213153910.11235-3-aford173@gmail.com>
 <VI1PR0402MB3485AB1908AD6B6617CFC08C98500@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485AB1908AD6B6617CFC08C98500@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 17 Dec 2019 07:07:22 -0600
Message-ID: <CAHCN7xLrX0R7Uag2vc1qMp4z=1r3haCWrcp4qJT0H0eC3RiA4Q@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 17, 2019 at 3:11 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 12/13/2019 5:39 PM, Adam Ford wrote:
> > Both the i.MX8MQ and i.MX8M Mini support the CAAM driver, but it
> So do the Layerscape ARMv8-based SoCs:
> LS1012A, LS1028A, LS1043A, LS1046A, LS1088A, LS2088A, LX2160A
>
> > is currently not enabled by default.
> >
> > This patch enables this driver by default.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
> > ---
> > V2:  New to series
> >
> > diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> > index 6a83ba2aea3e..0212975b908b 100644
> > --- a/arch/arm64/configs/defconfig
> > +++ b/arch/arm64/configs/defconfig
> > @@ -845,6 +845,7 @@ CONFIG_SECURITY=y
> >  CONFIG_CRYPTO_ECHAINIV=y
> >  CONFIG_CRYPTO_ANSI_CPRNG=y
> >  CONFIG_CRYPTO_DEV_SUN8I_CE=m
> > +CONFIG_CRYPTO_DEV_FSL_CAAM=y
> This should probably be "m" instead.

Out of curiosity, what is the rule for when things are 'm' vs 'y'?

In the Code Aurora repo, it is set to 'y' and the mainline kernel for
the i.MX6/7, the imx_v6_v7_defconfig is also set to 'y' which is why I
used 'y' here.

I can do a V3 to address the other items you noted, but I want to
understand the rules about the defconfig so I don't make the same
mistake again.

thanks,

adam
>
> Horia
