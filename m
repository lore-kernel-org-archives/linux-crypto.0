Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C488A24C676
	for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 09:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760175516; cv=none; b=DSIB/iLf9h98qtbq5tW44GjOGyux643yKWgfh5J0bMeQHMCY3mm8WeFDVuRoeEmb4YIGMZdg38ToAENHzLmLH43eGSTtr2I+GxgWSYDnpPHJKO967YmKpGk9rx2IEj8SQ/TTwsRZH41pWNt1LPQ8/aPVw7UXPYzc09D41DvVwPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760175516; c=relaxed/simple;
	bh=ZWZC3HR46WYmZ+8wzKB+Mk3y8cRFGoWt9AmI9Ho+J1U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TBcuv1tA9uKAyWMLGGxbYsT6NDpGwREh/2qc9u87Eywa2My7VEWvKqI3Q/q7Dc9Ddw4JLs+EmiSj4svhHQSQHjZ9Js/qXlsAPbYeWCoY/sugFTs8ERRtKsyrclH6x/nnWY5NWZOt9xsATQMm1ufLyEfMjgjHBx/lhufu4MSS76Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-927b19c5023so910822439f.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 02:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760175510; x=1760780310;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qpbRsa3rH9NfN3OftlUqfAnYoUCJIa24fvvL2Z31K3Q=;
        b=NGn75PzwAJGmcugBndh0Uq/835OEC9OnL/i7SUBN0Mim8weQya+oHsm69uJD46F4KW
         Vvx+CMKNiy2ssmPP3dxbK0UNdX0/1XQUjXYKB0n7XHLyBeaqnYKXN7fqwG43PagwOh+6
         p2QVayPYLxF+ltlaTYyePpAIY9OONjPzlxD+wmz5NK7fVKlCMZqQeyEQNCE+tdXzwPd0
         uUQjzNZWkH1nUVgA8UIzR/3uOyWq85rNVjFWfmBG51onNnnWwcj4yGB14cYRKSJW92Wb
         w+eM/3JlsUQUb0TBRTadWE5HI7gUuP873kmR7jknL1T8SnXw/hRgIZb74lpFeq/MtFPz
         VHzw==
X-Forwarded-Encrypted: i=1; AJvYcCVgkjD6NtBemcS6mn3i9EoDserchzbFTNaO+lczAFEnitkorQR1g+tYv99xg41jWOv8U+ZVuc5WcdXiB/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5CyRaU3vxJzRCuEV1sV+Zzi8MYNhb6JdY5/krEO2o5Zt8baPd
	rYOY8kghNcvvFscSkrD5pN0BzrjVeeasRaMr2xFOfR8+kPn0XWRvUMQ16kUMWXCVy7LUu7ByI3s
	adxURRXLFyJXzMltaISl94JfKciIU1LyFtUMSprOhtcgUICZUkPzsf16ugUU=
X-Google-Smtp-Source: AGHT+IHM/rntsLiZunZBSSBSqNrgrOW90+ZD6KjWJ/TgxEWZl1XjzGEoPljnpS68ATEB6KSEPhYXN6gw68sIgn/2djy8mER+yCED
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d16:b0:921:2f68:fa4 with SMTP id
 ca18e2360f4ac-93bd182ffbcmr2029171639f.4.1760175509938; Sat, 11 Oct 2025
 02:38:29 -0700 (PDT)
Date: Sat, 11 Oct 2025 02:38:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ea2595.a70a0220.b3ac9.0006.GAE@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in aes_encrypt (6)
From: syzbot <syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    917167ed1211 Merge tag 'xtensa-20251010' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f55304580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b820eb4c6dd8482
dashboard link: https://syzkaller.appspot.com/bug?extid=22bff16a8f91d65e2e58
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f8b165efe52b/disk-917167ed.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/01b56300cdc7/vmlinux-917167ed.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6c32d21e8075/bzImage-917167ed.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com

EXT4-fs error (device loop5): ext4_orphan_get:1418: comm syz.5.10451: bad orphan inode 131083
EXT4-fs (loop5): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
=====================================================
BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:150 [inline]
BUG: KMSAN: uninit-value in aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 subshift lib/crypto/aes.c:150 [inline]
 aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
 crypto_ecb_crypt crypto/ecb.c:23 [inline]
 crypto_ecb_encrypt2+0x13f/0x300 crypto/ecb.c:40
 crypto_lskcipher_crypt_sg+0x3a9/0x930 crypto/lskcipher.c:188
 crypto_lskcipher_encrypt_sg+0x8b/0xc0 crypto/lskcipher.c:207
 crypto_skcipher_encrypt+0x111/0x1e0 crypto/skcipher.c:194
 xts_encrypt+0x2e1/0x570 crypto/xts.c:269
 crypto_skcipher_encrypt+0x187/0x1e0 crypto/skcipher.c:195
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio fs/ext4/inode.c:2080 [inline]
 mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
 mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
 ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
 do_writepages+0x3ef/0x860 mm/page-writeback.c:2604
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
 do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
 vfs_writev+0x52a/0x1500 fs/read_write.c:1057
 do_pwritev fs/read_write.c:1153 [inline]
 __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
 __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
 __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
 ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32.h:380
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was stored to memory at:
 le128_xor include/crypto/b128ops.h:69 [inline]
 xts_xor_tweak+0x566/0xbd0 crypto/xts.c:123
 xts_xor_tweak_pre crypto/xts.c:135 [inline]
 xts_encrypt+0x278/0x570 crypto/xts.c:268
 crypto_skcipher_encrypt+0x187/0x1e0 crypto/skcipher.c:195
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio fs/ext4/inode.c:2080 [inline]
 mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
 mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
 ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
 do_writepages+0x3ef/0x860 mm/page-writeback.c:2604
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
 do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
 vfs_writev+0x52a/0x1500 fs/read_write.c:1057
 do_pwritev fs/read_write.c:1153 [inline]
 __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
 __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
 __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
 ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32.h:380
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

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
 generic_perform_write+0x362/0x1050 mm/filemap.c:4242
 ext4_buffered_write_iter+0x61a/0xce0 fs/ext4/file.c:299
 ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
 do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
 vfs_writev+0x52a/0x1500 fs/read_write.c:1057
 do_pwritev fs/read_write.c:1153 [inline]
 __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
 __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
 __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
 ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32.h:380
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 1 UID: 0 PID: 8113 Comm: syz.5.10451 Tainted: G        W           syzkaller #0 PREEMPT(none) 
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
