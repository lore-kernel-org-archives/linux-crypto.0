From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 2/3] crypto: ccp - Introduce the AMD Secure Processor
 device
Date: Thu, 6 Jul 2017 07:27:02 -0500
Message-ID: <0bcf2fa4-651a-5425-831e-a2b8324f37a8@amd.com>
References: <201707061641.wxDNmX4a%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.lendacky@amd.com,
        gary.hook@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0088.outbound.protection.outlook.com ([104.47.38.88]:25191
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752010AbdGFM1I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2017 08:27:08 -0400
In-Reply-To: <201707061641.wxDNmX4a%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 7/6/17 3:37 AM, kbuild test robot wrote:
> Hi Brijesh,
>
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on next-20170705]
> [cannot apply to v4.12]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Brijesh-Singh/Introduce-AMD-Secure-Processor-device/20170625-064400
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: x86_64-randconfig-x016-07060921 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> All errors (new ones prefixed by >>):
>
>>> ERROR: "ccp_dev_resume" [drivers/crypto/ccp/ccp.ko] undefined!
>>> ERROR: "ccp_dev_suspend" [drivers/crypto/ccp/ccp.ko] undefined!
I will send out v4 soon to fix it. We need to guard sp_dev_resume and
sp_dev_suspend with CONFIG_PM. I think in my .config I had CONFIG_PM
enabled, whereas the robot  config does not have CONFIG_PM.

> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
