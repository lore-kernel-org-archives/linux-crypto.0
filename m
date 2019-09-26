Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCCEC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 11:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704CA21D56
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 11:06:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YfBiKE5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfIZLGm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 07:06:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44742 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfIZLGm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 07:06:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id i18so1930901wru.11
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 04:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ISJbF27/cAPQNQgvnxPHBb1Qbw9yedrgRB0n8CYKTQ=;
        b=YfBiKE5lgqG/fhh+elwsgSqfDLerQmrfCrp44QJhXtZXye6PYh0+U96J4zqywHsIm5
         q9Xlik42QP/mA4i6HOuwM7P1FQR6x1+4HgZBHTX4412Npbxw/NzWjR7n0mfS9J5LWSXt
         f2X5gIp8jzdtCilvRPg5LGnY9SZ7fnDTAZw/mQ0oDc2xYoncFnJ3QTdEfTyZSr3zIS1v
         3b3apU+JygchS9NFVrv35f18/tmm7aKJskiVa5+4aZ+9Z/jYf7ohkruBVqTRhQjAkXSP
         o4s58+L2sTotPMRN68/2OHefYACwtfnrwJSz1b3uYiLHmAT77z9+rkstFZn1iYwThLmk
         STzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ISJbF27/cAPQNQgvnxPHBb1Qbw9yedrgRB0n8CYKTQ=;
        b=AtXfqckMiVNdDbmispKWwqrM5MIXL3xBflPyS9yR1JAvPMtcScsLSqNahaet5uo4zA
         RJI8WqtgtRhYFA1kj56IHlTVOb+7ZiLHKXNwmJDhn2rq/CojGyc2CWq0kCRrexU+wZm1
         40WEXTZ313NrIvBBVLdUoQC2y2d4/J8vGWLeHoW737UyOsoTuXa6O3cl5ICjOzl6Yg3h
         0dK/lh0FygOQpmYb1BB/4ZAmi8PyqXOeBC6cuTMif5xD3bgXkcATH+2uIk/FrL1Wc/51
         v+ywAyFhXxCe+YP8jAnmuFEMSgnT2RVjYgdUc1rHxrFICy1HNLYiL1mVTtIrH+eFCdSo
         zTbA==
X-Gm-Message-State: APjAAAVFcBtNNDSPvxLa4/43ZGyNkDIm34ZniVjhJDzc96P4h1jZ0KJZ
        JEbNnCBt287MGsKhn0okbS9diQJEzRuf9TfALYgo0Q==
X-Google-Smtp-Source: APXvYqz5P3xf4nCM4KKdqFs6qq4XwFOlsVErajRM4cxNmOP12Dj2xCWnWHB0mDvKB+LQvTn0daFZusGkSTCUhx9ufcM=
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr2046855wru.246.1569495997678;
 Thu, 26 Sep 2019 04:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
