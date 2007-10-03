From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Wed, 3 Oct 2007 18:21:49 +0800
Message-ID: <20071003102149.GA8203@gondor.apana.org.au>
References: <200710020547.l925l9in011560@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.sh
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4766 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372AbXJCKWH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 06:22:07 -0400
Content-Disposition: inline
In-Reply-To: <200710020547.l925l9in011560@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Joy:

On Tue, Oct 02, 2007 at 12:47:09AM -0500, Joy Latten wrote:
>
> So,  the correct way to say it is that my plaintext should be
> multiple of cipher's blocksize, not CTR's blocksize?

It won't be.  CTR is a stream cipher which means that it can
deal with any plain text without padding it to form a block.
So the last block may be shorter than the underlying block
size.  So if the last block is n bytes, then you use the first
n bytes of your keystream and discard the rest.

> I have made suggested changes in new patch below.
> This time, all the ctr testcases passed. :-)

Excellent! I think we're really close now :)

> +static void ctr_inc(__be32 *counter)
> +{
> +	u32 c; 
> +	
> +	c = be32_to_cpu(counter[3]);
> +	c++;
> +	counter[3] = cpu_to_be32(c);
> +}

We can't assume that the counter block is always 16 bytes
since that depends on the underlying block size.  It's probably
easiest if the caller computes the correct counter position and
gives that to us.

BTW, it isn't that hard to support arbitrary counter sizes so
we should fix that too and remove the counter size == 4 check.

Here's how you can do it:

static void ctr_inc_32(u8 *a, int size)
{
	__be32 *b = (__be32 *)a;

	*b = cpu_to_be32(be32_to_cpu(*b) + 1);
}

static void __ctr_inc_byte(u8 *a, int size)
{
	__be8 *b = (__be8 *)(a + size);
	u8 c;

	do {
		c = be8_to_cpu(*--b) + 1;
		*b = cpu_to_be8(c);
		if (c)
			break;
	} while (--size);
}

static void ctr_inc_quad(u8 *a, int size)
{
	__be32 *b = (__be32 *)(a + size);
	u32 c;

	for (; size >= 4; size -= 4) {
		c = be32_to_cpu(*--b) + 1;
		*b = cpu_to_be32(c);
		if (c)
			return;
	}

	__ctr_inc_byte(a, size);
}

Just select the ctr function where you select xor.

> +static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
> +			     unsigned int keylen)
> +{
> +	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(parent);
> +	struct crypto_cipher *child = ctx->child;
> +	struct ctr_instance_ctx *ictx = 
> +		crypto_instance_ctx(crypto_tfm_alg_instance(parent));
> +	
> +	unsigned int noncelen = ictx->noncesize;
> +	int err;
> +
> +	/* the nonce is stored in bytes at end of key */
> +	if (keylen < noncelen) {
> +		err = -EINVAL;
> +		return err; 
> +	}
> +
> +	ctx->nonce = (u8 *)(key + (keylen - noncelen));

This won't work as we can't hold a reference to the caller's
data.  You need to allocate space for it in the context and
copy it.

> +static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
> +				    struct crypto_cipher *tfm, u8 *ctrblk,
> +				    void (*xor)(u8 *, const u8 *, unsigned int))
> +{
> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
> +		   crypto_cipher_alg(tfm)->cia_encrypt;
> +	int bsize = crypto_cipher_blocksize(tfm);
> +	unsigned int nbytes = walk->nbytes;
> +	u8 *src = walk->src.virt.addr;
> +	u8 *dst = walk->dst.virt.addr;
> +
> +	do {
> +		/* create keystream */
> +		fn(crypto_cipher_tfm(tfm), dst, ctrblk); 
> +		xor(dst, src, bsize); 
> +		
> +		/* increment counter in counterblock */
> +		ctr_inc((__be32 *)ctrblk);
> +	
> +		src += bsize; 
> +		dst += bsize; 
> +	} while ((nbytes -= bsize) >= bsize);

As I mentioned above we need to deal with partial blocks at
the end.  The easiest way is to change the loop termination
to:

		if (nbytes < bsize)
			break;
		nbytes -= bsize;

and change

		xor(dst, src, bsize);

to

		xor(dst, src, min(nbytes, bsize));

Let's also get rid of the xor selection and just use this xor
function:

static void xor_quad(u8 *dst, const u8 *src, unsigned int bs)
{
	u32 *a = (u32 *)dst;
	u32 *b = (u32 *)src;

	for (; bs >= 4; bs -= 4)
		*a++ ^= *b++;

	xor_byte((u8 *)a, (u8 *)b, bs);
}

> +static int crypto_ctr_encrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst, struct scatterlist *src,
> +			      unsigned int nbytes)
> +{
> +	struct blkcipher_walk walk;
> +	struct crypto_blkcipher *tfm = desc->tfm;
> +	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
> +	struct crypto_cipher *child = ctx->child;
> +	int bsize = crypto_cipher_blocksize(child);
> +	struct ctr_instance_ctx *ictx = 
> +		crypto_instance_ctx(crypto_tfm_alg_instance(&tfm->base));
> +	u8 counterblk[bsize];

This needs to be aligned by the underlying mask and at least 4.

> +static int crypto_ctr_decrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst, struct scatterlist *src,
> +			      unsigned int nbytes)

This is identical to the encrypt function so we can delete one
of them.

> +	err = crypto_attr_u32(tb[2], &noncesize);
> +	if (err) 
> +		goto out_put_alg;
> +
> +	err = crypto_attr_u32(tb[3], &ivsize);
> +	if (err) 
> +		goto out_put_alg;
> +
> +	/* verify size of nonce + iv + counter */
> +	err = -EINVAL;
> +	if ((alg->cra_blocksize - noncesize - ivsize) != 4)
> +		goto out_put_alg;

We should also check that noncesize/ivsize are less than the
block size.

> +	inst->alg.cra_alignmask = alg->cra_alignmask;

This should just be 3.

> +	if (!(alg->cra_blocksize % 4))
> +		inst->alg.cra_alignmask |= 3;

This can go.

> +	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;

This should be ivsize.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
