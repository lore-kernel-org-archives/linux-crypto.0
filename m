From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: sha1-mb - remove HASH_FIRST flag
Date: Thu, 25 Jan 2018 14:03:40 -0800
Message-ID: <20180125220340.l2t2v7jjc5dwoe43@gmail.com>
References: <20180125031008.778-1-ebiggers3@gmail.com>
 <b5918f68-e4d3-e98c-00eb-d54c2d6e3329@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Megha Dey <megha.dey@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:41170 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbeAYWDn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jan 2018 17:03:43 -0500
Received: by mail-ot0-f193.google.com with SMTP id 44so8313771otk.8
        for <linux-crypto@vger.kernel.org>; Thu, 25 Jan 2018 14:03:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <b5918f68-e4d3-e98c-00eb-d54c2d6e3329@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 25, 2018 at 01:58:38PM -0800, Tim Chen wrote:
> On 01/24/2018 07:10 PM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The HASH_FIRST flag is never set.  Remove it.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  arch/x86/crypto/sha1-mb/sha1_mb.c     | 28 +++-------------------------
> >  arch/x86/crypto/sha1-mb/sha1_mb_ctx.h |  8 +++-----
> >  2 files changed, 6 insertions(+), 30 deletions(-)
> > 
> > diff --git a/arch/x86/crypto/sha1-mb/sha1_mb.c b/arch/x86/crypto/sha1-mb/sha1_mb.c
> > index acf9fdf01671..e17655ffde79 100644
> > --- a/arch/x86/crypto/sha1-mb/sha1_mb.c
> > +++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
> > @@ -106,13 +106,6 @@ static asmlinkage struct job_sha1* (*sha1_job_mgr_flush)
> >  static asmlinkage struct job_sha1* (*sha1_job_mgr_get_comp_job)
> >  						(struct sha1_mb_mgr *state);
> >  
> > -static inline void sha1_init_digest(uint32_t *digest)
> > -{
> > -	static const uint32_t initial_digest[SHA1_DIGEST_LENGTH] = {SHA1_H0,
> > -					SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 };
> > -	memcpy(digest, initial_digest, sizeof(initial_digest));
> > -}
> > -
> >  static inline uint32_t sha1_pad(uint8_t padblock[SHA1_BLOCK_SIZE * 2],
> >  			 uint64_t total_len)
> >  {
> > @@ -244,11 +237,8 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
> >  					  uint32_t len,
> >  					  int flags)
> >  {
> > -	if (flags & (~HASH_ENTIRE)) {
> > -		/*
> > -		 * User should not pass anything other than FIRST, UPDATE, or
> > -		 * LAST
> > -		 */
> > +	if (flags & ~(HASH_UPDATE | HASH_LAST)) {
> > +		/* User should not pass anything other than UPDATE or LAST */
> >  		ctx->error = HASH_CTX_ERROR_INVALID_FLAGS;
> >  		return ctx;
> >  	}
> > @@ -259,24 +249,12 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
> >  		return ctx;
> >  	}
> >  
> > -	if ((ctx->status & HASH_CTX_STS_COMPLETE) && !(flags & HASH_FIRST)) {
> > +	if (ctx->status & HASH_CTX_STS_COMPLETE) {
> >  		/* Cannot update a finished job. */
> >  		ctx->error = HASH_CTX_ERROR_ALREADY_COMPLETED;
> >  		return ctx;
> >  	}
> >  
> > -
> > -	if (flags & HASH_FIRST) {
> > -		/* Init digest */
> > -		sha1_init_digest(ctx->job.result_digest);
> > -
> > -		/* Reset byte counter */
> > -		ctx->total_length = 0;
> > -
> > -		/* Clear extra blocks */
> > -		ctx->partial_block_buffer_length = 0;
> > -	}
> > -
> 
> I suppose this will be okay as we are really doing the initialization in
> sha1_mb_init.  Megha is now maintaining this code.  Copying her
> so she can do some verification of this change.
> 

Please update the MAINTAINERS file so that people know who to Cc on patches.

Eric
