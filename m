From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC HIFN 00/02]: RNG support
Date: Sat, 17 Nov 2007 22:53:25 +0300
Message-ID: <20071117195324.GA4010@2ka.mipt.ru>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40588 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879AbXKQTxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2007 14:53:32 -0500
Content-Disposition: inline
In-Reply-To: <20071117192949.19399.75523.sendpatchset@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Patrick.

On Sat, Nov 17, 2007 at 08:30:09PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> These two patches add support for using the HIFN rng.

Great!

> The first patch improves the PLL initialization a bit by making the
> reference clock configurable and its speed known to the driver, which
> is needed to calculate the amount of time to wait between two RNG reads.
> Since there is no way to find out the frequency reliably (especially for
> the external clock), it adds some sane looking defaults and a module
> parameter to override it. Suggestions how to improve this are welcome.

I'm not sure it is possible to get it cleaner anyway.

> The second patch adds hw_random support. The ugly part is finding out
> when to allow reads from the RNG. It currently translates the public
> key engine clock cycles to CPU cycles based on a 4GHz CPU and uses
> get_cycles(). The problems with this are obvious, it only works on CPUs
> that actually have some kind of cycle counter, has problems with
> unsynchronized TSCs and the 4GHz assumption is not very nice either,
> but I was reluctant to use ktime for this since it seems rather
> expensive to call ktime_get once per 4 bytes of random. Suggestion
> for improvement of this are also welcome :)

It will not work on arm, but I'm not sure this is relevant...
Another option is to directly access xtime without all wrappers in the
ktime_get().

> Running rngtest on the random number generator indicates that it works
> properly, with an average failure ratio of about 1:1000 at ~2.5mbit.
> 
> 
>  drivers/crypto/hifn_795x.c |  158 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 156 insertions(+), 2 deletions(-)
> 
> Patrick McHardy (2):
>       [HIFN]: Improve PLL initialization
>       [HIFN]: Add support for using the random number generator

Ack both patches.
Thanks a lot Patrick.

-- 
	Evgeniy Polyakov
