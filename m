From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: 15 Dec 2014 03:42:44 -0500
Message-ID: <20141215084244.10306.qmail@ns.horizon.com>
References: <4224700.3m7VJgkz0U@tachyon.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:31195 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750917AbaLOImq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 03:42:46 -0500
In-Reply-To: <4224700.3m7VJgkz0U@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> - the non-determinism you get from get_random_int is very weak. If you start
> thinking about the information theoretical entropy behind that function that
> is used once in a while, you may not get much entropy. Please, please, please,
> I do not want to start a discussion around entropy -- I will not participate
> in such discussion :-)

I could have such a discussion, but there's no need to; for the most part,
I agree with you.  I wasn't trying to design a *good* RNG, I was trying
to comply slavishly with what X9.17, X9.31, and the NIST specification
call for: a timetamp.

To quote http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf,
section 3:

# Let DT be a date/time vector which is updated on each iteration. 

That's what I was trying to produce, nothing more and nothing less.

You will agree, I hope, that the result from get_random_int *does* include
the entropy of a high-resolution timestamp?  Which is cryptographically
equivalent to including the unobfuscated timestamp?

> Thus, I am questioning whether such slightly non-deterministic RNG would be 
> used.

As far as I know the only reason to *ever* use ansi_cprng is for
regulatory/certification reasons.  It's not horrible, but it's definitely
been superseded, by the NIST SP800-90A generators at least.

Which is why I'm trying to follow the spec as precisely as possible.
