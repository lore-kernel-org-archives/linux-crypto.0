From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH/RFC] [Crypto] Check if ablkcipher->queue field is used.
Date: Fri, 22 Jun 2007 19:47:42 +0800
Message-ID: <20070622114741.GA28395@gondor.apana.org.au>
References: <20070608175551.GA8770@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3402 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752334AbXFVLro (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 07:47:44 -0400
Content-Disposition: inline
In-Reply-To: <20070608175551.GA8770@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 08, 2007 at 05:55:51PM +0000, Sebastian Siewior wrote:
> Evgeniy's hifn driver and probably mine don't use ablkcipher->queue at all. 
> The show method of ablkcipher will access this field without checking if it 
> is valid.
> 
> Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>

Actually Evgeniy really needs to have a queue to handle users such
as dm-crypt.

However, I agree with your patch since it is quite valid to not have
a queue, e.g., a load balancer wouldn't need one since it's only
passing the request on.

So patch applied.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
