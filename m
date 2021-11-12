Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F28C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FE060F8F
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbhKLKW7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 05:22:59 -0500
Received: from mga05.intel.com ([192.55.52.43]:47526 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhKLKW6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 05:22:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="319317895"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="319317895"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 02:20:08 -0800
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="504832565"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 02:20:06 -0800
Date:   Fri, 12 Nov 2021 10:20:00 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     herbert@gondor.apana.org.au, kbuild-all@lists.01.org,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com
Subject: Re: [PATCH 13/24] crypto: qat - add pfvf_ops
Message-ID: <YY4/0D3CzOhkjiXr@silpixa00400314>
References: <20211110205217.99903-14-giovanni.cabiddu@intel.com>
 <202111121744.tlN4jsRt-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202111121744.tlN4jsRt-lkp@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 12, 2021 at 05:43:10PM +0800, kernel test robot wrote:
> Hi Giovanni,
> 
> Thank you for the patch! Yet something to improve:
Thanks. I identified the issue and I'm going to send a V2 of the set.

-- 
Giovanni
> 
> [auto build test ERROR on herbert-cryptodev-2.6/master]
> [also build test ERROR on herbert-crypto-2.6/master linus/master next-20211112]
> [cannot apply to v5.15]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Giovanni-Cabiddu/crypto-qat-PFVF-refactoring/20211111-045418
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: x86_64-randconfig-a002-20210928 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/3c769abfb3bc46aebd23323b3ed4ac36216dd51a
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Giovanni-Cabiddu/crypto-qat-PFVF-refactoring/20211111-045418
>         git checkout 3c769abfb3bc46aebd23323b3ed4ac36216dd51a
>         # save the attached .config to linux build tree
>         mkdir build_dir
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    ld: drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.o: in function `disable_vf2pf_interrupts':
> >> drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:151: undefined reference to `adf_gen2_disable_vf2pf_interrupts'
>    ld: drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.o: in function `enable_vf2pf_interrupts':
> >> drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:137: undefined reference to `adf_gen2_enable_vf2pf_interrupts'
>    ld: drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.o: in function `get_vf2pf_sources':
> >> drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:120: undefined reference to `adf_gen2_get_vf2pf_sources'
> 
> 
> vim +151 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
> 
> 22e4dda06dd0fa2 Allan, Bruce W  2015-01-09  115  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  116  static u32 get_vf2pf_sources(void __iomem *pmisc_bar)
> 993161d36ab5f0f Marco Chiappero 2021-09-28  117  {
> 993161d36ab5f0f Marco Chiappero 2021-09-28  118  	u32 errsou5, errmsk5, vf_int_mask;
> 993161d36ab5f0f Marco Chiappero 2021-09-28  119  
> 993161d36ab5f0f Marco Chiappero 2021-09-28 @120  	vf_int_mask = adf_gen2_get_vf2pf_sources(pmisc_bar);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  121  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  122  	/* Get the interrupt sources triggered by VFs, but to avoid duplicates
> 993161d36ab5f0f Marco Chiappero 2021-09-28  123  	 * in the work queue, clear vf_int_mask_sets bits that are already
> 993161d36ab5f0f Marco Chiappero 2021-09-28  124  	 * masked in ERRMSK register.
> 993161d36ab5f0f Marco Chiappero 2021-09-28  125  	 */
> 993161d36ab5f0f Marco Chiappero 2021-09-28  126  	errsou5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRSOU5);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  127  	errmsk5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRMSK5);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  128  	vf_int_mask |= ADF_DH895XCC_ERR_REG_VF2PF_U(errsou5);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  129  	vf_int_mask &= ~ADF_DH895XCC_ERR_REG_VF2PF_U(errmsk5);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  130  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  131  	return vf_int_mask;
> 993161d36ab5f0f Marco Chiappero 2021-09-28  132  }
> 993161d36ab5f0f Marco Chiappero 2021-09-28  133  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  134  static void enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
> 993161d36ab5f0f Marco Chiappero 2021-09-28  135  {
> 993161d36ab5f0f Marco Chiappero 2021-09-28  136  	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
> 993161d36ab5f0f Marco Chiappero 2021-09-28 @137  	adf_gen2_enable_vf2pf_interrupts(pmisc_addr, vf_mask);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  138  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  139  	/* Enable VF2PF Messaging Ints - VFs 16 through 31 per vf_mask[31:16] */
> 993161d36ab5f0f Marco Chiappero 2021-09-28  140  	if (vf_mask >> 16) {
> 993161d36ab5f0f Marco Chiappero 2021-09-28  141  		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5)
> 993161d36ab5f0f Marco Chiappero 2021-09-28  142  			  & ~ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  143  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  144  		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, val);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  145  	}
> 993161d36ab5f0f Marco Chiappero 2021-09-28  146  }
> 993161d36ab5f0f Marco Chiappero 2021-09-28  147  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  148  static void disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
> 993161d36ab5f0f Marco Chiappero 2021-09-28  149  {
> 993161d36ab5f0f Marco Chiappero 2021-09-28  150  	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
> 993161d36ab5f0f Marco Chiappero 2021-09-28 @151  	adf_gen2_disable_vf2pf_interrupts(pmisc_addr, vf_mask);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  152  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  153  	/* Disable VF2PF interrupts for VFs 16 through 31 per vf_mask[31:16] */
> 993161d36ab5f0f Marco Chiappero 2021-09-28  154  	if (vf_mask >> 16) {
> 993161d36ab5f0f Marco Chiappero 2021-09-28  155  		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5)
> 993161d36ab5f0f Marco Chiappero 2021-09-28  156  			  | ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  157  
> 993161d36ab5f0f Marco Chiappero 2021-09-28  158  		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, val);
> 993161d36ab5f0f Marco Chiappero 2021-09-28  159  	}
> 993161d36ab5f0f Marco Chiappero 2021-09-28  160  }
> 993161d36ab5f0f Marco Chiappero 2021-09-28  161  
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


