From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Tue, 21 Jun 2016 18:28:40 +0200
Message-ID: <183335903.ioesrD1Ugf@tauon.atsec.com>
References: <2754489.L1QYabbYUc@positron.chronox.de> <24059874.5WizEqNrfz@tauon.atsec.com> <e2612733-f3c1-bdc0-5822-3f20c44fe781@gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e2612733-f3c1-bdc0-5822-3f20c44fe781@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 21. Juni 2016, 12:03:56 schrieb Austin S. Hemmelgarn:

Hi Austin,

> On 2016-06-21 03:32, Stephan Mueller wrote:
> > Am Dienstag, 21. Juni 2016, 09:12:07 schrieb Nikos Mavrogiannopoulos:
> > 
> > Hi Nikos,
> > 
> >> On Mon, Jun 20, 2016 at 5:43 PM, Stephan Mueller <smueller@chronox.de>
> > 
> > wrote:
> >>>> Personally, I don't really use /dev/random, nor would I recommend it
> >>>> for most application programmers.  At this point, getrandom(2) really
> >>>> is the preferred interface unless you have some very specialized
> >>>> needs.
> >>> 
> >>> I fully agree. But there are use cases for /dev/random, notably as a
> >>> seed
> >>> source for other DRNG.
> >> 
> >> Is that really the case? I believe all DRNG's use /dev/urandom anyway
> >> for seeding since they cannot afford indeterminate blocking. It would
> >> be a gain for everyone if /dev/random was the same as /dev/urandom in
> >> Linux.
> > 
> > For standard approaches, this is true. But there are regulations, notably
> > in the German realm, /dev/random shall be used, at least partially (see
> > AIS 20/31).
> 
> Which just goes to show how utterly stupid some people who write laws
> and regulations are.  Saying specifically that '/dev/random shall be
> used' does not enforce any improvement of entrophic value in the data at
> all, it just coincidentally improves the theoretical quality of the data
> because of how Linux and some legacy UNIX systems are designed.  This
> 'regulation' already provides zero benefit other than a placebo effect
> on at least OpenBSD, FreeBSD, and I'm pretty certain most other BSD
> derivatives, as /dev/random and /dev/urandom point to the same thing
> there (on OpenBSD it's an arcfour based drbg, FreeBSD does similar but
> uses a CSPRNG called Fortuna), and while I'm not certain, I believe AIX
> does likewise (although they use a design based on yarrow).

It is NOT utterly stupid, you should listen to the reasons. The core reason is 
explained with the following analogy:

/dev/urandom, for a short period of time, operates as a DRNG. For the sake of 
discussion, let us assume that it is a DRNG which is, for the sake of 
discussion, seeded with 256 bits of entropy.

Now, you pull 256 bits out of it, you have 256 bits of entropy.

You pull again 256 bit out of it -- what entropy do you have? You do NOT have 
*again* 256 bits of entropy. All you can say is the entire generated 512 bits 
have collectively 256 bits of entropy. And so on and so forth.

Now, if you want to say that your newly spawned DRNG is seeded with X amount 
of entropy, the DRNG nature of /dev/urandom makes such a statement a 
challenge. The easy way out of the challenge is to use /dev/random (I am aware 
of the fact that the DRNG has a computational strength, but it is not, well, 
entropy).

In addition, when using /dev/urandom, you have to show that at the time you 
seed the DRNG, it is fully seeded. That is a challenge at boot time - a 
challenge this entire thread revolves around. Yes, getrandom(2) is the way 
out, but not everybody uses it. Again, /dev/random does NOT have this 
challenge.
> 
> On top of that though, just because some poorly thought out standard
> requires it's usage doesn't mean we have to work based on that.

I cannot concur.


Ciao
Stephan
