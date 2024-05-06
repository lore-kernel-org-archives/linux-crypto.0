Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC23381AA
	for <linux-crypto@vger.kernel.org>; Mon,  6 May 2024 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007502; cv=none; b=fNK7gP00RrLsAf864XdH3qz+rGXaTbrNQGPBQZ6o2kPPxoQFKvO5VTx5Ki5kM0mB9IlM+g/YZZEStEov9G1TPdeLfWYpzsd2zH9Dlq8xqgT9OwJYZahm0TR5XkGzmIqpVjFdgIw8SNfZfWXv3desVdspe+riGu0oHMQSa+y33FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007502; c=relaxed/simple;
	bh=dMu+g6NI3r9C6CMUMkC5JFPFB2iMl4cMfZ+o7TZ93u0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AqLuD0ARf45ZPUI0H6BLi9J0agEPO53y/knUTfqwzz4d6ueYNCnALCcHLBOHf7cwg2sVaOnk3yp+WIWK6ecnOsKo3ZK0FLAq+kvqs7mkPaNSEMDVvKHmWz95fwgK3pW97G3MiEHGW8VOu+L7aJxP9flWZfWjxZipcJ6fzronNuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7d6bf30c9e3so258747539f.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 May 2024 07:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715007500; x=1715612300;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CKMbgpzsdOZGbxnOE+LTRgGePwYHCQpx8G0wYn3ZvN8=;
        b=UxQFGaq8TdnADyJotxDXVfbrYD/YMzptjREvkJKkja63Hf1S+79kvpE0ugjV3+1IyD
         DsnWSRe2MpJvqILvQoefXXVab+zApsoZvnwDaO5Y4iNLmLccjEZbJ3a2uc/3c9nQZYxp
         5KdeIMoO+hkZOjpdspoDKy/GLFuCD76xY0RrzOQZ3Ba8rO15oQMnC0WUECJhdBlJwIjj
         c5qMJldUE2EA5fRU7lSbI+xOo7cFtFHS0QZYaIoy7TJ7vxzz00sY5dykmA3rq5HQQDPZ
         ywKOi8+2dPLxU9HvIGYiqpiRHeQUHmsfZhDuGXx1KVx77AYhk1H9PppSs0jwyWLChKIo
         zSfg==
X-Forwarded-Encrypted: i=1; AJvYcCWujnFI4hLS44gMU6mlVnt9Xh/KVC93oYIRdEKnRGmrDhityUdc2pBv6b73QOtRIw/m5uKdU2MCh9vLShRQEv6ErZWE/WCqKrnIqGjb
X-Gm-Message-State: AOJu0YxcMRuG6EzFHywbt68PdbW9qm1UvW1rQPSLVUZzIKeMPizKnEF/
	e26/kE+q7Lzm2musb0Vlsv7p+sFLYqE3QAdvCTQwuzD4I71qwNyH1CgKOFPV1RPvS65r5c7cY8H
	rgpheMDiam/s62i0nx6iEj69T+TnawMMoFzmjDYKKy4v9O4beDhghWHA=
X-Google-Smtp-Source: AGHT+IFphbCNbJkDMDAjh+T/FNEhX4UAlt9FmOZ5M2Cp+TczYHx3fTftuTa6ql011JQRIkwT8OuJEo/m79oyNN4sf8SzEDKmXwLe
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3589:b0:488:c743:c19 with SMTP id
 v9-20020a056638358900b00488c7430c19mr16525jal.4.1715007500195; Mon, 06 May
 2024 07:58:20 -0700 (PDT)
Date: Mon, 06 May 2024 07:58:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d62d530617ca4c33@google.com>
Subject: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in poly1305_update_arch
From: syzbot <syzbot+9375e47164f8e9588f17@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, davem@davemloft.net, 
	herbert@gondor.apana.org.au, hpa@zytor.com, kent.overstreet@linux.dev, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7367539ad4b0 Merge tag 'cxl-fixes-6.9-rc7' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c0b9ff180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=9375e47164f8e9588f17
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112b20e4980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e7ae87180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/03bd77f8af70/disk-7367539a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eb03a61f9582/vmlinux-7367539a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e4c5c654b571/bzImage-7367539a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/50d778114742/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1056ad1f180000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1256ad1f180000
console output: https://syzkaller.appspot.com/x/log.txt?x=1456ad1f180000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9375e47164f8e9588f17@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
loop0: detected capacity change from 0 to 32768
bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 10
==================================================================
BUG: KASAN: slab-out-of-bounds in poly1305_update_arch+0x259/0x7d0 arch/x86/crypto/poly1305_glue.c:198
Read of size 8 at addr ffff8880711a1790 by task syz-executor587/5067

CPU: 0 PID: 5067 Comm: syz-executor587 Not tainted 6.9.0-rc6-syzkaller-00234-g7367539ad4b0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 poly1305_update_arch+0x259/0x7d0 arch/x86/crypto/poly1305_glue.c:198
 crypto_poly1305_update+0x28/0x40 arch/x86/crypto/poly1305_glue.c:230
 bch2_checksum+0x5a9/0x730 fs/bcachefs/checksum.c:228
 bch2_btree_node_read_done+0x109a/0x5a40 fs/bcachefs/btree_io.c:1096
 btree_node_read_work+0x665/0x1300 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x2b64/0x32c0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x431c/0x6390 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1043
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2102
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1903
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1779
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed59dce66a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 1e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd6d591b08 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd6d591b20 RCX: 00007fed59dce66a
RDX: 0000000020011a00 RSI: 0000000020011a40 RDI: 00007ffd6d591b20
RBP: 0000000000000004 R08: 00007ffd6d591b60 R09: 00000000000119f3
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffd6d591b60 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

