Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E0BC3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 05:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D5192064A
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 05:21:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qYarr+xJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfHPFVm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 01:21:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39866 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfHPFVm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 01:21:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so346998wra.6
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 22:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=xU+VDH6kiQjQ9W6hrOKC4/ZWIEXkEKPeqD+ZZxurrAw=;
        b=qYarr+xJ0harmpsA45MNfnEHq3uRgTK/UmEGixNr2bfL+GURF6QFyHUqtrWLFg+EjQ
         QTEZq9UnaNYcI6spZoIKtdQTgpqhzhDfBCb6dRP0oydf0FKKfj8TbaJ4q0tv+kkej8sK
         DL57wpqFszPMeA5HOZwixd8CooXUe79k3BfqbWAwsdZBIYmMeesWuJoTJfTeGMLMibuB
         PWH8pl8b9bebgCyulpV3iuM5Jg6Alkys0fzk99owNmox2oQIb9GKAi3xYR21mLcx01Ht
         XS3Rj4gxOh5aFoxT8Epqxj5QKMBj9Dmg0FIt1zQLKp6QgzYm+JFmMNddfhNP25lvZriD
         rpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=xU+VDH6kiQjQ9W6hrOKC4/ZWIEXkEKPeqD+ZZxurrAw=;
        b=MBMJ3gE3jgDIKHkEThfqQMv7l/YRTR3YMsH3QbQ+lQP9i/V2DvXm+WD7quil7AXAlp
         hfJyATAV2/tHs2lDnDB8jUr+rU8cIZfaTwE8f1av7rNcDv0lEGzNXWV9gtgtKG5oYwsR
         87G1G79vpMkIEmWUMrFVSdnKMOG2i9Uxvhe7mvOPkTXyFOTERjOZ0LAEt88MJDDo2GLh
         5118yL1jI1iZFFxABX8bANJ9veRQANz7rpGukcqVLPX8aPiN5uL6j5L5FdtvuTHL0qV3
         reAmrNEncNCDH1WKOdOJArwX9MArJ2p80r5pM0OL+jMgP0bu6cilx0XaqXjyEI+Av79x
         2i4g==
X-Gm-Message-State: APjAAAXrRnkdBkdYrlgwHIn4ug2Schf/PznLVvGqTS3SewfYiOiJZg7X
        rBYbERnp2wASw7TNnd62BD/qxMoMcrY3/O/1O6sSsrTPR9YBimVL
X-Google-Smtp-Source: APXvYqzutkJxO4ku4lzEDNY0PGt9devjON7liekFbnki5eJNNlrNJCMGEAZoFCmlm9wNlNfGCsBjvELOYn+7AneuJ/M=
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr8489397wrx.241.1565932900111;
 Thu, 15 Aug 2019 22:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190809171457.12400-1-ard.biesheuvel@linaro.org>
 <20190815120800.GI29355@gondor.apana.org.au> <20190816010233.GA653@sol.localdomain>
In-Reply-To: <20190816010233.GA653@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 16 Aug 2019 08:21:30 +0300
Message-ID: <CAKv+Gu8ieCRH_R2EqwC-LMae5zaVrHMq_BuTDsN=5X1+u_CoWw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: xts - add support for ciphertext stealing
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 16 Aug 2019 at 04:02, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Aug 15, 2019 at 10:08:00PM +1000, Herbert Xu wrote:
> > On Fri, Aug 09, 2019 at 08:14:57PM +0300, Ard Biesheuvel wrote:
> > > Add support for the missing ciphertext stealing part of the XTS-AES
> > > specification, which permits inputs of any size >= the block size.
> > >
> > > Cc: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > > Tested-by: Milan Broz <gmazyland@gmail.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > > v2: fix scatterlist issue in async handling
> > >     remove stale comment
> > >
> > >  crypto/xts.c | 152 +++++++++++++++++---
> > >  1 file changed, 132 insertions(+), 20 deletions(-)
> >
> > Patch applied.  Thanks.
> > --
>
> I'm confused why this was applied as-is, since there are no test vectors for
> this added yet.  Nor were any other XTS implementations updated yet, so now
> users see inconsistent behavior, and all the XTS comparison fuzz tests fail.
> What is the plan for addressing these?  I had assumed that as much as possible
> would be fixed up at once.
>

I have the ARM/arm64 changes mostly ready to go [0], but I haven't had
the opportunity to test them on actual hardware yet (nor will I until
the end of next month). This branch contains the test vectors as well,
which check out against these implementations and the generic one (and
Pascal's safexcel one), but obviously, we cannot merge those until all
drivers are fixed.

The fuzz tests failing transiently is not a huge deal, IMO, but we do
need a deadline when we apply the test vectors.

We'll need volunteers to fix the x86, powerpc and s390 code. My branch
adds some helpers that could be useful here, but it really needs the
attention of people who can understand the code and are able to test
it.


[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=xts-cts
