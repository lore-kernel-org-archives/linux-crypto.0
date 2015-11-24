From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v3 5/5] crypto: AES CBC multi-buffer glue code
Date: Tue, 24 Nov 2015 10:30:06 -0800
Message-ID: <1448389806.4933.112.camel@schen9-desk2.jf.intel.com>
References: <cover.1447977406.git.tim.c.chen@linux.intel.com>
	 <1447971340.4933.81.camel@schen9-desk2.jf.intel.com>
	 <20151124094710.GA32679@gondor.apana.org.au>
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
Received: from mga02.intel.com ([134.134.136.20]:32034 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbbKXSaH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Nov 2015 13:30:07 -0500
In-Reply-To: <20151124094710.GA32679@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2015-11-24 at 17:47 +0800, Herbert Xu wrote:
> On Thu, Nov 19, 2015 at 02:15:40PM -0800, Tim Chen wrote:
> > 
> > This patch introduces the multi-buffer job manager which is responsible
> > for submitting scatter-gather buffers from several AES CBC jobs
> > to the multi-buffer algorithm. The glue code interfaces with the
> > underlying algorithm that handles 8 data streams of AES CBC encryption
> > in parallel. AES key expansion and CBC decryption requests are performed
> > in a manner similar to the existing AESNI Intel glue driver.
> 
> The rest of this series all look good.
> 
> > +static int mb_aes_cbc_decrypt(struct blkcipher_desc *desc,
> > +			      struct scatterlist *dst, struct scatterlist *src,
> > +			      unsigned int nbytes)
> > +{
> > +	struct crypto_aes_ctx *aesni_ctx;
> > +	struct mcryptd_blkcipher_request_ctx *rctx =
> > +		container_of(desc, struct mcryptd_blkcipher_request_ctx, desc);
> > +	struct ablkcipher_request *req;
> > +	struct blkcipher_walk walk;
> > +	bool is_mcryptd_req;
> > +	int err;
> > +
> > +	/* note here whether it is mcryptd req */
> > +	is_mcryptd_req = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> > +	req = cast_mcryptd_ctx_to_req(rctx);
> > +	aesni_ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
> > +
> > +	blkcipher_walk_init(&walk, dst, src, nbytes);
> > +	err = blkcipher_walk_virt(desc, &walk);
> > +	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > +
> > +	kernel_fpu_begin();
> > +	while ((nbytes = walk.nbytes)) {
> > +		aesni_cbc_dec(aesni_ctx, walk.dst.virt.addr, walk.src.virt.addr,
> > +			      nbytes & AES_BLOCK_MASK, walk.iv);
> > +		nbytes &= AES_BLOCK_SIZE - 1;
> > +		err = blkcipher_walk_done(desc, &walk, nbytes);
> > +	}
> > +	kernel_fpu_end();
> > +	if (!is_mcryptd_req) {
> > +		/* synchronous request */
> > +		return err;
> > +	}
> > +
> > +	/* from mcryptd, we need to callback */
> > +	if (irqs_disabled())
> > +		rctx->complete(&req->base, err);
> 
> I really hate this bit though.  I know that you're doing the same
> thing in sha-mb but relying on blkcipher_desc to contain extra
> data given by the caller is not nice.
> 
> So the issue here seems to be that you're using the blkcipher
> interface which has no completion mechanism.  What if you used
> ablkcipher here instead, would you still need to play nasty games
> such as
> this?

I have considered using ablkcipher walk always 
by invoking mb_aes_cbc_decrypt only through mcryptd, 
and allowing me to cast things back to an ablkcipher request
and always do ablkcipher walk here. 
But that will incur extra latency overhead
through mcryptd.

On the decrypt path, we don't need to use multi-buffer algorithm
as aes-cbc decrypt can be parallelized inherently on a single
request.  So most of the time the outer layer algorithm
cbc_mb_async_ablk_decrypt can bypass mcryptd and
invoke mb_aes_cbc_decrypt synchronously
to do aes_cbc_dec when fpu is available.
This avoids the overhead of going through mcryptd.  Hence
the use of blkcipher on the inner layer.  For the mcryptd
path, we will complete a decrypt request in one shot so
blkcipher usage should be fine.

Thanksgiving holidays in US coming up so my response may
be a bit slow for the rest of the week.

Thanks.

Tim
