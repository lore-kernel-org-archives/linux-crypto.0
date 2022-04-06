Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919B3C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 21:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbiDFVR5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiDFVRs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 17:17:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4532C2EE8
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 13:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649275537; x=1680811537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FctlQkIAqE+cllDctVQPEUPq8utwGbBmotBsI91dU78=;
  b=gpMyBX/JXB3wBFL+9W+KGMgPawh0aoQNSbf/EvWgxxozZjV7CPiF+eNN
   5m4ueSwRd3TeumIyiU8z6y3uWKCX25njz6DaR7XOGBjDAuNX7fJmLwbBJ
   WlqAjZaWDxk+D+j04SdMQye8EfofejGfnqEEY/AhnQsgYg5TrLkHQDZTq
   Wl8yGI6iSVdxI8o+7GhczSyCnhcckmTYIUbz9QTMBfD3h5UJ9lNRduG7J
   vyc1T2jyVEIQD50jt/U9jRxzzLWaUasxukkvOtusHeOSJum25kvxSCC9y
   yf30iCq92eS1aP2Uvn0hBqj/dNDbKDbFs1cj7Ee7lgZ9TdyKlomIBLyzS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="258733797"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="258733797"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 13:05:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="524622729"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 06 Apr 2022 13:05:35 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncBuJ-0004iB-1v;
        Wed, 06 Apr 2022 20:05:35 +0000
Date:   Thu, 7 Apr 2022 04:05:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     kbuild-all@lists.01.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 7/8] crypto: ahash - avoid DMA alignment for request
 structures unless needed
Message-ID: <202204070345.cL3xZHZm-lkp@intel.com>
References: <20220406142715.2270256-8-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406142715.2270256-8-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

I love your patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master sunxi/sunxi/for-next v5.18-rc1 next-20220406]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Ard-Biesheuvel/crypto-avoid-DMA-padding-for-request-structures/20220407-010855
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220407/202204070345.cL3xZHZm-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/072f0a01b9f98cd545d8179b1591b9f37be5cb2a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ard-Biesheuvel/crypto-avoid-DMA-padding-for-request-structures/20220407-010855
        git checkout 072f0a01b9f98cd545d8179b1591b9f37be5cb2a
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash drivers/crypto/inside-secure/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/vdso/const.h:5,
                    from include/linux/const.h:4,
                    from include/linux/list.h:9,
                    from include/linux/preempt.h:11,
                    from arch/m68k/include/asm/irqflags.h:6,
                    from include/linux/irqflags.h:16,
                    from arch/m68k/include/asm/atomic.h:6,
                    from include/linux/atomic.h:7,
                    from include/linux/crypto.h:15,
                    from include/crypto/aes.h:10,
                    from drivers/crypto/inside-secure/safexcel_hash.c:8:
   In function 'ahash_request_ctx',
       inlined from 'safexcel_ahash_exit_inv' at drivers/crypto/inside-secure/safexcel_hash.c:627:36:
>> include/crypto/hash.h:421:26: warning: '*(struct ahash_request *)(&__req_desc[0]).base.tfm' is used uninitialized [-Wuninitialized]
     421 |                          crypto_tfm_alg_req_alignmask(req->base.tfm) + 1);
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:32:50: note: in definition of macro '__ALIGN_KERNEL_MASK'
      32 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                                  ^~~~
   include/linux/align.h:8:33: note: in expansion of macro '__ALIGN_KERNEL'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ^~~~~~~~~~~~~~
   include/linux/align.h:11:45: note: in expansion of macro 'ALIGN'
      11 | #define PTR_ALIGN(p, a)         ((typeof(p))ALIGN((unsigned long)(p), (a)))
         |                                             ^~~~~
   include/crypto/hash.h:420:16: note: in expansion of macro 'PTR_ALIGN'
     420 |         return PTR_ALIGN(&req->__ctx,
         |                ^~~~~~~~~
   In file included from drivers/crypto/inside-secure/safexcel_hash.c:21:
   drivers/crypto/inside-secure/safexcel_hash.c: In function 'safexcel_ahash_exit_inv':
   drivers/crypto/inside-secure/safexcel.h:69:14: note: '__req_desc' declared here
      69 |         char __##name##_desc[size] CRYPTO_MINALIGN_ATTR; \
         |              ^~
   drivers/crypto/inside-secure/safexcel_hash.c:626:9: note: in expansion of macro 'EIP197_REQUEST_ON_STACK'
     626 |         EIP197_REQUEST_ON_STACK(req, ahash, EIP197_AHASH_REQ_SIZE);
         |         ^~~~~~~~~~~~~~~~~~~~~~~


vim +421 include/crypto/hash.h

   417	
   418	static inline void *ahash_request_ctx(struct ahash_request *req)
   419	{
   420		return PTR_ALIGN(&req->__ctx,
 > 421				 crypto_tfm_alg_req_alignmask(req->base.tfm) + 1);
   422	}
   423	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
