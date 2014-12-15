From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Mon, 15 Dec 2014 12:08:03 +0100
Message-ID: <8223281.EXVFeIIs4d@tauon>
References: <20141215104531.21040.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55070 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaLOLIl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 06:08:41 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC56D> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 15 Dec 2014 12:08:32 +0100
In-Reply-To: <20141215104531.21040.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Dezember 2014, 05:45:31 schrieb George Spelvin:

Hi George,

>>> You will agree, I hope, that the result from get_random_int *does*
>>> include the entropy of a high-resolution timestamp?  Which is
>>> cryptographically equivalent to including the unobfuscated
>>> timestamp?
>> 
>> get_random_int does provide entropy, but my gut feeling (I have not
>> done measurements) is that it is in the range of maybe 2 / 3 bits
>> per invocation.
>
>You said you didn't want to start a conversation about entropy,
>remember?
>:-)  So I'm not discussing the issue, but please don't interpret that
>
>as conceding anything.

;-)
>
>As I said, it doesn't matter; my goal is just to do what the spec asks
>for, as faithfully as possible without introducing any stupidities in
>the process.
>
>>> Which is why I'm trying to follow the spec as precisely as possible.
>> 
>> If you only look at the regulatory side, then you must be aware of
>> SP800-131A applicable at least to the US side. X9.31 is sunsetted by
>> the end of 2015 and even not FIPS 140-2 certifiable any more for new
>> validations.
>
>Well, if nobody wants it, why not simply rip it out?

All I referred to was the US regulatory side. And the US is not the 
world.

Note, even NIST considers X9.31 as a strong RNG after speaking with 
their cryptographers a couple of weeks ago. The only drawback it has is 
the missing reseed requirement which is brought in by SP800-90A.

After implementing SP800-90A I have to admit that I like the X9.31 for 
its simplicity (which is en-par with the HMAC DRBG which I therefore 
marked as default in the DRBG). The other two DRBGs (Hash and CTR are 
too complex for my personal taste -- but they are there for 
completeness).

Thus, I think the X9.31 does have a purpose as it implements a 
reasonably simple DRNG.
>
>I'm assuming there are other requirements documents that refer to
>those documents, and haven't been updated to reflect tha changes.

There are other regulartory bodies which still approve of the X9.31 -- 
like the German BSI, provided you can show that your use case ensures 
proper reseeding.
>
>That's what tends to happen: requirements flow downstream over
>a period of years.  NIST may change its mind, but my contract
>hasn't noticed yet.

Exactly -- there are use cases where the latest NIST regulations either 
accidentally or deliberately are not considered.

The biggest issue is today's "bad smell" of the SP800-90A standard after 
the Dual EC DRBG fiasco. Thus, I think people should think twice before 
using a NIST developed standard (which X9.31 is not, albeit IIRC it came 
out of the NSA realm long time ago).
>
>I know this from personal experience: I've had frustrating discussions
>about a "too hard to change" requirement for 1024-bit DSA *and* FIPS
>140 certification.

Hehehe, been there, done that, experienced the same.


Ciao
Stephan
