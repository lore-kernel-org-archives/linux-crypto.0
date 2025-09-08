Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11ED433C8
	for <linux-crypto@vger.kernel.org>; Mon,  8 Sep 2025 11:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757330790; cv=none; b=F+OyFPtlmjCUw3L0Jna3T5Ubd+UNE7sMOV6B0pBsvY67Ev4kqgOHa0aiecpacwONLAyuzQbqsHSiCUlrdkiv3KSW0+zBHwVqpTFoI3eHN44uRsk8CsB4T1tpJt7j0Bf1Ubflf8UDsXhwN9yK3Y5CpqSPUcbV7OoWE1I6ti1hxXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757330790; c=relaxed/simple;
	bh=y2Q1tyz1O1/FbRgYYErmhgG5y9eSQQK+NEfphOXmKMI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oaejz6O9uHf06yZFvVnWmluICO3JYYPFc6oNTQ1eYN7WQJYz6KLq7eBVOT3Xgmgbg+FqqefXSW/moIL71rrWFrYlz9znRamL4nLNhBXErKo0Z5OQkA3mjWViaXyzhPuAAndTUOc3ApgX2FtltmT5ZERQaKV7k9kT0xdwF7gGgHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-886e347d2afso395153439f.3
        for <linux-crypto@vger.kernel.org>; Mon, 08 Sep 2025 04:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757330788; x=1757935588;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9UGwP574UR8mluSEnTzhQ/L6kwzTH2koLeZ6O/JgxFM=;
        b=qogWuRn2e3ioZRrW2ZpnaCBnbpzErcHdpykjFnOmxK6uWDJ5k2qVSY2aOhhIq9of5E
         Hdt3tyrUqG4yPqutpwYpkWe/jDw2CwETStXEem6BSv4lIAzcUjr3xuOsWRrTPCO9c36K
         wBNaUFQMGzVZLtEA12YXMInSVzhXQiCMFURbwI/oHlHXAogzVboZca4RsfHrxvwyR4Ig
         FeM8Z27hVWHRcBcOG4RorLsobinqPPpPbydAdCrrX0vg4DLSj5G8M2iUZqO2ZBMayGPB
         rTF7YOahFPfVdhonrLIr1vUCb0YhNIDtUyBD9LHdLzJ+yT7P9NASfehGtn3XFTpOCPcO
         LsiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuaa08tW13278d1pdfRnjKtT6mYcKuDphVuWft0u3C+3zrhdNJxK9PkX0EWou9umK38yHmmVnVheknwBk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Wx0NLpFgo9yVVGSBaajgET82NoOa/tFSOrwXzt3rJDqfA2Mp
	fRWAnfnj8ywSfNZEskCsclVBHivw5+FBBUY0X08A2WaMQLDnDud0r9TNRcHG33lVuljHfsHcfT1
	HXfNFMPMbv1F7cizF17ugwS2/tjlSz1a980spyFOMyCLGhmVxCkC9xJpL50Q=
X-Google-Smtp-Source: AGHT+IGKO8iHWWTlpQIUCgDx0UeoGo92b/QAvIGmkZTq4yu2iMtPbYy4Zd/fmdshQWMoIEEtVzBn2Hm22Tlklb9+/OLXlxUVTe5M
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:378f:b0:402:c6fe:be8e with SMTP id
 e9e14a558f8ab-402c6fec001mr73417885ab.30.1757330787926; Mon, 08 Sep 2025
 04:26:27 -0700 (PDT)
