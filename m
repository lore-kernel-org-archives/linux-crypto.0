Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE9FC433DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 23:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA54220793
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 23:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbhABXTz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 18:19:55 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:50148 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbhABXTy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 18:19:54 -0500
Received: by mail-il1-f198.google.com with SMTP id x13so16742131ilv.16
        for <linux-crypto@vger.kernel.org>; Sat, 02 Jan 2021 15:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DbzTGlujJEXTqmX6SO3/r+HBuT/UsCQpzdiJC1Uw/Y4=;
        b=lrze0lpmKsASlgi4AxscniLv7IIWcPhGibssadwYIC1uOrUkcZ5vAzOrW1PkXDtvOK
         ZkvcLSt9o5IrSl+E+GRxdLx9n/VKZp90qgL9o0nwqOe0Do2MabJ8bjcVhu54LLqs/X1I
         m3Kng7ZrAN+jlLneWEBIV2rjY9zvp7s+iM1eV8yzL+1U0l7B/NEFNHFWUdQyV0GYPpjZ
         FfoAnCBUXzU1DMziYZ+8h6Chb7AM+egBrqfxvKyxDBa1MB5pG+MvbD33XC96WWPL2ywm
         xata0KlghNPJobhVkImTOuOhRm8/ZcSVZNhZvDG0O59KlpSBhGf9OeniYFTUTydu4mhS
         h4Pw==
X-Gm-Message-State: AOAM5325ygytV+aZtywYCoxSPYHlKvnUGxGSWyVmBwMZ9rtLB0JyJQTv
        PIqkFY38/sNY81dAB6bNe91LoPY2+vj/n+HjgoXY8W3i9U5A
X-Google-Smtp-Source: ABdhPJwsojFW+TNXcQXSa4k8MEkkVt6MfPI00jrYzgwfLxcRc0Wrva2oUl5Ghul0cd8cj6oxtSHRncePfkkCW7V6Pzh49PlJG/ou
MIME-Version: 1.0
X-Received: by 2002:a6b:f90f:: with SMTP id j15mr54554036iog.89.1609629552529;
 Sat, 02 Jan 2021 15:19:12 -0800 (PST)
Date:   Sat, 02 Jan 2021 15:19:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2d35705b7f31599@google.com>
Subject: INFO: task hung in virtio_cleanup
From:   syzbot <syzbot+1db88381b64aaa929ef6@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, mpm@selenic.com, mst@redhat.com,
        rikard.falkeborn@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cb4d9b52 usb: dwc3: drd: Improve dwc3_get_extcon() style
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=131bf58f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=151c953566c301b3
dashboard link: https://syzkaller.appspot.com/bug?extid=1db88381b64aaa929ef6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16aad077500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1647f5ff500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1db88381b64aaa929ef6@syzkaller.appspotmail.com

INFO: task kworker/1:1:32 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1     state:D stack:25200 pid:   32 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:4313 [inline]
 __schedule+0x8dc/0x1f40 kernel/sched/core.c:5064
 schedule+0xcb/0x270 kernel/sched/core.c:5143
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1854
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 virtio_cleanup+0x80/0xa0 drivers/char/hw_random/virtio-rng.c:85
 cleanup_rng drivers/char/hw_random/core.c:81 [inline]
 kref_put include/linux/kref.h:65 [inline]
 drop_current_rng+0xda/0x110 drivers/char/hw_random/core.c:109
 set_current_rng+0x2d3/0x490 drivers/char/hw_random/core.c:96
 hwrng_register+0x3bf/0x600 drivers/char/hw_random/core.c:505
 chaoskey_probe+0x886/0xc50 drivers/usb/misc/chaoskey.c:205
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x291/0xde0 drivers/base/dd.c:561
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:745
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:851
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:919
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbc4/0x1d90 drivers/base/core.c:3091
 usb_set_configuration+0x113c/0x1910 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xde0 drivers/base/dd.c:561
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:745
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:851
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:919
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbc4/0x1d90 drivers/base/core.c:3091
 usb_new_device.cold+0x71d/0xfe9 drivers/usb/core/hub.c:2555
 hub_port_connect drivers/usb/core/hub.c:5223 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 port_event drivers/usb/core/hub.c:5509 [inline]
 hub_event+0x2348/0x42d0 drivers/usb/core/hub.c:5591
 process_one_work+0x98d/0x1580 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
