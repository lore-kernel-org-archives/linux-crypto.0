From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: GPF in scatterwalk_start
Date: Tue, 19 Jan 2016 09:55:37 +0100
Message-ID: <CACT4Y+ZN-Kn4JOfAo=heB2it5MFticFeUmiZeCOHoj5uwj5FTg@mail.gmail.com>
References: <CACT4Y+bQGUjabQVkN=9C84tj716Ux8GprLwFYJSapWOLy-r50Q@mail.gmail.com>
 <20160119083513.GA8110@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: syzkaller <syzkaller@googlegroups.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33199 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbcASIz6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 03:55:58 -0500
Received: by mail-wm0-f47.google.com with SMTP id 123so81910847wmz.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jan 2016 00:55:57 -0800 (PST)
In-Reply-To: <20160119083513.GA8110@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 19, 2016 at 9:35 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 19, 2016 at 09:30:40AM +0100, Dmitry Vyukov wrote:
>> Hello,
>>
>> The following program causes GPF in scatterwalk_start.
>>
>> Herbert, I am on commit 5807fcaa9bf7dd87241df739161c119cf78a6bc4 with
>> all your fixes applied, including the fix for out-of-bounds in
>> skcipher_recvmsg.
>
> Does it happen without the out-of-bounds patch?


Yes, also happens on e31835ad3abc6809703d3bbd2400bdd6285f8fea of
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

BUG: unable to handle kernel NULL pointer dereference at 0000000000000014
IP: [<     inline     >] scatterwalk_start crypto/scatterwalk.c:35
IP: [<ffffffff817d8880>] scatterwalk_pagedone.part.8+0x30/0x50
crypto/scatterwalk.c:69
PGD 33f70067 PUD 3a328067 PMD 0
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in:
CPU: 0 PID: 6290 Comm: a.out Not tainted 4.4.0+ #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff88007979ad80 ti: ffff880076618000 task.ti: ffff880076618000
RIP: 0010:[<ffffffff817d8880>]  [<ffffffff817d8880>]
scatterwalk_pagedone.part.8+0x30/0x50
RSP: 0018:ffff88007661ba88  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88007661bbb0 RCX: 0000000000000000
RDX: 0000000000001000 RSI: ffff88003607f000 RDI: ffff88003499b3d8
RBP: ffff88007661ba90 R08: ffff88003499b3d8 R09: 0000000000000e62
R10: 0000000000000003 R11: 00000000f5dacfff R12: 000000000000000b
R13: 000000000000000b R14: ffff88007979ad80 R15: ffff88007661bbb0
FS:  00000000017c4880(0063) GS:ffff88003ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000014 CR3: 0000000036024000 CR4: 00000000000006f0
Stack:
 0000000000000005 ffff88007661bad8 ffffffff817d8ac1 000000007661bb90
 ffff8800371f301b ffff88007661bb90 0000000000000003 0000000000000010
 ffff88007661bc60 0000000000000010 ffff88007661bb10 ffffffff817db557
Call Trace:
 [<     inline     >] scatterwalk_pagedone crypto/scatterwalk.c:82
 [<ffffffff817d8ac1>] scatterwalk_copychunks+0x31/0x100 crypto/scatterwalk.c:102
 [<     inline     >] blkcipher_next_slow crypto/blkcipher.c:175
 [<ffffffff817db557>] blkcipher_walk_next+0x327/0x3a0 crypto/blkcipher.c:254
 [<ffffffff817db0a3>] blkcipher_walk_done+0x113/0x2a0 crypto/blkcipher.c:133
 [<ffffffff817f64fd>] crypto_ctr_crypt+0x11d/0x2a0 crypto/ctr.c:147
 [<     inline     >] skcipher_crypt_blkcipher crypto/skcipher.c:66
 [<ffffffff817db8de>] skcipher_decrypt_blkcipher+0x3e/0x40 crypto/skcipher.c:84
 [<     inline     >] crypto_skcipher_decrypt include/crypto/skcipher.h:363
 [<     inline     >] skcipher_recvmsg_sync crypto/algif_skcipher.c:680
 [<ffffffff8181cb1f>] skcipher_recvmsg+0x6ef/0x8b0 crypto/algif_skcipher.c:710
 [<     inline     >] sock_recvmsg_nosec net/socket.c:713
 [<ffffffff823208a6>] sock_recvmsg+0x36/0x40 net/socket.c:721
 [<ffffffff82321793>] ___sys_recvmsg+0xc3/0x1c0 net/socket.c:2099
 [<ffffffff8232251d>] __sys_recvmsg+0x3d/0x70 net/socket.c:2145
 [<     inline     >] SYSC_recvmsg net/socket.c:2157
 [<ffffffff8232255d>] SyS_recvmsg+0xd/0x20 net/socket.c:2152
 [<ffffffff82876076>] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185
Code: 8b 47 08 48 89 fb 05 ff 0f 00 00 25 00 f0 ff ff 89 47 08 48 8b
3f 8b 57 14 03 57 10 39 d0 73 03 5b 5d c3 e8 93 fe 08 00 48 89 03 <8b>
50 14 85 d2 74 09 8b 40 10 89 43 08 5b 5d c3 e8 7d a2 04 00
RIP  [<     inline     >] scatterwalk_start crypto/scatterwalk.c:35
RIP  [<ffffffff817d8880>] scatterwalk_pagedone.part.8+0x30/0x50
crypto/scatterwalk.c:69
 RSP <ffff88007661ba88>
CR2: 0000000000000014
---[ end trace 1b3652d0252e863c ]---
