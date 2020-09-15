Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F084DC2D0E0
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 07:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B06D321974
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 07:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600153865;
	bh=BGQ3eCEwFUe6AJJmnaDMEuJg2cqiX9jtXT/M/+4eiks=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AMsiAPQ6SmbHvFT90hCqBPHEGx7Y4YV67yjwRpmI0YYN6wO5QcALglxiUkb8D7wEV
	 Asg5pOMVQZuPDVPuD2goM0HN8sxR9QuvP42Fz4odIWdRoU1D/dmgxrBhOZAgJtmDQp
	 ZHC65KaZ5hTFgLuSAgJMytBwbwB8U4w3XwLnexHU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgIOHLE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgIOHKx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 03:10:53 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A908206B5;
        Tue, 15 Sep 2020 07:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600153852;
        bh=BGQ3eCEwFUe6AJJmnaDMEuJg2cqiX9jtXT/M/+4eiks=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hy57j0JDynjYyG6P78cB/X1ne7QBpDvOxYkzQbbuaNpIX3IdS2n1KyHL4x5/bi5+S
         3laCU23JHUdHfWt+siVuRf3ieBtU/E7sRcsZO7DqQX+xUgilE39x5D8ltzHwfHf3yc
         kDP0LT1pbCysA/0jbWpFreFar91CV8K4FxLz2ENA=
Received: by mail-oi1-f179.google.com with SMTP id x14so2717270oic.9;
        Tue, 15 Sep 2020 00:10:52 -0700 (PDT)
X-Gm-Message-State: AOAM5330TOH9YEifFZ64/Qa+2yl+UoDyGZVYlpx1mPoBb5PezPMQpdYo
        4lEYtfjLvgzu76BhwPuQnuEOwy+1wZn264Rvr8c=
X-Google-Smtp-Source: ABdhPJy2V/mnAsBclEEUOHdahMPoNIrScUu4KK+F3G+7suXAqZOb+5SpImHNQzKwxItMwxyIy05XxZZ+k4f/AYv1lvw=
X-Received: by 2002:a54:4517:: with SMTP id l23mr2478818oil.174.1600153851496;
 Tue, 15 Sep 2020 00:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200914204209.256266093@linutronix.de> <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com>
 <871rj4owfn.fsf@nanos.tec.linutronix.de> <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com>
 <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com>
 <20200915033024.GB25789@gondor.apana.org.au> <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com>
 <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com> <20200915070523.GA26629@gondor.apana.org.au>
In-Reply-To: <20200915070523.GA26629@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 15 Sep 2020 10:10:40 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGpGcvNKngJCx+5dDHMENrH2OdCwOMa6G9W6sAVhUp3Dg@mail.gmail.com>
Message-ID: <CAMj1kXGpGcvNKngJCx+5dDHMENrH2OdCwOMa6G9W6sAVhUp3Dg@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 15 Sep 2020 at 10:05, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Sep 14, 2020 at 11:55:53PM -0700, Linus Torvalds wrote:
> >
> > Maybe we could hide it behind a debug option, at least.
> >
> > Or, alterantively, introduce a new "debug_preempt_count" that doesn't
> > actually disable preemption, but warns about actual sleeping
> > operations..
>
> I'm more worried about existing users of kmap_atomic relying on
> the preemption disabling semantics.  Short of someone checking
> on every single instance (and that would include derived cases
> such as all users of sg miter), I think the safer option is to
> create something brand new and then migrate the existing users
> to it.  Something like
>
> static inline void *kmap_atomic_ifhigh(struct page *page)
> {
>         if (PageHighMem(page))
>                 return kmap_atomic(page);
>         return page_address(page);
> }
>
> static inline void kunmap_atomic_ifhigh(struct page *page, void *addr)
> {
>         if (PageHighMem(page))
>                 kunmap_atomic(addr);
> }
>

But we would still need to check all users of SG miter before we could
move it to this interface.
