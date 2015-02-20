From: Martin Hicks <mort@bork.org>
Subject: [PATCH 0/5] crypto: talitos: Add crypto async queue handling
Date: Fri, 20 Feb 2015 11:21:11 -0500
Message-ID: <1424449276-5288-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36201 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbbBTQVp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 11:21:45 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so8098501igb.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 08:21:45 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was testing dm-crypt performance with a Freescale P1022 board with 
a recent kernel and was getting IO errors while doing testing with LUKS.
Investigation showed that all hardware FIFO slots were filling and
the driver was returning EAGAIN to the block layer, which is not an
expected response for an async crypto implementation.

The following patch series adds a few small fixes, and reworks the
submission path to use the crypto_queue mechanism to handle the
request backlog.


Martin Hicks (5):
  crypto: talitos: Simplify per-channel initialization
  crypto: talitos: Remove MD5_BLOCK_SIZE
  crypto: talitos: Fix off-by-one and use all hardware slots
  crypto: talitos: Reorganize request submission data structures
  crypto: talitos: Add software backlog queue handling

 drivers/crypto/talitos.c |  189 ++++++++++++++++++++++++----------------------
 drivers/crypto/talitos.h |   44 +++++++++--
 2 files changed, 137 insertions(+), 96 deletions(-)

-- 
1.7.10.4
