From: Pavel Machek <pavel@ucw.cz>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 20:44:39 +0200
Message-ID: <20160426184439.GA8162@amd>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
 <20160424020323.GD20980@thunk.org>
 <5435493.2Hi9JfvD3o@positron.chronox.de>
 <20160426030735.GD28496@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160426030735.GD28496@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi1

> > When dropping the add_disk_randomness function in the legacy /dev/random, I 
> > would assume that without changes to add_input_randomness and 
> > add_interrupt_randomness, we become even more entropy-starved.
> 
> Sure, but your system isn't doing anything magical here.  The main
> difference is that you assume you can get almost a full bit of entropy
> out of each interrupt timing, where I'm much more conservative and
> assume we can only get 1/64th of a bit out of each interrupt timing.

Maybe 1/64th of a bit is a bit too conservative? I guess we really
have more than one bit of entropy on any system with timestamp
counter....

Making it 1/2 of bit (or something) should be very easy way to improve
entropy early during boot...

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
