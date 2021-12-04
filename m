Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE736C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Dec 2021 09:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354962AbhLDJd5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Dec 2021 04:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236112AbhLDJd4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Dec 2021 04:33:56 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BD9C061751
        for <linux-crypto@vger.kernel.org>; Sat,  4 Dec 2021 01:30:31 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so6677184otu.10
        for <linux-crypto@vger.kernel.org>; Sat, 04 Dec 2021 01:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eLphoARnpNhDXvL/GS5YL9RgcLOE5n6S5NZrlzfMofM=;
        b=llOAXJm5MzQYiE+MazC9mn/XoF6LdmtNr6HngrGBE+8Y1lx89AKnq42S7r0ajFUQyv
         wFNZgOPvvg7juRdE9iSDCd27+HZkVl6OSwF+UwGReFjSamzHAEHKGJnXPhNS4sVaYvVo
         7kruoaIHHNbgeLeun8UKl5Xd7XaGD2TMVOFmJic0DqmtjELZpZdECrgMJsUh5wUMAXkd
         V7teXsptQWlO+fYxVvRGivJk+x1wH1Wg3JmW0QJ7ZHMLazx45NUN+14EGg6jBcF7er89
         QbsaE/oamYMXXFeG6JLN+hW0qUdS0qv0S7NsL5u9u2Rvc/AXri17V/WWDk24uwTzuLj1
         9GXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eLphoARnpNhDXvL/GS5YL9RgcLOE5n6S5NZrlzfMofM=;
        b=QFeN7i76tCu/l1ECiWUuQHwLo0VH1JznH/AAR215qnScSPfWGOs4hCc1dYhmtjA+qO
         ZHfzfkLU6DAZtNfrNZBAuia36Brx1k0M+91qRFo42cOslBx4oF7tvuHI1HdXcZkiLr44
         2yIkvA98N++K76Gisd6QTae0XuFlimUEk5eThdPXcwW51MMBIYzhQOd53o86MY82PnAv
         BlVvKFipzU72qJ1PuPP9sgk3X/ZFeAiVrnWdNU3NgQFDwZLEqZCWtJfXemeDDTc3xGLq
         AkUJs45gHXBqo3nGKXHrUbwHJW8cfH6QjKlGArthC7RC3XZWwYQTJD9sqn4Rb7FOfwtF
         KPnA==
X-Gm-Message-State: AOAM532Hq2TVrhUVdsy6yrINOgVcxMgLT1PO49nJ7dgNgDCjvS6p+VNY
        r5pxmZ8pa3ce/qOPIX2+LEjiqmtASqS7MxrVMZhgbw==
X-Google-Smtp-Source: ABdhPJxWLMXNiseULS8xzg2rcQuqSyZ333C5GChbK035qBdy0M3bFTiSm/PagUOPjuOGCwafbdcw4FOLEMTUuB7OECw=
X-Received: by 2002:a05:6830:1356:: with SMTP id r22mr20127609otq.196.1638610230450;
 Sat, 04 Dec 2021 01:30:30 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a9ed6205c67e08c6@google.com> <0000000000006ce3ce05d220c008@google.com>
In-Reply-To: <0000000000006ce3ce05d220c008@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 4 Dec 2021 10:30:19 +0100
Message-ID: <CACT4Y+ZJHZKD4S4CNM1L1QK2ZDdUW5DAGtUocZp1GxrGwAH1dA@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in set_current_rng
To:     syzbot <syzbot+681da20be7291be15dca@syzkaller.appspotmail.com>
Cc:     colin.king@canonical.com, f.fangjian@huawei.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvivier@redhat.com, mpm@selenic.com,
        mst@redhat.com, syzkaller-bugs@googlegroups.com,
        tangzihao1@hisilicon.com, yuehaibing@huawei.com,
        zhangshaokun@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2 Dec 2021 at 03:43, syzbot
<syzbot+681da20be7291be15dca@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 2bb31abdbe55742c89f4dc0cc26fcbc8467364f6
> Author: Laurent Vivier <lvivier@redhat.com>
> Date:   Thu Oct 28 10:11:09 2021 +0000
>
>     hwrng: virtio - don't wait on cleanup
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=171ad129b00000
> start commit:   3dbdb38e2869 Merge branch 'for-5.14' of git://git.kernel.o..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1700b0b2b41cd52c
> dashboard link: https://syzkaller.appspot.com/bug?extid=681da20be7291be15dca
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a472e4300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c51a28300000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: hwrng: virtio - don't wait on cleanup
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection


Sounds reasonable:

#syz fix: hwrng: virtio - don't wait on cleanup
