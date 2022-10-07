Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FC2C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Oct 2022 21:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJGVzI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJGVzE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Oct 2022 17:55:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13F23F318
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 14:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C130C61DF6
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 21:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3065CC433D7
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 21:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665179702;
        bh=wQrjTImctRkR7wPbuDz6RXmupPHNOQ/LD+KDKr2vXrA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CE3lYiZnJEAIaaUshHuItl2AKCicjBucX9s1WzPQsfc+6XFreYXUrlNn3Ox+y2PeE
         WQJMrS5D4eJvNJ1kE9KjiJopPd6Aw6dvd5S2y1h3F1SSE/9xqdUd1gF5Z6YIllIQ2D
         c2EVevB7QOcCyWVX54VlK41pJLQfklNYoNEjTSFIoA9c0zpRnTkX0E7sSp/EQfT34k
         IzCIDNf6nBI2KC1O7VWDtqkTACJl51EDelOer9+vsFWj6vEUJa+RIfLy9HHiAYzaV0
         uUDBPjDIdve6Ees4Nk9k9IUBAkm3mOX6Jp1NYULiFCkuXCAdCRGYsqtWbbS8z2TlxC
         IUUeRozMGvYXg==
Received: by mail-lj1-f175.google.com with SMTP id f9so7146458ljk.12
        for <linux-crypto@vger.kernel.org>; Fri, 07 Oct 2022 14:55:02 -0700 (PDT)
X-Gm-Message-State: ACrzQf2ldMKXV5fHPkeIQyL0IXedjhcLawzxxywJeFerXeBtMuDENx/O
        +LP4XmlKA1CUDa0KLwt41KrnjM7RhmG5dAE0sPI=
X-Google-Smtp-Source: AMsMyM6xT/H8rawGUKT7mLAXaqs2iu3MRqmIlWMenmCEU5j7SxcJkDh5rpqUnop+0oXOurj8HRs36tLX7hpLzZWnTbw=
X-Received: by 2002:a2e:b621:0:b0:26e:535f:a90f with SMTP id
 s1-20020a2eb621000000b0026e535fa90fmr1480221ljn.69.1665179700248; Fri, 07 Oct
 2022 14:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221004044912.24770-1-ap420073@gmail.com> <Yzu8Kd2botr3eegj@gondor.apana.org.au>
 <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com> <MW5PR84MB18420D6E1A31D9C765EF6ED4AB5A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW5PR84MB18420D6E1A31D9C765EF6ED4AB5A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 7 Oct 2022 23:54:49 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGmKunh-OCvGFf8T6KJJXSHRYzacjSojBD3__u0o-3D1w@mail.gmail.com>
