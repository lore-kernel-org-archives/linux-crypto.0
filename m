Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F637C001B0
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Aug 2023 08:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjHPIPv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Aug 2023 04:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242822AbjHPIPl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2023 04:15:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8935B94
        for <linux-crypto@vger.kernel.org>; Wed, 16 Aug 2023 01:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692173740; x=1723709740;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fq3/yQ5GNTXk3fanQ4Pz/Ds7yeWCzYn66mWCbkmhU8E=;
  b=bw4ktPo+2IqgKhMxHQrYaiMbF4bF+M4dASmDcls/u6ljpbIkYTvRQDiV
   7WTTxEZAPdmHrROsCwbgFRLxllMCcQkNhyG9MHsBZG0bM2rBi5PbiYsJo
   Ri3Kx+drxsS0e32slli8F5ohP1jzhWTsxCW9yYmrdOLVexRb/FpTtw1ao
   aZW05BeWOU5sVjtW+mG2L5EbTGq2WGMUSJipjE9pGv29Hk6xVyQ+yVLE/
   GtJbjuB43paz2R0c6pyboyZB/sy71NWi/dNXkyYYCWNO8mML1rY/K0mUc
   smJ744NidNI6Y8H+ArRYKtV6QNIqjQyhxM/v+hpBI6Q67/u5wFiMIJzTu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="369946576"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="369946576"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 01:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="799487684"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="799487684"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2023 01:15:38 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWBgX-00007v-0W;
        Wed, 16 Aug 2023 08:15:27 +0000
Date:   Wed, 16 Aug 2023 16:13:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Prasad Pandit <ppandit@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-crypto@vger.kernel.org, P J P <pjp@fedoraproject.org>
Subject: Re: [PATCH] crypto: use SRCARCH to source arch Kconfigs
Message-ID: <202308161608.VTW4Ttjd-lkp@intel.com>
References: <20230816063107.11215-1-ppandit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230816063107.11215-1-ppandit@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Prasad,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.5-rc6 next-20230815]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Prasad-Pandit/crypto-use-SRCARCH-to-source-arch-Kconfigs/20230816-143209
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20230816063107.11215-1-ppandit%40redhat.com
patch subject: [PATCH] crypto: use SRCARCH to source arch Kconfigs
config: hexagon-randconfig-r011-20230816 (attached as .config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce: (https://download.01.org/0day-ci/archive/20230816/202308161608.VTW4Ttjd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308161608.VTW4Ttjd-lkp@intel.com/

All errors (new ones prefixed by >>):

>> crypto/Kconfig:1424: can't open file "arch/hexagon/crypto/Kconfig"
   make[3]: *** [scripts/kconfig/Makefile:77: oldconfig] Error 1 shuffle=3400782416
   make[2]: *** [Makefile:693: oldconfig] Error 2 shuffle=3400782416
   make[1]: *** [Makefile:234: __sub-make] Error 2 shuffle=3400782416
   make[1]: Target 'oldconfig' not remade because of errors.
   make: *** [Makefile:234: __sub-make] Error 2 shuffle=3400782416
   make: Target 'oldconfig' not remade because of errors.
--
>> crypto/Kconfig:1424: can't open file "arch/hexagon/crypto/Kconfig"
   make[3]: *** [scripts/kconfig/Makefile:77: olddefconfig] Error 1 shuffle=3400782416
   make[2]: *** [Makefile:693: olddefconfig] Error 2 shuffle=3400782416
   make[1]: *** [Makefile:234: __sub-make] Error 2 shuffle=3400782416
   make[1]: Target 'olddefconfig' not remade because of errors.
   make: *** [Makefile:234: __sub-make] Error 2 shuffle=3400782416
   make: Target 'olddefconfig' not remade because of errors.


vim +1424 crypto/Kconfig

  1419	
  1420	config CRYPTO_HASH_INFO
  1421		bool
  1422	
  1423	if !KMSAN # avoid false positives from assembly
> 1424	source "arch/$(SRCARCH)/crypto/Kconfig"
  1425	endif
  1426	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
