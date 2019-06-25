Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28665C48BD5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 14:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A782208E3
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 14:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfFYOHW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 10:07:22 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33021 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFYOHW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 10:07:22 -0400
Received: by mail-oi1-f195.google.com with SMTP id f80so12616804oib.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2019 07:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xu5K3cSApgyQCIPbxwida3cq6je8e/cZ02vCwRG1d+w=;
        b=AaYwLN6Cq3b/U6BOlHJEYx6rC0hXoubW6uBcoDJrSoxW2wQvtqc+SZlzHQ1pqfEYDV
         GpHI16gh37FxqWIHJblmiE2SkEq/fygryXryRpPPEBD60EB2v3x37tShQ+XSMHynGXmb
         74+0RXoS1/kvBCRUNtj3BSLXIw2hYO3j3N2w1qlAzdwVQc9+72A1X/VQvX6SABByo1QZ
         Ozh6cDTlxO9SryVQLpiO6gWW1WHCsxbwT+zA2I1yVQBuS4nNfmt3gh5Mq2ULGQYdTidy
         aVy1VrQ7i56f7uks+58kmg4fkLep0593POV61iqEyiJKQVeIa0GN/n8qonLkniuIGo1q
         H+DA==
X-Gm-Message-State: APjAAAWIfIggJrEXiQeEFmFCt/0uUkffawi8dkY8Pbfs/bLXCanddcP9
        OkRLelYlUiGbY4r1ZyZd2ySdVUIPUg6xEKkIswKiHg==
X-Google-Smtp-Source: APXvYqyhnHU3+3QLCRUz5Xg9saeFMZSdaOUxzK0ZU1+6c5QvjPo2LeghnD2BWPn5f41xuge8lDam212q25TqBdTMzss=
X-Received: by 2002:aca:a853:: with SMTP id r80mr14442083oie.156.1561471641232;
 Tue, 25 Jun 2019 07:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org> <20190624165641.GB211064@gmail.com>
In-Reply-To: <20190624165641.GB211064@gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 25 Jun 2019 16:07:09 +0200
Message-ID: <CAFqZXNvE2YaanvjQJq41AdcQh8qeY3=idng29GT=8Pt61PU_uw@mail.gmail.com>
Subject: Re: [PATCH 0/6] crypto: aegis128 - add NEON intrinsics version for ARM/arm64
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 24, 2019 at 6:57 PM Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Jun 24, 2019 at 09:38:12AM +0200, Ard Biesheuvel wrote:
> > Now that aegis128 has been announced as one of the winners of the CAESAR
> > competition, it's time to provide some better support for it on arm64 (and
> > 32-bit ARM *)
> >
> > This time, instead of cloning the generic driver twice and rewriting half
> > of it in arm64 and ARM assembly, add hooks for an accelerated SIMD path to
> > the generic driver, and populate it with a C version using NEON intrinsics
> > that can be built for both ARM and arm64. This results in a speedup of ~11x,
> > resulting in a performance of 2.2 cycles per byte on Cortex-A53.
> >
> > Patches #1 .. #3 are some fixes/improvements for the generic code. Patch #4
> > adds the plumbing for using a SIMD accelerated implementation. Patch #5
> > adds the ARM and arm64 code, and patch #6 adds a speed test.
> >
> > Note that aegis128l and aegis256 were not selected, and nor where any of the
> > morus contestants, and so we should probably consider dropping those drivers
> > again.
> >
>
> I'll also note that a few months ago there were attacks published on all
> versions of full MORUS, with only 2^76 data and time complexity
> (https://eprint.iacr.org/2019/172.pdf).  So MORUS is cryptographically broken,
> and isn't really something that people should be using.  Ondrej, are people
> actually using MORUS in the kernel?  I understand that you added it for your
> Master's Thesis with the intent that it would be used with dm-integrity and
> dm-crypt, but it's not clear that people are actually doing that.

AFAIK, the only (potential) users are dm-crypt/dm-integrity and
af_alg. I don't expect many (if any) users using it, but who knows...
I don't have any problem with MORUS being removed from crypto API. It
seems to be broken rather heavily...

>
> In any case we could consider dropping the assembly implementations, though.
>
> - Eric

--
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
