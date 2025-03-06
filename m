Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7911A255E54
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741282184; cv=none; b=tuGHN0FteoT65tKSu3qvqiNCJ4T8ApL+k44l5r8v/FHhtgz4L6SkIEI9ehryxa/gqmzQldFGo1cov1nAB3qQkr4hbS2FKVi54hzT/xUAFVZ65Iopcd5zuQWqjf2Smo8pK0T17ui4BRml11gBsCxxCX6ZwyT0/U/BmFAIcbgh0TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741282184; c=relaxed/simple;
	bh=nN2skTp+gZVejnrC6IQtai81LnqzSzZWVpaGPuRDZb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzdNMR4es7/UXci9NmUIE2LGlTWUjxhn90aFi8WP7CDCq/dJP/N3eVydNPrm0kmqg7k/X3vwp1Cy3mAnkltcqWtSLOhv1uZYbks242/Fosayqzzj9UM00Qnld0fzIXs7K4nTbXFCiXbFwW2+JMcGRe8iKSfSV/YtwvvJO792hTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDdttYrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDdttYrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3A5C4CEE0;
	Thu,  6 Mar 2025 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741282183;
	bh=nN2skTp+gZVejnrC6IQtai81LnqzSzZWVpaGPuRDZb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vDdttYrbydBLCLVu+2qCrNcj09vneWIqMNAnLNC1EU5MMuSwVsBemxD4NI43Ms6OA
	 1dQ+nJXOIYTO4u/uaqO5cM2UNWE1cE9r/n4NkLhqS5rFbwuQ2iZrstFN5n0Dwf1d6n
	 CoRvvZtDKi3BM3lNwGT/diXWqIsQBvuL7owWEC3ToLGEXL4lD1AhhoJduu8SK97v3l
	 h8tDBuUky78iEgC9ihpPGdCLrXHYdBDznBmzKI4QIP1ovUGZ93Javx96co/bXlfLao
	 Ld6oSUoeh17WoyiBj960q0uSKIggaPKydlqjqcxTDddI8GsdLke84Mqoko0CAbnVBz
	 MLi8c1o0NqFHA==
Date: Thu, 6 Mar 2025 09:29:42 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: skcipher - Elinimate duplicate virt.addr field
Message-ID: <20250306172942.GF1796@sol.localdomain>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306031005.GB1592@sol.localdomain>
 <Z8kT90qXaTo15271@gondor.apana.org.au>
 <20250306033658.GD1592@sol.localdomain>
 <Z8kZL2WlWX-KhkqR@gondor.apana.org.au>
 <20250306035937.GA1153@sol.localdomain>
 <Z8k7ttZ7PwjBC-AS@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8k7ttZ7PwjBC-AS@gondor.apana.org.au>

