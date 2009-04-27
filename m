From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH v2 1/4] padata: generic interface for parallel
	processing
Date: Mon, 27 Apr 2009 16:56:58 +0800
Message-ID: <20090427085658.GC21761@gondor.apana.org.au>
References: <20090424102451.GB12680@secunet.com> <20090424102609.GC12680@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56883 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753817AbZD0I5C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2009 04:57:02 -0400
Content-Disposition: inline
In-Reply-To: <20090424102609.GC12680@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 24, 2009 at 12:26:09PM +0200, Steffen Klassert wrote:
> This patch introduces an interface to process data objects
> in parallel. On request it is possible to serialize again.
> The parallelized objects return after serialization in the
> same order as they were before the parallelization.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

This part is ready to go in as far as I'm concerned.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
