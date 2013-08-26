From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.7a file/swap crypto package
Date: Mon, 26 Aug 2013 18:20:35 +0300
Message-ID: <521B7243.B0C3CC11@users.sourceforge.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

loop-AES changes since previous release:
- Code and struct cleanup, make it work on 3.11-rc kernels.
- Fixed directory permissions bug in util-linux-2.23.2 when "mount -a" set
  up encrypted file system using ramdom keys. util-linux-2.21.2 and older
  versions are not affected.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7a.tar.bz2
    md5sum f267cb2108ee94b09a30b2fc7e292104

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7a.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
