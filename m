Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606E2C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 336DF2077D
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmSSjKpc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgGAVwm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 17:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGAVwm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 17:52:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C1AC08C5C1;
        Wed,  1 Jul 2020 14:52:41 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l2so23669180wmf.0;
        Wed, 01 Jul 2020 14:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D29INuEoeDcyeVL/TnCmg6pQ17sEWGngSUsr5EQv9AM=;
        b=LmSSjKpcPy4KMLL3Y6VJfnPOAIoUAyYvyzdfCIYFEbkNF8GMwQnPzsFZb2s8ah3diI
         KOYFL1yunBIeXc9QyzINND39sVA3qee4K7y5oICJyyB6S5MjIfis8p6URwJ7NPUnARfC
         v4IDUuR7PMzaTTtqlwfbtBdapwb9L46gZ7zqAnvLQR4ISgOJNdatiJ3K4tehnKNq0zqy
         B+RhkI9zEeRx6NV+9MY6/6QjvI0/oJvcaWVTDCCjI8bo1xuly/oWBVBriqK4ku/wT3jz
         uSRnOvR2qDrlI6nPTAiP9WdjFORTHynAbhmx8iUKkY+GHLvk0WTaumHx4u8/jk1Tw/7Y
         kt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D29INuEoeDcyeVL/TnCmg6pQ17sEWGngSUsr5EQv9AM=;
        b=Jh2MVl0K1u6U6Mx9eKB2dhuLbqyFN74mUtnK0TNvUq5F3MWp10VSDuyXKRmGF8Avc6
         +3nT2yaR9GOuz3iXeBZecJB2a/LZVGVQFK+aI0iI1SbJlS0y7XFE55TKL292UQUjmmE3
         FFI0UW1DxfR2fz8TSXwGA8fJx3cyTtU+6kvwDi2EAWPahrd1FurjRU+UqJIl4NYsCbRt
         LUpm4mJ/4YOYXg7SSz787nm1dlhvJHRLm5hvTEA3k6qoW58/o4Gq8e3s0Ve/ohNydegx
         lfnniCdNDltWKWvUHB1QBg9Qn/abE8IClLBcZgQEoyt9nsB43gCiF2cHV1Y9CjydvYHQ
         JzsA==
X-Gm-Message-State: AOAM533B/rZGYJ2fFAZySewy66dW2GAQmEWEwXnOyw1NAfeBAPvjSmKO
        Sfo0pB2du2H4d6tvAXU+Hco=
X-Google-Smtp-Source: ABdhPJwbmkMUHF/Nq3SKLcm6+qfW5pe6n6Br38CypA8Qt9sdK8Y9+ol3hqFgixAbHUX5NP/XzZiIHQ==
X-Received: by 2002:a1c:80c8:: with SMTP id b191mr27052912wmd.37.1593640360581;
        Wed, 01 Jul 2020 14:52:40 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18sm8562985wrq.13.2020.07.01.14.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 14:52:39 -0700 (PDT)
Subject: Re: [PATCH 1/5] hwrng: bcm2835 - Constify bcm2835_rng_devtype[]
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
References: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
 <20200701200950.30314-2-rikard.falkeborn@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <83b5c8b5-484a-d688-3c22-b15e388575cd@gmail.com>
Date:   Wed, 1 Jul 2020 14:52:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701200950.30314-2-rikard.falkeborn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 7/1/2020 1:09 PM, Rikard Falkeborn wrote:
> bcm2835_rng_devtype[] is not modified and can be made const to allow the
> compiler to put it in read-only memory.
> 
> Before:
>    text    data     bss     dec     hex filename
>    2392     176       0    2568     a08 drivers/char/hw_random/bcm2835-rng.o
> 
> After:
>    text    data     bss     dec     hex filename
>    2464     104       0    2568     a08 drivers/char/hw_random/bcm2835-rng.o
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
