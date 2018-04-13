From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/5] random: fix crng_ready() test
Date: Fri, 13 Apr 2018 08:53:13 -0400
Message-ID: <20180413125313.GA2633@thunk.org>
References: <20180413013046.404-1-tytso@mit.edu>
 <1699469.KmO53oa8XU@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1699469.KmO53oa8XU@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 13, 2018 at 07:38:30AM +0200, Stephan Mueller wrote:
> > The crng_init variable has three states:
> > 
> > 0: The CRNG is not initialized at all
> > 1: The CRNG has a small amount of entropy, hopefully good enough for
> >    early-boot, non-cryptographical use cases
> > 2: The CRNG is fully initialized and we are sure it is safe for
> >    cryptographic use cases.
> > 
> > The crng_ready() function should only return true once we are in the
> > last state.
> > 
> Do I see that correctly that getrandom(2) will now unblock after the 
> input_pool has obtained 128 bits of entropy? Similarly for 
> get_random_bytes_wait.

Correct.

> As this seems to be the only real use case for crng_ready (apart from 
> logging), what is the purpose of crng_init == 1?

Immediately after boot (crng_init state 0), we funnel the harvested
entropy from add_interrupt_entropy() directly to the CRNG pool.  The
goal is to get at least some amount of entropy into the CRNG is it's
not blatently predictable.  When we have accomplished this, by mixing
in 2 * CHACHA20_KEY_SIZE bytes of input from add_input_randomness, we
enter state crng_init state 1.

In crng_init state 1, we start funnelling the harvested entropy to the
input_pool.  Once we have accumulated 128 bits of entropy in the input
pool, we then reseed the CRNG from the input_pool, and we consider the
CRNG to be fully intialized.

During crng_init state 1, the CRNG is basically in a "good enough for
government work" state.  It's going to get used by things like initial
TCP sequence numbers, and UUID's by udev, et. al, but I wouldn't want
to use it for anything that has strong cryptographic use cases.

It would be preferable if nothing in the kernel and early systemd
startup used get_random_bytes() or /dev/urandom or getrandom(2) w/
GRND_NONBLOCK.  Unfortunately, (a) there is a lot of legacy code which
still uses /dev/urandom and not getrandom(2) and (b) in some cases,
such as initialization of the Stack Canary, the kernel simply can't
wait for the CRNG to be fully initialized.  Or if the kernel needs
enough of the networking stack to mount an NFS root file system, for
example.

This was always the original design intent, but I screwed up and no
one noticed until Jann reached out to be and said, "Hey.... this
doesn't seem to make much sense".

Regards,

					- Ted
