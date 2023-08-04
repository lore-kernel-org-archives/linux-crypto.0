Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D83C001DB
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 12:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjHDMO3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 08:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjHDMO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 08:14:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8086246AA
        for <linux-crypto@vger.kernel.org>; Fri,  4 Aug 2023 05:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691151267; x=1722687267;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=o0H+lB4Rk6RDirf2lIgh9LS32KH7E9uhgY3k8BxKG0g=;
  b=Al4UuZkJpn6U6JtN1CtEPEPNMD+HgKWsUp+0/q5Xh0ixK0ITZRruBM8k
   fkFokRLEfUXyL6Y/8uyNuRfFuFXClFE3wAmJYTP5BzsklfE920Zxo9X7q
   xXu7pJzrPobXnzw+sFnVq+pz2yqz6g6Hdk1ku4Xy/7m47NoyqdhLnVq+s
   f8xNiiUsR+o54cQHKOdj8k0QZO85rji3FE7aJm4MHF2viDTwmKIdCeRka
   HnC5NqUL7IiZbg1dndM2Lb8GYeqjzViLZFCC/W5Lf0BPj9lpIzAUZ+WYU
   ew7xCePi+wA7P1RDMuWn1uIGtHdU1RyAzIIkA3dlysRlLMP41VhpR9b2R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10792"; a="370126469"
X-IronPort-AV: E=Sophos;i="6.01,255,1684825200"; 
   d="scan'208";a="370126469"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 05:14:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10792"; a="723640417"
X-IronPort-AV: E=Sophos;i="6.01,255,1684825200"; 
   d="scan'208";a="723640417"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 04 Aug 2023 05:14:25 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qRthI-0002pv-1O;
        Fri, 04 Aug 2023 12:14:24 +0000
Date:   Fri, 4 Aug 2023 20:14:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Rob Herring <robh@kernel.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [herbert-cryptodev-2.6:master 83/83]
 drivers/char/hw_random/xgene-rng.c:110:2: error: call to undeclared function
 'writel'; ISO C99 and later do not support implicit function declarations
