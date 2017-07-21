From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Thu, 20 Jul 2017 23:08:47 -0400
Message-ID: <20170721030846.m2r3ix4s2modahsw@thunk.org>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <4766174.b2XBWsRgGl@positron.chronox.de>
 <20170719172603.zlea7amylgdwt7hc@thunk.org>
 <5238256.jqB5BlnSCf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5238256.jqB5BlnSCf@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 20, 2017 at 09:00:02PM +0200, Stephan Müller wrote:
> I concur with your rationale where de-facto the correlation is effect is 
> diminished and eliminated with the fast_pool and the minimal entropy 
> estimation of interrupts.
> 
> But it does not address my concern. Maybe I was not clear, please allow me to 
> explain it again.
> 
> We have lots of entropy in the system which is discarded by the aforementioned 
> approach (if a high-res timer is present -- without it all bets are off anyway 
> and this should be covered in a separate discussion). At boot time, this issue 
> is fixed by injecting 256 interrupts in the CRNG and consider it seeded.
> 
> But at runtime, were we still need entropy to reseed the CRNG and to supply /
> dev/random. The accounting of entropy at runtime is much too conservative...

Practically no one uses /dev/random.  It's essentially a deprecated
interface; the primary interfaces that have been recommended for well
over a decade is /dev/urandom, and now, getrandom(2).  We only need
384 bits of randomness every 5 minutes to reseed the CRNG, and that's
plenty even given the very conservative entropy estimation currently
being used.

This was deliberate.  I care a lot more that we get the initial
boot-time CRNG initialization right on ARM32 and MIPS embedded
devices, far, far, more than I care about making plenty of
information-theoretic entropy available at /dev/random on an x86
system.  Further, I haven't seen an argument for the use case where
this would be valuable.

If you don't think they count because ARM32 and MIPS don't have a
high-res timer, then you have very different priorities than I do.  I
will point out that numerically there are huge number of these devices
--- and very, very few users of /dev/random.

> You mentioned that you are super conservative for interrupts due to timer 
> interrupts. In all measurements on the different systems I conducted, I have 
> not seen that the timer triggers an interrupt picked up by 
> add_interrupt_randomness.

Um, the timer is the largest number of interrupts on my system.  Compare:

            CPU0       CPU1       CPU2       CPU3
 LOC:    6396552    6038865    6558646    6057102   Local timer interrupts

with the number of disk related interrupts:

 120:      21492     139284      40513    1705886   PCI-MSI 376832-edge      ahci[0000:00:17.0]

... and add_interrupt_randomness() gets called for **every**
interrupt.  On an mostly idle machine (I was in meetings most of
today) it's not surprising that time interrupts dominate.  That
doesn't matter for me as much because I don't really care about
/dev/random performance.  What's is **far** more important is that the
entropy estimations behave correctly, across all of Linux's
architectures, while the kernel is going through startup, before CRNG
is declared initialized.

> As we have no formal model about entropy to begin with, we can only assume and 
> hope we underestimate entropy with the entropy heuristic.

Yes, and that's why I use an ultra-conservative estimate.  If we start
using a more aggressive hueristic, we open ourselves up to potentially
very severe security bugs --- and for what?  What's the cost benefit
ratio here which makes this a worthwhile thing to risk?

> Finally, I still think it is helpful to allow (not mandate) to involve the 
> kernel crypto API for the DRNG maintenance (i.e. the supplier for /dev/random 
> and /dev/urandom). The reason is that now more and more DRNG implementations 
> in hardware pop up. Why not allowing them to be used. I.e. random.c would only 
> contain the logic to manage entropy but uses the DRNG requested by a user.

We *do* allow them to be used.  And we support a large number of
hardware random number generators already.  See drivers/char/hw_random.

BTW, I theorize that this is why the companies that could do the
bootloader random seen work haven't bothered.  Most of their products
have a TPM or equivalent, and with modern kernel the hw_random
interface now has a kernel thread that will automatically fill the
/dev/random entropy pool from the hw_random device.  So this all works
already, today, without needing a userspace rngd (which used to be
required).

> In addition allowing a replacement of the DRNG component (at compile time at 
> least) may get us away from having a separate DRNG solution in the kernel 
> crypto API. Some users want their chosen or a standardized DRNG to deliver 
> random numbers. Thus, we have several DRNGs in the kernel crypto API which are 
> seeded by get_random_bytes. Or in user space, many folks need their own DRNG 
> in user space in addition to the kernel. IMHO this is all a waste. If we could 
> use the user-requested DRNG when producing random numbers for get_random_bytes 
> or /dev/urandom or getrandom.

To be honest, I've never understood why that's there in the crypto API
at all.  But adding more ways to switch out the DRNG for /dev/random
doesn't solve that problem; in fact it's moving things in the wrong
direction.

Cheers,

						- Ted
