Return-Path: <SRS0=CB0V=42=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3CCC10F27
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 15:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C18E22522
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 15:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d8BKpmAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCIPMg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Mar 2020 11:12:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35624 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCIPMg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Mar 2020 11:12:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id 7so4841786pgr.2
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2020 08:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QBCq+EzDEm5BPLMQXJO8/XI24XGMIDyYld7AIG2Dzqs=;
        b=d8BKpmAPrxtcToG0UILmzKFgpJQ8Mwfg2mwDLoiIz+KyqBx0RENrKeENwgY8UlMDfI
         YpIkoyB9x3zZaOs3ZSYpa8Nd+byCleYBVZSlfWDrOU7PARBxdtFeqfUGddW0cSynLquZ
         XXvta11TbIbxhzXIKvm3siSYWOiPzfU/9zTTOAIa15PxsNAwoe0WyQnISHvWB/JaoD4p
         wCnZ/tmwZknIH7boM+yi5ygzK6QsKfOsM6egw45hf3FxGPfvHWHf31aTSFE9QhE2bzwx
         hB47TGFAtr5dE6KxpHdiYIqvoGjtCIs1a+eQpdYT2SWSGiIM6Lxl05U+X9laQoNpJ/DY
         uBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QBCq+EzDEm5BPLMQXJO8/XI24XGMIDyYld7AIG2Dzqs=;
        b=Z6rLwWDThPiW3vDqdXhfycnRLmWFEELzjOi5WMvsx43mn+OeoqlhmyYl3bxSbptOmr
         bQgmWVZsr++34USu/EZSks0ramE548JZw7zFyvw4K7CUV7WP3ddNRVhLnWRnWFYVW0FG
         XGOE+pwNwVbuNVs1ZJD47HX+rSQ5ieyulLoVXmqJOO8hi7Q6WIVEtdcmYxgu85DI1ffH
         /TZErrX8FfxzOQw2JVA065jNT+ztlhkkeSkKjjCyrKx4CidKGZt+e9D4CD6ik31g9lfI
         g137z+pR3lFCS+Nj+lN8c5UA8eHphi8tAg0+HzrBt1tTSIdQ86Zhk0FPTLf6bNUlgiri
         lK5A==
X-Gm-Message-State: ANhLgQ1HN9tzjj4TqZnfkvBtFYdh/enAimKKMtt0P1YnJI3VLvF1PEVe
        o1480OdbTtaAR26U6/pa/riA7i0415AYuAAbOL8+rA==
X-Google-Smtp-Source: ADFU+vsAkRbR5uatz9RNEcryLjeXBH2gunjlYG1dPrCy7uNKiA+PH4b+flx2s6CTNzbjWr87km1vyF38sPPCDG7lwmc=
X-Received: by 2002:a63:a062:: with SMTP id u34mr17261015pgn.286.1583766754313;
 Mon, 09 Mar 2020 08:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009a2b62059879c830@google.com>
In-Reply-To: <0000000000009a2b62059879c830@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 9 Mar 2020 16:12:23 +0100
Message-ID: <CAAeHK+zouOgHjcbkTQ8ust_t_aFL3oPRLeH8gNBkJeSco710yA@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in chaoskey_disconnect
To:     syzbot <syzbot+8632e5cd5a4e644e5745@syzkaller.appspotmail.com>
Cc:     alexandre.belloni@bootlin.com, Arnd Bergmann <arnd@arndb.de>,
        b.zolnierkie@samsung.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, lvivier@redhat.com,
        mchehab+samsung@kernel.org, mpm@selenic.com, swboyd@chromium.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 29, 2019 at 11:35 AM syzbot
