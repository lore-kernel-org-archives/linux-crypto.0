From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Mon, 15 Dec 2014 09:50:17 +0100
Message-ID: <6843393.LtnAY8kkPy@tauon>
References: <20141215084244.10306.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55057 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaLOIub (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 03:50:31 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC51F> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 15 Dec 2014 09:50:26 +0100
In-Reply-To: <20141215084244.10306.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Dezember 2014, 03:42:44 schrieb George Spelvin:

Hi George,

>> - the non-determinism you get from get_random_int is very weak. If
>> you start thinking about the information theoretical entropy behind
>> that function that is used once in a while, you may not get much
>> entropy. Please, please, please, I do not want to start a discussion
>> around entropy -- I will not participate in such discussion :-)
>
>I could have such a discussion, but there's no need to; for the most
>part, I agree with you.  I wasn't trying to design a *good* RNG, I was
>trying to comply slavishly with what X9.17, X9.31, and the NIST
>specification call for: a timetamp.
>
>To quote
>http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf,
>section 3:
>
># Let DT be a date/time vector which is updated on each iteration.
>
>That's what I was trying to produce, nothing more and nothing less.

If you look into other X9.31 implementations, you see that the DT vector 
is a time stamp (even sometimes initialized to just 0 or 1) and then 
incremented each time. Thus, you get "some form" of a counter mode for 
the AES core.

But of course, you could update DT with time stamps, provided you can 
prove that they are monotonically increasing. 
>
>You will agree, I hope, that the result from get_random_int *does*
>include the entropy of a high-resolution timestamp?  Which is

get_random_int does provide entropy, but my gut feeling (I have not done 
measurements) is that it is in the range of maybe 2 / 3 bits per 
invocation.

>cryptographically equivalent to including the unobfuscated timestamp?

Sure.
>
>> Thus, I am questioning whether such slightly non-deterministic RNG
>> would be used.
>
>As far as I know the only reason to *ever* use ansi_cprng is for
>regulatory/certification reasons.  It's not horrible, but it's
>definitely been superseded, by the NIST SP800-90A generators at least.

Yes, therefore we have the DRBG implementation.
>
>Which is why I'm trying to follow the spec as precisely as possible.

If you only look at the regulatory side, then you must be aware of 
SP800-131A applicable at least to the US side. X9.31 is sunsetted by the 
end of 2015 and even not FIPS 140-2 certifiable any more for new 
validations.

Ciao
Stephan
