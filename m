From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Possible bug in AUTHENC
Date: Thu, 20 May 2010 19:42:09 +1000
Message-ID: <20100520094209.GA11131@gondor.apana.org.au>
References: <AANLkTiltCjRr91OASbzzDplRp3zl5yaUnM0RKwzg3S_G@mail.gmail.com> <20100520051750.GB7443@gondor.apana.org.au> <AANLkTimSgYBqh0HxizUbCoywTZyUN9yPoCOsibQQNVRj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Shikhar <shikhark@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:53742 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755131Ab0ETJmM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 May 2010 05:42:12 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimSgYBqh0HxizUbCoywTZyUN9yPoCOsibQQNVRj@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 20, 2010 at 11:26:00AM +0200, Shikhar wrote:
> crypto: authenc - Fix "cryptlen" calculation.
> 
> This patch (applied against 2.6.34) fixes the calculation of the
> length of the ABLKCIPHER decrypt request ("cryptlen") after an
> asynchronous hash request has been completed in the AUTHENC interface.
> 
> Signed-off-by: Shikhar Khattar <shikhark@gmail.com>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
