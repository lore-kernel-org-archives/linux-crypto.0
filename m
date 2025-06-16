Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED27F46B5;
	Mon, 16 Jun 2025 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750046446; cv=none; b=eRv8h7z/h2BDZmkmO3NAmRvTL90BmdjYnwQCxM3jciSYpoD6oCkygFCWnNoubtcOGz83YLTOeJjwEnxh+/ozR1rmr2j8XZIENvFNywm3ya3jFDpWbfr0AQbmKmUaggieZ+fFdepF5TvT7vT9Y0YB/VMkH48FbcDvZ1nSxVIlSSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750046446; c=relaxed/simple;
	bh=DNjwjD8hhxbYC5MpkZvfw4zJE0EdrDcAW1zA+Ae08dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwZ+pyWMVnvkWkKSIrU9AyCMzlLBQLa702l/Dv9JnhzVcyBSnT6ZiuFs5+pViSyaEjDTerXi0cQrGkIxPmwNqJNDqOqDG3uxB3gkWukce2wcXpUy638UT9yUHc+dpnDxVvsS38UpVULweq4ejIq6BlmztJs8eZcLEUspXpPBFYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJ1peQkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJ1peQkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFA7C4CEEA;
	Mon, 16 Jun 2025 04:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750046445;
	bh=DNjwjD8hhxbYC5MpkZvfw4zJE0EdrDcAW1zA+Ae08dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hJ1peQkDLOiv4Y+i8Uj6JDkRJBClMNSdzYWuoRgA7dIVv+UAlVomCsCTtYUBZtyva
	 4MNPrL/3n8vaoFc5U8hEBPhOQb4sUKuGKtLVUqI4VgD1TblmpuTE/AEQn+B93J0kzO
	 kfbw39TmzO/6Xl+JgG+CnP0OXYwDCBKI4r/f7WmyGchHF4WIB47S46tzh6gPrBr6Ji
	 mifNCMklUd5rQniJfvFb8wCXYq0one4WJKHd3w7peLeZ98ULoBpl1ZNfm64PjbtHiy
	 9HeUVguZMLVXO55sKzo0n7kQOBiMy3YdWE+JQm0T2Z5BdcTAqVuX+7hgpiO8w3OeeT
	 wBJfc/6yd39Ng==
Date: Sun, 15 Jun 2025 21:00:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Jason@zx2c4.com,
	ardb@kernel.org, kent.overstreet@linux.dev
Subject: Re: [PATCH] lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch()
Message-ID: <20250616040016.GA749462@sol>
References: <20250616010654.367302-1-ebiggers@kernel.org>
 <aE-PDfmowagPegen@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aE-PDfmowagPegen@gondor.apana.org.au>

On Mon, Jun 16, 2025 at 11:27:09AM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > For some reason arm64's Poly1305 code got changed to ignore the padbit
> > argument.  As a result, the output is incorrect when the message length
> > is not a multiple of 16 (which is not reached with the standard
> > ChaCha20Poly1305, but bcachefs could reach this).  Fix this.
> 
> Sorry, it was a cut-n-paste error since I copy the code from
> the update function where the padbit is always 1.
> 
> > diff --git a/arch/arm64/lib/crypto/poly1305-glue.c b/arch/arm64/lib/crypto/poly1305-glue.c
> > index 6a661cf048213..c9a74766785bd 100644
> > --- a/arch/arm64/lib/crypto/poly1305-glue.c
> > +++ b/arch/arm64/lib/crypto/poly1305-glue.c
> > @@ -36,18 +36,18 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
> >        if (static_branch_likely(&have_neon)) {
> >                do {
> >                        unsigned int todo = min_t(unsigned int, len, SZ_4K);
> > 
> >                        kernel_neon_begin();
> > -                       poly1305_blocks_neon(state, src, todo, 1);
> > +                       poly1305_blocks_neon(state, src, todo, padbit);
> 
> This would do the wrong thing if someone ever tried to pad a
> message more than 4K and called the block function with padbit == 0.
> Fortunately it can't happen today as there is no digest interface
> to poly1305.

The final partial block is (and needs to be) processed with its own call to
poly1305_blocks().

> Looking around it seems that this pattern is replicated across
> all of our poly1305 implementations so it isn't a big deal.
> 
> I presume you will be picking this up via the lib/crypto tree?

Yes.

- Eric
