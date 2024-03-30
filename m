Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101F71FA2
	for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 00:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711759277; cv=none; b=Eu7bXNIyVGXVvDwIWO8m6y8y8+4tp5H74eL8thSgFl2Y2YmsmA7RS61ZxddiwsdFwljUHtSpkVf6MTWNbT0I1sAl4RU9PnJAD3fhfB4DoghwBUg5RnTCrZQDOMQhx/Qo6rPMn59qtFVCz1NXCWTmgonew5feY0dKLC32Zrb5WRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711759277; c=relaxed/simple;
	bh=mcDTpowYshD4DGU5391WczKLG+u3QNgGqnYHf6aDL/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmVWwkR52tSKwZwbbPGdQJi8RgWrEzfGjKqOXSyfJfn0umpaR7tSqxVzSaW/iMHd6+o0GYqljOvSErdxrMpjHKEzrZqq2WVAdjZt/+RaFlGp4trMXpj5xHlrgTpgbZHUWzDLwS0SBkLfgResoJvhPfAaPRm0Nx/+fAcgDxZ3KCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kHlSQkMH; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kHlSQkMH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711759276; x=1743295276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mcDTpowYshD4DGU5391WczKLG+u3QNgGqnYHf6aDL/8=;
  b=kHlSQkMHSS777Jazy3g2HiXXsMZWodwnAd+imbet47mxkykmTN6D131S
   KJEJxCwgDerGVxZJURLaCxkQ7cBH/neeZvXnRLfEFsUR9WcvFMCusQoCo
   /sjx1u0tHvF/YEVYWGwIv6Hixgo9kwVYhDYjQXYW8kHn1pPE1H/9XfW16
   BXrGTGZ10BwnxovwbNLauUIiEGx8fIA53NDRejqKGq7thpbkV5tTlxMFu
   armhD6XIiYA/9GbMizmelII+kZQgsCy0sGk/cTAkvbIwR/5BU72uWU4bB
   WUAA/MKqZMC8GZKuwrRFjBkS6WjNumE47X6NBF08dRwGBMW9vB1GsMWO0
   w==;
X-CSE-ConnectionGUID: SaYp1KenTkKDx1ocQiA+Fw==
X-CSE-MsgGUID: S/bCwSfWQbC54H9YyHNlVA==
X-IronPort-AV: E=McAfee;i="6600,9927,11028"; a="18397587"
X-IronPort-AV: E=Sophos;i="6.07,166,1708416000"; 
   d="scan'208";a="18397587"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 17:41:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,166,1708416000"; 
   d="scan'208";a="17522810"
Received: from lkp-server01.sh.intel.com (HELO be39aa325d23) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 29 Mar 2024 17:41:14 -0700
Received: from kbuild by be39aa325d23 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rqMmV-0003na-06;
	Sat, 30 Mar 2024 00:41:11 +0000
