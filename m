Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A72CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 19:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25132086D
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 19:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fb4TmKo2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfJUTra (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 15:47:30 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:36299 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbfJUTra (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 15:47:30 -0400
Received: by mail-wm1-f51.google.com with SMTP id c22so4855487wmd.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 12:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ai6jTaEnE/eCESELsnuCoWMD+8zHxzMweDTyfBnXqO4=;
        b=Fb4TmKo2pTJMQc5qlG5zs/i8ed+h9L5+HfHZssVH7Fy/tF0coH5qLKRWqz0f7PK0vh
         eZf1rpNjMDBRAWbVvbM1rUDRCpbjHGtGcmd++k1yfvtsOtwTyOIbH5yBTuRy40K0uYGG
         J7R5G6QHw8+D7FNRNGAltuiDVm4TMsu2VVrtURumFVRD+iM1QhGqLtozE/DFmvFqfu3T
         5U1Vzv1mQ45hMd3832gTl4wQ6i5uABejJ/kVGvChdVMSFlj453a6WAs6+N4JtCP7CcSB
         6FRS0mr5uwkEGMwSpdBlBExqm+v39QF3OA6zfdBELEkLWyf/pTr//elkNspwpOmEmhw7
         S4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ai6jTaEnE/eCESELsnuCoWMD+8zHxzMweDTyfBnXqO4=;
        b=EtHPRorQwkraETOD8PxJBfUkjUnrBgC30KxdFPPSzL/0otBu3RfiXZ7okkevV8dlFe
         fhmQzUunWoQTK4Ojt7txypjxob4gpEwdOv6gJmmq+Vz81W/M8U5Hh6BShHDHzhJ003Gi
         rHdw+2c5LwH2Jw89Q3/+xJ8s8U1hOvlFLTjjU4tANsriW2sFtU85S2TliLBYt91eiF3l
         ieqdCXKxWvgPSluK7h2+hZC5V0uQ7i7dmwlwxe9cQ6434lZ5MHyJxQKY/mYFNTiJ0bjZ
         0wtfTx1d8UinadiRQdXALIc4BmqAPTtBct/fKiwaFgoP0rwuF8LK26r5hvHKEufQN+i+
         Urjg==
X-Gm-Message-State: APjAAAU3Okm0XrUkoDlqRRSmRo5ioZSLhjX/iK/jMdQOED5loY/E0nGc
        fA43iQ46Fo6RP/7zicfvnLgwtgBbBQCpI3Rg4aKLqw==
X-Google-Smtp-Source: APXvYqyVXtG9w6t8TJvQHQTyyBa/4lncCmBxhiRJtufcyXx32X6lcnwKwQMDs9UE5/8Qj1h1uPgHsSlRGhwtPbI+PVQ=
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr21171528wml.10.1571687245150;
 Mon, 21 Oct 2019 12:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8CvoaTCBxWjd9f=CtcK8GkgJkhRgYGjUHy3MqRKhezEg@mail.gmail.com>
 <MN2PR20MB2973E221217FBDA1252804E4CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_GnvoWd2OiY3C6enUMT4Vu5AyBaP8J3C4pVkK7yWeSng@mail.gmail.com>
 <MN2PR20MB2973876A85667AABE157A27ECA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8oyZUL+i23j6r7xYsOeBEUDdZC2w4TKLVtVDfCB1LXYg@mail.gmail.com>
 <MN2PR20MB29735A4F3B31EEBDC179D110CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_yH=VwCSWsQ8Qqw6D1kDNpOH-TFMv9+tVg55rsz7qDRQ@mail.gmail.com> <MN2PR20MB29732715582C9FEB04DD1B2BCA690@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29732715582C9FEB04DD1B2BCA690@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 21:47:19 +0200
Message-ID: <CAKv+Gu_uUGu0vhKTf49kpiUQFSt-p9mrx36wHbdeOFexdJR=mw@mail.gmail.com>
Subject: Re: Key endianness?
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Oct 2019 at 21:14, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Monday, October 21, 2019 6:15 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > Subject: Re: Key endianness?
> >
> > On Mon, 21 Oct 2019 at 17:55, Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > Sent: Monday, October 21, 2019 5:32 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > Subject: Re: Key endianness?
> > > >
> > > > p[
> > > >
> > > > On Mon, 21 Oct 2019 at 17:23, Pascal Van Leeuwen
> > > > <pvanleeuwen@verimatrix.com> wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > > > Sent: Monday, October 21, 2019 2:54 PM
> > > > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > > > Subject: Re: Key endianness?
> > > > > >
> > > > > > On Mon, 21 Oct 2019 at 14:40, Pascal Van Leeuwen
> > > > > > <pvanleeuwen@verimatrix.com> wrote:
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > > > > > Sent: Monday, October 21, 2019 1:59 PM
> > > > > > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > > > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > > > > > Subject: Re: Key endianness?
> > > > > > > >
> > > > > > > > On Mon, 21 Oct 2019 at 12:56, Pascal Van Leeuwen
> > > > > > > > <pvanleeuwen@verimatrix.com> wrote:
> > > > > > > > >
> > > > > > > > > Another endianness question:
> > > > > > > > >
> > > > > > > > > I have some data structure that can be either little or big endian,
> > > > > > > > > depending on the exact use case. Currently, I have it defined as u32.
> > > > > > > > > This causes sparse errors when accessing it using cpu_to_Xe32() and
> > > > > > > > > Xe32_to_cpu().
> > > > > > > > >
> > > > > > > > > Now, for the big endian case, I could use htonl()/ntohl() instead,
> > > > > > > > > but this is inconsistent with all other endian conversions in the
> > > > > > > > > driver ... and there's no little endian alternative I'm aware of.
> > > > > > > > > So I don't really like that approach.
> > > > > > > > >
> > > > > > > > > Alternatively, I could define a union of both a big and little
> > > > > > > > > endian version of the data but that would require touching a lot
> > > > > > > > > of legacy code (unless I use a C11 anonymous union ... not sure
> > > > > > > > > if that would be allowed?) and IMHO is a bit silly.
> > > > > > > > >
> > > > > > > > > Is there some way of telling sparse to _not_ check for "correct"
> > > > > > > > > use of these functions for a certain variable?
> > > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > In this case, just use (__force __Xe32*) to cast it to the correct
> > > > > > > > type. This annotates the cast as being intentionally endian-unclean,
> > > > > > > > and shuts up Sparse.
> > > > > > > >
> > > > > > > Thanks for trying to help out, but that just gives me an
> > > > > > > "error: not an lvalue" from both sparse and GCC.
> > > > > > > But I'm probably doing it wrong somehow ...
> > > > > > >
> > > > > >
> > > > > > It depends on what you are casting. But doing something like
> > > > > >
> > > > > > u32 l = ...
> > > > > > __le32 ll = (__force __le32)l
> > > > > >
> > > > > > should not trigger a sparse warning.
> > > > > >
> > > > > I was actually casting the left side, not the right side,
> > > > > as that's where my sparse issue was. Must be my poor grasp
> > > > > of the C language hurting me here as I don't understand why
> > > > > I'm not allowed to cast an array element to a different type
> > > > > of the _same size_ ...
> > > > >
> > > > > i.e. why can't I do (__be32)some_u32_array[3] = cpu_to_be32(some_value)?
> > > > >
> > > >
> > > > Because you can only change the type of an expression by casting, and
> > > > an lvalue is not an expression. A variable has a type already, and you
> > > > cannot cast that away - what would that mean, exactly? Would all
> > > > occurrences of some_u32_array[] suddenly have a different type? Or
> > > > only element [3]?
> > > >
> > > I think it would be perfectly logical to do such a cast and I'm really
> > > surprised that it is not legal. Obviously, it would only apply to the
> > > actual assignment it is used with. It's a cast, not a redefinition.
> > > After all, a variable or an array item is just some storage area in
> > > memory. Why shouldn't I be able to write to it _as if_ it is some
> > > different type (if I know what I'm doing and especially if it is the
> > > exact same size in memory)?
> > >
> > > >
> > > > > I managed to work around it by doing *(__be32 *)&some_u32_array[3] =
> > > > > but that's pretty ugly ... a better approach is still welcome.
> > > > >
> > > >
> > > > You need to cast the right hand side, not the left hand side. If
> > > > some_u32_array is u32[], force cast it to (__force u32)
> > > >
> > >
> > > Sure, you can do the casting on the right hand side, but that may not
> > > convey what you _really_ want to do, particularly in this case.
> > > As I _really_ want to write a big endian word there. I don't want to
> > > pretend I loose the endianness somewhere along the way. That written
> > > word is still very much big endian.
> > > (I know practically it makes no difference, but casting the left side
> > > would just be so much clearer IMHO)
> > >
> >
> >
> > No, it really isn't, and I am tired of having another endless debate about this.
> >
> I was not intending to start a debate - I was just being a newby C programmer
> being _honestly surprised_ by this limitation. You (or I, anyway) would just expect
> it to work. The rest is personal taste, which is is not debatable (it just is).
>

But it is not a limitation. You are arguing that it is natural and
obvious to cast the expression, but it is not. Really.

(be32)lvalue = <expression of type be32>

would actually mean that the operation applied to the expression is
the opposite, given the lvalue is *not* a be32 to begin with, and so
you expect that lvalue is made to be a be32 for the purpose of the
assignment, after which it is converted back to what it was before? In
this particular case, this comes down to doing the inverse cast on the
expression. But what happens is there is no inverse cast? What would
it mean, for instance, to do

(u16)lvalue = <expression of type s16>

when lvalue is of type s16 itself? Does the sign bit become a data bit
now? Do we have to keep track of this throughout the code?

The bottom line is that the cast operation is only defined for values,
not for variables. A variable's type is fixed - you cannot change it
for the duration of a cast operation and expect the compiler to infer
what this might mean in the general case, even if you think your
endianness conversion example is an obvious case.


> > C permits casting of expressions, not of lvalues.
> > ...
> > > > > >
> > > > > > > > If the
> > > > > > > > hardware chooses to reorder those bytes for some reason, it is the
> > > > > > > > responsibility of the driver to take care of that from the CPU side.
> > > > > > > >
> > > > > > > Which still requires you to know the byte order as used by the API.
> > > > > > >
> > > > > >
> > > > > > Only if API means the AES or ChaCha specific helper routines that we
> > > > > > have in the kernel. If you are using the AES helpers, then yes, you
> > > > > > need to ensure that you use the same convention. But the algorithms
> > > > > > themselves are fully defined by their specification, and so what other
> > > > > > implementations in the kernel do is not really relevant.
> > > > > >
> > > > > What is relevant is what the API expects
> > > >
> > > > But *which* API? The skcipher API uses u8[] for in/output and keys,
> > > > and how these byte arrays are interpreted is not (and cannot) be
> > > > defined at this level of abstraction.
> > > >
> > > Yes, skcipher API. Obviously. As that's what we're talking about.
> > > And _of course_ it has to be defined at that level of abstraction.
> > > (which doesn't preclude inheriting it from some other specification)
> > > Otherwise you would not able to e.g. exchange keys between different
> > > platforms.
> > >
> >
> > So what exactly are you suggesting? That the skcipher API should
> > specify that the key is u8[], unless the algo in question operates on
> > 32-bit words, in which case it is le32[], unless the algo in question
> > operates on 64-bit words, in which case it is le64[] etc etc? Do you
> > seriously think that at the skcipher API level we should mandate all
> > of that? That is insane.
> >
> You think being _clear_ on the actual byte order is _insane_? Seriously?

That is not what I said.

I said that an abstract API that reasons about unspecified algorithms
taking inputs and output of an unspecified nature, using keys of an
unspecified nature should not be expected to define how such
unspecified quantities are organized if they happen to be interpreted
as multi-byte words by some of its implementations.

> Like I said, inheriting that from the algorithm spec is fine but not all
> algorithm specs are clear and unambiguous w.r.t. byte order.
>

That doesn't make it the job of the abstraction that is layered on top
to define it.

> I know this is not crypto perse, but what would be the logical byte order
> for a CRC32 "key" considering it is a 32 bit word? The CRC32 definition
> sure isn't going to help you there, it is specified on 32 bit words only.
> So in such cases it must be clear how the byte stream maps onto the word.
>

Yes, so for the shash implementations of "crc32" and "crc32c", it is
defined by the implementation. But that doesn't mean shash should
specify that this is the case for all algorithms.

> > > >
> > > > > ... and from 20 years of
> > > > > experience I would say many algorithm specifications are not exactly
> > > > > very clear on the byte order at all, often assuming this to be
> > > > > "obvious". (and if it's not little-endian, it's not obvious to me ;-)
> > > > >
> > > >
> > > > I agree that not all specs are crystal clear on this. But it is still
> > > > the algorithm that needs to define this.
> > > >
> > > In an ideal world, probably. In the real world, it is entirely possible
> > > for an implementation to expect the key bytes in a different order.
> > > Would not be the first time I run into that.
> > >
> >
> > Of course. But that is not the point. The skcipher API cannot possibly
> > reason about byte orders of all current and future algorithms that it
> > may ever encapsulate.
> >
> Well, so far I got the impression that at least the intention is
> to follow the cipher specification. That's a start. You could add
> some generic rules on top of that, like "if the specification is
> word based and does not mandate a byte order, than these words
> shall be stored in little-endian byte order". It's not that hard.
> You really don't need to know "future algorithm" details for that.
>

I am not saying it is hard. I am saying it is wrong. The skcipher
API's job is not to fill holes in the algorithm's specification.
