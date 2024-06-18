Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9603156C6B
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718734278; cv=none; b=gazB4BpQGwojh0G3VY8dpPREiRYs0OYQkOoQzU8qAoBJXLAIohDTslPp5ueOl30YWSLGBbDYR4gWk6YCT6EnNcH37XmMrcX7/XqoDSq5vDX+t3cbOK0MklD0lSfBTObz6Qqdh7zgOEwVhZdQWgh+RBA3Ohc+S9i8YPtGnLKxHWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718734278; c=relaxed/simple;
	bh=jBoybDAiPnCVuLiqH6zRlwSnd4KssV1Llwy2FF6H7os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gta1cjJSAZM824JfghCxEst/9q5AWnjFel+EgE8wvXnAFbWtx8EmHdXbdIOWTD/grbA8utKu91cuLgqhHHG+qFXQGLw/4LLe53kzL+yS2QZnX1Sq43th2TnR0uj7xqXYzUvlxMKzL9ZisXwJSpoiTtBIpUIDzjn04KmPJJocms8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ds8LYlsz; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ds8LYlsz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718734275; x=1750270275;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jBoybDAiPnCVuLiqH6zRlwSnd4KssV1Llwy2FF6H7os=;
  b=ds8LYlszbmO3rLRe5ht7leMISHCk24bX3Iwud5nK8F7qFt4BXtVz6pam
   mS/0k+kMGb38pKarlwgmz/d4LesoN9tzMxq7lNcJvcG9RUQmpbfIXhxJA
   OM9zxkqn8pHIhM4q0G3aBw/QKnbeGWkIAzjBZ5zeU0DyDqqPq+aZBKVo0
   Dt5HASlvxwXDIaJ5Y4DlKhcbbr9RMOuL6DuqGrinkkeiRtGdvymxbdtGV
   8AXCdZuIjqtIFUMejVImam4LdmmvRN2waiEERobMHIN+80gnLobe+wB2j
   dnmDbDiANCJ1he/rO3dcm04QeguisVpggXiPMVVs75Owm5mZ6l7mLb/Ir
   g==;
X-CSE-ConnectionGUID: Hn/duE2/QOerMfdbVflSBw==
X-CSE-MsgGUID: tGJekwdfQJeWpgvEVj6Ynw==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15767048"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="15767048"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 11:11:15 -0700
X-CSE-ConnectionGUID: kp9EhoKaQFOUwmJ2WKfSvg==
X-CSE-MsgGUID: A7ZjQMqtRrSImsXL+ggvEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="46594168"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 18 Jun 2024 11:11:13 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sJdIV-0005nq-0i;
	Tue, 18 Jun 2024 18:11:11 +0000
Date: Wed, 19 Jun 2024 02:10:25 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v4 7/7] Enable Driver compilation in crypto Kconfig and
 Makefile
Message-ID: <202406190133.NR6c5fKB-lkp@intel.com>
References: <20240618042750.485720-8-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618042750.485720-8-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build errors:

[auto build test ERROR on 1dcf865d3bf5bff45e93cb2410911b3428dacb78]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-Skcipher-support/20240618-123149
base:   1dcf865d3bf5bff45e93cb2410911b3428dacb78
patch link:    https://lore.kernel.org/r/20240618042750.485720-8-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v4 7/7] Enable Driver compilation in crypto Kconfig and Makefile
config: arc-randconfig-001-20240619 (https://download.01.org/0day-ci/archive/20240619/202406190133.NR6c5fKB-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240619/202406190133.NR6c5fKB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406190133.NR6c5fKB-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'spacc_sg_chain',
       inlined from 'fixup_sg' at drivers/crypto/dwc-spacc/spacc_core.c:1030:4,
       inlined from 'spacc_sgs_to_ddt' at drivers/crypto/dwc-spacc/spacc_core.c:1059:16:
>> include/linux/compiler_types.h:487:45: error: call to '__compiletime_assert_234' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
     487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:468:25: note: in definition of macro '__compiletime_assert'
     468 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:487:9: note: in expansion of macro '_compiletime_assert'
     487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:998:9: note: in expansion of macro 'BUILD_BUG_ON'
     998 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
         |         ^~~~~~~~~~~~
   In function 'spacc_sg_chain',
       inlined from 'fixup_sg' at drivers/crypto/dwc-spacc/spacc_core.c:1030:4,
       inlined from 'spacc_sg_to_ddt' at drivers/crypto/dwc-spacc/spacc_core.c:1109:15:
>> include/linux/compiler_types.h:487:45: error: call to '__compiletime_assert_234' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
     487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:468:25: note: in definition of macro '__compiletime_assert'
     468 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:487:9: note: in expansion of macro '_compiletime_assert'
     487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/crypto/dwc-spacc/spacc_core.c:998:9: note: in expansion of macro 'BUILD_BUG_ON'
     998 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_234 +487 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  473  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  474  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  475  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  476  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  477  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  478   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  479   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  480   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  481   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  482   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  483   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  484   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  485   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  486  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @487  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  488  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
