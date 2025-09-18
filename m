Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15391DFD8B;
	Thu, 18 Sep 2025 01:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758158512; cv=none; b=QZsVxBjK6fpz1ou8vhn4sn6TpjM5rqWnMTu6PLizSyruCknNN2rFSH2SN6m/s9UNj5oS5hz9egpMv6O0v14tyPig4okIo36zz0fnnQepA37qqhk+gWYceQzI1mwmX1BpW/aVBpjAj7EysQuzb5XmVCl8C6sE1tqaC93BjiUwgzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758158512; c=relaxed/simple;
	bh=Vy8OK5kJzvHuwLBFfSz7rPqR5X9KlVDHhZG5vHMcUIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUtavrQCM+AFmUrk9bvUuhVrPhs1C2+m/lJjyaLHwOR9IJ35tHAoaAbd3XvpUMAverOzFqr4EiXjIiRqDxmCRCSOQRKlUpQyZkJJ0nT336uxR4krx8JsP8ZhMal670s4V5HcvMsNHhPDBJ58XaJqBTG+w1bxJlrz5aH3N8k8P9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfGmB311; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfGmB311"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758158510; x=1789694510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vy8OK5kJzvHuwLBFfSz7rPqR5X9KlVDHhZG5vHMcUIs=;
  b=dfGmB311H4M6r0VMv/1nqYxNBupkAOgtCuorAtkCrFrG/azQuY58143i
   Da/w9+KPcILu+eMNQopDC2XjmnSlLUw8LW/5aFngrb4Oq5lH5Dxp+WItg
   vWVe3H0jFbLaikDeNOWEhqivHPj6apxIxwEhUtxrS3XOLvhXYWatIGNv+
   cZ4e18jxZSXKurdVLPZuv728ncguoWEAJvl7sMvbdNf8JRZBoulTYeXjG
   8PWbdxPMm7rF2ygRuzcOWG/0fUTiKod903Ce+Esz4EZd8jKTCpV6bU8yu
   Px7JxhYuAB6AMEYppeQB2BsaLpTqokbIsR7DZIS+6eRrlJ5KtBH56pHVf
   w==;
X-CSE-ConnectionGUID: qaOgTSCHRZqwAiSxUalQkw==
X-CSE-MsgGUID: x08yL8zyRNuVSjauJ+Gmpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60627997"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="60627997"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 18:21:49 -0700
X-CSE-ConnectionGUID: 5pkUIZn2Q/6Mbe2PH99Gtw==
X-CSE-MsgGUID: wGtr9egyR3ugRJzUk/HTmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="175477862"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 17 Sep 2025 18:21:43 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz3LA-0002cJ-1Y;
	Thu, 18 Sep 2025 01:21:40 +0000
Date: Thu, 18 Sep 2025 09:21:23 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, andy@kernel.org,
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com,
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v1 03/10] kfuzztest: implement core module and input
 processing
Message-ID: <202509180855.TT6uHpiC-lkp@intel.com>
References: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250917]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-4-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 03/10] kfuzztest: implement core module and input processing
config: x86_64-randconfig-r112-20250918 (https://download.01.org/0day-ci/archive/20250918/202509180855.TT6uHpiC-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509180855.TT6uHpiC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509180855.TT6uHpiC-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/kfuzztest/main.c:65:15: sparse: sparse: symbol 'KFUZZTEST_INPUT_PERMS' was not declared. Should it be static?
>> lib/kfuzztest/main.c:66:15: sparse: sparse: symbol 'KFUZZTEST_MINALIGN_PERMS' was not declared. Should it be static?

vim +/KFUZZTEST_INPUT_PERMS +65 lib/kfuzztest/main.c

    64	
  > 65	const umode_t KFUZZTEST_INPUT_PERMS = 0222;
  > 66	const umode_t KFUZZTEST_MINALIGN_PERMS = 0444;
    67	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
