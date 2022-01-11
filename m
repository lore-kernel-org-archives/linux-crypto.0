Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA02C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 18:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242718AbiAKSfD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 13:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242309AbiAKSfD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 13:35:03 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00658C06173F
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 10:35:01 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o6so70828488edc.4
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 10:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CSoSpQ9zOyy/QikBM0vnpS1eqMInKyKYJBrQv7CQEsg=;
        b=VJOpOcg7Qhc9zoPtq7um8XML6ewwO5RhoRbPWA5M4k1Py/nVsMWfJz03sKBt7GzOAS
         2A09An+XCpPsraGsqXnLIkD07WrLQ67IVgUBIMDThwGvjjVoUfD7bOXiFCDodAR5IyPn
         YtsLmfQchbigL4azVHuwCT2UNEcXU7sMmS9LfHYIOXptpzAaVaxQoVlT/dv3RN7Kk85z
         VohKwgmfs1phmHsoBpHrg8wS7K6O3P2dphPHxA0hTHlUT/EA6GVtMcDqdK4l0cDBcDwT
         4G3152vO62WUn3URCQ4VMUN2DGU92R34yz70ig6lb218MFObP5/lA7gLyHGTbXFeb7lb
         CDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSoSpQ9zOyy/QikBM0vnpS1eqMInKyKYJBrQv7CQEsg=;
        b=TWypiOpgyR6ptifr7JcWGVLvWL1JTmwYQgUeAoHi7Qo0ZGXIdPwtY0cNHlN6MFaF7l
         bq3hQOKO4smkGfn2wQxhN0gE2Kiz7b5PmrQazxdXIiAF6YFh3dCsYY7akp1qBPp/zBiG
         ZhXnlx5BvmyNOGIotlVMflnKXAR8VoK9G5rdX6xocfjDvuI9UeDlRPMxBWBg1DM77OGZ
         cqRJtoa+b8rAB/9G4/kNLTNO/W95rxCh4328z3m17LZ4SmIa+6RXl4cSH2Qh6vT+ds5q
         7ktxUtwEw6V4r8CLsd0BYAfqlRtRNjw6IG86ccTNoP0qXhp4z15HhyZAIkFf+k4BW0wv
         /LqA==
X-Gm-Message-State: AOAM533klDDQA720fUksHiAwIOpzX16HfUy7Kq5FN1KaKPoF2g/liuZk
        0lPENIkD45pT+KgGSKvCyLnyv+SQne7P8Km5nDo=
X-Google-Smtp-Source: ABdhPJxI1PZElPkurH1bOvj3GSf1BXYJ8X2nex1vmbHssqhdI4fsWRdxl5ZvTZl00OP56CIACHOr/bBcbcEX6aHNwak=
X-Received: by 2002:a50:da48:: with SMTP id a8mr5440844edk.155.1641926100628;
 Tue, 11 Jan 2022 10:35:00 -0800 (PST)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com> <CAHQ1cqE1YO2A2mL9nDv7mjH=pBvNiOCqQwJYA6VOJpu5kRBUtA@mail.gmail.com>
In-Reply-To: <CAHQ1cqE1YO2A2mL9nDv7mjH=pBvNiOCqQwJYA6VOJpu5kRBUtA@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 11 Jan 2022 15:34:49 -0300
Message-ID: <CAOMZO5DUwg2ppLFMkzCYGA652j1Q6pcTuEnUEyTNGv7_rZLhQA@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Fredrik Yhlen <fredrik.yhlen@endian.se>,
        Heiko Schocher <hs@denx.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrey,

On Tue, Jan 11, 2022 at 3:21 PM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:

> Is this true for every i.MX device? I haven't worked with the

I do see the problem on i.MX6SX.

This thread reports the same problem on i.MX6D:
https://www.spinics.net/lists/linux-crypto/msg52319.html

> i.MX6Q/i.MX8 hardware I was enabling this feature for in a while, so
> I'm not 100% up to date on all of the problems we've seen with those,
> but last time enabling prediction resistance didn't seem to cause any
> issues besides a noticeable slowdown of random data generation.
>
> Can this be a Kconfig option or maybe a runtime flag so that it'd
> still be possible for some i.MX users to keep PR enabled?

The problem is that I don't know when it is safe or not to enable PR.

What about introducing a boolean devicetree property that when
present, disables prediction resistance?
