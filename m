Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E91267714
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 16:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775233949; cv=none; b=qYupPatEkLpOeai3ViM+kadmBSo9xjY+j0+ZkV5XBnj0fUFeEjgFbKe/l2nbu55t6Vaxvc1H+TiedJpzAl+PbJTg8TowqSIapqRBKsLZym+Ty3Oe5A/9cdaBbbkZF9nap6rfKAzBVZkN9S8BwIIrLRGP93nBGYTTIb1hDkX8G2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775233949; c=relaxed/simple;
	bh=FokEGhBBKkTYN2CODOW2zafoQomtiDdLI0zjzcNIY0k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dkKNXmVlxPXZk7BfBWqM6rhFqf4FD7EI0ZnuqoS78BhUPjnucvuY/Y4EHmUJUdseCRakvtxuI4JzlXEmH26EtOh/tzOapzTnQDyEFdWzDgIO6Av81hFrHjuhQAqEyKkFRf3s4M33KXSeg7uUwtYt2WlBkG8HsiG59FnSlUHGIw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-42322062cf3so1055656fac.2
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2026 09:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775233946; x=1775838746;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BJ+g+bzs5kN3sqsjm5bYRQ+XisYXxBWT6W6vYqfCBKo=;
        b=TkuOO1cmbv2l+bcfyUqSI99kU7yJoZ7ScqE5+rAVtYXlMVrTI7h1Y1L74tNaSbMwh0
         1cviRL01cO7Bat7bDmpc12sDQNYLqAQsRULvJZWbm86hVqsRmzfREHlImDP2FZXUpsD1
         XZg1g12MzTFKZo6uP2n1H08MX4/qwKQNkYptKoMFHk5nqBgg4uoTYWON7yYLOyP/wQmt
         c2rRuTDBgXEgVHn0F2Od24kqY06oKmKJy8tQccum2c9zP6/3wtBKCKuP9oiOChKyZ5vw
         y9zNDidgJYPRg3qpCC0qB5FCQazMpNJuFFBMnJr8L358iRU6t4fVeM/mxzIjJnZheG00
         RABA==
X-Forwarded-Encrypted: i=1; AJvYcCX+kQW/p+FBswdvHViGiXz+sqGmtiirwCLtMOlETAE1Ei7/1DKNLje8/wk0hRuSHwdNH4pyZWIo7WKC2lM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Lv8FFjq6qy7gio498bmJHrIU7uoZ5Dq4plfgOZLgnZB0G4Mo
	AdA/36LhnJKol7cbq04POdI5sSf5nzrTBdblKyB2MAE+7h+rc7+MuL5NbK3UhpB3Gfjvm5DUBKg
	QpaToOG5klrZSuWaS/WwlnVXch7MSgHPHmVpYe6jIQzt4vnIRr/uwaT/CzIs=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6189:b0:67e:2e06:46df with SMTP id
 006d021491bc7-682224fd332mr1173692eaf.66.1775233946618; Fri, 03 Apr 2026
 09:32:26 -0700 (PDT)
Date: Fri, 03 Apr 2026 09:32:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cfeb9a.050a0220.2dbe29.0011.GAE@google.com>
Subject: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in af_alg_pull_tsgl
From: syzbot <syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d8a9a4b11a13 Merge tag 'v7.0-rc6-smb3-client-fix' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133541ca580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6754c86e8d9e4c91
dashboard link: https://syzkaller.appspot.com/bug?extid=d23888375c2737c17ba5
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10cf146a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173541ca580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ecb473e5a4ef/disk-d8a9a4b1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eaedee0e571e/vmlinux-d8a9a4b1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e2ba27a7ba82/bzImage-d8a9a4b1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in sg_assign_page include/linux/scatterlist.h:131 [inline]
BUG: KASAN: slab-out-of-bounds in sg_set_page include/linux/scatterlist.h:162 [inline]
BUG: KASAN: slab-out-of-bounds in af_alg_pull_tsgl+0x1c6/0x740 crypto/af_alg.c:711
Read of size 8 at addr ffff888079ebbea0 by task syz.0.17/5997

