Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbfAOSkB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 13:40:01 -0500
Date: Tue, 15 Jan 2019 10:39:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+ee4f315443a4ea97512e@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in crypto_remove_spawns (2)
Message-ID: <20190115183956.GB10955@gmail.com>
References: <00000000000005cc6a057f65dcea@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000005cc6a057f65dcea@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 13, 2019 at 11:19:03PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    4b3c31c8d4dd Merge branch 'i2c/for-current' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=144cb817400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b05cfdb4ee8ab9b2
> dashboard link: https://syzkaller.appspot.com/bug?extid=ee4f315443a4ea97512e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+ee4f315443a4ea97512e@syzkaller.appspotmail.com
> 
> binder: 18706:18709 ioctl 40046207 0 returned -16
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 18713 Comm: cryptomgr_test Not tainted 5.0.0-rc1+ #21
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:crypto_remove_spawns+0x7ac/0x1340 crypto/algapi.c:194
> Code: 49 8d 7c 24 10 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 f2 06 00 00 49
> c7 44 24 10 00 00 00 00 4d 8d 66 10 4c 89 e0 48 c1 e8 03 <80> 3c 18 00 0f 85
> ef 06 00 00 49 83 7e 10 00 74 0a e8 4e 9e 24 fe
> RSP: 0000:ffff888054737b88 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: dffffc0000000000 RCX: 1ffff1100a8e6f86
> RDX: 0000000000000000 RSI: ffffffff835d58d2 RDI: ffff888085c226b8
> RBP: ffff888054737df8 R08: ffff88804fb4e4c0 R09: ffff88804fb4ed60
> R10: ffff88804fb4ed40 R11: 0000000000000001 R12: 0000000000000010
> R13: ffffed100a8e6f8e R14: 0000000000000000 R15: ffff888054737dd0
> FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f6091a29000 CR3: 00000000876f9000 CR4: 00000000001406e0
> kobject: 'loop2' (00000000d1d42c09): kobject_uevent_env
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> kobject: 'loop2' (00000000d1d42c09): fill_kobj_path: path =
> '/devices/virtual/block/loop2'
>  crypto_alg_tested+0x52d/0x790 crypto/algapi.c:339
>  cryptomgr_test+0x18/0x30 crypto/algboss.c:226
>  kthread+0x357/0x430 kernel/kthread.c:246
> binder: BINDER_SET_CONTEXT_MGR already set
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
> Modules linked in:
> kobject: 'loop3' (0000000091226001): kobject_uevent_env
> binder: 18723:18724 ioctl 40046207 0 returned -16
> kobject: 'loop3' (0000000091226001): fill_kobj_path: path =
> '/devices/virtual/block/loop3'
> kobject: 'loop5' (0000000038d1e891): kobject_uevent_env
> kobject: 'loop5' (0000000038d1e891): fill_kobj_path: path =
> '/devices/virtual/block/loop5'
> kobject: 'loop1' (0000000047f20675): kobject_uevent_env
> kobject: 'loop1' (0000000047f20675): fill_kobj_path: path =
> '/devices/virtual/block/loop1'
> kobject: 'loop0' (00000000f3ca3d42): kobject_uevent_env
> kobject: 'loop0' (00000000f3ca3d42): fill_kobj_path: path =
> '/devices/virtual/block/loop0'
> kobject: 'loop5' (0000000038d1e891): kobject_uevent_env
> kobject: 'loop5' (0000000038d1e891): fill_kobj_path: path =
> '/devices/virtual/block/loop5'
> kobject: 'loop1' (0000000047f20675): kobject_uevent_env
> kobject: 'loop1' (0000000047f20675): fill_kobj_path: path =
> '/devices/virtual/block/loop1'
> kobject: 'loop2' (00000000d1d42c09): kobject_uevent_env
> kobject: 'loop2' (00000000d1d42c09): fill_kobj_path: path =
> '/devices/virtual/block/loop2'
> ---[ end trace d2934b3fdb1c156e ]---
> RIP: 0010:crypto_remove_spawns+0x7ac/0x1340 crypto/algapi.c:194
> Code: 49 8d 7c 24 10 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 f2 06 00 00 49
> c7 44 24 10 00 00 00 00 4d 8d 66 10 4c 89 e0 48 c1 e8 03 <80> 3c 18 00 0f 85
> ef 06 00 00 49 83 7e 10 00 74 0a e8 4e 9e 24 fe
> RSP: 0000:ffff888054737b88 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: dffffc0000000000 RCX: 1ffff1100a8e6f86
> RDX: 0000000000000000 RSI: ffffffff835d58d2 RDI: ffff888085c226b8
> RBP: ffff888054737df8 R08: ffff88804fb4e4c0 R09: ffff88804fb4ed60
> R10: ffff88804fb4ed40 R11: 0000000000000001 R12: 0000000000000010
> R13: ffffed100a8e6f8e R14: 0000000000000000 R15: ffff888054737dd0
> FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000110cfd0 CR3: 0000000094f35000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
> 

This may be the bug that will be fixed by commit 6db43410179b ("crypto: adiantum
- initialize crypto_spawn::inst"), but I'm not sure.  Since it's unlikely that
anyone will do anything else with this bug report, I'm going ahead and marking
this fixed for syzbot so that it doesn't suppress similar crashes in the future.

#syz fix: crypto: adiantum - initialize crypto_spawn::inst

- Eric
