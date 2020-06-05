Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4B3C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 472ED207D8
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:27:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="GWG19R4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgFEJ1n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 05:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgFEJ1n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 05:27:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D89EC08C5C2;
        Fri,  5 Jun 2020 02:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JD+f68C2xsdIda1o1WPqknMCkMS5OJ8axT7mWVbzTRo=; b=GWG19R4tIHcgtyxteX9uf10fE
        Z7WE2epE/MSItPTXR+xqspTQxH6YYeuyf77a9K8BzhLG1DnAAZcNcrtSQjXOoXrxOnxcz1mjFw40K
        nSHrepHcaoQaIO8hUwaFq3LV7fOPwfekVShU8hky0XpzRdL4JR35CYeaVsIeRIxQh+OhQOmzBtgjj
        JXUyZR1FY1SjUc+B5VpL5f96FdupwBcPTPSGW97+WWiTO0OD/KYX25FWsC82Jpmaj51svWJyJgK4h
        uRsnY2W0Pyr8ypDvkUme5dMS8gpKoiSGoAFv9PNjSB/7k1PvVIpQZZAh/eMLnMzcPbsvhP+Ah7akZ
        mbIqw9Ujw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:49630)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jh8dR-0001kC-TS; Fri, 05 Jun 2020 10:27:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jh8dC-0007LF-Q0; Fri, 05 Jun 2020 10:27:18 +0100
Date:   Fri, 5 Jun 2020 10:27:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Julius Werner <jwerner@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Crystal Guo =?utf-8?B?KOmDreaZtik=?= <Crystal.Guo@mediatek.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Security Random Number Generator support
Message-ID: <20200605092718.GH1551@shell.armlinux.org.uk>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
 <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
 <1591169342.4878.9.camel@mtkswgap22>
 <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
 <20200603093416.GY1551@shell.armlinux.org.uk>
 <1591341543.19510.4.camel@mtkswgap22>
 <20200605080905.GF1551@shell.armlinux.org.uk>
 <1591347582.21704.9.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591347582.21704.9.camel@mtkswgap22>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 04:59:42PM +0800, Neal Liu wrote:
> On Fri, 2020-06-05 at 09:09 +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jun 05, 2020 at 03:19:03PM +0800, Neal Liu wrote:
> > > On Wed, 2020-06-03 at 17:34 +0800, Russell King - ARM Linux admin wrote:
> > > > This kind of thing is something that ARM have seems to shy away from
> > > > doing - it's a point I brought up many years ago when the whole
> > > > trustzone thing first appeared with its SMC call.  Those around the
> > > > conference table were not interested - ARM seemed to prefer every
> > > > vendor to do off and do their own thing with the SMC interface.
> > > 
> > > Does that mean it make sense to model a sec-rng driver, and get each
> > > vendor's SMC function id by DT node?
> > 
> > _If_ vendors have already gone off and decided to use different SMC
> > function IDs for this, while keeping the rest of the SMC interface
> > the same, then the choice has already been made.
> > 
> > I know on 32-bit that some of the secure world implementations can't
> > be changed; they're burnt into the ROM. I believe on 64-bit that isn't
> > the case, which makes it easier to standardise.
> > 
> > Do you have visibility of how this SMC is implemented in the secure
> > side?  Is it in ATF, and is it done as a vendor hack or is there an
> > element of generic implementation to it?  Has it been submitted
> > upstream to the main ATF repository?
> > 
> 
> Take MediaTek as an example, some SoCs are implemented in ATF, some of
> them are implemented in TEE. We have no plan to make generic
> implementation in "secure world".

I think you have your answer right there - by _not_ making the API
generic and giving no motivation to use it, different vendors are
going to do different things (maybe even with a different API as well)
so there's no point the kernel driver pretending to be a generic
driver. If the driver isn't going to be generic, I see little point in
the SMC function number being in DT.

I think that as a _whole_ is a big mistake - there should be a generic
kernel driver for this, and there should be a standardised interface to
it through firmware.  So, I would encourage you to try to get it
accepted one way or another amongst vendors as a standardised
interface.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
