Return-Path: <SRS0=1Cfx=ZR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159F0C432C3
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 18:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E33FB2082F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 18:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKYSll (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:41:41 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:41584 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKYSll (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Nov 2019 13:41:41 -0500
Received: by mail-io1-f72.google.com with SMTP id p2so11454440ioh.8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2019 10:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=80jidpt49g/pONxOu2n0U/AM8XIh1HfSkjAAlDTNwMw=;
        b=sIO28Hx2h/zUywAmCpJEZXtp7ozRa6edj/x0uw6J2pahA4JorshxYwrQbxnuLYsYhU
         OJIirRHBbTr6bQyFfYC6bRA5gzF8YpIT0C1tjFREjOWVzUY0RZeb3NtFPpux726SZq5u
         YbqA5e/5ZBeh6aOJlU5pVKhtiTIawnvJFaaF1d4k05TOcv3fsloFtVaHkbiB2dDuNM3f
         ejBflkcGgtytiVG1VWj1QgJ7pX4C0Ps9ywciyjlK70vzHH1mAJEDPc2UwV2bM4lAtAKk
         Hrzl9u/j8YcYlgGQyD+GWGBRsyjrdC6H36t/4UH4ySeGu0bO6Elis409J3fS6WnMZh5p
         QSfQ==
X-Gm-Message-State: APjAAAUDHJ/+UhqwK9ZPzLd9ZLhIsgQc/ufCWe5Z0GVN3+4V6l0ohxva
        cwXFULQJ2zJsUUdno2FpN9S+oORteN//HqGeD9ZqpBm2IsAN
X-Google-Smtp-Source: APXvYqyfUxmvjuzBXASF2cgOtcuwEsXqbA3yv4Cl/UPOFc9WoNlXUMKRtpvxEfILylI6titbC5EcmiCV/Oe2KN4vAO9FkSqDDMdW
MIME-Version: 1.0
X-Received: by 2002:a92:6611:: with SMTP id a17mr35070868ilc.208.1574706909444;
 Mon, 25 Nov 2019 10:35:09 -0800 (PST)
Date:   Mon, 25 Nov 2019 10:35:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f683660598300559@google.com>
Subject: INFO: rcu detected stall in sys_open (2)
From:   syzbot <syzbot+7ee926c5e237e614ccb1@syzkaller.appspotmail.com>
To:     bp@alien8.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b9d3d014 Add linux-next specific files for 20191122
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=116ea322e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c24c45ce29b175c
dashboard link: https://syzkaller.appspot.com/bug?extid=7ee926c5e237e614ccb1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e23986e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d6ad02e00000

Bisection is inconclusive: the first bad commit could be any of:

8ec426c7 lustre: don't set f_version in ll_readdir
ac0bf025 ima: Use i_version only when filesystem supports it
7a11ac28 ntfs: remove i_version handling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b9509ce00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7ee926c5e237e614ccb1@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 0, t=10502 jiffies, g=7137, q=12)
rcu: All QSes seen, last rcu_preempt kthread activity 10502  
(4295014020-4295003518), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor935 R  running task    23704  8896   8886 0x80004000
Call Trace:
  <IRQ>
  sched_show_task kernel/sched/core.c:5954 [inline]
  sched_show_task.cold+0x2ed/0x34e kernel/sched/core.c:5929
  print_other_cpu_stall kernel/rcu/tree_stall.h:410 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:538 [inline]
  rcu_pending kernel/rcu/tree.c:2827 [inline]
  rcu_sched_clock_irq.cold+0xaf4/0xc02 kernel/rcu/tree.c:2271
  update_process_times+0x2d/0x70 kernel/time/timer.c:1726
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1310
  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:loop2+0x1e5/0x39e
Code: 63 7b f0 f0 06 41 21 c7 45 31 f5 c4 63 7b f0 e2 0d 41 31 cf c4 63 7b  
f0 f2 16 89 d6 45 31 e6 c4 63 7b f0 e2 02 44 03 44 3c 20 <44> 09 d6 45 31  
e6 41 89 d4 44 21 ce 45 21 d4 45 01 ef 45 01 c3 44
RSP: 0018:ffff88809dacf080 EFLAGS: 00000a17 ORIG_RAX: ffffffffffffff13
RAX: 000000000d895faf RBX: 00000000af692001 RCX: 00000000c2b12cbe
RDX: 00000000398a2513 RSI: 00000000398a2513 RDI: 00000000000001c0
RBP: ffff88809dacf318 R08: 0000000023af5072 R09: 00000000d9fb4f71
R10: 00000000449125ce R11: 00000000c47f205e R12: 00000000ce628944
R13: 000000008d7843d3 R14: 00000000000d80b7 R15: 00000000cf392011
  sha256_avx2_update+0x2d/0x40 arch/x86/crypto/sha256_ssse3_glue.c:236
  crypto_shash_update+0xc9/0x120 crypto/shash.c:120
  ima_calc_file_hash_tfm+0x321/0x3e0 security/integrity/ima/ima_crypto.c:369
  ima_calc_file_shash security/integrity/ima/ima_crypto.c:389 [inline]
  ima_calc_file_hash+0x1aa/0x570 security/integrity/ima/ima_crypto.c:454
  ima_collect_measurement+0x534/0x5f0 security/integrity/ima/ima_api.c:247
  process_measurement+0xd45/0x1850 security/integrity/ima/ima_main.c:326
  ima_file_check+0xc5/0x110 security/integrity/ima/ima_main.c:442
  do_last fs/namei.c:3416 [inline]
  path_openat+0x113d/0x4710 fs/namei.c:3529
  do_filp_open+0x1a1/0x280 fs/namei.c:3559
  do_sys_open+0x3fe/0x5d0 fs/open.c:1097
  __do_sys_open fs/open.c:1115 [inline]
  __se_sys_open fs/open.c:1110 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1110
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447709
Code: e8 3c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 ab 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fce7ac54db8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00000000006ddc28 RCX: 0000000000447709
RDX: 0000000000000000 RSI: 0000000000141042 RDI: 0000000020000100
RBP: 00000000006ddc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006ddc2c
R13: 00007ffd0e67ecaf R14: 00007fce7ac559c0 R15: 0000000000000000
rcu: rcu_preempt kthread starved for 10502 jiffies! g7137 f0x2  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29272    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x8e1/0x1f30 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
  rcu_gp_fqs_loop kernel/rcu/tree.c:1661 [inline]
  rcu_gp_kthread+0x9b2/0x18d0 kernel/rcu/tree.c:1821
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
