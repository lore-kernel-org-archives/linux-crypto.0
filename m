Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B4ECA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B9B220882
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LWWPjSfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfJUMMD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:12:03 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:36545 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbfJUMMD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 08:12:03 -0400
Received: by mail-wm1-f43.google.com with SMTP id c22so3425861wmd.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 05:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C0g9TGDe0O3LzC0HasbbdWSuj85nnB/cdMz1Jtyyydc=;
        b=LWWPjSfJEZ3NpFvbzyyTxDdexw38zUHcMORx40TO7TTHWyJPYCi2XH6hhSRmKcWNPA
         KZtmELU6RoxABv1pWY8AApxsxWKoft+5BO4y1hhjTnSBQ4S9BmRhVaXbdRtoWUkFx2LC
         /XItztesRdzRmT+yGO9xXyWLDLzxf6rv4EuyBbyJG695YSJzjcO6FADiRfTCEo5ZfEaH
         hHySIox9aul9OV9k/A99mZvrY9Mdj9NuBfGZo/ca5bdve04yvWeV3eMG5Z8yNgxg+6uc
         uIad4oO7z96g6LCq+hZcWjMAvt1U8ttQbtG3D7TX12sRYTf2Y9KII/eeisIZn9W9d9wQ
         KNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C0g9TGDe0O3LzC0HasbbdWSuj85nnB/cdMz1Jtyyydc=;
        b=MgVRP7AC7UUOVZDSIgqpK79ZkEWMIB+N4en0S/WEljwizeGfsftrPsJkwdCEQXgAef
         hoLmnIY1Rqvu3oQt69KNRSLzz49V7pdwgRgWpDjk2OkPbEWb5ikknPhGs7G2CNqvYQSB
         ANtMR6E8xLSHW7T4yKsmuB0nGKGtST4Lu9yNtW1h+/zsWLh7JYUGQ79uNpwoVMyNogoy
         wnTq+OFj4U5eAhNyzhU6Hl2QCZnUXjJKg7ELGEhm/0RQMKolkDKTdt2EruxkagJPTOUZ
         wrw6dYhhpW1aFhcs9+26bcYSgSgB3Sv8yqbY18/L7ik2/Vybnf7qFq938RObpy+nAEoZ
         i6wQ==
X-Gm-Message-State: APjAAAWUEOs0DHgJ8VWgBGL6S/CZoPUXKgT8gGpIPG7QonLlGv7l/E/N
        jIqoe3zpRRu5xiPSKcQtlATzodpKNVTiFiF74VOOI8mBv6k=
X-Google-Smtp-Source: APXvYqxwOxITLFqwFrxSlSmJq42CF3BRStxCgg0ePqXU/bAuCzPp0bP9tjUZmnZMPrVthAgLhsIL+6axPpIJIBNn9yY=
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr18010266wmj.119.1571659919598;
 Mon, 21 Oct 2019 05:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29730B2489C1A416BE8B7864CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29730B2489C1A416BE8B7864CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 14:11:54 +0200
Message-ID: <CAKv+Gu8xVE+QwU39McGPsGRfx9PuoiHyHFY3fie4rDidhcSfYg@mail.gmail.com>
Subject: Re: Key endianness?
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Oct 2019 at 14:08, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> And now that we've opened Pandora's box of "ellendianness" (as we
> say here - a combination of the Dutch word "ellende", for misery,
> and endianness ;-):
>
> The inside-secure driver uses several packed bitfield structures
> (that are actually used directly by the little-endian hardware)
> What happens to these on a big-endian machine?

The C spec does not define how packed bitfields are projected onto
memory, so relying on that is a mistake. Your code should do the
bitwise arithmetic explicitly to be portable.

> I've seen examples that hint at having to define the bits in
> reverse order on big-endian machines, which would require a big
> "#ifdef LITTLE_ENDIAN / #else" around the whole struct definition.
>
> And then on top of that I'll probably still have to swap the bytes
> within words to get those into the correct order towards the HW.
> Which is not very convenient for fields crossing byte boundaries.
> (I'd probably want to use the byte swapping facilities of my HW
> for that and not the CPU)
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Pascal Van Leeuwen
> > Sent: Monday, October 21, 2019 12:56 PM
> > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > Subject: RE: Key endianness?
> >
> > Another endianness question:
> >
> > I have some data structure that can be either little or big endian,
> > depending on the exact use case. Currently, I have it defined as u32.
> > This causes sparse errors when accessing it using cpu_to_Xe32() and
> > Xe32_to_cpu().
> >
> > Now, for the big endian case, I could use htonl()/ntohl() instead,
> > but this is inconsistent with all other endian conversions in the
> > driver ... and there's no little endian alternative I'm aware of.
> > So I don't really like that approach.
> >
> > Alternatively, I could define a union of both a big and little
> > endian version of the data but that would require touching a lot
> > of legacy code (unless I use a C11 anonymous union ... not sure
> > if that would be allowed?) and IMHO is a bit silly.
> >
> > Is there some way of telling sparse to _not_ check for "correct"
> > use of these functions for a certain variable?
> >
> > Regards,
> > Pascal van Leeuwen
> > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > www.insidesecure.com
> >
> > > -----Original Message-----
> > > From: Pascal Van Leeuwen
> > > Sent: Monday, October 21, 2019 11:04 AM
> > > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > > Subject: Key endianness?
> > >
> > > Herbert,
> > >
> > > I'm currently busy fixing some endianness related sparse errors reported
> > > by this kbuild test robot and this triggered my to rethink some endian
> > > conversion being done in the inside-secure driver.
> > >
> > > I actually wonder what the endianness is of the input key data, e.g. the
> > > "u8 *key" parameter to the setkey function.
> > >
> > > I also wonder what the endianness is of the key data in a structure
> > > like "crypto_aes_ctx", as filled in by the aes_expandkey function.
> > >
> > > Since I know my current endianness conversions work on a little endian
> > > CPU, I guess the big question is whether the byte order of this key
> > > data is _CPU byte order_ or always some _fixed byte order_ (e.g. as per
> > > algorithm specification).
> > >
> > > I know I have some customers using big-endian CPU's, so I do care, but
> > > I unfortunately don't have any platform available to test this with.
> > >
> > > Regards,
> > > Pascal van Leeuwen
> > > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > > www.insidesecure.com
>
