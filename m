From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [sparc64] crc32c misbehave
Date: Wed, 31 May 2017 15:12:09 +0300
Message-ID: <CADxRZqwKAEHZwkCmZw7zShCm7uMACdLMfD=EdFETZK4HZ=DEeg@mail.gmail.com>
References: <CADxRZqzgaL4ew6PVek3WBsdwo6GcT0ORx=7h+6p0V3NAr8qF+w@mail.gmail.com>
 <CADxRZqzNTB1n0g1r_2rLsjifHpJ+_x1WPxNOSqEcHbi74jHi5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-crypto@vger.kernel.org
To: Sparc kernel list <sparclinux@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38732 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdEaMML (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 May 2017 08:12:11 -0400
In-Reply-To: <CADxRZqzNTB1n0g1r_2rLsjifHpJ+_x1WPxNOSqEcHbi74jHi5w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A bit more on testing machines:

kernel on T5 ldom ttip is git kernel:

Linux ttip 4.12.0-rc3-00011-gf511c0b17b08 #327 SMP Wed May 31 12:54:02
MSK 2017 sparc64 GNU/Linux

kernel on v215 is debian sid kernel:

Linux v215 4.9.0-3-sparc64-smp #1 SMP Debian 4.9.25-1 (2017-05-02)
sparc64 GNU/Linux

mator@ttip:~$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/sparc64-linux-gnu/6/lto-wrapper
Target: sparc64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian
6.3.0-18' --with-bugurl=file:///usr/share/doc/gcc-6/README.Bugs
--enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++
--prefix=/usr --program-suffix=-6 --program-prefix=sparc64-linux-gnu-
--enable-shared --enable-linker-build-id --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --libdir=/usr/lib
--enable-nls --with-sysroot=/ --enable-clocale=gnu
--enable-libstdcxx-debug --enable-libstdcxx-time=yes
--with-default-libstdcxx-abi=new --enable-gnu-unique-object
--disable-libquadmath --enable-plugin --enable-default-pie
--with-system-zlib --disable-browser-plugin --enable-java-awt=gtk
--enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-6-sparc64/jre
--enable-java-home
--with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-6-sparc64
--with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-6-sparc64
--with-arch-directory=sparc64
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc=auto
--enable-multiarch --enable-targets=all --with-cpu-32=ultrasparc
--with-long-double-128 --enable-multilib --enable-checking=release
--build=sparc64-linux-gnu --host=sparc64-linux-gnu
--target=sparc64-linux-gnu
Thread model: posix
gcc version 6.3.0 20170516 (Debian 6.3.0-18)
