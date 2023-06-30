Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B15CEB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 11:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjF3Lnk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 07:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjF3Lnk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 07:43:40 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464ED1BD4
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 04:43:39 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7836164a08aso74970739f.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 04:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688125418; x=1690717418;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NY+pHNYX++uPw0GdIA88Fg8qrzeAw3i64xZ2DUGb+XU=;
        b=mALpn/INM320JwgmXJ3mgi71Kga4fYNP3E4PyKcnacXgjqCZRO9ehSeO2U/6xeTMK/
         Zg1jidL3NDiwkrdriXpnVrieaXHFWnt2fp6OCr+5G7c0kFpeigOrXUC/y+3Vxg0IIL94
         mlvZHvcCe7kqOnT3WC9QngqI5aa+STAHICCNpBdjZL3jm5dXGQA2LP8Ms0cs6hCRdW1l
         fqeIRILF8eW1Qk6bF5dYSMiuG2nAqS/2jx3aFuCI2gAjbiXbJGPXisWOST/5rqyB6e15
         h3p6y4GGIaY+hYicx5CPBoWvzFPzM2PTnQebRGyfZhG6KJZ/IyinQEmt+68MVZcuyg9D
         8TZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688125418; x=1690717418;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NY+pHNYX++uPw0GdIA88Fg8qrzeAw3i64xZ2DUGb+XU=;
        b=dJZSLQdhIuzqu1nwySrqpYKn3fuOj0bSTcjV2AcNlASN7ElKaMjz9ol35D+yaOzID4
         PuAF0HU5vVu/TSqYGNLDcERPQNj6Z0uaCqCvSfGkZR1vVxe0gmPLKzdQklkWLjJNLXOn
         CLxHPtzoYyQJHQ3s+BUiRn2POnhX+86tEU69Xi2ToK8pJ93gKeOAFvx00fjIRoXy9XrR
         H9nDyQ6HaDFWeBhgG9stwKdxD+94Yz7t70WYQ8OvJi8nSGNsSWlciETYyN0zyCMw2QIJ
         9tn84a3RvjFL5hZli2d+uh7xzigKj2e2usa/MH1jx7JguAlL8eI9KSTNflwAgKWPyCms
         qJOA==
X-Gm-Message-State: AC+VfDwJtGQA7oYHJY3Atw2uYCq3fwrGHl6lAw0Z7qJjVLdXKspf6sR0
        WmwtkziDE/BE6DPryajlz1ACTGuAAaoOc20zmQFgrg==
X-Google-Smtp-Source: ACHHUZ7S5AQ4Drl3wvgUZEsizLAitrLmIDVn8VCrMpfr0mmLA3IalJKmWl+w1jOIERtY09bBZvP50K083lArebc8PQs=
X-Received: by 2002:a5d:8183:0:b0:776:fd07:3c96 with SMTP id
 u3-20020a5d8183000000b00776fd073c96mr2933630ion.7.1688125418565; Fri, 30 Jun
 2023 04:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008a7ae505aef61db1@google.com> <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
 <f5c2d592-4b97-93f8-b62e-402eeeaa70d9@I-love.SAKURA.ne.jp> <CAMj1kXH6STkFX-SocCiqRgFwkQFZEG=DW6hu6H9W7Egxm2icrw@mail.gmail.com>
In-Reply-To: <CAMj1kXH6STkFX-SocCiqRgFwkQFZEG=DW6hu6H9W7Egxm2icrw@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 30 Jun 2023 13:43:02 +0200
Message-ID: <CAG_fn=X2kbdxAC0EAPQnpQU12Vqz0DjAt2Y=HsEmWuTsPbJojw@mail.gmail.com>
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+828dfc12440b4f6f305d@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > >>>
> > >>> Could you please share your kernel config and the resulting kernel log
> > >>> when running the reproducer? I'll try to reproduce locally as well,
> > >>> and see if I can figure out what is going on in the crypto layer
> > >>
> > >> The config together with the repro is available at
> > >> https://syzkaller.appspot.com/bug?extid=828dfc12440b4f6f305d, see the
> > >> latest row of the "Crashes" table that contains a C repro.
> >
> > Kernel is commit e6bc8833d80f of https://github.com/google/kmsan/commits/master .
>
> That commit does not exist in that repo. Does it matter?

Apologies for this mess.
https://github.com/google/kmsan/commits/master is force-updated once a
week to point to the latest release candidate with KMSAN-specific
patches.
Older releases are called e.g. kmsan-v6.4-rc7.
Right now there's only one patch required to run torvalds/master with
KMSAN (https://github.com/google/kmsan/commit/e6bc8833d80f).
That patch will hit upstream in v6.5-rc1, after which I am going to
switch syzbot to test upstream.

For such a long-standing bug the exact version of KMSAN shouldn't matter.