On Thu, Mar 06, 2025 at 02:07:50PM +0800, Herbert Xu wrote:
> On Wed, Mar 05, 2025 at 07:59:37PM -0800, Eric Biggers wrote:
> >
> > I don't think it will be quite that simple, since the skcipher_walk code relies
> > on the different parts being split up so that it can do things like calculate
> > the length before it starts mapping anything.  If you can make it work, we can
> > do that.  But until that additional patch is ready I don't think it makes sense
> > to merge this one, as it leaves things half-baked with the redundant pointers.
> 
> Sure, fixing it might not be easy, partly because the new interface
> wasn't designed for its needs.
> 
> But getting rid of the duplicate field isn't hard, because we're
> already assuming that the user does not modify walk->XXX.virt.addr,
> at least not far enough to break the unmap (see the WALK_DIFF
> clause).  In fact, grepping through the arch code seems to show
> that nobody actually modifies them at all.  So we could even
> simplify the WALK_SLOW done path.
> 
> ---8<---
> Reuse the addr field from struct scatter_walk for skcipher_walk.
> In order to maintain backwards compatibility with existing users,
> retain the original virt.addr fields through unions.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/skcipher.c                  | 25 ++++++++++---------------
>  include/crypto/algapi.h            |  3 ++-
>  include/crypto/internal/skcipher.h | 20 +++++++++++++++-----
>  3 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index d321c8746950..f770307abb8e 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -43,14 +43,12 @@ static inline void skcipher_map_src(struct skcipher_walk *walk)
>  {
>  	/* XXX */
>  	walk->in.addr = scatterwalk_map(&walk->in);
> -	walk->src.virt.addr = walk->in.addr;
>  }
>  
>  static inline void skcipher_map_dst(struct skcipher_walk *walk)
>  {
>  	/* XXX */
>  	walk->out.addr = scatterwalk_map(&walk->out);
> -	walk->dst.virt.addr = walk->out.addr;
>  }
>  
>  static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
> @@ -100,8 +98,7 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
>  				    SKCIPHER_WALK_DIFF)))) {
>  		scatterwalk_advance(&walk->in, n);
>  	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
> -		scatterwalk_unmap(walk->src.virt.addr);
> -		scatterwalk_advance(&walk->in, n);
> +		scatterwalk_done_src(&walk->in, n);
>  	} else if (walk->flags & SKCIPHER_WALK_COPY) {
>  		scatterwalk_advance(&walk->in, n);
>  		skcipher_map_dst(walk);
> @@ -116,11 +113,8 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
>  			 */
>  			res = -EINVAL;
>  			total = 0;
> -		} else {
> -			u8 *buf = PTR_ALIGN(walk->buffer, walk->alignmask + 1);
> -
> -			memcpy_to_scatterwalk(&walk->out, buf, n);
> -		}
> +		} else
> +			memcpy_to_scatterwalk(&walk->out, walk->out.addr, n);
>  		goto dst_done;
>  	}
>  
> @@ -176,10 +170,11 @@ static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
>  			return skcipher_walk_done(walk, -ENOMEM);
>  		walk->buffer = buffer;
>  	}
> -	walk->dst.virt.addr = PTR_ALIGN(buffer, alignmask + 1);
> -	walk->src.virt.addr = walk->dst.virt.addr;
>  
> -	memcpy_from_scatterwalk(walk->src.virt.addr, &walk->in, bsize);
> +	buffer = PTR_ALIGN(buffer, alignmask + 1);
> +	memcpy_from_scatterwalk(buffer, &walk->in, bsize);
> +	walk->out.addr = buffer;
> +	walk->in.addr = walk->out.addr;
>  
>  	walk->nbytes = bsize;
>  	walk->flags |= SKCIPHER_WALK_SLOW;
> @@ -199,8 +194,8 @@ static int skcipher_next_copy(struct skcipher_walk *walk)
>  	 * processed (which might be less than walk->nbytes) is known.
>  	 */
>  
> -	walk->src.virt.addr = tmp;
> -	walk->dst.virt.addr = tmp;
> +	walk->in.addr = tmp;
> +	walk->out.addr = tmp;
>  	return 0;
>  }
>  
> @@ -214,7 +209,7 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
>  		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
>  
>  	skcipher_map_src(walk);
> -	walk->dst.virt.addr = walk->src.virt.addr;
> +	walk->out.addr = walk->in.addr;
>  
>  	if (diff) {
>  		walk->flags |= SKCIPHER_WALK_DIFF;
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index 41733a0b45dd..94147ea8c14d 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -120,9 +120,10 @@ struct crypto_queue {
>  };
>  
>  struct scatter_walk {
> +	/* Must be the first member, see struct skcipher_walk. */
> +	void *addr;
>  	struct scatterlist *sg;
>  	unsigned int offset;
> -	void *addr;
>  };
>  
>  struct crypto_attr_alg {
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index d6ae7a86fed2..357441b56c1e 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -57,14 +57,24 @@ struct crypto_lskcipher_spawn {
>  struct skcipher_walk {
>  	union {
>  		struct {
> -			void *addr;
> -		} virt;
> -	} src, dst;
> +			struct {
> +				void *const addr;
> +			} virt;
> +		} src;
> +		struct scatter_walk in;
> +	};
>  
> -	struct scatter_walk in;
>  	unsigned int nbytes;
>  
> -	struct scatter_walk out;
> +	union {
> +		struct {
> +			struct {
> +				void *const addr;
> +			} virt;
> +		} dst;
> +		struct scatter_walk out;
> +	};
> +

Those unions are ugly, but I guess this is good enough.  Please also delete the
/* XXX */ comments, fix the typo in the title, and resend this as a real patch.
Thanks!

- Eric
