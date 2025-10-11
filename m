Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18171D5ABA
	for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760194389; cv=none; b=iosDUOZEl0Gp6SDc9VokpwdNPsfcS3LRRFcFWmzTRJCOYDWELaDMaQzZbZd08ZkD25N9WgYNSI+tZ/pLNTqaInNq5JVfOBo4PQil+knGFtMB5CHoOjFlYS9A1sSaMt9ZeL590ViEhVmHJQoQ5+eqNhiB/SYp47NKC6w1DD6YP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760194389; c=relaxed/simple;
	bh=2o6Y4QMJ3kwR1b61kfI6whELDPLh1xqPYbhOWSGGHiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZMjmRKezZlTsUMK4vAWtNQeCBWZsx7dFGJWszwQEyX4++pWn6bRttV6rojS9tVcL/t+clln7ykRLyUE9IJmj4+5rEK1a7tAg4MaFA/JZT+c+mw0bx4Er2UCwlbu0MiECTUKgqbTokcFpueQhuPe9ywiVyUsM2QtcIpj+UxU1y/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0bJ6elz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0bJ6elz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D74C4CEF8
	for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760194389;
	bh=2o6Y4QMJ3kwR1b61kfI6whELDPLh1xqPYbhOWSGGHiI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F0bJ6elzU6UqeDjG9Kkz9AGHwQhI7yEQaKN51HdqSnWX4wO/BMRc3XP6R/suT6KIj
	 1nUjMx27Hx6Egu/ysr/jyYcddXj/otGIXXT13NZ19AWCmzECst+JWdVrOehX3XvT/S
	 YE3BtNMMDN7SVgKpc6j/13St7awvl/DefYfNgu3pLLqEjERtgQZpG8AYOFzZmlKde2
	 ityQXYqSKRhn5ZQJwD4lmtR5S3hhUxED1s/kkuX3lfN5TZvMa+gtCk395BicBA7mgY
	 iH0KT69qi5LD0xKnxJPovAsgecWB45niSfRU+6cUe+To8WXeEfj1R2IH1CupxrR//a
	 8t/4FbYnfaiNw==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5818de29d15so3568782e87.2
        for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 07:53:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUO5q6xrf4jpb3gr8/Q7cyY7q0UTiC6lUcYQdtIkFtC+g6nlwq/8djXdqbJq8ajJGs5wdMwNPb4fbXUJDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOLMjzemV9dq79xv3PRtPY62XDIz4ssXxDJ5/sSVSFOWSJDauS
	KOt9G8z3K5zLqGTyOlzkcLkxmj4wLdSjb4FG4BlUXDHcyLyoYI48r4z0YGNW7usPTmA87Xbwsuo
	ozWlwxmTb+cswJ1XQU0/ltujCICv3sEo=
X-Google-Smtp-Source: AGHT+IHd5tWMLT5Jd4S2AgeDrABowzME9iw/I95pcSe82Sob1tRy3izojgxncoXwecsm4I+jk8GvAwtA52c5jB+Jez4=
X-Received: by 2002:a05:6512:159c:b0:55b:8afb:e644 with SMTP id
 2adb3069b0e04-5906dd6fb34mr4724115e87.31.1760194387810; Sat, 11 Oct 2025
 07:53:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68ea2595.a70a0220.b3ac9.0006.GAE@google.com>
In-Reply-To: <68ea2595.a70a0220.b3ac9.0006.GAE@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 11 Oct 2025 07:52:55 -0700
X-Gmail-Original-Message-ID: <CAMj1kXErR15QWWZXFXjmXgRrxG0Fj_Qjk7OQzbUU+oR7g27RLw@mail.gmail.com>
X-Gm-Features: AS18NWBD8rnIAn6CYsNx800gL6dJWf7ONo_MN0mDMcLg4nt9U0znDH1flp3bTyc
Message-ID: <CAMj1kXErR15QWWZXFXjmXgRrxG0Fj_Qjk7OQzbUU+oR7g27RLw@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in aes_encrypt (6)
To: syzbot <syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

#syz set subsystems: ext4, fscrypt

