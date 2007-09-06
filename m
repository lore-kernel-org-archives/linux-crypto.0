From: rsnel@cube.dyndns.org
Subject: Re: [PATCH] an XTS blockcipher mode implementation without partial blocks
Date: Thu, 6 Sep 2007 16:57:26 +0200
Message-ID: <20070906145726.GA30421@cube.dyndns.org>
References: <11888559161619-git-send-email-rsnel@cube.dyndns.org> <20070905002906.GA6930@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, christoph.sievers@gmail.com,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2269 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbXIFO7D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2007 10:59:03 -0400
Content-Disposition: inline
In-Reply-To: <20070905002906.GA6930@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Sebastian,

Thanks for your review of the patch. I will address your points below.

On Wed, Sep 05, 2007 at 02:29:06AM +0200, Sebastian Siewior wrote:
> >diff --git a/crypto/xts.c b/crypto/xts.c
> [...]
> >+	/* key consists of keys of equal size concatenated, therefore
> >+	 * the length must be even */
> >+	if (keylen % 2) {
> >+		/* does anyone read this flag, it is not set if key setup
> >+		 * fails below (or is it?) */
> >+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> >+		return -EINVAL;
> >+	}
> 
> A algo user might read this.

Ok. I see that the error flags from the keysetup below are also copied
to the flags..., will update comment.
> 
> >+
> >+	/* we need two cipher instances: one to compute the inital 'tweak'
> >+	 * by encrypting the IV (usually the 'plain' iv) and the other
> >+	 * one to encrypt and decrypt the data */
> >+
> >+	/* tweak cipher, uses Key2 i.e. the second half of *key */
> >+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
> >+	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
> >+				       CRYPTO_TFM_REQ_MASK);
> >+	if ((err = crypto_cipher_setkey(child, key + keylen/2, keylen/2)))
> >+		return err;
> 
> why not
> 	err = crypto_cipher_setkey(child, key + keylen/2, keylen/2);
> 	if (err)
> 		return err;

Ok, I can see that it probably goes against the 'multiple statements on
a single line' rules in CodingStyle, will change.

> >+	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
> >+				     CRYPTO_TFM_RES_MASK);
> >+
> >+	child = ctx->child;
> >+
> >+	/* data cipher, uses Key1 i.e. the first half of *key */
> >+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
> >+	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
> >+				       CRYPTO_TFM_REQ_MASK);
> >+	if ((err = crypto_cipher_setkey(child, key, keylen/2)))
> ...

Copypaste from above...

> > [...]
> >+	err = blkcipher_walk_virt(d, w);
> >+	if (!(avail = w->nbytes))
> ...

Ok.

> >+		return err;
> >+
> >+	wsrc = w->src.virt.addr;
> >+	wdst = w->dst.virt.addr;
> >+
> >+	/* calculate first value of T */
> >+	iv = (be128 *)w->iv;
> >+	tw(crypto_cipher_tfm(ctx->tweak), (void*)&s.t, w->iv);
> >+
> >+	goto first;
> >+
> >+	for (;;) {
> >+		do {
> >+			gf128mul_x_ble(&s.t, &s.t);
> >+
> >+first:
> 
> why not
> 
> int first = 0;
> ...
> do {
>   if (!first) {
>     gf128mul_x_ble(&s.t, &s.t);
>     first = 1;
> }
> 
> The compiler should generate similar code.

I'd rather tell the compiler what I want than to introduce a new local
variable and a conditional branch in the hope that the compiler will
optimize it away, just to avoid a goto.

If you insist on getting rid of the goto, I could unroll the first
iteration of the loop by hand. (when is submitted lrw.c it had the first
iteration unrolled; Herbert replaced it with this goto)

> >+			xts_round(&s, wdst, wsrc);
> >+
> >+			wsrc += bs;
> >+			wdst += bs;
> >+		} while ((avail -= bs) >= bs);
> >+
> >+		err = blkcipher_walk_done(d, w, avail);
> >+		if (!(avail = w->nbytes))
> 
> 		avail = w->nbytes;
> 		if (!avail)
> 

Ok.

> > [...]
> >+	if (crypto_cipher_blocksize(cipher) != 16) {
> >+		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
> >+		return -EINVAL;
> >+	}
> >+
> >+	ctx->child = cipher;
> >+
> >+	cipher = crypto_spawn_cipher(spawn);
> >+	if (IS_ERR(cipher))
> >+		return PTR_ERR(cipher);
> 
> don't you want to free ctx->child on error?

Yes, of course. Fixed. 

> >+
> >+	/* this check isn't really needed */
> >+	if (crypto_cipher_blocksize(cipher) != 16) {
> >+		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
> >+		return -EINVAL;
> >+	}
> 
> and here both.

Fixed.

> Right now you should get the same algo but I don't thing that a check
> will hurt.

Agree.

> > [...]
> >+	if (alg->cra_alignmask < 7) inst->alg.cra_alignmask = 7;
> >+	else inst->alg.cra_alignmask = alg->cra_alignmask;
> >+	inst->alg.cra_type = &crypto_blkcipher_type;
> >+
> >+	if (!(alg->cra_blocksize % 4))
> >+		inst->alg.cra_alignmask |= 3;
> 
> please do
> 
> if (a)
>  do_on_a();
> else
>  do_on_b();

Ok.

> besides that, what are you trying to do? The if() makes sure that the
> alignmask is atleast 7 (0b111). And then, depending on the block size
> you might set the lower two bits (3 is 0b11) which are allready set.

Mmmm, I don't know why I did that. It is probably safe to assume that
alg->cra_alignmask = 2^n - 1 for some n, so I will remove the second if.

> >+	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
> >+	inst->alg.cra_blkcipher.min_keysize = 2*alg->cra_cipher.cia_min_keysize;
> >+	inst->alg.cra_blkcipher.max_keysize = 2*alg->cra_cipher.cia_max_keysize;
> 
> a space between the operator might not be a bad idea.

I wanted it to fit in 80 columns, will change.
> 
> > [...]
> >+MODULE_LICENSE("GPL");
> >+MODULE_DESCRIPTION("XTS block cipher mode");
> 
> The other things are looking fine to me. You might want to consider
> using ./scripts/checkpatch.pl on your patch the next time :)

I did just that, and it catched a (void*) should be (void *).

Christoph encountered a deadlock after a few hours and 16GB of data (on
an aes-xts-plain partition). Assuming there is an error in xts.c, is
there an obvious way of finding it?

Is my re-usage of *spawn (in init_tfm) the right way to get two
instances of the blockcipher?

A patch which fixes everything except the goto in crypt() will follow.

Greetings,

Rik.

-- 
Nothing is ever a total loss; it can always serve as a bad example.
