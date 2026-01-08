Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155CD4E377D
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 13:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767877281; cv=none; b=gnjTogWBxYalmyg/W7IEkuZkkwYbzA+DAZnhPgjaLmxAOnpCxg5e3Yc6RhB7DxDYk8zrWjTOwhLpDPtcIzc/enI/BFr/rrdzeYk8nhsMkna8Fqm97vqNPD3CdkaXmg9Z0wAGsUM7PvngEnQ/h8cawcIu8wEq38/Ju1ZRR5+6y/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767877281; c=relaxed/simple;
	bh=uCT17Cp9IBQKnQOwiMUSsKgZuQ3BjfYZe1vEs0z7ldg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=N4vNshbA5OvFGFOpdqyhMY2qTn+eQ2C0PXlMchEqacME/d82s/9C6pcWxL95F7+BRGrhfQx7WgYze3Jtj7N+c9Py+99zphHja6EAIGEK3byXXN1EeIsLR7jaX8OSBizSvAoLSmY9WIu/z1qIJxVVg6xPU9doIEmZGJOe2shFyEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-65f54007ca6so4372127eaf.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 05:01:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767877278; x=1768482078;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aAUZE8cHv01qmucZPVDcofQjncPR/tq1STmA93zmiq0=;
        b=EyaCjanR5vXU5d7IjSuH/AeAm2t7OLG7fXsoprTpBdUBRD7esiH5THCagBXAaLeMuY
         r1upxbWhkVtEE1EgumhiPKDQaVXdJcgV9aE7OiKjjCICZ9NHqDi3zqlekyGTxsXupSq8
         INDHJHC9fAZId4FpW8prqS0aIKjUCbI23XWg7WcW/ExFbvRTCi3ACr0qOO+6r17bjK90
         /WlIMtwozlftW7pr3YfDmvIGlhX6UOtijMkLlqclUvDK96zYERzmYOICEGbPBVXDkVOJ
         QhvmIEtYw+dfO2j5oo0QJ5IQpKEBWbHqvh/d8y6K8l3fICLP/AKWZnzqMtEpRKRa8axQ
         Aflg==
X-Forwarded-Encrypted: i=1; AJvYcCXDhyJvnY6E6AlEXcDa9B0Aw+lL31B3GDLnQKez0AW6LX2eifjHFOjZJUxBvU/ceifiaHPD/5I74uP/j90=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0SG5Q0N4jzXVnkpXr4826X+w5PVAL98mTbXaz47pu+XeZns5b
	OT7Oac697yIWrgOkRCT6Mfp0C6nUp4WRKS8mj0GxMicX9trIEeOY1kBw+8ew0vg/DIWwHbUxM3R
	4EbvqPZxi9dyVCSv3sFl8grWdP+cM8bkq5rR77EWzJRyuIH0ilUXCOPuLlLQ=
X-Google-Smtp-Source: AGHT+IHBgELra5o1mVlkrnWtbdJrJUQs0c7FO4DlFM9NKpH1Tx3/UpnawpkauuUgtx3kUrOHa25sFP6ePPiXO1lLMAiDNNNi1HWO
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1688:b0:657:6905:56f5 with SMTP id
 006d021491bc7-65f54e26d2emr2323785eaf.0.1767877277747; Thu, 08 Jan 2026
 05:01:17 -0800 (PST)
Date: Thu, 08 Jan 2026 05:01:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695faa9d.050a0220.1c677c.039d.GAE@google.com>
Subject: [syzbot] [crypto?] possible deadlock in crypto_alg_mod_lookup
From: syzbot <syzbot+ced80aa1e67e7ceac4ef@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f8f97927abf7 Add linux-next specific files for 20260105
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12474074580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0672dd8d69c3235
dashboard link: https://syzkaller.appspot.com/bug?extid=ced80aa1e67e7ceac4ef
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1837bbc8e23e/disk-f8f97927.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/07390717f7e4/vmlinux-f8f97927.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f4a72ec80dc/bzImage-f8f97927.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ced80aa1e67e7ceac4ef@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.0.8101/30017 is trying to acquire lock:
ffffffff8ea2bc10 (crypto_alg_sem){++++}-{4:4}, at: crypto_larval_add crypto/api.c:137 [inline]
ffffffff8ea2bc10 (crypto_alg_sem){++++}-{4:4}, at: crypto_larval_lookup crypto/api.c:316 [inline]
ffffffff8ea2bc10 (crypto_alg_sem){++++}-{4:4}, at: crypto_alg_mod_lookup+0x211/0x5f0 crypto/api.c:353

