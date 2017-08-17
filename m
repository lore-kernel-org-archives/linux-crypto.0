From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sahara - Fix dma unmap direction
Date: Thu, 17 Aug 2017 17:00:00 +0800
Message-ID: <20170817090000.GA25646@gondor.apana.org.au>
References: <20170803133412.14322-1-mlauridsen171@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mogens Lauridsen <mlauridsen171@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:47596 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdHQJAK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 05:00:10 -0400
Content-Disposition: inline
In-Reply-To: <20170803133412.14322-1-mlauridsen171@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 03, 2017 at 03:34:12PM +0200, Mogens Lauridsen wrote:
> The direction used in dma_unmap_sg in aes calc is wrong.
> This result in the cache not being invalidated correct when aes
> calculation is done and result has been dma'ed to memory.
> This is seen as sporadic wrong result from aes calc.
> 
> Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
