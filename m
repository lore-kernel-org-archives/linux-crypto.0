Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DA1C3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 12:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A3721897
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 12:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfH3MbZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 08:31:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:18024 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfH3MbZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 08:31:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 05:31:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,447,1559545200"; 
   d="gz'50?scan'50,208,50";a="193317254"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 30 Aug 2019 05:31:18 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1i3g3h-00078W-En; Fri, 30 Aug 2019 20:31:17 +0800
Date:   Fri, 30 Aug 2019 20:29:31 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 241/242] include/asm-generic/qspinlock.h:65:55:
 warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg'
 differ in signedness
Message-ID: <201908302048.mHBv1l98%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jiayyxjsuvphaf5g"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--jiayyxjsuvphaf5g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   1bbbbcfdc0f0fa7a98ba0d551fd03d2c45d5a318
commit: 9ecf5ad522e09d6e11a7e0a0b1845622a480f478 [241/242] crypto: sha256 - Add missing MODULE_LICENSE() to lib/crypto/sha256.c
config: x86_64-randconfig-c001-201934 (attached as .config)
compiler: gcc-7 (Debian 7.4.0-11) 7.4.0
reproduce:
        git checkout 9ecf5ad522e09d6e11a7e0a0b1845622a480f478
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qspinlock.h: In function 'queued_spin_trylock':
>> include/asm-generic/qspinlock.h:65:55: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     return likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL));
                                                          ^
   include/linux/compiler.h:33:34: note: in definition of macro '__branch_check__'
       ______r = __builtin_expect(!!(x), expect); \
                                     ^
>> include/asm-generic/qspinlock.h:65:9: note: in expansion of macro 'likely'
     return likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL));
            ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
>> include/asm-generic/qspinlock.h:65:55: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     return likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL));
                                                          ^
   include/linux/compiler.h:35:19: note: in definition of macro '__branch_check__'
              expect, is_constant); \
                      ^~~~~~~~~~~
>> include/asm-generic/qspinlock.h:65:9: note: in expansion of macro 'likely'
     return likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL));
            ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qspinlock.h: In function 'queued_spin_lock':
   include/asm-generic/qspinlock.h:78:52: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
                                                       ^
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                       ^~~~
>> include/asm-generic/qspinlock.h:78:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qspinlock.h:78:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qspinlock.h:78:52: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
                                                       ^
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                       ^~~~
>> include/asm-generic/qspinlock.h:78:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qspinlock.h:78:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qspinlock.h:78:52: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
                                                       ^
   include/linux/compiler.h:58:61: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                                ^~~~
>> include/asm-generic/qspinlock.h:78:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qspinlock.h:78:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qspinlock.h:78:52: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
                                                       ^
   include/linux/compiler.h:58:61: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                                ^~~~
>> include/asm-generic/qspinlock.h:78:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qspinlock.h:78:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qspinlock.h:78:52: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
                                                       ^
   include/linux/compiler.h:69:3: note: in definition of macro '__trace_if_value'
     (cond) ?     \
      ^~~~
   include/linux/compiler.h:56:28: note: in expansion of macro '__trace_if_var'
    #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                               ^~~~~~~~~~~~~~
>> include/asm-generic/qspinlock.h:78:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qspinlock.h:78:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qspinlock.h:78:52: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
                                                       ^
   include/linux/compiler.h:69:3: note: in definition of macro '__trace_if_value'
     (cond) ?     \
      ^~~~
   include/linux/compiler.h:56:28: note: in expansion of macro '__trace_if_var'
    #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                               ^~~~~~~~~~~~~~
>> include/asm-generic/qspinlock.h:78:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qspinlock.h:78:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qrwlock.h: In function 'queued_write_trylock':
>> include/asm-generic/qrwlock.h:65:56: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     return likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts,
                                                           ^
   include/linux/compiler.h:33:34: note: in definition of macro '__branch_check__'
       ______r = __builtin_expect(!!(x), expect); \
                                     ^
>> include/asm-generic/qrwlock.h:65:9: note: in expansion of macro 'likely'
     return likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts,
            ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
>> include/asm-generic/qrwlock.h:65:56: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     return likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts,
                                                           ^
   include/linux/compiler.h:35:19: note: in definition of macro '__branch_check__'
              expect, is_constant); \
                      ^~~~~~~~~~~
>> include/asm-generic/qrwlock.h:65:9: note: in expansion of macro 'likely'
     return likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts,
            ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qrwlock.h: In function 'queued_write_lock':
   include/asm-generic/qrwlock.h:92:53: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
                                                        ^
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                       ^~~~
>> include/asm-generic/qrwlock.h:92:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qrwlock.h:92:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qrwlock.h:92:53: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
                                                        ^
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                       ^~~~
>> include/asm-generic/qrwlock.h:92:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qrwlock.h:92:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qrwlock.h:92:53: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
                                                        ^
   include/linux/compiler.h:58:61: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                                ^~~~
>> include/asm-generic/qrwlock.h:92:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qrwlock.h:92:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qrwlock.h:92:53: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
                                                        ^
   include/linux/compiler.h:58:61: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                                ^~~~
>> include/asm-generic/qrwlock.h:92:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qrwlock.h:92:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qrwlock.h:92:53: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
                                                        ^
   include/linux/compiler.h:69:3: note: in definition of macro '__trace_if_value'
     (cond) ?     \
      ^~~~
   include/linux/compiler.h:56:28: note: in expansion of macro '__trace_if_var'
    #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                               ^~~~~~~~~~~~~~
