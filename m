Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A301C3815B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 13:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B7722070B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 13:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgDTN47 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 09:56:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:3768 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgDTN46 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 09:56:58 -0400
IronPort-SDR: mZ1ZPEcgWDQOUqXeP8GTLlwbHcg7fBMp0BX1IURozetuIUmeb3drRwsj3UAISfnJqNhpif9rcg
 L6atUAchD4EQ==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 06:56:58 -0700
IronPort-SDR: +RFjbCz6EuCuWy+VGeZ9m7L9kKKFAP81OLLBnSiqehL2XnTM29U9AxTw8iz77tCptHKCWxu/JO
 MXur0L2X7Azg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,406,1580803200"; 
   d="gz'50?scan'50,208,50";a="258351024"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2020 06:56:53 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jQWuq-000B7w-Vn; Mon, 20 Apr 2020 21:56:52 +0800
Date:   Mon, 20 Apr 2020 21:56:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 7/26] cctrng.c:undefined reference to
 `devm_ioremap_resource'
Message-ID: <202004202145.t2vRqPRr%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   3357b61177a7f34267256098b29a7f4992af40f3
commit: a583ed310bb6b514e717c11a30b5a7bc3a65d1b1 [7/26] hwrng: cctrng - introduce Arm CryptoCell driver
config: um-kunit_defconfig (attached as .config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce:
        git checkout a583ed310bb6b514e717c11a30b5a7bc3a65d1b1
        # save the attached .config to linux build tree
        make ARCH=um 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   /usr/bin/ld: drivers/char/hw_random/cctrng.o: in function `cctrng_probe':
>> cctrng.c:(.text+0x36f): undefined reference to `devm_ioremap_resource'
   collect2: error: ld returned 1 exit status

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--HcAYCG3uE/tztfnV
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
xNsBaF4Df9E4DMJnDer/F6EE7KmwRgAA

--HcAYCG3uE/tztfnV--
