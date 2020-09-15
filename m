Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DD6C43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 07:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E9D920897
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 07:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600153786;
	bh=v2czRDJr1AIXqzmgcL7bKJTuq9rzPOZ8lBwD+R5JJeg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=oq8ZxYrbzlC6zsoc7Fp277Tk88BnTnQG3hbP9upc4M40/0V//V++cXsxhU9W248Sr
	 5QaBlsl2jQg39G7YF3rxEBCvSX7YNjgHq10sn/v0frl2gL6fE48ys/q/hpd7280tGT
	 HlgTixU2o9d1vwQCfl1DzfyIcXoZi6Om9Zu+HJCM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgIOHJm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgIOHJf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 03:09:35 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDBA820897;
        Tue, 15 Sep 2020 07:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600153745;
        bh=v2czRDJr1AIXqzmgcL7bKJTuq9rzPOZ8lBwD+R5JJeg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IXPtXP9I+ZuF/J1bdTYJGDRGGqPdbvN+AD6pJp6Km0w31VpnyQMVpn2XGN3vdjskB
         sbqt44oVYweYRxG0pPrfHOKfnpv+HJ3oBIM3tSz8OR6ehiU3z1wUnbbTLVWoiLaD0r
         zquLyHuO5LuMbGyj20WSYK1il53zgTJ4Un/2FEWU=
Received: by mail-oi1-f178.google.com with SMTP id w16so2766375oia.2;
        Tue, 15 Sep 2020 00:09:05 -0700 (PDT)
X-Gm-Message-State: AOAM530soM5KzkM6vLEgmbjYPKoir0A5eyVkJwLTguhpmTu/69Pgrrdq
        T/4em8rsrJCYBm9HBcrPqM2SspThoXUu7+BzF0k=
X-Google-Smtp-Source: ABdhPJzrvtU+rmFv6V6i+uOB8xgr9QAhAQSYwUnFQ7bSIayE1xsuuDvzQbG3BE9hj9keU99enRqbYPLrkOm4EHcepbw=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr2342806oic.33.1600153745110;
 Tue, 15 Sep 2020 00:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200914204209.256266093@linutronix.de> <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com>
 <871rj4owfn.fsf@nanos.tec.linutronix.de> <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com>
 <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com>
 <20200915033024.GB25789@gondor.apana.org.au> <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com>
 <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com>
In-Reply-To: <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 15 Sep 2020 10:08:53 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFU7fkUgfPPqOVzTeVrJPm0RUPG4dd9WGiVt6yhmGaEag@mail.gmail.com>
Message-ID: <CAMj1kXFU7fkUgfPPqOVzTeVrJPm0RUPG4dd9WGiVt6yhmGaEag@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 15 Sep 2020 at 09:56, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Sep 14, 2020 at 11:45 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I mean, I did find one case that didn't set it (cb710-mmc.c), but
> > pattern-matching to the other mmc cases, that one looks like it
> > _should_ have set the atomic flag like everybody else did.
>
> Oh, and immediately after sending that out I notice
> nvmet_bdev_execute_rw(), which does seem to make allocations inside
> that sg_miter loop.
>
> So those non-atomic cases do clearly exist.
>
> It does make the case for why kmap_atomic() wants to have the
> debugging code. It will "just work" on 64-bit to do it wrong, because
> the address doesn't become invalid just because you sleep or get
> rescheduled. But then the code that every developer tests (since
> developers tend to run on good hardware) might be completely broken on
> bad old hardware.
>

If we want code that is optimal on recent hardware, and yet still
correct on older 32-bit hardware, kmap() is definitely a better choice
here than kmap_atomic(), since it is a no-op on !HIGHMEM, and
tolerates sleeping on 32-bit. /That/ is why I wrote the code this way.

The problem is of course that kmap() itself might sleep.

So I would argue that the semantics in the name of kmap_atomic() are
not about the fact that it starts a non-preemptible section, but that
it can be *called from* a non-preemptible section. And starting a
non-preemptible section is unnecessary on !HIGHMEM, and should be
avoided if possible.

> Maybe we could hide it behind a debug option, at least.
>
> Or, alterantively, introduce a new "debug_preempt_count" that doesn't
> actually disable preemption, but warns about actual sleeping
> operations..
>
>              Linus
