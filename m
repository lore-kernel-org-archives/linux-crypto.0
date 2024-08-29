Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BF918B460
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 21:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724968227; cv=none; b=iwnWRNNWPGzWhLQ8Ht4PEWRispjEnrG0uebO+y9ly2bDWcIcWxyyL8dvD068I2/u3DVSCP9UYQ2o2GK9G/bnkJqup3WV70GLcPc90S8yK+6IRqWdHuw2fomVZ7rTrfWPYy51puZSqh4MpDoCNcMOz9yoKk62YmQr5Tlz1wBxPJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724968227; c=relaxed/simple;
	bh=D71/8YhIYykgRRLrGUL5OqJn579RJY18Dj+3EIRoz3g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f6zlTkln0eTza1rBKA2h3dh/k8yEAn/9P+fw4l/6GvxFst3inUrKLXxm1m+bwFliMDbJJeDhd/Nx0NMGOeWnvYL1go9WykFogD5YX4fgRd7Vo6Dc5AK+5gW3edPjCNuah+jduWr5gccIiVfBMbDx/sWZ7C8/7uUiAX3RSq0jvjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f99a9111fso126245639f.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 14:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724968223; x=1725573023;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qswwExplEZg5MplKCrqtU1zfBevl1xiCA/odAG0HRnY=;
        b=bz7ZmyWj5O1N81A6dMsWMYCp2bKcWkMuFpNJHTQiR/99Q61DrCQaoD4ApkdNS48bz1
         9ac+HZtnWufmaNbIlSOBOKbK3urvIQyovOSJWV+MaTU0YNfOkqKZm74lHpxWWTth9Vng
         vPkJ+s68na2xy8lMCyEjAPnNbDLnm3cUKwI/8CiKnABKUh0lnPHYBQ7ktoJzbI2kMsd7
         /H2bCHVzFuwtvBYh8aHv9FmYVVi44OQAEMrEDZpgsVz+uwSQSy5SVm/xO8M/PaDMrA1J
         xgriXt9kqvWyr9Ad4JUcIh/cL+vmUi/lEyqXSpQIHZRcRgF0IwCNoFcD7Sg7zIhPaX3o
         e/Fg==
X-Forwarded-Encrypted: i=1; AJvYcCXQHYvkOVfAmczpOFzmo0epnvlStqRb+DzGbznSFRv4DNf4SxgzfSSSleBT1Cxp1yzXqd+MV/WwKyRav80=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu1s8Wn5sok/JRgmcSxtn9itacnW1Dk/WFK7YvhEir7NRco/sP
	DTYRFU0x5UGSakCZ+Mkcpr5jFIPHQeEsEVOvh3znTyB/b0voJP67tmnoaOZ3LgE7Jt5guqSX6K+
	uRnw4pKgdQRnY1IBkP7N/CDLyP7F9BnmxYecpqV7N94G00UCWECHqsn8=
X-Google-Smtp-Source: AGHT+IHdl4a0XrtF4G/HcXsFzyGe7XcP0ZqF3ESdwtIW7/b6hPy/ka6bqDMCHsNaGiM8cmk+DnKTkmfOQlmJWm+6biD+nKC56MKu
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:160e:b0:81f:861c:9d83 with SMTP id
 ca18e2360f4ac-82a2624763emr1292039f.1.1724968223240; Thu, 29 Aug 2024
 14:50:23 -0700 (PDT)
Date: Thu, 29 Aug 2024 14:50:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000320db40620d976af@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in lzo1x_1_do_compress (3)
From: syzbot <syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5be63fc19fca Linux 6.11-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17d06825980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=522060455c43d52e
dashboard link: https://syzkaller.appspot.com/bug?extid=02341e0daa42a15ce130
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4b3d7926efea/disk-5be63fc1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2e5cbee87f73/vmlinux-5be63fc1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fa58f9a69ae7/bzImage-5be63fc1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in lzo1x_1_do_compress+0x19f9/0x2510 lib/lzo/lzo1x_compress.c:178
 lzo1x_1_do_compress+0x19f9/0x2510 lib/lzo/lzo1x_compress.c:178
 lzogeneric1x_1_compress+0x26a/0x11b0 lib/lzo/lzo1x_compress.c:333
 lzo1x_1_compress+0x47/0x80 lib/lzo/lzo1x_compress.c:383
 __lzo_compress crypto/lzo.c:58 [inline]
 lzo_scompress+0x98/0x180 crypto/lzo.c:79
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
 kswapd+0x257e/0x4290 mm/vmscan.c:7223
 kthread+0x3dd/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

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
 kthread+0x3dd/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 copy_to_dinode+0x881/0xb30 fs/jfs/jfs_imap.c:3158
 diWrite+0x1bf5/0x1f00 fs/jfs/jfs_imap.c:790
 txCommit+0xdb8/0x8cd0 fs/jfs/jfs_txnmgr.c:1255
 __jfs_xattr_set+0x1b7/0x1f0 fs/jfs/xattr.c:936
 jfs_xattr_set+0x79/0x90 fs/jfs/xattr.c:958
 __vfs_setxattr+0x844/0x8b0 fs/xattr.c:200
 __vfs_setxattr_noperm+0x22f/0xb00 fs/xattr.c:234
 __vfs_setxattr_locked+0x441/0x480 fs/xattr.c:295
 vfs_setxattr+0x294/0x650 fs/xattr.c:321
 do_setxattr fs/xattr.c:629 [inline]
 __do_sys_fsetxattr fs/xattr.c:710 [inline]
 __se_sys_fsetxattr+0x7f0/0x980 fs/xattr.c:686
 __x64_sys_fsetxattr+0xe4/0x150 fs/xattr.c:686
 x64_sys_call+0x19c3/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:191
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 ea_put fs/jfs/xattr.c:639 [inline]
 __jfs_setxattr+0x185f/0x1ae0 fs/jfs/xattr.c:785
 __jfs_xattr_set+0xe6/0x1f0 fs/jfs/xattr.c:934
 jfs_xattr_set+0x79/0x90 fs/jfs/xattr.c:958
 __vfs_setxattr+0x844/0x8b0 fs/xattr.c:200
 __vfs_setxattr_noperm+0x22f/0xb00 fs/xattr.c:234
 __vfs_setxattr_locked+0x441/0x480 fs/xattr.c:295
 vfs_setxattr+0x294/0x650 fs/xattr.c:321
 do_setxattr fs/xattr.c:629 [inline]
 __do_sys_fsetxattr fs/xattr.c:710 [inline]
 __se_sys_fsetxattr+0x7f0/0x980 fs/xattr.c:686
 __x64_sys_fsetxattr+0xe4/0x150 fs/xattr.c:686
 x64_sys_call+0x19c3/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:191
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable ea_buf created at:
 __jfs_setxattr+0x5d/0x1ae0 fs/jfs/xattr.c:662
 __jfs_xattr_set+0xe6/0x1f0 fs/jfs/xattr.c:934

CPU: 0 UID: 0 PID: 81 Comm: kswapd0 Tainted: G        W          6.11.0-rc5-syzkaller #0
Tainted: [W]=WARN
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
