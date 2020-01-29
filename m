Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40951C35240
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 12:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 172832071E
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 12:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgA2M1S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 07:27:18 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:32812 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgA2M1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 07:27:10 -0500
Received: by mail-il1-f197.google.com with SMTP id s9so12888847ilk.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jan 2020 04:27:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=x2c2rAUs5VjWNl2yVpMiXXd6LGKNk8O648CMLyi/yxs=;
        b=WfNUOzpkjnfPgtnlsjvfw3qMyy9v9ALRJzZIlgwCZBL6eBEE/E6RbWBCj16Xi129OV
         0BvjuQPXy15+VXeizwJdmqLCvvsDMn9TPshhOM8yHvWaXw2gXUfU2FFM4F7NZaXcBPYm
         YDs/6JWZN+nxbWEBqEhD4cjt6MWiyu4F9Rp4KzjEYAPH9yD2d6u9Lx7lrDLa9Gbgg735
         cuqmlTzbhYvuHeAeGBRK4RAQTwAAohTINsOMMuCquOVb4zGTUj8xla2y4VVwoHYepnv7
         RqubYPhjnqgst6VLRK0jFH9bAuuzu6kG5AK+VsEdUJfKHTYiM/ueojOpW+CxA21GO+sa
         J1Eg==
X-Gm-Message-State: APjAAAVLg4V9g/4q6ZXPPZGAD+fUitd0hn6KOCM7WUvclH/+wy9bHLzU
        lm5QlU2x1ALow2UjKPvEEsJGRhturDslo/BVfqQ32r9OZwgm
X-Google-Smtp-Source: APXvYqy/vSrWy9MZoQS72VuYFVeLhSUiZRHRekQs1zZiXtmnAz1jlL1FLLfxa/VhRcEv5gf8cg+Dl8N9Fc2cXjhbsDyIjihK+7Zu
MIME-Version: 1.0
X-Received: by 2002:a92:5806:: with SMTP id m6mr24436789ilb.234.1580300829812;
 Wed, 29 Jan 2020 04:27:09 -0800 (PST)
Date:   Wed, 29 Jan 2020 04:27:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000996f3c059d46757a@google.com>
Subject: KASAN: use-after-free Write in chaoskey_disconnect
From:   syzbot <syzbot+73163a4458e7367880a0@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lvivier@redhat.com, mchehab+samsung@kernel.org, mpm@selenic.com,
        swboyd@chromium.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd234325 usb: gadget: add raw-gadget interface
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=140e49bee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb745005307bc641
dashboard link: https://syzkaller.appspot.com/bug?extid=73163a4458e7367880a0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+73163a4458e7367880a0@syzkaller.appspotmail.com

usb 2-1: USB disconnect, device number 45
==================================================================
BUG: KASAN: use-after-free in atomic_fetch_add include/asm-generic/atomic-instrumented.h:111 [inline]
BUG: KASAN: use-after-free in refcount_add include/linux/refcount.h:188 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:228 [inline]
BUG: KASAN: use-after-free in get_task_struct include/linux/sched/task.h:113 [inline]
BUG: KASAN: use-after-free in kthread_stop+0x90/0x780 kernel/kthread.c:554
Write of size 4 at addr ffff8881ca88e220 by task kworker/0:10/18542

CPU: 0 PID: 18542 Comm: kworker/0:10 Not tainted 5.5.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x85 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x152/0x1c0 mm/kasan/generic.c:192
 atomic_fetch_add include/asm-generic/atomic-instrumented.h:111 [inline]
 refcount_add include/linux/refcount.h:188 [inline]
 refcount_inc include/linux/refcount.h:228 [inline]
 get_task_struct include/linux/sched/task.h:113 [inline]
 kthread_stop+0x90/0x780 kernel/kthread.c:554
 hwrng_unregister+0x24f/0x330 drivers/char/hw_random/core.c:556
 chaoskey_disconnect+0x216/0x290 drivers/usb/misc/chaoskey.c:232
 usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:1134 [inline]
 device_release_driver_internal+0x42f/0x500 drivers/base/dd.c:1165
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:532
 device_del+0x481/0xd30 drivers/base/core.c:2664
 usb_disable_device+0x23d/0x790 drivers/usb/core/message.c:1237
 usb_disconnect+0x293/0x900 drivers/usb/core/hub.c:2201
 hub_port_connect drivers/usb/core/hub.c:5036 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5325 [inline]
 port_event drivers/usb/core/hub.c:5471 [inline]
 hub_event+0x1a1d/0x4300 drivers/usb/core/hub.c:5553
 process_one_work+0x945/0x15c0 kernel/workqueue.c:2264
 worker_thread+0x96/0xe20 kernel/workqueue.c:2410
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 1824:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:486
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc_node mm/slub.c:2759 [inline]
 kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2795
 alloc_task_struct_node kernel/fork.c:169 [inline]
 dup_task_struct kernel/fork.c:868 [inline]
 copy_process+0x43e3/0x6710 kernel/fork.c:1911
 _do_fork+0x12d/0xfd0 kernel/fork.c:2421
 __do_sys_clone kernel/fork.c:2576 [inline]
 __se_sys_clone kernel/fork.c:2557 [inline]
 __x64_sys_clone+0x182/0x210 kernel/fork.c:2557
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 1824:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:474
 slab_free_hook mm/slub.c:1425 [inline]
 slab_free_freelist_hook mm/slub.c:1458 [inline]
 slab_free mm/slub.c:3005 [inline]
 kmem_cache_free+0x9b/0x360 mm/slub.c:3021
 __put_task_struct+0x220/0x510 kernel/fork.c:751
 put_task_struct include/linux/sched/task.h:122 [inline]
 delayed_put_task_struct+0x22a/0x370 kernel/exit.c:182
 __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
 rcu_do_batch kernel/rcu/tree.c:2183 [inline]
 rcu_core+0x664/0x1e10 kernel/rcu/tree.c:2408
 __do_softirq+0x21e/0x950 kernel/softirq.c:292

The buggy address belongs to the object at ffff8881ca88e200
 which belongs to the cache task_struct of size 6016
The buggy address is located 32 bytes inside of
 6016-byte region [ffff8881ca88e200, ffff8881ca88f980)
The buggy address belongs to the page:
page:ffffea00072a2200 refcount:1 mapcount:0 mapping:ffff8881da116000 index:0x0 compound_mapcount: 0
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da116000
raw: 0000000000000000 0000000000050005 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881ca88e100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881ca88e180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881ca88e200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff8881ca88e280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881ca88e300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
