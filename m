From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in hmac_init_tfm
Date: Wed, 20 Dec 2017 15:09:47 -0800
Message-ID: <20171220230947.GF38504@gmail.com>
References: <94eb2c0d010ad8f1660560a275fd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+428944d1a848e9d7464aa96da32ba353cc812457@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:39102 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755691AbdLTXJv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 18:09:51 -0500
Content-Disposition: inline
In-Reply-To: <94eb2c0d010ad8f1660560a275fd@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 18, 2017 at 11:36:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 6084b576dca2e898f5c101baef151f7bfdbb606d
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached

FYI, in linux-next KASAN and other memory debugging options are now behind
CONFIG_DEBUG_MEMORY.  So, I think KASAN isn't getting turned on anymore, despite
the CONFIG_KASAN=y.  (Patch was "lib/: make "Memory Debugging" a menuconfig to
ease disabling it all".)

Eric
