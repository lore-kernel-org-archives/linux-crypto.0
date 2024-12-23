Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007531C3C12
	for <linux-crypto@vger.kernel.org>; Mon, 23 Dec 2024 19:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734983631; cv=none; b=gfp+lyKEox7SVTvhbEnuQSOM0fAIzl5nIFNtZAX/4hAyCx7cr/RAs5/r75E5jtE92MgIbRouXSn+hfFKKXymfJ1yq+jnlGzdzISChSGrO8XSSguyiLhAG0bsRRjcfUX61NbYxGcxsmfYooOevZxWAcXdLXKwubH9aAf63Men3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734983631; c=relaxed/simple;
	bh=nVOJTIBxYPEDW+qkLFwr0O9e/nJUtN5GdDoRydx5h34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBoC7HWqbMnmp+fgH+ZPYQXhYhiNc7amuyn7sDPMhai/haqPVe98CJU11o6Ez09N9Z5fkwol9fapERk8sjnkyhffvDsaS5bgQDy2DQTx4xbCZJkqFAbvZNhDrAIT7NkWjJY/qo3s/d2rETiIEG7nr7nuT6tcvpqZwwuv8r2EjJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZ78DogC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZ78DogC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D75C4CED3;
	Mon, 23 Dec 2024 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734983630;
	bh=nVOJTIBxYPEDW+qkLFwr0O9e/nJUtN5GdDoRydx5h34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CZ78DogCRPILlxvvcYkQHM3tFHetouuK3b+gKCL33HHVoA5fkIuGncxdUpAMDZTAe
	 Ph3HG6TDOwRdRDLxxMwW/ytrRFXtFZH0rlATD7DoSD5A2cQF7oHhGJPAe/zRDLeefs
	 xDJEUTsrqMXSCYlZlNJmg58UGmK+jqHyRrQ+Y6k92uwLL9ZlZAPeUGK+GJ1ofMLtNb
	 wMCuLBw5QaXli6hj42nafzvSYbOBPCLydx49zW6Bl6zYhPxtbuL1+6g5MMpttHR/sK
	 6gWcneo0h7gxUX7cnhEknpA9wf4B/J4QE28tUe23MRgKaw05k6tnk/VCjKhSfj+jaJ
	 RWGf3Sld9fxJA==
Date: Mon, 23 Dec 2024 11:53:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 13/29] crypto: scatterwalk - add new functions for
 iterating through data
Message-ID: <20241223195341.GC2032@quark.localdomain>
References: <20241221091056.282098-14-ebiggers@kernel.org>
 <Z2amIuU1sLDWBsSh@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2amIuU1sLDWBsSh@gondor.apana.org.au>

On Sat, Dec 21, 2024 at 07:27:30PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > +       if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
> > +               flush_dcache_page(scatterwalk_page(walk));
> 
> Does the if statement do anything? If so please add a comment
> about what it does because it's not obvious.
> 

Yes, since even though flush_dcache_page() is a no-op when
!ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE, scatterwalk_page() still calls sg_page()
which calls BUG_ON() when CONFIG_DEBUG_SG=y.  That can't be optimized out.  Note
that despite ostensibly being a debug option, CONFIG_DEBUG_SG=y is often used in
production kernels.  Also, in patch 29 this changes into a loop that may flush
multiple pages, and which makes it harder to show that it would get optimized
out even with CONFIG_DEBUG_SG=n; e.g., the compiler would have to prove that the
loop is finite.  I will add a comment to this patch and update it in patch 29.

- Eric
