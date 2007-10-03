From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Wed, 03 Oct 2007 18:17:08 -0500
Message-ID: <1191453429.2477.162.camel@faith.austin.ibm.com>
References: <200710020547.l925l9in011560@faith.austin.ibm.com>
	 <20071003102149.GA8203@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tgraf@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43694 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbXJCXVY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 19:21:24 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l93NLOfE004872
	for <linux-crypto@vger.kernel.org>; Wed, 3 Oct 2007 19:21:24 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l93NLOFo524086
	for <linux-crypto@vger.kernel.org>; Wed, 3 Oct 2007 19:21:24 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l93NLDKB032057
	for <linux-crypto@vger.kernel.org>; Wed, 3 Oct 2007 19:21:14 -0400
In-Reply-To: <20071003102149.GA8203@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2007-10-03 at 18:21 +0800, Herbert Xu wrote:
> We can't assume that the counter block is always 16 bytes
> since that depends on the underlying block size.  It's probably
> easiest if the caller computes the correct counter position and
> gives that to us.
> 
> BTW, it isn't that hard to support arbitrary counter sizes so
> we should fix that too and remove the counter size == 4 check.
> 
> Here's how you can do it:
> 
> static void ctr_inc_32(u8 *a, int size)
> {
> 	__be32 *b = (__be32 *)a;
> 
> 	*b = cpu_to_be32(be32_to_cpu(*b) + 1);
> }
> 
> static void __ctr_inc_byte(u8 *a, int size)
> {
> 	__be8 *b = (__be8 *)(a + size);
> 	u8 c;
> 
> 	do {
> 		c = be8_to_cpu(*--b) + 1;
> 		*b = cpu_to_be8(c);
> 		if (c)
> 			break;
> 	} while (--size);
> }
> 
> static void ctr_inc_quad(u8 *a, int size)
> {
> 	__be32 *b = (__be32 *)(a + size);
> 	u32 c;
> 
> 	for (; size >= 4; size -= 4) {
> 		c = be32_to_cpu(*--b) + 1;
> 		*b = cpu_to_be32(c);
> 		if (c)
> 			return;
> 	}
> 
> 	__ctr_inc_byte(a, size);
> }
> 
I really like this! Something else I should have thought of. :-)

> > +	do {
> > +		/* create keystream */
> > +		fn(crypto_cipher_tfm(tfm), dst, ctrblk); 
> > +		xor(dst, src, bsize); 
> > +		
> > +		/* increment counter in counterblock */
> > +		ctr_inc((__be32 *)ctrblk);
> > +	
> > +		src += bsize; 
> > +		dst += bsize; 
> > +	} while ((nbytes -= bsize) >= bsize);
> 
> As I mentioned above we need to deal with partial blocks at
> the end.  The easiest way is to change the loop termination
> to:
> 
> 		if (nbytes < bsize)
> 			break;
> 		nbytes -= bsize;
> 
> and change
> 
> 		xor(dst, src, bsize);
> 
> to
> 
> 		xor(dst, src, min(nbytes, bsize));

Ok. Also, I assumed the data we passed to the cipher
algorithms such as aes, des, etc... must be in blocks of blocksize.

Since the last block of data to CTR may be a partial block, I changed
the following in crypto_ctr_crypt_segment(),

		/* create keystream */
		fn(crypto_cipher_tfm(tfm), dst, ctrblk);
		xor_quad(dst, src, min(nbytes, bsize));
to

	        /* create keystream */
                fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
                xor_quad(keystream, src, min(nbytes, bsize));
		memcpy(dst, keystream, min(nbytes, bsize));

I also changed it such that we return 0 instead of nbytes.

This brings up another question... 
In the encrypt function, there's the loop,        

while (walk.nbytes) {
                if (walk.src.virt.addr == walk.dst.virt.addr)
                        nbytes = crypto_ctr_crypt_inplace(&walk, ctx,
                                                          counterblk,
                                                          countersize);
                else
                        nbytes = crypto_ctr_crypt_segment(&walk, ctx
                                                          counterblk,
                                                          countersize);

                err = blkcipher_walk_done(desc, &walk, nbytes);
        }

I assumed that if there is a partial block, it will occur at the
very end of all the data. However, looking at this loop, I wondered
if it was possible to get a partial block somewhere other than the end
while stepping through this loop?
I tried looking through blkcipher.c code, but figured I'd do better
just asking the question. :-) 


> > +static int crypto_ctr_encrypt(struct blkcipher_desc *desc,
> > +			      struct scatterlist *dst, struct scatterlist *src,
> > +			      unsigned int nbytes)
> > +{
> > +	struct blkcipher_walk walk;
> > +	struct crypto_blkcipher *tfm = desc->tfm;
> > +	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
> > +	struct crypto_cipher *child = ctx->child;
> > +	int bsize = crypto_cipher_blocksize(child);
> > +	struct ctr_instance_ctx *ictx = 
> > +		crypto_instance_ctx(crypto_tfm_alg_instance(&tfm->base));
> > +	u8 counterblk[bsize];
> 
> This needs to be aligned by the underlying mask and at least 4.
> 
Ok, sorry I missed that.
However, I don't understand what the check 
for 4 is for... my bsize should be at least 4?

Will get a new patch out to you shortly.

Thanks!!

Joy
