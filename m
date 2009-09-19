From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
	wrapper
Date: Sat, 19 Sep 2009 16:20:37 -0700
Message-ID: <20090919232037.GB8097@gondor.apana.org.au>
References: <20090831091145.GB32705@secunet.com> <20090831091442.GD32705@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36345 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752956AbZISXUh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Sep 2009 19:20:37 -0400
Content-Disposition: inline
In-Reply-To: <20090831091442.GD32705@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 31, 2009 at 11:14:42AM +0200, Steffen Klassert wrote:
> This patch adds a parallel crypto template that takes a crypto
> algorithm and converts it to process the crypto transforms in
> parallel. For the moment only aead is supported.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

I'll pick this up once we get the first patch through.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
