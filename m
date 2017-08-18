From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: engine - find request type with cra_type
Date: Fri, 18 Aug 2017 16:28:37 +0800
Message-ID: <20170818082836.GA29641@gondor.apana.org.au>
References: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
 <20170814131725.9402-3-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:49980 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdHRI2s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2017 04:28:48 -0400
Content-Disposition: inline
In-Reply-To: <20170814131725.9402-3-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 14, 2017 at 03:17:24PM +0200, Corentin Labbe wrote:
> The current method for finding request type is based on crypto_tfm_alg_type.
> 
> But in case of skcipher, it is the same than ablkcipher.
> Using cra_type for this work permits to make the distinction between the two.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

I think you misunderstood my suggestion.  I'm not saying that
you should use cra_type to distinguish all crypto types, it should
only be used to distinguish ablkcipher from skcipher.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
