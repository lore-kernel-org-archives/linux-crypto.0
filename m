From: tytso@mit.edu
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 17:30:41 +0000
Message-ID: <20160504173041.GB3901@thunk.org>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <6266306.8u6rsYMSBi@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6266306.8u6rsYMSBi@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 03, 2016 at 10:50:25AM +0200, Stephan Mueller wrote:
> > +/*
> > + * crng_init =  0 --> Uninitialized
> > + *		2 --> Initialized
> > + *		3 --> Initialized from input_pool
> > + */
> > +static int crng_init = 0;
> 
> shouldn't that be an atomic_t ?

The crng_init variable only gets incremented (it progresses from
0->1->2->3) and it's protected by the primary_crng->lock spinlock.
There are a few places where we read it without first taking the lock,
but that's where we depend on it getting incremented and where if we
race with another CPU which has just bumped the crng_init status, it's
not critical.  (Or we can take the lock and then recheck the crng_init
if we really need to be sure.)

> > +static void _initialize_crng(struct crng_state *crng)
> > +{
> > +	int		i;
> > +	unsigned long	rv;
> 
> Why do you use unsigned long here? I thought the state[i] is unsigned int.

Because it gets filled in via arch_get_random_seed_long(&rv) and
arch_get_random_log(&rv).  If that means we get 64 bits and we only
use 32 bits, that's OK....

> Would it make sense to add the ChaCha20 self test vectors from RFC7539 here to 
> test that the ChaCha20 works?

We're not doing that for any of the other ciphers and hashes.  We
didn't do that for SHA1, and the chacha20 code where I took this from
didn't check for this as well.  What threat are you most worried
about.  We don't care about chacha20 being exactly chacha20, so long
as it's cryptographically strong.  In fact I think I removed a
potential host order byteswap in the set key operation specifically
because we don't care and interop.

If this is required for FIPS mode, we can add that later.  I was
primarily trying to keep the patch small to be easier for people to
look at it, so I've deliberately left off bells and whistles that
aren't strictly needed to show that the new approach is sound.

> > +	if (crng_init++ >= 2)
> > +		wake_up_interruptible(&crng_init_wait);
> 
> Don't we have a race here with the crng_init < 3 check in crng_reseed 
> considering multi-core systems?

No, because we are holding the primary_crng->lock spinlock.  I'll add
a comment explaining the locking protections which is intended for
crng_init where we declare it.


> > +	if (num < 16 || num > 32) {
> > +		WARN_ON(1);
> > +		pr_err("crng_reseed: num is %d?!?\n", num);
> > +	}
> > +	num_words = (num + 3) / 4;
> > +	for (i = 0; i < num_words; i++)
> > +		primary_crng.state[i+4] ^= tmp[i];
> > +	primary_crng.init_time = jiffies;
> > +	if (crng_init < 3) {
> 
> Shouldn't that one be if (crng_init < 3 && num >= 16) ?

I'll just change the above WRN_ON test to be:

     BUG_ON(num < 16 || num > 32);

This really can't happen, and I had it as a WARN_ON with a printk for
debugging purpose in case I was wrong about how the code works.

> > +		crng_init = 3;
> > +		process_random_ready_list();
> > +		wake_up_interruptible(&crng_init_wait);
> > +		pr_notice("random: crng_init 3\n");
> 
> Would it make sense to be more descriptive here to allow readers of dmesg to 
> understand the output?

Yes, what we're currently printing during the initialization:

random: crng_init 1
random: crng_init 2
random: crng_init 3

was again mostly for debugging purposes.  What I'm thinking about
doing is changing crng_init 2 and 3 messages to be:

random: crng fast init done
random: crng conservative init done

> > +	}
> > +	ret = 1;
> > +out:
> > +	spin_unlock_irqrestore(&primary_crng.lock, flags);
> 
> memzero_explicit of tmp?

Good point, I've added a call to memzero_explicit().

> > +static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
> > +{
> > +	unsigned long v, flags;
> > +	struct crng_state *crng = &primary_crng;
> > +
> > +	if (crng_init > 2 &&
> > +	    time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
> > +		crng_reseed(&input_pool);
> > +	spin_lock_irqsave(&crng->lock, flags);
> > +	if (arch_get_random_long(&v))
> > +		crng->state[14] ^= v;
> > +	chacha20_block(&crng->state[0], out);
> > +	if (crng->state[12] == 0)
> > +		crng->state[13]++;

> What is the purpose to only cover the 2nd 32 bit value of the nonce with 
> arch_get_random?
> 
> state[12]++? Or why do you increment the nonce?

In Chacha20, its output is a funcrtion of the state array, where
state[0..3] is a constant specified by the Chacha20 definition,
state[4..11] is the Key, and state[12..15] is the IV.  The
chacha20_block() function increments state[12] each time it is called,
so state[12] is being used as the block counter.  The increment of
state[13] is used to make state[13] to be the upper 32-bits of the
block counter.  We *should* be reseeding more often than 2**32 calls
to chacha20_block(), and the increment is just to be safe in case
something goes wronng and we're not reseeding.

We're using crng[14] to be contain the output of RDRAND, so this is
where we mix in the contribution from a CPU-level hwrng.  Previously
we called RDRAND multiple times and XOR'ed the results into the
output.  This is a bit faster and is more comforting for paranoiacs
who are concerned that Intel might have down something shifty enough
to be able to read from memory and change the output of RDRAND to
force a particular output from the RNG.

Ware using state[15] to contain the NUMA node id.  This was because
originally the used used the same key bytes (state[4..11]) between
different NUMA state arrays, so state[15] was used to guarantee that
state arrays would be different between different NUMA node state
arrays.  Now that we are deriving the key from a primary_crng, we
could use state[15] for something else, including as a second
destination from RDRAND.

> Now I have to wear my (ugly) FIPS heat: we need that code from the current 
> implementation here:
> 
>                 if (fips_enabled) {
>                         spin_lock_irqsave(&r->lock, flags);
>                         if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
>                                 panic("Hardware RNG duplicated output!\n");
>                         memcpy(r->last_data, tmp, EXTRACT_SIZE);
>                         spin_unlock_irqrestore(&r->lock, flags);
>                 }
> 

I'll add FIPS support as a separate patch.  I personally consider FIPS
support to be a distraction, and it's only useful for people who need
to sell to governments (mostly US governments).

> > -	if (unlikely(nonblocking_pool.initialized == 0))
> > -		printk_once(KERN_NOTICE "random: %s urandom read "
> > -			    "with %d bits of entropy available\n",
> > -			    current->comm, nonblocking_pool.entropy_total);
> > -
> > +	crng_wait_ready();
> 
> Just for clarification: are you now blocking /dev/urandom until the CRNG is 
> filled? That would be a big win.

Until the the fast init state, yes.  In practice we are blocking until
128 interrupts have occurred, which during boot is hapens quickly
enough that even on a simple KVM system, this happens before userspace
starts up.  There *is* a risk here, though.  Imagine a embedded
platform with very few interrupt-driven devices so device probing
isn't enough to make the CRNG ready when the initial ramdisk starts
up, and the init program tries to read from /dev/urandom --- which
then blocks, potentially indefinitely.

If that happens, then we will have broken userspace, and we may need
to revert this part of the change.  But I'm willing to take the risk,
in hopes that such super-simplisitic devices don't exist in real life,
and if they do, the IOT devices will probably be blithely ignoring
cryptographic concerns so much that they aren't using /dev/urandom
anyway.  :-)

>Would it make sense to add another chacha20_block() call here at the end?
>Note, the one thing about the SP800-90A DRBG I really like is the enhanced
>backward secrecy support which is implemented by "updating" the internal state
>(the key / state) used for one or more random number generation rounds after
>one request for random numbers is satisfied.
>
>This means that even if the state becomes known or the subsequent caller
>manages to deduce the state of the RNG to some degree of confidence, he cannot
>backtrack the already generated random numbers.

That's a good idea; being able to prevent back-tracking attacks is
a good thing.  I'll add this in the next version.

Cheers,

						- Ted
