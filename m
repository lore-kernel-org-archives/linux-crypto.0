Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B6FC05027
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Feb 2023 17:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjBSR1N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Feb 2023 12:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjBSR1M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2023 12:27:12 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D7212F3F
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 09:27:11 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ek25so3333412edb.7
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 09:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nVudR2aOARjEd83sJSbtsKwFrXIDWImwbSkOC4N9De0=;
        b=Nor2rmKM0cGUiFgzqaWQKCtwzx4KQHKdPGStDUF2croDYFbaRM8uHhghBAqs+Dk+KE
         Szms/L8j8NePq3MAyOJZeOLQ4lQUdNTjan3WavWDzG9b3Ze/8IGVQUT7HErC3p3DlbNF
         5b6nQHkh0rvZmMMoaRmpS/Jgan3QvzMkWk7nx7sqwbH/TrUmXY3dHhPhJNQJvMQhM6r1
         VuijKd3EQk6ifoqrHh3rgcYrI33/XPyt8kFSNbx4SU/SePTFgvKhdBI+FMsQASMpPKfs
         xWq/6WdPW0B7F8TCJVxOIvxDzKwj9wZCneVf++clVufy5qXTVVIUHSt3l99fAuBe+8F1
         FDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nVudR2aOARjEd83sJSbtsKwFrXIDWImwbSkOC4N9De0=;
        b=Yi2oixh04CZuHj9nLbpgrR8XOGjMjqaYOrswytJWXuk+JUd4Mjwd7ckJXIAKIPB1sW
         Lg2cStiMKy4+A7/GGibE5Ot0XZkDoiUR38skjnzDmSsX/29G4TxrcS0yqqBV01nnX8WV
         p2OumwYzfANeInI72c0IUW8UMgbGya9jB5REv42GaJ2zx8yMkrnlYtoUeqLjdu0OeZzd
         Br+d/HD3WHtRF34DQC2YSo5+P2NzkIuBVjKWd9iC1zjw5/0DxFvFvhSBLpdrSd1/2J//
         kjCXJFBfp1Uw5JLc2koO78L+akcvgMDX9FzPLFh32SEHMLhQikPFWa/xcuAsbzXtw+9H
         /Ehw==
X-Gm-Message-State: AO0yUKXIB1axFWCaK4yDL1PTMXP7WijLNEgmDs0xO5+4Nz3oe76kJ31L
        ubqzueNFsGvIC+TjIYTvdkNiDSTyH4xZH86tqmEFBTII+gM=
X-Google-Smtp-Source: AK7set+FOBi8d/QJBaKuTLTh25DygjP3fwtO4Wn46Lo2mrYhGEJRipZ+tV5D13L6qK/4ffJTxfbjM0HCrOQkcu6/duQ=
X-Received: by 2002:a17:906:4f0a:b0:8b1:30eb:9dba with SMTP id
 t10-20020a1709064f0a00b008b130eb9dbamr2993044eju.6.1676827629675; Sun, 19 Feb
 2023 09:27:09 -0800 (PST)
MIME-Version: 1.0
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com> <08fa1416-8786-b442-2a45-0ba669992639@gmail.com>
In-Reply-To: <08fa1416-8786-b442-2a45-0ba669992639@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 19 Feb 2023 18:26:58 +0100
Message-ID: <CAFBinCDxBAyV8RiceOdreOu93RtF3n14mXhyeqHLt2hr2GEHAw@mail.gmail.com>
Subject: Re: [PATCH 1/5] hwrng: meson: remove unused member of struct meson_rng_data
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

On Sat, Feb 18, 2023 at 9:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Member pdev isn't used, remove it.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
