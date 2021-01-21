Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271C6C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8FF123A57
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389189AbhAUSKe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389207AbhAUSK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 13:10:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 652BA23A22
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jan 2021 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611252588;
        bh=ARgSFuVEjpl+Uc64D1m8g9thyMfi5NetN+wxnS/O6+o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=syhBc+JmZJ1uYHR6WpgyeI5c5j8vw8eLZnzNSlxWoiWijkm9fKdwLsUbDUIvHzI6P
         iRemYtH34+2gN18925Co1WlJmGmwdRhMGnoXh8Ea/Q9zRG7KQmtQIXGORWPAX9eRnT
         7vmVYdHy2v97DAo7t0a68eDxZ1dxmmZ2VHlg94cQXBIFKrgiDmDCACfmkUUHbxW8RA
         t1J4Ho2JWiblbV1riv6mUOL0VVQ4Bn425GuAoAhX++sZie++gyDdnG2G87XyH6xOhU
         9RqQBjYXGV+OiF/ToqrX5xmwFf6nK1E37OFIH/pE///JfeUQEi6n9r8PqzOhaLkQXM
         W59/+0qgJ2SLg==
Received: by mail-oo1-f52.google.com with SMTP id g46so360002ooi.9
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jan 2021 10:09:48 -0800 (PST)
X-Gm-Message-State: AOAM531xMz5eJ+qccFGbPNcIIkicjF1TeYJgWn35C//Br+uNGhTMfRwB
        fiLaLwoqB/hbk8zcXCYRrSaPtUYesfrfOJKwAuE=
X-Google-Smtp-Source: ABdhPJw5fb2aHkz6BhRzeg+V/F4VXHygRX671oXSlebgiiywcrltiwhlrYUoFJsxx0b0zBdsamVNJuX2yLqHr9oJ5ok=
X-Received: by 2002:a4a:bb86:: with SMTP id h6mr675631oop.13.1611252587755;
 Thu, 21 Jan 2021 10:09:47 -0800 (PST)
MIME-Version: 1.0
References: <20210121130733.1649-1-ardb@kernel.org> <20210121130733.1649-6-ardb@kernel.org>
 <YAnCbnnFCQkyBpUA@sol.localdomain>
In-Reply-To: <YAnCbnnFCQkyBpUA@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 21 Jan 2021 19:09:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
Message-ID: <CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] crypto: remove Salsa20 stream cipher algorithm
To:     Eric Biggers <ebiggers@kernel.org>, agk@redhat.com,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Milan Broz <gmazyland@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 21 Jan 2021 at 19:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 21, 2021 at 02:07:33PM +0100, Ard Biesheuvel wrote:
> > Salsa20 is not used anywhere in the kernel, is not suitable for disk
> > encryption, and widely considered to have been superseded by ChaCha20.
> > So let's remove it.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 +-
> >  crypto/Kconfig                                           |   12 -
> >  crypto/Makefile                                          |    1 -
> >  crypto/salsa20_generic.c                                 |  212 ----
> >  crypto/tcrypt.c                                          |   11 +-
> >  crypto/testmgr.c                                         |    6 -
> >  crypto/testmgr.h                                         | 1162 --------------------
> >  7 files changed, 3 insertions(+), 1405 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> > index 4e6f504474ac..d56112e2e354 100644
> > --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
> > +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> > @@ -143,8 +143,8 @@ recalculate
> >  journal_crypt:algorithm(:key)        (the key is optional)
> >       Encrypt the journal using given algorithm to make sure that the
> >       attacker can't read the journal. You can use a block cipher here
> > -     (such as "cbc(aes)") or a stream cipher (for example "chacha20",
> > -     "salsa20" or "ctr(aes)").
> > +     (such as "cbc(aes)") or a stream cipher (for example "chacha20"
> > +     or "ctr(aes)").
>
> You should check with the dm-integrity maintainers how likely it is that people
> are using salsa20 with dm-integrity.  It's possible that people are using it,
> especially since the documentation says that dm-integrity can use a stream
> cipher and specifically gives salsa20 as an example.
>

Good point - cc'ed them now.
