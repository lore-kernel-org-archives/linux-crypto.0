Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949943947B5
	for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2026 06:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785996466; cv=none; b=adie0lTwvfRumKOP69xp3sLU48qptGt9QR47PdRVt2aVoJdOFpETy993GMDKaqAlz4g1YRuEIHACizSZsftlFVmNFHz9jfm1JqFo9zJS/5vJdUYtNulh3FBD5enoLJMcgVhcOZptseFd8+NYam/zloXBgFsvGpcwwWCb10TKpTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785996466; c=relaxed/simple;
	bh=v0Vty1WCA7o4zhVkCWk9tgpYzthQQ3OkiuiM7lYmm/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwxCXyGSHcveAV7XbsoIVK1S7t/FGJMXAz+LLuX9nIdZl4e6UEzCjperDD8yRd2UBH4gUCC5SjH4mdzqjwj91Fy4By6/j9X85EJb4kAuV8NX3pwFk6+MD8XqjZ9O/DlUe84eMHkzORIGe9mTknYrmwm1BhPgw3KFRgTvmI83GCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EmWa5KnI; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EmWa5KnI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785996456; x=1817532456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v0Vty1WCA7o4zhVkCWk9tgpYzthQQ3OkiuiM7lYmm/U=;
  b=EmWa5KnIiRiT9IHBej6SnQCBLRrah3AgN4aLJZkR/RsNgm+1K2H55bC7
   Cvc8W6B+Qzi76r+7hENRCGUb8TL7YPdZi+S4zBxewzS694PdH/LKZ+MYI
   /yFkh0RRQ9ZiOLjj+K+x/voRFCdN+Pl8PAujW9YPnwVVpqqHJ+ekK1I55
   g9gTUsmwZaN+On65JUeBbDQIoYviUaq1+KAiefomvYQEkVYlfbXH644JC
   JhlnukPap7ALwkwCwg98JIf7zQTalI0/JSbAJBNVFKK76XlRVq9gKjmA+
   52JxYVkl3S3t/9nX30cmnGODdQz6Mit3eeWmB0XXAmYDgs83moEIOegk9
   Q==;
X-CSE-ConnectionGUID: OquLGIg+RKmDOZPTZC9iyg==
X-CSE-MsgGUID: A3NB2W8fTG2OlL94hi9HAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="86608887"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="86608887"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 23:07:35 -0700
X-CSE-ConnectionGUID: MIFC1WhyTqS+SwtwaqxGeg==
X-CSE-MsgGUID: Ah/cQnNSTmmAVhgoZP+Hcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="291931325"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 05 Aug 2026 23:07:33 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrrGM-00000000EL7-3bd9;
	Thu, 06 Aug 2026 06:07:30 +0000
Date: Thu, 6 Aug 2026 14:07:11 +0800
From: kernel test robot <lkp@intel.com>
To: Martin Willi <martin@strongswan.org>,
	Eric Biggers <ebiggers@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
Message-ID: <202608061336.JeqEp1TW-lkp@intel.com>
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
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260806/202608061336.JeqEp1TW-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260806/202608061336.JeqEp1TW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608061336.JeqEp1TW-lkp@intel.com/

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