On Sat, 11 Oct 2025 at 02:38, syzbot
<syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    917167ed1211 Merge tag 'xtensa-20251010' of https://github..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10f55304580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3b820eb4c6dd8482
> dashboard link: https://syzkaller.appspot.com/bug?extid=22bff16a8f91d65e2e58
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> userspace arch: i386
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f8b165efe52b/disk-917167ed.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/01b56300cdc7/vmlinux-917167ed.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6c32d21e8075/bzImage-917167ed.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com
>
> EXT4-fs error (device loop5): ext4_orphan_get:1418: comm syz.5.10451: bad orphan inode 131083
> EXT4-fs (loop5): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
> =====================================================
> BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:150 [inline]
> BUG: KMSAN: uninit-value in aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
>  subshift lib/crypto/aes.c:150 [inline]
>  aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
>  aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
>  crypto_ecb_crypt crypto/ecb.c:23 [inline]
>  crypto_ecb_encrypt2+0x13f/0x300 crypto/ecb.c:40
>  crypto_lskcipher_crypt_sg+0x3a9/0x930 crypto/lskcipher.c:188
>  crypto_lskcipher_encrypt_sg+0x8b/0xc0 crypto/lskcipher.c:207
>  crypto_skcipher_encrypt+0x111/0x1e0 crypto/skcipher.c:194
>  xts_encrypt+0x2e1/0x570 crypto/xts.c:269
>  crypto_skcipher_encrypt+0x187/0x1e0 crypto/skcipher.c:195
>  fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
>  fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
>  ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
>  mpage_submit_folio fs/ext4/inode.c:2080 [inline]
>  mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
>  mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
>  ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
>  ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
>  do_writepages+0x3ef/0x860 mm/page-writeback.c:2604
>  filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
>  __filemap_fdatawrite_range mm/filemap.c:422 [inline]
>  file_write_and_wait_range+0x6f0/0x7d0 mm/filemap.c:797
>  generic_buffers_fsync_noflush+0x79/0x3c0 fs/buffer.c:609
>  ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
>  ext4_sync_file+0x587/0x12f0 fs/ext4/fsync.c:147
>  vfs_fsync_range+0x1a1/0x240 fs/sync.c:187
>  generic_write_sync include/linux/fs.h:3046 [inline]
>  ext4_buffered_write_iter+0xae9/0xce0 fs/ext4/file.c:305
>  ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
>  do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
>  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
>  do_pwritev fs/read_write.c:1153 [inline]
>  __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
>  __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
>  __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
>  ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32.h:380
>  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
>  __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
>  do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
>  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>
> Uninit was stored to memory at:
>  le128_xor include/crypto/b128ops.h:69 [inline]
>  xts_xor_tweak+0x566/0xbd0 crypto/xts.c:123
>  xts_xor_tweak_pre crypto/xts.c:135 [inline]
>  xts_encrypt+0x278/0x570 crypto/xts.c:268
>  crypto_skcipher_encrypt+0x187/0x1e0 crypto/skcipher.c:195
>  fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
>  fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
>  ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
>  mpage_submit_folio fs/ext4/inode.c:2080 [inline]
>  mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
>  mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
>  ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
>  ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
>  do_writepages+0x3ef/0x860 mm/page-writeback.c:2604
>  filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
>  __filemap_fdatawrite_range mm/filemap.c:422 [inline]
>  file_write_and_wait_range+0x6f0/0x7d0 mm/filemap.c:797
>  generic_buffers_fsync_noflush+0x79/0x3c0 fs/buffer.c:609
>  ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
>  ext4_sync_file+0x587/0x12f0 fs/ext4/fsync.c:147
>  vfs_fsync_range+0x1a1/0x240 fs/sync.c:187
>  generic_write_sync include/linux/fs.h:3046 [inline]
>  ext4_buffered_write_iter+0xae9/0xce0 fs/ext4/file.c:305
>  ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
>  do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
>  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
>  do_pwritev fs/read_write.c:1153 [inline]
>  __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
>  __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
>  __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
>  ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32.h:380
>  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
>  __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
>  do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
>  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>
> Uninit was created at:
>  __alloc_frozen_pages_noprof+0x689/0xf00 mm/page_alloc.c:5206
>  alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2416
>  alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
>  alloc_pages_noprof mm/mempolicy.c:2507 [inline]
>  folio_alloc_noprof+0x109/0x360 mm/mempolicy.c:2517
>  filemap_alloc_folio_noprof+0x9d/0x420 mm/filemap.c:1020
>  __filemap_get_folio+0xb45/0x1930 mm/filemap.c:2012
>  write_begin_get_folio include/linux/pagemap.h:784 [inline]
>  ext4_write_begin+0x6d9/0x2d70 fs/ext4/inode.c:1318
>  generic_perform_write+0x362/0x1050 mm/filemap.c:4242
>  ext4_buffered_write_iter+0x61a/0xce0 fs/ext4/file.c:299
>  ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
>  do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
>  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
>  do_pwritev fs/read_write.c:1153 [inline]
>  __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
>  __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
>  __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
>  ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32.h:380
>  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
>  __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
>  do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
>  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>
> CPU: 1 UID: 0 PID: 8113 Comm: syz.5.10451 Tainted: G        W           syzkaller #0 PREEMPT(none)
> Tainted: [W]=WARN
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
> =====================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
