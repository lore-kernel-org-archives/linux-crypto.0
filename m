Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594071946DA;
	Thu,  1 May 2025 00:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746059414; cv=none; b=d6FTBTR3BMXAQjKG3bE+vJlxVIeAUiL/aLPI7cUTSGMt8X3ilpu/Mb31l0897VjDplYaK4zFeKUaVxZPq8kU9SvxD/9pNNB13OHDwkKTiMl6FXQOsBlDQCcxEt68Px08b2qH7EYTMwgMQML/hfwnRg739bmot6fop/CzbwTGKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746059414; c=relaxed/simple;
	bh=WqFeAZ/jYBbcn4Lyqysne4MrG0+jMo0kzk9jQZ/ULpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eam57Shw9bJXJBK3JzPte60V7VtOQoS7pXIoMQw08GkBnVdYbFKo5XxyXdc7xUAidg82kHuzRqIQ0CeJECHQyaYkez33GSHHf2M1kZEsa/6E1ko5awcYZynkrXhT8Nz2ErYNyvO+sKdcHledeCNKHQDg1TJsk5NREcMxytGO9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1xWOIcD; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1xWOIcD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746059412; x=1777595412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WqFeAZ/jYBbcn4Lyqysne4MrG0+jMo0kzk9jQZ/ULpw=;
  b=C1xWOIcDd8Gj/hqiIrFCbvOkfvKUr4nN1Gi2ywuoJAqVv9g+dM9YV8J2
   ZWKGaLvfVfR+nIWFjOfwQgA2v5E4+BOs6ZcuCpXDFsRw4lfzDAz5LN8mk
   HO/C89tVEdHzfHT36+nkC1fvyMfBq4r3kgJUtuI9QoFWgXjOzSd8YlQIb
   cDyvUX4qNKKmWvPLpVc/SgLBWU5Y5jiNszrQyRClY+sG1v7k3IcCK705s
   O0EVOczRHNa2dL6nhSL0IsgdgHSsHFo00Q+0+N/yfXKPRIxkAMi4RIkd+
   iauqfxyWJwyxWH5zv+vN/jFNtoPYiv3jZU3509ACnxDWBkBcCRWcXtmTO
   w==;
X-CSE-ConnectionGUID: yRFy2vmjSf+ClQDd9Q8TTg==
X-CSE-MsgGUID: otBB7CkyRxytpdlicQ+1Hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51559244"
X-IronPort-AV: E=Sophos;i="6.15,253,1739865600"; 
   d="scan'208";a="51559244"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 17:29:42 -0700
X-CSE-ConnectionGUID: T+7mU4vKThmDgukaOnd1JA==
X-CSE-MsgGUID: UtUhkO6FTu2QiMm8H67ZfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,253,1739865600"; 
   d="scan'208";a="134168109"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 30 Apr 2025 17:29:37 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uAHny-0003rV-2f;
	Thu, 01 May 2025 00:29:34 +0000
Date: Thu, 1 May 2025 08:29:15 +0800
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
Subject: Re: [PATCH v9 02/19] crypto: acomp - Reinstate non-chained
 crypto_acomp_[de]compress().
Message-ID: <202505010736.dy4ElGuu-lkp@intel.com>
References: <20250430205305.22844-3-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430205305.22844-3-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 2c01d9f3c61101355afde90dc5c0b39d9a772ef3]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Remove-request-chaining/20250501-045602
base:   2c01d9f3c61101355afde90dc5c0b39d9a772ef3
patch link:    https://lore.kernel.org/r/20250430205305.22844-3-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v9 02/19] crypto: acomp - Reinstate non-chained crypto_acomp_[de]compress().
config: arc-randconfig-001-20250501 (https://download.01.org/0day-ci/archive/20250501/202505010736.dy4ElGuu-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250501/202505010736.dy4ElGuu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505010736.dy4ElGuu-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> crypto/acompress.c:298:12: warning: 'acomp_do_req_chain' defined but not used [-Wunused-function]
     298 | static int acomp_do_req_chain(struct acomp_req *req, bool comp)
         |            ^~~~~~~~~~~~~~~~~~


vim +/acomp_do_req_chain +298 crypto/acompress.c

b67a026003725a5 Herbert Xu         2025-03-09  297  
1a66016d1faca1e Kanchana P Sridhar 2025-04-30 @298  static int acomp_do_req_chain(struct acomp_req *req, bool comp)
b67a026003725a5 Herbert Xu         2025-03-09  299  {
b67a026003725a5 Herbert Xu         2025-03-09  300  	int err;
b67a026003725a5 Herbert Xu         2025-03-09  301  
b67a026003725a5 Herbert Xu         2025-03-09  302  	acomp_save_req(req, acomp_reqchain_done);
b67a026003725a5 Herbert Xu         2025-03-09  303  
1a66016d1faca1e Kanchana P Sridhar 2025-04-30  304  	err = acomp_do_one_req(req, comp);
b67a026003725a5 Herbert Xu         2025-03-09  305  	if (err == -EBUSY || err == -EINPROGRESS)
1a66016d1faca1e Kanchana P Sridhar 2025-04-30  306  		return err;
b67a026003725a5 Herbert Xu         2025-03-09  307  
1a66016d1faca1e Kanchana P Sridhar 2025-04-30  308  	return acomp_reqchain_finish(req, err);
b67a026003725a5 Herbert Xu         2025-03-09  309  }
b67a026003725a5 Herbert Xu         2025-03-09  310  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
