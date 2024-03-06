Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3CF15AC4
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709698155; cv=none; b=l9Pr+3mD7ZogKFx2Hng0dispy/Yf5GypoqHKWqk3UtrA2iXB28F0YOTWyOE714tns/MMlUtlNzz1w7wyEPpYI/1LAcDRhUo6oim+sSeATZcVeHjAv2eosRR62R2jDPaofIvHSCCNBgm2WVdNL7y8F83O/d/T0xLwW9b4AAntbIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709698155; c=relaxed/simple;
	bh=vHqMB6JQ1+FvxXjoYl1KJuGgVFJ6+qEZb67ZhBvA4PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r96y2fjBraCAFFjQ1jOIl+2aEqLWXGnVTuFj4GDFlemR6c4ThJyKDhBF30Z4eRiqfZofBN9k2/4nKrxjFMdKr05AudUDorzKTG7yU12dkQImMT0LXiICV+Ky9PpfpKQrj4tmBzgSmVVMp9dx7gWqV0jBE9+DR4siGQF/QbRAYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YRKmW1Pf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YRKmW1Pf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709698153; x=1741234153;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vHqMB6JQ1+FvxXjoYl1KJuGgVFJ6+qEZb67ZhBvA4PE=;
  b=YRKmW1Pfs6OAZGHNh8d76IDqb6IIKMY9JTtMSW35aNLGCCZNNgVxXSla
   0oZnFlwDkv8snAVeuJfJ/6B/hruwx9l6sajSX8P30mYGtPUfYZH11ebUt
   cJaDnEnLewADTBbpkd7l+xS2EktS/lVN4qR7rC4FvSb6a/5DoTp9kwO4q
   vEJ5vI8lhthXiGY8/JWWr+GMdLMr3iCTu8PSstkNthworNYXQBIVUwwJI
   +mbJ3P30bghT+DKMx9hU7btE7vOpm7bCGYC7aPYJrcjKnQSMOeojVCtTs
   bnfbBzoJ+4d1RmPT6NaJXKyBzCxmVMh1MSuEqa9Hzpt5le6izqlBU2/rf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4409909"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="4409909"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 20:09:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="9523185"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 05 Mar 2024 20:09:08 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rhiaY-0003tt-1e;
	Wed, 06 Mar 2024 04:09:06 +0000
