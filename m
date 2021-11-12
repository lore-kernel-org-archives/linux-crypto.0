Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB76BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 06:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8CD060F42
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 06:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhKLGTK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 01:19:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:47071 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhKLGTG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 01:19:06 -0500
Received: by mail-io1-f72.google.com with SMTP id z21-20020a5e8615000000b005e22e531c8aso5595595ioj.13
        for <linux-crypto@vger.kernel.org>; Thu, 11 Nov 2021 22:16:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=h95aiI2OL6pv1tC2hySS8sQH6YMt5Au+h2zaEiTNf9I=;
        b=k3317/Sh4L4dFgjMzt0u7YBMSIiDG82RAsRGysNgRff2lz4rDj/v0AycW3v+lJYnOp
         4sbYbDs/+49xr3Md8On4YkUXDKsODeqD4MDEDS//zL3rS9uQcf0BP5crufBFcmRWsf4z
         /y2aigNB/l4YOODwtHVKYFUdLuEi229HmsPTjiTuhDQS0RbJBf+njFzhPaqkyNBHbmZF
         mChdHMkOEyi+s+RROBYnqffFtSfJSgvRVd30Amfl/kmp7IVi9u3HJsxLYIMKiU7dg2Qr
         f0ddAYXGAuVSmA2bEY6I8hInjk3C5uozyTOkYeLTS6+ai3KzX/7vino+yVALfYipo2bg
         c51g==
X-Gm-Message-State: AOAM532K5QixSXMm1NR+Of320X7WAX1qqLEWTfHIQVeMoR+RazEe9Tg3
        Vft8WI8PriqWRkOJJFeygfVh7KyZUnCLHNJHPg5ktDJCgKng
X-Google-Smtp-Source: ABdhPJwv38CoU5xFFHLAfMljQmhviZ0VQHuWT5jYXeqzV9JTP0D7iodZtEDh0DaBNHjBTsUZE61GqMmigEYSnELQ7Rq0Rd1doAEE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0e:: with SMTP id l14mr7470656ilh.8.1636697775906;
 Thu, 11 Nov 2021 22:16:15 -0800 (PST)
Date:   Thu, 11 Nov 2021 22:16:15 -0800
In-Reply-To: <0000000000003991b905c9cb527a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000089a5e805d0916571@google.com>
Subject: Re: [syzbot] INFO: task hung in hwrng_register
From:   syzbot <syzbot+fa0abe20d13faf06353d@syzkaller.appspotmail.com>
To:     f.fangjian@huawei.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvivier@redhat.com, mpm@selenic.com, mst@redhat.com,
        syzkaller-bugs@googlegroups.com, tangzihao1@hisilicon.com,
        yuehaibing@huawei.com, zhangshaokun@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 2bb31abdbe55742c89f4dc0cc26fcbc8467364f6
Author: Laurent Vivier <lvivier@redhat.com>
Date:   Thu Oct 28 10:11:09 2021 +0000

    hwrng: virtio - don't wait on cleanup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d4141ab00000
start commit:   f8e6dfc64f61 Merge tag 'net-5.14-rc6' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=171d57d5a48c8cad
dashboard link: https://syzkaller.appspot.com/bug?extid=fa0abe20d13faf06353d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cfe231300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: hwrng: virtio - don't wait on cleanup

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
