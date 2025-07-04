Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF94501A;
	Fri,  4 Jul 2025 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751644640; cv=none; b=T2aFgHG4MzNt5ZPej8rBYHAwioRA1hAVjCbXYHjGfpEt0jNqIyZebr8+HbZTpcBe6RFuI1DUYGAU0kxsyP6uArIaHz4VY/oafvdwNIaeeByohZnKLCLxDaABnOEpWDJc9l0PBM8dxvrwcC4a/Zx0s1R06hILkIKey66ssgwiyZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751644640; c=relaxed/simple;
	bh=KwR5g9qe9ps60+YgjR6/XFGIu3jFv+pBMeR7+nYiQzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8p+h04E/gAAOQ7FOSw8LrCqTlJeP8Z7+cl8hzgvu+C0oc582U7GDvBLT41uvYf9cl14vPJXYDBCqN+dG5Er9XTXGoM78byS/Pts7ad9qXHw7iFBLwiLvEA9cVf4q/zcGnfpE+sPLHZ5egvujKEeCW3FUVBI1Df/+XsWKgxRo/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsKfPW40; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsKfPW40"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751644639; x=1783180639;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KwR5g9qe9ps60+YgjR6/XFGIu3jFv+pBMeR7+nYiQzE=;
  b=DsKfPW40QRzYNqMKhh/ElrHC9LKSgY9OpoYOtjirHBpkwR/svY7g+1ry
   mtdCTyvpO+XOidsGM1L/io6twfTOUCDzE9cBnZ1indJfovva8jYMXZhaA
   IE1fgKiF0CwqSfxdJ+tKtjuwagfUDI3z7rZa7xQDR7WyaHHsiiyEMSPvS
   cMOVnU9A7e1rD5ZjZCR9pTITW170FNDlT7xWORTEbmuM9GO98GNbVTnDJ
   ozZQEkbEJcamKse1nPq0rQwQwu9gbaJ2x8BPnC83oWfRYnJLDKo9r8fm1
   M91Q7oUtF/Xnf/4GeJO4PdJdB7CQ5h80rOFY6XSVXwUZMm1aSwL7FxehB
   A==;
X-CSE-ConnectionGUID: I3ivcooVTr+NKDcRzLZO4g==
X-CSE-MsgGUID: KIryPaYpRTioVrVHkCXoEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11484"; a="79421301"
X-IronPort-AV: E=Sophos;i="6.16,287,1744095600"; 
   d="scan'208";a="79421301"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 08:57:17 -0700
X-CSE-ConnectionGUID: LlGoivA0SYalknVTk342qA==
X-CSE-MsgGUID: qlh1fCFKTHuFfvi/Myn5DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,287,1744095600"; 
   d="scan'208";a="158699194"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 04 Jul 2025 08:57:12 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uXimj-0003rB-2T;
	Fri, 04 Jul 2025 15:57:09 +0000
Date: Fri, 4 Jul 2025 23:56:53 +0800
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
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v10 10/25] crypto: iaa - Rearchitect the iaa_crypto
 driver to be usable by zswap and zram.
Message-ID: <202507050102.v288TUAS-lkp@intel.com>
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
config: x86_64-randconfig-004-20250704 (https://download.01.org/0day-ci/archive/20250705/202507050102.v288TUAS-lkp@intel.com/config)
compiler: clang version 20.1.7 (https://github.com/llvm/llvm-project 6146a88f60492b520a36f8f8f3231e15f3cc6082)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250705/202507050102.v288TUAS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507050102.v288TUAS-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/crypto/intel/iaa/iaa_crypto_main.c:2347:30: warning: variable 'ctx' set but not used [-Wunused-but-set-variable]
    2347 |         struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
         |                                     ^
   1 warning generated.


vim +/ctx +2347 drivers/crypto/intel/iaa/iaa_crypto_main.c

4d9d295bdce222 Kanchana P Sridhar 2025-07-03  2343  
2ec6761df889fd Tom Zanussi        2023-12-05  2344  static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
2ec6761df889fd Tom Zanussi        2023-12-05  2345  {
2ec6761df889fd Tom Zanussi        2023-12-05  2346  	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
2ec6761df889fd Tom Zanussi        2023-12-05 @2347  	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
2ec6761df889fd Tom Zanussi        2023-12-05  2348  
4d9d295bdce222 Kanchana P Sridhar 2025-07-03  2349  	ctx = iaa_ctx[IAA_MODE_FIXED];
0ece0d4e1175a0 Kanchana P Sridhar 2025-07-03  2350  
2ec6761df889fd Tom Zanussi        2023-12-05  2351  	return 0;
2ec6761df889fd Tom Zanussi        2023-12-05  2352  }
2ec6761df889fd Tom Zanussi        2023-12-05  2353  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