Date: Mon, 08 Sep 2025 04:26:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bebd63.050a0220.192772.086e.GAE@google.com>
Subject: [syzbot] [crypto?] general protection fault in xxh64_update
From: syzbot <syzbot+14c6a89d5f47cd26ea7a@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12951312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
dashboard link: https://syzkaller.appspot.com/bug?extid=14c6a89d5f47cd26ea7a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16951312580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b8e962580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/36645a51612c/disk-4ac65880.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bba80d634bef/vmlinux-4ac65880.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e58dd70dfd0f/bzImage-4ac65880.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+14c6a89d5f47cd26ea7a@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xe0009d1000000000: 0000 [#1] SMP KASAN PTI
KASAN: maybe wild-memory-access in range [0x0005088000000000-0x0005088000000007]
CPU: 0 UID: 0 PID: 6069 Comm: syz.0.32 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:get_unaligned_le64 include/linux/unaligned.h:28 [inline]
RIP: 0010:xxh64_update+0x55b/0xcf0 lib/xxhash.c:312
Code: 00 00 00 fc ff df 48 8b 44 24 30 48 83 c0 e0 48 89 44 24 18 48 89 5c 24 68 48 8b 1b 45 31 ff 4e 8d 0c 3e 4c 89 c8 48 c1 e8 03 <0f> b6 04 10 84 c0 0f 85 4a 01 00 00 4a 8d 3c 3e 48 83 c7 07 48 89
RSP: 0018:ffffc900039c7778 EFLAGS: 00010206
RAX: 0000a11000000000 RBX: 7a8f95a9137c12d5 RCX: ffff88802af8bc00
RDX: dffffc0000000000 RSI: 0005088000000000 RDI: 0000000000000000
RBP: 8c2c5b2336b29570 R08: c2b2ae3d27d4eb4f R09: 0005088000000000
R10: 0000000000000000 R11: ffffffff849f4de0 R12: bcfbe54b88bf1c85
R13: ffff88807c933360 R14: 128d621f73d40218 R15: 0000000000000000
FS:  00007fa7a7e826c0(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa7a7e60f98 CR3: 0000000075c6c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 xxhash64_update+0x27/0x40 crypto/xxhash_generic.c:46
 crypto_shash_update include/crypto/hash.h:1006 [inline]
 shash_ahash_update+0x213/0x2f0 crypto/ahash.c:178
 hash_sendmsg+0x96b/0x11d0 crypto/algif_hash.c:149
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa7a6f8ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa7a7e82038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa7a71c5fa0 RCX: 00007fa7a6f8ebe9
RDX: 0000000000000000 RSI: 0000200000001080 RDI: 0000000000000004
RBP: 00007fa7a7011e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa7a71c6038 R14: 00007fa7a71c5fa0 R15: 00007ffc0c907ff8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:get_unaligned_le64 include/linux/unaligned.h:28 [inline]
RIP: 0010:xxh64_update+0x55b/0xcf0 lib/xxhash.c:312
Code: 00 00 00 fc ff df 48 8b 44 24 30 48 83 c0 e0 48 89 44 24 18 48 89 5c 24 68 48 8b 1b 45 31 ff 4e 8d 0c 3e 4c 89 c8 48 c1 e8 03 <0f> b6 04 10 84 c0 0f 85 4a 01 00 00 4a 8d 3c 3e 48 83 c7 07 48 89
RSP: 0018:ffffc900039c7778 EFLAGS: 00010206
RAX: 0000a11000000000 RBX: 7a8f95a9137c12d5 RCX: ffff88802af8bc00
RDX: dffffc0000000000 RSI: 0005088000000000 RDI: 0000000000000000
RBP: 8c2c5b2336b29570 R08: c2b2ae3d27d4eb4f R09: 0005088000000000
R10: 0000000000000000 R11: ffffffff849f4de0 R12: bcfbe54b88bf1c85
R13: ffff88807c933360 R14: 128d621f73d40218 R15: 0000000000000000
FS:  00007fa7a7e826c0(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa7a7e60f98 CR3: 0000000075c6c000 CR4: 00000000003526f0
----------------
Code disassembly (best guess), 5 bytes skipped:
   0:	df 48 8b             	fisttps -0x75(%rax)
   3:	44 24 30             	rex.R and $0x30,%al
   6:	48 83 c0 e0          	add    $0xffffffffffffffe0,%rax
   a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   f:	48 89 5c 24 68       	mov    %rbx,0x68(%rsp)
  14:	48 8b 1b             	mov    (%rbx),%rbx
  17:	45 31 ff             	xor    %r15d,%r15d
  1a:	4e 8d 0c 3e          	lea    (%rsi,%r15,1),%r9
  1e:	4c 89 c8             	mov    %r9,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
* 25:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax <-- trapping instruction
  29:	84 c0                	test   %al,%al
  2b:	0f 85 4a 01 00 00    	jne    0x17b
  31:	4a 8d 3c 3e          	lea    (%rsi,%r15,1),%rdi
  35:	48 83 c7 07          	add    $0x7,%rdi
  39:	48                   	rex.W
  3a:	89                   	.byte 0x89


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
