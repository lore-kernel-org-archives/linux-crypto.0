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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D232C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02452218AF
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMjOvXX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfIGRy6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Sep 2019 13:54:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39263 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfIGRy6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Sep 2019 13:54:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so9663867wra.6;
        Sat, 07 Sep 2019 10:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ovbKflYW79On+Fsg/qSycQWq4G2Zyk4xgAJcuJTNrQE=;
        b=MMjOvXX6FOdobS1o/knW8/vtxdKc8kvVlOmPhNxCcRiVP8q1OfMXvUqDdhuUvOzpiC
         TVWX98ItImvUtC0khuAByixFUi3LpdN5/fns1QDA9bcPfViQSuDD28haLMn06ACXAYgX
         rqRcnb+QzMG4vZaFJE+kBw5gRDA+BSEdtxsowJW0sVDvIUmnCzp6AVzl71HaGH9UKqoR
         SZVwdEsODiDTBxG5AGaUab29TbuF9oZjQRgDhY+tUT0Tabjo4UJj55nbudNEXR+G9xzn
         leUZ4hQB29KXl2M+ftSIX+6oNwlge421xodj6u6l1N7rHGz2s2cw2FS2fs1MW7TZeYxo
         dskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ovbKflYW79On+Fsg/qSycQWq4G2Zyk4xgAJcuJTNrQE=;
        b=axKkE9RQYCQjAdt++Z9aV/wKhZkVJm5OhQIyAh7PxL4RNcMMU2KWo26l4gVqZlbDwZ
         GT8oXiB5rF+QlYBpDCT6wGQzoDQkBE/AQm4Cij45YkraBClPuk9Ata2lQ7PuQnDLNebJ
         gvUz9iWnUNbRpVIIAIntbU/TMkrX3wMfK2cxzyldKEoBiSfrInzBWmx0TukTXstZNzi5
         ifDVY3dLXT1b8pRtXS6aNPotZnIVvg+GY/oLmBskUInURQyHeIBQprhC/rgymD5DM2X4
         qD00SZAMi97P7DXMWrDP/fz2N9yOKRmqWE6TVCWMs60p4aGCcnGcTETZezRnD7ftpF8K
         CNhA==
X-Gm-Message-State: APjAAAWb2NExNUYlNcEwPHRyOvBbieFIyJK7o6u5HucRQMNMckG8Zx59
        abhkW5UmUs+aGPQJmF8/Ryk=
X-Google-Smtp-Source: APXvYqxqWP4aI4thp5ItxRe7R6UE5g455JNPLFP3xI9VD1ihOeyPmluNOVL2aFGZVmrmK+t59LPK7A==
X-Received: by 2002:a5d:5402:: with SMTP id g2mr12765767wrv.291.1567878895713;
        Sat, 07 Sep 2019 10:54:55 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id g24sm14618765wrb.35.2019.09.07.10.54.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:54:55 -0700 (PDT)
Date:   Sat, 7 Sep 2019 19:54:53 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 6/9] ARM64: dts: allwinner: sun50i: Add Crypto Engine
 node on A64
Message-ID: <20190907175453.GC2628@Red>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-7-clabbe.montjoie@gmail.com>
 <20190907040254.5ecohywqbekokwfx@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907040254.5ecohywqbekokwfx@flea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 07, 2019 at 07:02:54AM +0300, Maxime Ripard wrote:
> On Fri, Sep 06, 2019 at 08:45:48PM +0200, Corentin Labbe wrote:
> > The Crypto Engine is a hardware cryptographic accelerator that supports
> > many algorithms.
> > It could be found on most Allwinner SoCs.
> >
> > This patch enables the Crypto Engine on the Allwinner A64 SoC Device-tree.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> > index 69128a6dfc46..c9e30d462ab1 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> > @@ -487,6 +487,17 @@
> >  			reg = <0x1c14000 0x400>;
> >  		};
> >
> > +		crypto: crypto@1c15000 {
> > +			compatible = "allwinner,sun50i-a64-crypto";
> > +			reg = <0x01c15000 0x1000>;
> > +			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
> > +			interrupt-names = "ce_ns";
> 
> You didn't document that property
> 

It is unnecessary, I forgot to remove it.
Fixed, thanks.

