From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH v2 0/4] Parallel IPsec
Date: Sat, 25 Apr 2009 18:56:27 +0800
Message-ID: <20090425105627.GA6243@gondor.apana.org.au>
References: <20090424102451.GB12680@secunet.com> <20090425083849.GD26070@ioremap.net> <20090425092142.GA5830@gondor.apana.org.au> <20090425101019.GA28498@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49479 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752211AbZDYK4i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Apr 2009 06:56:38 -0400
Content-Disposition: inline
In-Reply-To: <20090425101019.GA28498@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 25, 2009 at 02:10:19PM +0400, Evgeniy Polyakov wrote:
>
> What's the deal PCI drivers have with CPUs data comes from/to?
> They do not touch cache, just run DMA transfer and complete the request.

It's the same as NICs.  To set things up and to reap the result
you need to synchronise.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
