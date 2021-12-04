Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9C2C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Dec 2021 03:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384128AbhLDDR5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 22:17:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:57081 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384126AbhLDDR5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 22:17:57 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="217778463"
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="217778463"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 19:14:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="603869773"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 03 Dec 2021 19:14:29 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtLVN-000INx-40; Sat, 04 Dec 2021 03:14:29 +0000
Date:   Sat, 4 Dec 2021 11:13:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Gonda <pgonda@google.com>, thomas.lendacky@amd.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH V5 5/5] crypto: ccp - Add SEV_INIT_EX support
Message-ID: <202112041112.wJCjLloK-lkp@intel.com>
References: <20211203144642.3460447-6-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203144642.3460447-6-pgonda@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Peter,

I love your patch! Yet something to improve:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master kvm/queue linus/master v5.16-rc3 next-20211203]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Peter-Gonda/Add-SEV_INIT_EX-support/20211203-224846
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: x86_64-randconfig-c007-20211203 (https://download.01.org/0day-ci/archive/20211204/202112041112.wJCjLloK-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project d30fcadf07ee552f20156ea90be2fdb54cb9cb08)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/32a279c228e30c47be88442fe20f890203854d9c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Peter-Gonda/Add-SEV_INIT_EX-support/20211203-224846
        git checkout 32a279c228e30c47be88442fe20f890203854d9c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/crypto/ccp/sev-dev.c:179:2: error: member reference type 'struct mutex' is not a pointer; did you mean to use '.'?
           lockdep_assert_held(sev_cmd_mutex);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: expanded from macro 'lockdep_assert_held'
           lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
           ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:286:52: note: expanded from macro 'lockdep_is_held'
   #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
                                                               ^
   include/linux/lockdep.h:310:32: note: expanded from macro 'lockdep_assert'
           do { WARN_ON(debug_locks && !(cond)); } while (0)
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:121:25: note: expanded from macro 'WARN_ON'
           int __ret_warn_on = !!(condition);                              \
                                  ^~~~~~~~~
>> drivers/crypto/ccp/sev-dev.c:179:2: error: cannot take the address of an rvalue of type 'struct lockdep_map'
           lockdep_assert_held(sev_cmd_mutex);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: expanded from macro 'lockdep_assert_held'
           lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
           ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:286:45: note: expanded from macro 'lockdep_is_held'
   #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
                                                        ^
   include/linux/lockdep.h:310:32: note: expanded from macro 'lockdep_assert'
           do { WARN_ON(debug_locks && !(cond)); } while (0)
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:121:25: note: expanded from macro 'WARN_ON'
           int __ret_warn_on = !!(condition);                              \
                                  ^~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:215:2: error: member reference type 'struct mutex' is not a pointer; did you mean to use '.'?
           lockdep_assert_held(sev_cmd_mutex);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: expanded from macro 'lockdep_assert_held'
           lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
           ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:286:52: note: expanded from macro 'lockdep_is_held'
   #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
                                                               ^
   include/linux/lockdep.h:310:32: note: expanded from macro 'lockdep_assert'
           do { WARN_ON(debug_locks && !(cond)); } while (0)
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:121:25: note: expanded from macro 'WARN_ON'
           int __ret_warn_on = !!(condition);                              \
                                  ^~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:215:2: error: cannot take the address of an rvalue of type 'struct lockdep_map'
           lockdep_assert_held(sev_cmd_mutex);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: expanded from macro 'lockdep_assert_held'
           lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
           ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:286:45: note: expanded from macro 'lockdep_is_held'
   #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
                                                        ^
   include/linux/lockdep.h:310:32: note: expanded from macro 'lockdep_assert'
           do { WARN_ON(debug_locks && !(cond)); } while (0)
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:121:25: note: expanded from macro 'WARN_ON'
           int __ret_warn_on = !!(condition);                              \
                                  ^~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:224:4: warning: format specifies type 'int' but the argument has type 'long' [-Wformat]
                           PTR_ERR(fp));
                           ^~~~~~~~~~~
   include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
           dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                                  ~~~     ^~~~~~~~~~~
   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
                                ~~~    ^~~~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:244:2: error: member reference type 'struct mutex' is not a pointer; did you mean to use '.'?
           lockdep_assert_held(sev_cmd_mutex);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: expanded from macro 'lockdep_assert_held'
           lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
           ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:286:52: note: expanded from macro 'lockdep_is_held'
   #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
                                                               ^
   include/linux/lockdep.h:310:32: note: expanded from macro 'lockdep_assert'
           do { WARN_ON(debug_locks && !(cond)); } while (0)
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:121:25: note: expanded from macro 'WARN_ON'
           int __ret_warn_on = !!(condition);                              \
                                  ^~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:244:2: error: cannot take the address of an rvalue of type 'struct lockdep_map'
           lockdep_assert_held(sev_cmd_mutex);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: expanded from macro 'lockdep_assert_held'
           lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
           ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:286:45: note: expanded from macro 'lockdep_is_held'
   #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
                                                        ^
   include/linux/lockdep.h:310:32: note: expanded from macro 'lockdep_assert'
           do { WARN_ON(debug_locks && !(cond)); } while (0)
                ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:121:25: note: expanded from macro 'WARN_ON'
           int __ret_warn_on = !!(condition);                              \
                                  ^~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:1250:15: warning: unused variable 'tmr_page' [-Wunused-variable]
           struct page *tmr_page;
                        ^
   2 warnings and 6 errors generated.


vim +179 drivers/crypto/ccp/sev-dev.c

   172	
   173	static int sev_read_init_ex_file(void)
   174	{
   175		struct sev_device *sev = psp_master->sev_data;
   176		struct file *fp;
   177		ssize_t nread;
   178	
 > 179		lockdep_assert_held(sev_cmd_mutex);
   180	
   181		if (!sev_init_ex_buffer)
   182			return -EOPNOTSUPP;
   183	
   184		fp = filp_open(init_ex_path, O_RDONLY, 0);
   185		if (IS_ERR(fp)) {
   186			int ret = PTR_ERR(fp);
   187	
   188			dev_err(sev->dev,
   189				"SEV: could not open %s for read, error %d\n",
   190				init_ex_path, ret);
   191			return ret;
   192		}
   193	
   194		nread = kernel_read(fp, sev_init_ex_buffer, NV_LENGTH, NULL);
   195		if (nread != NV_LENGTH) {
   196			dev_err(sev->dev,
   197				"SEV: failed to read %u bytes to non volatile memory area, ret %ld\n",
   198				NV_LENGTH, nread);
   199			return -EIO;
   200		}
   201	
   202		dev_dbg(sev->dev, "SEV: read %ld bytes from NV file\n", nread);
   203		filp_close(fp, NULL);
   204	
   205		return 0;
   206	}
   207	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
