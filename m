From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 5/5] crypto: AES CBC multi-buffer glue code
Date: Tue, 24 Nov 2015 17:47:10 +0800
Message-ID: <20151124094710.GA32679@gondor.apana.org.au>
References: <cover.1447977406.git.tim.c.chen@linux.intel.com>
 <1447971340.4933.81.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447971340.4933.81.camel@schen9-desk2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 19, 2015 at 02:15:40PM -0800, Tim Chen wrote:
> 
> This patch introduces the multi-buffer job manager which is responsible
> for submitting scatter-gather buffers from several AES CBC jobs
> to the multi-buffer algorithm. The glue code interfaces with the
> underlying algorithm that handles 8 data streams of AES CBC encryption
> in parallel. AES key expansion and CBC decryption requests are performed
> in a manner similar to the existing AESNI Intel glue driver.

The rest of this series all look good.

> +static int mb_aes_cbc_decrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst, struct scatterlist *src,
> +			      unsigned int nbytes)
> +{
> +	struct crypto_aes_ctx *aesni_ctx;
> +	struct mcryptd_blkcipher_request_ctx *rctx =
> +		container_of(desc, struct mcryptd_blkcipher_request_ctx, desc);
> +	struct ablkcipher_request *req;
> +	struct blkcipher_walk walk;
> +	bool is_mcryptd_req;
> +	int err;
> +
> +	/* note here whether it is mcryptd req */
> +	is_mcryptd_req = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> +	req = cast_mcryptd_ctx_to_req(rctx);
> +	aesni_ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
> +
> +	blkcipher_walk_init(&walk, dst, src, nbytes);
> +	err = blkcipher_walk_virt(desc, &walk);
> +	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> +
> +	kernel_fpu_begin();
> +	while ((nbytes = walk.nbytes)) {
> +		aesni_cbc_dec(aesni_ctx, walk.dst.virt.addr, walk.src.virt.addr,
> +			      nbytes & AES_BLOCK_MASK, walk.iv);
> +		nbytes &= AES_BLOCK_SIZE - 1;
> +		err = blkcipher_walk_done(desc, &walk, nbytes);
> +	}
> +	kernel_fpu_end();
> +	if (!is_mcryptd_req) {
> +		/* synchronous request */
> +		return err;
> +	}
> +
> +	/* from mcryptd, we need to callback */
> +	if (irqs_disabled())
> +		rctx->complete(&req->base, err);

I really hate this bit though.  I know that you're doing the same
thing in sha-mb but relying on blkcipher_desc to contain extra
data given by the caller is not nice.

So the issue here seems to be that you're using the blkcipher
interface which has no completion mechanism.  What if you used
ablkcipher here instead, would you still need to play nasty games
such as
this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
