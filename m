Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FF2EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 15:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjF3PR7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 11:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjF3PRl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 11:17:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F56F49FA
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 08:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20C1561773
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 15:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C02C433C8;
        Fri, 30 Jun 2023 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688138180;
        bh=AfDywCb2+AWTCrpWQEU0+M02rOsm/xUaTET5Eh90bBc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=F/kLkGR/taZXcopd/ScaWwpB1BhQ3KKxPL3b5Ud9RuF3PbVq6oj0esTVWglVuflEX
         XOuSuC3dVm1i2iO9rXHr0hVIqXZ11276AV7Fe0FieNS5IIXEEXMpo4PkTcK5BGdhth
         Jxe9nKkD3WQD/7xbilj8PHE4xWUbPCy9YwUx/P5oWSFqzko65J07/2dxleEWdNuHzK
         +UwRhfuQd4inzCeFcdAL2qVP4LZNfbUYS0N0dDnBXl1gJkpDwOy5GBi/IL0Z7Dy2Pz
         4raHECfMX9HuXHoXe5iVvJ62OoZ8gGr9NuSRFjdHTaS6TALmhFg+xCOfPAZupGhTW2
         rQv9ktYlsIYdg==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2b6a5fd1f46so30834951fa.1;
        Fri, 30 Jun 2023 08:16:20 -0700 (PDT)
X-Gm-Message-State: ABy/qLYOBdkjXimnrIx34b3O2KhdY8a1zrnHBuUwS2wXROH3lVPuJg3B
        ALq2tUiggxdnlRvtOhEbN6TZ0xSipezQ2SDE01w=
X-Google-Smtp-Source: APBJJlGLMq3/U2kGaqB9ONlDo3ecq4EmzB3lqqvjDoOmAWTUO+DmY2cp0AoehE7m9E0IrYAoDv9WZX29Wdemp8ht2HM=
X-Received: by 2002:ac2:5bd0:0:b0:4f8:6600:4074 with SMTP id
 u16-20020ac25bd0000000b004f866004074mr2674183lfn.17.1688138178555; Fri, 30
 Jun 2023 08:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008a7ae505aef61db1@google.com> <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
 <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com>
 <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com> <CAG_fn=UWZWc+FZ_shCr+T9Y3gV9Bue-ZFHKJj78YXBq3JfnUKA@mail.gmail.com>
In-Reply-To: <CAG_fn=UWZWc+FZ_shCr+T9Y3gV9Bue-ZFHKJj78YXBq3JfnUKA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Jun 2023 17:16:06 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE_PjQT6+A9a0Y=ZfbOr_H+umYSqHuRrM6AT_gFJxxP1w@mail.gmail.com>
Message-ID: <CAMj1kXE_PjQT6+A9a0Y=ZfbOr_H+umYSqHuRrM6AT_gFJxxP1w@mail.gmail.com>
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

