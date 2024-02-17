Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50752149E08
	for <linux-crypto@vger.kernel.org>; Sat, 17 Feb 2024 01:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708133728; cv=none; b=I2WUjoQUmFQyaQD/zdDGb68aXPlqCIpcywLCMKRED2I+VFnRX3XPcbvxviPLlxN+f2Y3GMM6Yf0zTneGn9jEgOTXgWkg5Uqqp8VoKe0ANQcIT4+OKn+izIKRsLEXJi9LBJ+ul94tlL0+6A7FVZvUkL4nlxoIUkZl2w2mNO4nBEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708133728; c=relaxed/simple;
	bh=IEuFfjywNldRNgW+0Ea0aCdtJBWExVI5YnvceJ8eHGQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qE3VntTuCJsZ3WDVEgFkU8qdzqKa83LpG4iMi6j1TY2F2pvu4GEhBdg/9O5NFwDHylvrynyytQaKzUALAr8khpXL5HurUEsNM362tMqwc4bJbBCNHj0DL+N0HwO9Kgan3lkInuRLYVMcjpf4QrCV2E4tR2pzEccMwMas3yP8LuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3650bfcb2bfso7563195ab.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 17:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708133726; x=1708738526;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rXCsIGoqOw5tNh5U7A+hJMtNMmu1TmiTgiAyYxTtY3c=;
        b=tSOZkoyHMv8ElN9RaXuSLRINminlInc2IcHFO+Ct8/FL8y/uPIkjbuyZuLPzAa5xjV
         oD9E+nqcASnN6BDkn7IToaCMTvOPmHwh1aYF4S3YYOSzfBxbOGs5K7ukkuQRelbQIuIx
         TFmycWCC7a4ZwdEkIAgSp3UkS7i7Wo+77mPLq9vsBK41m3AVCEHenA5A63tVnLJSQTCh
         P9yUUui/xU8GM3LJrahJOucQSV6YSd4Vl7j7C2nCkCHkrdSCj6ki8afYnLLMaEEQL2sI
         UO/hNwTZxyVOs1iMCoaUIdcCD6wectuai7SLAyiK1q5ovcqINBJWCBdj2MAkgUkQOMuC
         kFpA==
X-Forwarded-Encrypted: i=1; AJvYcCU/T6nqU0mZva6XjtLWTsO4LOU+xRET1joUYRNmZw8V171lGOvxZgRGsOBwFjLKoD8/EE4XVoGrXwDeu9bzPI4hLwQxTmAqpN2EG63j
X-Gm-Message-State: AOJu0YwYTsTa56+RYbFELWwrxAojLW9y1mdI9Waru28kQerwm7n3d3hR
	ZsWE64zuu/0bZMa5pughlHSTQk/tR30dzpNqlHwTfcKBcNByVLBYkc9DkiuG65sQm2QYzy9Oveb
	XOAexwfibvsxJdai9IpjoEHshcxaaj4cGqIQo65HZsAMQIxwNnuUraVM=
X-Google-Smtp-Source: AGHT+IHd7SEsOb3PgOVPG1aQE5VO1v7haBKCXwSaSoaIJgBEL/bRINUGfIBb9kqS2FvKBH3N4nB7CyhtB9Srs6g1hBxwOa2CxOn4
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160d:b0:363:df76:4a1f with SMTP id
 t13-20020a056e02160d00b00363df764a1fmr503151ilu.2.1708133726494; Fri, 16 Feb
 2024 17:35:26 -0800 (PST)
Date: Fri, 16 Feb 2024 17:35:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ff2c3f061189df71@google.com>
Subject: [syzbot] [arm?] [crypto?] KASAN: invalid-access Read in neon_aes_ctr_encrypt
From: syzbot <syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c664e16bb1ba Merge tag 'docs-6.8-fixes2' of git://git.lwn...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13e83cc8180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4dde08ba7d52a4b
dashboard link: https://syzkaller.appspot.com/bug?extid=f1ceaa1a09ab891e1934
compiler:       aarch64-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fff792180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cbe4dc180000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/384ffdcca292/non_bootable_disk-c664e16b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/864da5a66121/vmlinux-c664e16b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/044de3e4ddc5/Image-c664e16b.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: invalid-access in neon_aes_ctr_encrypt+0x15c/0x1ec arch/arm64/crypto/aes-modes.S:599
Read at addr fcff000006797ff1 by task syz-executor675/3149
Pointer tag: [fc], memory tag: [fe]

CPU: 1 PID: 3149 Comm: syz-executor675 Not tainted 6.8.0-rc4-syzkaller-00005-gc664e16bb1ba #0
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0x94/0xec arch/arm64/kernel/stacktrace.c:291
 show_stack+0x18/0x24 arch/arm64/kernel/stacktrace.c:298
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x48/0x60 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x108/0x618 mm/kasan/report.c:488
 kasan_report+0x88/0xac mm/kasan/report.c:601
 report_tag_fault arch/arm64/mm/fault.c:334 [inline]
 do_tag_recovery arch/arm64/mm/fault.c:346 [inline]
 __do_kernel_fault+0x17c/0x1e8 arch/arm64/mm/fault.c:393
 do_bad_area arch/arm64/mm/fault.c:493 [inline]
 do_tag_check_fault+0x78/0x8c arch/arm64/mm/fault.c:772
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:848
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:398
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:458
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:593
 neon_aes_ctr_encrypt+0x15c/0x1ec arch/arm64/crypto/aes-modes.S:599
 ctr_encrypt+0xfc/0x144 arch/arm64/crypto/aes-neonbs-glue.c:230
 crypto_skcipher_decrypt+0x4c/0x60 crypto/skcipher.c:695
 _skcipher_recvmsg crypto/algif_skcipher.c:199 [inline]
 skcipher_recvmsg+0x39c/0x46c crypto/algif_skcipher.c:221
 sock_recvmsg_nosec net/socket.c:1046 [inline]
 sock_recvmsg net/socket.c:1068 [inline]
 sock_recvmsg net/socket.c:1064 [inline]
 sock_read_iter+0xec/0x118 net/socket.c:1138
 call_read_iter include/linux/fs.h:2079 [inline]
 new_sync_read fs/read_write.c:395 [inline]
 vfs_read+0x2cc/0x304 fs/read_write.c:476
 ksys_read+0xe8/0x104 fs/read_write.c:619
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __arm64_sys_read+0x1c/0x28 fs/read_write.c:627
 __invoke_syscall arch/arm64/kernel/syscall.c:37 [inline]
 invoke_syscall+0x48/0x114 arch/arm64/kernel/syscall.c:51
 el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:136
 do_el0_svc+0x1c/0x28 arch/arm64/kernel/syscall.c:155
 el0_svc+0x34/0xd8 arch/arm64/kernel/entry-common.c:678
 el0t_64_sync_handler+0x100/0x12c arch/arm64/kernel/entry-common.c:696
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:598

The buggy address belongs to the physical page:
page:0000000060acabc6 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x46797
flags: 0x1ffc28000000000(node=0|zone=0|lastcpupid=0x7ff|kasantag=0xa)
page_type: 0xffffffff()
raw: 01ffc28000000000 fffffc0000168bc8 fffffc0000199e08 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff000006797d00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
 ffff000006797e00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>ffff000006797f00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
                                                                ^
 ffff000006798000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff000006798100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
