From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium/nitrox - use dma_pool_zalloc()
Date: Fri, 21 Sep 2018 13:43:51 +0800
Message-ID: <20180921054351.spae5c5ah2z4b6zn@gondor.apana.org.au>
References: <20180910082452.19842-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgadam@cavium.com
To: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180910082452.19842-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 10, 2018 at 01:54:52PM +0530, Srikanth Jampala wrote:
> use dma_pool_zalloc() instead of dma_pool_alloc with __GFP_ZERO flag.
> crypto dma pool renamed to "nitrox-context".
> 
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
