Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950FE1DE2C1
	for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2025 21:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740434004; cv=none; b=I7fvMXvzlTalUA/LQ6Nb62ojnLZHgzMANr+1+Gt/R1ulXiaScvN5gabTcCcosaISvQni6dmJ2Xf6AlN7mroamDxI8JomO2yMhcYtZZotKn7RsbZwdBDsCsYBANZwnw15ZMSPFq3GNm4mGXjvo6Ih6VyeS6+Jrxte6EIE8ntZRs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740434004; c=relaxed/simple;
	bh=CSm4IKIIGo3NNCfeh6K2j7UriVaFAlPR2aj1b+Nim/E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ivFrNlvB6PANC0tzDz2Ku6hV2BFxjlNNQ6B0H10VKm1yTqsUvm/liC+6gffmfzL3m1Sxfkoo1pl+YJ6z5honguElXf5u7d9x6goLt+r7wmn3NFx4La6M18TsRxMupmJKhHxWKbTRfM2T7Sto470uRTLxcdShg1psa951VVHDo58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ce8cdf1898so42224185ab.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2025 13:53:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740434001; x=1741038801;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YgU+3s2XffgAkhGqgiW9xHV1qsCRbz4+whll19johCs=;
        b=fr5r6+SwioDxiCurhfusyuQA+vlETszjf5LO+/9dulX3526rVMsW+mX3dTFK8nPjse
         44S1NNt5PiEsULhcfoY1P/EgWZduw47lGAIY5GmCXO4sSIYfZk3S2xVwKpVedefz0DMh
         jcSgjODdguO4GeHRLJBgY3S+05R/dHftmliDQF8AhLv5RfAYUim8AAdg1tBZVgz+rqXK
         0u5WolgZBtrsawba3somiYIPT+IfU2HCtzVmoYMOJEGLNW5P83+MoYVCT4NQDs/CAr4t
         /Q27JaC5GRoEk3NYv7R9CJh2XhIAh1BIMI7pjxSIBMWwp66WFAVLoxEUWSoo0uzlt96u
         /W8g==
X-Forwarded-Encrypted: i=1; AJvYcCUYFltGq3oKKk908dXwj8S5SpRfIbE/w9qf5ikHXep+QApVLe9oLL9Q0UNbA6PpQgAGqVyZuyjw1oUDPDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6h4pQ6rG9fGFwG8cB+5Bq65/ExgbJBPaasy8dV6uga8lwJiYG
	tyl3Mt+cYJeph8cyuOuBYqVP6+eLGR1wWXbUpnq5e9AyjELn59Udbcvxiaj+5j6GGenqhpwVRxZ
	VItGqM8Y5ACdlBOgzZpdNoTha7t6Zrrx/mBo7a8e0z1Ay53Ajqu2kbV8=
X-Google-Smtp-Source: AGHT+IEmtLyf903MvD/OSUmkRQgWzQpO25kB4MNT8aBNYol/PerpcfmKEXUHgNdJvahMECDsjIU2A/5R2oQqxReJsBZmZooeOJ6j
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a22:b0:3d0:27f5:1b6c with SMTP id
 e9e14a558f8ab-3d2cb5151b1mr109586995ab.14.1740434001671; Mon, 24 Feb 2025
 13:53:21 -0800 (PST)
Date: Mon, 24 Feb 2025 13:53:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>
Subject: [syzbot] [crypto?] possible deadlock in crypto_exit_scomp_ops_async
From: syzbot <syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e9a8cac0bf89 Merge tag 'v6.14-rc3-smb3-client-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b667f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61cbf5ac8a063ad4
dashboard link: https://syzkaller.appspot.com/bug?extid=1a517ccfcbc6a7ab0f82
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8441f1b50402/disk-e9a8cac0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/65b1f8d2f790/vmlinux-e9a8cac0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1d6f6d8c3d6b/bzImage-e9a8cac0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com

smpboot: CPU 0 is now offline
crash hp: kexec_trylock() failed, kdump image may be inaccurate
======================================================
WARNING: possible circular locking dependency detected
6.14.0-rc3-syzkaller-00096-ge9a8cac0bf89 #0 Not tainted
------------------------------------------------------
kworker/1:1/46 is trying to acquire lock:
ffffffff8ec41aa8 (scomp_lock){+.+.}-{4:4}, at: crypto_exit_scomp_ops_async+0x42/0x90 crypto/scompress.c:201

