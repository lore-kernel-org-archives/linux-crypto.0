From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: 15 Dec 2014 05:45:31 -0500
Message-ID: <20141215104531.21040.qmail@ns.horizon.com>
References: <6843393.LtnAY8kkPy@tauon>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:55480 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750782AbaLOKpd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 05:45:33 -0500
In-Reply-To: <6843393.LtnAY8kkPy@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> If you look into other X9.31 implementations, you see that the DT vector 
> is a time stamp (even sometimes initialized to just 0 or 1) and then 
> incremented each time. Thus, you get "some form" of a counter mode for 
> the AES core.

I'm not saying you're wrong, but that still seems to me an extremely
contrived interpretation.  You're right that the tick rate isn't specified
and "once per call" isn't unambigously forbidden, but the plain reading
of the spec calls for a clock, not a counter.

> But of course, you could update DT with time stamps, provided you can 
> prove that they are monotonically increasing. 

I don't even see a need for that, although I could easily do it (by
adding get_random_int() rather than replacing).  I thought the goal was
that they were non-repeating, so short cycles are impossible.

>> You will agree, I hope, that the result from get_random_int *does*
>> include the entropy of a high-resolution timestamp?  Which is
>> cryptographically equivalent to including the unobfuscated timestamp?

> get_random_int does provide entropy, but my gut feeling (I have not done 
> measurements) is that it is in the range of maybe 2 / 3 bits per 
> invocation.

You said you didn't want to start a conversation about entropy, remember?
:-)  So I'm not discussing the issue, but please don't interpret that
as conceding anything.

As I said, it doesn't matter; my goal is just to do what the spec asks
for, as faithfully as possible without introducing any stupidities in
the process.

>> Which is why I'm trying to follow the spec as precisely as possible.

> If you only look at the regulatory side, then you must be aware of 
> SP800-131A applicable at least to the US side. X9.31 is sunsetted by the 
> end of 2015 and even not FIPS 140-2 certifiable any more for new 
> validations.

Well, if nobody wants it, why not simply rip it out?

I'm assuming there are other requirements documents that refer to
those documents, and haven't been updated to reflect tha changes.

That's what tends to happen: requirements flow downstream over
a period of years.  NIST may change its mind, but my contract
hasn't noticed yet.

I know this from personal experience: I've had frustrating discussions
about a "too hard to change" requirement for 1024-bit DSA *and* FIPS
140 certification.