<syzbot+8632e5cd5a4e644e5745@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    da06441b usb: gadget: add raw-gadget interface
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=10dd88eee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=99c88c44660624e7
> dashboard link: https://syzkaller.appspot.com/bug?extid=8632e5cd5a4e644e5745
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+8632e5cd5a4e644e5745@syzkaller.appspotmail.com
>
> usb 3-1: USB disconnect, device number 46
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in atomic_read
> include/asm-generic/atomic-instrumented.h:26 [inline]
> BUG: KASAN: slab-out-of-bounds in refcount_inc_not_zero_checked+0x72/0x1e0
> lib/refcount.c:123
> Read of size 4 at addr ffff8881d2771820 by task kworker/1:4/3303
>
> CPU: 1 PID: 3303 Comm: kworker/1:4 Not tainted 5.4.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xca/0x13e lib/dump_stack.c:113
>   print_address_description.constprop.0+0x36/0x50 mm/kasan/report.c:374
>   __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:506
>   kasan_report+0xe/0x20 mm/kasan/common.c:634
>   check_memory_region_inline mm/kasan/generic.c:185 [inline]
>   check_memory_region+0x128/0x190 mm/kasan/generic.c:192
>   atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
>   refcount_inc_not_zero_checked+0x72/0x1e0 lib/refcount.c:123
>   refcount_inc_checked+0x12/0x60 lib/refcount.c:156
>   get_task_struct include/linux/sched/task.h:110 [inline]
>   kthread_stop+0x6c/0x610 kernel/kthread.c:554
>   hwrng_unregister+0x190/0x210 drivers/char/hw_random/core.c:538
>   chaoskey_disconnect+0x1b2/0x200 drivers/usb/misc/chaoskey.c:232
>   usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
>   __device_release_driver drivers/base/dd.c:1134 [inline]
>   device_release_driver_internal+0x42f/0x500 drivers/base/dd.c:1165
>   bus_remove_device+0x2dc/0x4a0 drivers/base/bus.c:532
>   device_del+0x420/0xb20 drivers/base/core.c:2376
>   usb_disable_device+0x211/0x690 drivers/usb/core/message.c:1237
>   usb_disconnect+0x284/0x8d0 drivers/usb/core/hub.c:2200
>   hub_port_connect drivers/usb/core/hub.c:5035 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5324 [inline]
>   port_event drivers/usb/core/hub.c:5470 [inline]
>   hub_event+0x16f2/0x3800 drivers/usb/core/hub.c:5552
>   process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
>   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
>   kthread+0x318/0x420 kernel/kthread.c:255
>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
> Allocated by task 25070:
>   save_stack+0x1b/0x80 mm/kasan/common.c:69
>   set_track mm/kasan/common.c:77 [inline]
>   __kasan_kmalloc mm/kasan/common.c:510 [inline]
>   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:483
>   kmalloc_node include/linux/slab.h:599 [inline]
>   kvmalloc_node+0x61/0xf0 mm/util.c:564
>   kvmalloc include/linux/mm.h:670 [inline]
>   seq_buf_alloc fs/seq_file.c:32 [inline]
>   seq_read+0x805/0x10f0 fs/seq_file.c:204
>   kernfs_fop_read+0xe9/0x560 fs/kernfs/file.c:251
>   __vfs_read+0x76/0x100 fs/read_write.c:425
>   vfs_read+0x1ea/0x430 fs/read_write.c:461
>   ksys_read+0x127/0x250 fs/read_write.c:587
>   do_syscall_64+0xb7/0x580 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 25070:
>   save_stack+0x1b/0x80 mm/kasan/common.c:69
>   set_track mm/kasan/common.c:77 [inline]
>   kasan_set_free_info mm/kasan/common.c:332 [inline]
>   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:471
>   slab_free_hook mm/slub.c:1424 [inline]
>   slab_free_freelist_hook mm/slub.c:1475 [inline]
>   slab_free mm/slub.c:3025 [inline]
>   kfree+0xe4/0x320 mm/slub.c:3977
>   kvfree+0x59/0x60 mm/util.c:593
>   seq_release+0x4f/0x80 fs/seq_file.c:360
>   kernfs_fop_release+0xf2/0x190 fs/kernfs/file.c:780
>   __fput+0x2d7/0x840 fs/file_table.c:280
>   task_work_run+0x13f/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>   exit_to_usermode_loop+0x1d2/0x200 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x45f/0x580 arch/x86/entry/common.c:300
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8881d2770000
>   which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 2080 bytes to the right of
>   4096-byte region [ffff8881d2770000, ffff8881d2771000)
> The buggy address belongs to the page:
> page:ffffea000749dc00 refcount:1 mapcount:0 mapping:ffff8881da00c280
> index:0x0 compound_mapcount: 0
> flags: 0x200000000010200(slab|head)
> raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da00c280
> raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8881d2771700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8881d2771780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > ffff8881d2771800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                                 ^
>   ffff8881d2771880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8881d2771900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

Most likely:

#syz dup: KASAN: use-after-free Read in chaoskey_disconnect

https://syzkaller.appspot.com/bug?id=d39d574f73e4b96265c6af6deeaff32f9bbd5ede
