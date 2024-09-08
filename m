Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A517346C
	for <linux-crypto@vger.kernel.org>; Sun,  8 Sep 2024 05:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725774025; cv=none; b=OIET5aCTQ7gEQTScfxashqIRt1Gg8/FXI7WWepBD2hc1H7S9jI/RSSTR8QbMbKF7d3YNbe1U+UlsuMtbClrv2fWxCQxR/fyTynkhUgsfZ+inqHTmGlzNctLo9rG+GXrNzsn484G4MXPl8H9YNppCWwvC/CXCS3MBhO88JxDNxWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725774025; c=relaxed/simple;
	bh=3DD3YEh8rNS1p+LJFcqH44x1frFbjWB1nyxN3uiGqtU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VYKd4jdCsT6UNKZCLtwQn0w6/rtcr3BANxwf/L7DXChvo33dUcIA/pln9L7Nryi3eQm2f/YkHrUHIwOxHf2kXnXgy+sTE0c6Uxjlj0TINbXnTjoqQsrmL//SK4Q6SalRT9ew98NqlzHNH1oOfPuZfnYEKAnJWH4t51OMHoKipb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-39d4ba9c42aso70655135ab.3
        for <linux-crypto@vger.kernel.org>; Sat, 07 Sep 2024 22:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725774023; x=1726378823;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v0C/eB988nOfIfjc2yda9ra69Q8KJs4DhAtITLlcIgw=;
        b=OunEVvL85icOs3xhFTpJRnkRbkF0mKrOm4JSeBJzxbUKfr72FfxfBJoR+FF5Vp+3z1
         kNMOu0gt5/Ifj5aiOj6FRL2SMUemsagqz1LajDb645UA6xJJHFS5BEjP4Npp9Iij0vIZ
         gK8vzgiv7BFRdmqebcFWz53AsrAbOGk8mjVE1VUhRrkPyFOcflhjFBOKl8HGbt6X8MWw
         AA0Ngq9UHrPhGs4m8Wic7MZ0Pf8/UHAtvp/IcF+RlHz7IKidVxXQoT1darFM9oKcBb/s
         Bb7tJOoL+oAk8uyGPHdbvYFQZDbkI9yW7x/stQcmCz/VmCXg6+wo8D8qhdi6auVeVCk2
         fm4g==
X-Forwarded-Encrypted: i=1; AJvYcCUiwMLIe998F6THn5q2B/AaU3ao+zxEBL8VCdp7t5qHoSnhVFMKH5xCHQPROgiedGTbr0y9PhcyS9foTSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMSTdhdNSG7+ZEwv0kaPDKB+yzzMLScv+HaOHkv6c2TXyp6DXZ
	6mphmu8dw+ZlYu6qDCHAWr/EqaKGhVHqgKZ8NmpaIslECTz17RQsLncodzxeA380BfRlT4EQBF3
	d71PFJl1OhoFuaGI5sbchvFid2Uud1VHgBauBijdXeqhIzWecBedlL6c=
X-Google-Smtp-Source: AGHT+IEohT0XsHhfehAaKW6rJio2JeksxT9kGPKgDk6EqctkbFHxatqvZzCOZLQmIibg3tK3m2kanhH/hopldzunJPHHV9MzvFPW
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:138d:b0:39f:5baa:e50e with SMTP id
 e9e14a558f8ab-3a05224acafmr65163845ab.7.1725774022823; Sat, 07 Sep 2024
 22:40:22 -0700 (PDT)
Date: Sat, 07 Sep 2024 22:40:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097e14f0621951335@google.com>
Subject: [syzbot] [crypto?] [ntfs3?] KMSAN: uninit-value in sw842_compress
From: syzbot <syzbot+17cae3c0a5b0acdc327d@syzkaller.appspotmail.com>
To: almaz.alexandrovich@paragon-software.com, davem@davemloft.net, 
	haren@us.ibm.com, herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ntfs3@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    88fac17500f4 Merge tag 'fuse-fixes-6.11-rc7' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14d165b7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=35c699864e165c51
