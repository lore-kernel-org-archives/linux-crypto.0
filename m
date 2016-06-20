From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Mon, 20 Jun 2016 10:27:40 +0200
Message-ID: <20160620082740.GA10238@amd>
References: <2754489.L1QYabbYUc@positron.chronox.de>
 <20160619193614.GA26146@amd>
 <3817952.8FvMDE0Kc7@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3817952.8FvMDE0Kc7@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> > On Sun 2016-06-19 17:58:41, Stephan Mueller wrote:
> > > Hi Herbert, Ted,
> > > 
> > > The following patch set provides a different approach to /dev/random which
> > > I call Linux Random Number Generator (LRNG) to collect entropy within the
> > > Linux kernel. The main improvements compared to the legacy /dev/random is
> > > to provide sufficient entropy during boot time as well as in virtual
> > > environments and when using SSDs. A secondary design goal is to limit the
> > > impact of the entropy collection on massive parallel systems and also
> > > allow the use accelerated cryptographic primitives. Also, all steps of
> > > the entropic data processing are testable. Finally massive performance
> > > improvements are visible at /dev/urandom and get_random_bytes.
> > 
> > Dunno. It is very similar to existing rng, AFAICT. And at the very
> > least, constants in existing RNG could be tuned to provide "entropy at
> > the boot time".
> 
> The key differences and thus my main concerns I have with the current design 
> are the following items. If we would change them, it is an intrusive change. 
> As of now, I have not seen that intrusive changes were accepted. This led me 
> to develop a competing algorithm.

Well, intrusive changes are hard to do, but replacing whole subsystems
is even harder -- and rightly so.

> - There was a debate around my approach assuming one bit of entropy per 
> received IRQ. I am really wondering about that discussion when there is a much 
> bigger "forcast" problem with the legacy /dev/random: how can we credit HIDs 
> up to 11 bits of entropy when the user (a potential adversary) triggers these 
> events? I am sure I would be shot down with such an approach if I would 
> deliver that with a new implementation.

Well, if you can demonstrate 11 bits is too much, go ahead... I'm sure
that is rather easy to adjust.

But I believe that 1) user is not normally an adversary and 2) the
best thing for him to do would still be "pressing nothing". It will be
hard to press keys (etc) with great enough precision...

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
