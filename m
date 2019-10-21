Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30426CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 15:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF5720B7C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 15:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NhPUd2hV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbfJUPbt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 11:31:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44918 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbfJUPbt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 11:31:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id z9so14501403wrl.11
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 08:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=umwFzrfvCHqAWjqnbJ7c+GUihR3wgKbPKMdVvtxiwXA=;
        b=NhPUd2hVd17j/YxoW6TTVx47yx7Kq194LvJlFQSWnitbMxi/J4z0+qE5NfX1V7XoFz
         O1Gx83vASHPwTCnAKVqtF5EUIlVxOL4M1dD96PXr/UN17j8jKFrtSYbyjSQFG2X95hUr
         PGXlOHoRm1AXiJzTe9S6rSHEsJbn3UfsvLUzGJeZG1xa8Os5dGKm6DbTCBj4HQDx8zQ/
         QgztPLRZU78SQk2yrbZT6NwmUK9wgf6k7J7ma1QfcYPPVxTwuuHyB8BkU6UMlS1ZSM7i
         AgbfSIzkPaFNRwjujcpyV9oeAbpfFfozCttnJ2jbS9vM3OxKHQMBveAWCW25dHsNz+s1
         GNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=umwFzrfvCHqAWjqnbJ7c+GUihR3wgKbPKMdVvtxiwXA=;
        b=V9fRpsaa8yGxoQyMQzOVhNb2ICPfDrk0l7vHbdrjUrq9OqS+YwChRgczZEBtHVPA94
         uHW1ZqrC8rw0bEf15JPwnx9kIqnNTDd5lBFPAoNbsWAc2cSE6JiLKLqrguM7D2mXff1s
         zhSb4goRXd40WuYMr30RXS75VWTFegxzP7yltn49io9vNQwKtIRj38OPXERFtsH/YMLI
         iM6D5dN3E+c+Z5t+KwyCPsK2dN6A47PlFqT5RoO07TybX6pMdahUrKkP82AKhhzYRZEh
         I5pYYMBRIbLAMGfEm6dCgJo0I8nmoLwBd0WoFGSOPiZ0mJ5yATwQ4tjenPB87KSM8/pm
         511w==
X-Gm-Message-State: APjAAAU5pmsp2QDGBnHDqxNc9SNk1EofXnjIrhhKifyF8p6S0crX4n+u
        ttypaB6E56VMITr8szP7yMyOL0pX3j804GvsZbAb9w==
X-Google-Smtp-Source: APXvYqybqBLFgiG5vHWZjUVmX5NkApW26l+ElZe+oE+e2JFPpbFwgEtmE9md7WzESWfmJqdkXNDj0CIVHg7Qn58wjWE=
X-Received: by 2002:a5d:6b0a:: with SMTP id v10mr19183431wrw.32.1571671905673;
 Mon, 21 Oct 2019 08:31:45 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8CvoaTCBxWjd9f=CtcK8GkgJkhRgYGjUHy3MqRKhezEg@mail.gmail.com>
 <MN2PR20MB2973E221217FBDA1252804E4CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_GnvoWd2OiY3C6enUMT4Vu5AyBaP8J3C4pVkK7yWeSng@mail.gmail.com> <MN2PR20MB2973876A85667AABE157A27ECA690@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973876A85667AABE157A27ECA690@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 17:31:33 +0200
Message-ID: <CAKv+Gu8oyZUL+i23j6r7xYsOeBEUDdZC2w4TKLVtVDfCB1LXYg@mail.gmail.com>
Subject: Re: Key endianness?
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

