Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10615C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Feb 2022 13:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiBONsF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Feb 2022 08:48:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238418AbiBONsD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Feb 2022 08:48:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9640DFE3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Feb 2022 05:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644932872; x=1676468872;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2UAUvyzwxNEYemBY9ZEdKEkeTMqJuAaln8vIyIpz+Eg=;
  b=YANGPNoXw7XHWRKTtkwglJrFZCLBDqgFoWEPWCT74Oiy4sSMfcQDY4S0
   NqtJTangtGPxbl3nALS9em+bpUuWF456dZ34p+3qm1RtK0UbAChDVWtc+
   7kEHd2dc8LilJjsrSS7rLDkTtNryL2/Pi1kQit27XPRb76LyAkpgbDOci
   p4AgQirFrs0mdwOKVIZwcCyiRzj4E/Lt6q4RxcnCSveFBT1+XKQPFMbjl
   9zmTTvSswxdxgq19UqUf3Fe/SgXYbPVBpWyIUlEB9xcHQWtqY17i8VGkR
   CrCEhQvjN3aR0i5FQbf72x6m8FMthum1/H7v/23UOUjDTEyboxg4TML3t
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="313627392"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="313627392"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 05:47:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="497138677"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 15 Feb 2022 05:47:50 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nJyBK-0009ho-6l; Tue, 15 Feb 2022 13:47:50 +0000
Date:   Tue, 15 Feb 2022 21:47:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     kbuild-all@lists.01.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: crypto_xor - use helpers for unaligned accesses
Message-ID: <202202152134.HZ9sQwkL-lkp@intel.com>
References: <20220215105717.184572-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215105717.184572-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

I love your patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master v5.17-rc4 next-20220215]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ard-Biesheuvel/crypto-crypto_xor-use-helpers-for-unaligned-accesses/20220215-185741
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220215/202202152134.HZ9sQwkL-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/6ca2d09816a67230ab30f3c7e7d87815e833d0af
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ard-Biesheuvel/crypto-crypto_xor-use-helpers-for-unaligned-accesses/20220215-185741
        git checkout 6ca2d09816a67230ab30f3c7e7d87815e833d0af
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from arch/arc/include/asm/unaligned.h:11,
                    from arch/arc/include/asm/io.h:12,
                    from include/linux/io.h:13,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/arc/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/highmem.h:11,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/bio.h:10,
                    from drivers/md/dm-crypt.c:16:
   In function 'crypto_xor_cpy',
       inlined from 'crypt_iv_tcw_whitening.isra' at drivers/md/dm-crypt.c:645:2:
