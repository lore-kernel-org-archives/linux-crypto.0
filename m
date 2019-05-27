Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6198C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 16:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF052147A
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 16:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VKHvqlqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfE0QVT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 12:21:19 -0400
Received: from mail-it1-f178.google.com ([209.85.166.178]:37300 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfE0QVT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 12:21:19 -0400
Received: by mail-it1-f178.google.com with SMTP id m140so27310itg.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2019 09:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q26DC+ECiEMQ+pVFE4cWiNt/ySl4lct5yteKh5807c4=;
        b=VKHvqlqMnFcbA8ZYQkNyQpbLX7ksTFk+v/BhT8ZPyIxk9pn4mSfteROI+We8DnR8OM
         Dn3jZyuQheQzjnR9Ih4V0Tio/j/j9yt042/l7NMjzEsES7qThfg6ZQVQ+rkYY8cxjFKJ
         t+y+Auf1eVrLkGWLn4CirNPbe0ZFrujIvSq8GYV4XPKsn8oafKJLTqAeY+MdPygJdQpg
         c3moN9LYAzPmzfE4Ui3dwq4GayVn/l5+CtIaK0vVpEHYOFYov1VzIOuL8Cze/gCpoxkI
         rkkHy4QxPNoKYb0dFWXQ8BnS7ugLT4AsFadx/VL6mYAE033xzqzbLK7sQzs8/Bng8/j3
         xwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q26DC+ECiEMQ+pVFE4cWiNt/ySl4lct5yteKh5807c4=;
        b=lhBk6rqbxrmGJpwpIiRKWtc09IrTIkDQ7Rh3Aj3Lc/MypIR5z7T8MGs0QlPjPEmQDf
         eE0PwV5+neQsBcZL2boR5Z/wUo22eJN7L0RUoVhQ8m+rCz9Fnlfc3SSQ0AbQiM/V8vDS
         Y328A6yEFJPydVOW/bQs/4AXzP+meUzKM5/eqoCZ7xBhA98p+zzQSfwnnk19KqWU4yd8
         RBFYzJq86w2asBLtvFfCEgg5ydrsUad2DhOvb3qdlCkBk70M0hkz0m1hdQIlugF3cjOP
         oFa5Q/nnTfibZDqoOy38Au9D696/yWfzvHdwYEfcOMKlEJYmTT6EGmQmTwP1JxSjvw85
         c0Dg==
X-Gm-Message-State: APjAAAXHbLgCz8o2x4Tim7MZS6cwQOFw2jBa7Mhg3RtqBmR/qG2vz6KB
        4ResO6g+LbUovu5EGvlOsGXnS0bDMzWeHpf+8uju5BB5Ibo=
X-Google-Smtp-Source: APXvYqzkRTXiWJuMj3jgfuUbp5P5YWDoUSQdKHFmEliXEmRnhCEzqcZUCdf3GR6dc0TGY0mekDozkdiWwCui1uHAwVA=
X-Received: by 2002:a24:d00e:: with SMTP id m14mr26941052itg.153.1558974078191;
 Mon, 27 May 2019 09:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com> <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr> <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
 <AM6PR09MB35235BFCE71343986251E163D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-q2ETftN=S_biUmamxeXFe=CHMWGd=xeZT+w4Zx0Ou2w@mail.gmail.com>
 <AM6PR09MB352398BD645902A305C680C9D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8ScTXM2qxrG__RW6SLKZYrevjfCi_HxpSOJRH5+9Knzg@mail.gmail.com>
 <AM6PR09MB3523090454E4FB6825797A0FD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu85qp44C9Leydz=ES+ByWYoYSWMC-Kiv2Gw403sYBGkcw@mail.gmail.com>
 <AM6PR09MB352345877965022A77586DEED21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8W67CDJp3ifWF-wfa47aD4Aim_RnrY9sRxyifnD_KO2g@mail.gmail.com> <AM6PR09MB35235BD86DCE54760EB14C49D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB35235BD86DCE54760EB14C49D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 27 May 2019 18:21:06 +0200
Message-ID: <CAKv+Gu-LuwaXsbU=cp24513p+t=SPtvkSbSs9bTE5=ds-=wmbA@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 May 2019 at 17:56, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > > I understand that as well. But that doesn't change the fact that the
> > > application may be waiting for a loooooong (relatively speaking) time
> > > for it's results. As latency through hardware may be several orders of
> > > a magnitude larger than the time it actually takes to *process* the
> > > request.  So when used synchronously the HW may appear to work at a mere
> > > fraction of its true performance.
> > >
> >
> > Of course. Sometimes you care about that, and sometimes you don't.
> >
> > > And if your main interest is in that application, you may not care so
> > > much about what the rest of the system does, even if it can use the
> > > remaining bandwidth of the accelerator.
> > >
> >
> > 100s of instances of that application, thread, etc could be running at
> > the same time, and throughput may be more important than latency.
> >
> > > In which case it may be desirable *not* to use the accelerator for that
> > > application at all due to *very* poor performance (for that application).
> > >
> > > Which would make even more cycles on the accelerator available to the
> > > other applications in the system, so that knife cuts both ways ...
> > >
> >
> > Single thread perfomance is only one metric, and it may not be the one
> > you care about most.
> >
>
> How relevant is the fact that there may be (other) situations where latency
> is not relevant for someone being in a situation where it is relevant?
>
> I was just talking about that situation where it actually is relevant and
> therefore you do *not* wish the hardware driver to be used.
>
> Ok, let's phrase it such that can be no further misunderstandings:
>
> If you want performance from a single-threaded single application that does
> synchronous, blocking, crypto API calls, then you do not want those to end
> up at our hardware. Or, very likely, pretty much any other hardware.
> The cra_priority mechanism does not allow the driver to convey such a thing.
>

Agreed.

But we came to this point in response to your assertion that a
userland application can only make meaningful use of the hardware
accelerator if it uses some kind of asynchronous API like AIO, and I
tried to explain that this is not the case.

> > > Adding tons of workarounds to drivers, for example, slows them down, makes
> > them
> > > use more CPU cycles and more power, and ultimately defeats the purpose of
> > having
> > > a hardware accelerator at all. That is actually my concern.
> >
> > If the workaround is in a driver and not on a hot path, we don't
> > really care about the memory footprint.
> >
> These workarounds are on a hot path by definition, as they have to filter
> out specific requests coming in, i.e. it affects every single request done
> to the driver. As for memory footprint: that is still relevant for embedded
> systems even today. Besides, memory footprint affects instruction cache hit
> ratio and therefore, indirectly, performance as well.
>

Of course. But what appears on the actual hot path is a single 'cbz'
instruction that is always predicted correctly, and the actual code
lives somewhere else in the binary. That is why I said *memory*
footprint not *cache* footprint, since it only affects the former and
not the latter.

> > > And as an aside, once workarounds have been implemented and proven to
> > "work", the
> > > underlying issue rarely makes it to the HW guys so we're stuck with it
> > forever.
> > >
> >
> > Well, the starting point of the argument was that you deliberately
> > omitted handling of zero length inputs to save silicon area.
> >
> Where did I ever say that we omitted that to save silicon area?
> You're putting words in my mouth (or fingers) now. I never said that,
> that is not the reason at all.
>

Fair enough. But I did understand correctly that this was a deliberate
decision, no?

> > So the
> > issue would already be known to the h/w guys, and they decided it was
> > something they'd punt to the software instead.
> >
> NO. We never decided any such thing. We decided that it was not a relevant
> use case that we needed to support at all. Neither in the hardware nor in
> the driver. Our own generic OS driver does not contain any such workarounds.
> In fact, based on this Linux driver thing we had a new internal discussion
> on it and the outcome did not change: not a relevant use case for us.
>

RIght. So how does this this relate to your remark above that working
workarounds prevent issues from being known to the h/w guys?

> > > NO. Hardware is broken if it doesn't comply to its own specifications -
> > > which *may* include references to industry standards it must comply with.
> > > If I intentionally specify that zero length hashes are not supported, and
> > > I don't pretend to comply with any industry standard that requires them,
> > > then that's just a *limitation* of the hardware, most certainly not a bug.
> >
> > Fair enough. But if you want to integrate that h/w in a system that
> > does aim to comply, it is up to the software to fix the impedance
> > mismatch.
> >
> Comply with what exactly? You can't "comply" with algorithms ... you just
> implement whatever subset makes sense and specify the constraints. You can
> comply with protocol specifications, and that's what we do. None of those
> requires zero length hashing, HMAC, cipher or AEAD operations.
> Many algorithms are unbounded anyway and hardware is bounded by definition.
>

I'll ignore the remark about boundedness since it has no bearing
whatsoever on this discussion.

As for compliance, many of the zero length test vectors were sourced
from FIPS or NIST documents, so i don't care what you call it, but it
is a perfectly reasonable requirement that new implementations work as
expected for test vectors that have been published along with the
algorithm.

Again, I am not saying your hardware should do this. I am only saying
that, from a software engineering perspective, your driver is where we
fix up the differences, not anywhere else.


> > > Hardware necessarily *always* has limitations because of all kinds of
> > > constraints: area, power, complexity. And even something as mundane as a
> > > schedule constraint where you simply can't fit all desired features in the
> > > desired schedule. Which is usually very solid due to timeslots being
> > > planned in a fab etc. We don't have the luxury of extending our schedule
> > > forever like SW guys tend to do ... we're very proud of our track record
> > > of always meeting our promised schedules. Plus - silicon can't be patched,
> > > so what's done is done and you have to live with it. For many years to
> > > come, usually.
> > >
> >
> > This is all pretty well understood. We all have different interests to
> > balance against each other, which is why we are perfectly fine with
> > handling some corner cases in the driver. What we are not prepared to
> > do is let those corner cases leak into the core crypto layer as cases
> > that require special handling.
> >
> Which can be avoided by not selecting a driver for an application it
> does not support ... if the corner case is not exercised, then no harm is
> done. No need for any "leaking" through the crypto layers.
>

True. So again, if you choose to support your hardware as part of a
subsystem that does not have these requirements, I am perfectly fine
with that.

> > > > I know there is a gradient here going
> > > > from hashes, AEADs to symmetric ciphers, but I think this applies to
> > > > all of them.
> > > >
> > > > > Please keep in mind that existing hardware cannot be changed. So why
> > > > > wasn't the API designed around the limitations of *existing* hardware?
> > > >
> > > > From a software point of view, adding special cases for zero length
> > > > inputs amounts to what you are trying to avoid: using more 'silicon
> > > > area'.
> > > >
> > > No, that's actually not the reason at all in this case. We're trying to
> > > avoid significant extra complexity and effort on both the hardware itself
> > > and the verification thereof. Silicon area is not even in the picture as
> > > a concern for something as "small" as this.
> > >
> > > Adding zero length support to our hardware architecture is not a trivial
> > > exercise. And then you have to weigh added complexity - =added risk, when
> > > you talk about hardware with multi-million dollar mask sets in play -
> > > against usefulness. Zero-length support was - and still is! - simply not
> > > worth the added risk and effort.
> > >
> >
> > Of course. That is why it is perfectly fine to handle this in your driver.
> >
> Perfectly fine for you, maybe, but not so much for me.
>
> Why:
> Performance loss.

Negligible

> Driver complexity vs maintenance.

Yes, but again, this complexity has to live *somewhere*, and we don't
want it in the generic code.

> Wasted effort implementing totally irrelevant cases.
>

I agree that it is unfortunate that we have to spend time on this.

> > > And if you go that naive route, just fix everything in the driver, then
> > > you simply end up with something terribly inefficient because all those
> > > corner case checks end up in the fast path and eating up code space.
> > >
> >
> > This is *exactly* the reason why we want this workaround in your
> > driver, because if it is not in your driver, we will have to put it in
> > generic code where it affects everybody.
> >
> > > For a someone claiming to "meet in the middle to compromise" you're
> > > surely not compromising anything at all ... No offense.
> > >
> >
> > None taken. I am really trying to work with you here, but changing
> > core code to address the limitations of one particular h/w
> > implementation is not something we do lightly.
> >
> Well, for one thing it is not "one particular h/w implementation".
> As for the zero length thing, I believe it's almost all of them, based
> on comments from other driver maintainers. I've only seen 1 comment saying
> that the HW *did* support it. And that was a "maybe".
>
> And my main suggestion does not require any core code changes at all.
>

So what exactly are you proposing? Mind you, we cannot optimize this
away, so we will have to add checks /somewhere/ that we are not
calling into the crypto code with length values it doesn't support.
