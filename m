Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE824CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 11:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B191320640
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 11:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YN7iUvki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfJUL7c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 07:59:32 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36120 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbfJUL7c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 07:59:32 -0400
Received: by mail-wr1-f48.google.com with SMTP id w18so13097167wrt.3
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 04:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1TPKHfH/kbmCHL76T/6tItyZln2h374nSowXmwjw59w=;
        b=YN7iUvkiHY1XB5oo5NJG/snW0kwT6ccQWy0ETrs4QJDV81HfKojcsSMQaoQYQJIkJk
         d8E8xYRq/NVsEX3Kd9uAVYHYD0GeCWe36gZug0SM0Ju4VoJL2eK1/j6Vw6sT+P2viZdm
         /PY5yi3Q8ZyMOPtBiqfF+1m0HyfeDUuqi2BG1Kug7nDjm16a0x66UzjcdbYfHfzjpTKh
         +LEHTTh4DATmPfSX/bjM6DfUxgawWzgaV6N5vEBfQY/CYBiKsw7ycahdoB5HUL/uJx5i
         9e3W3c6pwWe2+43JSN+L5MBCmII4krT7NJj0w8baV0D7wViu1AdMEwDGbvkidC1PXHo3
         Q+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1TPKHfH/kbmCHL76T/6tItyZln2h374nSowXmwjw59w=;
        b=jgRcxtKSlex04csWTSTQSJip2ujIfpeFuaimkzz5c3kjND9jpnc4ye110x6TPFehq0
         SVPNc6fEVfl6rUidmTsLYPI7+Z+BOlHWo7C/A4ZztMj2QqWanNwSaZnvf3qd0AmWGsUJ
         xzQ/FfbnQEdJwrD0flq6Wymo1zwWrxUTSy183Ge5k7/BDEkD2k+1rQ0YWqvF+RnZw6R2
         05+lfSOPDWZr3qJ/odKeSss39spKosH58lb/sHBPcMJWg8QtGfLDM8FAs7m80+Q5OhGq
         bpCxVkYOYdJjrT6i4Lci2FpfFLnN8tHmUPp+qU++uHjleB/i1M5s4IrrqOLdo3LlasMs
         vOGg==
X-Gm-Message-State: APjAAAWz5NJOn/7XxtXsYD/XksKv2z2yIQ/TN45n9j+hvF5llHEwYB51
        VCWfLM+BRCbrWTZSUbskMRgQVsKREoJ14y46zHFs8CA1PqASEw==
X-Google-Smtp-Source: APXvYqwpx1nX7XpLw7JUbkhlnRxb7V3j/ueiJ+x3MPSNlHy5KfCZdRJgRlPOKJbd7nQGbRwgLY7fFVFDfNNPBKggrBI=
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr12444914wrr.200.1571659170203;
 Mon, 21 Oct 2019 04:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 13:59:24 +0200
Message-ID: <CAKv+Gu8CvoaTCBxWjd9f=CtcK8GkgJkhRgYGjUHy3MqRKhezEg@mail.gmail.com>
Subject: Re: Key endianness?
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Oct 2019 at 12:56, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> Another endianness question:
>
> I have some data structure that can be either little or big endian,
> depending on the exact use case. Currently, I have it defined as u32.
> This causes sparse errors when accessing it using cpu_to_Xe32() and
> Xe32_to_cpu().
>
> Now, for the big endian case, I could use htonl()/ntohl() instead,
> but this is inconsistent with all other endian conversions in the
> driver ... and there's no little endian alternative I'm aware of.
> So I don't really like that approach.
>
> Alternatively, I could define a union of both a big and little
> endian version of the data but that would require touching a lot
> of legacy code (unless I use a C11 anonymous union ... not sure
> if that would be allowed?) and IMHO is a bit silly.
>
> Is there some way of telling sparse to _not_ check for "correct"
> use of these functions for a certain variable?
>


In this case, just use (__force __Xe32*) to cast it to the correct
type. This annotates the cast as being intentionally endian-unclean,
and shuts up Sparse.

> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
>
> > -----Original Message-----
> > From: Pascal Van Leeuwen
> > Sent: Monday, October 21, 2019 11:04 AM
> > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > Subject: Key endianness?
> >
> > Herbert,
> >
> > I'm currently busy fixing some endianness related sparse errors reported
> > by this kbuild test robot and this triggered my to rethink some endian
> > conversion being done in the inside-secure driver.
> >
> > I actually wonder what the endianness is of the input key data, e.g. the
> > "u8 *key" parameter to the setkey function.
> >
> > I also wonder what the endianness is of the key data in a structure
> > like "crypto_aes_ctx", as filled in by the aes_expandkey function.
> >

crypto_aes_ctx uses CPU endianness for the round keys.

In general, though, there is no such thing as endianness for a key
that is declared as u8[], it is simply a sequence of bytes. If the
hardware chooses to reorder those bytes for some reason, it is the
responsibility of the driver to take care of that from the CPU side.


> > Since I know my current endianness conversions work on a little endian
> > CPU, I guess the big question is whether the byte order of this key
> > data is _CPU byte order_ or always some _fixed byte order_ (e.g. as per
> > algorithm specification).
> >
> > I know I have some customers using big-endian CPU's, so I do care, but
> > I unfortunately don't have any platform available to test this with.
> >

You can boot big endian kernels on MacchiatoBin, in case that helps
(using u-boot, not EFI)
