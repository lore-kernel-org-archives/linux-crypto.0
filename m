Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C48C07E96
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Jul 2021 00:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD2F661CAA
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Jul 2021 00:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhGGBA6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jul 2021 21:00:58 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:38779 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhGGBA5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jul 2021 21:00:57 -0400
Received: by mail-io1-f70.google.com with SMTP id y8-20020a5e87080000b029050cfd126a26so488723ioj.5
        for <linux-crypto@vger.kernel.org>; Tue, 06 Jul 2021 17:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vZf3B/GjtO0uXvqJJFjh6duuRg13nY/82mtz/5bn2eg=;
        b=MwrPQb/s1JIWylYZPJ/ibrFz1u0CReCqT5K80R7rtAPQA9xNdfcXXYwr5QYs6vRgyr
         KmB1d6J2FgzLgOMHu76WR9ONQ1vRaSySCcnq1NLUz2iYWU7x0L3++LJRo3DWzfKILxLN
         K1W4OJNswujoH3RLhB8mU101cdNZI4kmDAdCSCXHIGhgCfkAamOAYysj2C2hxmHEAZEt
         aL0ac1kjhmL7KQ4jTRhNmd0XMlyQIOFUIm0lLpnDJXcpBSIljQoHZqplMdd2mRnVqYb0
         7DT+xPLunA7693Elz41glrdvOvdj2RBo5I3vsrYjcRtliHOwyue+XMCrhdnr62P4YV0q
         9+MQ==
X-Gm-Message-State: AOAM531EUl09XZwH1TT17Veu4WSy3pPERDIlVrtkCJO02Pe9XVJI+lre
        nud3FtpMTdYH4wGhPt7Dizeqg7TufExW4ZQcBI0mamqdsmru
X-Google-Smtp-Source: ABdhPJwm2ePla3rrFtaa4iOlr2iUMjHQkWvskTQkD18HW6EikIG57prs40cLm6Y/FzoM9vD86lMI0gFmYpxwWR59rZ000J861lFA
MIME-Version: 1.0
X-Received: by 2002:a92:db4b:: with SMTP id w11mr16165638ilq.194.1625619497084;
 Tue, 06 Jul 2021 17:58:17 -0700 (PDT)
Date:   Tue, 06 Jul 2021 17:58:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a9ed6205c67e08c6@google.com>
Subject: [syzbot] INFO: task hung in set_current_rng
From:   syzbot <syzbot+681da20be7291be15dca@syzkaller.appspotmail.com>
To:     colin.king@canonical.com, f.fangjian@huawei.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        syzkaller-bugs@googlegroups.com, tangzihao1@hisilicon.com,
        yuehaibing@huawei.com, zhangshaokun@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3dbdb38e Merge branch 'for-5.14' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=145c4c9c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1700b0b2b41cd52c
dashboard link: https://syzkaller.appspot.com/bug?extid=681da20be7291be15dca
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a472e4300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c51a28300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+681da20be7291be15dca@syzkaller.appspotmail.com