>> include/asm-generic/unaligned.h:14:15: warning: '*(const struct <anonymous> *)(&buf[0]).x' is used uninitialized [-Wuninitialized]
      14 |         __pptr->x;                                                              \
         |         ~~~~~~^~~
   include/asm-generic/unaligned.h:22:33: note: in expansion of macro '__get_unaligned_t'
      22 | #define get_unaligned(ptr)      __get_unaligned_t(typeof(*(ptr)), (ptr))
         |                                 ^~~~~~~~~~~~~~~~~
   include/crypto/algapi.h:183:29: note: in expansion of macro 'get_unaligned'
     183 |                         l = get_unaligned(d) ^ get_unaligned(s1++)
         |                             ^~~~~~~~~~~~~
   drivers/md/dm-crypt.c: In function 'crypt_iv_tcw_whitening.isra':
   drivers/md/dm-crypt.c:640:12: note: 'buf' declared here
     640 |         u8 buf[TCW_WHITENING_SIZE];
         |            ^~~
   In file included from arch/arc/include/asm/unaligned.h:11,
                    from arch/arc/include/asm/io.h:12,
                    from include/linux/io.h:13,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/arc/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/highmem.h:11,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/bio.h:10,
                    from drivers/md/dm-crypt.c:16:
   In function 'crypto_xor_cpy',
       inlined from 'crypt_iv_tcw_whitening.isra' at drivers/md/dm-crypt.c:645:2:
   include/asm-generic/unaligned.h:14:15: warning: '*(const struct <anonymous> *)(&buf[4]).x' is used uninitialized [-Wuninitialized]
      14 |         __pptr->x;                                                              \
         |         ~~~~~~^~~
   include/asm-generic/unaligned.h:22:33: note: in expansion of macro '__get_unaligned_t'
      22 | #define get_unaligned(ptr)      __get_unaligned_t(typeof(*(ptr)), (ptr))
         |                                 ^~~~~~~~~~~~~~~~~
   include/crypto/algapi.h:183:29: note: in expansion of macro 'get_unaligned'
     183 |                         l = get_unaligned(d) ^ get_unaligned(s1++)
         |                             ^~~~~~~~~~~~~
   drivers/md/dm-crypt.c: In function 'crypt_iv_tcw_whitening.isra':
   drivers/md/dm-crypt.c:640:12: note: 'buf' declared here
     640 |         u8 buf[TCW_WHITENING_SIZE];
         |            ^~~
   In file included from arch/arc/include/asm/unaligned.h:11,
                    from arch/arc/include/asm/io.h:12,
                    from include/linux/io.h:13,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/arc/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/highmem.h:11,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/bio.h:10,
                    from drivers/md/dm-crypt.c:16:
   In function 'crypto_xor_cpy',
       inlined from 'crypt_iv_tcw_whitening.isra' at drivers/md/dm-crypt.c:646:2:
   include/asm-generic/unaligned.h:14:15: warning: '*(const struct <anonymous> *)(&buf[8]).x' is used uninitialized [-Wuninitialized]
      14 |         __pptr->x;                                                              \
         |         ~~~~~~^~~
   include/asm-generic/unaligned.h:22:33: note: in expansion of macro '__get_unaligned_t'
      22 | #define get_unaligned(ptr)      __get_unaligned_t(typeof(*(ptr)), (ptr))
         |                                 ^~~~~~~~~~~~~~~~~
   include/crypto/algapi.h:183:29: note: in expansion of macro 'get_unaligned'
     183 |                         l = get_unaligned(d) ^ get_unaligned(s1++)
         |                             ^~~~~~~~~~~~~
   drivers/md/dm-crypt.c: In function 'crypt_iv_tcw_whitening.isra':
   drivers/md/dm-crypt.c:640:12: note: 'buf' declared here
     640 |         u8 buf[TCW_WHITENING_SIZE];
         |            ^~~
   In file included from arch/arc/include/asm/unaligned.h:11,
                    from arch/arc/include/asm/io.h:12,
                    from include/linux/io.h:13,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/arc/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/highmem.h:11,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/bio.h:10,
                    from drivers/md/dm-crypt.c:16:
   In function 'crypto_xor_cpy',
       inlined from 'crypt_iv_tcw_whitening.isra' at drivers/md/dm-crypt.c:646:2:
   include/asm-generic/unaligned.h:14:15: warning: '*(const struct <anonymous> *)(&buf[12]).x' is used uninitialized [-Wuninitialized]
      14 |         __pptr->x;                                                              \
         |         ~~~~~~^~~
   include/asm-generic/unaligned.h:22:33: note: in expansion of macro '__get_unaligned_t'
      22 | #define get_unaligned(ptr)      __get_unaligned_t(typeof(*(ptr)), (ptr))
         |                                 ^~~~~~~~~~~~~~~~~
   include/crypto/algapi.h:183:29: note: in expansion of macro 'get_unaligned'
     183 |                         l = get_unaligned(d) ^ get_unaligned(s1++)
         |                             ^~~~~~~~~~~~~
   drivers/md/dm-crypt.c: In function 'crypt_iv_tcw_whitening.isra':
   drivers/md/dm-crypt.c:640:12: note: 'buf' declared here
     640 |         u8 buf[TCW_WHITENING_SIZE];
         |            ^~~


vim +14 include/asm-generic/unaligned.h

aafe4dbed0bf6c Arnd Bergmann 2009-05-13  11  
803f4e1eab7a89 Arnd Bergmann 2021-05-08  12  #define __get_unaligned_t(type, ptr) ({						\
803f4e1eab7a89 Arnd Bergmann 2021-05-08  13  	const struct { type x; } __packed *__pptr = (typeof(__pptr))(ptr);	\
803f4e1eab7a89 Arnd Bergmann 2021-05-08 @14  	__pptr->x;								\
803f4e1eab7a89 Arnd Bergmann 2021-05-08  15  })
803f4e1eab7a89 Arnd Bergmann 2021-05-08  16  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
