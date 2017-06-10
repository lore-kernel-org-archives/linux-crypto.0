From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rng - move __crypto_rng_cast to the rng header
Date: Sat, 10 Jun 2017 12:14:40 +0800
Message-ID: <20170610041440.GA14719@gondor.apana.org.au>
References: <20170509083222.1100-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nhorman@tuxdriver.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170509083222.1100-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 09, 2017 at 10:32:22AM +0200, Corentin Labbe wrote:
> This patch move __crypto_rng_cast() to the right header like other
> __algo_cast functions.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

As there is another patch which will remove thie function altogether,
I think I'll just leave it in place.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
