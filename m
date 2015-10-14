From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [cryptodev:master 62/67]
 drivers/char/hw_random/stm32-rng.c:163:51: error: 'pdev' undeclared
Date: Wed, 14 Oct 2015 16:15:01 +0100
Message-ID: <561E7175.7050106@linaro.org>
References: <201510142211.TZbOa7j7%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Walleij <linus.walleij@linaro.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34686 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbJNPPE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 11:15:04 -0400
Received: by wicgb1 with SMTP id gb1so134048503wic.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2015 08:15:03 -0700 (PDT)
In-Reply-To: <201510142211.TZbOa7j7%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14/10/15 15:59, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   62f57d05e287e950c6e1246b1dba08e12985195a
> commit: c6a97c42e399ad0d639f616e58e13f0b4ae87626 [62/67] hwrng: stm32 - add support for STM32 HW RNG
> config: i386-allmodconfig (attached as .config)
> reproduce:
>          git checkout c6a97c42e399ad0d639f616e58e13f0b4ae87626
>          # save the attached .config to linux build tree
>          make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>     drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_runtime_suspend':
>>> drivers/char/hw_random/stm32-rng.c:163:51: error: 'pdev' undeclared (first use in this function)
>       struct stm32_rng_private *priv = dev_get_drvdata(pdev);
>                                                        ^
>     drivers/char/hw_random/stm32-rng.c:163:51: note: each undeclared identifier is reported only once for each function it appears in
>     drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_runtime_resume':
>     drivers/char/hw_random/stm32-rng.c:172:51: error: 'pdev' undeclared (first use in this function)
>       struct stm32_rng_private *priv = dev_get_drvdata(pdev);
>                                                        ^
>
> vim +/pdev +163 drivers/char/hw_random/stm32-rng.c
>
>     157		return devm_hwrng_register(dev, &priv->rng);
>     158	}
>     159	
>     160	#ifdef CONFIG_PM
>     161	static int stm32_rng_runtime_suspend(struct device *dev)
>     162	{
>   > 163		struct stm32_rng_private *priv = dev_get_drvdata(pdev);
>     164	
>     165		stm32_rng_cleanup(&priv->rng);
>     166	

Oops...

That is a serious oversight on my side. Unlike all my other kernel work 
I test the STM32 stuff with a buildroot wrapper. I checked that I had 
CONFIG_PM enabled (for good compile coverage) but it looks like I forgot 
the "linux-rebuild" when I made final tweaks to the patchset.

I will fix immediately.


Daniel.
