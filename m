Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B6A1AADB
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 06:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709707396; cv=none; b=HLTkd17y+Fp3u7V7ML9zCJ6XLcBExRh4+8BdDXem5ZZ75hjEhNm2EGSkt2COs+M3GnSryv4NLJrr01k3Txhif3ydMuVaiNXguwOWn47vwz0mIkkLFxXUjgiRcqAK02kJLW4SmgvKlAkdw/5cVrU55Vi/Oh9O4XkUpq6aa430Bw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709707396; c=relaxed/simple;
	bh=tllpSW3ytqOpaPanRYnqU4KOP6S6nWY4KMK8UEqLVfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZUrUk2Ob5p4x+AYM7E6u1v/oPsFDtMAxVKs0pNNYJ55galYFdQ5481XgsCnoD9gv9c92NKDmeoqXVFnOlwnKaGsksGo382XVyu6pelIC0zOVoU+rEfgu/5io2ayD2OQQepRVo5bY077eXnMCkp8bh+uxYsghA3oQNLbQz6kE58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INMuYuf3; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INMuYuf3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709707395; x=1741243395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tllpSW3ytqOpaPanRYnqU4KOP6S6nWY4KMK8UEqLVfs=;
  b=INMuYuf3z2mdUycya2sollr5fCUYSprJBDB0zNKoetH6RSelNemi43KE
   SZu+4OKmrVLK0OOXAR8XGtR9YXnwfBX4c99AvmOtltaHT5fpAxKCx8NP3
   eMk9NQ0LF5bvyhlb+Ry6ZlfOslm/ktn6owHX8xvrzNBx1N80ioDqDIkE/
   qok+Q2LGuLT9Ga8DzBQQ+1D51Q5aFm5Zx0H5y7VbFiRklLD3YZn8iKpCR
   R2mApLfesY9hzPktU7He8Sz/fs863SdpojzrN9tpBr5RwD/NIw5WlC7Qq
   jv1UntvVCn1ucucxtE2DRH6lwv68X8kO3koUssQTwnn5dqTOBnMX4fIyd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="14880144"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="14880144"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 22:43:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="14208517"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Mar 2024 22:43:12 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rhkze-0003zp-07;
	Wed, 06 Mar 2024 06:43:10 +0000
Date: Wed, 6 Mar 2024 14:43:02 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202403061413.rdjPqkel-lkp@intel.com>
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
config: csky-randconfig-r071-20240306 (https://download.01.org/0day-ci/archive/20240306/202403061413.rdjPqkel-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240306/202403061413.rdjPqkel-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403061413.rdjPqkel-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/dwc-spacc/spacc_core.c:2835:56: warning: 'reg_names' defined but not used [-Wunused-const-variable=]
    2835 | static const struct { unsigned int addr; char *name; } reg_names[] = {
         |                                                        ^~~~~~~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:1395:12: warning: 'spacc_set_auxinfo' defined but not used [-Wunused-function]
    1395 | static int spacc_set_auxinfo(struct spacc_device *spacc, int jobid, uint32_t
         |            ^~~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:984:26: warning: 'names' defined but not used [-Wunused-const-variable=]
     984 | static const char *const names[] = {
         |                          ^~~~~
   In file included from <command-line>:
   In function 'spacc_sg_chain',
       inlined from 'fixup_sg' at drivers/crypto/dwc-spacc/spacc_core.c:1115:4,
       inlined from 'spacc_sgs_to_ddt' at drivers/crypto/dwc-spacc/spacc_core.c:1144:16:
   include/linux/compiler_types.h:435:45: error: call to '__compiletime_assert_240' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
     435 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:416:25: note: in definition of macro '__compiletime_assert'
     416 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:435:9: note: in expansion of macro '_compiletime_assert'
     435 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:1082:9: note: in expansion of macro 'BUILD_BUG_ON'
    1082 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
         |         ^~~~~~~~~~~~
   In function 'spacc_sg_chain',
       inlined from 'fixup_sg' at drivers/crypto/dwc-spacc/spacc_core.c:1115:4,
       inlined from 'spacc_sg_to_ddt' at drivers/crypto/dwc-spacc/spacc_core.c:1252:15:
   include/linux/compiler_types.h:435:45: error: call to '__compiletime_assert_240' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
     435 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:416:25: note: in definition of macro '__compiletime_assert'
     416 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:435:9: note: in expansion of macro '_compiletime_assert'
     435 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:1082:9: note: in expansion of macro 'BUILD_BUG_ON'
    1082 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
         |         ^~~~~~~~~~~~


vim +/spacc_set_auxinfo +1395 drivers/crypto/dwc-spacc/spacc_core.c

6ad822cec22644 Pavitrakumar M 2024-03-05  1394  
6ad822cec22644 Pavitrakumar M 2024-03-05 @1395  static int spacc_set_auxinfo(struct spacc_device *spacc, int jobid, uint32_t
6ad822cec22644 Pavitrakumar M 2024-03-05  1396  		direction, uint32_t bitsize)
6ad822cec22644 Pavitrakumar M 2024-03-05  1397  {
6ad822cec22644 Pavitrakumar M 2024-03-05  1398  	int ret = CRYPTO_OK;
6ad822cec22644 Pavitrakumar M 2024-03-05  1399  	struct spacc_job *job;
6ad822cec22644 Pavitrakumar M 2024-03-05  1400  
6ad822cec22644 Pavitrakumar M 2024-03-05  1401  	if (jobid < 0 || jobid > SPACC_MAX_JOBS)
6ad822cec22644 Pavitrakumar M 2024-03-05  1402  		return -ENXIO;
6ad822cec22644 Pavitrakumar M 2024-03-05  1403  
6ad822cec22644 Pavitrakumar M 2024-03-05  1404  	job = &spacc->job[jobid];
6ad822cec22644 Pavitrakumar M 2024-03-05  1405  	if (!job) {
6ad822cec22644 Pavitrakumar M 2024-03-05  1406  		ret = -EIO;
6ad822cec22644 Pavitrakumar M 2024-03-05  1407  	} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  1408  		job->auxinfo_dir = direction;
6ad822cec22644 Pavitrakumar M 2024-03-05  1409  		job->auxinfo_bit_align = bitsize;
6ad822cec22644 Pavitrakumar M 2024-03-05  1410  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  1411  
6ad822cec22644 Pavitrakumar M 2024-03-05  1412  	return ret;
6ad822cec22644 Pavitrakumar M 2024-03-05  1413  }
6ad822cec22644 Pavitrakumar M 2024-03-05  1414  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
