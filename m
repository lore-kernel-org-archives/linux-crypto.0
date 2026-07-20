Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC833EA949
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 22:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784587891; cv=none; b=R5sWcT8dN1qD3K8K1ARDlpHl3Ndp+rNIAt9GixpWxRho3Ox5Zde7yB4FwZlPtdm2YGhbTtlwjifK9blxrSxfRFXrNSm9yoH3L27UA/WZ1ZIeIASSpMh2VwzNayDLJ+t0XYN7eAEZF7WpayuX27XgnPpPNp5xXVLbW0weR91ngQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784587891; c=relaxed/simple;
	bh=mzXkBKeMUHMrqLp8+yeu+sKDUWlHPQ/F9UGDYvUx4ik=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=L2p60qO1UbDtVh6zbbmcHDT1uO72RYWJHsxrBuXdWkFgSLhDpwJOCYIMul6+PL+wwSq+FNf+evs4jGbw9Z3KnDfayLDUoajUFrZOb6+qJG5in+vM1myVAeHzZYgomlOYER61acJh/YjxnelJuCtdmQgH5NFdj5jtzbCr4EC+ePg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4a49f09233dso5941516b6e.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 15:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784587888; x=1785192688;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/4H/e5Xa9neimMWvXsSAb9oWXY/qj2xEbVw5H7rrwgw=;
        b=Doy1Yo+cuhfjCBu8SwKblmcG9G/5zQTz7kHdO8AnebVbryRcox2aAVesQggpWKfbSv
         soXiqg4kmYpWPKBrxz2Xslmhn8zd3qyiM8HFfGD8nVU7r58Jf8fVVrnd4Zdj5ujZQCvH
         Vm9aDnVXCdQp7yNtw+awfL3DaafG6LR+7Yo9TGAnG4TINXqrGvTP1r66cG/1j2aLagcG
         +j7OLn8qocumclgkDB9ELlBOJnbiNCRYIQAhMmKqwSMITRBKdt88GR8KA8BZD7WiFBA4
         lbDzj7vkwZyHKXVDek1C4Aure+NjgE7wy81DOdqMKdhL4x8mpUr96HB1oNSzxMFDVWrO
         7pTw==
X-Forwarded-Encrypted: i=1; AHgh+RrTkwWjwEx/knEfYM7L4lPfuwkJUu1Qaxvv45c7/WONXp/Ev+W3tZLfP/iN03srihh18m0xovrCEBso7mo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm+SR8aKV/iGfF3UQRbSBWGPZy56XnFjr9ce68T/G4pkg4Tbvr
	ly7Qc+beMGzHd8JaGuFgURtVWl6xQrtq9g+jTQ0OdQfdWvXE8VEsPeyWOl6xcqtNGCm4/mBxXVu
	MoZEOslNmRO5pzzMf4aAhGZGrBhoxG0Kgo/ybz3AA0Hfk6ijiGOZgTMqJz9E=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:15a3:b0:4a4:cf25:baf8 with SMTP id
 5614622812f47-4a4d039a6abmr8739278b6e.34.1784587888024; Mon, 20 Jul 2026
 15:51:28 -0700 (PDT)
Date: Mon, 20 Jul 2026 15:51:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5ea670.f1649fcc.2a4208.0576.GAE@google.com>
Subject: [syzbot] [crypto?] possible deadlock in __alloc_workqueue (3)
From: syzbot <syzbot+5f117b3024eab6a14c35@syzkaller.appspotmail.com>
To: daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f6f3b36c15ed net: ethernet: qualcomm: remove unneeded 'fas..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=152cacb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c4196ba0e33631d
dashboard link: https://syzkaller.appspot.com/bug?extid=5f117b3024eab6a14c35
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/47ae09206bf6/disk-f6f3b36c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9e3daf94ae30/vmlinux-f6f3b36c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c266cfd24092/bzImage-f6f3b36c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f117b3024eab6a14c35@syzkaller.appspotmail.com

