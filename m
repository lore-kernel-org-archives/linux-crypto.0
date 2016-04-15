From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [cryptodev:master 43/49] WARNING:
 drivers/crypto/qat/qat_common/intel_qat.o(.init.text+0x30d): Section mismatch
 in reference from the function init_module() to the function
 .exit.text:adf_exit_vf_wq()
Date: Fri, 15 Apr 2016 13:39:28 -0700
Message-ID: <57115180.3060009@intel.com>
References: <201604160353.56AsWSoq%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbcDOUos (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 16:44:48 -0400
In-Reply-To: <201604160353.56AsWSoq%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/15/2016 12:52 PM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   5f575efea79caae69b81f922d99b221302a2c003
> commit: d6064165ba4449ea085a389724d728258a3180ec [43/49] crypto: qat - adf_dev_stop should not be called in atomic context
> config: i386-allmodconfig (attached as .config)
> reproduce:
>         git checkout d6064165ba4449ea085a389724d728258a3180ec
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All warnings (new ones prefixed by >>):
> 
>>> WARNING: drivers/crypto/qat/qat_common/intel_qat.o(.init.text+0x30d): Section mismatch in reference from the function init_module() to the function .exit.text:adf_exit_vf_wq()
>    The function __init init_module() references
>    a function __exit adf_exit_vf_wq().
>    This is often seen when error handling in the init function
>    uses functionality in the exit path.
>    The fix is often to remove the __exit annotation of
>    adf_exit_vf_wq() so it may be used outside an exit section.
> 
Is it still complaining even after this?
https://patchwork.kernel.org/patch/8854461/

Thanks,
-- 
TS