Date: Wed, 6 Mar 2024 12:08:26 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202403061121.TsVV67xo-lkp@intel.com>
References: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.8-rc7 next-20240305]
[cannot apply to xilinx-xlnx/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-driver-to-Linux-kernel/20240305-193337
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20240305112831.3380896-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: x86_64-randconfig-121-20240306 (https://download.01.org/0day-ci/archive/20240306/202403061121.TsVV67xo-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240306/202403061121.TsVV67xo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403061121.TsVV67xo-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/dwc-spacc/spacc_core.c:1418:44: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1418:44: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1418:44: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:1421:44: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1421:44: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1421:44: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_core.c:1550:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1550:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1550:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:1553:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1553:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1553:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:1562:38: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1562:38: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1562:38: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:1563:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1563:49: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1563:49: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:1650:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1650:49: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1650:49: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:1651:55: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:1651:55: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:1651:55: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2513:50: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2513:50: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2513:50: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2514:50: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2514:50: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2514:50: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2515:34: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2515:34: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2515:34: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2516:34: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2516:34: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2516:34: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2517:34: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2517:34: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2517:34: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2518:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2518:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2518:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2519:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2519:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2519:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2545:63: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2545:63: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2545:63: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2550:60: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2550:60: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2550:60: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2557:65: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2557:65: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2557:65: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2560:68: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2560:68: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2560:68: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2575:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2575:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2575:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2576:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2576:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2576:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2577:42: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2577:42: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2577:42: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2579:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2579:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2579:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2580:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2580:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2580:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2581:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2581:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2581:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2582:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2582:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2582:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2583:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2583:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2583:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2689:42: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2689:42: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2689:42: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2690:58: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2690:58: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2690:58: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2698:34: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2698:34: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2698:34: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2716:42: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2716:42: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2716:42: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2742:45: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2742:45: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2742:45: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2743:45: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2743:45: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2743:45: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2744:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2744:38: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2744:38: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2746:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2746:38: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_core.c:2746:38: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_core.c:2756:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_core.c:2756:33: sparse:     expected void volatile [noderef] __iomem *addr

vim +1418 drivers/crypto/dwc-spacc/spacc_core.c

6ad822cec22644 Pavitrakumar M 2024-03-05  1414  
6ad822cec22644 Pavitrakumar M 2024-03-05  1415  static int _spacc_fifo_full(struct spacc_device *spacc, uint32_t prio)
6ad822cec22644 Pavitrakumar M 2024-03-05  1416  {
6ad822cec22644 Pavitrakumar M 2024-03-05  1417  	if (spacc->config.is_qos)
6ad822cec22644 Pavitrakumar M 2024-03-05 @1418  		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
6ad822cec22644 Pavitrakumar M 2024-03-05  1419  			SPACC_FIFO_STAT_CMDX_FULL(prio);
6ad822cec22644 Pavitrakumar M 2024-03-05  1420  	else
6ad822cec22644 Pavitrakumar M 2024-03-05  1421  		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
6ad822cec22644 Pavitrakumar M 2024-03-05  1422  			SPACC_FIFO_STAT_CMD0_FULL;
6ad822cec22644 Pavitrakumar M 2024-03-05  1423  }
6ad822cec22644 Pavitrakumar M 2024-03-05  1424  
6ad822cec22644 Pavitrakumar M 2024-03-05  1425  /* When proc_sz != 0 it overrides the ddt_len value
6ad822cec22644 Pavitrakumar M 2024-03-05  1426   * defined in the context referenced by 'job_idx'
6ad822cec22644 Pavitrakumar M 2024-03-05  1427   */
6ad822cec22644 Pavitrakumar M 2024-03-05  1428  int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb, int
6ad822cec22644 Pavitrakumar M 2024-03-05  1429  		job_idx, struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
6ad822cec22644 Pavitrakumar M 2024-03-05  1430  		u32 proc_sz, uint32_t aad_offset, uint32_t pre_aad_sz,
6ad822cec22644 Pavitrakumar M 2024-03-05  1431  		u32 post_aad_sz, uint32_t iv_offset, uint32_t prio)
6ad822cec22644 Pavitrakumar M 2024-03-05  1432  {
6ad822cec22644 Pavitrakumar M 2024-03-05  1433  	int ret = CRYPTO_OK, proc_len;
6ad822cec22644 Pavitrakumar M 2024-03-05  1434  	struct spacc_job *job;
6ad822cec22644 Pavitrakumar M 2024-03-05  1435  
6ad822cec22644 Pavitrakumar M 2024-03-05  1436  	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
6ad822cec22644 Pavitrakumar M 2024-03-05  1437  		return -ENXIO;
6ad822cec22644 Pavitrakumar M 2024-03-05  1438  
6ad822cec22644 Pavitrakumar M 2024-03-05  1439  	switch (prio)  {
6ad822cec22644 Pavitrakumar M 2024-03-05  1440  	case SPACC_SW_CTRL_PRIO_MED:
6ad822cec22644 Pavitrakumar M 2024-03-05  1441  		if (spacc->config.cmd1_fifo_depth == 0)
6ad822cec22644 Pavitrakumar M 2024-03-05  1442  			return -EINVAL;
6ad822cec22644 Pavitrakumar M 2024-03-05  1443  		break;
6ad822cec22644 Pavitrakumar M 2024-03-05  1444  	case SPACC_SW_CTRL_PRIO_LOW:
6ad822cec22644 Pavitrakumar M 2024-03-05  1445  		if (spacc->config.cmd2_fifo_depth == 0)
6ad822cec22644 Pavitrakumar M 2024-03-05  1446  			return -EINVAL;
6ad822cec22644 Pavitrakumar M 2024-03-05  1447  		break;
6ad822cec22644 Pavitrakumar M 2024-03-05  1448  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  1449  
6ad822cec22644 Pavitrakumar M 2024-03-05  1450  	job = &spacc->job[job_idx];
6ad822cec22644 Pavitrakumar M 2024-03-05  1451  	if (!job) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1452  		ret = -EIO;
6ad822cec22644 Pavitrakumar M 2024-03-05  1453  	} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1454  		/* process any jobs in the jb*/
6ad822cec22644 Pavitrakumar M 2024-03-05  1455  		if (use_jb && spacc_process_jb(spacc) != 0)
6ad822cec22644 Pavitrakumar M 2024-03-05  1456  			goto fifo_full;
6ad822cec22644 Pavitrakumar M 2024-03-05  1457  
6ad822cec22644 Pavitrakumar M 2024-03-05  1458  		if (_spacc_fifo_full(spacc, prio)) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1459  			if (use_jb)
6ad822cec22644 Pavitrakumar M 2024-03-05  1460  				goto fifo_full;
6ad822cec22644 Pavitrakumar M 2024-03-05  1461  			else
6ad822cec22644 Pavitrakumar M 2024-03-05  1462  				return -EBUSY;
6ad822cec22644 Pavitrakumar M 2024-03-05  1463  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1464  
6ad822cec22644 Pavitrakumar M 2024-03-05  1465  		/* compute the length we must process, in decrypt mode
6ad822cec22644 Pavitrakumar M 2024-03-05  1466  		 * with an ICV (hash, hmac or CCM modes)
6ad822cec22644 Pavitrakumar M 2024-03-05  1467  		 * we must subtract the icv length from the buffer size
6ad822cec22644 Pavitrakumar M 2024-03-05  1468  		 */
6ad822cec22644 Pavitrakumar M 2024-03-05  1469  		if (proc_sz == SPACC_AUTO_SIZE) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1470  			if (job->op == OP_DECRYPT &&
6ad822cec22644 Pavitrakumar M 2024-03-05  1471  			    (job->hash_mode > 0 || (job->enc_mode ==
6ad822cec22644 Pavitrakumar M 2024-03-05  1472  				    CRYPTO_MODE_AES_CCM || job->enc_mode ==
6ad822cec22644 Pavitrakumar M 2024-03-05  1473  				    CRYPTO_MODE_AES_GCM)) &&	!(job->ctrl &
6ad822cec22644 Pavitrakumar M 2024-03-05  1474  				    SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC))) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1475  				proc_len = src_ddt->len - job->icv_len;
6ad822cec22644 Pavitrakumar M 2024-03-05  1476  			} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1477  				proc_len = src_ddt->len;
6ad822cec22644 Pavitrakumar M 2024-03-05  1478  			}
6ad822cec22644 Pavitrakumar M 2024-03-05  1479  		} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1480  			proc_len = proc_sz;
6ad822cec22644 Pavitrakumar M 2024-03-05  1481  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1482  
6ad822cec22644 Pavitrakumar M 2024-03-05  1483  		if (pre_aad_sz & SPACC_AADCOPY_FLAG) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1484  			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
6ad822cec22644 Pavitrakumar M 2024-03-05  1485  			pre_aad_sz &= ~(SPACC_AADCOPY_FLAG);
6ad822cec22644 Pavitrakumar M 2024-03-05  1486  		} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1487  			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
6ad822cec22644 Pavitrakumar M 2024-03-05  1488  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1489  
6ad822cec22644 Pavitrakumar M 2024-03-05  1490  		job->pre_aad_sz  = pre_aad_sz;
6ad822cec22644 Pavitrakumar M 2024-03-05  1491  		job->post_aad_sz = post_aad_sz;
6ad822cec22644 Pavitrakumar M 2024-03-05  1492  
6ad822cec22644 Pavitrakumar M 2024-03-05  1493  		if (spacc->config.dma_type == SPACC_DMA_DDT) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1494  			pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1495  					SPACC_REG_SRC_PTR,
6ad822cec22644 Pavitrakumar M 2024-03-05  1496  					(uint32_t)src_ddt->phys,
6ad822cec22644 Pavitrakumar M 2024-03-05  1497  					&spacc->cache.src_ptr);
6ad822cec22644 Pavitrakumar M 2024-03-05  1498  			pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1499  					SPACC_REG_DST_PTR,
6ad822cec22644 Pavitrakumar M 2024-03-05  1500  					(uint32_t)dst_ddt->phys,
6ad822cec22644 Pavitrakumar M 2024-03-05  1501  					&spacc->cache.dst_ptr);
6ad822cec22644 Pavitrakumar M 2024-03-05  1502  		} else if (spacc->config.dma_type == SPACC_DMA_LINEAR) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1503  			pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1504  					SPACC_REG_SRC_PTR,
6ad822cec22644 Pavitrakumar M 2024-03-05  1505  					(uint32_t)src_ddt->virt[0],
6ad822cec22644 Pavitrakumar M 2024-03-05  1506  					&spacc->cache.src_ptr);
6ad822cec22644 Pavitrakumar M 2024-03-05  1507  			pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1508  					SPACC_REG_DST_PTR,
6ad822cec22644 Pavitrakumar M 2024-03-05  1509  					(uint32_t)dst_ddt->virt[0],
6ad822cec22644 Pavitrakumar M 2024-03-05  1510  					&spacc->cache.dst_ptr);
6ad822cec22644 Pavitrakumar M 2024-03-05  1511  		} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1512  			return -EIO;
6ad822cec22644 Pavitrakumar M 2024-03-05  1513  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1514  
6ad822cec22644 Pavitrakumar M 2024-03-05  1515  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1516  				SPACC_REG_PROC_LEN,     proc_len -
6ad822cec22644 Pavitrakumar M 2024-03-05  1517  				job->post_aad_sz,
6ad822cec22644 Pavitrakumar M 2024-03-05  1518  				&spacc->cache.proc_len);
6ad822cec22644 Pavitrakumar M 2024-03-05  1519  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1520  				SPACC_REG_ICV_LEN,      job->icv_len,
6ad822cec22644 Pavitrakumar M 2024-03-05  1521  				&spacc->cache.icv_len);
6ad822cec22644 Pavitrakumar M 2024-03-05  1522  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1523  				SPACC_REG_ICV_OFFSET,
6ad822cec22644 Pavitrakumar M 2024-03-05  1524  				job->icv_offset,
6ad822cec22644 Pavitrakumar M 2024-03-05  1525  				&spacc->cache.icv_offset);
6ad822cec22644 Pavitrakumar M 2024-03-05  1526  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1527  				SPACC_REG_PRE_AAD_LEN,
6ad822cec22644 Pavitrakumar M 2024-03-05  1528  				job->pre_aad_sz,
6ad822cec22644 Pavitrakumar M 2024-03-05  1529  				&spacc->cache.pre_aad);
6ad822cec22644 Pavitrakumar M 2024-03-05  1530  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1531  				SPACC_REG_POST_AAD_LEN,
6ad822cec22644 Pavitrakumar M 2024-03-05  1532  				job->post_aad_sz,
6ad822cec22644 Pavitrakumar M 2024-03-05  1533  				&spacc->cache.post_aad);
6ad822cec22644 Pavitrakumar M 2024-03-05  1534  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1535  				SPACC_REG_IV_OFFSET,    iv_offset,
6ad822cec22644 Pavitrakumar M 2024-03-05  1536  				&spacc->cache.iv_offset);
6ad822cec22644 Pavitrakumar M 2024-03-05  1537  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1538  				SPACC_REG_OFFSET,
6ad822cec22644 Pavitrakumar M 2024-03-05  1539  				aad_offset, &spacc->cache.offset);
6ad822cec22644 Pavitrakumar M 2024-03-05  1540  		pdu_io_cached_write(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05  1541  				SPACC_REG_AUX_INFO,
6ad822cec22644 Pavitrakumar M 2024-03-05  1542  				AUX_DIR(job->auxinfo_dir) |
6ad822cec22644 Pavitrakumar M 2024-03-05  1543  				AUX_BIT_ALIGN(job->auxinfo_bit_align) |
6ad822cec22644 Pavitrakumar M 2024-03-05  1544  				AUX_CBC_CS(job->auxinfo_cs_mode),
6ad822cec22644 Pavitrakumar M 2024-03-05  1545  				&spacc->cache.aux);
6ad822cec22644 Pavitrakumar M 2024-03-05  1546  
6ad822cec22644 Pavitrakumar M 2024-03-05  1547  		if (job->first_use == 1) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1548  			writel(job->ckey_sz |
6ad822cec22644 Pavitrakumar M 2024-03-05  1549  				SPACC_SET_KEY_CTX(job->ctx_idx),
6ad822cec22644 Pavitrakumar M 2024-03-05 @1550  				spacc->regmap + SPACC_REG_KEY_SZ);
6ad822cec22644 Pavitrakumar M 2024-03-05  1551  			writel(job->hkey_sz |
6ad822cec22644 Pavitrakumar M 2024-03-05  1552  				SPACC_SET_KEY_CTX(job->ctx_idx),
6ad822cec22644 Pavitrakumar M 2024-03-05  1553  				spacc->regmap + SPACC_REG_KEY_SZ);
6ad822cec22644 Pavitrakumar M 2024-03-05  1554  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1555  
6ad822cec22644 Pavitrakumar M 2024-03-05  1556  		job->job_swid = spacc->job_next_swid;
6ad822cec22644 Pavitrakumar M 2024-03-05  1557  		spacc->job_lookup[job->job_swid] = job_idx;
6ad822cec22644 Pavitrakumar M 2024-03-05  1558  		spacc->job_next_swid = (spacc->job_next_swid + 1) %
6ad822cec22644 Pavitrakumar M 2024-03-05  1559  			SPACC_MAX_JOBS;
6ad822cec22644 Pavitrakumar M 2024-03-05  1560  		writel(SPACC_SW_CTRL_ID_SET(job->job_swid) |
6ad822cec22644 Pavitrakumar M 2024-03-05  1561  		       SPACC_SW_CTRL_PRIO_SET(prio),
6ad822cec22644 Pavitrakumar M 2024-03-05  1562  		       spacc->regmap + SPACC_REG_SW_CTRL);
6ad822cec22644 Pavitrakumar M 2024-03-05  1563  		writel(job->ctrl, spacc->regmap + SPACC_REG_CTRL);
6ad822cec22644 Pavitrakumar M 2024-03-05  1564  
6ad822cec22644 Pavitrakumar M 2024-03-05  1565  		/* Clear an expansion key after the first call*/
6ad822cec22644 Pavitrakumar M 2024-03-05  1566  		if (job->first_use == 1) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1567  			job->first_use = 0;
6ad822cec22644 Pavitrakumar M 2024-03-05  1568  			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
6ad822cec22644 Pavitrakumar M 2024-03-05  1569  		}
6ad822cec22644 Pavitrakumar M 2024-03-05  1570  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  1571  
6ad822cec22644 Pavitrakumar M 2024-03-05  1572  
6ad822cec22644 Pavitrakumar M 2024-03-05  1573  	return ret;
6ad822cec22644 Pavitrakumar M 2024-03-05  1574  fifo_full:
6ad822cec22644 Pavitrakumar M 2024-03-05  1575  	/* try to add a job to the job buffers*/
6ad822cec22644 Pavitrakumar M 2024-03-05  1576  	{
6ad822cec22644 Pavitrakumar M 2024-03-05  1577  		int i;
6ad822cec22644 Pavitrakumar M 2024-03-05  1578  
6ad822cec22644 Pavitrakumar M 2024-03-05  1579  		i = spacc->jb_head + 1;
6ad822cec22644 Pavitrakumar M 2024-03-05  1580  		if (i == SPACC_MAX_JOB_BUFFERS)
6ad822cec22644 Pavitrakumar M 2024-03-05  1581  			i = 0;
6ad822cec22644 Pavitrakumar M 2024-03-05  1582  
6ad822cec22644 Pavitrakumar M 2024-03-05  1583  		if (i == spacc->jb_tail)
6ad822cec22644 Pavitrakumar M 2024-03-05  1584  			return -EBUSY;
6ad822cec22644 Pavitrakumar M 2024-03-05  1585  
6ad822cec22644 Pavitrakumar M 2024-03-05  1586  		spacc->job_buffer[spacc->jb_head] = (struct spacc_job_buffer) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1587  			.active		= 1,
6ad822cec22644 Pavitrakumar M 2024-03-05  1588  			.job_idx	= job_idx,
6ad822cec22644 Pavitrakumar M 2024-03-05  1589  			.src		= src_ddt,
6ad822cec22644 Pavitrakumar M 2024-03-05  1590  			.dst		= dst_ddt,
6ad822cec22644 Pavitrakumar M 2024-03-05  1591  			.proc_sz	= proc_sz,
6ad822cec22644 Pavitrakumar M 2024-03-05  1592  			.aad_offset	= aad_offset,
6ad822cec22644 Pavitrakumar M 2024-03-05  1593  			.pre_aad_sz	= pre_aad_sz,
6ad822cec22644 Pavitrakumar M 2024-03-05  1594  			.post_aad_sz	= post_aad_sz,
6ad822cec22644 Pavitrakumar M 2024-03-05  1595  			.iv_offset	= iv_offset,
6ad822cec22644 Pavitrakumar M 2024-03-05  1596  			.prio		= prio
6ad822cec22644 Pavitrakumar M 2024-03-05  1597  		};
6ad822cec22644 Pavitrakumar M 2024-03-05  1598  
6ad822cec22644 Pavitrakumar M 2024-03-05  1599  		spacc->jb_head = i;
6ad822cec22644 Pavitrakumar M 2024-03-05  1600  
6ad822cec22644 Pavitrakumar M 2024-03-05  1601  		return CRYPTO_USED_JB;
6ad822cec22644 Pavitrakumar M 2024-03-05  1602  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  1603  }
6ad822cec22644 Pavitrakumar M 2024-03-05  1604  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
