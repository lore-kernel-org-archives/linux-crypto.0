Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0F7C54FCB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 20:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B452074B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 20:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="g6cvQ0mB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgDVURo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 16:17:44 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:34387 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgDVURn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 16:17:43 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5d86e8b1;
        Wed, 22 Apr 2020 20:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zcAqlsS6cbJG+9ZYLKubSmS1+4E=; b=g6cvQ0
        mBzP+iPykSyvY4aC9vay4EW/eOKh++k2StorKsZG8KSB6v5eFkQlIg2+ebDfyg7i
        KGISl+E9XBYJ0QU4/x8BZ376+rbdgF6Vo33zoCc/5ZyAghtXhswLRm6MmW42iUaC
        i7mNpDBcfVymXJUGUH/NqiJgT/V6y1yi6qqtR2huKeF/7pYsS4wtmC320tZG7kSA
        2a1PzDcQhWSanXwNVMC7Rmb1sym+sjCygvZnGIjEBOAlkY/s+FWdV7c1U2PYB+ci
        KbzyJUL62dRxT45/JPY/Zau6c0jukMD6PYDap/6FCcSXpsO9chNDuOPNlirZaL4f
        IAyim/Uu747aoWLA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 850def34 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Apr 2020 20:06:45 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id 19so3880811ioz.10;
        Wed, 22 Apr 2020 13:17:39 -0700 (PDT)
X-Gm-Message-State: AGi0PuYlG+XLCi2JR3fVxl+cskGrZ2NrfOB8eNUfhVX310Fj6hMqp0DE
        aXQFJNm3hKtHxNTRzW3ZBzv1a8BpAS+lIjKuJwQ=
X-Google-Smtp-Source: APiQypLeAfwZfIEvq8SjW1sawfpEIZjTTCkUn7CnS7yPa/RT9YO6yz9/p22sOOAYPD7ud6+ZqfrnecelDN4vSeaLASo=
X-Received: by 2002:a05:6638:4e:: with SMTP id a14mr171449jap.108.1587586659063;
 Wed, 22 Apr 2020 13:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <20200422040415.GA2881@sol.localdomain>
 <CAHmME9q=hMRjBG=SBX8gCC3qx-t1wdEwMOYx952m9HkByjiofA@mail.gmail.com>
 <CAMj1kXE-UZxw0C3WRVh7RfuWE0BNDT4bt4qJa1SyOH3K-qBBcQ@mail.gmail.com> <CAHmME9qXy4X3GtCtt5_1+KTxTXd6+nfhvE_c8Xn6_iJdRWhQmA@mail.gmail.com>
In-Reply-To: <CAHmME9qXy4X3GtCtt5_1+KTxTXd6+nfhvE_c8Xn6_iJdRWhQmA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 22 Apr 2020 14:17:28 -0600
X-Gmail-Original-Message-ID: <CAHmME9rqG56i+TfOhY-yt52XZrFRRTv0Vwr27qn5yL0=OpQa-A@mail.gmail.com>
Message-ID: <CAHmME9rqG56i+TfOhY-yt52XZrFRRTv0Vwr27qn5yL0=OpQa-A@mail.gmail.com>
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

On Wed, Apr 22, 2020 at 1:51 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Apr 22, 2020 at 1:39 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Wed, 22 Apr 2020 at 09:32, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > On Tue, Apr 21, 2020 at 10:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > Seems this should just be a 'while' loop?
> > > >
> > > >         while (bytes) {
> > > >                 unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
> > > >
> > > >                 kernel_neon_begin();
> > > >                 chacha_doneon(state, dst, src, todo, nrounds);
> > > >                 kernel_neon_end();
> > > >
> > > >                 bytes -= todo;
> > > >                 src += todo;
> > > >                 dst += todo;
> > > >         }
> > >
> > > The for(;;) is how it's done elsewhere in the kernel (that this patch
> > > doesn't touch), because then we can break out of the loop before
> > > having to increment src and dst unnecessarily. Likely a pointless
> > > optimization as probably the compiler can figure out how to avoid
> > > that. But maybe it can't. If you have a strong preference, I can
> > > reactor everything to use `while (bytes)`, but if you don't care,
> > > let's keep this as-is. Opinion?
> > >
> >
> > Since we're bikeshedding, I'd prefer 'do { } while (bytes);' here,
> > given that bytes is guaranteed to be non-zero before we enter the
> > loop. But in any case, I'd prefer avoiding for(;;) or while(1) where
> > we can.
>
> Okay, will do-while it up for v2.

I just sent v2 containing do-while, and I'm fine with that going in
that way. But just in the interest of curiosity in the pan-tone
palette, check this out:

https://godbolt.org/z/VxXien

It looks like on mine, the compiler avoids unnecessarily calling those
adds on the last iteration, but on the other hand, it results in an
otherwise unnecessary unconditional jump for the < 4096 case. Sort of
interesting. Arm64 code is more or less the same difference too.
