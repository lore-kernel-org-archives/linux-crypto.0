From: Jamie Iles <jamie.iles@picochip.com>
Subject: Re: IPSec AH hardware offload
Date: Wed, 28 Jan 2009 08:36:19 +0000
Message-ID: <49801903.2000303@picochip.com>
References: <20090128033736.GA5888@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from jamieiles.v.servelocity.net ([85.8.132.214]:55939 "EHLO
	jamieiles.v.servelocity.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbZA1J2E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2009 04:28:04 -0500
In-Reply-To: <20090128033736.GA5888@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Once that's completed we can then convert IPsec (or rather, authenc)
> over to using ahash.
Does that include the hash for authentication header in 
net/ipv[46]/ah[46].c?

The driver implements authenc algorithms, so we'll already get 
asynchronous operation for ESP, but the crypto_alloc_hash() in ah[46].c 
explicitly requests a synchronous hash. Is this worth converting to use 
ahash?

Thanks,

Jamie
