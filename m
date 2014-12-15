From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Mon, 15 Dec 2014 07:18:45 +0100
Message-ID: <9854162.QuL0WEq81y@tachyon.chronox.de>
References: <20141214194730.17204.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55050 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbaLOGSr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 01:18:47 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC4D2> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 15 Dec 2014 07:18:45 +0100
In-Reply-To: <20141214194730.17204.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 14. Dezember 2014, 14:47:30 schrieb George Spelvin:

Hi George,

> >> Pending issues:
> >> * Neil would like me to post the results of the NIST and FIPS test
> >> 
> >>   vectors.  The current code doesn't print anything on a successful
> >>   test; I need to know what result format is wanted.
> >> 
> >> * Stephan says he has the FIPS test vectors referred to above and
> >> 
> >>   will send them to me when he finds them.
> > 
> > I have send these vectors about a week ago. Do you have results?
> 
> I got them, but I've been twiddling my thumbs waiting for the first
> point above: to know what format the results should be in.


I just would like to see a yes or no -- you got the expected results with the 
test vectors too. Thus, generate the random numbers, do a comparison with the 
expected results (and maybe publish your code for others to verify) and be 
done with it.
> 
> > Note, apart from the two comments  I sent today, I do not see any big
> > prolems in the patch set. However, I would like to see the test results.
> 
> As far as I can tell, the tcrypt.ko module prints *nothing* if a test
> is successful, and there is no module option to make it more verbose,
> so I don't know what to show people.

Passing tcrypt and testmgr is good. However, the CAVS test vectors test some 
edge conditions. Therefore, I would like to see them passing and not just the 
"normal" test vectors in testmgr.
> 
> I can say "yes, I ran it, and saw no errors" but that seems unsatisfactory.

Publish the code on how you ran it.
> 
> What would you like to see, other than the following uuencoded test
> results:
> 
> begin 664 test_results
> `
> end
> 
> As I mentioned (in passing; you may have forgotten), for my own use,
> I simply copied the test code & vectors out of testmgr.[ch] and pasted
> it into ansi_cprng.c's prng_mod_init (at the end, so it doesn't mess up
> the line numbers of the other patches), with some tweaks to say "Test
> %d passed".

See above on my thoughts of those vectors.
> 
> There's also a debug option that dumps all kinds of details in
> _get_more_prng_bytes, but that produces so much output on a 10,000-round
> MCT that the kernel log buffer overflows and loses data.

No interim results are necessary.

-- 
Ciao
Stephan
