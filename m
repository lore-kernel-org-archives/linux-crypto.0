Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2E82DC781;
	Thu,  1 May 2025 05:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746076201; cv=none; b=HV6IuD0hUkZde78II/GPUoaF7yY4c/3FF1cnc2uFaI+RdegYVIKDNIC+GgjV6wf+HwtOaiqI62RcsYZiohaqfSuOwm9l1xhhV5bn7ye+3aFNZwYCaNN0eXsDqOU+mbxHgJjCi/KPLYuNFj4sLHuS+8nqQ6vu0emegI4VVfIYWzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746076201; c=relaxed/simple;
	bh=4D0v6q2FPCydzL2tI0QPpq6lmvFlFvq+AVNj4AcB2co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/Z/bbyyC6pAj3Tqh2k1L/tKH73X5NfxhVmcy/lGQMnTKLT1XcSde80BelkbN66khNpIPF7nR+P5gzWqgGv0TgfuHEvB0scRwCFBg4PxbGcmkFqXd2V10WQ3Ni8DlnqYmzHx3Suejp/XTeiTxv55n+em62IyI28fWiLfvJmCvs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GgIzyP10; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GgIzyP10"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746076198; x=1777612198;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4D0v6q2FPCydzL2tI0QPpq6lmvFlFvq+AVNj4AcB2co=;
  b=GgIzyP10VngoBRLBpa5ciEZtF7j4yKmS3VpqgLZzqMuewcA8xD9n4YTW
   xG3U0ifCQoXH6sQliYqleesluvWsmQhHyQU9J/D0G7KYSz1PETllBvpzd
   Lmt5n34nq3S0+LVdfzT3fZkZ3OO70cF/ATp5Aetrvk4vTcRSRXfxCMUZ3
   saYBIlMs5ZAnwbGG22Bn2h+/5iek1VKymSScpVBfGnihpufgypy5ffifz
   70Fn+6reFu216yhCX31yf6PYRriP6V6j2TqEPO7h+LDvjjje0zNUrGVnp
   EtuE+Op1tkvQJn7SzYY+qF8fxFf02xmbmQwoQp8upATv++cUnu1bnhlbC
   A==;
X-CSE-ConnectionGUID: D6VcjS+4R2KEk59ZwUZlvA==
X-CSE-MsgGUID: MJ0DnTx2ToyGRcw1tO7Alg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="47658806"
X-IronPort-AV: E=Sophos;i="6.15,253,1739865600"; 
   d="scan'208";a="47658806"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 22:09:58 -0700
X-CSE-ConnectionGUID: GLbqYsz4QjmN398xDP7Kzg==
X-CSE-MsgGUID: DSoubaDoRLeGAKkvNDuB8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,253,1739865600"; 
   d="scan'208";a="135269143"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 30 Apr 2025 22:09:52 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uAMBB-0003yj-23;
	Thu, 01 May 2025 05:09:49 +0000
Date: Thu, 1 May 2025 13:09:38 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosry.ahmed@linux.dev, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com
Cc: oe-kbuild-all@lists.linux.dev, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com, kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v9 18/19] mm: zswap: zswap_store() will process a folio
 in batches.
Message-ID: <202505011147.h3jgtfmE-lkp@intel.com>
References: <20250430205305.22844-19-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430205305.22844-19-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build errors:

[auto build test ERROR on 2c01d9f3c61101355afde90dc5c0b39d9a772ef3]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Remove-request-chaining/20250501-045602
base:   2c01d9f3c61101355afde90dc5c0b39d9a772ef3
patch link:    https://lore.kernel.org/r/20250430205305.22844-19-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v9 18/19] mm: zswap: zswap_store() will process a folio in batches.
config: arc-randconfig-001-20250501 (https://download.01.org/0day-ci/archive/20250501/202505011147.h3jgtfmE-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250501/202505011147.h3jgtfmE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505011147.h3jgtfmE-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   mm/zswap.c: In function 'zswap_store':
>> include/linux/compiler_types.h:557:45: error: call to '__compiletime_assert_394' declared with attribute error: min(start + batch_size, nr_pages) signedness error
     557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:538:25: note: in definition of macro '__compiletime_assert'
     538 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:557:9: note: in expansion of macro '_compiletime_assert'
     557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:93:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
         |         ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:98:9: note: in expansion of macro '__careful_cmp_once'
      98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
     105 | #define min(x, y)       __careful_cmp(min, x, y)
         |                         ^~~~~~~~~~~~~
   mm/zswap.c:1703:23: note: in expansion of macro 'min'
    1703 |                 end = min(start + batch_size, nr_pages);
         |                       ^~~


vim +/__compiletime_assert_394 +557 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  543  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  544  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  545  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  546  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  547  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  548   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  549   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  550   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  551   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  552   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  553   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  554   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  555   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  556  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @557  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
