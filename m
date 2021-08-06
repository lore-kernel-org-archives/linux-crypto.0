Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18926C4338F
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E18D2611C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243992AbhHFJIL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231559AbhHFJIK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 05:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 326C8610FC;
        Fri,  6 Aug 2021 09:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628240875;
        bh=ejOJ4yOTdt++hSuEVFyBcqe0mDTZq1Op+aa5WSDlpMw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U7D7iPPKheAiktcC1WYe7ihJc7BGV/Z+IGFIg2T/Cl0Hz0Q0Qn+mHYhncf4MBPzLZ
         vwriHDiBes5zJ35P/jf6DhXz1Ec8YL+zFQYl/aXrlWicARmsHprwZAyjQtTzPVwkWU
         sDIxEE9RzG7WFc2rWSLRW5vZdaoMu38opbMytZs6fjR5sp2D6Nmih+0pQUQrZQmlhs
         C20kJyYLwexuGxLgmKoawSszfqsIMLmQVZKEWAzuz6LgVAJxI+rCLBrYZYBU+zj9oJ
         32GZPAWzgB1+sC8zpQJF+dpxqxtS3qIxNyRPOM3+hgM/wAjwuEtfRKfUFEgDh5xFld
         vAuUxi4gm3k7g==
Received: by mail-ot1-f44.google.com with SMTP id v24-20020a0568300918b02904f3d10c9742so4843419ott.4;
        Fri, 06 Aug 2021 02:07:55 -0700 (PDT)
X-Gm-Message-State: AOAM533aOe3H0oISSzLs0aBIo4t2GTx1f73I0RbmlH2bj2/CKmvP61y1
        niGDD2/UfSSMGN2RwuLIaCePOxLyI3CyY+Gr2ng=
X-Google-Smtp-Source: ABdhPJxiBXdPCPi0oYqZp3db0lOhP7eLSnW28s3ECdNbOKwYfQul0lJbuhizLqR5EcBaTo6rl/qeV25kX171MPaExBs=
X-Received: by 2002:a9d:5c2:: with SMTP id 60mr6671258otd.77.1628240874580;
 Fri, 06 Aug 2021 02:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210730134155.1005358-1-chouhan.shreyansh630@gmail.com>
 <20210806082320.GA12731@gondor.apana.org.au> <CAMj1kXFnCK5xiuGzxkj6rOP43a7OuA7uUP9-eJqsgb54MmuZPQ@mail.gmail.com>
In-Reply-To: <CAMj1kXFnCK5xiuGzxkj6rOP43a7OuA7uUP9-eJqsgb54MmuZPQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 6 Aug 2021 11:07:43 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEYymiYaMUobuncmyO-vQxHrOByc7wQn4rKK_wdKuLgXQ@mail.gmail.com>
Message-ID: <CAMj1kXEYymiYaMUobuncmyO-vQxHrOByc7wQn4rKK_wdKuLgXQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: add missing kernel_fpu_end() call
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

On Fri, 6 Aug 2021 at 11:05, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 6 Aug 2021 at 10:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Fri, Jul 30, 2021 at 07:11:55PM +0530, Shreyansh Chouhan wrote:
> > > xts_crypt() code doesn't call kernel_fpu_end() after calling
> > > kernel_fpu_begin() if walk.nbytes is 0. Add a call to kernel_fpu_end()
> > > for this case.
> > >
> > > Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
> > > Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
> > > ---
> > >  arch/x86/crypto/aesni-intel_glue.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> >
> > Ard?
> >
> > > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > > index 2144e54a6c89..bd55a0cd7bde 100644
> > > --- a/arch/x86/crypto/aesni-intel_glue.c
> > > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > > @@ -894,6 +894,9 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
> > >                       kernel_fpu_begin();
> > >       }
> > >
> > > +     if (walk.nbytes == 0)
> > > +             kernel_fpu_end();
> > > +
>
> Don't we end up calling kernel_fpu_end() twice this way if we do enter
> the while() loop at least once?
>

How about the below instead, does that work?

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,7 +849,7 @@ static int xts_crypt(struct skcipher_request *req,
bool encrypt)
                return -EINVAL;

        err = skcipher_walk_virt(&walk, req, false);
-       if (err)
+       if (err || !walk.nbytes)
                return err;

        if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
