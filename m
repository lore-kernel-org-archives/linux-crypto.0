From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Thu, 18 Aug 2016 22:49:47 -0400
Message-ID: <20160819024947.GA10888@thunk.org>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
 <20160817214254.GA22438@amd>
 <20160818172712.GA22054@thunk.org>
 <20160818183923.GA24817@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au,
        sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
        John Denker <jsd@av8n.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160818183923.GA24817@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 18, 2016 at 08:39:23PM +0200, Pavel Machek wrote:
> 
> But this is the scary part. Not limited to ssh. "We perform the
> largest ever network survey of TLS and SSH servers and present
> evidence that vulnerable keys are surprisingly widespread. We find
> that 0.75% of TLS certificates share keys due to insufficient entropy
> during key generation, and we suspect that another 1.70% come from the
> same faulty implementations and may be susceptible to compromise.
> Even more alarmingly, we are able to obtain RSA private keys for 0.50%
> of TLS hosts and 0.03% of SSH hosts, because their public keys shared
> nontrivial common factors due to entropy problems, and DSA private
> keys for 1.03% of SSH hosts, because of insufficient signature
> randomness"
> 
> https://factorable.net/weakkeys12.conference.pdf

That's a very old paper, and we've made a lot of changes since then.
Before that we weren't accumulating entropy from the interrupt
handler, but only from spinning disk drives, some network interrupts
(but not from all NIC's; it was quite arbitrary), and keyboard and
mouse interrupts.  So hours and hours could go by and you still
wouldn't have accumulated much entropy.

> From my point of view, it would make sense to factor time from RTC and
> mac addresses into the initial hash. Situation in the paper was so bad
> some devices had _completely identical_ keys. We should be able to do
> better than that.

We fixed that **years** ago.  In fact, the authors shared with me an
early look at that paper and I implemented add_device_entropy() over
the July 4th weekend back in 2012.  So we are indeed mixing in MAC
addresses and the hardware clock (if it is initialized that early).
In fact that was one of the first things that I did.  Note that this
doesn't really add much entropy, but it does prevent the GCD attack
from demonstrating completely identical keys.  Hence, we had
remediations in the mainline kernel before the factorable.net paper
was published (not that really helped with devices with embedded
Linux, especially since device manufactures don't see anything wrong
with shipping machines with kernels that are years and years out of
date --- OTOH, these systems were probably also shipping with dozens
of known exploitable holes in userspace, if that's any comfort.
Probably not much if you were planning on deploying lots of IOT
devices in your home network.  :-)

> BTW... 128 interrupts... that's 1.3 seconds, right? Would it make
> sense to wait two seconds if urandom use is attempted before it is
> ready?

That really depends on the system.  We can't assume that people are
using systems with a 100Hz clock interrupt.  More often than not
people are using tickless kernels these days.  That's actually the
problem with changing /dev/urandom to block until things are
initialized.

If you do that, then on some system Python will use /dev/urandom to
initialize a salt used by the Python dictionaries, to protect against
DOS attacks when Python is used to run web scripts.  This is a
completely irrelevant reason when Python is being used for systemd
generator scripts in early boot, and if /dev/urandom were to block,
then the system ends up doing nothing, and on a tickless kernels hours
and hours can go by on a VM and Python would still be blocked on
/dev/urandom.  And since none of the system scripts are running, there
are no interrupts, and so Python ends up blocking on /dev/urandom for
a very long time.  (Eventually someone will start trying to brute
force passwords on the VM's ssh port, assuming that the VM's firewall
rules allow this, and that will cause interrupts that will eventually
initialize /dev/urandom.  But that could take hours.)

And this, boys and girls, is why we can't make /dev/urandom block
until its pool is initialized.  There's too great of a chance that we
will break userspace, and then Linus will yell at us and revert the
commit.

						- Ted
