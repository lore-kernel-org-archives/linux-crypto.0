From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.6b file/swap crypto package
Date: Sat, 26 Feb 2011 20:40:43 +0200
Message-ID: <4D69492B.CB694458@users.sourceforge.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailq1.tnnet.fi ([217.112.240.127]:52849 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1BZSvO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Feb 2011 13:51:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

loop-AES changes since previous release:
- Fixed a bug that can cause "NULL pointer dereference" at /dev/md* backing
  device, and possibly other backing devices that call __bio_clone(). This
  bug is present in loop-AES-v3.6a (and loop-AES-v3.5 versions with
  linux-2.6.37 or later kernels).
- Fixed a bug that can cause slow operation or even deadlock. This bug is
  present only in loop-AES-v3.6a version. Older versions are not affected.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6b.tar.bz2
    md5sum 247e5a909877577bdcd246f8caada689

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6b.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
