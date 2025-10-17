Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5DF28369D;
	Fri, 17 Oct 2025 08:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689484; cv=none; b=HhChziBUc48TXzLCsNivm/cgUIpJdPee/aH6pXAjISKwHKkWR5cawVwNlawOUj4Kf0wQJZyykPyvwuTiOSzgDPCt7ItFmI1FzPSw9eWQ9Zh9XZZabX3mL+k94939RVJaTVGRGdS+QE/Bnu8xIKD8iSO7Jxruk7vcoP12XTZ/Vd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689484; c=relaxed/simple;
	bh=BPU23vPGqET5S4IshQUba4H3iULRdJDNoQpea9/vMQA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ZhHwucIMNQ12bunJ7RsTlGLFp3F9e3HLII1UDAuOuy+m2Bh50ZRlftf+FMOJKBCB4OKH2P+XdyAHO9+/QtjN3PPkODSMBCQoZOpdQ09j4QxpHgtt3VB8t4mT9oNuW+0jYCfDFMSHlPoSNj4xfAX1V2noknIq2U7tjzz1zdOALxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sdbOt1eR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sdbOt1eR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=Y9Y3bZVMiVT7LSsUENrnNH3ug536bMShede7QuAEHss=; b=sdbOt1eRF8CCXigWbpGO79R8WC
	AIxX74WrfadX/joc2wVxME+BiwzNaoJ3AuzIVqufNgx+rcirS1fq4nCM7fyJwyxj/+55uRBkXj2kT
	ytGonf3i9+Kg7R8ow6iZBP1Bd4GRcqaAVU1mjlLOa2ftPor3FXBUi47Dtrx7f6FivteZv7yIx9MOH
	If/kxLRwCWNH5XJ3JIQzlmXmYHvcCRMpq7ORFCnzr5fI/agNDPGjsB7FZA2eN3rE4bvgUObAmfdrN
	Y83ScBYmpDduFxKxhBBSuosMLCYVelScV/8P4sePj1GSpzePUXBnwslocXDMNbzX/87lKrhfOB3e3
	mDOFbERQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9flO-00DN7L-2K;
	Fri, 17 Oct 2025 16:24:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:24:38 +0800
Date: Fri, 17 Oct 2025 16:24:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, ardb@kernel.org, Jason@zx2c4.com,
	ebiggers@kernel.org
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <aPH9RuBNzCg7u4aM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002023117.37504-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> This patchset replaces the 256-bit vector implementation of AES-GCM for
> x86_64 with one that requires AVX2 rather than AVX512.  This greatly
> improves AES-GCM performance on CPUs that have VAES but not AVX512, for
> example by up to 74% on AMD Zen 3.  For more details, see patch 1.
> 
> This patchset also renames the 512-bit vector implementation of AES-GCM
> for x86_64 to be named after AVX512 rather than AVX10/512, then adds
> some additional optimizations to it.
> 
> This patchset applies to next-20250929 and is targeting 6.19.  Herbert,
> I'd prefer to just apply this myself.  But let me know if you'd prefer
> to take it instead (considering that AES-GCM hasn't been librarified
> yet).  Either way, there's no hurry, since this is targeting 6.19.
> 
> Eric Biggers (8):
>  crypto: x86/aes-gcm - add VAES+AVX2 optimized code
>  crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
>  crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
>  crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
>  crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update
>    functions
>  crypto: x86/aes-gcm - revise some comments in AVX512 code
>  crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
>  crypto: x86/aes-gcm - optimize long AAD processing with AVX512
> 
> arch/x86/crypto/Makefile                      |    5 +-
> arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   12 +-
> arch/x86/crypto/aes-gcm-vaes-avx2.S           | 1150 +++++++++++++++++
> ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 +++++------
> arch/x86/crypto/aesni-intel_glue.c            |  264 ++--
> 5 files changed, 1667 insertions(+), 486 deletions(-)
> create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
> rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)
> 
> base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
