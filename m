From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH v2 2/4] pcrypt: Add pcrypt crypto parallelization
	engine
Date: Tue, 28 Apr 2009 08:23:16 +0200
Message-ID: <20090428062316.GA20366@secunet.com>
References: <20090424102451.GB12680@secunet.com> <20090424102720.GD12680@secunet.com> <20090427085620.GB21761@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:36697 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZD1GVL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 02:21:11 -0400
Content-Disposition: inline
In-Reply-To: <20090427085620.GB21761@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 27, 2009 at 04:56:20PM +0800, Herbert Xu wrote:
> On Fri, Apr 24, 2009 at 12:27:20PM +0200, Steffen Klassert wrote:
> >
> > +	alg = crypto_get_attr_alg(tb, algt->type,
> > +				  (algt->mask & CRYPTO_ALG_TYPE_MASK)
> > +				  | CRYPTO_ALG_PCRYPT);
> 
> Do you really need to exclude pcrypt algorithms here? If the user
> wants to added another layer of pcrypt then we should obey.
> 

I don't need to exclude it. I just wanted to avoid another layer
of pcrypt here because it does not make too much sense to parallelize
a second time. If the aead algorithm is already parallel it would just
add overhead if we parallelize an underlying algorithm too.
Anyway, I would not mind to allow more than one pcrypt layer.

Steffen
