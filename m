From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: CTR DRBG - advance output buffer pointer
Date: Mon, 21 Nov 2016 22:55:29 +0800
Message-ID: <20161121145529.GA6730@gondor.apana.org.au>
References: <18729386.1pHbKfYFYP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56818 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753882AbcKUOzk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 09:55:40 -0500
Content-Disposition: inline
In-Reply-To: <18729386.1pHbKfYFYP@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 18, 2016 at 12:27:56PM +0100, Stephan Mueller wrote:
> The CTR DRBG segments the number of random bytes to be generated into
> 128 byte blocks. The current code misses the advancement of the output
> buffer pointer when the requestor asks for more than 128 bytes of data.
> In this case, the next 128 byte block of random numbers is copied to
> the beginning of the output buffer again. This implies that only the
> first 128 bytes of the output buffer would ever be filled.
> 
> The patch adds the advancement of the buffer pointer to fill the entire
> buffer.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
