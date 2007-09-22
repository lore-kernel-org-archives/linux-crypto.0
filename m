From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 1/1]: CTR mode implementation
Date: Fri, 21 Sep 2007 19:15:02 -0500
Message-ID: <1190420102.2477.53.camel@faith.austin.ibm.com>
References: <200708301614.l7UGEj44031217@faith.austin.ibm.com>
	 <20070919130615.GA20468@gondor.apana.org.au>
	 <1190242276.15699.996.camel@faith.austin.ibm.com>
	 <20070920081920.GA31211@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48424 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbXIVASq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Sep 2007 20:18:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8M0Ig5p005149
	for <linux-crypto@vger.kernel.org>; Fri, 21 Sep 2007 20:18:42 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8M0Iggo545382
	for <linux-crypto@vger.kernel.org>; Fri, 21 Sep 2007 20:18:42 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8M0IgUe004852
	for <linux-crypto@vger.kernel.org>; Fri, 21 Sep 2007 20:18:42 -0400
In-Reply-To: <20070920081920.GA31211@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2007-09-20 at 16:19 +0800, Herbert Xu wrote:
> On Wed, Sep 19, 2007 at 05:51:15PM -0500, Joy Latten wrote:
> >
> > predictability into my sessions? I could truncate the salt
> > in my counter block to 2 bytes and put 2 bytes of the IV for
> > blocksizes of 8... does that sound, ok?
> > Or am I totally misunderstanding it all?
> 
> I suggest that you make these parameters to your CTR template.
> So instead of requesting for "ctr(aes)", you could request for
> "ctr(aes, 4, 8)" where 4 is the length of the nonce in the
> counter block and 8 is the length of the IV.  The counter
> itself would then be calculated as block_size - 4 - 8.
> 
Ok, pretty much had this coded up when it dawned on me
maybe I should include the nonce as parameter too.
Whenever you use ctr, it is a given you need the nonce.
Couldn't the user of the api, separate the nonce from 
the key and pass it in the template? It would solve
my problem about sometimes the keylen is bigger than 
max-key-length for the algorithm with the additional bytes 
for nonce. So, I could pass in ctr(aes, nonce, noncesize, ivsize).
Let me know if this sounds ok or did I miss something important?

> > > > +static int crypto_ctr_encrypt(struct blkcipher_desc *desc,
> > > > +			      struct scatterlist *dst, struct scatterlist *src,
> > > > +			      unsigned int nbytes)
> > > > +{
> > > > +	struct blkcipher_walk walk;
> > > > +	struct crypto_blkcipher *tfm = desc->tfm;
> > > > +	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
> > > > +	struct crypto_cipher *child = ctx->child;
> > > > +	u8 *counterblk = ctx->ctrblk;
> > > 
> > > We need to support simultaneous calls to the same tfm so you
> > > need to allocate this somewhere else.  Just use the original
> > > IV since it should be of the right length.
> > 
> > Just to make sure I understand what you meant, you mean just use
> > ctx->ctrblk directly?
> 
> No I mean that you can't use anything from the ctx as the same
> ctx may be used by multiple calls at the same time.  You'd have
> to allocate it on the stack or via kmalloc.
> 
Ok, I get it. Thanks. :-)
I will try using the original IV as you first suggested.

Joy