6 locks held by kworker/1:1/32:
 #0: ffff888103fd0538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103fd0538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888103fd0538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888103fd0538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888103fd0538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888103fd0538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x871/0x1580 kernel/workqueue.c:2246
 #1: ffffc900001a7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1580 kernel/workqueue.c:2250
 #2: ffff888108aeb218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:725 [inline]
 #2: ffff888108aeb218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x42d0 drivers/usb/core/hub.c:5537
 #3: ffff8881023fc218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:725 [inline]
 #3: ffff8881023fc218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:894
 #4: ffff8881023fd1a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:725 [inline]
 #4: ffff8881023fd1a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:894
 #5: ffffffff877ee1c8 (rng_mutex){+.+.}-{3:3}, at: hwrng_register+0x7a/0x600 drivers/char/hw_random/core.c:478
1 lock held by khungtaskd/1241:
 #0: ffffffff8744c5a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x269 kernel/locking/lockdep.c:6254
1 lock held by hwrng/1663:
 #0: ffffffff877ee1c8 (rng_mutex){+.+.}-{3:3}, at: get_current_rng drivers/char/hw_random/core.c:126 [inline]
 #0: ffffffff877ee1c8 (rng_mutex){+.+.}-{3:3}, at: hwrng_fillfn+0x3d/0x2d0 drivers/char/hw_random/core.c:438
2 locks held by in:imklog/4297:
 #0: ffff888108c64af0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:949
 #1: ffffffff8743ea78 (logbuf_lock){....}-{2:2}, at: __debug_check_no_obj_freed lib/debugobjects.c:975 [inline]
 #1: ffffffff8743ea78 (logbuf_lock){....}-{2:2}, at: debug_check_no_obj_freed+0xc7/0x420 lib/debugobjects.c:1018

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1241 Comm: khungtaskd Not tainted 5.11.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x46/0xe0 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1da/0x200 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd32/0xf70 kernel/hung_task.c:294
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 2636 Comm: systemd-journal Not tainted 5.11.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:arch_local_irq_save arch/x86/include/asm/irqflags.h:121 [inline]
RIP: 0010:lock_release+0x14d/0x6d0 kernel/locking/lockdep.c:5453
Code: 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 0a 05 00 00 45 8b 8e 1c 09 00 00 45 85 c9 0f 85 74 02 00 00 9c 8f 04 24 <fa> 48 89 da c7 44 24 40 01 00 00 00 83 e3 07 48 b8 00 00 00 00 00
RSP: 0018:ffffc90000247958 EFLAGS: 00000246
RAX: 0000000000000007 RBX: ffffffff885e153c RCX: 1ffffffff10bc2a7
RDX: 0000000000000000 RSI: ffffffff8744c4e0 RDI: ffff88810e573c9c
RBP: 1ffff92000048f2d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff87524300
R13: ffffffff81d63134 R14: ffff88810e573380 R15: 0000000000000dc0
FS:  00007fdcf82a68c0(0000) GS:ffff8881f6a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdcf562d000 CR3: 0000000101da9000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 might_alloc include/linux/sched/mm.h:193 [inline]
 slab_pre_alloc_hook mm/slab.h:493 [inline]
 slab_alloc_node mm/slub.c:2817 [inline]
 slab_alloc mm/slub.c:2900 [inline]
 kmem_cache_alloc+0x3b/0x360 mm/slub.c:2905
 kmem_cache_zalloc include/linux/slab.h:672 [inline]
 lsm_file_alloc security/security.c:569 [inline]
 security_file_alloc+0x34/0x170 security/security.c:1457
 __alloc_file+0xd8/0x280 fs/file_table.c:106
 alloc_empty_file+0x6d/0x170 fs/file_table.c:150
 path_openat+0xe3/0x2730 fs/namei.c:3357
 do_filp_open+0x17e/0x3c0 fs/namei.c:3398
 do_sys_openat2+0x16d/0x420 fs/open.c:1172
 do_sys_open fs/open.c:1188 [inline]
 __do_sys_open fs/open.c:1196 [inline]
 __se_sys_open fs/open.c:1192 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1192
 do_syscall_64+0x2d/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fdcf7836840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007ffc45a1fe78 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007ffc45a20180 RCX: 00007fdcf7836840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 000055959b084b30
RBP: 000000000000000d R08: 000000000000ffc0 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000055959b077040 R14: 00007ffc45a20140 R15: 000055959b084950


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