>> include/asm-generic/qrwlock.h:92:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qrwlock.h:92:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/bitops.h:16:0,
                    from include/linux/bitops.h:19,
                    from lib/crypto/sha256.c:14:
   include/asm-generic/qrwlock.h:92:53: warning: pointer targets in passing argument 2 of 'atomic_try_cmpxchg' differ in signedness [-Wpointer-sign]
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
                                                        ^
   include/linux/compiler.h:69:3: note: in definition of macro '__trace_if_value'
     (cond) ?     \
      ^~~~
   include/linux/compiler.h:56:28: note: in expansion of macro '__trace_if_var'
    #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                               ^~~~~~~~~~~~~~
>> include/asm-generic/qrwlock.h:92:2: note: in expansion of macro 'if'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
     ^~
   include/linux/compiler.h:45:22: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__branch_check__(x, 1, __builtin_constant_p(x)))
                         ^~~~~~~~~~~~~~~~
   include/asm-generic/qrwlock.h:92:6: note: in expansion of macro 'likely'
     if (likely(atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED)))
         ^~~~~~
   In file included from arch/x86/include/asm/atomic.h:265:0,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:249,
                    from include/linux/static_key.h:1,
                    from arch/x86/include/asm/nospec-branch.h:6,
                    from arch/x86/include/asm/paravirt_types.h:46,
                    from arch/x86/include/asm/ptrace.h:94,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:12,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from lib/crypto/sha256.c:16:
   include/asm-generic/atomic-instrumented.h:691:1: note: expected 'int *' but argument is of type 'u32 * {aka unsigned int *}'
    atomic_try_cmpxchg(atomic_t *v, int *old, int new)
    ^~~~~~~~~~~~~~~~~~

vim +/atomic_try_cmpxchg +65 include/asm-generic/qspinlock.h

a33fda35e3a765 Waiman Long    2015-04-24  43  
a33fda35e3a765 Waiman Long    2015-04-24  44  /**
a33fda35e3a765 Waiman Long    2015-04-24  45   * queued_spin_is_contended - check if the lock is contended
a33fda35e3a765 Waiman Long    2015-04-24  46   * @lock : Pointer to queued spinlock structure
a33fda35e3a765 Waiman Long    2015-04-24  47   * Return: 1 if lock contended, 0 otherwise
a33fda35e3a765 Waiman Long    2015-04-24  48   */
a33fda35e3a765 Waiman Long    2015-04-24  49  static __always_inline int queued_spin_is_contended(struct qspinlock *lock)
a33fda35e3a765 Waiman Long    2015-04-24  50  {
a33fda35e3a765 Waiman Long    2015-04-24  51  	return atomic_read(&lock->val) & ~_Q_LOCKED_MASK;
a33fda35e3a765 Waiman Long    2015-04-24  52  }
a33fda35e3a765 Waiman Long    2015-04-24  53  /**
a33fda35e3a765 Waiman Long    2015-04-24  54   * queued_spin_trylock - try to acquire the queued spinlock
a33fda35e3a765 Waiman Long    2015-04-24  55   * @lock : Pointer to queued spinlock structure
a33fda35e3a765 Waiman Long    2015-04-24  56   * Return: 1 if lock acquired, 0 if failed
a33fda35e3a765 Waiman Long    2015-04-24  57   */
a33fda35e3a765 Waiman Long    2015-04-24  58  static __always_inline int queued_spin_trylock(struct qspinlock *lock)
a33fda35e3a765 Waiman Long    2015-04-24  59  {
27df89689e257c Matthew Wilcox 2018-08-20  60  	u32 val = atomic_read(&lock->val);
27df89689e257c Matthew Wilcox 2018-08-20  61  
27df89689e257c Matthew Wilcox 2018-08-20  62  	if (unlikely(val))
a33fda35e3a765 Waiman Long    2015-04-24  63  		return 0;
27df89689e257c Matthew Wilcox 2018-08-20  64  
27df89689e257c Matthew Wilcox 2018-08-20 @65  	return likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL));
a33fda35e3a765 Waiman Long    2015-04-24  66  }
a33fda35e3a765 Waiman Long    2015-04-24  67  
a33fda35e3a765 Waiman Long    2015-04-24  68  extern void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
a33fda35e3a765 Waiman Long    2015-04-24  69  
a33fda35e3a765 Waiman Long    2015-04-24  70  /**
a33fda35e3a765 Waiman Long    2015-04-24  71   * queued_spin_lock - acquire a queued spinlock
a33fda35e3a765 Waiman Long    2015-04-24  72   * @lock: Pointer to queued spinlock structure
a33fda35e3a765 Waiman Long    2015-04-24  73   */
a33fda35e3a765 Waiman Long    2015-04-24  74  static __always_inline void queued_spin_lock(struct qspinlock *lock)
a33fda35e3a765 Waiman Long    2015-04-24  75  {
27df89689e257c Matthew Wilcox 2018-08-20  76  	u32 val = 0;
a33fda35e3a765 Waiman Long    2015-04-24  77  
27df89689e257c Matthew Wilcox 2018-08-20 @78  	if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
a33fda35e3a765 Waiman Long    2015-04-24  79  		return;
27df89689e257c Matthew Wilcox 2018-08-20  80  
a33fda35e3a765 Waiman Long    2015-04-24  81  	queued_spin_lock_slowpath(lock, val);
a33fda35e3a765 Waiman Long    2015-04-24  82  }
a33fda35e3a765 Waiman Long    2015-04-24  83  

:::::: The code at line 65 was first introduced by commit
:::::: 27df89689e257cccb604fdf56c91a75a25aa554a locking/spinlocks: Remove an instruction from spin and write locks

:::::: TO: Matthew Wilcox <willy@infradead.org>
:::::: CC: Ingo Molnar <mingo@kernel.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--jiayyxjsuvphaf5g
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--jiayyxjsuvphaf5g--
