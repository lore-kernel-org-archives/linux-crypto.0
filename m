From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: chcr - Fix error handling related to
 'chcr_alloc_shash'
Date: Fri, 21 Apr 2017 21:15:12 +0800
Message-ID: <20170421131512.GD14803@gondor.apana.org.au>
References: <20170413182515.29107-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, harsh@chelsio.com, hariprasad@chelsio.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42888 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039710AbdDUNPx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:15:53 -0400
Content-Disposition: inline
In-Reply-To: <20170413182515.29107-1-christophe.jaillet@wanadoo.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 13, 2017 at 08:25:15PM +0200, Christophe JAILLET wrote:
> Up to now, 'crypto_alloc_shash()' may return a valid pointer, an error
> pointer or NULL (in case of invalid parameter)
> Update it to always return an error pointer in case of error. It now
> returns ERR_PTR(-EINVAL) instead of NULL in case of invalid parameter.
> 
> This simplifies error handling.
> 
> Also fix a crash in 'chcr_authenc_setkey()' if 'chcr_alloc_shash()'
> returns an error pointer and the "goto out" path is taken.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