Allocated by task 5066:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slub.c:3966 [inline]
 __kmalloc+0x233/0x4a0 mm/slub.c:3979
 kmalloc include/linux/slab.h:632 [inline]
 tomoyo_realpath_from_path+0xcf/0x5e0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x2b7/0x740 security/tomoyo/file.c:822
 security_inode_getattr+0xd8/0x130 security/security.c:2269
 vfs_getattr+0x45/0x430 fs/stat.c:173
 vfs_statx+0x1a5/0x4e0 fs/stat.c:248
 vfs_fstatat+0x135/0x190 fs/stat.c:304
 __do_sys_newfstatat fs/stat.c:468 [inline]
 __se_sys_newfstatat fs/stat.c:462 [inline]
 __x64_sys_newfstatat+0x117/0x190 fs/stat.c:462
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5066:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xa6/0xe0 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2106 [inline]
 slab_free mm/slub.c:4280 [inline]
 kfree+0x153/0x3a0 mm/slub.c:4390
 tomoyo_realpath_from_path+0x5a9/0x5e0 security/tomoyo/realpath.c:286
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x2b7/0x740 security/tomoyo/file.c:822
 security_inode_getattr+0xd8/0x130 security/security.c:2269
 vfs_getattr+0x45/0x430 fs/stat.c:173
 vfs_statx+0x1a5/0x4e0 fs/stat.c:248
 vfs_fstatat+0x135/0x190 fs/stat.c:304
 __do_sys_newfstatat fs/stat.c:468 [inline]
 __se_sys_newfstatat fs/stat.c:462 [inline]
 __x64_sys_newfstatat+0x117/0x190 fs/stat.c:462
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880711a0000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1936 bytes to the right of
 allocated 4096-byte region [ffff8880711a0000, ffff8880711a1000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x711a0
head: order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000840(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000000840 ffff888015042140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
head: 00fff00000000840 ffff888015042140 dead000000000122 0000000000000000
head: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
head: 00fff00000000003 ffffea0001c46801 dead000000000122 00000000ffffffff
head: 0000000800000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5066, tgid 536082784 (udevd), ts 5066, free_ts 15045477140
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1ea/0x210 mm/page_alloc.c:1534
 prep_new_page mm/page_alloc.c:1541 [inline]
 get_page_from_freelist+0x3410/0x35b0 mm/page_alloc.c:3317
 __alloc_pages+0x256/0x6c0 mm/page_alloc.c:4575
 __alloc_pages_node include/linux/gfp.h:238 [inline]
 alloc_pages_node include/linux/gfp.h:261 [inline]
 alloc_slab_page+0x5f/0x160 mm/slub.c:2175
 allocate_slab mm/slub.c:2338 [inline]
 new_slab+0x84/0x2f0 mm/slub.c:2391
 ___slab_alloc+0xc73/0x1260 mm/slub.c:3525
 __slab_alloc mm/slub.c:3610 [inline]
 __slab_alloc_node mm/slub.c:3663 [inline]
 slab_alloc_node mm/slub.c:3835 [inline]
 __do_kmalloc_node mm/slub.c:3965 [inline]
 __kmalloc+0x2e5/0x4a0 mm/slub.c:3979
 kmalloc include/linux/slab.h:632 [inline]
 tomoyo_realpath_from_path+0xcf/0x5e0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x2b7/0x740 security/tomoyo/file.c:822
 security_inode_getattr+0xd8/0x130 security/security.c:2269
 vfs_getattr+0x45/0x430 fs/stat.c:173
 vfs_statx+0x1a5/0x4e0 fs/stat.c:248
 vfs_fstatat+0x135/0x190 fs/stat.c:304
 __do_sys_newfstatat fs/stat.c:468 [inline]
 __se_sys_newfstatat fs/stat.c:462 [inline]
 __x64_sys_newfstatat+0x117/0x190 fs/stat.c:462
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1141 [inline]
 free_unref_page_prepare+0x97b/0xaa0 mm/page_alloc.c:2347
 free_unref_page+0x37/0x3f0 mm/page_alloc.c:2487
 free_contig_range+0x9e/0x160 mm/page_alloc.c:6572
 destroy_args+0x8a/0x890 mm/debug_vm_pgtable.c:1036
 debug_vm_pgtable+0x4be/0x550 mm/debug_vm_pgtable.c:1416
 do_one_initcall+0x248/0x880 init/main.c:1245
 do_initcall_level+0x157/0x210 init/main.c:1307
 do_initcalls+0x3f/0x80 init/main.c:1323
 kernel_init_freeable+0x435/0x5d0 init/main.c:1555
 kernel_init+0x1d/0x2b0 init/main.c:1444
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff8880711a1680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880711a1700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880711a1780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff8880711a1800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880711a1880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
