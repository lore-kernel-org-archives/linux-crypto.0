From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: CTR mode implementation
Date: Wed, 19 Sep 2007 21:06:15 +0800
Message-ID: <20070919130615.GA20468@gondor.apana.org.au>
References: <200708301614.l7UGEj44031217@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3692 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752079AbXISNGs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2007 09:06:48 -0400
Content-Disposition: inline
In-Reply-To: <200708301614.l7UGEj44031217@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 30, 2007 at 11:14:45AM -0500, Joy Latten wrote:
>
> The tcrypt vectors are from rfc 3686. They all pass except for the
> ones with 256-bit keys. 
> 
> Please let me know if all looks ok or not.

Thanks Joy, it looks pretty good.

Please add a signed-off-by line.

I need to do some surgery to IPsec before we can safely
include CTR.  As it is the IV generation in IPsec is insecure
for CTR which requires uniqueness of the IV.

So my plan is to let the algorithm have a say in how the
IV is produced.

> +static void ctr_inc(__be32 *counter)
> +{
> +	u_int32_t c; 

Please use u32 for consistency.

> +static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
> +			     unsigned int keylen)
> +{
> +	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(parent);
> +	struct crypto_cipher *child = ctx->child;
> +	int err;
> +
> +	/* salt is stored in last 4 bytes of key */
> +	if ((keylen % 8) != 4) {
> +		err = -EINVAL;
> +		return err; 
> +	}

This isn't right.  The underlying algorithm may have a key
length that's not a multiple of 4.  Just check that you do
have 4 bytes, take it and let the underlying setkey fail if
what remains isn't enough.

> +	do {
> +		/* create keystream */
> +		fn(crypto_cipher_tfm(tfm), dst, ctrblk); 
> +		xor_128(dst, src); 

You seem to be assuming that the cipher algorithm is AES.
That's not necessarily the case so either use xor_quad from
CBC or all of those xor_* functions as CBC does.

> +static int crypto_ctr_crypt_inplace(struct blkcipher_desc *desc,
> +				    struct blkcipher_walk *walk,
> +				    struct crypto_cipher *tfm, 
> +				    u8 *ctrblk)
> +{
> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
> +		   crypto_cipher_alg(tfm)->cia_encrypt;
> +	int bsize = crypto_cipher_blocksize(tfm);
> +	unsigned int nbytes = walk->nbytes;
> +	u8 *src = walk->src.virt.addr;
> +	u8 keystream[bsize];	/* bsize = 16 */ 

Since this is passed to the underlying algorithm you need to
check alignment.  The CBC in-place decryption code should work
here.

> +static int crypto_ctr_encrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst, struct scatterlist *src,
> +			      unsigned int nbytes)
> +{
> +	struct blkcipher_walk walk;
> +	struct crypto_blkcipher *tfm = desc->tfm;
> +	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
> +	struct crypto_cipher *child = ctx->child;
> +	u8 *counterblk = ctx->ctrblk;

We need to support simultaneous calls to the same tfm so you
need to allocate this somewhere else.  Just use the original
IV since it should be of the right length.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
