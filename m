From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: 14 Dec 2014 14:47:30 -0500
Message-ID: <20141214194730.17204.qmail@ns.horizon.com>
References: <2320511.tdzPj5eXcj@tachyon.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:31055 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750727AbaLNTrc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2014 14:47:32 -0500
In-Reply-To: <2320511.tdzPj5eXcj@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> Pending issues:
>> * Neil would like me to post the results of the NIST and FIPS test
>>   vectors.  The current code doesn't print anything on a successful
>>   test; I need to know what result format is wanted.
>> * Stephan says he has the FIPS test vectors referred to above and
>>   will send them to me when he finds them.

> I have send these vectors about a week ago. Do you have results?

I got them, but I've been twiddling my thumbs waiting for the first
point above: to know what format the results should be in.

> Note, apart from the two comments  I sent today, I do not see any big
> prolems in the patch set. However, I would like to see the test results.

As far as I can tell, the tcrypt.ko module prints *nothing* if a test
is successful, and there is no module option to make it more verbose,
so I don't know what to show people.

I can say "yes, I ran it, and saw no errors" but that seems unsatisfactory.

What would you like to see, other than the following uuencoded test
results:

begin 664 test_results
`
end

As I mentioned (in passing; you may have forgotten), for my own use,
I simply copied the test code & vectors out of testmgr.[ch] and pasted
it into ansi_cprng.c's prng_mod_init (at the end, so it doesn't mess up
the line numbers of the other patches), with some tweaks to say "Test
%d passed".

There's also a debug option that dumps all kinds of details in
_get_more_prng_bytes, but that produces so much output on a 10,000-round
MCT that the kernel log buffer overflows and loses data.
