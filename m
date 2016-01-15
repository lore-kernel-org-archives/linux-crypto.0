From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 0/2] crypto: Fix race condition in *_check_key
Date: Fri, 15 Jan 2016 10:06:11 +0100
Message-ID: <CACT4Y+bEJ4iVqUB8yFT=7bHgyaQmFQUq08kEa8Wp_poj5Mthog@mail.gmail.com>
References: <CACT4Y+ap-GiGRjwWr9kDwMNwQOg5TbJfi8kGD2H2Qv5SBrQK4Q@mail.gmail.com>
 <20160114141341.GA21300@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37635 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcAOJGd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 04:06:33 -0500
Received: by mail-wm0-f48.google.com with SMTP id f206so14356639wmf.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jan 2016 01:06:32 -0800 (PST)
In-Reply-To: <20160114141341.GA21300@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 14, 2016 at 3:13 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 13, 2016 at 12:58:34PM +0100, Dmitry Vyukov wrote:
>>
>> The following program triggers use-after-free in skcipher_sock_destruct.
>> This is on upstream commit 03891f9c853d5c4473224478a1e03ea00d70ff8d +
>> all pending patches from
>> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git +
>> 4 latest Herbert patches.
>
> OK, the check_key function is buggy in that it doesn't lock the
> child socket so if you make two syscalls on the child socket at
> the same time you can end up freeing the parent socket.
>
> Please try these two patches.


With these patches I see lots of:

[ INFO: possible recursive locking detected ]
4.4.0+ #250 Not tainted
---------------------------------------------
syz-executor/16742 is trying to acquire lock:
 (sk_lock-AF_ALG){+.+.+.}, at: [<     inline     >] lock_sock
include/net/sock.h:1480
 (sk_lock-AF_ALG){+.+.+.}, at: [<ffffffff828661d2>]
hash_check_key.isra.3+0xd2/0x210 crypto/algif_hash.c:261

but task is already holding lock:
 (sk_lock-AF_ALG){+.+.+.}, at: [<     inline     >] lock_sock
include/net/sock.h:1480
 (sk_lock-AF_ALG){+.+.+.}, at: [<ffffffff82866126>]
hash_check_key.isra.3+0x26/0x210 crypto/algif_hash.c:252

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_ALG);
  lock(sk_lock-AF_ALG);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by syz-executor/16742:
 #0:  (sk_lock-AF_ALG){+.+.+.}, at: [<     inline     >] lock_sock
include/net/sock.h:1480
 #0:  (sk_lock-AF_ALG){+.+.+.}, at: [<ffffffff82866126>]
hash_check_key.isra.3+0x26/0x210 crypto/algif_hash.c:252

stack backtrace:
CPU: 0 PID: 16742 Comm: syz-executor Not tainted 4.4.0+ #250
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 00000000ffffffff ffff880035e277b0 ffffffff82925f5d 0000000000000000
 ffffffff88ec2570 ffffffff88ec2570 ffff880035e27938 ffffffff81454890
 ffff880000008900 fffffbfff128d2c0 ffff880035e27890 ffffed0006959405
Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff82925f5d>] dump_stack+0x6f/0xa2 lib/dump_stack.c:50
 [<     inline     >] print_deadlock_bug kernel/locking/lockdep.c:1752
 [<     inline     >] check_deadlock kernel/locking/lockdep.c:1796
 [<     inline     >] validate_chain kernel/locking/lockdep.c:2128
 [<ffffffff81454890>] __lock_acquire+0x17e0/0x4700 kernel/locking/lockdep.c:3206
 [<ffffffff81459bfc>] lock_acquire+0x1dc/0x430 kernel/locking/lockdep.c:3585
 [<ffffffff8510caab>] lock_sock_nested+0xcb/0x120 net/core/sock.c:2462
 [<     inline     >] lock_sock include/net/sock.h:1480
 [<ffffffff828661d2>] hash_check_key.isra.3+0xd2/0x210 crypto/algif_hash.c:261
 [<ffffffff8286646f>] hash_sendmsg_nokey+0x3f/0x80 crypto/algif_hash.c:286
 [<     inline     >] sock_sendmsg_nosec net/socket.c:611
 [<ffffffff8510415a>] sock_sendmsg+0xca/0x110 net/socket.c:621
 [<ffffffff85105b79>] ___sys_sendmsg+0x309/0x840 net/socket.c:1947
 [<ffffffff85108194>] __sys_sendmmsg+0x134/0x350 net/socket.c:2032
 [<     inline     >] SYSC_sendmmsg net/socket.c:2061
 [<ffffffff851083e5>] SyS_sendmmsg+0x35/0x60 net/socket.c:2056
 [<ffffffff8626c3f6>] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185
