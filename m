From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rmd256 - use swap macro in rmd256_transform
Date: Sat, 28 Jul 2018 00:05:39 +0800
Message-ID: <20180727160538.dp77igw2wi2ktaab@gondor.apana.org.au>
References: <20180718171200.GA20997@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718171200.GA20997@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 18, 2018 at 12:12:00PM -0500, Gustavo A. R. Silva wrote:
> Make use of the swap macro and remove unnecessary variable *tmp*.
> This makes the code easier to read and maintain.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
