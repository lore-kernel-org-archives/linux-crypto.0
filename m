Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836DDC6FD1C
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 16:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCXQF2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 12:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCXQF1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 12:05:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1FD222F9
        for <linux-crypto@vger.kernel.org>; Fri, 24 Mar 2023 09:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679673926; x=1711209926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=fKhAQVZhrCogzpWJuiQYxDYscKhCZ5VAUX30DZ22lQM=;
  b=Zk+S9jT37LSloHv0Tmk18xKpWRtGThF7XlE1k7L8F6Mdq/3TrDoXvUsN
   HnA1M07Sfyt9RKHGNXFOLW67YsvZ9+z/5X37fJdyX/AftDkJhp+20Brx2
   t4tUQkygtgAPG0HmDY19wgo7ge1NnRB9HfTTTX9dXrM/L4ei2vl9ERwx9
   AypXcvRHE2zAfS/uGUT3orv6bew7QSxcXWpnfIZlwTysQT2zJlhAQof34
   t0yplk/PjWDsNBKI/QJ3f4C+/LA01pWgZtH5orBjpBZr4sIsOK4SY1iDk
   OFnF5tk6l3XhCkJIor3zK5mF0ne4qnl9hvDF4Lj9StA2pan/YCXMqCNFq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="320210773"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="320210773"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 09:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="751943439"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="751943439"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 Mar 2023 09:04:21 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pfjts-000FRL-38;
        Fri, 24 Mar 2023 16:04:20 +0000
Date:   Sat, 25 Mar 2023 00:03:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2] Jitter RNG - Permanent and Intermittent health errors
Message-ID: <202303242344.goIWq8zw-lkp@intel.com>
References: <2671913.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2671913.mvXUDI8C0e@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Stephan-M-ller/Jitter-RNG-Permanent-and-Intermittent-health-errors/20230324-203251
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/2671913.mvXUDI8C0e%40positron.chronox.de
patch subject: [PATCH v2] Jitter RNG - Permanent and Intermittent health errors
config: hexagon-randconfig-r045-20230322 (https://download.01.org/0day-ci/archive/20230324/202303242344.goIWq8zw-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ce362096eea814a823f7bf4aef00f8680aab9056
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stephan-M-ller/Jitter-RNG-Permanent-and-Intermittent-health-errors/20230324-203251
        git checkout ce362096eea814a823f7bf4aef00f8680aab9056
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303242344.goIWq8zw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> crypto/jitterentropy-kcapi.c:165:1: warning: unused label 'out' [-Wunused-label]
   out:
   ^~~~
   1 warning generated.


vim +/out +165 crypto/jitterentropy-kcapi.c

dfc9fa91938bd0 Stephan Mueller 2015-06-23  131  
dfc9fa91938bd0 Stephan Mueller 2015-06-23  132  static int jent_kcapi_random(struct crypto_rng *tfm,
dfc9fa91938bd0 Stephan Mueller 2015-06-23  133  			     const u8 *src, unsigned int slen,
dfc9fa91938bd0 Stephan Mueller 2015-06-23  134  			     u8 *rdata, unsigned int dlen)
dfc9fa91938bd0 Stephan Mueller 2015-06-23  135  {
dfc9fa91938bd0 Stephan Mueller 2015-06-23  136  	struct jitterentropy *rng = crypto_rng_ctx(tfm);
dfc9fa91938bd0 Stephan Mueller 2015-06-23  137  	int ret = 0;
dfc9fa91938bd0 Stephan Mueller 2015-06-23  138  
dfc9fa91938bd0 Stephan Mueller 2015-06-23  139  	spin_lock(&rng->jent_lock);
764428fe99e82c Stephan Müller  2020-04-17  140  
dfc9fa91938bd0 Stephan Mueller 2015-06-23  141  	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
764428fe99e82c Stephan Müller  2020-04-17  142  
ce362096eea814 Stephan Müller  2023-03-24  143  	if (ret == -3) {
ce362096eea814 Stephan Müller  2023-03-24  144  		/* Handle permanent health test error */
ce362096eea814 Stephan Müller  2023-03-24  145  		/*
ce362096eea814 Stephan Müller  2023-03-24  146  		 * If the kernel was booted with fips=2, it implies that
ce362096eea814 Stephan Müller  2023-03-24  147  		 * the entire kernel acts as a FIPS 140 module. In this case
ce362096eea814 Stephan Müller  2023-03-24  148  		 * an SP800-90B permanent health test error is treated as
ce362096eea814 Stephan Müller  2023-03-24  149  		 * a FIPS module error.
ce362096eea814 Stephan Müller  2023-03-24  150  		 */
ce362096eea814 Stephan Müller  2023-03-24  151  		if (fips_enabled)
ce362096eea814 Stephan Müller  2023-03-24  152  			panic("Jitter RNG permanent health test failure\n");
764428fe99e82c Stephan Müller  2020-04-17  153  
ce362096eea814 Stephan Müller  2023-03-24  154  		pr_err("Jitter RNG permanent health test failure\n");
ce362096eea814 Stephan Müller  2023-03-24  155  		ret = -EFAULT;
ce362096eea814 Stephan Müller  2023-03-24  156  	} else if (ret == -2) {
ce362096eea814 Stephan Müller  2023-03-24  157  		/* Handle intermittent health test error */
ce362096eea814 Stephan Müller  2023-03-24  158  		pr_warn_ratelimited("Reset Jitter RNG due to intermittent health test failure\n");
764428fe99e82c Stephan Müller  2020-04-17  159  		ret = -EAGAIN;
ce362096eea814 Stephan Müller  2023-03-24  160  	} else if (ret == -1) {
ce362096eea814 Stephan Müller  2023-03-24  161  		/* Handle other errors */
764428fe99e82c Stephan Müller  2020-04-17  162  		ret = -EINVAL;
764428fe99e82c Stephan Müller  2020-04-17  163  	}
764428fe99e82c Stephan Müller  2020-04-17  164  
764428fe99e82c Stephan Müller  2020-04-17 @165  out:
dfc9fa91938bd0 Stephan Mueller 2015-06-23  166  	spin_unlock(&rng->jent_lock);
dfc9fa91938bd0 Stephan Mueller 2015-06-23  167  
dfc9fa91938bd0 Stephan Mueller 2015-06-23  168  	return ret;
dfc9fa91938bd0 Stephan Mueller 2015-06-23  169  }
dfc9fa91938bd0 Stephan Mueller 2015-06-23  170  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
