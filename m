Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0832E62B3;
	Fri,  4 Apr 2025 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743729267; cv=none; b=RyhTHZ/ChdUK/oVlN3e3NIJeffERSOYL2f956Oxc/CQd/F+ifhrrggUw1wyNRmyZuD4NxneOTmvz/H0rF8SWrS0RiaqA/BOMq0IMOFozYKx8bz8ACZyaam4Zea/4/3u/vTwysGV8I8GRzuolpNkkcNpaSH+5SWqjxDn8W0hP7hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743729267; c=relaxed/simple;
	bh=q9IGyyt4yzFu6LMyBZ5igtAo2ZNWnWDUXaG4HECDyTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBTIXMJ8ea5U2gh7DVGDhx+08Obz+HgsK3o3R943oRnSnkpGOET3+LGtt3R+CSmkIRKAjDeH10rG+V6TG799T+NSx2y+5RLcSC8/JRoqSnuM8fwOlrjjUmeHSnH0HpWqks3ze5jeqa9jLXYlQtjyeryhudlD4tXhuq55SIuv9FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AoOjKAXe; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AoOjKAXe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743729266; x=1775265266;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q9IGyyt4yzFu6LMyBZ5igtAo2ZNWnWDUXaG4HECDyTQ=;
  b=AoOjKAXe4Y+EmgsmegZkM5ps534okns5lpzZE1Lih3EaoMOHc/fqP0Vc
   Uduv0A44YjcTXFFRWmBjpjVjPvF62jFz1bCmPCTru+IvTexP0u4k3+5hC
   /aMNysBS8l4l2XfijWfC9x3o42Su18TBwXz4MWJLUuAVGwUp1V0WIBCmu
   tS188JgkA56Y9E62ypmyFLHDpNC6Kz4JdWZGTlJeSpWOnEcgTFdOyilvE
   CfmkDAh8RZ30pq3LxXEHwG9bxSrAE2S2eKu75of65RfkRBbQVfzY18Xzg
   Sb6yt/06t6D4253BnEdTahjnaOtGtJN6WdpHrRpUDmzFpvZCe3QJgUs+L
   g==;
X-CSE-ConnectionGUID: lMBE2c2cTjuW+XXfRLCj5w==
X-CSE-MsgGUID: JjdvAPCdQLiXY4i+uRLY9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="32765282"
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="32765282"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 18:14:25 -0700
X-CSE-ConnectionGUID: iY7ecYXeTP+vDClZNCg3bQ==
X-CSE-MsgGUID: aonLBCsRRnebZxE+bqDA5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="127125003"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 03 Apr 2025 18:14:22 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u0VdU-0000uB-0W;
	Fri, 04 Apr 2025 01:14:20 +0000
Date: Fri, 4 Apr 2025 09:13:40 +0800
From: kernel test robot <lkp@intel.com>
To: Uros Bizjak <ubizjak@gmail.com>, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Uros Bizjak <ubizjak@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
Message-ID: <202504040855.mr885Pz1-lkp@intel.com>
References: <20250403094527.349526-3-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403094527.349526-3-ubizjak@gmail.com>

Hi Uros,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master tip/x86/core linus/master v6.14]
[cannot apply to next-20250403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Uros-Bizjak/crypto-x86-Remove-CONFIG_AS_SHA256_NI/20250403-174814
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250403094527.349526-3-ubizjak%40gmail.com
patch subject: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
config: i386-buildonly-randconfig-001-20250404 (https://download.01.org/0day-ci/archive/20250404/202504040855.mr885Pz1-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250404/202504040855.mr885Pz1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504040855.mr885Pz1-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/raid6/recov_avx512.c:382:2: warning: #warning "your version of binutils lacks AVX512 support" [-Wcpp]
     382 | #warning "your version of binutils lacks AVX512 support"
         |  ^~~~~~~


vim +382 lib/raid6/recov_avx512.c

13c520b2993c9fa Gayatri Kammela 2016-08-12  380  
13c520b2993c9fa Gayatri Kammela 2016-08-12  381  #else
13c520b2993c9fa Gayatri Kammela 2016-08-12 @382  #warning "your version of binutils lacks AVX512 support"

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
