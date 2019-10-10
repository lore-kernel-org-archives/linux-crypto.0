Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FDCC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 13:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550F8208C3
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 13:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfJJNxe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 09:53:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:15874 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfJJNxd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 09:53:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 06:53:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,280,1566889200"; 
   d="scan'208";a="277784035"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 10 Oct 2019 06:53:31 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iIYsl-000ETz-B3; Thu, 10 Oct 2019 21:53:31 +0800
Date:   Thu, 10 Oct 2019 21:53:11 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hui Tang <tanghui20@huawei.com>
Subject: [cryptodev:master 66/78]
 drivers/crypto/hisilicon/hpre/hpre_main.c:450:16: sparse: sparse: incorrect
 type in assignment (different base types)
Message-ID: <201910102109.AWW4BMfE%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   504582e8e40b90b8f8c58783e2d1e4f6a2b71a3a
commit: c8b4b477079d1995cc0a1c10d5cdfd02be938cdf [66/78] crypto: hisilicon - add HiSilicon HPRE accelerator
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout c8b4b477079d1995cc0a1c10d5cdfd02be938cdf
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/hisilicon/hpre/hpre_main.c:450:16: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted pci_ers_result_t [usertype] qm_ret @@    got e] qm_ret @@
>> drivers/crypto/hisilicon/hpre/hpre_main.c:450:16: sparse:    expected restricted pci_ers_result_t [usertype] qm_ret
>> drivers/crypto/hisilicon/hpre/hpre_main.c:450:16: sparse:    got int
--
>> drivers/crypto/hisilicon/hpre/hpre_crypto.c:378:26: sparse: sparse: restricted __le16 degrades to integer
>> drivers/crypto/hisilicon/hpre/hpre_crypto.c:475:26: sparse: sparse: invalid assignment: |=
>> drivers/crypto/hisilicon/hpre/hpre_crypto.c:475:26: sparse:    left side has type restricted __le32
>> drivers/crypto/hisilicon/hpre/hpre_crypto.c:475:26: sparse:    right side has type int
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:477:26: sparse: sparse: invalid assignment: |=
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:477:26: sparse:    left side has type restricted __le32
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:477:26: sparse:    right side has type int
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:740:26: sparse: sparse: invalid assignment: |=
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:740:26: sparse:    left side has type restricted __le32
   drivers/crypto/hisilicon/hpre/hpre_crypto.c:740:26: sparse:    right side has type int

vim +450 drivers/crypto/hisilicon/hpre/hpre_main.c

   443	
   444	static pci_ers_result_t hpre_process_hw_error(struct pci_dev *pdev)
   445	{
   446		struct hpre *hpre = pci_get_drvdata(pdev);
   447		pci_ers_result_t qm_ret, hpre_ret;
   448	
   449		/* log qm error */
 > 450		qm_ret = hisi_qm_hw_error_handle(&hpre->qm);
   451	
   452		/* log hpre error */
   453		hpre_ret = hpre_hw_error_handle(hpre);
   454	
   455		return (qm_ret == PCI_ERS_RESULT_NEED_RESET ||
   456			hpre_ret == PCI_ERS_RESULT_NEED_RESET) ?
   457			PCI_ERS_RESULT_NEED_RESET : PCI_ERS_RESULT_RECOVERED;
   458	}
   459	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
