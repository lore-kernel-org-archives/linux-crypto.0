From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.6h file/swap crypto package
Date: Mon, 29 Apr 2013 14:10:56 +0300
Message-ID: <517E5540.F64D5681@users.sourceforge.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

loop-AES changes since previous release:
- Fixed bug that caused compile failure if kernel configuration has
  CONFIG_UIDGID_STRICT_TYPE_CHECKS=y. Patch from Hank Leininger.
- Worked around block layer interface changes on 3.9 kernels.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6h.tar.bz2
    md5sum 7c5ad5761e58fc8eb0176b00c69b6b75

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6h.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
