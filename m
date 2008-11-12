From: Tobias Geiger <tobias.geiger@vido.info>
Subject: dm-crypt using hifn_795x - still broken
Date: Wed, 12 Nov 2008 17:10:41 +0100
Message-ID: <200811121710.41666.tobias.geiger@vido.info>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: zbr@ioremap.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.vido.info ([78.47.43.171]:45056 "EHLO mail.vido.info"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752198AbYKLQoG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 11:44:06 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

i tested 2.6.28-rc4 with the patch from 
http://marc.info/?l=linux-crypto-vger&m=122643041300555&w=2

but i get the following error, as soon as i try to mount the de-crypted 
dm-cypt-block device (cryptsetup luksOpen however works):

hifn0: r: 00000000, active: 0, started: 20, success: 4247: qlen: 0/1, reset: 
1.
hifn795x: assuming 66MHz clock speed, override with 
hifn_pll_ref=ext<frequency>
I/O error in filesystem ("dm-0") meta-data dev dm-0 block 0x1c88d6fb       
("xlog_bread")
error 5 buf count 2097152
XFS: failed to find log head
XFS: log mount/recovery failed: error 5
XFS: log mount failed

tell me if you need more info for debugging this.

Thanks for your efforts!
Tobias