INFO: task kworker/1:0:20 blocked for more than 143 seconds.
      Tainted: G        W         5.13.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0     state:D stack:22328 pid:   20 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0xc07/0x11f0 kernel/sched/core.c:5940
 schedule+0x14b/0x210 kernel/sched/core.c:6019
 schedule_timeout+0x98/0x2f0 kernel/time/timer.c:1868
 do_wait_for_common+0x2da/0x480 kernel/sched/completion.c:85
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x48/0x60 kernel/sched/completion.c:138
 cleanup_rng drivers/char/hw_random/core.c:81 [inline]
 kref_put include/linux/kref.h:65 [inline]
 drop_current_rng drivers/char/hw_random/core.c:109 [inline]
 set_current_rng+0x421/0x610 drivers/char/hw_random/core.c:96
 hwrng_register+0x38f/0x720 drivers/char/hw_random/core.c:499
 chaoskey_probe+0x755/0xb30 drivers/usb/misc/chaoskey.c:205
 usb_probe_interface+0x633/0xb40 drivers/usb/core/driver.c:396
 really_probe+0x3cb/0x1020 drivers/base/dd.c:580
 driver_probe_device+0x175/0x340 drivers/base/dd.c:763
 bus_for_each_drv+0x16a/0x1f0 drivers/base/bus.c:431
 __device_attach+0x301/0x560 drivers/base/dd.c:938
 bus_probe_device+0xb8/0x1f0 drivers/base/bus.c:491
 device_add+0x11fc/0x1670 drivers/base/core.c:3324
 usb_set_configuration+0x1a86/0x2100 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0x83/0x140 drivers/usb/core/generic.c:238
 usb_probe_device+0x13a/0x260 drivers/usb/core/driver.c:293
 really_probe+0x3cb/0x1020 drivers/base/dd.c:580
 driver_probe_device+0x175/0x340 drivers/base/dd.c:763
 bus_for_each_drv+0x16a/0x1f0 drivers/base/bus.c:431
 __device_attach+0x301/0x560 drivers/base/dd.c:938
 bus_probe_device+0xb8/0x1f0 drivers/base/bus.c:491
 device_add+0x11fc/0x1670 drivers/base/core.c:3324
 usb_new_device+0xd45/0x1790 drivers/usb/core/hub.c:2558
 hub_port_connect+0x1055/0x27a0 drivers/usb/core/hub.c:5278
 hub_port_connect_change+0x5d0/0xbf0 drivers/usb/core/hub.c:5418
 port_event+0xaee/0x1140 drivers/usb/core/hub.c:5564
 hub_event+0x48d/0xd80 drivers/usb/core/hub.c:5646
 process_one_work+0x833/0x10c0 kernel/workqueue.c:2276
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2422
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 PID: 1638 Comm: khungtaskd Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0x1d3/0x29f lib/dump_stack.c:96
 nmi_cpu_backtrace+0x16c/0x190 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x191/0x2f0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd06/0xd50 kernel/hung_task.c:294
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 4857 Comm: systemd-journal Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__seccomp_filter+0x551/0x1f90 kernel/seccomp.c:1208
Code: 80 3c 28 00 74 08 48 89 df e8 eb 6e 48 00 4c 89 33 4c 89 e7 4c 8b 74 24 38 e9 bf 10 00 00 81 fb 00 00 f0 7f 0f 84 3c 02 00 00 <81> fb 00 00 fc 7f 0f 85 c5 03 00 00 8b 1d 6d 31 75 0b 89 de 83 e6
RSP: 0018:ffffc9000af4fbc0 EFLAGS: 00000206
RAX: 0000000000000000 RBX: 000000007fff0000 RCX: 0000000000000003
RDX: 0000000000000006 RSI: ffffffff8cf558e0 RDI: 000000007fff0000
RBP: ffffc9000af4fee8 R08: 0000000000000005 R09: ffffffff81802512
R10: 0000000000000006 R11: ffff888017249c40 R12: ffffc9000af4fdc0
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc9000af4fde0
FS:  00007fb81e94f8c0(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb81bd45018 CR3: 00000000163fa000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 syscall_trace_enter kernel/entry/common.c:68 [inline]
 __syscall_enter_from_user_work kernel/entry/common.c:90 [inline]
 syscall_enter_from_user_mode+0xf0/0x1b0 kernel/entry/common.c:108
 do_syscall_64+0x1e/0xb0 arch/x86/entry/common.c:76
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb81dbe7f17
Code: ff ff ff 48 8b 4d a0 0f b7 51 fe 48 8b 4d a8 66 89 54 08 fe e9 1a ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 b8 27 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 6e 00 00 00 0f 05 c3 0f 1f 84 00 00
RSP: 002b:00007ffce70946e8 EFLAGS: 00000202 ORIG_RAX: 0000000000000027
RAX: ffffffffffffffda RBX: 00005601e1e091e0 RCX: 00007fb81dbe7f17
RDX: 0000000000000000 RSI: 00007ffce7094800 RDI: 00005601e1e091e0
RBP: 00007ffce7094800 R08: 82fc88903cbe97aa R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000012f9
R13: 00007ffce70947a8 R14: 00007ffce7094800 R15: 00007ffce7094d98


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
