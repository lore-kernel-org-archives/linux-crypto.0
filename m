Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2545FEB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 11:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjF3Lcw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 07:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjF3Lcv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 07:32:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37402694
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 04:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C1EC61722
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 11:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAA2C433C9;
        Fri, 30 Jun 2023 11:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688124767;
        bh=IwLRq9z+hrMdyjwQbtFHevcefMZs2+6JG3EKKH+6Ovg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gA3Li7tA6yEuixaZpRXKut5coEIAn1cFUqjO08lebl3yspyxgLE5CoH+JiOgve64C
         R4X5y5U+V8TFLZjGHqjayczFYp5nr+k9T1WsgoeUYMbJq5ZHXx9EkdUk5QCJa2DCc6
         ZSWlZMQVf3nJDpspWBM+I0JnMsvX2EhElvJ8LZ+N/3FR9GVQIhS0jmLHfRfAqeRgcm
         EF+1kVK/ol0MeDbS01a+NngSTQThlotHo3+HqI/8T/sqIxMkoO6QyuoWK1gbeyO0Rc
         Kj4yJcQcjn7fssuqsqgSBUjzkzW+ot1lVpsGCcg5UT/srAmttrhbZcLCs4q3LwCNjk
         dyh8V7conZadQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-4fb960b7c9dso2845256e87.0;
        Fri, 30 Jun 2023 04:32:47 -0700 (PDT)
X-Gm-Message-State: ABy/qLZFzQf/7bs2y3ULy6CpurgMYmAcd8goBIozPhqNrCRqIZc5bFug
        6/h6oQKpAcUoWva+HBtdAuYPnT0eLHPwemTiprs=
X-Google-Smtp-Source: APBJJlGkwz15vHDREuU6VdvcQvLujtJ8zMbb+IGFvk9AwitVG6WyV6ZsaBy1cwkIFYCJJMHYXuRioDfEB9CwZ6XQFds=
X-Received: by 2002:ac2:5e6b:0:b0:4fb:744c:2e9a with SMTP id
 a11-20020ac25e6b000000b004fb744c2e9amr1798556lfr.32.1688124765419; Fri, 30
 Jun 2023 04:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008a7ae505aef61db1@google.com> <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com> <f5c2d592-4b97-93f8-b62e-402eeeaa70d9@I-love.SAKURA.ne.jp>
In-Reply-To: <f5c2d592-4b97-93f8-b62e-402eeeaa70d9@I-love.SAKURA.ne.jp>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Jun 2023 13:32:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH6STkFX-SocCiqRgFwkQFZEG=DW6hu6H9W7Egxm2icrw@mail.gmail.com>
Message-ID: <CAMj1kXH6STkFX-SocCiqRgFwkQFZEG=DW6hu6H9W7Egxm2icrw@mail.gmail.com>
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Alexander Potapenko <glider@google.com>,
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

On Fri, 30 Jun 2023 at 13:12, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2023/06/30 19:18, Ard Biesheuvel wrote:
> > On Fri, 30 Jun 2023 at 12:11, Alexander Potapenko <glider@google.com> w=
rote:
> >>
> >> On Fri, Jun 30, 2023 at 12:02=E2=80=AFPM Ard Biesheuvel <ardb@kernel.o=
rg> wrote:
> >>>
> >>> On Fri, 30 Jun 2023 at 11:53, Tetsuo Handa
> >>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >>>>
> >>>> On 2023/06/30 18:36, Ard Biesheuvel wrote:
> >>>>> Why are you sending this now?
> >>>>
> >>>> Just because this is currently top crasher and I can reproduce local=
ly.
> >>>>
> >>>>> Do you have a reproducer for this issue?
> >>>>
> >>>> Yes. https://syzkaller.appspot.com/text?tag=3DReproC&x=3D12931621900=
000 works.
> >>>>
> >>>
> >>> Could you please share your kernel config and the resulting kernel lo=
g
> >>> when running the reproducer? I'll try to reproduce locally as well,
> >>> and see if I can figure out what is going on in the crypto layer
> >>
> >> The config together with the repro is available at
> >> https://syzkaller.appspot.com/bug?extid=3D828dfc12440b4f6f305d, see th=
e
> >> latest row of the "Crashes" table that contains a C repro.
>
> Kernel is commit e6bc8833d80f of https://github.com/google/kmsan/commits/=
master .

