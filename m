Return-Path: <SRS0=CB0V=42=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6A7C18E5A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 15:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B55208C3
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 15:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HJecWp6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgCIPLd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Mar 2020 11:11:33 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34816 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgCIPLc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Mar 2020 11:11:32 -0400
Received: by mail-pj1-f65.google.com with SMTP id mq3so924138pjb.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2020 08:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KmA7BL+srj2+l3c7L/8DF7DGtL94PX+KpP96GTTm2NY=;
        b=HJecWp6qMkGlJfIDth1jRi3nfW0k6jl6bPwx74XtKeJs0nrfSDTvxsIYrqdqjoYrB0
         mC2JWkgTqx+B03oEBaUoSYJYXtA2l47bOzZR+g7zOt692Pz8+LA4k+fr0ObcdmKEX6Xt
         gmegKpYs7lQM1NhIHtuwH+FtJ/8JIqwwXs8WvpclCrzQ850e9svqJil3uWS9VIM7PpED
         MZTAQ+VFImsjboEgHG4/30nnC4D9FGksijAuIoYc7IMSEaILjsRN1YLOBgj9SkGRqpG1
         eobFDOwNXJsoQM8JHsUlkaU5VhLhKAubtkPyPvCyV+uelSfXChtUWqLWqQcU6No0Zdg7
         6DBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KmA7BL+srj2+l3c7L/8DF7DGtL94PX+KpP96GTTm2NY=;
        b=b/1NInPzDb1MmHH1hzcr5zTINCz1iGBR0/R1syypwZNSb6t4BUAU4xMECsEb4k+MFu
         eK1HxbimrCapWemSjRrp1IRQLKuA7vB0dGN9UsuIViC9p74K0HEWr7AZkFUAPcFkza6I
         C+6JHujWZRP301mbdTjAdUUEtjhNP6jzvjSIt/EY4odQPqvkiDjf3/II/YfRFXhFlhUB
         iXHBocbZE1dtAeLjofqPV3O2+JsZoa1Z0vm6Q5onVD+Co8CVBDIkZeHGIqLfhTmwDRpP
         KIjq1cFNgkKSevbpstVpUfnjqAuFpII92aGaZx4nMUr1GwD7Xe2ceeLmdES5tMes70xZ
         2MTA==
X-Gm-Message-State: ANhLgQ3m8mAhgiHZSURrnJxLcajvdEcDrsT8o/s8AnUKxWLJ5W2wXLg7
        iVLhD1Ydh8mCNksODwxOp3DVhU7kfDJQOKZe7VUI+w==
X-Google-Smtp-Source: ADFU+vvAQx3ODEl7ED4mitSfL2UB5jmdI4E9w2ll9tFEjKtYHc+X6onHB7zmij99sP2FKX/ULKj0IxV8GHCEuNK2HcY=
X-Received: by 2002:a17:902:9889:: with SMTP id s9mr15193056plp.252.1583766691257;
 Mon, 09 Mar 2020 08:11:31 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000996f3c059d46757a@google.com>
In-Reply-To: <000000000000996f3c059d46757a@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 9 Mar 2020 16:11:20 +0100
Message-ID: <CAAeHK+xhfd-bAwO93WZpBHe=kg2a8urACf+uuAgiabXmW7uNDQ@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in chaoskey_disconnect
To:     syzbot <syzbot+73163a4458e7367880a0@syzkaller.appspotmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
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

