Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5D0C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Nov 2022 15:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiKLPAM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Nov 2022 10:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiKLPAL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Nov 2022 10:00:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8789D85
        for <linux-crypto@vger.kernel.org>; Sat, 12 Nov 2022 07:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5815AB80937
        for <linux-crypto@vger.kernel.org>; Sat, 12 Nov 2022 15:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3E9C433D7
        for <linux-crypto@vger.kernel.org>; Sat, 12 Nov 2022 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668265206;
        bh=NWz/jQZUJJPvDahD/g7+rxLhPhTnTwb/EaNjaU+YyI4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=imQeOftfBGcVWEu6WLs8cLPjS+eA3hwALlldy8Nt2t5gAQh2hTp9lt5MaxqTEaCvs
         37yjDMLA37pTJrSQfedYTtgWr73m5Ne3rioS4MzCZjJ0EXP0Zi8e9Vapp9BVaUI8A+
         0UfA9OJOocMmr5b3yzzMB9vrwjBCMgPp0GXvvy8Si5RehsqfkWOfJ9qyUWRWmc5mbd
         QYZrqOT6L7a5Cr2PWEN+F3RNuW6euaII72PlVhxejqUHFwuriaeedKnmklygWYWFwF
         8Podct5iLZ3cWjsmS1p2H561mXjuhrVOBdRbcbfbmDjA7p0yFQ4Mmt+46IvwUtF2va
         /nvOs0F1oX2Qw==
Received: by mail-lf1-f46.google.com with SMTP id f37so12449970lfv.8
        for <linux-crypto@vger.kernel.org>; Sat, 12 Nov 2022 07:00:06 -0800 (PST)
X-Gm-Message-State: ANoB5pnJcXD7cBxQBFz5w76PGKIoQmJppTIpZR1wjNRBcognDivREjDs
        NOcTYlwxfOwVZEbnZu8VessJMVwBXVr21GDTOBU=
X-Google-Smtp-Source: AA0mqf7GYWpe8W04J5VIQs4NMAYiJpSpDPNLoIoD4l511sk7+Z+zDAD7B7SLUQBNh9nYWRhZevjF4WkGypJQngLKW6s=
X-Received: by 2002:a05:6512:138f:b0:4ab:534b:1b2c with SMTP id
 p15-20020a056512138f00b004ab534b1b2cmr2016483lfa.426.1668265204749; Sat, 12
 Nov 2022 07:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20201210024342.GA26428@gondor.apana.org.au> <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au> <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au> <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au> <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
 <Y2sj84u/w/nOgKwx@gondor.apana.org.au> <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
 <6e20b593-393c-9fa1-76aa-b78951b1f2f3@candelatech.com>
In-Reply-To: <6e20b593-393c-9fa1-76aa-b78951b1f2f3@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 12 Nov 2022 15:59:53 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEqcPvb-uLvGLhue=6eME-6WhuPgoG+HgLH0EoZLE9aZA@mail.gmail.com>
Message-ID: <CAMj1kXEqcPvb-uLvGLhue=6eME-6WhuPgoG+HgLH0EoZLE9aZA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ben Greear <greearb@candelatech.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 11 Nov 2022 at 23:29, Ben Greear <greearb@candelatech.com> wrote:
>
> On 11/9/22 2:05 AM, Ard Biesheuvel wrote:
> > On Wed, 9 Nov 2022 at 04:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >>
> >> On Tue, Nov 08, 2022 at 10:50:48AM -0800, Ben Greear wrote:
> >>>
> >>> While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
> >>> and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
> >>> supported upstream now?  Or is it specific to whatever xctr is?  If so,
> >>> any chance the patch is wanted upstream now?
> >>
> >> AFAICS the xctr patch has nothing to do with what you were trying
> >> to achieve with wireless.  My objection still stands with regards
> >> to wireless, we should patch wireless to use the async crypto
> >> interface and not hack around it in the Crypto API.
> >>
> >
> > Indeed. Those are just add/add conflicts because both patches
> > introduce new code into the same set of files. The resolution is
> > generally to keep both sides.
> >
> > As for Herbert's objection: I will note here that in the meantime,
> > arm64 now has gotten rid of the scalar fallbacks entirely in AEAD and
> > skipcher implementations, because those are only callable in task or
> > softirq context, and the arm64 SIMD wrappers now disable softirq
> > processing. This means that the condition that results in the fallback
> > being needed can no longer occur, making the SIMD helper dead code on
> > arm64.
> >
> > I suppose we might do the same thing on x86, but since the kernel mode
> > SIMD handling is highly arch specific, you'd really need to raise this
> > with the x86 maintainers.
> >
>
> Hello Ard,
>
> Could you please review the attached patch to make sure I merged it properly?  My concern
> is the cleanup section and/or some problems I might have introduced related to the similarly
> named code that was added upstream.
>

I don't think the logic is quite right, although it rarely matter.

I've pushed my version here - it invokes the static call for CTR so it
will use the faster AVX version if the CPU supports it.

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=aesni-ccm-v6.1
