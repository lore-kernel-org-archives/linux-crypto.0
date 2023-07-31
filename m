Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D626AC001DC
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jul 2023 12:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjGaMFK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jul 2023 08:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjGaMFF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2023 08:05:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB52410E2;
        Mon, 31 Jul 2023 05:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690805094; x=1722341094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3c6oBoFpHQziMzfCMoTU2TqpujXOOndbTD+TwZIrDJo=;
  b=A913f4LTDM+C7MRjsRDNGjnqxYvCV6QrR63PszcEFUOHfI9oGbxC9CJD
   03rKpp0xcNu8CDhRC25W4GxXcDjDc9/iwIxIwinc15I3OnDiu+a61lxPT
   uW2N86mqOCL3dLRjG0uQ4NI8q/pnl0YXLQqOHLB1rmzyoPq49YCBzfKsn
   NZwHXBT8Nb2RhLfhtBIbpeGTgUH1mltk86TVwKzZWdjOoIG99nfrZXC7/
   7oZL99gBk1drSDm5yfmI998+de2KpNyeDQpWntedQ1owW5Y6GupnkdxDK
   cx4Y3WoL+OCAE5aM2m+xzgkkXUTD8zN32MA2UW0Q86JPNpVlmygMmrHPY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="369014395"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="369014395"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 05:04:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="728286546"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="728286546"
Received: from lkp-server02.sh.intel.com (HELO 953e8cd98f7d) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 31 Jul 2023 05:04:34 -0700
Received: from kbuild by 953e8cd98f7d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qQRdZ-00056l-2Q;
        Mon, 31 Jul 2023 12:04:33 +0000
Date:   Mon, 31 Jul 2023 20:04:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     LeoLiu-oc <LeoLiu-oc@zhaoxin.com>, olivia@selenic.com,
        herbert@gondor.apana.org.au, jiajie.ho@starfivetech.com,
        conor.dooley@microchip.com, martin@kaiser.cx, mmyangfl@gmail.com,
        jenny.zhang@starfivetech.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, leoliu@zhaoxin.com,
        CobeChen@zhaoxin.com, YunShen@zhaoxin.com, TonyWWang@zhaoxin.com,
        leoliu-oc <leoliu-oc@zhaoxin.com>
Subject: Re: [PATCH v2 2/2] hwrng: add Zhaoxin HW RNG driver
Message-ID: <202307311942.Qpu13qjG-lkp@intel.com>
References: <20230731084515.2057375-3-LeoLiu-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731084515.2057375-3-LeoLiu-oc@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi LeoLiu-oc,

kernel test robot noticed the following build errors:

[auto build test ERROR on char-misc/char-misc-testing]
[also build test ERROR on char-misc/char-misc-next char-misc/char-misc-linus herbert-cryptodev-2.6/master linus/master v6.5-rc4 next-20230731]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/LeoLiu-oc/hwrng-via-rng-convert-to-x86_cpu_id-probing/20230731-164950
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20230731084515.2057375-3-LeoLiu-oc%40zhaoxin.com
patch subject: [PATCH v2 2/2] hwrng: add Zhaoxin HW RNG driver
config: openrisc-randconfig-r025-20230731 (https://download.01.org/0day-ci/archive/20230731/202307311942.Qpu13qjG-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230731/202307311942.Qpu13qjG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307311942.Qpu13qjG-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/char/hw_random/zhaoxin-rng.c:16:10: fatal error: asm/cpu_device_id.h: No such file or directory
      16 | #include <asm/cpu_device_id.h>
         |          ^~~~~~~~~~~~~~~~~~~~~
   compilation terminated.


vim +16 drivers/char/hw_random/zhaoxin-rng.c

  > 16	#include <asm/cpu_device_id.h>
    17	#include <asm/fpu/api.h>
    18	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
