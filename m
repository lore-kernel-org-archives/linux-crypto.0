Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0CDEB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 11:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbjF3Lzt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 07:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbjF3Lzn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 07:55:43 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2F73C06
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 04:55:37 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-345b548a055so7544245ab.2
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 04:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688126137; x=1690718137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgpzQ5xWMVxLbExeM6SQbFWEzkacJCn5gH2LJPXZCaU=;
        b=1DL8et9fvGtl6tF9tF6t/kwLQf2SIgv8EcIl6hqN/zs+zp/PZSPWYv1AkSLD9T7FVF
         if7FXswuGrsgS/P/NqC0cpYDgBSCnLwd62UueBBGSdZ+/5BwbpxZzOwKn7NY2+wkeqKi
         OTqvs3zc3zbcvtDgbmzUMlYz2qaF3l1I8cTcAjHIoCn4lAH9vThd1vdKgptunKdg71A9
         2W3c1afa4oI0dvkaHwdK3ZpvXJcCm7wxkkWICbOx5/40EQpVJTbgw+BR3y1J3dK1JAim
         j0qaXJy8v7V4v8MPVw8n2b/AjaUmsTHAzcGhaa4CTlD9GkoeHgXrFSbgb+NWCjDbFz/w
         jQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688126137; x=1690718137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgpzQ5xWMVxLbExeM6SQbFWEzkacJCn5gH2LJPXZCaU=;
        b=XnxKSYFXfOGO68ALXEm4lziDnLYwA6qIVC5L3/Ue5ApCkGe4jKzXonNy7quZArtlrd
         10pImsoBI/ZepFoJWCaPs3JQyC+bBVMyIvgDnptl0WcDGxe9bm8R+d2lLOHlxPfvJkSe
         zHUnQkCTv7qzx0qZu5cJrkkhZELV9n/5JntB9sGUweNf/lnP9zw1zr7Bpy85wAIF0RwL
         8Ue6D+ixgTFxN0YvvpzPjDNcmrc4YS+FqSpnRoN3kfvROgnVNU1qYGVy4ynL7ynN3kSA
         Hw9Y9CWAYMwbsG+Qb1ARed67n1DRP36d/R7TOBiVV6O/EhlX333bzRN88lkB27jAQ7RX
         zreg==
X-Gm-Message-State: AC+VfDynG86plrClBpu7AutsdWE0UwdjhRf0jok7v4PKk3L0ufq6N5Kv
        CkZMEqyPT2gp74thIED/vPMOR5Zz+R25Vt0r4pRS0g==
X-Google-Smtp-Source: ACHHUZ4rXI5PVeIemzLyNBZwidWazY4antRdG3+rQ/g3beRRAK+2DEPVa0L+UHieAtXGM7VIaFvRNXLxM6tHVOqiZOE=
X-Received: by 2002:a6b:7e03:0:b0:786:267e:bd4 with SMTP id
 i3-20020a6b7e03000000b00786267e0bd4mr2613878iom.10.1688126136898; Fri, 30 Jun
 2023 04:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008a7ae505aef61db1@google.com> <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
 <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com> <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
In-Reply-To: <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 30 Jun 2023 13:55:00 +0200
Message-ID: <CAG_fn=UWZWc+FZ_shCr+T9Y3gV9Bue-ZFHKJj78YXBq3JfnUKA@mail.gmail.com>
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

On Fri, Jun 30, 2023 at 1:49=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
> On Fri, 30 Jun 2023 at 13:38, Alexander Potapenko <glider@google.com> wro=
te:
> >
> > On Fri, Jun 30, 2023 at 12:18=E2=80=AFPM Ard Biesheuvel <ardb@kernel.or=
g> wrote:
> > >
> > > On Fri, 30 Jun 2023 at 12:11, Alexander Potapenko <glider@google.com>=
 wrote:
