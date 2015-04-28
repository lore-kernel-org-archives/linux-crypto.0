From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Tue, 28 Apr 2015 09:09:41 +0800
Message-ID: <20150428010941.GA28820@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51682 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbbD1BJr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 21:09:47 -0400
Content-Disposition: inline
In-Reply-To: <1515730.LIeS5qas5m@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 26, 2015 at 12:07:31AM +0200, Stephan Mueller wrote:
> Hi,
> 
> Please note that this patch will conflict with the DRBG patch for
> additional seeding sent earlier today. Both add test vectors in
> testmgr.c between the existing hmac() and lrw() due to the ordering
> requirements of testmgr.c.

Can you clarify the use case of this algorithm? In particular,
who is going to use it in the kernel? This doesn't seem to be
a candidate for use via algif since there aren't any or aren't
likely going to be any hardware implementations.

If we can narrow down who is going to use it perhaps we can then
figure out the appropriate interface for this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
