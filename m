Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D08C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 14:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32D860F93
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 14:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhIPOIP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 10:08:15 -0400
Received: from phobos.denx.de ([85.214.62.61]:48384 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235997AbhIPOIP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 10:08:15 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id ED42A831ED;
        Thu, 16 Sep 2021 16:06:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1631801213;
        bh=zoJ02OJ4nxwoswG+O6ZZ0PSEXtTU5qDjJ//KrHG0qF0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jRvcW+FX1MZ/yMKlI6eXJbpqIHUnLrNbQ2L7xLLA0RpOXpVBBiIg/SjBkMy2enHkl
         aA1knRkzMqBe89GEVWJ85tFRa5/NCiE5X0HNnTta1+4ZIcWUHudNEkKranHJTZH8GK
         t6aGhcK4+011xIIEVDW2Hw7UkGXxHkk9wdB1aol4ELsflmgtcoF00eian13iSAcr9m
         7hV4g2KR6fDX4xaAUi/oJAGUsLOdqPWwGsmWWidj/NmzTmnhTNCnhFqL9Ct3V102zz
         CrP87dRya0t3oJkBrvJ1MeyiFaWA2SoF9eCpojOggB1+Xb8QsGW30sCWTRXNVDrtin
         lwtvKa57rMC4A==
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-crypto@vger.kernel.org
Cc:     ch@denx.de, Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20210916134154.8764-1-marex@denx.de>
 <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
Date:   Thu, 16 Sep 2021 16:06:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/16/21 3:59 PM, Krzysztof Kozlowski wrote:
> On 16/09/2021 15:41, Marek Vasut wrote:
>> Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: Horia Geantă <horia.geanta@nxp.com>
>> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>> ---
>>   drivers/crypto/caam/ctrl.c | 1 +
>>   drivers/crypto/caam/jr.c   | 1 +
>>   2 files changed, 2 insertions(+)
>>
> 
> Since you marked it as RFC, let me share a comment - would be nice to
> see here explanation why do you need module alias.
> 
> Drivers usually do not need module alias to be auto-loaded, unless the
> subsystem/bus reports different alias than one used for binding. Since
> the CAAM can bind only via OF, I wonder what is really missing here. Is
> it a MFD child (it's one of cases this can happen)?

I noticed the CAAM is not being auto-loaded on boot, and then I noticed 
the MODULE_ALIAS fixes cropping up in the kernel log, but I couldn't 
find a good documentation for that MODULE_ALIAS. So I was hoping to get 
a feedback on it.
