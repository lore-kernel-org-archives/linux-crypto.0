From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 1/1]: CTR mode implementation
Date: Wed, 19 Sep 2007 17:51:15 -0500
Message-ID: <1190242276.15699.996.camel@faith.austin.ibm.com>
References: <200708301614.l7UGEj44031217@faith.austin.ibm.com>
	 <20070919130615.GA20468@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:35552 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbXISWzF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2007 18:55:05 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l8JLl8PJ017107
	for <linux-crypto@vger.kernel.org>; Wed, 19 Sep 2007 17:47:08 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8JMt4s1398722
	for <linux-crypto@vger.kernel.org>; Wed, 19 Sep 2007 16:55:04 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8JMt3bA003876
	for <linux-crypto@vger.kernel.org>; Wed, 19 Sep 2007 16:55:04 -0600
In-Reply-To: <20070919130615.GA20468@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2007-09-19 at 21:06 +0800, Herbert Xu wrote:
> > +	do {
> > +		/* create keystream */
> > +		fn(crypto_cipher_tfm(tfm), dst, ctrblk); 
> > +		xor_128(dst, src); 
> 
> You seem to be assuming that the cipher algorithm is AES.
> That's not necessarily the case so either use xor_quad from
> CBC or all of those xor_* functions as CBC does.
> 
Yes, I was using rfc 3686 that only considered AES. My mistake.

I think I see another problem. My control block is
128 bits and it is the input into the cipher algorithm. 
For algorithms with a blocksize other than 128 bits, this could
be a problem. I think in order to preserve purpose of controlblock
and not to produce same keystream, the size of my control block 
ought to be the blocksize of the cipher algorithm, right?

If so, I could fix this by changing the control block declaration
to be ctrblk[blksize] instead of ctrblk[16].
Currently, the control block consists of 4 bytes for salt, 
4 bytes for counter and 8 bytes for IV. I could let the IV 
be the variable here, requiring that cipher algos have a 
blocksize of 8 or greater. But, wouldn't that be a problem
for those ciphers with a blocksize of 8... since the salt 
value doesn't change until a rekey (thinking of IPsec)
and the counter portion would always start over with "1" for
each session.... I mean, wouldn't I have introduced some
predictability into my sessions? I could truncate the salt
in my counter block to 2 bytes and put 2 bytes of the IV for
blocksizes of 8... does that sound, ok?
Or am I totally misunderstanding it all?

> > +static int crypto_ctr_encrypt(struct blkcipher_desc *desc,
> > +			      struct scatterlist *dst, struct scatterlist *src,
> > +			      unsigned int nbytes)
> > +{
> > +	struct blkcipher_walk walk;
> > +	struct crypto_blkcipher *tfm = desc->tfm;
> > +	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
> > +	struct crypto_cipher *child = ctx->child;
> > +	u8 *counterblk = ctx->ctrblk;
> 
> We need to support simultaneous calls to the same tfm so you
> need to allocate this somewhere else.  Just use the original
> IV since it should be of the right length.

Just to make sure I understand what you meant, you mean just use
ctx->ctrblk directly?

Thanks! Will fix everything you mentioned and submit new patch shortly.

Joy
