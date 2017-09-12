From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: md5sum (from libkcapi) fails as splice() returns -ENOKEY
Date: Tue, 12 Sep 2017 09:01:08 +0200
Message-ID: <85331bd3-b799-f4a1-d1da-085be723f5cb@c-s.fr>
References: <dadd0e10-f2e8-015a-a432-e7174331ab46@c-s.fr>
 <3811873.su3Mf2IGi3@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:41985 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbdILHBK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 03:01:10 -0400
In-Reply-To: <3811873.su3Mf2IGi3@positron.chronox.de>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan

Le 11/09/2017 à 21:17, Stephan Müller a écrit :
> Am Montag, 11. September 2017, 19:07:31 CEST schrieb christophe leroy:
> 
> Hi christophe,
> 
>> Hello Stephan,
>>
>> I'm trying to use md5sum from the latest libkcapi 0.14 and I getting a
>> failure with return code -5.
>>
>> What am I missing ? See strace below, splice() return -ENOKEY.
> 
> The ENOKEY error is due to an accept() at the wrong location. But I do not see
> that error:

I did the test once more without the Talitos Crypto driver compiled in 
the kernel, and this time it works.
I believe it must then be an issue with that driver.
What could be the issue, what should I look for in the driver ?

> 
> tar xvfJ libkcapi-0.14.0.tar.xz
> cd libkcapi-0.14.0
> autoreconf -i

I get an error here, have to replace AC_CONFIG_MACRO_DIRS by 
AC_CONFIG_MACRO_DIR in configure.ac

# tar xfJ libkcapi-0.14.0.tar.xz

# cd libkcapi-0.14.0

# autoreconf -i
libtoolize: putting auxiliary files in `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `AC_CONFIG_MACRO_DIR([m4])' to configure.ac and
libtoolize: rerunning libtoolize, to keep the correct libtool macros 
in-tree.
configure.ac:26: error: possibly undefined macro: AC_CONFIG_MACRO_DIRS
       If this token and others are legitimate, please use m4_pattern_allow.
       See the Autoconf documentation.
autoreconf: /usr/bin/autoconf failed with exit status: 1

# sed -i s/AC_CONFIG_MACRO_DIRS/AC_CONFIG_MACRO_DIR/g configure.ac

# autoreconf -i
configure.ac:22: installing `./config.guess'
configure.ac:22: installing `./config.sub'
configure.ac:21: installing `./install-sh'
configure.ac:21: installing `./missing'
lib/doc/Makefile.am: installing `./depcomp'

# autoreconf --version
autoreconf (GNU Autoconf) 2.63
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv2+: GNU GPL version 2 or later
<http://gnu.org/licenses/old-licenses/gpl-2.0.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by David J. MacKenzie and Akim Demaille.

Thanks
Christophe


> ./configure --enable-kcapi-hasher
> make
> cd bin/.libs/ # I make no make install for testing
> ln kcapi-hasher md5sum # create md5sum app
> export LD_LIBRARY_PATH=../../.libs/ # location of current library
> 
> $ ./md5sum md5sum
> ddd1a82680b16fb6c241d81656b844df  md5sum
> 
> So, it works for me.
> 
> Can you please check whether you use the current library version? Note,
> library version 0.10.1 fixed the aforementioned accept() call for kernel 4.4
> and later.
> 
> $ ./md5sum -v
> md5sum: libkcapi 0.14.0
> 
> Ciao
> Stephan
> 
