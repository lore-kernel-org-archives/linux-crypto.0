From: Gary R Hook <ghook@amd.com>
Subject: Re: [cryptodev:master 17/45] drivers/crypto/ccp/ccp-dev-v5.c:838:3:
 error: label 'e_hwrng' used but not defined
Date: Wed, 10 Aug 2016 11:48:25 -0500
Message-ID: <2e640792-3d6a-f24e-8295-363a9553f00e@amd.com>
References: <201608102355.WhiXil4y%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:1440
	"EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751335AbcHJSUh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 14:20:37 -0400
In-Reply-To: <201608102355.WhiXil4y%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A patch for this will be submitted shortly.

On 08/10/2016 10:30 AM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   47856204146ba6fd0f198dbb23c4ed7ad1c3fd99
> commit: 99d90b2ebd8b327c0c496798db99009b30c70945 [17/45] crypto: ccp - Enable DMA service on a v5 CCP
> config: i386-randconfig-h1-08102150 (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         git checkout 99d90b2ebd8b327c0c496798db99009b30c70945
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> Note: the cryptodev/master HEAD 47856204146ba6fd0f198dbb23c4ed7ad1c3fd99 builds fine.
>       It only hurts bisectibility.
>
> All errors (new ones prefixed by >>):
>
>    drivers/crypto/ccp/ccp-dev-v5.c: In function 'ccp5_init':
>>> drivers/crypto/ccp/ccp-dev-v5.c:838:3: error: label 'e_hwrng' used but not defined
>       goto e_hwrng;
>       ^~~~
>
> vim +/e_hwrng +838 drivers/crypto/ccp/ccp-dev-v5.c
>
>    832		if (ret)
>    833			goto e_kthread;
>    834	
>    835		/* Register the DMA engine support */
>    836		ret = ccp_dmaengine_register(ccp);
>    837		if (ret)
>  > 838			goto e_hwrng;
>    839	
>    840		return 0;
>    841	
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
