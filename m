From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] Generic crypto counters
Date: Wed, 20 Jun 2012 17:24:14 +0800
Message-ID: <20120620092414.GA8928@gondor.apana.org.au>
References: <1339744473.8069.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:40833 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884Ab2FTJYV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jun 2012 05:24:21 -0400
Content-Disposition: inline
In-Reply-To: <1339744473.8069.28.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 15, 2012 at 09:14:33AM +0200, Jan Glauber wrote:
>
> Simple counters for the number of processed bytes per algorithm is
> something which I wanted to have for some time now. The reason is that
> its not obvious to tell if the hardware or software implementation
> was used. The only way to determine this currently is to look at the
> speed of the operation or add debug output, both methods kind of suck.

You can query /proc/crypto and look at the ref count to see which
algorithm is in use.

However, I'm certainly not against having usage counters since they
would be quite useful in their own right.  BTW, we now have a user-
space interface in crypto/crypto_user.c.  So when you add stuff to
/proc/crypto please consider adding it to crypto_user as well.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
