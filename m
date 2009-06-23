From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Tue, 23 Jun 2009 08:21:39 +0200
Message-ID: <20090623062139.GA20366@secunet.com>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com> <20090619122113.GA18631@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:37781 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZFWGTG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 02:19:06 -0400
Content-Disposition: inline
In-Reply-To: <20090619122113.GA18631@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 08:21:13PM +0800, Herbert Xu wrote:
> On Mon, Jun 08, 2009 at 09:10:00AM +0200, Steffen Klassert wrote:
> >
> > +config CRYPTO_PCRYPT_CORE
> > +	bool
> > +	select CRYPTO_AEAD
> 
> BTW just noticed that this forces AEAD to be built-in even when
> pcrypt is a module.  We should fix this up.
> 

Yes, I'll change this with the next version.
