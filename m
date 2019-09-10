Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A850C49ED6
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 10:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE38208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 10:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EGSd4zC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfIJKyi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 06:54:38 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39760 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbfIJKyh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 06:54:37 -0400
Received: by mail-ot1-f65.google.com with SMTP id n7so17822597otk.6;
        Tue, 10 Sep 2019 03:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8ZMbUskOXgI25SOWpInQr+JY4OVqm269xolgAnTkx6o=;
        b=EGSd4zC9zj4ozGWRafNcd7zQYF3M9VsWONRgl+QjdNIEM79+bKsCrFb17BtLyPmqkQ
         CaqcRpp5eDXG9jH5V2QfkHtZpgiizobgVG/UxP9YujE6rzKCYTrFlRxVnwIVLSRV/UbK
         JC54F9CvJcFFMjuNQj9TbNDvhX6hg4iz5/v7LyJNVgyh2NpImytRv2U1Wnv52PIMdyBb
         UMwUWmUsBTDuIjnnoeTvotJasrZzMQcYztjoivFIuxjKa5FEaKUzxamI2/2JBSkPFBT3
         4wyUcsZJkztw4ouOvsuPil5iuLNrXNoZ85Z9ZfO3p0ue5bOrxB/LdREdAYDUIltR/3Bn
         RGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8ZMbUskOXgI25SOWpInQr+JY4OVqm269xolgAnTkx6o=;
        b=lQK89km0cuY0IBcu8OZYZR+rot3pZtUGikmlX/fV3Pjs+vdXDVSuWv04YfTcbiVZf4
         mtajs8UrsjCyoBx6AeNs08XLMuRPrrp1JvCI7EaZAn726/qYDHWiGGw4YBW8/mE5mg6w
         sXscow1M71JAXRSndho4p/Ap9Ila/zZlugZQapUYMFSNFtvT8DDtVrBbDkuBQv1yKi/M
         Em96Bq1a5xFIObvK/5QruFmPoEHQqK8JkaebM6rxa8yiLmvCbUCgpkvjojADyz9m2nki
         ra/LO6wdgrowl7L3e/s2BaQIbEXWkIAx5uReTGkC91FMz9r5SlTXUGGjMndPJsCJsqry
         wcvg==
X-Gm-Message-State: APjAAAV717JNiy91egyc8x7ZB83uBbdtxf5Ft3N6UPzmafUX9GA11y0H
        B+3x9EnRoWTZ6hYxL1AXFNMJNGNUK2mWOMhoPZ0=
X-Google-Smtp-Source: APXvYqyg34n5MHhPXpxUWiAatELovwJjnUreZtCpVAAiJWUlqu3+uQJg85oSoiYFctwHKQufK14w+RrlW1OXddsgws4=
X-Received: by 2002:a9d:39b7:: with SMTP id y52mr430394otb.205.1568112876680;
 Tue, 10 Sep 2019 03:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190830210139.7028-1-andrew.smirnov@gmail.com>
In-Reply-To: <20190830210139.7028-1-andrew.smirnov@gmail.com>
From:   Yang Li <pku.leo@gmail.com>
Date:   Tue, 10 Sep 2019 11:54:25 +0100
Message-ID: <CADRPPNSRv-WLCbhWmmbsyjaUD0v-_Au8utXDy1z8gx45TnwDwQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: imx8mq: Add CAAM node
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Shawn Guo <shawnguo@kernel.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 30, 2019 at 10:05 PM Andrey Smirnov
<andrew.smirnov@gmail.com> wrote:
>
> Add node for CAAM - Cryptographic Acceleration and Assurance Module.
>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>

The patch itself looks good to me.

Acked-by: Li Yang <leoyang.li@nxp.com>

> Cc: Cory Tusar <cory.tusar@zii.aero>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>
> Shawn:
>
> Just a bit of a context: as per this thread
> https://lore.kernel.org/linux-crypto/20190830131547.GA27480@gondor.apana.=
org.au/
> I am hoping I can get and Ack from you for this patch, so it can go
> via cryptodev tree.

The dts is describing the hardware and normally update to it shouldn't
break old drivers.  Not sure if this time the dts change is depending
on driver change again?   I remember previously arm-soc maintainer
prefer to have dts changes merged with soc trees as a common practice.

Regards,
Leo

>
> Thanks,
> Andrey Smirnov
>
>  arch/arm64/boot/dts/freescale/imx8mq.dtsi | 30 +++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/=
dts/freescale/imx8mq.dtsi
> index d09b808eff87..752d5a61878c 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
> @@ -728,6 +728,36 @@
>                                 status =3D "disabled";
>                         };
>
> +                       crypto: crypto@30900000 {
> +                               compatible =3D "fsl,sec-v4.0";
> +                               #address-cells =3D <1>;
> +                               #size-cells =3D <1>;
> +                               reg =3D <0x30900000 0x40000>;
> +                               ranges =3D <0 0x30900000 0x40000>;
> +                               interrupts =3D <GIC_SPI 91 IRQ_TYPE_LEVEL=
_HIGH>;
> +                               clocks =3D <&clk IMX8MQ_CLK_AHB>,
> +                                        <&clk IMX8MQ_CLK_IPG_ROOT>;
> +                               clock-names =3D "aclk", "ipg";
> +
> +                               sec_jr0: jr@1000 {
> +                                       compatible =3D "fsl,sec-v4.0-job-=
ring";
> +                                       reg =3D <0x1000 0x1000>;
> +                                       interrupts =3D <GIC_SPI 105 IRQ_T=
YPE_LEVEL_HIGH>;
> +                               };
> +
> +                               sec_jr1: jr@2000 {
> +                                       compatible =3D "fsl,sec-v4.0-job-=
ring";
> +                                       reg =3D <0x2000 0x1000>;
> +                                       interrupts =3D <GIC_SPI 106 IRQ_T=
YPE_LEVEL_HIGH>;
> +                               };
> +
> +                               sec_jr2: jr@3000 {
> +                                       compatible =3D "fsl,sec-v4.0-job-=
ring";
> +                                       reg =3D <0x3000 0x1000>;
> +                                       interrupts =3D <GIC_SPI 114 IRQ_T=
YPE_LEVEL_HIGH>;
> +                               };
> +                       };
> +
>                         i2c1: i2c@30a20000 {
>                                 compatible =3D "fsl,imx8mq-i2c", "fsl,imx=
21-i2c";
>                                 reg =3D <0x30a20000 0x10000>;
> --
> 2.21.0
>


--=20
- Leo
