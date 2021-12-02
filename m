Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E89AC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Dec 2021 02:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354958AbhLBCqf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Dec 2021 21:46:35 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:49130 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354817AbhLBCqe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Dec 2021 21:46:34 -0500
Received: by mail-io1-f70.google.com with SMTP id g23-20020a6be617000000b005e245747fb4so31239817ioh.15
        for <linux-crypto@vger.kernel.org>; Wed, 01 Dec 2021 18:43:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=861cFVE9yMdYZPPo4IwcsubtwbX+fHJmIXiFQWVSCVs=;
        b=jOriu2O2+6n0IUrzMnQru9ZMh8W2SqS5uET5U/hdzDqMCthUR4v3Qf6A49TVg8Uo1g
         r62bbSkBk9IxfJAM6YW7CvzxqnD68g6Y2E9gCOvbethdMWyRCua/F0gHAgPtUbthug6X
         uptpZV86d++VmB/Ls4/4oDZWPBSi524DE5Raaw/eFxeNqpSh3LZDTF+Ex+oxO5MDsxuP
         6e+y/N8NreRzpN1lCYwfCe0lB+U2mBlOa4Cd2L5/MWS8jXWvAEUoCZQJuXpPezpF7fLd
         DfdVO0UW5d1aEFE7bQG/op4q1s2ARM+/vd1YqTxTzEwd1TSuCS3DuzZ4Pd5h+LSZ3bg/
         9ElQ==
X-Gm-Message-State: AOAM532qpeiwkGFg4vS1Yy8mxfNCrt9rEQDpvmQGiVsW6S3V8guDHfLs
        Dpz2/wrKsSI/hOK40E8IwsrGTScBHLEoxouWuXq1L1Qh7N5C
X-Google-Smtp-Source: ABdhPJxVfkKZsgfrINxKH5d4qFILdmhdRAQ0bMdMTA9hk0hIyISa2bFgV0QjyA1RbVRq73PcuziBvpRfxBy8TZQoJiHDDvP1WQUE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b84:: with SMTP id h4mr13487031ili.215.1638412992699;
 Wed, 01 Dec 2021 18:43:12 -0800 (PST)
Date:   Wed, 01 Dec 2021 18:43:12 -0800
In-Reply-To: <000000000000a9ed6205c67e08c6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ce3ce05d220c008@google.com>
Subject: Re: [syzbot] INFO: task hung in set_current_rng
From:   syzbot <syzbot+681da20be7291be15dca@syzkaller.appspotmail.com>
To:     colin.king@canonical.com, f.fangjian@huawei.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvivier@redhat.com, mpm@selenic.com,
        mst@redhat.com, syzkaller-bugs@googlegroups.com,
        tangzihao1@hisilicon.com, yuehaibing@huawei.com,
        zhangshaokun@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 2bb31abdbe55742c89f4dc0cc26fcbc8467364f6
Author: Laurent Vivier <lvivier@redhat.com>
Date:   Thu Oct 28 10:11:09 2021 +0000

    hwrng: virtio - don't wait on cleanup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=171ad129b00000
start commit:   3dbdb38e2869 Merge branch 'for-5.14' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1700b0b2b41cd52c
dashboard link: https://syzkaller.appspot.com/bug?extid=681da20be7291be15dca
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a472e4300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c51a28300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: hwrng: virtio - don't wait on cleanup

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
