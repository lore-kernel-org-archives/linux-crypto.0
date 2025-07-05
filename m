Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDA11DE8BB;
	Sat,  5 Jul 2025 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751727011; cv=none; b=KvfdfUSEUyYu7ZaMh+d0TSdwp4SmyhkH/v0YmzVRyqvPuMPvkpWsaLwuKdKjsBskw/cZzQbV314hMNTJbARAiyi057j2bWXj3BxkbUibEwKoG5J/WL6pxvYT1Z2k6agMEM/VNxOqACu06hXCIjcZlWu6IgjOzLjxY0sTMvDcCrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751727011; c=relaxed/simple;
	bh=8YlbuHheA6By8EjMGyLEssbYxaR6FFh/g8IrjzNaAzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8OzPyK/hEpn+rEIm/jqAIlzRUCwPpfvgubRYGJpONBbEjgWHPzTHzh1vBN58gZuaPmMDdXpsuaCJSvsa7nQBxwGZ/50POL7fPYpEssQXhy8vOhaHPrk5m696icCHPD7J3dDLMGK9HoAV0G6DU9B17hKbWWwXjo2ZnAZXSY8hCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrU0kt/t; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrU0kt/t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751727010; x=1783263010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8YlbuHheA6By8EjMGyLEssbYxaR6FFh/g8IrjzNaAzk=;
  b=PrU0kt/tF/hl6/S39hT382+2Rsjc83z/SwWJs0bNaDdcwEmlzAaS5Fxt
   qWcJG+YPUxfsEYl+boXGMYk/Wc3oe2rIAzozmJ2EIiggRIFin4dxpsZEi
   sHkzDDlyQEQmvIAckdRlFEOIlL9KaX7tEhyKRfm/g3jnlGCSBoJOyHw/T
   /nn2/q21nuUklHN6xRMJoCU9PV2UGdzi8cSh/lIZB3piOOxSNZBixPEFg
   KPlOC011LRnvUz1PA2fBQfKxsYu7kE7J6I6FE47qnl9CkDOoMa0cdGHbq
   D0KygpaTLE0zPDLevDMUJ82weY568fARPe3Wrby3jA5x1lgyWuwBJdR+J
   A==;
X-CSE-ConnectionGUID: vl1YKZHBS3e4r81w3c+ldA==
X-CSE-MsgGUID: tIas2Ag0QM2uzxixNr9XLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11485"; a="53892868"
X-IronPort-AV: E=Sophos;i="6.16,290,1744095600"; 
   d="scan'208";a="53892868"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2025 07:50:10 -0700
X-CSE-ConnectionGUID: GIk3FXhdQ3GQSiZkuPc/ug==
X-CSE-MsgGUID: mf2246VSSWKHafcH/0/rRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,290,1744095600"; 
   d="scan'208";a="154477300"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 05 Jul 2025 07:50:03 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uY4DJ-0004Y7-2E;
	Sat, 05 Jul 2025 14:50:01 +0000
Date: Sat, 5 Jul 2025 22:49:02 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosry.ahmed@linux.dev, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: oe-kbuild-all@lists.linux.dev, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com, kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v10 10/25] crypto: iaa - Rearchitect the iaa_crypto
 driver to be usable by zswap and zram.
Message-ID: <202507052222.LbMGkyWl-lkp@intel.com>
References: <20250704042323.10318-11-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704042323.10318-11-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master akpm-mm/mm-everything linus/master v6.16-rc4 next-20250704]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-iaa-Reorganize-the-iaa_crypto-driver-code/20250704-122613
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250704042323.10318-11-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v10 10/25] crypto: iaa - Rearchitect the iaa_crypto driver to be usable by zswap and zram.
config: x86_64-randconfig-123-20250704 (https://download.01.org/0day-ci/archive/20250705/202507052222.LbMGkyWl-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250705/202507052222.LbMGkyWl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507052222.LbMGkyWl-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   drivers/crypto/intel/iaa/iaa_crypto_main.c:98:1: sparse: sparse: symbol 'first_wq_found_lock' was not declared. Should it be static?
>> drivers/crypto/intel/iaa/iaa_crypto_main.c:100:12: sparse: sparse: symbol 'iaa_compression_mode_names' was not declared. Should it be static?
>> drivers/crypto/intel/iaa/iaa_crypto_main.c:104:12: sparse: sparse: symbol 'iaa_compression_alg_names' was not declared. Should it be static?

vim +/iaa_compression_mode_names +100 drivers/crypto/intel/iaa/iaa_crypto_main.c

    99	
 > 100	const char *iaa_compression_mode_names[IAA_COMP_MODES_MAX] = {
   101		"fixed",
   102	};
   103	
 > 104	const char *iaa_compression_alg_names[IAA_COMP_MODES_MAX] = {
   105		"deflate-iaa",
   106	};
   107	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