wlan1 speed is unknown, defaulting to 1000
wlan1 speed is unknown, defaulting to 1000
wlan1 speed is unknown, defaulting to 1000
infiniband syz1: set down
infiniband syz1: added wlan1
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.1.835/9438 is trying to acquire lock:
ffffffff8ec848a0 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:317 [inline]
ffffffff8ec848a0 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4565 [inline]
ffffffff8ec848a0 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4925 [inline]
ffffffff8ec848a0 (fs_reclaim){+.+.}-{0:0}, at: __do_kmalloc_node mm/slub.c:5361 [inline]
ffffffff8ec848a0 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_noprof+0xbc/0x720 mm/slub.c:5387

but task is already holding lock:
ffffffff8e9f6d00 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0xa9c/0x2060 kernel/workqueue.c:5895

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (wq_pool_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       __alloc_workqueue+0xa9c/0x2060 kernel/workqueue.c:5895
       alloc_workqueue_va kernel/workqueue.c:5946 [inline]
       alloc_workqueue_noprof+0xe3/0x210 kernel/workqueue.c:5962
       padata_alloc+0xbe/0x360 kernel/padata.c:964
       pcrypt_init_padata+0x27/0x100 crypto/pcrypt.c:335
       pcrypt_init+0x60/0xc0 crypto/pcrypt.c:360
       do_one_initcall+0x250/0x870 init/main.c:1347
       do_initcall_level+0x10a/0x1a0 init/main.c:1409
       do_initcalls+0x59/0xa0 init/main.c:1425
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
       kernel_init+0x1d/0x1d0 init/main.c:1548
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #6 (cpu_hotplug_lock){++++}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read include/linux/percpu-rwsem.h:77 [inline]
       cpus_read_lock+0x42/0x160 kernel/cpu.c:490
       static_key_slow_inc+0x12/0x30 kernel/jump_label.c:190
       nbd_reconnect_socket drivers/block/nbd.c:1379 [inline]
       nbd_genl_reconfigure+0x1301/0x1e80 drivers/block/nbd.c:2468
       genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
       genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
       genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
       netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
       sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
       __sock_sendmsg net/socket.c:790 [inline]
       ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
       ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
       __sys_sendmsg net/socket.c:2770 [inline]
       __do_sys_sendmsg net/socket.c:2775 [inline]
       __se_sys_sendmsg net/socket.c:2773 [inline]
       __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       nbd_handle_cmd drivers/block/nbd.c:1143 [inline]
       nbd_queue_rq+0x373/0x1150 drivers/block/nbd.c:1207
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2117
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x16c/0x300 block/blk-mq.c:2532
       process_one_work kernel/workqueue.c:3322 [inline]
       process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #4 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       nbd_queue_rq+0xc1/0x1150 drivers/block/nbd.c:1199
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2117
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x16c/0x300 block/blk-mq.c:2532
       process_one_work kernel/workqueue.c:3322 [inline]
       process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #3 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:199 [inline]
       __synchronize_srcu+0xc9/0x2f0 kernel/rcu/srcutree.c:1481
       elevator_switch+0x1e8/0x7b0 block/elevator.c:576
       elevator_change+0x2fa/0x480 block/elevator.c:681
       elevator_set_default+0x375/0x440 block/elevator.c:754
       blk_register_queue+0x3f3/0x4e0 block/blk-sysfs.c:992
       __add_disk+0x6cb/0xe30 block/genhd.c:528
       add_disk_fwnode+0xfb/0x4b0 block/genhd.c:597
       add_disk include/linux/blkdev.h:800 [inline]
       nbd_dev_add+0x733/0xb60 drivers/block/nbd.c:2021
       nbd_init+0x15f/0x1e0 drivers/block/nbd.c:2729
       do_one_initcall+0x250/0x870 init/main.c:1347
       do_initcall_level+0x10a/0x1a0 init/main.c:1409
       do_initcalls+0x59/0xa0 init/main.c:1425
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
       kernel_init+0x1d/0x1d0 init/main.c:1548
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       elevator_change+0x1af/0x480 block/elevator.c:679
       elevator_set_none+0xb5/0x140 block/elevator.c:769
       blk_mq_elv_switch_none block/blk-mq.c:5101 [inline]
       __blk_mq_update_nr_hw_queues block/blk-mq.c:5146 [inline]
       blk_mq_update_nr_hw_queues+0x5ef/0x19f0 block/blk-mq.c:5211
       nbd_start_device+0x189/0xb30 drivers/block/nbd.c:1526
       nbd_genl_connect+0x1597/0x1c10 drivers/block/nbd.c:2276
       genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
       genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
       genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
       netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
       sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
       __sock_sendmsg net/socket.c:790 [inline]
       ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
       ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
       __sys_sendmsg net/socket.c:2770 [inline]
       __do_sys_sendmsg net/socket.c:2775 [inline]
       __se_sys_sendmsg net/socket.c:2773 [inline]
       __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#50){++++}-{0:0}:
       blk_alloc_queue+0x544/0x690 block/blk-core.c:504
       blk_mq_alloc_queue block/blk-mq.c:4420 [inline]
       __blk_mq_alloc_disk+0x194/0x390 block/blk-mq.c:4467
       nbd_dev_add+0x494/0xb60 drivers/block/nbd.c:1991
       nbd_init+0x15f/0x1e0 drivers/block/nbd.c:2729
       do_one_initcall+0x250/0x870 init/main.c:1347
       do_initcall_level+0x10a/0x1a0 init/main.c:1409
       do_initcalls+0x59/0xa0 init/main.c:1425
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
       kernel_init+0x1d/0x1d0 init/main.c:1548
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4329 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4343
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4565 [inline]
       slab_alloc_node mm/slub.c:4925 [inline]
       __do_kmalloc_node mm/slub.c:5361 [inline]
       __kmalloc_noprof+0xbc/0x720 mm/slub.c:5387
       _kmalloc_noprof include/linux/slab.h:973 [inline]
       _kzalloc_noprof include/linux/slab.h:1290 [inline]
       apply_wqattrs_prepare+0xee/0xdc0 kernel/workqueue.c:5410
       apply_workqueue_attrs_locked kernel/workqueue.c:5495 [inline]
       alloc_and_link_pwqs kernel/workqueue.c:5645 [inline]
       __alloc_workqueue+0x117c/0x2060 kernel/workqueue.c:5897
       alloc_workqueue_va kernel/workqueue.c:5946 [inline]
       alloc_workqueue_noprof+0xe3/0x210 kernel/workqueue.c:5962
       ib_mad_port_open drivers/infiniband/core/mad.c:3252 [inline]
       ib_mad_init_device+0x993/0x2150 drivers/infiniband/core/mad.c:3339
       add_client_context+0x37c/0x7b0 drivers/infiniband/core/device.c:732
       enable_device_and_get+0x19c/0x3e0 drivers/infiniband/core/device.c:1341
       ib_register_device+0x10af/0x1380 drivers/infiniband/core/device.c:1468
       rxe_register_device+0x1e3/0x350 drivers/infiniband/sw/rxe/rxe_verbs.c:1543
       rxe_net_add+0x81/0x110 drivers/infiniband/sw/rxe/rxe_net.c:625
       rxe_newlink+0xf4/0x1c0 drivers/infiniband/sw/rxe/rxe.c:243
       nldev_newlink+0x5bc/0x650 drivers/infiniband/core/nldev.c:1816
       rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:-1 [inline]
       rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
       rdma_nl_rcv+0x6ef/0xa40 drivers/infiniband/core/netlink.c:259
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
       sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
       __sock_sendmsg net/socket.c:790 [inline]
       ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
       ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
       __sys_sendmsg net/socket.c:2770 [inline]
       __do_sys_sendmsg net/socket.c:2775 [inline]
       __se_sys_sendmsg net/socket.c:2773 [inline]
       __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> cpu_hotplug_lock --> wq_pool_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(wq_pool_mutex);
                               lock(cpu_hotplug_lock);
                               lock(wq_pool_mutex);
  lock(fs_reclaim);

 *** DEADLOCK ***

6 locks held by syz.1.835/9438:
 #0: ffffffff9ab1b1a8 (&rdma_nl_types[idx].sem){.+.+}-{4:4}, at: rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:164 [inline]
 #0: ffffffff9ab1b1a8 (&rdma_nl_types[idx].sem){.+.+}-{4:4}, at: rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 #0: ffffffff9ab1b1a8 (&rdma_nl_types[idx].sem){.+.+}-{4:4}, at: rdma_nl_rcv+0x33d/0xa40 drivers/infiniband/core/netlink.c:259
 #1: ffffffff8fd8ae28 (link_ops_rwsem){++++}-{4:4}, at: nldev_newlink+0x429/0x650 drivers/infiniband/core/nldev.c:1806
 #2: ffffffff8fd7c308 (devices_rwsem){++++}-{4:4}, at: enable_device_and_get+0xff/0x3e0 drivers/infiniband/core/device.c:1331
 #3: ffffffff8fd7c608 (clients_rwsem){++++}-{4:4}, at: enable_device_and_get+0x165/0x3e0 drivers/infiniband/core/device.c:1339
 #4: ffff888020ea0620 (&device->client_data_rwsem){++++}-{4:4}, at: add_client_context+0x33e/0x7b0 drivers/infiniband/core/device.c:730
 #5: ffffffff8e9f6d00 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0xa9c/0x2060 kernel/workqueue.c:5895

stack backtrace:
CPU: 1 UID: 0 PID: 9438 Comm: syz.1.835 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/25/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __fs_reclaim_acquire mm/page_alloc.c:4329 [inline]
 fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4343
 might_alloc include/linux/sched/mm.h:317 [inline]
 slab_pre_alloc_hook mm/slub.c:4565 [inline]
 slab_alloc_node mm/slub.c:4925 [inline]
 __do_kmalloc_node mm/slub.c:5361 [inline]
 __kmalloc_noprof+0xbc/0x720 mm/slub.c:5387
 _kmalloc_noprof include/linux/slab.h:973 [inline]
 _kzalloc_noprof include/linux/slab.h:1290 [inline]
 apply_wqattrs_prepare+0xee/0xdc0 kernel/workqueue.c:5410
 apply_workqueue_attrs_locked kernel/workqueue.c:5495 [inline]
 alloc_and_link_pwqs kernel/workqueue.c:5645 [inline]
 __alloc_workqueue+0x117c/0x2060 kernel/workqueue.c:5897
 alloc_workqueue_va kernel/workqueue.c:5946 [inline]
 alloc_workqueue_noprof+0xe3/0x210 kernel/workqueue.c:5962
 ib_mad_port_open drivers/infiniband/core/mad.c:3252 [inline]
 ib_mad_init_device+0x993/0x2150 drivers/infiniband/core/mad.c:3339
 add_client_context+0x37c/0x7b0 drivers/infiniband/core/device.c:732
 enable_device_and_get+0x19c/0x3e0 drivers/infiniband/core/device.c:1341
 ib_register_device+0x10af/0x1380 drivers/infiniband/core/device.c:1468
 rxe_register_device+0x1e3/0x350 drivers/infiniband/sw/rxe/rxe_verbs.c:1543
 rxe_net_add+0x81/0x110 drivers/infiniband/sw/rxe/rxe_net.c:625
 rxe_newlink+0xf4/0x1c0 drivers/infiniband/sw/rxe/rxe.c:243
 nldev_newlink+0x5bc/0x650 drivers/infiniband/core/nldev.c:1816
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:-1 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x6ef/0xa40 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8013f9de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8014d82028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f8014225fa0 RCX: 00007f8013f9de59
RDX: 0000000004000000 RSI: 00002000000002c0 RDI: 000000000000000d
RBP: 00007f8014033e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8014226038 R14: 00007f8014225fa0 R15: 00007ffc03c3f938
 </TASK>
smbdirect: ib_dev[syz1]: added: IB_CA max_fast_reg_page_list_len=512 device_cap_flags=0x1c001223c76 kernel_cap_flags=0x14 page_size_cap=0xfffff000
smbdirect: ib_dev[syz1]: num_ports=1 max_qp_rd_atom=128 max_qp_init_rd_atom=128 max_sgl_rd=0 max_sge_rd=32 max_cqe=32767 max_qp_wr=1048576 max_send_sge=32 max_recv_sge=32
smbdirect: ib_dev[syz1]PORT[1]: iwarp=0 ib=0 roce=1 v1=0 v2=1 core_cap_flags=0x803005
RDS/IB: syz1: added
smc: adding ib device syz1 with port count 1
smc:    ib device syz1 port 1 has no pnetid
wlan1 speed is unknown, defaulting to 1000
wlan1 speed is unknown, defaulting to 1000
wlan1 speed is unknown, defaulting to 1000
wlan1 speed is unknown, defaulting to 1000
wlan1 speed is unknown, defaulting to 1000


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
