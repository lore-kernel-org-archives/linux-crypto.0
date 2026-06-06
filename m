Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65512E6CC7
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jun 2026 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780764217; cv=none; b=lSZ2ghaDaJu1I9clM5qTe8mYR6QKWe0h4COTORZXb+94pk/MlUQlMlOrNCVjEmVsgY8gEJptsMMV9iKD2AAX212Rhy9h79HwbqSInnDZ2nDAWgbe15i1qq/SXZ0Ef8v5Y7CSWr7nEukUZtlOy6RtucokS/kc/sldTDK9Bmj+a+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780764217; c=relaxed/simple;
	bh=N1cMyWdy2eTSuBOraWn76SHNvwH/nqNjhmSv5ad8U48=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=N6HzKlQBC2Xd722Oipgu2Uru6Qv80Eon0gsmV/OPreamlX5gqA5rX2BOp4q63+xYJawG2ZYY81g6dZ7JwCPRz+KDIgUevgYgCnQy2Wf3wQO5jC0jfcvGom88fzXAkP3KkLaZZa28ONGietyeeTvypambOwgxcErVxpNpV5+Q/mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e6db540d17so5747845a34.0
        for <linux-crypto@vger.kernel.org>; Sat, 06 Jun 2026 09:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780764214; x=1781369014;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mdCPkvJAxBED08vCYu3LyBpnUNR81kJq+FrazPIoX6c=;
        b=ShTuhx5F+UcjyKQ2JqWhHAfRmN+hWOaMXmU6+1VZUbZclIwkmU4drB0i9GtE53ZvkW
         C2o29l8fzWsrtPHhKxQKqpuvtML5VJAHsDmql+Erf/jV8DcjkbeLBhLSk6Vt4G+8nf1h
         YK28F/esH050pGpHgEUfnxRlYmWMm5vecfL85eM9XpvjDOnFK7ImLSptJXnazFXYOfMj
         MB7mVHe2++3rqqU4uobfWX1oXBHpq30t7rCyaRCTsDgtN+eouqCpVjwnBGyFH+HhyNc5
         9W7X/SPK9qlH+0GHPakYQjhJeiBymYp35A4yksv/VtNBxRhv+ovdizdIpryZBVSifUaQ
         xL2w==
X-Forwarded-Encrypted: i=1; AFNElJ8/GQlcoJmBfC0MZcXwP2TX0A326ovJOaRkn70K/Pf5Y49TrBYx1L2j9OSszwt0R4Fa5W03i6840jvx7FI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu/UNX49c1gHuK3iT5vjDPnjFbuh/nJ8eO+P3df7VED1o9vOIJ
	aMlHrF5Fc+a8aoQ9s6eDJuh73mw+HNIbiHiC2ZC+zNLJbJTSSulZ5KCMNUqG1MuB2QAmJqZCGfB
	jujlhwiVCYZqndsvynzSToQtZGMz4idWHXD7h4rHyg6/XUeSmx2mh9qNCgv8=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:161f:b0:69e:6e2a:d63d with SMTP id
 006d021491bc7-69e6e2adda4mr3371193eaf.31.1780764214714; Sat, 06 Jun 2026
 09:43:34 -0700 (PDT)
Date: Sat, 06 Jun 2026 09:43:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a244e36.c25708ab.1b19ef.0007.GAE@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in sw842_compress (2)
From: syzbot <syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com>
To: davem@davemloft.net, haren@us.ibm.com, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6f3ed7fec72f Merge tag 'for-7.1/dm-fixes-3' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17311750580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0ca3b8cb3875012
dashboard link: https://syzkaller.appspot.com/bug?extid=bf5586280a66e9ccdfa9
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/74be992d336f/disk-6f3ed7fe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d51c3e8d59b5/vmlinux-6f3ed7fe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/34df0814d707/bzImage-6f3ed7fe.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in sw842_compress+0xd09/0x5060 lib/842/842_compress.c:528
 sw842_compress+0xd09/0x5060 lib/842/842_compress.c:528
 crypto842_scompress+0x4e/0x70 crypto/842.c:46
 scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h:-1
 scomp_acomp_compress+0x33/0x40 crypto/scompress.c:280
 crypto_acomp_compress+0x5c4/0xe50 crypto/acompress.c:287
 zswap_compress mm/zswap.c:874 [inline]
 zswap_store_page mm/zswap.c:1415 [inline]
 zswap_store+0x1a1d/0x48b0 mm/zswap.c:1526
 swap_writeout+0x7a1/0x1120 mm/page_io.c:275
 shmem_writeout+0x1db1/0x2210 mm/shmem.c:1705
 writeout mm/vmscan.c:630 [inline]
 pageout mm/vmscan.c:679 [inline]
 shrink_folio_list+0x5ade/0x8000 mm/vmscan.c:1400
 evict_folios+0x9704/0xbb70 mm/vmscan.c:4854
 try_to_shrink_lruvec+0x1734/0x24b0 mm/vmscan.c:5009
 lru_gen_shrink_lruvec mm/vmscan.c:5173 [inline]
 shrink_lruvec+0x4f8/0x4e20 mm/vmscan.c:5932
 shrink_node_memcgs mm/vmscan.c:6171 [inline]
 shrink_node+0xf19/0x5a30 mm/vmscan.c:6215
 shrink_zones mm/vmscan.c:6454 [inline]
 do_try_to_free_pages+0x956/0x2640 mm/vmscan.c:6516
 try_to_free_mem_cgroup_pages+0x352/0x920 mm/vmscan.c:6838
 try_charge_memcg+0x815/0x1c20 mm/memcontrol.c:2627
 charge_memcg+0x113/0x410 mm/memcontrol.c:5021
 __mem_cgroup_charge+0x71/0x2e0 mm/memcontrol.c:5038
 mem_cgroup_charge include/linux/memcontrol.h:644 [inline]
 shmem_alloc_and_add_folio+0xe4d/0x1bd0 mm/shmem.c:1985
 shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2564
 shmem_get_folio mm/shmem.c:2670 [inline]
 shmem_write_begin+0x230/0x560 mm/shmem.c:3303
 generic_perform_write+0x364/0x1050 mm/filemap.c:4325
 shmem_file_write_iter+0x2b7/0x2f0 mm/shmem.c:3478
 __kernel_write_iter+0x6f9/0xdd0 fs/read_write.c:621
 dump_emit_page fs/coredump.c:1304 [inline]
 dump_user_range+0x1936/0x2070 fs/coredump.c:1378
 elf_core_dump+0x697e/0x6c30 fs/binfmt_elf.c:2109
 coredump_write+0x20c9/0x2ce0 fs/coredump.c:1053
 do_coredump fs/coredump.c:1132 [inline]
 vfs_coredump+0x7ae1/0x8f00 fs/coredump.c:1206
 get_signal+0x2075/0x29f0 kernel/signal.c:3022
 arch_do_signal_or_restart+0x53/0xc70 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:244 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:315 [inline]
 irqentry_exit+0x16f/0xa00 kernel/entry/common.c:162
 exc_page_fault+0x7e/0xb0 arch/x86/mm/fault.c:1530
 asm_exc_page_fault+0x2b/0x30 arch/x86/include/asm/idtentry.h:618

