From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2] crypto: authenc - convert to ahash
Date: Thu, 23 Jul 2009 12:23:14 +0200
Message-ID: <20090723102314.GN20288@secunet.com>
References: <20090721090217.GF20288@secunet.com> <20090721122509.GG20288@secunet.com> <20090721130725.GA19550@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:52126 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZGWKUk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jul 2009 06:20:40 -0400
Content-Disposition: inline
In-Reply-To: <20090721130725.GA19550@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 21, 2009 at 09:07:25PM +0800, Herbert Xu wrote:
> On Tue, Jul 21, 2009 at 02:25:09PM +0200, Steffen Klassert wrote:
> > I just noticed that your shash version of hmac keeps the paded keys
> > on the transform. I assumed the hashing to be reentrant, so I
> > removed the locks arround the hash functions here.
> 
> The padded keys are in the transform because they never change
> unless you call setkey.  The assumption has always been that
> you should use one tfm per key.
> 

I found the problem. It's the digest state that is saved on the
transform right behind the opad in hmac_finup() and hmac_final().
The digest state is of course not constant and must be saved on the
request. That's why I needed the locks in authenc to get pcrypt to
work. I have a patch which moves the digest state to the request,
based on the cryptodev-2.6 tree.
However, as soon as your recent import/export patches are in the
cryptodev-2.6 tree we could probaply change hmac to do prehashing of the
keys what would fix the problem too.
