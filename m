From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 20:43:55 +0200
Message-ID: <5279345.Lo7T948V4W@positron.chronox.de>
References: <20160426015943.27472.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: sandyinchina@gmail.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernrl.org,
	tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53702 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbcDZSoG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 14:44:06 -0400
In-Reply-To: <20160426015943.27472.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 25. April 2016, 21:59:43 schrieb George Spelvin:

Hi George,
> 
> > not the rest of Stephan's input handling code: the parity
> > calculation and XORing the resulting single bit into the entropy pool.
> 
> Indeed, this is an incredibly popular novice mistake and I don't
> understand why people keep making it.

Can you please elaborate on your statement to help me understanding the issue 
and substantiate your claim here?

Please note the mathematical background I outlined in my documentation: What I 
try is to collapse the received data such as a time stamp into one bit by 
XORing each bit with each other. Note, the bits within a time stamp are IID 
(independent and identically distributed -- i.e. when you see one or more bits 
of a given time stamp, you cannot derive the yet unseen bit values). 
Technically this is identical to a parity calculation.

The XOR operation is known how it relates to entropy. Besides, I discussed 
such approach with mathematicians from NIST as well as the German BSI and 
neither even expressed remote concerns.

Given the measurements of the resulting bit stream behaving like white noise, 
dependencies between the time stamps are eliminated at least on a statistical 
level as well.

[...]

> 2. Use a good collision-resistant, and preferably cryptographically
>    strong, hash.  /dev/random's CRC-based input mix is pretty much
>    the lightest defensible thing.  XOR is bad for for the same reason
>    that any additive checksum is weak.

I am wondering about such kind of statements:

- the folded bit stream already behaves like white noise considering 
statistical measurements. A hash can only whiten a data stream but not 
increase its entropy. So, whiten an already white noise does not look 
convincing to me.

- the output of the entropy pool is meant to be fed into a DRBG. Such DRBG 
(let us take the example of a Hash DRBG) will, well, hash the input data. So, 
what help does a hash to raw entropy before feeding it to a DRBG which will 
hash it (again)?

- the entropy pool maintenance does not need to have any backtracking 
resistance as (1) it is always postprocessed by the cryptographic operation of 
the DRBG, and (2) constantly overwritten by new interrupts coming in

- to hash raw input data is usually performed to whiten it. When you have a 
need to whiten it, it contains skews and statistical weaknesses that you try 
to disguise. My approach is to not disguise anything -- I try to have "nothing 
up my sleeve". 


Ciao
Stephan