Uninit was stored to memory at:
 memcpy_from_iter lib/iov_iter.c:85 [inline]
 iterate_bvec include/linux/iov_iter.h:123 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:306 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 __copy_from_iter lib/iov_iter.c:261 [inline]
 copy_folio_from_iter_atomic+0xe91/0x3810 lib/iov_iter.c:491
 generic_perform_write+0x8b7/0x1050 mm/filemap.c:4343
 shmem_file_write_iter+0x2b7/0x2f0 mm/shmem.c:3478
 lo_rw_aio+0x1164/0x14a0 drivers/block/loop.c:-1
 do_req_filebacked drivers/block/loop.c:-1 [inline]
 loop_handle_cmd drivers/block/loop.c:1925 [inline]
 loop_process_work+0xf05/0x1ff0 drivers/block/loop.c:1960
 loop_workfn+0x3e/0x60 drivers/block/loop.c:1984
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb65/0x1e40 kernel/workqueue.c:3397
 worker_thread+0xee4/0x1590 kernel/workqueue.c:3478
 kthread+0x53a/0x5f0 kernel/kthread.c:436
 ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 __alloc_frozen_pages_noprof+0x6fa/0x1000 mm/page_alloc.c:5244
 __alloc_pages_noprof mm/page_alloc.c:5255 [inline]
 alloc_pages_bulk_noprof+0x1664/0x1aa0 mm/page_alloc.c:5175
 btrfs_alloc_page_array fs/btrfs/extent_io.c:675 [inline]
 alloc_eb_folio_array fs/btrfs/extent_io.c:699 [inline]
 alloc_extent_buffer+0xa85/0x4670 fs/btrfs/extent_io.c:3495
 btrfs_find_create_tree_block+0x44/0x60 fs/btrfs/disk-io.c:574
 btrfs_init_new_buffer fs/btrfs/extent-tree.c:5260 [inline]
 btrfs_alloc_tree_block+0x3fe/0x1bc0 fs/btrfs/extent-tree.c:5373
 btrfs_alloc_log_tree_node fs/btrfs/disk-io.c:890 [inline]
 btrfs_add_log_tree+0x243/0x7a0 fs/btrfs/disk-io.c:938
 start_log_trans fs/btrfs/tree-log.c:349 [inline]
 btrfs_log_inode_parent+0x9cf/0x1e00 fs/btrfs/tree-log.c:7562
 btrfs_log_dentry_safe+0x96/0x130 fs/btrfs/tree-log.c:7668
 btrfs_sync_file+0x16bc/0x21c0 fs/btrfs/file.c:1736
 vfs_fsync_range+0x135/0x1c0 fs/sync.c:186
 generic_write_sync include/linux/fs.h:2654 [inline]
 btrfs_do_write_iter+0xb20/0xd70 fs/btrfs/file.c:1473
 btrfs_file_write_iter+0x38/0x50 fs/btrfs/file.c:1483
 do_iter_readv_writev+0x9e0/0xc10 fs/read_write.c:-1
 vfs_writev+0x52a/0x1500 fs/read_write.c:1059
 do_pwritev fs/read_write.c:1155 [inline]
 __do_sys_pwritev2 fs/read_write.c:1213 [inline]
 __se_sys_pwritev2+0x22f/0x470 fs/read_write.c:1204
 __x64_sys_pwritev2+0xe4/0x150 fs/read_write.c:1204
 x64_sys_call+0x10a2/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:329
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15d/0x3c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 15366 Comm: syz.6.2383 Not tainted syzkaller #0 PREEMPT(lazy) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
=====================================================


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
