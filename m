From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: api - Change crypto_unregister_instance argument type
Date: Thu, 2 Apr 2015 23:15:23 +0800
Message-ID: <20150402151523.GA10421@gondor.apana.org.au>
References: <20150402143122.GA9699@gondor.apana.org.au>
 <2597941.K7IMfLeYM0@tauon>
 <20150402145911.GA10227@gondor.apana.org.au>
 <8420276.vapgpo2qik@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37921 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbbDBPPZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Apr 2015 11:15:25 -0400
Content-Disposition: inline
In-Reply-To: <8420276.vapgpo2qik@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 02, 2015 at 05:13:23PM +0200, Stephan Mueller wrote:
>
> In crypto_remove_instance, the code dereferences inst->tmpl. If you say that 
> it is not guaranteed that the alg is always wrapped by an inst, wouldn't we 
> have a potential invalid pointer?

This particular spot is always an instance because we just checked
it.  In any case the container_of buys us nothing and simply makes
the code more convoluted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
