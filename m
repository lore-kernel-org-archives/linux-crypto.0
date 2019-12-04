Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4387AC43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 17:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E9962073B
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 17:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfLDRRT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:17:19 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58384 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRRT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 12:17:19 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 3AACF260419
Subject: Re: ardb/for-kernelci bisection: boot on rk3288-rock2-square
To:     Ard Biesheuvel <ardb@kernel.org>, mgalka@collabora.com,
        broonie@kernel.org, enric.balletbo@collabora.com,
        tomeu.vizoso@collabora.com, khilman@baylibre.com
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>
References: <5de7d155.1c69fb81.c06f8.3583@mx.google.com>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <377fa169-7ae5-479f-023c-e282d8c19f3a@collabora.com>
Date:   Wed, 4 Dec 2019 17:17:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5de7d155.1c69fb81.c06f8.3583@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 04/12/2019 15:31, kernelci.org bot wrote:
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> ardb/for-kernelci bisection: boot on rk3288-rock2-square
> 
> Summary:
>   Start:      16839329da69 enable extra tests by default
>   Details:    https://kernelci.org/boot/id/5de79104990bc03e5a960f0b
>   Plain log:  https://storage.kernelci.org//ardb/for-kernelci/v5.4-9340-g16839329da69/arm/multi_v7_defconfig+CONFIG_EFI=y+CONFIG_ARM_LPAE=y/gcc-8/lab-collabora/boot-rk3288-rock2-square.txt
>   HTML log:   https://storage.kernelci.org//ardb/for-kernelci/v5.4-9340-g16839329da69/arm/multi_v7_defconfig+CONFIG_EFI=y+CONFIG_ARM_LPAE=y/gcc-8/lab-collabora/boot-rk3288-rock2-square.html
>   Result:     16839329da69 enable extra tests by default
> 
> Checks:
>   revert:     PASS
>   verify:     PASS
> 
> Parameters:
>   Tree:       ardb
>   URL:        git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git
>   Branch:     for-kernelci
>   Target:     rk3288-rock2-square
>   CPU arch:   arm
>   Lab:        lab-collabora
>   Compiler:   gcc-8
>   Config:     multi_v7_defconfig+CONFIG_EFI=y+CONFIG_ARM_LPAE=y
>   Test suite: boot
> 
> Breaking commit found:
> 
> -------------------------------------------------------------------------------
> commit 16839329da69263e7360f3819bae01bcf4b220ec
> Author: Ard Biesheuvel <ardb@kernel.org>
> Date:   Tue Dec 3 12:29:31 2019 +0000
> 
>     enable extra tests by default
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 5575d48473bd..36af840aa820 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -140,7 +140,6 @@ if CRYPTO_MANAGER2
>  
>  config CRYPTO_MANAGER_DISABLE_TESTS
>  	bool "Disable run-time self tests"
> -	default y
>  	help
>  	  Disable run-time self tests that normally take place at
>  	  algorithm registration.
> @@ -148,6 +147,7 @@ config CRYPTO_MANAGER_DISABLE_TESTS
>  config CRYPTO_MANAGER_EXTRA_TESTS
>  	bool "Enable extra run-time crypto self tests"
>  	depends on DEBUG_KERNEL && !CRYPTO_MANAGER_DISABLE_TESTS
> +	default y
>  	help
>  	  Enable extra run-time self tests of registered crypto algorithms,
>  	  including randomized fuzz tests.
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 88f33c0efb23..5df87bcf6c4d 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -40,7 +40,7 @@ static bool notests;
>  module_param(notests, bool, 0644);
>  MODULE_PARM_DESC(notests, "disable crypto self-tests");
>  
> -static bool panic_on_fail;
> +static bool panic_on_fail = true;
>  module_param(panic_on_fail, bool, 0444);
>  
>  #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
> -------------------------------------------------------------------------------


Seems legit, from the log:

<3>[   18.186181] rk3288-crypto ff8a0000.cypto-controller: [rk_load_data:123] pcopy err
<3>[   18.199432] alg: skcipher: ecb-aes-rk encryption failed on test vector \"random: len=0 klen=32\"; expected_error=0, actual_error=-22, cfg=\"random: inplace use_finup nosimd src_divs=[100.0%@+2054] key_offset=16\"
<0>[   18.220458] Kernel panic - not syncing: alg: self-tests for ecb-aes-rk (ecb(aes)) failed in panic_on_fail mode!

Let me know if you need any help with testing a fix on this
platform or anything.

Also, as you probably only want this to be enabled in KernelCI
and not merged upstream, we could have a config fragment to
enable the config with your branch and maybe even others.

Guillaume


> Git bisection log:
> 
> -------------------------------------------------------------------------------
> git bisect start
> # good: [b94ae8ad9fe79da61231999f347f79645b909bda] Merge tag 'seccomp-v5.5-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
> git bisect good b94ae8ad9fe79da61231999f347f79645b909bda
> # bad: [16839329da69263e7360f3819bae01bcf4b220ec] enable extra tests by default
> git bisect bad 16839329da69263e7360f3819bae01bcf4b220ec
> # good: [25cbf24a7eec7c3dee4113b2e98b572e128009b7] crypto: aead - move crypto_aead_maxauthsize() to <crypto/aead.h>
> git bisect good 25cbf24a7eec7c3dee4113b2e98b572e128009b7
> # good: [7b19c7a82950ed034645fa92adce29cd6163ed3e] crypto: testmgr - check skcipher min_keysize
> git bisect good 7b19c7a82950ed034645fa92adce29cd6163ed3e
> # good: [062752a354aaf03b46b86cba5fdaa2fd5c932860] crypto: testmgr - create struct aead_extra_tests_ctx
> git bisect good 062752a354aaf03b46b86cba5fdaa2fd5c932860
> # good: [2cd56a00fff8584e342164c65e6b55da61f79c4a] crypto: testmgr - generate inauthentic AEAD test vectors
> git bisect good 2cd56a00fff8584e342164c65e6b55da61f79c4a
> # first bad commit: [16839329da69263e7360f3819bae01bcf4b220ec] enable extra tests by default
> -------------------------------------------------------------------------------
> 

