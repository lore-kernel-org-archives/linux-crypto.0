Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5485C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Nov 2022 09:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiKXJWu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Nov 2022 04:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKXJWt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2022 04:22:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16031EAC6;
        Thu, 24 Nov 2022 01:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A78B82732;
        Thu, 24 Nov 2022 09:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF40C433D7;
        Thu, 24 Nov 2022 09:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669281764;
        bh=uMhyK13xAibvCn+lmTWBR14qTDOfbpe7P4NVLrGyh54=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YSyLI2UP9lA7Ff8khZpDIJ2CTqI8o8bfEN/iWI/kM7WUTFnXWaZAwAUydajozgvV7
         ZbqNkHDUqYnQDf8eg6kzYqgQu8e4YOPWlGEVHkPDRcbWnLAzOe76zS3X0O4Jotd3rm
         AWA3940B7oM2l/1nBwqFFt3WQsJo/JlJdul7OKvCiTcV1UB2Ajid1Oqf/BJ6gnki3H
         1AqL3WChOt6wqZIRy/QEYesZIKLR1W/FAyv5HCmdchrJSCzgToW55p5jBS8yOTg+0U
         fsLeIE9bE2G4o6ZYvHASo6FSz2HDeF9ZaD+WQY4vh2hisW30PQVHSe6PjcGgosbD1c
         EmkQDBC7jo7Xg==
Message-ID: <7b11aca1-c984-d8f4-6d99-13833270ee16@kernel.org>
Date:   Thu, 24 Nov 2022 10:22:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 1/4] dt-bindings: crypto: Let STM32 define Ux500 CRYP
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org
References: <20221119221219.1232541-1-linus.walleij@linaro.org>
 <20221119221219.1232541-2-linus.walleij@linaro.org>
 <73df18a2-b0d6-72de-37bb-17ba84b54b82@kernel.org>
 <CACRpkdZsxk2MH0AEHE=kpHuikdP35d3_q6wrr3+Yrs2QpZy62A@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <CACRpkdZsxk2MH0AEHE=kpHuikdP35d3_q6wrr3+Yrs2QpZy62A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/11/2022 22:35, Linus Walleij wrote:
> On Wed, Nov 23, 2022 at 5:13 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> 
>>> Cc: devicetree@vger.kernel.org
>>> Cc: Lionel Debieve <lionel.debieve@foss.st.com>
>>> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> (...)
>>
>> Please use scripts/get_maintainers.pl to get a list of necessary people
>> and lists to CC.  It might happen, that command when run on an older
>> kernel, gives you outdated entries.  Therefore please be sure you base
>> your patches on recent Linux kernel.
> 
> The people reported by get_maintainers are maybe not on the CC
> line of the patch, but if you look at the mail header they are
> on the Cc: line... because I pass the not immediately relevant people
> to git-send-email rather than add them in the Cc tags.

I am referring to the mail header, not to "CC" lines above. You missed
to Cc Devicetree maintainers (maybe more folks, I did not check all
addresses).

get_maintainers.pl would give you proper addresses.

Best regards,
Krzysztof

