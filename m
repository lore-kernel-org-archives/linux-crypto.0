Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69436C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Mar 2022 07:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiC1HlM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Mar 2022 03:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbiC1HlK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Mar 2022 03:41:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2822B52E1C;
        Mon, 28 Mar 2022 00:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3428B80E67;
        Mon, 28 Mar 2022 07:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D28C34100;
        Mon, 28 Mar 2022 07:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648453166;
        bh=Y3D0Y07G0RU3hYpbOKQsQlIhpGXe9fEsIt2tSvoMROQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sszPDGSg+zPRYwRHrekax9kkwFh7EIknbfoPAkDT5rE0ezdFWguwVHLUF4FTNLbUp
         aqhNQOrNivckgEQA/LTuF64CchTZoa/ZhCYM90v3FOkqaaqHx9KTC6LJUVRhorOGU9
         i8Tzq4Vns59glvv7UQVg7LUTVCi713NhBGWcFv12cDTWAd4W+yqkU5t/RBPBe2wCaM
         fuz0pLa69M/OfccqsH1YiFxxglPbOI7vxp0bPViEGIrh9PCm1UPowsUaTi1Vl3knPR
         jygLaKKjBy+jUdSXOzZsQqpRMsdl99AGyFl0GEjP3Spw7ngso54Fr2A8q5SMoz1nVv
         z/fvulXQaFVZw==
Received: by mail-ot1-f52.google.com with SMTP id i11-20020a9d4a8b000000b005cda3b9754aso10121001otf.12;
        Mon, 28 Mar 2022 00:39:26 -0700 (PDT)
X-Gm-Message-State: AOAM531oPd6PEqGRDDs1Ne5t59kx6y6VrnAKdkgH0ZmhHUsBVozPGzja
        wWlWqRfPcuxzLSyPFZlUwoprkKLLcNFCczz69+A=
X-Google-Smtp-Source: ABdhPJzn1zIPrYjl5hE8jh+EbsIGMCPB+U0fNhCYfMpIJclzXpSeC2ympvLgAsQF0DbLd/W/NtHGF3vMBf2Cv0M/qR0=
X-Received: by 2002:a05:6830:1e9c:b0:5cd:8c15:5799 with SMTP id
 n28-20020a0568301e9c00b005cd8c155799mr9420603otr.265.1648453165431; Mon, 28
 Mar 2022 00:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220326172051.14722-1-thepaulodoom@thepaulodoom.com>
 <CAMj1kXEQtTAMPLTtgc=9sDYvgxs+oihfnY7Q6bggC0p5u-V1Hw@mail.gmail.com> <20220327224009.2jotnczk67j4cfh2@hp-amd-paul>
In-Reply-To: <20220327224009.2jotnczk67j4cfh2@hp-amd-paul>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 28 Mar 2022 09:39:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHCR1nD24WDnYpD4Nu23x9+hw+=7EXOpq7y7m9LDk2J0w@mail.gmail.com>
Message-ID: <CAMj1kXHCR1nD24WDnYpD4Nu23x9+hw+=7EXOpq7y7m9LDk2J0w@mail.gmail.com>
Subject: Re: [PATCH] crypto: aes_generic: fixed styling warnings
To:     Paul Lemmermann <thepaulodoom@thepaulodoom.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(please keep the cc's)

On Mon, 28 Mar 2022 at 00:46, Paul Lemmermann
<thepaulodoom@thepaulodoom.com> wrote:
>
> On Sun, Mar 27, 2022 at 01:41:19PM +0200, Ard Biesheuvel wrote:
> > On Sat, 26 Mar 2022 at 18:48, Paul Lemmermann
> > <thepaulodoom@thepaulodoom.com> wrote:
> > >
> > > Fixed all styling warnings from the checkpatch.pl script.
> > >
> > > Signed-off-by: Paul Lemmermann <thepaulodoom@thepaulodoom.com>
> >
> > Did you test this code after 'fixing' it?
> >
> No, I did not. Now that I scrutinized it a bit more, I realized the
> kernel coding conventions. Sorry about that, this is my first patch.

In that case, welcome!

This is not about coding conventions. This is about correctness.

For instance,

> > >
> > > -#define f_nround(bo, bi, k)    do {\
> > > +#define f_nround(bo, bi, k)    while (0) {\
> > >         f_rn(bo, bi, 0, k);     \
> > >         f_rn(bo, bi, 1, k);     \
> > >         f_rn(bo, bi, 2, k);     \
> > >         f_rn(bo, bi, 3, k);     \
> > >         k += 4;                 \
> > > -} while (0)
> > > +}
> > >

Why are you making this change, and why do you think it produces the
same result?

> Can you remove everything in the patch past the section with line
> 1144, or do I have to resubit the patch?
>

checkpatch.pl is a useful tool for finding style issues, but please
use it with care. And changing decades old code just to fix issues
reported by checkpatch.pl is really just pointless churn.

So let's just drop this patch altogether, shall we? If you're
interested in helping out, please have a look at the staging/ tree -
there is a lot of code there that needs cleaning up.

Thanks,
Ard.
