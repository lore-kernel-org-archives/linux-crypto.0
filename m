From: Pavel Machek <pavel@ucw.cz>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 21:41:55 +0200
Message-ID: <20160426194155.GB11111@amd>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
 <20160426030735.GD28496@thunk.org>
 <20160426184439.GA8162@amd>
 <1948798.MKebf3xYm7@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46862 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbcDZTl6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 15:41:58 -0400
Content-Disposition: inline
In-Reply-To: <1948798.MKebf3xYm7@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

> > > > When dropping the add_disk_randomness function in the legacy
> > > > /dev/random, I
> > > > would assume that without changes to add_input_randomness and
> > > > add_interrupt_randomness, we become even more entropy-starved.
> > > 
> > > Sure, but your system isn't doing anything magical here.  The main
> > > difference is that you assume you can get almost a full bit of entropy
> > > out of each interrupt timing, where I'm much more conservative and
> > > assume we can only get 1/64th of a bit out of each interrupt timing.
> > 
> > Maybe 1/64th of a bit is a bit too conservative? I guess we really
> > have more than one bit of entropy on any system with timestamp
> > counter....
> > 
> > Making it 1/2 of bit (or something) should be very easy way to improve
> > entropy early during boot...
> 
> I can easily settle on 1/2 bit here. The LRNG currently uses 0.9 bits which 
> are based on measurements plus a safety margin. But I see no issue to even 
> lower it further to, say, 1/2.

No, you don't need to change anything. But maybe mainline rng should
change.

									Pavel
									
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
