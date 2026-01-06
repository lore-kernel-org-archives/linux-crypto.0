Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4670033F8DC;
	Tue,  6 Jan 2026 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767706970; cv=none; b=nan2YvgWuHo+yv4i8XJ8l6jx85fvEeoySglS65ScfAWDo4HtPunSRp0BbQMWg3XJbeMXPaMM7MaHkckdGUTGOLaqVHCAZwAG80E4KgNwHEeV/0FfsYfTNHOWDnIMPWB4srMMIwOcHFmxnHouSfrox0XQfxchebAY66QAFqlou3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767706970; c=relaxed/simple;
	bh=/ypj9IGr9SpILRjmMB7Es04MpkJP3Q2y17MtgZNQWGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJVMND4Eu9aZfQdlJqeHJmxMUEHrb3HsRxQyRu/LtiPW6Lss+ILP5WGX2ZnLJ1fGZjf9MS35gBgSLtcdu33uluGLAFwdIYJg8vQ0KfDduOEFllBox0IdCZM/K4m5owTRXUEI7aNoEy+AZ2o4rEo2Xhju6YXiayrrxKGWbaexexk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZuoNGfi5; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZuoNGfi5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767706970; x=1799242970;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ypj9IGr9SpILRjmMB7Es04MpkJP3Q2y17MtgZNQWGQ=;
  b=ZuoNGfi5frsJLrbz9EXqGut8sTFMizDVHbpI+eJF/1osnsF3R/1+tuDJ
   cBNQKnll/o9z5YECKrn/CJCVlS3DRmMThouSN12YS1K3T/tCPL31NKeU/
   M2zkZMrqpwFd1Hw78yw7Fa6b8Ln7CbLWWUzn6ndxIq++RqcXpFZgd2cEW
   a6OhfuiWa79qYd70sY0C+l/WNFkPbBiO8uZe4miYM76dQWacp5FbObTLL
   HmIhAd6AELg6z1BrxSxboFhqv2+oqxjOaCOy9cBiUaxJZujfGzYvwIHd6
   3l4XZEPKmHBZ9SV4cuEAjPGj0t786OBwNjowphFCFapkVOp8WKVZC1gHT
   g==;
X-CSE-ConnectionGUID: XnAc8mLMT0amZoedL8zoAw==
X-CSE-MsgGUID: b9a+JfN5RNS0JojDG86dDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="79375096"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="79375096"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 05:42:49 -0800
X-CSE-ConnectionGUID: 2XRiPS6RSOidjwAP96ISog==
X-CSE-MsgGUID: PaBKRFjjSvCwPVhjPh6Ueg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="240150728"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 06 Jan 2026 05:42:46 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vd7Kd-000000001J7-1lTF;
	Tue, 06 Jan 2026 13:42:43 +0000
Date: Tue, 6 Jan 2026 14:42:34 +0100
From: kernel test robot <lkp@intel.com>
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: oe-kbuild-all@lists.linux.dev, John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	"(open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER)" <linux-crypto@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org,
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@dell.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: Re: [PATCH v4 3/5] crypto: ccp - Add an S4 restore flow
Message-ID: <202601061453.8zskdbs5-lkp@intel.com>
References: <20260106045423.55190-4-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106045423.55190-4-superm1@kernel.org>

Hi Mario,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.16-rc1 next-20260106]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mario-Limonciello-AMD/platform-x86-amd-pmf-Prevent-TEE-errors-after-hibernate/20260106-130236
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20260106045423.55190-4-superm1%40kernel.org
patch subject: [PATCH v4 3/5] crypto: ccp - Add an S4 restore flow
config: x86_64-rhel-9.4-kunit (https://download.01.org/0day-ci/archive/20260106/202601061453.8zskdbs5-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260106/202601061453.8zskdbs5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601061453.8zskdbs5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/ccp/psp-dev.c: In function 'psp_restore':
>> drivers/crypto/ccp/psp-dev.c:357:13: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
     357 |         int ret = 0;
         |             ^~~


vim +/ret +357 drivers/crypto/ccp/psp-dev.c

   353	
   354	int psp_restore(struct sp_device *sp)
   355	{
   356		struct psp_device *psp = sp->psp_data;
 > 357		int ret = 0;
   358	
   359		if (psp->tee_data)
   360			ret = tee_restore(psp);
   361	
   362		return 0;
   363	}
   364	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
