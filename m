From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 23:01:29 +0200
Message-ID: <25204908.NQ7XpImiHx@positron.chronox.de>
References: <20160426204330.15098.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53734 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbcDZVBd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 17:01:33 -0400
In-Reply-To: <20160426204330.15098.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 26. April 2016, 16:43:30 schrieb George Spelvin:

Hi George,

(I am not covering the initial part as I leave you time to read through the 
paper which should cover those aspects)

> 
> That's what I don't like about Intel's RDRAND and similar hardware RNGs:
> they are whitening too early.
> 
> That's also what I don't like about XORing down to 1 bit before adding
> to the pool.  Again, whitening too early!
> 
> 
> Is that any clearer?

I see what you are saying. And I know that the best way (TM) would be to 
simply concatenate the time stamps. But that is not feasible.

And considering that I only want to have 0.9 bits of entropy, why should I not 
collapse it? The XOR operation does not destroy the existing entropy, it only 
caps it to at most one bit of information theoretical entropy. As I can show 
that the original value has many more bits of entropy, I use that as my safety 
margin.

Hence, I combine the safety margin provided by the XOR folding with a nice and 
easy maintenance of the harvested one bit by simply concatenating them. Again, 
the entire harvesting and collection shall be very easy to understand without 
hiding anything. In addition it is intended to solely use XOR and 
concatenation, i.e. the two only functions whose effect on entropy are known.

Ciao
Stephan
