Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227E726B764;
	Sat, 30 May 2026 19:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780169199; cv=none; b=u/1xtziztBhvRTokk5vCilMPwLplNEbcAjLLpD1+/ikbG42WpZwySwbB9V+N6ux4y93rY8mA21fgLoVCrE9e2cVMqEvx5lfClwOtujs0YbXsbl5aCxxAPV1xH+se5xvPR9qyD2+WlIbmbm502DU8Er44VQ+OkrKbxFUjSzd6AYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780169199; c=relaxed/simple;
	bh=V5JDf3FoZpGmt8nIt1lcKs/LSZF2o0MDSYTrqqrMOu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0sRbMb4DMWBRHXbJletdsUUxnkf8MPx85KuE/4Uxeu7YKf/l7Jsum/LeBjaea71WvaydfI+KMe2WbTITi5KzJMhkQJFuhs8mscYMSNoWiMYgsFjwEsd/H1MaF7jbKC5VUPY8i2pHv89oy/jnTxGoJT3i+m3rLUZXyMCCPBBm/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gE6tY2C1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gE6tY2C1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7821F00899;
	Sat, 30 May 2026 19:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780169197;
	bh=z5GsolBXXG87q6U09vPL4wkhz04P58jv7onQiI/rtEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gE6tY2C169MjZGxfK1lZvyGSb6rNyisdk9hNjLiqAv/5UjrwIvu6eRjZKaI8FMafi
	 8SmYISFrENntrlZoRw6boLB8gRAwxqNVp47J48Md0Yq4HlZj6+KIfkwYn7vRfw0p7S
	 2Dp32qEn744GwPbS26zLypvHNJ0qxMC/a7I+n2OC82tGMyf340Rh51Z/syVlcLlJ0F
	 Fk2iA8WOWIyhuNhQ2JHVFQx91inAfMk+FJlFeIxjGZ901dFVnb6h5ZBW/81of9YPkN
	 z6bq8VVhQ5VpbdJtYF94j93q7ZArNcDoUMvGFO5jka8c0/vLKPukANTmjTf99wi+16
	 bfm+4HjNQ6bFQ==
Date: Sat, 30 May 2026 12:26:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Lamparter <chunkeey@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: crypto4xx - Remove insecure and unused rng_alg
Message-ID: <20260530192630.GB6807@quark>
References: <20260529220430.34135-1-ebiggers@kernel.org>
 <5c74c261-53cf-4185-a8a0-7554bc9fe5f7@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c74c261-53cf-4185-a8a0-7554bc9fe5f7@wp.pl>

On Sat, May 30, 2026 at 05:05:19PM +0200, Aleksander Jan Bajkowski wrote:
> Hi Eric,
> 
> On 30/05/2026 00:04, Eric Biggers wrote:
> > Remove crypto4xx_rng, as it is insecure and unused:
> > 
> > - It has only a 64-bit security strength, which is highly inadequate.
> >    This can be seen by the fact that crypto4xx_hw_init() seeds it with
> >    only 64 bits of entropy, and the fact that the original commit
> >    mentions that it implements ANSI X9.17 Annex C.
> 
> In addition to a seed, the PRNG also uses ring oscillators as sources of
> entropy. The entropy should be higher than 64b. This is the Rambus EIP-73d
> IP core. The same IP core is built into eip93 (EIP-73a), eip97 (EIP-73d),
> and eip197 (EIP-73d). You can find the documentation online. The complete
> "container" is actually Rambus EIP-94, and one of its parts is EIP-73d.

Just because it may have another source of entropy doesn't mean its
security strength is higher than 64 bits.

I cannot find any documentation other than
https://datasheet.octopart.com/PPC460EX-SUB800T-AMCC-datasheet-11553412.pdf
which says "ANSI X9.17 Annex C compliant using a DES algorithm".

DES actually has a 56-bit key, so maybe I was over-generous.

And according to https://cacr.uwaterloo.ca/hac/about/chap5.pdf ANSI
X9.17 has only a 64-bit state anyway.  So even if we assume the
datasheet is incorrect and the algorithm is actually 3DES which has a
longer key, the state is likely still 64-bit.

So it isn't looking good.  And since it's an undocumented proprietary
design it shouldn't be given the benefit of the doubt either.

> This PRNG is also used internally for Generation IV with IPSEC offload. The
> IPSEC offload implementation for eip93 was recently submitted to upstream.
> I am not sure whether eip94 shares some of the logic for IPSEC offload and
> it will be possible to use some of the code.

That's not related to this patch.

- Eric
