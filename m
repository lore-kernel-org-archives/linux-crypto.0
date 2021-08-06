Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E671C4338F
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 399E4611C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243869AbhHFJFh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243794AbhHFJFh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 05:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1797611C9;
        Fri,  6 Aug 2021 09:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628240721;
        bh=TNTkDivd9iEayXno0KqWQGcsGWF9R2u7kmQVVbQ599o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IOIlyUjaXAIuXdnTMnPwQo/aRvckN2cFjeGIwEcVA/JnWN635BXz1yFWYglNQMCMw
         ENAcRMHBLzQ98S4YcQHfrrcChDNFN68+q4cx1Qy/Pe49/qq5tx90bTAucGYSB2JSni
         YTdk54Q6ES6FoHBhAqT8F9lDvwLJ6rrZGI9fMmaC6tz1V7uk3TBMRhp1pdSHdPe9Un
         aUyeeMoUGhMWaLS0VuY1J30l9Fj0kKVM+xNLaxXUL7OMTBKZYtqnhYTOJq1s/hGtQp
         RKNks++OVG9nii5IZ0RhnXR4YoDT8P/gPx7HRgJLyLDPFDfmaLDinjrDMqDk8dSmRi
         vgKuh03oMWIyw==
Received: by mail-oo1-f52.google.com with SMTP id z3-20020a4a98430000b029025f4693434bso2060550ooi.3;
        Fri, 06 Aug 2021 02:05:21 -0700 (PDT)
X-Gm-Message-State: AOAM530mDlKZhDKT503b/V+fR1LydP/L/jcAClk6DiJdWdLG1YURb1c6
        uAiDtsgyrqpeyV4Er8GoNsdrzBrzCM4Tnqp+Wrc=
X-Google-Smtp-Source: ABdhPJx5KVGcVwubPN1s9jELV2wY6UX+s5VXewRK26P7IoSSx07z6hMOluoz7TrsWlBZBqLl7JuHLA5ZfZ/G3bchqXE=
X-Received: by 2002:a4a:e750:: with SMTP id n16mr4229495oov.13.1628240721001;
 Fri, 06 Aug 2021 02:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210730134155.1005358-1-chouhan.shreyansh630@gmail.com> <20210806082320.GA12731@gondor.apana.org.au>
In-Reply-To: <20210806082320.GA12731@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 6 Aug 2021 11:05:09 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFnCK5xiuGzxkj6rOP43a7OuA7uUP9-eJqsgb54MmuZPQ@mail.gmail.com>
Message-ID: <CAMj1kXFnCK5xiuGzxkj6rOP43a7OuA7uUP9-eJqsgb54MmuZPQ@mail.gmail.com>
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

On Fri, 6 Aug 2021 at 10:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jul 30, 2021 at 07:11:55PM +0530, Shreyansh Chouhan wrote:
> > xts_crypt() code doesn't call kernel_fpu_end() after calling
> > kernel_fpu_begin() if walk.nbytes is 0. Add a call to kernel_fpu_end()
> > for this case.
> >
> > Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
> > Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 3 +++
> >  1 file changed, 3 insertions(+)
>
> Ard?
>
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index 2144e54a6c89..bd55a0cd7bde 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -894,6 +894,9 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
> >                       kernel_fpu_begin();
> >       }
> >
> > +     if (walk.nbytes == 0)
> > +             kernel_fpu_end();
> > +

Don't we end up calling kernel_fpu_end() twice this way if we do enter
the while() loop at least once?


> >       if (unlikely(tail > 0 && !err)) {
> >               struct scatterlist sg_src[2], sg_dst[2];
> >               struct scatterlist *src, *dst;
> > --
> > 2.31.1
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
