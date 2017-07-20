From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Thu, 20 Jul 2017 21:00:02 +0200
Message-ID: <5238256.jqB5BlnSCf@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <4766174.b2XBWsRgGl@positron.chronox.de> <20170719172603.zlea7amylgdwt7hc@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60766 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934835AbdGTTAV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 15:00:21 -0400
In-Reply-To: <20170719172603.zlea7amylgdwt7hc@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 19. Juli 2017, 19:26:03 CEST schrieb Theodore Ts'o:

Hi Theodore,

> On Wed, Jul 19, 2017 at 08:22:18AM +0200, Stephan Müller wrote:
> > In the email [1] I have expressed the core concerns I see -- none of them
> > address the need to keep the Jitter RNG as one noise source. To address
> > those, a very deep dive into random.c needs to be made.
> 
> That's simply not true.  The other issues besides the Jitter RNG are
> really nits.
> 
> One of your complaints is the fact that we collect both interrupt
> timing and HID/block timings.  First of all, we could eliminate the
> HID/block timings since in practice we get the vast majority of our
> entropy from the interrupt timing.  I keep it because we have a real
> theoretical basis for their being unpredictability from the HID/block
> timings.  For example, [1].
> 
> [1] http://world.std.com/~dtd/random/forward.pdf
> 
> The fact that there might be double count from the perspective of
> entropy is not really an issue because we do a "fast mix" of 64
> interrupts before we mix into the primary interrupt pool.  And when we
> do mix into the primary pool we count that only as a single bit of
> entropy.  The reason why I'm being super cautious here is because some
> of these interrupts might be timer interrupts, or come from other
> sources that might be correlated to the clock interrupt.  The
> conservative assumption here is that at least one of the interrupts
> out of 64, on average, will come from something that the adversary can
> not anticipate, such as coming from a NIC or wireless device, and that
> we will get at least one bit's worth of unpredictability.
> 
> The fact that we also mix in the jiffies plus the keyboard/mouse scan
> code, is something that happens immediately.  So even if you think we
> should not count the fast mix interrupt count, the fact that we mix
> the timing values from 64 interrupts before we credit the entropy
> counter by a single bit is sufficiently conservative; we're talking
> about 1/64th of a bit here.

I concur with your rationale where de-facto the correlation is effect is 
diminished and eliminated with the fast_pool and the minimal entropy 
estimation of interrupts.

But it does not address my concern. Maybe I was not clear, please allow me to 
explain it again.

We have lots of entropy in the system which is discarded by the aforementioned 
approach (if a high-res timer is present -- without it all bets are off anyway 
and this should be covered in a separate discussion). At boot time, this issue 
is fixed by injecting 256 interrupts in the CRNG and consider it seeded.

But at runtime, were we still need entropy to reseed the CRNG and to supply /
dev/random. The accounting of entropy at runtime is much too conservative 
compared to any types of measurements that were conducted on bare metal or 
virtualized environment or on different architectures (if requested, I can 
surely share the test code and results in addition to already published 
studies -- see [1] table 1, 2 and 3 with figure 3.2 to get an idea). As long 
as a high-resolution time stamp is present, interrupts do provide much more 
than 1/64th bit of entropy per occurrence.

[1] http://www.chronox.de/lrng/doc/lrng.pdf

The implementation that was precisely outlined above present in random.c 
however does not allow revaluing the amount of entropy present in interrupts 
to a higher level simply because then the correlation issue kicks in.

Thus, when we want to re-value the interrupts with a higher level of entropy, 
we need to take out the high-resolution time stamp (and thus the more or less 
sole effective entropy provider for add_[disk|input]_randomness).

You mentioned that you are super conservative for interrupts due to timer 
interrupts. In all measurements on the different systems I conducted, I have 
not seen that the timer triggers an interrupt picked up by 
add_interrupt_randomness. For the sake of discussion, let us assume that such 
timer interrupts are present for a worst-case assessment. Such timer 
interrupts by nature should occur very periodically. Thus, it should be easy 
to detect them. IMHO the suggested stuck test in the LRNG exactly covers that 
scenario: only if the 1st, 2nd and 3rd derivative of the time stamp is non-
zero, the interrupt time stamp is considered to deliver entropy.

