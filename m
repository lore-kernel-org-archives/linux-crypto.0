From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] crypto: cmac - fix alignment of 'consts'
Date: Mon, 10 Oct 2016 10:37:56 -0700
Message-ID: <20161010173756.GA115716@google.com>
References: <1476119715-71397-2-git-send-email-ebiggers@google.com>
 <1476120595.2856.28.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33172 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbcJJRiE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2016 13:38:04 -0400
Received: by mail-pa0-f48.google.com with SMTP id vu5so20643233pab.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2016 10:38:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1476120595.2856.28.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 10, 2016 at 10:29:55AM -0700, Joe Perches wrote:
> On Mon, 2016-10-10 at 10:15 -0700, Eric Biggers wrote:
> > The per-transform 'consts' array is accessed as __be64 in
> > crypto_cmac_digest_setkey() but was only guaranteed to be aligned to
> > __alignof__(long).  Fix this by aligning it to __alignof__(__be64).
> []
> > diff --git a/crypto/cmac.c b/crypto/cmac.c
> []
> > @@ -57,7 +57,8 @@ static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
> >  	unsigned long alignmask = crypto_shash_alignmask(parent);
> >  	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
> >  	unsigned int bs = crypto_shash_blocksize(parent);
> > -	__be64 *consts = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
> > +	__be64 *consts = PTR_ALIGN((void *)ctx->ctx,
> > +				   (alignmask | (__alignof__(__be64) - 1)) + 1);
> 
> Using a bitwise or looks very odd there.  Perhaps:
> 
> 		min(alignmask + 1, __alignof__(__be64))
> 

Alignment has to be a power of 2.  From the code I've read, crypto drivers work
with alignment a lot and use bitwise OR to mean "the more restrictive of these
alignmasks".  So I believe the way it's written is the preferred style.

Eric
