From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: dh - fix memory leak
Date: Fri, 20 Jul 2018 13:53:09 +0800
Message-ID: <20180720055309.h5hjdhysko5grhf5@gondor.apana.org.au>
References: <20180710142252.GA19600@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180710142252.GA19600@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 10, 2018 at 09:22:52AM -0500, Gustavo A. R. Silva wrote:
> In case memory resources for *base* were allocated, release them
> before return.
> 
> Addresses-Coverity-ID: 1471702 ("Resource leak")
> Fixes: e3fe0ae12962 ("crypto: dh - add public key verification test")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