Thus, when revaluing the interrupt entropy, and removing the high-res timer 
from HID/block devices, the entropy heuristic in add_timer_randomness can go.

As we have no formal model about entropy to begin with, we can only assume and 
hope we underestimate entropy with the entropy heuristic. Thus, a precise 
entropy update with the asymptotic calculation in credit_entropy_bits may also 
not really be helpful and could be discarded.

> 
> But if you **really** think mixing in the timing of the HID event
> (gathered via a different mechanism --- jiffies vs cycle counter, and
> including the the keyboard scan), a patch to disable
> add_keyboard_randomness() is pretty trivial.  It doesn't justify a
> complete rewrite of the random core.
> 
> (BTW, granted this is anecdata, but on my laptop, the CRNG is fully
> initialized before systemd has even started and before the root file
> system is mounted.

Agreed, I see that too. And as mentioned above, this is how I think it is 
appropriate. This behavior is very similar to what I see on my LRNG.

> And after that point the entropy initialization
> only matters for the legacy apps that use /dev/random, which doesn't
> even exist in your proposed RNG, since everything just uses a
> ChaCha20-based CRNG.)
> 

I am not sure I understand the last statement. The blocking_pool (or the 
ChaCha20 DRNG in my LRNG) feeding /dev/random is simply a deterministic RNG 
with prediction resistance (in SP800-90A-speak). I.e. when one random bit 
shall be generated, one bit of entropy from the noise sources needs to go in.

Whether you have a blocking_pool or a normal DRNG to feed /dev/random does not 
matter as long as it only delivers as many bits as went in as entropy.
> 
> Another one of your complaints is a straw-man argument ("I understand
> that this pathological case is not present for the legacy
> /dev/random...").  First of all, how we do entropy estimation after
> the CRNG boot is far less important, because the primary recommended
> interface is /dev/urandom or better yet getrandom(2).  Secondly, we
> *don't* allow transfer of small quantums of entropy.  There is a
> minimum transfer limit of 64 bits, and that can easily be increased to
> 128 bits if one really cared.  I've never really considered recovery
> from state compromise to be that important, but if one did care,
> increasing that limit is a two line patch.

_xfer_secondary_pool says:

        /* pull at least as much as a wakeup */
        bytes = max_t(int, bytes, random_read_wakeup_bits / 8);

This determines the minimum amount. random_read_wakeup_bits can be changed by 
user space:

        {
                .procname       = "read_wakeup_threshold",
                .data           = &random_read_wakeup_bits,
                .maxlen         = sizeof(int),
                .mode           = 0644,
                .proc_handler   = proc_dointvec_minmax,
                .extra1         = &min_read_thresh,
                .extra2         = &max_read_thresh,
        },

min_read_thresh is 8.

Thus, the minimum amount of transfer is 1 byte as far as I read. I concur, 
however, that the default is 64 (bits).

This is what I would suggest to have changed to, say, the absolute minimum of 
64 or 128 bits.



Finally, I still think it is helpful to allow (not mandate) to involve the 
kernel crypto API for the DRNG maintenance (i.e. the supplier for /dev/random 
and /dev/urandom). The reason is that now more and more DRNG implementations 
in hardware pop up. Why not allowing them to be used. I.e. random.c would only 
contain the logic to manage entropy but uses the DRNG requested by a user.

In addition allowing a replacement of the DRNG component (at compile time at 
least) may get us away from having a separate DRNG solution in the kernel 
crypto API. Some users want their chosen or a standardized DRNG to deliver 
random numbers. Thus, we have several DRNGs in the kernel crypto API which are 
seeded by get_random_bytes. Or in user space, many folks need their own DRNG 
in user space in addition to the kernel. IMHO this is all a waste. If we could 
use the user-requested DRNG when producing random numbers for get_random_bytes 
or /dev/urandom or getrandom.

Ciao
Stephan
