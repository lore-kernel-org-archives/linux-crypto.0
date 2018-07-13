From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chtls - use 64-bit arithmetic instead of 32-bit
Date: Fri, 13 Jul 2018 18:33:31 +0800
Message-ID: <20180713103331.5574mnd4ecjson7n@gondor.apana.org.au>
References: <20180704163720.GA16912@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180704163720.GA16912@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 04, 2018 at 11:37:20AM -0500, Gustavo A. R. Silva wrote:
> Cast *val* to u64 in order to give the compiler complete
> information about the proper arithmetic to use.
> 
> Notice that such variable is used in a context that expects an
> expression of type u64 (64 bits, unsigned) and the following
> expression is currently being evaluated using 32-bit arithmetic:
> 
> val << bit_pos
> 
> Addresses-Coverity-ID: 1467425 ("Unintentional integer overflow")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
