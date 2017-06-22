From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] gcm - fix setkey cache coherence issues
Date: Thu, 22 Jun 2017 10:40:51 +0800
Message-ID: <20170622024051.GA24529@gondor.apana.org.au>
References: <1498055361-12493-1-git-send-email-radu.solea@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        horia.geanta@nxp.com
To: Radu Solea <radu.solea@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34328 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdFVClR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 22:41:17 -0400
Content-Disposition: inline
In-Reply-To: <1498055361-12493-1-git-send-email-radu.solea@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 21, 2017 at 05:29:21PM +0300, Radu Solea wrote:
> Generic GCM is likely to end up using a hardware accelerator to do
> part of the job. Allocating hash, iv and result in a contiguous memory
> area increases the risk of dma mapping multiple ranges on the same
> cacheline. Also having dma and cpu written data on the same cacheline
> will cause coherence issues.
> 
> Signed-off-by: Radu Solea <radu.solea@nxp.com>
> ---
> Hi!
> 
> I've encountered cache coherence issues when using GCM with CAAM and this was
> one way of fixing them but it has its drawbacks. Another would be to allocate
> each element instead of all at once, but that only decreases the likelyhood of
> this happening. Does anyone know of a better way of fixing this?

I don't get it.  You're modifying the software version of GCM, and
the function is marked as static.  How can this patch have any effect
on CAAM?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
