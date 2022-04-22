Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EE4C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Apr 2022 02:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443468AbiDVCod (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 22:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353014AbiDVCod (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 22:44:33 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD494C41D
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 19:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650595298; x=1682131298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0H+dqDafy0QtwS4F6hhvIGfbg8sBLbyVV0ipTGHQWrk=;
  b=PpG6WVoAY/lX4k3kVelFw+aPH+8ZQS3BwziFD9sHpY5U0ZEHfCfgIpVI
   ge+gXwCFqSF3dN+HTR8+8uOvzmN1IIiRlUlyKXEpUkBol9qdiI672emCJ
   GiE6D4fRWTYvYRMH8Yk9fqKEy2MugMiUbpI5ZIHoASxRuLugpERr5jxZt
   ufYJPov9spSeXR1TEKebFqlE5Tg0HoiDFOKr0i+X45gN8nDDWou7BmWti
   klAyrqa1V466RiViIn9NDuh1ARkSwofB41vqTsoXKdGhBu7niPb4OLkYE
   FrR6N2e2zXa6LRZhqF1fuFsSuLCPzK/aFKXbdzNW4dU++jH0P+2ru4TV5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="350987816"
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="350987816"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 19:41:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="728297781"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2022 19:41:35 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhjEl-000980-7v;
        Fri, 22 Apr 2022 02:41:35 +0000
Date:   Fri, 22 Apr 2022 10:40:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH] hwrng: cn10k - Enable compile testing
Message-ID: <202204221037.taeIlED5-lkp@intel.com>
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
[also build test ERROR on herbert-cryptodev-2.6/master v5.18-rc3 next-20220421]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/hwrng-cn10k-Enable-compile-testing/20220421-181432
base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git c50c29a806113614098efd8da9fd7b48d605ba45
config: arm-randconfig-r023-20220421 (https://download.01.org/0day-ci/archive/20220422/202204221037.taeIlED5-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5bd87350a5ae429baf8f373cb226a57b62f87280)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/c804fd47b3fa542852a8cbd9c76ded8a43d32a90
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Herbert-Xu/hwrng-cn10k-Enable-compile-testing/20220421-181432
        git checkout c804fd47b3fa542852a8cbd9c76ded8a43d32a90
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/char/hw_random/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/char/hw_random/cn10k-rng.c:55:11: error: call to undeclared function 'readq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           status = readq(rng->reg_base + RNM_PF_EBG_HEALTH);
                    ^
   drivers/char/hw_random/cn10k-rng.c:71:11: error: call to undeclared function 'readq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           *value = readq(rng->reg_base + RNM_PF_RANDOM);
                    ^
   2 errors generated.


vim +/readq +55 drivers/char/hw_random/cn10k-rng.c

38e9791a020904 Sunil Goutham 2021-12-14  45  
38e9791a020904 Sunil Goutham 2021-12-14  46  static int check_rng_health(struct cn10k_rng *rng)
38e9791a020904 Sunil Goutham 2021-12-14  47  {
38e9791a020904 Sunil Goutham 2021-12-14  48  	u64 status;
38e9791a020904 Sunil Goutham 2021-12-14  49  	int err;
38e9791a020904 Sunil Goutham 2021-12-14  50  
38e9791a020904 Sunil Goutham 2021-12-14  51  	/* Skip checking health */
38e9791a020904 Sunil Goutham 2021-12-14  52  	if (!rng->reg_base)
38e9791a020904 Sunil Goutham 2021-12-14  53  		return 0;
38e9791a020904 Sunil Goutham 2021-12-14  54  
38e9791a020904 Sunil Goutham 2021-12-14 @55  	status = readq(rng->reg_base + RNM_PF_EBG_HEALTH);
38e9791a020904 Sunil Goutham 2021-12-14  56  	if (status & BIT_ULL(20)) {
38e9791a020904 Sunil Goutham 2021-12-14  57  		err = reset_rng_health_state(rng);
38e9791a020904 Sunil Goutham 2021-12-14  58  		if (err) {
38e9791a020904 Sunil Goutham 2021-12-14  59  			dev_err(&rng->pdev->dev, "HWRNG: Health test failed (status=%llx)\n",
38e9791a020904 Sunil Goutham 2021-12-14  60  					status);
38e9791a020904 Sunil Goutham 2021-12-14  61  			dev_err(&rng->pdev->dev, "HWRNG: error during reset\n");
38e9791a020904 Sunil Goutham 2021-12-14  62  		}
38e9791a020904 Sunil Goutham 2021-12-14  63  	}
38e9791a020904 Sunil Goutham 2021-12-14  64  	return 0;
38e9791a020904 Sunil Goutham 2021-12-14  65  }
38e9791a020904 Sunil Goutham 2021-12-14  66  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
