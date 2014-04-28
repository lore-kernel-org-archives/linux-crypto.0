From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto 1/2] crypto: caam - fix mem leak in ahash_setkey
Date: Mon, 28 Apr 2014 18:25:36 +0800
Message-ID: <20140428102536.GB17037@gondor.apana.org.au>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
 <201404230147.32552.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia Geanta <horia.geanta@freescale.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201404230147.32552.marex@denx.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 23, 2014 at 01:47:32AM +0200, Marek Vasut wrote:
> On Friday, April 18, 2014 at 12:01:41 PM, Horia Geanta wrote:
> > In case hash key is bigger than algorithm block size, it is hashed.
> > In this case, memory is allocated to keep this hash in hashed_key.
> > hashed_key has to be freed on the key_dma dma mapping error path.
> > 
> > Cc: <stable@vger.kernel.org> # 3.10+
> > Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> > ---
> >  drivers/crypto/caam/caamhash.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/crypto/caam/caamhash.c
> > b/drivers/crypto/caam/caamhash.c index 0378328f47a7..2d244e629ed2 100644
> > --- a/drivers/crypto/caam/caamhash.c
> > +++ b/drivers/crypto/caam/caamhash.c
> > @@ -545,7 +545,8 @@ static int ahash_setkey(struct crypto_ahash *ahash,
> >  				      DMA_TO_DEVICE);
> >  	if (dma_mapping_error(jrdev, ctx->key_dma)) {
> >  		dev_err(jrdev, "unable to map key i/o memory\n");
> > -		return -ENOMEM;
> > +		ret = -ENOMEM;
> > +		goto map_err;
> >  	}
> >  #ifdef DEBUG
> >  	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
> > @@ -559,6 +560,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
> >  				 DMA_TO_DEVICE);
> >  	}
> > 
> > +map_err:
> >  	kfree(hashed_key);
> 
> Reviewed-by: Marek Vasut <marex@denx.de>

Patch applied to cryptodev.  I'm not pushing this to stable
because it doesn't satisfy the conditions for it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
