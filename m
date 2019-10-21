Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489E1CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 16:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0990121906
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 16:14:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nvGHEccy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfJUQOy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:14:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38420 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJUQOx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 12:14:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so13415372wmi.3
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 09:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aLijmoFtWrlwzjdRPcGBJYBpKEzzSKb+WfKp6Nlphco=;
        b=nvGHEccyPKhVDa3BmPZ4oQs5v0mEqV7IEnO3KhFmUMoAl7eHOv10hQU9mcN9IiFEHT
         dmCded44/XucWfgG0/M93WZ++aboGezsyW209OqdUplunwRhsyve2lQcEESRBJytTYBY
         o5gSfImwzBnT2vfoZyFEo0cg71ZTbO8tcxm1vmyhypGoiFzmvIpaFvlzO5qA9dtJBH5Q
         fNoGcp80tKZTnlUxN2Jc7isXl4YZBB6NL7FcM/W6LyBgQkK5lFexFtV1+ku+Hpcs3V18
         UoLZGdByuOsyG4zoKVwbTSYZmgnA2GM495wc1gld16A3WX1Cv/+tnTTnfkf9d4hiPsHZ
         odXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aLijmoFtWrlwzjdRPcGBJYBpKEzzSKb+WfKp6Nlphco=;
        b=aF30ND3y1ZDof7e/qX+4XonNYBifcxNXq548Jma7f6S9J+U8oHk/YGW/PS6LLyrDQj
         TYO6sQhKNBtugd91UGPU2UoPoQSh+sDoi9/mevJU1717HdDNF/vwpUzqrkVfySNmYOMT
         hqyJbsvI9lFE9HQcuw3tao+xmFn3ZiPU5U1zheE1WevZmzYyXNBc+oVF8RodLTUBVrvS
         xO/ii9ID0JfXMl25qbDeFXwj7z9/9p4UJRHJcxaZCD4a1mnVIA5TgTnpkaSqNlP4j1Z1
         T1XxBfXyM3BAaEvD0y4dqnKH2jsrdBodtPE3qPFQmbYHKFp18OzMF7r2WomUx9XflHDZ
         PZVg==
X-Gm-Message-State: APjAAAWKb8i3YLO+vBXbSaE2jCb8SX9g7qlx7/D2qqvNYL2y+okIQ2ro
        DdMDK6jRi1Lvo7jOMbRMzDyno19sYli/ETF09cVeiNxg698=
X-Google-Smtp-Source: APXvYqxDm0t/GKxevM/veLyah2G24/WYxx1dzp2ZHCyDlj2v3Jew7W6h2oaLfakeXl0ibCSbjbiicbOsq5xK63RWxZ8=
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr7203476wme.53.1571674490439;
 Mon, 21 Oct 2019 09:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8CvoaTCBxWjd9f=CtcK8GkgJkhRgYGjUHy3MqRKhezEg@mail.gmail.com>
 <MN2PR20MB2973E221217FBDA1252804E4CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_GnvoWd2OiY3C6enUMT4Vu5AyBaP8J3C4pVkK7yWeSng@mail.gmail.com>
 <MN2PR20MB2973876A85667AABE157A27ECA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8oyZUL+i23j6r7xYsOeBEUDdZC2w4TKLVtVDfCB1LXYg@mail.gmail.com> <MN2PR20MB29735A4F3B31EEBDC179D110CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29735A4F3B31EEBDC179D110CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 18:14:38 +0200
