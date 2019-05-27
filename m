Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC184C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECDE2070D
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CfG4ait1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfE0OpW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:45:22 -0400
Received: from mail-it1-f175.google.com ([209.85.166.175]:54454 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfE0OpW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:45:22 -0400
Received: by mail-it1-f175.google.com with SMTP id h20so27201755itk.4
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2019 07:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hbCSQCK4ocM7KeKUEQJnR/igGMxr2D4lwXxSdDADMw=;
        b=CfG4ait18ZloKqxdvQkVEkSLLxbX/JX5ppAPdAlMfYgYtKssYljr0y2f0njNQKU8/I
         pUcb/ewTZcHZdBTsLoaIHvidWV4ZF6vHyJYDn/1yDyFiH1esATg2paroDERJxuxQCW0a
         u4C4oRFUsFr4xpeLgRM619CU902dpURycS1Lwrrmun1pE2j+LfJ0TiVEwizbtyYsDwaS
         Wgtp/3syyRGw3UOzwSANltzzsz5e89k/szjXL8k/f0SzbKkUyW8Z73gJWQJEdBVEjc+O
         doCPdhor1fJbhtUCXQTRlxTAL8E4bC46fDCm2yVS3LMgEx7LgVYO2ei0e8zNRCOEQq22
         msCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hbCSQCK4ocM7KeKUEQJnR/igGMxr2D4lwXxSdDADMw=;
        b=Uc9tnZckQiJQh8jHiBdWA+XO/HGhi73GPYG98EprEgACErlN0gOco99jPJvKBmDPvS
         eNY/AjXeJXd2BqNKCURwAkhYlaSZB/nOg7aWvonKXqQX0BdNJWjmwJcVGFtWqhE2rURg
         c46qHoBCTGcgUfWXvNa0dR/4L7zPnDQlemPdAI0H4LPm9YaIISMKNWD8lwCIltMSSMbI
         0RjpuELcX5zWPPWBKIfiJDs330E1L8J21EtBhyD4UkzCA7I+nieEHK+lMlDnZzQWI++8
         GyIsRKGiad6mFsVTBMBRSafL44FKKGqFVPRxa3ZBwHym5SNj8QMKuCg9HZG1907cGT1+
         8UWQ==
X-Gm-Message-State: APjAAAXWFhH+meTNkItUJUJXLogHlyoO7t3f4F+1964igcWHMM4ZFTgq
        SW9WG7iQjbAj1osO8qvUIz2nngWoMF2/T+UUbdExyg==
X-Google-Smtp-Source: APXvYqyJXpAxTJ+MxBHnNSaA0MVxgd5JumBjDZECju19ewsu5Thvxeec2aImTfo9WUyHSfCud/KypT1ixD5PkHpb7H8=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr27079188itg.104.1558968321851;
 Mon, 27 May 2019 07:45:21 -0700 (PDT)
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
 <CAKv+Gu85qp44C9Leydz=ES+ByWYoYSWMC-Kiv2Gw403sYBGkcw@mail.gmail.com> <AM6PR09MB35236E55357F5FA41AF47146D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB35236E55357F5FA41AF47146D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 27 May 2019 16:45:10 +0200
Message-ID: <CAKv+Gu86f-JuU23igrxRSkWOfXhQVUO8pA0FaY=n7pxQ3r5poA@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 May 2019 at 14:41, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > And if you go that naive route, just fix everything in the driver, then
> > you simply end up with something terribly inefficient because all those
> > corner case checks end up in the fast path and eating up code space.
> >
> One thing I forgot to mention here that should especially interest you:
> you add a lot of complexity to the *driver* that needs to verified and
> maintained (by the kernel community?!). Some of these workarounds I had to
> implement are really quite a convoluted mess and it's starting to take up
> a significant portion of the driver's code base as well ... just to support
> some fringe cases that are not even relevant to the hardware's main use
> cases (as "we" as the "hardware vendor" see it) at all.
>
> Note that I actually *have* implemented all these workarounds and my
> driver is fully passing all fuzzing tests etc. I'm just not happy with it.
>

Good, glad to hear that. I would test it myself if my MacchiatoBin
hadn't self combusted recently (for the second time!) but there are
some others that volunteered IIUC?

I think nobody is happy that we are adding code like that to the
kernel, but it seems we will have to agree to disagree on the
alternatives, since teaching the upper layers about zero length inputs
being special cases is simply not acceptable (and it would result in
those workarounds to be added to generic code where it would be
affecting everyone instead of only the users of your IP)

But I fully understand that dealing with this case in hardware is not
feasible either, and so this approach is what we will have to live
with.
