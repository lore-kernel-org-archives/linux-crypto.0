From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Fri, 19 Aug 2016 09:48:05 +0200
Message-ID: <20160819074805.GA18425@atrey.karlin.mff.cuni.cz>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
 <20160817214254.GA22438@amd>
 <20160818172712.GA22054@thunk.org>
 <20160818183923.GA24817@amd>
 <20160819024947.GA10888@thunk.org>
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
In-Reply-To: <20160819024947.GA10888@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> > From my point of view, it would make sense to factor time from RTC and
> > mac addresses into the initial hash. Situation in the paper was so bad
> > some devices had _completely identical_ keys. We should be able to do
> > better than that.
> 
> We fixed that **years** ago.  In fact, the authors shared with me an
> early look at that paper and I implemented add_device_entropy() over
> the July 4th weekend back in 2012.  So we are indeed mixing in MAC
> addresses and the hardware clock (if it is initialized that early).
> In fact that was one of the first things that I did.  Note that this

Ok, thanks.

> > BTW... 128 interrupts... that's 1.3 seconds, right? Would it make
> > sense to wait two seconds if urandom use is attempted before it is
> > ready?
> 
> That really depends on the system.  We can't assume that people are
> using systems with a 100Hz clock interrupt.  More often than not
> people are using tickless kernels these days.  That's actually the
> problem with changing /dev/urandom to block until things are
> initialized.

Ok, let me check:

config HZ_PERIODIC
config NO_HZ_IDLE
config NO_HZ_FULL

in HZ_PERIODIC, there should be no problem.

NO_HZ_IDLE... should not be a problem either. We can easily make sure
that cpu's are not idle, something like 

     while (not_enough_entropy())
     	   schedule()

NO_HZ_FULL.... first, help text seems to imply that timer ticks still
happen when cpu is in kernel, and second, there is always one CPU that
handles timer ticks. So we are still ok.

So I believe we should add the wait to urandom. One second delay in
rare cases sounds better than alternatives.

Best regards,
									Pavel
PS: Are there systems where the timer interrupt is the only source of time?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
