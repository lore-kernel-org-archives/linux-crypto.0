Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0CB11CAB
	for <linux-crypto@vger.kernel.org>; Mon, 22 Apr 2024 05:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713765560; cv=none; b=DD3g+QbJ5X4wi127J08F5JpnIUM+8NRRtCUIGj10DlcInXeIdz87qOM9O2ZzL06zVp6pUJolnIRw1U/7SrcXesbt/citY78e8F8zJQMQLGgWSgawTQimmHy8ODDvM0AtkqVt56+MribpX+GH/gezrI4l9ZW64F+Sc1OOCtywAQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713765560; c=relaxed/simple;
	bh=D79eC8RJMKbFce8fku++21OGsQR2++flL3fDDqwdG7o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=AyUJG2HYZryfGHGQj/ab72CiQVhMmYWoHKp9Y13Gc9K41lCDc+ifV+bUq0+34VGrV4eUjDcfIaXlHDPweFX2MxL2GPh9ZJa71ywqiEqBnkBiLVNZaF7OBrLz7qnwvKj1Wfq80sU8O9ABNq/ZDH7dXC8IC3ZI7rGXC98t3bwHVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36c09a7173dso13933785ab.2
        for <linux-crypto@vger.kernel.org>; Sun, 21 Apr 2024 22:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713765557; x=1714370357;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2d2NpQ9xAPEYhugtPsQxFL11CSDyYRVuV6nMVsTlPI=;
        b=mVqNGACeFue+Gkdy4EmgIbGYTzLvwQ7rh5PiiFUViRup5ZHSXstmXIGJnn+YTkYi/N
         vdoNQsZgJ64g2KKI8BNk9+i4Yp/1pqGEBOU6XYIhXBSTXOq+sOJjL6BM8/T66JHMcFcw
         HGya+L9a7AuPfMYFx2CrRRkAEA5s7TkuQy48zGAj7h8/MhsacdeVkk3hzKeoBYHDNii4
         XogYiBk9zbj2pWvhKZllWwzTYQVa5+QJm5gK3mk49lMZZb4BV8+UexN2Dexcluv6FHsB
         knSP1MTNbV0/AFwoxeLj85iNvj0xi7+5ClHImSu/Qi7O62idUfA34nIeEyTKrjvxpxYc
         2x2w==
X-Forwarded-Encrypted: i=1; AJvYcCV7+0/thP0GdovbIEk14f6lWQ/LjX36TqAI3Cj6xDvwKmP1/1tukSEKtyIp7lCVYfV4qXsliBshoWNiZnjSJl8a1fz3B+fG8Uf8+QH5
X-Gm-Message-State: AOJu0YwqHW+vSrhBrusUDoTO0hNwEhHjq9Ru0buvaCjjgXemSMrI11Hy
	K/WmTvoJt1sSS3oxzikummoH7SLjgjsXPXIL8HrtWcOVw6RchBHVKW8CyxGF8zhEx5Xwi25VGJ5
	swI4KXx/Z+lMWEoFo68J99jHVG8OEBQiB1lVLbwNwnoVLruwfRWly3BI=
X-Google-Smtp-Source: AGHT+IGiKq6tLFsZZugvLy4A9PfNmkP00nQs83eDbIUn9ZWGg5P4PZUUYaFKyjyh/wMyfLYwZRIAX/45y/as2MPxo4A86aDUBBwg
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ed:b0:36b:f94f:3022 with SMTP id
 l13-20020a056e0212ed00b0036bf94f3022mr324469iln.5.1713765557765; Sun, 21 Apr
 2024 22:59:17 -0700 (PDT)
