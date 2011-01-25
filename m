From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Announce loop-AES-v3.6a file/swap crypto package
Date: Tue, 25 Jan 2011 08:46:18 +0200
Message-ID: <4D3E71BA.6CAA2BE8@users.sourceforge.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailq2.tnnet.fi ([217.112.254.233]:53404 "EHLO mailq2.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1AYGxE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Jan 2011 01:53:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

loop-AES changes since previous release:
- Worked around block layer interface breakage on 2.6.32.x, 2.6.36.x, and
  2.6.37-rc kernels.
- Queue code removal/rewrite for all 2.6.x kernels. This fixes a SMP race
  when more than one helper thread (per loop device) was used. Default
  was/is one helper thread. This race could leave backing device in
  "plugged" state when it should have been "unplugged". This race was
  introduced in loop-AES-v3.5a, and affected only 2.6.37 and later kernels.
- Merged two loop kernel 2.6.x code bases back into one. This unfortunately
  re-introduces lots of #ifdef spaghetti.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6a.tar.bz2
    md5sum 196d082506f2b3d94528f9e8f5b9074f

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6a.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
