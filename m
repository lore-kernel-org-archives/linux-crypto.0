Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FAE13B787
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 04:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715313749; cv=none; b=sxeUXmvM4Bn8Le6RBHQy4eZ/KBsGaq4xvhYSMzhm5UN/dEfHXDBNNXSQfRFI74XyUKyTZRRPceqAxxtrKPkP/bnjdLGnCC1lENd5um9p4d5ms2F0KmwOJzp4rNTjaYn5y2+/N6qaYdPZGtjey2KBMXhJFVM8L8fOaDLV3Li3zG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715313749; c=relaxed/simple;
	bh=FX4YDm1+K2XG8kzOQ0sYIE8tr2B0jbpKTCbNR6tcPdc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=pGFHs+k0HfotjGw8js2lhyAcsIRx611t7f6dgw/p+NR4nhxKxxGrnfhTQsvCziwOBWBv/6KSu3uLA0AcUGL/WB5VE+fUh3VvemjpCrcW7O0f3MjucOzrjt5YNKFx6vrnNlbwPuXFFv2qfBl972qmoU6SyNaR8HIt0GR4H943vc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e1ba5714efso14734439f.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 May 2024 21:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715313747; x=1715918547;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=If1PDv1uBM3szrPcm69kN2kOnkiY7/ecFpsuuHWQ2ds=;
        b=v0/XPSYi39fR1437wwW4D/2Q1w1YktQaut7Ayl6N5qF967ujGJs4k0oYULWqMCVnfS
         hgME1pYiRgeHfQFskHpFDVaRUw2wKpz7Kj5VMq0DCihLPHhtikNhm0eZjkkadMcoMByJ
         NMfNSiuo7fCQ4XG3GngEc2wayQK5cIJwTgXQstf0aTKfGd8QkWqkqaMRJzDuFeBnVyZM
         5KbHZcmR6BAPM5dDWvBJNGo9hjdDffRQ9ItjFw2/6KM9kIJ5UMd+83bRFupI2rIxRFQX
         os+YCqqSo/MDBvSaKD8ZQrrP3toIxtj5LsPRAQpqnnCSxr2vPs1PfihBGhfbenpKAuAs
         63tw==
X-Forwarded-Encrypted: i=1; AJvYcCWBLJQIAXrm0w4BzcXgjgQVK/Kzqdgw+eFdpMBIQiKuklD+shqLVly82QIpQHttzaNZCZq6QOjEHxhQcX9QNfudLF+cCqTCx7265zcN
X-Gm-Message-State: AOJu0YzHMHgMWswCwIQXuurmwar3BvCulnG8tWFZDgWHffYaQS0EVfn5
	LKYGExKGu2DpNYoVMKzc+pnNoPNTpHMla2RdlIVhFq5OjUpF1xAh9lp14BUcmvNnADWRxYLP7Kf
	we7zykHwO6RXeRY3hNr9H9HMVQSXDTEcM0y53Bpu1uxiC1kPeQvk19Rg=
X-Google-Smtp-Source: AGHT+IHbBwegPr7g9i4rDVm3C4RvodhKYqtM8sMkz5gW79d+RrZRpzYuSXDxq+ROajsAmwDC+0y1nsJ3lbeR5B2XK+/DXiAIRt7u
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1609:b0:7da:bb15:56fd with SMTP id
 ca18e2360f4ac-7e1b51facc1mr7556439f.1.1715313747497; Thu, 09 May 2024
 21:02:27 -0700 (PDT)
Date: Thu, 09 May 2024 21:02:27 -0700
In-Reply-To: <0000000000000fe556061725a7be@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099249d0618119a0c@google.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in aes_encrypt (5)
From: syzbot <syzbot+aeb14e2539ffb6d21130@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    45db3ab70092 Merge tag '6.9-rc7-ksmbd-fixes' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14d9bfdf180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=617171361dd3cd47
dashboard link: https://syzkaller.appspot.com/bug?extid=aeb14e2539ffb6d21130
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1617adb8980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112f45d4980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/232e7c2a73a5/disk-45db3ab7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7e9bf7c936ab/vmlinux-45db3ab7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5e8f98ee02d8/bzImage-45db3ab7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/fcc88c919ed9/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aeb14e2539ffb6d21130@syzkaller.appspotmail.com

