From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 crypto_alg_tested
Date: Tue, 16 Jan 2018 22:41:10 -0800
Message-ID: <20180117064110.GE15527@zzz.localdomain>
References: <089e082658c47391ec0560fcf166@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+fa8a8377747a0f0fe1a01cceb33e58cda44955ad@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36930 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbeAQGlN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 01:41:13 -0500
Content-Disposition: inline
In-Reply-To: <089e082658c47391ec0560fcf166@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 11:33:02PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 6084b576dca2e898f5c101baef151f7bfdbb606d
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> encrypted_key: master key parameter '� ����
> ���"j�f@��� 0UY@*��q� -� {�o�' is invalid
> could not allocate digest TFM handle cryptd(sha224)
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> binder: BINDER_SET_CONTEXT_MGR already set
> binder: 5108:5114 ioctl 40046207 0 returned -16
> encrypted_key: master key parameter '� ����
> ���"j�f@��� 0UY@*��q� -� {�o�' is invalid
> IP: crypto_alg_tested+0xe9/0x260 crypto/algapi.c:275
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 5153 Comm: cryptomgr_test Not tainted 4.15.0-rc3-next-20171214+
> #67
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:crypto_alg_tested+0xe9/0x260 crypto/algapi.c:275
> RSP: 0018:ffffc90000eafe98 EFLAGS: 00010293
> RAX: ffff8801fc9d66c0 RBX: ffff8801fcb35400 RCX: ffffffff81677729
> RDX: 0000000000000000 RSI: ffff880215732481 RDI: ffff8801fd654081
> RBP: ffffc90000eafee8 R08: 0000000000000001 R09: 0000000000000004
> R10: ffffc90000eafe08 R11: 0000000000000004 R12: 0000000000000000
> R13: ffff8801fd654048 R14: 0000000000000c8f R15: ffffc90000eafeb0
> FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000020 CR3: 000000000301e002 CR4: 00000000001606f0
> DR0: 0000000020001000 DR1: 0000000020001008 DR2: 0000000020001000
> DR3: 0000000020001008 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  cryptomgr_test+0x17/0x30 crypto/algboss.c:226
>  kthread+0x149/0x170 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:524
> Code: c5 0f 84 a5 00 00 00 e8 36 2c c4 ff 41 81 4d 20 00 04 00 00 49 8d 45
> 38 48 89 45 c0 e8 21 2c c4 ff 4d 39 e5 74 70 e8 17 2c c4 ff <45> 8b 74 24 20
> 41 f6 c6 60 75 60 e8 07 2c c4 ff 49 8d 44 24 38
> RIP: crypto_alg_tested+0xe9/0x260 crypto/algapi.c:275 RSP: ffffc90000eafe98
> CR2: 0000000000000020
> ---[ end trace bf93c4f60f101736 ]---
> Kernel panic - not syncing: Fatal exception
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

Invalidating this bug now that a similar one has been fixed; we'll see if it
happens again...

#syz invalid
