Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F4D80025;
	Fri, 31 May 2024 06:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717138381; cv=none; b=CBs4Lzerd0VHIFZxYVYXODXsVwsOoGjnpFo9wVnhNVPUkwNoWv8/TgzDuP/z8TUFJchq56vWI/4udrXgrOmluYvX5ZWOtDzhM8HsTgEuh+NrHY42p0+NcGS8AADE6ZEOg7P/zmIjQmcHI4R3JOT0GjMxwPNmQcg5diGPMsryWhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717138381; c=relaxed/simple;
	bh=jbRblOzBr7lRYlUaucJDVxoE9gSNIZAerMvYUvNHzWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwonhsXcrfV7ZVWHCHtz7Vn9cXLNQ+mRzwtHjf31AN5cyQ7MInZ51aoj+zNRspVM5Ux57ldeo6C3SKZouGpAOAdc4pzz+gdaD7eVuphGLiGUkZifFpW5ZGMMbWwCA0F2NUDBLzjQXb9xci+vUP/QFVoyTgbF3ZObnhgW0KYReEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcfbWXSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcfbWXSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F413C116B1;
	Fri, 31 May 2024 06:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717138380;
	bh=jbRblOzBr7lRYlUaucJDVxoE9gSNIZAerMvYUvNHzWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lcfbWXSeUnI69nk5WuQJvKTVVwjkcCqw0WfYfByVZCx7gwCkp6qSlHXzoM/Z9+vd2
	 3Q2tqmiOegwZi2I4aDhHqC5rwTduSVuQm+uLI9Ih+7Z2qPx3+dhdE6VHVJQgcMATLW
	 GELNwUMxOLcaf1QxG20ippUJcCYawkMyyQJCz9p5FwmZypZ+aDd55kXoCdNyS/8cm/
	 k1K0sGZ+Sss7BhAh0EX6RejOIPzsUAeGAhUpwc4ysuII+5yAh0el8WgxWG1jBKVLR6
	 Wihwk7fV0punCRJa/wJ+I/EQdZpTPlko42tXM53/ZKsNT0/hHStot1K7qAMhA2nyTR
	 Wc+MsBvs5Ymgw==
Date: Thu, 30 May 2024 23:52:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v3 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240531065258.GH6505@sol.localdomain>
References: <20240507002343.239552-7-ebiggers@kernel.org>
 <ZllXDOJKW2pHWBTz@gondor.apana.org.au>
 <20240531061348.GG6505@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531061348.GG6505@sol.localdomain>

On Thu, May 30, 2024 at 11:13:48PM -0700, Eric Biggers wrote:
> On Fri, May 31, 2024 at 12:50:20PM +0800, Herbert Xu wrote:
> > Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > +               if (multibuffer) {
> > > +                       if (ctx->pending_data) {
> > > +                               /* Hash and verify two data blocks. */
> > > +                               err = fsverity_hash_2_blocks(params,
> > > +                                                            inode,
> > > +                                                            ctx->pending_data,
> > > +                                                            data,
> > > +                                                            ctx->hash1,
> > > +                                                            ctx->hash2);
> > > +                               kunmap_local(data);
> > > +                               kunmap_local(ctx->pending_data);
> > > +                               ctx->pending_data = NULL;
> > > +                               if (err != 0 ||
> > > +                                   !verify_data_block(inode, vi, ctx->hash1,
> > > +                                                      ctx->pending_pos,
> > > +                                                      ctx->max_ra_pages) ||
> > > +                                   !verify_data_block(inode, vi, ctx->hash2,
> > > +                                                      pos, ctx->max_ra_pages))
> > > +                                       return false;
> > > +                       } else {
> > > +                               /* Wait and see if there's another block. */
> > > +                               ctx->pending_data = data;
> > > +                               ctx->pending_pos = pos;
> > > +                       }
> > > +               } else {
> > > +                       /* Hash and verify one data block. */
> > > +                       err = fsverity_hash_block(params, inode, data,
> > > +                                                 ctx->hash1);
> > > +                       kunmap_local(data);
> > > +                       if (err != 0 ||
> > > +                           !verify_data_block(inode, vi, ctx->hash1,
> > > +                                              pos, ctx->max_ra_pages))
> > > +                               return false;
> > > +               }
> > > +               pos += block_size;
> > 
> > I think this complexity is gross.  Look at how we did GSO in
> > networking.  There should be a unified code-path for aggregated
> > data and simple data, not an aggregated path versus a simple path.
> > 
> > I think ultimately it stems from the fact that this code went from
> > ahash to shash.  What were the issues back then? If it's just vmalloc
> > we should fix ahash to support that, rather than making users of the
> > Crypto API go through contortions like this.
> 
> It can't be asynchronous, period.  As I've explained, that would be far too
> complex, and it would also defeat the purpose because it would make performance
> worse.  Messages *must* be queued up and hashed in the caller's context.
> 
> What could make sense would be some helper functions and an associated struct
> for queueing up messages for a particular crypto_shash, up to its mb_max_msgs
> value, and then flushing them and retrieving the digests.  These would be
> provided by the crypto API.
> 
> I think this would address your concern, in that the users (fsverity and
> dm-verity) would have a unified code path for multiple vs. single blocks.
> 
> I didn't think it would be worthwhile to go there yet, given that fsverity and
> dm-verity just want 2x or 1x, and it ends up being simpler and more efficient to
> handle those cases directly.  But we could go with the more general queueing
> helper functions instead if you feel they should be included from the start.
> 

Looking at it again a bit more closely, both fsverity and dm-verity have
per-block information that they need to keep track of in the queue in addition
to the data buffers and hashes: the block number, and in dm-verity's case also a
bvec_iter pointing to that block.

So I think it really does make sense to have them both handle the queueing
themselves, and not have it split between them and some crypto API helper
functions (i.e. two queues that mirror each other).

It would be possible, though, to organize the code in dm-verity and fsverity to
represent the queue as an array and operate on it as such.  That would also
address your concern about the two code paths.  Again, things would end up being
a bit less efficient than my more optimized code that handles 1x and 2x (which
is all that's actually needed for now) specifically, but it would work, I think.

- Eric
