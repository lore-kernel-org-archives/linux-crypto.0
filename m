From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Mon, 25 Apr 2016 07:12:02 +0200
Message-ID: <2786389.45NX5QFsAJ@positron.chronox.de>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <9492847.lAf6tQpUi9@positron.chronox.de> <20160424212459.GA4725@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandyinchina@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53518 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbcDYFMG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 01:12:06 -0400
In-Reply-To: <20160424212459.GA4725@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 24. April 2016, 23:25:00 schrieb Pavel Machek:

Hi Pavel,

> > /* This RNG does not work if no high-resolution timer is available */
> > BUG_ON(!random_get_entropy() && !random_get_entropy());
> 
> Heh, does this cause BUG() with 2^-64 probability? :-).

No, but for the listed arches, get_cycles would return 0. And I only call the 
function twice to not be tripped by a potential wrap around at the time of 
calling.
> 
> > If there is no high-resolution timer, the LRNG will not produce good
> > entropic random numbers. The current kernel code implements
> > high-resolution timers for all but the following architectures where
> > neither random_get_entropy nor
> > get_cycles are implemented:
> Ok, what about stuff like Intel 486 (no RDTSC)?
> 
> > Thus, for all large-scale architectures, the LRNG would be applicable.
> > 
> > Please note that also the legacy /dev/random will have hard time to obtain
> > entropy for these environments. The majority of the entropy comes
> > from high-
> 
> Understood.
> 
> > Though, the patch I offer leaves the legacy /dev/random in peace for those
> > architectures to not touch the status quo.
> 
> Well -- that's the major problem -- right? Makes it tricky to tell
> what changed, and we had two RNGs to maintain.

I would rather think that even the legacy /dev/random should not return any 
values in those environments. The random numbers that are returned on these 
systems are bogus, considering that the only noise source that could deliver 
some entropy excluding timestamps (if you trust the user) are the HID event 
values. And for those listed systems, I doubt very much that they are used in 
a desktop environment where you have a console.

If everybody agrees, I can surely add some logic to make the LRNG working on 
those systems. But those additions cannot be subjected to a thorough entropy 
analysis. Yet I feel that this is wrong.

My goal with the LRNG is to provide a new design using proven techniques that 
is forward looking. I am aware that the design does not work in circumstances 
where the high-res timer is not present. But do we have to settle on the least 
common denominator knowing that this one will not really work to begin with?

Ciao
Stephan
