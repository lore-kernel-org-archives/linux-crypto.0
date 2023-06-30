Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6160CEB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 10:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjF3KLG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 06:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjF3KLD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 06:11:03 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDB71FCB
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 03:11:02 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-78363cc070aso68738439f.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 03:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688119861; x=1690711861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPgv2wjYUy5dqqrgnRN0xY0ydItBAFdyM2i3QC0UNps=;
        b=2bPx93RprgLnbiRKrzjsqjj+vifT+CCfzTNk3XaX+rnPFSveZGYvKMaWmHvF/aMr6J
         naURugz+pnX6tvBDsPl+f0qHAFPvpJGHUV6P9f4K2P1ZFOB6s7logboprIK4kfRBlz6q
         NgIE6RElJA+wlYPoTfSgMw5Pm5bSyPtgx8u/MDqvxaMlTZU6y11mo0aDQvxN/pQ5WQn3
         6XSKjaLAGUy15l/czMvayi/tQQDxbzMVW3RLIvNCEha+VDDWLx3vgP5tA7BWvym617T7
         4+Wm2JsvRG1+QTgq2DPP2L3n1KI7SFDkZVT5Mrt4eIyCWT/WmaKoRjaAiEx117+yBd1Q
         l5qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688119861; x=1690711861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lPgv2wjYUy5dqqrgnRN0xY0ydItBAFdyM2i3QC0UNps=;
        b=k9s8B58f36R49aBJ+KyJ9zyOwuwC6XXBjv94SaGumMCGLZxAz3sMJ1IXcLIkOt+sMo
         pXWvCtjpOiAMYQ70n5vXofQroo7xiLTudbTvSpRMnDMuWH7uK9wb/7HDx5JYL+gD8qaj
         xQEitl08UD2unnkAAfxDGLGMfA8YPwJ/rQgIHimPh2kY6BY46ur3V6RISS/kxgHW6F3B
         qPGmJRp9OUzf19JxOs67RbYQE4H/NxlXnU05N+9xvnSoQ2d9fh/0lKv9XXkTilJlMkR3
         ++W+Bd3Eq7wr9GdsXdztPP8VU5EK2/j27FRtp8WmW9e0xtBaMWMprbWqlaJ/vlmXhGwV
         nRKQ==
X-Gm-Message-State: AC+VfDy5nAOteOvctFaUlHAYLQ6pJ+xUhGslqrRe38sIAKazNCCXy5JX
        jrrQKkEN1lWLr9bvlyP77DyxI1apFgnN+GU8fGzDxw==
X-Google-Smtp-Source: ACHHUZ4+dc69o9vQKPPPDgt5vUwiBfzzawcNELYwqgULuYMz3I09WnUqxE7mt9iM8JnsPzAnc+seS+TgUyU4JpzNoRo=
X-Received: by 2002:a6b:db16:0:b0:783:606b:740f with SMTP id
 t22-20020a6bdb16000000b00783606b740fmr2300876ioc.15.1688119861642; Fri, 30
 Jun 2023 03:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008a7ae505aef61db1@google.com> <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp> <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
In-Reply-To: <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 30 Jun 2023 12:10:25 +0200
Message-ID: <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 30, 2023 at 12:02=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> w=
rote:
>
> On Fri, 30 Jun 2023 at 11:53, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >
> > On 2023/06/30 18:36, Ard Biesheuvel wrote:
> > > Why are you sending this now?
> >
> > Just because this is currently top crasher and I can reproduce locally.
> >
> > > Do you have a reproducer for this issue?
> >
> > Yes. https://syzkaller.appspot.com/text?tag=3DReproC&x=3D12931621900000=
 works.
> >
>
> Could you please share your kernel config and the resulting kernel log
> when running the reproducer? I'll try to reproduce locally as well,
> and see if I can figure out what is going on in the crypto layer

The config together with the repro is available at
https://syzkaller.appspot.com/bug?extid=3D828dfc12440b4f6f305d, see the
latest row of the "Crashes" table that contains a C repro.
Config: https://syzkaller.appspot.com/text?tag=3DKernelConfig&x=3Dee5f7a0b2=
e48ed66
Report: https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D1325260d90=
0000
Syz repro: https://syzkaller.appspot.com/text?tag=3DReproSyz&x=3D11af973e90=
0000
C repro: https://syzkaller.appspot.com/text?tag=3DReproC&x=3D163a1e45900000

The bug is reproducible for me locally as well (and Tetsuo's patch
makes it disappear, although I have no opinion on its correctness).
