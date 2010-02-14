From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: crypto_remove_spawns: BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000018
Date: Sun, 14 Feb 2010 19:45:07 +0200
Message-ID: <20100214174507.GA8688@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59075 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0BNRpO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Feb 2010 12:45:14 -0500
Received: by fxm27 with SMTP id 27so429487fxm.25
        for <linux-crypto@vger.kernel.org>; Sun, 14 Feb 2010 09:45:12 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff81145bf4>] crypto_remove_spawns+0xd4/0x340
PGD bdc48067 PUD bc954067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
CPU 0 
Pid: 16500, comm: rmmod Not tainted 2.6.33-rc7-next-20100212+ #9 P5E/P5E
RIP: 0010:[<ffffffff81145bf4>]  [<ffffffff81145bf4>] crypto_remove_spawns+0xd4/0x340
RSP: 0018:ffff8800bc9dfde8  EFLAGS: 00010282
RAX: ffff8800bc901498 RBX: 0000000000000000 RCX: ffff8800ba859610
RDX: ffff8800bc900380 RSI: ffff8800bc9dfe18 RDI: ffff8800bc9015c0
RBP: ffff8800bc9dfe68 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800bc901488
R13: ffff8800bc9dfe18 R14: ffffffffa05817e0 R15: 0000000000000000
FS:  00007fdd2ec1c6f0(0000) GS:ffff880002200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 00000000bca34000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 16500, threadinfo ffff8800bc9de000, task ffff8800bd53ad90)
Stack:
 ffff8800bc9dfe08 ffff8800bc9dfe28 ffff8800bc9dfe98 0000042181636020
<0> ffff8800bc9dfe08 ffff8800bc9dfe08 ffff8800bc9015c0 ffff8800bc900380
<0> ffff8800ba859808 ffff8800ba859610 ffff8800bc9dfe98 ffffffffa05817e0
Call Trace:
 [<ffffffff81145eb1>] crypto_remove_alg+0x51/0x60
 [<ffffffff81145ef3>] crypto_unregister_alg+0x33/0x90
 [<ffffffffa058175c>] aes_fini+0x10/0x12 [aes_x86_64]
 [<ffffffff8107266c>] sys_delete_module+0x19c/0x250
 [<ffffffff8100256b>] system_call_fastpath+0x16/0x1b
Code: 02 00 eb c3 0f 1f 00 48 8b 47 08 48 8d 75 c0 4c 89 28 49 89 45 08 48 8b 55 c0 e8 a8 fa 02 00 48 8d 45 a0 48 8b 18 48 39 d8 74 44 <4c> 8b 63 18 4d 39 f4 0f 84 4e 02 00 00 48 8b 13 48 8b 43 08 4c 
RIP  [<ffffffff81145bf4>] crypto_remove_spawns+0xd4/0x340
 RSP <ffff8800bc9dfde8>
CR2: 0000000000000018


crypto_remove_spawns:

	spawn = list_first_entry(spawns, struct crypto_spawn, list);
	inst = spawn->inst;

spawn is NULL here.
