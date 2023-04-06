Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C168BC7618D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Apr 2023 10:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbjDFK2z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Apr 2023 06:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbjDFK2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2023 06:28:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867433C0B
        for <linux-crypto@vger.kernel.org>; Thu,  6 Apr 2023 03:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680776931; x=1712312931;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=CPQtr4AWrKHYsAM9P/I20Oa+5IJQPuFw75sL8XFtth0=;
  b=BY2mbqh+77HqVkMST2TOlQZxnj/DaXu4XhWAnjPz9Rb59aoLX1huM6i/
   WGfPP6O8aC8pt4PTge8gSj+8KA2qORdTNHhjk6PRw0TLotILg9U9Ajxka
   8HvUnpT1QC238Lb05u0sTqPknpr8lxxtB90jXFTarUHhGsir2Bx5gpJGI
   pt8dmmsnBdmEzTxf0/eHzq/M9tekdMV8oLGLB0HXPpJM3NXj3fVtvJ1gB
   oZBDBiUrXcS0LFkG1WYxelIeVq843OloYDWzqcJHhUyoXBk23xS21eULD
   tQmseJbg2j0sZ0n6MsdN+Dn1DXPE6SrKu2zsRW1SOlTLMZcEM/691KkJv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="405487522"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="405487522"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 03:28:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="830702523"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="830702523"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 06 Apr 2023 03:28:48 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkMrI-000RJ0-04;
        Thu, 06 Apr 2023 10:28:48 +0000
Date:   Thu, 6 Apr 2023 18:28:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tom Zanussi <tom.zanussi@linux.intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [herbert-cryptodev-2.6:master 99/105]
 include/linux/compiler_types.h:397:45: error: call to
 '__compiletime_assert_385' declared with attribute error: BUILD_BUG_ON
 failed: sizeof(struct crypt_ctl) != 64
Message-ID: <202304061846.G6cpPXiQ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   a2216e1874715a8b4a6f4da2ddbe9277e5613c49
commit: 1bc7fdbf2677cc1866c025e5a393811ea8e25486 [99/105] crypto: ixp4xx - Move driver to drivers/crypto/intel/ixp4xx
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20230406/202304061846.G6cpPXiQ-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=1bc7fdbf2677cc1866c025e5a393811ea8e25486
        git remote add herbert-cryptodev-2.6 https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
        git fetch --no-tags herbert-cryptodev-2.6 master
        git checkout 1bc7fdbf2677cc1866c025e5a393811ea8e25486
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/crypto/intel/ixp4xx/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304061846.G6cpPXiQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'setup_crypt_desc',
       inlined from 'get_crypt_desc' at drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c:285:3:
>> include/linux/compiler_types.h:397:45: error: call to '__compiletime_assert_385' declared with attribute error: BUILD_BUG_ON failed: sizeof(struct crypt_ctl) != 64
     397 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:378:25: note: in definition of macro '__compiletime_assert'
     378 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:397:9: note: in expansion of macro '_compiletime_assert'
     397 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c:266:9: note: in expansion of macro 'BUILD_BUG_ON'
     266 |         BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_385 +397 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  383  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  384  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  385  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  386  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  387  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  388   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  389   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  390   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  391   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  392   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  393   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  394   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  395   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  396  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @397  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  398  

:::::: The code at line 397 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
