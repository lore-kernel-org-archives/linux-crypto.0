From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 1/9] crypto: introduce decompression API that can be
 called via sharable tfm object
Date: Fri, 25 Sep 2015 14:29:39 +0900
Message-ID: <20150925052939.GC7158@js1304-P5Q-DELUXE>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921053859.GB5313@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150921053859.GB5313@swordfish>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 21, 2015 at 02:38:59PM +0900, Sergey Senozhatsky wrote:
> On (09/18/15 14:19), Joonsoo Kim wrote:
> [..]
> > @@ -61,7 +61,8 @@ static struct crypto_alg alg = {
> >  	.cra_module		= THIS_MODULE,
> >  	.cra_u			= { .compress = {
> >  	.coa_compress		= crypto842_compress,
> > -	.coa_decompress		= crypto842_decompress } }
> > +	.coa_decompress		= crypto842_decompress,
> > +	.coa_decompress_noctx	= NULL } }
> >  };
> >  
> >  static int __init crypto842_mod_init(void)
> > diff --git a/crypto/compress.c b/crypto/compress.c
> > index c33f076..abb36a8 100644
> > --- a/crypto/compress.c
> > +++ b/crypto/compress.c
> > @@ -33,12 +33,21 @@ static int crypto_decompress(struct crypto_tfm *tfm,
> >  	                                                   dlen);
> >  }
> >  
> > +static int crypto_decompress_noctx(struct crypto_tfm *tfm,
> > +				const u8 *src, unsigned int slen,
> > +				u8 *dst, unsigned int *dlen)
> > +{
> > +	return tfm->__crt_alg->cra_compress.coa_decompress_noctx(src, slen,
> > +								dst, dlen);
> > +}
> 
> 
> hm... well... sorry, if irrelevant.
> if the algorithm can have a _noctx() decompression function, does it
> automatically guarantee that this algorithm never dereferences a passed
> `struct crypto_tfm *tfm' pointer in its decompress function? in other words,
> can we simply pass that `shared tfm pointer' to the existing decompress
> function instead of defining new symbols, new callbacks, etc.?
> 
> 	cot_decompress_noctx()  ==  cot_decompress(shared_ftm) ?
> 
> just a thought.

Will think it if I implement next version in this way. Due to Herbert
comment, interface will be changed so much in next version.

> 
> [..]
> > +struct crypto_comp *crypto_alloc_comp_noctx(const char *alg_name,
> > +					u32 type, u32 mask)
> > +{
> > +	struct crypto_comp *comp;
> > +	struct crypto_tfm *tfm;
> > +	struct compress_tfm *ops;
> > +
> > +	comp = crypto_alloc_comp(alg_name, type, mask);
> > +	if (IS_ERR(comp))
> > +		return comp;
> > +
> > +	tfm = crypto_comp_tfm(comp);
> > +	if (!tfm->__crt_alg->cra_compress.coa_decompress_noctx) {
> > +		crypto_free_comp(comp);
> > +		return ERR_PTR(-EINVAL);
> 
> 	-ENOMEM?

No, it's failure isn't related to NOMEM. Just not support it.

Thanks.