In-Reply-To: <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 26 Sep 2019 13:06:26 +0200
Message-ID: <CAKv+Gu_YOqvqJ4YC=ixBh-v4fiFTFNpEagHiTRU7Oq4PrhJPkw@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 26 Sep 2019 at 00:15, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Sep 25, 2019 at 9:14 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > Replace the chacha20poly1305() library calls with invocations of the
> > RFC7539 AEAD, as implemented by the generic chacha20poly1305 template.
>
> Honestly, the other patches look fine to me from what I've seen (with
> the small note I had in a separate email for 11/18), but this one I
> consider just nasty, and a prime example of why people hate those
> crypto lookup routines.
>
> Some of it is just the fundamental and pointless silly indirection,
> that just makes things harder to read, less efficient, and less
> straightforward.
>
> That's exemplified by this part of the patch:
>
> >  struct noise_symmetric_key {
> > -       u8 key[NOISE_SYMMETRIC_KEY_LEN];
> > +       struct crypto_aead *tfm;
>
> which is just one of those "we know what we want and we just want to
> use it directly" things, and then the crypto indirection comes along
> and makes that simple inline allocation of a small constant size
> (afaik it is CHACHA20POLY1305_KEY_SIZE, which is 32) be another
> allocation entirely.
>
> And it's some random odd non-typed thing too, so then you have that
> silly and stupid dynamic allocation using a name lookup:
>
>    crypto_alloc_aead("rfc7539(chacha20,poly1305)", 0, CRYPTO_ALG_ASYNC);
>
> to create what used to be (and should be) a simple allocation that was
> has a static type and was just part of the code.
>

That crypto_alloc_aead() call does a lot of things under the hood:
- use an existing instantiation of rfc7539(chacha20,poly1305) if available,
- look for modules that implement the whole transformation directly,
- if none are found, instantiate the rfc7539 template, which will
essentially do the above for chacha20 and poly1305, potentially using
per-arch accelerated implementations if available (for either), or
otherwise, fall back to the generic versions.

What *I* see as the issue here is not that we need to do this at all,
but that we have to do it for each value of the key. IMO, it would be
much better to instantiate this thing only once, and have a way of
passing a per-request key into it, permitting us to hide the whole
thing behind the existing library interface.


> It also ends up doing other bad things, ie that packet-time
>
> +       if (unlikely(crypto_aead_reqsize(key->tfm) > 0)) {
> +               req = aead_request_alloc(key->tfm, GFP_ATOMIC);
> +               if (!req)
> +                       return false;
>
> thing that hopefully _is_ unlikely, but that's just more potential
> breakage from that whole async crypto interface.
>
> This is what people do *not* want to do, and why people often don't
> like the crypto interfaces.
>
> It's exactly why we then have those "bare" routines as a library where
> people just want to access the low-level hashing or whatever directly.
>
> So please don't do things like this for an initial import.
>

This is tied to the zero reqsize patch earlier in the series. If your
crypto_alloc_aead() call gets fulfilled by the template we modified
earlier (and which is the only synchronous implementation we currently
have), this is guaranteed to be unlikely/false. For async
implementations, however, we need this allocation to be on the heap
since the stack will go away before the call completes.

> Leave the thing alone, and just use the direct and synchronous static
> crypto library interface tjhat you imported in patch 14/18 (but see
> below about the incomplete import).
>

Patch #14 only imports the C library version, not any of the
accelerated versions that Jason proposed. So we will need a way to
hook all the existing accelerated drivers into that library interface,
add handling for SIMD etc.

> Now, later on, if you can *show* that some async implementation really
> really helps, and you have numbers for it, and you can convince people
> that the above kind of indirection is _worth_ it, then that's a second
> phase. But don't make code uglier without those actual numbers.
>
> Because it's not just uglier and has that silly extra indirection and
> potential allocation problems, this part just looks very fragile
> indeed:
>
> > The nonce related changes are there to address the mismatch between the
> > 96-bit nonce (aka IV) that the rfc7539() template expects, and the 64-bit
> > nonce that WireGuard uses.
> ...
> >  struct packet_cb {
> > -       u64 nonce;
> > -       struct noise_keypair *keypair;
> >         atomic_t state;
> > +       __le32 ivpad;                   /* pad 64-bit nonce to 96 bits */
> > +       __le64 nonce;
> > +       struct noise_keypair *keypair;
> >         u32 mtu;
> >         u8 ds;
> >  };
>
> The above is subtle and silently depends on the struct layout.
>
> It really really shouldn't.
>
> Can it be acceptable doing something like that? Yeah, but you really
> should be making it very explicit, perhaps using
>
>   struct {
>         __le32 ivpad;
>         __le64 nonce;
>    } __packed;
>
> or something like that.
>

This is what I started out with, put the packed struct causes GCC on
architectures that care about alignment to switch to the unaligned
accessors, which I tried to avoid. I'll add a build_bug to ensure that
offset(ivpad) + 4 == offset(nonce).

> Because right now you're depending on particular layout of those fields:
>
> > +       aead_request_set_crypt(req, sg, sg, skb->len,
> > +                              (u8 *)&PACKET_CB(skb)->ivpad);
>
> but honestly, that's not ok at all.
>
> Somebody makes a slight change to that struct, and it might continue
> to work fine on x86-32 (where 64-bit values are only 32-bit aligned)
> but subtly break on other architectures.
>
> Also, you changed how the nonce works from being in CPU byte order to
> be explicitly LE. That may be ok, and looks like it might be a
> cleanup, but honestly I think it should have been done as a separate
> patch.
>

Fair enough.

> So could you please update that patch 14/18 to also have that
> synchronous chacha20poly1305_decrypt_sg() interface, and then just
> drop this 18/18 for now?
>

Hmm, not really, because then performance is going to suck. The way we
organise the code in the crypto API today is to have generic C
libraries in lib/crypto, and use the full API for per-arch accelerated
code (or async accelerators). Patch #14 uses the former.

We'll need a way to refactor the existing accelerated code so it is
exposed via the library interface, and there are a couple of options:
- modify our AEAD code so it can take per-request keys - that way, we
could instantiate a single TFM in the implementation of the library,
and keep the chacha20poly1305_[en|de]crypt_sg() interfaces intact,
- create arch/*/lib versions of all the accelerated ChaCha20 and
Poly1305 routines we have, so that the ordinary library precedence
rules give you the fastest implementation available - we may need some
tweaks to the module loader for weak symbols etc to make this
seamless, but it should be doable
- add an entirely new accelerated crypto library stack on the side (aka Zinc)


> That would mean that
>
>  (a) you wouldn't need this patch, and you can then do that as a
> separate second phase once you have numbers and it can stand on its
> own.
>
>  (b) you'd actually have something that *builds* when  you import the
> main wireguard patch in 15/18
>
> because right now it looks like you're not only forcing this async
> interface with the unnecessary indirection, you're also basically
> having a tree that doesn't even build or work for a couple of commits.
>

True, but this was intentional, and not intended for merge as-is.

> And I'm still not convinced (a) ever makes sense - the overhead of any
> accelerator is just high enought that I doubt you'll have numbers -
> performance _or_ power.
>
> But even if you're right that it might be a power advantage on some
> platform, that wouldn't make it an advantage on other platforms. Maybe
> it could be done as a config option where you can opt in to the async
> interface when that makes sense - but not force the indirection and
> extra allocations when it doesn't.

I know the code isn't pretty, but it looks worse than it is. I'll look
into using the new static calls framework to instantiate the library
interface based on whatever the platform provides as synchronous
implementations of ChaCha20 and Poly1305.

> As a separate patch, something like
> that doesn't sound horrendous (and I think that's also an argument for
> doing that CPU->LE change as an independent change).
>
> Yes, yes, there's also that 17/18 that switches over to a different
> header file location and Kconfig names but that could easily be folded
> into 15/18 and then it would all be bisectable.
>
> Alternatively, maybe 15/18 could be done with wireguard disabled in
> the Kconfig (just to make the patch identical), and then 17/18 enables
> it when it compiles with a big note about how you wanted to keep 15/18
> pristine to make the changes obvious.
>
> Hmm?
>
> I don't really have a dog in this fight, but on the whole I really
> liked the series. But this 18/18 raised my heckles, and I think I
> understand why it might raise the heckles of the wireguard people.
>

We're likely to spend some time discussing all this before I get
around to respinning this (if ever). But I am also a fan of WireGuard,
and I am eager to finish this discussion once and for all.
