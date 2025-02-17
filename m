Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10069192D80
	for <linux-crypto@vger.kernel.org>; Mon, 17 Feb 2025 07:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739778810; cv=none; b=rsj+KricU52cWL7mI4wJMNuNS3KqsduCEBCYh6u1X7f8Yohrzs7Er2jatqk2tSctRLU5Z7WH366CzUuKDOZJ5VVo1mB51k7Kyt0jzC2Jb6qPEsITknizA+sSxaTB/nTTk9ptr6t9e9B8IMEk6TakdBtHjq/m1LvQcHnNBpM+wVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739778810; c=relaxed/simple;
	bh=0eB6pfik9lPrKnBrPr5YRGNnZCcmDvEsBLomBFwCLzw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HmglxmmJS/kPSu/Yv93stArsN29Hm28DjmOQgrALJbKO8VTUZyrvMqxbDthruChnCGsLE1aHvosArqIg6lFGVy/RZAyyzlvjuZkyVhQlO98qK4xg2RzJ+TmwJkqlOpuRyyKlnAJ7f1fQ/iDKxkohcYAZ7ss0WpTf+WCzLcQqAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d143a428bcso78137485ab.1
        for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 23:53:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739778808; x=1740383608;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OnjOPcPtQJidYYXAir6799pgHthwAAAi4v1nTbaniHg=;
        b=oT3ODYnTGQuJkZtXwZKahK6z4KbZYpSQ4VcPy6bnTlAgJQ2D53hKlT/qSEzTeFMBT0
         Q84l3Kw+RZ5VhsLJqLVf/xvHgH89muy0wfRc7UAzC9gyEBpw+MDAKgZPRon3/87G9Fms
         qhI1UFjf73VCbculo98V1czS/RteDypkx95D77jmCZhHbhwsqqDgGwGrAhg99yY9VPrH
         vH4tAg4v0DLvRGf/8OPxaXfpDYmtumqBNEsEO1OGa+xpMzBuViTD8SQ/cQehGJwb/ZAH
         ixaDrUVq4bhsZUw4ApSlVfkXF6LEehTtgaFffBQZ/nMGEUEoWkJKrKxidHWNVCZ6GKBN
         WpAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKmv7LlBpOL2WkPKSbQBSQGHtLKaCOJkXuBGtGa5xXY9mMpl1JHIB3bo+ZaxbqmBorcvyP8Hwf9WoO4EM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6alaJt6U8ZlA8c5U6hGr7OIrUWlF2Kw3fulx+dxowe3ykpc/f
	JjT9Ijg6S8xSvV7bQFAwCXZRGuC8ox44exrWjwQxMaGAPLcjRsnD1ypXu/kcgXfMcA6MNWm4lft
	2jlFCLcZpipprm4oppa+/txOE9xqmK13109fTJGrnFcIU1dH+M/Vw6Ek=
X-Google-Smtp-Source: AGHT+IHUJpTvEOY7k+3N0NKWON1rIkG0PuVtRogPOq4lO3+Q5V6JgBp9PpQFV246dsEQo5Da/Bkt6x18R8Y0eY73CR4Sa7BdehDk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:240b:b0:3d2:75bc:730 with SMTP id
 e9e14a558f8ab-3d2809d9587mr73860745ab.19.1739778808203; Sun, 16 Feb 2025
 23:53:28 -0800 (PST)
Date: Sun, 16 Feb 2025 23:53:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b2eaf8.050a0220.173698.0020.GAE@google.com>
Subject: [syzbot] [crypto?] KASAN: use-after-free Read in crypto_poly1305_update
From: syzbot <syzbot+d587b24799bd8c2d32f4@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, davem@davemloft.net, 
	herbert@gondor.apana.org.au, hpa@zytor.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ba643b6d8440 Merge tag 'irq_urgent_for_v6.14_rc3' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176ea898580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=d587b24799bd8c2d32f4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150557df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eea898580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ba643b6d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b6a86fb77c0b/vmlinux-ba643b6d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c4725da84fe0/bzImage-ba643b6d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/769f8967e4f1/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d587b24799bd8c2d32f4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in crypto_poly1305_update+0x28/0x40 arch/x86/crypto/poly1305_glue.c:230
Read of size 8 at addr ffff888049757390 by task syz-executor358/5305

CPU: 0 UID: 0 PID: 5305 Comm: syz-executor358 Not tainted 6.14.0-rc2-syzkaller-00346-gba643b6d8440 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 crypto_poly1305_update+0x28/0x40 arch/x86/crypto/poly1305_glue.c:230
 bch2_checksum+0x5fa/0x780 fs/bcachefs/checksum.c:239
 bch2_btree_node_read_done+0x1402/0x6180 fs/bcachefs/btree_io.c:1130
 btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
 bch2_btree_node_read+0x2433/0x29f0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1789 [inline]
 bch2_btree_root_read+0x626/0x7b0 fs/bcachefs/btree_io.c:1811
 read_btree_roots+0x3d3/0xa70 fs/bcachefs/recovery.c:581
 bch2_fs_recovery+0x260f/0x3de0 fs/bcachefs/recovery.c:928
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd8b49b71ba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff5a4d7e78 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff5a4d7e90 RCX: 00007fd8b49b71ba
RDX: 0000400000000000 RSI: 0000400000000200 RDI: 00007fff5a4d7e90
RBP: 0000400000000000 R08: 00007fff5a4d7ed0 R09: 000000000000f634
R10: 0000000002a08414 R11: 0000000000000282 R12: 0000400000000200
R13: 00007fff5a4d7ed0 R14: 0000000000000003 R15: 0000000002a08414
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x49757
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 ffffea000125d5c8 ffffea000125d5c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffff888049757280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888049757300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888049757380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                         ^
 ffff888049757400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888049757480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
