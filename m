From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2] staging: ccree: Fix format/argument mismatches
Date: Thu, 03 Aug 2017 06:49:59 -0700
Message-ID: <1501768199.31625.17.camel@perches.com>
References: <201708031730.VcP8Q0DJ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:57200 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751154AbdHCNuE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 09:50:04 -0400
In-Reply-To: <201708031730.VcP8Q0DJ%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2017-08-03 at 17:09 +0800, kbuild test robot wrote:
> Hi Joe,
> 
> [auto build test WARNING on staging/staging-testing]
> [also build test WARNING on next-20170803]
> [cannot apply to v4.13-rc3]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

Pretty odd that m32r has ioread32 as _readl and so unsigned long
Seems silly to have to cast it.

Gilad, is this actually a supported platform for ccree?

> url:    https://github.com/0day-ci/linux/commits/Joe-Perches/staging-ccree-Fix-format-argument-mismatches/20170731-191055
> config: m32r-allmodconfig (attached as .config)
> compiler: m32r-linux-gcc (GCC) 6.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=m32r 
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/kernel.h:13:0,
>                     from drivers/staging/ccree/ssi_driver.c:17:
>    drivers/staging/ccree/ssi_driver.c: In function 'init_cc_regs':
> > > drivers/staging/ccree/ssi_driver.c:180:16: warning: format '%X' expects argument of type 'unsigned int', but argument 2 has type 'long unsigned int' [-Wformat=]
> 
>      SSI_LOG_DEBUG("AXIM_CFG=0x%08X\n", CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG)));
