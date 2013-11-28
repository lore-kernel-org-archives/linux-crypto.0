From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix potential NULL pointer dereference in
 skcipher_alloc_sgl()
Date: Thu, 28 Nov 2013 21:52:18 +0800
Message-ID: <20131128135218.GA31989@gondor.apana.org.au>
References: <5285877D.7020004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55770 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3K1NwW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 08:52:22 -0500
Content-Disposition: inline
In-Reply-To: <5285877D.7020004@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 15, 2013 at 10:31:25AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> In skcipher_alloc_sgl(), there is a potential null pointer dereference
> issue to retrieve the last item from ctx->tsgl list if the list is empty.
> 
> This patch fix it by checking if the list is empty or not at first.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Were you actually able to make this crash?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
