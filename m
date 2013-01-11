From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH 0/2] crypto: caam - Fix bugs in hashing module
Date: Fri, 11 Jan 2013 15:33:55 +0530
Message-ID: <1357898637-18971-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:7565
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295Ab3AKKGZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2013 05:06:25 -0500
Received: from mail69-ch1 (localhost [127.0.0.1])	by mail69-ch1-R.bigfish.com
 (Postfix) with ESMTP id B58821C0245	for <linux-crypto@vger.kernel.org>; Fri,
 11 Jan 2013 10:06:24 +0000 (UTC)
Received: from CH1EHSMHS040.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.254])	by mail69-ch1.bigfish.com (Postfix) with ESMTP id DFF852E004C
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2013 10:06:22 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r0BA6EZ2008314	for
 <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2013 03:06:15 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These patches have been authored by Steve Cornelius.
These patches fix uninitialised variables left in the hashing module.

<steve.cornelius@freescale.com>.

Steve Cornelius (2):
  crypto: caam - Fix DMA size in descriptor in ahash_digest()
  crypto: caam - improve init for context state saves

 drivers/crypto/caam/caamhash.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

-- 
1.7.7.6
