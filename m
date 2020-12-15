Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900ABC4361B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 08:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C54622225
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 08:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgLOI4i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 03:56:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgLOI4c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 03:56:32 -0500
X-Gm-Message-State: AOAM530Hac0bMk5sERUXG911rJsypgGAZCYwfwOgxhb409rf/mltBBGr
        2XYm5OPAf2V4bf/zV/dy6oaggidzQSTSEpQ7yiY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608022550;
        bh=D2+MbPEoLQnpTqTu5KG2rzBroID4r2x61dVimhXbLb0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jFMyfiX3u18/YLOaBuiBFFLMfzD33IAnBbqlvJhl2HYlTQER5k7SBbkD/YQBq3dEC
         TLjhW00UI+XDO/dEE6YdFFo5ivWHOzxDqp/oPnIV6NlZBqoeQeYMxaJ+yqXuY4zsms
         m/KugvOiZnaj/kc29nhr7c2EkTcpWtqrUtkUd63tHng+JzEAQwpvazaSVv3V4DPla5
         GqjghIDS7epqQ8bFpq5whBKaqoaVjduhZ3+QDQ57sMzEGBn9ah5oCyTCrOOwaTL42S
         wy0wwXS6f+KHaYhstvv28//Yl/VUjcQ6dbExMbMvseRfY4bySAr+JiHmP36MGP2p+T
         w2PO3/Tca6M7A==
X-Google-Smtp-Source: ABdhPJy5MHyCIOmI2KPR75DMyNS6+dFAQmh9gMndmZn+cCV7InhvJ7MVk/HBp+SPEhx2xnretew1/htnWhWbTCyArAI=
X-Received: by 2002:aca:b809:: with SMTP id i9mr20685479oif.174.1608022548913;
 Tue, 15 Dec 2020 00:55:48 -0800 (PST)
MIME-Version: 1.0
References: <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au> <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au> <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
 <20201210024342.GA26428@gondor.apana.org.au> <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au> <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au> <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
In-Reply-To: <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 15 Dec 2020 09:55:37 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
Message-ID: <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Eric)

TL;DR can we find a way to use synchronous SIMD skciphers/aeads
without cryptd or scalar fallbacks

On Thu, 10 Dec 2020 at 13:19, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 10 Dec 2020 at 13:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Thu, Dec 10, 2020 at 01:03:56PM +0100, Ard Biesheuvel wrote:
> > >
> > > But we should probably start policing this a bit more. For instance, we now have
> > >
> > > drivers/net/macsec.c:
> > >
> > > /* Pick a sync gcm(aes) cipher to ensure order is preserved. */
> > > tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
> > >
> > > (btw the comment is bogus, right?)
> > >
> > > TLS_SW does the same thing in net/tls/tls_device_fallback.c.
> >
> > Short of us volunteering to write code for every user out there
> > I don't see a way out.
> >
> > > Async is obviously needed for h/w accelerators, but could we perhaps
> > > do better for s/w SIMD algorithms? Those are by far the most widely
> > > used ones.
> >
> > If you can come up with a way that avoids the cryptd model without
> > using a fallback obviously that would be the ultimate solution.
> >
>
> Could we disable softirq handling in these regions?

I have been looking into this a bit, and I wonder if we might consider
doing the following:
- forbid synchronous skcipher/aead encrypt/decrypt calls from any
other context than task or softirq (insofar this is not already the
case)
- limit kernel mode SIMD in general to task or softirq context
- reduce the scope for simd begin/end blocks, which is better for
PREEMPT in any case, and no longer results in a performance hit on x86
as it did before, now that we have lazy restore for the userland FPU
state
- disable softirq processing when enabling kernel mode SIMD

This way, we don't need a scalar fallback at all, given that any SIMD
use in softirq context is guaranteed to occur when the SIMD registers
are dead from the task's pov.

So the question is then how granular these kernel mode SIMD regions
need to be to avoid excessive latencies in softirq handling.

I think this could also be an opportunity for a bit more alignment
between architectures on this topic.

-- 
Ard.