dashboard link: https://syzkaller.appspot.com/bug?extid=17cae3c0a5b0acdc327d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156a4e8f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a2c309980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6e5a9ba13ba0/disk-88fac175.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/229238ec073e/vmlinux-88fac175.xz
kernel image: https://storage.googleapis.com/syzbot-assets/64327bdcda24/bzImage-88fac175.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e120b354c45a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+17cae3c0a5b0acdc327d@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in check_template lib/842/842_compress.c:391 [inline]
BUG: KMSAN: uninit-value in process_next lib/842/842_compress.c:456 [inline]
BUG: KMSAN: uninit-value in sw842_compress+0x15eb/0x5990 lib/842/842_compress.c:543
 check_template lib/842/842_compress.c:391 [inline]
 process_next lib/842/842_compress.c:456 [inline]
 sw842_compress+0x15eb/0x5990 lib/842/842_compress.c:543
 crypto842_scompress+0x4f/0x70 crypto/842.c:78
 scomp_acomp_comp_decomp+0x7c6/0xb90
 scomp_acomp_compress+0x32/0x40 crypto/scompress.c:187
 crypto_acomp_compress include/crypto/acompress.h:251 [inline]
 zswap_compress+0x368/0xad0 mm/zswap.c:927
 zswap_store+0x1af3/0x2dd0 mm/zswap.c:1459
 swap_writepage+0x11f/0x470 mm/page_io.c:198
 shmem_writepage+0x1a75/0x1f70 mm/shmem.c:1536
 pageout mm/vmscan.c:680 [inline]
 shrink_folio_list+0x577f/0x7cb0 mm/vmscan.c:1360
 evict_folios+0x9bce/0xbc80 mm/vmscan.c:4580
 try_to_shrink_lruvec+0x13a3/0x1750 mm/vmscan.c:4775
 shrink_one+0x646/0xd20 mm/vmscan.c:4813
 shrink_many mm/vmscan.c:4876 [inline]
 lru_gen_shrink_node mm/vmscan.c:4954 [inline]
 shrink_node+0x451a/0x50f0 mm/vmscan.c:5934
 kswapd_shrink_node mm/vmscan.c:6762 [inline]
 balance_pgdat mm/vmscan.c:6954 [inline]
 kswapd+0x2627/0x4350 mm/vmscan.c:7223
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

<Zero or more stacks not recorded to save memory>

