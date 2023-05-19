Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8A3C77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 11:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjESLzO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 07:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjESLzO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 07:55:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C50191
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 04:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684497310; x=1716033310;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=toHxbtn6az1Iif8PKSJUhxj8yPw2n1M/FuYET+fPq5k=;
  b=CJEaQSVtamesdqudcXMvXEj4q/TVj0wRXkhXaRjEFWRoVkCH7wkI/wmZ
   Mb1ouI9aDnUWtMo1gDV08aqvqfSPMuEhrwHT4BWkxqtRGNqvBHpals3K4
   Vymk5Ec3WKlHkvb8OoXFyRdlwIHuTOwDCyyhWGIgNmO0MB6bGOOCMmt+2
   mXWjHfvifJkA8QKg8suQ+Pffrk8I+++siPv/HDngf2SFa8HhBGVpF5CS9
   5G8XTXiXCoKvBYnxsyqpNcQDrZHA8eanFjjfRWMDZUdRqXJgoBD91yDOf
   swDuXCkRGrJzpmpylNOqAr5JJF2atB9QYzY1+LcS5o2AGWs6itCzvQHNT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="355580584"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="355580584"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 04:55:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="792353782"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="792353782"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 19 May 2023 04:55:08 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pzyhP-000AoM-2V;
        Fri, 19 May 2023 11:55:07 +0000
Date:   Fri, 19 May 2023 19:54:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 17/22]
 arch/arm64/crypto/sha256-glue.c:194:1: warning: data definition has no type
 or storage class
Message-ID: <202305191953.PIB1w80W-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   7883d1b28a2b0e62edcacea22de6b36a1918b15a
commit: 6c19f3bfff0344cdc02e7b074062a9acd026f010 [17/22] crypto: lib/sha256 - Use generic code from sha256_base
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20230519/202305191953.PIB1w80W-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=6c19f3bfff0344cdc02e7b074062a9acd026f010
        git remote add herbert-cryptodev-2.6 https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
        git fetch --no-tags herbert-cryptodev-2.6 master
        git checkout 6c19f3bfff0344cdc02e7b074062a9acd026f010
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/crypto/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305191953.PIB1w80W-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/arm64/crypto/sha256-glue.c:18:20: error: expected declaration specifiers or '...' before string constant
      18 | MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash for arm64");
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:19:15: error: expected declaration specifiers or '...' before string constant
      19 | MODULE_AUTHOR("Andy Polyakov <appro@openssl.org>");
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:20:15: error: expected declaration specifiers or '...' before string constant
      20 | MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:21:16: error: expected declaration specifiers or '...' before string constant
      21 | MODULE_LICENSE("GPL v2");
         |                ^~~~~~~~
   In file included from include/crypto/internal/hash.h:11,
                    from arch/arm64/crypto/sha256-glue.c:11:
   arch/arm64/crypto/sha256-glue.c:22:21: error: expected ')' before string constant
      22 | MODULE_ALIAS_CRYPTO("sha224");
         |                     ^~~~~~~~
   include/crypto/algapi.h:44:55: note: in definition of macro 'MODULE_ALIAS_CRYPTO'
      44 |                 __MODULE_INFO(alias, alias_userspace, name);    \
         |                                                       ^~~~
   include/crypto/algapi.h:45:52: error: expected ')' before string constant
      45 |                 __MODULE_INFO(alias, alias_crypto, "crypto-" name)
         |                                                    ^~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:22:1: note: in expansion of macro 'MODULE_ALIAS_CRYPTO'
      22 | MODULE_ALIAS_CRYPTO("sha224");
         | ^~~~~~~~~~~~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:23:21: error: expected ')' before string constant
      23 | MODULE_ALIAS_CRYPTO("sha256");
         |                     ^~~~~~~~
   include/crypto/algapi.h:44:55: note: in definition of macro 'MODULE_ALIAS_CRYPTO'
      44 |                 __MODULE_INFO(alias, alias_userspace, name);    \
         |                                                       ^~~~
   include/crypto/algapi.h:45:52: error: expected ')' before string constant
      45 |                 __MODULE_INFO(alias, alias_crypto, "crypto-" name)
         |                                                    ^~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:23:1: note: in expansion of macro 'MODULE_ALIAS_CRYPTO'
      23 | MODULE_ALIAS_CRYPTO("sha256");
         | ^~~~~~~~~~~~~~~~~~~
>> arch/arm64/crypto/sha256-glue.c:194:1: warning: data definition has no type or storage class
     194 | module_init(sha256_mod_init);
         | ^~~~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:194:1: error: type defaults to 'int' in declaration of 'module_init' [-Werror=implicit-int]
>> arch/arm64/crypto/sha256-glue.c:194:1: warning: parameter names (without types) in function declaration
   arch/arm64/crypto/sha256-glue.c:195:1: warning: data definition has no type or storage class
     195 | module_exit(sha256_mod_fini);
         | ^~~~~~~~~~~
   arch/arm64/crypto/sha256-glue.c:195:1: error: type defaults to 'int' in declaration of 'module_exit' [-Werror=implicit-int]
   arch/arm64/crypto/sha256-glue.c:195:1: warning: parameter names (without types) in function declaration
   arch/arm64/crypto/sha256-glue.c:173:19: warning: 'sha256_mod_init' defined but not used [-Wunused-function]
     173 | static int __init sha256_mod_init(void)
         |                   ^~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +194 arch/arm64/crypto/sha256-glue.c

7918ecef073fe8 Ard Biesheuvel 2016-11-20  193  
7918ecef073fe8 Ard Biesheuvel 2016-11-20 @194  module_init(sha256_mod_init);

:::::: The code at line 194 was first introduced by commit
:::::: 7918ecef073fe80eeb399a37d8d48561864eedf1 crypto: arm64/sha2 - integrate OpenSSL implementations of SHA256/SHA512

:::::: TO: Ard Biesheuvel <ard.biesheuvel@linaro.org>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
