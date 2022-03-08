Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE7EC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Mar 2022 00:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiCHAJV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243897AbiCHAJU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Mar 2022 19:09:20 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6120BDFA6
        for <linux-crypto@vger.kernel.org>; Mon,  7 Mar 2022 16:08:24 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2dc348dab52so150213047b3.6
        for <linux-crypto@vger.kernel.org>; Mon, 07 Mar 2022 16:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mx5hLEqn8My0F+yXTcGcX8saGMYANVTYsACmCpFd5d0=;
        b=LiHV6K7JBJSMYhKhrKF9W2mHES55ZBn8mEURsw17mfuBV4BSev7POOOhRzd8JKyBKF
         paBwZnN+QOzLeUc0+g7vXjBOguhMIuEnf1ZzfLj4rTs40Tnk9H0t9vCr5wE3rHn0D+gV
         EWtZrTqcTGgFWFx7nknKXdOQIhqGEenOZKYB7PKKunlLxXOUMVndrc89oQV6wAgrYTut
         SjP7NBczzWSbkdpJMULm7WEqLrJoggoPCkrhfB9dXfxHFE80l5050MfAK+EirIfJ0ry2
         RulRW9iQLwlKAPRgozIw8dYstsFGH/t5TM5OGhdxL5bZT3gwfFmrXCCO+mzlUHow/h/t
         Gevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mx5hLEqn8My0F+yXTcGcX8saGMYANVTYsACmCpFd5d0=;
        b=J5VZTFRaF7NrI2NU8EVrytJf4L8MnNH1DKeUIvjM2+gXMOBhoZbcemVz5gp1YMT8k5
         u2wiMBqgFxTHkW/sXDlBdw5q3PKCmFRi1LOpBSI7cSmeJt0zbBultjGCmtslSu80suuC
         xAcGQCo7fbKUXNqbdnmce+OEJo4D7+w/sQAvQkpINYNcXvblvITFJGU/dpoXwa3xH2hf
         68uq8oTyf5EzyjqVB4/QsAGTrleeCuapTuHurzqE8rGQzdxtR+pZ5XDphps4Um2lgkWA
         W7VxfVsx2LgN1bZ8tsUQNEP8pue0qxIYjm+ZdaD97ews4hQTANov4hCMRyxEwuKKGUrw
         EYFQ==
X-Gm-Message-State: AOAM532XvaQGZ50NWZcF1RDHF+dHRRJTfywCxDGO1enpl2SYWZBmr9n/
        7o9yw1kIKlvoLjBg7+7u+45LfUOZvkGvoEtRG/ePKw==
X-Google-Smtp-Source: ABdhPJwxi+FboTfWrIvFpQLriAStK9q1fbskER46jhk3WG0eM/a3DZxitYTJ/w20P3pnlqOQ/WkPO91Kvl7D/sPujJU=
X-Received: by 2002:a81:854:0:b0:2db:255b:dd6 with SMTP id 81-20020a810854000000b002db255b0dd6mr11185948ywi.140.1646698103518;
 Mon, 07 Mar 2022 16:08:23 -0800 (PST)
MIME-Version: 1.0
References: <20220307110728.15635-1-linmq006@gmail.com>
In-Reply-To: <20220307110728.15635-1-linmq006@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 8 Mar 2022 01:08:12 +0100
Message-ID: <CACRpkdYTZDeumBHewcP79nvVOkHZtKZFecRQHtP4Uqouhzxu4Q@mail.gmail.com>
Subject: Re: [PATCH] hwrng: nomadik: Change clk_disable to clk_disable_unprepare
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 7, 2022 at 12:07 PM Miaoqian Lin <linmq006@gmail.com> wrote:

> The corresponding API for clk_prepare_enable is clk_disable_unprepare,
> other than clk_disable_unprepare.
>
> Fix this by changing clk_disable to clk_disable_unprepare.
>
> Fixes: beca35d05cc2 ("hwrng: nomadik - use clk_prepare_enable()")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Thanks for fixing this!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
