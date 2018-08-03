From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium: nitrox: Replace GFP_ATOMIC with
 GFP_KERNEL in crypto_alloc_context()
Date: Fri, 3 Aug 2018 21:57:56 +0800
Message-ID: <20180803135756.e4fy35olg3nuhtur@gondor.apana.org.au>
References: <20180723081426.31780-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723081426.31780-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 23, 2018 at 04:14:26PM +0800, Jia-Ju Bai wrote:
> crypto_alloc_context() is only called by nitrox_skcipher_init(), which is
> never called in atomic context.
> 
> crypto_alloc_context() calls dma_pool_alloc() with GFP_ATOMIC,
> which is not necessary.
> GFP_ATOMIC can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
> I also manually check the kernel code before reporting it.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