> > > >
> > > > On Fri, Jun 30, 2023 at 12:02=E2=80=AFPM Ard Biesheuvel <ardb@kerne=
l.org> wrote:
> > > > >
> > > > > On Fri, 30 Jun 2023 at 11:53, Tetsuo Handa
> > > > > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > > > >
> > > > > > On 2023/06/30 18:36, Ard Biesheuvel wrote:
> > > > > > > Why are you sending this now?
> > > > > >
> > > > > > Just because this is currently top crasher and I can reproduce =
locally.
> > > > > >
> > > > > > > Do you have a reproducer for this issue?
> > > > > >
> > > > > > Yes. https://syzkaller.appspot.com/text?tag=3DReproC&x=3D129316=
21900000 works.
> > > > > >
> > > > >
> > > > > Could you please share your kernel config and the resulting kerne=
l log
> > > > > when running the reproducer? I'll try to reproduce locally as wel=
l,
> > > > > and see if I can figure out what is going on in the crypto layer
> > > >
> > > > The config together with the repro is available at
> > > > https://syzkaller.appspot.com/bug?extid=3D828dfc12440b4f6f305d, see=
 the
> > > > latest row of the "Crashes" table that contains a C repro.
> > >
> > > Could you explain why that bug contains ~50 reports that seem entirel=
y
> > > unrelated?
> >
> > These are some unfortunate effects of syzbot trying to deduplicate
> > bugs. There's a tradeoff between reporting every single crash
> > separately and grouping together those that have e.g. the same origin.
> > Applying this algorithm transitively results in bigger clusters
> > containing unwanted reports.
> > We'll look closer.
> >
> > > AIUI, this actual issue has not been reproduced since
> > > 2020??
> >
> > Oh, sorry, I misread the table and misinformed you. The topmost row of
> > the table is indeed the _oldest_ one.
> > Another manifestation of the bug was on 2023/05/23
> > (https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D146f66b128000=
0)
> >
>
> That one has nothing to do with networking, so I don't see how this
> patch would affect it.

I definitely have to be more attentive.
You are right that this bug report is also unrelated. Yet it is still
fine to use the build artifacts corresponding to it (which is what I
did).
I'll investigate why so many reports got clustered into this one.



> OK, thanks for the instructions.
>
> Out of curiosity - does the stack trace you cut off here include the
> BPF routine mentioned in the report?

It does:

