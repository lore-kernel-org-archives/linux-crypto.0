Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70366C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EDFE2077C
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LHFiCjiF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfDLFit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:38:49 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:33149 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfDLFip (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:38:45 -0400
Received: by mail-it1-f195.google.com with SMTP id v8so4057249itf.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 22:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xHEBZHc0l3bFwYTk5fYReti+5FO3ym176CcS7WgDG0U=;
        b=LHFiCjiFfNyVsrihH6WNLeRGo+81LhYX8qh+9xuxZEdr8ykj1kYG4C/o0XWeNKfsgv
         DRGEzr6lPVkVkg5zWDc0aXsK2jpqGe6PpWKNOYKMpZM2CrseqPL247swdESteWd2hSHo
         cNJsfIF5nwptLD2oX6E/kCtH25o9rBVPyeBkb3aqFV4FOVA7ufSpLWO82GSDEV/EfTK4
         PDPF+FdGNQFh/AKt0iTNuLk8v1wrx0L/yfjRp+8d4W/TTGcS2Hg+Mu1w+lahE8WaLseQ
         zJPPEfG6JyEDjjLV9qONfzpDxJp6GHicJ28d2qi3fseOaxEO8bVwUMUzeKBRBup/iW/u
         1+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xHEBZHc0l3bFwYTk5fYReti+5FO3ym176CcS7WgDG0U=;
        b=mdI4ZLjktftBZVGHg9xI932QR7u5POg3UQkkGToMFXPbmkPj2dGwZxe14PKu8ev246
         SOV1kxwgFgPd9NJHiuvC7xEYUThVM3W4ew6JecD3HRpr8HdT1KuOuOC9PgQDSISwi+CL
         lE6b3UDedMpf3R4Nun6+X23gzqIVXcVGabzWIcI/rT6lEARK6zEl6bL173+beWoYJxv5
         SHsi+ELcYBSZw6FgMwD2FamOxnZMhxHrOL/cj003GKLIxvjpoFmnCgAil0HzQvqx8qIk
         bou+Fo4QTMF1eB7j+rW3aPbEIug64nUL6xGsHdtsB/H2TK8xOyU1qpQYrtzF1M6CXtBx
         oW9g==
X-Gm-Message-State: APjAAAX84l0jR4i/XdDQq9CCpZXbfpAG2e/EJM6Cw2/VgriEClDDLpD2
        J4K13AQ9mLnzzMm2oQZyoSLGWEr+Fzn3VR2iWF4ASg==
X-Google-Smtp-Source: APXvYqwUZtVFQvFpYQpaGAL7Cy3lPOR1C4iDSXGEIVhBDyVA7Oeg/wpcgg8wzmLRQRRJ8kLdwiEsTeEeTev3uTew3DY=
X-Received: by 2002:a02:6553:: with SMTP id u80mr38602190jab.51.1555047523884;
 Thu, 11 Apr 2019 22:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190411192607.GD225654@gmail.com> <20190411192827.72551-1-ebiggers@kernel.org>
 <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
In-Reply-To: <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 12 Apr 2019 07:38:32 +0200
Message-ID: <CACT4Y+a2rVobq+40tH+TgvmVfMOZvFT1y0ZJSRtsZu00EmeVzg@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - allocate buffers with __GFP_COMP
To:     Kees Cook <keescook@chromium.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 10:32 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Apr 11, 2019 at 12:31 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > This is needed so that CONFIG_HARDENED_USERCOPY_PAGESPAN=y doesn't
> > incorrectly report a buffer overflow when the destination of
> > copy_from_iter() spans the page boundary in the 2-page buffer.
> >
> > Fixes: 3f47a03df6e8 ("crypto: testmgr - add testvec_config struct and helper functions")
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> > ---
> >  crypto/testmgr.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 0f6bfb6ce6a46..3522c0bed2492 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -156,7 +156,8 @@ static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
> >         int i;
> >
> >         for (i = 0; i < XBUFSIZE; i++) {
> > -               buf[i] = (char *)__get_free_pages(GFP_KERNEL, order);
> > +               buf[i] = (char *)__get_free_pages(GFP_KERNEL | __GFP_COMP,
> > +                                                 order);
>
> Is there a reason __GFP_COMP isn't automatically included in all page
> allocations? (Or rather, it seems like the exception is when things
> should NOT be considered part of the same allocation, so something
> like __GFP_SINGLE should exist?.)

It would be reasonable if __get_free_pages would automatically mark
consecutive pages as consecutive.
When these should not be considered part of the same allocation? Is it
possible to free them separately? Will that BUG with __GFP_COMP mark?
I understand that there can be a weak "these are actually the same
allocation, but I would like to think about them as separate". But
potentially we can ignore such cases.

> -Kees
>
> >                 if (!buf[i])
> >                         goto err_free_buf;
> >         }
> > --
> > 2.21.0.392.gf8f6787159e-goog
> >
>
>
> --
> Kees Cook
