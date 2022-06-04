Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29C6C433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jun 2022 08:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbiFDIr3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Jun 2022 04:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiFDIr2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Jun 2022 04:47:28 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332D213E9F
        for <linux-crypto@vger.kernel.org>; Sat,  4 Jun 2022 01:47:27 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id z19-20020a05660200d300b0066583f8cf2eso4246193ioe.2
        for <linux-crypto@vger.kernel.org>; Sat, 04 Jun 2022 01:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UaHwaU32taiyTeqT8kxlZyvHpAtVYBA32xb/CMdfweI=;
        b=3F+iMpii5E2tVtt7f9rpv8fnukeazXfeG3vxDVvW/7AXfVtOHKPATv4ta1QqkZpSuO
         6GtYvspAhBQ4AGcZN0lwyvur+EMTHHEID0MP/xODsMJ/AY1BsyoL9Kal9QWdnacRdAN/
         rD1steVw55wCf6oS3k2NpG/G/zekrXyy4m/qrHmUFMmswcBxmLl4+g65n3RmcJBUIrFL
         CyJlz9pmuLyk/RMwxyAD9tpQ1K/5MsxIPcZp2rM6vk0EERNx41nEbJL3/QIX9T8gkzeh
         4UyHh2Y2FvuWMYPXBQ3zr7KpquXWlDvKPPBpIqhLdd4mruZy0NdY0plVpx28V3k+CiWy
         azfg==
X-Gm-Message-State: AOAM532reziZ1CLPz/IoRFkVQzHpm2R5V/QwHqwhYTzyytKB/ygPuVmf
        EhQiHkm3FcUgkQF9Rk8YC1rmMD+5qaZOOsCsIHQVRi25JYrg
X-Google-Smtp-Source: ABdhPJyAou73aeSVYPW0jEuJolTephhgRV6INYY4gg4SViXrhc5p6kyFkiRKMnSNFFcvGaScqCF/YbV1zyvIvowtdeSF5PxmCd97
MIME-Version: 1.0
X-Received: by 2002:a6b:5a16:0:b0:668:cab7:c6d5 with SMTP id
 o22-20020a6b5a16000000b00668cab7c6d5mr6464357iob.214.1654332446626; Sat, 04
 Jun 2022 01:47:26 -0700 (PDT)
Date:   Sat, 04 Jun 2022 01:47:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d268b905e09b4915@google.com>
Subject: [syzbot] upstream boot error: INFO: task hung in add_early_randomness
From:   syzbot <syzbot+760e6f85822d8b6bc5ae@syzkaller.appspotmail.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@dominikbrodowski.net,
        mpm@selenic.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    032dcf09e2bf Merge tag 'gpio-fixes-for-v5.19-rc1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1457b6dbf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3096247591885bfa
dashboard link: https://syzkaller.appspot.com/bug?extid=760e6f85822d8b6bc5ae
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+760e6f85822d8b6bc5ae@syzkaller.appspotmail.com

INFO: task swapper/0:1 blocked for more than 143 seconds.
      Not tainted 5.18.0-syzkaller-13760-g032dcf09e2bf #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:swapper/0       state:D stack:22136 pid:    1 ppid:     0 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0xa00/0x4b30 kernel/sched/core.c:6428
 schedule+0xd2/0x1f0 kernel/sched/core.c:6500
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6559
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa70/0x1350 kernel/locking/mutex.c:747
 add_early_randomness+0x1a/0x170 drivers/char/hw_random/core.c:69
 hwrng_register+0x399/0x510 drivers/char/hw_random/core.c:599
 virtrng_scan+0x37/0x90 drivers/char/hw_random/virtio-rng.c:205
 virtio_dev_probe+0x639/0x910 drivers/virtio/virtio.c:313
 call_driver_probe drivers/base/dd.c:555 [inline]
 really_probe+0x23e/0xb90 drivers/base/dd.c:634
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:764
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:794
 __driver_attach+0x22d/0x550 drivers/base/dd.c:1163
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
 bus_add_driver+0x422/0x640 drivers/base/bus.c:618
 driver_register+0x220/0x3a0 drivers/base/driver.c:240
 do_one_initcall+0x103/0x650 init/main.c:1295
 do_initcall_level init/main.c:1368 [inline]
 do_initcalls init/main.c:1384 [inline]
 do_basic_setup init/main.c:1403 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1610
 kernel_init+0x1a/0x1d0 init/main.c:1499
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>

Showing all locks held in the system:
2 locks held by swapper/0/1:
 #0: ffff8881460e2170 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff8881460e2170 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1054 [inline]
 #0: ffff8881460e2170 (&dev->mutex){....}-{3:3}, at: __driver_attach+0x222/0x550 drivers/base/dd.c:1162
 #1: ffffffff8c832d88 (reading_mutex){+.+.}-{3:3}, at: add_early_randomness+0x1a/0x170 drivers/char/hw_random/core.c:69
2 locks held by kworker/u4:0/8:
 #0: ffff888011869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888011869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888011869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888011869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888011869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888011869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc900000d7da8 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
2 locks held by pr/ttyS0/16:
1 lock held by khungtaskd/29:
 #0: ffffffff8bd86be0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6491
1 lock held by hwrng/756:
 #0: ffffffff8c832d88 (reading_mutex){+.+.}-{3:3}, at: hwrng_fillfn+0x141/0x370 drivers/char/hw_random/core.c:503

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
