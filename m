Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA0FC0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 04:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CBC02071C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 04:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qm57GoxA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgCPEPD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 00:15:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35209 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgCPEPD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 00:15:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id m3so16443269wmi.0;
        Sun, 15 Mar 2020 21:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3iz7M4n4vFnZlY3xJtiBBVd2QMi0cxZMNzGQK0mvGgU=;
        b=Qm57GoxAvObsxjUCwFXGwb6fTVZevkffefjkygHM2wKdzEH5TdTIZ8CQPsfvDrOquL
         iTKdu5SRtb2qvQA0lSlBxOYWaWUFraJgn9mFTtU8xD9g8xoRuwy4N1LTrZIq7jXtKlht
         ThvpvhmabSheJK+5t9TzVfncKDUVMRwzoVPfrbnkJ6XqcOgxGO6sVuqET3SiZoIAp1vr
         6Zpjb/wuigPojbksg3WJ9/WlfYS9UJvelcwNZwAmEJwwFqQv1HWxgvGtXKP2z4uUOCXM
         qRiATOTGjwUqv9ieffMy0CKjISNE5zpxMhMIyJF6+BJWNFW4WAVA/XOniBqKYCxOXmiX
         gTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3iz7M4n4vFnZlY3xJtiBBVd2QMi0cxZMNzGQK0mvGgU=;
        b=ETJLrtn8R1eKIar5Dva4RIuXFXdVQkL9AfGfVE4/rnoNH518dCaCv7pjwmAdo83a7J
         swSwpROZ0ZjC6KHZlq3FuGDp514vfsspettxwYW8nNdF68zy5Z4gxqL7FjOeTiZ9AANU
         BnUIz6f7lqgScrHyFpHleN1X6eaOBWSZ6kjO1ua7Dno1mcl1p2p8m6Ak69j9ifkgL730
         jIDhfYka5MjmjFR1VHaRwY0yPbwKcwAzE7aAI8k4R0WaqmCxuiYBBCtDVwA9m9O1sIdI
         7K1wgj7UwBAyI0FvMdaLoesPAZ+NNXXi5UK50NSnFkDBlh5jfXDI4GFhOLhHzDj6BYzg
         7jKw==
X-Gm-Message-State: ANhLgQ2mGJSe7gOf8Weou24TkE/DvoPaiivRhHzzHRFJLG4sI2RC/rvn
        RGVHEJkJt5Qg6V/q0C6xgGhUQ/chxc9auaaJrfE=
X-Google-Smtp-Source: ADFU+vsb6tTIy7aNbe5hox5lzXtNlAswN/TLEr3PvFO5UJXfiLG/mBbEiYczD4nl8OHxwPiIZadH1b768KaOJjOYKKo=
X-Received: by 2002:a1c:3585:: with SMTP id c127mr25298561wma.124.1584332101597;
 Sun, 15 Mar 2020 21:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-2-andrew.smirnov@gmail.com> <VI1PR0402MB3485FF5402B8C0FFF48FBF2298030@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485FF5402B8C0FFF48FBF2298030@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Sun, 15 Mar 2020 21:14:49 -0700
Message-ID: <CAHQ1cqGZP5RKTsc4+jikyPVggt-mGViRtKNvyOx9FGkYW9pgmg@mail.gmail.com>
Subject: Re: [PATCH v7 1/9] crypto: caam - allocate RNG instantiation
 descriptor with GFP_DMA
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 4, 2020 at 6:08 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/27/2020 6:57 PM, Andrey Smirnov wrote:
> > Be consistent with the rest of the codebase and use GFP_DMA when
> > allocating memory for a CAAM JR descriptor.
> >
> Please use GFP_DMA32 instead.
> Device is not limited to less than 32 bits of addressing
> in any of its incarnations.
>
> s/GFP_DMA/GFP_DMA32 should be performed throughout caam driver.
> (But of course, I wouldn't include this change in current patch series).
>

Hmm, I am triggering
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/slub.c?h=v5.6-rc6#n1721
by using GFP_DMA32. AFAICT, GFP_DMA32 can't be used in SLUB/SLAB
allocated memory:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/internal.h?h=v5.6-rc6#n32

I'll stick with GFP_DMA for now, unless you have a different preference.

Thanks,
Andrey Smirnov
