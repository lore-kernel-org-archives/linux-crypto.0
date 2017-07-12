From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chcr: Avoid algo allocation in softirq.
Date: Wed, 12 Jul 2017 18:52:10 +0800
Message-ID: <20170712105210.GD22109@gondor.apana.org.au>
References: <cover.1498225095.git.harsh@chelsio.com>
 <ec9da7c14a5a5a21da0eb1cef7882cff1ca0cf03.1498225095.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45608 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756453AbdGLKwg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 06:52:36 -0400
Content-Disposition: inline
In-Reply-To: <ec9da7c14a5a5a21da0eb1cef7882cff1ca0cf03.1498225095.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 07:45:11PM +0530, Harsh Jain wrote:
> Thsi patch fixes calling "crypto_alloc_cipher" call in bottom halves.
> Pre allocate aes cipher required to update Tweak value for XTS.
> 
> Signed-off-by: Harsh Jain <harsh@chelsio.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
