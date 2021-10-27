Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33791C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A09E61056
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242140AbhJ0Ni5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 09:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242197AbhJ0Ni5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 09:38:57 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0BDC061767
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 06:36:31 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id s18-20020a0568301e1200b0054e77a16651so3598926otr.7
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 06:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wRt8TSJKf2XFyfF6HeRRA8Fcsjf8RvgcXHZHz2hidKE=;
        b=d07KZTCZN/Z5SvZwb0834lF3mfuutMvQSe69XLJcUm7SPUOE0oCjFwKxlj5HysGvCh
         lZqRkcSS4l39MPFuPTLU+wBYqWkKSDVHNzViNBpFF8cBYQed06csp4uCp/9p5qS5s7mv
         GWGmALsnysYM7mGByPvjKi6CfItRMEaomk8AhCwMNzje7KyeUaKiUgGtoT2iyqMkUdDp
         SIOLX1P14F2AEnKtnSFBLtCABht5v6ZTNPtxksx1WYF+EDCuOq82hhhNoosaUrDs/DaO
         MjTXEbstG08hcG7+3WJJiac35lc6hNrCjKK6rWVVSLzS5Z7o5411up7yyrfR/Kter7aE
         vx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wRt8TSJKf2XFyfF6HeRRA8Fcsjf8RvgcXHZHz2hidKE=;
        b=4XsBX7x62V1AQ5riOYm1MMTM7uJ8K79tKUrBV5qA2Th9BcRP2uvoUgqKy1ikVgkJfM
         RUfWVg7DYGHibbpsiheyjkiLNeaZlUb4M1UQ/f8EOoVarjOy5SA8cmzzHLpBQMXY/TcP
         vZeevC0Wm9VqNdrs1QXSPaie3gThBdsCX5b2nNC+4b38D1XrEsueS8yo+14g//Y5ZilU
         DfS/+oJrnzetiEdwQ/rV+YVgiCkjATbZx7lAp6ZVnbXIxRjxxDNg6+zFDr5upe0AGnZa
         gctbLuILLnh4gmEwD9x2tRpp6EWLVGFKk6fvJAkuiYA6+ImEp6i/Y0BdvdgFkM2qNVQ4
         G/Ag==
X-Gm-Message-State: AOAM530BOaL8QOTFX7HhX0Hxv6m/hjl5VoShtlQb5JVK/l4Uvtx52850
        H+D1A0GdusojZQnV9h3Yj0KJ/gUVrovnvUTorMcJ4W1r3iFfuA==
X-Google-Smtp-Source: ABdhPJw+wufOf2shJ+/efTDa2p/cH5pukOwDKDaqX0k/t88m8qXv09E2sslzGnwgBBvMmNVzu8vz2c+MEdkQn9p8OKo=
X-Received: by 2002:a9d:44a:: with SMTP id 68mr2739395otc.319.1635341790830;
 Wed, 27 Oct 2021 06:36:30 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a4cd2105cf441e76@google.com> <eab57f0e-d3c6-7619-97cc-9bc3a7a07219@redhat.com>
In-Reply-To: <eab57f0e-d3c6-7619-97cc-9bc3a7a07219@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 27 Oct 2021 15:36:19 +0200
Message-ID: <CACT4Y+amyT9dk-6iVqru-wQnotmwW=bt4VwaysgzjH9=PkxGww@mail.gmail.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 27 Oct 2021 at 15:11, Laurent Vivier <lvivier@redhat.com> wrote:
>
> On 26/10/2021 18:39, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
> >
> > The issue was bisected to:
> >
> > commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
> > Author: Leon Romanovsky <leonro@nvidia.com>
> > Date:   Thu Oct 21 14:16:14 2021 +0000
> >
> >      devlink: Remove not-executed trap policer notifications
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
> > Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
> >
> > ==================================================================
> > BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
> > BUG: KASAN: slab-out-of-bounds in copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
> > Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542
> >
>
> I'm not able to reproduce the problem with next-20211026 and the C reproducer.
>
> And reviewing the code in copy_data() I don't see any issue.
>
> Is it possible to know what it the VM configuration used to test it?

Hi Laurent,

syzbot used e2-standard-2 GCE VM when that happened.
You can see some info about these VMs under the "VM info" link on the dashboard.
