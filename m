Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F234C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 07:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E765520663
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 07:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfHLHRS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 03:17:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54388 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725923AbfHLHRR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 03:17:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2B13BFD9E5112802F7E6;
        Mon, 12 Aug 2019 15:17:08 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Mon, 12 Aug 2019
 15:16:57 +0800
Subject: Re: [cryptodev:master 124/144] drivers/crypto/hisilicon/qm.c:338:2:
 note: in expansion of macro 'dev_dbg'
To:     kbuild test robot <lkp@intel.com>
References: <201908092010.VKcbSwFV%lkp@intel.com>
CC:     <kbuild-all@01.org>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shiju Jose <shiju.jose@huawei.com>,
        "Kenneth Lee" <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
        John Garry <john.garry@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D511268.80607@hisilicon.com>
Date:   Mon, 12 Aug 2019 15:16:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <201908092010.VKcbSwFV%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/8/9 20:17, kbuild test robot wrote:
> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   ec9c7d19336ee98ecba8de80128aa405c45feebb
> commit: 62c455ca853e3e352e465d66a6cc39f1f88caa60 [124/144] crypto: hisilicon - add HiSilicon ZIP accelerator support
> config: sh-allmodconfig (attached as .config)
> compiler: sh4-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 62c455ca853e3e352e465d66a6cc39f1f88caa60
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=sh 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/printk.h:332:0,
>                     from include/linux/kernel.h:15,
>                     from include/asm-generic/bug.h:18,
>                     from arch/sh/include/asm/bug.h:112,
>                     from include/linux/bug.h:5,
>                     from arch/sh/include/asm/uncached.h:5,
>                     from arch/sh/include/asm/page.h:49,
>                     from drivers/crypto/hisilicon/qm.c:3:
>    drivers/crypto/hisilicon/qm.c: In function 'qm_mb':
>>> drivers/crypto/hisilicon/qm.c:338:26: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t {aka unsigned int}' [-Wformat=]
>      dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%llx\n", queue,

Should be %pad for dma, I will fix this.

