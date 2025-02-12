Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5972D600;
	Wed, 12 Feb 2025 05:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739336978; cv=none; b=X0uT45wjZiNAG8n+GFv2Elq3Q7Ct7s/IomQ1NEuxEe1YfG9+Np0Gs1liGp9fuoqbyWmmWSOfAGawSFAjHtIWbBSMXQCqJUn9NXgVWmIEYUIjp8m89MfR9DT4y/AbdDTFIAUlEF7wh1yydISFRaaoSEptKMA6hWgJdOW/AZdjL+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739336978; c=relaxed/simple;
	bh=rTwWzK2R5eDHPwNZlzEPgv/sFPzyIQ5iAEXmdHJPvLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpDVndHBDmiIcUqEvZZHe1Ct/cNLheXsnZDq/GDnFzih8weMpal/pqRDc1fP1ys5KxKjY5jucDXFL54BX4iOvHbbzbzwEdr8qosU03/b2xplsByj7MpubHHB0hMDhMxGwQmggFLvssdPj9+5C0nmfWHM3cmysjqfzz2YLbcWvb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pn5tCHJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pn5tCHJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF04C4CEDF;
	Wed, 12 Feb 2025 05:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739336978;
	bh=rTwWzK2R5eDHPwNZlzEPgv/sFPzyIQ5iAEXmdHJPvLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pn5tCHJrzTM3ToHa89t1YtbsX3sakR38xaIZQmVhye3ZeCDtfB/OM2NIPy+p6YsvX
	 w27WDsufZQbzUwe08sthFVmMjPZjbtAecz45Tw4IG1nV38qsQqRCmpggxsZEaOZUmv
	 tyO+CFqxNtohfD7gd3hMovkjbsyNZj9/xjMdmEjsHHiIbbOBcoAw/gndw6rJL/l1YE
	 xHuYGY5CRpPiNmT5D514pwHCNHhlko4NnIdxmYrtww9jaP090NRZBXOt2AlcQ93UCy
	 gxBQO6UdJP86APaf8wU748uYhGO5rPFHGraLkckcl6wbxHPp7qx8S+2gv6JZ6/ap6m
	 gySGaiE04PWXg==
Date: Wed, 12 Feb 2025 05:09:36 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <lkp@intel.com>, Danny Tsen <dtsen@linux.ibm.com>,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/Kconfig - Fix lib built-in failure when arch
 is modular
Message-ID: <20250212050936.GB2010357@google.com>
References: <202501230223.ikroNDr1-lkp@intel.com>
 <Z6woN4vgdaywOZxm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6woN4vgdaywOZxm@gondor.apana.org.au>

On Wed, Feb 12, 2025 at 12:48:55PM +0800, Herbert Xu wrote:
> On Thu, Jan 23, 2025 at 02:18:27AM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   c4b9570cfb63501638db720f3bee9f6dfd044b82
> > commit: b42519dbba838c928e82b55f32712fbe3eed2c45 crypto: ppc/curve25519 - Update Kconfig and Makefile for ppc64le
> > date:   8 months ago
> > config: powerpc64-randconfig-r111-20250122 (https://download.01.org/0day-ci/archive/20250123/202501230223.ikroNDr1-lkp@intel.com/config)
> > compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
> > reproduce: (https://download.01.org/0day-ci/archive/20250123/202501230223.ikroNDr1-lkp@intel.com/reproduce)
> 
> Thanks for the report.  This is the old built-in vs. modular Kconfig
> problem.  This patch should fix it:
> 
> ---8<---
> The HAVE_ARCH Kconfig options in lib/crypto try to solve the
> modular versus built-in problem, but it still fails when the
> the LIB option (e.g., CRYPTO_LIB_CURVE25519) is selected externally.
> 
> Fix this by introducing a level of indirection with ARCH_MAY_HAVE
> Kconfig options, these then go on to select the ARCH_HAVE options
> if the ARCH Kconfig options matches that of the LIB option.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202501230223.ikroNDr1-lkp@intel.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 32650c8431d9..47d9cc59f254 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -6,7 +6,7 @@ config CRYPTO_CURVE25519_NEON
>  	tristate "Public key crypto: Curve25519 (NEON)"
>  	depends on KERNEL_MODE_NEON
>  	select CRYPTO_LIB_CURVE25519_GENERIC
> -	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
> +	select CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
>  	help
>  	  Curve25519 algorithm

Please name these like ARCH_HAS_CURVE25519 and CRYPTO_LIB_CURVE25519_ARCH to be
consistent with the CRC library, the many other ARCH_HAS_* options, and
CRYPTO_LIB_CURVE25519_GENERIC.  Nothing uses names that contain "MAY_HAVE",
which is ambiguous.

FWIW, at some point the arch optimized crypto algorithms also need to just be
enabled by default.  The fact that they're not is a longstanding bug that is
really harmful to users and needs to be fixed.

- Eric
