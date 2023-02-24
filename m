Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C77C6FA8E
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Feb 2023 23:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBXXXP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Feb 2023 18:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBXXXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2023 18:23:13 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F461E1E4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2023 15:23:12 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-536cb25982eso20296867b3.13
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2023 15:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JJloBPukjosp0Co3bwwIxo1Na9CysMVJH+mDRCTcgY0=;
        b=mQfsAqFRu1lR3UwE74SBhH1BARt50OxJKOy+g64t4XNTrgyQCrPnHRedv9N0jlLotd
         IxIJ5XI8j43YBOv3tqgCss8qU9C76Nq2l6JYpY6tFSkdFR4EWZHP05jRFVT+N/YiDeVx
         5NPEV7R9weBdjpzSFrAAQzYhI7dFyXZZmAIwFu+8jG4CHZsoUiR7gUV+pBpigPhcgBiu
         zgrhXu2WWGrwvQLQY0KoVDxLSn3BAWGf92VCPXJpBNqv5t1rSTCoBU7el3zEC8cREBQt
         AYQXi/a8PcdopK+yYyHOOZPfINcmsv0J4A9HFBCXFR0C30ERpi0nYBaIeExEv3zRMh9j
         MMoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JJloBPukjosp0Co3bwwIxo1Na9CysMVJH+mDRCTcgY0=;
        b=SwutmvYP2A8OiJFsmowowqKbFfNJcCwxkXz/9e5enE2/H5orkqGoxaRin9Gy2WsEFz
         NLPV/6BJKkwNywfrr0WQErUt37BNURen5nYzhupIUFuXHUsaSvQiNy1HMi7R7e92rP2d
         rmKNo2xOvB1oHqYxDhJJkJVEyNYTiEgtZosK+L5Baa8UvycJLiyPIokeTEbJrXElKKwn
         zkwaYzSw4vVr818+0SW7UuZzJFfUzETxo7OUI/7gngvXhC9P4hSd0OMzWzv5763oGMXv
         s8gNajpJVq04x4NYBzF/0Vhd9t3p2fc3FfHPQBufFHyK49jB49WjsK2Jr9b7ewp/NW9w
         /Qjg==
X-Gm-Message-State: AO0yUKXxyIVQuRdDEtwBJmMjm/2dX/N+a6stHhpDwlOFL52QS+O0W9fO
        yHpjIHLKVsbMm5zItkuarofk4sMSxkf4aMhM93civq7si//ADTRg
X-Google-Smtp-Source: AK7set80l9b7wx0n0L1HwF0zisFs/rqgF9dYT4DpqFQ2vP3QBA8LDn1hWX0f5G2GLMcFuJw2CDgOl69eMN1vThG6DA8=
X-Received: by 2002:a25:790d:0:b0:9f1:6c48:f95f with SMTP id
 u13-20020a25790d000000b009f16c48f95fmr4133553ybc.5.1677280992025; Fri, 24 Feb
 2023 15:23:12 -0800 (PST)
MIME-Version: 1.0
References: <Y/hGU7r56Phsz3wN@gondor.apana.org.au>
In-Reply-To: <Y/hGU7r56Phsz3wN@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 25 Feb 2023 00:23:00 +0100
Message-ID: <CACRpkdbMXKeiHPCSdupFRd50WjcidT22odYuu-VNvHYgeuYTrA@mail.gmail.com>
Subject: Re: [PATCH] crypto: stm32 - Fix empty message checks
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 24, 2023 at 6:08 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:

> The empty message checks may trigger on non-empty messages split
> over an update operation followed by a final operation (where
> req->nbytes can/should be set to zero).
>
> Fixes: b56403a25af7 ("crypto: stm32/hash - Support Ux500 hash")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks for fixing this Herbert!
Tested with extended tests on Ux500 without problems.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
