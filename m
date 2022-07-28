Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E60C04A68
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jul 2022 11:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbiG1LBg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jul 2022 07:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiG1LBg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jul 2022 07:01:36 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F232563939
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jul 2022 04:01:34 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-f2a4c51c45so1882179fac.9
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jul 2022 04:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sx8dXhWzRCLHTFr/Lnj/hvOO96cuB5U55JfjkIOpYeQ=;
        b=oegR4psTFcBqQwjzpSNPFOVTR/HjGklFpCIN9hbD5WFNX9l4SbfVr9LRKyCw1eNPnZ
         qeFnIwfRpPoV/WmIrGOm3Am1RiuNi5Pk7c0Qjvx0wzqfGHeRWSZJetBVoZVRdqGwLY2q
         QfwoEeT7R8e3bI0EgkGA2Vm17otx+S3OE8Kl2iS0hztOGpdQlTRBdDpus+bloLnMkt7q
         9a9GuNT4b+uGaaC86Xt5RGcQbK/K51Xejo2/GJP3j/cXaq5DBeo4QrOaAbWpeeOmcOUX
         jy34S5aEFhRBm3YrdbkRrtJmjARItIUHzpC0k3p7+o7gdAhgHO4PYz6HtbfAd2UVCImr
         5J6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sx8dXhWzRCLHTFr/Lnj/hvOO96cuB5U55JfjkIOpYeQ=;
        b=RiQgNmduR9O2SlNNbZj0NSt3hMncuPYkEJJEc1SobkEUw8ePhdgCJVfx57VYmRPH7D
         IUPHkwmzVWUXIswCgWvxLaBoZX1SLttvl7vxvwFOaC9+uxzepzBx8pgJfHIwkEDpNtEC
         VhgcRNJ23aVSgz2tcTnSssMeem8BLDwiPYueJgags3fcJIypp7BeNkHMuMCrG9uGbnAM
         JSYrAFwJiPJyAwsHjCcYfk6hqXeugtdQAIGWzoEU2iJIak9zuaaJv1oCllxUtYV/dkNz
         ghFBjM9Xl31jb7RfZi5zJLV+3I/Tqi1F2pRxrf8IOBIPcTM+PPJNK76MQtT0m702cYN8
         mvMQ==
X-Gm-Message-State: AJIora8Z7CMXMcxVmcTvaACfmNt01Vf2O1o4kW1adXp36gm0cGQLWsxt
        gnPHCsePN1ey6ltFOgaHAroRbOcZqwKQBsZsqZFvpA==
X-Google-Smtp-Source: AGRyM1vmW/Ay79hmx64TnCoDIsCNfdS2lHYKc0EOlDU1Rdgz/oYP2E3BIVF+8zhIXocGFIR4Yu001IJyKOLh1s8wtco=
X-Received: by 2002:a05:6870:1686:b0:10d:9cbf:aa6f with SMTP id
 j6-20020a056870168600b0010d9cbfaa6fmr4241116oae.93.1659006092860; Thu, 28 Jul
 2022 04:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220726190830.1189339-1-Jason@zx2c4.com> <20220726195822.1223048-1-Jason@zx2c4.com>
 <YuJlCijOtAXOco6h@arm.com> <YuJmtY6agbe2pBSW@arm.com>
In-Reply-To: <YuJmtY6agbe2pBSW@arm.com>
From:   Adhemerval Zanella <adhemerval.zanella@linaro.org>
Date:   Thu, 28 Jul 2022 08:01:22 -0300
Message-ID: <CAMXh4bW2gPP3nBaBUH-Rr2KTizuTPXD6wPYAdux=XU=iKRUaVg@mail.gmail.com>
Subject: Re: [PATCH v6] arc4random: simplify design for better safety
To:     Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Weimer <fweimer@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, libc-alpha@sourceware.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 28, 2022 at 7:37 AM Szabolcs Nagy via Libc-alpha
<libc-alpha@sourceware.org> wrote:
>
> The 07/28/2022 11:29, Szabolcs Nagy via Libc-alpha wrote:
> > The 07/26/2022 21:58, Jason A. Donenfeld via Libc-alpha wrote:
> ...
> >
> > fyi, after this patch i see
> >
> > FAIL: stdlib/tst-arc4random-thread
> >
> > with
> >
> > $ cat stdlib/tst-arc4random-thread.out
> > info: arc4random: minimum of 1750000 blob results expected
> > info: arc4random: 1750777 blob results observed
> > info: arc4random_buf: minimum of 1750000 blob results expected
> > info: arc4random_buf: 1750000 blob results observed
> > info: arc4random_uniform: minimum of 1750000 blob results expected
> > Timed out: killed the child process
> > Termination time: 2022-07-27T14:41:33.766791947
> > Last write to standard output: 2022-07-27T14:41:22.522497854
> >
> > on an arm and aarch64 builder.
> >
> > running it manually it takes >30s to complete.
>
> note that before the patch it was <5s on the same machine.

Yeap, we need to tune down the internal test parameters [1].

[1] https://patchwork.sourceware.org/project/glibc/patch/20220727131031.2016648-1-adhemerval.zanella@linaro.org/
