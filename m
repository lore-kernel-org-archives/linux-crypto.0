Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CAFC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 11:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B17D321773
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 11:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zMjNHVLR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390699AbfEXLJs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 07:09:48 -0400
Received: from mail-it1-f179.google.com ([209.85.166.179]:51516 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390565AbfEXLJs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 07:09:48 -0400
Received: by mail-it1-f179.google.com with SMTP id m3so15090045itl.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 04:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ecWAffExgMOh6fC4F5DAN6LdGHJhegyGR6+xIjTg6/0=;
        b=zMjNHVLR/aohuUbPkGZFTQDiCuPn8zxdNXuisoVVgcDRJtxmYvOjWOA/8HZ/e9AYsj
         eqR22yqzFeqAovZVTzYaXTcPEV8A2XGx8xx8iNK32AkviXqBlM2RIfxgx3bsJIuIKiVU
         xp2Mr+dXBVt51y5xGJgP7RoZ3A7+LePlIlPUSiXJ4UQ68DrN6XyP+gUhPzN3hKsI+Fd4
         iZSHZ9BzqifahH+3mCftK1vLTk8ngxDMwsm3fQwo9F6PtHiWhoQGwROrR67+P2SiLg5a
         Fdif4FTS1T/7uKOn/O3leXg5P5QqN06SDkLnbpc9823jA/0oItUm6bEKVjZzgRDb221Z
         yDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ecWAffExgMOh6fC4F5DAN6LdGHJhegyGR6+xIjTg6/0=;
        b=V4lnJdErKnEQvvkW0t520BnjY/mBc/B2lOc3kQHFnJJsWHCaZu6i2/0i7k/VuTwYLK
         kMEiPi8RmlzEypQcCneFvBqnnk51oMcumDhKy0EyG4lzgP8SlJl6aK1dxUUX8JVuA8El
         3r7jcoQPEBhhde3UcN+K/3FhRQHigE4D0EZN4XzHBPb7lVVq8cRUMyFz6Lc4fEcKVCwm
         nL1jC0IiUDxcci5fLuAo20YdSOBRx6vs42UDuBOP/IRSjDtksMFY3BQZ/PztzKlyddi+
         CY7xXR0PDHRC+lM+UyGlV9pkcxnJkJCWC/ubalc5eww0g87gztZ/elyd1nJQ1SOtVaKd
         Pm2g==
X-Gm-Message-State: APjAAAXaxEd5TFutCGraJixWdW9FMfqbwn+4SJ2CCZUyUc2l1gzUV85K
        d+rPH7GOcnzmqsdkuu4If4PSn13ap49bB3tROYNUOw==
X-Google-Smtp-Source: APXvYqzaAkrIEYn5C4fbYRaWf5QJ+DYy81nchQFTyOwWE6p2jZ9wTFWNKxdbrw5qEQYQnYcor0UCuua1+JgHJZke8bo=
X-Received: by 2002:a02:9381:: with SMTP id z1mr28171025jah.130.1558696187418;
 Fri, 24 May 2019 04:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com> <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr> <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com> <AM6PR09MB35232C98F70FCB4A37AE7148D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB35232C98F70FCB4A37AE7148D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 24 May 2019 13:09:35 +0200
Message-ID: <CAKv+Gu-iPWA8i9f9SYkoG4SJYUv93PBo6ozMqBA7nGegUVm5gQ@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 24 May 2019 at 11:57, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > Again, you are making assumptions here that don't always hold. Note that
> > - a frozen process frees up the CPU to do other things while the
> > crypto is in progress;
> > - h/w crypto is typically more power efficient than CPU crypto;
> >
> True. Those are the "other" reasons - besides acceleration - to use hardware
> offload which we often use to sell our IP.
> But the honest story there is that that only works out for situations
> where there's enough work to do to make the software overhead for actually
> starting and managing that work insignificant.
>
> And even then, it's only a valid use case if that is your *intention*.
> If you *just* needed the highest performance, you don't want to go through
> the HW in this case (unless you have a *very* weak CPU perhaps, or a
> huge amount of data to process in one go).
>
> The catch is in the "always". But how do you make an informed decision
> here? The current Crypto API does not really seem to provide a mechanism
> for doing so. In which case MY approach would be "if I'm not SURE that
> the HW can do it better, then I probably shouldn't be doing in on the HW".
>

It becomes even more complicated to reason about if you take into
account that you may have 10s or 100s of instances of the CPU crypto
logic (one for each CPU) while the number of h/w IP blocks and/or
parallel processing queues typically doesn't scale in the same way.

But we are going down a rabbit hole here: even if you and I would
agree that it never makes any sense whatsoever to use h/w accelerators
from userland, the reality is that this is happening today, and so we
have to ensure that all drivers expose an interface that produces the
correct result for all imaginable corner cases.

> > - several userland programs and in-kernel users may be active at the
> > same time, so the fact that a single user sleeps doesn't mean the
> > hardware is used inefficiently
> >
> I'm not worried about the *HW* being used inefficiently.
> I'm worried about using the HW not being an improvement.
>

Evidently, it requires some care to use the AF_ALG interface
meaningfully. But that does not mean it cannot ever be used in the
right way.
