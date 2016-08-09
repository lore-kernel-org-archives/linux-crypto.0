From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] hwrng: core - Allow for multiple simultaneous active
 hwrng devices
Date: Tue, 9 Aug 2016 18:26:20 +0000
Message-ID: <20160809182620.GF2013@io.lakedaemon.net>
References: <1469477255-26824-1-git-send-email-keithp@keithp.com>
 <20160809095058.GA6618@gondor.apana.org.au>
 <20160809165710.GC2013@io.lakedaemon.net>
 <86y445rfiq.fsf@hiro.keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Keith Packard <keithp@keithp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:39442 "EHLO
	outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbcHIS0d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 14:26:33 -0400
Content-Disposition: inline
In-Reply-To: <86y445rfiq.fsf@hiro.keithp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Keith,

On Tue, Aug 09, 2016 at 10:58:05AM -0700, Keith Packard wrote:
> Jason Cooper <jason@lakedaemon.net> writes:
> > Perhaps a /dev/hwrng[0-9] per rng?  That would lend itself nicely to a
> > sysfs interface for per device quality, rate, and enabled attributes.
> > e.g. /sys/class/hw_random/hwrng0/{device/,quality,rate,enabled}
> 
> I was interested in the data being provided for /dev/random; that seems
> like the most important interface to me.

Me too, agreed.

> But, exposing all of the devices using consistent names does seem like
> a useful idea at some level.

On another thread, regarding the ath9k-rng (actually just the adc
registers), Henrique asked about per-source knobs.  My suggestion
follows from that.

> > /dev/hwrng could pull from the one with the highest quality, or user
> > specified for backwards compatibility.
> 
> I like the notion of using all of them in turn; if one of them turns out
> to be broken, you're still stirring in data from the others. After all,
> the quality metric is provided by the device, we aren't doing any
> analysis on the data to determine it independently.

Sure, but /dev/hwrng is a user interface.  Typically to rngd, but not
necessarily.  We need to make sure it's behavior is consistent with
existing expectations.

We shouldn't attach first-probed to /dev/hwrng, because that may not be
what the user is expecting.  If I bought a raw entropy source, and knew
nothing of the proposed multi-source interfaces, I'd expect the USB
dongle to be attached to /dev/hwrng.  Despite the fact that my pcie wifi
card was probed first and has adc registers providing an entropy source.

I'm not sure how we ensure that.  Perhaps an 'environmental' flag in the
hw_random source attributes?  Or a 'not-designed-to-be-an-rng' flag? :)
Maybe those would be /dev/envrng[0-9]...

thx,

Jason.
