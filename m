Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCC4C4332F
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 14:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiKFOky (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 09:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiKFOkx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 09:40:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5321DDEFC
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 06:40:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D1660BFF
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 14:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0948C433C1;
        Sun,  6 Nov 2022 14:40:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pF57fNjb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667745648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uWi00VPzm/KSCY92/QWftOK8dxKg3xaPTW7cQ4Tl+kU=;
        b=pF57fNjbiYfBS+0yb5h7S6trb5F/WGCU1waHKdPnrxmM4+AeT7LNecLSYNxgurJ9Vj8DAB
        lOYrfsMBngpiA7YcYr0O/PAJos2AqqB39UdOWzaj3A2f4psBt4EUUOYelQk4l79nJEkxhw
        bXEPit+YyqSa7sc4YYTP2qEbWxysfrI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 94f9f24a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 6 Nov 2022 14:40:47 +0000 (UTC)
Date:   Sun, 6 Nov 2022 15:40:44 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] hw_random: treat default_quality as a maximum and
 default to 1024
Message-ID: <Y2fHbAxGY/VKLzbC@zx2c4.com>
References: <20221104154230.52836-1-Jason@zx2c4.com>
 <Y2dctc4A0ccl3Hwp@owl.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2dctc4A0ccl3Hwp@owl.dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dominik,

On Sun, Nov 06, 2022 at 08:05:25AM +0100, Dominik Brodowski wrote:
> Am Fri, Nov 04, 2022 at 04:42:30PM +0100 schrieb Jason A. Donenfeld:
> > Most hw_random devices return entropy which is assumed to be of full
> > quality, but driver authors don't bother setting the quality knob. Some
> > hw_random devices return less than full quality entropy, and then driver
> > authors set the quality knob. Therefore, the entropy crediting should be
> > opt-out rather than opt-in per-driver, to reflect the actual reality on
> > the ground.
> > 
> > For example, the two Raspberry Pi RNG drivers produce full entropy
> > randomness, and both EDK2 and U-Boot's drivers for these treat them as
> > such. The result is that EFI then uses these numbers and passes the to
> > Linux, and Linux credits them as boot, thereby initializing the RNG.
> > Yet, in Linux, the quality knob was never set to anything, and so on the
> > chance that Linux is booted without EFI, nothing is ever credited.
> > That's annoying.
> > 
> > The same pattern appears to repeat itself throughout various drivers. In
> > fact, very very few drivers have bothered setting quality=1024.
> > 
> > So let's invert this logic. A hw_random struct's quality knob now
> > controls the maximum quality a driver can produce, or 0 to specify 1024.
> > Then, the module-wide switch called "default_quality" is changed to
> > represent the maximum quality of any driver. By default it's 1024, and
> > the quality of any particular driver is then given by:
> > 
> >     min(default_quality, rng->quality ?: 1024);
> > 
> > This way, the user can still turn this off for weird reasons, yet we get
> > proper crediting for relevant RNGs.
> 
> Hm. Wouldn't we need to verify that 1024 is appropriate for all drivers
> where the quality currently is not set?

No, certainly not, and I think this sort of thought belies a really
backwards attitude. Hardware RNGs are assumed to produce good
randomness. Some manufacturers provide a caveat, "actually, we're giving
raw entropy with only N bits quality", but for the ones who don't, the
overarching assumption is that the bits are fully entropic. This is
what's done every place else in the field, across operating systems,
boot environments, firmwares, and otherwise. It's so much so, that both
EDK2's EFI and U-Boot's DTB and U-Boot's EFI will use RNGs for which the
Linux driver has an empty quality setting and provide output from these
as fully entropic seeds to Linux. And why shouldn't they? It seems
entirely reasonable to do, given very okay assumptions.

But more generally, this fetishization of entropy estimation has got to
come to a close at some point. It wasn't a very good idea in the first
place to bake that into the heart of all the Linux RNG APIs, but here we
are. Just consider how meaningless the count is: random.c will do some
completely bogus hocus pocus with interrupt counting, with disk seeks,
with input events, to draw a number out of hat. Or it will twiddle
around with `struct timer_list` functions and count some entropy there,
which is complete nonsense, but whatever, it's by and large "good
enough". However, what we're talking about here are RNG hardware devices
that say on the tin "hey I'm an RNG device", which is an infinitely
better guarantee that we should count entropy from them (unless, of
course, the tin also says, "only count half the bits", or whatever). 

I mention "good enough", because really, the more important thing here
from the security angle is that we're getting bits into the RNG quite
fast at boot, and we largely accomplish that now. The next important
thing is getting the RNG initialized quickly so that userspace doesn't
block. Adding hw_random to the equation makes perfect sense here.

And, like RDRAND, there's still a switch to turn this off for lunatics
who simply don't trust anything.

So, no, the way hw_random is oriented now, the whole thing is backwards,
in a way that's not reflected across the rest of the hardware RNG and OS
ecosystem, and just results in a total waste. I think it's important
that we don't hold up progress here.

Jason
