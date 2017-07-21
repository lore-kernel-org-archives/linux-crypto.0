From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Fri, 21 Jul 2017 07:30:50 -0400
Message-ID: <CAH8yC8=5-bEae8jRthfbNrmnng-QEc9hgf+hd+k5Srja+Z1HKA@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35185 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdGULaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 07:30:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

Snipping one comment:

> Practically no one uses /dev/random.  It's essentially a deprecated
> interface; the primary interfaces that have been recommended for well
> over a decade is /dev/urandom, and now, getrandom(2).  We only need
> 384 bits of randomness every 5 minutes to reseed the CRNG, and that's
> plenty even given the very conservative entropy estimation currently
> being used.

The statement about /dev/random being deprecated is not well
documented. A quick search is not turning up the expected results.

The RANDOM(4) man page provides competing (conflicting?) information:

       When read, the /dev/random device will return random bytes only  wit=
hin
       the estimated number of bits of noise in the entropy pool.  /dev/ran=
dom
       should be suitable for uses that need very high quality randomness s=
uch
       as  one-time  pad  or  key generation...

We regularly test the /dev/random generator by reading 10K bytes in
non-blocking, discarding them, and then asking for 16 bytes in
blocking. We also compress as a poor man's fitness test. We are
interested in how robust the generator is, how well it performs under
stress, and how well it recovers.

After draining it often takes minutes for the generator to produce 16
bytes. On Debian based systems the experiment usually fails unless
rng-tools is installed. The failures occur even on systems with
hardware based generators like rdrand and rdseed. I've witnessed the
failure on i686, x86_64, ARM and MIPS.

We recently suggested the GCC compile farm install rng-tools because
we were witnessing the problem there on machines. Cf.,
https://lists.tetaneutral.net/pipermail/cfarm-users/2017-July/000030.html
. I've even seen vendors recommend wiring /dev/random to /dev/urandom
because of the entropy depletion problems. That's a big No-No
according to https://lwn.net/Articles/525459/.

The failures have always left me with an uncomfortable feeling because
there are so many damn programs out there that do their own thing.
Distro don't perform a SecArch review before packaging, so problems
lie in wait.

If the generator is truly deprecated, then it may be prudent to remove
it completely or remove it from userland. Otherwise, improve its
robustness. At minimum, update the documentation.

Jeff

On Thu, Jul 20, 2017 at 11:08 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 20, 2017 at 09:00:02PM +0200, Stephan M=C3=BCller wrote:
>> I concur with your rationale where de-facto the correlation is effect is
>> diminished and eliminated with the fast_pool and the minimal entropy
>> estimation of interrupts.
>>
>> But it does not address my concern. Maybe I was not clear, please allow =
me to
>> explain it again.
>>
>> We have lots of entropy in the system which is discarded by the aforemen=
tioned
>> approach (if a high-res timer is present -- without it all bets are off =
anyway
>> and this should be covered in a separate discussion). At boot time, this=
 issue
>> is fixed by injecting 256 interrupts in the CRNG and consider it seeded.
>>
>> But at runtime, were we still need entropy to reseed the CRNG and to sup=
ply /
>> dev/random. The accounting of entropy at runtime is much too conservativ=
e...
>
> Practically no one uses /dev/random.  It's essentially a deprecated
> interface; the primary interfaces that have been recommended for well
> over a decade is /dev/urandom, and now, getrandom(2).  We only need
> 384 bits of randomness every 5 minutes to reseed the CRNG, and that's
> plenty even given the very conservative entropy estimation currently
> being used.
>
> This was deliberate.  I care a lot more that we get the initial
> boot-time CRNG initialization right on ARM32 and MIPS embedded
> devices, far, far, more than I care about making plenty of
> information-theoretic entropy available at /dev/random on an x86
> system.  Further, I haven't seen an argument for the use case where
> this would be valuable.
>
> If you don't think they count because ARM32 and MIPS don't have a
> high-res timer, then you have very different priorities than I do.  I
> will point out that numerically there are huge number of these devices
> --- and very, very few users of /dev/random.
>
>> You mentioned that you are super conservative for interrupts due to time=
r
>> interrupts. In all measurements on the different systems I conducted, I =
have
>> not seen that the timer triggers an interrupt picked up by
>> add_interrupt_randomness.
>
> Um, the timer is the largest number of interrupts on my system.  Compare:
>
>             CPU0       CPU1       CPU2       CPU3
>  LOC:    6396552    6038865    6558646    6057102   Local timer interrupt=
s
>
> with the number of disk related interrupts:
>
>  120:      21492     139284      40513    1705886   PCI-MSI 376832-edge  =
    ahci[0000:00:17.0]
>
> ... and add_interrupt_randomness() gets called for **every**
> interrupt.  On an mostly idle machine (I was in meetings most of
> today) it's not surprising that time interrupts dominate.  That
> doesn't matter for me as much because I don't really care about
> /dev/random performance.  What's is **far** more important is that the
> entropy estimations behave correctly, across all of Linux's
> architectures, while the kernel is going through startup, before CRNG
> is declared initialized.
>
>> As we have no formal model about entropy to begin with, we can only assu=
me and
>> hope we underestimate entropy with the entropy heuristic.
>
> Yes, and that's why I use an ultra-conservative estimate.  If we start
> using a more aggressive hueristic, we open ourselves up to potentially
> very severe security bugs --- and for what?  What's the cost benefit
> ratio here which makes this a worthwhile thing to risk?
>
>> Finally, I still think it is helpful to allow (not mandate) to involve t=
he
>> kernel crypto API for the DRNG maintenance (i.e. the supplier for /dev/r=
andom
>> and /dev/urandom). The reason is that now more and more DRNG implementat=
ions
>> in hardware pop up. Why not allowing them to be used. I.e. random.c woul=
d only
>> contain the logic to manage entropy but uses the DRNG requested by a use=
r.
>
> We *do* allow them to be used.  And we support a large number of
> hardware random number generators already.  See drivers/char/hw_random.
>
> BTW, I theorize that this is why the companies that could do the
> bootloader random seen work haven't bothered.  Most of their products
> have a TPM or equivalent, and with modern kernel the hw_random
> interface now has a kernel thread that will automatically fill the
> /dev/random entropy pool from the hw_random device.  So this all works
> already, today, without needing a userspace rngd (which used to be
> required).
>
>> In addition allowing a replacement of the DRNG component (at compile tim=
e at
>> least) may get us away from having a separate DRNG solution in the kerne=
l
>> crypto API. Some users want their chosen or a standardized DRNG to deliv=
er
>> random numbers. Thus, we have several DRNGs in the kernel crypto API whi=
ch are
>> seeded by get_random_bytes. Or in user space, many folks need their own =
DRNG
>> in user space in addition to the kernel. IMHO this is all a waste. If we=
 could
>> use the user-requested DRNG when producing random numbers for get_random=
_bytes
>> or /dev/urandom or getrandom.
>
> To be honest, I've never understood why that's there in the crypto API
> at all.  But adding more ways to switch out the DRNG for /dev/random
> doesn't solve that problem; in fact it's moving things in the wrong
> direction.