Date: Sat, 30 Mar 2024 08:40:37 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v1 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202403300840.vE1pjy9E-lkp@intel.com>
References: <20240328182652.3587727-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328182652.3587727-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6a8dbd71a70620c42d4fa82509204ba18231f28d]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-driver-to-Linux-kernel/20240329-023010
base:   6a8dbd71a70620c42d4fa82509204ba18231f28d
patch link:    https://lore.kernel.org/r/20240328182652.3587727-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v1 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: mips-randconfig-r122-20240330 (https://download.01.org/0day-ci/archive/20240330/202403300840.vE1pjy9E-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 79ba323bdd0843275019e16b6e9b35133677c514)
reproduce: (https://download.01.org/0day-ci/archive/20240330/202403300840.vE1pjy9E-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403300840.vE1pjy9E-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/dwc-spacc/spacc_manager.c:135:46: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *mem @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_manager.c:135:46: sparse:     expected void volatile [noderef] __iomem *mem
   drivers/crypto/dwc-spacc/spacc_manager.c:135:46: sparse:     got void *

vim +135 drivers/crypto/dwc-spacc/spacc_manager.c

b37587c90bca57 Pavitrakumar M 2024-03-28  107  
b37587c90bca57 Pavitrakumar M 2024-03-28  108  static int spacc_ctx_release(struct spacc_device *spacc, int ctx_id)
b37587c90bca57 Pavitrakumar M 2024-03-28  109  {
b37587c90bca57 Pavitrakumar M 2024-03-28  110  	unsigned long lock_flag;
b37587c90bca57 Pavitrakumar M 2024-03-28  111  	int ncontig;
b37587c90bca57 Pavitrakumar M 2024-03-28  112  	int y;
b37587c90bca57 Pavitrakumar M 2024-03-28  113  
b37587c90bca57 Pavitrakumar M 2024-03-28  114  
b37587c90bca57 Pavitrakumar M 2024-03-28  115  	if (ctx_id < 0 || ctx_id > spacc->config.num_ctx)
b37587c90bca57 Pavitrakumar M 2024-03-28  116  		return -EINVAL;
b37587c90bca57 Pavitrakumar M 2024-03-28  117  
b37587c90bca57 Pavitrakumar M 2024-03-28  118  	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
b37587c90bca57 Pavitrakumar M 2024-03-28  119  	/* release the base context and contiguous block */
b37587c90bca57 Pavitrakumar M 2024-03-28  120  	ncontig = (&spacc->ctx[ctx_id])->ncontig;
b37587c90bca57 Pavitrakumar M 2024-03-28  121  	for (y = 0; y <= ncontig; y++) {
b37587c90bca57 Pavitrakumar M 2024-03-28  122  		if ((&spacc->ctx[ctx_id + y])->ref_cnt > 0)
b37587c90bca57 Pavitrakumar M 2024-03-28  123  			(&spacc->ctx[ctx_id + y])->ref_cnt--;
b37587c90bca57 Pavitrakumar M 2024-03-28  124  	}
b37587c90bca57 Pavitrakumar M 2024-03-28  125  
b37587c90bca57 Pavitrakumar M 2024-03-28  126  	if ((&spacc->ctx[ctx_id])->ref_cnt == 0) {
b37587c90bca57 Pavitrakumar M 2024-03-28  127  		(&spacc->ctx[ctx_id])->ncontig = 0;
b37587c90bca57 Pavitrakumar M 2024-03-28  128  #ifdef CONFIG_CRYPTO_DEV_SPACC_SECURE_MODE
b37587c90bca57 Pavitrakumar M 2024-03-28  129  		/* TODO:  This driver works in harmony with "normal" kernel
b37587c90bca57 Pavitrakumar M 2024-03-28  130  		 * processes so we release the context all the time
b37587c90bca57 Pavitrakumar M 2024-03-28  131  		 * normally this would be done from a "secure" kernel process
b37587c90bca57 Pavitrakumar M 2024-03-28  132  		 * (trustzone/etc).  This hack is so that SPACC.0
b37587c90bca57 Pavitrakumar M 2024-03-28  133  		 * cores can both use the same context space.
b37587c90bca57 Pavitrakumar M 2024-03-28  134  		 */
b37587c90bca57 Pavitrakumar M 2024-03-28 @135  		writel(ctx_id, spacc->regmap + SPACC_REG_SECURE_RELEASE);
b37587c90bca57 Pavitrakumar M 2024-03-28  136  #endif
b37587c90bca57 Pavitrakumar M 2024-03-28  137  	}
b37587c90bca57 Pavitrakumar M 2024-03-28  138  
b37587c90bca57 Pavitrakumar M 2024-03-28  139  	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
b37587c90bca57 Pavitrakumar M 2024-03-28  140  
b37587c90bca57 Pavitrakumar M 2024-03-28  141  	return CRYPTO_OK;
b37587c90bca57 Pavitrakumar M 2024-03-28  142  }
b37587c90bca57 Pavitrakumar M 2024-03-28  143  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
