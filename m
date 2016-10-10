From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: cmac - fix alignment of 'consts'
Date: Mon, 10 Oct 2016 10:51:14 -0700
Message-ID: <1476121874.2856.30.camel@perches.com>
References: <1476119715-71397-2-git-send-email-ebiggers@google.com>
         <1476120595.2856.28.camel@perches.com> <20161010173756.GA115716@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:54555 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752316AbcJJRvS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2016 13:51:18 -0400
In-Reply-To: <20161010173756.GA115716@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2016-10-10 at 10:37 -0700, Eric Biggers wrote:
> On Mon, Oct 10, 2016 at 10:29:55AM -0700, Joe Perches wrote:
> > On Mon, 2016-10-10 at 10:15 -0700, Eric Biggers wrote:
> > > The per-transform 'consts' array is accessed as __be64 in
> > > crypto_cmac_digest_setkey() but was only guaranteed to be aligned to
> > > __alignof__(long).  Fix this by aligning it to __alignof__(__be64).
> > []
> > > diff --git a/crypto/cmac.c b/crypto/cmac.c
> > []
> > > @@ -57,7 +57,8 @@ static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
> > >  	unsigned long alignmask = crypto_shash_alignmask(parent);
> > >  	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
> > >  	unsigned int bs = crypto_shash_blocksize(parent);
> > > -	__be64 *consts = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
> > > +	__be64 *consts = PTR_ALIGN((void *)ctx->ctx,
> > > +				   (alignmask | (__alignof__(__be64) - 1)) + 1);
> > 
> > 
> > Using a bitwise or looks very odd there.  Perhaps:
> > 
> > 		min(alignmask + 1, __alignof__(__be64))
> > 
> 
> 
> Alignment has to be a power of 2.  From the code I've read, crypto drivers work
> with alignment a lot and use bitwise OR to mean "the more restrictive of these
> alignmasks".  So I believe the way it's written is the preferred style.
> 
> Eric

Hey Eric.

I don't see any PTR_ALIGN uses in crypto/ or drivers/crypto/ that
use a bitwise or, just mask + 1, but I believe the effect is the
same.  Anyway, your choice, but I think using min is clearer.

cheers, Joe
