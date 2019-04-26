Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64815C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 01:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49477206BF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 01:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfDZBhl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 21:37:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:36796 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfDZBhl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 21:37:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Apr 2019 18:37:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,395,1549958400"; 
   d="scan'208";a="340881738"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 25 Apr 2019 18:37:39 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hJpo2-000BW1-RE; Fri, 26 Apr 2019 09:37:38 +0800
Date:   Fri, 26 Apr 2019 09:37:15 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 136/163] drivers/crypto/ccree/cc_driver.c:112:16:
 sparse: sparse: cast to restricted __le32
Message-ID: <201904260914.Bqug5kZa%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   1036633e10f86b793e60dd8698c65df6712cad2a
commit: dcf6285d18ea147b3366de14121825be82a243f2 [136/163] crypto: ccree - add CID and PID support
reproduce:
        # apt-get install sparse
        git checkout dcf6285d18ea147b3366de14121825be82a243f2
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/ccree/cc_driver.c:37:6: sparse: sparse: symbol 'cc_sec_disable' was not declared. Should it be static?
>> drivers/crypto/ccree/cc_driver.c:112:16: sparse: sparse: cast to restricted __le32

vim +112 drivers/crypto/ccree/cc_driver.c

    36	
  > 37	bool cc_sec_disable;
    38	module_param_named(sec_disable, cc_sec_disable, bool, 0600);
    39	MODULE_PARM_DESC(cc_sec_disable, "Disable security functions");
    40	
    41	struct cc_hw_data {
    42		char *name;
    43		enum cc_hw_rev rev;
    44		u32 sig;
    45		u32 cidr_0123;
    46		u32 pidr_0124;
    47		int std_bodies;
    48	};
    49	
    50	#define CC_NUM_IDRS 4
    51	
    52	/* Note: PIDR3 holds CMOD/Rev so ignored for HW identification purposes */
    53	static const u32 pidr_0124_offsets[CC_NUM_IDRS] = {
    54		CC_REG(PERIPHERAL_ID_0), CC_REG(PERIPHERAL_ID_1),
    55		CC_REG(PERIPHERAL_ID_2), CC_REG(PERIPHERAL_ID_4)
    56	};
    57	
    58	static const u32 cidr_0123_offsets[CC_NUM_IDRS] = {
    59		CC_REG(COMPONENT_ID_0), CC_REG(COMPONENT_ID_1),
    60		CC_REG(COMPONENT_ID_2), CC_REG(COMPONENT_ID_3)
    61	};
    62	
    63	/* Hardware revisions defs. */
    64	
    65	/* The 703 is a OSCCA only variant of the 713 */
    66	static const struct cc_hw_data cc703_hw = {
    67		.name = "703", .rev = CC_HW_REV_713, .cidr_0123 = 0xB105F00DU,
    68		.pidr_0124 = 0x040BB0D0U, .std_bodies = CC_STD_OSCCA
    69	};
    70	
    71	static const struct cc_hw_data cc713_hw = {
    72		.name = "713", .rev = CC_HW_REV_713, .cidr_0123 = 0xB105F00DU,
    73		.pidr_0124 = 0x040BB0D0U, .std_bodies = CC_STD_ALL
    74	};
    75	
    76	static const struct cc_hw_data cc712_hw = {
    77		.name = "712", .rev = CC_HW_REV_712, .sig =  0xDCC71200U,
    78		.std_bodies = CC_STD_ALL
    79	};
    80	
    81	static const struct cc_hw_data cc710_hw = {
    82		.name = "710", .rev = CC_HW_REV_710, .sig =  0xDCC63200U,
    83		.std_bodies = CC_STD_ALL
    84	};
    85	
    86	static const struct cc_hw_data cc630p_hw = {
    87		.name = "630P", .rev = CC_HW_REV_630, .sig = 0xDCC63000U,
    88		.std_bodies = CC_STD_ALL
    89	};
    90	
    91	static const struct of_device_id arm_ccree_dev_of_match[] = {
    92		{ .compatible = "arm,cryptocell-703-ree", .data = &cc703_hw },
    93		{ .compatible = "arm,cryptocell-713-ree", .data = &cc713_hw },
    94		{ .compatible = "arm,cryptocell-712-ree", .data = &cc712_hw },
    95		{ .compatible = "arm,cryptocell-710-ree", .data = &cc710_hw },
    96		{ .compatible = "arm,cryptocell-630p-ree", .data = &cc630p_hw },
    97		{}
    98	};
    99	MODULE_DEVICE_TABLE(of, arm_ccree_dev_of_match);
   100	
   101	static u32 cc_read_idr(struct cc_drvdata *drvdata, const u32 *idr_offsets)
   102	{
   103		int i;
   104		union {
   105			u8 regs[CC_NUM_IDRS];
   106			u32 val;
   107		} idr;
   108	
   109		for (i = 0; i < CC_NUM_IDRS; ++i)
   110			idr.regs[i] = cc_ioread(drvdata, idr_offsets[i]);
   111	
 > 112		return le32_to_cpu(idr.val);
   113	}
   114	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
