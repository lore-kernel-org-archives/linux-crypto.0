Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BADC05027
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Feb 2023 18:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjBSS0w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Feb 2023 13:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjBSS0w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2023 13:26:52 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BD8EF86
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 10:26:50 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id ec23so3668966edb.1
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 10:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CrSEjosx76DpSWx5XDTFr+kUHA2weQ52QVd5sK72Ask=;
        b=JE4X7P2DG03+lyF/2gceW8ohZM1k5wSTKsf1SQOU7UDCeZ3Gm0oFjG40qNr776LP9T
         QnL+FDfpPeSfFJUshAB4b02iaCOQFT/MtF70g6w/V0e/HNXlixpKivlt1lEnW6Morj0p
         dBuXztEHPwtjhcXOomHm/ZOqOC+HLKd4wYKAlYCEksNPLvMOvcGDX6OGNd3uY2+6T3kq
         GXhfFFe7e2qzmQAJErXuX4sZNbxaeZuwMYYK5hKDlxgdh66PwEYxs1XQfO1+hKPKFIHw
         JGJ2/VcFXhF7anLeVVOX1QEk4QNAv0zvrHhijWiCFHrvducSXIc8ZU7C/UGSbGDtQOZR
         Ahqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CrSEjosx76DpSWx5XDTFr+kUHA2weQ52QVd5sK72Ask=;
        b=4fAbElwbASWrcfN37M7KGesrZueVPSf5gZ2bh5DqSHGAynHFjckSece9yb2P7+xm81
         xo34pCZF06jwsIlpKHwmGArEzLAnwDBz0auji1sntFDLIK7DbxwEFcghj8vn4Wur4Zxg
         6ne745DcnQC8vKJdx236/p5j6r+mT+N4x0dfldHe9CpseCaGoUXk8jUYm7Xa/LONa55j
         0FDR4/vVSlAvXc1DMOFf3SzNhACT6zdVqkki5Sr7tvbupgQ0uGlN8L4aCATtbCgSgtjk
         h2fLBdbd4zYrx6zrHZd14qVVKz1sUnZgsNjkbh0DABz1Yu6i1L569PL7ug4L3yqBvsIe
         4agg==
X-Gm-Message-State: AO0yUKV7s9yef+uedX2GjbO9GmUJYJ5qW3lopvlhrLgV7TIADqykqjCE
        Mb6l3gJY9sHfi1qmJzUU5PQq4O9+3yuY/54QJf2pzVZh2dM=
X-Google-Smtp-Source: AK7set+hjIMZyDpWx0rNwLV2D3blCrW7tgAwg1K2/j6FObetNlFrdX0uEMMoCDudXOq+g1TFWGFxopgLio98kMF2Iko=
X-Received: by 2002:a17:906:ce59:b0:8b1:7e1b:5ec1 with SMTP id
 se25-20020a170906ce5900b008b17e1b5ec1mr4185182ejb.6.1676831209353; Sun, 19
 Feb 2023 10:26:49 -0800 (PST)
MIME-Version: 1.0
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com> <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
In-Reply-To: <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 19 Feb 2023 19:26:38 +0100
Message-ID: <CAFBinCAL+UdDm6P-AhEkS-M7nR=HkFJQ-nijZU8qgp7ZCJ2aww@mail.gmail.com>
Subject: Re: [PATCH 4/5] hwrng: meson: use struct hw_random priv data
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Heiner,

On Sat, Feb 18, 2023 at 9:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> +       void __iomem *base = (__force void __iomem *)rng->priv;
I find that "(void __force __iomem *)" is the more common order in
other drivers. Which of these is correct is something I cannot tell
though.

Also I would like to hear some other opinions because to me the code
was easier to read before.
Your way is shorter and may save a few bytes (including alignment etc.) though.


Best regards,
Martin
