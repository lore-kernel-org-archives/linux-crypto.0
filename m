Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B12ECA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0211E20679
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rfQLwvpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfJUMxq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:53:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33720 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfJUMxp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 08:53:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id s1so5099498wro.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 05:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSebvPESGwnUjjGoT6ZpzbwMlXXAMLskHvaQ/O5GIS0=;
        b=rfQLwvpEgkYV/YwdmgXLj/kBHQtl+Ol92Fm8EsJRm/2ncoE7dTK3TLOk0yctOqSSC/
         d7E96MJ5CnotdiPff0640mD6kZeXnK1NZio/0rwpPxCEok1h+osERxkcdPyy9VSDIghw
         URgiB74lgWMHfYY6ryph42mgLx8I89v72OHXSOG/UWF3q+MThnYcy91NgYyp+QAnUdVA
         9VXhw2kmaYr/eKeS3Eb08F10/acPVeNUTAds3bKXwwHs0U4GBIPNFP7lNHwKHqncaDqg
         42Ti5coXWFeggDFkqYFYaMFvqgC0ROd+pH8xtnND6gBVfOQCqD7G1KT/zcu/lLKQIvAD
         FsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSebvPESGwnUjjGoT6ZpzbwMlXXAMLskHvaQ/O5GIS0=;
        b=K65zDEOINgjM2uStBoC8pyA4hNXPDoRP4OyftidiliYxOvtYOG5wHEo1U2qAlR+1US
         /uSGqKkZtVaqk8Z00R8uB0Q9BKVWhV7yiHdDDJpprIoIE1dXrRWcCprygv+gnCXrnD2l
         kh/YS46LEghxXejoVGwhh56unpFWERgmJJNH5TVyB1qd4sRQoAsyhiEQh2Icbn/+nRQw
         LiuEAwsX08+Fgr+vnreGt8CG66oNcQyiDL+UWIXfklC+71uUroYTtHlgnzu+mEe9w0Jb
         Iuk4qbx8Q9jwVA6cTQTCLfk7QNFDFkPQ48ITCXCfHHHCBZi3PmU/0R6o67UZ8WEcNXq/
         WpQg==
X-Gm-Message-State: APjAAAXOCzgtDp3wGu90SUDptKrqT9+KafYIZ5747YD5ncsBkFdKdnC+
        JWgddFdAVoKu1Zs5Nzj3CIclbsmgNLsSOAIqun/rug==
X-Google-Smtp-Source: APXvYqz0I3xRZTLtE658nLAaURtqgFv/Qqq9a4R67o1uvvyWhgwRhjMCQmvuWW9YY+XvcZD/AO1+uSk7oSbu9v85fps=
X-Received: by 2002:adf:f685:: with SMTP id v5mr16760183wrp.246.1571662422945;
 Mon, 21 Oct 2019 05:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8CvoaTCBxWjd9f=CtcK8GkgJkhRgYGjUHy3MqRKhezEg@mail.gmail.com> <MN2PR20MB2973E221217FBDA1252804E4CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973E221217FBDA1252804E4CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 14:53:36 +0200
