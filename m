Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7C7C43460
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3885F61360
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352575AbhERVqK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 17:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242685AbhERVqJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 17:46:09 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05205C06175F
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:44:50 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w33so8057007lfu.7
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDa4WHcFdueIrXi1rhrqppN7ZdRyzonqmDM/tclsxk8=;
        b=Lozegdgl3LLaiS0DXMtRyh+aYAHSn61Q/FZlftfF4LWfmAT2SnDWl/kDnCvxJ0+HCg
         C/UczA06CvIaQwdsRrA0MRbAP18/vKmY3tp8abR4BWTx9vExf4998RxT+wY4EjVlgIA3
         P9dMcEWNlvtU8tJps7PF1fbPzPLKjRrQZRlLFdFw6rcl1zMBoUuEMfuET28VQgrrUP5a
         zwmFBQhStoj5cxp+N77Qu61+4FJNBwaqNjqQzeHhjNFz4RjCmNxRDaZv4ycSqK8WFUq3
         oCwDwaGi5gelGVkpHyD7wSJJNXcQbKeOxVM/azsA+biQ6dJ+wa7qS1e7YAxhFKyjyM/X
         1QWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDa4WHcFdueIrXi1rhrqppN7ZdRyzonqmDM/tclsxk8=;
        b=WEXTnNBNKQr+hYTNEpOGfqZasrDb8kWwA0wgNUUWksEvw+dcimw4HxrGImxsLT46pl
         1ExoI8tGsOhon1WwtRzidVxFE+s01YimqkRxzdZ88kmfgpgb+osQPO5ndjXmaKZtj6km
         FDxSG8CnubHht5PjVihpCGtX0QjAW3aI1omhEyfYfdO5BL3G5y0j35TpHwx82yesvsq/
         NrMfmVm3QGioeeIfegy6sVgz3rhC98qGD2sWan9QP2i6SsOWx8ZnxlnzJ26DG6voUsne
         DVWvh7PkuzGp6WIYbd8BMimna7VrD6ouq6J2xTpElgRj5Htpyf0zpJhfPUUuPN7RrDFs
         LihQ==
X-Gm-Message-State: AOAM530JJESSjLhFgpKUQ6S6RF1Ur/FTfGZJjkCzQk7mWYTknjZmPSvZ
        On3mQcvV1g/sG8m7SRrWTNjGF2qDQUTrdfWW2g6qgQ==
X-Google-Smtp-Source: ABdhPJyv4BLDM+5oyevoFet2Ve5mvZ0YIVLNRIwIVT5044vGftDZlD8yee6eNLuaQFvmk1PTZxkoGk+fLfCys6C7K6o=
X-Received: by 2002:a05:6512:49b:: with SMTP id v27mr5678712lfq.29.1621374288547;
 Tue, 18 May 2021 14:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210518151655.125153-1-clabbe@baylibre.com> <20210518151655.125153-5-clabbe@baylibre.com>
In-Reply-To: <20210518151655.125153-5-clabbe@baylibre.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 18 May 2021 23:44:37 +0200
Message-ID: <CACRpkdaP5eGe+afaDd29hYy=_drH-245OTcdUFgq0Sz8nZxajw@mail.gmail.com>
Subject: Re: [PATCH 4/5] ARM: gemini_config: enable sl3516-ce crypto
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 5:17 PM Corentin Labbe <clabbe@baylibre.com> wrote:

> Enable the crypto offloader by default.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

I'll apply this once the driver is applied to the crypto tree, I need to
update the defconfig for gemini in some other regards as well.

Thanks!
Linus Walleij
