Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A556C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Apr 2022 03:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiD0DSh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244309AbiD0DSc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 23:18:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B156413F1B
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 20:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651029322; x=1682565322;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CxNPtwgYBw9B+jGMjd8TzcClQe20UzJJk/iZIJUCvkA=;
  b=T1/+NNYl3TupKWHfDxYc1OdWH+mtzjIZ2LSakVck70Dm6OaGa34qahjj
   FJj3wkx8DWKLZzSZYLm7gaGmgTYT5KlNmVPtMii9+HtiypZQX9I6j2lt5
   vs3K4DwQXBVe2ra4GioHlTA+55zp/4oqSHOh9nrIbPkWAvcGFPSjXju82
   804NvHiVjPPpwfqn6vTmg4HQWRVX+hxwvfAqDpF7LHs/J9hGGOl2ddYxn
   0vmfmLvLM1Y89Eydia4VNZ7W7bdivDvThiJnfpuC69hVRs7XUqkHr4i4Y
   TQQyOOdVe3HlFMCuyyK4zILgFfy3wxaUKYh56A87lVWAQiNrRJNfz44S3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="290946729"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="290946729"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 20:15:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="650498542"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Apr 2022 20:15:21 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njY9A-0004GE-OX;
        Wed, 27 Apr 2022 03:15:20 +0000
Date:   Wed, 27 Apr 2022 11:14:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH] hwrng: cn10k - Enable compile testing
Message-ID: <202204271119.5APX0rdl-lkp@intel.com>
References: <YmEqVLcteYSrDYr6@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmEqVLcteYSrDYr6@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

I love your patch! Yet something to improve:

[auto build test ERROR on char-misc/char-misc-testing]
[also build test ERROR on herbert-cryptodev-2.6/master v5.18-rc4 next-20220426]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/hwrng-cn10k-Enable-compile-testing/20220421-181432
base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git c50c29a806113614098efd8da9fd7b48d605ba45
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220427/202204271119.5APX0rdl-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c804fd47b3fa542852a8cbd9c76ded8a43d32a90
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Herbert-Xu/hwrng-cn10k-Enable-compile-testing/20220421-181432
        git checkout c804fd47b3fa542852a8cbd9c76ded8a43d32a90
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/char/hw_random/cn10k-rng.c: In function 'check_rng_health':
>> drivers/char/hw_random/cn10k-rng.c:55:18: error: implicit declaration of function 'readq'; did you mean 'readb'? [-Werror=implicit-function-declaration]
      55 |         status = readq(rng->reg_base + RNM_PF_EBG_HEALTH);
         |                  ^~~~~
         |                  readb
   cc1: some warnings being treated as errors


vim +55 drivers/char/hw_random/cn10k-rng.c

38e9791a0209041 Sunil Goutham 2021-12-14  45  
38e9791a0209041 Sunil Goutham 2021-12-14  46  static int check_rng_health(struct cn10k_rng *rng)
38e9791a0209041 Sunil Goutham 2021-12-14  47  {
38e9791a0209041 Sunil Goutham 2021-12-14  48  	u64 status;
38e9791a0209041 Sunil Goutham 2021-12-14  49  	int err;
38e9791a0209041 Sunil Goutham 2021-12-14  50  
38e9791a0209041 Sunil Goutham 2021-12-14  51  	/* Skip checking health */
38e9791a0209041 Sunil Goutham 2021-12-14  52  	if (!rng->reg_base)
38e9791a0209041 Sunil Goutham 2021-12-14  53  		return 0;
38e9791a0209041 Sunil Goutham 2021-12-14  54  
38e9791a0209041 Sunil Goutham 2021-12-14 @55  	status = readq(rng->reg_base + RNM_PF_EBG_HEALTH);
38e9791a0209041 Sunil Goutham 2021-12-14  56  	if (status & BIT_ULL(20)) {
38e9791a0209041 Sunil Goutham 2021-12-14  57  		err = reset_rng_health_state(rng);
38e9791a0209041 Sunil Goutham 2021-12-14  58  		if (err) {
38e9791a0209041 Sunil Goutham 2021-12-14  59  			dev_err(&rng->pdev->dev, "HWRNG: Health test failed (status=%llx)\n",
38e9791a0209041 Sunil Goutham 2021-12-14  60  					status);
38e9791a0209041 Sunil Goutham 2021-12-14  61  			dev_err(&rng->pdev->dev, "HWRNG: error during reset\n");
38e9791a0209041 Sunil Goutham 2021-12-14  62  		}
38e9791a0209041 Sunil Goutham 2021-12-14  63  	}
38e9791a0209041 Sunil Goutham 2021-12-14  64  	return 0;
38e9791a0209041 Sunil Goutham 2021-12-14  65  }
38e9791a0209041 Sunil Goutham 2021-12-14  66  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
