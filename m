From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Tue, 18 Jul 2017 21:51:33 -0400
Message-ID: <20170719015133.aijabk36g7m6daek@thunk.org>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <150039607.torZXMN7kc@positron.chronox.de>
 <20170718085212.GB25267@kroah.com>
 <1780567.qGdv4EjEMp@positron.chronox.de>
 <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
 <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 09:00:10PM -0400, Sandy Harris wrote:
> The only really good solution I know of is to find a way to provide a
> chunk of randomness early in the boot process. John Denker has a good
> discussion of doing this by modifying the kernel image & Ted talks of
> doing it via the boot loader. Neither looks remarkably easy. Other
> approaches like making the kernel read a seed file or passing a
> parameter on the kernel command line have been suggested but, if I
> recall right, rejected.

It's actually not that _hard_ to modify the boot loader.  It's not
finicky work like, say, adding support for metadata checksums or xattr
deduplication to ext4.  It's actually mostly plumbing.  It's just that
we haven't found a lot of people willing to do it as paid work, and
the hobbyists haven't been interested.

> As I see it, the questions about Jitter, or any other in-kernel
> generator based on timing, are whether it is good enough to be useful
> until we have one of the above solutions or useful as a
> defense-in-depth trick after we have one. I'd say yes to both.
> 
> There's been a lot of analysis. Stephan has a detailed rationale & a
> lot of test data in his papers & the Havege papers also discuss
> getting entropy from timer operations. I'd say the best paper is
> McGuire et al:
> https://static.lwn.net/images/conf/rtlws11/random-hardware.pdf

So here's the problem that I have with most of these analyses.  Most
of them are done using the x86 as the CPU.  This is true of the
McGuire, Okech, and Schiesser paper you've cited above.  But things
are largely irrelevant on the x86, because we have RDRAND.  And while
I like to mix in environmental noise before generating personal
long-term public keys.  I'm actually mostly OK with relying on RDRAND
for initializing the seeds for hash table to protect against network
denial of service attacks.  (Which is currently the first user of the
not-yet-initialized CRNG on my laptop during kernel boot.)

The real problem is with the non-x86 systems that don't have a
hardware RNG, and there depending timing events which don't depend on
external devices is much more dodgy.  Remember that on most embedded
devices there is only a single oscillator driving the entire system.
It's not like you even have multiple crystal oscillators beating
against one another.

So if you are only depending on CPU timing loops, you basically have a
very complex state machine, driven by a single oscillator, and you're
trying to kid yourself that you're getting entropy out the other end.
How is that any different from using AES in counter mode and claiming
because you don't know the seed, that it's "true randomness"?  It
certainly passes all of the statistical tests!

Hence, we have to rely on external events outside of the CPU and so we
need to depend on interrupt timing --- and that's what we do in
drivers/char/random.c already!  You can debate whether we are being
too conservative with when we judge that we've collective enough
unpredictability to count it as a "bit" of randomness.  So it's
trivially easy to turn the knob and make sure the CRNG gets
initialized more quickly using fewer interrupt timings, and boom!
Problem solved.

Simply turning the knob to make our entropy estimator more lax makes
people uncomfortable, and since they don't have access to the internal
microarchitecture of the CPU, they take comfort in the fact that it's
really, really complicated, and so something like the Jitter RNG
*must* be a more secure way to do things.  But that's really an illusion.

If the real unpredictability is really coming from the interrupts
changing the state of the CPU microarchitecture, the real question is
how many interrupts do you need before you consider things
"unpredictable" to an adequate level of security?  Arguing that we
should turn down the "interrupts per bit of entropy" in
drivers/char/random.c is a much more honest way of having that
discussion.

					- Ted

P.S.  In the McGuire paper you cited, it assumes that the system is
fully booted and there are multiple processes running which are
influencing the kernel scheduler.  This makes the paper **not** an
applicable at all.  So if you think that is the most compelling
analysis, I'm definitely not impressed....
