From: Andreas Jellinghaus <aj@ciphirelabs.com>
Subject: Re: [0/3] [DM] dm-crypt: Add async crypto support
Date: Wed, 11 Jul 2007 09:45:20 +0200
Message-ID: <f721vl$h3i$1@sea.gmane.org>
References: <20070711030303.GA6730@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:44896 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbXGKHsW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2007 03:48:22 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1I8Wvn-0005Qr-Gq
	for linux-crypto@vger.kernel.org; Wed, 11 Jul 2007 09:48:15 +0200
Received: from ciphirelabs.net ([217.72.114.248])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jul 2007 09:48:15 +0200
Received: from aj by ciphirelabs.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jul 2007 09:48:15 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu wrote:
> I've rebased the async dm-crypt patches for 2.6.22.  In doing
> so I've refactored the kcryptd split so that all crypto operations
> happen in kcryptd while all IO submissions occur in kcryptd-io.

will this reduce latencies and stalls with dm-crypt? When copying large
files dm-crypted machines (swap+root) are often not very usable.

Also in some cases I see no i/o happening in vmstat, sometimes for a minute,
while lots of processes are blocked waiting for data read and decrypted
from disk. But I don't have a recipe for reproducing this so far and only
tested up to 2.6.21.*.

Regards, Andreas
