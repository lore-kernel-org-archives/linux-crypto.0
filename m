Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B45C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94FAC217F4
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="coniqE30"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfE0PAJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 11:00:09 -0400
Received: from mail-it1-f177.google.com ([209.85.166.177]:39767 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfE0PAJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 11:00:09 -0400
Received: by mail-it1-f177.google.com with SMTP id 9so24452024itf.4
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2019 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbXkp8iIVTTo0xA0zMK6M1BcvHybxVBg0Mpluu73W/s=;
        b=coniqE308t52HinaHTNXYB85u4yWXYoZO9n52uS6wBGGQWqMvju+A8kojlEOd68igu
         +Rfl+GtCwP2CLecYoaYsoJUse3ZsmmutpbhPKLZDfs/NBbOAKjL8xN/z6mRQRSMTrd7/
         cG0EkOsinsgGNSKpDdgWmu2PGNOCLVN7MurDqq2EBLcgq8u79cM1nKzMJOZfz5FMU+Bj
         zVC0rI23ArtmFFXHcyHqWDv8QK4+s+GhwNahpkvbh1jIAvSIsklXKHCxYrs7Z2TzKjjK
         B9ZtG1xzNQ8S/Y1GZzUbu5SnDelf7tfmI1qe6KKCfl3wSb+TFlFjqmHXYo/o96cWm0Ov
         Jv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbXkp8iIVTTo0xA0zMK6M1BcvHybxVBg0Mpluu73W/s=;
        b=dK/8iYW3m5311mz7pZuKBDTHvT9IosFDwgwZyY0yfcYvxCnypVkFYAyawIU4KH5GU1
         96HoenOf3gJX0qYYU5Bthcpc9410obZRZ24zJqDpMgdXbUlxLc11uH82CrRuDP/R3ReX
         Rgmh7QC46FOe66KRp/JW6TQsnH8jl5FB8qWtOiIuDn9GqQ7KfH/tO58brWPFFZIrS/l+
         psaAS73GcKN3Avfqkab+hZJXAhJ7CSfShwCRrcpx68tV+4RjtsRmnuxbTtOChvXSrXOi
         EQM2YUXwuGOrZS0pA/Ba9DfYfjmAZ6yFoxCLcrNIh4WDFlLNt29uxP4Ud7lJjCptmmVx
         QQJg==
X-Gm-Message-State: APjAAAVGrdNekPd115Bjv69e0QSZWcG+/t5eujrKWtOCzMFjjQWfoXvt
        8GmErsl0BCFTe6yo4cNtXe4guDFGEpJtkaKZXxroFg==
X-Google-Smtp-Source: APXvYqx7Hnaj11ECKZMs3hZ8ptaGUpld1WWlMAScG6DgPcXvByvgjDGolFTss7A1TPB+0qjOHiTA2Lwlv1cZa6Yaesw=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr27123628itg.104.1558969207693;
 Mon, 27 May 2019 08:00:07 -0700 (PDT)
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
 <CAKv+Gu85qp44C9Leydz=ES+ByWYoYSWMC-Kiv2Gw403sYBGkcw@mail.gmail.com> <AM6PR09MB352345877965022A77586DEED21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB352345877965022A77586DEED21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 27 May 2019 16:59:56 +0200
Message-ID: <CAKv+Gu8W67CDJp3ifWF-wfa47aD4Aim_RnrY9sRxyifnD_KO2g@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 May 2019 at 14:22, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> >
> > I understand that. But even if the application is synchronous, it does
> > not mean that the whole world stops and nothing is using the
> > accelerator in the mean time.
> >
> I understand that as well. But that doesn't change the fact that the
> application may be waiting for a loooooong (relatively speaking) time
> for it's results. As latency through hardware may be several orders of
> a magnitude larger than the time it actually takes to *process* the
> request.  So when used synchronously the HW may appear to work at a mere
> fraction of its true performance.
>

Of course. Sometimes you care about that, and sometimes you don't.

> And if your main interest is in that application, you may not care so
> much about what the rest of the system does, even if it can use the
> remaining bandwidth of the accelerator.
>

100s of instances of that application, thread, etc could be running at
the same time, and throughput may be more important than latency.

> In which case it may be desirable *not* to use the accelerator for that
> application at all due to *very* poor performance (for that application).
>
> Which would make even more cycles on the accelerator available to the
> other applications in the system, so that knife cuts both ways ...
>

Single thread perfomance is only one metric, and it may not be the one
you care about most.

> > > > This is made worse by the priority scheme, which does not really
> > > > convery information like this.
> > > >
> > > Yes, the priority scheme is far too simplistic to cover all details
> > > regarding hardware acceleration. Which why we probably shouldn't use
> > > it to select hardware drivers at all.
> > >
> > > > > But then again that would still be too simplistic to select to best
> > > > > driver under all possible circumstances ... so why even bother.
> > > > >
> > > > > > flag for that. But even if that does happen, it doesn't mean you can
> > > > > > stop caring about zero length inputs :-)
> > > > > >
> > > > > If the selection of the hardware driver becomes explicit and not
> > > > > automatic, you could argue for a case where the driver does NOT have
> > > > > to implement all dark corners of the API. As, as a hardware vendor,
> > > > > we could simply recommend NOT to use it for application XYZ  because
> > > > > it does things - like zero length messages - we don't support.
> > > > >
> > > >
> > > > Spoken like a true h/w guy :-)
> > > >
> > > Guilty as charged. I AM a true H/W guy and not a software engineer at all.
> > > But have you ever stopped to wonder WHY all hardware guys talk like that?
> > > Maybe, just maybe, they have a damn good reason to do so ...
> > >
> >
> > Of course. And so do we. And that is why we meet in the middle to compromise.
> >
> Yes, we try where we can. But you have to remember that ultimately hardware
> is bound by the limitations of the physical world. Which doesn't compromise :-)
> And compromises have consequences that need to be carefully considered.
>