On Fri, 30 Jun 2023 at 13:55, Alexander Potapenko <glider@google.com> wrote=
:
>
> On Fri, Jun 30, 2023 at 1:49=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> =
wrote:
> >
> > On Fri, 30 Jun 2023 at 13:38, Alexander Potapenko <glider@google.com> w=
rote:
> > >
> > > On Fri, Jun 30, 2023 at 12:18=E2=80=AFPM Ard Biesheuvel <ardb@kernel.=
org> wrote:
> > > >
> > > > On Fri, 30 Jun 2023 at 12:11, Alexander Potapenko <glider@google.co=
m> wrote:
> > > > >
> > > > > On Fri, Jun 30, 2023 at 12:02=E2=80=AFPM Ard Biesheuvel <ardb@ker=
nel.org> wrote:
> > > > > >
> > > > > > On Fri, 30 Jun 2023 at 11:53, Tetsuo Handa
> > > > > > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > > > > >
> > > > > > > On 2023/06/30 18:36, Ard Biesheuvel wrote:
> > > > > > > > Why are you sending this now?
> > > > > > >
> > > > > > > Just because this is currently top crasher and I can reproduc=
e locally.
> > > > > > >
> > > > > > > > Do you have a reproducer for this issue?
> > > > > > >
> > > > > > > Yes. https://syzkaller.appspot.com/text?tag=3DReproC&x=3D1293=
1621900000 works.
> > > > > > >
> > > > > >
> > > > > > Could you please share your kernel config and the resulting ker=
nel log
> > > > > > when running the reproducer? I'll try to reproduce locally as w=
ell,
> > > > > > and see if I can figure out what is going on in the crypto laye=
r
> > > > >
> > > > > The config together with the repro is available at
> > > > > https://syzkaller.appspot.com/bug?extid=3D828dfc12440b4f6f305d, s=
ee the
> > > > > latest row of the "Crashes" table that contains a C repro.
> > > >
> > > > Could you explain why that bug contains ~50 reports that seem entir=
ely
> > > > unrelated?
> > >
> > > These are some unfortunate effects of syzbot trying to deduplicate
> > > bugs. There's a tradeoff between reporting every single crash
> > > separately and grouping together those that have e.g. the same origin=
.
> > > Applying this algorithm transitively results in bigger clusters
> > > containing unwanted reports.
> > > We'll look closer.
> > >
> > > > AIUI, this actual issue has not been reproduced since
> > > > 2020??
> > >
> > > Oh, sorry, I misread the table and misinformed you. The topmost row o=
f
> > > the table is indeed the _oldest_ one.
> > > Another manifestation of the bug was on 2023/05/23
> > > (https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D146f66b1280=
000)
> > >
> >
> > That one has nothing to do with networking, so I don't see how this
> > patch would affect it.
>
> I definitely have to be more attentive.
> You are right that this bug report is also unrelated. Yet it is still
> fine to use the build artifacts corresponding to it (which is what I
> did).
> I'll investigate why so many reports got clustered into this one.
>
>
>
> > OK, thanks for the instructions.
> >
> > Out of curiosity - does the stack trace you cut off here include the
> > BPF routine mentioned in the report?
>
> It does:
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
> [  151.529459][ T5865]  shash_ahash_finup+0x66e/0xc00
> [  151.530541][ T5865]  shash_async_finup+0x7f/0xc0
> [  151.531542][ T5865]  crypto_ahash_finup+0x1b8/0x3e0
> [  151.532583][ T5865]  crypto_ccm_auth+0x1269/0x1350
> [  151.533606][ T5865]  crypto_ccm_encrypt+0x1c9/0x7a0
> [  151.534650][ T5865]  crypto_aead_encrypt+0xe0/0x150
> [  151.535695][ T5865]  tls_push_record+0x3bf3/0x4ec0
> [  151.539491][ T5865]  bpf_exec_tx_verdict+0x46e/0x21d0
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> [  151.540597][ T5865]  tls_sw_do_sendpage+0x1150/0x1ad0

OK, so after poking around a little bit, I have managed to confirm
that the problem is in the TLS layer, and I am a bit out of my depth
debugging that.

With the debugging code below applied, KMSAN triggers on an
uninit-memory in the input scatterlist provided by the TLS layer into
the CCM code.

[  148.375852][ T2424] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  148.377269][ T2424] BUG: KMSAN: uninit-value in tls_push_record+0x2d9f/0=
x3eb0
[  148.378623][ T2424]  tls_push_record+0x2d9f/0x3eb0
[  148.379559][ T2424]  bpf_exec_tx_verdict+0x5ba/0x2530
[  148.380534][ T2424]  tls_sw_do_sendpage+0x169c/0x1f80
[  148.381519][ T2424]  tls_sw_sendpage+0x247/0x2b0
...
[  148.411559][ T2424]
[  148.412108][ T2424] Bytes 0-15 of 16 are uninitialized
[  148.413379][ T2424] Memory access of size 16 starts at ffff8880157889c7

Note that this is the *input* scatterlist containing the AAD
(additional authenticated data) and the crypto input, and so there is
definitely a bug here that shouldn't be papered over by zero'ing the
allocation.

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -543,6 +543,21 @@ static int tls_do_encryption(struct sock *sk,
        list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
        atomic_inc(&ctx->encrypt_pending);

+       {
+               int len =3D aead_req->assoclen + aead_req->cryptlen;
+               struct sg_mapping_iter miter;
+
+               sg_miter_start(&miter, rec->sg_aead_in,
+                              sg_nents(rec->sg_aead_in),
+                              SG_MITER_TO_SG | SG_MITER_ATOMIC);
+
+               while (len > 0 && sg_miter_next(&miter)) {
+                       kmsan_check_memory(miter.addr, min(len,
(int)miter.length));
+                       len -=3D miter.length;
+               }
+               sg_miter_stop(&miter);
+       }
+

The reason that this cascades all the way down to the AES cipher code
appears to be that sbox substitution involves array indexing, which is
one of the actions KMSAN qualifies as 'use' of uninit data.
