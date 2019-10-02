Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A3DECE58B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 08:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBB92190F
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 08:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsrXNzo8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfJBIoJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 04:44:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44995 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJBIoJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 04:44:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id z9so5477207wrl.11;
        Wed, 02 Oct 2019 01:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QP3i5oRbnEcOsn2Nh4j8y0vWxevdrVw2BJcYZbqFbx4=;
        b=UsrXNzo8+90vsV5ERk4uasjuBQGbONq6vSFSId/rzHWsOKsIH5vuVz+2kTf4k+kfPJ
         zlPjLQvVdfMDM+hpYnookmcXVT04tpSTVD3T7epCC4T3jmmCHGpGKflcOJXl7ytEwbrc
         mIhuIwcridGT5YJgVgDGqhCgUm9st82V0u/43S2eQImyRX7+H3iZsdR0Y3fI1IvI99J+
         CZ09owxjQzF8wkdiQi5FCTl+dQg1fRdAHHq+xjn2aE5MXMfwaXr+b5QvZSRBjxE1/w4t
         2O20e8iVBfJ2doPgA3UMYCC22SiiotLOiGtRopEopwI0vLT9ybSgrmT/cxBo+AShmR8a
         7u/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QP3i5oRbnEcOsn2Nh4j8y0vWxevdrVw2BJcYZbqFbx4=;
        b=WAS3iY4Gc1VQr3DNNBYnACR+LwLSaATz1V4UBlu2ZHnNaZqbo4wC0/TeblfUrKd+15
         GIUlEhu1+nwLP+pgUrpzbTN1NNWv/GtcicZ1STwsA7Xe7nWMkWUrVGCvhJkpwuYaE9Rq
         HFC2+FD2anttiAys4TyvqHPWKEdspUtlVWhc+ffvj+fAy+2r31TrbJX+zUt1nPEsCCzN
         iISeEGWRP9WBUbTMFs1RZ2QcyrlWaKfkYo/pzKiBipp7cff/vNaZxduPLF7DdMbT5+/0
         V6z5Vo10weRn4edqSHRbI5MvAXVS5RwPs/VVMZd5TASmwPEHjEBMvsU/bL9Vt9k+vLRo
         b7Cw==
X-Gm-Message-State: APjAAAXAAz58b1QgVYuSFdWFFPV3K/Xvu/EI5AjTqbfPqvvhE/0bVrNd
        qTa/CHG6byp9F9MrFmhV1cI=
X-Google-Smtp-Source: APXvYqzIqo97fauDu2NNtpT95i5jes5tUblWKnlFRoxJmsyAkkvAGFGwphEVnugX59rbhtZRvfWFgw==
X-Received: by 2002:adf:ce83:: with SMTP id r3mr1869573wrn.219.1570005847043;
        Wed, 02 Oct 2019 01:44:07 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y5sm6524440wma.14.2019.10.02.01.44.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 01:44:06 -0700 (PDT)
Date:   Wed, 2 Oct 2019 10:44:04 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 05/11] ARM: dts: sun8i: H3: Add Crypto Engine node
Message-ID: <20191002084404.GA3101@Red>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
 <20191001184141.27956-6-clabbe.montjoie@gmail.com>
 <20191002060214.bu67nkd3y6puknrb@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002060214.bu67nkd3y6puknrb@gilmour>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 08:02:14AM +0200, Maxime Ripard wrote:
> On Tue, Oct 01, 2019 at 08:41:35PM +0200, Corentin Labbe wrote:
> > The Crypto Engine is a hardware cryptographic accelerator that supports
> > many algorithms.
> > It could be found on most Allwinner SoCs.
> >
> > This patch enables the Crypto Engine on the Allwinner H3 SoC Device-tree.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  arch/arm/boot/dts/sun8i-h3.dtsi | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
> > index e37c30e811d3..778a23a794c9 100644
> > --- a/arch/arm/boot/dts/sun8i-h3.dtsi
> > +++ b/arch/arm/boot/dts/sun8i-h3.dtsi
> > @@ -153,6 +153,17 @@
> >  			allwinner,sram = <&ve_sram 1>;
> >  		};
> >
> > +		crypto: crypto@1c15000 {
> > +			compatible = "allwinner,sun8i-h3-crypto";
> > +			reg = <0x01c15000 0x1000>;
> > +			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
> > +			interrupt-names = "ce_ns";
> 
> That's not documented in the binding (and I guess unnecessary)
> 

Hello

Yes this should be removed.

> > +			resets = <&ccu RST_BUS_CE>;
> > +			reset-names = "bus";
> > +			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
> > +			clock-names = "bus", "mod";
> 
> Nit: we put the clocks before the resets usually
> 

Will do it.

Thanks
Regards
