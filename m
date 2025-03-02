Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781517E110
	for <linux-crypto@vger.kernel.org>; Sun,  2 Mar 2025 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740922618; cv=none; b=uF6xZ4SKPRLR5AJK3rzuieTQ17y8O32tAIJfK2ucPLfLrDhEB8SX5Xb95uqVo2tWFGwZzocX79ODBMpRxgWH8ayCw/MwrVRU67u73LSxUAvxCTY1c3Gy4Q4RhKq88utgGecziD4cfc+D2PRdcf67GIB1yFEzspCMDQn6CqBgJv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740922618; c=relaxed/simple;
	bh=l+zsLC8s84ltpnm1i/kPYGRjjbphM84+KlnE6PUEsxo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ETj2E1sqg5QX51PtUpSWObybX6mThOZDbYXeUc8YPVX63PAaYXL5Ggqym6/k1QbjOZvO4JYiMGzpdYSCIWVj816uz9bh3O5PYOJnWr/3KPBt9cw+ryBNLDAixTjWtMXWSkUZwSazOu2/YyOJwnv8G6zfczOMfNe6N6N2rZ8bVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b14rSvD6; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b14rSvD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740922616; x=1772458616;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=l+zsLC8s84ltpnm1i/kPYGRjjbphM84+KlnE6PUEsxo=;
  b=b14rSvD6Llux+TU76Us5mbkvyJj7Diaa8XL6fU7HMrYXgPTc6/MjVjg3
   0SOJx6fKWGiBhkdvYFApNCDo9DfwCpg/DzUy2SlrlfMEyx17FWUsI6xVl
   xgB+FSrUrP4abdV9bpfx2YS+6MbESGUkxdQ/fc19VyNrU04PMbrUHsZ4Q
   BiTqvKkuZVorL3Rma1bUTn+LTKM2mLKArl9sj5t9Ps2NTwJJcIskyBBqi
   spm4nL9e3T2Y1kziHdrKahM2hqNs5rcNG0CUflIymnFywHmwe+fFXgmid
   5yiQVjgVlIeG1dIPyYOObMwYvsEX5PtsF3wE2W8Pf5oGCKOs4zy78r9hx
   Q==;
X-CSE-ConnectionGUID: Rbn1KFW5QhuhhDikBNG9iQ==
X-CSE-MsgGUID: YYYFOIjzRXe//dbT3eCR3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11360"; a="52007369"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="52007369"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 05:36:56 -0800
X-CSE-ConnectionGUID: zygYOZM6TrCjL4iTvW0ghg==
X-CSE-MsgGUID: IY6K0RdwRV2dMOukrBpyFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="154949545"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 02 Mar 2025 05:36:55 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tojUy-000HLO-2D;
	Sun, 02 Mar 2025 13:36:52 +0000
Date: Sun, 2 Mar 2025 21:36:08 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 80/80] ERROR: modpost:
 "poly1305_final_generic" [crypto/poly1305_generic.ko] undefined!
Message-ID: <202503022115.9OOyDR5A-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   17ec3e71ba797cdb62164fea9532c81b60f47167
commit: 17ec3e71ba797cdb62164fea9532c81b60f47167 [80/80] crypto: lib/Kconfig - Hide arch options from user
config: arm64-randconfig-002-20250302 (https://download.01.org/0day-ci/archive/20250302/202503022115.9OOyDR5A-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250302/202503022115.9OOyDR5A-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503022115.9OOyDR5A-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "poly1305_final_generic" [crypto/poly1305_generic.ko] undefined!
>> ERROR: modpost: "poly1305_core_blocks" [crypto/poly1305_generic.ko] undefined!
>> ERROR: modpost: "poly1305_core_setkey" [crypto/poly1305_generic.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
