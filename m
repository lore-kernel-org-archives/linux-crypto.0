Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98F93FE4
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742099793; cv=none; b=qAf5OQLUjXSfhu2nVEG8KfjMFr2vNYP1UKbvac5bZIMz1ljOCtMrcf1bGQHfEJ5a2laf/XdRpn/oupcmNAVbOCSlel0vRzdFf93p3DqFaAmfpC3uNhvIErPeBFKGRC7zlvDWMxAZYopPs0QvqF0WUkG/YY4A1UFgdn5ILJo1bvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742099793; c=relaxed/simple;
	bh=SencnnOEgjallz4lIuxp4nn/vvqcLNJ1WTKcrAklLQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSL4saldW7T35O18nqcf4z9GmT0Pk8qZvdB/pIkJywjWxz/xTU8aezvvQ8DYqitAXXUtF5JpBCCTZzb79oO1B8uafon4XNZ21r6TBF/dF9vUbTV6c0HjO/SyN2HzHNtvzs3x2Rky4r8kvwfT5cUCzZ1WWKP9FYfOi4OS2ysWqTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grWVnqrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grWVnqrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE405C4CEDD;
	Sun, 16 Mar 2025 04:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742099793;
	bh=SencnnOEgjallz4lIuxp4nn/vvqcLNJ1WTKcrAklLQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grWVnqrCuVHN+WZtvYhUACt5TP+mKxzlYLelp4A7ittoi6F0D9D5el5iWA1EKgF+p
	 hsZ7rYg1XrhR1ZqbJ26KIhvpREgEY3e+0Ea8tDErWh/S2frez2zkkRLQBpYcnWaRal
	 IgYu+5Q9OLkMEMXU5cAzpkTmv++ZF0z6J1pDi5VAvmWmF1PZTqFqPNnEEYrDl44QeQ
	 P1/62B/LtnKINtGy3dlQmJeiJ7H65y2bvE71uQqoYen7XK7hLIQD4V2D5EJsNpph/h
	 k4R2HL7ZsRwyMUTQUyWSRXB3ns5SxHl7CozLwBVqWEDQG6EzkQi+Ngrk2i1ckPVkpj
	 gygkkNx3HUaYg==
Date: Sat, 15 Mar 2025 21:36:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 3/8] crypto: acomp - Move stream management into scomp
 layer
Message-ID: <20250316043631.GC117195@sol.localdomain>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <25f96a0e0e642e9d1c6014b12b00fd21b9f9c785.1741488107.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25f96a0e0e642e9d1c6014b12b00fd21b9f9c785.1741488107.git.herbert@gondor.apana.org.au>

On Sun, Mar 09, 2025 at 10:43:17AM +0800, Herbert Xu wrote:
> Rather than allocating the stream memoryin the request object,
> move it into a per-cpu buffer managed by scomp.  This takes the
> stress off the user from having to manage large request objects
> and setting up their own per-cpu buffers in order to do so.

Well, except the workspace (which you seem to be calling a "stream" for some
reason) size depends heavily on the compression parameters, such as the maximum
input length and compression level.  Zstd for example wants 1303288 (comp) +
95944 (decomp) with the parameters the crypto API is currently setting, but only
89848 + 95944 if it's properly configured with estimated_src_size=4096 which is
what most of the users actually want.  So making this a per-algorithm property
is insufficiently flexible.

But of course there is also no guarantee that users want it to be per-"tfm"
either, let alone have a full set of per-CPU buffers.  FWIW, this series makes
the kernel use an extra 40 MB of memory on my system if I enable
CONFIG_UBIFS_FS, which seems problematic.

I don't think the crypto API model works well for compression at all, TBH.

- Eric
