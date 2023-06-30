Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47F7EB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 11:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjF3Ltv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 07:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjF3Ltu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 07:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7503A87
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 04:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 017FB61730
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 11:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668C3C43391;
        Fri, 30 Jun 2023 11:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688125788;
        bh=VdAfzLBbSkl+/YOzY755sG4yaX5WI2D5q5ibxkkxAKk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GiCd4pLmfDbfJDGvKDW5FZF+CySd/jhR7uMQMdEb/ctKBJYw+FxWlDJ7mk6xqlsp2
         DQhdmtL2+pDknGFDoU5dEATE1jtEJEOtHNzk2rd6EYmW5FLtivVCGYHAC8U46tgB+7
         BxYKul+eBmpxDoaacU8YtakVRHrrIAXM/kw3XJ/a0F5KCRtVrbCXAbBSnbotqlw3XF
         3ec8GYmtF0KzeLBz+yLrLws36FXSaDkL7cMsDRMABGdMd/lhwchLIVYrccCzIi8DyX
         R99ZCOUIXsnvfAYYuek/apbt6M4zpAoAi4P9SrscqKNSEgKJhkh/fQT+mJrE4mm3Rd
         yj+eMeh9uECqg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-4fb77f21c63so2843826e87.2;
        Fri, 30 Jun 2023 04:49:48 -0700 (PDT)
X-Gm-Message-State: ABy/qLbSv1KwA9LXCGYvziaupiCokS+j2kywcAXCzyODR7rAeu57a0Ri
        1sJ/4uhhqEdm62Vg4P6PlXXRfuRkWF8Wx1GfBDs=
X-Google-Smtp-Source: APBJJlHBoc1DIeaLKxAanV/6/skMuHbWNDym/NZzDpmifmrua6+uTG/2cmMrV0KS8rAbbx/9MWmJns4BByOHrgrVeTQ=
X-Received: by 2002:a05:6512:3d0f:b0:4f8:5bf7:db05 with SMTP id
 d15-20020a0565123d0f00b004f85bf7db05mr2278533lfv.27.1688125786347; Fri, 30
 Jun 2023 04:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008a7ae505aef61db1@google.com> <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com> <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com>
In-Reply-To: <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Jun 2023 13:49:34 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
Message-ID: <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
To:     Alexander Potapenko <glider@google.com>
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

On Fri, 30 Jun 2023 at 13:38, Alexander Potapenko <glider@google.com> wrote=
:
>
> On Fri, Jun 30, 2023 at 12:18=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org>=
 wrote:
> >
> > On Fri, 30 Jun 2023 at 12:11, Alexander Potapenko <glider@google.com> w=
rote:
> > >
> > > On Fri, Jun 30, 2023 at 12:02=E2=80=AFPM Ard Biesheuvel <ardb@kernel.=
org> wrote:
> > > >
> > > > On Fri, 30 Jun 2023 at 11:53, Tetsuo Handa
> > > > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > > >
> > > > > On 2023/06/30 18:36, Ard Biesheuvel wrote:
> > > > > > Why are you sending this now?
> > > > >
> > > > > Just because this is currently top crasher and I can reproduce lo=
cally.
> > > > >
> > > > > > Do you have a reproducer for this issue?
> > > > >
> > > > > Yes. https://syzkaller.appspot.com/text?tag=3DReproC&x=3D12931621=
900000 works.
> > > > >
> > > >
> > > > Could you please share your kernel config and the resulting kernel =
log
> > > > when running the reproducer? I'll try to reproduce locally as well,
> > > > and see if I can figure out what is going on in the crypto layer
> > >
> > > The config together with the repro is available at
> > > https://syzkaller.appspot.com/bug?extid=3D828dfc12440b4f6f305d, see t=
he
> > > latest row of the "Crashes" table that contains a C repro.
> >
> > Could you explain why that bug contains ~50 reports that seem entirely
> > unrelated?
>
> These are some unfortunate effects of syzbot trying to deduplicate
> bugs. There's a tradeoff between reporting every single crash
> separately and grouping together those that have e.g. the same origin.
> Applying this algorithm transitively results in bigger clusters
> containing unwanted reports.
> We'll look closer.
>
> > AIUI, this actual issue has not been reproduced since
> > 2020??
>
> Oh, sorry, I misread the table and misinformed you. The topmost row of
> the table is indeed the _oldest_ one.
> Another manifestation of the bug was on 2023/05/23
> (https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D146f66b1280000)
>

That one has nothing to do with networking, so I don't see how this
patch would affect it.

>
> >
> > > Config: https://syzkaller.appspot.com/text?tag=3DKernelConfig&x=3Dee5=
f7a0b2e48ed66
> > > Report: https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D1325=
260d900000
> > > Syz repro: https://syzkaller.appspot.com/text?tag=3DReproSyz&x=3D11af=
973e900000
> > > C repro: https://syzkaller.appspot.com/text?tag=3DReproC&x=3D163a1e45=
900000
> > >
> > > The bug is reproducible for me locally as well (and Tetsuo's patch
> > > makes it disappear, although I have no opinion on its correctness).
> >
> > What I'd like to do is run a kernel plus initrd locally in OVMF and
> > reproduce the issue - can I do that without all the syzkaller
> > machinery?
>
> You can build the kernel from the config linked above, that's what I
> did to reproduce it locally.
> As for initrd, there are disk images attached to the reports, will that h=
elp?
>
> E.g.
>   $ wget https://storage.googleapis.com/syzbot-assets/79bb4ff7cc58/disk-f=
93f2fed.raw.xz
>   $ unxz disk-f93f2fed.raw.xz
>   $ qemu-system-x86_64 -smp 2,sockets=3D2,cores=3D1 -m 4G -drive
> file=3Ddisk-f93f2fed.raw -snapshot -nographic -enable-kvm
>
> lets me boot syzkaller with the disk/kernel from that report of 2023/05/2=
3.
> Adding "-net user,hostfwd=3Dtcp::10022-:22 -net nic,model=3De1000" I am
> also able to SSH into the machine (there's no password):
>
> $ ssh -o "StrictHostKeyChecking no"  -p 10022     root@localhost
>
> Then the repro can be downloaded and executed:
>
> $ wget "https://syzkaller.appspot.com/text?tag=3DReproC&x=3D163a1e4590000=
0" -O t.c
> $ gcc t.c -static -o t
> $ scp -o "StrictHostKeyChecking no" -P 10022   t  root@localhost:
> $ ssh -o "StrictHostKeyChecking no"  -p 10022     root@localhost ./t
>
> Within a couple minutes the kernel crashes with the report:
>
> [  151.522472][ T5865] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  151.523843][ T5865] BUG: KMSAN: uninit-value in aes_encrypt+0x15cc/0x1=
db0
> [  151.525120][ T5865]  aes_encrypt+0x15cc/0x1db0
> [  151.526113][ T5865]  aesti_encrypt+0x7d/0xf0
> [  151.527057][ T5865]  crypto_cipher_encrypt_one+0x112/0x200
> [  151.528224][ T5865]  crypto_cbcmac_digest_update+0x301/0x4b0
>

OK, thanks for the instructions.

Out of curiosity - does the stack trace you cut off here include the
BPF routine mentioned in the report?
