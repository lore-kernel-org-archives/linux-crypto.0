From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Sun, 03 Nov 2013 08:20:34 +0100
Message-ID: <3537770.iLHXPOXMiU@tauon>
References: <2579337.FPgJGgHYdz@tauon> <7861469.OAmn4h8An0@tauon> <20131102110112.GA16231@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:43377 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab3KCHUn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Nov 2013 02:20:43 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S1D7> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 3 Nov 2013 08:20:35 +0100
In-Reply-To: <20131102110112.GA16231@amd.pavel.ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 2. November 2013, 12:01:13 schrieb Pavel Machek:

Hi Pavel,

>Hi!
>
>> >sense of where the unpredictability might be coming from, and
>> >whether
>> >the unpredictability is coming from something which is fundamentally
>> >arising from something which is chaotic or quantum effect, or just
>> >because we don't have a good way of modelling the behavior of the
>> >L1/L2 cache (for example) and that is spoofing your entropy
>> >estimator.
>> 
>> Please note: if the jitter really comes from the oscillator effect of
>> the RAM clock vs. the CPU clock (which I suspect), we will not be
>> able
>> to alter the jitter software wise.
>
>Well... if it is really oscillator effect, there should be _no_
>entropy when running with L1/L2 enabled (because DRAM will not be
>accessed at all at that case).

That is a good one!

Another friend of mine mentioned that he assumes the rise and fall times 
of transistors varies very slightly and could be the main reason for the 
jitter. I do not think that this is really the case, because our gates 
that form the CPU instructions comprise of many transistors. The 
combined raise/fall jitter should cancel each other out.

That said, the full root cause is is not really known at this time 
considering that major chip vendors have no real clue either.

>
>There should be way to extract entropy more directly from various
>oscillator effects, no?

I am working a different way of measuring such oscillator effects by 
using the high-resolution timer of the CPU and measure it with a 
Jiffies-based snapshotting window. So, here I would combine two timers 
that are differently generated. If their frequencies would be relative 
prime to each other, we would measure a direct oscillator effect.

This already was tried in the cryptlib RNG, but I try a slightly 
different approach.

Yet, nothing is complete at this point.
>
>For DRAM, just perform timing, have entropy. Plus we could for example
>measure PIT vs. other timer sources... (but I suspect that on PCs we
>already have enough entropy...)

I suspect so too, but my measurements as of now are not conclusive.
>									
Pavel


Ciao
Stephan
