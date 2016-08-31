From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: FIPS - allow tests to be disabled in FIPS mode
Date: Wed, 31 Aug 2016 23:18:07 +0800
Message-ID: <20160831151807.GB28366@gondor.apana.org.au>
References: <1685622.m1phZymvbe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Tapas Sarangi <TSarangi@trustwave.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38628 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933887AbcHaPSL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 11:18:11 -0400
Content-Disposition: inline
In-Reply-To: <1685622.m1phZymvbe@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 25, 2016 at 03:15:01PM +0200, Stephan Mueller wrote:
> In FIPS mode, additional restrictions may apply. If these restrictions
> are violated, the kernel will panic(). This patch allows test vectors
> for symmetric ciphers to be marked as to be skipped in FIPS mode.
> 
> Together with the patch, the XTS test vectors where the AES key is
> identical to the tweak key is disabled in FIPS mode. This test vector
> violates the FIPS requirement that both keys must be different.
> 
> Reported-by: Tapas Sarangi <TSarangi@trustwave.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
