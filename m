From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Wed, 22 Apr 2015 14:13:54 +0800
Message-ID: <20150422061354.GA8053@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <20150422055324.GA7872@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42638 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbbDVGOA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 02:14:00 -0400
Content-Disposition: inline
In-Reply-To: <20150422055324.GA7872@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 01:53:24PM +0800, Herbert Xu wrote:
> On Wed, Apr 22, 2015 at 06:36:59AM +0200, Stephan Mueller wrote:
> > 
> > The key wrapping is an authenticated encryption operation without
> > associated data. Therefore, setting of AAD is permissible, but that data
> > is not used by the cipher implementation.
> 
> In that case you should return an error if AAD is provided rather
> than silently discarding them since by definition AEAD must include
> the AAD in the integrity value.

In fact drop the AEAD altogether and just use ablkcipher.  The
integrity value is then simply the output IV.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
