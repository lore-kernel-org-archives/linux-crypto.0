Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255BFC43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E95F521871
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:54:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjTCr5v8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfIGRyM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Sep 2019 13:54:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52487 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfIGRyM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Sep 2019 13:54:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id t17so9535141wmi.2;
        Sat, 07 Sep 2019 10:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hiUXBkiQbc16IdopYPDPirbBRyqBVObPwXAlnyGJKFM=;
        b=FjTCr5v8LuQgVVNsuDdiwTTeimQZm0P9jI5mkwRE55/MwI5OMxqV6tDISyp8Ghxtfv
         cICzYY9w8DsHGC4tCzwWzzPZ4oDJhTeuu0PaD+YqSugVSapkGnyeEDiJXo3Np9ao5f5Y
         kVYGYcbLkRQ5rNx7ADwCHab6WWS55lPJ0VnGYaSsGWu5urDfuWxojP3ej/bv4eSWPEXQ
         Pnx+PmVCC7CULc+68zAoxNW128zHZqkMAMlj/OEVNrjPg+KwD4hLWvyGRRHr6dOC3fUL
         y7+JvbDH66lW/Vb9o9IXS07zUkYyfagHelRqbL77GJugZIRVueMOGqvEEX7/DNSZDTBa
         pJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hiUXBkiQbc16IdopYPDPirbBRyqBVObPwXAlnyGJKFM=;
        b=SO3DUcWTHW3h1qR/EwfXWnzhNqXvDgXkcExLgbM/w8YTsp0nzX/nt2GAHtmwM81O4y
         wIDGqSCuu1ywkOR7rQRO7ANX0qIAbvQv7bGyT689tv4nZLcwmcWqv3RD05fbQXf1ivyS
         JrnC1z36Qxx4YxZfzduD/T8WbUtLrF2Ngy+z/tC4cYfLNLhKQsSJIrvWxTecetlcy1nJ
         uCDm5zOT+I1JJCI46ol5p21Lw0q8Eln0bI78weHC0yXgHX+YC29+NCMuSjbQiTmRZc9d
         RFutNMsjbPiQ6Vq/x3Dl4b2/V1jjUqYbFh6vya41BLscHyey6jnUDu+im32Dwfs8yOnf
         /RlA==
X-Gm-Message-State: APjAAAVEtkOvTRzFS0zAQaWkRBSEgI84Ne+DhGvJiEJo0cwXm6ZU7+M9
        psXSxeF6kLKJoTCik6bLGAo=
X-Google-Smtp-Source: APXvYqzeU9yRw1n3fBHksbV82lOrLtD14+mnTih2C50hKWyUxYtUbZ3svSZc/H2l0oAT/0tZcV+tmA==
X-Received: by 2002:a1c:7c15:: with SMTP id x21mr13095007wmc.154.1567878849794;
        Sat, 07 Sep 2019 10:54:09 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id b194sm20110217wmg.46.2019.09.07.10.54.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:54:09 -0700 (PDT)
Date:   Sat, 7 Sep 2019 19:54:07 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 4/9] ARM: dts: sun8i: r40: add crypto engine node
Message-ID: <20190907175407.GB2628@Red>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-5-clabbe.montjoie@gmail.com>
 <20190907040217.kzvq7gfxz67pluhz@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907040217.kzvq7gfxz67pluhz@flea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 07, 2019 at 07:02:17AM +0300, Maxime Ripard wrote:
> On Fri, Sep 06, 2019 at 08:45:46PM +0200, Corentin Labbe wrote:
> > The Crypto Engine is a hardware cryptographic offloader that supports
> > many algorithms.
> > It could be found on most Allwinner SoCs.
> >
> > This patch enables the Crypto Engine on the Allwinner R40 SoC Device-tree.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  arch/arm/boot/dts/sun8i-r40.dtsi | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/sun8i-r40.dtsi b/arch/arm/boot/dts/sun8i-r40.dtsi
> > index bde068111b85..7eb649cea163 100644
> > --- a/arch/arm/boot/dts/sun8i-r40.dtsi
> > +++ b/arch/arm/boot/dts/sun8i-r40.dtsi
> > @@ -266,6 +266,17 @@
> >  			#phy-cells = <1>;
> >  		};
> >
> > +		crypto: crypto-engine@1c15000 {
> > +			compatible = "allwinner,sun8i-r40-crypto";
> > +			reg = <0x01c15000 0x1000>;
> > +			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
> > +			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
> > +			clock-names = "ahb", "mod";
> > +			resets = <&ccu RST_BUS_CE>;
> > +			reset-names = "ahb";
> > +			status = "okay";
> 
> The driver will probe if status is not declared, so if you want it
> always enabled you should simply remove status
> 

Fixed, thanks.
