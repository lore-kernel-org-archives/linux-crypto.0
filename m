Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE1785C5E
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 14:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931208; cv=none; b=QpYEVn8fChEE7TNv7bXY9IVe0t0QQb4zmBwOAfg3L/w1hKrTNtzLVDS91dYmqQq7MqS9WiRKwYhsOX7rdbC709G0kOURojoQg7dnmwXLcmZTuDVNXAEie3s1/jOsZTFTUX+kWLKBJJXF4RFPXLWji8QfURy/LuwEDzlga38Kdi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931208; c=relaxed/simple;
	bh=yOTeDIOUM3sRlPEUvMZUQwKSza+UxSYtDVoeicVVSN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IANfxH0QxPXKteyL9RwbWeCh4uoM6v+y1rLXJI7oaIwyqXQqBewazQsMXyYb72PtFVMuj7kBVE+ht9B5jhT2zHhDKWaVYlbT/AxamnGttqutXj8H9kZKOCO9dNSCbkUCzD9Y+KjjvK3oC4fbAt5M+ijy8DXIp8fn6xzGtEgL0to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VCQCd4P0; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VCQCd4P0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712931207; x=1744467207;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yOTeDIOUM3sRlPEUvMZUQwKSza+UxSYtDVoeicVVSN8=;
  b=VCQCd4P0kcWS83x+zFixHHDNAFkwh+gn1blaZ6S2WWtihUtlFKcsqpFR
   wrc7tWU004P2McoMWfFlyvac0Uc6H9JFQtP0/5ZteTfLS048PHoDUJgI3
   yGEFWMf5cIg8cyoxVtr/RJNMuWMEc+JHvYPOcv7KBtVnyLiQiABairtEh
   +c92Rkv6uFJglRLoL7fDRHU57Myk6gEOgz9GNpU4qGQSQ2Q3pK6oGdar1
   8CSMyqrrP95qVNKBy6K02dgbqYSQcRRqxeBgmNP1m3QSIkQUbtqIWEwC9
   b009SHP/vLMQvMBMFOfcrtIacEJsSEhcptdpJceWTE7+b8OXVpojU7ZtM
   A==;
X-CSE-ConnectionGUID: 2uKlumDgQQukJ1EYr1RyuQ==
X-CSE-MsgGUID: Vc/ym/cXSaC02FoM8J9E3Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8303718"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="8303718"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 07:13:26 -0700
X-CSE-ConnectionGUID: /VuspQ6uQp2ElXIifw10dQ==
X-CSE-MsgGUID: YMkSpEr5SBiZclxRREMrkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="26032344"
Received: from lkp-server01.sh.intel.com (HELO e61807b1d151) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 12 Apr 2024 07:13:23 -0700
Received: from kbuild by e61807b1d151 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rvHea-0009pJ-35;
	Fri, 12 Apr 2024 14:13:20 +0000
Date: Fri, 12 Apr 2024 22:12:58 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v2 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202404122115.QyB2yx7M-lkp@intel.com>
References: <20240412035342.1233930-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412035342.1233930-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 4ad27a8be9dbefd4820da0f60da879d512b2f659]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-driver-to-Linux-kernel/20240412-115552
base:   4ad27a8be9dbefd4820da0f60da879d512b2f659
patch link:    https://lore.kernel.org/r/20240412035342.1233930-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v2 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: i386-randconfig-061-20240412 (https://download.01.org/0day-ci/archive/20240412/202404122115.QyB2yx7M-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240412/202404122115.QyB2yx7M-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404122115.QyB2yx7M-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/dwc-spacc/spacc_manager.c:663:31: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected unsigned int [usertype] *ciph_key @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_manager.c:663:31: sparse:     expected unsigned int [usertype] *ciph_key
   drivers/crypto/dwc-spacc/spacc_manager.c:663:31: sparse:     got void [noderef] __iomem *
>> drivers/crypto/dwc-spacc/spacc_manager.c:665:31: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected unsigned int [usertype] *hash_key @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_manager.c:665:31: sparse:     expected unsigned int [usertype] *hash_key
   drivers/crypto/dwc-spacc/spacc_manager.c:665:31: sparse:     got void [noderef] __iomem *
