From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 5/5] crypto: AES CBC multi-buffer glue code
Date: Wed, 09 Dec 2015 09:23:14 -0800
Message-ID: <1449681794.22260.58.camel@schen9-desk2.jf.intel.com>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
	 <1449086565.22260.15.camel@schen9-desk2.jf.intel.com>
	 <20151209025242.GA24861@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbbLIRXR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 12:23:17 -0500
In-Reply-To: <20151209025242.GA24861@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2015-12-09 at 10:52 +0800, Herbert Xu wrote:
> On Wed, Dec 02, 2015 at 12:02:45PM -0800, Tim Chen wrote:
> >
> > +/*
> > + * CRYPTO_ALG_ASYNC flag is passed to indicate we have an ablk
> > + * scatter-gather walk.
> > + */
> > +
> > +static struct crypto_alg aes_cbc_mb_alg = {
> > +	.cra_name		= "__cbc-aes-aesni-mb",
> > +	.cra_driver_name	= "__driver-cbc-aes-aesni-mb",
> > +	.cra_priority		= 100,
> > +	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC
> > +					| CRYPTO_ALG_INTERNAL,
> > +	.cra_blocksize		= AES_BLOCK_SIZE,
> > +	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
> > +				  AESNI_ALIGN - 1,
> > +	.cra_alignmask		= 0,
> > +	.cra_type		= &crypto_blkcipher_type,
> > +	.cra_module		= THIS_MODULE,
> > +	.cra_list		= LIST_HEAD_INIT(aes_cbc_mb_alg.cra_list),
> > +	.cra_u = {
> > +		.blkcipher = {
> > +			.min_keysize	= AES_MIN_KEY_SIZE,
> > +			.max_keysize	= AES_MAX_KEY_SIZE,
> > +			.ivsize		= AES_BLOCK_SIZE,
> > +			.setkey		= aes_set_key,
> > +			.encrypt	= mb_aes_cbc_encrypt,
> > +			.decrypt	= mb_aes_cbc_decrypt
> > +		},
> > +	},
> > +};
> 
> So why do we still need this? Shouldn't a single ablkcipher cover
> all the cases?
> 
> Thanks,

This is an internal algorithm.  We are indeed casting the request
to the outer ablkcipher request when we do the async cipher walk.

See

static int mb_aes_cbc_decrypt(struct blkcipher_desc *desc,
                              struct scatterlist *dst, struct scatterlist *src,
                              unsigned int nbytes)
{
        struct crypto_aes_ctx *aesni_ctx;
        struct mcryptd_blkcipher_request_ctx *rctx =
                container_of(desc, struct mcryptd_blkcipher_request_ctx, desc);
        struct ablkcipher_request *req;
        bool is_mcryptd_req;
        unsigned long src_paddr;
        unsigned long dst_paddr;
        int err;

        /* note here whether it is mcryptd req */
        is_mcryptd_req = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
        req = cast_mcryptd_ctx_to_req(rctx);
        aesni_ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));

        ablkcipher_walk_init(&rctx->walk, dst, src, nbytes);
        err = ablkcipher_walk_phys(req, &rctx->walk);
        if (err || !rctx->walk.nbytes)
                goto done1;
        desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;

        kernel_fpu_begin();
        while ((nbytes = rctx->walk.nbytes)) {
                src_paddr = (page_to_phys(rctx->walk.src.page) + rctx->walk.src.offset);
                dst_paddr = (page_to_phys(rctx->walk.dst.page) + rctx->walk.dst.offset);
                aesni_cbc_dec(aesni_ctx, phys_to_virt(dst_paddr), phys_to_virt(src_paddr),
                              rctx->walk.nbytes & AES_BLOCK_MASK, rctx->walk.iv);
                nbytes &= AES_BLOCK_SIZE - 1;
                err = ablkcipher_walk_done(req, &rctx->walk, nbytes);
                if (err)
                        goto done2;
        }
done2:
        kernel_fpu_end();
done1:
        ablkcipher_walk_complete(&rctx->walk);


Thanks.

Tim
