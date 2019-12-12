Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4A6C3F68F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F308227BF
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfLLOoE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:44:04 -0500
Received: from foss.arm.com ([217.140.110.172]:49196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbfLLOoE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 09:44:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B0E530E;
        Thu, 12 Dec 2019 06:44:03 -0800 (PST)
Received: from bogus (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D90EA3F718;
        Thu, 12 Dec 2019 06:44:00 -0800 (PST)
Date:   Thu, 12 Dec 2019 14:43:55 +0000
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Neal Liu <neal.liu@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Lars Persson <lists@bofh.nu>,
        Mark Rutland <mark.rutland@arm.com>,
        DTML <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Sean Wang <sean.wang@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Crystal Guo =?utf-8?B?KOmDreaZtik=?= <Crystal.Guo@mediatek.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
Message-ID: <20191212144355.GA13263@bogus>
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
 <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
 <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
 <1575027046.24848.4.camel@mtkswgap22>
 <CAKv+Gu_um7eRYXbieW7ogDX5mmZaxP7JQBJM9CajK+6CsO5RgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_um7eRYXbieW7ogDX5mmZaxP7JQBJM9CajK+6CsO5RgQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 02, 2019 at 04:12:09PM +0000, Ard Biesheuvel wrote:
> (adding some more arm64 folks)
> 
> On Fri, 29 Nov 2019 at 11:30, Neal Liu <neal.liu@mediatek.com> wrote:
> >
> > On Fri, 2019-11-29 at 18:02 +0800, Lars Persson wrote:
> > > Hi Neal,
> > >
> > > On Wed, Nov 27, 2019 at 3:23 PM Neal Liu <neal.liu@mediatek.com> wrote:
> > > >
> > > > For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
> > > > entropy sources is not accessible from normal world (linux) and
> > > > rather accessible from secure world (ATF/TEE) only. This driver aims
> > > > to provide a generic interface to ATF rng service.
> > > >
> > >
> > > I am working on several SoCs that also will need this kind of driver
> > > to get entropy from Arm trusted firmware.
> > > If you intend to make this a generic interface, please clean up the
> > > references to MediaTek and give it a more generic name. For example
> > > "Arm Trusted Firmware random number driver".
> > >
> > > It will also be helpful if the SMC call number is configurable.
> > >
> > > - Lars
> >
> > Yes, I'm trying to make this to a generic interface. I'll try to make
> > HW/platform related dependency to be configurable and let it more
> > generic.
> > Thanks for your suggestion.
> >
> 
> I don't think it makes sense for each arm64 platform to expose an
> entropy source via SMC calls in a slightly different way, and model it
> as a h/w driver. Instead, we should try to standardize this, and
> perhaps expose it via the architectural helpers that already exist
> (get_random_seed_long() and friends), so they get plugged into the
> kernel random pool driver directly.
> 
> Note that in addition to drivers based on vendor SMC calls, we already
> have a RNG h/w driver based on OP-TEE as well, where the driver
> attaches to a standardized trusted OS interface identified by a UUID,
> and which also gets invoked via SMC calls into secure firmware.

Yes, I agree. I had raised the issue internally and forgot to follow up.
I raised this few months back after I read a blog[1]

--
Regards,
Sudeep

[1] https://community.arm.com/developer/ip-products/processors/f/cortex-a-forum/43679/arm-really-should-standardize-an-smc-interface-for-hardware-random-number-generators
