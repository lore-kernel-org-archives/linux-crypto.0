Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71783C5DC4
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 16:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775233949; cv=none; b=j6o662EV75PluZQl+K+oIFJi44Z+qwzgipNn5qQjFss1kRXqlF4wa8ek0+Avyuowd479tHYd8YtipBASDtFmX5pGmH9rkDUqshDYfopsBrpMLs9XYUPzX6m0hlkcIzDr4EqCoge6+O5E25n5NZbXt1DZv3b1/HtobqTEQI/rvj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775233949; c=relaxed/simple;
	bh=qfr6neH7KOpkhICdsmAGPVUpUAdCWOmTk90/4X7duvc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kav2E5pACNl0q6e1pJ9fwbIjsOt9rYr0tVowPjK6lIzz+a5yEH/5fSSJEnmfs3cnVJRigDGDJMejk8vjZlnI4ca7LkGZNRoeARBMZS7xsQ+vwdfwBQpOpnwn3ojdfTKQ8slWBiok7C93QS2mkKmtENmBgOkolQwAMQpdbgmB1iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-67a1e063795so8411415eaf.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2026 09:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775233947; x=1775838747;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WMrjXk9A+5MghAXGyIdAHA6fxy0ZBzM8+MCHu3USr+k=;
        b=nQQ5V3X+1dJ0kCp8xXy12aRaOqrMahWPIFtT6cALKHLamJ5abTPTjgXQzq6+bSYDAx
         IORhbQd9SFV3zW1PcatUYqKa3FB9s6AZzoCHxv/2s0Hms1dJJGDblY2z0/IqZ4BctBaC
         xC+qHgzdA4iCbQejoMSzDLmDli/RK7gPKIexHJY4hih7Z2DTefNLWf4HXr/OsQNm1tDL
         yw08RG7ZPB2rMzrH6FwHAoc4MYcIrPTySzB9NqnZXpu7Y8lFZotgSodsX+7N2lGp6qOh
         yzNZfrdktJDzBf6Rp1/wll9+Kb2Icsd87XAjHzXlwmbnZXZtBUeONGNygTwTyoD8OLVX
         gAhA==
X-Forwarded-Encrypted: i=1; AJvYcCUAWwjL6dRyUvHL+epG2kRjtXyZnq6WKn72l6AdBLWN2XRS7rK4Tqsn1R7iyXntB/fw9lXW8fTGezK2hjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxalFICEbiPbMm43d/sKAECpd+VROuKd3r1J8aAiBENQ5WJBJiV
	48D9DZiWl/83tYnFgnuuuH1fMxbJK9gqCr5Okhhu9bkSRXfYu0nrSLp+DRW33dEzlDXNFB+0jCl
	opPWKMw/SEkxQ9qNPbAnUB1c+YDc6KavC0FF/Yufgt6jX207ZOcjr/qN9hwc=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:d348:0:b0:683:121c:5aa with SMTP id
 006d021491bc7-683121c0694mr467172eaf.10.1775233946863; Fri, 03 Apr 2026
 09:32:26 -0700 (PDT)
Date: Fri, 03 Apr 2026 09:32:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cfeb9a.050a0220.2dbe29.0012.GAE@google.com>
Subject: [syzbot] [crypto?] general protection fault in aead_recvmsg
From: syzbot <syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d8a9a4b11a13 Merge tag 'v7.0-rc6-smb3-client-fix' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17649d02580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6754c86e8d9e4c91
dashboard link: https://syzkaller.appspot.com/bug?extid=aa11561819dc42ebbc7c
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b0946a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17eb8dda580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ecb473e5a4ef/disk-d8a9a4b1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eaedee0e571e/vmlinux-d8a9a4b1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e2ba27a7ba82/bzImage-d8a9a4b1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com

trusted_key: syz.0.17 sent an empty control message without MSG_MORE.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5987 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:memcpy_sglist+0x420/0x730 crypto/scatterwalk.c:177
Code: e8 b5 b9 52 fd f6 c3 01 0f 85 0a 01 00 00 e8 c7 b4 52 fd 4c 89 f3 eb 07 e8 bd b4 52 fd 31 db 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <0f> b6 04 28 84 c0 0f 85 1d 02 00 00 41 8b 07 89 44 24 04 49 8d 7d
RSP: 0018:ffffc900035a7698 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888026dc1e80
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88802543b200 R14: ffff888033865080 R15: 0000000000000008
FS:  000055556d3e1500(0000) GS:ffff888125457000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000004580 CR3: 0000000035e06000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 _aead_recvmsg crypto/algif_aead.c:186 [inline]
 aead_recvmsg+0x719/0x1030 crypto/algif_aead.c:240
 sock_recvmsg_nosec+0x10c/0x140 net/socket.c:1078
 ____sys_recvmsg+0x3e3/0x4a0 net/socket.c:2810
 ___sys_recvmsg+0x215/0x590 net/socket.c:2854
 do_recvmmsg+0x334/0x800 net/socket.c:2949
 __sys_recvmmsg net/socket.c:3023 [inline]
 __do_sys_recvmmsg net/socket.c:3046 [inline]
 __se_sys_recvmmsg net/socket.c:3039 [inline]
 __x64_sys_recvmmsg+0x198/0x250 net/socket.c:3039
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f726eb9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc9ba0f7c8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007f726ee15fa0 RCX: 00007f726eb9c819
RDX: 0000000000000002 RSI: 0000200000004580 RDI: 0000000000000004
RBP: 00007f726ec32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000060 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f726ee15fac R14: 00007f726ee15fa0 R15: 00007f726ee15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:memcpy_sglist+0x420/0x730 crypto/scatterwalk.c:177
Code: e8 b5 b9 52 fd f6 c3 01 0f 85 0a 01 00 00 e8 c7 b4 52 fd 4c 89 f3 eb 07 e8 bd b4 52 fd 31 db 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <0f> b6 04 28 84 c0 0f 85 1d 02 00 00 41 8b 07 89 44 24 04 49 8d 7d
RSP: 0018:ffffc900035a7698 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888026dc1e80
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88802543b200 R14: ffff888033865080 R15: 0000000000000008
FS:  000055556d3e1500(0000) GS:ffff888125557000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055607067bee0 CR3: 0000000035e06000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	e8 b5 b9 52 fd       	call   0xfd52b9ba
   5:	f6 c3 01             	test   $0x1,%bl
   8:	0f 85 0a 01 00 00    	jne    0x118
   e:	e8 c7 b4 52 fd       	call   0xfd52b4da
  13:	4c 89 f3             	mov    %r14,%rbx
  16:	eb 07                	jmp    0x1f
  18:	e8 bd b4 52 fd       	call   0xfd52b4da
  1d:	31 db                	xor    %ebx,%ebx
  1f:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 28          	movzbl (%rax,%rbp,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 1d 02 00 00    	jne    0x253
  36:	41 8b 07             	mov    (%r15),%eax
  39:	89 44 24 04          	mov    %eax,0x4(%rsp)
  3d:	49                   	rex.WB
  3e:	8d                   	.byte 0x8d
  3f:	7d                   	.byte 0x7d


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
