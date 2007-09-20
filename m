From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: CTR mode implementation
Date: Thu, 20 Sep 2007 16:19:20 +0800
Message-ID: <20070920081920.GA31211@gondor.apana.org.au>
References: <200708301614.l7UGEj44031217@faith.austin.ibm.com> <20070919130615.GA20468@gondor.apana.org.au> <1190242276.15699.996.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1030 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760219AbXITIUF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Sep 2007 04:20:05 -0400
Content-Disposition: inline
In-Reply-To: <1190242276.15699.996.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 19, 2007 at 05:51:15PM -0500, Joy Latten wrote:
>
> predictability into my sessions? I could truncate the salt
> in my counter block to 2 bytes and put 2 bytes of the IV for
> blocksizes of 8... does that sound, ok?
> Or am I totally misunderstanding it all?

I suggest that you make these parameters to your CTR template.
So instead of requesting for "ctr(aes)", you could request for
"ctr(aes, 4, 8)" where 4 is the length of the nonce in the
counter block and 8 is the length of the IV.  The counter
itself would then be calculated as block_size - 4 - 8.

> > > +static int crypto_ctr_encrypt(struct blkcipher_desc *desc,
> > > +			      struct scatterlist *dst, struct scatterlist *src,
> > > +			      unsigned int nbytes)
> > > +{
> > > +	struct blkcipher_walk walk;
> > > +	struct crypto_blkcipher *tfm = desc->tfm;
> > > +	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
> > > +	struct crypto_cipher *child = ctx->child;
> > > +	u8 *counterblk = ctx->ctrblk;
> > 
> > We need to support simultaneous calls to the same tfm so you
> > need to allocate this somewhere else.  Just use the original
> > IV since it should be of the right length.
> 
> Just to make sure I understand what you meant, you mean just use
> ctx->ctrblk directly?

No I mean that you can't use anything from the ctx as the same
ctx may be used by multiple calls at the same time.  You'd have
to allocate it on the stack or via kmalloc.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
