Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F413C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 10:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B916238D7
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 10:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbhAUKDA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbhAUKC5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 05:02:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3D2D239A4;
        Thu, 21 Jan 2021 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611223335;
        bh=Usn9Wh/dmRovxaADPt/skhN4qrNG9qwZMhB/ref6Oig=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jRqPXJRN2P3v7GaKD5LF4yWqM3yUNzbz8N+mgh17JQmRelDkzMeTIsk904RpKa8R2
         gsUSskRX6d2Ft9LH9SX1Bi2QCjGJc8f3Uw2za8ddyrQwi8ynzPN4dDaa2YU68NrkoK
         1rcubIcYc/pkKu23GhK+TjNVbGom5xN0BBDg5Gg7GQF4vOBLCGvA+d2JVuv8Vk8YQC
         5/L+uOpKgsU5Azn2QMfY6WrVE1A0Yuu5oaONhqLfmlDfscUH8LrxodUUrqNmK8GLyx
         FQfxKrTs6HwTmJL4JBweI/ZH5QTgA7sm1S92ljp/89LMaX4M5XAjae9RwD/F435jmm
         GVAqHEFPthQKw==
Received: by mail-ot1-f42.google.com with SMTP id i20so1062332otl.7;
        Thu, 21 Jan 2021 02:02:15 -0800 (PST)
X-Gm-Message-State: AOAM532MIPfAyjfK3OxcX1qB8tPJkZpvl8L4aXV/HwCAvYhE2fqjKY4X
        XfXbTMIE0M7sWvkRsFfzltHWCHWzUUTGs8gE+A8=
X-Google-Smtp-Source: ABdhPJyiTMZ7F7Ce9f4OLX5nYH3aSt0XLhnadS1cBkE743L07yp87cGVGygXB+Y1HdGWhBM3qoqJaqBUs/p/RjiyCzA=
X-Received: by 2002:a05:6830:1158:: with SMTP id x24mr9677454otq.108.1611223334974;
 Thu, 21 Jan 2021 02:02:14 -0800 (PST)
MIME-Version: 1.0
References: <4b7a870573f485b9fea496b13c9b02d86dd97314.1611169001.git.christophe.leroy@csgroup.eu>
 <CAMj1kXE7B05eAnR7KoDCym09Cw5qnzrV8KfNT2zJrko+mFic+w@mail.gmail.com>
 <6b804eff-bc9f-5e05-d479-f398de4e2b30@csgroup.eu> <CAMj1kXHz8LdDgfOcifcB-MBMM9-TbymOU_psT3JBFQfyvQ=EjQ@mail.gmail.com>
 <ecdd07b3-afca-7e26-b6b6-3a3a985bc5a1@csgroup.eu>
In-Reply-To: <ecdd07b3-afca-7e26-b6b6-3a3a985bc5a1@csgroup.eu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 21 Jan 2021 11:02:04 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFNZba9T45RaB_W58Z+4sdAyUDVJM_ZZPk+Y6Mf9DZUQw@mail.gmail.com>
Message-ID: <CAMj1kXFNZba9T45RaB_W58Z+4sdAyUDVJM_ZZPk+Y6Mf9DZUQw@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: talitos - Work around SEC6 ERRATA (AES-CTR
 mode data size error)
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 21 Jan 2021 at 10:54, Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 21/01/2021 =C3=A0 08:31, Ard Biesheuvel a =C3=A9crit :
> > On Thu, 21 Jan 2021 at 06:35, Christophe Leroy
> > <christophe.leroy@csgroup.eu> wrote:
> >>
> >>
> >>
> >> Le 20/01/2021 =C3=A0 23:23, Ard Biesheuvel a =C3=A9crit :
> >>> On Wed, 20 Jan 2021 at 19:59, Christophe Leroy
> >>> <christophe.leroy@csgroup.eu> wrote:
> >>>>
> >>>> Talitos Security Engine AESU considers any input
> >>>> data size that is not a multiple of 16 bytes to be an error.
> >>>> This is not a problem in general, except for Counter mode
> >>>> that is a stream cipher and can have an input of any size.
> >>>>
> >>>> Test Manager for ctr(aes) fails on 4th test vector which has
> >>>> a length of 499 while all previous vectors which have a 16 bytes
> >>>> multiple length succeed.
> >>>>
> >>>> As suggested by Freescale, round up the input data length to the
> >>>> nearest 16 bytes.
> >>>>
> >>>> Fixes: 5e75ae1b3cef ("crypto: talitos - add new crypto modes")
> >>>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> >>>
> >>> Doesn't this cause the hardware to write outside the given buffer?
> >>
> >>
> >> Only the input length is modified. Not the output length.
> >>
> >> The ERRATA says:
> >>
> >> The input data length (in the descriptor) can be rounded up to the nea=
rest 16B. Set the
> >> data-in length (in the descriptor) to include X bytes of data beyond t=
he payload. Set the
> >> data-out length to only output the relevant payload (don't need to out=
put the padding).
> >> SEC reads from memory are not destructive, so the extra bytes included=
 in the AES-CTR
> >> operation can be whatever bytes are contiguously trailing the payload.
> >
> > So what happens if the input is not 16 byte aligned, and rounding it
> > up causes it to extend across a page boundary into a page that is not
> > mapped by the IOMMU/SMMU?
> >
>
> What is the IOMMU/SMMU ?
>
> The mpc8xx, mpc82xx and mpc83xx which embed the Talitos Security Engine d=
on't have such thing, the
> security engine uses DMA and has direct access to the memory bus for read=
ing and writing.
>

OK, good. So the only case where this could break is when the DMA
access spills over into a page that does not exist, and I suppose this
could only happen if the transfer involves a buffer located at the
very top of DRAM, right?
