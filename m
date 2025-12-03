Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A171BC2A
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 01:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764727049; cv=none; b=YLzuWkFXrdQBCGnTFpFgmLAc8PRhfB8XxVlc6saCuSKyse3l8XBpfHFC6nnA+b+bU5y6KX93yoxjYaWc7WLaoqT8VDTK2yy8VucLg4J6PTQgDy8+YVoTu/+YinSkuhZKy7/QP28uFjUZCfvjRyw85LWa+DKaWpEJv0MjiefSIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764727049; c=relaxed/simple;
	bh=+6t665L7JElpLOaVjFqHc+JPAwrJCKZ5m+0YDlZlEVk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ihF949QUw6jEq2iYAEvQ3rwKDT2B6oYy7FUAEiFqI8rIY1RlAQrCp85tdGgvWAMpES7f9nXmq6EVieacvxcCKa7U47RMcP6vELu331KHyWVv06OZXNzH7Zp8oUuwi4Ir6dppaouOVlXv6fsUiGuVkVlb9TWUOzUTD3abSZlsvDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-6574b639289so3197387eaf.1
        for <linux-crypto@vger.kernel.org>; Tue, 02 Dec 2025 17:57:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764727046; x=1765331846;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hLYlxtksAUO/eEHSHZ/6FbrzuglQbbR4CCaUse6Bb74=;
        b=fOi6HE6m6yYBkx2Om5crne/vN0hIZVCSdCO8yk3tjcYM7BN9Q6s63yzrORJf+P2ve5
         B64hXSMem1Os/DFDDHajmQaW++/lReTupl3XsJDz0visM1rVajDKkO19TxT29wFMfmf+
         +/OgSXQm9lUj+H3B/KQD5scl0/2DzYlZlaipKAvMWCZ8Q9GeEVOq9KxzIvMIN3MDJ0Pz
         vvH1W6tezLi+5YEE0BaKT/kjd4ZAhsIIps05hyoVqhVx9YQcofy6tvH8QfsAIDbVOcnm
         8CQIt19LFOxB4XGYH6kenybeEv5etghr605gpFKiOtsNT6QjMY1xth1eu5Crs/Ofv0iC
         hVZg==
X-Forwarded-Encrypted: i=1; AJvYcCVE9x8EfjzmdEsPb7NANn7MXneTkBrfaXNUCabwkBXNq06JlTaFW8ivMHd3uNC3kB858JNLiZpykpHG4zk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi8UA8d6yXJJgx/2JGr9yq6I1NwG1bbVbZikcSsrOt/SUKM/Rd
	wZZi0XhqYyB5okw02jqkxXEGuefsWmFM/j9/Wk3frkC/KhfzOEk+wcybJkZqN7OxBdv77oXfzBi
	bpNPvhLUtaYKZ9LRcFZDnj/2+L7uqasDCMY0HSI/NxnEeJSbKXv7CWJNAoJE=
X-Google-Smtp-Source: AGHT+IGa8pL5m5ewYmYgBeQ5nguUiVBpoaKYGf1+lKXmP+2AEgrh0FTTEVg1/MhztW1zBSuJ+aewZLrLnM9gauGox70xKcqfmHzG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1c05:b0:453:f62:dddc with SMTP id
 5614622812f47-4536e3a415cmr300036b6e.7.1764727046475; Tue, 02 Dec 2025
 17:57:26 -0800 (PST)
