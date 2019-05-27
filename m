Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3C9C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25DFC20859
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nXNROYUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfE0K5W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 06:57:22 -0400
Received: from mail-it1-f172.google.com ([209.85.166.172]:35559 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfE0K5W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 06:57:22 -0400
Received: by mail-it1-f172.google.com with SMTP id u186so23548317ith.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2019 03:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N2hq4ZfVyMMNCqFy9iMLgtSB91dXTxW+1HyHn2OClP0=;
        b=nXNROYUktPUej6xYwUxiR8e/Isl4a6GS3vSoGo1KmtD5rD3VA7oE6kRqSrlgd0L1Wq
         ChDEA0PymH/u7lq0cGsGq23FVXYoK2+Wn+rUBSIRfOruvV2YbCCIf10rjPgaoKhq/SMO
         qwLgBYBqhmagYgetUYnTAbAgyPpSjuLPKzxrvSyJ+YPcLrTkEdmvqy9356VnjKLm/+bO
         SNQqESq6uXHAMC8gI8lumU6J2t1qND74jYVqeuWh4KPXulqP3SXeu14uMbbroyZKDBoU
         KU1ZjTRk2T3hz+YiFHSapXWfaWqdtyB0QjWN1UvJXmk1I6v3pm+9qyKOW4y5c8gOTu1D
         TzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N2hq4ZfVyMMNCqFy9iMLgtSB91dXTxW+1HyHn2OClP0=;
        b=sb50aI3CpegiEjJrS2lUHs8Jtf8YsnhzPJff0mZFOuSvh57wa9hiP2Pnitwnwfr2VW
         QDvyT/LpmwIQV/7DehR4FCmRFdET5L6Lat4xKJ6Alhkw/6aRFIpYUDE+oAskNBLVOARd
         PzazFKg+9LedUoyPpSyHgumZ6X/hKhF5vJV1xHkBDJ3TD/MhDWOtPc10OeqyfsQzD9X+
         X2qkBr1BVWJsTU7+5hcWO/yVLh5MJNsreOdmmp+agTsfZUY/4ujjmi4FzhNvfrFUyEkx
         hpe7PTe0XoVlwnJSsXJLyDRT3OpIV0IHySfWxDH6TEDfFMlPSkI3UDAV9k4NZrxEgaVo
         i7lA==
X-Gm-Message-State: APjAAAVPhILykco4WoQ9t92pYn1VDxREuytF51Bj+Q6fBuIPNezNqq0r
        c9i8jnJNIMHtdnAUH1fj924SEKj3+7jdIJWck4tBKg==
X-Google-Smtp-Source: APXvYqxkgA0wcTfIh/4z3LnyMCjHKDs2SnwXmYg+BfDjcotaZ98KHeq78skdLSf2+asnF6rGjyB1q+x1nKdMFIb6aEA=
X-Received: by 2002:a24:910b:: with SMTP id i11mr30251296ite.76.1558954641703;
 Mon, 27 May 2019 03:57:21 -0700 (PDT)
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
 <CAKv+Gu8ScTXM2qxrG__RW6SLKZYrevjfCi_HxpSOJRH5+9Knzg@mail.gmail.com> <AM6PR09MB3523090454E4FB6825797A0FD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523090454E4FB6825797A0FD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 27 May 2019 12:57:08 +0200
Message-ID: <CAKv+Gu85qp44C9Leydz=ES+ByWYoYSWMC-Kiv2Gw403sYBGkcw@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 May 2019 at 12:43, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > As I explained before, what appears synchronous to a single userland
> > process may look very differently from the OS and h/w perspective. But
> > of course, I take your point that h/w is not faster than the CPU in
> > the general case, and so care must be taken.
> >
> "Synchronous" in this context was referring to a use case where the
> application does a request and then *waits* for the result of that
> request before continuing.
> While "asynchronous" would refer to a case where the application fires
> off a request and then merrily goes off doing "other" things (which
> could be, but is not limited to, preparing and posting new requests).
>
> So I'm strictly viewing it from the applications' perspective here.
>

I understand that. But even if the application is synchronous, it does
not mean that the whole world stops and nothing is using the
accelerator in the mean time.

> > This is made worse by the priority scheme, which does not really
> > convery information like this.
> >
> Yes, the priority scheme is far too simplistic to cover all details
> regarding hardware acceleration. Which why we probably shouldn't use
> it to select hardware drivers at all.
>
> > > But then again that would still be too simplistic to select to best
> > > driver under all possible circumstances ... so why even bother.
> > >
> > > > flag for that. But even if that does happen, it doesn't mean you can
> > > > stop caring about zero length inputs :-)
> > > >
> > > If the selection of the hardware driver becomes explicit and not
> > > automatic, you could argue for a case where the driver does NOT have
> > > to implement all dark corners of the API. As, as a hardware vendor,
> > > we could simply recommend NOT to use it for application XYZ  because
> > > it does things - like zero length messages - we don't support.
> > >
> >
> > Spoken like a true h/w guy :-)
> >
> Guilty as charged. I AM a true H/W guy and not a software engineer at all.
> But have you ever stopped to wonder WHY all hardware guys talk like that?
> Maybe, just maybe, they have a damn good reason to do so ...
>

Of course. And so do we. And that is why we meet in the middle to compromise.

> > Our crypto s/w stack and the storage, networking and other subsystems
> > that are layered on top of it are complex enough that we shouldn't try
> > to cater for non-compliant hardware. This is why you need to fix this
> > in your driver: to prevent the issue from leaking into other layers,
> > making it even more difficult to do testing and validation.
> >
> Now where am I suggesting that applications should cater for non-compliant
> hardware? I'm simply suggesting that you should NOT use the hardware for
> such an application at all. If you make it explicit, you can do that.
>
> And besides, who decides what is "compliant" and what the rules are?

If the algorithm in question is defined for zero length inputs, but
the h/w chooses not to implement that case, I think non-compliant is a
rather nice way to say 'broken'. I know there is a gradient here going
from hashes, AEADs to symmetric ciphers, but I think this applies to
all of them.

> Please keep in mind that existing hardware cannot be changed. So why
> wasn't the API designed around the limitations of *existing* hardware?

From a software point of view, adding special cases for zero length
inputs amounts to what you are trying to avoid: using more 'silicon
area'.

Proper validation requires coverage based testing, i.e., that all
statements in a program can be proven to be exercised by some use
case, and produce the correct result.

This means that, if we have to add 'if (message_length > 0) { do this;
} else { do that; }' everywhere, we are moving the effort from your
corner to mine. Of course I am going to oppose to that :-)

> It can take several years for a hardware fix to reach the end user ...
>

While software implementations can sometimes be fixed quickly,
software APIs have *really* long lifetimes as well, especially in the
server space. And until you have reached sufficient coverage with your
updated API, you are stuck with both the old one and the new one, so
you have even more code to worry about.

So a crypto API where zero length inputs are not permitted or treated
specially is not the way to fix this.

> As for testing and validation: if the selection is explicit, then the
> responsibility for the testing and validation can move to the HW vendor.
>

I think the bottom line is still to fix the driver and be done with
it. I honestly don't care about what exactly your h/w supports, as
long as the driver that encapsulates it addresses the impedance
mismatch between what the h/w layer provides and what the upper layer
expects.
