From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about the Crypto API
Date: Thu, 8 Aug 2013 15:01:40 +1000
Message-ID: <20130808050139.GA9636@gondor.apana.org.au>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <20130806120540.GA364@oc8526070481.ibm.com>
 <20130806141612.GB364@oc8526070481.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47919 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953Ab3HHFBr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Aug 2013 01:01:47 -0400
Content-Disposition: inline
In-Reply-To: <20130806141612.GB364@oc8526070481.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 06, 2013 at 11:16:12AM -0300, Marcelo Cerri wrote:
> Herbert,
> 
> Let me include a few more questions.
> 
> There are flags in several structures such as crypto_async_request,
> blkcipher_desc and crypto_tfm. How they are intended to be used?
> 
> For example if I want to explicitly make a call that shouldn't sleep,
> should I clear the CRYPTO_TFM_REQ_MAY_SLEEP in one of these structures?
> And in which one?
> 
> Since cryptographic methods can be called in softirq contexts, is the
> caller responsible for setting this flag correctly based on the context
> it is running?

Yes, although MAY_SLEEP is mostly used by synchronous implementations
since async drivers can simply return instead of sleeping.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
