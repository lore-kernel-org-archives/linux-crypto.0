From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Possible bug in AUTHENC
Date: Thu, 20 May 2010 15:17:50 +1000
Message-ID: <20100520051750.GB7443@gondor.apana.org.au>
References: <AANLkTiltCjRr91OASbzzDplRp3zl5yaUnM0RKwzg3S_G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Shikhar <shikhark@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:47375 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826Ab0ETFRw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 May 2010 01:17:52 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTiltCjRr91OASbzzDplRp3zl5yaUnM0RKwzg3S_G@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 19, 2010 at 03:24:24PM +0200, Shikhar wrote:
> Hi,
> 
> I am currently working on a driver for our crypto HW and the initial
> aim was to offload IPSec (ESP for now) to HW. I did this by
> registering the cipher and hash algorithms (both asynchronous)
> separately (AES-CBC, HMAC-SHA1 only for now) and let the API handle
> the request using the AUTHENC interface.
> 
> The problem seems to be after the asynchronous hash request is
> completed, the length of the ABLKCIPHER decrypt request is not
> calculated correctly in "authenc_verify_ahash_update_done()" and
> "authenc_verify_ahash_done()". The length should be subtracted by
> "authsize" as done in "crypto_authenc_decrypt()".
> 
> The following patch (applied against 2.6.34) should fix it. I hope I
> didn't miss anything.

Your patch looks good to me.  Could you please resubmit with
a sign-off (see Documentation/SubmittingPatches)?

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
