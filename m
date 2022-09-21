Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33346ECAAD8
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Sep 2022 04:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiIUEv1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Sep 2022 00:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIUEvJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Sep 2022 00:51:09 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8179E7D7B5
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 21:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663735866; x=1695271866;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UW395vIxglVQDSDO3HwtYk1twddnHI3slTRWZcVfxnY=;
  b=Tlx0GdJ/368jeMwn4yrTd8n0j3I7gPvZyb3IkOSQEQ0bgg+fNRkOHtxo
   GWL05JPLcauRsiHuA2ms2hri6sVNkIkvY+E/e6qI1Xl4FnmEuKl/FGtcD
   gvWwqdiPN+7VhcUjXMqxZb/s7hhv8srdiKJ5EZ28i9X5fk1GfSf+rnj2M
   8OKtOqJEYsdiOzlVrwTPDQh0am6Azc5E9uu5gaVRv+pJjzbmQse3CM02I
   DzeQ7+EPtTbUE982owfjF/2ZIX3uEhaqLr92LHoloyNwUAAL9bKv1znLX
   U6IuBUYHPG+HFNDP7LrdvQYId+TeInEQ8AzpSgdL1uaTlx1PKawShoJX/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="286968369"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="286968369"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 21:51:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="652379705"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 20 Sep 2022 21:51:04 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oarhP-0003FB-2A;
        Wed, 21 Sep 2022 04:51:03 +0000
Date:   Wed, 21 Sep 2022 12:50:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Harliman Liem <pliem@maxlinear.com>, atenart@kernel.org,
        herbert@gondor.apana.org.au
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>
Subject: Re: [PATCH 2/3] crypto: inside-secure - Add fw_little_endian option
Message-ID: <202209211245.XnqzyM7N-lkp@intel.com>
References: <29cf210c9adce088bc50248ad46255d883bd5edc.1663660578.git.pliem@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29cf210c9adce088bc50248ad46255d883bd5edc.1663660578.git.pliem@maxlinear.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Peter,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.0-rc6 next-20220920]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Harliman-Liem/crypto-inside-secure-Expand-soc-data-structure/20220920-170235
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: parisc-randconfig-s051-20220921 (https://download.01.org/0day-ci/archive/20220921/202209211245.XnqzyM7N-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/637d1b2810d1e9da47b6a637f9cea7c5bb4bf765
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peter-Harliman-Liem/crypto-inside-secure-Expand-soc-data-structure/20220920-170235
        git checkout 637d1b2810d1e9da47b6a637f9cea7c5bb4bf765
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=parisc SHELL=/bin/bash drivers/crypto/inside-secure/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/inside-secure/safexcel.c:326:31: sparse: sparse: cast to restricted __le32
>> drivers/crypto/inside-secure/safexcel.c:326:31: sparse: sparse: cast to restricted __le32
>> drivers/crypto/inside-secure/safexcel.c:326:31: sparse: sparse: cast to restricted __le32
>> drivers/crypto/inside-secure/safexcel.c:326:31: sparse: sparse: cast to restricted __le32
>> drivers/crypto/inside-secure/safexcel.c:326:31: sparse: sparse: cast to restricted __le32
>> drivers/crypto/inside-secure/safexcel.c:326:31: sparse: sparse: cast to restricted __le32
   drivers/crypto/inside-secure/safexcel.c:328:31: sparse: sparse: cast to restricted __be32

vim +326 drivers/crypto/inside-secure/safexcel.c

   315	
   316	static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
   317					  const struct firmware *fw)
   318	{
   319		const u32 *data = (const u32 *)fw->data;
   320		u32 val;
   321		int i;
   322	
   323		/* Write the firmware */
   324		for (i = 0; i < fw->size / sizeof(u32); i++) {
   325			if (priv->data->fw_little_endian)
 > 326				val = le32_to_cpu(data[i]);
   327			else
   328				val = be32_to_cpu(data[i]);
   329	
   330			writel(val,
   331			       priv->base + EIP197_CLASSIFICATION_RAMS +
   332			       i * sizeof(*data));
   333		}
   334	
   335		/* Exclude final 2 NOPs from size */
   336		return i - EIP197_FW_TERMINAL_NOPS;
   337	}
   338	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
