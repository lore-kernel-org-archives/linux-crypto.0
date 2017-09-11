From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: md5sum (from libkcapi) fails as splice() returns -ENOKEY
Date: Mon, 11 Sep 2017 21:17:05 +0200
Message-ID: <3811873.su3Mf2IGi3@positron.chronox.de>
References: <dadd0e10-f2e8-015a-a432-e7174331ab46@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: christophe leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34684 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdIKTRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2017 15:17:08 -0400
In-Reply-To: <dadd0e10-f2e8-015a-a432-e7174331ab46@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 11. September 2017, 19:07:31 CEST schrieb christophe leroy:

Hi christophe,

> Hello Stephan,
> 
> I'm trying to use md5sum from the latest libkcapi 0.14 and I getting a
> failure with return code -5.
> 
> What am I missing ? See strace below, splice() return -ENOKEY.

The ENOKEY error is due to an accept() at the wrong location. But I do not see 
that error:

tar xvfJ libkcapi-0.14.0.tar.xz
cd libkcapi-0.14.0
autoreconf -i
./configure --enable-kcapi-hasher
make
cd bin/.libs/ # I make no make install for testing
ln kcapi-hasher md5sum # create md5sum app
export LD_LIBRARY_PATH=../../.libs/ # location of current library

$ ./md5sum md5sum 
ddd1a82680b16fb6c241d81656b844df  md5sum

So, it works for me.

Can you please check whether you use the current library version? Note, 
library version 0.10.1 fixed the aforementioned accept() call for kernel 4.4 
and later.

$ ./md5sum -v
md5sum: libkcapi 0.14.0

Ciao
Stephan