but task is already holding lock:
ffff88801fb4df20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1700 [inline]
ffff88801fb4df20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: do_tls_setsockopt net/tls/tls_main.c:871 [inline]
ffff88801fb4df20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tls_setsockopt+0x384/0x1600 net/tls/tls_main.c:905

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (sk_lock-AF_INET6){+.+.}-{0:0}:
       lock_sock_nested+0x48/0x100 net/core/sock.c:3780
       lock_sock include/net/sock.h:1700 [inline]
       inet_shutdown+0x6a/0x390 net/ipv4/af_inet.c:913
       nbd_mark_nsock_dead+0x2e9/0x560 drivers/block/nbd.c:318
       recv_work+0x1b38/0x1c50 drivers/block/nbd.c:1021
       process_one_work+0x93a/0x15a0 kernel/workqueue.c:3279
       process_scheduled_works kernel/workqueue.c:3362 [inline]
       worker_thread+0x9b0/0xee0 kernel/workqueue.c:3443
       kthread+0x389/0x480 kernel/kthread.c:467
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #7 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
       nbd_handle_cmd drivers/block/nbd.c:1143 [inline]
       nbd_queue_rq+0x257/0xf10 drivers/block/nbd.c:1207
       blk_mq_dispatch_rq_list+0x4c0/0x1900 block/blk-mq.c:2135
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xdac/0x1570 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x348/0x4f0 block/blk-mq.c:2373
       blk_mq_dispatch_list+0xd0b/0xe00 include/linux/spinlock.h:-1
       blk_mq_flush_plug_list+0x469/0x550 block/blk-mq.c:2984
       __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       __submit_bio+0x2d0/0x5a0 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x2eb/0xa30 block/blk-core.c:755
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x7b7/0x830 fs/buffer.c:2461
       filemap_read_folio+0x117/0x380 mm/filemap.c:2496
       do_read_cache_folio+0x358/0x590 mm/filemap.c:4096
       read_mapping_folio include/linux/pagemap.h:1028 [inline]
       read_part_sector+0xb6/0x2b0 block/partitions/core.c:722
       adfspart_check_ICS+0xa4/0xa50 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x75f/0x14b0 block/partitions/core.c:693
       blkdev_get_whole+0x380/0x510 block/bdev.c:765
       bdev_open+0x31e/0xd30 block/bdev.c:974
       blkdev_open+0x457/0x600 block/fops.c:698
       do_dentry_open+0x785/0x14e0 fs/open.c:962
       vfs_open+0x3b/0x340 fs/open.c:1094
       do_open fs/namei.c:4627 [inline]
       path_openat+0x2de0/0x3840 fs/namei.c:4786
       do_filp_open+0x1fa/0x410 fs/namei.c:4813
       do_sys_openat2+0x121/0x200 fs/open.c:1391
       do_sys_open fs/open.c:1397 [inline]
       __do_sys_openat fs/open.c:1413 [inline]
       __se_sys_openat fs/open.c:1408 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1408
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
       nbd_queue_rq+0xc8/0xf10 drivers/block/nbd.c:1199
       blk_mq_dispatch_rq_list+0x4c0/0x1900 block/blk-mq.c:2135
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xdac/0x1570 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x348/0x4f0 block/blk-mq.c:2373
       blk_mq_dispatch_list+0xd0b/0xe00 include/linux/spinlock.h:-1
       blk_mq_flush_plug_list+0x469/0x550 block/blk-mq.c:2984
       __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       __submit_bio+0x2d0/0x5a0 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x2eb/0xa30 block/blk-core.c:755
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x7b7/0x830 fs/buffer.c:2461
       filemap_read_folio+0x117/0x380 mm/filemap.c:2496
       do_read_cache_folio+0x358/0x590 mm/filemap.c:4096
       read_mapping_folio include/linux/pagemap.h:1028 [inline]
       read_part_sector+0xb6/0x2b0 block/partitions/core.c:722
       adfspart_check_ICS+0xa4/0xa50 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x75f/0x14b0 block/partitions/core.c:693
       blkdev_get_whole+0x380/0x510 block/bdev.c:765
       bdev_open+0x31e/0xd30 block/bdev.c:974
       blkdev_open+0x457/0x600 block/fops.c:698
       do_dentry_open+0x785/0x14e0 fs/open.c:962
       vfs_open+0x3b/0x340 fs/open.c:1094
       do_open fs/namei.c:4627 [inline]
       path_openat+0x2de0/0x3840 fs/namei.c:4786
       do_filp_open+0x1fa/0x410 fs/namei.c:4813
       do_sys_openat2+0x121/0x200 fs/open.c:1391
       do_sys_open fs/open.c:1397 [inline]
       __do_sys_openat fs/open.c:1413 [inline]
       __se_sys_openat fs/open.c:1408 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1408
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:197 [inline]
       __synchronize_srcu+0x96/0x390 kernel/rcu/srcutree.c:1503
       elevator_switch+0x12b/0x5f0 block/elevator.c:576
       elevator_change+0x2cd/0x450 block/elevator.c:680
       elevator_set_default+0x1af/0x2b0 block/elevator.c:753
       blk_register_queue+0x34e/0x3f0 block/blk-sysfs.c:932
       __add_disk+0x677/0xd50 block/genhd.c:528
       add_disk_fwnode+0xfc/0x480 block/genhd.c:597
       add_disk include/linux/blkdev.h:785 [inline]
       nbd_dev_add+0x717/0xae0 drivers/block/nbd.c:1984
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2692
       do_one_initcall+0x1f1/0x800 init/main.c:1378
       do_initcall_level+0x104/0x190 init/main.c:1440
       do_initcalls+0x59/0xa0 init/main.c:1456
       kernel_init_freeable+0x2a7/0x3d0 init/main.c:1688
       kernel_init+0x1d/0x1d0 init/main.c:1578
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #4 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
       elevator_change+0x1b4/0x450 block/elevator.c:678
       elevator_set_none+0x98/0x110 block/elevator.c:768
       blk_mq_elv_switch_none block/blk-mq.c:5085 [inline]
       __blk_mq_update_nr_hw_queues block/blk-mq.c:5129 [inline]
       blk_mq_update_nr_hw_queues+0x5b4/0x1a80 block/blk-mq.c:5187
       nbd_start_device+0x17f/0xb10 drivers/block/nbd.c:1489
       nbd_start_device_ioctl drivers/block/nbd.c:1548 [inline]
       __nbd_ioctl drivers/block/nbd.c:1623 [inline]
       nbd_ioctl+0x56e/0xe10 drivers/block/nbd.c:1663
       blkdev_ioctl+0x60e/0x710 block/ioctl.c:792
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&q->q_usage_counter(io)#53){++++}-{0:0}:
       blk_alloc_queue+0x52f/0x610 block/blk-core.c:461
       blk_mq_alloc_queue block/blk-mq.c:4416 [inline]
       __blk_mq_alloc_disk+0x15c/0x340 block/blk-mq.c:4463
       nbd_dev_add+0x46c/0xae0 drivers/block/nbd.c:1954
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2692
       do_one_initcall+0x1f1/0x800 init/main.c:1378
       do_initcall_level+0x104/0x190 init/main.c:1440
       do_initcalls+0x59/0xa0 init/main.c:1456
       kernel_init_freeable+0x2a7/0x3d0 init/main.c:1688
       kernel_init+0x1d/0x1d0 init/main.c:1578
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #2 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4304 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4318
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4904 [inline]
       slab_alloc_node mm/slub.c:5243 [inline]
       __kmalloc_cache_noprof+0x40/0x700 mm/slub.c:5775
       kmalloc_noprof include/linux/slab.h:957 [inline]
       kzalloc_noprof include/linux/slab.h:1094 [inline]
       cryptomgr_schedule_probe crypto/algboss.c:87 [inline]
       cryptomgr_notify+0x85/0x930 crypto/algboss.c:225
       notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
       blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
       crypto_probing_notify crypto/api.c:327 [inline]
       crypto_alg_mod_lookup+0x3b1/0x5f0 crypto/api.c:357
       crypto_find_alg crypto/api.c:599 [inline]
       crypto_alloc_tfm_node+0x13e/0x3f0 crypto/api.c:636
       crypto_alloc_tfm crypto/internal.h:149 [inline]
       crypto_alloc_sync_skcipher+0x39/0xd0 crypto/skcipher.c:653
       rxkad_init+0x20/0xe0 net/rxrpc/rxkad.c:1309
       rxrpc_init_security+0x72/0x120 net/rxrpc/security.c:34
       af_rxrpc_init+0x121/0x2d0 net/rxrpc/af_rxrpc.c:1060
       do_one_initcall+0x1f1/0x800 init/main.c:1378
       do_initcall_level+0x104/0x190 init/main.c:1440
       do_initcalls+0x59/0xa0 init/main.c:1456
       kernel_init_freeable+0x2a7/0x3d0 init/main.c:1688
       kernel_init+0x1d/0x1d0 init/main.c:1578
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #1 ((crypto_chain).rwsem){++++}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
       blocking_notifier_call_chain+0x54/0x90 kernel/notifier.c:379
       __crypto_register_alg+0x32b/0x3c0 crypto/algapi.c:346
       crypto_register_alg+0x437/0x800 crypto/algapi.c:455
       crypto_register_shash crypto/shash.c:529 [inline]
       crypto_register_shashes+0x5a/0x100 crypto/shash.c:544
       do_one_initcall+0x1f1/0x800 init/main.c:1378
       do_initcall_level+0x104/0x190 init/main.c:1440
       do_initcalls+0x59/0xa0 init/main.c:1456
       kernel_init_freeable+0x2a7/0x3d0 init/main.c:1688
       kernel_init+0x1d/0x1d0 init/main.c:1578
       ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #0 (crypto_alg_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       crypto_larval_add crypto/api.c:137 [inline]
       crypto_larval_lookup crypto/api.c:316 [inline]
       crypto_alg_mod_lookup+0x211/0x5f0 crypto/api.c:353
       crypto_find_alg crypto/api.c:599 [inline]
       crypto_alloc_tfm_node+0x13e/0x3f0 crypto/api.c:636
       tls_set_sw_offload+0xa33/0x1780 net/tls/tls_sw.c:2839
       do_tls_setsockopt_conf net/tls/tls_main.c:740 [inline]
       do_tls_setsockopt net/tls/tls_main.c:872 [inline]
       tls_setsockopt+0xefe/0x1600 net/tls/tls_main.c:905
       do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2337
       __sys_setsockopt net/socket.c:2362 [inline]
       __do_sys_setsockopt net/socket.c:2368 [inline]
       __se_sys_setsockopt net/socket.c:2365 [inline]
       __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2365
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  crypto_alg_sem --> &nsock->tx_lock --> sk_lock-AF_INET6

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sk_lock-AF_INET6);
                               lock(&nsock->tx_lock);
                               lock(sk_lock-AF_INET6);
  lock(crypto_alg_sem);

 *** DEADLOCK ***

