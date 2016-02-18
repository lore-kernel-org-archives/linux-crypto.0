From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [cryptodev:master 95/102] arch/arm64/crypto/aes-glue.c:88:2: error: implicit declaration of function 'xts_check_key'
Date: Thu, 18 Feb 2016 09:13:46 +0100
Message-ID: <63297293.nlJ5af0sSv@positron.chronox.de>
References: <201602181230.TW8SGoZR%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34134 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425327AbcBRINi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Feb 2016 03:13:38 -0500
In-Reply-To: <201602181230.TW8SGoZR%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 18. Februar 2016, 12:35:33 schrieb kbuild test robot:

Hi,

> tree:  
> https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> master head:   49abc0d2e19b28e90f443334fb6cd66f275713e6
> commit: 28856a9e52c7cac712af6c143de04766617535dc [95/102] crypto: xts -
> consolidate sanity check for keys config: arm64-defconfig (attached as
> .config)
> reproduce:
>         wget
> https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/m
> ake.cross -O ~/bin/make.cross chmod +x ~/bin/make.cross
>         git checkout 28856a9e52c7cac712af6c143de04766617535dc
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm64
> 
> Note: the cryptodev/master HEAD 49abc0d2e19b28e90f443334fb6cd66f275713e6
> builds fine. It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    arch/arm64/crypto/aes-glue.c: In function 'xts_set_key':
> >> arch/arm64/crypto/aes-glue.c:88:2: error: implicit declaration of
> >> function 'xts_check_key' [-Werror=implicit-function-declaration]

With the patch sent and added yesterday that covered the addition of 
crypto/xts.h to arch/arm64/crypto/aes-glue.c, this error should be covered.

Did you use the cryptodev-2.6 tree from yesterday?

Thanks

>      ret = xts_check_key(tfm, in_key, key_len);
>      ^
>    cc1: some warnings being treated as errors
> 
> vim +/xts_check_key +88 arch/arm64/crypto/aes-glue.c
> 
>     82	static int xts_set_key(struct crypto_tfm *tfm, const u8 
*in_key,
>     83			       unsigned int key_len)
>     84	{
>     85		struct crypto_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
>     86		int ret;
>     87
> 
>   > 88		ret = xts_check_key(tfm, in_key, key_len);
> 
>     89		if (ret)
>     90			return ret;
>     91
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation


Ciao
Stephan
