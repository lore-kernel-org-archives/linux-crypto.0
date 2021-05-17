Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E351C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 22:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B24C611BF
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 22:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344038AbhEQWpa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 18:45:30 -0400
Received: from mail-oo1-f52.google.com ([209.85.161.52]:33679 "EHLO
        mail-oo1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239660AbhEQWpa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 18:45:30 -0400
Received: by mail-oo1-f52.google.com with SMTP id j17-20020a4ad6d10000b02901fef5280522so1829785oot.0;
        Mon, 17 May 2021 15:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L+8IYdctVljsJPJZjh7tFzHKTPA7QUIi97B/h1sPgbk=;
        b=QrxK/XlYAOK8wHpkskjWNUGYIh1MJSGeBqG8bUKxBP3tHIWih3lb2u0t4C/pcpygdv
         UADUHiRpE5fViytgraXmHZuMInYBZorYdSwtTZmfBPH/hpmG5yram0UdphcMWj2Yn1L0
         gux2pzjB3rk10NkPfHeqlOteoQCFeLmTLJlVGw0nRWKU31I88sDOSPNjAeSqBUlLgWU3
         VyGokV8KqQF628d7SD2bsR74wTiDgXSaji4XPNQesbnVeo7Zmuawf8WoGWN1RWqeZuEC
         idPkR1WXcMfxYWl2yCarzyWLpUf4wPnTCLGdn3n+PSCpoDBqGdO9QxKlE1MCaAZ7f0W/
         Q+Dw==
X-Gm-Message-State: AOAM5317GxqlwAeo2h3d4un19dvlXXK6Cz4zMbWGsJkDhIGd3Ms+BgXp
        3W0dYyVfwslI0Y3OBQeusg==
X-Google-Smtp-Source: ABdhPJx9mnuaKeSNahPLlZlzIGu86g0crYHS92e2Mp8vyOsAOYJIRjXDCJOjPnG7ZUwY3isL0TpDkA==
X-Received: by 2002:a4a:250e:: with SMTP id g14mr1726791ooa.31.1621291452176;
        Mon, 17 May 2021 15:44:12 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j18sm3415782ota.7.2021.05.17.15.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:44:11 -0700 (PDT)
Received: (nullmailer pid 3346634 invoked by uid 1000);
        Mon, 17 May 2021 22:44:10 -0000
Date:   Mon, 17 May 2021 17:44:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     devicetree@vger.kernel.org, Deepak Saxena <dsaxena@plexity.net>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 4/5] hw_random: ixp4xx: Add DT bindings
Message-ID: <20210517224410.GA3346574@robh.at.kernel.org>
References: <20210511132928.814697-1-linus.walleij@linaro.org>
 <20210511132928.814697-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511132928.814697-4-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 11 May 2021 15:29:27 +0200, Linus Walleij wrote:
> This adds device tree bindings for the simple random number
> generator found in the IXP46x SoCs.
> 
> Cc: Deepak Saxena <dsaxena@plexity.net>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> The idea is to apply this through the ARM SoC tree along
> with other IXP4xx refactorings.
> Please tell me if you prefer another solution.
> ---
>  .../bindings/rng/intel,ixp46x-rng.yaml        | 36 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