Date: Tue, 02 Dec 2025 17:57:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692f9906.a70a0220.d98e3.01ae.GAE@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in adiantum_crypt
From: syzbot <syzbot+703d8a2cd20971854b06@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6cf62f0174de Merge tag 'char-misc-6.18-rc8' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1727df42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61a9bf3cc5d17a01
dashboard link: https://syzkaller.appspot.com/bug?extid=703d8a2cd20971854b06
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bfa112580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=169e422c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fb216361ff9c/disk-6cf62f01.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eb55e25eb970/vmlinux-6cf62f01.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5110f00a1a4e/bzImage-6cf62f01.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7a62729c5268/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=16dd8112580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+703d8a2cd20971854b06@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:150 [inline]
BUG: KMSAN: uninit-value in aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 subshift lib/crypto/aes.c:150 [inline]
 aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
 cipher_crypt_one+0x120/0x2e0 crypto/cipher.c:75
 crypto_cipher_encrypt_one+0x33/0x40 crypto/cipher.c:82
 adiantum_crypt+0x939/0xe60 crypto/adiantum.c:383
 adiantum_encrypt+0x33/0x40 crypto/adiantum.c:419
 crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:195
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio fs/ext4/inode.c:2080 [inline]
 mpage_map_and_submit_buffers fs/ext4/inode.c:2324 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2514 [inline]
 ext4_do_writepages+0x3c08/0x8020 fs/ext4/inode.c:2931
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
 do_writepages+0x3f2/0x860 mm/page-writeback.c:2604
 __writeback_single_inode+0x101/0x1190 fs/fs-writeback.c:1719
 writeback_sb_inodes+0xac1/0x1cb0 fs/fs-writeback.c:2015
 wb_writeback+0x4ce/0xc00 fs/fs-writeback.c:2195
 wb_do_writeback fs/fs-writeback.c:2342 [inline]
 wb_workfn+0x397/0x1910 fs/fs-writeback.c:2382
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3346
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3427
 kthread+0xd5c/0xf00 kernel/kthread.c:463
 ret_from_fork+0x1f5/0x4c0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 le128_add crypto/adiantum.c:191 [inline]
 adiantum_crypt+0xcf7/0xe60 crypto/adiantum.c:379
 adiantum_encrypt+0x33/0x40 crypto/adiantum.c:419
 crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:195
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio fs/ext4/inode.c:2080 [inline]
 mpage_map_and_submit_buffers fs/ext4/inode.c:2324 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2514 [inline]
 ext4_do_writepages+0x3c08/0x8020 fs/ext4/inode.c:2931
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
 do_writepages+0x3f2/0x860 mm/page-writeback.c:2604
 __writeback_single_inode+0x101/0x1190 fs/fs-writeback.c:1719
 writeback_sb_inodes+0xac1/0x1cb0 fs/fs-writeback.c:2015
 wb_writeback+0x4ce/0xc00 fs/fs-writeback.c:2195
 wb_do_writeback fs/fs-writeback.c:2342 [inline]
 wb_workfn+0x397/0x1910 fs/fs-writeback.c:2382
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3346
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3427
 kthread+0xd5c/0xf00 kernel/kthread.c:463
 ret_from_fork+0x1f5/0x4c0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 adiantum_crypt+0x531/0xe60 crypto/adiantum.c:368
 adiantum_encrypt+0x33/0x40 crypto/adiantum.c:419
 crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:195
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio fs/ext4/inode.c:2080 [inline]
 mpage_map_and_submit_buffers fs/ext4/inode.c:2324 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2514 [inline]
 ext4_do_writepages+0x3c08/0x8020 fs/ext4/inode.c:2931
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
 do_writepages+0x3f2/0x860 mm/page-writeback.c:2604
 __writeback_single_inode+0x101/0x1190 fs/fs-writeback.c:1719
 writeback_sb_inodes+0xac1/0x1cb0 fs/fs-writeback.c:2015
 wb_writeback+0x4ce/0xc00 fs/fs-writeback.c:2195
 wb_do_writeback fs/fs-writeback.c:2342 [inline]
 wb_workfn+0x397/0x1910 fs/fs-writeback.c:2382
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3346
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3427
 kthread+0xd5c/0xf00 kernel/kthread.c:463
 ret_from_fork+0x1f5/0x4c0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 __alloc_frozen_pages_noprof+0x689/0xf00 mm/page_alloc.c:5201
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof mm/mempolicy.c:2507 [inline]
 folio_alloc_noprof+0x109/0x360 mm/mempolicy.c:2517
 filemap_alloc_folio_noprof+0x9d/0x420 mm/filemap.c:1020
 __filemap_get_folio+0xb45/0x1930 mm/filemap.c:2012
 write_begin_get_folio include/linux/pagemap.h:784 [inline]
 ext4_write_begin+0x6d9/0x2d70 fs/ext4/inode.c:1318
 ext4_da_write_begin+0x77c/0x1490 fs/ext4/inode.c:3129
 generic_perform_write+0x365/0x1050 mm/filemap.c:4255
 ext4_buffered_write_iter+0x61a/0xce0 fs/ext4/file.c:299
 ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0xbe2/0x15d0 fs/read_write.c:686
 ksys_pwrite64 fs/read_write.c:793 [inline]
 __do_sys_pwrite64 fs/read_write.c:801 [inline]
 __se_sys_pwrite64 fs/read_write.c:798 [inline]
 __x64_sys_pwrite64+0x2ab/0x3b0 fs/read_write.c:798
 x64_sys_call+0xe77/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:19
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 3651 Comm: kworker/u8:15 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: writeback wb_workfn (flush-7:0)
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
