Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44821C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 19:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbiAKTFt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 14:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiAKTFs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 14:05:48 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1940EC06173F
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 11:05:48 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t28so34952wrb.4
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 11:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=okJCrF7LiRXE9T1l5tvJzGAbQH9Uqdsl1xMR9gFPJF0=;
        b=IYzJfZ6V1cZyQqqLdogoLADZBQkWt/7ikDWzvy33RC6jT1+5zRa1xQ4ctxOCuwz8om
         LLHEfPDcWjSgZrgkkfx1ysvm2xITNKCYg21QzfEeCt1w1GtaECJOJVIj5jUgKeObuV/F
         AqMiLAB15PlfZys7/6KrTGyeH2nb2h32KitjfyuWi6mAM4Qumqn7u38BISOkzFLjynHJ
         QiNL2aShdKaTB8Yn8zINwyIyJ0JEt86AWcBxgoGAz0SQJRdSlTidaUdHTZ9HTXOyha1D
         qdr+cG/obexgeNkezdWyQBh8dzGNXWC7LnS5JsYQMd/ogKbEWh1oxzNSaCW5XdaXO8WY
         UIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=okJCrF7LiRXE9T1l5tvJzGAbQH9Uqdsl1xMR9gFPJF0=;
        b=mhODLj6PYYEWnKmuH+QUTuTyz43WKN9AM1di5mMyQ09o+CfP0xA700NrDYAA0iuJ0J
         LygC5H0yJ2bfyccTqK3G5S8yieRH4lAP8AJB0zbQTJ1zyDWX8BNOSgVFFjdrKy+6B0xF
         Su4gr9oRwFFnFQzvEqjB8QJaeIEdVDZxCBZZ0caX4ZxlD+/S/05/QQerkqrRvK8TJMvV
         lSM0pd4BbBgkhDWorDkTnDfF9cMRwzAfRRCYOApqz/FuZgcc8lGJ8+5jqgo2DjFC/8IR
         YUd8cuxHaC/jS/CI5A8kmgqHhNUtFiLrjKoN+S3LHUyo8aiYpJeFo9Fv9P+WyEIed43G
         x1Og==
X-Gm-Message-State: AOAM531mM7d7qxS0z9F87t8DLW/4E7KLTNHB4cCfwIFpwdVxp4R3WaRt
        bXIxxJUqupwMyvnXziZkrycstEoRRh3wjmshfas=
X-Google-Smtp-Source: ABdhPJwCtN4NI8tGVGaCe8l2AFbNvJ2O7IzwfNLAMyLXUEqdU2EBXgtNMmiM9/cnpeafehkeG5+0d7dVJ9o5D/tr+yM=
X-Received: by 2002:adf:c74e:: with SMTP id b14mr5032117wrh.97.1641927946621;
 Tue, 11 Jan 2022 11:05:46 -0800 (PST)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com> <CAHQ1cqE1YO2A2mL9nDv7mjH=pBvNiOCqQwJYA6VOJpu5kRBUtA@mail.gmail.com>
 <CAOMZO5DUwg2ppLFMkzCYGA652j1Q6pcTuEnUEyTNGv7_rZLhQA@mail.gmail.com>
In-Reply-To: <CAOMZO5DUwg2ppLFMkzCYGA652j1Q6pcTuEnUEyTNGv7_rZLhQA@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 11 Jan 2022 11:05:36 -0800
Message-ID: <CAHQ1cqF83o0hXo20ES64t1XFt6coPcirezE+nRA_K7Bn7FsP-g@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
To:     Fabio Estevam <festevam@gmail.com>
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

On Tue, Jan 11, 2022 at 10:35 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> Hi Andrey,
>
> On Tue, Jan 11, 2022 at 3:21 PM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
>
> > Is this true for every i.MX device? I haven't worked with the
>
> I do see the problem on i.MX6SX.
>
> This thread reports the same problem on i.MX6D:
> https://www.spinics.net/lists/linux-crypto/msg52319.html
>
> > i.MX6Q/i.MX8 hardware I was enabling this feature for in a while, so
> > I'm not 100% up to date on all of the problems we've seen with those,
> > but last time enabling prediction resistance didn't seem to cause any
> > issues besides a noticeable slowdown of random data generation.
> >
> > Can this be a Kconfig option or maybe a runtime flag so that it'd
> > still be possible for some i.MX users to keep PR enabled?
>
> The problem is that I don't know when it is safe or not to enable PR.
>

Yeah, I hear you. It sounds like long term, we'll need some advice
from HW folks on this. I don't have any FAE contacts anymore, but
maybe you or Horia do have a venue to pursue this?

> What about introducing a boolean devicetree property that when
> present, disables prediction resistance?

That sounds fair.