On Wed, Jan 29, 2020 at 1:27 PM syzbot
<syzbot+73163a4458e7367880a0@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    cd234325 usb: gadget: add raw-gadget interface
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=140e49bee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bb745005307bc641
> dashboard link: https://syzkaller.appspot.com/bug?extid=73163a4458e7367880a0
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+73163a4458e7367880a0@syzkaller.appspotmail.com
>
> usb 2-1: USB disconnect, device number 45
> ==================================================================
> BUG: KASAN: use-after-free in atomic_fetch_add include/asm-generic/atomic-instrumented.h:111 [inline]
> BUG: KASAN: use-after-free in refcount_add include/linux/refcount.h:188 [inline]
> BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:228 [inline]
> BUG: KASAN: use-after-free in get_task_struct include/linux/sched/task.h:113 [inline]
> BUG: KASAN: use-after-free in kthread_stop+0x90/0x780 kernel/kthread.c:554
> Write of size 4 at addr ffff8881ca88e220 by task kworker/0:10/18542
>
> CPU: 0 PID: 18542 Comm: kworker/0:10 Not tainted 5.5.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xef/0x16e lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
>  __kasan_report.cold+0x37/0x85 mm/kasan/report.c:506
>  kasan_report+0xe/0x20 mm/kasan/common.c:639
>  check_memory_region_inline mm/kasan/generic.c:185 [inline]
>  check_memory_region+0x152/0x1c0 mm/kasan/generic.c:192
>  atomic_fetch_add include/asm-generic/atomic-instrumented.h:111 [inline]
>  refcount_add include/linux/refcount.h:188 [inline]
>  refcount_inc include/linux/refcount.h:228 [inline]
>  get_task_struct include/linux/sched/task.h:113 [inline]
>  kthread_stop+0x90/0x780 kernel/kthread.c:554
>  hwrng_unregister+0x24f/0x330 drivers/char/hw_random/core.c:556
>  chaoskey_disconnect+0x216/0x290 drivers/usb/misc/chaoskey.c:232
>  usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
>  __device_release_driver drivers/base/dd.c:1134 [inline]
>  device_release_driver_internal+0x42f/0x500 drivers/base/dd.c:1165
>  bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:532
>  device_del+0x481/0xd30 drivers/base/core.c:2664
>  usb_disable_device+0x23d/0x790 drivers/usb/core/message.c:1237
>  usb_disconnect+0x293/0x900 drivers/usb/core/hub.c:2201
>  hub_port_connect drivers/usb/core/hub.c:5036 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5325 [inline]
>  port_event drivers/usb/core/hub.c:5471 [inline]
>  hub_event+0x1a1d/0x4300 drivers/usb/core/hub.c:5553
>  process_one_work+0x945/0x15c0 kernel/workqueue.c:2264
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2410
>  kthread+0x318/0x420 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
> Allocated by task 1824:
>  save_stack+0x1b/0x80 mm/kasan/common.c:72
>  set_track mm/kasan/common.c:80 [inline]
>  __kasan_kmalloc mm/kasan/common.c:513 [inline]
>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:486
>  slab_post_alloc_hook mm/slab.h:584 [inline]
>  slab_alloc_node mm/slub.c:2759 [inline]
>  kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2795
>  alloc_task_struct_node kernel/fork.c:169 [inline]
>  dup_task_struct kernel/fork.c:868 [inline]
>  copy_process+0x43e3/0x6710 kernel/fork.c:1911
>  _do_fork+0x12d/0xfd0 kernel/fork.c:2421
>  __do_sys_clone kernel/fork.c:2576 [inline]
>  __se_sys_clone kernel/fork.c:2557 [inline]
>  __x64_sys_clone+0x182/0x210 kernel/fork.c:2557
>  do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 1824:
>  save_stack+0x1b/0x80 mm/kasan/common.c:72
>  set_track mm/kasan/common.c:80 [inline]
>  kasan_set_free_info mm/kasan/common.c:335 [inline]
>  __kasan_slab_free+0x117/0x160 mm/kasan/common.c:474
>  slab_free_hook mm/slub.c:1425 [inline]
>  slab_free_freelist_hook mm/slub.c:1458 [inline]
>  slab_free mm/slub.c:3005 [inline]
>  kmem_cache_free+0x9b/0x360 mm/slub.c:3021
>  __put_task_struct+0x220/0x510 kernel/fork.c:751
>  put_task_struct include/linux/sched/task.h:122 [inline]
>  delayed_put_task_struct+0x22a/0x370 kernel/exit.c:182
>  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
>  rcu_do_batch kernel/rcu/tree.c:2183 [inline]
>  rcu_core+0x664/0x1e10 kernel/rcu/tree.c:2408
>  __do_softirq+0x21e/0x950 kernel/softirq.c:292
>
> The buggy address belongs to the object at ffff8881ca88e200
>  which belongs to the cache task_struct of size 6016
> The buggy address is located 32 bytes inside of
>  6016-byte region [ffff8881ca88e200, ffff8881ca88f980)
> The buggy address belongs to the page:
> page:ffffea00072a2200 refcount:1 mapcount:0 mapping:ffff8881da116000 index:0x0 compound_mapcount: 0
> raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da116000
> raw: 0000000000000000 0000000000050005 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8881ca88e100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8881ca88e180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff8881ca88e200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                ^
>  ffff8881ca88e280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881ca88e300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>

#syz dup: KASAN: use-after-free Read in chaoskey_disconnect

https://syzkaller.appspot.com/bug?id=d39d574f73e4b96265c6af6deeaff32f9bbd5ede
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
