Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A41FC001E0
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Oct 2023 10:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjJUKEK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Oct 2023 06:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjJUKEJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2023 06:04:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69E51A4
        for <linux-crypto@vger.kernel.org>; Sat, 21 Oct 2023 03:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697882644; x=1729418644;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LDhf8SqgIzRjwu7NTPeGKJ/7xAfgLZBLFeqSrJvgaBk=;
  b=gwekXyCfOlIJ9M2bIl8O+c6yaHsCIJvKjDiDHmcnj0xK5ipgooI7TNs3
   9FCmZwSqfQVwz2QycSgyKwuB8+agoObL4IP5sycz9/RUFsp+N+IGj7aeO
   WZjGaF7z7OndTacc43DeAQ/vMfVfe6wH9SLms8GELVyfW3fmO3R5P+v/0
   KojF/4sAJLUi4ON0YhjJqe5LWdXI8djVyN7xa6YCNEyzlEicAM0owJ+/1
   Va49N9T6R3LB/mYgYNjZ2/chVr8l6a94YvVlGhmvZZHFUWZxjVB6POPP9
   tQePCkIExfLSD3KaPHteQ8wv7PvbOwWiq/pyy8Y+ZmnRmhYvQOQqveWyo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="371692002"
X-IronPort-AV: E=Sophos;i="6.03,240,1694761200"; 
   d="scan'208";a="371692002"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2023 03:04:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="751172339"
X-IronPort-AV: E=Sophos;i="6.03,240,1694761200"; 
   d="scan'208";a="751172339"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 21 Oct 2023 03:04:02 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qu8pr-0004iY-23;
        Sat, 21 Oct 2023 10:03:59 +0000
Date:   Sat, 21 Oct 2023 18:03:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Srujana Challa <schalla@marvell.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
        bbrezillon@kernel.org, arno@natisbad.org, kuba@kernel.org,
        ndabilpuram@marvell.com, schalla@marvell.com
Subject: Re: [PATCH 04/10] crypto: octeontx2: add devlink option to set t106
 mode
Message-ID: <202310211716.02lrxOQo-lkp@intel.com>
References: <20231016064934.1913964-5-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016064934.1913964-5-schalla@marvell.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Srujana,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.6-rc6 next-20231020]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Srujana-Challa/crypto-octeontx2-remove-CPT-block-reset/20231017-141612
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20231016064934.1913964-5-schalla%40marvell.com
patch subject: [PATCH 04/10] crypto: octeontx2: add devlink option to set t106 mode
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20231021/202310211716.02lrxOQo-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231021/202310211716.02lrxOQo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310211716.02lrxOQo-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c: In function 'otx2_cpt_register_dl':
>> drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c:208:9: error: implicit declaration of function 'devlink_params_publish'; did you mean 'devlink_params_register'? [-Werror=implicit-function-declaration]
     208 |         devlink_params_publish(dl);
         |         ^~~~~~~~~~~~~~~~~~~~~~
         |         devlink_params_register
   cc1: some warnings being treated as errors


vim +208 drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c

   181	
   182	int otx2_cpt_register_dl(struct otx2_cptpf_dev *cptpf)
   183	{
   184		struct device *dev = &cptpf->pdev->dev;
   185		struct otx2_cpt_devlink *cpt_dl;
   186		struct devlink *dl;
   187		int ret;
   188	
   189		dl = devlink_alloc(&otx2_cpt_devlink_ops,
   190				   sizeof(struct otx2_cpt_devlink), dev);
   191		if (!dl) {
   192			dev_warn(dev, "devlink_alloc failed\n");
   193			return -ENOMEM;
   194		}
   195	
   196		cpt_dl = devlink_priv(dl);
   197		cpt_dl->dl = dl;
   198		cpt_dl->cptpf = cptpf;
   199		cptpf->dl = dl;
   200		ret = devlink_params_register(dl, otx2_cpt_dl_params,
   201					      ARRAY_SIZE(otx2_cpt_dl_params));
   202		if (ret) {
   203			dev_err(dev, "devlink params register failed with error %d",
   204				ret);
   205			devlink_free(dl);
   206			return ret;
   207		}
 > 208		devlink_params_publish(dl);
   209		devlink_register(dl);
   210	
   211		return 0;
   212	}
   213	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