Message-ID: <CAKv+Gu_GnvoWd2OiY3C6enUMT4Vu5AyBaP8J3C4pVkK7yWeSng@mail.gmail.com>
Subject: Re: Key endianness?
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Oct 2019 at 14:40, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Monday, October 21, 2019 1:59 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > Subject: Re: Key endianness?
> >
> > On Mon, 21 Oct 2019 at 12:56, Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> > >
> > > Another endianness question:
> > >
> > > I have some data structure that can be either little or big endian,
> > > depending on the exact use case. Currently, I have it defined as u32.
> > > This causes sparse errors when accessing it using cpu_to_Xe32() and
> > > Xe32_to_cpu().
> > >
> > > Now, for the big endian case, I could use htonl()/ntohl() instead,
> > > but this is inconsistent with all other endian conversions in the
> > > driver ... and there's no little endian alternative I'm aware of.
> > > So I don't really like that approach.
> > >
> > > Alternatively, I could define a union of both a big and little
> > > endian version of the data but that would require touching a lot
> > > of legacy code (unless I use a C11 anonymous union ... not sure
> > > if that would be allowed?) and IMHO is a bit silly.
> > >
> > > Is there some way of telling sparse to _not_ check for "correct"
> > > use of these functions for a certain variable?
> > >
> >
> >
> > In this case, just use (__force __Xe32*) to cast it to the correct
> > type. This annotates the cast as being intentionally endian-unclean,
> > and shuts up Sparse.
> >
> Thanks for trying to help out, but that just gives me an
> "error: not an lvalue" from both sparse and GCC.
> But I'm probably doing it wrong somehow ...
>

It depends on what you are casting. But doing something like

u32 l = ...
__le32 ll = (__force __le32)l

should not trigger a sparse warning.


> > > Regards,
> > > Pascal van Leeuwen
> > > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > > www.insidesecure.com
> > >
> > > > -----Original Message-----
> > > > From: Pascal Van Leeuwen
> > > > Sent: Monday, October 21, 2019 11:04 AM
> > > > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > > Subject: Key endianness?
> > > >
> > > > Herbert,
> > > >
> > > > I'm currently busy fixing some endianness related sparse errors reported
> > > > by this kbuild test robot and this triggered my to rethink some endian
> > > > conversion being done in the inside-secure driver.
> > > >
> > > > I actually wonder what the endianness is of the input key data, e.g. the
> > > > "u8 *key" parameter to the setkey function.
> > > >
> > > > I also wonder what the endianness is of the key data in a structure
> > > > like "crypto_aes_ctx", as filled in by the aes_expandkey function.
> > > >
> >
> > crypto_aes_ctx uses CPU endianness for the round keys.
> >
> So these will need to be consistently handled using cpu_to_Xe32.
>

If you are using the generic aes_expandkey and want to reuse the key
schedule, it is indeed good to be aware that both the round keys
themselves as well as the key length are recorded in CPU endianness.

> > In general, though, there is no such thing as endianness for a key
> > that is declared as u8[], it is simply a sequence of bytes.
> >
> Depends a bit on the algorithm. Some keys are indeed defined as byte
> streams, in which case you have a point. Assuming you mean that the
> crypto API follows the byte order as defined by the algorithm spec.
>
> But sometimes the key data is actually a stream of _words_ (example:
> Chacha20) and then endianness _does_ matter. Same thing applies to
> things like nonces and initial counter values BTW.
>

Endianness always matters, and both AES and ChaCha are rather similar
in that respect in the sense that it is the algorithm that defines how
a byte stream is mapped onto 32-bit words, and in both cases, they use
little endianness.


> > If the
> > hardware chooses to reorder those bytes for some reason, it is the
> > responsibility of the driver to take care of that from the CPU side.
> >
> Which still requires you to know the byte order as used by the API.
>

Only if API means the AES or ChaCha specific helper routines that we
have in the kernel. If you are using the AES helpers, then yes, you
need to ensure that you use the same convention. But the algorithms
themselves are fully defined by their specification, and so what other
implementations in the kernel do is not really relevant.



> >
> > > > Since I know my current endianness conversions work on a little endian
> > > > CPU, I guess the big question is whether the byte order of this key
> > > > data is _CPU byte order_ or always some _fixed byte order_ (e.g. as per
> > > > algorithm specification).
> > > >
> > > > I know I have some customers using big-endian CPU's, so I do care, but
> > > > I unfortunately don't have any platform available to test this with.
> > > >
> >
> > You can boot big endian kernels on MacchiatoBin, in case that helps
> > (using u-boot, not EFI)
> >
> I'm sure _someone_ can, I'm not so sure _I_ can ;-)
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
