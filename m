From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Sun, 24 Apr 2016 10:03:45 +0200
Message-ID: <5435493.2Hi9JfvD3o@positron.chronox.de>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com> <20160424020323.GD20980@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160424020323.GD20980@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Samstag, 23. April 2016, 22:03:23 schrieb Theodore Ts'o:

Hi Theodore,

> On Fri, Apr 22, 2016 at 06:27:48PM -0400, Sandy Harris wrote:
> > I really like Stephan's idea of simplifying the interrupt handling,
> > replacing the multiple entropy-gathering calls in the current driver
> > with one routine called for all interrupts. See section 1.2 of his
> > doc. That seems to me a much cleaner design, easier both to analyse
> > and to optimise as a fast interrupt handler.
> 
> The current /dev/random driver *already* has a fast interrupt handler,
> and it was designed specifically to be very fast and very lightweight.

I agree here. The only challenge with the current implementation is the time 
the fast_pool is to be mixed into an entropy pool. This requires a lock and 
quite some code afterwards.

I tried hard to avoid such additional code paths in my LRNG.
> 
> It's a fair argument that getting rid of add_disk_randomness()
> probably makes sense.  However, add_input_randomness() is useful
> because it is also mixing in the HID input (e.g., the characters typed
> or the mouse movements), and that is extremely valuable and I wouldn't
> want to get rid of this.

In addition to the request to remove the Jitter RNG, I also have added support 
for the add_input_randomness function into the LRNG. I will release the code 
shortly.

When dropping the add_disk_randomness function in the legacy /dev/random, I 
would assume that without changes to add_input_randomness and 
add_interrupt_randomness, we become even more entropy-starved. The entropy 
heuristic for add_interrupt_randomness cannot be re-valued to a higher level 
because the time stamp for the HID is still processed as part of 
add_input_randomness -- i.e. there is still a high correlation between the 
processed values of add_interrupt_randomness and add_input_randomness. Thus, 
all events received for block devices are now valued at most with 1/64th bits 
of entropy when dropping add_disk_randomness (which partially used to be 
valued higher).

Thus, I tried with the LRNG to implement add_input_randomness as follows: it 
only picks up the key numbers or mouse coordinates but no timestamp. Those are 
mixed into the entropy pool without crediting any entropy. The reason for not 
crediting any entropy is that an unprivileged user knows the keys he pressed. 
Thus the user is an observer and a potential attacker that has full knowledge 
of an input value into the entropy pool. As each HID event is also processed 
as an interrupt, the interrupt processing of the LRNG will credit close to one 
bit of entropy for each HID event due to the interrupt timing nonetheless.
> 
> > In the current driver -- and I think in Stephan's, though I have not
> > looked at his code in any detail, only his paper -- heavy use of
> > /dev/urandom or the kernel get_random_bytes() call can deplete the
> > entropy available to /dev/random. That can be a serious problem in
> > some circumstances, but I think I have a fix.
> 
> So /dev/urandom, or preferentially, the getrandom(2) system call,
> which will block until the entropy pool is initialized, is designed to
> be a CRNG.  We use the entropy accounting for the urandom pool as a
> hueristic to know how aggressively to pull the random pool and/or
> things like hwrandom (since pulling entropy from the TPM does have
> costs, for example power utilization for battery-powered devices).
> 
> We already throttle back how much we pull from the input pool if it is
> being used heavily, specifically to avoid this problem.

Agreed. And this exact behavior I tried to replicate into the LRNG (the 
blocking of getrandom and the emergency entropy for /dev/random). The 
processing leaves an "emergency" level of entropy in the pool that is 
inaccessible to /dev/urandom. Furthermore, when a call to /dev/random drains 
the entropy pool completely, the emergency entropy is replenished first before 
/dev/urandom gets new entropy from the entropy pool.

Ciao
Stephan
