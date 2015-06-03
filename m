From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/8] crypto: Avoid using RNG in interrupt context
Date: Wed, 3 Jun 2015 14:46:41 +0800
Message-ID: <20150603064641.GA4655@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37821 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbFCGqq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:46:46 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Currently we always use stdrng in interrupt context, which doesn't
work very well with DRBG which cannot be called there.

We could change DRBG but it really does a lot of work (e.g., a
reseed) in its generation function and doing it in interrupt context
would be bad.

In fact, the only reason we were doing this in interrupt context
is to conserver entropy, which is a non-issue with DRBG.

So this series changes all the RNG users to only use the RNG in
process context, and then makes DRBG the default RNG.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
