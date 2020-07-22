Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BC9C433E3
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 18:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464162084D
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 18:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lW5+R6aR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgGVS2J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 14:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgGVS2J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 14:28:09 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F8FC0619DC;
        Wed, 22 Jul 2020 11:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=OYSn/KpUWZQ4nMms7wrSLpPiy3w6Iv2nJw1LBl+3jF0=; b=lW5+R6aRaWcL9XzKxeo7g5Hful
        WB3kf8WqLPpb61zWFBlp7UgSv7qpIOeGa48lURbXLzeLUsAifWGG+HFuqixLg88RFHNQU0lq+bs/H
        3PzfQDfTGsTByGAh8tILgch4vOdKZDJENn8NKjnX0nqCrnRJNCC+VofhJPLMlfjkJW7/uWH+1lHud
        jSAxkZtocZ/eaqN7pNp3RILjxqQ3tc/1TUZtHI1B7SvLNuhzGPsv730DR+KbCNSKR8Xw0j2G/b4EB
        ONOnnHLQ9PNAUV8QUjQAPaxaXRqWnjt+OxdEfbV9evkI7uK//nHt4CDmfoFo/X+RtDijYKwKhf28W
        AP/sr27g==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyJSb-0001BB-Ve; Wed, 22 Jul 2020 18:27:22 +0000
Subject: Re: [PATCH 2/2] crypto: Ingenic: Add hardware RNG for Ingenic JZ4780
 and X1000.
To:     =?UTF-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>, arnd@arndb.de,
        gregkh@linuxfoundation.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, hadar.gat@arm.com,
        prasannatsmkumar@gmail.com, krzk@kernel.org, masahiroy@kernel.org,
        xuzaibo@huawei.com, daniel.thompson@linaro.org,
        tmaimon77@gmail.com, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        yanfei.li@ingenic.com, sernia.zhou@foxmail.com,
        zhenwenjin@gmail.com
References: <20200722164007.77655-1-zhouyanjie@wanyeetech.com>
 <20200722164007.77655-3-zhouyanjie@wanyeetech.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <779949c8-8b1a-52ed-f695-7006f0045d7e@infradead.org>
Date:   Wed, 22 Jul 2020 11:27:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722164007.77655-3-zhouyanjie@wanyeetech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/22/20 9:40 AM, 周琰杰 (Zhou Yanjie) wrote:
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 0ad17efc96df..fcb06027cd88 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -257,6 +257,21 @@ config HW_RANDOM_IMX_RNGC
>  
>  	  If unsure, say Y.
>  
> +config HW_RANDOM_INGENIC_RNG
> +	tristate "Ingenic Random Number Generator support"
> +	depends on HW_RANDOM
> +	depends on MACH_JZ4780 || MACH_X1000
> +	default HW_RANDOM
> +	---help---

Just use:
	help
here. See this for why:

commit 8f268881d7d278047b00eed54bbb9288dbd6ab23
Author: Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue Dec 17 20:51:51 2019 +0900

    kconfig: remove ---help--- from documentation
    
    Since commit 84af7a6194e4 ("checkpatch: kconfig: prefer 'help' over
    '---help---'"), scripts/checkpatch.pl warns the use of ---help---.
    
    Kconfig still supports ---help---, but new code should avoid using it.
    Let's stop advertising it in documentation.

> +	  This driver provides kernel-side support for the Random Number Generator
> +	  hardware found in ingenic JZ4780 and X1000 SoC. MIPS Creator CI20 uses
> +	  JZ4780 SoC, YSH & ATIL CU1000-Neo uses X1000 SoC.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ingenic-rng.
> +
> +	  If unsure, say Y.
> +
>  config HW_RANDOM_NOMADIK
>  	tristate "ST-Ericsson Nomadik Random Number Generator support"
>  	depends on ARCH_NOMADIK

thanks.
-- 
~Randy

