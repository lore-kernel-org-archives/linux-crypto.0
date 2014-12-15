From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: 15 Dec 2014 03:28:16 -0500
Message-ID: <20141215082816.9004.qmail@ns.horizon.com>
References: <9786224.Pe6urDKot3@tachyon.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:51043 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750865AbaLOI2S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 03:28:18 -0500
In-Reply-To: <9786224.Pe6urDKot3@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> That output is good for the VST test vectors. For the MCT vectors, I need the 
> 10000th value.

That was test 9 in the first group:

> [167586.784923] COUNT = 9
> [167586.784925] Key = 10379b53317a2500879e88ad445ea387
> [167586.784927] DT = 055a913d7587d54ee58c053fd4beb4a2
> [167586.784928] V = a7d058a34e1bf49b40f0b6d26661f889
> [167586.791891] R = c252c3f173558775929fe3fb8345feb2
> [167586.791892] cprng: Test 9 passed
> [167586.797633] cprng: Stutter test 9 passed

Just like the CAVS test vectors, I don't print the "loops" value
anywhere.

> With some minor editor massaging (deleting the timestamps and
> inserting a blank line before every "COUNT" line), it matches the
> ANSI931_AES128MCT.fax and ANSI931_AES128VST.fax you sent.  I left it
> un-massaged as some sort of evidence that it isn't just a direct copy.

> I cannot match these test vectors and the results to the ones I sent to you. 
> E.g. I do not find the key value f3b1666d13607242ed061cabb8d46202 anywhere in 
> the data set.

Sorry, that's the union of the testmgr.h tests, a couple I added by hand,
and (at the end) the ones you sent me.

So no, you can't find all of my test results in your test vectors, but
all of your test vectors are in my test results.

(In all cases, the software compares the results with the expected answers.)
