Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6345BC001E0
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Oct 2023 06:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjJUGrC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Oct 2023 02:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjJUGrC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2023 02:47:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5679D52
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 23:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697870816; x=1729406816;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BMmN8PvjKtY+UEnVZR8hGDWrMHsSetH3EUV6qoiVuI4=;
  b=CNIWdbFQ9zga2xCPhIfv7Enb+PXNCwb03KhXADwTMvnp7KAeXl5+nwzC
   MfNcJiuIx5xbs0srKQsWAmyOAINY8jWENTlbACiy6uBdpHftakv8GSupu
   tj6Ox7IjsYfDCywIEI1GCJ7GAtuPPVVbk351Njxr3MYT0bMVuJYPF35IC
   bZOWIkSE5inC42wZ2+Ncl3Bh4GZBM526GaZRuoX3T3MLSPpbnNABworkt
   fZffTA5tV1RPnYhrbv//Gfh7ob/nG7OCDTnFEDBhNY4pbLosKjLjXlqxH
   cWOBPzdVAtIA/mGHUZJ45oCctqZXRahlRT5ClYvRSwlP2fA1/wnJyJlk1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="385506388"
X-IronPort-AV: E=Sophos;i="6.03,240,1694761200"; 
   d="scan'208";a="385506388"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 23:46:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="901328780"
X-IronPort-AV: E=Sophos;i="6.03,240,1694761200"; 
   d="scan'208";a="901328780"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 20 Oct 2023 23:44:42 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qu5l5-0004X8-2h;
        Sat, 21 Oct 2023 06:46:51 +0000
Date:   Sat, 21 Oct 2023 14:46:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Srujana Challa <schalla@marvell.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
        bbrezillon@kernel.org, arno@natisbad.org, kuba@kernel.org,
        ndabilpuram@marvell.com, schalla@marvell.com
Subject: Re: [PATCH 03/10] crypto: octeontx2: add devlink option to set
 max_rxc_icb_cnt
Message-ID: <202310211411.QqrLly6F-lkp@intel.com>
References: <20231016064934.1913964-4-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016064934.1913964-4-schalla@marvell.com>
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
patch link:    https://lore.kernel.org/r/20231016064934.1913964-4-schalla%40marvell.com
patch subject: [PATCH 03/10] crypto: octeontx2: add devlink option to set max_rxc_icb_cnt
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20231021/202310211411.QqrLly6F-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231021/202310211411.QqrLly6F-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310211411.QqrLly6F-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c: In function 'rvu_cpt_init':
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c:1222:36: error: implicit declaration of function 'is_cn10ka_a0'; did you mean 'is_cnf10ka_a0'? [-Werror=implicit-function-declaration]
    1222 |             (!is_rvu_otx2(rvu) && !is_cn10ka_a0(rvu) && !is_cn10ka_a1(rvu))) {
         |                                    ^~~~~~~~~~~~
         |                                    is_cnf10ka_a0
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c:1222:58: error: implicit declaration of function 'is_cn10ka_a1'; did you mean 'is_cnf10ka_a0'? [-Werror=implicit-function-declaration]
    1222 |             (!is_rvu_otx2(rvu) && !is_cn10ka_a0(rvu) && !is_cn10ka_a1(rvu))) {
         |                                                          ^~~~~~~~~~~~
         |                                                          is_cnf10ka_a0
   cc1: some warnings being treated as errors


vim +1222 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

  1214	
  1215	int rvu_cpt_init(struct rvu *rvu)
  1216	{
  1217		u64 reg_val;
  1218	
  1219		/* Retrieve CPT PF number */
  1220		rvu->cpt_pf_num = get_cpt_pf_num(rvu);
  1221		if (is_block_implemented(rvu->hw, BLKADDR_CPT0) &&
> 1222		    (!is_rvu_otx2(rvu) && !is_cn10ka_a0(rvu) && !is_cn10ka_a1(rvu))) {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
