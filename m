From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - Add support for hashing export and import
 functions
Date: Sun, 18 Oct 2015 08:35:42 +0800
Message-ID: <20151018003542.GA27786@gondor.apana.org.au>
References: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
 <20151017173823.GP32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Victoria Milhoan <vicki.milhoan@freescale.com>,
	linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	fabio.estevam@freescale.com, boris.brezillon@free-electrons.com,
	arno@natisbad.org, thomas.petazzoni@free-electrons.com,
	jason@lakedaemon.net, davem@davemloft.net
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53217 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbbJRAgM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 20:36:12 -0400
Content-Disposition: inline
In-Reply-To: <20151017173823.GP32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 17, 2015 at 06:38:23PM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 16, 2015 at 04:19:33PM -0700, Victoria Milhoan wrote:
> > @@ -1569,6 +1601,10 @@ static int ahash_import(struct ahash_request *req, const void *in)
> >  	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
> >  	struct caam_hash_state *state = ahash_request_ctx(req);
> >  
> > +	/* Allocate new data buffers to use for this request */
> > +	state->buf_0 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> > +	state->buf_1 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> > +
> 
> I'm really not sure you can do this at all.  What if the previous
> digest calculation prior to the accept() cloning the state was for
> a non-hash-block aligned size of data.  The above will lose that
> state, and produce an incorrect hash result.  Herbert, can you
> confirm please?

Well the patch you're responding to is simply bogus.  It is making
an allocation and then immediately overwriting that pointer value
with memcpy from the imported state.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
