Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD04C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Feb 2022 17:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiBORCO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Feb 2022 12:02:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242080AbiBORCO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Feb 2022 12:02:14 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5DA119F3C
        for <linux-crypto@vger.kernel.org>; Tue, 15 Feb 2022 09:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644944523; x=1676480523;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z13Y5lNt52SwgdcOjACeM02u4yxevlg0/5f+qMCZWEA=;
  b=T6e9CSbeOn/MQXH9hgZMCZINDucfgY4fQNSxpkpgk+eptPfd0d4+bUul
   iPLCdPXuZAuVwohyVYIRjdQ9FrGdbIf+LzXKGc777qLdnojPGrYxMoODu
   Wfv3sA80MTlRkif3pUb7hMko6yS5Dc3AnmonwdDx9YeztikxMyidcoUhR
   t5A/kJ8GL4ne3HU7+c7nXDotPpWo0Ma5g7qzNlziC3TidUMe5u8+B4J7/
   vjvo3GKrQwwzXo8oW4LgaOoqT/UDaxDFab24XUCyhNCw3QdLiAo5suzZw
   IU26GuifTFsRZKTj7lOaRV9LMmvYhM8NeI1spvHbTWbsGJPpQmjco7wgp
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="233938337"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="233938337"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:02:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="528961528"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 15 Feb 2022 09:02:01 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nK1DE-0009sG-AQ; Tue, 15 Feb 2022 17:02:00 +0000
Date:   Wed, 16 Feb 2022 01:01:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     kbuild-all@lists.01.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: crypto_xor - use helpers for unaligned accesses
Message-ID: <202202160048.w2jucJCP-lkp@intel.com>
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
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220216/202202160048.w2jucJCP-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/6ca2d09816a67230ab30f3c7e7d87815e833d0af
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ard-Biesheuvel/crypto-crypto_xor-use-helpers-for-unaligned-accesses/20220215-185741
        git checkout 6ca2d09816a67230ab30f3c7e7d87815e833d0af
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kernel/ drivers/md/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from ./arch/x86/include/generated/asm/unaligned.h:1,
                    from drivers/md/dm-crypt.c:30:
   drivers/md/dm-crypt.c: In function 'crypt_iv_tcw_whitening':
>> include/asm-generic/unaligned.h:14:8: warning: 'buf.x' is used uninitialized in this function [-Wuninitialized]
      14 |  __pptr->x;        \
         |        ^~
>> include/asm-generic/unaligned.h:14:8: warning: '*((void *)&buf+4).x' is used uninitialized in this function [-Wuninitialized]
   include/asm-generic/unaligned.h:14:8: warning: '*((void *)&buf+8).x' is used uninitialized in this function [-Wuninitialized]
   include/asm-generic/unaligned.h:14:8: warning: '*((void *)&buf+12).x' is used uninitialized in this function [-Wuninitialized]


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
