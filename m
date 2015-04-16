From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: DRBG seeding
Date: Thu, 16 Apr 2015 22:36:17 +0800
Message-ID: <20150416143617.GA17178@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37413 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbbDPOgW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Apr 2015 10:36:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan:

Currently DRBG is seeded with entropy from get_random_bytes.
However, get_random_bytes is basically the kernel version of
/dev/urandom.  So there is no guarantee that you're actually
getting the amount of entropy required.

Are you sure this is compliant with the DRBG specification?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
