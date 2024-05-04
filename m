Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8379A17550
	for <linux-crypto@vger.kernel.org>; Sat,  4 May 2024 09:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714816651; cv=none; b=Xr/fcvxKBojCzZi/BOfPAHo9SoCrux7fZOYdobqoN6RkZ7k5unIwgfNhUSNW02AkMtsy11Xa37l9JAI7zvGb2vkiRhur9tCKMttknpboyy3YhYAkEnd4RkpTGx/j7D7IBdDq0qTM8nzT7yvfZmhqCWrUyQYmqPY5YLi9QGiPbjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714816651; c=relaxed/simple;
	bh=quHTecvUIKqm7t81ymnmqetwBusXjGNW8ywKmF/J+F4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u3ZPi5KF49AWCYPrVEcPFr4W85VEbfSWCfBrivuMcOu1D/2MLl0DLpNv6j4v5ZK8Pv3T9MaewXZEmkC4pwYdvffpWM+UtJ8juj5BeNpX0AeDsNv3O+3KdlcCJUuI9WPzC6xxGaJ5Xmz+eDfFjMd8Thq5JBQ7LwTBcW4adeHTovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7e15eaeef60so28280939f.1
        for <linux-crypto@vger.kernel.org>; Sat, 04 May 2024 02:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714816649; x=1715421449;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U62vJ6jjysNLagWXTsewxexQRONTjEFIrU/oNk5SnpU=;
        b=coDgcx99tIU1rIfY7l4TmWbJDJan6v4Z3gSfpKzBwkRiEZ+XV157NslpvvO03nQBfh
         xlB06Csd7KG+gUvH7ZIwiXXPgOHuQMaoeK30TQsSPpbqasmxnUU8C6GsE1wtsVf4aqrX
         l1CuBwpTsqjsiUE3vjzhCgsMgWe/ZjNxhqmOxbq0KnSepzTLJCfYL+7ZwWo5OsqZAx51
         FcH6BcAGT3WEgtlCvlX6jERAPztkp71wWXvso5HBpjuW23LQ+k/M7bvljpr8mMFXIMpZ
         8+zI0pmD7hqxJt01zqbEu0oYmbBd4xJ5TIEwsADB6j/4sR2vKSYnsC83lk6ChY+Be0A/
         z3Jw==
X-Forwarded-Encrypted: i=1; AJvYcCVKsE8dp4buqWGDdrxhyGZBZT1ZwGjhftqvq8cfTDLl10Rne84q9cvxlsklokcIx02oNpV8SJrCsQJBegJtoeby0zIu8QAqzE72l6g8
X-Gm-Message-State: AOJu0YxwnX5XvQdAZM/xAQzZTxcC2J1V9SYFO6PCIGNWa0Hr3mPUxVby
	YYyYs51GTvzD9zOX7Zo+IOKXnkVoA//VaAC/D1RQbAdQdf3as3ZeMpcp0dO/v5LxxQtK8QF9UhK
	uDL5rVWSW+bJ4wsBK2gyedu+qHigft4OmjMTfDSrLWUmQYpjdKYVIX/s=
X-Google-Smtp-Source: AGHT+IF3+P9yjc45SQpvTz1Idl2Gl8va7nxc6vKWIdvyWvVzBhVv+QqfCckG4kH7QAwg261QlShhJHjfZNL2ueOrD1KrFoecHQXt
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:869c:b0:487:c6e:1bf2 with SMTP id
 iv28-20020a056638869c00b004870c6e1bf2mr275279jab.1.1714816648708; Sat, 04 May
 2024 02:57:28 -0700 (PDT)
Date: Sat, 04 May 2024 02:57:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003392c606179ddd1a@google.com>
Subject: [syzbot] [crypto?] KASAN: use-after-free Read in scatterwalk_copychunks
From: syzbot <syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9221b2819b8a Add linux-next specific files for 20240503
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=130f062f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ab537f51a6a0d98
dashboard link: https://syzkaller.appspot.com/bug?extid=8c4acf719c3fc41e8439
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111abc97180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10059004980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3e67dbdc3c37/disk-9221b281.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ade618fa19f8/vmlinux-9221b281.xz
kernel image: https://storage.googleapis.com/syzbot-assets/df12e5073c97/bzImage-9221b281.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9035c2c41138/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 13
==================================================================
BUG: KASAN: use-after-free in memcpy_dir crypto/scatterwalk.c:23 [inline]
BUG: KASAN: use-after-free in scatterwalk_copychunks+0x1cc/0x460 crypto/scatterwalk.c:38
Read of size 32 at addr ffff888049380000 by task syz-executor169/5094

CPU: 0 PID: 5094 Comm: syz-executor169 Not tainted 6.9.0-rc6-next-20240503-syzkaller #0
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
 memcpy_dir crypto/scatterwalk.c:23 [inline]
 scatterwalk_copychunks+0x1cc/0x460 crypto/scatterwalk.c:38
 skcipher_next_slow+0x39d/0x480 crypto/skcipher.c:276
 skcipher_walk_next+0x634/0xba0 crypto/skcipher.c:361
 chacha_simd_stream_xor+0x67f/0xd10 arch/x86/crypto/chacha_glue.c:192
 do_encrypt_sg fs/bcachefs/checksum.c:107 [inline]
 do_encrypt+0x4de/0x7b0 fs/bcachefs/checksum.c:127
 bset_encrypt fs/bcachefs/btree_io.h:120 [inline]
 bch2_btree_node_read_done+0x1dca/0x5ed0 fs/bcachefs/btree_io.c:1090
 btree_node_read_work+0x665/0x1300 fs/bcachefs/btree_io.c:1345
 bch2_btree_node_read+0x2637/0x2c80 fs/bcachefs/btree_io.c:1730
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1769 [inline]
 bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1793
 read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:472
 bch2_fs_recovery+0x2334/0x36e0 fs/bcachefs/recovery.c:800
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1030
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2105
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa185da797a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcd1a149e8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffcd1a14a00 RCX: 00007fa185da797a
RDX: 000000002000f640 RSI: 000000002000f680 RDI: 00007ffcd1a14a00
RBP: 0000000000000004 R08: 00007ffcd1a14a40 R09: 000000000000f62b
R10: 0000000000010400 R11: 0000000000000282 R12: 0000000000010400
R13: 00007ffcd1a14a40 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x49380
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffff7f(buddy)
raw: 00fff00000000000 ffffea0001249008 ffffea0001223008 0000000000000000
raw: 0000000000000000 0000000000000006 00000000ffffff7f 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x500cc2(GFP_HIGHUSER|__GFP_ACCOUNT), pid 4945, tgid 4945 (sshd), ts 47548197350, free_ts 47548625509
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1468
 prep_new_page mm/page_alloc.c:1476 [inline]
 get_page_from_freelist+0x2ce2/0x2d90 mm/page_alloc.c:3438
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4696
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 pipe_write+0x657/0x1a40 fs/pipe.c:513
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa72/0xc90 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 4947 tgid 4947 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1088 [inline]
 free_unref_page+0xd22/0xea0 mm/page_alloc.c:2601
 __folio_put+0x3b9/0x620 mm/swap.c:129
 pipe_buf_release include/linux/pipe_fs_i.h:219 [inline]
 pipe_update_tail fs/pipe.c:224 [inline]
 pipe_read+0x6f2/0x13e0 fs/pipe.c:344
 new_sync_read fs/read_write.c:395 [inline]
 vfs_read+0x9c4/0xbd0 fs/read_write.c:476
 ksys_read+0x1a0/0x2c0 fs/read_write.c:619
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88804937ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88804937ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888049380000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888049380080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888049380100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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
