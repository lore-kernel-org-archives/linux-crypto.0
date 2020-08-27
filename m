Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF1FC433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 16:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09E6322BEB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 16:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgH0QZ7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 12:25:59 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:38897 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgH0QZ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 12:25:58 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M89TB-1kEtDr2pt5-005M6W; Thu, 27 Aug 2020 18:25:56 +0200
Received: by mail-qk1-f180.google.com with SMTP id n129so6405768qkd.6;
        Thu, 27 Aug 2020 09:25:56 -0700 (PDT)
X-Gm-Message-State: AOAM530hfiOv3Nt3JWJ9skH5mYcG5EU0jHuMjJPtbUYNykBXdj3CYXdO
        RR+N4CIoYzd9Ndb0o7q8orD4myxeO+/DD5yj6Uc=
X-Google-Smtp-Source: ABdhPJxUhdTYhY5CBzZ+dnCUwe09YWPFjNGZ49hDy6yxEVFcT4Wq23Bym6d8f1MFQkwXoxzROGFxS/9tnxZFvGwWwhU=
X-Received: by 2002:a37:6351:: with SMTP id x78mr19372765qkb.394.1598545555412;
 Thu, 27 Aug 2020 09:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
 <CAK8P3a3tjv78arTj75eKk5zYUhrGkPYRDLiqv3WJJC=U+Jia0Q@mail.gmail.com>
 <CAMj1kXHhmAdHjK5avXOySw43khzft1g8p48jX7aTeTC0FvS7tQ@mail.gmail.com>
 <CAK8P3a1nOL+BbvGAM3-aiH-mfzmFYgfFL2dWJKd8=Rw-WosP=w@mail.gmail.com>
 <CAMj1kXGpX+g_t4aAz5yGs-c+PG+NLnu1j9_QLJ6teWTjJ1FkMQ@mail.gmail.com> <20200827115104.GA5409@gondor.apana.org.au>
In-Reply-To: <20200827115104.GA5409@gondor.apana.org.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 27 Aug 2020 18:25:39 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3Wo2cj-tHybp_e0zJ2b-88V1oxZzBz-pKtMu-+DovF3w@mail.gmail.com>
Message-ID: <CAK8P3a3Wo2cj-tHybp_e0zJ2b-88V1oxZzBz-pKtMu-+DovF3w@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:fuLDV0wazP+WHq7dP5kt8PSrweN0/iiqPWlZbrVcUhgf0r1IC1E
 lYd4kNjqWI8GqyPnMxCBNbdqSxihOiAuZJV8gjyEtO1dTl+agVefPyyoxf0id6lStrkgj+m
 SCbFVy6767t7QwqvN6ExDQbgbH0KfJbB2MQwxH8KiuXm7Tmn036Q9eZWvsefSHCtNzAeP5W
 3JJtsJjawbmZCZVnnwGRg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:o9cHxfUUjek=:lgAKLYV0WjxcSheIFnBDqk
 TRGksPEAdDIO8B21mS6G5/G+kI0r04YVw0o6ZX/pegZjQVFXb2W0qO/tRncf4NP14yVC8l+i2
 M+Wd6zl7SFgQlPUy/G3Y3skgBisJoJhgtrDoHcZ2Xiv+Pk0iaes+l+ib4KwzWLx1L8NpaXq0x
 hrNJ0vfaG52GuHe8OHORwC2seJM1w3Sn6CryfqdrM1+Te7IwBSAICYe8h1s4dsKCMK0k//UQn
 zF2v4vw3b84zHWZO+dzgwzxAOiRCLdkxkwsIYwnUFO3tTIIu3+mTLtB2I3LaCXmu5ibB/P0B3
 5HY75n3TntmgLxR+3+FJDsynxRHNtyFdb+/iQz48AENP3Fh6E1VzZjphLb52HPafoIKrKUgHL
 IqSCMPmyUdUgobbqyaNr4oZ+72kZ8mqf7aqF7dQiOfw0k20sKW+4G/dtmSesFsiSeJNP5bt4L
 Bd6YhHg1eSFzH3aDd55beq1Jx+3LtGrV73788Ofb2Y3y9RGR4Ja+vj8TzA/iT4HtFmAdlQTqT
 zL1s0/tGDl9bQFPdEVXm89QcUVfy1usvUjxbrB+Fc5U7ABvauUBdkMrqyih7racjmFjbh7WoC
 cG10u5fkRlNhSnPbCJ59+UmIa0gxRCuDlYgZBRBq3++uCr/QUZCjpUFGzdrVuU/QIehUWpcv/
 lKyZVZejnyO/o81Npxd58jDEIxEqfAg2d0U9mCwxHupc+yEVpsiq8QzUIQOLNa36jDWPd27tA
 7+2NS94nsaQrYA9mJ0mrqSAgWFZYNNckLCX9EesrrP8SAHwtTM/5XcAR+MBR5lfwHViEZs13Q
 49ShMY2swfDKY/7kjNlT28SoGalySqZoPKk5DLDE6QTHYChhSvWfIRvntaTZs/WjwWhWDuQ
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 1:51 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 27, 2020 at 12:41:53PM +0200, Ard Biesheuvel wrote:
> >
> > That does not help, unfortunately.
> >
> > What does seem to work is
> >
> > struct chacha_state { u32 x[16]; };
> >
> > struct chacha_state chacha_permute(struct chacha_state st, int nrounds)
>
> Passing 64 bytes by value is not good.
>
> Passing struct chacha_state as a pointer doesn't work either.

Marking the function as __always_inline avoids the problem, as it
lets the compiler see the issue, but seems to produce somewhat
worse object code.

I also tested with clang-11, which supports both -fsanitize-bounds
and -fprofile-arcs but only needs 8 bytes of stack for this function.

One more data point, I looked at the actual object code and found
that neither -fprofile-arcs  nor -fsanitize-bounds has a noticeable
impact on the object code output by themselves (aside of not
leading to the warning as you already mentioned). I would
conclude that there is an actual problem with gcc here.

      Arnd