[  151.522472][ T5865] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  151.523843][ T5865] BUG: KMSAN: uninit-value in aes_encrypt+0x15cc/0x1db=
0
[  151.525120][ T5865]  aes_encrypt+0x15cc/0x1db0
[  151.526113][ T5865]  aesti_encrypt+0x7d/0xf0
[  151.527057][ T5865]  crypto_cipher_encrypt_one+0x112/0x200
[  151.528224][ T5865]  crypto_cbcmac_digest_update+0x301/0x4b0
[  151.529459][ T5865]  shash_ahash_finup+0x66e/0xc00
[  151.530541][ T5865]  shash_async_finup+0x7f/0xc0
[  151.531542][ T5865]  crypto_ahash_finup+0x1b8/0x3e0
[  151.532583][ T5865]  crypto_ccm_auth+0x1269/0x1350
[  151.533606][ T5865]  crypto_ccm_encrypt+0x1c9/0x7a0
[  151.534650][ T5865]  crypto_aead_encrypt+0xe0/0x150
[  151.535695][ T5865]  tls_push_record+0x3bf3/0x4ec0
[  151.539491][ T5865]  bpf_exec_tx_verdict+0x46e/0x21d0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[  151.540597][ T5865]  tls_sw_do_sendpage+0x1150/0x1ad0
[  151.541594][ T5865]  tls_sw_sendpage+0x15b/0x1b0
[  151.542500][ T5865]  inet_sendpage+0x138/0x210
[  151.543365][ T5865]  kernel_sendpage+0x34c/0x6d0
[  151.544269][ T5865]  sock_sendpage+0xb0/0x160
[  151.545117][ T5865]  pipe_to_sendpage+0x304/0x3f0
[  151.546051][ T5865]  __splice_from_pipe+0x438/0xc20
[  151.547013][ T5865]  generic_splice_sendpage+0x100/0x160
[  151.548068][ T5865]  do_splice+0x213b/0x2d10
[  151.548933][ T5865]  __se_sys_splice+0x5ad/0x8f0
[  151.549851][ T5865]  __x64_sys_splice+0x11b/0x1a0
[  151.550790][ T5865]  do_syscall_64+0x41/0xc0
[  151.551646][ T5865]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  151.552773][ T5865]
[  151.553220][ T5865] Uninit was stored to memory at:
[  151.554212][ T5865]  __crypto_xor+0x171/0x1310
[  151.555062][ T5865]  crypto_cbcmac_digest_update+0x208/0x4b0
[  151.556132][ T5865]  shash_ahash_finup+0x66e/0xc00
[  151.557084][ T5865]  shash_async_finup+0x7f/0xc0
[  151.557989][ T5865]  crypto_ahash_finup+0x1b8/0x3e0
[  151.558941][ T5865]  crypto_ccm_auth+0x1269/0x1350
[  151.559874][ T5865]  crypto_ccm_encrypt+0x1c9/0x7a0
[  151.560812][ T5865]  crypto_aead_encrypt+0xe0/0x150
[  151.561749][ T5865]  tls_push_record+0x3bf3/0x4ec0
[  151.562835][ T5865]  bpf_exec_tx_verdict+0x46e/0x21d0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[  151.563967][ T5865]  tls_sw_do_sendpage+0x1150/0x1ad0
[  151.565075][ T5865]  tls_sw_sendpage+0x15b/0x1b0
[  151.566107][ T5865]  inet_sendpage+0x138/0x210
[  151.567078][ T5865]  kernel_sendpage+0x34c/0x6d0
[  151.568087][ T5865]  sock_sendpage+0xb0/0x160
[  151.568960][ T5865]  pipe_to_sendpage+0x304/0x3f0
[  151.569909][ T5865]  __splice_from_pipe+0x438/0xc20
[  151.570886][ T5865]  generic_splice_sendpage+0x100/0x160
[  151.571946][ T5865]  do_splice+0x213b/0x2d10
[  151.572810][ T5865]  __se_sys_splice+0x5ad/0x8f0
[  151.573732][ T5865]  __x64_sys_splice+0x11b/0x1a0
[  151.574664][ T5865]  do_syscall_64+0x41/0xc0
[  151.575513][ T5865]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  151.576640][ T5865]
[  151.577084][ T5865] Uninit was created at:
[  151.577949][ T5865]  __alloc_pages+0x9a4/0xe00
[  151.578849][ T5865]  alloc_pages+0xd01/0x1040
[  151.579729][ T5865]  skb_page_frag_refill+0x2bf/0x7c0
[  151.580752][ T5865]  sk_page_frag_refill+0x59/0x130
[  151.581720][ T5865]  sk_msg_alloc+0x198/0x10d0
[  151.582611][ T5865]  tls_sw_do_sendpage+0x98a/0x1ad0
[  151.583599][ T5865]  tls_sw_sendpage+0x15b/0x1b0
[  151.584535][ T5865]  inet_sendpage+0x138/0x210
[  151.585404][ T5865]  kernel_sendpage+0x34c/0x6d0
[  151.586275][ T5865]  sock_sendpage+0xb0/0x160
[  151.587099][ T5865]  pipe_to_sendpage+0x304/0x3f0
[  151.588023][ T5865]  __splice_from_pipe+0x438/0xc20
[  151.588981][ T5865]  generic_splice_sendpage+0x100/0x160
[  151.590032][ T5865]  do_splice+0x213b/0x2d10
[  151.590910][ T5865]  __se_sys_splice+0x5ad/0x8f0
[  151.591840][ T5865]  __x64_sys_splice+0x11b/0x1a0
[  151.592780][ T5865]  do_syscall_64+0x41/0xc0
[  151.593748][ T5865]  entry_SYSCALL_64_after_hwframe+0x63/0xcd



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
