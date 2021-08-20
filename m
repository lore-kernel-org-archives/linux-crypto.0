Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930FAC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 11:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FCC961040
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 11:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbhHTLPm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Aug 2021 07:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231852AbhHTLPl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Aug 2021 07:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E00946108B;
        Fri, 20 Aug 2021 11:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629458103;
        bh=JP1kImrQsAE3QCEh5iekGAPOx3Dc6A8nBuPEECbeP8Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L32IgBvSAK0hAtatDRv/3WqmNUlPKO7q2df1NxthhaH9xYqShfPjx8gb5H5OuB5bX
         l4bOi+nXO+s/21kZt0h4mXMm1RGEIx6N6swUTOijgqhvqymwjRi2ZNlS4+IhFq27vv
         VwmHsVivP816sIkbTDOOd/frkuxyiSKYWwtj3eOouq41bON5moe7KC+hZ9yHH6JWrI
         0lZrg0NYtU361vSY0EJL3vOmvSgttITcTRU745H0FsAX1TuWI2/vb0ji8urOtG2/5H
         Sbkz7OEmWUkw8HuROvk9dPvG/MWO6FIjqpjsi9NVf6DlRr/ZNvgZ7zkHd5hZDpvvFR
         Sti0b6/3FUBRw==
Received: by mail-ot1-f44.google.com with SMTP id w22-20020a056830411600b0048bcf4c6bd9so12636525ott.8;
        Fri, 20 Aug 2021 04:15:03 -0700 (PDT)
X-Gm-Message-State: AOAM532RaWhjIn0vip4+xEbTtuQgP0QzLYi89Z3XwovPu+ecRTWL5s4V
        PtZcjUidUhnfnTGNUq9TDWwRfKd4RC2OWg3jgcw=
X-Google-Smtp-Source: ABdhPJz9MNP8ONxnR/5BjUVeuUEBaC91X02XVqqYLF/c8m9sPYLVvZc8gb21FVszX+eOixQUvrz2Zcetrsj1HH5bgQk=
X-Received: by 2002:aca:ea54:: with SMTP id i81mr2575045oih.174.1629458103236;
 Fri, 20 Aug 2021 04:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <YQ0Qm+Xs1g/7Eant@fedora> <20210809141027.860850-1-chouhan.shreyansh630@gmail.com>
 <20210820083111.GA28484@gondor.apana.org.au>
In-Reply-To: <20210820083111.GA28484@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 20 Aug 2021 13:14:52 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGMPimX0_dR_kLuzZjuJK9rM=uCpRDtoJq0UjWq12M10A@mail.gmail.com>
Message-ID: <CAMj1kXGMPimX0_dR_kLuzZjuJK9rM=uCpRDtoJq0UjWq12M10A@mail.gmail.com>
Subject: Re: [PATCH] crypto: xts_crypt() return if walk.nbytes is 0
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Aug 2021 at 10:31, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 09, 2021 at 07:40:27PM +0530, Shreyansh Chouhan wrote:
> > xts_crypt() code doesn't call kernel_fpu_end() after calling
> > kernel_fpu_begin() if walk.nbytes is 0. The correct behavior should be
> > not calling kernel_fpu_begin() if walk.nbytes is 0.
> >
> > Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
> > Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index 388643ca2177..ec6eac57c493 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -849,7 +849,7 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
> >               return -EINVAL;
> >
> >       err = skcipher_walk_virt(&walk, req, false);
> > -     if (err)
> > +     if (err || !walk.nbytes)
> >               return err;
>
> The err check is now redundant because when there is an error
> nbytes is always zero.
>

In spite of that, I have a slight preference for this version, given
that it makes it obvious that we bail on two separate conditions:
- an error has occurred
- no error has occurred but the resulting walk is empty

Testing walk.nbytes only needlessly obfuscates the code, as we need to
return 'err' in the end anyway.
