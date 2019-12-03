Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0A1C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 10:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B96206DF
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 10:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575368266;
	bh=5ySN3e5aUDRbhiQLCPyxs/vWIneLIy4KAn4LJwCq6Qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=k56t0/TgEav6VLnyx1p5s8/RdHWSzo1v1G2BZlDiAfdZl/Pj2Zgxkj8FH7x0IYyOS
	 lGZTHCuL+jvvv4611u3Y2XhVWrJf3Yvz401C+VC3OTsnQxwdBGBHVJqbaHAScZL/CI
	 Ty1a26xHb7d1p3er644MRQkxr9Bmt4qFp27bwNCo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLCKRl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:17:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbfLCKRl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 05:17:41 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBC562068E;
        Tue,  3 Dec 2019 10:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575368260;
        bh=5ySN3e5aUDRbhiQLCPyxs/vWIneLIy4KAn4LJwCq6Qs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kMScm8GSzW4KeDWfSNSKzpGeRbVVCFvwkHxu3o+HncYmc1ZMD9uM8+flajxYG3OSj
         /3ciRNYMo3BiZw+E7eMtEjiYd7+acvkY5XsvqH5JshHzGPG8kNDM9bW1JHSNuNlDOg
         pVuRor6iCytI5GH4UIuH6jiB6DLUtCW0mKX2yae8=
Date:   Tue, 3 Dec 2019 10:17:20 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Neal Liu <neal.liu@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
Message-ID: <20191203101720.GD6815@willie-the-truck>
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
 <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
 <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
 <1575027046.24848.4.camel@mtkswgap22>
 <CAKv+Gu_um7eRYXbieW7ogDX5mmZaxP7JQBJM9CajK+6CsO5RgQ@mail.gmail.com>
 <20191202191146.79e6368c@why>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202191146.79e6368c@why>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 02, 2019 at 07:11:46PM +0000, Marc Zyngier wrote:
> On Mon, 2 Dec 2019 16:12:09 +0000
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> 
> > (adding some more arm64 folks)
> > 
> > On Fri, 29 Nov 2019 at 11:30, Neal Liu <neal.liu@mediatek.com> wrote:
> > >
> > > On Fri, 2019-11-29 at 18:02 +0800, Lars Persson wrote:  
> > > > Hi Neal,
> > > >
> > > > On Wed, Nov 27, 2019 at 3:23 PM Neal Liu <neal.liu@mediatek.com> wrote:  
> > > > >
> > > > > For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
> > > > > entropy sources is not accessible from normal world (linux) and
> > > > > rather accessible from secure world (ATF/TEE) only. This driver aims
> > > > > to provide a generic interface to ATF rng service.
> > > > >  
> > > >
> > > > I am working on several SoCs that also will need this kind of driver
> > > > to get entropy from Arm trusted firmware.
> > > > If you intend to make this a generic interface, please clean up the
> > > > references to MediaTek and give it a more generic name. For example
> > > > "Arm Trusted Firmware random number driver".
> > > >
> > > > It will also be helpful if the SMC call number is configurable.
> > > >
> > > > - Lars  
> > >
> > > Yes, I'm trying to make this to a generic interface. I'll try to make
> > > HW/platform related dependency to be configurable and let it more
> > > generic.
> > > Thanks for your suggestion.
> > >  
> > 
> > I don't think it makes sense for each arm64 platform to expose an
> > entropy source via SMC calls in a slightly different way, and model it
> > as a h/w driver. Instead, we should try to standardize this, and
> > perhaps expose it via the architectural helpers that already exist
> > (get_random_seed_long() and friends), so they get plugged into the
> > kernel random pool driver directly.
> 
> Absolutely. I'd love to see a standard, ARM-specified, virtualizable
> RNG that is abstracted from the HW.

Same here. I hacked up some initial code for doing this with KVM [1], but
I'd much rather it was part of a standard service specification so that
we could use the same interface for talking to the firmware and the
hypervisor.

Will

[1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/hvc