--
>> drivers/crypto/dwc-spacc/spacc_core.c:1384:59: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1384:59: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1384:59: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1388:59: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1388:59: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1388:59: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1393:59: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1393:59: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1393:59: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1397:59: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1397:59: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1397:59: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1405:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1405:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1405:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1409:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1409:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1409:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1412:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1412:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1412:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1416:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1416:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1416:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1420:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1420:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1420:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1424:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1424:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1424:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1427:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1427:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1427:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:1430:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1430:51: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1430:51: sparse:     got void [noderef] __iomem *
   drivers/crypto/dwc-spacc/spacc_core.c:2442:52: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void *addr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2442:52: sparse:     expected void *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2442:52: sparse:     got void [noderef] __iomem *
>> drivers/crypto/dwc-spacc/spacc_core.c:2524:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __iomem *regmap @@     got void *baseaddr @@
   drivers/crypto/dwc-spacc/spacc_core.c:2524:23: sparse:     expected void [noderef] __iomem *regmap
   drivers/crypto/dwc-spacc/spacc_core.c:2524:23: sparse:     got void *baseaddr
   drivers/crypto/dwc-spacc/spacc_core.c:2646:45: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2646:45: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2646:45: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2647:45: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2647:45: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2647:45: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2648:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2648:38: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2648:38: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2650:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2650:38: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2650:38: sparse:     got void *

vim +663 drivers/crypto/dwc-spacc/spacc_manager.c

ed973f332d62f8 Pavitrakumar M 2024-04-12  646  
ed973f332d62f8 Pavitrakumar M 2024-04-12  647  /* Context manager */
ed973f332d62f8 Pavitrakumar M 2024-04-12  648  /* This will reset all reference counts, pointers, etc */
ed973f332d62f8 Pavitrakumar M 2024-04-12  649  void spacc_ctx_init_all(struct spacc_device *spacc)
ed973f332d62f8 Pavitrakumar M 2024-04-12  650  {
ed973f332d62f8 Pavitrakumar M 2024-04-12  651  	int x;
ed973f332d62f8 Pavitrakumar M 2024-04-12  652  	struct spacc_ctx *ctx;
ed973f332d62f8 Pavitrakumar M 2024-04-12  653  	unsigned long lock_flag;
ed973f332d62f8 Pavitrakumar M 2024-04-12  654  
ed973f332d62f8 Pavitrakumar M 2024-04-12  655  	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
ed973f332d62f8 Pavitrakumar M 2024-04-12  656  	/* initialize contexts */
ed973f332d62f8 Pavitrakumar M 2024-04-12  657  	for (x = 0; x < spacc->config.num_ctx; x++) {
ed973f332d62f8 Pavitrakumar M 2024-04-12  658  		ctx = &spacc->ctx[x];
ed973f332d62f8 Pavitrakumar M 2024-04-12  659  
ed973f332d62f8 Pavitrakumar M 2024-04-12  660  		/* sets everything including ref_cnt and ncontig to 0 */
ed973f332d62f8 Pavitrakumar M 2024-04-12  661  		memset(ctx, 0, sizeof(*ctx));
ed973f332d62f8 Pavitrakumar M 2024-04-12  662  
ed973f332d62f8 Pavitrakumar M 2024-04-12 @663  		ctx->ciph_key = spacc->regmap + SPACC_CTX_CIPH_KEY + (x *
ed973f332d62f8 Pavitrakumar M 2024-04-12  664  				spacc->config.ciph_page_size);
ed973f332d62f8 Pavitrakumar M 2024-04-12 @665  		ctx->hash_key = spacc->regmap + SPACC_CTX_HASH_KEY + (x *
ed973f332d62f8 Pavitrakumar M 2024-04-12  666  				spacc->config.hash_page_size);
ed973f332d62f8 Pavitrakumar M 2024-04-12  667  	}
ed973f332d62f8 Pavitrakumar M 2024-04-12  668  	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
ed973f332d62f8 Pavitrakumar M 2024-04-12  669  }
ed973f332d62f8 Pavitrakumar M 2024-04-12  670  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
