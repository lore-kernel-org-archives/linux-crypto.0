Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1C2C001B0
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Aug 2023 08:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbjHPIR3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Aug 2023 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242824AbjHPIRQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2023 04:17:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E872EE
        for <linux-crypto@vger.kernel.org>; Wed, 16 Aug 2023 01:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692173835; x=1723709835;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GjmPOJXGEExKiJaF36kU9IFiFGVAdr/o6q5VqRn0LVY=;
  b=JFKDS1+26GdUPYxeJaGEua8W9QERXQdb60YvYNeNq5di9I4S2gjZB/8g
   FWKVkGvjCqTc54RhLJfr4mibk2vjMCKEMe24BfKztyeIP+a1wdj1Q0kdK
   TnOtZ50IfKacOrXn3Y7wieS1dl2wwWiWuZSk7w0K4ke3htkSxx6yq3H/V
   R0eZUzWdwfpgzxbhut3h5A2ufv5dW1mReyj6pJ8piKfmy4r2oIIEG6mct
   xNVw8Dd4SshF8RxvS88MstTpbqJ7dw+sYHpK2wi9Vj0FhHlx7kus6+Z8a
   Rs1Cs1x3arlZKbwxXZomI23c4rZwO92orQA9d2EHIdukEjfr1+kwQQogj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="372472638"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="372472638"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 01:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="737209515"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="737209515"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2023 01:16:35 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWBgn-00007z-2Y;
        Wed, 16 Aug 2023 08:15:47 +0000
Date:   Wed, 16 Aug 2023 16:13:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Prasad Pandit <ppandit@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
        P J P <pjp@fedoraproject.org>
Subject: Re: [PATCH] crypto: use SRCARCH to source arch Kconfigs
Message-ID: <202308161653.3g2hn5Wr-lkp@intel.com>
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
config: arc-randconfig-r035-20230816 (attached as .config)
compiler: arc-elf-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230816/202308161653.3g2hn5Wr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308161653.3g2hn5Wr-lkp@intel.com/

All errors (new ones prefixed by >>):

>> crypto/Kconfig:1424: can't open file "arch/arc/crypto/Kconfig"
   make[3]: *** [scripts/kconfig/Makefile:77: oldconfig] Error 1 shuffle=2853089106
   make[2]: *** [Makefile:693: oldconfig] Error 2 shuffle=2853089106
   make[1]: *** [Makefile:234: __sub-make] Error 2 shuffle=2853089106
   make[1]: Target 'oldconfig' not remade because of errors.
   make: *** [Makefile:234: __sub-make] Error 2 shuffle=2853089106
   make: Target 'oldconfig' not remade because of errors.
--
>> crypto/Kconfig:1424: can't open file "arch/arc/crypto/Kconfig"
   make[3]: *** [scripts/kconfig/Makefile:77: olddefconfig] Error 1 shuffle=2853089106
   make[2]: *** [Makefile:693: olddefconfig] Error 2 shuffle=2853089106
   make[1]: *** [Makefile:234: __sub-make] Error 2 shuffle=2853089106
   make[1]: Target 'olddefconfig' not remade because of errors.
   make: *** [Makefile:234: __sub-make] Error 2 shuffle=2853089106
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
