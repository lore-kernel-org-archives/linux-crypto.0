Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B56913AA2D
	for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2024 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735510213; cv=none; b=Sw5pDWg2ZMtKYiQKRT9n56yp04Qp9pqg1LgmPu9osfOqeTkK46pkmvUOu4iV5s7RaBYL6EK/Wf2A1VsOi2yNWbrzsRyJmyJwA6XwJG6NmWskQoOIdv8QRLNUGQ+N9AnYTMcL1LpSTIzTkVvcu/+Y/7by1UTGE8CtpsIlNdzvXgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735510213; c=relaxed/simple;
	bh=JIVzdtxPyiuH9YhaASpOH75NAlmkltS/dKNv5lsveyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpNsh0TgLLaxnwuXzq8w+jPRO9jMfG7dMhh0lOA286uzXAY++ZZLDXA+2Iwn174dtiJSLWuG+GKSkSvbKDNP3c8gcRx3PDDL1y+oQ/vUqGq0sIh3ZzbAVXxE9fp7+UTzzie8lxfkfnrNpqAZ5XxeRGkvasyRF4eYdZ+tUnQj5wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpY+vzXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpY+vzXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5C2C4CED1;
	Sun, 29 Dec 2024 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735510212;
	bh=JIVzdtxPyiuH9YhaASpOH75NAlmkltS/dKNv5lsveyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MpY+vzXSqc5iVN6yiVTwj1JEXplJ5PfP/K+y8ZxjwVbKpk1lXFxMp3HmLfkAJ8WtE
	 kDyzOmtJzoKYR9sfDSqs9bgWrO2NO13WGHNxILQpnvFI37SGCJ5/KUZG4oo/HoyEl5
	 kqmuTB3vT4GTblD3ntoiFo7BmZBko30L5u7jD7QdLX5felGQIDJz5ilaNV7BkMdO3d
	 3/20EIpTfGs0WN00gX1JLh0E9YLm/pVBIu3d34+Ojq699NhihugjFyXta0Em4Tntzg
	 EfBePj8bcXdaW5r//EgX5XatyfHFXxl8/2h1DwH3T4+jISilh+dvAVyqF6p+MgQnFx
	 qtlqnOPPPTVTg==
Date: Sun, 29 Dec 2024 14:10:11 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 07/29] crypto: skcipher - optimize initializing
 skcipher_walk fields
Message-ID: <20241229221011.GA1332@quark.localdomain>
References: <20241221091056.282098-8-ebiggers@kernel.org>
 <Z2ajd9PdI3noj-oT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2ajd9PdI3noj-oT@gondor.apana.org.au>

On Sat, Dec 21, 2024 at 07:16:07PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > @@ -326,13 +326,13 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
> >                return 0;
> > 
> >        scatterwalk_start(&walk->in, req->src);
> >        scatterwalk_start(&walk->out, req->dst);
> > 
> > -       walk->blocksize = crypto_skcipher_blocksize(tfm);
> > -       walk->ivsize = crypto_skcipher_ivsize(tfm);
> > -       walk->alignmask = crypto_skcipher_alignmask(tfm);
> > +       walk->blocksize = alg->base.cra_blocksize;
> > +       walk->ivsize = alg->co.ivsize;
> > +       walk->alignmask = alg->base.cra_alignmask;
> 
> Please do this instead:
> 
> 	unsigned bs, ivs, am;
> 
> 	bs = crypto_skcipher_blocksize(tfm);
> 	ivs = crypto_skcipher_ivsize(tfm);
> 	am = crypto_skcipher_alignmask(tfm);
> 	walk->blocksize = bs;
> 	walk->ivsize = ivs;
> 	walk->alignmask = am;
> 
> This generates the right thing for me with gcc12.
> 

This seems strictly worse than my version, so I don't plan to do this.  It's
more lines of code, and it causes an extra push and pop to be needed in
skcipher_walk_virt() to free up enough registers to hold all values at once.  It
may be intended that API users are supposed to use the helper functions instead
of accessing the algorithm struct directly, but this code is not a user; it's
part of the API implementation in crypto/skcipher.c.  There are already lots of
other direct accesses to the algorithm struct in the same file, and even another
in skcipher_walk_virt() already.  The helper functions are pointless in this
context and just cause problems like the one this patch is fixing.

- Eric
