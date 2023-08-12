Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAF1C001DB
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Aug 2023 11:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjHLLaQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Aug 2023 07:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjHLLaO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Aug 2023 07:30:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF281E7B
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 04:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691839816; x=1723375816;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zxepW2DRCXsv+ofUCbgAIQqCB+KiMC1oG6uJAVwXWmQ=;
  b=eXl/SdUnWvDwuplhVbvtmQBKqusgwIUM9iAf1/gqFzVy/sG3qyi1NtTg
   k6cNQVWDtVrgo89bbx4H+z5Z9Gw3+8JihGSF88SrUfJyjWJTt7war/p6J
   0OBHlKtfcbFDrVjo//iC8MB1CIYqNS6YNMiFVLEBex10dZHLvoJ9WBvXN
   3FW2y+X6hWMeuRi4x+d6p0h1Iib2ZxZqHtNTcfuJRatY0gQQiox0YrKqX
   froW42vqnIdGYJl3IHyAy1IUjiPA8M6iwz+UBYNZRgDQNaRsTbWYGS6jb
   aYtZcI2ZwUVUq5gtRZ5JM0ghybsvO49DvNw9EzFONM1hE5Tq7ucrF+FrN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="374587864"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="374587864"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2023 04:30:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="798303316"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="798303316"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2023 04:30:13 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qUmou-0008XY-0o;
        Sat, 12 Aug 2023 11:30:12 +0000
Date:   Sat, 12 Aug 2023 19:29:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 22/36] crypto: sun8i-ce - Use new crypto_engine_op
 interface
Message-ID: <202308121917.EnLW5HaE-lkp@intel.com>
References: <E1qUOTQ-0020gC-0Q@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1qUOTQ-0020gC-0Q@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on next-20230809]
[cannot apply to herbert-crypto-2.6/master sunxi/sunxi/for-next linus/master v6.5-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-sun8i-ce-Remove-prepare-unprepare-request/20230811-173253
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/E1qUOTQ-0020gC-0Q%40formenos.hmeau.com
patch subject: [PATCH 22/36] crypto: sun8i-ce - Use new crypto_engine_op interface
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230812/202308121917.EnLW5HaE-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230812/202308121917.EnLW5HaE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308121917.EnLW5HaE-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/preempt.h:12,
                    from include/linux/bottom_half.h:6,
                    from drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c:14:
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c: In function 'sun8i_ce_cipher_fallback':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c:99:16: note: in expansion of macro 'container_of'
      99 |         algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
         |                ^~~~~~~~~~~~
--
   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/swait.h:5,
                    from include/linux/completion.h:12,
                    from include/linux/crypto.h:15,
                    from include/crypto/algapi.h:13,
                    from include/crypto/internal/hash.h:11,
                    from drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c:13:
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c: In function 'sun8i_ce_hash_final':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c:126:16: note: in expansion of macro 'container_of'
     126 |         algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
         |                ^~~~~~~~~~~~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c: In function 'sun8i_ce_hash_finup':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c:166:16: note: in expansion of macro 'container_of'
     166 |         algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
         |                ^~~~~~~~~~~~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c: In function 'sun8i_ce_hash_digest_fb':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
      20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c:191:16: note: in expansion of macro 'container_of'
     191 |         algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
         |                ^~~~~~~~~~~~


vim +78 include/linux/build_bug.h

bc6245e5efd70c Ian Abbott       2017-07-10  60  
6bab69c65013be Rasmus Villemoes 2019-03-07  61  /**
6bab69c65013be Rasmus Villemoes 2019-03-07  62   * static_assert - check integer constant expression at build time
6bab69c65013be Rasmus Villemoes 2019-03-07  63   *
6bab69c65013be Rasmus Villemoes 2019-03-07  64   * static_assert() is a wrapper for the C11 _Static_assert, with a
6bab69c65013be Rasmus Villemoes 2019-03-07  65   * little macro magic to make the message optional (defaulting to the
6bab69c65013be Rasmus Villemoes 2019-03-07  66   * stringification of the tested expression).
6bab69c65013be Rasmus Villemoes 2019-03-07  67   *
6bab69c65013be Rasmus Villemoes 2019-03-07  68   * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
6bab69c65013be Rasmus Villemoes 2019-03-07  69   * scope, but requires the expression to be an integer constant
6bab69c65013be Rasmus Villemoes 2019-03-07  70   * expression (i.e., it is not enough that __builtin_constant_p() is
6bab69c65013be Rasmus Villemoes 2019-03-07  71   * true for expr).
6bab69c65013be Rasmus Villemoes 2019-03-07  72   *
6bab69c65013be Rasmus Villemoes 2019-03-07  73   * Also note that BUILD_BUG_ON() fails the build if the condition is
6bab69c65013be Rasmus Villemoes 2019-03-07  74   * true, while static_assert() fails the build if the expression is
6bab69c65013be Rasmus Villemoes 2019-03-07  75   * false.
6bab69c65013be Rasmus Villemoes 2019-03-07  76   */
6bab69c65013be Rasmus Villemoes 2019-03-07  77  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
6bab69c65013be Rasmus Villemoes 2019-03-07 @78  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
6bab69c65013be Rasmus Villemoes 2019-03-07  79  
07a368b3f55a79 Maxim Levitsky   2022-10-25  80  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
