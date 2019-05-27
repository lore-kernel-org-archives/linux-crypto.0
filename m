Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF677C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B66F92183F
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fa44gXyx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfE0PYw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 11:24:52 -0400
Received: from mail-it1-f174.google.com ([209.85.166.174]:54469 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfE0PYw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 11:24:52 -0400
Received: by mail-it1-f174.google.com with SMTP id h20so27388574itk.4
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2019 08:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lbO3is/CFmmbbbmJk9/7hWxUH+Wm2TW0wNcxZv2NB/k=;
        b=fa44gXyx9yWvNMXn2R5wlbND70nzwxlUL402r/yN0miZGEjDtPemw1oN/ne8KmmyY+
         xnpe8Z2FxxcjRQOXdEIFg/paSAv3jU2fJnL1BVZuFtSNzCbKhMjGV5kpJI1/y3GBng3w
         a7RrkkGhx1coY9VEiWKLdJKHJIVdYHbn/8U7NWPKmliGsv/CAq2RRq+ZOLlkwTz4Xpxg
         KlIlVWyi5pcyzLCPoWoVikhE+rSqhSTuk3w/Nd2+QwW/Ui44M3uiJlMpEgw/b4t6i70D
         Dva3e/6BS7txSGynAOBT4tHpUPPitPcoVySISlBOdmuu2f8lnnXx+WJtCRofkHZuvLfq
         4F1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lbO3is/CFmmbbbmJk9/7hWxUH+Wm2TW0wNcxZv2NB/k=;
        b=AO0AqNxkyCGTAQwXNgDVSUNffAD51uBdIIy3Ch85Jg4+ikTXGKjvMBKqWUv++G63jC
         9VzrHptJhuZcIv3zzzSeeKNe/GXwPswhaLO91N4BRGxVtmb73bbigunZLMKFCwxBJRW6
         UyU0TjhzoxUM5BcRH7MPWeoYRGp6DjfW13iAWaZngTY1kAZQbB7fclFzymIRiN+W8wkr
         bY35n7JLmMOsVygLQ1TsqVH4hDwbKqqWHAg8eQuR9RgX9wwnsRtkKZLBHuYj/dcvJiF7
         GzyXynTT0gzPVU9Dz/ScqxgGSqnViLxcloEzqeNV3LPyHR4LXlnW8zLBfEn08E0g3FpG
         8M+w==
X-Gm-Message-State: APjAAAU72qzUf6IuqdQbfldeW5ZEASaNKRoJvpDoSv40cGSqdndbn5Lr
        +3HiSDMh3OBP1TRG+7EyNN4YJgJlfb+EpQQyB1k64ogJRjQ=
X-Google-Smtp-Source: APXvYqwwy84Srcz/Rf+JMAYmCXWZv+YpBgrvkh2Prd4C85WWZw+kv78ToLd7NCi7xllR0JdWylV1rk7I+al0nXNlcTU=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr27210779itg.104.1558970690462;
 Mon, 27 May 2019 08:24:50 -0700 (PDT)
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
 <AM6PR09MB35236E55357F5FA41AF47146D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu86f-JuU23igrxRSkWOfXhQVUO8pA0FaY=n7pxQ3r5poA@mail.gmail.com> <AM6PR09MB35231DD72CBD3CC7B6EA96FDD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB35231DD72CBD3CC7B6EA96FDD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 27 May 2019 17:24:38 +0200
Message-ID: <CAKv+Gu87J0wZSkNCritGmrrGZ5ems7OE2zSM2k9HDGYZ8Ogmog@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 May 2019 at 17:16, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > > One thing I forgot to mention here that should especially interest you:
> > > you add a lot of complexity to the *driver* that needs to verified and
> > > maintained (by the kernel community?!). Some of these workarounds I had to
> > > implement are really quite a convoluted mess and it's starting to take up
> > > a significant portion of the driver's code base as well ... just to support
> > > some fringe cases that are not even relevant to the hardware's main use
> > > cases (as "we" as the "hardware vendor" see it) at all.
> > >
> > > Note that I actually *have* implemented all these workarounds and my
> > > driver is fully passing all fuzzing tests etc. I'm just not happy with it.
> > >
> >
> > Good, glad to hear that. I would test it myself if my MacchiatoBin
> > hadn't self combusted recently (for the second time!) but there are
> > some others that volunteered IIUC?
> >
> Some people did volunteer about a month ago but I haven't heard from
> any of them since ... which means my fixes won't make it into any kernel
> trees any day soon.
>

OK. Can you share your git tree again? I will try to ping some people.

> > I think nobody is happy that we are adding code like that to the
> > kernel, but it seems we will have to agree to disagree on the
> > alternatives, since teaching the upper layers about zero length inputs
> > being special cases is simply not acceptable (and it would result in
> > those workarounds to be added to generic code where it would be
> > affecting everyone instead of only the users of your IP)
> >
> You keep missing my point though ... I was not suggesting teaching
> upper layers about zero lengths or any other hardware limitations.
> My point is that the overal majory of the "upper layers" are known not
> to need zero lengths or any of these other corner cases and our driver/
> hardware doesn't really care about supporting the ones that do, because
> those "upper layers" would not benefit from our driver/hardware anyway.
>

Yes, but 'are not known' today is not enough. Once we open that door,
it becomes our responsibility as kernel maintainers to ensure that
this remains the case.

So i understand perfectly well that current in-kernel users may never
issue crypto requests that exercise this code path. But the nice thing
today is that we don't have to care about this at all, since zero
length vectors are simply supported as well. Once we start
distinguishing the two, we have to start policing this at *some* level
rather than just pretend the issue isn't there and get bitten by it
down the road.

So no, i am not missing your point. But I think we disagree on your
conclusion that this permits is to optimize this case away and simply
don't reason about it at all.

> You know, all I *really* care about at this point is *just* supporting
> the kernel IPsec stack. The rest is just baggage for me anyway.
>

I see.

> It's all about preventing the "upper layers" from selecting our driver.
> Which can be arranged very easily. Just set cra_priority to 0 which
> requires it to be selected explicitly, moving the responsibility to
> whomever configures the machine.
>

So which algorithms that IPsec actually uses on your hardware does
this issue apply to? Does the hardware implement the complete AEAD
transform? Or does it rely on software to wire the MAC and skcipher
pieces together?

> > But I fully understand that dealing with this case in hardware is not
> > feasible either, and so this approach is what we will have to live
> > with.
> >
> We don't *have* to do anything ... this thing is not set in stone as far
> as I know. We could actually come up with a real compromise, which this
> is not. It just requires some flexibility of mind and some good will ...
>

The Latin term escapes me, but surely, complaining about the other's
unwillingness to compromise rather than give actual convincing
arguments is one of the well known rhetorical fallacies? :-)
