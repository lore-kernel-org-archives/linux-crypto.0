Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EC7C4338F
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 10:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBEA260F42
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 10:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245153AbhHFKgg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 06:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245103AbhHFKgf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 06:36:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3E1C061798;
        Fri,  6 Aug 2021 03:36:18 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l19so16041445pjz.0;
        Fri, 06 Aug 2021 03:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KvDsWq0aD9C7qh0g19FSMx9NiSGhRzrfiTYiXVD5DrQ=;
        b=MXxObmZt4nfxA1erJGVzMqnOkcazWAzBFX5WJDMmNvE3MS6cAmvs0dvfjU3xn03JSx
         cbZp/3kn4sOISQ7g+gS9A+VMecWeUqBFmKASryFE10839CsGxmgBZuC+2jFuBfUSf8zP
         WIN1PaRCRIz7t/UeIUYyocC8bWtXuav/ndV/D0VGIYI5LjrYVYQSltvCWwYI4iOMIHgk
         L7YdQLzqgPpbH3hz+lB7poc8YggmvsjgT2vSp3UBDnC0P1AMfkD+CG8RmRDUvJ9T8dFe
         xeLcnpvTRlgbcPVTvs/neCkXGWi6unA7fro9NlmHImu6uvXrNUAK/TrkZJLB2UlH63Va
         G+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KvDsWq0aD9C7qh0g19FSMx9NiSGhRzrfiTYiXVD5DrQ=;
        b=udb0e8I57VJW7NvFMUCUWknM4Xj8ziSxBzAPXylQuEQdogiX4XUWMAiIxRxMifGj1z
         OLy3RhNFdgtjEgxSTEG3J0DNARj7syGN0e8bB00BdE7rs23dnytOmBoulF4QG4ijwH6F
         hDVa2Bpva4yKG978pYNZYkXEZnN5EobXsAT8BGHYfLNMi7e2C2ghn+HAXWSinlxbA+xX
         jtLWZZuGNHbRxmeKippcAdCMImATe7pVOijxbwf6iD3E9Ck9DE4m1BnELoAUMAuT0odO
         v3/lC646wZK9+QyoyL7KwlgA70JerC8KSpFixpZW2m6MUM4X3aBMv4K8KfQmPgF/COwi
         5i0Q==
X-Gm-Message-State: AOAM530LrvNa8DimMgFHOgjUytu1GHYqOH1sdiI8C1M0eouf+o+fppLP
        6i8ZT+Ud2NUI9HBw0qY04CE=
X-Google-Smtp-Source: ABdhPJxJ2KOgE6CUJCASuhD/shIkShZeJY6pS1EEvW6wJxTZC7itD6HQkcSQ1JzqW6gUAC+aFF3Gcg==
X-Received: by 2002:a17:90a:940e:: with SMTP id r14mr20097966pjo.41.1628246177736;
        Fri, 06 Aug 2021 03:36:17 -0700 (PDT)
Received: from fedora ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.gmail.com with ESMTPSA id g7sm9477138pfv.66.2021.08.06.03.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:36:17 -0700 (PDT)
Date:   Fri, 6 Aug 2021 16:06:11 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: add missing kernel_fpu_end() call
Message-ID: <YQ0Qm+Xs1g/7Eant@fedora>
References: <20210730134155.1005358-1-chouhan.shreyansh630@gmail.com>
 <20210806082320.GA12731@gondor.apana.org.au>
 <CAMj1kXFnCK5xiuGzxkj6rOP43a7OuA7uUP9-eJqsgb54MmuZPQ@mail.gmail.com>
 <CAMj1kXEYymiYaMUobuncmyO-vQxHrOByc7wQn4rKK_wdKuLgXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEYymiYaMUobuncmyO-vQxHrOByc7wQn4rKK_wdKuLgXQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, Aug 06, 2021 at 11:07:43AM +0200, Ard Biesheuvel wrote:
> On Fri, 6 Aug 2021 at 11:05, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Fri, 6 Aug 2021 at 10:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > On Fri, Jul 30, 2021 at 07:11:55PM +0530, Shreyansh Chouhan wrote:
> > > > xts_crypt() code doesn't call kernel_fpu_end() after calling
> > > > kernel_fpu_begin() if walk.nbytes is 0. Add a call to kernel_fpu_end()
> > > > for this case.
> > > >
> > > > Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
> > > > Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
> > > > ---
> > > >  arch/x86/crypto/aesni-intel_glue.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > >
> > > Ard?
> > >
> > > > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > > > index 2144e54a6c89..bd55a0cd7bde 100644
> > > > --- a/arch/x86/crypto/aesni-intel_glue.c
> > > > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > > > @@ -894,6 +894,9 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
> > > >                       kernel_fpu_begin();
> > > >       }
> > > >
> > > > +     if (walk.nbytes == 0)
> > > > +             kernel_fpu_end();
> > > > +
> >
> > Don't we end up calling kernel_fpu_end() twice this way if we do enter
> > the while() loop at least once?
> >

Oh ha, we do. I missed that.

> 
> How about the below instead, does that work?
> 

This should work. I will resend the updated patch.

> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -849,7 +849,7 @@ static int xts_crypt(struct skcipher_request *req,
> bool encrypt)
>                 return -EINVAL;
> 
>         err = skcipher_walk_virt(&walk, req, false);
> -       if (err)
> +       if (err || !walk.nbytes)
>                 return err;
> 
>         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {

Thanks a lot for the review.

Regards,
Shreyansh Chouhan