but task is already holding lock:
ffffe8ffffc21250 (&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex){+.+.}-{4:4}, at: zswap_cpu_comp_dead+0x80/0x210 mm/zswap.c:885

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xb10 kernel/locking/mutex.c:730
       acomp_ctx_get_cpu_lock mm/zswap.c:905 [inline]
       zswap_compress mm/zswap.c:937 [inline]
       zswap_store_page mm/zswap.c:1462 [inline]
       zswap_store+0x8fc/0x2690 mm/zswap.c:1571
       swap_writepage+0x3b6/0x1120 mm/page_io.c:278
       pageout+0x3b2/0xaa0 mm/vmscan.c:696
       shrink_folio_list+0x2f7f/0x40c0 mm/vmscan.c:1402
       evict_folios+0x774/0x1ab0 mm/vmscan.c:4660
       try_to_shrink_lruvec+0x5a2/0x9a0 mm/vmscan.c:4821
       shrink_one+0x3e3/0x7b0 mm/vmscan.c:4866
       shrink_many mm/vmscan.c:4929 [inline]
       lru_gen_shrink_node mm/vmscan.c:5007 [inline]
       shrink_node+0x2761/0x3e60 mm/vmscan.c:5978
       kswapd_shrink_node mm/vmscan.c:6807 [inline]
       balance_pgdat+0xbab/0x19c0 mm/vmscan.c:6999
       kswapd+0x590/0xb70 mm/vmscan.c:7264
       kthread+0x3af/0x750 kernel/kthread.c:464
       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
       fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:3867
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4066 [inline]
       slab_alloc_node mm/slub.c:4144 [inline]
       __kmalloc_cache_node_noprof+0x54/0x420 mm/slub.c:4333
       kmalloc_node_noprof include/linux/slab.h:924 [inline]
       __get_vm_area_node+0x101/0x2f0 mm/vmalloc.c:3127
       __vmalloc_node_range_noprof+0x26a/0x1530 mm/vmalloc.c:3806
       __vmalloc_node_noprof mm/vmalloc.c:3911 [inline]
       vmalloc_node_noprof+0x6f/0x90 mm/vmalloc.c:4022
       crypto_scomp_alloc_scratches crypto/scompress.c:86 [inline]
       crypto_scomp_init_tfm+0x122/0x270 crypto/scompress.c:107
       crypto_create_tfm_node+0x100/0x320 crypto/api.c:539
       crypto_create_tfm crypto/internal.h:120 [inline]
       crypto_init_scomp_ops_async+0x5d/0x1d0 crypto/scompress.c:217
       crypto_acomp_init_tfm+0x240/0x2e0 crypto/acompress.c:70
       crypto_create_tfm_node+0x100/0x320 crypto/api.c:539
       crypto_alloc_tfm_node+0x102/0x260 crypto/api.c:640
       zswap_cpu_comp_prepare+0xe2/0x420 mm/zswap.c:834
       cpuhp_invoke_callback+0x20c/0xa10 kernel/cpu.c:204
       cpuhp_issue_call+0x1c0/0x980 kernel/cpu.c:2376
       __cpuhp_state_add_instance_cpuslocked+0x1a4/0x3c0 kernel/cpu.c:2438
       __cpuhp_state_add_instance+0xd7/0x2e0 kernel/cpu.c:2459
       cpuhp_state_add_instance include/linux/cpuhotplug.h:387 [inline]
       zswap_pool_create+0x59a/0x7b0 mm/zswap.c:291
       __zswap_pool_create_fallback mm/zswap.c:359 [inline]
       zswap_setup+0x402/0x810 mm/zswap.c:1814
       zswap_init+0x2c/0x40 mm/zswap.c:1850
       do_one_initcall+0x128/0x700 init/main.c:1257
       do_initcall_level init/main.c:1319 [inline]
       do_initcalls init/main.c:1335 [inline]
       do_basic_setup init/main.c:1354 [inline]
       kernel_init_freeable+0x5c7/0x900 init/main.c:1568
       kernel_init+0x1c/0x2b0 init/main.c:1457
       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (scomp_lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain kernel/locking/lockdep.c:3906 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5228
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5851
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xb10 kernel/locking/mutex.c:730
       crypto_exit_scomp_ops_async+0x42/0x90 crypto/scompress.c:201
       crypto_exit_ops crypto/api.c:370 [inline]
       crypto_destroy_tfm crypto/api.c:681 [inline]
       crypto_destroy_tfm+0x135/0x2b0 crypto/api.c:668
       crypto_free_acomp include/crypto/acompress.h:159 [inline]
       zswap_cpu_comp_dead+0x169/0x210 mm/zswap.c:891
       cpuhp_invoke_callback+0x528/0xa10 kernel/cpu.c:216
       __cpuhp_invoke_callback_range+0x101/0x200 kernel/cpu.c:966
       cpuhp_invoke_callback_range kernel/cpu.c:990 [inline]
       cpuhp_down_callbacks kernel/cpu.c:1383 [inline]
       _cpu_down+0x422/0xf20 kernel/cpu.c:1444
       __cpu_down_maps_locked+0x6c/0x90 kernel/cpu.c:1474
       work_for_cpu_fn+0x52/0xa0 kernel/workqueue.c:6731
       process_one_work+0x9c5/0x1ba0 kernel/workqueue.c:3236
       process_scheduled_works kernel/workqueue.c:3317 [inline]
       worker_thread+0x6c8/0xf00 kernel/workqueue.c:3398
       kthread+0x3af/0x750 kernel/kthread.c:464
       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  scomp_lock --> fs_reclaim --> &per_cpu_ptr(pool->acomp_ctx, cpu)->mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
                               lock(fs_reclaim);
                               lock(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
  lock(scomp_lock);

 *** DEADLOCK ***

4 locks held by kworker/1:1/46:
 #0: ffff88801b080d48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1293/0x1ba0 kernel/workqueue.c:3211
 #1: ffffc90000b67d18 ((work_completion)(&wfc.work)){+.+.}-{0:0}, at: process_one_work+0x921/0x1ba0 kernel/workqueue.c:3212
 #2: ffffffff8e060bd0 (cpu_hotplug_lock){++++}-{0:0}, at: cpus_write_lock kernel/cpu.c:508 [inline]
 #2: ffffffff8e060bd0 (cpu_hotplug_lock){++++}-{0:0}, at: _cpu_down+0xe5/0xf20 kernel/cpu.c:1412
 #3: ffffe8ffffc21250 (&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex){+.+.}-{4:4}, at: zswap_cpu_comp_dead+0x80/0x210 mm/zswap.c:885

stack backtrace:
CPU: 1 UID: 0 PID: 46 Comm: kworker/1:1 Not tainted 6.14.0-rc3-syzkaller-00096-ge9a8cac0bf89 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: events work_for_cpu_fn
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x490/0x760 kernel/locking/lockdep.c:2076
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain kernel/locking/lockdep.c:3906 [inline]
 __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5228
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5851
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0x19b/0xb10 kernel/locking/mutex.c:730
 crypto_exit_scomp_ops_async+0x42/0x90 crypto/scompress.c:201
 crypto_exit_ops crypto/api.c:370 [inline]
 crypto_destroy_tfm crypto/api.c:681 [inline]
 crypto_destroy_tfm+0x135/0x2b0 crypto/api.c:668
 crypto_free_acomp include/crypto/acompress.h:159 [inline]
 zswap_cpu_comp_dead+0x169/0x210 mm/zswap.c:891
 cpuhp_invoke_callback+0x528/0xa10 kernel/cpu.c:216
 __cpuhp_invoke_callback_range+0x101/0x200 kernel/cpu.c:966
 cpuhp_invoke_callback_range kernel/cpu.c:990 [inline]
 cpuhp_down_callbacks kernel/cpu.c:1383 [inline]
 _cpu_down+0x422/0xf20 kernel/cpu.c:1444
 __cpu_down_maps_locked+0x6c/0x90 kernel/cpu.c:1474
 work_for_cpu_fn+0x52/0xa0 kernel/workqueue.c:6731
 process_one_work+0x9c5/0x1ba0 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3317 [inline]
 worker_thread+0x6c8/0xf00 kernel/workqueue.c:3398
 kthread+0x3af/0x750 kernel/kthread.c:464
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
