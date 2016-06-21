From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Tue, 21 Jun 2016 20:46:44 +0200
Message-ID: <4433978.k6OLO1ofNE@positron.chronox.de>
References: <2754489.L1QYabbYUc@positron.chronox.de> <183335903.ioesrD1Ugf@tauon.atsec.com> <8e41b430-51e5-b0a4-8801-e44c9623e2bd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37846 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbcFUSqw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 14:46:52 -0400
In-Reply-To: <8e41b430-51e5-b0a4-8801-e44c9623e2bd@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. Juni 2016, 14:22:48 schrieb Austin S. Hemmelgarn:

Hi Austin,

> On 2016-06-21 12:28, Stephan Mueller wrote:
> > Am Dienstag, 21. Juni 2016, 12:03:56 schrieb Austin S. Hemmelgarn:
> > 
> > Hi Austin,
> > 
> >> On 2016-06-21 03:32, Stephan Mueller wrote:
> >>> Am Dienstag, 21. Juni 2016, 09:12:07 schrieb Nikos Mavrogiannopoulos:
> >>> 
> >>> Hi Nikos,
> >>> 
> >>>> On Mon, Jun 20, 2016 at 5:43 PM, Stephan Mueller <smueller@chronox.de>
> >>> 
> >>> wrote:
> >>>>>> Personally, I don't really use /dev/random, nor would I recommend it
> >>>>>> for most application programmers.  At this point, getrandom(2) really
> >>>>>> is the preferred interface unless you have some very specialized
> >>>>>> needs.
> >>>>> 
> >>>>> I fully agree. But there are use cases for /dev/random, notably as a
> >>>>> seed
> >>>>> source for other DRNG.
> >>>> 
> >>>> Is that really the case? I believe all DRNG's use /dev/urandom anyway
> >>>> for seeding since they cannot afford indeterminate blocking. It would
> >>>> be a gain for everyone if /dev/random was the same as /dev/urandom in
> >>>> Linux.
> >>> 
> >>> For standard approaches, this is true. But there are regulations,
> >>> notably
> >>> in the German realm, /dev/random shall be used, at least partially (see
> >>> AIS 20/31).
> >> 
> >> Which just goes to show how utterly stupid some people who write laws
> >> and regulations are.  Saying specifically that '/dev/random shall be
> >> used' does not enforce any improvement of entrophic value in the data at
> >> all, it just coincidentally improves the theoretical quality of the data
> >> because of how Linux and some legacy UNIX systems are designed.  This
> >> 'regulation' already provides zero benefit other than a placebo effect
> >> on at least OpenBSD, FreeBSD, and I'm pretty certain most other BSD
> >> derivatives, as /dev/random and /dev/urandom point to the same thing
> >> there (on OpenBSD it's an arcfour based drbg, FreeBSD does similar but
> >> uses a CSPRNG called Fortuna), and while I'm not certain, I believe AIX
> >> does likewise (although they use a design based on yarrow).
> > 
> > It is NOT utterly stupid, you should listen to the reasons.
> 
> I'm not commenting about them wanting cryptographically secure entropy.
> My statement about the intelligence of the people who wrote the standard
> was commenting on their saying '/dev/random shall be used' instead of 'a

It behooves if you read the documents before making statements! AIS 20/31 does 
not require /dev/random in the documentation, but specifies a number of 
requirements for a seed source (NTG.1, PTG.[1|2|3]). And /dev/random happens 
to be an NTG.1 whereas /dev/urandom is not.

> cryptographically secure entropy source shall be used'.  POSIX requires
> that the first statement imply the second, but the second does not
> require the first.  Their choice to use the first indicates that they
> assume this will be the only implementation that will ever matter, and
> that POSIX systems will be the only thing anyone using the standard
> cares about, both of which are inherently poor assumptions outside of a
> completely closed system.  Most standards proposed or mandated by
> bureaucracies have similar issues making bad assumptions about the
> context in which they will be used.
> 
> > The core reason is
> > explained with the following analogy:
> > 
> > /dev/urandom, for a short period of time, operates as a DRNG. For the sake
> > of discussion, let us assume that it is a DRNG which is, for the sake of
> > discussion, seeded with 256 bits of entropy.
> > 
> > Now, you pull 256 bits out of it, you have 256 bits of entropy.
> > 
> > You pull again 256 bit out of it -- what entropy do you have? You do NOT
> > have *again* 256 bits of entropy. All you can say is the entire generated
> > 512 bits have collectively 256 bits of entropy. And so on and so forth.
> > 
> > Now, if you want to say that your newly spawned DRNG is seeded with X
> > amount of entropy, the DRNG nature of /dev/urandom makes such a statement
> > a challenge. The easy way out of the challenge is to use /dev/random (I
> > am aware of the fact that the DRNG has a computational strength, but it
> > is not, well, entropy).
> > 
> > In addition, when using /dev/urandom, you have to show that at the time
> > you
> > seed the DRNG, it is fully seeded. That is a challenge at boot time - a
> > challenge this entire thread revolves around. Yes, getrandom(2) is the way
> > out, but not everybody uses it. Again, /dev/random does NOT have this
> > challenge.
> 
> The fact that that's how /dev/urandom works is a result of the
> implementation, I already listed at least 3 UNIX derivatives that do not
> work this way and provide cryptographically secure entropy from the same
> source stream for both /dev/random and /dev/urandom.  Changing this on
> Linux would not break backwards compatibility as long as we provide
> sufficient entropy via /dev/random, because nobody depends on it
> blocking for anything other than ensuring they get good entropy, so if
> it always returns good cryptographically secure entropy, we never need
> to block unless the generator hasn't yet been seeded.  Now, on top of
> that, there's still no absolute guarantee that what you get from
> /dev/random is actually cryptographically secure, but that's a separate
> issue.

I am not sure what your point is, so let us leave it at that.

Ciao
Stephan
