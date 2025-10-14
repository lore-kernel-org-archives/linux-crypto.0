Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C40E1A9FAA;
	Tue, 14 Oct 2025 00:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760401975; cv=none; b=YcJEeu906DEhM7mDPucsj4aLwGDvolpZrdr+SXziiCFQJ/FtSZg9wr3yN3kUw2TOr7k4OgLbDilfdxz9S7U50lkCxz2M2+axkfcM+azk2tws2Ts2T3S8sOTjqoByIwi6J/GMtChWhHyvaejwhg+NSQkR/fQPD5bQTn1xaSIlXFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760401975; c=relaxed/simple;
	bh=l3hcgd7zQfZciXGoXSE+hgsm6c75qLFFS4okpW8o84A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wodmv6tytl6qScQ1Qh3cTbYAxsw15hgCe9H5Ki9WNL+WIwcooKvh82rp6se2dnLUDvqSfqCjmB/qzb4JWai1B10S9jcL6e2ldL6H9AHu4ose5nL+DvEe3O+ZoZvIxio+1e87KUEVUsUL/Vs/468p6+TFSqvIkoxLR/oaDDksxoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGx9KtxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGx9KtxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73A6C4CEE7;
	Tue, 14 Oct 2025 00:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760401975;
	bh=l3hcgd7zQfZciXGoXSE+hgsm6c75qLFFS4okpW8o84A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XGx9KtxIl5KDM3DaJs6JHWEB3A06cw0l1xdrBAM8S2os7M1CedLNq+uEe8AJgTi3u
	 O0f82vW4FD64St5f5osxEd3cuueDZXeVrLE4wKs82GbWhFuDnatR45LWihBM9CCWMb
	 raf4AYfVHda8FtOsSA6x8Js2C0ZVFBhHCp2CZUGcOgDu+0PWayuwEDxeAfCDooMzWX
	 gIzO//xGDnGFeG1lLlR+G+5PNBNakV3dgyJhcZkpcdYTLA5YOLj90W9oSco1QNBaEH
	 R/QGhvCPrg2I1omRj0qRf1un58xFJSRntsMLX+MD/ZczuWn7bzt38VoiAA2YT2NPE8
	 GBdkAG4ba5KWA==
Date: Mon, 13 Oct 2025 17:31:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <20251014003123.GA2763@sol>
References: <20251002023117.37504-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002023117.37504-1-ebiggers@kernel.org>

On Wed, Oct 01, 2025 at 07:31:09PM -0700, Eric Biggers wrote:
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
>   crypto: x86/aes-gcm - add VAES+AVX2 optimized code
>   crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
>   crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
>   crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
>   crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update
>     functions
>   crypto: x86/aes-gcm - revise some comments in AVX512 code
>   crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
>   crypto: x86/aes-gcm - optimize long AAD processing with AVX512
> 
>  arch/x86/crypto/Makefile                      |    5 +-
>  arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   12 +-
>  arch/x86/crypto/aes-gcm-vaes-avx2.S           | 1150 +++++++++++++++++
>  ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 +++++------
>  arch/x86/crypto/aesni-intel_glue.c            |  264 ++--
>  5 files changed, 1667 insertions(+), 486 deletions(-)
>  create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
>  rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)
> 
> base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