p[

On Mon, 21 Oct 2019 at 17:23, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Monday, October 21, 2019 2:54 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > Subject: Re: Key endianness?
> >
> > On Mon, 21 Oct 2019 at 14:40, Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > Sent: Monday, October 21, 2019 1:59 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > Subject: Re: Key endianness?
> > > >
> > > > On Mon, 21 Oct 2019 at 12:56, Pascal Van Leeuwen
> > > > <pvanleeuwen@verimatrix.com> wrote:
> > > > >
> > > > > Another endianness question:
> > > > >
> > > > > I have some data structure that can be either little or big endian,
> > > > > depending on the exact use case. Currently, I have it defined as u32.
> > > > > This causes sparse errors when accessing it using cpu_to_Xe32() and
> > > > > Xe32_to_cpu().
> > > > >
> > > > > Now, for the big endian case, I could use htonl()/ntohl() instead,
> > > > > but this is inconsistent with all other endian conversions in the
> > > > > driver ... and there's no little endian alternative I'm aware of.
> > > > > So I don't really like that approach.
> > > > >
> > > > > Alternatively, I could define a union of both a big and little
> > > > > endian version of the data but that would require touching a lot
> > > > > of legacy code (unless I use a C11 anonymous union ... not sure
> > > > > if that would be allowed?) and IMHO is a bit silly.
> > > > >
> > > > > Is there some way of telling sparse to _not_ check for "correct"
> > > > > use of these functions for a certain variable?
> > > > >
> > > >
> > > >
> > > > In this case, just use (__force __Xe32*) to cast it to the correct
> > > > type. This annotates the cast as being intentionally endian-unclean,
> > > > and shuts up Sparse.
> > > >
> > > Thanks for trying to help out, but that just gives me an
> > > "error: not an lvalue" from both sparse and GCC.
> > > But I'm probably doing it wrong somehow ...
> > >
> >
> > It depends on what you are casting. But doing something like
> >
> > u32 l = ...
> > __le32 ll = (__force __le32)l
> >
> > should not trigger a sparse warning.
> >
> I was actually casting the left side, not the right side,
> as that's where my sparse issue was. Must be my poor grasp
> of the C language hurting me here as I don't understand why
> I'm not allowed to cast an array element to a different type
> of the _same size_ ...
>
> i.e. why can't I do (__be32)some_u32_array[3] = cpu_to_be32(some_value)?
>

Because you can only change the type of an expression by casting, and
an lvalue is not an expression. A variable has a type already, and you
cannot cast that away - what would that mean, exactly? Would all
occurrences of some_u32_array[] suddenly have a different type? Or
only element [3]?


> I managed to work around it by doing *(__be32 *)&some_u32_array[3] =
> but that's pretty ugly ... a better approach is still welcome.
>

You need to cast the right hand side, not the left hand side. If
some_u32_array is u32[], force cast it to (__force u32)

> >
> > > > > Regards,
> > > > > Pascal van Leeuwen
> > > > > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > > > > www.insidesecure.com
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Pascal Van Leeuwen
> > > > > > Sent: Monday, October 21, 2019 11:04 AM
> > > > > > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > > > Subject: Key endianness?
> > > > > >
> > > > > > Herbert,
> > > > > >
> > > > > > I'm currently busy fixing some endianness related sparse errors reported
> > > > > > by this kbuild test robot and this triggered my to rethink some endian
> > > > > > conversion being done in the inside-secure driver.
> > > > > >
> > > > > > I actually wonder what the endianness is of the input key data, e.g. the
> > > > > > "u8 *key" parameter to the setkey function.
> > > > > >
> > > > > > I also wonder what the endianness is of the key data in a structure
> > > > > > like "crypto_aes_ctx", as filled in by the aes_expandkey function.
> > > > > >
> > > >
> > > > crypto_aes_ctx uses CPU endianness for the round keys.
> > > >
> > > So these will need to be consistently handled using cpu_to_Xe32.
> > >
> >
> > If you are using the generic aes_expandkey and want to reuse the key
> > schedule, it is indeed good to be aware that both the round keys
> > themselves as well as the key length are recorded in CPU endianness.
> >
> Actually, I have a big patch standing by getting rid of aes_expandkey()
> altogether as I don't need _any_ of those round keys generated, ii
> was just used for AES key validity checks and nothing else.
>
> But since that patch is not ready for prime time yet, I have to fix
> these sparse errors for the time being.
>
> > > > In general, though, there is no such thing as endianness for a key
> > > > that is declared as u8[], it is simply a sequence of bytes.
> > > >
> > > Depends a bit on the algorithm. Some keys are indeed defined as byte
> > > streams, in which case you have a point. Assuming you mean that the
> > > crypto API follows the byte order as defined by the algorithm spec.
> > >
> > > But sometimes the key data is actually a stream of _words_ (example:
> > > Chacha20) and then endianness _does_ matter. Same thing applies to
> > > things like nonces and initial counter values BTW.
> > >
> >
> > Endianness always matters, and both AES and ChaCha are rather similar
> > in that respect in the sense that it is the algorithm that defines how
> > a byte stream is mapped onto 32-bit words, and in both cases, they use
> > little endianness.
> >
> Thanks, that's actually something I can _use_ ;-)
>
> >
> > > > If the
> > > > hardware chooses to reorder those bytes for some reason, it is the
> > > > responsibility of the driver to take care of that from the CPU side.
> > > >
> > > Which still requires you to know the byte order as used by the API.
> > >
> >
> > Only if API means the AES or ChaCha specific helper routines that we
> > have in the kernel. If you are using the AES helpers, then yes, you
> > need to ensure that you use the same convention. But the algorithms
> > themselves are fully defined by their specification, and so what other
> > implementations in the kernel do is not really relevant.
> >
> What is relevant is what the API expects

But *which* API? The skcipher API uses u8[] for in/output and keys,
and how these byte arrays are interpreted is not (and cannot) be
defined at this level of abstraction.


> ... and from 20 years of
> experience I would say many algorithm specifications are not exactly
> very clear on the byte order at all, often assuming this to be
> "obvious". (and if it's not little-endian, it's not obvious to me ;-)
>

I agree that not all specs are crystal clear on this. But it is still
the algorithm that needs to define this.

> Very often getting the byte order right was just trial and error
> using known-good reference vectors and just trying every possible
> byte/word/whatever swap you could think of. (hence "ellendianness")
>
> >
> >
> > > >
> > > > > > Since I know my current endianness conversions work on a little endian
> > > > > > CPU, I guess the big question is whether the byte order of this key
> > > > > > data is _CPU byte order_ or always some _fixed byte order_ (e.g. as per
> > > > > > algorithm specification).
> > > > > >
> > > > > > I know I have some customers using big-endian CPU's, so I do care, but
> > > > > > I unfortunately don't have any platform available to test this with.
> > > > > >
> > > >
> > > > You can boot big endian kernels on MacchiatoBin, in case that helps
> > > > (using u-boot, not EFI)
> > > >
> > > I'm sure _someone_ can, I'm not so sure _I_ can ;-)
> > >
> > > Regards,
> > > Pascal van Leeuwen
> > > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > > www.insidesecure.com
>
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
>
