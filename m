Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664EFC07542
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F8C21721
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ohpBWVC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfE0JuG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 05:50:06 -0400
Received: from mail-it1-f169.google.com ([209.85.166.169]:53414 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfE0JuG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 05:50:06 -0400
Received: by mail-it1-f169.google.com with SMTP id m141so25940021ita.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2019 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4yczy0pDvMnd9N5HE+qUeg+w5lKU4fTc3gfoDvXKhs=;
        b=ohpBWVC7BUkhHc6lX+EAPUetyYaVSJLoDC3zlsDsppY5h/aVMdlWFE74NoBXdPMbDK
         lHTPImFbuF/pdWFaItdsQjXJFtzljeXd2ALKV9KvvH6VL04G59zWsimBjFRfF9qvSUH/
         59VUlwWgY0zj2N9M1cR+teWnLWlhjA3ymRpTRNPiZWfJmFAqP6UGr3DuwPf8B+UJZmgR
         YufgpYimLKBJwR7bUZBmfMRcVCE4jLxBcPHqEG41J9oiqxP8SbuEd1DbmA9rTCPe18RB
         gbhSPh/l/2SgEsaZfBJA9RzkyJdHSgtgmxKMy63qF28KBVg2NItpDWMmetnifO9fX9cD
         buWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/4yczy0pDvMnd9N5HE+qUeg+w5lKU4fTc3gfoDvXKhs=;
        b=EDH/L3/6uP4J4+C51nhUwt0RK73ko0ZNZOpX2MuBdxZ7kFcLEQPf9kCbMJW7GbevwJ
         q4t83obQ/Ft0WFVq5rxsfLOPDFn5ocscgyVoztlDthnA8TFGuqIbiPMpbOcin72x+rHy
         2yqfOVOH85qgTIg0QV8zr4gUpyNp1nBR5zmMclh9kttULak1eldxyWJd6zrRI9RMX2T7
         pCyliLEs0W1FTQ4GkjaodDnQ9hvQnPhGgX2LuMIkG8mkdp/01om/fH4myGHvgJVcH4j5
         JdeCXRJf5uvg0jzCn3ASBQO3YOqWR3iTGXM4IxKBX0WY3m4KpMgtaydeGGUvPZJhB5Ln
         E5+w==
X-Gm-Message-State: APjAAAXzH59g07Bo1dmQLefl1GxgPA/thsCpsEKf9kIRq7BfJ+TSLYIX
        pySa0OB8NMChy9WBile6jJtHuJYHMF7kUWIW7UUDTw==
X-Google-Smtp-Source: APXvYqxsAkXRTNSQysdhxpTP3jrGHKvEyy0T3+r+QrPtCxdDPZYIRxCBnk7puJsI3aLZzBGObj7q5LacYcMmSJjJDy8=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr26215160itg.104.1558950605441;
 Mon, 27 May 2019 02:50:05 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com> <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr> <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com> <AM6PR09MB35235BFCE71343986251E163D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB35235BFCE71343986251E163D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 27 May 2019 11:49:52 +0200
Message-ID: <CAKv+Gu-q2ETftN=S_biUmamxeXFe=CHMWGd=xeZT+w4Zx0Ou2w@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 May 2019 at 11:44, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel [mailto:ard.biesheuvel@linaro.org]
> > Sent: Friday, May 24, 2019 11:45 AM
> > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > Cc: Christophe Leroy <christophe.leroy@c-s.fr>; linux-crypto@vger.kernel.org
> > Subject: Re: another testmgr question
> >
> > On Fri, 24 May 2019 at 11:34, Pascal Van Leeuwen
> > <pvanleeuwen@insidesecure.com> wrote:
> > >
> > > > All userland clients of the in-kernel crypto use it specifically to
> > > > access h/w accelerators, given that software crypto doesn't require
> > > > the higher privilege level (no point in issuing those AES CPU
> > > > instructions from the kernel if you can issue them in your program
> > > > directly)
> > > >
> > > > Basically, what is used is a socket interface that can block on
> > > > read()/write(). So the userspace program doesn't need to be aware of
> > > > the asynchronous nature, it is just frozen while the calls are being
> > > > handled by the hardware.
> > > >
> > > With all due respect, but if the userland application is indeed
> > > *frozen* while the calls are being handled, then that seems like its
> > > pretty useless - for symmetric crypto, anyway - as performance would be
> > > dominated by latency, not throughput.
> > > Hardware acceleration would almost always lose that compared to a local
> > > software implementation.
> > > I certainly wouldn't want such an operation to end up at my driver!
> > >
> >
> > Again, you are making assumptions here that don't always hold. Note that
> > - a frozen process frees up the CPU to do other things while the
> > crypto is in progress;
> > - h/w crypto is typically more power efficient than CPU crypto;
> > - several userland programs and in-kernel users may be active at the
> > same time, so the fact that a single user sleeps doesn't mean the
> > hardware is used inefficiently
> >
> With all due respect, but you are making assumptions as well. You are
> making the assumption that reducing CPU load and/or reducing power
> consumption is *more* important than absolute application performance or
> latency. Which is certainly not always the case.
>

I never said power consumption is *always* more important. You were
assuming it never is.

> In addition to the assumption that using the hardware will actually
> *achieve* this, while that really depends on the ratio of driver overhead
> (which can be quite significant, unfortunately, especially if the API was
> not really created from the get-go with HW in mind) vs hardware processing
> time.
>

Of course.

> In many cases where only small amounts of data are processed sequentially,
> the hardware will simply lose on all accounts ... So Linus actually did
> have a point there. Hardware only wins for specific use cases. It's
> important to realize that and not try and use hardware for everything.
>

True. But we have already painted ourselves into a corner here, since
whatever we expose to userland today cannot simply be revoked.

I guess you could argue that your particular driver should not be
exposed to userland, and I think we may even have a CRYPTO_ALG_xxx
flag for that. But even if that does happen, it doesn't mean you can
stop caring about zero length inputs :-)
