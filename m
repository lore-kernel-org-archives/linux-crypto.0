From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: artpec6 - remove select on non-existing
 CRYPTO_SHA384
Date: Fri, 26 Jan 2018 23:45:38 +0800
Message-ID: <20180126154537.GG4002@gondor.apana.org.au>
References: <20180117185056.11562-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180117185056.11562-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 17, 2018 at 07:50:56PM +0100, Corentin Labbe wrote:
> Since CRYPTO_SHA384 does not exists, Kconfig should not select it.
> Anyway, all SHA384 stuff is in CRYPTO_SHA512 which is already selected.
> 
> Fixes: a21eb94fc4d3i ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
