From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: general protection fault in crypto_remove_spawns
Date: Tue, 28 Nov 2017 23:06:18 +0100
Message-ID: <2621541.YkCu9MsXr4@positron.chronox.de>
References: <001a1141c43ad30ccf055efb76ed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42594 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750904AbdK1WGV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 17:06:21 -0500
In-Reply-To: <001a1141c43ad30ccf055efb76ed@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 27. November 2017, 19:56:46 CET schrieb syzbot:

Hi Herbert,

The issue seems to trigger a bug whose results we have seen before. When 
starting the reproducer and stopping it shortly thereafter, I see the numerous 
identical entries in /proc/crypto:

name         : cmac(des3_ede)
driver       : cmac(des3_ede-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 8
digestsize   : 8

name         : cmac(des3_ede)
driver       : cmac(des3_ede-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 8
digestsize   : 8

name         : cmac(des3_ede)
driver       : cmac(des3_ede-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 8
digestsize   : 8

...

And this list keeps on growing without end:

# ./repro

# less /proc/crypto | wc
   9559   26456  188754

# ./repro

# less /proc/crypto | wc
  11440   31586  226032

At one point in time I think the system simply has too many entries.

Ciao
Stephan
