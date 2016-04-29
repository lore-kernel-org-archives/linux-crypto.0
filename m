From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 29 Apr 2016 18:32:36 -0400
Message-ID: <20160429223236.18347.qmail@ns.horizon.com>
References: <2585243.Yy23BEqhqI@positron.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:25238 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752041AbcD2Wci (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 18:32:38 -0400
In-Reply-To: <2585243.Yy23BEqhqI@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I think we can agree that we disagree.

Yes, we agree on that, at least!

The problem is, this is supposed to be a matter of fact, not opinion,
so there should be one right answer.

I suppose it's possible it's still an issue of terminology, but we've
exhausted

> Though, I will get back to the drawing board and think about the problem
> of how to efficiently collect entropy.

For *collecting* it, there are two obvious sources that would be very
nice to use, I've just never had the courage to dig into the relevant
subsystems deep enough to add the hooks.

These could be turned on when entropy is required and turned off afterward:

1) The RTC periodic interrupt.  This is invariably driven by
   a separate 32.768 Hz crystal, so the jitter against the main
   clock oscillator is a useful source.

   A stadanrd PC RTC can run at up to 8 kHz, and probably deliver
   a few hundred bits/s.

2) Any available ADCs, especially audio ADCs.  A 16-bit or better ADC is a
   very rich source of entropy.  We'd need hook into the audio subsystem
   which could activate the ADC when needed and, most importantly,
   guarantee that the data did not go anywhere else.

   Becasue we can't guarantee that the audio input is quiet when collected,
   the entropy would have to be estimated a priori rather than deduced
   from measurements.  Some measurements would still be useful as a sanity
   check to ensure the data isn't digital zero or something.


For storing it after collecting it, I still think the current CRC-based
scheme is pretty good.  Note that cyclical XOR is a special case of this,
just using a polynomial of x^4096-1.  The good properties of CRCs for
detection of hardware-type errors are exactly equivalent to the collision
resistance properties desired for an entropy pool.

A collision results in an undetected error in the former case, and loss
of entropy in the latter.
