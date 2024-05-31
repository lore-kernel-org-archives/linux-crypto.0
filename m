Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792033CA;
	Fri, 31 May 2024 06:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717136030; cv=none; b=KOLUjWSvZwtRHZa6MudK+REUo48PhJznZuNNyQpjs9T2BTooEHga3cgXnv4udivq50ysBLFBri10bi+v73+h8yUHJMZYKDs3mVAgQNbLQczrR+SL8fd4GSUkf74fJrNvzSs3gk3t5zo44W+lP5yctLw+v/3WqlRvSCwtm0sj6JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717136030; c=relaxed/simple;
	bh=RwsGqrGzZfc9T/Pyy9DhR5luwagmo4FWO+rh19v6NW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHbs4nXaF3cutW/syWhSnzEJ7xmMX+IKHBpY1sUE5gZKZ0W4W4aKZ7677CC5lgjGsK3kNECmENd0+od/1mn7iwTcNuO8FxaCAZ98+sci1iHL4HiXEaUNaTj0O1Wxab2s2I8dTSRHjk/i1f8+w0wAtChLI4MYK8W9hCzb7r9dHBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPzdf9Cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPzdf9Cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58E6C116B1;
	Fri, 31 May 2024 06:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717136030;
	bh=RwsGqrGzZfc9T/Pyy9DhR5luwagmo4FWO+rh19v6NW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nPzdf9Cu3FvihQInblNSELG24n3AUYO8ACQqjIF71UQEdW0RAKQXMUtjS8K8Shc7a
	 YAiTOZcRYARi8CC4DQCCjmcDoenzTNkHYLftgLTMQ2AeGte60hnswj4r3bQ/oQSre1
	 dIzVSG/Xe3+H2tEkNr+X1bQKk9kMJwuHnYepOaMySGo1mknj9DWP6koxt8/erQlXIU
	 AlnmPkKU7U15QlDoIE2B0kaH19jThQ3TZJBKNjmMZMoVJHBP37Rx1vO6mABI5xJXh0
	 auEsg/ljvHUxhtelB7bkSs6AGGs8Pi7TX8rue/+b27ltXRDmQty1pb2CJgAIVLnykb
	 5vMMJxUEyUGxg==
Date: Thu, 30 May 2024 23:13:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v3 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240531061348.GG6505@sol.localdomain>
References: <20240507002343.239552-7-ebiggers@kernel.org>
 <ZllXDOJKW2pHWBTz@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZllXDOJKW2pHWBTz@gondor.apana.org.au>

On Fri, May 31, 2024 at 12:50:20PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > +               if (multibuffer) {
> > +                       if (ctx->pending_data) {
> > +                               /* Hash and verify two data blocks. */
> > +                               err = fsverity_hash_2_blocks(params,
> > +                                                            inode,
> > +                                                            ctx->pending_data,
> > +                                                            data,
> > +                                                            ctx->hash1,
> > +                                                            ctx->hash2);
> > +                               kunmap_local(data);
> > +                               kunmap_local(ctx->pending_data);
> > +                               ctx->pending_data = NULL;
> > +                               if (err != 0 ||
> > +                                   !verify_data_block(inode, vi, ctx->hash1,
> > +                                                      ctx->pending_pos,
> > +                                                      ctx->max_ra_pages) ||
> > +                                   !verify_data_block(inode, vi, ctx->hash2,
> > +                                                      pos, ctx->max_ra_pages))
> > +                                       return false;
> > +                       } else {
> > +                               /* Wait and see if there's another block. */
> > +                               ctx->pending_data = data;
> > +                               ctx->pending_pos = pos;
> > +                       }
> > +               } else {
> > +                       /* Hash and verify one data block. */
> > +                       err = fsverity_hash_block(params, inode, data,
> > +                                                 ctx->hash1);
> > +                       kunmap_local(data);
> > +                       if (err != 0 ||
> > +                           !verify_data_block(inode, vi, ctx->hash1,
> > +                                              pos, ctx->max_ra_pages))
> > +                               return false;
> > +               }
> > +               pos += block_size;
> 
> I think this complexity is gross.  Look at how we did GSO in
> networking.  There should be a unified code-path for aggregated
> data and simple data, not an aggregated path versus a simple path.
> 
> I think ultimately it stems from the fact that this code went from
> ahash to shash.  What were the issues back then? If it's just vmalloc
> we should fix ahash to support that, rather than making users of the
> Crypto API go through contortions like this.

It can't be asynchronous, period.  As I've explained, that would be far too
complex, and it would also defeat the purpose because it would make performance
worse.  Messages *must* be queued up and hashed in the caller's context.

What could make sense would be some helper functions and an associated struct
for queueing up messages for a particular crypto_shash, up to its mb_max_msgs
value, and then flushing them and retrieving the digests.  These would be
provided by the crypto API.

I think this would address your concern, in that the users (fsverity and
dm-verity) would have a unified code path for multiple vs. single blocks.

I didn't think it would be worthwhile to go there yet, given that fsverity and
dm-verity just want 2x or 1x, and it ends up being simpler and more efficient to
handle those cases directly.  But we could go with the more general queueing
helper functions instead if you feel they should be included from the start.

- Eric
