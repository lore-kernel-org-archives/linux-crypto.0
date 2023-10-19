Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD604CDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 07:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbjJSHJN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 03:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbjJSHJB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 03:09:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D29918E
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 00:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697699339; x=1729235339;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LWbMWa2oKAzRdgSddSsqJ3NCUwFiucOIocVyWU28w/c=;
  b=lCAfQMyKfvjN4zRcwb9svFX9EAbxelg3ADHGqRjGXyX2l9m/8dLiWXnh
   7LN8I/raTMXV6NT1P/klWRzoa2R3GWEmDle17Nik8q1Js58RxjulmbDzp
   kF6pPkTbZHOky6sdfCrT4sm7CvwN/Fvo20M1k/joSN30Uq0h2ImVeF+u8
   c/17cM+RpVFvY3GD8yjhYa/S3x3wPRoAiWNdKu4gRsmHkqNUkU3yn/vhw
   /XJOkrhLpo654L8PUGoj+lHH09H+6ad3zh0UkxJfV1MQkm5tQuxSKxWDw
   38Ng7/MmcJNmebrrb6SsWAxew9a9ZsNCCD9LwBUG3EIBRX5z0gBnQzsDy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="450409109"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="450409109"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 00:08:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="791899817"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="791899817"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 19 Oct 2023 00:08:57 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qtN9J-0001mI-32;
        Thu, 19 Oct 2023 07:08:53 +0000
Date:   Thu, 19 Oct 2023 15:08:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        herbert@gondor.apana.org.au
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
        "Ospan, Abylay" <aospan@amazon.com>,
        Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH] crypto: jitter - use permanent health test storage
Message-ID: <202310191425.b4ubLtWo-lkp@intel.com>
References: <5719392.DvuYhMxLoT@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5719392.DvuYhMxLoT@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20231018]
[cannot apply to linus/master v6.6-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Stephan-M-ller/crypto-jitter-use-permanent-health-test-storage/20231019-134905
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/5719392.DvuYhMxLoT%40positron.chronox.de
patch subject: [PATCH] crypto: jitter - use permanent health test storage
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20231019/202310191425.b4ubLtWo-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231019/202310191425.b4ubLtWo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310191425.b4ubLtWo-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> crypto/jitterentropy.c:359:14: warning: no previous prototype for 'jent_health_failure' [-Wmissing-prototypes]
     359 | unsigned int jent_health_failure(struct rand_data *ec)
         |              ^~~~~~~~~~~~~~~~~~~


vim +/jent_health_failure +359 crypto/jitterentropy.c

   346	
   347	/*
   348	 * Report any health test failures
   349	 *
   350	 * @ec [in] Reference to entropy collector
   351	 *
   352	 * @return a bitmask indicating which tests failed
   353	 *	0 No health test failure
   354	 *	1 RCT failure
   355	 *	2 APT failure
   356	 *	1<<JENT_PERMANENT_FAILURE_SHIFT RCT permanent failure
   357	 *	2<<JENT_PERMANENT_FAILURE_SHIFT APT permanent failure
   358	 */
 > 359	unsigned int jent_health_failure(struct rand_data *ec)
   360	{
   361		/* Test is only enabled in FIPS mode */
   362		if (!fips_enabled)
   363			return 0;
   364	
   365		return ec->health_failure;
   366	}
   367	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