Message-ID: <CAKv+Gu_yH=VwCSWsQ8Qqw6D1kDNpOH-TFMv9+tVg55rsz7qDRQ@mail.gmail.com>
Subject: Re: Key endianness?
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Oct 2019 at 17:55, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Monday, October 21, 2019 5:32 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > Subject: Re: Key endianness?
> >
> > p[
> >
> > On Mon, 21 Oct 2019 at 17:23, Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > Sent: Monday, October 21, 2019 2:54 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > Subject: Re: Key endianness?
> > > >
> > > > On Mon, 21 Oct 2019 at 14:40, Pascal Van Leeuwen
> > > > <pvanleeuwen@verimatrix.com> wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > > > Sent: Monday, October 21, 2019 1:59 PM
> > > > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > > > Subject: Re: Key endianness?
> > > > > >
> > > > > > On Mon, 21 Oct 2019 at 12:56, Pascal Van Leeuwen
> > > > > > <pvanleeuwen@verimatrix.com> wrote:
> > > > > > >
> > > > > > > Another endianness question:
> > > > > > >
> > > > > > > I have some data structure that can be either little or big endian,
> > > > > > > depending on the exact use case. Currently, I have it defined as u32.
> > > > > > > This causes sparse errors when accessing it using cpu_to_Xe32() and
> > > > > > > Xe32_to_cpu().
> > > > > > >
> > > > > > > Now, for the big endian case, I could use htonl()/ntohl() instead,
> > > > > > > but this is inconsistent with all other endian conversions in the
> > > > > > > driver ... and there's no little endian alternative I'm aware of.
> > > > > > > So I don't really like that approach.
> > > > > > >
> > > > > > > Alternatively, I could define a union of both a big and little
> > > > > > > endian version of the data but that would require touching a lot
> > > > > > > of legacy code (unless I use a C11 anonymous union ... not sure
> > > > > > > if that would be allowed?) and IMHO is a bit silly.
> > > > > > >
> > > > > > > Is there some way of telling sparse to _not_ check for "correct"
> > > > > > > use of these functions for a certain variable?
> > > > > > >
> > > > > >
> > > > > >
> > > > > > In this case, just use (__force __Xe32*) to cast it to the correct
> > > > > > type. This annotates the cast as being intentionally endian-unclean,
> > > > > > and shuts up Sparse.
> > > > > >
> > > > > Thanks for trying to help out, but that just gives me an
> > > > > "error: not an lvalue" from both sparse and GCC.
> > > > > But I'm probably doing it wrong somehow ...
> > > > >
> > > >
> > > > It depends on what you are casting. But doing something like
> > > >
> > > > u32 l = ...
> > > > __le32 ll = (__force __le32)l
> > > >
> > > > should not trigger a sparse warning.
> > > >
> > > I was actually casting the left side, not the right side,
> > > as that's where my sparse issue was. Must be my poor grasp
> > > of the C language hurting me here as I don't understand why
> > > I'm not allowed to cast an array element to a different type
> > > of the _same size_ ...
> > >
> > > i.e. why can't I do (__be32)some_u32_array[3] = cpu_to_be32(some_value)?
> > >
> >
> > Because you can only change the type of an expression by casting, and
> > an lvalue is not an expression. A variable has a type already, and you
> > cannot cast that away - what would that mean, exactly? Would all
> > occurrences of some_u32_array[] suddenly have a different type? Or
> > only element [3]?
> >
> I think it would be perfectly logical to do such a cast and I'm really
> surprised that it is not legal. Obviously, it would only apply to the
> actual assignment it is used with. It's a cast, not a redefinition.
> After all, a variable or an array item is just some storage area in
> memory. Why shouldn't I be able to write to it _as if_ it is some
> different type (if I know what I'm doing and especially if it is the
> exact same size in memory)?
>
> >
> > > I managed to work around it by doing *(__be32 *)&some_u32_array[3] =
> > > but that's pretty ugly ... a better approach is still welcome.
> > >
> >
> > You need to cast the right hand side, not the left hand side. If
> > some_u32_array is u32[], force cast it to (__force u32)
> >
>
> Sure, you can do the casting on the right hand side, but that may not
> convey what you _really_ want to do, particularly in this case.
> As I _really_ want to write a big endian word there. I don't want to
> pretend I loose the endianness somewhere along the way. That written
> word is still very much big endian.
> (I know practically it makes no difference, but casting the left side
> would just be so much clearer IMHO)
>


No, it really isn't, and I am tired of having another endless debate about this.

C permits casting of expressions, not of lvalues.
...
> > > >
> > > > > > If the
> > > > > > hardware chooses to reorder those bytes for some reason, it is the
> > > > > > responsibility of the driver to take care of that from the CPU side.
> > > > > >
> > > > > Which still requires you to know the byte order as used by the API.
> > > > >
> > > >
> > > > Only if API means the AES or ChaCha specific helper routines that we
> > > > have in the kernel. If you are using the AES helpers, then yes, you
> > > > need to ensure that you use the same convention. But the algorithms
> > > > themselves are fully defined by their specification, and so what other
> > > > implementations in the kernel do is not really relevant.
> > > >
> > > What is relevant is what the API expects
> >
> > But *which* API? The skcipher API uses u8[] for in/output and keys,
> > and how these byte arrays are interpreted is not (and cannot) be
> > defined at this level of abstraction.
> >
> Yes, skcipher API. Obviously. As that's what we're talking about.
> And _of course_ it has to be defined at that level of abstraction.
> (which doesn't preclude inheriting it from some other specification)
> Otherwise you would not able to e.g. exchange keys between different
> platforms.
>

So what exactly are you suggesting? That the skcipher API should
specify that the key is u8[], unless the algo in question operates on
32-bit words, in which case it is le32[], unless the algo in question
operates on 64-bit words, in which case it is le64[] etc etc? Do you
seriously think that at the skcipher API level we should mandate all
of that? That is insane.

> >
> > > ... and from 20 years of
> > > experience I would say many algorithm specifications are not exactly
> > > very clear on the byte order at all, often assuming this to be
> > > "obvious". (and if it's not little-endian, it's not obvious to me ;-)
> > >
> >
> > I agree that not all specs are crystal clear on this. But it is still
> > the algorithm that needs to define this.
> >
> In an ideal world, probably. In the real world, it is entirely possible
> for an implementation to expect the key bytes in a different order.
> Would not be the first time I run into that.
>

Of course. But that is not the point. The skcipher API cannot possibly
reason about byte orders of all current and future algorithms that it
may ever encapsulate.
