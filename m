Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE06FC35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 08:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46E621D82
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 08:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4ga2iLE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfJBIob (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 04:44:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45592 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJBIoa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 04:44:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so18569730wrm.12;
        Wed, 02 Oct 2019 01:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8K7h7HUyw90enLd8fQVTYuZsXONTGa9SFgE/KcYk7vs=;
        b=H4ga2iLEryrxqvflHTtca2vKkCgGeokG+ejsoRMU0WVStBKbBr8fcIcjoXakIR69eT
         Qpwddh8aBaHsjRgog6AA7cFmSDh+ctXZlDsQ8V2j84lvjACGjeZtU1gQZKMlia8aO5/t
         7OvtGl+BWcY16ginjj4LY7nyIwNKioxsUwvg2aCCepCJk44+KJF9QVG1wwlUzE65Q0OE
         d1jB+RKlRDnhBz5CWqBUXNhV66xm5hwyjgqvWqTg/LTCyJWvmIvu+Lb7fRX5F6wiU4zb
         B83/tC1MXvsEz/JYD+jLfZFd0THvnIwQcJO0XWpVcngBpZ3GDNd25eqbeZBtRnKdZsiP
         mSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8K7h7HUyw90enLd8fQVTYuZsXONTGa9SFgE/KcYk7vs=;
        b=PNL9RJp+6FL3t5xXNAOHn8ar1VRLw61ptAn/0HSKR/5U2XngC3ybxuam2X+j/PGe42
         9HY8gR2esiSnmeEkZ39kh7WzAeTY6BxFgoBD9hiiSzMA03SlpbPf4mElY8OCs6IjB+sz
         Xy5t182WTmSbZmiaJpXnNPcVfy6Cso6GiPcAGTx8/UeEDFJGdOBxFp83mrd0WGokNIQr
         ++LymrWFiSog0tUPZ9tZQLHa+/xLry1yxHZH5+5f1NeVjYoOk7Hj97h6N7JpYASfUaB4
         y6O+tgXUNuixbvUw7IOaXmQY8M/J9ztUtctkohoZAAdm8APKPh4L9pxC2DHKp+ckpwUh
         bsyA==
X-Gm-Message-State: APjAAAVxdnbpLO6q9Ncz+z8JHLHp8RaNyBHW5DmxBNx4tZA24f1F94mX
        WqVNWBU3lUAZZeAJ7AIZ674=
X-Google-Smtp-Source: APXvYqwU9NBbWZxUMWnf59AxkO4xub+qdOeGyBh+vhJmkqA5LxZqkHxzsR61IjlUIUupcBWIrJEqrQ==
X-Received: by 2002:adf:e701:: with SMTP id c1mr1759802wrm.296.1570005868747;
        Wed, 02 Oct 2019 01:44:28 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h10sm4269419wrq.95.2019.10.02.01.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 01:44:28 -0700 (PDT)
Date:   Wed, 2 Oct 2019 10:44:26 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Priit Laes <plaes@plaes.org>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v2 04/11] ARM: dts: sun8i: R40: add crypto
 engine node
Message-ID: <20191002084426.GB3101@Red>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
 <20191001184141.27956-5-clabbe.montjoie@gmail.com>
 <20191002080827.GB6347@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002080827.GB6347@plaes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 08:08:27AM +0000, Priit Laes wrote:
> On Tue, Oct 01, 2019 at 08:41:34PM +0200, Corentin Labbe wrote:
> > The Crypto Engine is a hardware cryptographic offloader that supports
> > many algorithms.
> > It could be found on most Allwinner SoCs.
> > 
> > This patch enables the Crypto Engine on the Allwinner R40 SoC Device-tree.
> > 
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  arch/arm/boot/dts/sun8i-r40.dtsi | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/sun8i-r40.dtsi b/arch/arm/boot/dts/sun8i-r40.dtsi
> > index bde068111b85..1fc3297a55ec 100644
> > --- a/arch/arm/boot/dts/sun8i-r40.dtsi
> > +++ b/arch/arm/boot/dts/sun8i-r40.dtsi
> > @@ -266,6 +266,16 @@
> >  			#phy-cells = <1>;
> >  		};
> >  
> > +		crypto: crypto-engine@1c15000 {
> 
> All the other .dtsi files have `crypto: crypto@...` instead of crypto-engine.
> 

Hello

I will fix that.

Thanks
Regards
