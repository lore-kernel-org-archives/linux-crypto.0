Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D51AC54FCB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 19:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4292077D
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 19:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DzWXWEmo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgDVTv0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 15:51:26 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:47849 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgDVTv0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 15:51:26 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a798252e;
        Wed, 22 Apr 2020 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=tmNupWC70NVGm/tMVbvc7BFrrNg=; b=DzWXWE
        moKbxT7kjSO08amgUpAFwUCd+I29Xq42tkce5oHehqFmvv3OtG2iDqwhD87Hk/fy
        lnaR4ogzAX3vs8vsPtenLuJdGKq7vaguTB7NXIg6gggvKdY+Q0MmrcM/4KIljv4G
        QqkNjF1rfv6FWHSnNZsb2MDURDcn2Y3rXKvp0nJP4iArJRraxYr1PgMBRXeHScGM
        dyxOklSEfb5gxX2sm0QJUkEwd/aSne6kWssDx8FnGi6fRfYvNGByiJsPJ/YPMG1e
        KxeiSkCbEcoCcIKTcW5gqSpoDT7Zf5rCquYmaHLh2XcFkRrisYobUXYFdun6hxSt
        AoNlTA9VHZs9Y/Mw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b459a4ef (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Apr 2020 19:40:29 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id p10so3795070ioh.7;
        Wed, 22 Apr 2020 12:51:23 -0700 (PDT)
X-Gm-Message-State: AGi0PuYpmIw2uRbFSOnabvdtT0EbLa2IY4ZoHfcWM9b5iS/lfBPh232r
        VYq1WAczqSraJ8ihIgcF53pJ2dxLi+rYeAa7Bwo=
X-Google-Smtp-Source: APiQypImt546bSQQ9x+3fZW3TT9sKxrBbjdfsqVNomDRWCA2qh+bZcPg1WFkSiBFVwqB2Qw9f0su2PuNMWeO9QHtOW4=
X-Received: by 2002:a05:6602:21d3:: with SMTP id c19mr391548ioc.29.1587585082737;
 Wed, 22 Apr 2020 12:51:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <20200422040415.GA2881@sol.localdomain>
 <CAHmME9q=hMRjBG=SBX8gCC3qx-t1wdEwMOYx952m9HkByjiofA@mail.gmail.com> <CAMj1kXE-UZxw0C3WRVh7RfuWE0BNDT4bt4qJa1SyOH3K-qBBcQ@mail.gmail.com>
In-Reply-To: <CAMj1kXE-UZxw0C3WRVh7RfuWE0BNDT4bt4qJa1SyOH3K-qBBcQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 22 Apr 2020 13:51:11 -0600
X-Gmail-Original-Message-ID: <CAHmME9qXy4X3GtCtt5_1+KTxTXd6+nfhvE_c8Xn6_iJdRWhQmA@mail.gmail.com>
Message-ID: <CAHmME9qXy4X3GtCtt5_1+KTxTXd6+nfhvE_c8Xn6_iJdRWhQmA@mail.gmail.com>
Subject: Re: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 22, 2020 at 1:39 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 22 Apr 2020 at 09:32, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Tue, Apr 21, 2020 at 10:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > Seems this should just be a 'while' loop?
> > >
> > >         while (bytes) {
> > >                 unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
> > >
> > >                 kernel_neon_begin();
> > >                 chacha_doneon(state, dst, src, todo, nrounds);
> > >                 kernel_neon_end();
> > >
> > >                 bytes -= todo;
> > >                 src += todo;
> > >                 dst += todo;
> > >         }
> >
> > The for(;;) is how it's done elsewhere in the kernel (that this patch
> > doesn't touch), because then we can break out of the loop before
> > having to increment src and dst unnecessarily. Likely a pointless
> > optimization as probably the compiler can figure out how to avoid
> > that. But maybe it can't. If you have a strong preference, I can
> > reactor everything to use `while (bytes)`, but if you don't care,
> > let's keep this as-is. Opinion?
> >
>
> Since we're bikeshedding, I'd prefer 'do { } while (bytes);' here,
> given that bytes is guaranteed to be non-zero before we enter the
> loop. But in any case, I'd prefer avoiding for(;;) or while(1) where
> we can.

Okay, will do-while it up for v2.
