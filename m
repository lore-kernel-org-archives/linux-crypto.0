Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6063AA4EB
	for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2026 01:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785978997; cv=none; b=OFqCgA8nF/ym2daY+D4rpUvVaIScnGd6zGEGlbMYAHrLTJk9ymygW+YR7QesWV5sJPkzgMKsIGNFIrPCT4hih9A12e3HN++ivi4AatjWsu3bUOwcqKtQbJA3uvf52Ce0HjvmZZDITweVjN4PdFgosZZp8VIYdenlEiNg6G9XTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785978997; c=relaxed/simple;
	bh=3/2WHbRB3qn6wmWMcXTmqFuRaTyDnA/ClCHZXpfomCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abu/KJyw4TD0SgXUq4A12zsTl+ofu5YgOyhPhNWwu2Gs7YfGF0fgFxTs01W2M8vbI4uih+OnQv6ZPlCsmYi7uAkOsEPYN9zKkeLD9pXvcTF+svqnXMmuRXQZvdQmUjUOqq/YI4KfmzDa4/++ovP7aPprdsN9dbqet3inFy6Q2Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=blXcvACa; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="blXcvACa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785978995; x=1817514995;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3/2WHbRB3qn6wmWMcXTmqFuRaTyDnA/ClCHZXpfomCg=;
  b=blXcvACaQ5lBJpbn5Yjkh4eNDgMT9SJCElLyaok3MLZZdN0bEXScm7jx
   NbmGDmSQ/6MvA2Fl1UZGM21NnM+31H9AJQD7Bij3F2hDMAqMjgl+j2xTA
   aJWbt1IYXyo5/+pJPfiB6FTRdzemd00yCKu3A2IRayRvptgb9L9lPA6L2
   RxBHDyep10nBUVqf0aTHBgpH4E1dG3/cnV22Ey+OfvlmebjK+24X12gnP
   tGA/dFx3G1DbTbDs9jntK8ArfHL5ODo+9ejFcj0F+IjSS0c1l2pX4h6M1
   pfwHkDLh++XquO9KNU8RoNy9JKGFD3FoFCE14YjhSrCWVkUUBmMNhisZW
   g==;
X-CSE-ConnectionGUID: 2p1D9TamTeOMURQLTgns4Q==
X-CSE-MsgGUID: LX2br6KaQZCUk6wjc+uRUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="103967889"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="103967889"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 18:16:34 -0700
X-CSE-ConnectionGUID: ov2u0TipTg+IML3KzrgeWQ==
X-CSE-MsgGUID: MCevZ67pSvGO6SWqd9GfBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="260182500"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 05 Aug 2026 18:16:33 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrmil-000000004XC-1IdO;
	Thu, 06 Aug 2026 01:16:31 +0000
Date: Thu, 6 Aug 2026 03:16:10 +0200
From: kernel test robot <lkp@intel.com>
To: Martin Willi <martin@strongswan.org>,
	Eric Biggers <ebiggers@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
Message-ID: <202608060312.gxywEDwl-lkp@intel.com>
References: <20260722153247.630519-1-martin@strongswan.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722153247.630519-1-martin@strongswan.org>

Hi Martin,

kernel test robot noticed the following build errors:

[auto build test ERROR on linux-review/Eric-Biggers/x86-fpu-Check-for-missing-AVX-and-AVX-512-xstate-bits/20260626-124221]

url:    https://github.com/intel-lab-lkp/linux/commits/Martin-Willi/lib-crypto-x86-chacha-Add-a-16-block-AVX-512-variant/20260805-221950
base:   https://github.com/intel-lab-lkp/linux Eric-Biggers/x86-fpu-Check-for-missing-AVX-and-AVX-512-xstate-bits/20260626-124221
patch link:    https://lore.kernel.org/r/20260722153247.630519-1-martin%40strongswan.org
patch subject: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260806/202608060312.gxywEDwl-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260806/202608060312.gxywEDwl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608060312.gxywEDwl-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from lib/crypto/chacha.c:35:
   lib/crypto/x86/chacha.h: In function 'chacha_mod_init_arch':
>> lib/crypto/x86/chacha.h:199:29: error: implicit declaration of function 'cpu_has_xfeatures'; did you mean 'cpu_have_feature'? [-Wimplicit-function-declaration]
     199 |                             cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL))
         |                             ^~~~~~~~~~~~~~~~~
         |                             cpu_have_feature


vim +199 lib/crypto/x86/chacha.h

   180	
   181	#define chacha_mod_init_arch chacha_mod_init_arch
   182	static void chacha_mod_init_arch(void)
   183	{
   184		if (!boot_cpu_has(X86_FEATURE_SSSE3))
   185			return;
   186	
   187		static_branch_enable(&chacha_use_simd);
   188	
   189		if (boot_cpu_has(X86_FEATURE_AVX) &&
   190		    boot_cpu_has(X86_FEATURE_AVX2)) {
   191			static_branch_enable(&chacha_use_avx2);
   192	
   193			if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
   194			    boot_cpu_has(X86_FEATURE_AVX512BW)) { /* kmovq */
   195				static_branch_enable(&chacha_use_avx512vl);
   196	
   197				if (boot_cpu_has(X86_FEATURE_AVX512F) &&
   198				    !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&
 > 199				    cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL))

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
