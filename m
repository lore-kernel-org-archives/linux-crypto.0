Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D833C77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 12:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjESMjr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 08:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjESMjq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 08:39:46 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C24EF4
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 05:39:43 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 334B324E1F2;
        Fri, 19 May 2023 20:39:37 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 19 May
 2023 20:39:37 +0800
Received: from [192.168.100.10] (161.142.156.50) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 19 May
 2023 20:39:34 +0800
Message-ID: <d4751f66-6e57-66da-f8ad-4ac2c8c46fd2@starfivetech.com>
Date:   Fri, 19 May 2023 20:39:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [herbert-cryptodev-2.6:master 21/22]
 drivers/tty/serial/amba-pl011.c:379:30: error: implicit declaration of
 function 'phys_to_page'; did you mean 'pfn_to_page'?
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
References: <202305191929.Eq4OVZ6D-lkp@intel.com>
From:   Jia Jie Ho <jiajie.ho@starfivetech.com>
In-Reply-To: <202305191929.Eq4OVZ6D-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [161.142.156.50]
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX168.cuchost.com
 (172.16.6.78)
X-YovoleRuleAgent: yovoleflag
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19/5/2023 7:33 pm, kernel test robot wrote:
> Hi Jia,
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   7883d1b28a2b0e62edcacea22de6b36a1918b15a
> commit: 42ef0e944b0119e9987819af0a5a04d32d5e5edf [21/22] crypto: starfive - Add crypto engine support
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230519/202305191929.Eq4OVZ6D-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=42ef0e944b0119e9987819af0a5a04d32d5e5edf
>         git remote add herbert-cryptodev-2.6 https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>         git fetch --no-tags herbert-cryptodev-2.6 master
>         git checkout 42ef0e944b0119e9987819af0a5a04d32d5e5edf
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash drivers/tty/serial/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202305191929.Eq4OVZ6D-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/tty/serial/amba-pl011.c: In function 'pl011_sgbuf_init':
>>> drivers/tty/serial/amba-pl011.c:379:30: error: implicit declaration of function 'phys_to_page'; did you mean 'pfn_to_page'? [-Werror=implicit-function-declaration]
>      379 |         sg_set_page(&sg->sg, phys_to_page(dma_addr),
>          |                              ^~~~~~~~~~~~
>          |                              pfn_to_page
>>> drivers/tty/serial/amba-pl011.c:379:30: warning: passing argument 2 of 'sg_set_page' makes pointer from integer without a cast [-Wint-conversion]
>      379 |         sg_set_page(&sg->sg, phys_to_page(dma_addr),
>          |                              ^~~~~~~~~~~~~~~~~~~~~~
>          |                              |
>          |                              int
>    In file included from include/linux/kfifo.h:42,
>                     from include/linux/tty_port.h:5,
>                     from include/linux/tty.h:12,
>                     from drivers/tty/serial/amba-pl011.c:25:
>    include/linux/scatterlist.h:136:69: note: expected 'struct page *' but argument is of type 'int'
>      136 | static inline void sg_set_page(struct scatterlist *sg, struct page *page,
>          |                                                        ~~~~~~~~~~~~~^~~~
>    cc1: some warnings being treated as errors
> 
> Kconfig warnings: (for reference only)
>    WARNING: unmet direct dependencies detected for DMADEVICES
>    Depends on [n]: HAS_DMA [=n]
>    Selected by [m]:
>    - CRYPTO_DEV_JH7110 [=m] && CRYPTO [=y] && CRYPTO_HW [=y] && (SOC_STARFIVE || COMPILE_TEST [=y])
> 

Hi Herbert,

Should I submit a new patch to select HAS_DMA in my Kconfig?

Thanks,
Jia Jie

