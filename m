Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7422C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D8B7208CA
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xhpfgQXD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfE0K2v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 06:28:51 -0400
Received: from mail-it1-f182.google.com ([209.85.166.182]:36277 "EHLO
        mail-it1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfE0K2v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 06:28:51 -0400
Received: by mail-it1-f182.google.com with SMTP id e184so23460106ite.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2019 03:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+y8Z+9vEThSyppBMbyLMZw4ZHnA9acMBrBgNYPw8nU=;
        b=xhpfgQXD7x8fXmlfiVu9Lb6QrfGRCLpD7NwVfehZnwpxG11lHr+OPLqp1WBqegr4tD
         Y1yxA9c0awOl9RYtqrdDOZAZJKnYtGJ6ZpXDx0b5NMYx1bthBs8Fr7GZe1PoiouCdqfC
         UrJ17UoYfeDVbCusHtND1STRyBfnThWk3Mfh/zq9/vOIMLconoDaWGJIczJX0BcxOSz2
         jGAulCwrVl2AzuA797rIIBkafzRP3h5niJE6lqHwEnVUpNcm262GgBM/NnnNkbQr6iry
         80W3iX3iDnMJ1GufeVSR4wbk3PpcAAxjcComwiCZJ/FM5PswJ1cvILzilmN/6wIDRl3P
         1/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+y8Z+9vEThSyppBMbyLMZw4ZHnA9acMBrBgNYPw8nU=;
        b=Qr9SNLhwyBv/fG7/5kEWuV5pgXXbndQM2WhDrrpZABHDuHB/wIQXFgXj5/gLWSG7BH
         IJrDfnSmieFq5vWayj+ME5w1CfXyeYswR04WC3qS0ZmV2g9ytpb4GPdp07Dz+mJ61Es1
         9kDH9kTQFYtMsJZpsuihsj6oDhlpy+AjKrjjyu9Vm3XRXUejPcsF0KECK70ryM4yb6LB
         Hqm15F1YA8yv/4Trs88j744BJVTUJ5MAhYW7NX5s1Bb1MQ+7uF/GYs91+jqTOv539kR9
         lG5LX+1vi8SMzBhl6/tVxtcn9kEUBpbXVmbgb9HrC0L8rYdciUB7GyY6ZTjal8CoDNFv
         yCnA==
X-Gm-Message-State: APjAAAUWj9tLwd6olO9grLtPCbSyJr8kIOpKxsjRfAOpnngQx+Wr0LDV
        tCGvFedo0fFN9/VmGu5DpnNhIVXzO/2rR9JQd0ZhnQ==
X-Google-Smtp-Source: APXvYqyl7TexkbZcgvCIXgD7Ivf0/tdBU3bU2I+F1iamtJLb4t/x2fEHubQWzFCDuENkPlFIXBRm0mbJgTjvSz2JJ7I=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr26310714itg.104.1558952930137;
 Mon, 27 May 2019 03:28:50 -0700 (PDT)
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
 <CAKv+Gu-q2ETftN=S_biUmamxeXFe=CHMWGd=xeZT+w4Zx0Ou2w@mail.gmail.com> <AM6PR09MB352398BD645902A305C680C9D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB352398BD645902A305C680C9D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 27 May 2019 12:28:37 +0200
Message-ID: <CAKv+Gu8ScTXM2qxrG__RW6SLKZYrevjfCi_HxpSOJRH5+9Knzg@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 May 2019 at 12:04, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > > With all due respect, but you are making assumptions as well. You are
> > > making the assumption that reducing CPU load and/or reducing power
> > > consumption is *more* important than absolute application performance or
> > > latency. Which is certainly not always the case.
> > >
> >
> > I never said power consumption is *always* more important. You were
> > assuming it never is.
> >
> Nooooo I wasn't. Not on purpose, anyway. Power consumption is a major selling
> point for us. If you got that impression, then that's some misunderstanding.
> My argument was simply that there *may* be other requirements. You don't know,
> so you shouldn't make assumptions in the other direction either.
>

That was basically *my* point. But you're welcome to use it :-)

> > > In many cases where only small amounts of data are processed sequentially,
> > > the hardware will simply lose on all accounts ... So Linus actually did
> > > have a point there. Hardware only wins for specific use cases. It's
> > > important to realize that and not try and use hardware for everything.
> > >
> >
> > True. But we have already painted ourselves into a corner here, since
> > whatever we expose to userland today cannot simply be revoked.
> >
> > I guess you could argue that your particular driver should not be
> > exposed to userland, and I think we may even have a CRYPTO_ALG_xxx
> >
> Well, I understood from someone else on this list that CRYPTO_ALG can
> do async operations in which case I would assume it doesn't block??
>
> I would rather see a flag denoting "do not use me in a synchronous
> fashion on relatively small datablocks, only use me if you intend to
> seriously pipeline your requests". Or somesuch.
>

As I explained before, what appears synchronous to a single userland
process may look very differently from the OS and h/w perspective. But
of course, I take your point that h/w is not faster than the CPU in
the general case, and so care must be taken.

This is made worse by the priority scheme, which does not really
convery information like this.

> But then again that would still be too simplistic to select to best
> driver under all possible circumstances ... so why even bother.
>
> > flag for that. But even if that does happen, it doesn't mean you can
> > stop caring about zero length inputs :-)
> >
> If the selection of the hardware driver becomes explicit and not
> automatic, you could argue for a case where the driver does NOT have
> to implement all dark corners of the API. As, as a hardware vendor,
> we could simply recommend NOT to use it for application XYZ  because
> it does things - like zero length messages - we don't support.
>

Spoken like a true h/w guy :-)

Our crypto s/w stack and the storage, networking and other subsystems
that are layered on top of it are complex enough that we shouldn't try
to cater for non-compliant hardware. This is why you need to fix this
in your driver: to prevent the issue from leaking into other layers,
making it even more difficult to do testing and validation.
