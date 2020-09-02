Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A569EC433E7
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 01:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8953F20707
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 01:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgIBB2X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 21:28:23 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:34429 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgIBB2W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 21:28:22 -0400
Received: by mail-il1-f199.google.com with SMTP id m1so2344643ilg.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2020 18:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YDQoAQ2h8GHSxFnWfXwXTc4FW1J0BtuD5JOXYDMkd/o=;
        b=GDTncvWwTRlLjuJXzk4nBE/q42/fwypfOCM1CnUdIuXBFwygGu95GUpcnecOjl8nJh
         8GunZy+ETtdGFLmtYc1MaSHxMghd/FFOhJshWDG/7f7Uy14LkuIdS5xjRKA2d/1yHGs7
         hU/XnIo1CvWih4YAmB/hsMy5IVZuWmwUlxYPrTzizfF2dmKzm/mAEgUWfK5Wo1fn5jvC
         S8oUCroU/Oz8MDTrJ48EscM3oGI9a29mFrEkX0HbITGmogPXkmrk73xcm70RlMbNXFAu
         PPOkoTywUh0Sa3HvRpP47iEepn+uu4T6aCviS7k7kGNU9czXnFiV3fBDOJIvRk/XWXa2
         N88g==
X-Gm-Message-State: AOAM530ycZGpwsKq45s6nOXCZT7s6xcSpXCzdeCWW5b1wju/GRC/oZco
        TZokKD8bbaBl9Cq8IXnHDAz/hgbtokAje0UNTWIelj/fDzAf
X-Google-Smtp-Source: ABdhPJz4Y5wCV12fYE6qA2XXcpPMJvtZaK1G6wgTNZsgVJJmPApC9548GY0FEs4QhpVjuv74sRaaxferECHvEU8uZ1yVYmQpscfu
MIME-Version: 1.0
X-Received: by 2002:a6b:8e8d:: with SMTP id q135mr1647100iod.52.1599010101107;
 Tue, 01 Sep 2020 18:28:21 -0700 (PDT)
Date:   Tue, 01 Sep 2020 18:28:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011b0ed05ae4a8d08@google.com>
Subject: inconsistent lock state in padata_do_parallel
From:   syzbot <syzbot+f4b9f49e38e25eb4ef52@syzkaller.appspotmail.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    96d454cd Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1015301e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978db74cb30aa994
dashboard link: https://syzkaller.appspot.com/bug?extid=f4b9f49e38e25eb4ef52
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4b9f49e38e25eb4ef52@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.9.0-rc2-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz-executor.0/26715 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffffffff89c54eb8 (padata_works_lock){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffffffff89c54eb8 (padata_works_lock){+.?.}-{2:2}, at: padata_do_parallel+0x4d7/0x860 kernel/padata.c:220
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  padata_do_parallel+0x4d7/0x860 kernel/padata.c:220
  pcrypt_aead_encrypt+0x39f/0x4d0 crypto/pcrypt.c:115
  crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
  tipc_aead_encrypt net/tipc/crypto.c:736 [inline]
  tipc_crypto_xmit+0x1868/0x2790 net/tipc/crypto.c:1607
  tipc_bearer_xmit_skb+0x180/0x3f0 net/tipc/bearer.c:523
  tipc_disc_timeout+0x84b/0xc90 net/tipc/discover.c:334
  call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
  expire_timers kernel/time/timer.c:1458 [inline]
  __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
  __run_timers kernel/time/timer.c:1736 [inline]
  run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
  __do_softirq+0x2de/0xa24 kernel/softirq.c:298
  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
  do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
  invoke_softirq kernel/softirq.c:393 [inline]
  __irq_exit_rcu kernel/softirq.c:423 [inline]
  irq_exit_rcu+0x1f3/0x230 kernel/softirq.c:435
  sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
  tomoyo_check_acl+0xad/0x410 security/tomoyo/domain.c:173
  tomoyo_path_permission security/tomoyo/file.c:586 [inline]
  tomoyo_path_permission+0x1f5/0x360 security/tomoyo/file.c:573
  tomoyo_path_perm+0x2e7/0x3f0 security/tomoyo/file.c:838
  security_inode_getattr+0xcf/0x140 security/security.c:1278
  vfs_getattr fs/stat.c:121 [inline]
  vfs_statx_fd+0x70/0xf0 fs/stat.c:151
  vfs_fstat include/linux/fs.h:3189 [inline]
  __do_sys_newfstat+0x88/0x100 fs/stat.c:398
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
irq event stamp: 311
hardirqs last  enabled at (311): [<ffffffff8146df01>] __local_bh_enable_ip+0xd1/0x190 kernel/softirq.c:200
hardirqs last disabled at (309): [<ffffffff8146dec9>] __local_bh_enable_ip+0x99/0x190 kernel/softirq.c:177
softirqs last  enabled at (310): [<ffffffff81939bcd>] rcu_read_unlock_bh include/linux/rcupdate.h:719 [inline]
softirqs last  enabled at (310): [<ffffffff81939bcd>] padata_do_parallel+0x49d/0x860 kernel/padata.c:218
softirqs last disabled at (308): [<ffffffff81939767>] padata_do_parallel+0x37/0x860 kernel/padata.c:183

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(padata_works_lock);
  <Interrupt>
    lock(padata_works_lock);

 *** DEADLOCK ***

1 lock held by syz-executor.0/26715:
 #0: ffff88804f22c120 (sk_lock-AF_ALG){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1583 [inline]
 #0: ffff88804f22c120 (sk_lock-AF_ALG){+.+.}-{0:0}, at: aead_recvmsg+0xc1/0x15c0 crypto/algif_aead.c:328

stack backtrace:
CPU: 0 PID: 26715 Comm: syz-executor.0 Not tainted 5.9.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:4020 [inline]
 valid_state kernel/locking/lockdep.c:3361 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3560 [inline]
 mark_lock.cold+0x7a/0x7f kernel/locking/lockdep.c:4006
 mark_usage kernel/locking/lockdep.c:3923 [inline]
 __lock_acquire+0x8cd/0x5640 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 padata_do_parallel+0x4d7/0x860 kernel/padata.c:220
 pcrypt_aead_encrypt+0x39f/0x4d0 crypto/pcrypt.c:115
 crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
 _aead_recvmsg crypto/algif_aead.c:310 [inline]
 aead_recvmsg+0x844/0x15c0 crypto/algif_aead.c:330
 sock_recvmsg_nosec net/socket.c:885 [inline]
 sock_recvmsg net/socket.c:903 [inline]
 sock_recvmsg net/socket.c:899 [inline]
 ____sys_recvmsg+0x2c4/0x640 net/socket.c:2576
 ___sys_recvmsg+0x127/0x200 net/socket.c:2618
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2652
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7547b83c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 0000000000026b00 RCX: 000000000045d5b9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 000000000169fb6f R14: 00007f7547b849c0 R15: 000000000118cf4c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
