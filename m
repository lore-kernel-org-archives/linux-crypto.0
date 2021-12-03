Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CE0C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 21:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbhLCVaF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 16:30:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:18811 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238454AbhLCVaF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 16:30:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="261073141"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="261073141"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 13:26:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="577615485"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 03 Dec 2021 13:26:22 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtG4U-000I3I-4H; Fri, 03 Dec 2021 21:26:22 +0000
Date:   Sat, 4 Dec 2021 05:25:28 +0800
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
Message-ID: <202112040513.JRZWd1LU-lkp@intel.com>
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

I love your patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master kvm/queue linus/master v5.16-rc3 next-20211203]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Peter-Gonda/Add-SEV_INIT_EX-support/20211203-224846
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: x86_64-randconfig-c007-20211203 (https://download.01.org/0day-ci/archive/20211204/202112040513.JRZWd1LU-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/crypto/ccp/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/crypto/ccp/sev-dev.c:179:2: error: member reference type 'struct mutex' is not a pointer; did you mean to use '.'?
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
   drivers/crypto/ccp/sev-dev.c:179:2: error: cannot take the address of an rvalue of type 'struct lockdep_map'
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
>> drivers/crypto/ccp/sev-dev.c:224:4: warning: format specifies type 'int' but the argument has type 'long' [-Wformat]
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


vim +224 drivers/crypto/ccp/sev-dev.c

   207	
   208	static void sev_write_init_ex_file(void)
   209	{
   210		struct sev_device *sev = psp_master->sev_data;
   211		struct file *fp;
   212		loff_t offset = 0;
   213		ssize_t nwrite;
   214	
   215		lockdep_assert_held(sev_cmd_mutex);
   216	
   217		if (!sev_init_ex_buffer)
   218			return;
   219	
   220		fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
   221		if (IS_ERR(fp)) {
   222			dev_err(sev->dev,
   223				"SEV: could not open file for write, error %d\n",
 > 224				PTR_ERR(fp));
   225			return;
   226		}
   227	
   228		nwrite = kernel_write(fp, sev_init_ex_buffer, NV_LENGTH, &offset);
   229		vfs_fsync(fp, 0);
   230		filp_close(fp, NULL);
   231	
   232		if (nwrite != NV_LENGTH) {
   233			dev_err(sev->dev,
   234				"SEV: failed to write %u bytes to non volatile memory area, ret %ld\n",
   235				NV_LENGTH, nwrite);
   236			return;
   237		}
   238	
   239		dev_dbg(sev->dev, "SEV: write successful to NV file\n");
   240	}
   241	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
