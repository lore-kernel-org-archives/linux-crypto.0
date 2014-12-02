From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 03/17] crypto: ansi_cprng - Eliminate ctx->I
Date: 2 Dec 2014 15:03:38 -0500
Message-ID: <20141202200338.13255.qmail@ns.horizon.com>
References: <20141202145249.GE3388@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:62517 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751396AbaLBUDk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 15:03:40 -0500
In-Reply-To: <20141202145249.GE3388@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I'm only ok with removing I if you can continue to be able to output it.
> given that I is listed as part of the test sequences that NIST provides,
> I'd like to be able to compare the values.

I can do that easily, but I can't print the *input* I, which
is the result of encrypting the previous DT, as it's thrown
away earlier.

You'd have to look further back in the debug messages to find it.

Is changing the format of the debug messages okay?  I'd like the debug
messages to describe the code, but I don't know if you have something
that parses the current output.


The test output I see on p. 33 of
http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
doesn't include I.  Can you point me to a sample that includes I?

It might be best to more significantly  rework the debug messages to
resemble the NIST test vectors.
