From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Thu, 18 Aug 2016 20:39:23 +0200
Message-ID: <20160818183923.GA24817@amd>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
 <20160817214254.GA22438@amd>
 <20160818172712.GA22054@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        herbert@gondor.apana.org.au, sandyinchina@gmail.com,
        Jason Cooper <cryptography@lakedaemon.net>,
        John Denker <jsd@av8n.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160818172712.GA22054@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2016-08-18 13:27:12, Theodore Ts'o wrote:
> On Wed, Aug 17, 2016 at 11:42:55PM +0200, Pavel Machek wrote:
> > 
> > Actually.. I'm starting to believe that getting enough entropy before
> > userspace starts is more important than pretty much anything else.
> > 
> > We only "need" 64-bits of entropy, AFAICT. If it passes statistical
> > tests, I'd use it... for initial bringup.
> 
> Definitely not 64 bits.  Back in *1996* the estimate was that we
> needed at least 75-bits in order to be protected against brute force
> attacks.  It's been two *deacdes* years later, and granted Moore's law
> has ceased to apply in the last couple of years, but I'm sure 64 bits
> is not enough.
> 
> What is your specific concern vis-a-vis when userspace starts?  We now
> print a warning if someone tries to draw from /dev/urandom, and so it
> should be easy to see if someone is doing something dangerous.  The

Well, warning is nice, but I'm afraid it is not going to stop everyone.

> have only been known cases (at last as far asI know where) where some
> software was doing something as *insane* as to create keys right out
> of the box was.  One was ssh, and at least on a modern Debian system,
> that doesn't happen until fairly late in the process:

It is more widespread than that:

rapsberry pi:
https://www.raspberrypi.org/forums/viewtopic.php?t=126892

But this is the scary part. Not limited to ssh. "We perform the
largest ever network survey of TLS and SSH servers and present
evidence that vulnerable keys are surprisingly widespread. We find
that 0.75% of TLS certificates share keys due to insufficient entropy
during key generation, and we suspect that another 1.70% come from the
same faulty implementations and may be susceptible to compromise.
Even more alarmingly, we are able to obtain RSA private keys for 0.50%
of TLS hosts and 0.03% of SSH hosts, because their public keys shared
nontrivial common factors due to entropy problems, and DSA private
keys for 1.03% of SSH hosts, because of insufficient signature
randomness"

https://factorable.net/weakkeys12.conference.pdf

Responsible devices were Gigaset SX762, ADTran Total Access
businessgrade phone/network routers, IBM RSA II remote administration
cards, BladeCenter devices, Juniper Networks Branch SRX devices,
... "We used the techniques described in Section 3.2 to identify
apparently vulnerable devices from 27 manufacturers.  These include
enterprise-grade routers from Cisco; server management cards from
Dell, Hewlett-Packard, and IBM; virtual-private-network (VPN) devices;
building security systems; network attached storage devices; and
several kinds of consumer routers and VoIP products."

> The other was HP, which was generating an RSA key very shortly after
> the first time the printer was powered on.

Its definitely more than two incidents.

> > We can switch to more conservative estimates when system is fully
> > running. But IMO it is very important to get _some_ randomness at the
> > begining...
> 
> We're doing this already in the latest getrandom(2) implementation.
> For the purposes of initializing the crng, we assume that each
> interrupt has a single bit of entropy.  So it requires 128 initerrupts
> for getrandom(2) to be fully initialized.  I'm actually worried that
> this is too high as it is for architectures that don't have a
> fine-grained clock.  Given that on many of these embedded platforms
> there is a oscillator which drives all of the clocks and subsystems,
> it just doesn't make *sense* that than each interrupt could result in
> 5-6 bits of entropy, no matter what a magical statistical formula
> might say.

>From my point of view, it would make sense to factor time from RTC and
mac addresses into the initial hash. Situation in the paper was so bad
some devices had _completely identical_ keys. We should be able to do
better than that.

BTW... 128 interrupts... that's 1.3 seconds, right? Would it make
sense to wait two seconds if urandom use is attempted before it is
ready?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