1 lock held by syz.0.8101/30017:
 #0: ffff88801fb4df20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1700 [inline]
 #0: ffff88801fb4df20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: do_tls_setsockopt net/tls/tls_main.c:871 [inline]
 #0: ffff88801fb4df20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tls_setsockopt+0x384/0x1600 net/tls/tls_main.c:905

stack backtrace:
CPU: 1 UID: 0 PID: 30017 Comm: syz.0.8101 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 crypto_larval_add crypto/api.c:137 [inline]
 crypto_larval_lookup crypto/api.c:316 [inline]
 crypto_alg_mod_lookup+0x211/0x5f0 crypto/api.c:353
 crypto_find_alg crypto/api.c:599 [inline]
 crypto_alloc_tfm_node+0x13e/0x3f0 crypto/api.c:636
 tls_set_sw_offload+0xa33/0x1780 net/tls/tls_sw.c:2839
 do_tls_setsockopt_conf net/tls/tls_main.c:740 [inline]
 do_tls_setsockopt net/tls/tls_main.c:872 [inline]
 tls_setsockopt+0xefe/0x1600 net/tls/tls_main.c:905
 do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2337
 __sys_setsockopt net/socket.c:2362 [inline]
 __do_sys_setsockopt net/socket.c:2368 [inline]
 __se_sys_setsockopt net/socket.c:2365 [inline]
 __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2365
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f86bdb8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f86bea17038 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f86bdde5fa0 RCX: 00007f86bdb8f749
RDX: 0000000000000002 RSI: 000000000000011a RDI: 0000000000000003
RBP: 00007f86bdc13f91 R08: 0000000000000028 R09: 0000000000000000
R10: 0000200000000140 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f86bdde6038 R14: 00007f86bdde5fa0 R15: 00007ffce8b79188
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
