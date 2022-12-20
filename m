Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB923C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Dec 2022 10:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiLTKLh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Dec 2022 05:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiLTKLg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Dec 2022 05:11:36 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BD4F25
        for <linux-crypto@vger.kernel.org>; Tue, 20 Dec 2022 02:11:36 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1445ca00781so14887732fac.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Dec 2022 02:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X6d3Z6dvdsIJ7mSON8osSHcFlqBJfVh3ygvs/0GnLUA=;
        b=XOH19Nuw5AW71x4dMl+COJmb20aWkbQV4JS6o9ilHkOS3MiliNZZ0Ioo2gtmDPjSjC
         j9QEyBPUmidYmnYsuyUIL/2K0FKnsiKZEI6M8LGhOR+FstULcvGlJFEc4UgYdHbCGK03
         1IHK8DMp1qNglENfFSfhq6LvCcCamKLH3HouZRM9/VBhjz6axY02dY5dDu767L67aIOc
         h2vYAYduY9NuPoYpHky3qZuclig8/4jJKMpPAxkIydkY/ese1mraC9/bPhGs8mU/bvMF
         PHUNgc3NdO6inhdmyzu05WF3+k+YGuW3JOlEL3V9lRUb1HH386gqaBdQ8zgPjN83PlUn
         cJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6d3Z6dvdsIJ7mSON8osSHcFlqBJfVh3ygvs/0GnLUA=;
        b=SBLauf7LxkuIcOKHSQRuQz++NHDmBgl0xklTBmUaQ2bRDCioNuL2DfhnPZW3TbOvkf
         Yd4b8PmsDJTI5GL5hgaAUZCyY5BW1iYMWg9z+w9xPye9Ot7jPdelJyVfaRNJQZXgz4Mx
         U5nN4TymOM3vJWvPVzvF0bAz7IMIjdVztYFpGwCrXeZKQypKPevVYZ7Q0/ZBKJjaSZr8
         IQRs4n5FLMh9Ot2eQHcpblemogPnciLqi2YlpfDQ4N78/IkCj8rMt9v/a5UOkHSPNoKw
         UGNrkBSdyAh7Mx5Po/Nb5y+5H3dwd2yBjZKEsaIwyrwUUhIIkVLiDbpiVvHVWlYZBuKn
         RjGw==
X-Gm-Message-State: AFqh2koj9pRzlGe0dEf9cbQ+Lgv9/1vgk6ifqE1ODTHELsjoSrS3SMgy
        eRRofqPw+GcxHn/kydQs6qNQO/nUNZh+J3pu90KUAg==
X-Google-Smtp-Source: AMrXdXu4MHoS5gKZBxPWbLf6IfGETzNFrfJ7rJVFxDXPSQ6OvduE8JP8iY32hcC0PljM8KzcQahIdGHMj25AGSs6J1M=
X-Received: by 2002:a05:6870:a790:b0:13b:96fc:18c1 with SMTP id
 x16-20020a056870a79000b0013b96fc18c1mr1602468oao.291.1671531094833; Tue, 20
 Dec 2022 02:11:34 -0800 (PST)
MIME-Version: 1.0
References: <20221220080536.30794-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20221220080536.30794-1-lukas.bulwahn@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 20 Dec 2022 11:11:20 +0100
Message-ID: <CACRpkdahe6-ryRb+qO3+u6-XyhQY12++2eq_CZB-g40dj3Hd-Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: ux500: update debug config after ux500 cryp
 driver removal
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 20, 2022 at 9:05 AM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:

> Commit 453de3eb08c4 ("crypto: ux500/cryp - delete driver") removes the
> config CRYPTO_DEV_UX500_CRYP, but leaves an obsolete reference in the
> dependencies of config CRYPTO_DEV_UX500_DEBUG.
>
> Remove that obsolete reference, and adjust the description while at it.
>
> Fixes: 453de3eb08c4 ("crypto: ux500/cryp - delete driver")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
