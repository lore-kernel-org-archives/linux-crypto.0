Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC38C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 17:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245718AbiCWRNs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 13:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245713AbiCWRNr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 13:13:47 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B137E7CB12
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 10:12:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 25so2756654ljv.10
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 10:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dM4pcJiBV/awg1oo073JqIl31YIDpGaE/EgJFPs8wAs=;
        b=ItfWo5NdAT0PuC7laIcMECceoq0vJUY3m9ub8l6qo0aAI375KLdo5miTd4vOl/wPiq
         k7RU8heaGNRHky+eTCK0QkGkMr6Ln6AUWHbBqJhtP16bOJi1hQ0NiNsylKlGFDYyiWMJ
         lOxhbZx/ePVCZTiHAzjyKVPDFnHUKq9yYABJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dM4pcJiBV/awg1oo073JqIl31YIDpGaE/EgJFPs8wAs=;
        b=J/Tpq6s3Mkosu5oyjJHpUWvaNwBGW32UmPShiMntGa+SYDdr7gCllGvIwQ14nnLa2/
         fZFZO6ybVvEqdB56vFMIKqKzP4X/hPkv2XsE9UP1bwaNy0Ud1SyfNuEctPHypNaP0hSo
         9VdTOH8fTWsg8ha/UlUXmjavTPVi4OpEQ56rEJYUKt70xoy6R70pGDT1dwgH2oY73pd8
         c1Ug4IqGVf+sG3AdjhZtfbnriCX2HdeWrdJUpTXrc+nNUgtSOG1omw0Jz5p2J4LRcBZD
         sxLAd/JlZm9iqTqHiZs6ExKvvHf7o+YyT2HUDGeWhL/ArMuKOg4vcMSAJLXo90GnivU5
         Bc+A==
X-Gm-Message-State: AOAM531REm/1uJG5SNmPCLm5xFBr9UnOGXjs3pB2oM7ReQMzaRtwvTuG
        HulG7g+jYZWUYelacPvEbJWz141Qji31ixhgW9M=
X-Google-Smtp-Source: ABdhPJyECfjxcF0ZxHoWu93eI7P3u2mUnbmaG/xWxhwl6rk/1qNRuhgGL5hjIchkvitsZpHSjjPydQ==
X-Received: by 2002:a2e:96c6:0:b0:249:863c:5b2a with SMTP id d6-20020a2e96c6000000b00249863c5b2amr796520ljj.103.1648055534807;
        Wed, 23 Mar 2022 10:12:14 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id u2-20020a197902000000b00448a4a7cfc3sm42880lfc.136.2022.03.23.10.12.13
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 10:12:13 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id e16so3759810lfc.13
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 10:12:13 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr643064lfj.449.1648055533141; Wed, 23 Mar
 2022 10:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <Yigc4cQlTJRRZsQg@gondor.apana.org.au> <20220322131327.GA747088@roeck-us.net>
 <YjqVblTmjNYl3Zjc@gondor.apana.org.au>
In-Reply-To: <YjqVblTmjNYl3Zjc@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Mar 2022 10:11:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjKzJGO3bMv1hANBtnSAgt0A5X9rM2Lpd6YritqSsH0Yw@mail.gmail.com>
Message-ID: <CAHk-=wjKzJGO3bMv1hANBtnSAgt0A5X9rM2Lpd6YritqSsH0Yw@mail.gmail.com>
Subject: Re: [PATCH] cacheflush.h: Add forward declaration for struct folio
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Harsha <harsha.harsha@xilinx.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 22, 2022 at 8:35 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This should be fixed in cacheflush.h:

Applied. Thanks,

              Linus
