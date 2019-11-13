Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13ACC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 22:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6B12206EE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 22:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dZb5uR28"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfKMW2d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 17:28:33 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:46282 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMW2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 17:28:33 -0500
Received: by mail-vs1-f65.google.com with SMTP id m6so2475067vsn.13
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 14:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=df+DaKSym2F9N38LbwQBau3uyVIjwZlwEI4gpy1fPE4=;
        b=dZb5uR28WtYmsIGQUl7x9pIgxS9KCCtdlUs9VoItFY5+c1+CApd8HbmkRUyerPpjHO
         gv+ogesx6Ikklix2lZMfqiwnJqGFYKybH2NcArccBFnXRMyJtTBobVjX2j3X3AvJhFlN
         9AcGprpxGi6mMOsBsVvcl0XYhdP5V2Ruf+wPdwgRvEtHXksnGjqVuioxHg6oX0MAgyGS
         O6e9uN/vo4c/x2u7XiDMhCWfzS4QslstYQYB4fu76AkptLbmn2qqu57heYwEhbMgtPH9
         MQaDP5Jy6GFzLHQIK1QKUN8YLZvx/m59XTd6leHo14UcJ4n880Yi2KQwPbPEAmJFIJfs
         +i5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=df+DaKSym2F9N38LbwQBau3uyVIjwZlwEI4gpy1fPE4=;
        b=n3sG3Rg5MTV2eP5LKXpYHGqqM0MWHnFBfiZmYsGQM8rRiiFeXmYBMDfmo0/bbOEcLy
         iqvtxpajeYxaEBUDhXFzxx9fuC1uaR4JVn1Sc78cgBDwkf1dSvyL97cq/wVkMQdHLoNn
         7QQTtl+rv/B89AqozBX2DKlm45KBDHOvy7jbRRN7rRt9O9D0A91ihRo63Q1MF4I0OxRj
         WB8HCxrybkqpE6AlSZu7zJrPsGFAMff6Os41aaQDEFCnBh78dlCHg9k9ROy8Hm4WbloO
         JBFvUPC9DEmN2Fh0fmUyFU0AlomKapsTBIuQ86NrzKXjUIrXcOLynXSjrjlozKgNCkbx
         HETg==
X-Gm-Message-State: APjAAAUwmMEF7UubtMNI2gUCuLtrrO+ZRvWTDeKH106qrjnXyvcFi3XW
        2rGs6xDro0sYKhun+/ZMYwtEzhiasczlivKufwZalQ==
X-Google-Smtp-Source: APXvYqxfpgw1bAj534p0frCXIEt+l0yG7RkVd1Sj5Hvf+PUYmwQzQTLAWLYEMRDZVRNouwEoi67rVA5OIosex2sZLnI=
X-Received: by 2002:a67:c58e:: with SMTP id h14mr3590395vsk.104.1573684112019;
 Wed, 13 Nov 2019 14:28:32 -0800 (PST)
MIME-Version: 1.0
References: <20191112223046.176097-1-samitolvanen@google.com> <20191113200419.GE221701@gmail.com>
In-Reply-To: <20191113200419.GE221701@gmail.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Wed, 13 Nov 2019 14:28:20 -0800
Message-ID: <CABCJKudoBHo6rZoGMFproXjmexu16gonVKDPdnq9XDCmO2J2cw@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/sha: fix function types
To:     Sami Tolvanen <samitolvanen@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 13, 2019 at 12:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Nov 12, 2019 at 02:30:46PM -0800, Sami Tolvanen wrote:
> > Declare assembly functions with the expected function type
> > instead of casting pointers in C to avoid type mismatch failures
> > with Control-Flow Integrity (CFI) checking.
> >
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  arch/arm64/crypto/sha1-ce-glue.c   | 12 +++++-------
> >  arch/arm64/crypto/sha2-ce-glue.c   | 26 +++++++++++---------------
> >  arch/arm64/crypto/sha256-glue.c    | 30 ++++++++++++------------------
> >  arch/arm64/crypto/sha512-ce-glue.c | 23 ++++++++++-------------
> >  arch/arm64/crypto/sha512-glue.c    | 13 +++++--------
> >  5 files changed, 43 insertions(+), 61 deletions(-)
> >
> > diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> > index bdc1b6d7aff7..3153a9bbb683 100644
> > --- a/arch/arm64/crypto/sha1-ce-glue.c
> > +++ b/arch/arm64/crypto/sha1-ce-glue.c
> > @@ -25,7 +25,7 @@ struct sha1_ce_state {
> >       u32                     finalize;
> >  };
> >
> > -asmlinkage void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
> > +asmlinkage void sha1_ce_transform(struct sha1_state *sst, u8 const *src,
> >                                 int blocks);
>
> Please update the comments in the corresponding assembly files too.
>
> Also, this change doesn't really make sense because the assembly functions still
> expect struct sha1_ce_state, and they access sha1_ce_state::finalize which is
> not present in struct sha1_state.  There should either be wrapper functions that
> explicitly do the cast from sha1_state to sha1_ce_state, or there should be
> comments in the assembly files that very clearly explain that although the
> function prototype takes sha1_state, it's really assumed to be a sha1_ce_state.

Agreed, this needs a comment explaining the type mismatch. I'm also
fine with using wrapper functions and explicitly casting the
parameters instead of changing function declarations. Herbert, Ard,
any preferences?

Sami
