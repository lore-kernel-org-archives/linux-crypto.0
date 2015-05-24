From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.7d file/swap crypto package
Date: Sun, 24 May 2015 11:58:56 +0300
Message-ID: <CACMCwJJ4eMymCgMZ-Y8x9nrNeKnXHZ+vr_zt11RS+DhFS4zoyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36073 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbEXI65 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 May 2015 04:58:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

loop-AES changes since previous release:
- Fixed endianness bug on little-endian PowerPC. More common big-endian
  PowerPC was OK. Bug reported by Fernando Seiti Furusato.
- Worked around VFS changes on 4.1-rc kernels.
- Some #ifdef spaghetti removed for 4.x kernels.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7d.tar.bz2
    md5sum 78b8d93e4b03a42ef9be99ad1eea7db2

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7d.tar.bz2.sign

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
