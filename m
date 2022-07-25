Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C319C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 16:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiGYQYM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiGYQYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 12:24:10 -0400
X-Greylist: delayed 1033 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Jul 2022 09:24:08 PDT
Received: from brightrain.aerifal.cx (brightrain.aerifal.cx [216.12.86.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C8017A8C
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:24:07 -0700 (PDT)
Date:   Mon, 25 Jul 2022 12:06:53 -0400
From:   Rich Felker <dalias@libc.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>,
        linux-crypto@vger.kernel.org, Michael@phoronix.com
Subject: Re: arc4random - are you sure we want these?
Message-ID: <20220725160652.GG7074@brightrain.aerifal.cx>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com>
 <Yt54x7uWnsL3eZSx@zx2c4.com>
 <87v8rlqscj.fsf@oldenburg.str.redhat.com>
 <Yt6eHfnlEN8ViWrA@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yt6eHfnlEN8ViWrA@zx2c4.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 03:43:57PM +0200, Jason A. Donenfeld via Libc-alpha wrote:
> Hi Florian,
> 
> On Mon, Jul 25, 2022 at 02:39:24PM +0200, Florian Weimer wrote:
> > Below you suggest to use GRND_INSECURE to avoid deadlocks during
> > booting.  It's documented in the UAPI header as “Return
> > non-cryptographic random bytes”.  I assume it's broadly equivalent to
> > reading from /dev/urandom (which we need to support for backwards
> > compatibility, and currently use to avoid blocking).  This means that we
> > cannot really document the resulting bits as cryptographically strong
> > from an application perspective because the kernel is not willing to
> > make this commitment.
> > Regarding the technical aspect, GRND_INSECURE is somewhat new-ish, but
> > as I wrote above, it's UAPI documentation is a bit scary.  Maybe it
> > would be possible to clarify this in the manual pages a bit?  I *assume*
> > that if we are willing to read from /dev/urandom, we can use
> > GRND_INSECURE right away to avoid that fallback path on sufficiently new
> > kernels.  But it would be nice to have confirmation.
> 
> getrandom(GRND_INSECURE) is the same as getrandom(0), except before the
> RNG is seeded, in which case the former will return ~garbage randomness
> while the latter will block. The only current difference between
> getrandom(GRND_INSECURE) and /dev/urandom is the latter will try for a
> second to do the jitter entropy thing if the RNG isn't seeded yet.
> 
> I agree that the documentation around this is really bad. Actually, so
> much of the documentation is out of date or confusing. Thanks for the
> kick on this: I really do need to rewrite that / clean it up.
> 
> So with my random.c maintainer hat on: getrandom(GRND_INSECURE) will
> return the same "quality" randomness as getrandom(0), except before
> the RNG is initialized. I'll fix up the docs for that, but feel free to
> refer to this statement ahead of that if you need.
> 
> Code-wise, the only relevant branch related to GRND_INSECURE is:
> 
> 	if (!crng_ready() && !(flags & GRND_INSECURE)) {
> 		if (flags & GRND_NONBLOCK)
> 			return -EAGAIN;
> 		ret = wait_for_random_bytes();
> 		if (unlikely(ret))
> 			return ret;
> 	}
> 
> That means: if it's not ready, and you didn't pass _INSECURE, and you
> didn't pass _NONBLOCK, then wait for the RNG to be ready, and error out
> if that's interrupted by a signal. Other than that one block, it
> continues on to do the same thing as getrandom(0).
> 
> With that said, however, I think it'd be nice if you used only blocking
> randomness, and shove the initialization problem at init systems and
> bootloaders and such. In 5.20, for example, there'll be an x86 boot
> protocol for GRUB and kexec and hypervisors and such to pass a seed, and
> since a long time, there exists a device tree attribute for the same.
> Proliferating "unsafe" /dev/urandom-style usage doesn't seem good for
> the ecosystem at large. And I'm in general interest in seeing progress
> on decades long initialization-time seeding concerns.

arc4random's contract is supposed to be that it always succeeds and
always produces cryptographic output. It cannot use GRND_INSECURE or
other insecure fallback methods to avoid blocking. It has to block.
This function (inherently, in its contract) is not usable for early
boot stuff where one is pretending to want actual cryptographic
entropy but is just as happy getting some "high quality" non-CS stuff,
and thereby would be just as happy with rand() or likely even with
"42". Programs that will run in that context on Linux need to be
explicitly aware of the messy "early boot" situation and figure out
how they're going to handle it securely or if they even wanted CS
randomness to begin with. Fortunately virtually nothing has to do
that. On most (non-embedded) systems, init can just bring up a rw
filesystem with saved entropy on it early and load that, then provide
a fully-working environment to programs it invokes.

> > I had some patches with AT_RANDOM fallback, including overwriting
> > AT_RANDOM with output from the seeded PRNG.  It's certainly messy.  I
> > probably didn't bother to post these patches given how bizarre the whole
> > thing was.  I did have fallback to CPU instructions, but that turned out
> > to be unworkable due to bugs in suspend on AMD CPUs (kernel or firmware,
> > unclear).
> 
> Yea, it's kind of tricky as other things might be using AT_RANDOM also
> and then you have a whole race issue and domain separation and whatnot.
> The thing in systemd isn't really good for crypto -- no forward secrecy
> and such -- but it's ostensibly better than random().

AT_RANDOM is unusable as a fallback here because it's equivalent to
GRND_INSECURE. It's silently broken at early boot time. In musl we're
likely going to end up using the legacy SYS_sysctl on pre-getrandom
kernels even though it spammed syslog just because it seems to be the
only way to get blocking secure entropy on those kernels.

Rich
