Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5A619CD0B
	for <linux-crypto@vger.kernel.org>; Mon, 26 May 2025 08:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748248778; cv=none; b=bvfmmlmO4OKyHSEYsSBGsCSZcKLtdckvFRwY+RWeCs9gft3hy6MZdmqw4X8wPTrb18MBYGD4QYVTa7eARBP/DZnbI/JojmNXm1yy6NJzqgocUtBAroKK+DIG/hz2bDep0p9h+/6OYO4tHxYJ8gN3e9BZaIWC7GDTPW8gDYOo93Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748248778; c=relaxed/simple;
	bh=fEYhv7ZIfgSVDpuGqxUtnvETd7LVIaAzhZM/s2uotuE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PPLPribb7JLvMnFykEvppdOoA7In2brFfZM6ovLioG+ZdusyLRBGyXlWC0kn7bPuazOUfv618pfMojUt3vONpAzXCOTtOXqTQkS4juOVavi/o3Df/R085PVDwOPHSeSWXqfKzsO4XgvzSHKmSgRwIOykKXe1DDOREZLWBawpzC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-86463467dddso183041439f.3
        for <linux-crypto@vger.kernel.org>; Mon, 26 May 2025 01:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748248776; x=1748853576;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nZYc+FdbnMpgL9dDlhBbqTk7u9ortcl4G1kxEIbvj2o=;
        b=FTbrLEctVkPNf4YJG6FaLT/Q++LML1O+NckiMg5rGEQOEwWpgzclO1ZR8/QcakN9JL
         +vrtcZSnn9QZsJeMFx6p3OumhzTXCNT4wsKhWJgpV63QJSfIjEunaqUqmtvG8FQhVuDt
         yzOAqCXoUccKvb/43gehQQR16WaeOLCqx4BKEbcMp+a8r8+hUB42wHKpkQ7RosmYIBT2
         5xPboqBZfyxA78ZzI4nzNMi77F034cLFpDQoDzeQXo+lnwwSE2/l1YXl0HY9B4eSRRpS
         +mp1EOegIiOfFefAZBGls6B1+mbeN5QLoRzAEtWNd48iBPdU+ebDMhTxFmQeJGDz8066
         9Zog==
X-Forwarded-Encrypted: i=1; AJvYcCW3BaLKaT3yYaIw3TvI39Yg11RlmM+d7ps9QDoJbZfXZHouav1964xeI1+1uwnPGJsxUitVHPpTWbVDlnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsS8ykCyNDcpboDhjeFcZ1JluSBI5ctCdu3eeb7TbbQoLB/20N
	595a1aAcYJ1z0a6+9uzmTXIct++ZLm6MW/B5U6IFLjZ0V/8ycCk7UAQz91Oiz+VPjptRWrr0IGD
	1siwKq24WpEPxsj2RkVvpHq+K7wJWB6RZX/zXgEyb3a9Pv29NFoHW4jt2b+A=
X-Google-Smtp-Source: AGHT+IHvCT+3WLL6KLdkaLVAUARkYBpFmCQpMy6VEsr6jow6ac75moiyN+ijPGGitWFWTtxASQ/z11Y9WSy7VcfjvW6AfS1HVf6T
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:408c:b0:86a:246:ee96 with SMTP id
 ca18e2360f4ac-86cbb8ed94dmr1002858939f.11.1748248776052; Mon, 26 May 2025
 01:39:36 -0700 (PDT)
Date: Mon, 26 May 2025 01:39:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683428c8.a70a0220.29d4a0.0801.GAE@google.com>
Subject: [syzbot] [crypto?] KASAN: use-after-free Write in __crypto_shash_import
From: syzbot <syzbot+4851c19615d35f0e4d68@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    176e917e010c Add linux-next specific files for 20250523
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=175c1ad4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7902c752bef748
dashboard link: https://syzkaller.appspot.com/bug?extid=4851c19615d35f0e4d68
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f92170580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17bd88e8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5f7692c642fa/disk-176e917e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/057a442d42d0/vmlinux-176e917e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f8ebdb4dd96/bzImage-176e917e.xz

The issue was bisected to:

commit 7650f826f7b2d84782f9147c51687ff0364125e9
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Apr 18 02:58:41 2025 +0000

    crypto: shash - Handle partial blocks in API

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10cba170580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12cba170580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14cba170580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4851c19615d35f0e4d68@syzkaller.appspotmail.com
Fixes: 7650f826f7b2 ("crypto: shash - Handle partial blocks in API")

==================================================================
BUG: KASAN: use-after-free in __crypto_shash_import+0x26a/0x2a0 crypto/shash.c:263
Write of size 1 at addr ffff88817c920b47 by task syz-executor264/5855

CPU: 0 UID: 0 PID: 5855 Comm: syz-executor264 Not tainted 6.15.0-rc7-next-20250523-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 __crypto_shash_import+0x26a/0x2a0 crypto/shash.c:263
 crypto_shash_import+0x84/0x230 crypto/shash.c:286
 hash_accept+0x1fb/0x280 crypto/algif_hash.c:267
 do_accept+0x48f/0x680 net/socket.c:1924
 __sys_accept4_file net/socket.c:1964 [inline]
 __sys_accept4+0x11c/0x1c0 net/socket.c:1993
 __do_sys_accept net/socket.c:2006 [inline]
 __se_sys_accept net/socket.c:2003 [inline]
 __x64_sys_accept+0x7d/0x90 net/socket.c:2003
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f685ecf6d59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe73b98688 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: ffffffffffffffda RBX: 00000000000158a5 RCX: 00007f685ecf6d59
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000000 R08: 00007ffe73b986bc R09: 00007ffe73b986bc
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe73b986bc
R13: 00007ffe73b986f0 R14: 00007ffe73b986d0 R15: 0000000000000002
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x17c920
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000000 ffffea0005f24808 ffffea0005f24808 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffff88817c920a00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88817c920a80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88817c920b00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                           ^
 ffff88817c920b80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88817c920c00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