Message-ID: <CAMj1kXGmKunh-OCvGFf8T6KJJXSHRYzacjSojBD3__u0o-3D1w@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86: Do not acquire fpu context for too long
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 4 Oct 2022 at 17:17, Elliott, Robert (Servers) <elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Taehee Yoo <ap420073@gmail.com>
> > Sent: Tuesday, October 4, 2022 1:02 AM
> > To: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: linux-crypto@vger.kernel.org; davem@davemloft.net; tglx@linutronix.de;
> > mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com; x86@kernel.org;
> > hpa@zytor.com; ardb@kernel.org; ebiggers@google.com
> > Subject: Re: [PATCH] crypto: x86: Do not acquire fpu context for too long
> >
> > Hi Herbert,
> > Thanks a lot for your review!
> >
> > On 10/4/22 13:52, Herbert Xu wrote:
> >  > On Tue, Oct 04, 2022 at 04:49:12AM +0000, Taehee Yoo wrote:
> >  >>
> >  >>   #define ECB_WALK_START(req, bsize, fpu_blocks) do {                     \
> >  >>           void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));   \
> >  >> + unsigned int walked_bytes = 0;                                  \
> >  >>           const int __bsize = (bsize);                                    \
> >  >>           struct skcipher_walk walk;                                      \
> >  >> - int err = skcipher_walk_virt(&walk, (req), false);              \
> >  >> + int err;                                                        \
> >  >> +                                                                 \
> >  >> + err = skcipher_walk_virt(&walk, (req), false);                  \
> >  >>           while (walk.nbytes > 0) {                                       \
> >  >> -         unsigned int nbytes = walk.nbytes;                      \
> >  >> -         bool do_fpu = (fpu_blocks) != -1 &&                     \
> >  >> -                       nbytes >= (fpu_blocks) * __bsize;         \
> >  >>                   const u8 *src = walk.src.virt.addr;                     \
> >  >> -         u8 *dst = walk.dst.virt.addr;                           \
> >  >>                   u8 __maybe_unused buf[(bsize)];                         \
> >  >> -         if (do_fpu) kernel_fpu_begin()
> >  >> +         u8 *dst = walk.dst.virt.addr;                           \
> >  >> +         unsigned int nbytes;                                    \
> >  >> +         bool do_fpu;                                            \
> >  >> +                                                                 \
> >  >> +         if (walk.nbytes - walked_bytes > ECB_CBC_WALK_MAX) {    \
> >  >> +                 nbytes = ECB_CBC_WALK_MAX;                      \
> >  >> +                 walked_bytes += ECB_CBC_WALK_MAX;               \
> >  >> +         } else {                                                \
> >  >> +                 nbytes = walk.nbytes - walked_bytes;            \
> >  >> +                 walked_bytes = walk.nbytes;                     \
> >  >> +         }                                                       \
> >  >> +                                                                 \
> >  >> +         do_fpu = (fpu_blocks) != -1 &&                          \
> >  >> +                  nbytes >= (fpu_blocks) * __bsize;              \
> >  >> +         if (do_fpu)                                             \
> >  >> +                 kernel_fpu_begin()
> >  >>
> >  >>   #define CBC_WALK_START(req, bsize, fpu_blocks)                          \
> >  >>           ECB_WALK_START(req, bsize, fpu_blocks)
> >  >> @@ -65,8 +81,12 @@
> >  >>   } while (0)
> >  >>
> >  >>   #define ECB_WALK_END()                                                  \
> >  >> -         if (do_fpu) kernel_fpu_end();                           \
> >  >> +         if (do_fpu)                                             \
> >  >> +                 kernel_fpu_end();                               \
> >  >> +         if (walked_bytes < walk.nbytes)                         \
> >  >> +                 continue;                                       \
> >  >>                   err = skcipher_walk_done(&walk, nbytes);                \
> >  >> +         walked_bytes = 0;                                       \
> >  >>           }                                                               \
> >  >>           return err;                                                     \
> >  >>   } while (0)
> >  >
> >  > skcipher_walk_* is supposed to return at most a page.  Why is this
> >  > necessary?
> >  >
> >  > Cheers,
> >
> > I referred to below link.
> > https://lore.kernel.org/all/MW5PR84MB18426EBBA3303770A8BC0BDFAB759@MW5PR84MB18
> > 42.NAMPRD84.PROD.OUTLOOK.COM/
> >
> > Sorry for that I didn't check that skcipher_walk_* returns only under 4K
> > sizes.
> > So, I thought fpu context would be too long.
> > But, I just checked the skcipher_walk_*, and it's right, it returns
> > under 4K sizes.
> > So, there are no problems as you mentioned.
> >
> > Thank you so much!
> > Taehee Yoo
>
> I think functions using the ECB and CBC macros (and
> those helper functions) are safe  - notice the third
> argument is called fpu_blocks. So, Aria's ECB mode is
> probably safe. There are no CTR macros, so that needs
> to be checked more carefully.
>
> We need to check all the functions that don't use the
> macros and functions. The SHA functions (I've started
> working on a patch for those).
>
> Running modprobe tcrypt mode=0, I encountered RCU stalls
> on these:
>         tcrypt: testing encryption speed of sync skcipher cts(cbc(aes)) using cts(cbc(aes-aesni))
>         tcrypt: testing encryption speed of sync skcipher cfb(aes) using cfb(aes-aesni)
>
> aesni-intel_glue.c registers "__cts(cbs(aes))", not "cts(cbc(aes-aesni)",
> and doesn't register any cfb algorithms, so those tests are using the
> generic templates, which must not be breaking up the loops as needed.
>

These all use the aes-aesni cipher wrapped in various layers of
generic code. The core cipher puts kernel_fpu_begin/end around every
AES block {16 bytes) it processes, so I doubt that the crypto code is
at fault here, unless the issues is in tcrypt itself.