That commit does not exist in that repo. Does it matter?

> Config is available in the dashboard page, but a smaller one is available=
 at
> https://I-love.SAKURA.ne.jp/tmp/config-6.4.0-rc7-kmsan .
>

Thanks - I'll try to rebuild v6.4-rc7 with that.


> I'm using a debug printk() patch shown below.
>
> ----------------------------------------
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 1a53c8f481e9..b32bb015995c 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1210,7 +1210,8 @@ static int tls_sw_do_sendpage(struct sock *sk, stru=
ct page *page,
>                 if (!sk_stream_memory_free(sk))
>                         goto wait_for_sndbuf;
>  alloc_payload:
> -               ret =3D tls_alloc_encrypted_msg(sk, required_size);
> +               ret =3D tls_alloc_encrypted_msg(sk, required_size); /////
> +               pr_info("required_size=3D%d ret=3D%d\n", required_size, r=
et);
>                 if (ret) {
>                         if (ret !=3D -ENOSPC)
>                                 goto wait_for_memory;
> @@ -1232,7 +1233,9 @@ static int tls_sw_do_sendpage(struct sock *sk, stru=
ct page *page,
>
>                 tls_ctx->pending_open_record_frags =3D true;
>                 if (full_record || eor || sk_msg_full(msg_pl)) {
> -                       ret =3D bpf_exec_tx_verdict(msg_pl, sk, full_reco=
rd,
> +                       pr_info("full_record=3D%d eor=3D%d sk_msg_full(ms=
g_pl)=3D%d copied=3D%d\n",
> +                               full_record, eor, sk_msg_full(msg_pl), co=
pied);
> +                       ret =3D bpf_exec_tx_verdict(msg_pl, sk, full_reco=
rd, /////
>                                                   record_type, &copied, f=
lags);
>                         if (ret) {
>                                 if (ret =3D=3D -EINPROGRESS)
> ----------------------------------------
>
> Output (on Ubuntu 22.04 on Oracle VM VirtualBox) is shown below.
> Please check tendency of the sum of required_size=3D values up to the ful=
l_record=3D line.
> It seems that the value of required_size=3D might vary depending on the t=
imings, but
> the sum of the values seems to have some rule.
>
>   4125+8221+12317+16413=3D41076 (the lower 4 bits are 0100)
>   2461+6557+10653+14749+16413=3D50833 (the lower 4 bits are 0001)
>   2461+6573+10669+14765+16413=3D50881 (the lower 4 bits are 0001)
>
> KMSAN reports this problem when the lower 4 bits became 0001 for the seco=
nd time.
> Unless KMSAN's reporting is asynchronous, maybe the reason of "for the se=
cond time"
> part is that the previous state is relevant...
>
> ----------------------------------------
> [  157.471712][ T3414] required_size=3D4125 ret=3D0
> [  157.475879][ T3414] required_size=3D8221 ret=3D0
> [  157.480471][ T3414] required_size=3D12317 ret=3D0
> [  157.484604][ T3414] required_size=3D16413 ret=3D0
> [  157.490499][ T3414] full_record=3D1 eor=3D0 sk_msg_full(msg_pl)=3D0 co=
pied=3D4096
> [  157.513772][ T3414] required_size=3D4125 ret=3D0
> [  157.523782][ T3414] required_size=3D8221 ret=3D0
> [  157.533658][ T3414] required_size=3D12317 ret=3D0
> [  157.539579][ T3414] required_size=3D16413 ret=3D0
> [  157.543785][ T3414] full_record=3D1 eor=3D0 sk_msg_full(msg_pl)=3D0 co=
pied=3D4096
> [  157.572869][ T3414] required_size=3D4125 ret=3D0
> [  157.579350][ T3414] required_size=3D8221 ret=3D0
> [  157.584699][ T3414] required_size=3D12317 ret=3D0
> [  157.591756][ T3414] required_size=3D16413 ret=3D0
> [  157.595891][ T3414] full_record=3D1 eor=3D0 sk_msg_full(msg_pl)=3D0 co=
pied=3D4096
> [  157.790734][ T3424] required_size=3D2461 ret=3D0
> [  157.800725][ T3424] required_size=3D6557 ret=3D0
> [  157.804560][ T3424] required_size=3D10653 ret=3D0
> [  157.808433][ T3424] required_size=3D14749 ret=3D0
> [  157.810125][ T3424] required_size=3D16413 ret=3D0
> [  157.829564][ T3424] full_record=3D1 eor=3D0 sk_msg_full(msg_pl)=3D0 co=
pied=3D1664
> [  157.848397][ T3424] required_size=3D2461 ret=3D0
> [  157.854875][ T3424] required_size=3D6573 ret=3D0
> [  157.860883][ T3424] required_size=3D10669 ret=3D0
> [  157.865463][ T3424] required_size=3D14765 ret=3D0
> [  157.871794][ T3424] required_size=3D16413 ret=3D0
> [  157.877333][ T3424] full_record=3D1 eor=3D0 sk_msg_full(msg_pl)=3D0 co=
pied=3D1648
> [  157.885187][ T3424] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  157.887262][ T3424] BUG: KMSAN: uninit-value in aes_encrypt+0x1692/0x1=
fa0
> [  157.887262][ T3424]  aes_encrypt+0x1692/0x1fa0
> [  157.887262][ T3424]  aesti_encrypt+0xe1/0x160
> [  157.887262][ T3424]  crypto_cipher_encrypt_one+0x1d1/0x2e0
> [  157.887262][ T3424]  crypto_cbcmac_digest_update+0x3ff/0x5a0
> [  157.887262][ T3424]  shash_ahash_finup+0x79d/0xd00
> [  157.887262][ T3424]  shash_async_finup+0xbf/0x110
> [  157.887262][ T3424]  crypto_ahash_finup+0x244/0x500
> [  157.887262][ T3424]  crypto_ccm_auth+0x14df/0x15a0
> [  157.887262][ T3424]  crypto_ccm_encrypt+0x2ad/0x8b0
> [  157.887262][ T3424]  crypto_aead_encrypt+0x116/0x1a0
> [  157.887262][ T3424]  tls_push_record+0x2bbe/0x3bf0
> [  157.887262][ T3424]  bpf_exec_tx_verdict+0x5ba/0x2530
> [  157.887262][ T3424]  tls_sw_do_sendpage+0x1779/0x21f0
> [  157.887262][ T3424]  tls_sw_sendpage+0x247/0x2b0
> [  157.887262][ T3424]  inet_sendpage+0x1de/0x2f0
> [  157.887262][ T3424]  kernel_sendpage+0x4cc/0x940
> [  158.004827][ T3424]  sock_sendpage+0x162/0x220
> [  158.004827][ T3424]  pipe_to_sendpage+0x3df/0x4f0
> [  158.004827][ T3424]  __splice_from_pipe+0x5c7/0x1010
> [  158.004827][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
> [  158.004827][ T3424]  do_splice+0x26d8/0x32f0
> [  158.004827][ T3424]  __se_sys_splice+0x81f/0xba0
> [  158.004827][ T3424]  __x64_sys_splice+0x1a1/0x200
> [  158.004827][ T3424]  do_syscall_64+0x41/0x90
> [  158.004827][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  158.004827][ T3424]
> [  158.004827][ T3424] Uninit was stored to memory at:
> [  158.004827][ T3424]  __crypto_xor+0x285/0x1700
> [  158.004827][ T3424]  crypto_cbcmac_digest_update+0x2ba/0x5a0
> [  158.004827][ T3424]  shash_ahash_finup+0x79d/0xd00
> [  158.004827][ T3424]  shash_async_finup+0xbf/0x110
> [  158.004827][ T3424]  crypto_ahash_finup+0x244/0x500
> [  158.004827][ T3424]  crypto_ccm_auth+0x14df/0x15a0
> [  158.004827][ T3424]  crypto_ccm_encrypt+0x2ad/0x8b0
> [  158.004827][ T3424]  crypto_aead_encrypt+0x116/0x1a0
> [  158.004827][ T3424]  tls_push_record+0x2bbe/0x3bf0
> [  158.004827][ T3424]  bpf_exec_tx_verdict+0x5ba/0x2530
> [  158.004827][ T3424]  tls_sw_do_sendpage+0x1779/0x21f0
> [  158.004827][ T3424]  tls_sw_sendpage+0x247/0x2b0
> [  158.004827][ T3424]  inet_sendpage+0x1de/0x2f0
> [  158.004827][ T3424]  kernel_sendpage+0x4cc/0x940
> [  158.004827][ T3424]  sock_sendpage+0x162/0x220
> [  158.004827][ T3424]  pipe_to_sendpage+0x3df/0x4f0
> [  158.004827][ T3424]  __splice_from_pipe+0x5c7/0x1010
> [  158.004827][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
> [  158.004827][ T3424]  do_splice+0x26d8/0x32f0
> [  158.004827][ T3424]  __se_sys_splice+0x81f/0xba0
> [  158.004827][ T3424]  __x64_sys_splice+0x1a1/0x200
> [  158.004827][ T3424]  do_syscall_64+0x41/0x90
> [  158.004827][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  158.004827][ T3424]
> [  158.004827][ T3424] Uninit was created at:
> [  158.004827][ T3424]  __alloc_pages+0x925/0x1050
> [  158.004827][ T3424]  alloc_pages+0xe30/0x11b0
> [  158.004827][ T3424]  skb_page_frag_refill+0x362/0x910
> [  158.004827][ T3424]  sk_page_frag_refill+0xa2/0x1c0
> [  158.004827][ T3424]  sk_msg_alloc+0x278/0x1560
> [  158.004827][ T3424]  tls_sw_do_sendpage+0xbec/0x21f0
> [  158.004827][ T3424]  tls_sw_sendpage+0x247/0x2b0
> [  158.004827][ T3424]  inet_sendpage+0x1de/0x2f0
> [  158.004827][ T3424]  kernel_sendpage+0x4cc/0x940
> [  158.004827][ T3424]  sock_sendpage+0x162/0x220
> [  158.004827][ T3424]  pipe_to_sendpage+0x3df/0x4f0
> [  158.004827][ T3424]  __splice_from_pipe+0x5c7/0x1010
> [  158.004827][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
> [  158.260226][ T3424]  do_splice+0x26d8/0x32f0
> [  158.260226][ T3424]  __se_sys_splice+0x81f/0xba0
> [  158.260226][ T3424]  __x64_sys_splice+0x1a1/0x200
> [  158.260226][ T3424]  do_syscall_64+0x41/0x90
> [  158.260226][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  158.260226][ T3424]
> [  158.260226][ T3424] CPU: 7 PID: 3424 Comm: a.out Not tainted 6.4.0-rc7=
-ge6bc8833d80f-dirty #26
> [  158.260226][ T3424] Hardware name: innotek GmbH VirtualBox/VirtualBox,=
 BIOS VirtualBox 12/01/2006
> [  158.260226][ T3424] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  158.260226][ T3424] Disabling lock debugging due to kernel taint
> [  158.260226][ T3424] Kernel panic - not syncing: kmsan.panic set ...
> [  158.260226][ T3424] CPU: 7 PID: 3424 Comm: a.out Tainted: G    B      =
        6.4.0-rc7-ge6bc8833d80f-dirty #26
> [  158.320898][ T3424] Hardware name: innotek GmbH VirtualBox/VirtualBox,=
 BIOS VirtualBox 12/01/2006
> [  158.334186][ T3424] Call Trace:
> [  158.334186][ T3424]  <TASK>
> [  158.334186][ T3424]  dump_stack_lvl+0x1f6/0x280
> [  158.334186][ T3424]  dump_stack+0x29/0x30
> [  158.334186][ T3424]  panic+0x4e7/0xc60
> [  158.334186][ T3424]  ? add_taint+0x185/0x210
> [  158.334186][ T3424]  kmsan_report+0x2d1/0x2e0
> [  158.334186][ T3424]  ? __msan_warning+0x98/0x120
> [  158.334186][ T3424]  ? aes_encrypt+0x1692/0x1fa0
> [  158.334186][ T3424]  ? aesti_encrypt+0xe1/0x160
> [  158.334186][ T3424]  ? crypto_cipher_encrypt_one+0x1d1/0x2e0
> [  158.334186][ T3424]  ? crypto_cbcmac_digest_update+0x3ff/0x5a0
> [  158.334186][ T3424]  ? shash_ahash_finup+0x79d/0xd00
> [  158.334186][ T3424]  ? shash_async_finup+0xbf/0x110
> [  158.334186][ T3424]  ? crypto_ahash_finup+0x244/0x500
> [  158.334186][ T3424]  ? crypto_ccm_auth+0x14df/0x15a0
> [  158.334186][ T3424]  ? crypto_ccm_encrypt+0x2ad/0x8b0
> [  158.334186][ T3424]  ? crypto_aead_encrypt+0x116/0x1a0
> [  158.334186][ T3424]  ? tls_push_record+0x2bbe/0x3bf0
> [  158.334186][ T3424]  ? bpf_exec_tx_verdict+0x5ba/0x2530
> [  158.334186][ T3424]  ? tls_sw_do_sendpage+0x1779/0x21f0
> [  158.334186][ T3424]  ? tls_sw_sendpage+0x247/0x2b0
> [  158.334186][ T3424]  ? inet_sendpage+0x1de/0x2f0
> [  158.334186][ T3424]  ? kernel_sendpage+0x4cc/0x940
> [  158.334186][ T3424]  ? sock_sendpage+0x162/0x220
> [  158.334186][ T3424]  ? pipe_to_sendpage+0x3df/0x4f0
> [  158.334186][ T3424]  ? __splice_from_pipe+0x5c7/0x1010
> [  158.334186][ T3424]  ? generic_splice_sendpage+0x1c6/0x2a0
> [  158.334186][ T3424]  ? do_splice+0x26d8/0x32f0
> [  158.334186][ T3424]  ? __se_sys_splice+0x81f/0xba0
> [  158.334186][ T3424]  ? __x64_sys_splice+0x1a1/0x200
> [  158.334186][ T3424]  ? do_syscall_64+0x41/0x90
> [  158.334186][ T3424]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  158.334186][ T3424]  ? filter_irq_stacks+0xb9/0x230
> [  158.334186][ T3424]  ? __stack_depot_save+0x22/0x490
> [  158.334186][ T3424]  ? kmsan_internal_set_shadow_origin+0x66/0xe0
> [  158.334186][ T3424]  ? kmsan_internal_chain_origin+0x110/0x120
> [  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
> [  158.334186][ T3424]  __msan_warning+0x98/0x120
> [  158.334186][ T3424]  aes_encrypt+0x1692/0x1fa0
> [  158.334186][ T3424]  aesti_encrypt+0xe1/0x160
> [  158.334186][ T3424]  crypto_cipher_encrypt_one+0x1d1/0x2e0
> [  158.334186][ T3424]  ? aesti_set_key+0xb0/0xb0
> [  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
> [  158.334186][ T3424]  crypto_cbcmac_digest_update+0x3ff/0x5a0
> [  158.334186][ T3424]  ? crypto_cbcmac_digest_init+0x140/0x140
> [  158.334186][ T3424]  shash_ahash_finup+0x79d/0xd00
> [  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
> [  158.334186][ T3424]  shash_async_finup+0xbf/0x110
> [  158.334186][ T3424]  crypto_ahash_finup+0x244/0x500
> [  158.334186][ T3424]  ? shash_async_final+0x3d0/0x3d0
> [  158.334186][ T3424]  crypto_ccm_auth+0x14df/0x15a0
> [  158.334186][ T3424]  crypto_ccm_encrypt+0x2ad/0x8b0
> [  158.334186][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
> [  158.334186][ T3424]  ? crypto_ccm_setauthsize+0x100/0x100
> [  158.334186][ T3424]  crypto_aead_encrypt+0x116/0x1a0
> [  158.653332][ T3424]  tls_push_record+0x2bbe/0x3bf0
> [  158.653332][ T3424]  bpf_exec_tx_verdict+0x5ba/0x2530
> [  158.653332][ T3424]  ? _printk+0x181/0x1b0
> [  158.653332][ T3424]  ? tls_sw_do_sendpage+0xc81/0x21f0
> [  158.653332][ T3424]  tls_sw_do_sendpage+0x1779/0x21f0
> [  158.653332][ T3424]  tls_sw_sendpage+0x247/0x2b0
> [  158.653332][ T3424]  ? tls_sw_do_sendpage+0x21f0/0x21f0
> [  158.653332][ T3424]  inet_sendpage+0x1de/0x2f0
> [  158.653332][ T3424]  ? inet_sendmsg+0x1d0/0x1d0
> [  158.653332][ T3424]  kernel_sendpage+0x4cc/0x940
> [  158.653332][ T3424]  sock_sendpage+0x162/0x220
> [  158.653332][ T3424]  pipe_to_sendpage+0x3df/0x4f0
> [  158.653332][ T3424]  ? sock_fasync+0x240/0x240
> [  158.653332][ T3424]  __splice_from_pipe+0x5c7/0x1010
> [  158.653332][ T3424]  ? generic_splice_sendpage+0x2a0/0x2a0
> [  158.653332][ T3424]  generic_splice_sendpage+0x1c6/0x2a0
> [  158.653332][ T3424]  ? iter_file_splice_write+0x1a30/0x1a30
> [  158.653332][ T3424]  do_splice+0x26d8/0x32f0
> [  158.653332][ T3424]  ? kmsan_get_shadow_origin_ptr+0x4d/0xa0
> [  158.653332][ T3424]  ? __se_sys_splice+0x292/0xba0
> [  158.653332][ T3424]  ? __msan_metadata_ptr_for_load_8+0x24/0x40
> [  158.653332][ T3424]  ? filter_irq_stacks+0xb9/0x230
> [  158.653332][ T3424]  __se_sys_splice+0x81f/0xba0
> [  158.870673][ T3424]  __x64_sys_splice+0x1a1/0x200
> [  158.870673][ T3424]  do_syscall_64+0x41/0x90
> [  158.870673][ T3424]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  158.870673][ T3424] RIP: 0033:0x7f6bbd51ea3d
> [  158.895223][ T3424] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f=
 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08=
 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 a3 0f 00 f7 d8 64 89 01 48
> [  158.895223][ T3424] RSP: 002b:00007f6bbd731e08 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000113
> [  158.895223][ T3424] RAX: ffffffffffffffda RBX: 000055ccd9ea6080 RCX: 0=
0007f6bbd51ea3d
> [  158.895223][ T3424] RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0=
000000000000003
> [  158.895223][ T3424] RBP: 000055ccd9ea41f4 R08: 00080000fffffffc R09: 0=
000000000000000
> [  158.895223][ T3424] R10: 0000000000000000 R11: 0000000000000246 R12: 0=
100000000000000
> [  158.895223][ T3424] R13: e65b75b4ec4292eb R14: f2300cdb85a45425 R15: 0=
00055ccd9ea6088
> [  159.041467][ T3424]  </TASK>
> [  159.041467][ T3424] Kernel Offset: disabled
> [  159.041467][ T3424] Rebooting in 10 seconds..
> ----------------------------------------
>
> >
> > Could you explain why that bug contains ~50 reports that seem entirely
> > unrelated? AIUI, this actual issue has not been reproduced since
> > 2020??
>
> Multiple different bugs are reported as the same problem.
> Reproducer is available for only bpf_exec_tx_verdict() one, and the repro=
ducer still works.
>
> >
> >
> >> Config: https://syzkaller.appspot.com/text?tag=3DKernelConfig&x=3Dee5f=
7a0b2e48ed66
> >> Report: https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D13252=
60d900000
> >> Syz repro: https://syzkaller.appspot.com/text?tag=3DReproSyz&x=3D11af9=
73e900000
> >> C repro: https://syzkaller.appspot.com/text?tag=3DReproC&x=3D163a1e459=
00000
> >>
> >> The bug is reproducible for me locally as well (and Tetsuo's patch
> >> makes it disappear, although I have no opinion on its correctness).
> >
> > What I'd like to do is run a kernel plus initrd locally in OVMF and
> > reproduce the issue - can I do that without all the syzkaller
> > machinery?
>
> I'm using Ubuntu 22.04 on Oracle VM VirtualBox.
> I don't know if this can be reproduced with kernel plus initrd only. But
> since the C reproducer is standalone, syzkaller machinery is not involved=
.
>
