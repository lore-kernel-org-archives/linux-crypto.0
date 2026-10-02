Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0308E38D3EE;
	Fri,  2 Oct 2026 21:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977389; cv=none; b=I85T3xPQF0NUxcmsJ9V1KOvw/c30QqpufE+cfTf92kUTZFYBcHOL1Nb4Q29x9Bru0yiLCehinZvAZbCJ8EBWZRcaWc+16Bsheg0qazq87FAgBPDjjIfjX6wl2LhWLZz4qNBO1DlHfAYWVOsh4RUgWQ6rDMDmzg8brvNAP1vmW/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977389; c=relaxed/simple;
	bh=fNKKvytyE02K2bkXk/IXWX+PuiA294VKpQJ/Ylqiios=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjeR1IibIj8uQjTVuJ3QCnj+kHX2clhW9HDm8Au3//m7TLuuC5zHwj+YnzqJgabd4KNu7VfJO3VqSYflzbGzGmnnfMOGpH+0E8YM3GaObsKvJ8hnag2tfT7sSIJq6cdHlNzKr5Y5DGfGZNsSX8Vd2gxGqlTVxZP4nNRp+8wI5iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQOdPJor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQOdPJor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026A11F000FF;
	Fri,  2 Oct 2026 21:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790977387;
	bh=w/kS8p4PHUGiNKYAO/ix54By46On2QqKie4f487msYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EQOdPJoroBcTw7XAmszQ7kxMPsckEFvgLdj5hxYRvafHDitxDk4Kg4MhUD8Es6/LA
	 zm4sgyMs3SLimnQJKIglJeFt/qLMguvM1s6kEaRWlz/NzjUenRo0XwtxZsIMGxjbap
	 shAxEA/mscVynjZu+ZAfLD1G3qKAzNnX5nPtUdW3w3bdq01tDke3FFCnI29TM2uu5y
	 8Pw4qpV9dMn+7b/gALmVRBMehpjhClCuUv2QwUCHTcosxV/R7NEnYaa6DxKiXRdy59
	 FhfyfbjTmujPS/6pWMRQthGGKbs+xEkAZKWj8lzZ4BUnuYosyi44IHE6+QSnG8y/QT
	 V5W3VWkgUjAhw==
Date: Fri, 2 Oct 2026 14:42:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: x86/aes-ctr: Remove some unreachable code
Message-ID: <20261002214245.GB3006@quark>
References: <20261002034405.49886-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002034405.49886-1-ebiggers@kernel.org>

On Thu, Oct 01, 2026 at 08:44:05PM -0700, Eric Biggers wrote:
> In the AES-CTR and AES-XCTR code that handles a remainder of '4*VL < LEN
> < 8*VL', first 4 full vectors are processed, leaving 0 < LEN < 4*VL.
> After that, five different cases are handled depending on whether there
> are 0, 1, 2, 3, or 4 full vectors remaining.  But the case of 4 vectors
> is never reached there, making the code handling it unused.  Remove it.
> 
> With that done, the '.Lxor_tail_partial_vec_3\@' block would be reached
> only via an unconditional jump.  Therefore, relocate it to the only
> place that jumps to it.  This allows removing the jump at the end of the
> '.Lxor_tail_partial_vec_2\@' block and making it fall through.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/aes-ctr-avx-x86_64.S | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
