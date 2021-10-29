Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B595EC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 16:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6196115C
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 16:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJ2QvS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 12:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhJ2QvR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 12:51:17 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A389AC061570;
        Fri, 29 Oct 2021 09:48:48 -0700 (PDT)
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 28B7C82952;
        Fri, 29 Oct 2021 18:48:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1635526125;
        bh=6zdVEZVllSYH2Pu2kQDESwjXTwsDnaWusbLxdvceA80=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Qm2LC35DVg0x4tRrz3XRlrKkmMk8WgAGYcTHDq6/7sMIka9JAy/hBAu+OpkwqD8B9
         L0nM++Z+eWa3pgNf/ecCpkmYgU4FZqeyLZQYOS7+33nCZuIAoMu10RaKDbWBlt6Kem
         KH8cPSoiFHst4BMuQ/x6zvmVw9bOWGcXmCB0Eu4jlx1gVEa+SzLFAxiYTKe+c+GncX
         buALthx3xKmG3TINMPfhBBZZ59wqTkjFQqkFMICmYpM/VBbAx1hzW3YhRey3cqYszs
         4uxXTYK+gZYHLpMFxCcdJOAOi4/sV6N2CUFN3Q6KsiSXAwAd5rfw4l8WoLErO+QNp5
         VJCLO/wL+V0DA==
Subject: Re: [PATCH 4/8] crypto: stm32/cryp - fix race condition
To:     Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
 <20211029135454.4383-5-nicolas.toromanoff@foss.st.com>
 <1ec60d9c-1ab4-8a92-1c6d-8093232ca039@denx.de>
 <alpine.DEB.2.21.2110291708040.20378@gnbcxd0088.gnb.st.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <f8de0493-29f3-550c-611e-97b7ee36e628@denx.de>
Date:   Fri, 29 Oct 2021 18:48:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2110291708040.20378@gnbcxd0088.gnb.st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/29/21 5:21 PM, Nicolas Toromanoff wrote:
> On Fri, 29 Oct 2021, Marek Vasut wrote:
> 
>> On 10/29/21 3:54 PM, Nicolas Toromanoff wrote:
>>> Erase key before finalizing request.
>>> Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto 
>>> module")
>>
>> Can you be a bit more specific in your commit messages ? That applies 
>> to the entire patchset. It is absolutely impossible to tell what race 
>> is fixed here or why it is fixed by exactly this change. This applies 
>> to the entire series.
> 
> I'll send a v2 with better commit messages.
> 
> for this specific patch:
> We reset the saved key before the crypto_finalize_*() call. Otherwise a 
> still pending crypto action could be ran with a wrong key = {0};
> 
>> And while I am at it, does the CRYP finally pass at least the most 
>> basic kernel boot time crypto tests or does running those still 
>> overwrite kernel memory and/or completely crash or lock up the machine ?
> 
> All extra tests (finally) pass.
> 
> With a kernel config :
>    # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>    CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
>    CONFIG_CRYPTO_DEV_STM32_CRYP=m

Can you also do a boot test with CRYP compiled into the kernel ?
I recall that is how the original bug was reported -- the machine 
crashed completely on boot even before reaching userspace, or the kernel 
crashed on memory corruption before reaching userspace.
