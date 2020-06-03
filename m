Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD83BC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 09:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A52232077D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 09:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="aFWUUXJq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCJey (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFCJex (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 05:34:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5196C05BD43;
        Wed,  3 Jun 2020 02:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RCFP1A+jP0Ejskt3PALHHBHaCjZj9CjOP9H+ZUjtVwM=; b=aFWUUXJqdnK1WDUWqzRKMDXBM
        1kVv5yXQAwa2Lb3TmbtSDvvBJ64BRFACoVB+RZ0tgL0YuklkRY/bcQdyJW2P60h1MJeiTlpxi6g9I
        meZNBHpZMQ8WsKgm4tqAC16EYMcl/NpNGlG4fgZTNJE0RCxca/b0rSHQvJeKrbKnKWv4YWXgf58he
        yXqLmgHCujl9SFNppMaI9CEPWAtNSvh3A3yBafP64u3ywxSGDLlNuRtysF6aLQd1qGP0SIeIHJT2Y
        ZI/Lc0+PtL3erv1xuxcT+FQtsMq8POUrUjHA1w7xpnoTb1gNl9uRDIQuJ8AenWbYjQCTLvoKghfki
        s4pbL54Lg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38300)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jgPn9-00058L-4d; Wed, 03 Jun 2020 10:34:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jgPmq-0005HW-Su; Wed, 03 Jun 2020 10:34:16 +0100
Date:   Wed, 3 Jun 2020 10:34:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Neal Liu <neal.liu@mediatek.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Julius Werner <jwerner@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Crystal Guo =?utf-8?B?KOmDreaZtik=?= <Crystal.Guo@mediatek.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Security Random Number Generator support
Message-ID: <20200603093416.GY1551@shell.armlinux.org.uk>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
 <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
 <1591169342.4878.9.camel@mtkswgap22>
 <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 03, 2020 at 08:40:58AM +0100, Marc Zyngier wrote:
> On 2020-06-03 08:29, Neal Liu wrote:
> > On Tue, 2020-06-02 at 21:02 +0800, Marc Zyngier wrote:
> > > On 2020-06-02 13:14, Ard Biesheuvel wrote:
> > > > On Tue, 2 Jun 2020 at 10:15, Neal Liu <neal.liu@mediatek.com> wrote:
> > > >>
> > > >> These patch series introduce a security random number generator
> > > >> which provides a generic interface to get hardware rnd from Secure
> > > >> state. The Secure state can be Arm Trusted Firmware(ATF), Trusted
> > > >> Execution Environment(TEE), or even EL2 hypervisor.
> > > >>
> > > >> Patch #1..2 adds sec-rng kernel driver for Trustzone based SoCs.
> > > >> For security awareness SoCs on ARMv8 with TrustZone enabled,
> > > >> peripherals like entropy sources is not accessible from normal world
> > > >> (linux) and rather accessible from secure world (HYP/ATF/TEE) only.
> > > >> This driver aims to provide a generic interface to Arm Trusted
> > > >> Firmware or Hypervisor rng service.
> > > >>
> > > >>
> > > >> changes since v1:
> > > >> - rename mt67xx-rng to mtk-sec-rng since all MediaTek ARMv8 SoCs can
> > > >> reuse
> > > >>   this driver.
> > > >>   - refine coding style and unnecessary check.
> > > >>
> > > >>   changes since v2:
> > > >>   - remove unused comments.
> > > >>   - remove redundant variable.
> > > >>
> > > >>   changes since v3:
> > > >>   - add dt-bindings for MediaTek rng with TrustZone enabled.
> > > >>   - revise HWRNG SMC call fid.
> > > >>
> > > >>   changes since v4:
> > > >>   - move bindings to the arm/firmware directory.
> > > >>   - revise driver init flow to check more property.
> > > >>
> > > >>   changes since v5:
> > > >>   - refactor to more generic security rng driver which
> > > >>     is not platform specific.
> > > >>
> > > >> *** BLURB HERE ***
> > > >>
> > > >> Neal Liu (2):
> > > >>   dt-bindings: rng: add bindings for sec-rng
> > > >>   hwrng: add sec-rng driver
> > > >>
> > > >
> > > > There is no reason to model a SMC call as a driver, and represent it
> > > > via a DT node like this.
> > > 
> > > +1.
> > > 
> > > > It would be much better if this SMC interface is made truly generic,
> > > > and wired into the arch_get_random() interface, which can be used much
> > > > earlier.
> > > 
> > > Wasn't there a plan to standardize a SMC call to rule them all?
> > > 
> > >          M.
> > 
> > Could you give us a hint how to make this SMC interface more generic in
> > addition to my approach?
> > There is no (easy) way to get platform-independent SMC function ID,
> > which is why we encode it into device tree, and provide a generic
> > driver. In this way, different devices can be mapped and then get
> > different function ID internally.
> 
> The idea is simply to have *one* single ID that caters for all
> implementations, just like we did for PSCI at the time. This
> requires ARM to edict a standard, which is what I was referring
> to above.

This sounds all too familiar.

This kind of thing is something that ARM have seems to shy away from
doing - it's a point I brought up many years ago when the whole
trustzone thing first appeared with its SMC call.  Those around the
conference table were not interested - ARM seemed to prefer every
vendor to do off and do their own thing with the SMC interface.

Then OMAP came along with its SMC interfaces, and so did the pain of
not having a standardised way to configure the L2C when Linux was
running in the non-secure world, resulting in stuff like l2c_configure
etc, where each and every implementation has to supply a function to
call its platform specific SMC interfaces to configure a piece of
hardware common across many different platforms.

ARM have seemed reluctant to standardise on stuff like this, so
unless someone pushes hard for it from inside ARM, I doubt it will
ever happen.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
