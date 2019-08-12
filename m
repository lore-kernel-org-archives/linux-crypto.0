Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC2DC433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 10:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E5C2085A
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 10:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfHLKuD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 06:50:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727235AbfHLKuD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 06:50:03 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 941E4761203E8FFCC3F5;
        Mon, 12 Aug 2019 18:50:01 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 12 Aug 2019
 18:49:54 +0800
Subject: Re: [cryptodev:master 124/144] drivers/crypto/hisilicon/qm.c:322:2:
 error: impossible constraint in 'asm'
To:     kbuild test robot <lkp@intel.com>
References: <201908092005.GIPAS1Oq%lkp@intel.com>
CC:     <kbuild-all@01.org>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shiju Jose <shiju.jose@huawei.com>,
        "Kenneth Lee" <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
        John Garry <john.garry@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D514451.5000001@hisilicon.com>
Date:   Mon, 12 Aug 2019 18:49:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <201908092005.GIPAS1Oq%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/8/9 20:20, kbuild test robot wrote:
> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   ec9c7d19336ee98ecba8de80128aa405c45feebb
> commit: 62c455ca853e3e352e465d66a6cc39f1f88caa60 [124/144] crypto: hisilicon - add HiSilicon ZIP accelerator support
> config: sparc64-allmodconfig (attached as .config)
> compiler: sparc64-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 62c455ca853e3e352e465d66a6cc39f1f88caa60
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=sparc64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/crypto/hisilicon/qm.c: In function 'qm_mb.constprop':
>>> drivers/crypto/hisilicon/qm.c:322:2: warning: asm operand 3 probably doesn't match constraints
>      asm volatile("ldp %0, %1, %3\n"
>      ^~~
>    drivers/crypto/hisilicon/qm.c:322:2: warning: asm operand 4 probably doesn't match constraints
>>> drivers/crypto/hisilicon/qm.c:322:2: error: impossible constraint in 'asm'
> --
>    drivers/crypto/hisilicon/sgl.c: In function 'hisi_acc_sg_buf_map_to_hw_sgl':
>>> drivers/crypto/hisilicon/sgl.c:181:14: warning: 'curr_sgl_dma' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      *hw_sgl_dma = curr_sgl_dma;
>      ~~~~~~~~~~~~^~~~~~~~~~~~~~

Hi Herbert,

I will fix this and set dependency on arm64 for zip.

Should I just post a fix patch or repost the whole series
([PATCH v3 0/7] crypto: hisilicon: Add HiSilicon QM and ZIP controller driver) with fixes?

Best,
Zhou

> 
> vim +/asm +322 drivers/crypto/hisilicon/qm.c
> 
> 263c9959c9376e Zhou Wang 2019-08-02  315  
> 263c9959c9376e Zhou Wang 2019-08-02  316  /* 128 bit should be written to hardware at one time to trigger a mailbox */
> 263c9959c9376e Zhou Wang 2019-08-02  317  static void qm_mb_write(struct hisi_qm *qm, const void *src)
> 263c9959c9376e Zhou Wang 2019-08-02  318  {
> 263c9959c9376e Zhou Wang 2019-08-02  319  	void __iomem *fun_base = qm->io_base + QM_MB_CMD_SEND_BASE;
> 263c9959c9376e Zhou Wang 2019-08-02  320  	unsigned long tmp0 = 0, tmp1 = 0;
> 263c9959c9376e Zhou Wang 2019-08-02  321  
> 263c9959c9376e Zhou Wang 2019-08-02 @322  	asm volatile("ldp %0, %1, %3\n"
> 263c9959c9376e Zhou Wang 2019-08-02  323  		     "stp %0, %1, %2\n"
> 263c9959c9376e Zhou Wang 2019-08-02  324  		     "dsb sy\n"
> 263c9959c9376e Zhou Wang 2019-08-02  325  		     : "=&r" (tmp0),
> 263c9959c9376e Zhou Wang 2019-08-02  326  		       "=&r" (tmp1),
> 263c9959c9376e Zhou Wang 2019-08-02  327  		       "+Q" (*((char *)fun_base))
> 263c9959c9376e Zhou Wang 2019-08-02  328  		     : "Q" (*((char *)src))
> 263c9959c9376e Zhou Wang 2019-08-02  329  		     : "memory");
> 263c9959c9376e Zhou Wang 2019-08-02  330  }
> 263c9959c9376e Zhou Wang 2019-08-02  331  
> 
> :::::: The code at line 322 was first introduced by commit
> :::::: 263c9959c9376ec0217d6adc61222a53469eed3c crypto: hisilicon - add queue management driver for HiSilicon QM module
> 
> :::::: TO: Zhou Wang <wangzhou1@hisilicon.com>
> :::::: CC: Herbert Xu <herbert@gondor.apana.org.au>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

