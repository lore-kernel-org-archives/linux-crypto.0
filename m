Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1362DC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 10:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB55663211
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 10:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhKOKNc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbhKOKMs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 05:12:48 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6D0C061746
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 02:09:40 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id o15-20020a9d410f000000b0055c942cc7a0so26560180ote.8
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 02:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjxaQQAlP137GPcg7neUj3SWU2e+pxtE3HKBOPV3JdQ=;
        b=NzVOqEsSDaO9mCUH4qXmz+xyTienfK7XMGLeAkRKj2IzpM2AGkZb8+JpaYYGiZWZR8
         uqqvrA8JfOITXlAkjlaNBPc1iY6lNSwKRcKZNOdt+HyKL3XlcZcOhMNrzwLkUxieooFE
         J2wc5mnC1OMXRNsgjbl+lQESXvrsCAWQDG1acz7Zo0u9AohZ0OJGQizdAIePR6VKnc0X
         WW/a9zuexzYjltl2klzT+k3t+3GfIVwrgCXjLoeKoRu0ps33IbhCrwUoNAVC2KCe2fco
         pewFaNH8M8qi32K/i7jazBc4hlgnqjMLrP43s3bbfPMKZzoqI7uZ6cFfl9Tyvu61QG4E
         ffJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjxaQQAlP137GPcg7neUj3SWU2e+pxtE3HKBOPV3JdQ=;
        b=gqiDkq4gNhovotfzCV/LzmEuWfxFOhvSAsA9K3Ed/quu3mSLX/mXGOv109BWYjU8gg
         /ZLZhkymlYjWQm8RQA+sRxogHVQv9pTwjmZormFgBy5AJGTwio30MQWHUmodbclfT1gS
         p7shLLfYH3N5ijcHyc3J3pEonAaeVswxptFQmybe3EOzft7X91STKnuBcA/vMaSxcud/
         93KTDxkYmleMEZ2D0E5gE4Vvs5Oacizxl4Xzh6f9neygVznp5gBmV3W8KzCGhG5GYePn
         coiprqGod6WQQR/ixXIESiwF4h9Nl0cb7xNP2ZGM6z2/ch7Ogej8LaCr26kMh7nNxOx9
         +0fQ==
X-Gm-Message-State: AOAM5303OUrOEjCdwSCEHmBp4bp8Joxy2e9kh6BcPPuHTnqJRhIOSi8c
        Tcowz00laBT8DeknVlAsTLds+fAWU6LAhTRjEBPivw==
X-Google-Smtp-Source: ABdhPJwGcrYnf+NB6iN80f6JjshEqP2H3y1O+o3D//32tHQgeu7qbsBzw4jy850txIU+80oZj38AgWEjEv7jfivh3to=
X-Received: by 2002:a05:6830:1356:: with SMTP id r22mr30067230otq.196.1636970979616;
 Mon, 15 Nov 2021 02:09:39 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003991b905c9cb527a@google.com> <00000000000089a5e805d0916571@google.com>
In-Reply-To: <00000000000089a5e805d0916571@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 15 Nov 2021 11:09:28 +0100
Message-ID: <CACT4Y+anuf4qTHm05JiQ0ShsH__vjgoOhbB12L9VOTRsZapCtQ@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in hwrng_register
To:     syzbot <syzbot+fa0abe20d13faf06353d@syzkaller.appspotmail.com>
Cc:     f.fangjian@huawei.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvivier@redhat.com, mpm@selenic.com, mst@redhat.com,
        syzkaller-bugs@googlegroups.com, tangzihao1@hisilicon.com,
        yuehaibing@huawei.com, zhangshaokun@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 12 Nov 2021 at 07:16, syzbot
<syzbot+fa0abe20d13faf06353d@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 2bb31abdbe55742c89f4dc0cc26fcbc8467364f6
> Author: Laurent Vivier <lvivier@redhat.com>
> Date:   Thu Oct 28 10:11:09 2021 +0000
>
>     hwrng: virtio - don't wait on cleanup
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d4141ab00000
> start commit:   f8e6dfc64f61 Merge tag 'net-5.14-rc6' of git://git.kernel...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=171d57d5a48c8cad
> dashboard link: https://syzkaller.appspot.com/bug?extid=fa0abe20d13faf06353d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cfe231300000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: hwrng: virtio - don't wait on cleanup
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks reasonable:

#syz fix: hwrng: virtio - don't wait on cleanup
