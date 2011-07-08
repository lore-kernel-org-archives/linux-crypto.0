From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.6d file/swap crypto package
Date: Fri, 08 Jul 2011 19:46:09 +0300
Message-ID: <4E173451.DD55B8DF@users.sourceforge.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.tnnet.fi ([217.112.240.26]:59470 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab1GHQqM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 12:46:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

loop-AES changes since previous release:
- build-initrd.sh is now able to set up more than one loop device.
- Fixed build on 3.x kernels.
- Lots of #ifdef spaghetti removed for 3.x kernels.
- Fixed build on recent RHEL kernels.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6d.tar.bz2
    md5sum a8b88ae368e1fcbcc073adf28fdfeb1a

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6d.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
