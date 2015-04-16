From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: DRBG parallel requests
Date: Thu, 16 Apr 2015 22:44:55 +0800
Message-ID: <20150416144455.GA17293@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Stephan Mueller <smueller@chronox.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46024 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbbDPOo7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Apr 2015 10:44:59 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan:

Currently you can have two users of DRBG issuing requests in
parallel and end up using the same internal state.  The only
difference between them is the cycle counter that you inject
into the DRBG.

I can't see how this is safe as the cycle counter contains minimal
entropy.  The whole DRBG scheme depends on the fact that states
are not reused so surely this is a very bad thing?

I think we should just stick with locking the entire generation
function.

The only users of RNG in the crypto API do so in process context
so we can make it a rule that all users RNG must be in process
context.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
