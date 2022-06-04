Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A318C433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jun 2022 08:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiFDIqf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Jun 2022 04:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiFDIqe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Jun 2022 04:46:34 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846351DA41
        for <linux-crypto@vger.kernel.org>; Sat,  4 Jun 2022 01:46:32 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id y2-20020a056602164200b00668dc549adbso4207905iow.18
        for <linux-crypto@vger.kernel.org>; Sat, 04 Jun 2022 01:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EAmEsme5YYFJiKes3V7u3zWV9aQvc7Sy9ZCLt3bKslQ=;
        b=HswnmzaWQNr8KhfKmT9Z+mtsjGesAdO6tUJ/giVJsKJOg1kvFvKloNcbNdCNoi9XF+
         R0T6yX2x2ln9eeIM7k2wdx+IoK6PaOLC/dJHi8DbGMPOG3rI6RD9ySoVmJ7AEvknyWbD
         874irfRDrmn4rT/eKKipXJDkFPzl9deRIEF095pd56BsQhFESsJDW7jXbZhJ3jzdkIiX
         iAnG+fSCyQ6M25i680UxkBzytARGXk+xBBkLNU1eAwVSj7A5rtFdmYIlxXmj/1CFYWlE
         Q1NYs8TilzRNNkY69YuPbmaUGohBDGrONPhOVcdUVknXsdyaiqN3rNP0TFZTpQ+axRZl
         /0nQ==
X-Gm-Message-State: AOAM531eeOjV8JlX537tXNniPS8ceNVFrSEAHqyJQ11RMSQ5il3wsvqn
        MxuHkLplnczXh+PXpqFzsUbBGbPu32fxNqlC2O/JWnjVgH4G
X-Google-Smtp-Source: ABdhPJzS0AbZ70DQXCvSEeq+2tJHbjhi5IHr7BHbtltlgRjjeXnAyu1zSKp0UsiOd2KaW+tuwMu00XTvwc59QSVs1XhkIzYanr1x
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d86:b0:330:c1e4:d91d with SMTP id
 l6-20020a0566380d8600b00330c1e4d91dmr7719881jaj.278.1654332391858; Sat, 04
 Jun 2022 01:46:31 -0700 (PDT)
Date:   Sat, 04 Jun 2022 01:46:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008ea7ac05e09b46a6@google.com>
Subject: [syzbot] upstream boot error: INFO: task hung in hwrng_register
From:   syzbot <syzbot+6da75abeed821109137b@syzkaller.appspotmail.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@dominikbrodowski.net,
        llvm@lists.linux.dev, mpm@selenic.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    032dcf09e2bf Merge tag 'gpio-fixes-for-v5.19-rc1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14409a93f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99f457384a4fea79
dashboard link: https://syzkaller.appspot.com/bug?extid=6da75abeed821109137b
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6da75abeed821109137b@syzkaller.appspotmail.com

INFO: task swapper/0:1 blocked for more than 143 seconds.
      Not tainted 5.18.0-syzkaller-13760-g032dcf09e2bf #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:swapper/0       state:D stack:21080 pid:    1 ppid:     0 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0x957/0xec0 kernel/sched/core.c:6428
 schedule+0xeb/0x1b0 kernel/sched/core.c:6500
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6559
 __mutex_lock_common+0xecf/0x26c0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 add_early_randomness drivers/char/hw_random/core.c:69 [inline]
 hwrng_register+0x3bf/0x680 drivers/char/hw_random/core.c:599
 virtrng_scan+0x3e/0x90 drivers/char/hw_random/virtio-rng.c:205
 virtio_dev_probe+0xa03/0xba0 drivers/virtio/virtio.c:313
 call_driver_probe+0x96/0x250
 really_probe+0x220/0x940 drivers/base/dd.c:634
 __driver_probe_device+0x1f4/0x3f0 drivers/base/dd.c:764
 driver_probe_device+0x50/0x240 drivers/base/dd.c:794
 __driver_attach+0x35f/0x5a0 drivers/base/dd.c:1163
 bus_for_each_dev+0x188/0x1f0 drivers/base/bus.c:301
 bus_add_driver+0x32f/0x600 drivers/base/bus.c:618
 bus_add_driver+0x32f/0x600 drivers/base/bus.c:618
 driver_register+0x2e9/0x3e0 drivers/base/driver.c:240
 do_one_initcall+0xbd/0x2b0 init/main.c:1295
 do_initcall_level+0x168/0x218 init/main.c:1368
 do_initcalls+0x4b/0x8c init/main.c:1384
 kernel_init_freeable+0x43a/0x5c3 init/main.c:1610
 kernel_init+0x19/0x2b0 init/main.c:1499
 ret_from_fork+0x1f/0x30
 </TASK>

Showing all locks held in the system:
2 locks held by swapper/0/1:
 #0: ffff8881468d4170 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff8881468d4170 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1054 [inline]
 #0: ffff8881468d4170 (&dev->mutex){....}-{3:3}, at: __driver_attach+0x353/0x5a0 drivers/base/dd.c:1162
 #1: ffffffff8d24ccc8 (reading_mutex){+.+.}-{3:3}, at: add_early_randomness drivers/char/hw_random/core.c:69 [inline]
 #1: ffffffff8d24ccc8 (reading_mutex){+.+.}-{3:3}, at: hwrng_register+0x3bf/0x680 drivers/char/hw_random/core.c:599
2 locks held by pr/ttyS0/16:
1 lock held by khungtaskd/29:
 #0: ffffffff8cb1eee0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
2 locks held by kworker/u4:4/56:
 #0: ffff888011c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc900013e7d00 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
1 lock held by hwrng/755:
 #0: ffffffff8d24ccc8 (reading_mutex){+.+.}-{3:3}, at: hwrng_fillfn+0xec/0x470 drivers/char/hw_random/core.c:503

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