Message-ID: <202308042049.8R2tNRoo-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   1ce1cd8208ad6060e4fcf6e09068c8954687c127
commit: 1ce1cd8208ad6060e4fcf6e09068c8954687c127 [83/83] hwrng: Enable COMPILE_TEST for more drivers
config: s390-randconfig-r015-20230801 (https://download.01.org/0day-ci/archive/20230804/202308042049.8R2tNRoo-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230804/202308042049.8R2tNRoo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308042049.8R2tNRoo-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/char/hw_random/xgene-rng.c:110:2: error: call to undeclared function 'writel'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     110 |         writel(fro_val, ctx->csr_base + RNG_FRODETUNE);
         |         ^
>> drivers/char/hw_random/xgene-rng.c:120:8: error: call to undeclared function 'readl'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     120 |         val = readl(ctx->csr_base + RNG_INTR_STS_ACK);
         |               ^
   drivers/char/hw_random/xgene-rng.c:196:2: error: call to undeclared function 'writel'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     196 |         writel(val, ctx->csr_base + RNG_INTR_STS_ACK);
         |         ^
   drivers/char/hw_random/xgene-rng.c:215:9: error: call to undeclared function 'readl'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     215 |                 val = readl(ctx->csr_base + RNG_INTR_STS_ACK);
         |                       ^
   drivers/char/hw_random/xgene-rng.c:230:13: error: call to undeclared function 'readl'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     230 |                 data[i] = readl(ctx->csr_base + RNG_INOUT_0 + i * 4);
         |                           ^
   drivers/char/hw_random/xgene-rng.c:233:2: error: call to undeclared function 'writel'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     233 |         writel(READY_MASK, ctx->csr_base + RNG_INTR_STS_ACK);
         |         ^
   drivers/char/hw_random/xgene-rng.c:242:2: error: call to undeclared function 'writel'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     242 |         writel(0x00000000, ctx->csr_base + RNG_CONTROL);
         |         ^
   drivers/char/hw_random/xgene-rng.c:280:18: error: call to undeclared function 'readl'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     280 |         ctx->revision = readl(ctx->csr_base + RNG_EIP_REV);
         |                         ^
   8 errors generated.


vim +/writel +110 drivers/char/hw_random/xgene-rng.c

a91ae4eba9f9977 Feng Kan 2014-08-22  104  
a91ae4eba9f9977 Feng Kan 2014-08-22  105  /*
a91ae4eba9f9977 Feng Kan 2014-08-22  106   * Initialize or reinit free running oscillators (FROs)
a91ae4eba9f9977 Feng Kan 2014-08-22  107   */
a91ae4eba9f9977 Feng Kan 2014-08-22  108  static void xgene_rng_init_fro(struct xgene_rng_dev *ctx, u32 fro_val)
a91ae4eba9f9977 Feng Kan 2014-08-22  109  {
a91ae4eba9f9977 Feng Kan 2014-08-22 @110  	writel(fro_val, ctx->csr_base + RNG_FRODETUNE);
a91ae4eba9f9977 Feng Kan 2014-08-22  111  	writel(0x00000000, ctx->csr_base + RNG_ALARMMASK);
a91ae4eba9f9977 Feng Kan 2014-08-22  112  	writel(0x00000000, ctx->csr_base + RNG_ALARMSTOP);
a91ae4eba9f9977 Feng Kan 2014-08-22  113  	writel(0xFFFFFFFF, ctx->csr_base + RNG_FROENABLE);
a91ae4eba9f9977 Feng Kan 2014-08-22  114  }
a91ae4eba9f9977 Feng Kan 2014-08-22  115  
a91ae4eba9f9977 Feng Kan 2014-08-22  116  static void xgene_rng_chk_overflow(struct xgene_rng_dev *ctx)
a91ae4eba9f9977 Feng Kan 2014-08-22  117  {
a91ae4eba9f9977 Feng Kan 2014-08-22  118  	u32 val;
a91ae4eba9f9977 Feng Kan 2014-08-22  119  
a91ae4eba9f9977 Feng Kan 2014-08-22 @120  	val = readl(ctx->csr_base + RNG_INTR_STS_ACK);
a91ae4eba9f9977 Feng Kan 2014-08-22  121  	if (val & MONOBIT_FAIL_MASK)
a91ae4eba9f9977 Feng Kan 2014-08-22  122  		/*
a91ae4eba9f9977 Feng Kan 2014-08-22  123  		 * LFSR detected an out-of-bounds number of 1s after
a91ae4eba9f9977 Feng Kan 2014-08-22  124  		 * checking 20,000 bits (test T1 as specified in the
a91ae4eba9f9977 Feng Kan 2014-08-22  125  		 * AIS-31 standard)
a91ae4eba9f9977 Feng Kan 2014-08-22  126  		 */
a91ae4eba9f9977 Feng Kan 2014-08-22  127  		dev_err(ctx->dev, "test monobit failure error 0x%08X\n", val);
a91ae4eba9f9977 Feng Kan 2014-08-22  128  	if (val & POKER_FAIL_MASK)
a91ae4eba9f9977 Feng Kan 2014-08-22  129  		/*
a91ae4eba9f9977 Feng Kan 2014-08-22  130  		 * LFSR detected an out-of-bounds value in at least one
a91ae4eba9f9977 Feng Kan 2014-08-22  131  		 * of the 16 poker_count_X counters or an out of bounds sum
a91ae4eba9f9977 Feng Kan 2014-08-22  132  		 * of squares value after checking 20,000 bits (test T2 as
a91ae4eba9f9977 Feng Kan 2014-08-22  133  		 * specified in the AIS-31 standard)
a91ae4eba9f9977 Feng Kan 2014-08-22  134  		 */
a91ae4eba9f9977 Feng Kan 2014-08-22  135  		dev_err(ctx->dev, "test poker failure error 0x%08X\n", val);
a91ae4eba9f9977 Feng Kan 2014-08-22  136  	if (val & LONG_RUN_FAIL_MASK)
a91ae4eba9f9977 Feng Kan 2014-08-22  137  		/*
a91ae4eba9f9977 Feng Kan 2014-08-22  138  		 * LFSR detected a sequence of 34 identical bits
a91ae4eba9f9977 Feng Kan 2014-08-22  139  		 * (test T4 as specified in the AIS-31 standard)
a91ae4eba9f9977 Feng Kan 2014-08-22  140  		 */
a91ae4eba9f9977 Feng Kan 2014-08-22  141  		dev_err(ctx->dev, "test long run failure error 0x%08X\n", val);
a91ae4eba9f9977 Feng Kan 2014-08-22  142  	if (val & RUN_FAIL_MASK)
a91ae4eba9f9977 Feng Kan 2014-08-22  143  		/*
a91ae4eba9f9977 Feng Kan 2014-08-22  144  		 * LFSR detected an outof-bounds value for at least one
a91ae4eba9f9977 Feng Kan 2014-08-22  145  		 * of the running counters after checking 20,000 bits
a91ae4eba9f9977 Feng Kan 2014-08-22  146  		 * (test T3 as specified in the AIS-31 standard)
a91ae4eba9f9977 Feng Kan 2014-08-22  147  		 */
a91ae4eba9f9977 Feng Kan 2014-08-22  148  		dev_err(ctx->dev, "test run failure error 0x%08X\n", val);
a91ae4eba9f9977 Feng Kan 2014-08-22  149  	if (val & NOISE_FAIL_MASK)
a91ae4eba9f9977 Feng Kan 2014-08-22  150  		/* LFSR detected a sequence of 48 identical bits */
a91ae4eba9f9977 Feng Kan 2014-08-22  151  		dev_err(ctx->dev, "noise failure error 0x%08X\n", val);
a91ae4eba9f9977 Feng Kan 2014-08-22  152  	if (val & STUCK_OUT_MASK)
a91ae4eba9f9977 Feng Kan 2014-08-22  153  		/*
a91ae4eba9f9977 Feng Kan 2014-08-22  154  		 * Detected output data registers generated same value twice
a91ae4eba9f9977 Feng Kan 2014-08-22  155  		 * in a row
a91ae4eba9f9977 Feng Kan 2014-08-22  156  		 */
a91ae4eba9f9977 Feng Kan 2014-08-22  157  		dev_err(ctx->dev, "stuck out failure error 0x%08X\n", val);
a91ae4eba9f9977 Feng Kan 2014-08-22  158  
a91ae4eba9f9977 Feng Kan 2014-08-22  159  	if (val & SHUTDOWN_OFLO_MASK) {
a91ae4eba9f9977 Feng Kan 2014-08-22  160  		u32 frostopped;
a91ae4eba9f9977 Feng Kan 2014-08-22  161  
a91ae4eba9f9977 Feng Kan 2014-08-22  162  		/* FROs shut down after a second error event. Try recover. */
a91ae4eba9f9977 Feng Kan 2014-08-22  163  		if (++ctx->failure_cnt == 1) {
a91ae4eba9f9977 Feng Kan 2014-08-22  164  			/* 1st time, just recover */
a91ae4eba9f9977 Feng Kan 2014-08-22  165  			ctx->failure_ts = jiffies;
a91ae4eba9f9977 Feng Kan 2014-08-22  166  			frostopped = readl(ctx->csr_base + RNG_ALARMSTOP);
a91ae4eba9f9977 Feng Kan 2014-08-22  167  			xgene_rng_init_fro(ctx, frostopped);
a91ae4eba9f9977 Feng Kan 2014-08-22  168  
a91ae4eba9f9977 Feng Kan 2014-08-22  169  			/*
a91ae4eba9f9977 Feng Kan 2014-08-22  170  			 * We must start a timer to clear out this error
a91ae4eba9f9977 Feng Kan 2014-08-22  171  			 * in case the system timer wrap around
a91ae4eba9f9977 Feng Kan 2014-08-22  172  			 */
a91ae4eba9f9977 Feng Kan 2014-08-22  173  			xgene_rng_start_timer(ctx);
a91ae4eba9f9977 Feng Kan 2014-08-22  174  		} else {
a91ae4eba9f9977 Feng Kan 2014-08-22  175  			/* 2nd time failure in lesser than 1 minute? */
a91ae4eba9f9977 Feng Kan 2014-08-22  176  			if (time_after(ctx->failure_ts + 60 * HZ, jiffies)) {
a91ae4eba9f9977 Feng Kan 2014-08-22  177  				dev_err(ctx->dev,
a91ae4eba9f9977 Feng Kan 2014-08-22  178  					"FRO shutdown failure error 0x%08X\n",
a91ae4eba9f9977 Feng Kan 2014-08-22  179  					val);
a91ae4eba9f9977 Feng Kan 2014-08-22  180  			} else {
a91ae4eba9f9977 Feng Kan 2014-08-22  181  				/* 2nd time failure after 1 minutes, recover */
a91ae4eba9f9977 Feng Kan 2014-08-22  182  				ctx->failure_ts = jiffies;
a91ae4eba9f9977 Feng Kan 2014-08-22  183  				ctx->failure_cnt = 1;
a91ae4eba9f9977 Feng Kan 2014-08-22  184  				/*
a91ae4eba9f9977 Feng Kan 2014-08-22  185  				 * We must start a timer to clear out this
a91ae4eba9f9977 Feng Kan 2014-08-22  186  				 * error in case the system timer wrap
a91ae4eba9f9977 Feng Kan 2014-08-22  187  				 * around
a91ae4eba9f9977 Feng Kan 2014-08-22  188  				 */
a91ae4eba9f9977 Feng Kan 2014-08-22  189  				xgene_rng_start_timer(ctx);
a91ae4eba9f9977 Feng Kan 2014-08-22  190  			}
a91ae4eba9f9977 Feng Kan 2014-08-22  191  			frostopped = readl(ctx->csr_base + RNG_ALARMSTOP);
a91ae4eba9f9977 Feng Kan 2014-08-22  192  			xgene_rng_init_fro(ctx, frostopped);
a91ae4eba9f9977 Feng Kan 2014-08-22  193  		}
a91ae4eba9f9977 Feng Kan 2014-08-22  194  	}
a91ae4eba9f9977 Feng Kan 2014-08-22  195  	/* Clear them all */
a91ae4eba9f9977 Feng Kan 2014-08-22  196  	writel(val, ctx->csr_base + RNG_INTR_STS_ACK);
a91ae4eba9f9977 Feng Kan 2014-08-22  197  }
a91ae4eba9f9977 Feng Kan 2014-08-22  198  

:::::: The code at line 110 was first introduced by commit
:::::: a91ae4eba9f9977863b57f2ac61e2e8e780375a8 hwrng: xgene - add support for APM X-Gene SoC RNG support

:::::: TO: Feng Kan <fkan@apm.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
