From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Wed, 19 Jul 2017 13:26:03 -0400
Message-ID: <20170719172603.zlea7amylgdwt7hc@thunk.org>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <1780567.qGdv4EjEMp@positron.chronox.de>
 <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
 <4766174.b2XBWsRgGl@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41270 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753166AbdGSR0J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 13:26:09 -0400
Content-Disposition: inline
In-Reply-To: <4766174.b2XBWsRgGl@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 19, 2017 at 08:22:18AM +0200, Stephan Müller wrote:
> In the email [1] I have expressed the core concerns I see -- none of them 
> address the need to keep the Jitter RNG as one noise source. To address those, 
> a very deep dive into random.c needs to be made.

That's simply not true.  The other issues besides the Jitter RNG are
really nits.

One of your complaints is the fact that we collect both interrupt
timing and HID/block timings.  First of all, we could eliminate the
HID/block timings since in practice we get the vast majority of our
entropy from the interrupt timing.  I keep it because we have a real
theoretical basis for their being unpredictability from the HID/block
timings.  For example, [1].

[1] http://world.std.com/~dtd/random/forward.pdf

The fact that there might be double count from the perspective of
entropy is not really an issue because we do a "fast mix" of 64
interrupts before we mix into the primary interrupt pool.  And when we
do mix into the primary pool we count that only as a single bit of
entropy.  The reason why I'm being super cautious here is because some
of these interrupts might be timer interrupts, or come from other
sources that might be correlated to the clock interrupt.  The
conservative assumption here is that at least one of the interrupts
out of 64, on average, will come from something that the adversary can
not anticipate, such as coming from a NIC or wireless device, and that
we will get at least one bit's worth of unpredictability.

The fact that we also mix in the jiffies plus the keyboard/mouse scan
code, is something that happens immediately.  So even if you think we
should not count the fast mix interrupt count, the fact that we mix
the timing values from 64 interrupts before we credit the entropy
counter by a single bit is sufficiently conservative; we're talking
about 1/64th of a bit here.

But if you **really** think mixing in the timing of the HID event
(gathered via a different mechanism --- jiffies vs cycle counter, and
including the the keyboard scan), a patch to disable
add_keyboard_randomness() is pretty trivial.  It doesn't justify a
complete rewrite of the random core.

(BTW, granted this is anecdata, but on my laptop, the CRNG is fully
initialized before systemd has even started and before the root file
system is mounted.  And after that point the entropy initialization
only matters for the legacy apps that use /dev/random, which doesn't
even exist in your proposed RNG, since everything just uses a
ChaCha20-based CRNG.)


Another one of your complaints is a straw-man argument ("I understand
that this pathological case is not present for the legacy
/dev/random...").  First of all, how we do entropy estimation after
the CRNG boot is far less important, because the primary recommended
interface is /dev/urandom or better yet getrandom(2).  Secondly, we
*don't* allow transfer of small quantums of entropy.  There is a
minimum transfer limit of 64 bits, and that can easily be increased to
128 bits if one really cared.  I've never really considered recovery
from state compromise to be that important, but if one did care,
increasing that limit is a two line patch.


I could go on, but the bottom line is that, quite frankly, I don't
consider your criticsms to be particular compelling or convincing.

Regards,

						- Ted
