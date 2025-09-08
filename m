Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE80AA55
	for <linux-crypto@vger.kernel.org>; Mon,  8 Sep 2025 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757327490; cv=none; b=opdmLrx57nFEnJL3DD6Bh/tO4RDW9JdLFARjCgJ6Ib9+e6QgfXRQQV45LOX/Av1TUQsPqNsnertPnSTzgLEbvQIfAwOKnmwDhymzXsjdhxuICyXx0Xs///1S0Kt6r+ykmQqppJIJygSNUgTzGovQzEpKvakFEoVB4Cf/Goc0syI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757327490; c=relaxed/simple;
	bh=jKcAUYY51A7KTMimnZdCvOaqDwEfhuPg++4X0pDGJWo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sZKzlAc+lltICdzaO6qV+Ay+H5CEtweABkccrxfM5WkB56j19C3wR/KpE7oJ+HhD5yMspfwtZJPyejk9UouMYncJlERMI7qYephR8eJWpaF7Q3ys6Eo4yrEwwWmpGpDcgXCdMC0r0sJ3WwZDntr+8La8KdktTUl4+L+wlbeUoXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-889b8d8b6b7so98023939f.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Sep 2025 03:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757327488; x=1757932288;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lHq6t1W+owY0uHXSp5L2X1n6+Wjuo05wcsZyezt8tOU=;
        b=dtLHfFHDAlzus2nhlk/CRV5jWT8jOtCjpCe2ImAD5JXP+JpF0BLhIMIwJcpR7IRRG/
         3aXulSPRz3HQVQfcmHmvKglXi4CJZMOBfB/rJrs1sQkwcw1AgUPaC9rAh2qMhatUN4f6
         bAT+RKO10PmDDoOHAZrDpduPUbZds5RbB5xNM1rQxvcHpI0nf7HqkoqlM9zvFKSjKP5A
         /q9UcbGJtmd4CQU/oIAnHSllo4nCumJDRBmAgKOAeWvZK98LKHzGOiIqOoqyJD465FhB
         EN4TRgswlUb30wUpkPD06uZC/gWA1qMJCdIT9wUNPhvZK4OAC/Ej/1Wmw7lSQDJO1PRa
         oxPA==
X-Forwarded-Encrypted: i=1; AJvYcCWKD3ImZfZKMsbUlzZbGRI61NL8S370QcN4biHgn2RIzEYR8GAVaz3uKaex5Byc53vADgv2uDFFvNSEb9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJtcRSQzeKYAehG//o2/hRKC5qZ0+XbJ0BGtvY8ukUsWIli5rq
	wmjlLS+LjlnjU470N2ZFZXCxij8ADVeP8uHOnoEUeJHpgFnkg+eV4dxhn2N89dwU03ECAABTEHj
	8VcLZEGY0b/n/qukXMfAuzW2JRM29SpTsy2L61GXsyS6bMxOMdNWLoYU9pQ0=
X-Google-Smtp-Source: AGHT+IFxlEq1fsiVslmGm2GTL/gNo/Ik8p/l8iqEaw5p/Ls+vWb8UgpnsIv3pKbvrEnsxMnLd1FLG0/+htpOawUkZ7g4ZVkM8zvQ
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c9:b0:3f6:5b66:b5cd with SMTP id
 e9e14a558f8ab-3fdfdb2e2a2mr95939465ab.6.1757327487967; Mon, 08 Sep 2025
 03:31:27 -0700 (PDT)
Date: Mon, 08 Sep 2025 03:31:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68beb07f.050a0220.192772.086a.GAE@google.com>
Subject: [syzbot] [crypto?] KASAN: wild-memory-access Read in __sha512_update
From: syzbot <syzbot+e37eedd918576774ec80@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11136312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1220fefb3f11f346
dashboard link: https://syzkaller.appspot.com/bug?extid=e37eedd918576774ec80
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15136312580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e23e62580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/17aafe2d8f53/disk-4ac65880.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/09caead80fb0/vmlinux-4ac65880.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b33c041f8dc2/bzImage-4ac65880.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e37eedd918576774ec80@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: wild-memory-access in __sha512_update+0x10d/0x1d0 lib/crypto/sha512.c:175
Read of size 2 at addr 0005088000000000 by task syz.0.17/6022

CPU: 0 UID: 0 PID: 6022 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 __sha512_update+0x10d/0x1d0 lib/crypto/sha512.c:175
 sha512_update include/crypto/sha2.h:734 [inline]
 crypto_sha512_update+0x27/0x40 crypto/sha512.c:151
 crypto_shash_update include/crypto/hash.h:1006 [inline]
 shash_ahash_update+0x213/0x2f0 crypto/ahash.c:178
 hash_sendmsg+0x96b/0x11d0 crypto/algif_hash.c:149
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x52d/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmmsg+0x227/0x430 net/socket.c:2757
 __do_sys_sendmmsg net/socket.c:2784 [inline]
 __se_sys_sendmmsg net/socket.c:2781 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2781
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9e1df8ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd2b583528 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f9e1e1c5fa0 RCX: 00007f9e1df8ebe9
RDX: 0000000000000001 RSI: 0000200000000640 RDI: 0000000000000004
RBP: 00007f9e1e011e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9e1e1c5fa0 R14: 00007f9e1e1c5fa0 R15: 0000000000000004
 </TASK>
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
