From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.7m file/swap crypto package
Date: Tue, 5 Dec 2017 16:18:22 +0200
Message-ID: <CACMCwJK59YfBHETBGR6C2D9tCaaZi9OthjtNS8MKA8A3grd6pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40447 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbdLEOSZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 09:18:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

loop-AES changes since previous release:
- Worked around kernel interface changes on 4.14 and 4.15-rc kernels.
- Fixed possible timer delete race condition at loop detach time when key
  scrubbing was enabled.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7m.tar.bz2
    md5sum 288105b86f7733224ddd5f7369b6a025

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7m.tar.bz2.sign

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
