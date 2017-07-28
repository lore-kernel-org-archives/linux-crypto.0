From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/rng: ensure that the RNG is ready before using
Date: Fri, 28 Jul 2017 21:53:10 +0800
Message-ID: <20170728135310.GF21401@gondor.apana.org.au>
References: <20170716172206.6541-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39928 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbdG1NxV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 09:53:21 -0400
Content-Disposition: inline
In-Reply-To: <20170716172206.6541-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 16, 2017 at 07:22:06PM +0200, Jason A. Donenfeld wrote:
> Otherwise, we might be seeding the RNG using bad randomness, which is
> dangerous. The one use of this function from within the kernel -- not
> from userspace -- is being removed (keys/big_key), so that call site
> isn't relevant in assessing this.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
