Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBF92DF144
	for <linux-crypto@vger.kernel.org>; Wed, 15 Apr 2026 12:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776257789; cv=none; b=kmGAZ1RdKTdsHkto5HDSDHk0Uz47O2nGDoXv3tfbik+yIr/BRflY60mm6zUfIoLesV3dWhsBIwmNn9wCtPAEd4aIKNjvbhFwfy2rWlAG+8Z3oQz58xZ97GH60EhO4gkwi6by1mciONVPpCRLlwezYSiYOqLC2E0+XfRWn76KOds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776257789; c=relaxed/simple;
	bh=5AuRlB+9yMZG4ipWdVB55t0J4/N/uSr/+Jy8FUJQ4Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFPKV8IfOHFAREV5xlkKL1B4QwoM+JhPp2DiUmYKafZaBcql2tKWt+VwbaW2iYzQokT/cA4Y9CNQlqQGkqA2s5DQcWavsQuVXUJCQ8dwo+8xNKu5v9hEoo2/g8SrdqQ0BnwZ+/EXRzhuXCL0WwTx2kEAm7yONbkRsp5RdWVpIG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uMXWqK1b; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uMXWqK1b"
Date: Wed, 15 Apr 2026 14:56:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776257775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6slVawSfKMpPOqYqLmHiTqmE6ERD5QkVfclKC4M3nU=;
	b=uMXWqK1bdAp49aHv1oUPRTWyI4Zgvh5Z32YDev4Dp8hlMtsO26s4sEABk1Ee3TPjaH7QKN
	0m/pZ1eSbhJoh8WO4Nr4K+tVzXjiIzWz+pSgRn9ZFpnvFNd4IvdQ5Y48fRnYjDtTBT7q9k
	21ojmPq4t9DWmLBxBH6YQtRl761pHBo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: blake2s - use memcpy_and_pad in
 __blake2s_init
Message-ID: <ad-K6-ohL0AZoOQk@linux.dev>
References: <20260414154902.344182-3-thorsten.blum@linux.dev>
 <20260414154902.344182-4-thorsten.blum@linux.dev>
 <20260414173915.GB24456@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414173915.GB24456@quark>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 14, 2026 at 10:39:15AM -0700, Eric Biggers wrote:
> On Tue, Apr 14, 2026 at 05:49:04PM +0200, Thorsten Blum wrote:
> > Use memcpy_and_pad() instead of memcpy() followed by memset() to
> > simplify __blake2s_init(). Use sizeof(ctx->buf) instead of the macro
> > BLAKE2S_BLOCK_SIZE.
> > 
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  include/crypto/blake2s.h | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
> > index 648cb7824358..f0e0ce0b30a5 100644
> > --- a/include/crypto/blake2s.h
> > +++ b/include/crypto/blake2s.h
> > @@ -70,9 +70,8 @@ static inline void __blake2s_init(struct blake2s_ctx *ctx, size_t outlen,
> >  	ctx->buflen = 0;
> >  	ctx->outlen = outlen;
> >  	if (keylen) {
> > -		memcpy(ctx->buf, key, keylen);
> > -		memset(&ctx->buf[keylen], 0, BLAKE2S_BLOCK_SIZE - keylen);
> > -		ctx->buflen = BLAKE2S_BLOCK_SIZE;
> > +		memcpy_and_pad(ctx->buf, sizeof(ctx->buf), key, keylen, 0);
> > +		ctx->buflen = sizeof(ctx->buf);
> 
> I'm wondering if this is actually better.  It's another helper function
> to remember.  Also 'keylen' can be a compile-time constant here, and
> compilers know what memcpy() and memset() do, so they will optimize the
> code accordingly.  The helper function takes away the compiler's ability
> to perform this optimization.  If this was already an out-of-line
> function, it would be a bit more convincing.

My motivation was readability/maintainability and avoiding the manual
tail-size arithmetic.  memcpy_and_pad() is just a thin wrapper around
memcpy()/memset(), with an additional safety check to prevent integer
wraparound.

Currently, nothing stops __blake2s_init() or blake2s_init_key() from
being called with keylen > BLAKE2S_BLOCK_SIZE. The WARN_ON() in
blake2s_init_key() is only available in DEBUG builds.

That said, happy to drop the patch if the explicit version is preferred
for performance reasons.

Thanks,
Thorsten