CPU: 1 UID: 0 PID: 5997 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 sg_assign_page include/linux/scatterlist.h:131 [inline]
 sg_set_page include/linux/scatterlist.h:162 [inline]
 af_alg_pull_tsgl+0x1c6/0x740 crypto/af_alg.c:711
 _skcipher_recvmsg crypto/algif_skcipher.c:152 [inline]
 skcipher_recvmsg+0x5df/0x1140 crypto/algif_skcipher.c:221
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0x172/0x1b0 net/socket.c:1100
 ____sys_recvmsg+0x1e6/0x4a0 net/socket.c:2812
 ___sys_recvmsg+0x215/0x590 net/socket.c:2854
 __sys_recvmsg net/socket.c:2887 [inline]
 __do_sys_recvmsg net/socket.c:2893 [inline]
 __se_sys_recvmsg net/socket.c:2890 [inline]
 __x64_sys_recvmsg+0x1ba/0x2a0 net/socket.c:2890
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8e9759c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8e984e9028 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 00007f8e97816090 RCX: 00007f8e9759c819
RDX: 0000000040000003 RSI: 0000200000000600 RDI: 0000000000000004
RBP: 00007f8e97632c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8e97816128 R14: 00007f8e97816090 R15: 00007ffc82e5dba8
 </TASK>

Allocated by task 5997:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 sock_kmalloc+0xd6/0x160 net/core/sock.c:2880
 _skcipher_recvmsg crypto/algif_skcipher.c:144 [inline]
 skcipher_recvmsg+0x54d/0x1140 crypto/algif_skcipher.c:221
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0x172/0x1b0 net/socket.c:1100
 ____sys_recvmsg+0x1e6/0x4a0 net/socket.c:2812
 ___sys_recvmsg+0x215/0x590 net/socket.c:2854
 __sys_recvmsg net/socket.c:2887 [inline]
 __do_sys_recvmsg net/socket.c:2893 [inline]
 __se_sys_recvmsg net/socket.c:2890 [inline]
 __x64_sys_recvmsg+0x1ba/0x2a0 net/socket.c:2890
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888079ebbe80
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes to the right of
 allocated 32-byte region [ffff888079ebbe80, ffff888079ebbea0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x79ebb
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88813fea6780 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800400040 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5670, tgid 5670 (sshd), ts 54454536707, free_ts 54453387176
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __kmalloc_cache_noprof+0x392/0x660 mm/slub.c:5375
 kmalloc_noprof include/linux/slab.h:950 [inline]
 slab_free_hook mm/slub.c:2637 [inline]
 slab_free mm/slub.c:6165 [inline]
 kmem_cache_free+0x15b/0x630 mm/slub.c:6295
 tear_down_vmas+0x312/0x520 mm/mmap.c:1264
 exit_mmap+0x4b6/0xa10 mm/mmap.c:1322
 __mmput+0x118/0x430 kernel/fork.c:1175
 exec_mmap+0x3b4/0x440 fs/exec.c:893
 begin_new_exec+0x134a/0x24a0 fs/exec.c:1148
 load_elf_binary+0xa47/0x2980 fs/binfmt_elf.c:1011
 search_binary_handler fs/exec.c:1664 [inline]
 exec_binprm fs/exec.c:1696 [inline]
 bprm_execve+0x93d/0x1460 fs/exec.c:1748
 do_execveat_common+0x50d/0x690 fs/exec.c:1846
page last free pid 5670 tgid 5670 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 tlb_batch_list_free mm/mmu_gather.c:161 [inline]
 tlb_finish_mmu+0x144/0x230 mm/mmu_gather.c:533
 exit_mmap+0x498/0xa10 mm/mmap.c:1315
 __mmput+0x118/0x430 kernel/fork.c:1175
 exec_mmap+0x3b4/0x440 fs/exec.c:893
 begin_new_exec+0x134a/0x24a0 fs/exec.c:1148
 load_elf_binary+0xa47/0x2980 fs/binfmt_elf.c:1011
 search_binary_handler fs/exec.c:1664 [inline]
 exec_binprm fs/exec.c:1696 [inline]
 bprm_execve+0x93d/0x1460 fs/exec.c:1748
 do_execveat_common+0x50d/0x690 fs/exec.c:1846
 __do_sys_execve fs/exec.c:1930 [inline]
 __se_sys_execve fs/exec.c:1924 [inline]
 __x64_sys_execve+0x97/0xc0 fs/exec.c:1924
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888079ebbd80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 ffff888079ebbe00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
>ffff888079ebbe80: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
                               ^
 ffff888079ebbf00: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
 ffff888079ebbf80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
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
