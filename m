From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Write in sha3_final
Date: Tue, 28 Nov 2017 11:13:38 -0800
Message-ID: <20171128191338.GE45321@gmail.com>
References: <001a1143d526998683055f0aee04@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+21d2e751cbf850bffdba93a41b744ee510bb7613@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:44315 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbdK1TNl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 14:13:41 -0500
Content-Disposition: inline
In-Reply-To: <001a1143d526998683055f0aee04@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 05:24:00AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 0c86a6bd85ff0629cd2c5141027fc1c8bb6cde9c
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in memset include/linux/string.h:326
> [inline]
> BUG: KASAN: stack-out-of-bounds in sha3_final+0xeb/0x2e0
> crypto/sha3_generic.c:173
> Write of size 4294967174 at addr ffff8801cc307cba by task
> syzkaller578788/3306

#syz dup: KASAN: stack-out-of-bounds Write in sha3_update
