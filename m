Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADB5C433E1
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 08:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96DC220820
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 08:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="wBe35UXK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFEIJX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 04:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgFEIJX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 04:09:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07574C08C5C2;
        Fri,  5 Jun 2020 01:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xTC03c+VN1v9oPdUo2yGRbRXi+/1BHiQCVEdadEW0B0=; b=wBe35UXKkNUxuKRFJWItlkvuD
        1XY++1q2yh1Zdn8E9bM44XF0UXOTbnrgJPyyFkMCF+P4VJYeq+HpcJrBCctVCNZHX/QflI8PUFqtB
        eZVzlHFtFLAMWyyURO+ZOuWjWW2UT6JYXUsEuLKMJ9qbhzww3ib7kkkI1fJmq070czJ/cCNCfTdtc
        86LNj7hzaz4ANgBd2UcVJ/DlxPycd45pLpZ+iVRHYTIIhttw+53TPqf/dL2Ynv8/juj15jvwn3A7S
        5jRRS8YLk88zzyi7ZU5mxkYkidghFxHNQohGA2yHxTA2VLGXaTvLNOXzek+UAYiFZxKhE4g3JDHDX
        ldCDaZPKQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:49608)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jh7Pb-0001ay-Ky; Fri, 05 Jun 2020 09:09:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jh7PW-0007IR-1u; Fri, 05 Jun 2020 09:09:06 +0100
Date:   Fri, 5 Jun 2020 09:09:06 +0100
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
Message-ID: <20200605080905.GF1551@shell.armlinux.org.uk>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
 <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
 <1591169342.4878.9.camel@mtkswgap22>
 <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
 <20200603093416.GY1551@shell.armlinux.org.uk>
 <1591341543.19510.4.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591341543.19510.4.camel@mtkswgap22>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 03:19:03PM +0800, Neal Liu wrote:
> On Wed, 2020-06-03 at 17:34 +0800, Russell King - ARM Linux admin wrote:
> > This kind of thing is something that ARM have seems to shy away from
> > doing - it's a point I brought up many years ago when the whole
> > trustzone thing first appeared with its SMC call.  Those around the
> > conference table were not interested - ARM seemed to prefer every
> > vendor to do off and do their own thing with the SMC interface.
> 
> Does that mean it make sense to model a sec-rng driver, and get each
> vendor's SMC function id by DT node?

_If_ vendors have already gone off and decided to use different SMC
function IDs for this, while keeping the rest of the SMC interface
the same, then the choice has already been made.

I know on 32-bit that some of the secure world implementations can't
be changed; they're burnt into the ROM. I believe on 64-bit that isn't
the case, which makes it easier to standardise.

Do you have visibility of how this SMC is implemented in the secure
side?  Is it in ATF, and is it done as a vendor hack or is there an
element of generic implementation to it?  Has it been submitted
upstream to the main ATF repository?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
