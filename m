Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D59C3DA6F
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Aug 2023 08:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjHXI0W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 04:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240514AbjHXI0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 04:26:10 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2F1171B
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 01:26:00 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4fe15bfb1adso9850712e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 01:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shruggie-ro.20221208.gappssmtp.com; s=20221208; t=1692865559; x=1693470359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TdEpv+yQehOUDtMKfkCTqDpBdvgIuQ3N6LCjN8giao=;
        b=EASC/7rEBvQrMbHPL5P18e+Gv0IysWXqXE1fqTXxrHpJiN5DPS4j4Jl7iNnQVmxXRU
         hutYsBtZYQOQwpYtCBq29vUB2PCiCghVrG9CgkYYwiTJL5oJ70gkJ3FmH0xd2Je1m+II
         b6OO4C3fHi63RQA02cvgNvZ7Gbs0wcANGsxtQfdI2Cu1jz9A2lSczu8XTvMIdH9iN+UX
         Y9tGKcQxI6BcNud8UYveJoIktq7HXH0ynHtpOpwuHPZ/m31kIPbK4nThZnms2awWvfBJ
         QVj5lNoi/F93jqCjQiK5CaLU8TKosum0TbyZfpLCWAqgSybpawJHtijNV8IjyLEzhIGp
         5ueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692865559; x=1693470359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7TdEpv+yQehOUDtMKfkCTqDpBdvgIuQ3N6LCjN8giao=;
        b=HtHpZ4DB9+sevMDf/5gTl+pONMgneGrGV8OG0sEsMqyoOFbtiw96TGVE6PCuDk496s
         b9L0jS+JC1iC94SMoNZpIRpp1gIaz8wDHFFtXRbvEVsGLZL/rrzNlSjprQGiK/S10vvv
         6GTqJIYiCYnKOVv7a4FdGOZW5eY2gsEwFyBaVCDbOqRuKdeRlC5lDIoVGNm1y2Avs6tI
         N7iufyaAaFjGpBbOCAxfBqoGSQQ8ICvGOnafcpgKnWe9J0GKQuKMAvXFg3z9treZ8VDi
         9GgN8r6qfE2zBa1dNEUXkmTAD2iIZ3Q9lwjYD2ZbyC+gKpRVVOjPzVszCYxKkJYJb5av
         jZmg==
X-Gm-Message-State: AOJu0YyhkOZ/20A3YO4KZdsnC5r4F1pPf+1XnkfWeyfSb9AbnbXL93PJ
        P3TWvDB9h6BAjBC+smUJvfmV6JszciNLlijbeYFG8Q==
X-Google-Smtp-Source: AGHT+IFTPLS7aaKK01I0mp960T0BithUnoHmGGRJbVNYRe76nw/p/hxRCaEv3yHpiI2RI6IP/xAhZqWnbUMBuPQqksU=
X-Received: by 2002:a05:6512:32ce:b0:4f9:58bd:9e5c with SMTP id
 f14-20020a05651232ce00b004f958bd9e5cmr13013611lfg.3.1692865558635; Thu, 24
 Aug 2023 01:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230823111555.3734-1-aboutphysycs@gmail.com> <20230823115857.qi44xa77doimlare@viti.kaiser.cx>
In-Reply-To: <20230823115857.qi44xa77doimlare@viti.kaiser.cx>
From:   Alexandru Ardelean <alex@shruggie.ro>
Date:   Thu, 24 Aug 2023 11:25:47 +0300
Message-ID: <CAH3L5QphsxcYC7=FK1=MEYcE-VyFy9t60jS8MZ_9TA5SMKTibg@mail.gmail.com>
Subject: Re: [PATCH] char: hw_random: bcm2835-rng: removed call to platform_set_drvdata()
To:     Martin Kaiser <lists@kaiser.cx>
Cc:     Andrei Coardos <aboutphysycs@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Jason@zx2c4.com, bcm-kernel-feedback-list@broadcom.com,
        sbranden@broadcom.com, rjui@broadcom.com,
        florian.fainelli@broadcom.com, herbert@gondor.apana.org.au,
        olivia@selenic.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 23, 2023 at 2:59=E2=80=AFPM Martin Kaiser <lists@kaiser.cx> wro=
te:
>
> Andrei Coardos (aboutphysycs@gmail.com) wrote:
>
> > This function call was found to be unnecessary as there is no equivalen=
t
> > platform_get_drvdata() call to access the private data of the driver. A=
lso,
> > the private data is defined in this driver, so there is no risk of it b=
eing
> > accessed outside of this driver file.
>
> You're right. The platform_get_drvdata call was removed in
> 4c04b3729 ("hwrng: bcm2835 - Use device managed helpers").
>

Reviewed-by: Alexandru Ardelean <alex@shruggie.ro>

> Reviewed-by: Martin Kaiser <martin@kaiser.cx>
