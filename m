Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E26C6FD1D
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 15:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjCQPXa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Mar 2023 11:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCQPXP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2023 11:23:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609BE5AB77
        for <linux-crypto@vger.kernel.org>; Fri, 17 Mar 2023 08:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679066594; x=1710602594;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=zH6EitUMEaU147W0JczqO8czkcauYeElBYHUWTJ1cBk=;
  b=CLwtfhBd+o/7fK60au/Bp4Ji+GYlzPbMwNoua1TgVh6npf4lzOkXQ+kG
   uw7CIIZ7oKIS9HT+NnB7U5Hi9IhSAkZrL/OWUROb2+fVtuJr4BK0ld04n
   PRHKvyrMTdIzREHtEfh+Tvgy+haNYgDsjorwupd/xogNHbU1ZBZ10vE3k
   sPl277bFyIlDO/q8LureHrD4TD2mBIBgCTmKTi9CgIzDmCiwIxJyHBas1
   KoJSKfA5t+cqoAR8UtTMr1MDO6wv24B7skgn3Lo+5QjuJfJEWDt69KXH1
   UgN342s7ixBfiuNCCBMwbFyQXYaju76mJxE9tkZAhrRftT4qmPeErw+eD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="335778786"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="335778786"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 08:23:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="926181246"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="926181246"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2023 08:23:12 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pdBvD-0009Qs-1K;
        Fri, 17 Mar 2023 15:23:11 +0000
Date:   Fri, 17 Mar 2023 23:22:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [herbert-cryptodev-2.6:master 21/74] ERROR: modpost:
 "devm_platform_get_and_ioremap_resource" [drivers/crypto/ccree/ccree.ko]
 undefined!
Message-ID: <202303172304.WjoeTv4E-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   e6af5c0c4d32a27e04a56f29aad587e03ff427f1
commit: e70a329832df84e25ed47cbdc5c96276331356b3 [21/74] crypto: ccree - Use devm_platform_get_and_ioremap_resource()
config: s390-randconfig-r032-20230316 (https://download.01.org/0day-ci/archive/20230317/202303172304.WjoeTv4E-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=e70a329832df84e25ed47cbdc5c96276331356b3
        git remote add herbert-cryptodev-2.6 https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
        git fetch --no-tags herbert-cryptodev-2.6 master
        git checkout e70a329832df84e25ed47cbdc5c96276331356b3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303172304.WjoeTv4E-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "devm_ioremap_resource" [drivers/dma/qcom/hdma.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
>> ERROR: modpost: "devm_platform_get_and_ioremap_resource" [drivers/crypto/ccree/ccree.ko] undefined!
ERROR: modpost: "debugfs_create_regset32" [drivers/crypto/ccree/ccree.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
