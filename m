Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACAFC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 07:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241208AbiE0HfZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 03:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347541AbiE0HfY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 03:35:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47622F748B
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 00:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653636921; x=1685172921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VYwmOmBPjINlynsTfW5Xd7vJTN2cgivmkkg3cKE8lqk=;
  b=gPvrifL2p15c6BhA/REl3CL7GgFspW3mMLZHOiESWPXhJtY+6jDQQQjH
   gCFImpDMxGPqEz0IoSgyXjvDUjF647fJIQwLXcLIybTqH3DkaxpdV14ia
   QaNqwcmKpRAe8AGwhgbqzj4sywNn++u7PbAmT0+zkIC3mk3kzKhDV+I6u
   R8T///u5bX9od9hVCjFTf861aTMH+X7A+TuT/FowvNrTgvko6foQ2kKx7
   The8QbWVZh8lzR8r7sOZA6CbqKVFTUlpC/N5RPA7Ghc8+rWlxhiSBKTVa
   ZMNjQLDvNKr75tNaWS+rmT0G0PEGvu2paLsymuLExiAw+7WJw4VKPZyIx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="256481559"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="256481559"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 00:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="610114827"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 27 May 2022 00:35:19 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nuUVC-0004WS-Fo;
        Fri, 27 May 2022 07:35:18 +0000
Date:   Fri, 27 May 2022 15:34:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     kbuild-all@lists.01.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH crypto] crypto: poly1305 - cleanup stray
 CRYPTO_LIB_POLY1305_RSIZE
Message-ID: <202205271557.oReeyAVT-lkp@intel.com>
References: <20220526093547.212294-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526093547.212294-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi "Jason,

I love your patch! Yet something to improve:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master crng-random/master v5.18 next-20220526]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-A-Donenfeld/crypto-poly1305-cleanup-stray-CRYPTO_LIB_POLY1305_RSIZE/20220526-173718
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: i386-debian-10.3-kselftests (https://download.01.org/0day-ci/archive/20220527/202205271557.oReeyAVT-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/fde026a9e6312b3278b170ca6a41cd84a6fb935e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jason-A-Donenfeld/crypto-poly1305-cleanup-stray-CRYPTO_LIB_POLY1305_RSIZE/20220526-173718
        git checkout fde026a9e6312b3278b170ca6a41cd84a6fb935e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash lib/crypto/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/crypto/internal/poly1305.h:11,
                    from lib/crypto/poly1305-donna32.c:11:
>> include/crypto/poly1305.h:56:46: error: 'CONFIG_CRYPTO_LIB_POLY1305_RSIZE' undeclared here (not in a function); did you mean 'CONFIG_CRYPTO_POLY1305_MODULE'?
      56 |                 struct poly1305_key opaque_r[CONFIG_CRYPTO_LIB_POLY1305_RSIZE];
         |                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                              CONFIG_CRYPTO_POLY1305_MODULE


vim +56 include/crypto/poly1305.h

878afc35cd28bc Eric Biggers       2018-11-16  40  
2546f811ef45fc Martin Willi       2015-07-16  41  struct poly1305_desc_ctx {
2546f811ef45fc Martin Willi       2015-07-16  42  	/* partial buffer */
2546f811ef45fc Martin Willi       2015-07-16  43  	u8 buf[POLY1305_BLOCK_SIZE];
2546f811ef45fc Martin Willi       2015-07-16  44  	/* bytes used in partial buffer */
2546f811ef45fc Martin Willi       2015-07-16  45  	unsigned int buflen;
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  46  	/* how many keys have been set in r[] */
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  47  	unsigned short rset;
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  48  	/* whether s[] has been set */
2546f811ef45fc Martin Willi       2015-07-16  49  	bool sset;
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  50  	/* finalize key */
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  51  	u32 s[4];
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  52  	/* accumulator */
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  53  	struct poly1305_state h;
ad8f5b88383ea6 Ard Biesheuvel     2019-11-08  54  	/* key */
1c08a104360f3e Jason A. Donenfeld 2020-01-05  55  	union {
1c08a104360f3e Jason A. Donenfeld 2020-01-05 @56  		struct poly1305_key opaque_r[CONFIG_CRYPTO_LIB_POLY1305_RSIZE];
1c08a104360f3e Jason A. Donenfeld 2020-01-05  57  		struct poly1305_core_key core_r;
1c08a104360f3e Jason A. Donenfeld 2020-01-05  58  	};
2546f811ef45fc Martin Willi       2015-07-16  59  };
2546f811ef45fc Martin Willi       2015-07-16  60  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