Of course.

> Adding tons of workarounds to drivers, for example, slows them down, makes them
> use more CPU cycles and more power, and ultimately defeats the purpose of having
> a hardware accelerator at all. That is actually my concern.

If the workaround is in a driver and not on a hot path, we don't
really care about the memory footprint.

> And as an aside, once workarounds have been implemented and proven to "work", the
> underlying issue rarely makes it to the HW guys so we're stuck with it forever.
>

Well, the starting point of the argument was that you deliberately
omitted handling of zero length inputs to save silicon area. So the
issue would already be known to the h/w guys, and they decided it was
something they'd punt to the software instead.

> > > > Our crypto s/w stack and the storage, networking and other subsystems
> > > > that are layered on top of it are complex enough that we shouldn't try
> > > > to cater for non-compliant hardware. This is why you need to fix this
> > > > in your driver: to prevent the issue from leaking into other layers,
> > > > making it even more difficult to do testing and validation.
> > > >
> > > Now where am I suggesting that applications should cater for non-compliant
> > > hardware? I'm simply suggesting that you should NOT use the hardware for
> > > such an application at all. If you make it explicit, you can do that.
> > >
> > > And besides, who decides what is "compliant" and what the rules are?
> >
> > If the algorithm in question is defined for zero length inputs, but
> > the h/w chooses not to implement that case, I think non-compliant is a
> > rather nice way to say 'broken'.
> >
> NO. Hardware is broken if it doesn't comply to its own specifications -
> which *may* include references to industry standards it must comply with.
> If I intentionally specify that zero length hashes are not supported, and
> I don't pretend to comply with any industry standard that requires them,
> then that's just a *limitation* of the hardware, most certainly not a bug.

Fair enough. But if you want to integrate that h/w in a system that
does aim to comply, it is up to the software to fix the impedance
mismatch.

> Which may be perfectly valid as hardware is usually created for specific
> use cases.
> In the case of the Inside Secure HW/driver: mainly IPsec and perhaps disk
> encryption, but certainly not Ye Olde's basic random crypto request.
>

Sure.

