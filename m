Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923B2C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 11:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiKGLOG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 06:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiKGLOF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 06:14:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8552F6151
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 03:14:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1102060FD4
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 11:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCBEC433D6;
        Mon,  7 Nov 2022 11:14:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FB+k25ql"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667819639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Q8LK4IFlgszP9qeSy5mWHj8mt89V7kMcY7SZG6pc5M=;
        b=FB+k25qlTXmSBwBGNVmWPnQG7sCmibF7oV6u5zpKA4yC4daxdYuY/0s1/urSu5t9KVgAYT
        3evGszNO40EVKuNvB5CxBYs0SZicVm5sFIsltRU0e74n+rWhhId31MO2B2/sWmqtACvLlF
        YKoGr9TtFCSCiDxsnzXM96gqaD/i18A=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e03771a3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 7 Nov 2022 11:13:59 +0000 (UTC)
Date:   Mon, 7 Nov 2022 12:13:57 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] hw_random: treat default_quality as a maximum and
 default to 1024
Message-ID: <Y2jodSK9o0HvnpQ8@zx2c4.com>
References: <20221104154230.52836-1-Jason@zx2c4.com>
 <Y2dctc4A0ccl3Hwp@owl.dominikbrodowski.net>
 <Y2fHbAxGY/VKLzbC@zx2c4.com>
 <Y2i1JgQJQot6W1PD@owl.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2i1JgQJQot6W1PD@owl.dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dominik,

On Mon, Nov 07, 2022 at 08:35:02AM +0100, Dominik Brodowski wrote:
> Hi Jason,
> 
> Am Sun, Nov 06, 2022 at 03:40:44PM +0100 schrieb Jason A. Donenfeld:
> > On Sun, Nov 06, 2022 at 08:05:25AM +0100, Dominik Brodowski wrote:
> > > Am Fri, Nov 04, 2022 at 04:42:30PM +0100 schrieb Jason A. Donenfeld:
> > > > Most hw_random devices return entropy which is assumed to be of full
> > > > quality, but driver authors don't bother setting the quality knob. Some
> > > > hw_random devices return less than full quality entropy, and then driver
> > > > authors set the quality knob. Therefore, the entropy crediting should be
> > > > opt-out rather than opt-in per-driver, to reflect the actual reality on
> > > > the ground.
> > > > 
> > > > For example, the two Raspberry Pi RNG drivers produce full entropy
> > > > randomness, and both EDK2 and U-Boot's drivers for these treat them as
> > > > such. The result is that EFI then uses these numbers and passes the to
> > > > Linux, and Linux credits them as boot, thereby initializing the RNG.
> > > > Yet, in Linux, the quality knob was never set to anything, and so on the
> > > > chance that Linux is booted without EFI, nothing is ever credited.
> > > > That's annoying.
> > > > 
> > > > The same pattern appears to repeat itself throughout various drivers. In
> > > > fact, very very few drivers have bothered setting quality=1024.
> > > > 
> > > > So let's invert this logic. A hw_random struct's quality knob now
> > > > controls the maximum quality a driver can produce, or 0 to specify 1024.
> > > > Then, the module-wide switch called "default_quality" is changed to
> > > > represent the maximum quality of any driver. By default it's 1024, and
> > > > the quality of any particular driver is then given by:
> > > > 
> > > >     min(default_quality, rng->quality ?: 1024);
> > > > 
> > > > This way, the user can still turn this off for weird reasons, yet we get
> > > > proper crediting for relevant RNGs.
> > > 
> > > Hm. Wouldn't we need to verify that 1024 is appropriate for all drivers
> > > where the quality currently is not set?
> > 
> > No, certainly not, and I think this sort of thought belies a really
> > backwards attitude. Hardware RNGs are assumed to produce good
> > randomness. Some manufacturers provide a caveat, "actually, we're giving
> > raw entropy with only N bits quality", but for the ones who don't, the
> > overarching assumption is that the bits are fully entropic.
> 
> My point is not about the 1024 as an exact value, it's more about "do the
> driver and the hardware really provide _something_ sensible or not". In the
> past, the default mode as to feed the output of hw_rng devies to some
> userspace daemon, which then tried to verify that the device works as
> expected, and then feeded the data back to the crng core. This userspace
> indirection is largely removed already (in particular by a patch of mine
> which starts up the hwrng kernel thread also for devices with quality==0)
> once the crng is fully initialized, on the rationale that even bad quality
> data will do no harm. Yet, we may need to be a tad more careful whether or
> not to trust devices for the initial seeding of the crng.

I got your point, and I still think it's a bad one, for the reasons
already explained to you. If it's a hardware RNG, then it's sensible to
assume it provides hardware random bits, unless we have documentation
that says it provides something less than perfect.

Now you've moved on to talking again about entropy estimation. Stop with
this nonsense. Entropy estimation is an impossible proposition that
actually results in an infoleak. With that said, a self-test to make
sure the hardware isn't completely borked would be a nice thing, but
this applies for any device no matter what assumptions are made. So if
you want to work on that, go ahead, but it's completely orthogonal to
this change here.

Jason
