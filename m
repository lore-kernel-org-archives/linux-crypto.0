Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020D012B78
	for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708668557; cv=none; b=DpSLudOFMgfBpQcajCH4IMfvRPEGuTB4/YTSkdSFg25ECpKx9y2GWhkaTzAtGWpz5g7qz/Qd3rgjEfqeqj/Y6u/pM6ki/BpYiJMw9ovV5748f9XysaHGmLujnSwG60T1J1dLGVxuGS2yJ9KFucm+QwftXERKu8/VKTQz6sNTbw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708668557; c=relaxed/simple;
	bh=q2eyXMPh7Kjf6+KRRv1NhFS1KW07y22cJChsrDaetIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIz6O5ooNIqnBFWCkJYG0I7/lWBt8qp4dPrVxvZghFT267KlQnGSzHV9TzzptFNbtQTK23DkGZvmE+plOaaER8PZk61eucRjpCP5vHjS1i5F7kgw4LuTb0Cv8ZgXCgcRyIRwGxqt9vvxkk5mXT4yADgHRcv6vdAz10Bou56nC0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdF2miBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdF2miBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEEBC43394;
	Fri, 23 Feb 2024 06:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708668556;
	bh=q2eyXMPh7Kjf6+KRRv1NhFS1KW07y22cJChsrDaetIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QdF2miBWkR2DfA76mt7rl8MuSIaUEaHbuFyNUmYRsrAOgOT1G1AjGnZvfpZcrOHTd
	 /BWXWRDhxcZ3b6NyP0QokBGDc95Y02mcUyEW4CWlqEYJ4uGZ7Ldts4YjLvObfE1ZBB
	 SBS6Am5fKLBzNNZ/YkBIzGY6HiUAa2OfJTiis7Tqe1TtBuxWXzWAApDuFPHQkr/bd8
	 kXuEg7tQKRI5U8fKeF6fOazrY0qTvtgxsG2McGMWxbRPZQ4RdaunUL3j9hoIm4kN9q
	 spBfrLpxqaaS3oLhdzCcYLg8dXfivSC6elIxMaAcDBbnp0foiCpidtH0H783F4Lx7q
	 lYIH6LxUOE49g==
Date: Thu, 22 Feb 2024 22:09:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 13/15] crypto: cts,xts - Update parameters
 blocksize/chunksize/tailsize
Message-ID: <20240223060914.GH25631@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <b149e8743355be694c96da02ced0811963298373.1707815065.git.herbert@gondor.apana.org.au>
 <20240214230021.GC1638@sol.localdomain>
 <Zc3D8kwfZXiCagOL@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc3D8kwfZXiCagOL@gondor.apana.org.au>

On Thu, Feb 15, 2024 at 03:57:38PM +0800, Herbert Xu wrote:
> On Wed, Feb 14, 2024 at 03:00:21PM -0800, Eric Biggers wrote:
> >
> > Before messing around with cra_blocksize, it needs to be decided what it
> > actually means, and document it appropriately.  According to the current
> > specification, AES_BLOCK_SIZE is correct here, not 1:
> 
> Block size should always be set to 1 unless the algorithm is only
> capable of handling input data that is a multiple of block size.
> 
> >  * @cra_blocksize: Minimum block size of this transformation. The size in bytes
> >  *		   of the smallest possible unit which can be transformed with
> >  *		   this algorithm. The users must respect this value.
> >  *		   In case of HASH transformation, it is possible for a smaller
> >  *		   block than @cra_blocksize to be passed to the crypto API for
> >  *		   transformation, in case of any other transformation type, an
> >  * 		   error will be returned upon any attempt to transform smaller
> >  *		   than @cra_blocksize chunks.
> 
> OK this is wrong.  We should fix it.  For skciphers, the input
> length must be a multiple of blocksize.

That seems logical, but everything needs to be updated to be consistent.  Note
that adiantum and hctr2 also use the currently documented convention, i.e. they
support byte-aligned messages but they set cra_blocksize to 16 because that's
their minimum message size.  Also, while the proposed definition seems logical,
do you have any more specific rationale for wanting to make this change?

- Eric
