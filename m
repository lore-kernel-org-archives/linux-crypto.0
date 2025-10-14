Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6372FF64C
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760453439; cv=none; b=jrbl+hik/Ydw2cas/E6sjrDjZ3StSqHaqusG5TVTv/p77fWtUMq9MTgB3WeHIeLXFxulKkJytGbezU2g5TU3hiwzszLyxu9fV+zrEd2xbnGa1R4su5NUkcKg3ddcYtXWp1XsU6s2dKj+KZRabaJcapyIoYAWUmGBrv7wg8+hyIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760453439; c=relaxed/simple;
	bh=WBIdf1PaikHecpubelq05cegP0L27isbRJGMXaU/Dk0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lZ+vchaD1rhTD/HAM9W9IiWpCZlfhOFValw+lLruQbo1X7f/NG4Xx94U7plZYxtEhn7PkENWggji/hFtRFfnWqajH9rRRZMupA1ioIgWG5n0D/MXiVdBR3XsSD7LrZ+00I7V4BDaR2gduQbIVWFZMltT5aZdE1y33U/4W2roPDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-42f9bf61913so121156935ab.3
        for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 07:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453437; x=1761058237;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z8PtWzect3QXv79Fy+/g+zWxxtYKh2X3YZ2rtikGVGg=;
        b=ZIeti641Z2EDqjFVIm15aKqY4WH+8PmU4tC89PxQcMRlCkx0wcGH5IS1RvHeNmT5GR
         d/VOZSshT0SVdxZI4b2xQsYOUGUxLj4yWCkb0FJghEbNQCcEU5c+H3rxORLjHkDE8ct5
         PzeX0YhLfWfXUUbnBfPVr9xcnRWNTu53HSrbSQCkIDcmurxArL64H/CRfyIDFPsDaMTK
         HQnO5d9Yh7AofTByon5zB0V84wmMTJGQvh7txbBPhuDTXNvB8YHGZfklO+cRD0WmCfMH
         U4WodN/js6W++EPUuXbbnAWh4+gcJ+QTvCrwGRkboA7Difo3xUq2zjEkengUa6QdZRve
         feyA==
X-Forwarded-Encrypted: i=1; AJvYcCXd+DdQhiO4AkkIOdc3nNKRdMjREP809aeMAKbJ4xYLcV1rGHwts07+DN4QSRBZgA5D9bF/2+T191Iixg8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy89quXXp2AnrL4GhfNhTNUn5dPjwbjAqPURsMHKn8Ww2xQcuwg
	4EYtrpeyZAlB+Jw4PUw+gsotl1dPxwVwkJwZClW5Q2kV3hgLhSFLAmCp4ncq23I7Ri11MxVaz3w
	VUQR3rwvze/p6MAfqDZMR7p2ZnrLjNU7jkcCrpGmludPUegxOn+7g7whD+f0=
X-Google-Smtp-Source: AGHT+IF2wEZJR1y/MWn185G0kFP/ky/VeNQhv6GND9ix7rMYc8ScAwUgiVo1GUD7YVemWjNoghs2OMHskRick/iqhhIzQX7akfGJ
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1544:b0:42f:9e92:a434 with SMTP id
 e9e14a558f8ab-42f9e92bb45mr140891015ab.21.1760453436724; Tue, 14 Oct 2025
 07:50:36 -0700 (PDT)
Date: Tue, 14 Oct 2025 07:50:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ee633c.050a0220.1186a4.002a.GAE@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in fscrypt_crypt_data_unit
From: syzbot <syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3a8660878839 Linux 6.18-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d25dcd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbd3e7f3c2e28265
dashboard link: https://syzkaller.appspot.com/bug?extid=7add5c56bc2a14145d20
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d996feb56093/disk-3a866087.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa6f6bc3b02a/vmlinux-3a866087.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7571083a68d6/bzImage-3a866087.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com

EXT4-fs (loop5): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: writeback.
=====================================================
BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:150 [inline]
BUG: KMSAN: uninit-value in aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 subshift lib/crypto/aes.c:150 [inline]
 aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
 crypto_ecb_crypt crypto/ecb.c:23 [inline]
 crypto_ecb_encrypt2+0x142/0x300 crypto/ecb.c:40
 crypto_lskcipher_crypt_sg+0x3ac/0x930 crypto/lskcipher.c:188
 crypto_lskcipher_encrypt_sg+0x8b/0xc0 crypto/lskcipher.c:207
 crypto_skcipher_encrypt+0x111/0x1e0 crypto/skcipher.c:194
 xts_encrypt+0x2e1/0x570 crypto/xts.c:269
 crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:195
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio fs/ext4/inode.c:2080 [inline]
 mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
 mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
 ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
 do_writepages+0x3f2/0x860 mm/page-writeback.c:2604
 filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
 __filemap_fdatawrite_range mm/filemap.c:422 [inline]
 file_write_and_wait_range+0x6f0/0x7d0 mm/filemap.c:797
 generic_buffers_fsync_noflush+0x79/0x3c0 fs/buffer.c:609
 ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
 ext4_sync_file+0x587/0x12f0 fs/ext4/fsync.c:147
 vfs_fsync_range+0x1a1/0x240 fs/sync.c:187
 generic_write_sync include/linux/fs.h:3046 [inline]
 ext4_buffered_write_iter+0xae9/0xce0 fs/ext4/file.c:305
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

Uninit was stored to memory at:
 le128_xor include/crypto/b128ops.h:69 [inline]
 xts_xor_tweak+0x566/0xbd0 crypto/xts.c:123
 xts_xor_tweak_pre crypto/xts.c:135 [inline]
 xts_encrypt+0x278/0x570 crypto/xts.c:268
 crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:195
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio fs/ext4/inode.c:2080 [inline]
 mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
 mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
 ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
 do_writepages+0x3f2/0x860 mm/page-writeback.c:2604
 filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
 __filemap_fdatawrite_range mm/filemap.c:422 [inline]
 file_write_and_wait_range+0x6f0/0x7d0 mm/filemap.c:797
 generic_buffers_fsync_noflush+0x79/0x3c0 fs/buffer.c:609
 ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
 ext4_sync_file+0x587/0x12f0 fs/ext4/fsync.c:147
 vfs_fsync_range+0x1a1/0x240 fs/sync.c:187
 generic_write_sync include/linux/fs.h:3046 [inline]
 ext4_buffered_write_iter+0xae9/0xce0 fs/ext4/file.c:305
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

Uninit was created at:
 __alloc_frozen_pages_noprof+0x689/0xf00 mm/page_alloc.c:5206
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof mm/mempolicy.c:2507 [inline]
 folio_alloc_noprof+0x109/0x360 mm/mempolicy.c:2517
 filemap_alloc_folio_noprof+0x9d/0x420 mm/filemap.c:1020
 __filemap_get_folio+0xb45/0x1930 mm/filemap.c:2012
 write_begin_get_folio include/linux/pagemap.h:784 [inline]
 ext4_write_begin+0x6d9/0x2d70 fs/ext4/inode.c:1318
 generic_perform_write+0x365/0x1050 mm/filemap.c:4242
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

CPU: 1 UID: 0 PID: 5879 Comm: syz.5.3882 Tainted: G        W           syzkaller #0 PREEMPT(none) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
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
