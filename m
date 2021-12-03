Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CA1C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 21:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbhLCVaG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 16:30:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:24702 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233581AbhLCVaF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 16:30:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="300444599"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="300444599"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 13:26:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="561896077"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 03 Dec 2021 13:26:22 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtG4U-000I3F-3w; Fri, 03 Dec 2021 21:26:22 +0000
Date:   Sat, 4 Dec 2021 05:25:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Gonda <pgonda@google.com>, thomas.lendacky@amd.com
Cc:     kbuild-all@lists.01.org, David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH V5 5/5] crypto: ccp - Add SEV_INIT_EX support
Message-ID: <202112040501.zlOm5XQW-lkp@intel.com>
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
config: x86_64-randconfig-a002-20211203 (https://download.01.org/0day-ci/archive/20211204/202112040501.zlOm5XQW-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/32a279c228e30c47be88442fe20f890203854d9c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Peter-Gonda/Add-SEV_INIT_EX-support/20211203-224846
        git checkout 32a279c228e30c47be88442fe20f890203854d9c
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/crypto/ccp/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/x86/include/asm/bug.h:84,
                    from include/linux/bug.h:5,
                    from include/linux/jump_label.h:262,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:40,
                    from arch/x86/include/asm/ptrace.h:97,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:13,
                    from arch/x86/include/asm/timex.h:5,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/crypto/ccp/sev-dev.c:10:
   drivers/crypto/ccp/sev-dev.c: In function 'sev_read_init_ex_file':
>> include/linux/lockdep.h:286:52: error: invalid type argument of '->' (have 'struct mutex')
     286 | #define lockdep_is_held(lock)  lock_is_held(&(lock)->dep_map)
         |                                                    ^~
   include/asm-generic/bug.h:121:25: note: in definition of macro 'WARN_ON'
     121 |  int __ret_warn_on = !!(condition);    \
         |                         ^~~~~~~~~
   include/linux/lockdep.h:316:2: note: in expansion of macro 'lockdep_assert'
     316 |  lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |  ^~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: in expansion of macro 'lockdep_is_held'
     316 |  lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |                 ^~~~~~~~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:179:2: note: in expansion of macro 'lockdep_assert_held'
     179 |  lockdep_assert_held(sev_cmd_mutex);
         |  ^~~~~~~~~~~~~~~~~~~
   drivers/crypto/ccp/sev-dev.c: In function 'sev_write_init_ex_file':
>> include/linux/lockdep.h:286:52: error: invalid type argument of '->' (have 'struct mutex')
     286 | #define lockdep_is_held(lock)  lock_is_held(&(lock)->dep_map)
         |                                                    ^~
   include/asm-generic/bug.h:121:25: note: in definition of macro 'WARN_ON'
     121 |  int __ret_warn_on = !!(condition);    \
         |                         ^~~~~~~~~
   include/linux/lockdep.h:316:2: note: in expansion of macro 'lockdep_assert'
     316 |  lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |  ^~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: in expansion of macro 'lockdep_is_held'
     316 |  lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |                 ^~~~~~~~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:215:2: note: in expansion of macro 'lockdep_assert_held'
     215 |  lockdep_assert_held(sev_cmd_mutex);
         |  ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/device.h:15,
                    from drivers/crypto/ccp/psp-dev.h:13,
                    from drivers/crypto/ccp/sev-dev.c:29:
   drivers/crypto/ccp/sev-dev.c:223:4: warning: format '%d' expects argument of type 'int', but argument 3 has type 'long int' [-Wformat=]
     223 |    "SEV: could not open file for write, error %d\n",
         |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:110:16: note: in definition of macro 'dev_printk_index_wrap'
     110 |   _p_func(dev, fmt, ##__VA_ARGS__);   \
         |                ^~~
   include/linux/dev_printk.h:144:49: note: in expansion of macro 'dev_fmt'
     144 |  dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                 ^~~~~~~
   drivers/crypto/ccp/sev-dev.c:222:3: note: in expansion of macro 'dev_err'
     222 |   dev_err(sev->dev,
         |   ^~~~~~~
   drivers/crypto/ccp/sev-dev.c:223:48: note: format string is defined here
     223 |    "SEV: could not open file for write, error %d\n",
         |                                               ~^
         |                                                |
         |                                                int
         |                                               %ld
   In file included from arch/x86/include/asm/bug.h:84,
                    from include/linux/bug.h:5,
                    from include/linux/jump_label.h:262,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:40,
                    from arch/x86/include/asm/ptrace.h:97,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:13,
                    from arch/x86/include/asm/timex.h:5,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/crypto/ccp/sev-dev.c:10:
   drivers/crypto/ccp/sev-dev.c: In function 'sev_write_init_ex_file_if_required':
>> include/linux/lockdep.h:286:52: error: invalid type argument of '->' (have 'struct mutex')
     286 | #define lockdep_is_held(lock)  lock_is_held(&(lock)->dep_map)
         |                                                    ^~
   include/asm-generic/bug.h:121:25: note: in definition of macro 'WARN_ON'
     121 |  int __ret_warn_on = !!(condition);    \
         |                         ^~~~~~~~~
   include/linux/lockdep.h:316:2: note: in expansion of macro 'lockdep_assert'
     316 |  lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |  ^~~~~~~~~~~~~~
   include/linux/lockdep.h:316:17: note: in expansion of macro 'lockdep_is_held'
     316 |  lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |                 ^~~~~~~~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:244:2: note: in expansion of macro 'lockdep_assert_held'
     244 |  lockdep_assert_held(sev_cmd_mutex);
         |  ^~~~~~~~~~~~~~~~~~~
   drivers/crypto/ccp/sev-dev.c: In function 'sev_pci_init':
   drivers/crypto/ccp/sev-dev.c:1250:15: warning: unused variable 'tmr_page' [-Wunused-variable]
    1250 |  struct page *tmr_page;
         |               ^~~~~~~~


vim +286 include/linux/lockdep.h

f607c668577481 Peter Zijlstra 2009-07-20  285  
f8319483f57f1c Peter Zijlstra 2016-11-30 @286  #define lockdep_is_held(lock)		lock_is_held(&(lock)->dep_map)
f8319483f57f1c Peter Zijlstra 2016-11-30  287  #define lockdep_is_held_type(lock, r)	lock_is_held_type(&(lock)->dep_map, (r))
f607c668577481 Peter Zijlstra 2009-07-20  288  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
