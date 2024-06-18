Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28261156F2D
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718734279; cv=none; b=IqIpU4YizDSa0TOS+3NYwL6KLmgqFndGNHi1H4sY7qpENMOFfWlDNEfc7LJ9SrX7q7HCgZtL0QD2Vo9vYI6tc2GJ7q3uLluTjTE640lOGL6EoxJECZot4y09Ej20uNCtmQr/ChdJYlhXpgoRZ03ls8G0dlxlbUkSO5gwUOBnh6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718734279; c=relaxed/simple;
	bh=nXjgX1ZtcDY8hux9Z/Rw4HshZKEqXQSD6Gemi7xNpW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d96KeGEJE5iYJj/nWmHA3E5a4Zx5ApbQZLerJ8aD2aIBC8Hr/It59c532acoPiO6GgE/eKbZ5m6T7Ow/uvLRSZN5DItuBr/nkahHTw6m31Cfp5JlZGQVuAE8hDO4QHZTEmspEfjAZPDdiPJDf8neCeIgil1TOCBIdXI9iY8Qtak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPYmXpff; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPYmXpff"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718734278; x=1750270278;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nXjgX1ZtcDY8hux9Z/Rw4HshZKEqXQSD6Gemi7xNpW4=;
  b=CPYmXpffJzjD0JLeUuuSZ50y4KKBxgtUs6NT9z2gVUuRiJbr1LDgSI3C
   qtvhdnOte3gQgB9sfXz29fMSjk81FaVUgugWGUYQrJpGgVpK+HIDBSFul
   RWH4zwPrgqqkS7QZ8wYgtvcj/y4igiV+CWgv31l7xHWWHvB2Ws6pNsi9s
   fYalxNbIGKtIsRH7dwe2npm2bwCp3BkoDKgp22QSA96+fusvvaIjJOK43
   LR0jCR4jtXp6Xd8HlpV1mH/ZfhmQ/QKcqRCsKX39OG2cLKpkDUISRagI0
   BaqWiOonEMEhEM7JElzlxUEb/AJtoOJ1g9AaEQUWR+2SVGlYDYzuwJXYB
   Q==;
X-CSE-ConnectionGUID: K9gBKMeFRdeDoKxCRQCeGw==
X-CSE-MsgGUID: HuyO6b0rQlSMXhoVq6sHRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="26218737"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="26218737"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 11:11:15 -0700
X-CSE-ConnectionGUID: 9tQZzRz1RUCROKyUgAdI9A==
X-CSE-MsgGUID: DkbKC6SgQq2LcNeN4Dh4EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="41591160"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 18 Jun 2024 11:11:13 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sJdIV-0005ni-0Q;
	Tue, 18 Jun 2024 18:11:11 +0000
Date: Wed, 19 Jun 2024 02:10:24 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v4 7/7] Enable Driver compilation in crypto Kconfig and
 Makefile
Message-ID: <202406190117.ogrwpVBI-lkp@intel.com>
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
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20240619/202406190117.ogrwpVBI-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 78ee473784e5ef6f0b19ce4cb111fb6e4d23c6b2)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240619/202406190117.ogrwpVBI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406190117.ogrwpVBI-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/crypto/dwc-spacc/spacc_core.c:6:
   In file included from include/linux/interrupt.h:21:
   In file included from arch/riscv/include/asm/sections.h:9:
   In file included from include/linux/mm.h:2253:
   include/linux/vmstat.h:514:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     514 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/crypto/dwc-spacc/spacc_core.c:998:2: error: call to '__compiletime_assert_287' declared with 'error' attribute: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
     998 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
         |         ^
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:487:2: note: expanded from macro 'compiletime_assert'
     487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:475:2: note: expanded from macro '_compiletime_assert'
     475 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:468:4: note: expanded from macro '__compiletime_assert'
     468 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:90:1: note: expanded from here
      90 | __compiletime_assert_287
         | ^
>> drivers/crypto/dwc-spacc/spacc_core.c:998:2: error: call to '__compiletime_assert_287' declared with 'error' attribute: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_DEBUG_SG)
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:487:2: note: expanded from macro 'compiletime_assert'
     487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:475:2: note: expanded from macro '_compiletime_assert'
     475 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:468:4: note: expanded from macro '__compiletime_assert'
     468 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:90:1: note: expanded from here
      90 | __compiletime_assert_287
         | ^
   1 warning and 2 errors generated.


vim +998 drivers/crypto/dwc-spacc/spacc_core.c

53fcef670e7764 Pavitrakumar M 2024-06-18   984  
7b7fdb79292ddd Pavitrakumar M 2024-06-18   985  /*
7b7fdb79292ddd Pavitrakumar M 2024-06-18   986   * This hack implements SG chaining in a way that works around some
7b7fdb79292ddd Pavitrakumar M 2024-06-18   987   * limitations of Linux -- the generic sg_chain function fails on ARM, and
7b7fdb79292ddd Pavitrakumar M 2024-06-18   988   * the scatterwalk_sg_chain function creates chains that cannot be DMA mapped
7b7fdb79292ddd Pavitrakumar M 2024-06-18   989   * on x86.  So this one is halfway inbetween, and hopefully works in both
7b7fdb79292ddd Pavitrakumar M 2024-06-18   990   * environments.
7b7fdb79292ddd Pavitrakumar M 2024-06-18   991   *
7b7fdb79292ddd Pavitrakumar M 2024-06-18   992   * Unfortunately, if SG debugging is enabled the scatterwalk code will bail
7b7fdb79292ddd Pavitrakumar M 2024-06-18   993   * on these chains, but it will otherwise work properly.
7b7fdb79292ddd Pavitrakumar M 2024-06-18   994   */
7b7fdb79292ddd Pavitrakumar M 2024-06-18   995  static inline void spacc_sg_chain(struct scatterlist *sg1, int num,
7b7fdb79292ddd Pavitrakumar M 2024-06-18   996  				  struct scatterlist *sg2)
7b7fdb79292ddd Pavitrakumar M 2024-06-18   997  {
7b7fdb79292ddd Pavitrakumar M 2024-06-18  @998  	BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
7b7fdb79292ddd Pavitrakumar M 2024-06-18   999  	sg_chain(sg1, num, sg2);
7b7fdb79292ddd Pavitrakumar M 2024-06-18  1000  	sg1[num - 1].page_link |= 1;
7b7fdb79292ddd Pavitrakumar M 2024-06-18  1001  }
7b7fdb79292ddd Pavitrakumar M 2024-06-18  1002  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
