Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F8ECE79CE
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 13:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbjITN6S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbjITN6F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 09:58:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BD110C7
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 06:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695218252; x=1726754252;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=p1x2Ttzj8WjkBiDYr4XpsFCCMdbi2Yl7HFiQzRHr2I0=;
  b=H9qeSKg24xYBPc5Wi17XgsvUdSnTTobpYFU2V53aXr5gZlD2PSRvnJhb
   iMdiHDHkr4uVOp9FNXFfr255kEdg/5UB8KGAaceTQzWgqkCchG82J/M52
   IRHsIX6NdNcvjFrA2BenwMhiFQ8Wbgo3+H9z2NiZGTEFrtRk9n1KBXzk7
   G0BAsqVPvTkR0Y9+U8V+YrqihnqT9CWrH/u3ZRsJZUVXjKisbCAtvyEkI
   BaaIQIrfIsEGBnwqpSma7L9xngb3TNCR7o6lxJSwbZ/N0wskxCoprbBjF
   rYg21eaX7gSKvJOCnk5ggIwiw5sX3TwceyiAQiS8GCpXFHmll/rBjEak3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="379110186"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="379110186"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 06:57:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="723294913"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="723294913"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 20 Sep 2023 06:57:30 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qixho-0008nQ-1Q;
        Wed, 20 Sep 2023 13:57:28 +0000
Date:   Wed, 20 Sep 2023 21:57:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 47/64] xfrm_algo.c:undefined reference
 to `crypto_has_aead'
Message-ID: <202309202112.33V1Ezb1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   1c43c0f1f84aa59dfc98ce66f0a67b2922aa7f9d
commit: a1383e2ab102c4e0d25304c07c66232c23ee0d9b [47/64] ipsec: Stop using crypto_has_alg
config: arc-defconfig (https://download.01.org/0day-ci/archive/20230920/202309202112.33V1Ezb1-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230920/202309202112.33V1Ezb1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309202112.33V1Ezb1-lkp@intel.com/

All errors (new ones prefixed by >>):

   arc-elf-ld: net/xfrm/xfrm_algo.o: in function `xfrm_aead_get_byname':
>> xfrm_algo.c:(.text+0x46c): undefined reference to `crypto_has_aead'
>> arc-elf-ld: xfrm_algo.c:(.text+0x46c): undefined reference to `crypto_has_aead'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