>                              ^
>    include/linux/dynamic_debug.h:125:15: note: in definition of macro '__dynamic_func_call'
>       func(&id, ##__VA_ARGS__);  \
>                   ^~~~~~~~~~~
>    include/linux/dynamic_debug.h:157:2: note: in expansion of macro '_dynamic_func_call'
>      _dynamic_func_call(fmt,__dynamic_dev_dbg,   \
>      ^~~~~~~~~~~~~~~~~~
>    include/linux/device.h:1503:2: note: in expansion of macro 'dynamic_dev_dbg'
>      dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~
>    include/linux/device.h:1503:23: note: in expansion of macro 'dev_fmt'
>      dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>                           ^~~~~~~
>>> drivers/crypto/hisilicon/qm.c:338:2: note: in expansion of macro 'dev_dbg'
>      dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%llx\n", queue,
>      ^~~~~~~
>    drivers/crypto/hisilicon/qm.c: In function 'qm_irq_register':
>>> drivers/crypto/hisilicon/qm.c:583:20: error: implicit declaration of function 'pci_irq_vector'; did you mean 'rcu_irq_enter'? [-Werror=implicit-function-declaration]
>      ret = request_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR),
>                        ^~~~~~~~~~~~~~
>                        rcu_irq_enter
>    In file included from include/linux/printk.h:332:0,
>                     from include/linux/kernel.h:15,
>                     from include/asm-generic/bug.h:18,
>                     from arch/sh/include/asm/bug.h:112,
>                     from include/linux/bug.h:5,
>                     from arch/sh/include/asm/uncached.h:5,
>                     from arch/sh/include/asm/page.h:49,
>                     from drivers/crypto/hisilicon/qm.c:3:
>    drivers/crypto/hisilicon/qm.c: In function 'hisi_qm_create_qp':
>>> drivers/crypto/hisilicon/qm.c:879:16: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'size_t {aka unsigned int}' [-Wformat=]
>       dev_dbg(dev, "allocate qp dma buf(va=%pK, dma=%pad, size=%lx)\n",

Should be size=%zx, will fix this.

>                    ^
>    include/linux/dynamic_debug.h:125:15: note: in definition of macro '__dynamic_func_call'
>       func(&id, ##__VA_ARGS__);  \
>                   ^~~~~~~~~~~
>    include/linux/dynamic_debug.h:157:2: note: in expansion of macro '_dynamic_func_call'
>      _dynamic_func_call(fmt,__dynamic_dev_dbg,   \
>      ^~~~~~~~~~~~~~~~~~
>    include/linux/device.h:1503:2: note: in expansion of macro 'dynamic_dev_dbg'
>      dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~
>    include/linux/device.h:1503:23: note: in expansion of macro 'dev_fmt'
>      dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>                           ^~~~~~~
>    drivers/crypto/hisilicon/qm.c:879:3: note: in expansion of macro 'dev_dbg'
>       dev_dbg(dev, "allocate qp dma buf(va=%pK, dma=%pad, size=%lx)\n",
>       ^~~~~~~
>    drivers/crypto/hisilicon/qm.c: In function 'hisi_qm_init':
>>> drivers/crypto/hisilicon/qm.c:1156:8: error: implicit declaration of function 'pci_enable_device_mem'; did you mean 'pci_enable_device'? [-Werror=implicit-function-declaration]
>      ret = pci_enable_device_mem(pdev);
>            ^~~~~~~~~~~~~~~~~~~~~
>            pci_enable_device
>>> drivers/crypto/hisilicon/qm.c:1162:8: error: implicit declaration of function 'pci_request_mem_regions'; did you mean 'pci_request_regions'? [-Werror=implicit-function-declaration]
>      ret = pci_request_mem_regions(pdev, qm->dev_name);
>            ^~~~~~~~~~~~~~~~~~~~~~~
>            pci_request_regions
>>> drivers/crypto/hisilicon/qm.c:1185:8: error: implicit declaration of function 'pci_alloc_irq_vectors'; did you mean 'pci_alloc_consistent'? [-Werror=implicit-function-declaration]
>      ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSI);
>            ^~~~~~~~~~~~~~~~~~~~~
>            pci_alloc_consistent
>>> drivers/crypto/hisilicon/qm.c:1185:54: error: 'PCI_IRQ_MSI' undeclared (first use in this function); did you mean 'IRQ_MSK'?
>      ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSI);
>                                                          ^~~~~~~~~~~
>                                                          IRQ_MSK
>    drivers/crypto/hisilicon/qm.c:1185:54: note: each undeclared identifier is reported only once for each function it appears in
>>> drivers/crypto/hisilicon/qm.c:1201:2: error: implicit declaration of function 'pci_free_irq_vectors'; did you mean 'pci_free_consistent'? [-Werror=implicit-function-declaration]
>      pci_free_irq_vectors(pdev);
>      ^~~~~~~~~~~~~~~~~~~~
>      pci_free_consistent
>>> drivers/crypto/hisilicon/qm.c:1205:2: error: implicit declaration of function 'pci_release_mem_regions'; did you mean 'pci_release_regions'? [-Werror=implicit-function-declaration]
>      pci_release_mem_regions(pdev);
>      ^~~~~~~~~~~~~~~~~~~~~~~
>      pci_release_regions
>    In file included from include/linux/printk.h:332:0,
>                     from include/linux/kernel.h:15,
>                     from include/asm-generic/bug.h:18,
>                     from arch/sh/include/asm/bug.h:112,
>                     from include/linux/bug.h:5,
>                     from arch/sh/include/asm/uncached.h:5,
>                     from arch/sh/include/asm/page.h:49,
>                     from drivers/crypto/hisilicon/qm.c:3:
>    drivers/crypto/hisilicon/qm.c: In function 'hisi_qm_start':
>    drivers/crypto/hisilicon/qm.c:1425:16: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'size_t {aka unsigned int}' [-Wformat=]
>       dev_dbg(dev, "allocate qm dma buf(va=%pK, dma=%pad, size=%lx)\n",
>                    ^
>    include/linux/dynamic_debug.h:125:15: note: in definition of macro '__dynamic_func_call'
>       func(&id, ##__VA_ARGS__);  \
>                   ^~~~~~~~~~~
>    include/linux/dynamic_debug.h:157:2: note: in expansion of macro '_dynamic_func_call'
>      _dynamic_func_call(fmt,__dynamic_dev_dbg,   \
>      ^~~~~~~~~~~~~~~~~~
>    include/linux/device.h:1503:2: note: in expansion of macro 'dynamic_dev_dbg'
>      dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~
>    include/linux/device.h:1503:23: note: in expansion of macro 'dev_fmt'
>      dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>                           ^~~~~~~
>    drivers/crypto/hisilicon/qm.c:1425:3: note: in expansion of macro 'dev_dbg'
>       dev_dbg(dev, "allocate qm dma buf(va=%pK, dma=%pad, size=%lx)\n",

should be size=%zx.

>       ^~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/dev_dbg +338 drivers/crypto/hisilicon/qm.c
> 
> 263c9959c9376e Zhou Wang 2019-08-02  331  
> 263c9959c9376e Zhou Wang 2019-08-02  332  static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
> 263c9959c9376e Zhou Wang 2019-08-02  333  		 bool op)
> 263c9959c9376e Zhou Wang 2019-08-02  334  {
> 263c9959c9376e Zhou Wang 2019-08-02  335  	struct qm_mailbox mailbox;
> 263c9959c9376e Zhou Wang 2019-08-02  336  	int ret = 0;
> 263c9959c9376e Zhou Wang 2019-08-02  337  
> 263c9959c9376e Zhou Wang 2019-08-02 @338  	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%llx\n", queue,
> 263c9959c9376e Zhou Wang 2019-08-02  339  		cmd, dma_addr);
> 263c9959c9376e Zhou Wang 2019-08-02  340  
> 263c9959c9376e Zhou Wang 2019-08-02  341  	mailbox.w0 = cmd |
> 263c9959c9376e Zhou Wang 2019-08-02  342  		     (op ? 0x1 << QM_MB_OP_SHIFT : 0) |
> 263c9959c9376e Zhou Wang 2019-08-02  343  		     (0x1 << QM_MB_BUSY_SHIFT);
> 263c9959c9376e Zhou Wang 2019-08-02  344  	mailbox.queue_num = queue;
> 263c9959c9376e Zhou Wang 2019-08-02  345  	mailbox.base_l = lower_32_bits(dma_addr);
> 263c9959c9376e Zhou Wang 2019-08-02  346  	mailbox.base_h = upper_32_bits(dma_addr);
> 263c9959c9376e Zhou Wang 2019-08-02  347  	mailbox.rsvd = 0;
> 263c9959c9376e Zhou Wang 2019-08-02  348  
> 263c9959c9376e Zhou Wang 2019-08-02  349  	mutex_lock(&qm->mailbox_lock);
> 263c9959c9376e Zhou Wang 2019-08-02  350  
> 263c9959c9376e Zhou Wang 2019-08-02  351  	if (unlikely(qm_wait_mb_ready(qm))) {
> 263c9959c9376e Zhou Wang 2019-08-02  352  		ret = -EBUSY;
> 263c9959c9376e Zhou Wang 2019-08-02  353  		dev_err(&qm->pdev->dev, "QM mailbox is busy to start!\n");
> 263c9959c9376e Zhou Wang 2019-08-02  354  		goto busy_unlock;
> 263c9959c9376e Zhou Wang 2019-08-02  355  	}
> 263c9959c9376e Zhou Wang 2019-08-02  356  
> 263c9959c9376e Zhou Wang 2019-08-02  357  	qm_mb_write(qm, &mailbox);
> 263c9959c9376e Zhou Wang 2019-08-02  358  
> 263c9959c9376e Zhou Wang 2019-08-02  359  	if (unlikely(qm_wait_mb_ready(qm))) {
> 263c9959c9376e Zhou Wang 2019-08-02  360  		ret = -EBUSY;
> 263c9959c9376e Zhou Wang 2019-08-02  361  		dev_err(&qm->pdev->dev, "QM mailbox operation timeout!\n");
> 263c9959c9376e Zhou Wang 2019-08-02  362  		goto busy_unlock;
> 263c9959c9376e Zhou Wang 2019-08-02  363  	}
> 263c9959c9376e Zhou Wang 2019-08-02  364  
> 263c9959c9376e Zhou Wang 2019-08-02  365  busy_unlock:
> 263c9959c9376e Zhou Wang 2019-08-02  366  	mutex_unlock(&qm->mailbox_lock);
> 263c9959c9376e Zhou Wang 2019-08-02  367  
> 263c9959c9376e Zhou Wang 2019-08-02  368  	return ret;
> 263c9959c9376e Zhou Wang 2019-08-02  369  }
> 263c9959c9376e Zhou Wang 2019-08-02  370  
> 
> :::::: The code at line 338 was first introduced by commit
> :::::: 263c9959c9376ec0217d6adc61222a53469eed3c crypto: hisilicon - add queue management driver for HiSilicon QM module
> 
> :::::: TO: Zhou Wang <wangzhou1@hisilicon.com>
> :::::: CC: Herbert Xu <herbert@gondor.apana.org.au>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

