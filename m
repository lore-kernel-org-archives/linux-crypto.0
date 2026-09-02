Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AD84AA1F8;
	Wed,  2 Sep 2026 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366457; cv=none; b=RtGQ7gSThk6esR9DguTTOp5KN6fOlnxrFdmf4ri4kg0yN4tDwiVYHnqU4vSp+pVmivQKQ9JKTo4/YME+RG+X6a9ctp5rLPvmrSaniM1EKnDyAtu9L/A70iuCHONao7a4ONHgwQUf72c/KV2Zf0zG5ONAKvAi60WA49+pZK2tAfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366457; c=relaxed/simple;
	bh=EdznoufdT+3hv3wj7hVc5FYRCuFUglG/YkxUow61JzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JT6TX78H8Jb3Kxrc7KG3hVyvH53m/vk4zE2aShofuPuBETmNCt1jCmGAuEEItA/7Mbs+Pgad4Hg1IsWmI/fJpG1+aZQLfgAXyZ/2efgQHWDx9lvHc4jD42bwTvlPQLWIuKdWmMmVEaIXnHbpZ794icmUu12vKvPXNOzHXywHDnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MspZZKfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MspZZKfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0CE1F000E9;
	Wed,  2 Sep 2026 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366455;
	bh=sGPLVPrsW20Hc2QncRMwkmjHyjocTS2ojD12u4G0sfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MspZZKfvIAFuphkmaZgCpAI5aUlQmNQF1XShkiGVm6iGCoRalHPyFGYbFCjrSyC5E
	 whWofDqFdHAPlV6mSFaybRGOahZ5OYK0etK1HhqqiJp4eNP90f9wMi8bJD6bbBTaZV
	 heLet/ZXSHnt6XIEcK29rgKd01qhlN+xDmi5xJim1suKTE8cSP6yItnEb7UEdgzitp
	 d6oda4lAyz1FL9UxeyhrUUQLIxiBa001A+Rj4E+U9a+cTCZIxeQCq8fzDXfUZuHsCp
	 eGjI9ZSNVbyozgcbJHmGvvDUOIUeCig7iOOrI/LZqxZ6fUjQNsV5ZmY1Fc8GS/2TcK
	 5EoaUrjr2JnzA==
Date: Wed, 2 Sep 2026 09:27:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, stable@vger.kernel.org,
	Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH RESEND] crypto: x86/aria - add missing vzeroupper in AVX2
 code
Message-ID: <20260902162734.GB2497@quark>
References: <20260831211715.213121-1-ebiggers@kernel.org>
 <apfghSk4CWshYcUF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apfghSk4CWshYcUF@gondor.apana.org.au>

On Wed, Sep 02, 2026 at 06:38:29PM +1000, Herbert Xu wrote:
> On Mon, Aug 31, 2026 at 02:17:15PM -0700, Eric Biggers wrote:
> > Since the AVX2 optimized ARIA code uses YMM registers, execute
> > vzeroupper before returning from it.  This is needed to avoid degrading
> > the performance of any later SSE code that may happen to be executed.
> > 
> > Fixes: 37d8d3ae7a58 ("crypto: x86/aria - implement aria-avx2")
> > Cc: stable@vger.kernel.org
> > Cc: Taehee Yoo <ap420073@gmail.com>
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> > 
> > This didn't get picked up by the x86 maintainers yet.  Herbert, can you
> > take this through the crypto tree?
> 
> OK I could do that.  I presume you want this to go into 7.3, right?
> 

It is a bug fix, so yes it should go into 7.3.

- Eric
