Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B28CC43217
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 07:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiKGHjc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 02:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiKGHjb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 02:39:31 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9417CFF
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 23:39:30 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id D3B212014B3;
        Mon,  7 Nov 2022 07:39:28 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 6542D806D2; Mon,  7 Nov 2022 08:35:02 +0100 (CET)
Date:   Mon, 7 Nov 2022 08:35:02 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] hw_random: treat default_quality as a maximum and
 default to 1024
Message-ID: <Y2i1JgQJQot6W1PD@owl.dominikbrodowski.net>
References: <20221104154230.52836-1-Jason@zx2c4.com>
 <Y2dctc4A0ccl3Hwp@owl.dominikbrodowski.net>
 <Y2fHbAxGY/VKLzbC@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2fHbAxGY/VKLzbC@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

Am Sun, Nov 06, 2022 at 03:40:44PM +0100 schrieb Jason A. Donenfeld:
> On Sun, Nov 06, 2022 at 08:05:25AM +0100, Dominik Brodowski wrote:
> > Am Fri, Nov 04, 2022 at 04:42:30PM +0100 schrieb Jason A. Donenfeld:
> > > Most hw_random devices return entropy which is assumed to be of full
> > > quality, but driver authors don't bother setting the quality knob. Some
> > > hw_random devices return less than full quality entropy, and then driver
> > > authors set the quality knob. Therefore, the entropy crediting should be
> > > opt-out rather than opt-in per-driver, to reflect the actual reality on
> > > the ground.
> > > 
> > > For example, the two Raspberry Pi RNG drivers produce full entropy
> > > randomness, and both EDK2 and U-Boot's drivers for these treat them as
> > > such. The result is that EFI then uses these numbers and passes the to
> > > Linux, and Linux credits them as boot, thereby initializing the RNG.
> > > Yet, in Linux, the quality knob was never set to anything, and so on the
> > > chance that Linux is booted without EFI, nothing is ever credited.
> > > That's annoying.
> > > 
> > > The same pattern appears to repeat itself throughout various drivers. In
> > > fact, very very few drivers have bothered setting quality=1024.
> > > 
> > > So let's invert this logic. A hw_random struct's quality knob now
> > > controls the maximum quality a driver can produce, or 0 to specify 1024.
> > > Then, the module-wide switch called "default_quality" is changed to
> > > represent the maximum quality of any driver. By default it's 1024, and
> > > the quality of any particular driver is then given by:
> > > 
> > >     min(default_quality, rng->quality ?: 1024);
> > > 
> > > This way, the user can still turn this off for weird reasons, yet we get
> > > proper crediting for relevant RNGs.
> > 
> > Hm. Wouldn't we need to verify that 1024 is appropriate for all drivers
> > where the quality currently is not set?
> 
> No, certainly not, and I think this sort of thought belies a really
> backwards attitude. Hardware RNGs are assumed to produce good
> randomness. Some manufacturers provide a caveat, "actually, we're giving
> raw entropy with only N bits quality", but for the ones who don't, the
> overarching assumption is that the bits are fully entropic.

My point is not about the 1024 as an exact value, it's more about "do the
driver and the hardware really provide _something_ sensible or not". In the
past, the default mode as to feed the output of hw_rng devies to some
userspace daemon, which then tried to verify that the device works as
expected, and then feeded the data back to the crng core. This userspace
indirection is largely removed already (in particular by a patch of mine
which starts up the hwrng kernel thread also for devices with quality==0)
once the crng is fully initialized, on the rationale that even bad quality
data will do no harm. Yet, we may need to be a tad more careful whether or
not to trust devices for the initial seeding of the crng.

Thanks,
	Dominik
