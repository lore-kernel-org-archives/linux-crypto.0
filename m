Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB91D7DA93
	for <linux-crypto@vger.kernel.org>; Sun, 29 Jun 2025 04:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751172566; cv=none; b=CMEqewzcukCSED0nz6Tf0XP3EsuvYtJghO/7wqq+Nqc/QAL+TxZi8S8Bung6O1LwrfEJX/cjpD1zxsbklqX+W6wcPjPjaxHG0tr+t/YNPYxGvqgfk+VM2lYXEUR6op9xE3odN3f6xPC23q19jg1MRkXz0l2Yyk6zyyqWNYkbWlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751172566; c=relaxed/simple;
	bh=/G+1vAbo4n+EqcDzwn0O2XGd7JR4h2NC/9qwvEBUQaQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u7h5YK+FSb10K/aX2fQDyQdmIbj5dZSQ1W0c3zs5MulxCtJ84yWZOZPpOntH0keRGwklSNE+Y8asi9iVqtAYvZZZTzgFQtUMaEgrxsN2oWJ7HObHuSxDR0ApxqMI4YoQ04KjnwDbUX6QPM24HjDabR+pPEdx0sVM9RMVvyeRYT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3de0dc57859so15186885ab.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Jun 2025 21:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751172564; x=1751777364;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P2mY2eamG78sGsn3j8Cd+B3ncgAl4vhBnOUZVJt6TG8=;
        b=jYeI8cIVer5pcTIej7QBVOj43ciYNdPLQhdxIKcGUvab0QrAj1o1oqFQseaDih37fE
         Hj1RF1eHx8m4+73JWJ2tYmHovhqnXcKRnGCQ28Z5h8GrcU3DZryzdKG21RR/U/IcLQGl
         CfRQ1Fa9g0N4aGQELdG1uGWO+CB26kg2Nsj3BFSsK8AwdCSp79dzH3SId9ZH/xRSBN72
         7eTF6ucwopvNrtgS29Yp8eWv2aPB/7jtmjOh/GJglnlE/uWIaKmTWL0LBsT/lHFqYPlV
         dSoh8G4GXP3xX6Na9K6An2TEVWcsqo8eE2/yZbYVr6q+xnPiOXUec3ICLpYymkeHTfHH
         3lgg==
X-Forwarded-Encrypted: i=1; AJvYcCVSRiLX7SD35xBEiuzOEe6BTmFotRl5KYT3iOGO17oU+rn7s3gWNPVMFfuEo1EgYpbij6IcwUyOkj/BX14=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrrenxZVlo6jo3IieBrmHK6mJAB7qZ1jt4Qt8vf9F2+RdQK+s3
	/VuV21keL+ISUJQURsy8rgYVBbbSqDm45tgHorxqp6aDy/Zqj2eL0+RzKUMqBmsbH1t4VWuXjuQ
	CCASiZzTSgJ4Ksi4rvUklY2zxXOgFiGgD8jOfpsLEO0q/zqJ3c7YNZQbK7VU=
X-Google-Smtp-Source: AGHT+IEDNwpVGLB58tw/xoj7Yro64h0VmQPbfvdd9zILkoAkCF8gPPqTLDcgooR46dJkY6VxiAQMb+CrLdF6evqDG5SuETe3RBNw
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214a:b0:3df:3926:88b7 with SMTP id
 e9e14a558f8ab-3df4ab5672cmr88761325ab.5.1751172563896; Sat, 28 Jun 2025
 21:49:23 -0700 (PDT)
Date: Sat, 28 Jun 2025 21:49:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6860c5d3.a00a0220.c1739.0009.GAE@google.com>
Subject: [syzbot] [crypto?] possible deadlock in padata_do_serial
From: syzbot <syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com>
To: daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, steffen.klassert@secunet.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ae2aaafb214 Add linux-next specific files for 20250624
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10deb70c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d85d3c440a754f86
dashboard link: https://syzkaller.appspot.com/bug?extid=bd936ccd4339cea66e6b
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/689f558e5251/disk-2ae2aaaf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/355aae0f4972/vmlinux-2ae2aaaf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/94e736ebe604/bzImage-2ae2aaaf.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
6.16.0-rc3-next-20250624-syzkaller #0 Not tainted
--------------------------------------------
kworker/u8:11/20346 is trying to acquire lock:
ffffe8ffffd55fd8 (&pd_list->lock){+...}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffffe8ffffd55fd8 (&pd_list->lock){+...}-{3:3}, at: padata_find_next kernel/padata.c:256 [inline]
ffffe8ffffd55fd8 (&pd_list->lock){+...}-{3:3}, at: padata_reorder kernel/padata.c:309 [inline]
ffffe8ffffd55fd8 (&pd_list->lock){+...}-{3:3}, at: padata_do_serial+0x73e/0xb80 kernel/padata.c:379

but task is already holding lock:
ffffe8ffffd5f4d8 (&pd_list->lock){+...}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffffe8ffffd5f4d8 (&pd_list->lock){+...}-{3:3}, at: padata_reorder kernel/padata.c:300 [inline]
ffffe8ffffd5f4d8 (&pd_list->lock){+...}-{3:3}, at: padata_do_serial+0x5b5/0xb80 kernel/padata.c:379

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&pd_list->lock);
  lock(&pd_list->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u8:11/20346:
 #0: ffff888146e84948 ((wq_completion)pencrypt_parallel){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff888146e84948 ((wq_completion)pencrypt_parallel){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc9000bf7fbc0 ((work_completion)(&pw->pw_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc9000bf7fbc0 ((work_completion)(&pw->pw_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffffe8ffffd5f4d8 (&pd_list->lock){+...}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #2: ffffe8ffffd5f4d8 (&pd_list->lock){+...}-{3:3}, at: padata_reorder kernel/padata.c:300 [inline]
 #2: ffffe8ffffd5f4d8 (&pd_list->lock){+...}-{3:3}, at: padata_do_serial+0x5b5/0xb80 kernel/padata.c:379

stack backtrace:
CPU: 1 UID: 0 PID: 20346 Comm: kworker/u8:11 Not tainted 6.16.0-rc3-next-20250624-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Workqueue: pencrypt_parallel padata_parallel_worker
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3044
 check_deadlock kernel/locking/lockdep.c:3096 [inline]
 validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3898
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 padata_find_next kernel/padata.c:256 [inline]
 padata_reorder kernel/padata.c:309 [inline]
 padata_do_serial+0x73e/0xb80 kernel/padata.c:379
 padata_parallel_worker+0x75/0x1d0 kernel/padata.c:157
 process_one_work kernel/workqueue.c:3239 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3322
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3403
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
