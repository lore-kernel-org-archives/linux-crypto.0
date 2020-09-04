Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09003C433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 10:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF9C620791
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 10:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgIDKGd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:06:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728588AbgIDKGd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 06:06:33 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ECB1BDEE2024DA5FD44A;
        Fri,  4 Sep 2020 18:06:30 +0800 (CST)
Received: from [10.67.103.233] (10.67.103.233) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 18:06:23 +0800
Subject: Re: [PATCH 1/2] crypto: hisilicon/qm - fix wrong return type of
 'pci_get_drvdata'
To:     kernel test robot <lkp@intel.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
References: <1599134040-55860-2-git-send-email-qianweili@huawei.com>
 <202009032313.H2XXWT1y%lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <2904eae5-3b99-3007-2b51-0ded42c2a250@huawei.com>
Date:   Fri, 4 Sep 2020 18:06:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <202009032313.H2XXWT1y%lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.233]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/9/3 23:15, kernel test robot wrote:
> Hi Weili,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on crypto/master sparc-next/master v5.9-rc3 next-20200903]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Weili-Qian/crypto-hisilicon-misc-fixes/20200903-200547
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: ia64-allmodconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=ia64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/crypto/hisilicon/zip/zip_main.c: In function 'hisi_zip_remove':
>>> drivers/crypto/hisilicon/zip/zip_main.c:862:24: error: 'hisi_zip' undeclared (first use in this function)
>      862 |  hisi_zip_debugfs_exit(hisi_zip);
>          |                        ^~~~~~~~
>    drivers/crypto/hisilicon/zip/zip_main.c:862:24: note: each undeclared identifier is reported only once for each function it appears in
> 
> # https://github.com/0day-ci/linux/commit/9233b94d43e85aa53ba599605c7536455521f576
> git remote add linux-review https://github.com/0day-ci/linux
> git fetch --no-tags linux-review Weili-Qian/crypto-hisilicon-misc-fixes/20200903-200547
> git checkout 9233b94d43e85aa53ba599605c7536455521f576
> vim +/hisi_zip +862 drivers/crypto/hisilicon/zip/zip_main.c
> 
> 39977f4b51cdc5 Hao Fang   2019-11-07  851  
> 62c455ca853e3e Zhou Wang  2019-08-02  852  static void hisi_zip_remove(struct pci_dev *pdev)
> 62c455ca853e3e Zhou Wang  2019-08-02  853  {
> 9233b94d43e85a Yang Shen  2020-09-03  854  	struct hisi_qm *qm = pci_get_drvdata(pdev);
> 62c455ca853e3e Zhou Wang  2019-08-02  855  
> daa31783c0ebab Weili Qian 2020-08-15  856  	hisi_qm_wait_task_finish(qm, &zip_devices);
> 3d29e98d1d7550 Yang Shen  2020-08-15  857  	hisi_qm_alg_unregister(qm, &zip_devices);
> 3d29e98d1d7550 Yang Shen  2020-08-15  858  
> 619e464ae22a17 Shukun Tan 2020-04-02  859  	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
> daa31783c0ebab Weili Qian 2020-08-15  860  		hisi_qm_sriov_disable(pdev, qm->is_frozen);
> 79e09f30eeba85 Zhou Wang  2019-08-02  861  
> 72c7a68d2ea348 Zhou Wang  2019-08-02 @862  	hisi_zip_debugfs_exit(hisi_zip);
> e88dd6e1d8370f Yang Shen  2020-08-15  863  	hisi_qm_stop(qm, QM_NORMAL);
> eaebf4c3b103df Shukun Tan 2020-01-20  864  	hisi_qm_dev_err_uninit(qm);
> 62c455ca853e3e Zhou Wang  2019-08-02  865  	hisi_qm_uninit(qm);
> 62c455ca853e3e Zhou Wang  2019-08-02  866  }
> 62c455ca853e3e Zhou Wang  2019-08-02  867  
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

Hi all,
 Sorry，this patch depends on https://patchwork.kernel.org/patch/11732097/.
I will resend it when the dependent patch is applied.

Thanks,
Weili

