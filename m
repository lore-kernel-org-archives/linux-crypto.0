Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69962E62B6;
	Fri,  4 Apr 2025 01:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743731479; cv=none; b=k68tLFvkDKY81+xHI06emVNcD0RknQuMvGgpr+2ZdhNdGZn+113/qb/QvVh5aPsC8It/paqHt3ScSWxQNPVaIWVWMm2qOsgmwLr7aKn9yKnzEqF02kWNkRvYIPcHHyhuNkCGmpM04MS/i02dHz7iQKAc62eFzhOG8W8mNr7LKxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743731479; c=relaxed/simple;
	bh=9BoW4B3ZGSIAPStsSTAkrF11eLh+Pal6bHutBUTfweI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q36WUzs5TmpVK7mSmVOzty125V8Os8eXrB460RUSXj+YBAuNntmDgeE35z610BjAqZJU3tKJC5bqO67UHm6UHpFdR3m6fE+hW3KC9sp+XYc1LCTCyUKmqSJdAxAIX3G7PnZCPIC1xa5FQEYbgLUxbgP3URPnIXEtllCq3izs2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlzPqpQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlzPqpQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0BFC4CEE7;
	Fri,  4 Apr 2025 01:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743731474;
	bh=9BoW4B3ZGSIAPStsSTAkrF11eLh+Pal6bHutBUTfweI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mlzPqpQMtxka8dg4h0lb/M46ArxUyLQIZqOH1ccPbgdTlOKZZTO6v8jYWON1cHta3
	 rFA0Cc60/MthP3RsQdcHw6Q0sCFuCWB5PVMy+CYUudkH7XgPxe2/WMkgFT4g78I2VC
	 kqqT7aPrcDCnf5TIHJ4wjnPuKuB4PZUvBymnlSbyhd607+hD4VWrJbYXWhXE/Na3jB
	 sy2/FxQSxSShqZXHEMIFOW/gNH91OYCz/BSN2Y+MnWLIlN/hd4+SyptGTFCGLKXUlH
	 1GfRw7N7xUgqy0w/lsDvK3V3vqT3ExmnaV6xhR/j+RFaL0bUjO92XqlDvcfCvPfUJ4
	 zSHuzlF+DWDEg==
Date: Thu, 3 Apr 2025 18:51:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
Message-ID: <20250404015112.GA96368@sol.localdomain>
References: <20250403094527.349526-3-ubizjak@gmail.com>
 <202504040855.mr885Pz1-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202504040855.mr885Pz1-lkp@intel.com>

On Fri, Apr 04, 2025 at 09:13:40AM +0800, kernel test robot wrote:
> Hi Uros,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on herbert-cryptodev-2.6/master]
> [also build test WARNING on herbert-crypto-2.6/master tip/x86/core linus/master v6.14]
> [cannot apply to next-20250403]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Uros-Bizjak/crypto-x86-Remove-CONFIG_AS_SHA256_NI/20250403-174814
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> patch link:    https://lore.kernel.org/r/20250403094527.349526-3-ubizjak%40gmail.com
> patch subject: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
> config: i386-buildonly-randconfig-001-20250404 (https://download.01.org/0day-ci/archive/20250404/202504040855.mr885Pz1-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250404/202504040855.mr885Pz1-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202504040855.mr885Pz1-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> lib/raid6/recov_avx512.c:382:2: warning: #warning "your version of binutils lacks AVX512 support" [-Wcpp]
>      382 | #warning "your version of binutils lacks AVX512 support"
>          |  ^~~~~~~
> 
> 
> vim +382 lib/raid6/recov_avx512.c
> 
> 13c520b2993c9fa Gayatri Kammela 2016-08-12  380  
> 13c520b2993c9fa Gayatri Kammela 2016-08-12  381  #else
> 13c520b2993c9fa Gayatri Kammela 2016-08-12 @382  #warning "your version of binutils lacks AVX512 support"

Yeah, CONFIG_AS_AVX512 needs to be removed from lib/raid6/ too.  It looked like
that directory was rolling its own CONFIG_AS_AVX512 in lib/raid6/test/Makefile,
but that's a makefile for a test program and not the actual kernel makefile.

- Eric