fscrypt: AES-256-XTS using implementation "xts(ecb(aes-fixed-time))"
=====================================================
BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:149 [inline]
BUG: KMSAN: uninit-value in aes_encrypt+0x15cc/0x1db0 lib/crypto/aes.c:282
 subshift lib/crypto/aes.c:149 [inline]
 aes_encrypt+0x15cc/0x1db0 lib/crypto/aes.c:282
 aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
 crypto_ecb_crypt crypto/ecb.c:23 [inline]
 crypto_ecb_encrypt2+0x18a/0x300 crypto/ecb.c:40
 crypto_lskcipher_crypt_sg+0x36b/0x7f0 crypto/lskcipher.c:228
 crypto_lskcipher_encrypt_sg+0x8a/0xc0 crypto/lskcipher.c:247
 crypto_skcipher_encrypt+0x119/0x1e0 crypto/skcipher.c:669
 xts_encrypt+0x3c4/0x550 crypto/xts.c:269
 crypto_skcipher_encrypt+0x1a0/0x1e0 crypto/skcipher.c:671
 fscrypt_crypt_data_unit+0x4ee/0x8f0 fs/crypto/crypto.c:144
 fscrypt_encrypt_pagecache_blocks+0x422/0x900 fs/crypto/crypto.c:207
 ext4_bio_write_folio+0x13db/0x2e40 fs/ext4/page-io.c:526
 mpage_submit_folio+0x351/0x4a0 fs/ext4/inode.c:1869
 mpage_process_page_bufs+0xb92/0xe30 fs/ext4/inode.c:1982
 mpage_prepare_extent_to_map+0x1702/0x22c0 fs/ext4/inode.c:2490
 ext4_do_writepages+0x1117/0x62e0 fs/ext4/inode.c:2632
 ext4_writepages+0x312/0x830 fs/ext4/inode.c:2768
 do_writepages+0x427/0xc30 mm/page-writeback.c:2612
 filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x1bf/0x370 mm/filemap.c:788
 generic_buffers_fsync_noflush+0x84/0x3e0 fs/buffer.c:602
 ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
 ext4_sync_file+0x5ba/0x13a0 fs/ext4/fsync.c:151
 vfs_fsync_range+0x20d/0x270 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2795 [inline]
 ext4_buffered_write_iter+0x9ad/0xaa0 fs/ext4/file.c:305
 ext4_file_write_iter+0x208/0x3450
 call_write_iter include/linux/fs.h:2110 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb63/0x1520 fs/read_write.c:590
 ksys_write+0x20f/0x4c0 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0x93/0xe0 fs/read_write.c:652
 x64_sys_call+0x3062/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:2
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 le128_xor include/crypto/b128ops.h:69 [inline]
 xts_xor_tweak+0x4ae/0xbf0 crypto/xts.c:123
 xts_xor_tweak_pre crypto/xts.c:135 [inline]
 xts_encrypt+0x296/0x550 crypto/xts.c:268
 crypto_skcipher_encrypt+0x1a0/0x1e0 crypto/skcipher.c:671
 fscrypt_crypt_data_unit+0x4ee/0x8f0 fs/crypto/crypto.c:144
 fscrypt_encrypt_pagecache_blocks+0x422/0x900 fs/crypto/crypto.c:207
 ext4_bio_write_folio+0x13db/0x2e40 fs/ext4/page-io.c:526
 mpage_submit_folio+0x351/0x4a0 fs/ext4/inode.c:1869
 mpage_process_page_bufs+0xb92/0xe30 fs/ext4/inode.c:1982
 mpage_prepare_extent_to_map+0x1702/0x22c0 fs/ext4/inode.c:2490
 ext4_do_writepages+0x1117/0x62e0 fs/ext4/inode.c:2632
 ext4_writepages+0x312/0x830 fs/ext4/inode.c:2768
 do_writepages+0x427/0xc30 mm/page-writeback.c:2612
 filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x1bf/0x370 mm/filemap.c:788
 generic_buffers_fsync_noflush+0x84/0x3e0 fs/buffer.c:602
 ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
 ext4_sync_file+0x5ba/0x13a0 fs/ext4/fsync.c:151
 vfs_fsync_range+0x20d/0x270 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2795 [inline]
 ext4_buffered_write_iter+0x9ad/0xaa0 fs/ext4/file.c:305
 ext4_file_write_iter+0x208/0x3450
 call_write_iter include/linux/fs.h:2110 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb63/0x1520 fs/read_write.c:590
 ksys_write+0x20f/0x4c0 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0x93/0xe0 fs/read_write.c:652
 x64_sys_call+0x3062/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:2
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __alloc_pages+0x9d6/0xe70 mm/page_alloc.c:4598
 alloc_pages_mpol+0x299/0x990 mm/mempolicy.c:2264
 alloc_pages mm/mempolicy.c:2335 [inline]
 folio_alloc+0x1d0/0x230 mm/mempolicy.c:2342
 filemap_alloc_folio+0xa6/0x440 mm/filemap.c:984
 __filemap_get_folio+0xa10/0x14b0 mm/filemap.c:1926
 ext4_write_begin+0x3e5/0x2230 fs/ext4/inode.c:1159
 generic_perform_write+0x400/0xc60 mm/filemap.c:3974
 ext4_buffered_write_iter+0x564/0xaa0 fs/ext4/file.c:299
 ext4_file_write_iter+0x208/0x3450
 call_write_iter include/linux/fs.h:2110 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb63/0x1520 fs/read_write.c:590
 ksys_write+0x20f/0x4c0 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0x93/0xe0 fs/read_write.c:652
 x64_sys_call+0x3062/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:2
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 PID: 5048 Comm: syz-executor132 Not tainted 6.9.0-rc7-syzkaller-00056-g45db3ab70092 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