> Hardware necessarily *always* has limitations because of all kinds of
> constraints: area, power, complexity. And even something as mundane as a
> schedule constraint where you simply can't fit all desired features in the
> desired schedule. Which is usually very solid due to timeslots being
> planned in a fab etc. We don't have the luxury of extending our schedule
> forever like SW guys tend to do ... we're very proud of our track record
> of always meeting our promised schedules. Plus - silicon can't be patched,
> so what's done is done and you have to live with it. For many years to
> come, usually.
>

This is all pretty well understood. We all have different interests to
balance against each other, which is why we are perfectly fine with
handling some corner cases in the driver. What we are not prepared to
do is let those corner cases leak into the core crypto layer as cases
that require special handling.

> > I know there is a gradient here going
> > from hashes, AEADs to symmetric ciphers, but I think this applies to
> > all of them.
> >
> > > Please keep in mind that existing hardware cannot be changed. So why
> > > wasn't the API designed around the limitations of *existing* hardware?
> >
> > From a software point of view, adding special cases for zero length
> > inputs amounts to what you are trying to avoid: using more 'silicon
> > area'.
> >
> No, that's actually not the reason at all in this case. We're trying to
> avoid significant extra complexity and effort on both the hardware itself
> and the verification thereof. Silicon area is not even in the picture as
> a concern for something as "small" as this.
>
> Adding zero length support to our hardware architecture is not a trivial
> exercise. And then you have to weigh added complexity - =added risk, when
> you talk about hardware with multi-million dollar mask sets in play -
> against usefulness. Zero-length support was - and still is! - simply not
> worth the added risk and effort.
>

Of course. That is why it is perfectly fine to handle this in your driver.

> > Proper validation requires coverage based testing, i.e., that all
> > statements in a program can be proven to be exercised by some use
> > case, and produce the correct result.
> >
> > This means that, if we have to add 'if (message_length > 0) { do this;
> > } else { do that; }' everywhere, we are moving the effort from your
> > corner to mine. Of course I am going to oppose to that :-)
> >
> > > It can take several years for a hardware fix to reach the end user ...
> > >
> >
> > While software implementations can sometimes be fixed quickly,
> > software APIs have *really* long lifetimes as well, especially in the
> > server space. And until you have reached sufficient coverage with your
> > updated API, you are stuck with both the old one and the new one, so
> > you have even more code to worry about.
> >
> > So a crypto API where zero length inputs are not permitted or treated
> > specially is not the way to fix this.
> >
> Well, for one thing even FIPS certification allows zero lengths not to be
> supported by an implementation. So there's definitely prior art to that.
> You could handle this by means of capability flags or profiles or whatever.
> But I was not even going that far in my suggestions.
>
> I was merely suggesting that IF a driver needs to be explicitly selected to
> be used, THEN you could allow that driver to be not fully compliant to some
> extent. And then the driver could come with a README or so - maintained by
> the HW vendor - detailing which use cases have actually been validated with
> it.
>

That is also fine. If you choose to expose your hardware via a
different subsystem than the crypto subsystem, there is obviously no
need to abide by the crypto subsystem's really. But if you claim to
implement these algorithms, your driver must do so without special
corner cases.

> > > As for testing and validation: if the selection is explicit, then the
> > > responsibility for the testing and validation can move to the HW vendor.
> > >
> >
> > I think the bottom line is still to fix the driver and be done with
> > it. I honestly don't care about what exactly your h/w supports, as
> > long as the driver that encapsulates it addresses the impedance
> > mismatch between what the h/w layer provides and what the upper layer
> > expects.
> >
> And if you go that naive route, just fix everything in the driver, then
> you simply end up with something terribly inefficient because all those
> corner case checks end up in the fast path and eating up code space.
>

This is *exactly* the reason why we want this workaround in your
driver, because if it is not in your driver, we will have to put it in
generic code where it affects everybody.

> For a someone claiming to "meet in the middle to compromise" you're
> surely not compromising anything at all ... No offense.
>

None taken. I am really trying to work with you here, but changing
core code to address the limitations of one particular h/w
implementation is not something we do lightly.
