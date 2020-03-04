Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F131C3F2CD
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 016AC2166E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 08:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgCDIIN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 03:08:13 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:36888 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDIIN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 03:08:13 -0500
Received: by mail-il1-f198.google.com with SMTP id e70so833823ill.4
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2020 00:08:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QWihqIbI3h2cwVYItSSsgDU+DanrmjhYM/cRBn7sMYM=;
        b=pCIJ5jIRXs5CWs8i6IAVZ4mMMu0UwDRBsjkMv9Azwz+NVq16aum9EJ56a2nRY52iTu
         Mf6ax7daXgnNaVGzZIlDI/3wsKZ0zIUbsMiyFBi//woI4JgBNGUm8BsZ1MGea+o29WlX
         hxNIaEc03qK+crS/sD5dzb3VpxNcIhWl/BB/eP6dgV9l4JMo98+LUJrpagBi1xztSnkB
         WRaMZigJUYlWYlss6W0lna5p5InPFLAI3exhngJZoNir/fFa2ll1i6CfkNYczqY6OvDl
         hoiE4PeCNJagfBnKhAIMT8jU9lez9NouBEmuHbHWMIvB7jf9mLFBQTK8spQf9yTLLWvS
         6KcA==
X-Gm-Message-State: ANhLgQ2/MHlXR1S9zjM4IGX08/B7I5ZYNKEaZXdIsZ4GjA6vkaVA+86R
        vcBdP5yPecHjudwzdxJL6Sy+CdIhOXK2IF6HK3MGRP4PsDyL
X-Google-Smtp-Source: ADFU+vuO5aJSyB0F3WMNwd9r/kxM2JQMSL8AbibBvCOWRnOfCodaF/8419p9BH+fF/DNjT+h/zRr0l5nq4MoEGP/MnVGS+lg5YZP
MIME-Version: 1.0
X-Received: by 2002:a02:a516:: with SMTP id e22mr1642125jam.116.1583309291096;
 Wed, 04 Mar 2020 00:08:11 -0800 (PST)
Date:   Wed, 04 Mar 2020 00:08:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd909105a002ebe6@google.com>
Subject: INFO: rcu detected stall in sys_keyctl
From:   syzbot <syzbot+0c5c2dbf76930df91489@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15257ba1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=0c5c2dbf76930df91489
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0c5c2dbf76930df91489@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (1 GPs behind) idle=576/1/0x4000000000000002 softirq=55718/56054 fqs=5235 
	(t=10500 jiffies g=63445 q=1523)
NMI backtrace for cpu 0
CPU: 0 PID: 18804 Comm: syz-executor.4 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
 rcu_pending kernel/rcu/tree.c:3030 [inline]
 rcu_sched_clock_irq.cold+0x51a/0xc37 kernel/rcu/tree.c:2276
 update_process_times+0x2d/0x70 kernel/time/timer.c:1726
 tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
 tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1119 [inline]
 smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1144
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x16/0x20 kernel/kcov.c:276
Code: 48 89 e5 48 8b 4d 08 e8 d8 fe ff ff 5d c3 66 0f 1f 44 00 00 55 89 f2 89 fe bf 05 00 00 00 48 89 e5 48 8b 4d 08 e8 ba fe ff ff <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 f2 48 89 fe bf 07 00 00 00
RSP: 0018:ffffc900053877d8 EFLAGS: 00000297 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000002 RBX: 584279fc973b765a RCX: ffffffff83b71a81
RDX: 00000000ffffff75 RSI: 0000000000000000 RDI: 0000000000000005
RBP: ffffc900053877d8 R08: ffff888041a265c0 R09: 0000000000000092
R10: ffffed1015d0707b R11: ffff8880ae8383db R12: ffff88809eb56398
R13: 000000003ab2c4e4 R14: 1b0d4377a72d08f5 R15: 00000000ffffff75
 mpihelp_submul_1+0x161/0x1a0 lib/mpi/generic_mpih-mul3.c:45
 mpihelp_divrem+0x1ce/0x1360 lib/mpi/mpih-div.c:209
 mpi_powm+0xffb/0x1d20 lib/mpi/mpi-pow.c:205
 _compute_val crypto/dh.c:39 [inline]
 dh_compute_value+0x373/0x610 crypto/dh.c:178
 crypto_kpp_generate_public_key include/crypto/kpp.h:315 [inline]
 __keyctl_dh_compute+0x9ae/0x1470 security/keys/dh.c:367
 keyctl_dh_compute+0xcf/0x12d security/keys/dh.c:422
 __do_sys_keyctl security/keys/keyctl.c:1818 [inline]
 __se_sys_keyctl security/keys/keyctl.c:1714 [inline]
 __x64_sys_keyctl+0x159/0x470 security/keys/keyctl.c:1714
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c479
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f872a51fc78 EFLAGS: 00000246 ORIG_RAX: 00000000000000fa
RAX: ffffffffffffffda RBX: 00007f872a5206d4 RCX: 000000000045c479
RDX: 0000000020002700 RSI: 0000000020000400 RDI: 0000000000000017
RBP: 000000000076bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffff84 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000006fa R14: 00000000004c9883 R15: 000000000076bfcc


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
