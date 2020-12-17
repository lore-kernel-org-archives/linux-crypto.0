Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09FDC2BB9A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 08:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B175238E5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 08:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgLQITk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 03:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgLQITk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 03:19:40 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E9CC061794
        for <linux-crypto@vger.kernel.org>; Thu, 17 Dec 2020 00:18:59 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id l7so12909891qvt.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Dec 2020 00:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5VQg7Qq6tu9zxEiOHWHdVZC+h6E0ef9ck17g1uIq278=;
        b=JiQsm1xH9UW6+PT9gLz89MNIxj6KBYXql+gCE8wkihR9NAvOX7KpOCM/9cefnTv3lR
         q8I4WTdZo+TDkCag7yIKnHY+hhasYZAL6+fohN4tCZyLhBQZg+nJfFZ8MbjO1fZSzSs9
         sKnFb57GeKrVj1XsWwkBxRApKKCiw0IAg3QWpAzIXksF/AyUvXwBiTbpyh0tWPh2bFlV
         OCuS8eyah3aaHvWroPQC07NszabIlb4iPIJMtM70rhFqUSKhqeyIS4SsLXep6pcEX/kN
         r17nqSa7So8qGDQSi/VXcKrJHGGTo+l1gDmrIKA7tbMYmR3rpdJEkAaUkkY1RJwgXmi5
         eQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5VQg7Qq6tu9zxEiOHWHdVZC+h6E0ef9ck17g1uIq278=;
        b=Pq4M/d3UQ+7uBPQMzsC0aKUPt/t2+AUgGa3L6DPkHTq53lAM1meqR74NG8HTAF5ziF
         nS1myY1lr05wEieIC5CBLuJmMgJAscRbGssbWqfLxe8+9BD6S/WE0EWiyifqFu00hL7l
         Rz3LJt1yt0V6i6cgkWIwflJPgZeQO5ozlzcbVWsksa+7voUzRw5KdEYyCmMCcSI9SkqT
         hPYcidFdMknyrM9yensYC50EfbHWysLePytfctTbabAPxgYfGFwsw0g9LA10V/pdLP0k
         Q2xc8KmYjTrZK/WHQkk4YLnuQTeEd23nOPUeJz+4SJUdJH4qjwLuDoYhBCN8JQCVKNh/
         Fj/w==
X-Gm-Message-State: AOAM532s58q2MPdHvdJvC1nb3uQPGP/Z2NF8q2RUUZbzr/MP8ijuH6fq
        LVgNb9XTJUHXdZQ3zIaeTRot9crjxhpqukltfR4w/A==
X-Google-Smtp-Source: ABdhPJyMAxUvSxPZNp7c19iP1MJhJ0bR5Yv/kJcGX8Ex7UvCtSI4xwbzgaZS8dJXfg+pTmJTHUo3J0yAza8eKWA295o=
X-Received: by 2002:a0c:b20d:: with SMTP id x13mr47798309qvd.18.1608193138660;
 Thu, 17 Dec 2020 00:18:58 -0800 (PST)
MIME-Version: 1.0
References: <000000000000f683660598300559@google.com> <0000000000002aca3d05b69503ac@google.com>
In-Reply-To: <0000000000002aca3d05b69503ac@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 17 Dec 2020 09:18:45 +0100
Message-ID: <CACT4Y+Z0=kRUdwOguF5a_E+HyUUsnD3Gw=qx9Z_dao1o41W=ag@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in sys_open (2)
To:     syzbot <syzbot+7ee926c5e237e614ccb1@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-afs@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 16, 2020 at 2:40 PM syzbot
<syzbot+7ee926c5e237e614ccb1@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 1d0e850a49a5b56f8f3cb51e74a11e2fedb96be6
> Author: David Howells <dhowells@redhat.com>
> Date:   Fri Oct 16 12:21:14 2020 +0000
>
>     afs: Fix cell removal
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=128ceadf500000
> start commit:   c85fb28b Merge tag 'arm64-fixes' of git://git.kernel.org/p..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=de7f697da23057c7
> dashboard link: https://syzkaller.appspot.com/bug?extid=7ee926c5e237e614ccb1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1227c177900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13553f60500000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: afs: Fix cell removal
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: afs: Fix cell removal
