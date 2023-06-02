Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616FEC7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 22:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbjFBW7P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 18:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbjFBW7N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 18:59:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CEAE62
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 15:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685746747; x=1717282747;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=sUMEbFM86zU0fMuhT+iHRBGTBzBlHqfh0Ve0b2k8dDs=;
  b=Hffsi3PJKdGzdtpczM30Hv0LpFmzRZE+9jBE8BaQ4DL3ds9JT2OEWokN
   /aQPRevtELGSZPgtWVCw8D109JQ6OThvRMepFROwmooz/mSx/P3qDyaPT
   C7pVKCi9dlKn9YwEwcT8YUv1sDAbCFIQHKGg/BGdSLXBKVqX3xI7iXNXD
   fpB9m7Y3r0jB1kVSP80ZWrwi5H2NuNpyeuV3gM6gWLohgPg4fQNHdcV6G
   PhQkXtx3RQN9F+407kOs9pwjsfKsH+ezf8m2pHjgFG/dFhKxZs+e6G3/F
   JufgumV0Evdr4VWCVzuS/V0k/itY2DGBhmD7D+VOEXOI85994Fk4bi+Ec
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="419527338"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="419527338"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 15:59:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="737695985"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="737695985"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 02 Jun 2023 15:59:05 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q5Djc-00012H-1x;
        Fri, 02 Jun 2023 22:59:04 +0000
Date:   Sat, 3 Jun 2023 06:58:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [herbert-cryptodev-2.6:master 45/47]
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c:69:9: error: implicit
 declaration of function 'adf_dbgfs_exit'; did you mean 'adf_dbgfs_init'?
Message-ID: <202306030654.5t4qkyN1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   1d217fa26680b074dbb44f6183f971a5304eaf8b
commit: 9260db6640a61ebba5348ceae7fa26307d9d5b0e [45/47] crypto: qat - move dbgfs init to separate file
config: parisc-randconfig-r005-20230531 (https://download.01.org/0day-ci/archive/20230603/202306030654.5t4qkyN1-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=9260db6640a61ebba5348ceae7fa26307d9d5b0e
        git remote add herbert-cryptodev-2.6 https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
        git fetch --no-tags herbert-cryptodev-2.6 master
        git checkout 9260db6640a61ebba5348ceae7fa26307d9d5b0e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=parisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash drivers/crypto/intel/qat/qat_c3xxxvf/ drivers/crypto/intel/qat/qat_c62x/ drivers/crypto/intel/qat/qat_dh895xcc/ fs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306030654.5t4qkyN1-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c: In function 'adf_cleanup_accel':
>> drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c:69:9: error: implicit declaration of function 'adf_dbgfs_exit'; did you mean 'adf_dbgfs_init'? [-Werror=implicit-function-declaration]
      69 |         adf_dbgfs_exit(accel_dev);
         |         ^~~~~~~~~~~~~~
         |         adf_dbgfs_init
   cc1: some warnings being treated as errors
--
   drivers/crypto/intel/qat/qat_c62x/adf_drv.c: In function 'adf_cleanup_accel':
>> drivers/crypto/intel/qat/qat_c62x/adf_drv.c:69:9: error: implicit declaration of function 'adf_dbgfs_exit'; did you mean 'adf_dbgfs_init'? [-Werror=implicit-function-declaration]
      69 |         adf_dbgfs_exit(accel_dev);
         |         ^~~~~~~~~~~~~~
         |         adf_dbgfs_init
   cc1: some warnings being treated as errors
--
   drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c: In function 'adf_cleanup_accel':
>> drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c:68:9: error: implicit declaration of function 'adf_dbgfs_exit'; did you mean 'adf_dbgfs_init'? [-Werror=implicit-function-declaration]
      68 |         adf_dbgfs_exit(accel_dev);
         |         ^~~~~~~~~~~~~~
         |         adf_dbgfs_init
   cc1: some warnings being treated as errors


vim +69 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c

    45	
    46	static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
    47	{
    48		struct adf_accel_pci *accel_pci_dev = &accel_dev->accel_pci_dev;
    49		int i;
    50	
    51		for (i = 0; i < ADF_PCI_MAX_BARS; i++) {
    52			struct adf_bar *bar = &accel_pci_dev->pci_bars[i];
    53	
    54			if (bar->virt_addr)
    55				pci_iounmap(accel_pci_dev->pci_dev, bar->virt_addr);
    56		}
    57	
    58		if (accel_dev->hw_device) {
    59			switch (accel_pci_dev->pci_dev->device) {
    60			case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
    61				adf_clean_hw_data_dh895xcc(accel_dev->hw_device);
    62				break;
    63			default:
    64				break;
    65			}
    66			kfree(accel_dev->hw_device);
    67			accel_dev->hw_device = NULL;
    68		}
  > 69		adf_dbgfs_exit(accel_dev);
    70		adf_cfg_dev_remove(accel_dev);
    71		adf_devmgr_rm_dev(accel_dev, NULL);
    72	}
    73	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
