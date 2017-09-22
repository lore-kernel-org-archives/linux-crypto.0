From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: doc - clarify return values for async hash
 methods
Date: Fri, 22 Sep 2017 18:12:41 +0800
Message-ID: <20170922101241.GA16270@gondor.apana.org.au>
References: <CGME20170817102713eucas1p226423aedceb56acc9374f1a3cc28ee99@eucas1p2.samsung.com>
 <c00e8de8-fbf0-d92d-4b3c-959dd0ca3113@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38652 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdIVKNH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 06:13:07 -0400
Content-Disposition: inline
In-Reply-To: <c00e8de8-fbf0-d92d-4b3c-959dd0ca3113@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 17, 2017 at 12:27:12PM +0200, Kamil Konieczny wrote:
> >From af1b10e1e6aaf67f8dc45ed78de89b0469794a98 Mon Sep 17 00:00:00 2001
> From: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Date: Thu, 17 Aug 2017 12:11:36 +0200
> Subject: [PATCH] crypto: doc - clarify return values for async hash methods
> 
> * fix documentation of return values for crypto_ahash_init(),
>   crypto_ahash_finup(), crypto_ahash_final(),
>   crypto_ahash_digest() and crypto_ahash_update()
> 
> Also while at it:
> 
> * add notes for device driver developers in struct ahash_alg
>   description
> 
> * fix description of @final method in struct ahash_alg
> 
> * fix typo in crypto_ahash_finup() description
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
