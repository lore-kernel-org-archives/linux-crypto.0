Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F783C77B78
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Apr 2023 08:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjDUI7l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Apr 2023 04:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjDUI7C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2023 04:59:02 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40C5A26F
        for <linux-crypto@vger.kernel.org>; Fri, 21 Apr 2023 01:58:15 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-54fb9384c2dso16359537b3.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Apr 2023 01:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682067495; x=1684659495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tnh709okt+uP41Hcpil4IPZBFvTT3gggD3zdKbpf1Cs=;
        b=t/VhQCQGdS9C8p03FedeZO7vrHCPZ7h328TvprmMDkHuVUT5QivUzLhgQCGlM8DEcd
         Iz87fiFm6M+KEfTkAMe9yJQaxyUquICvqqvSwse7XVLDsqJcmKyezRyfwfHFFdQHcitt
         W8mWWelB/b2kcF5C8KdIAfaeKqFwB7B5rvH8C1H/YcTg3e/Eiw4FsQIRZLRqoj7Dznbm
         ZfEFDDoqvQHt73bdxMrsLimaAyYeMXqG+95/qP+pIyhoRMseFxrt3xkBdzfwKBlVwZeS
         wT0NwWOHgytg+YUR6BTBSlxUflPc4F/f7qVYTJvsFee1fdzXX+/Sw5cE1d6cfuD8FlMh
         P1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682067495; x=1684659495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tnh709okt+uP41Hcpil4IPZBFvTT3gggD3zdKbpf1Cs=;
        b=dltMYGWtzYMxDa0d+3ZbnsI1BcrDWVlhOoDgbPsKh9a/ITfNulC/7oT0NseztoxXEc
         cyy1HyvfsWHOyjtpmP9oXa3xzEsjjB602kk1uaQQ83kmBpo6RTAMxm1udAbKs/+Jw68/
         zDUpW932ZFpoT/XsBhaQ3CDpahRo3kijkJymh+8HQMnVxJMDNBmiSUiAKN0l1x0+Mu0b
         8p5/oI2wJ1gPQZOLyweETIf5wqSE2Vnt7z4hcG+SVPIxykHMWTNEDh3jG9rRElxPdZJh
         leq0U06wV4d5wx7RIStB8cMrHl/4y/qoX+p9oKmTErRBDFFiQRNudjFGJW4lJcdIyBGM
         LTHA==
X-Gm-Message-State: AAQBX9dknpJDW3m4r/APO1jYS0uh8NDRGAWR5cVpy0SXnGz89gxc0imh
        t8iKR6lRVoLytqkXxjNK1zl3jUJYB1gNNELJ7Yn/xw==
X-Google-Smtp-Source: AKy350a1ARMKHmgYAXdj4qmbuGefNt5X5XrEyfvLA6zisnjtQpG1+XfI6gOzF761tMUJN5V0aCqIyrvUsZbF51sXCq4=
X-Received: by 2002:a0d:d905:0:b0:556:10c4:6b1f with SMTP id
 b5-20020a0dd905000000b0055610c46b1fmr1258230ywe.36.1682067494767; Fri, 21 Apr
 2023 01:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <7de7d932-d01b-4ada-ae07-827c32438e00@kili.mountain>
In-Reply-To: <7de7d932-d01b-4ada-ae07-827c32438e00@kili.mountain>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 21 Apr 2023 10:58:03 +0200
Message-ID: <CACRpkdY=-=VRf1XtjcXvSjBzmxPS_UsKT32=JNAmAoX5Lp5Ciw@mail.gmail.com>
Subject: Re: [PATCH] crypto: ixp4xx - silence uninitialized variable warning
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linusw@kernel.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 19, 2023 at 4:26=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:

> Smatch complains that "dma" is uninitialized if dma_pool_alloc() fails.
> This is true, but also harmless.  Anyway, move the assignment after the
> error checking to silence this warning.
>
> Fixes: 586d492f2856 ("crypto: ixp4xx - fix building wiht 64-bit dma_addr_=
t")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
