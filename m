Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F26C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 09:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A44E720709
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 09:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FRq3dG1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfKNJpR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:45:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42641 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKNJpR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 04:45:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so5641911wrf.9
        for <linux-crypto@vger.kernel.org>; Thu, 14 Nov 2019 01:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bhvzp5b+Q4a3/0oVBXiXpioibMrQjz/TpooATE3bWZA=;
        b=FRq3dG1d6Uc9go+BHE9dRYlgxm27TAnBxLKzGjuZ3yaZVQcY47huQPCgrKiEA+vQyZ
         gnkCiCD6RsSG+sOD5K7C88cYC7VTN5SNn/gFYioXG1S7mBIoK55zINU57SmF133BB5SB
         T5IIjsBXNZJwZwmzfSDyKgCR9i9MPBxkZ5EHRkof1ydCBQ3WzaY1ZWS26GU218U7RbZe
         V47xLggJ3QJ7sEzKDBFHTsKxVV9yagwoN4oWqADLFcsYLQQT/sVXb2hXdzOkRPvgCLa/
         Fk9rN4bVSNvqxTpqPpXu4A6yfnxnW1/ywsO5+FW/Payabj6CngpZg/41xWpl0hZeAN6a
         QvLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bhvzp5b+Q4a3/0oVBXiXpioibMrQjz/TpooATE3bWZA=;
        b=GUDLj+hSbL/bNnpB50iRqgnSgMEhxZMcZszLlR6jwH7A5zjfWyUXEzXTnVRvYUj9VP
         K+ldJrcceMOSF2PvLVTvgxX/VN2ZwvzLXDmSJa6jocatTI4Vn0F7+1cCtT+EX2ICOgoh
         1JzjRQSDn23vXJgWUDi/ICOEwL2xOR/MyfXarnJc7DOtQhqY/55ocsQCIxjCDhyTVJW9
         ts/ThRzFo11/3BTikCjS/C0+YU1jg6iC3swY/j1sJwvaSateM8UkPSjU1falpW7EBBRf
         QqrYD21FPEoC4RAp3CphALU61cUE0DYNEltYi4KPEnLMw+Vi39EdPPHg9D8jE8R77ABm
         5Pag==
X-Gm-Message-State: APjAAAWir3QICUEmF1H7fthHiCsVjDZz3ALRuulK/UbXLijevAa0j/Ju
        9se9AyAO2KumbxVB1Tf48UYIFW3KnQ6q8nRRVQzckQ==
X-Google-Smtp-Source: APXvYqxyGDZLLSdO7iFFPhCbyuFwYfQ2O45xwAZvkApwZrLzKIl7bERQR2BXJZAlRkzAJg02ZY/qIbP0G6b7FHE6kC0=
X-Received: by 2002:adf:f743:: with SMTP id z3mr6981129wrp.200.1573724714881;
 Thu, 14 Nov 2019 01:45:14 -0800 (PST)
MIME-Version: 1.0
References: <20191112223046.176097-1-samitolvanen@google.com>
 <20191113200419.GE221701@gmail.com> <CABCJKudoBHo6rZoGMFproXjmexu16gonVKDPdnq9XDCmO2J2cw@mail.gmail.com>
In-Reply-To: <CABCJKudoBHo6rZoGMFproXjmexu16gonVKDPdnq9XDCmO2J2cw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 14 Nov 2019 09:45:05 +0000
Message-ID: <CAKv+Gu85PY+A_XxB9DcmcoV8+nAJZGfAc59sj6XnOGyhDedNQA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/sha: fix function types
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Kees Cook <keescook@chromium.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Nov 2019 at 22:28, Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Wed, Nov 13, 2019 at 12:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Nov 12, 2019 at 02:30:46PM -0800, Sami Tolvanen wrote:
> > > Declare assembly functions with the expected function type
> > > instead of casting pointers in C to avoid type mismatch failures
> > > with Control-Flow Integrity (CFI) checking.
> > >
> > > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > > ---
> > >  arch/arm64/crypto/sha1-ce-glue.c   | 12 +++++-------
> > >  arch/arm64/crypto/sha2-ce-glue.c   | 26 +++++++++++---------------
> > >  arch/arm64/crypto/sha256-glue.c    | 30 ++++++++++++------------------
> > >  arch/arm64/crypto/sha512-ce-glue.c | 23 ++++++++++-------------
> > >  arch/arm64/crypto/sha512-glue.c    | 13 +++++--------
> > >  5 files changed, 43 insertions(+), 61 deletions(-)
> > >
> > > diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> > > index bdc1b6d7aff7..3153a9bbb683 100644
> > > --- a/arch/arm64/crypto/sha1-ce-glue.c
> > > +++ b/arch/arm64/crypto/sha1-ce-glue.c
> > > @@ -25,7 +25,7 @@ struct sha1_ce_state {
> > >       u32                     finalize;
> > >  };
> > >
> > > -asmlinkage void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
> > > +asmlinkage void sha1_ce_transform(struct sha1_state *sst, u8 const *src,
> > >                                 int blocks);
> >
> > Please update the comments in the corresponding assembly files too.
> >
> > Also, this change doesn't really make sense because the assembly functions still
> > expect struct sha1_ce_state, and they access sha1_ce_state::finalize which is
> > not present in struct sha1_state.  There should either be wrapper functions that
> > explicitly do the cast from sha1_state to sha1_ce_state, or there should be
> > comments in the assembly files that very clearly explain that although the
> > function prototype takes sha1_state, it's really assumed to be a sha1_ce_state.
>
> Agreed, this needs a comment explaining the type mismatch. I'm also
> fine with using wrapper functions and explicitly casting the
> parameters instead of changing function declarations. Herbert, Ard,
> any preferences?
>

I guess the former would be cleaner, using container_of() rather than
a blind cast to make the code more self-documenting. The extra branch
shouldn't really matter.
