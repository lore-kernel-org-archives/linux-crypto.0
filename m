From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.7g file/swap crypto package
Date: Wed, 13 Jan 2016 11:36:10 +0200
Message-ID: <CACMCwJKZWd3xmCSj8X7fxSRCFfsPwzN4OxJ00wJT-URs28RUcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

loop-AES changes since previous release:
- Fixed a bug in util-linux-2.27.1 patch that resulted in /tmp partition
  with random encryption keys not working at all. If /sbin/mkfs was from
  older version of util-linux, then this bug did not trigger. This problem
  was reported by Gabriel Vlasiu.
- Worked around block layer interface changes on 4.4 kernels.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7g.tar.bz2
    md5sum 6fb2217b15586295ce949e93538a701d

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7g.tar.bz2.sign

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
