Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991DFC55191
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 20:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D6C20776
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 20:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587674990;
	bh=MSlxj3FTC3nvLdjAv5FJt6Di8Yjgc404KV1QceXr2gI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=EGTAi9BDKrQH1k/rU12tfCuVArwFvp6TMzhqFoGXoKo6sdwgb4MYZZ7WA+EHceYo+
	 wsqP5PhnMsJ/m9GRwnhnbk0M7jxccDMaiRnwJDSQwopDfNRncvYhUMFm+ux4MM48gv
	 k93WF9Ert8/zwJAcfBoa9bWgixaJ7YcGSueHRUn0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDWUtq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 16:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgDWUtq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 16:49:46 -0400
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 463F721473;
        Thu, 23 Apr 2020 20:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587674985;
        bh=MSlxj3FTC3nvLdjAv5FJt6Di8Yjgc404KV1QceXr2gI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UicUjR+a4xpbgRR+RESVsg4TX92eq4fXd03Apr7YUXTTQLfjlwJD0+vlrfCPxCu8E
         Oe6PEnEYeTV7VVF5e5SbN/XV9jcI74Dr+IPLZlhDZDXE4srwpr7dJfe8mzvEm8gPeb
         o6epNkCAuG3YCRgONcfhTaTmu9I9/wBzDEaoryJ4=
Received: by mail-il1-f182.google.com with SMTP id f82so7200949ilh.8;
        Thu, 23 Apr 2020 13:49:45 -0700 (PDT)
X-Gm-Message-State: AGi0Pub5dXv2N7mSPLsInzfceKDIj1daEzoZ8M9z6Ob57gpxHX+e0x14
        aIhNygSxYhbFsgZH+xtOXR6mhmNCbjW0TrBhw84=
X-Google-Smtp-Source: APiQypI98P4YREZggeC8yAufVgd3Z1NcZrt0gB1INf8LQJiS0Q+a9x8mlmZViFeOMli+kJL5XCPNMdRFYd5e33KnizU=
X-Received: by 2002:a02:6a1e:: with SMTP id l30mr4929086jac.98.1587674984585;
 Thu, 23 Apr 2020 13:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200422200344.239462-1-Jason@zx2c4.com> <20200422231854.675965-1-Jason@zx2c4.com>
 <CAMj1kXHV=ryaFmj0jhQVGBd31nfHs7q5RtSyu7dY6GdEJJsr7A@mail.gmail.com>
 <20200423184219.GA80650@kroah.com> <CAMj1kXF9uLUE3=rX1i_yYoigB7j-nLMZpGc35ve2KV+NxjRhVQ@mail.gmail.com>
 <20200423202348.GA2796@gmail.com>
In-Reply-To: <20200423202348.GA2796@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 23 Apr 2020 22:49:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGAUQ3DT-9roymODC20+GPFv4R280r1BrN=juHtYhnq7g@mail.gmail.com>
Message-ID: <CAMj1kXGAUQ3DT-9roymODC20+GPFv4R280r1BrN=juHtYhnq7g@mail.gmail.com>
Subject: Re: [PATCH crypto-stable v3 1/2] crypto: arch/lib - limit simd usage
 to 4k chunks
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 23 Apr 2020 at 22:23, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Apr 23, 2020 at 08:47:00PM +0200, Ard Biesheuvel wrote:
> > On Thu, 23 Apr 2020 at 20:42, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Apr 23, 2020 at 09:18:15AM +0200, Ard Biesheuvel wrote:
> > > > FYI: you shouldn't cc stable@vger.kernel.org directly on your patches,
> > > > or add the cc: line. Only patches that are already in Linus' tree
> > > > should be sent there.
> > >
> > > Not true at all, please read:
> > >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > > for how to do this properly.  Please do not spread incorrect
> > > information.
> > >
> > > And Jason did this properly, he put cc: stable@ in the s-o-b area and
> > > all is good, I will pick up this patch once it hits Linus's tree.
> > >
> > > And there is no problem actually sending the patch to stable@vger while
> > > under development like this, as it gives me a heads-up that something is
> > > coming, and is trivial to filter out.
> > >
> > > If you really want to be nice, you can just do:
> > >         cc: stable@kernel.org
> > > which goes to /dev/null on kernel.org, so no email will be sent to any
> > > list, but my scripts still pick it up.  But no real need to do that,
> > > it's fine.
> > >
> >
> > OK, thanks for clearing this up.
> >
> > So does this mean you have stopped sending out 'formletter'
> > auto-replies for patches that were sent out to stable@vger.kernel.org
> > directly, telling people not to do that?
> >
>
> I often leave stable@vger.kernel.org in the email Cc list, and no one has ever
> complained.  It's only sending patches directly "To:" stable@vger.kernel.org
> that isn't allowed, except when actually sending out backports.
>
> If there were people who had an actual issue with Cc, then I think the rules
> would have changed long ago to using some other tag like Backport-to that
> doesn't get picked up by git send-email.
>

OK, good to know.