Date: Sun, 21 Apr 2024 22:59:17 -0700
In-Reply-To: <000000000000e71ee0060ee5283b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004c9ae20616a923cf@google.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in lzo1x_1_do_compress (2)
From: syzbot <syzbot+9a049ebdaacbb076e50a@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    3b68086599f8 Merge tag 'sched_urgent_for_v6.9_rc5' of git:..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1717a99f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87a805e655619c64
dashboard link: https://syzkaller.appspot.com/bug?extid=9a049ebdaacbb076e50a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1293271b180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173fe0fd180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6a0c6d102762/disk-3b680865.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/02126711948e/vmlinux-3b680865.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7d390469c033/bzImage-3b680865.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4f2c52f00058/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9a049ebdaacbb076e50a@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in lzo1x_1_do_compress+0x913/0x2510 lib/lzo/lzo1x_compress.c:107
 lzo1x_1_do_compress+0x913/0x2510 lib/lzo/lzo1x_compress.c:107
 lzogeneric1x_1_compress+0x26a/0x11b0 lib/lzo/lzo1x_compress.c:333
 lzo1x_1_compress+0x47/0x80 lib/lzo/lzo1x_compress.c:383
 __lzo_compress crypto/lzo.c:58 [inline]
 lzo_scompress+0x98/0x180 crypto/lzo.c:79
 scomp_acomp_comp_decomp+0x7c6/0xb90
 scomp_acomp_compress+0x32/0x40 crypto/scompress.c:187
 crypto_acomp_compress include/crypto/acompress.h:308 [inline]
 zswap_compress+0x377/0xb10 mm/zswap.c:1040
 zswap_store+0x2180/0x2ca0 mm/zswap.c:1573
 swap_writepage+0x126/0x4c0 mm/page_io.c:198
 shmem_writepage+0x1826/0x1f70 mm/shmem.c:1518
 pageout mm/vmscan.c:660 [inline]
 shrink_folio_list+0x4a55/0x7910 mm/vmscan.c:1323
 evict_folios+0x9d7f/0xcc20 mm/vmscan.c:4537
 try_to_shrink_lruvec+0x160e/0x1a50 mm/vmscan.c:4733
 shrink_one+0x66f/0xd40 mm/vmscan.c:4772
 shrink_many mm/vmscan.c:4835 [inline]
 lru_gen_shrink_node mm/vmscan.c:4935 [inline]
 shrink_node+0x4856/0x55f0 mm/vmscan.c:5894
 kswapd_shrink_node mm/vmscan.c:6704 [inline]
 balance_pgdat mm/vmscan.c:6895 [inline]
 kswapd+0x1eba/0x4460 mm/vmscan.c:7164
 kthread+0x3e2/0x540 kernel/kthread.c:388
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_from_iter lib/iov_iter.c:73 [inline]
 iterate_bvec include/linux/iov_iter.h:122 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:249 [inline]
 iterate_and_advance include/linux/iov_iter.h:271 [inline]
 __copy_from_iter lib/iov_iter.c:249 [inline]
 copy_page_from_iter_atomic+0x12b7/0x2b60 lib/iov_iter.c:481
 generic_perform_write+0x4c1/0xc60 mm/filemap.c:3982
 shmem_file_write_iter+0x2bd/0x2f0 mm/shmem.c:2920
 do_iter_readv_writev+0x7e6/0x960
 vfs_iter_write+0x459/0xd00 fs/read_write.c:895
 lo_write_bvec drivers/block/loop.c:246 [inline]
 lo_write_simple drivers/block/loop.c:267 [inline]
 do_req_filebacked drivers/block/loop.c:491 [inline]
 loop_handle_cmd drivers/block/loop.c:1907 [inline]
 loop_process_work+0x1502/0x3440 drivers/block/loop.c:1942
 loop_rootcg_workfn+0x2b/0x40 drivers/block/loop.c:1973
 process_one_work kernel/workqueue.c:3254 [inline]
 process_scheduled_works+0xa81/0x1bd0 kernel/workqueue.c:3335
 worker_thread+0xea5/0x1560 kernel/workqueue.c:3416
 kthread+0x3e2/0x540 kernel/kthread.c:388
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 ntfs_write_bh+0x652/0xdb0 fs/ntfs3/fsntfs.c:1450
 indx_write fs/ntfs3/index.c:1027 [inline]
 indx_insert_into_root+0x36f4/0x37d0 fs/ntfs3/index.c:1761
 indx_insert_entry+0xe1d/0xee0 fs/ntfs3/index.c:1975
 ntfs_create_inode+0x49b6/0x5100 fs/ntfs3/inode.c:1671
 ntfs_atomic_open+0x90a/0xbb0 fs/ntfs3/namei.c:434
 atomic_open fs/namei.c:3360 [inline]
 lookup_open fs/namei.c:3468 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x2230/0x5b00 fs/namei.c:3796
 do_filp_open+0x20e/0x590 fs/namei.c:3826
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_creat fs/open.c:1497 [inline]
 __se_sys_creat fs/open.c:1491 [inline]
 __x64_sys_creat+0xe6/0x140 fs/open.c:1491
 x64_sys_call+0x2966/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:86
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 hdr_insert_de+0x3d4/0x3f0 fs/ntfs3/index.c:838
 indx_insert_into_root+0x33f6/0x37d0 fs/ntfs3/index.c:1753
 indx_insert_entry+0xe1d/0xee0 fs/ntfs3/index.c:1975
 ntfs_create_inode+0x49b6/0x5100 fs/ntfs3/inode.c:1671
 ntfs_atomic_open+0x90a/0xbb0 fs/ntfs3/namei.c:434
 atomic_open fs/namei.c:3360 [inline]
 lookup_open fs/namei.c:3468 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x2230/0x5b00 fs/namei.c:3796
 do_filp_open+0x20e/0x590 fs/namei.c:3826
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_creat fs/open.c:1497 [inline]
 __se_sys_creat fs/open.c:1491 [inline]
 __x64_sys_creat+0xe6/0x140 fs/open.c:1491
 x64_sys_call+0x2966/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:86
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3804 [inline]
 slab_alloc_node mm/slub.c:3845 [inline]
 kmem_cache_alloc+0x5b6/0xbe0 mm/slub.c:3852
 ntfs_create_inode+0x5e0/0x5100 fs/ntfs3/inode.c:1314
 ntfs_atomic_open+0x90a/0xbb0 fs/ntfs3/namei.c:434
 atomic_open fs/namei.c:3360 [inline]
 lookup_open fs/namei.c:3468 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x2230/0x5b00 fs/namei.c:3796
 do_filp_open+0x20e/0x590 fs/namei.c:3826
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_creat fs/open.c:1497 [inline]
 __se_sys_creat fs/open.c:1491 [inline]
 __x64_sys_creat+0xe6/0x140 fs/open.c:1491
 x64_sys_call+0x2966/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:86
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 PID: 80 Comm: kswapd0 Not tainted 6.9.0-rc4-syzkaller-00274-g3b68086599f8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
