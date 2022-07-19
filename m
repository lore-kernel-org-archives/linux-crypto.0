Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5FCC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 23:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiGSXZ3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 19:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiGSXZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 19:25:28 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFAA1F2F1
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 16:25:26 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l23so30053490ejr.5
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 16:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=+x94cAjZkFVL3ZsDtxHVUI8uCzktHKi7ciRf4TeKZOU=;
        b=Cez9eh9EZhh4oT7EaF2jYUNSsVYV8lB4Qk74i+By7tuGrR8Lkgv7P/mKuvJ05aUNcl
         YzyWZv0YJAJfo+jJktHq93VK26Wep60w5WmhD3lbcCzTzPymnn808tZa2+efl2pjF4N6
         rNeiaBAQW8Jf4UTcOCukEBUkH1lXskuqnIBE1sDi5wei0FSlntkFoKtWmnC5zG4CDCRi
         PAawX/kUcjS/Gu6P/n0eMiS/HTJ1UJGYp44MNxF5jfLLYGXy2fPzamkBPWaWZeWwKpq4
         9gyAclWhcBWWqFfKn/7yad0pD8p5W0CE0g7SSzUcvn/iWdlm8uHaeLvWcEbV2G0yNBmn
         +gyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=+x94cAjZkFVL3ZsDtxHVUI8uCzktHKi7ciRf4TeKZOU=;
        b=xsGpZDmxCLoQ0xfRXDLE36FAcIyELn3Js3T9qO6Rdq/OXxvXEnKFIcAsUWUT34kVR5
         0vGsTpIdazMzPEGCuezdnIVTMoXeErDvoruL5XokPkS0JXryRZg5o3viAekl1VOxKygx
         /ndlx5KOhcAhEjSg+GY8dneviGxwEJGfkHU5DTW/uvB3uueqn4mFb9UeSXVqueyk6nAc
         SVauLwZSnK86DM+UeiBucZy+IrxzpVgpSw4e2eWG63fLkkryxldtBxHEKV4qH9RQQrEg
         yoIH8bS3tHJxJiKRL2qTxn8g2OZO/79Okjh0VtU3pc08UNQXqfrlykpTU5O/OkCV6OLa
         2AbQ==
X-Gm-Message-State: AJIora/YuNz5TUD1SxGPZ7GEsfDtuQqmmVNpQItqClli1ylkB3Prn/U6
        sEBeQz9t5LEFX1Cs9ENSvjOZmh/hvJf9YbOFvjBU3D0uyy3Ksg==
X-Google-Smtp-Source: AGRyM1uTBl2oJ4LWH+bLhWVfeaagjN3WgUNBch/8gMt0J/RIMuARaHkctgzT1EQ0X7fpPRdBOFL4IGOL5/L8Wk55m0U=
X-Received: by 2002:a17:906:5a61:b0:72b:1468:7fac with SMTP id
 my33-20020a1709065a6100b0072b14687facmr32293976ejc.440.1658273125020; Tue, 19
 Jul 2022 16:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220719140238.127690-1-linus.walleij@linaro.org>
In-Reply-To: <20220719140238.127690-1-linus.walleij@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 20 Jul 2022 01:25:14 +0200
Message-ID: <CACRpkdaJSAy21_OfYowwdbJH9=MpwQbmCcSVwTiMbPxSK9=uMg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ux500/hash: Implement .export and .import
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 19, 2022 at 4:04 PM Linus Walleij <linus.walleij@linaro.org> wrote:

> The .export and .import callbacks are just implemented as stubs
> which makes the tests fail:
>
>  alg: ahash: hmac-sha256-ux500 export() failed with err -38 on
>    test vector 0, cfg="import/export"
>  ------------[ cut here ]------------
>  WARNING: CPU: 1 PID: 92 at crypto/testmgr.c:5777
>    alg_test.part.0+0x160/0x3ec
>  alg: self-tests for hmac-sha256-ux500 (hmac(sha256)) failed (rc=-38)
>
> The driver already has code for saving and restoring the hardware
> state. Pass the tests by simply implementing the callbacks
> properly.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Forget this patch, I found some corner cases that make it fail.
I'll come up with something more elaborate.

Yours,
Linus Walleij
