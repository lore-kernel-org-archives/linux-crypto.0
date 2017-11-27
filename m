From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: KASAN: use-after-free Read in aead_recvmsg
Date: Mon, 27 Nov 2017 23:02:08 +0100
Message-ID: <2409323.isfI9bk5QC@positron.chronox.de>
References: <001a113ebb5ece8a7a055efb7676@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+6fbc13c3b1ed2105e7a2e516be43d6a0624a59c0@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42498 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752258AbdK0WCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 17:02:12 -0500
In-Reply-To: <001a113ebb5ece8a7a055efb7676@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 27. November 2017, 19:56:46 CET schrieb syzbot:

Hi,

> Hello,
> 
> syzkaller hit the following crash on
> 6fc478f80f6809cc4b1a4230f47a62d3b7378dc0
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers

Could you please re-perform the test applying the patch https://
git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/commit/?
id=8e1fa89aa8bc2870009b4486644e4a58f2e2a4f5 ?

At least I am not able to reproduce that issue using the repro.c with the 
patch applied.

Thanks a lot.

Ciao
Stephan
