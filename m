From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Wed, 6 Nov 2013 14:26:35 +0100
Message-ID: <20131106132635.GA25971@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <4763730.CsXSbevC1J@tauon>
 <7447932.fADKoNoZRI@tauon>
 <6186307.PQMXWdkvke@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6186307.PQMXWdkvke@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> >I plugged that idea into my current Jitter RNG processing and disabled
> >the other jitter measurements to get a clear, isolated picture.
> >
> >The result is also a white noise! And it is even quite fast.
> 
> After doing some more research on this approach, I have to admit that 
> the output not good (i.e. white noise) in all situations. Therefore, I 
> dropped that (for now).

Is there chance to extract at least some entropy from it? (Can you
post the code you used for testing?) Because in this case we know
where the entropy comes from, which is important for Ted.

Thanks,
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
