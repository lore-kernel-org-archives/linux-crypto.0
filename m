From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: bad page state due to PF_ALG socket
Date: Mon, 21 Dec 2015 17:03:24 -0800
Message-ID: <CAM_iQpWUeGHVx5c4-XF4OuwAr3PmZBrXvY0Juohb0SCFD8KAFg@mail.gmail.com>
References: <CACT4Y+a2H0WXdrK3CHn6UHXMA=cnU3+FaxB=qcq+yRQYRy+pAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:34572 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbbLVBDZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Dec 2015 20:03:25 -0500
In-Reply-To: <CACT4Y+a2H0WXdrK3CHn6UHXMA=cnU3+FaxB=qcq+yRQYRy+pAg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 17, 2015 at 4:58 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> Modules linked in:
> CPU: 3 PID: 7168 Comm: a.out Tainted: G    B           4.4.0-rc3+ #151
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> task: ffff88003712ad00 ti: ffff8800331d8000 task.ti: ffff8800331d8000
> RIP: 0010:[<ffffffff82d2d812>]  [<ffffffff82d2d812>]
> skcipher_recvmsg+0x82/0x1f10
> RSP: 0018:ffff8800331dfb80  EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: ffff88006b98f300 RCX: 0000000000010040
> RDX: 0000000000000002 RSI: ffff8800331dfdc0 RDI: 0000000000000016
> RBP: ffff8800331dfc80 R08: ffff8800331dfdd0 R09: 000000000000000a
> R10: 0000000000010040 R11: 0000000000000246 R12: 0000000000000006
> R13: ffff8800331dfdc0 R14: ffff8800331dfdc0 R15: 0000000000010040
> FS:  0000000002630880(0063) GS:ffff88006cf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000c8200d73b0 CR3: 0000000064c58000 CR4: 00000000000006e0
> Stack:
>  ffff88006aba6024 ffff88006ab24520 ffff88006ab24510 ffff88006aba67e0
>  ffff88006aba602c ffffed000d574cfc 0000000000000000 ffff88006ab24518
>  ffff88006aba602d 0000000000001000 ffff88006ab24500 ffff88006aba6a48
> Call Trace:
>  [<     inline     >] sock_recvmsg_nosec net/socket.c:712
>  [<ffffffff856b1c8a>] sock_recvmsg+0xaa/0xe0 net/socket.c:720
>  [<ffffffff856b2424>] SYSC_recvfrom+0x1e4/0x370 net/socket.c:1707
>  [<ffffffff856b7570>] SyS_recvfrom+0x40/0x50 net/socket.c:1681
>  [<ffffffff86a89fb6>] entry_SYSCALL_64_fastpath+0x16/0x7a
> arch/x86/entry/entry_64.S:185

I think it is probably fixed by:

commit 130ed5d105dde141e7fe60d5440aa53e0a84f13b
Author: tadeusz.struk@intel.com <tadeusz.struk@intel.com>
Date:   Tue Dec 15 10:46:17 2015 -0800

    net: fix uninitialized variable issue
