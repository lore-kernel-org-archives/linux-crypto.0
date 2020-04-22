Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9A5C5518A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 07:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29A8E206D6
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 07:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587540228;
	bh=L5TDaMDRemQ8AGr2Dj9skIorBPYELmS/cq8i0YBwSoc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=VOyU06EV6YU8l8gLqq1RXezqadxkLVPcF/3LjoJOIgLYQ46OOa8KSUnfCOZq7J6zr
	 8/vfxihIxZDiNAmc8ddGdij2B5zjhB+ZUqxwB9uyTvhW9GQwzSk99U2gSbpjowzx6t
	 KhFGbNKZ3DYuPMi+eQ7GsVuFWsvfh9rY1EYK5yJA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgDVHXr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 03:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgDVHXr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 03:23:47 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E9F2074F;
        Wed, 22 Apr 2020 07:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587540226;
        bh=L5TDaMDRemQ8AGr2Dj9skIorBPYELmS/cq8i0YBwSoc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cX920elmziksye1yP8zH+7dQlu3XjDVSe42j+8PEqqg6g13BKgam4eSVCckkMp3dR
         2KcNYFCUdYQlGDFXFs8JSSwCH/dLd5f0L3KP4GSJUDl6Fj/ijZGyYVXE+sYwEbSIGs
         pNqN3WeTqEFvvr1H4iMG8eTFJBRY9K1nHqZ2ETc0=
Received: by mail-io1-f50.google.com with SMTP id 19so1261745ioz.10;
        Wed, 22 Apr 2020 00:23:46 -0700 (PDT)
X-Gm-Message-State: AGi0PuY8rrVSZ7rYpR8CTuTPXigifD5o+vG2tIY2DczUYrbNuaji1UVA
        rWCJvOLYeSPLWqC+vmI/C4Z9tekl35NQzHc+IBc=
X-Google-Smtp-Source: APiQypJQGzUV9IySh874c0FFt+wd03o/B+FAE6AcMDzj38JnN+eF1V4zqv4V92DTWWqARAe8SZ+3Ag4MaS0hLFJq8JE=
X-Received: by 2002:a5d:8045:: with SMTP id b5mr16465126ior.16.1587540225306;
 Wed, 22 Apr 2020 00:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <20200422040415.GA2881@sol.localdomain>
In-Reply-To: <20200422040415.GA2881@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 22 Apr 2020 09:23:34 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGRNCEkTFPGM03h1N+HtOiLVMcm89UJYMZcuWjyFAp5Ag@mail.gmail.com>
Message-ID: <CAMj1kXGRNCEkTFPGM03h1N+HtOiLVMcm89UJYMZcuWjyFAp5Ag@mail.gmail.com>
Subject: Re: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
To:     Eric Biggers <ebiggers@kernel.org>, bigeasy@linutronix.de,
        linux-rt-users@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ linux-rt folks)

On Wed, 22 Apr 2020 at 06:04, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Apr 20, 2020 at 01:57:11AM -0600, Jason A. Donenfeld wrote:
> > The initial Zinc patchset, after some mailing list discussion, contained
> > code to ensure that kernel_fpu_enable would not be kept on for more than
> > a PAGE_SIZE chunk, since it disables preemption. The choice of PAGE_SIZE
> > isn't totally scientific, but it's not a bad guess either, and it's
> > what's used in both the x86 poly1305 and blake2s library code already.
> > Unfortunately it appears to have been left out of the final patchset
> > that actually added the glue code. So, this commit adds back the
> > PAGE_SIZE chunking.
> >
> > Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
> > Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
> > Fixes: a44a3430d71b ("crypto: arm/chacha - expose ARM ChaCha routine as library function")
> > Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> > Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> > Cc: Eric Biggers <ebiggers@google.com>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> > Eric, Ard - I'm wondering if this was in fact just an oversight in Ard's
> > patches, or if there was actually some later discussion in which we
> > concluded that the PAGE_SIZE chunking wasn't required, perhaps because
> > of FPU changes. If that's the case, please do let me know, in which case
> > I'll submit a _different_ patch that removes the chunking from x86 poly
> > and blake. I can't find any emails that would indicate that, but I might
> > be mistaken.
> >
> >  arch/arm/crypto/chacha-glue.c        | 16 +++++++++++++---
> >  arch/arm/crypto/poly1305-glue.c      | 17 +++++++++++++----
> >  arch/arm64/crypto/chacha-neon-glue.c | 16 +++++++++++++---
> >  arch/arm64/crypto/poly1305-glue.c    | 17 +++++++++++++----
> >  arch/x86/crypto/chacha_glue.c        | 16 +++++++++++++---
> >  5 files changed, 65 insertions(+), 17 deletions(-)
>
> I don't think you're missing anything.  On x86, kernel_fpu_begin() and
> kernel_fpu_end() did get optimized in v5.2.  But they still disable preemption,
> which is the concern here.
>

My memory is a bit fuzzy here. I remember talking to the linux-rt guys
about what delay is actually acceptable, which was a lot higher than I
had thought based on their initial reports about scheduling blackouts
on arm64 due to preemption remaining disabled for too long. I intended
to revisit this with more accurate bounds but then I apparently
forgot.

So SIMD chacha20 and SIMD poly1305 both run in <5 cycles per bytes,
both on x86 and ARM. If we take 20 microseconds as a ballpark upper
bound for how long preemption may be disabled, that gives us ~4000
bytes of ChaCha20 or Poly1305 on a hypothetical 1 GHz core.

So I think 4 KB is indeed a reasonable quantum of work here. Only
PAGE_SIZE is not necessarily equal to 4 KB on arm64, so we should use
SZ_4K instead.

*However*, at the time, the report was triggered by the fact that we
were keeping SIMD enabled across calls into the scatterwalk API, which
may call kmalloc()/kfree() etc. There is no need for that anymore, now
that the FPU begin/end routines all have been optimized to restore the
userland SIMD state lazily.

So do we have any callers that are likely to pass more than 4 KB of
input at a time? AF_ALG perhaps? Is this code path covered by the
tcrypt tests? Even if we all agree that this chunking is probably
needed, I'd still like us to have an idea of when/how it is likely to
get exercised.


> >
> > diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
> > index 6fdb0ac62b3d..0e29ebac95fd 100644
> > --- a/arch/arm/crypto/chacha-glue.c
> > +++ b/arch/arm/crypto/chacha-glue.c
> > @@ -91,9 +91,19 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
> >               return;
> >       }
> >
> > -     kernel_neon_begin();
> > -     chacha_doneon(state, dst, src, bytes, nrounds);
> > -     kernel_neon_end();
> > +     for (;;) {
> > +             unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
> > +
> > +             kernel_neon_begin();
> > +             chacha_doneon(state, dst, src, todo, nrounds);
> > +             kernel_neon_end();
> > +
> > +             bytes -= todo;
> > +             if (!bytes)
> > +                     break;
> > +             src += todo;
> > +             dst += todo;
> > +     }
> >  }
> >  EXPORT_SYMBOL(chacha_crypt_arch);
>
> Seems this should just be a 'while' loop?
>
>         while (bytes) {
>                 unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
>
>                 kernel_neon_begin();
>                 chacha_doneon(state, dst, src, todo, nrounds);
>                 kernel_neon_end();
>
>                 bytes -= todo;
>                 src += todo;
>                 dst += todo;
>         }
>
> Likewise elsewhere in this patch.  (For Poly1305, len >= POLY1305_BLOCK_SIZE at
> the beginning, so that could use a 'do' loop.)
>
> - Eric
