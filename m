From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] hwrng: core - Allow for multiple simultaneous active
 hwrng devices
Date: Tue, 9 Aug 2016 16:57:10 +0000
Message-ID: <20160809165710.GC2013@io.lakedaemon.net>
References: <1469477255-26824-1-git-send-email-keithp@keithp.com>
 <20160809095058.GA6618@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Keith Packard <keithp@keithp.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pmta2.delivery5.ore.mailhop.org ([54.186.218.12]:63062 "EHLO
	pmta2.delivery5.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419AbcHIQ5Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 12:57:16 -0400
Content-Disposition: inline
In-Reply-To: <20160809095058.GA6618@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Keith, Herbert,

On Tue, Aug 09, 2016 at 05:50:58PM +0800, Herbert Xu wrote:
> On Mon, Jul 25, 2016 at 01:07:35PM -0700, Keith Packard wrote:
> > Instead of having only one hwrng feeding /dev/random at a time, maintain
> > a list of devices and cycle between them when filling the entropy pool.
> > 
> > Signed-off-by: Keith Packard <keithp@keithp.com>
> 
> So you're cycling RNGs even for user-space reads? That could be
> problematic because not all hardware RNGs carry the maximum amount
> of entropy.  It would be rather annoying to be cycling between
> RNGs of different qualities.
> 
> Perhaps only cycle for the kernel hwrngd?

Perhaps a /dev/hwrng[0-9] per rng?  That would lend itself nicely to a
sysfs interface for per device quality, rate, and enabled attributes.
e.g. /sys/class/hw_random/hwrng0/{device/,quality,rate,enabled}

/dev/hwrng could pull from the one with the highest quality, or user
specified for backwards compatibility.

thx,

Jason.