Uninit was stored to memory at:
 memcpy_from_iter lib/iov_iter.c:73 [inline]
 iterate_bvec include/linux/iov_iter.h:122 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:249 [inline]
 iterate_and_advance include/linux/iov_iter.h:271 [inline]
 __copy_from_iter lib/iov_iter.c:249 [inline]
 copy_page_from_iter_atomic+0x12bb/0x2ae0 lib/iov_iter.c:481
 copy_folio_from_iter_atomic include/linux/uio.h:186 [inline]
 generic_perform_write+0x896/0x12e0 mm/filemap.c:4032
 shmem_file_write_iter+0x2bd/0x2f0 mm/shmem.c:3074
 do_iter_readv_writev+0x8a1/0xa40
 vfs_iter_write+0x459/0xd50 fs/read_write.c:895
 lo_write_bvec drivers/block/loop.c:243 [inline]
 lo_write_simple drivers/block/loop.c:264 [inline]
 do_req_filebacked drivers/block/loop.c:511 [inline]
 loop_handle_cmd drivers/block/loop.c:1910 [inline]
 loop_process_work+0x15ec/0x3750 drivers/block/loop.c:1945
 loop_rootcg_workfn+0x2b/0x40 drivers/block/loop.c:1976
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_write_bh+0x652/0xdb0 fs/ntfs3/fsntfs.c:1450
 indx_write fs/ntfs3/index.c:1027 [inline]
 indx_update_dup+0xd81/0xf80 fs/ntfs3/index.c:2694
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_read_run_nb+0x786/0x1070 fs/ntfs3/fsntfs.c:1252
 ntfs_read_bh+0x64/0xde0 fs/ntfs3/fsntfs.c:1313
 indx_read+0x44e/0x17b0 fs/ntfs3/index.c:1067
 indx_find+0xd12/0x1440 fs/ntfs3/index.c:1181
 indx_update_dup+0x607/0xf80 fs/ntfs3/index.c:2666
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_write_bh+0x652/0xdb0 fs/ntfs3/fsntfs.c:1450
 indx_write fs/ntfs3/index.c:1027 [inline]
 indx_update_dup+0xd81/0xf80 fs/ntfs3/index.c:2694
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_read_run_nb+0x786/0x1070 fs/ntfs3/fsntfs.c:1252
 ntfs_read_bh+0x64/0xde0 fs/ntfs3/fsntfs.c:1313
 indx_read+0x44e/0x17b0 fs/ntfs3/index.c:1067
 indx_find+0xd12/0x1440 fs/ntfs3/index.c:1181
 indx_update_dup+0x607/0xf80 fs/ntfs3/index.c:2666
 ni_update_parent+0x12de/0x14b0 fs/ntfs3/frecord.c:3301
 ni_write_inode+0x1cf4/0x1de0 fs/ntfs3/frecord.c:3392
 ntfs3_write_inode+0x94/0xb0 fs/ntfs3/inode.c:1052
 write_inode fs/fs-writeback.c:1497 [inline]
 __writeback_single_inode+0x849/0x12c0 fs/fs-writeback.c:1716
 writeback_sb_inodes+0xc95/0x1e00 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2018
 wb_writeback+0x50b/0xea0 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3312
 worker_thread+0xea7/0x14d0 kernel/workqueue.c:3389
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_write_bh+0x652/0xdb0 fs/ntfs3/fsntfs.c:1450
 indx_write fs/ntfs3/index.c:1027 [inline]
 indx_insert_into_buffer+0xd8f/0x2010 fs/ntfs3/index.c:1811
 indx_insert_entry+0xa3c/0xee0 fs/ntfs3/index.c:1988
 ni_add_name+0xe5d/0x10d0 fs/ntfs3/frecord.c:3123
 ntfs_link_inode+0x265/0x310 fs/ntfs3/inode.c:1768
 ntfs_link+0x21d/0x500 fs/ntfs3/namei.c:146
 vfs_link+0x93d/0xb70 fs/namei.c:4692
 do_linkat+0x4f5/0xfd0 fs/namei.c:4762
 __do_sys_link fs/namei.c:4796 [inline]
 __se_sys_link fs/namei.c:4794 [inline]
 __x64_sys_link+0xe8/0x140 fs/namei.c:4794
 x64_sys_call+0x2853/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:87
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 hdr_insert_de fs/ntfs3/index.c:838 [inline]
 indx_insert_into_buffer+0xcdf/0x2010 fs/ntfs3/index.c:1807
 indx_insert_entry+0xa3c/0xee0 fs/ntfs3/index.c:1988
 ni_add_name+0xe5d/0x10d0 fs/ntfs3/frecord.c:3123
 ntfs_link_inode+0x265/0x310 fs/ntfs3/inode.c:1768
 ntfs_link+0x21d/0x500 fs/ntfs3/namei.c:146
 vfs_link+0x93d/0xb70 fs/namei.c:4692
 do_linkat+0x4f5/0xfd0 fs/namei.c:4762
 __do_sys_link fs/namei.c:4796 [inline]
 __se_sys_link fs/namei.c:4794 [inline]
 __x64_sys_link+0xe8/0x140 fs/namei.c:4794
 x64_sys_call+0x2853/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:87
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3994 [inline]
 slab_alloc_node mm/slub.c:4037 [inline]
 kmem_cache_alloc_noprof+0x637/0xb20 mm/slub.c:4044
 ntfs_link_inode+0x8f/0x310 fs/ntfs3/inode.c:1756
 ntfs_link+0x21d/0x500 fs/ntfs3/namei.c:146
 vfs_link+0x93d/0xb70 fs/namei.c:4692
 do_linkat+0x4f5/0xfd0 fs/namei.c:4762
 __do_sys_link fs/namei.c:4796 [inline]
 __se_sys_link fs/namei.c:4794 [inline]
 __x64_sys_link+0xe8/0x140 fs/namei.c:4794
 x64_sys_call+0x2853/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:87
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 83 Comm: kswapd0 Not tainted 6.11.0-rc6-syzkaller-00026-g88fac17500f4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
