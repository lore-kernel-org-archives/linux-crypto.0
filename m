Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4C4C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 14:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiKUOLR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Nov 2022 09:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKUOK4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2022 09:10:56 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF74A11163
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 06:07:54 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id z192so13723552yba.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 06:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IWOZXSWadpIbDXCwQsI8zutVdTS+C5TkqaxcBi/y1dg=;
        b=m/1O1bJEHXsx6J9Mujw+gsd9g+z98hk92EVKBqEk3sHE1ScqSQZbnSxhZ11v8OOIZU
         PPDQFLV15YEBsPnWtkgUZVnvGEgAO1xxYCfl22clmWNiU2eq8oA0b/UqU0pHHzVNGp3O
         psvzrwPrnBYsgk0l2wlkayXynDsrKHwJVGJnVntPqWM+tqaB5b9FDGUYVJhlO5CvPv8e
         c4ydE43cgaxgsQYKYO78fh4oT4EG1zfkhtUFei4WahCRErL8kQN2Pmt0OYDnw4fVEl7Y
         /eLV1C51AOk5lnV6tOLSB5WoU9QQFFyF9x0ecZyEkIk2JrEVsSMDJsWzsyjuJ/2PET65
         50ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWOZXSWadpIbDXCwQsI8zutVdTS+C5TkqaxcBi/y1dg=;
        b=MFI+Dd5dQz349xkU45WU37Y0ArHjfCrNZzqV4Kx1YepjLqn1YdostCEBUPtJ70ZNru
         DFK4UGIe5olUA88Uk+lxJwTlpDLpJzFDjDMb9sq/T0JRUvh6Y1CF/AWN4UUG6UM4K0Hy
         d943Mxi7C0dtlqn9jc3cfxFCMvAgNbczNwPNTL2D4nOD7lBkC8RfM4a7q35e791ee/Qe
         CrQqTTCSGg4VFZ2HmNgkA/PkLtTaiAUThpPtYvRzpVmsFLkLnyIf7F4iNImGH35hz5Y6
         45MHU79okE6wgMXwxxqAX7Fm3RWNShG87C/ecsHU/8MS35GEuVGtySh4iexOukesgXMP
         goBQ==
X-Gm-Message-State: ANoB5pl6X5zt1S4WC6ATAQsaYHZ/fDaY55LOv08NfDzMYTSdyTN+mOYy
        GVeGvYf79QPvw7rf4CsKFfrPZbMT9PVcZOK7HjocdA==
X-Google-Smtp-Source: AA0mqf6koKfrv1sUPz1RuyfPFqXMHWeOJkaz2tBv+fn82k4M8T9LPB0xozZUrsBaMW+2AebPNH4ZVg0MAPxHY0/NBjY=
X-Received: by 2002:a25:734a:0:b0:6dc:324a:7561 with SMTP id
 o71-20020a25734a000000b006dc324a7561mr17155400ybc.52.1669039673956; Mon, 21
 Nov 2022 06:07:53 -0800 (PST)
MIME-Version: 1.0
References: <20221119221219.1232541-1-linus.walleij@linaro.org>
 <20221119221219.1232541-4-linus.walleij@linaro.org> <8f55596e-12e3-8968-ebe5-e90be38ca5cb@foss.st.com>
In-Reply-To: <8f55596e-12e3-8968-ebe5-e90be38ca5cb@foss.st.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 21 Nov 2022 15:07:42 +0100
Message-ID: <CACRpkdYr3RKidNUjJQG88wEua0OvMYRTHe_48W7N35C5MSsSKQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] crypto: stm32/cryp - enable for use with Ux500
To:     Lionel DEBIEVE <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 21, 2022 at 2:35 PM Lionel DEBIEVE
<lionel.debieve@foss.st.com> wrote:

> + writel_relaxed(readl_relaxed(cryp->regs + CRYP_CR) | CR_KEYRDEN, cryp->regs + CRYP_CR);
>
> Why are you still using CRYP_CR here, would it be better to use cryp->caps->cr to keep compatibility?

I noticed that the first two registers were not moved in the memory map so
I just kept CR and SR as hard defines.

It could be argued that the code will be containing one less memory reference
and addition so it is more efficient, but it's so little so I am fine
to change it
to an offset in the caps if you prefer it to be uniform.

Yours,
Linus Walleij
