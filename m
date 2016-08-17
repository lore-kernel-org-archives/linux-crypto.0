From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Wed, 17 Aug 2016 23:42:55 +0200
Message-ID: <20160817214254.GA22438@amd>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
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
In-Reply-To: <20160811213632.GL10626@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> As far as whether or not you can gather enough entropy at boot time,
> what we're really talking about how how much entropy we want to assume
> can be gathered from interrupt timings, since what you do in your code
> is not all that different from what the current random driver is
> doing.  So it's pretty easy to turn a knob and say, "hey presto, we
> can get all of the entropy we need before userspace starts!"  But
> justifying this is much harder, and using statistical tests isn't
> really sufficient as far as I'm concerned.

Actually.. I'm starting to believe that getting enough entropy before
userspace starts is more important than pretty much anything else.

We only "need" 64-bits of entropy, AFAICT. If it passes statistical
tests, I'd use it... for initial bringup.

We can switch to more conservative estimates when system is fully
running. But IMO it is very important to get _some_ randomness at the
begining...

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
